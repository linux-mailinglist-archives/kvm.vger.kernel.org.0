Return-Path: <kvm+bounces-31236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8F799C1888
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 09:56:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1858C1C20B7D
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 08:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3492A1E048A;
	Fri,  8 Nov 2024 08:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hA/Kr6Ej"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0891DFE3F
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 08:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056162; cv=none; b=ZkgjistAL0IepHWMlukWz8VNopYfvo71378uCrAU7b1kmFx6aQOOEOz+fApW4/TbnCFQmeD0aPoSBa9mTKTmWpVHWfiE+4UMRAbz3LsPqQMwIg+39ZNjaEJQP7+gZDmrozsgKy8HuhEnPHyS9CLQEBEGyJn1JCgQTTseA1f2grc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056162; c=relaxed/simple;
	bh=RvjEnSoS2rKmQa4Vl1T9Yde1sARG3bd+J9ylnj5sE6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ecoNl67RwBpIf0vKXbWmfKFXNWaF6oo8dWubELTmiCpmucTupAXuz+PxoN7aMhNm5rL1iNmLKWm0mIc/3FV+CGPXsF6YNU8lXfifW3tbpQcHmiCSyu2M4h2JSoR94vExSXtQgksiOvRZl/VOWzEzuz2Y63WSJh542iHZNTc/HZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hA/Kr6Ej; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731056159;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p7+n19lrgiAJuEoskSWGxrEplWe5QxXbROOP/SEkcpY=;
	b=hA/Kr6EjXpnhdRJL6j2yOnUerA8+yZRDw4Dwu/L2xOwo0m4p1Vg6elp9fdOS0vZO+B+Ki1
	w9Sq/CfNzMDLu2ijAAvc+OPmRkXU8bKuhZCyRulReiuhRG0cuP4+2yony8SqOX9SQeAIwa
	WGmieFkUc/7fiAXxK0rMyeTpLufjJLs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-Gl9tBQY_MYCDxVzvdqcyyg-1; Fri, 08 Nov 2024 03:55:57 -0500
X-MC-Unique: Gl9tBQY_MYCDxVzvdqcyyg-1
X-Mimecast-MFC-AGG-ID: Gl9tBQY_MYCDxVzvdqcyyg
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7b14538be1eso234002485a.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 00:55:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731056156; x=1731660956;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p7+n19lrgiAJuEoskSWGxrEplWe5QxXbROOP/SEkcpY=;
        b=i5digZxo8rILRr/1ej5n/ChHRnn0DHob2iSgQrIWFfGgJhAV9jH/TT6m8DXr0PmnMz
         suNfnbMffVmL1OqrtrUICkRqmXjW4R0ZfqfANb+XC6WhQPslBe3cdpSayWbOVcTodaQF
         qLtp4xX+KyFsfSENrOxysc+sPWSIMZ+vp/2o4zZBDI2TX9ASziv0nFGpv7Oa0vqKFyj3
         bpCc2JvLFsJMxHGn8lwrVqVTo7K+1KPKpkbFHOKqUmFeFU6TtX9TdTG/NYolejFgGv0e
         2GFBay2uZKiLSTxDCo6AEvNxtNOXHHG5mGHPzW9lUfvHmIGuZmirHAV+bC0A8aQl81sP
         gs3Q==
X-Forwarded-Encrypted: i=1; AJvYcCW7j58XggVMWaMlGIYUAbLAuU1F0nZkMz4/pLW+M10MfD+DfrixBPbxt7gfzBRlrmqvopM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUKvW4C7iEu52DTkuVp/loSLgbFh5AhvH9l3j4e/yQJ+Y49GOA
	N6qz5DWUT0OMPHgFjo3VqUd3nUzfqKJyJFpk8ehPLACjHhIwgz3TaGbrMScS8gnYfzYZkS6FLf1
	LegB/LsBPfX6myAF/RcG8+0TGsm6k7H5kTH0ctVtVsHy9mw0s/g==
X-Received: by 2002:a05:6214:588e:b0:6d1:7854:ab49 with SMTP id 6a1803df08f44-6d39e120d01mr23301246d6.11.1731056156712;
        Fri, 08 Nov 2024 00:55:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwRj/6Dr08Zq/2CalNmB2mzI7xIogqbu3h+dTo6AiUl7OKWmmmDoPSjhOiOzCp+l6bFoIZFg==
X-Received: by 2002:a05:6214:588e:b0:6d1:7854:ab49 with SMTP id 6a1803df08f44-6d39e120d01mr23301066d6.11.1731056156395;
        Fri, 08 Nov 2024 00:55:56 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d39643b982sm17009106d6.85.2024.11.08.00.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 00:55:55 -0800 (PST)
Message-ID: <f241da92-6888-4171-9604-d72f78eb9829@redhat.com>
Date: Fri, 8 Nov 2024 09:55:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 2/3] KVM: selftests: Introduce kvm_vm_dead_free
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
Cc: eric.auger.pro@gmail.com, broonie@kernel.org, maz@kernel.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, joey.gouly@arm.com,
 shuah@kernel.org, pbonzini@redhat.com
