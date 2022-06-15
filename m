Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705E354CB67
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242340AbiFOOcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiFOOcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:32:51 -0400
X-Greylist: delayed 981 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Jun 2022 07:32:49 PDT
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307B029366
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=393jYk0BHRsjYGtrYQk+4+L0lb7cpOQc6CKXPRMTyRs=; b=SaiFND/q+HXjfLPZI3Z
        jgcFvD5EEqlNSB9B/HJdnl0ELU1CKzKTgzAEahQgqpx1Om4lD7Uvs8TOPuVgSAuNZfbLkLJwPJomm
        ml0PB6BLoNkvak889x3K4ywfU1FgOYAQuuE9IJBiZ+eHxbnkAm1uKRYgT0WmDE73ZqWA3I/bq90=;
Received: from [192.168.16.39] (helo=mikhalitsyn-laptop)
        by relay.virtuozzo.com with esmtp (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1o1Tng-005JLB-Pk; Wed, 15 Jun 2022 16:15:16 +0200
Date:   Wed, 15 Jun 2022 17:14:10 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, den@virtuozzo.com,
        ptikhomirov@virtuozzo.com, alexander@mihalicyn.com
Subject: [Question] debugging VM cpu hotplug (#GP -> #DF) which results in
 reset
Message-Id: <20220615171410.ab537c7af3691a0d91171a76@virtuozzo.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear friends,

I'm sorry for disturbing you but I've getting stuck with debugging KVM problem and looking for an advice. I'm working mostly on kernel containers/CRIU and am newbie with KVM so, I believe that I'm missing something very simple.

My case:
- AMD EPYC 7443P 24-Core Processor (Milan family processor)
- OpenVZ kernel (based on RHEL7 3.10.0-1160.53.1) on the Host Node (HN)
- Qemu/KVM VM (8 vCPU assigned) with many different kernels from 3.10.0-1160 RHEL7 to mainline 5.18

Reproducer (run inside VM):
echo 0 > /sys/devices/system/cpu/cpu3/online
echo 1 > /sys/devices/system/cpu/cpu3/online <- got reset here

*Not* reproducible on:
- any Intel which we tried
- AMD EPYC 7261 (Rome family)
- without KVM (on Host)

Issue is not reproducible on the Host. But it's reproducible in L2 (with /sys/module/kvm_amd/parameters/nested = 1, of course).

I know that RHEL7 is not supports AMD Milan but OpenVZ have some limited support backported from fresh kernels.

What was done to debug it:
1. of course, kexec/crashkernel is useless here, because VM just resets without producing
a panic().

2. qemu-kvm cmdline option -d int,unimp,guest_errors,cpu_reset
shows me that the CPU which was offlined/onlined is in 32-bit mode (!) just before reset (thanks to cpu_reset option)

*I'll put qemu log at the end of email*

3. I've used qemu gdb server and step by step debugging with hope that I find the particular instruction which triggers reset. I always came into smpboot.c/do_boot_cpu() function and reset comes somewhere in between of:
	if (!boot_error) {
...
		while (time_before(jiffies, timeout)) {
			if (cpumask_test_cpu(cpu, cpu_initialized_mask)) {
				/*
				 * Tell AP to proceed with initialization
				 */
				cpumask_set_cpu(cpu, cpu_callout_mask);
				boot_error = 0;
				break;
			}
			schedule();
		}
	}

	if (!boot_error) {
		/*
		 * Wait till AP completes initial initialization
		 */
		while (!cpumask_test_cpu(cpu, cpu_callin_mask)) {
			/*
			 * Allow other tasks to run while we wait for the
			 * AP to come online. This also gives a chance
			 * for the MTRR work(triggered by the AP coming online)
			 * to be completed in the stop machine context.
			 */
			schedule();
		}
	}

But I can't manage to catch a particular instruction.
* gdb session logs at the end *

My suspicious is that problem happens in the middle on schedule() call because processor wasn't fully initialized during onlining for some reason. schedule() does a lot of tricky activity like rcu-related things and so on. I can't figure out the where to pay attention.

4. perf. I've set probes in most interesting places in the kernel where tripple/double faults are handled kvm_multiple_exception, handle_emulation_failure, shutdown_interception, vcpu_enter_guest functions. And got *log at the end*.

If I'm correct, #GP happens, then #DF and then reset. But I've no idea how to catch origin problem of #GP. And why fault occurs during #GP processing?..

5. building with CFLAGS_smpboot.o  :=  -DDEBUG

[    5.529631] device virbr0-nic left promiscuous mode
[    5.529661] virbr0: port 1(virbr0-nic) entered disabled state
[    8.395604] input: spice vdagent tablet as /devices/virtual/input/input6
[   46.687483] smpboot: CPU 3 is now offline
--Type <RET> for more, q to quit, c to continue without paging--
[  186.136060] smpboot: ++++++++++++++++++++=_---CPU UP  3
[  186.136180] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  186.136180] smpboot: Setting warm reset code and vector.
[  186.150339] smpboot: Asserting INIT
[  186.150352] smpboot: Waiting for send to finish...
[  186.150352] smpboot: Deasserting INIT
[  186.150360] smpboot: Waiting for send to finish...
[  186.150361] smpboot: #startup loops: 2
[  186.150361] smpboot: Sending STARTUP #1
[  186.150387] smpboot: After apic_write
[  186.150420] smpboot: Startup point 1
[  186.150422] smpboot: Waiting for send to finish...
[  186.150451] smpboot: Sending STARTUP #2
[  186.150469] smpboot: After apic_write
[  186.150490] smpboot: Startup point 1
[  186.150490] smpboot: Waiting for send to finish...
[  186.150514] smpboot: After Startup

*reset occured*

Finally, I'm looking for advices about approaches to debug Double faults/Tripple faults and fresh look on this bug.

Thanks for your attention to my email. I'll be happy about any advice/point.

Regards,
Alexander Mikhalitsyn

===== Logs =====

====== qemu-kvm -d int,unimp,guest_errors,cpu_reset =======

CPU Reset (CPU 0)
RAX=ffffffff81bb1480 RBX=0000000000000000 RCX=7fffffef89980f7f RDX=00000000000b99d6
RSI=0000000000000000 RDI=ffff88807fc1d680 RBP=0000000000000000 RSP=ffffffff82603e80
R8 =000000000000cf59 R9 =ffff888004913000 R10=0000000000000014 R11=0000000000000003
R12=ffffffffffffffff R13=0000000000000000 R14=0000000000000000 R15=ffffffff82614840
RIP=ffffffff81bb15ce RFL=00000206 [-----P-] CPL=0 II=0 A20=1 SMM=0 HLT=1
ES =0000 0000000000000000 00000000 00000000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0000 0000000000000000 00000000 00000000
FS =0000 0000000000000000 00000000 00000000
GS =0000 ffff88807fc00000 00000000 00000000
LDT=0000 0000000000000000 00000000 00000000
TR =0040 fffffe0000003000 0000206f 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000001000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=000055b078794670 CR3=000000000260c003 CR4=00370ef0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000ffff0ff0 DR7=0000000000000400
CCS=0000000000000000 CCD=0000000000000000 CCO=DYNAMIC 
EFER=0000000000000d01
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001fa0
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=c000000000000000 4000
FPR6=c000000000000000 4000 FPR7=e000000000000000 4001
XMM00=00007f2b4660666000007f2b5330a000 XMM01=00007f2b4662ed1800007f2b5330a000
XMM02=000000ff00000000ff000000ff0000ff XMM03=00007f2b476c5c5000007f2b4663ae88
XMM04=00007f2b4662e88000007f2b538e9ed8 XMM05=00007f2b4662e22800007f2b50c69688
XMM06=00007f2b50c6968800007f2b50c69688 XMM07=00007f2b50c6968800007f2b50c69688
XMM08=4f4f7c006672657000697c69004f4f00 XMM09=00000000000000000000000000000000
XMM10=000000000000000000007f2b5332b9d0 XMM11=00000000000000000000000000000000
XMM12=ffffffffffffffffffffffffffffffff XMM13=00000000000000030000000000000000
XMM14=00007f2b4844d85000007f2b47ee9b10 XMM15=00000004000000040000000400000004
CPU Reset (CPU 1)
RAX=ffffffff81bb1480 RBX=0000000000000001 RCX=ffff8880049fcd58 RDX=00000000000b157a
RSI=0000000000000000 RDI=00000010767732c0 RBP=0000000000000001 RSP=ffffc9000038fea0
R8 =fffffffffff18c64 R9 =0000000000000001 R10=0000000000000033 R11=0000000000000000
R12=ffffffffffffffff R13=0000000000000000 R14=0000000000000000 R15=ffff888004910000
RIP=ffffffff81bb15ce RFL=00000202 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=1
ES =0000 0000000000000000 00000000 00000000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0000 0000000000000000 00000000 00000000
FS =0000 0000000000000000 00000000 00000000
GS =0000 ffff88807fc80000 00000000 00000000
LDT=0000 0000000000000000 00000000 00000000
TR =0040 fffffe0000036000 0000206f 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000034000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=000055b07875dc18 CR3=000000000260c005 CR4=00370ee0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000ffff0ff0 DR7=0000000000000400
CCS=0000000000000000 CCD=0000000000000000 CCO=DYNAMIC 
EFER=0000000000000d01
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00007fff7180e6600000003000000010
XMM02=ff00000000000000000000000000ff00 XMM03=79732f6563696c732e6d65747379732f
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000
XMM08=0074736f507472617453636578450065 XMM09=00000000000000000000000000000000
XMM10=20202000002020202020202020202020 XMM11=00000000000000000000000000000000
XMM12=00000000000000000000000000000000 XMM13=00000000000000000000000000000000
XMM14=00000000000000000000000000000000 XMM15=00000000000000000000000000000000
CPU Reset (CPU 2)
RAX=0000000000000001 RBX=ffff88807fd2a080 RCX=dead000000000200 RDX=0000000000000000
RSI=ffff88807fd2aab8 RDI=ffff88807fd2a080 RBP=ffffc90000acbc98 RSP=ffffc90000acbc38
R8 =ffff88807fd2aab8 R9 =0000000000000004 R10=0000000000000000 R11=0000000000000001
R12=ffff888044d817c0 R13=ffff888044d817c0 R14=0000000000000000 R15=ffffffff82033800
RIP=ffffffff811c463c RFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 00000000 00000000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0000 0000000000000000 00000000 00000000
FS =0000 00007f3bb670a740 00000000 00000000
GS =0000 ffff88807fd00000 00000000 00000000
LDT=0000 0000000000000000 00000000 00000000
TR =0040 fffffe0000069000 0000206f 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000067000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=000055a6d6c955c8 CR3=00000000092a2005 CR4=00370ee0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000ffff0ff0 DR7=0000000000000400
CCS=0000000000000000 CCD=0000000000000000 CCO=DYNAMIC 
EFER=0000000000000d01
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=8000000000000000 3fff
FPR6=8000000000000000 3fff FPR7=c000000000000000 4000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00000001007501090000680100670108 XMM03=0000000400750105000000360000001b
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000
XMM08=302e373231007373657264646120676e XMM09=00000000000000000000000000000000
XMM10=20002020000000000000000000000000 XMM11=00000000000000000000000000000000
XMM12=00000000000000000000000000000000 XMM13=00000000000000000000000000000000
XMM14=00000000000000000000000000000000 XMM15=00000000000000000000000000000000
CPU Reset (CPU 3)
EAX=00000001 EBX=03000800 ECX=fffa3203 EDX=06000018
ESI=00000000 EDI=00000001 EBP=00000000 ESP=00005020
EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 00000000 0000ffff 00009300
CS =f000 ffff0000 0000ffff 00009a00
SS =0000 00000000 0000ffff 00009200
DS =0000 00000000 0000ffff 00009300
FS =0000 00000000 0000ffff 00009300
GS =0000 00000000 0000ffff 00009300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008300
GDT=     00000000 0000ffff
IDT=     00000000 0000ffff
CR0=60000010 CR2=00000000 CR3=0260c004 CR4=00370ee0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000ffff0ff0 DR7=0000000000000400
CCS=00000000 CCD=00000000 CCO=DYNAMIC 
EFER=0000000000000000
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001fa0
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=c000000000000000 4000
FPR6=c000000000000000 4000 FPR7=e000000000000000 4001
XMM00=00000000000000000000000000000000 XMM01=0356e899f600f6798ce31f5fdc51809a
XMM02=4121079c00270412e4aa20f6253322c0 XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000 XMM05=00000000000000006fecd5e21a37c78d
XMM06=0569fa2fe5158326a00bd0180a1318c6 XMM07=95af9ce2f991ed48a5622a37ef069be0

==== trace-cmd record -b 20000 -e kvm:kvm_cr -e kvm:kvm_userspace_exit -e probe:* =====

             CPU-1834  [003] 69194.833364: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
             CPU-1838  [000] 69194.834177: kvm_multiple_exception_L9: (ffffffff814313c6) vcpu=0xffff93ee9a528000
             CPU-1838  [000] 69194.834180: kvm_multiple_exception_L41: (ffffffff81431493) vcpu=0xffff93ee9a528000 exception=0xd000001 has_error=0x0 nr=0xd error_code=0x0 has_payload=0x0
             CPU-1838  [000] 69194.834195: kvm_multiple_exception_L9: (ffffffff814313c6) vcpu=0xffff93ee9a528000
             CPU-1838  [000] 69194.834196: kvm_multiple_exception_L41: (ffffffff81431493) vcpu=0xffff93ee9a528000 exception=0x8000100 has_error=0x0 nr=0x8 error_code=0x0 has_payload=0x0
             CPU-1838  [000] 69194.834200: shutdown_interception_L8: (ffffffff8146e4a0)
             CPU-1838  [000] 69194.834207: kvm_userspace_exit:   reason KVM_EXIT_SHUTDOWN (8)
             CPU-1834  [003] 69194.836313: kvm_userspace_exit:   reason KVM_EXIT_INTR (10)
             CPU-1836  [006] 69194.836352: kvm_userspace_exit:   reason KVM_EXIT_INTR (10)
             CPU-1837  [005] 69194.836513: kvm_userspace_exit:   reason KVM_EXIT_INTR (10)
             CPU-1836  [007] 69194.930872: kvm_userspace_exit:   reason KVM_EXIT_INTR (10)
             CPU-1838  [000] 69194.930915: kvm_userspace_exit:   reason KVM_EXIT_SHUTDOWN (8)


======= gdb session ========

[root@localhost linux-4.18.0-348.el8.x86_64]# gdb vmlinux 
...
(gdb) lx-symbols 
loading vmlinux
(gdb) target remote :1234
Remote debugging using :1234
0xffffffff81bb15ce in native_safe_halt () at ./arch/x86/include/asm/irqflags.h:57
57		asm volatile("sti; hlt": : :"memory");
(gdb) break do_boot_cpu
Breakpoint 1 at 0xffffffff810d2ef0: file arch/x86/kernel/smpboot.c, line 1049.
(gdb) break arch/x86/kernel/smpboot.c:1067
Breakpoint 2 at 0xffffffff810d3020: file arch/x86/kernel/smpboot.c, line 1074.
(gdb) c
Continuing.
[Switching to Thread 1.2]

Thread 2 hit Breakpoint 1, do_boot_cpu (apicid=apicid@entry=3, cpu=cpu@entry=3, idle=idle@entry=0xffff888004938000, cpu0_nmi_registered=cpu0_nmi_registered@entry=0xffffc90000d77d0c)
    at arch/x86/kernel/smpboot.c:1049
1049	{
(gdb) s
1050		volatile u32 *trampoline_status =
(gdb) s
1058		idle->thread.sp = (unsigned long)task_pt_regs(idle);
(gdb) s
1059		early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
(gdb) s
get_cpu_gdt_rw (cpu=<optimized out>) at ./arch/x86/include/asm/desc.h:57
57		return per_cpu(gdt_page, cpu).gdt;
(gdb) s
do_boot_cpu (apicid=apicid@entry=3, cpu=cpu@entry=3, idle=idle@entry=0xffff888004938000, cpu0_nmi_registered=cpu0_nmi_registered@entry=0xffffc90000d77d0c) at arch/x86/kernel/smpboot.c:1064
1064		init_espfix_ap(cpu);
(gdb) si
init_espfix_ap (cpu=cpu@entry=3) at arch/x86/kernel/espfix_64.c:140
140	{
(gdb) si
151		if (likely(per_cpu(espfix_stack, cpu)))
..
(gdb) si
933		if (system_state < SYSTEM_RUNNING) {
(gdb) si
0xffffffff810d2fd1	933		if (system_state < SYSTEM_RUNNING) {
(gdb) si
950			pr_info("Booting Node %d Processor %d APIC 0x%x\n",
(gdb) si
0xffffffff810d3d23	950			pr_info("Booting Node %d Processor %d APIC 0x%x\n",
..
(gdb) si
0xffffffff810d3022	1074		if (x86_platform.legacy.warm_reset) {
(gdb) si
arch_static_branch (branch=false, key=0xffffffff8285ce68 <descriptor+40>) at ./arch/x86/include/asm/jump_label.h:38
38		asm_volatile_goto("1:"
(gdb) si
smpboot_setup_warm_reset_vector (start_eip=630784) at ./include/linux/spinlock.h:329
329		return &lock->rlock;
(gdb) si
0xffffffff810d3034	329		return &lock->rlock;
(gdb) si
0xffffffff810d3038	329		return &lock->rlock;
(gdb) si
_raw_spin_lock_irqsave (lock=0xffffffff82fdc7a0 <rtc_lock>) at kernel/locking/spinlock.c:158
158	{
..
(gdb) si
0xffffffff810d306f in smpboot_setup_warm_reset_vector (start_eip=630784) at ./arch/x86/include/asm/io.h:150
150		return __va(address);
..
(gdb) si
apic_read (reg=640) at ./arch/x86/include/asm/apic.h:398
398		return apic->read(reg);
(gdb) n
do_boot_cpu (apicid=apicid@entry=3, cpu=cpu@entry=3, idle=idle@entry=0xffff888004938000, cpu0_nmi_registered=cpu0_nmi_registered@entry=0xffffc90000d77d0c) at arch/x86/kernel/smpboot.c:1094
1094		cpumask_clear_cpu(cpu, cpu_initialized_mask);
(gdb) si
clear_bit (addr=<optimized out>, nr=3) at ./arch/x86/include/asm/bitops.h:118
118			asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
(gdb) si
do_boot_cpu (apicid=apicid@entry=3, cpu=cpu@entry=3, idle=idle@entry=0xffff888004938000, cpu0_nmi_registered=cpu0_nmi_registered@entry=0xffffc90000d77d0c) at arch/x86/kernel/smpboot.c:1095
1095		smp_mb();
(gdb) si
1103		if (apic->wakeup_secondary_cpu)
(gdb) si
0xffffffff810d30ce	1103		if (apic->wakeup_secondary_cpu)
(gdb) si
0xffffffff810d30d5	1103		if (apic->wakeup_secondary_cpu)
(gdb) si
0xffffffff810d30d8	1103		if (apic->wakeup_secondary_cpu)
(gdb) si
wakeup_cpu_via_init_nmi (cpu0_nmi_registered=0xffffc90000d77d0c, apicid=3, start_ip=630784, cpu=3) at arch/x86/kernel/smpboot.c:1106
1106			boot_error = wakeup_cpu_via_init_nmi(cpu, start_ip, apicid,
..
(gdb) n
wakeup_secondary_cpu_via_init (start_eip=630784, phys_apicid=3) at arch/x86/kernel/smpboot.c:817
817			apic_read(APIC_ESR);
(gdb) n
820		pr_debug("Asserting INIT\n");
(gdb) n
828		apic_icr_write(APIC_INT_LEVELTRIG | APIC_INT_ASSERT | APIC_DM_INIT,
(gdb) n
831		pr_debug("Waiting for send to finish...\n");
(gdb) n
832		send_status = safe_apic_wait_icr_idle();
(gdb) si
0xffffffff810d32e6 in safe_apic_wait_icr_idle () at ./arch/x86/include/asm/apic.h:428
428		return apic->safe_wait_icr_idle();
(gdb) n
wakeup_secondary_cpu_via_init (start_eip=630784, phys_apicid=3) at arch/x86/kernel/smpboot.c:834
834		udelay(init_udelay);
(gdb) si
0xffffffff810d32f5	834		udelay(init_udelay);
(gdb) si
__udelay (usecs=0) at arch/x86/lib/delay.c:222
222	{
(gdb) si
__const_udelay (xloops=0) at arch/x86/lib/delay.c:223
223		__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
(gdb) n
209		unsigned long lpj = this_cpu_read(cpu_info.loops_per_jiffy) ? : loops_per_jiffy;
(gdb) n
212		xloops *= 4;
(gdb) n
213		asm("mull %%edx"
(gdb) n
217		__delay(++xloops);
(gdb) n
delay_tsc (cycles=1) at arch/x86/lib/delay.c:64
64	{
(gdb) n
69		cpu = smp_processor_id();
(gdb) n
70		bclock = rdtsc_ordered();
(gdb) n
72			now = rdtsc_ordered();
(gdb) n
73			if ((now - bclock) >= cycles)
(gdb) n
96		preempt_enable();
(gdb) n
wakeup_secondary_cpu_via_init (start_eip=630784, phys_apicid=3) at arch/x86/kernel/smpboot.c:836
836		pr_debug("Deasserting INIT\n");
(gdb) n
840		apic_icr_write(APIC_INT_LEVELTRIG | APIC_DM_INIT, phys_apicid);
(gdb) n
842		pr_debug("Waiting for send to finish...\n");
(gdb) n
843		send_status = safe_apic_wait_icr_idle();
(gdb) n
845		mb();
(gdb) n
861		pr_debug("#startup loops: %d\n", num_starts);
(gdb) n
...
(gdb) n
904			if (send_status || accept_status)
(gdb) n
863		for (j = 1; j <= num_starts; j++) {
(gdb) n
864			pr_debug("Sending STARTUP #%d\n", j);
(gdb) n
865			if (maxlvt > 3)		/* Due to the Pentium erratum 3AP.  */
(gdb) n
...
(gdb) si
1114			timeout = jiffies + 10*HZ;
(gdb) n
1115			while (time_before(jiffies, timeout)) {
(gdb) n
1116				if (cpumask_test_cpu(cpu, cpu_initialized_mask)) {
(gdb) n
341		return oldbit;
(gdb) n
1124				schedule();
(gdb) si
schedule () at kernel/sched/core.c:3932
3932	{
...
