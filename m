Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572842635A0
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 20:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgIISKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 14:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIISKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 14:10:33 -0400
X-Greylist: delayed 379 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Sep 2020 11:10:32 PDT
Received: from forward106o.mail.yandex.net (forward106o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61DDC061573
        for <kvm@vger.kernel.org>; Wed,  9 Sep 2020 11:10:32 -0700 (PDT)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward106o.mail.yandex.net (Yandex) with ESMTP id 49DF7506113E;
        Wed,  9 Sep 2020 21:04:06 +0300 (MSK)
Received: from mxback11q.mail.yandex.net (mxback11q.mail.yandex.net [IPv6:2a02:6b8:c0e:1b4:0:640:1f0c:10f2])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id 44351CF40002;
        Wed,  9 Sep 2020 21:04:06 +0300 (MSK)
Received: from vla3-3dd1bd6927b2.qloud-c.yandex.net (vla3-3dd1bd6927b2.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:3dd1:bd69])
        by mxback11q.mail.yandex.net (mxback/Yandex) with ESMTP id bgIBNja6DN-465S2L4H;
        Wed, 09 Sep 2020 21:04:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1599674646;
        bh=T0j8Q3vuZtATAiCDjEQw13Mr97E2iSSRD8sa7SL2wbE=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=HJ0FzRAO9Hw7bA/+QrN8gEFLFBan5k/QtiK6ceyuLJbl6YLXvdpcBL5Z5rK2kByDc
         5LE981l2CO6QpcTk6DjwXl2mMrirVCKAo3M9LOEyFcBikevaLRm5VLnTU3FcWZw2jQ
         tPIVVTyzt/zxqizK8gHV6bwwnA+AI/FbSYaSD/QI=
Authentication-Results: mxback11q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla3-3dd1bd6927b2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id s05EzP7qon-45IaI471;
        Wed, 09 Sep 2020 21:04:05 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: KVM_SET_SREGS & cr4.VMXE problems
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
References: <8f0d9048-c935-bccf-f7bd-58ba61759a54@yandex.ru>
 <20200909163023.GA11727@sjchrist-ice>
From:   stsp <stsp2@yandex.ru>
Message-ID: <fdeb1ecb-abee-2197-4449-88d33480c5fe@yandex.ru>
Date:   Wed, 9 Sep 2020 21:04:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200909163023.GA11727@sjchrist-ice>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, good to see an Intel person
involved in that. :)

09.09.2020 19:30, Sean Christopherson пишет:
> On Wed, Sep 09, 2020 at 01:04:45PM +0300, stsp wrote:
>> Hi Guys!
>>
>> I have a kvm-based hypervisor, and also I have problems with how KVM handles
>> cr4.VMXE flag.
>>
>> Problem 1 can be shown as follows.
>>
>> The below snippet WORKS as expected:
>> ---
>>      sregs.cr4 |= X86_CR4_VMXE;
> What is the starting value of sregs?  Not that it should matter, but it'd
> be helpful to reproduce and understand the issue.

Just X86_CR4_VME.
In fact, I do KVM_GET_SREGS first
and OR with VME, but there are no
other flags set, so just VME.
Also I can give you a reference
where you can see all of the state:
https://github.com/dosemu2/dosemu2/issues/1274#issuecomment-687900084


>>      ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
>>      if (ret == -1) {
>>        perror("KVM: KVM_SET_SREGS");
>>        leavedos(99);
>>      }
>> ---
>>
>> The below one doesn't:
>> ---
>>      ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
>>      if (ret == -1) {
>>        perror("KVM: KVM_SET_SREGS");
>>        leavedos(99);
>>      }
>>      sregs.cr4 |= X86_CR4_VMXE;
>>      ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
>>      if (ret == -1) {
>>        perror("KVM: KVM_SET_SREGS");
>>        leavedos(99);
>>      }
>> ---
>>
>> Basically that example demonstrates that I can set VMXE flag only by the very
>> first call to KVM_SET_SREGS. Any subsequent calls do not allow me to modify
>> VMXE flag, even though no error is returned, and other flags are modified, if
>> needed, as expected, but not this one.  Is there any reason why VMXE flag is
>> "locked" to its very first setting?
> IIUC, in the above snippet, you observe that "ret == 0" but rereading sregs
> shows the old CR4 value?

Indeed:
---

     ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
     if (ret == -1) {
       perror("KVM: KVM_SET_SREGS");
       leavedos(99);
     }
     ret = ioctl(vcpufd, KVM_GET_SREGS, &sregs);
     printf("cr4(init): %llx\n", sregs.cr4);
     sregs.cr4 |= X86_CR4_VMXE;
     printf("cr4(want): %llx\n", sregs.cr4);
     ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
     if (ret == -1) {
       perror("KVM: KVM_SET_SREGS");
       leavedos(99);
     }
     ret = ioctl(vcpufd, KVM_GET_SREGS, &sregs);
    printf("cr4(got): %llx\n", sregs.cr4);
