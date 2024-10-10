Return-Path: <kvm+bounces-28422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC1F998684
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA0712833D3
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 12:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBD31C6F6E;
	Thu, 10 Oct 2024 12:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D733iDXb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D210A1C6885
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 12:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728564383; cv=none; b=OiVHWGNGUBZ8/sUp9ty9cXn8EXs6l1Fevrs2WGdvpzBMAKEsk9tQiw+aYQws9MQB68Kd5MNKK6KKilKpboyUgYVw8oeVC4WhykhnYE8WTSNyuDxlvP2BnkhUZq99B4oM9UA46F7OkaVBbPX/t+zrJatG36gNuY/ilj39F6u5kq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728564383; c=relaxed/simple;
	bh=gB/Bxcsggt/d/+PHWcnc10XGSm/R2PwjjQ6YpCvpjUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dVnzorrZ0G58oYGnXiiIacD+SXogZOw5yTlrC6Q/1HiOYGh9xlmOCck5aZ8AcV5wRnjjzp3HSLP/oASvzWYoA1lob2g7eYPdjrdEfLRgymU6LydLodr7o/9Q64bpNJ36QtF9tZbH2jL5+/XKfv/H4zJT+6tZ7sS40KbGfwJ+iqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D733iDXb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728564380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Pp428+o6AOVfMNyGufRXb57C/mbuEZh30bGw/01Jeok=;
	b=D733iDXb61lBPcryXrjYFzLuduQ936BSiMcHHgXJOD7s1mvUSVafOSNuhU/dHHtJkNYVY4
	EVmfhFXkJ/lQLEShWgZXPk3o9g9gmuLsAU1XtEEBt9xoehHAHDiMgB1/jjW8Mj1VFjR3jG
	aGBFzZaGHGEe6PT0iq2R5hRwh7hrlqY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-ciN_LvbiOWC-BT_Rnl8uDg-1; Thu, 10 Oct 2024 08:46:19 -0400
X-MC-Unique: ciN_LvbiOWC-BT_Rnl8uDg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a994dfbb8b9so69593866b.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 05:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728564378; x=1729169178;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pp428+o6AOVfMNyGufRXb57C/mbuEZh30bGw/01Jeok=;
        b=SN6IgTf1nyEKo+CiF7poRmUrciT8glsKaUMmtA5TBbQhgD3g9TkCWZN6O+YI000l/u
         gi652ttk/1upEG8St+/AxTVMqYW7+pzvY0/lQ+7oYJkNtKALjfkkW5bogIc/O1OK3lt2
         LWq7jS8rtm5gNVJ7pH/36aemrXZFcmXvnksgLz5diMqXdtr17KFIVahsVNT4PFsJM5A3
         SzjUnSU6N2NQMcOC/SRBuPUf16UtbiuyWGUcevl2c1sYr5DvlcfFZrpZ0wS/n0W9WRVG
         b+uL+mehn3liOI6zvbHG7UXx4ahP1c7ZUAKasDYX/5WwWhumlIbIQmow81vNnuYd5iDS
         60Ew==
X-Gm-Message-State: AOJu0YzdTdSeJIsfRDYb1vLaoSW1R5v8cnnN8iQBBKC4mcI0jPPvxgRi
	/v498IhDyhyeI48CJ3O3EKwLuDiYHGZDROR1SFSTN9yZDU2PGqgMtRZwrfqTZweSj7Wr/nXAjuG
	vxxGBvujJRKsqoefL8Bpv6ZQOmMPKelT3ys3kIN/sXqS5YyKMkA==
X-Received: by 2002:a17:907:940d:b0:a99:4eac:bb98 with SMTP id a640c23a62f3a-a998d31c068mr569316566b.51.1728564378457;
        Thu, 10 Oct 2024 05:46:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZQJ0C4cv3iGhR09yajySYTcDf+yHyYkfG33sSJXo+9rrIeBRewHZY6fgvqwKjME2LxydoDg==
X-Received: by 2002:a17:907:940d:b0:a99:4eac:bb98 with SMTP id a640c23a62f3a-a998d31c068mr569314266b.51.1728564378020;
        Thu, 10 Oct 2024 05:46:18 -0700 (PDT)
