Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF1C57E166
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 14:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiGVM2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 08:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiGVM2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 08:28:33 -0400
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D898C4BD17
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 05:28:30 -0700 (PDT)
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 542BF424F9;
        Fri, 22 Jul 2022 14:28:29 +0200 (CEST)
Message-ID: <e4c49e1d-4c37-981f-0611-afc754d52202@proxmox.com>
Date:   Fri, 22 Jul 2022 14:28:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Guest reboot issues since QEMU 6.0 and Linux 5.11
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Cc:     Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Mira Limbeck <m.limbeck@proxmox.com>
References: <eb0e0c7e-5b6f-a573-43f6-bd58be243d6b@proxmox.com>
 <8ac992205e740722160f770821a49278bfa12b0a.camel@redhat.com>
From:   Fiona Ebner <f.ebner@proxmox.com>
In-Reply-To: <8ac992205e740722160f770821a49278bfa12b0a.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 21.07.22 um 17:51 schrieb Maxim Levitsky:
> On Thu, 2022-07-21 at 14:49 +0200, Fabian Ebner wrote:
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
>> KVM_EXIT_SHUTDOWN (which to my understanding indicates a triple fa
>> ult)
>> and then it repeats. It's not clear if the issues are related.
> 
> 
> Does the guest have HyperV enabled in it (that is nested virtualization?)
> 

For all three machines described above
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
indicates that HyperV is disabled.

> Intel or AMD?
> 

We do have reports for both Intel and AMD.

> Does the VM uses secure boot / SMM?
> 

The customer VM which can reliably trigger the issue after loading the
state and rebooting uses SeaBIOS. For the other two VMs,
Confirm-SecureBootUEFI
returns "False".

SMM might be a lead! We did disable SMM in the past, because apparently
there were problems with it (didn't dig out which, was before I worked
here), and the timing of enabling it and the reports coming in would
match. I guess (some) guest OSes don't expect it to be suddenly turned on?

However, there is a report of a user with two clusters with QEMU 5.2,
one with kernel 5.4 without the issue and one with kernel 5.11 with the
issue (Windows VM with spinning circles). So that's confusing :/


We do use some additional options if the OS type is "Windows" in our
high-level configuration, including hyperV enlightenments:

> -cpu 'host,hv_ipi,hv_relaxed,hv_reset,hv_runtime,hv_spinlocks=0x1fff,hv_stimer,hv_synic,hv_time,hv_vapic,hv_vpindex,+kvm_pv_eoi,+kvm_pv_unhalt'
> -no-hpet
> -rtc 'driftfix=slew,base=localtime'
> -global 'kvm-pit.lost_tick_policy=discard'

But one user reported running into the issue even with OS type "other",
i.e. when the above options are not present and CPU flags should be just
'+kvm_pv_eoi,+kvm_pv_unhalt'. There are also reports with CPU type
different from 'host', also with 'kvm64' (where we automatically set the
flags +lahf_lm,+sep).


Thank you and Best Regards,
Fiona

P.S. Please don't mind the (from your perspective sudden) name change.
I'm still the same person and don't intend to change it again :)

> Best regards,
> 	Maxim Levitsky
> 
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
> 
> 
> 

