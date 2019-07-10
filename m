Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6049964D96
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 22:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfGJUb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 16:31:58 -0400
Received: from goliath.siemens.de ([192.35.17.28]:37584 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfGJUb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 16:31:58 -0400
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id x6AKVcCV020887
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 22:31:38 +0200
Received: from [139.22.38.2] ([139.22.38.2])
        by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id x6AKVbi3030034;
        Wed, 10 Jul 2019 22:31:37 +0200
Subject: Re: KVM_SET_NESTED_STATE not yet stable
From:   Jan Kiszka <jan.kiszka@siemens.com>
To:     "Raslan, KarimAllah" <karahmed@amazon.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <9eb4dd9f-65e5-627d-b288-e5fe8ade0963@siemens.com>
 <1562772280.18613.25.camel@amazon.de>
 <f1936ed9-e41b-4d36-50bb-3956434d993c@siemens.com>
Cc:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
Message-ID: <cfd86643-dbac-3a69-9faf-03eaa8aee6a1@siemens.com>
Date:   Wed, 10 Jul 2019 22:31:37 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <f1936ed9-e41b-4d36-50bb-3956434d993c@siemens.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.07.19 18:05, Jan Kiszka wrote:
> Hi KarimAllah,
> 
> On 10.07.19 17:24, Raslan, KarimAllah wrote:
>> On Mon, 2019-07-08 at 22:39 +0200, Jan Kiszka wrote:
>>> Hi all,
>>>
>>> it seems the "new" KVM_SET_NESTED_STATE interface has some remaining
>>> robustness issues.
>>
>> I would be very interested to learn about any more robustness issues that you 
>> are seeing.
>>
>>> The most urgent one: With the help of latest QEMU
>>> master that uses this interface, you can easily crash the host. You just
>>> need to start qemu-system-x86 -enable-kvm in L1 and then hard-reset L1.
>>> The host CPU that ran this will stall, the system will freeze soon.
>>
>> Just to confirm, you start an L2 guest using qemu inside an L1-guest and then 
>> hard-reset the L1 guest?
> 
> Exactly.
> 
>>
>> Are you running any special workload in L2 or L1 when you reset? Also how 
> 
> Nope. It is a standard (though rather oldish) userland in L1, just running a
> more recent kernel 5.2.
> 
>> exactly are you doing this "hard reset"?
> 
> system_reset from the monitor or "reset" from QEMU window menu.
> 
>>
>> (sorry just tried this in my setup and I did not see any problem but my setup
>>  is slightly different, so just ruling out obvious stuff).
>>
> 
> If it helps, I can share privately a guest image that was built via
> https://github.com/siemens/jailhouse-images which exposes the reset issue after
> starting Jailhouse (instead of qemu-system-x86_64 - though that should "work" as
> well, just not tested yet). It's about 70M packed.
> 
> Host-wise, 5.2.0 + QEMU master should do. I can also provide you the .config if
> needed.
> 
>>>
>>> I've also seen a pattern with my Jailhouse test VM where I seems to get
>>> stuck in a loop between L1 and L2:
>>>
>>>  qemu-system-x86-6660  [007]   398.691401: kvm_nested_vmexit:    rip 7fa9ee5224e4 reason IO_INSTRUCTION info1 5658000b info2 0 int_info 0 int_info_err 0
>>>  qemu-system-x86-6660  [007]   398.691402: kvm_fpu:              unload
>>>  qemu-system-x86-6660  [007]   398.691403: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
>>>  qemu-system-x86-6660  [007]   398.691440: kvm_fpu:              load
>>>  qemu-system-x86-6660  [007]   398.691441: kvm_pio:              pio_read at 0x5658 size 4 count 1 val 0x4 
>>>  qemu-system-x86-6660  [007]   398.691443: kvm_mmu_get_page:     existing sp gfn 3a22e 1/4 q3 direct --x !pge !nxe root 6 sync
>>>  qemu-system-x86-6660  [007]   398.691444: kvm_entry:            vcpu 3
>>>  qemu-system-x86-6660  [007]   398.691475: kvm_exit:             reason IO_INSTRUCTION rip 0x7fa9ee5224e4 info 5658000b 0
>>>  qemu-system-x86-6660  [007]   398.691476: kvm_nested_vmexit:    rip 7fa9ee5224e4 reason IO_INSTRUCTION info1 5658000b info2 0 int_info 0 int_info_err 0
>>>  qemu-system-x86-6660  [007]   398.691477: kvm_fpu:              unload
>>>  qemu-system-x86-6660  [007]   398.691478: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
>>>  qemu-system-x86-6660  [007]   398.691526: kvm_fpu:              load
>>>  qemu-system-x86-6660  [007]   398.691527: kvm_pio:              pio_read at 0x5658 size 4 count 1 val 0x4 
>>>  qemu-system-x86-6660  [007]   398.691529: kvm_mmu_get_page:     existing sp gfn 3a22e 1/4 q3 direct --x !pge !nxe root 6 sync
>>>  qemu-system-x86-6660  [007]   398.691530: kvm_entry:            vcpu 3
>>>  qemu-system-x86-6660  [007]   398.691533: kvm_exit:             reason IO_INSTRUCTION rip 0x7fa9ee5224e4 info 5658000b 0
>>>  qemu-system-x86-6660  [007]   398.691534: kvm_nested_vmexit:    rip 7fa9ee5224e4 reason IO_INSTRUCTION info1 5658000b info2 0 int_info 0 int_info_err 0
>>>
>>> These issues disappear when going from ebbfef2f back to 6cfd7639 (both
>>> with build fixes) in QEMU.
>>
>> This is the QEMU that you are using in L0 to launch an L1 guest, right? or are 
>> you still referring to the QEMU mentioned above?
> 
> This scenario is similar but still a bit different than the above. Yes, same L0
> image and host QEMU here (and the traces were taken on the host, obviously), but
> the workload is now as follows:
> 
>  - boot L1 Linux
>  - enable Jailhouse inside L1
>  - move the mouse over the graphical desktop of L2, ie. the former L1
>    Linux (Jailhouse is now L1)
>  - the L1/L2 guests enter the loop above while trying to read from the
>    vmmouse port
> 
> Jan
> 

Ralf tried my case on some of his systems as well but he also didn't succeed in
reproducing. So we compared vmxcap lists because I'm starting to think it's
feature-related. There are some differences...

--- vmxcap.i7-5600u	2019-07-10 21:59:05.616547924 +0200
+++ vmxcap.jan	2019-07-10 21:58:23.135686409 +0200
@@ -1,6 +1,6 @@
 Basic VMX Information
-  Hex: 0xda040000000012
-  Revision                                 18
+  Hex: 0xda040000000004
+  Revision                                 4
   VMCS size                                1024
   VMCS restricted to 32 bit addresses      no
   Dual-monitor support                     yes
@@ -51,13 +51,13 @@
   Enable INVPCID                           yes
   Enable VM functions                      yes
   VMCS shadowing                           yes
-  Enable ENCLS exiting                     no
+  Enable ENCLS exiting                     yes
   RDSEED exiting                           yes
-  Enable PML                               no
+  Enable PML                               yes
   EPT-violation #VE                        yes
-  Conceal non-root operation from PT       no
-  Enable XSAVES/XRSTORS                    no
-  Mode-based execute control (XS/XU)       no
+  Conceal non-root operation from PT       yes
+  Enable XSAVES/XRSTORS                    yes
+  Mode-based execute control (XS/XU)       yes
   TSC scaling                              no
 VM-Exit controls
   Save debug controls                      default
@@ -69,8 +69,8 @@
   Save IA32_EFER                           yes
   Load IA32_EFER                           yes
   Save VMX-preemption timer value          yes
-  Clear IA32_BNDCFGS                       no
-  Conceal VM exits from PT                 no
+  Clear IA32_BNDCFGS                       yes
+  Conceal VM exits from PT                 yes
 VM-Entry controls
   Load debug controls                      default
   IA-32e mode guest                        yes
@@ -79,11 +79,11 @@
   Load IA32_PERF_GLOBAL_CTRL               yes
   Load IA32_PAT                            yes
   Load IA32_EFER                           yes
-  Load IA32_BNDCFGS                        no
-  Conceal VM entries from PT               no
+  Load IA32_BNDCFGS                        yes
+  Conceal VM entries from PT               yes
 Miscellaneous data
-  Hex: 0x300481e5
-  VMX-preemption timer scale (log2)        5
+  Hex: 0x7004c1e7
+  VMX-preemption timer scale (log2)        7
   Store EFER.LMA into IA-32e mode guest control yes
   HLT activity state                       yes
   Shutdown activity state                  yes
@@ -93,10 +93,10 @@
   MSR-load/store count recommendation      0
   IA32_SMM_MONITOR_CTL[2] can be set to 1  yes
   VMWRITE to VM-exit information fields    yes
-  Inject event with insn length=0          no
+  Inject event with insn length=0          yes
   MSEG revision identifier                 0
 VPID and EPT capabilities
-  Hex: 0xf0106334141
+  Hex: 0xf0106734141
   Execute-only EPT translations            yes
   Page-walk length 4                       yes
   Paging-structure memory type UC          yes

And another machine that does not crash:

--- vmxcaps.e5-2683v4	2019-07-10 22:21:28.620329384 +0200
+++ vmxcap.jan	2019-07-10 21:58:23.135686409 +0200
@@ -1,6 +1,6 @@
 Basic VMX Information
-  Hex: 0xda040000000012
-  Revision                                 18
+  Hex: 0xda040000000004
+  Revision                                 4
   VMCS size                                1024
   VMCS restricted to 32 bit addresses      no
   Dual-monitor support                     yes
@@ -12,7 +12,7 @@
   NMI exiting                              yes
   Virtual NMIs                             yes
   Activate VMX-preemption timer            yes
-  Process posted interrupts                yes
+  Process posted interrupts                no
 primary processor-based controls
   Interrupt window exiting                 yes
   Use TSC offsetting                       yes
@@ -44,20 +44,20 @@
   Enable VPID                              yes
   WBINVD exiting                           yes
   Unrestricted guest                       yes
-  APIC register emulation                  yes
-  Virtual interrupt delivery               yes
+  APIC register emulation                  no
+  Virtual interrupt delivery               no
   PAUSE-loop exiting                       yes
   RDRAND exiting                           yes
   Enable INVPCID                           yes
   Enable VM functions                      yes
   VMCS shadowing                           yes
-  Enable ENCLS exiting                     no
+  Enable ENCLS exiting                     yes
   RDSEED exiting                           yes
   Enable PML                               yes
   EPT-violation #VE                        yes
-  Conceal non-root operation from PT       no
-  Enable XSAVES/XRSTORS                    no
-  Mode-based execute control (XS/XU)       no
+  Conceal non-root operation from PT       yes
+  Enable XSAVES/XRSTORS                    yes
+  Mode-based execute control (XS/XU)       yes
   TSC scaling                              no
 VM-Exit controls
   Save debug controls                      default
@@ -69,8 +69,8 @@
   Save IA32_EFER                           yes
   Load IA32_EFER                           yes
   Save VMX-preemption timer value          yes
-  Clear IA32_BNDCFGS                       no
-  Conceal VM exits from PT                 no
+  Clear IA32_BNDCFGS                       yes
+  Conceal VM exits from PT                 yes
 VM-Entry controls
   Load debug controls                      default
   IA-32e mode guest                        yes
@@ -79,11 +79,11 @@
   Load IA32_PERF_GLOBAL_CTRL               yes
   Load IA32_PAT                            yes
   Load IA32_EFER                           yes
-  Load IA32_BNDCFGS                        no
-  Conceal VM entries from PT               no
+  Load IA32_BNDCFGS                        yes
+  Conceal VM entries from PT               yes
 Miscellaneous data
-  Hex: 0x300481e5
-  VMX-preemption timer scale (log2)        5
+  Hex: 0x7004c1e7
+  VMX-preemption timer scale (log2)        7
   Store EFER.LMA into IA-32e mode guest control yes
   HLT activity state                       yes
   Shutdown activity state                  yes
@@ -93,10 +93,10 @@
   MSR-load/store count recommendation      0
   IA32_SMM_MONITOR_CTL[2] can be set to 1  yes
   VMWRITE to VM-exit information fields    yes
-  Inject event with insn length=0          no
+  Inject event with insn length=0          yes
   MSEG revision identifier                 0
 VPID and EPT capabilities
-  Hex: 0xf0106334141
+  Hex: 0xf0106734141
   Execute-only EPT translations            yes
   Page-walk length 4                       yes
   Paging-structure memory type UC          yes

And on a Xeon D-1540, I'm not seeing a crash but a kvm entry failure when
resetting L1 while running Jailhouse:

KVM: entry failed, hardware error 0x7
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000f61
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
EIP=0000fff0 EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 00000000 0000ffff 00009300
CS =f000 ffff0000 0000ffff 00a09b00
SS =0000 00000000 0000ffff 00c09300
DS =0000 00000000 0000ffff 00009300
FS =0000 00000000 0000ffff 00009300
GS =0000 00000000 0000ffff 00009300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008b00
GDT=     00000000 0000ffff
IDT=     00000000 0000ffff
CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000680
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000000
Code=00 66 89 d8 66 e8 af a1 ff ff 66 83 c4 0c 66 5b 66 5e 66 c3 <ea> 5b e0 00
f0 30 36 2f 32 33 2f 39 39 00 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Here is the vmxcap diff:

--- xeon-d	2019-07-10 22:29:56.735374032 +0200
+++ i7-8850H	2019-07-10 22:29:31.747467248 +0200
@@ -1,6 +1,6 @@
 Basic VMX Information
-  Hex: 0xda040000000012
-  Revision                                 18
+  Hex: 0xda040000000004
+  Revision                                 4
   VMCS size                                1024
   VMCS restricted to 32 bit addresses      no
   Dual-monitor support                     yes
@@ -12,7 +12,7 @@ pin-based controls
   NMI exiting                              yes
   Virtual NMIs                             yes
   Activate VMX-preemption timer            yes
-  Process posted interrupts                yes
+  Process posted interrupts                no
 primary processor-based controls
   Interrupt window exiting                 yes
   Use TSC offsetting                       yes
@@ -44,20 +44,20 @@ secondary processor-based controls
   Enable VPID                              yes
   WBINVD exiting                           yes
   Unrestricted guest                       yes
-  APIC register emulation                  yes
-  Virtual interrupt delivery               yes
+  APIC register emulation                  no
+  Virtual interrupt delivery               no
   PAUSE-loop exiting                       yes
   RDRAND exiting                           yes
   Enable INVPCID                           yes
   Enable VM functions                      yes
   VMCS shadowing                           yes
-  Enable ENCLS exiting                     no
+  Enable ENCLS exiting                     yes
   RDSEED exiting                           yes
   Enable PML                               yes
   EPT-violation #VE                        yes
-  Conceal non-root operation from PT       no
-  Enable XSAVES/XRSTORS                    no
-  Mode-based execute control (XS/XU)       no
+  Conceal non-root operation from PT       yes
+  Enable XSAVES/XRSTORS                    yes
+  Mode-based execute control (XS/XU)       yes
   TSC scaling                              no
 VM-Exit controls
   Save debug controls                      default
@@ -69,8 +69,8 @@ VM-Exit controls
   Save IA32_EFER                           yes
   Load IA32_EFER                           yes
   Save VMX-preemption timer value          yes
-  Clear IA32_BNDCFGS                       no
-  Conceal VM exits from PT                 no
+  Clear IA32_BNDCFGS                       yes
+  Conceal VM exits from PT                 yes
 VM-Entry controls
   Load debug controls                      default
   IA-32e mode guest                        yes
@@ -79,11 +79,11 @@ VM-Entry controls
   Load IA32_PERF_GLOBAL_CTRL               yes
   Load IA32_PAT                            yes
   Load IA32_EFER                           yes
-  Load IA32_BNDCFGS                        no
-  Conceal VM entries from PT               no
+  Load IA32_BNDCFGS                        yes
+  Conceal VM entries from PT               yes
 Miscellaneous data
-  Hex: 0x300481e5
-  VMX-preemption timer scale (log2)        5
+  Hex: 0x7004c1e7
+  VMX-preemption timer scale (log2)        7
   Store EFER.LMA into IA-32e mode guest control yes
   HLT activity state                       yes
   Shutdown activity state                  yes
@@ -93,10 +93,10 @@ Miscellaneous data
   MSR-load/store count recommendation      0
   IA32_SMM_MONITOR_CTL[2] can be set to 1  yes
   VMWRITE to VM-exit information fields    yes
-  Inject event with insn length=0          no
+  Inject event with insn length=0          yes
   MSEG revision identifier                 0
 VPID and EPT capabilities
-  Hex: 0xf0106334141
+  Hex: 0xf0106734141
   Execute-only EPT translations            yes
   Page-walk length 4                       yes
   Paging-structure memory type UC          yes

Maybe the KVM code does not take the latest VMX features into account when
importing a userspace nested state?

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