Received: from [192.168.10.81] ([151.81.124.37])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a99a7ec4cd0sm84679966b.1.2024.10.10.05.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 05:46:17 -0700 (PDT)
Message-ID: <1baf4159-ce53-4a75-99bf-adf4b89dd07b@redhat.com>
Date: Thu, 10 Oct 2024 14:46:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] Revert "KVM: Fix vcpu_array[0] races"
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>,
 Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
References: <20241009150455.1057573-1-seanjc@google.com>
 <20241009150455.1057573-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241009150455.1057573-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 17:04, Sean Christopherson wrote:
> Now that KVM loads from vcpu_array if and only if the target index is
> valid with respect to online_vcpus, i.e. now that it is safe to erase a
> not-fully-onlined vCPU entry, revert to storing into vcpu_array before
> success is guaranteed.
> 
> If xa_store() fails, which _should_ be impossible, then putting the vCPU's
> reference to 'struct kvm' results in a refcounting bug as the vCPU fd has
> been installed and owns the vCPU's reference.
> 
> This was found by inspection, but forcing the xa_store() to fail
> confirms the problem:
> 
>   | Unable to handle kernel paging request at virtual address ffff800080ecd960
>   | Call trace:
>   |  _raw_spin_lock_irq+0x2c/0x70
>   |  kvm_irqfd_release+0x24/0xa0
>   |  kvm_vm_release+0x1c/0x38
>   |  __fput+0x88/0x2ec
>   |  ____fput+0x10/0x1c
>   |  task_work_run+0xb0/0xd4
>   |  do_exit+0x210/0x854
>   |  do_group_exit+0x70/0x98
>   |  get_signal+0x6b0/0x73c
>   |  do_signal+0xa4/0x11e8
>   |  do_notify_resume+0x60/0x12c
>   |  el0_svc+0x64/0x68
>   |  el0t_64_sync_handler+0x84/0xfc
>   |  el0t_64_sync+0x190/0x194
>   | Code: b9000909 d503201f 2a1f03e1 52800028 (88e17c08)
> 
> Practically speaking, this is a non-issue as xa_store() can't fail, absent
> a nasty kernel bug.  But the code is visually jarring and technically
> broken.
> 
> This reverts commit afb2acb2e3a32e4d56f7fbd819769b98ed1b7520.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Michal Luczaj <mhal@rbox.co>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Reported-by: Will Deacon <will@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 14 +++++---------
>   1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fca9f74e9544..f081839521ef 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4283,7 +4283,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>   	}
>   
>   	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
> -	r = xa_reserve(&kvm->vcpu_array, vcpu->vcpu_idx, GFP_KERNEL_ACCOUNT);
> +	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
> +	BUG_ON(r == -EBUSY);
>   	if (r)
>   		goto unlock_vcpu_destroy;
>   
> @@ -4298,12 +4299,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>   	kvm_get_kvm(kvm);
>   	r = create_vcpu_fd(vcpu);
>   	if (r < 0)
> -		goto kvm_put_xa_release;
> -
> -	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> -		r = -EINVAL;
> -		goto kvm_put_xa_release;
> -	}
> +		goto kvm_put_xa_erase;

I also find it a bit jarring though that we have to undo the insertion. 
This is a chicken-and-egg situation where you are pick one operation B 
that will have to undo operation A if it fails.  But what xa_store is 
doing, is breaking this deadlock.

The code is a bit longer, sure, but I don't see the point in 
complicating the vcpu_array invariants and letting an entry disappear.

The rest of the series is still good, of course.

Paolo

>   	/*
>   	 * Pairs with smp_rmb() in kvm_get_vcpu.  Store the vcpu
> @@ -4318,10 +4314,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>   	kvm_create_vcpu_debugfs(vcpu);
>   	return r;
>   
> -kvm_put_xa_release:
> +kvm_put_xa_erase:
>   	mutex_unlock(&vcpu->mutex);
>   	kvm_put_kvm_no_destroy(kvm);
> -	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
> +	xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);
>   unlock_vcpu_destroy:
>   	mutex_unlock(&kvm->lock);
>   	kvm_dirty_ring_free(&vcpu->dirty_ring);


