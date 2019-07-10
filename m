Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBB664A89
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfGJQMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:12:05 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:37402 "EHLO lizzard.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfGJQMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 12:12:05 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 12:12:04 EDT
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by lizzard.sbs.de (8.15.2/8.15.2) with ESMTPS id x6AG5OGb021938
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 18:05:24 +0200
Received: from [139.25.68.37] (md1q0hnc.ad001.siemens.net [139.25.68.37] (may be forged))
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id x6AG5O2o029032;
        Wed, 10 Jul 2019 18:05:24 +0200
Subject: Re: KVM_SET_NESTED_STATE not yet stable
To:     "Raslan, KarimAllah" <karahmed@amazon.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <9eb4dd9f-65e5-627d-b288-e5fe8ade0963@siemens.com>
 <1562772280.18613.25.camel@amazon.de>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <f1936ed9-e41b-4d36-50bb-3956434d993c@siemens.com>
Date:   Wed, 10 Jul 2019 18:05:23 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <1562772280.18613.25.camel@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi KarimAllah,

On 10.07.19 17:24, Raslan, KarimAllah wrote:
> On Mon, 2019-07-08 at 22:39 +0200, Jan Kiszka wrote:
>> Hi all,
>>
>> it seems the "new" KVM_SET_NESTED_STATE interface has some remaining
>> robustness issues.
> 
> I would be very interested to learn about any more robustness issues that you 
> are seeing.
> 
>> The most urgent one: With the help of latest QEMU
>> master that uses this interface, you can easily crash the host. You just
>> need to start qemu-system-x86 -enable-kvm in L1 and then hard-reset L1.
>> The host CPU that ran this will stall, the system will freeze soon.
> 
> Just to confirm, you start an L2 guest using qemu inside an L1-guest and then 
> hard-reset the L1 guest?

Exactly.

> 
> Are you running any special workload in L2 or L1 when you reset? Also how 

Nope. It is a standard (though rather oldish) userland in L1, just running a
more recent kernel 5.2.

> exactly are you doing this "hard reset"?

system_reset from the monitor or "reset" from QEMU window menu.

> 
> (sorry just tried this in my setup and I did not see any problem but my setup
>  is slightly different, so just ruling out obvious stuff).
> 

If it helps, I can share privately a guest image that was built via
https://github.com/siemens/jailhouse-images which exposes the reset issue after
starting Jailhouse (instead of qemu-system-x86_64 - though that should "work" as
well, just not tested yet). It's about 70M packed.

Host-wise, 5.2.0 + QEMU master should do. I can also provide you the .config if
needed.

>>
>> I've also seen a pattern with my Jailhouse test VM where I seems to get
>> stuck in a loop between L1 and L2:
>>
>>  qemu-system-x86-6660  [007]   398.691401: kvm_nested_vmexit:    rip 7fa9ee5224e4 reason IO_INSTRUCTION info1 5658000b info2 0 int_info 0 int_info_err 0
>>  qemu-system-x86-6660  [007]   398.691402: kvm_fpu:              unload
>>  qemu-system-x86-6660  [007]   398.691403: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
>>  qemu-system-x86-6660  [007]   398.691440: kvm_fpu:              load
>>  qemu-system-x86-6660  [007]   398.691441: kvm_pio:              pio_read at 0x5658 size 4 count 1 val 0x4 
>>  qemu-system-x86-6660  [007]   398.691443: kvm_mmu_get_page:     existing sp gfn 3a22e 1/4 q3 direct --x !pge !nxe root 6 sync
>>  qemu-system-x86-6660  [007]   398.691444: kvm_entry:            vcpu 3
>>  qemu-system-x86-6660  [007]   398.691475: kvm_exit:             reason IO_INSTRUCTION rip 0x7fa9ee5224e4 info 5658000b 0
>>  qemu-system-x86-6660  [007]   398.691476: kvm_nested_vmexit:    rip 7fa9ee5224e4 reason IO_INSTRUCTION info1 5658000b info2 0 int_info 0 int_info_err 0
>>  qemu-system-x86-6660  [007]   398.691477: kvm_fpu:              unload
>>  qemu-system-x86-6660  [007]   398.691478: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
>>  qemu-system-x86-6660  [007]   398.691526: kvm_fpu:              load
>>  qemu-system-x86-6660  [007]   398.691527: kvm_pio:              pio_read at 0x5658 size 4 count 1 val 0x4 
>>  qemu-system-x86-6660  [007]   398.691529: kvm_mmu_get_page:     existing sp gfn 3a22e 1/4 q3 direct --x !pge !nxe root 6 sync
>>  qemu-system-x86-6660  [007]   398.691530: kvm_entry:            vcpu 3
>>  qemu-system-x86-6660  [007]   398.691533: kvm_exit:             reason IO_INSTRUCTION rip 0x7fa9ee5224e4 info 5658000b 0
>>  qemu-system-x86-6660  [007]   398.691534: kvm_nested_vmexit:    rip 7fa9ee5224e4 reason IO_INSTRUCTION info1 5658000b info2 0 int_info 0 int_info_err 0
>>
>> These issues disappear when going from ebbfef2f back to 6cfd7639 (both
>> with build fixes) in QEMU.
> 
> This is the QEMU that you are using in L0 to launch an L1 guest, right? or are 
> you still referring to the QEMU mentioned above?

This scenario is similar but still a bit different than the above. Yes, same L0
image and host QEMU here (and the traces were taken on the host, obviously), but
the workload is now as follows:

 - boot L1 Linux
 - enable Jailhouse inside L1
 - move the mouse over the graphical desktop of L2, ie. the former L1
   Linux (Jailhouse is now L1)
 - the L1/L2 guests enter the loop above while trying to read from the
   vmmouse port

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
