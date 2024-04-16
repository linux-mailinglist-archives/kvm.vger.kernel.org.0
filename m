Return-Path: <kvm+bounces-14800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE958A71CA
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB44D1C21049
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73C52EAF9;
	Tue, 16 Apr 2024 16:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1RbIIpUX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA41F12B156
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 16:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713286758; cv=none; b=RScNIDK2wtYmuFHy6vCOBJwJNTrDsjGaQY5p29JzAuDSa4pprYhyVkF7zCqvwpYAtDPx+volnBLPDWuO3O0ton8Ka3RQZlm96StWdoAw3g1MWVfkUkxyBC1ipGZZG3ng5RsT04vguafF3klfoSRzyczSj7OgE9qU1R9Fr4SSKFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713286758; c=relaxed/simple;
	bh=lAG7HK9LS3RguNksITKHpnbLyLRmYW0EtfDyd2Pjk6s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ozIpUbQrIkndxjXLn5u65si9uZwrb3XdnxerFXEuAF6M1oRu0NVpRCoW7DT8G8/+euDMKGFPoPvHyj+uES/ocNm3+VHN5IckoAmixZ3iEXk1jq+tLY39FnCfUqHVeDQHsiD7kw3CXrakXihMKNtKnFeZ5wsnU8NIfWviTyoSLQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1RbIIpUX; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so8447399276.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713286756; x=1713891556; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pch99LG5Z4+0qcPmdsQsFZx2/c919CFue2a0/cLk2Ls=;
        b=1RbIIpUX83aOQU6H5j3s78z0adOgis1EETzgr9T1LYU1+SA4NofWw9PYA3MZqmwl3H
         FHdxkuV7MyDnsPoN9LanzfocKczOapVCPcDCayzw1I8JQpObhyjCQfJFTkabsdjnn6WZ
         dPfq9So3/Xifl0h4YfI7iOdiSmU4mKMkSXLvIVwJK3LOFlnNhecTxDdF4inzyhmR8nHX
         rgl7KMOKbRo0uCvdnMv1Zddtetm+uznOrtox34y1WScVTQcOdmWIqo7LqLUmfH3esIgE
         V2D6jiGUOELj8+/fWvJMeVfci2FowYI5iRExvWv1QaYpQVpaB5iUD9zQ/7irXd+3gryw
         7y/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713286756; x=1713891556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pch99LG5Z4+0qcPmdsQsFZx2/c919CFue2a0/cLk2Ls=;
        b=JyilkMqGYhCvTmCYrJ297L+d4e2RQW5ESCEDHuDRB3KlZSk4V9I//0OekaKdi+sr1G
         ajIjJGsBfIMA6WFgE78Ulaw3uJnhR8PfVlKBBvfWQp2+jjk5aLCOBMYxD16sRqgM5cdZ
         EUHdYYqMjb4f8RSgzyBUQEe/BQpCsQtkDT/HENDaZtAAkAGwQpG0S+brs/0rrSU/DNCn
         SSo/srHtmyXbFQYCYS5efuV4gRxBe3Z1mQanhnbV5KacrCCid/HvKONj/5UjaRqifJ6V
         H4iwB2AzOS56TNVXLq0mdwkbf++q79RWa6OkCWj0ZatpF7p1PaGikHzS7J//ciOMOpp4
         VhsA==
X-Forwarded-Encrypted: i=1; AJvYcCXaAhj8PhxJm29xMGok9QFQ9aX40KcvGmBWKlHc6vPfW14qF0eol1Il/a15tc9hm3EJLh3W4CJLicb2U4sub7efwDAf
X-Gm-Message-State: AOJu0Yx3FAu+CFYEtJKpWumxYPqvRc7b4MFiWbCe2FFRZjPZWlcfT+kz
	utc5n2MuCDy8cEJOXOl5dLlYw7JJ3s3fkM9MpqGFrJaDCie8/7vabFO2wJGeeGa9CgmBM8VKtib
	WtA==
X-Google-Smtp-Source: AGHT+IGgV8tD+/WlgBqDEX77Q+L+nZ8vVpSHTWkkbOK3/cgYFe5OI9cPw3KH7NrasTqLOd/oM15ysxEw8iw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1896:b0:ddd:7581:1237 with SMTP id
 cj22-20020a056902189600b00ddd75811237mr4146341ybb.3.1713286755633; Tue, 16
 Apr 2024 09:59:15 -0700 (PDT)
Date: Tue, 16 Apr 2024 09:59:14 -0700
In-Reply-To: <20240221195125.102479-2-shivam.kumar1@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com> <20240221195125.102479-2-shivam.kumar1@nutanix.com>
Message-ID: <Zh6uYhMTAHwTjJUu@google.com>
Subject: Re: [PATCH v10 1/3] KVM: Implement dirty quota-based throttling of vcpus
From: Sean Christopherson <seanjc@google.com>
To: Shivam Kumar <shivam.kumar1@nutanix.com>
Cc: maz@kernel.org, pbonzini@redhat.com, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, aravind.retnakaran@nutanix.com, 
	carl.waldspurger@nutanix.com, david.vrabel@nutanix.com, david@redhat.com, 
	will@kernel.org, kvm@vger.kernel.org, 
	Shaju Abraham <shaju.abraham@nutanix.com>, Manish Mishra <manish.mishra@nutanix.com>, 
	Anurag Madnawat <anurag.madnawat@nutanix.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 21, 2024, Shivam Kumar wrote:
> @@ -1291,6 +1293,13 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
>  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
>  bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
>  unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes);
> +#else
> +static inline void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes)
> +{
> +}
> +#endif
>  void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
>  void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c3308536482b..217f19100003 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -210,6 +210,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_NOTIFY           37
>  #define KVM_EXIT_LOONGARCH_IOCSR  38
>  #define KVM_EXIT_MEMORY_FAULT     39
> +#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 40
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -491,6 +492,12 @@ struct kvm_run {
>  		struct kvm_sync_regs regs;
>  		char padding[SYNC_REGS_SIZE_BYTES];
>  	} s;
> +	/*
> +	 * Number of bytes the vCPU is allowed to dirty if KVM_CAP_DIRTY_QUOTA is
> +	 * enabled. KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if this quota
> +	 * is exhausted, i.e. dirty_quota_bytes <= 0.
> +	 */
> +	long dirty_quota_bytes;

This needs to be a u64 so that the size is consistent for 32-bit and 64-bit
userspace vs. kernel.

