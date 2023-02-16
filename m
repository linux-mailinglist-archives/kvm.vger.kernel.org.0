Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F790699C92
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBPSoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBPSoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:44:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F354E5D6
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676572991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nzs3CwprvCrdgRRmVwPIesvKSOpY6LpE+5oegZVwNwo=;
        b=PERxfmmKHSiMgflPUdhFk3/JwoIiSCF32V68ZUvK02CjAbwx97C1LMqVYkNCWKpV1Rj7hq
        RYO+lesR8mUobIq5bVBNgZzo9c/X3eVkgkgjgfSARJjLA035OBiAWOma/eWP3+6yAAePQm
        afNtYjIlAXkUKzhEM2cscFGvRF+YNGo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-630-ieZpbSi1MA239eJyDssmaA-1; Thu, 16 Feb 2023 13:43:09 -0500
X-MC-Unique: ieZpbSi1MA239eJyDssmaA-1
Received: by mail-wm1-f69.google.com with SMTP id l31-20020a05600c1d1f00b003deab30bb8bso1172043wms.2
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nzs3CwprvCrdgRRmVwPIesvKSOpY6LpE+5oegZVwNwo=;
        b=fA+CbgUPMJZLgESKBDGmJNAEedVT19TdZowZtlp9damqQ/bsCHrvhgu7x9sBEnFd1J
         6RpRIMehi+l1WJGmfGswXncPWSWStHKlTEVJLAgeO8SYWMz8UYdBo7XEfpzLsLWPYZ7l
         Eg6+y1mMnk4uqiIZOaNlEWeZ1DAMZPyUR0axGeiJXH0F7kESgeBPX9epfEdxGNWrEyBh
         BcPvWyMn+NR6UqhHCIPP966s5sMEn3PnZ3dpa87XfXPPa2aZgU7mCHgLnbYEHFmvA0YG
         upZRaQvh0zkn1ohzskGrq4P61AWYyz/vATIZgPEjRWLVgbCgumL6Xi4JOGoO8AwMA2sr
         7/jg==
X-Gm-Message-State: AO0yUKXIKgLKpOb55k3tbSC6fE4Vfsl24I4eWCi2RDuxCAMRB6lpcwV1
        zfYpMhePrraFJ0N4B4k4XcB6H8aUROS+c9Lb15DQ7y5CII62FQUZ70sM1JkeIvZWHVyOs42v8B0
        Dq0YAJfe1Bo6g
X-Received: by 2002:a05:600c:1da3:b0:3df:e57d:f4ba with SMTP id p35-20020a05600c1da300b003dfe57df4bamr6024969wms.7.1676572988260;
        Thu, 16 Feb 2023 10:43:08 -0800 (PST)
X-Google-Smtp-Source: AK7set9i9qeHYjmEZ2is1wvLp7yVMnqkgqsHnyVkFPX/lN9nzPn01iuqCeMIhZ0a5u7WriXwtqT3ZQ==
X-Received: by 2002:a05:600c:1da3:b0:3df:e57d:f4ba with SMTP id p35-20020a05600c1da300b003dfe57df4bamr6024957wms.7.1676572987939;
        Thu, 16 Feb 2023 10:43:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id h8-20020a1ccc08000000b003e1202744f2sm6193608wmb.31.2023.02.16.10.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 10:43:07 -0800 (PST)
Message-ID: <c34b8753-d70b-3d0f-f3b1-c89264642291@redhat.com>
Date:   Thu, 16 Feb 2023 19:43:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>
Cc:     Sagi Shahar <sagis@google.com>, kvm@vger.kernel.org,
        Erdem Aktas <erdemaktas@google.com>,
        Ryan Afranji <afranji@google.com>,
        Michael Sterritt <sterritt@google.com>
References: <CAAhR5DE4rYey42thw_4toKx0tEn5ZY3mRq8AJT=YQqemqvt7pw@mail.gmail.com>
 <CAMkAt6pTNZ2_+0RNZcPFHhG-9o2q0ew0Wgd=m_T6KfLSYJyB4g@mail.gmail.com>
 <Y+5zaeJxKr6hzp4w@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Issue with "KVM: SEV: Add support for SEV intra host migration"
