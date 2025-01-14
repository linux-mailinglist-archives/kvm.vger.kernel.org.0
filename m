Return-Path: <kvm+bounces-35436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 233CDA10FA5
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 19:16:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 468043A12D0
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 18:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 763F320CCD9;
	Tue, 14 Jan 2025 18:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aUqQ3SE+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A6B1FC7DC
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 18:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736878236; cv=none; b=CWLYWIp+8UgzlXIt+8f5BaHJJhiiWehbTOk1DdUYgvOgB6N56H0LIxbiTG+CvYHhIdZ42Lcdhl7PgLQBkuhkIYPH+y/+lRXaOsP9I51h38mJpU/SegtuWgVbVBF5BRBWkA8COHz10anFS4hhBHXnVyKTTs/v3QQGBLFtGKr6hCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736878236; c=relaxed/simple;
	bh=rm5bseuOfkg7Nv5j9XkkBqPDRAglt8yWnlDl3ZJmXpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NandDRVoAaIMfAXIP44ZI8b+vJEfWWKMEV588oWeWhU3MgH0OMOuP77Xms8OVHTW02XkEeItgqcsvesWGy8EbcIYe8sttePDY4I1Qa78nN7ttRul/trTIrItpzHmzGYzbzPqPlTaPLibUN3hCSLpKbk4dwJa61yQ6EdG3LgjJxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aUqQ3SE+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736878234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HTMflfcSEv8r63eX3hGqRB00Pjloo/uHEdFnr9bFEGI=;
	b=aUqQ3SE+H+kgq0YmH1JRG70nldTSRRFGR5BS+vxCSxyBPLy1LM+/omFVlaQ1h/8lCy6YU+
	CkAr3hRJTyzsXmVKX2jF9+aw6sTvkZJ9RjaGUeZqp+RIoJ3/jDYr3DmBAwx+RVKeOfQ2IS
	SrtO9tKb/E4BlQAq6Rp9uMCLQyONF9E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-LO5iW1BROOOG9yJwypibcQ-1; Tue, 14 Jan 2025 13:10:32 -0500
X-MC-Unique: LO5iW1BROOOG9yJwypibcQ-1
X-Mimecast-MFC-AGG-ID: LO5iW1BROOOG9yJwypibcQ
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38629a685fdso2071235f8f.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 10:10:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736878231; x=1737483031;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HTMflfcSEv8r63eX3hGqRB00Pjloo/uHEdFnr9bFEGI=;
        b=rjeo/VAvYP1aJeKo9cgQX4HgUH2dQDheqrZ+4IML79FUMpA2d0egIg55TCgrI6w6L5
         PRWx2FOYh6brdhUdJ8MYMqG6KNSjGCqBRjkOhlcRoZRlE//atFHnQ7ADyz9NHgoTRdoT
         AATCc4hdMHtXqAjeyH0qHMojIrEhtjryAOh7ANPFPkNwLhONkjhBTZy68oyBoH7Ko3Cd
         NZr63LYqtdIAgOy8z/LS7mC7bSJiPEQgSQN/88adSYSNZkm9iq8PwsikEXJpHT+3AtsJ
         Gh2/ndTpXJzvynshXKnfY4uJk76WuT2OMxHUNCawsv4WzKlNbzFO9HsL0MkxKdEqZUes
         Tr4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWDQsjhdwdbYqSMVc2V7UXTHZML4eyhvvKy2yoZtUhkDEkab8FtN0EyuLlWw0uvmA3HjiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9HJ1pbtPMavdKKRqyyDw3KWCcSOXfyW6FWliHwoi18eOWf2+p
	F49Sj455cIi/glS9bYFSx4McrV2ZRYPgIc7M6glhkl2y6Kosufkmt9BlZolaAbYegNtuIOhCCC2
	XQHe1O4+QCv8ExEwo0xcP7v+DpNVgFwMThZrH2cKtfba/sZ4Wyw==
X-Gm-Gg: ASbGncvqeFEmDnLq7+bWMXzGfBfnq77oHNyC/XjtEBdQRhRwR4MHYmY6SQ331r4OaOG
	cbsmZ7JFroi6bbmDOrPYkqTfEC7JF9S52NJXFxSHaJcJwdsY8KJe6YTC75xItrIBRSxgMizScm8
	l40Q88IpZcMG12Utl85tBrGgcIukarbhB1xXBeqGU1W62jN0z2fmDiHiZTem3AiQII3vMP1dphe
	zYwO8XR6xJRq1FcaUlvFNC8M4JvbNsOMhOkPH82EyYL/yvcgQfcE/7/yBlv
