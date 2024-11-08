Return-Path: <kvm+bounces-31238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3925B9C189F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 10:00:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BEEA1C20B89
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 09:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC311DED55;
	Fri,  8 Nov 2024 09:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cAZd6qAC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E17E1E0DB8
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056416; cv=none; b=bWE/nftXVTTcp9EYIPBqFW7L6pP3XzXVieU1WILF/edq6e3PPqc/Z+XWp1P6NgG1Io0HAtZ1vsSSykG1IKoV7uPtRAZrDSJzeWQ8MkWwq5ztVzhVjiCEHma4qcEIVVOwkKSQVrprlB5GRYbDiAYx9jtaqYRvducSC7//Cr9tr7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056416; c=relaxed/simple;
	bh=DiATwo03/8GtzbkcrrG2dwFva/jS1oeBl8PrDGHVMdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MFHXV5YOAgea3bJHIs0Blv9to2R3QYCEFhyTD6fTdqFcudvC4SN+wQm7m25QQdLoUWCQAzbrrbzwtKQDWkIJYnlJRTCccJkR3u6f3Vh0u8qTb/8B2cdNBZBgwLuQZztoVqcGguIHzlMxr16hiSdmbJbDwsmak47Cz0vmh0s5jO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cAZd6qAC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731056413;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZN3IWgvO5K2UzU+TxYiLQK0pb6ZI5Cu0LnpdZy+E0as=;
	b=cAZd6qACojq8z2mRZWZpbGwMFvxKV3zQV8ARl8qDzGxh68ooRTm+NTvecgchSA2v0OSd7/
	sFMsUb5iMXjqwW/WAanyme42ipVzg0dLcenA4ZvnOK7/DxQE4Y8Jg8Uq5rulV1+f76UhWL
	aGjRpk/yv6yWT45TJZ+2SuaM78acvMU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-pRuyNP4_MOaFsX9B8FJZeA-1; Fri, 08 Nov 2024 04:00:12 -0500
X-MC-Unique: pRuyNP4_MOaFsX9B8FJZeA-1
X-Mimecast-MFC-AGG-ID: pRuyNP4_MOaFsX9B8FJZeA
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7b31ccf23ebso200918985a.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 01:00:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731056412; x=1731661212;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZN3IWgvO5K2UzU+TxYiLQK0pb6ZI5Cu0LnpdZy+E0as=;
        b=K3zm43wvcM4nFDMpXGtvBbIRMiPQVzVf8j03rOj4KCzi7Fh0asIWSsgXb9DueqaAuF
         uhgs7RNU1p3ie8e4ibgga4ZWA2YcQ6MmVNc+3Cut7EW6KMt1tQPrp0vHx1q6yFi/DDH0
         GDuv5znKR+01hkd5l9n08VPfP/3g+OfkYIcwVYNixQ4rmZp2wyuKbUsSTD1qfBghs0TB
         ZptzXC5GRw2KAPkQnOvpWaBlQ3jPEupGfKe8/8sRmy3/9oihfyo4hiogh44j3TViTLE6
         34332xuOnFPtk7w0PtfswtOK/gNXej49r4GkhucdL9TD8pIyWN5ExFF1OOwbGaIAKiFa
         H8pg==
X-Forwarded-Encrypted: i=1; AJvYcCV6Ferm7PZb6Ou7FNLokeW48YuuO0sh7mPwDNu0IpuaUU68sOlrYjksRZ47zs+C3js2znE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvDqS+iWcZuBcbA1ng3mwG06b2yZ1ad1VwgG1fRte/6ssJLSrt
	DBqyPwWDGoVLPEjwHhUrc2aF0hLlocyrwTiSbfp8foFsGa07E3sYdal03+gWs9nMnkXTWZFReOG
	8Y2qaU0wuw9VSV4w9zpD8sV/vUONAF9fqQBigPKE/L/lfjGetSg==
X-Received: by 2002:a05:620a:9342:b0:7b1:56f0:e06f with SMTP id af79cd13be357-7b331e8cc94mr215955485a.15.1731056411869;
        Fri, 08 Nov 2024 01:00:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGkxg/sJsdiIHyCj/wQKR1CoiDq38NePwxcDPuV2+H6LqXetQIZJsRE5c1XC8s2tutl3zRGAQ==
X-Received: by 2002:a05:620a:9342:b0:7b1:56f0:e06f with SMTP id af79cd13be357-7b331e8cc94mr215951285a.15.1731056411365;
        Fri, 08 Nov 2024 01:00:11 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b32ac2dd1fsm142265085a.15.2024.11.08.01.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 01:00:10 -0800 (PST)
Message-ID: <77cc68a6-2d7a-4ef3-bf4d-93fc9987f466@redhat.com>
Date: Fri, 8 Nov 2024 10:00:06 +0100
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

Hi Oliver,

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

Currently the vgic_test does not check that the VM is dead, it just
checks the first expected errno according to the uapi documentation.
Besides AFAIK this latter has not been updated according to the new VM
dead implementation.

Eric
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