References: <20241107094000.70705-1-eric.auger@redhat.com>
 <20241107094000.70705-3-eric.auger@redhat.com> <Zyz_KGtoXt0gnMM8@google.com>
 <Zy0QFhFsICeNt8kF@linux.dev> <Zy0bcM0m-N18gAZz@google.com>
 <Zy0fPgwymCdBwLd_@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Zy0fPgwymCdBwLd_@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sean, Oliver,

On 11/7/24 21:12, Oliver Upton wrote:
> On Thu, Nov 07, 2024 at 11:56:32AM -0800, Sean Christopherson wrote:
>> On Thu, Nov 07, 2024, Oliver Upton wrote:
>>> On Thu, Nov 07, 2024 at 09:55:52AM -0800, Sean Christopherson wrote:
>>>> On Thu, Nov 07, 2024, Eric Auger wrote:
>>>>> In case a KVM_REQ_VM_DEAD request was sent to a VM, subsequent
>>>>> KVM ioctls will fail and cause test failure. This now happens
>>>>> with an aarch64 vgic test where the kvm_vm_free() fails. Let's
>>>>> add a new kvm_vm_dead_free() helper that does all the deallocation
>>>>> besides the KVM_SET_USER_MEMORY_REGION2 ioctl.
>>>> Please no.  I don't want to bleed the kvm->vm_dead behavior all over selftests.
>>>> The hack in __TEST_ASSERT_VM_VCPU_IOCTL() is there purely to provide users with
>>>> a more helpful error message, it is most definitely not intended to be an "official"
>>>> way to detect and react to the VM being dead.
>>>>
>>>> IMO, tests that intentionally result in a dead VM should assert that subsequent
>>>> VM/vCPU ioctls return -EIO, and that's all.  Attempting to gracefully free
>>>> resources adds complexity and pollutes the core selftests APIs, with very little
>>>> benefit.
>>> Encouraging tests to explicitly leak resources to fudge around assertions
>>> in the selftests library seems off to me.
>> I don't disagree, but I really, really don't want to add vm_dead().
> It'd still be valuable to test that the VM is properly dead and
> subsequent ioctls also return EIO, but I understand the hesitation.
>
>>> IMO, the better approach would be to provide a helper that gives the
>>> impression of freeing the VM but implicitly leaks it, paired with some
>>> reasoning for it.
>> Actually, duh.  There's no need to manually delete KVM memslots for *any* VM,
>> dead or alive.  Just skip that unconditionally when freeing the VM, and then the
>> vGIC test just needs to assert on -EIO instead -ENXIO/-EBUSY.
> Yeah, that'd tighten up the assertions a bit more to the exact ioctl
> where we expect the VM to go sideways.
>
>> ---
>> From: Sean Christopherson <seanjc@google.com>
>> Date: Thu, 7 Nov 2024 11:39:59 -0800
>> Subject: [PATCH] KVM: selftests: Don't bother deleting memslots in KVM when
>>  freeing VMs
>>
>> When freeing a VM, don't call into KVM to manually remove each memslot,
>> simply cleanup and free any userspace assets associated with the memory
>> region.  KVM is ultimately responsible for ensuring kernel resources are
>> freed when the VM is destroyed, deleting memslots one-by-one is
>> unnecessarily slow, and unless a test is already leaking the VM fd, the
>> VM will be destroyed when kvm_vm_release() is called.
>>
>> Not deleting KVM's memslot also allows cleaning up dead VMs without having
>> to care whether or not the to-be-freed VM is dead or alive.
> Can you add a comment to kvm_vm_free() about why we want to avoid ioctls
> in that helper? It'd help discourage this situation from happening again
> in the future in the unlikely case someone wants to park an ioctl there.
>
>> Reported-by: Eric Auger <eric.auger@redhat.com>
>> Reported-by: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> I'm assuming you want to take this, happy to grab it otherwise.
>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
>
>>>> Marking a VM dead should be a _very_ rare event; it's not something that I think
>>>> we should encourage, i.e. we shouldn't make it easier to deal with.  Ideally,
>>>> use of kvm_vm_dead() should be limited to things like sev_vm_move_enc_context_from(),
>>>> where KVM needs to prever accessing the source VM to protect the host.  IMO, the
>>>> vGIC case and x86's enter_smm() are hacks.  E.g. I don't see any reason why the
>>>> enter_smm() case can't synthesize a triple fault.
>>> The VGIC case is at least better than the alternative of slapping
>>> bandaids all over the shop to cope with a half-baked VM and ensure we
>>> tear it down correctly. Userspace is far up shit creek at the point the
>>> VM is marked as dead, so I don't see any value in hobbling along
>>> afterwards.
>> Again, I don't disagree, but I don't want to normalize shooting the VM on errors.
> Definitely not. It is very much a break-glass situation where this is
> even somewhat OK.
>