X-Received: by 2002:a05:6000:1f86:b0:38a:9ed4:a015 with SMTP id ffacd0b85a97d-38a9ed4e698mr11777264f8f.44.1736878231359;
        Tue, 14 Jan 2025 10:10:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEj3VdRImUiiEStsKtjAbIc6XqU2DQeu8Cp3QsYK3CXSP4yvsdqGoAQE/WOi2MalWouyYaxmw==
X-Received: by 2002:a05:6000:1f86:b0:38a:9ed4:a015 with SMTP id ffacd0b85a97d-38a9ed4e698mr11777241f8f.44.1736878230901;
        Tue, 14 Jan 2025 10:10:30 -0800 (PST)
Received: from [192.168.10.3] ([176.206.124.70])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38be422191fsm1529482f8f.56.2025.01.14.10.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 10:10:30 -0800 (PST)
Message-ID: <0862979d-cb85-44a8-904b-7318a5be0460@redhat.com>
Date: Tue, 14 Jan 2025 19:10:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
To: Keith Busch <kbusch@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 michael.christie@oracle.com, Tejun Heo <tj@kernel.org>,
 Luca Boccassi <bluca@debian.org>
References: <20241108130737.126567-1-pbonzini@redhat.com>
 <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
 <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
 <Z4Uy1beVh78KoBqN@kbusch-mbp>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z4Uy1beVh78KoBqN@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/25 16:35, Keith Busch wrote:
>> Ok, I found the code and it doesn't exec (e.g.
>> https://github.com/google/crosvm/blob/b339d3d7/src/crosvm/sys/linux/jail_warden.rs#L122),
>> so that's not an option. Well, if I understand correctly from a
>> cursory look at the code, crosvm is creating a jailed child process
>> early, and then spawns further jails through it; so it's just this
>> first process that has to cheat.
>>
>> One possibility on the KVM side is to delay creating the vhost_task
>> until the first KVM_RUN. I don't like it but...
> 
> This option is actually kind of appealing in that we don't need to
> change any application side to filter out kernel tasks, as well as not
> having a new kernel dependency to even report these types of tasks as
> kernel threads.
> 
> I gave it a quick try. I'm not very familiar with the code here, so not
> sure if this is thread safe or not, but it did successfully get crosvm
> booting again.

That looks good to me too.  Would you like to send it with a commit 
message and SoB?

Thanks,

Paolo

> ---
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2401606db2604..422b6b06de4fe 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7415,6 +7415,8 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
>   {
>   	if (nx_hugepage_mitigation_hard_disabled)
>   		return 0;
> +	if (kvm->arch.nx_huge_page_recovery_thread)
> +		return 0;
>   
>   	kvm->arch.nx_huge_page_last = get_jiffies_64();
>   	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c79a8cc57ba42..263363c46626b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11463,6 +11463,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   	struct kvm_run *kvm_run = vcpu->run;
>   	int r;
>   
> +	r = kvm_mmu_post_init_vm(vcpu->kvm);
> +	if (r)
> +		return r;
> +
>   	vcpu_load(vcpu);
>   	kvm_sigset_activate(vcpu);
>   	kvm_run->flags = 0;
> @@ -12740,11 +12744,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	return ret;
>   }
>   
> -int kvm_arch_post_init_vm(struct kvm *kvm)
> -{
> -	return kvm_mmu_post_init_vm(kvm);
> -}
> -
>   static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
>   {
>   	vcpu_load(vcpu);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 401439bb21e3e..a219bd2d8aec8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1596,7 +1596,6 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
>   bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
>   bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
>   bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu);
> -int kvm_arch_post_init_vm(struct kvm *kvm);
>   void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>   void kvm_arch_create_vm_debugfs(struct kvm *kvm);
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index de2c11dae2316..adacc6eaa7d9d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1065,15 +1065,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
>   	return ret;
>   }
>   
> -/*
> - * Called after the VM is otherwise initialized, but just before adding it to
> - * the vm_list.
> - */
> -int __weak kvm_arch_post_init_vm(struct kvm *kvm)
> -{
> -	return 0;
> -}
> -
>   /*
>    * Called just after removing the VM from the vm_list, but before doing any
>    * other destruction.
> @@ -1194,10 +1185,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>   	if (r)
>   		goto out_err_no_debugfs;
>   
> -	r = kvm_arch_post_init_vm(kvm);
> -	if (r)
> -		goto out_err;
> -
>   	mutex_lock(&kvm_lock);
>   	list_add(&kvm->vm_list, &vm_list);
>   	mutex_unlock(&kvm_lock);
> @@ -1207,8 +1194,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>   
>   	return kvm;
>   
> -out_err:
> -	kvm_destroy_vm_debugfs(kvm);
>   out_err_no_debugfs:
>   	kvm_coalesced_mmio_free(kvm);
>   out_no_coalesced_mmio:
> --
> 