---


With this I get:

cr4(init): 1
cr4(want): 2001
cr4(got): 1

So its ignored both on read-back,
and in the guest state dump:
https://github.com/dosemu2/dosemu2/issues/1274#issuecomment-689158696


> The direct cause of the weirdness is a KVM bug in KVM_SET_SREGS where it
> doesn't check the return of vendor specific handling (VMX vs. SVM) of setting
> CR4.

Note that I reproduce that on an AMD CPU.
Other guy at guthub tried on Intel. Same thing.


>> Problem 2:
>> If I set both VME and VMXE flags (by the very first invocation of
>> KVM_SET_SREGS, yes), then VME flag does not actually work. My hypervisor then
>> runs in non-VME mode.  Is it KVM that clears the VME flag when VMXE is set,
>> or is it really not a workable combination of flags?
> What do you mean by "My hypervisor runs in non-VME mode"?  I assume you mean
> the guest is in non-VME mode?

Yes, of course. Sorry for confusion.
Hypervisor itself does not need VME
on host.


> If you're referring to the guest, what CPU generation are you running?

Surprisingly, I am reproducing this all
on AMD FX. So its really something very
generic. It was initially reported to me
on github against an Intel CPU, but I can
reproduce on AMD.


>> Problem 3.
>> Some older Intel CPUs appear to require the VMXE flag even in non-root VMX.
>> This is vaguely documented in an Intel specs:
>> ---
>> The first processors to support VMX operation require that the
>> following bits be 1 in VMX operation: CR0.PE, CR0.NE, CR0.PG, and CR4.VMXE.
>> ---
>>
>> They are not explicit about a non-root mode, but my experiments show they
>> meant exactly that. On such CPUs, KVM otherwise returns KVM_EXIT_FAIL_ENTRY,
>> "invalid guest state".
> Do you have emulate_invalid_guest_state disabled?

I asked that on github.
The guy reports it is enabled:
https://github.com/dosemu2/dosemu2/issues/1274#issuecomment-689724729


>> Question: did they really mean non-root, and if so - shouldn't KVM itself
>> work around such quirks?
> Yes, it really does include non-root.  On CPUs without unrestricted guest,
> the world switch to non-root is less complete, for lack of a better term.
> Non-root without unrestricted guest requires the CPU to be in protected mode
> with paging enabled as the CPU isn't capable of properly virtualizing things
> if paging is disabled.  CR4.VMXE=1 is always required, even on modern CPUs.

You mean, even in non-root? Why?
That sounds strange, i.e. at least I
don't need to set in in sregs, and on
modern CPUs it works OK without.
I thought it would only make sense
in non-root for the nested execution,
or is this assumption wrong?


> However, those are the _hardware_ values of CR4, not the guest value of CR4,
> i.e. the value visible to the guest is different than the actual value in
> hardware.  And KVM_SET_SREGS operates on the _guest_ value, KVM always has
> final say on the hardware value.

Interestingly, as we can see from the
state dumps (that are on github), the
sreg's cr4 value goes to "shadow".
Does "shadow" means "for guest",
and "actual" means "hardware"?
I am confused, seems like some inversion
of terms somewhere. I thought "shadow"
should mean "hardware", but its not
what I see in the dumps.


> Note, the hardware value when running in the guest (non-root) will be very
> different than the hardware value when running in the host (root), e.g. MCE
> is the only CR4 bit that is explicitly propagated to the hardware value for
> the guest, all other bits (including VME) are recomputed based on CPU
> capabilities, KVM module params, and guest state.

Why would VME be re-computed?
Is it not always supported?


>> I wouldn't mind enabling VMXE myself, if not for the Problem 2 above, that
>> just disables VME then.  Can KVM be somehow "fixed" to not require all these
>> dancing, or is there a better ways of fixing that problem?
> Can you rewind and describe your original problem?  It sounds like you're
> trying to do something very specific on old hardware, encountered an error,
> and then built up a pile of workarounds that led you into more issues that
> aren't directly related to the original problem.

Its indeed exactly how it was escalating! :)
I got a report about an older Intel CPUs,
but was able to reproduce a lot of "crap"
also on AMD, so now I am completely confused.

As for the original problem: there are at least
2 problems.

On OLD intel:
- KVM fails with invalid guest state unless
you set VMXE in guest's cr4, and do it from
the very first attempt!

On any CPU:
- If you set VMXE in guest's cr4, then guest
works in non-VME mode, as if cr4.VME was
cleared. But I didn't clear it - KVM did!

Thanks for your help.