In-Reply-To: <Y+5zaeJxKr6hzp4w@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/16/23 19:18, Sean Christopherson wrote:
> On Thu, Feb 16, 2023, Peter Gonda wrote:
>>> From what we are seeing, there are at least 2 IOCTLs that VMM is
>>> issuing on the source VM after the migration is completed. The first
>>> one is KVM_IOEVENTFD for unwiring an eventfd used for the NVMe admin
>>> queue during the NVMe device unplug sequence. The second IOCTL is
>>> KVM_SET_USER_MEMORY_REGION for removing the memslots during VM
>>> destruction. Failing any of these IOCTLs will cause the migration to
>>> fail.
> 
> Does the VMM _need_ to cleanly teardown the source VM?  If so, why?

I can see why it is much easier on userspace to use the regular clean up 
sequence.  However, I'm not sure about allowing a specific subset of 
ioctls, and in fact KVM_SET_USER_MEMORY_REGION is one of those that are 
more "scary" because it interacts with page table management.  This is 
not a big problem for SEV, but it's worse for TDX.

>>> 1) If we want to keep the vm_dead logic as is, this means changing to
>>> VMM code in some pretty hacky way. We will need to distinguish between
>>> regular VM shutdown to VM shutdown after migration. We will also need
>>> to make absolutely sure that we don't leave any dangling data in the
>>> kernel by skipping some of the cleanup stages.

If I were doing it in the VMM, I would wrap the ioctls with something like

    ret = ioctl(vm->fd, cmd, arg);
    if (ret == -1 && errno == EIO && vm->is_migrated ) {
        switch (cmd) {
        case KVM_IOEVENTFD:
            /* safe because MMIO cannot be issued by the VM. */
        case KVM_SET_USER_MEMORY_REGION:
            /* safe because memory cannot be accessed by the VM. */
        ...
            return 0;
        }
    }

which is yucky (the list of ioctls is hard to maintain) but at least 
it's self-contained and documented.

>>> 2) If we want to remove the vm_dead logic we can simply not mark the
>>> vm as dead after migration. It looks like it will just work but might
>>> create special cases where IOCTLs can be called on a TD which isn't
>>> valid anymore. From what I can tell, some of these code paths are
>>> already  protected by a check if hkid is assigned so it might not be a
>>> big issue. Not sure how this will work for SEV but I'm guessing
>>> there's a similar mechanism there as well.
>>>
>>> 3) We can also go half way and only block certain memory encryption
>>> related IOCTLs if the VM got migrated. This will likely require more
>>> changes when we try to push this ustream since it will require adding
>>> a new field for vm_mem_enc_dead (or something similar) in addition to
>>> the current vm_bugged and vm_dead.
>>
>> I agree option 2 or 3 seem preferable. Option two sounds good to me, I
>> am not sure why we needed to disable all IOCLTs on the source VM after
>> the migration. I was just taking feedback on the review.
> 
> I don't like #2.  For all intents and purposes, the source VM _is_ dead, or at
> least zombified.  It _was_ an SEV guest, but after migration it's no longer an
> SEV guest, e.g. doesn't have a dedicated ASID, etc.  But the CPUID state and a
> pile of register state won't be coherent, especially on SEV-ES where KVM doesn't
> have visibility into guest state.

I agree that (2) is the worst option.

>> We have the ASID similar to the HKID in SEV. I don't think the code
>> paths are already protected like you mention TDX is but that seems
>> like a simple enough fix. Or maybe it's better to introduce a new
>> VM_MOVED like VM_BUGGED and VM_DEAD which allows most IOCTLs but just
>> disables running vCPUs.
> 
> I kinda like the idea of a VM_MOVED flag, but I'm a bit leary of it from a
> a maintenance and ABI perspective.  Definining and documenting what ioctls()
> are/aren't allowed would get rather messy.  The beauty of VM_DEAD is that it's
> all or nothing.

Yes, it's a bit of a cop out but _in practice_ VM_MOVED is going to be a 
whack-a-mole job where each bug can have security consequences.

> As above, I'm concerned with KVM's safety, not the guest's.

+1

> Depending on why the source VM needs to be cleaned up, one thought would be add
> a dedicated ioctl(), e.g. KVM_DISMANTLE_VM, and make that the _only_ ioctl() that's
> allowed to operate on a dead VM.  The ioctl() would be defined as a best-effort
> mechanism to teardown/free internal state, e.g. destroy KVM_PIO_BUS, KVM_MMIO_BUS,
> and memslots, zap all SPTEs, etc...

If we have to write the code we might as well do it directly at 
context-move time, couldn't we?  I like the idea of minimizing the 
memory cost of the zombie VM.

Paolo

