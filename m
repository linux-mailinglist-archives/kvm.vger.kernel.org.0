Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8D6587BDA
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 13:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbiHBL5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 07:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236575AbiHBL5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 07:57:53 -0400
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5673B4D4E0
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 04:57:51 -0700 (PDT)
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 6CEE742DAC;
        Tue,  2 Aug 2022 13:57:49 +0200 (CEST)
Message-ID: <ce2d0157-c269-f50d-8aa3-6caa2ac02593@proxmox.com>
Date:   Tue, 2 Aug 2022 13:57:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Guest reboot issues since QEMU 6.0 and Linux 5.11
Content-Language: en-US
To:     Yan Vugenfirer <yan@daynix.com>
Cc:     kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Mira Limbeck <m.limbeck@proxmox.com>
References: <eb0e0c7e-5b6f-a573-43f6-bd58be243d6b@proxmox.com>
 <1675C8E3-D071-4F5A-814B-A06C281CC930@daynix.com>
From:   Fiona Ebner <f.ebner@proxmox.com>
In-Reply-To: <1675C8E3-D071-4F5A-814B-A06C281CC930@daynix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 28.07.22 um 12:13 schrieb Yan Vugenfirer:
> Hi Fabian,
> 
> Can you save the dump file with QEMU monitor using dump-guest-memory or with virsh dump?
> Then you can use elf2dmp (compiled with QEMU and is found in “contrib” folder) to covert the dump file to WinDbg format and examine the stack. 
> 

Hi Yan,
thank you for the suggestion!

So for the two VMs in the KVM_EXIT_SHUTDOWN-qemu_system_reset-loop, I get

> 2 CPU states has been found
> CPU #0 CR3 is 0x0000000000800000
> DirectoryTableBase = 0x000fffffffd08000 has been found from CPU #0 as interrupt handling CR3
> [1]    4169758 segmentation fault (core dumped)  elf2dmp memdump.elf memdump.dmp

I tried twice more, hoping for better timing, but the results were the
same (haven't looked into why it segfaults yet). For the second one
there is no segfault, but still an error upon conversion:

> 2 CPU states has been found
> CPU #0 CR3 is 0x0000000000800000
> DirectoryTableBase = 0x0000000000000000 has been found from CPU #0 as interrupt handling CR3
> Failed to find paging base


For the VM with the spinning circles, the dump was converted
successfully at least, but I don't have any experience with WinDbg and
nothing interesting pops out to me:

> Microsoft (R) Windows Debugger Version 10.0.22621.1 AMD64
> Copyright (c) Microsoft Corporation. All rights reserved.
> 
> 
> Loading Dump File [F:\win-reboot-dump\memdump-circles.dmp]
> Kernel Complete Dump File: Full address space is available
> 
> Comment: 'Hello from elf2dmp!'
> Symbol search path is: srv*
> Executable search path is: 
> Windows 8.1 Kernel Version 9600 MP (2 procs) Free x64
> Product: Server, suite: TerminalServer SingleUserTS
> Edition build lab: 9600.19913.amd64fre.winblue_ltsb_escrow.201207-1920
> Machine Name:
> Kernel base = 0xfffff802`05073000 PsLoadedModuleList = 0xfffff802`053385d0
> System Uptime: 0 days 0:00:52.919
> Loading Kernel Symbols
> ...............................................................
> .....................................
> Loading User Symbols
> 
> Loading unloaded module list
> ..
> Unknown exception - code 00000000 (first/second chance not available)
> For analysis of this file, run !analyze -v
> 0: kd> ~0
> 0: kd> kb
>  # RetAddr               : Args to Child                                                           : Call Site
> 00 fffff802`0526a0ad     : ffffe002`00519650 ffffe002`00519410 00000000`00000000 fffff802`05354180 : hal!HalProcessorIdle+0xf
> 01 fffff802`05168a50     : fffff802`05354180 fffff802`066a2300 00000000`00000000 ffffe002`00519410 : nt!PpmIdleDefaultExecute+0x1d
> 02 fffff802`050dd186     : fffff802`05354180 fffff802`066a23cc fffff802`066a23d0 fffff802`066a23d8 : nt!PpmIdleExecuteTransition+0x400
> 03 fffff802`051b71ac     : fffff802`05354180 fffff802`05354180 fffff802`053bba00 00000000`00000000 : nt!PoIdle+0x2f6
> 04 00000000`00000000     : fffff802`066a3000 fffff802`0669c000 00000000`00000000 00000000`00000000 : nt!KiIdleLoop+0x2c
> 0: kd> r
> rax=0000000000000000 rbx=0000000000000000 rcx=0000000000000086
> rdx=0000000000000000 rsi=00000000ffffffff rdi=ffffe00200519410
> rip=fffff8020501e81f rsp=fffff802066a2258 rbp=fffff802066a2339
>  r8=00000000ffffffff  r9=0000000000000000 r10=0000000000000002
> r11=0000000000000001 r12=0000000000000000 r13=0000000000000001
> r14=000000001f8de167 r15=0000000000000000
> iopl=0         nv up ei ng nz na pe nc
> cs=0010  ss=0018  ds=002b  es=002b  fs=0053  gs=002b             efl=00000282
> hal!HalProcessorIdle+0xf:
> fffff802`0501e81f c3              ret
> 0: kd> ~1
> 1: kd> kb
>  # RetAddr               : Args to Child                                                           : Call Site
> 00 fffff802`0526a0ad     : ffffe002`00521b20 ffffe002`005218e0 00000000`00000000 ffffd000`203da180 : hal!HalProcessorIdle+0xf
> 01 fffff802`05168a50     : ffffd000`203da180 ffffd000`203f8300 00000000`00000000 0000018e`b7f04213 : nt!PpmIdleDefaultExecute+0x1d
> 02 fffff802`050dd186     : ffffd000`203da180 ffffd000`203f83cc ffffd000`203f83d0 ffffd000`203f83d8 : nt!PpmIdleExecuteTransition+0x400
> 03 fffff802`051b71ac     : ffffd000`203da180 ffffd000`203da180 ffffd000`203ea300 00000000`00000000 : nt!PoIdle+0x2f6
> 04 00000000`00000000     : ffffd000`203f9000 ffffd000`203f2000 00000000`00000000 00000000`00000000 : nt!KiIdleLoop+0x2c
> 1: kd> r
> rax=0000000000000020 rbx=0000000000000000 rcx=0000000000000086
> rdx=0000000000000000 rsi=00000000ffffffff rdi=ffffe002005218e0
> rip=fffff8020501e81f rsp=ffffd000203f8258 rbp=ffffd000203f8339
>  r8=00000000ffffffff  r9=0000000000000000 r10=0000000000000002
> r11=0000000000000001 r12=0000000000000000 r13=0000000000000001
> r14=000128d624996edd r15=0000000000000000
> iopl=0         nv up ei ng nz na pe nc
> cs=0010  ss=0018  ds=002b  es=002b  fs=0053  gs=002b             efl=00000282
> hal!HalProcessorIdle+0xf:
> fffff802`0501e81f c3              ret

Is there anything I should be looking at in particular?

I took a second dump about 40 minutes later, but it essentially looks
the same.

Best regards,
Fiona

> 
> Best regards,
> Yan.
> 
> 
>> On 21 Jul 2022, at 3:49 PM, Fabian Ebner <f.ebner@proxmox.com> wrote:
>>
>> Hi,
>> since about half a year ago, we're getting user reports about guest
>> reboot issues with KVM/QEMU[0].
>>
>> The most common scenario is a Windows Server VM (2012R2/2016/2019,
>> UEFI/OVMF and SeaBIOS) getting stuck during the screen with the Windows
>> logo and the spinning circles after a reboot was triggered from within
>> the guest. Quitting the kvm process and booting with a fresh instance
>> works. The issue seems to become more likely, the longer the kvm
>> instance runs.
>>
>> We did not get such reports while we were providing Linux 5.4 and QEMU
>> 5.2.0, but we do with Linux 5.11/5.13/5.15 and QEMU 6.x.
>>
>> I'm just wondering if anybody has seen this issue before or might have a
>> hunch what it's about? Any tips on what to look out for when debugging
>> are also greatly appreciated!
>>
>> We do have debug access to a user's test VM and the VM state was saved
>> before a problematic reboot, but I can't modify the host system there.
>> AFAICT QEMU just executes guest code as usual, but I'm really not sure
>> what to look out for.
>>
>> That VM has CPU type host, and a colleague did have a similar enough CPU
>> to load the VM state, but for him, the reboot went through normally. On
>> the user's system, it triggers consistently after loading the VM state
>> and rebooting.
>>
>> So unfortunately, we didn't manage to reproduce the issue locally yet.
>> With two other images provided by users, we ran into a boot loop, where
>> QEMU resets the CPUs and does a few KVM_RUNs before the exit reason is
>> KVM_EXIT_SHUTDOWN (which to my understanding indicates a triple fault)
>> and then it repeats. It's not clear if the issues are related.
>>
>> There are also a few reports about non-Windows VMs, mostly Ubuntu 20.04
>> with UEFI/OVMF, but again, it's not clear if the issues are related.
>>
>> [0]: https://forum.proxmox.com/threads/100744/
>> (the forum thread is a bit chaotic unfortunately).
>>
>> Best Regards,
>> Fabi
>>
>>
>>
> 
> 

