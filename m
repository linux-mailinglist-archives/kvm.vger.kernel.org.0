Return-Path: <kvm+bounces-11227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16FEF874533
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61407287321
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC37441F;
	Thu,  7 Mar 2024 00:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vjykp72+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229B217F0
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 00:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709771939; cv=none; b=R2KjsyUFHojsgh40F9ZL5WEHbRlJNQOwbZRy4Y/7P4xR4aQAv28zVIf2+Rtllhnq/9MeG+hDznFWicyIsAKp69Po+A8O3EhTde/kPUb7ElDzsHGAVxWnY13nfy9XKoE14hj50jI5b/CDLt9/TKXs/SdFucrSR8JPNnCfApoy6ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709771939; c=relaxed/simple;
	bh=CFE532M5hAtX5Za+q/iJbe7f0CvmNnRovlc6d0cc4yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=prQUx6nzWcp90JmIrHSFnd7YgduYN/n04XJOjmxAU/9l+BAd1Gitf+ibIrhwB0dYl2/AMNlmicX3sQhYc1ZiNzR/Q0Cry9xHmbTNEPHgbt0WubBuS4ZY1ihHSba7B5If6NWHfVqBHwPj7CHy7OUxTtnR+rDc+ilB1LBsVNUu3cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vjykp72+; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5c6bd3100fcso232832a12.3
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 16:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709771937; x=1710376737; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=07yicnOc/PjJtyaEa9iiJfb1DnX3D1F7MyH/+iGhC1A=;
        b=vjykp72+xqV0dHaGy5TYekAAgSbYv0YhBAuQ7IhgVyBB88v31QVYmo0+i6KRdQTktP
         bgZ4xJT6gGEYgAhgR9H7+CT0k70J36SRGX+iwRsAnYvvSpW0r73Q3gDRCHuyk4s6hRr7
         609r+vZ6UmAjqm4ZzjIN1QXIegF2b1lbVhRmuC6M2w7x8gPwpRZna3OEogwPLGFhCJsu
         K2IyCVSNUua1jt8o+c37DPcv8Gv8XTYJE99VsHjLQy6/b44CgRf62D+WHOVvQ7YG0tD2
         JhLgvee7Rlri39KaX0RbOt7iGHbxd3mSFKw/6c2P0Aj6TA0KeTD1ZMtOFVlyMcvk/Gup
         JuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709771937; x=1710376737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07yicnOc/PjJtyaEa9iiJfb1DnX3D1F7MyH/+iGhC1A=;
        b=LJAjwLRue3v22dSXxSpDJWxbwa1roPr3o21hRzzO2OwTK15M0PSvyYbygVllRiSXFb
         fQBADOwt9wX6M7MKnE+BvJF5e0ySVOD6KANvFbq2lNJ6OeyxS+Wma6fWy/+T8olW1HOD
         dMj6TJ4Tf60gi0jIBasVrf+8SJsrl46yE6KrNKugKQLTEjHs+Ua+kZ0g2Ruh7xh0nhy9
         Q7bbYyesRVb0AsISvaMGBemUEAQWixCP5d2QfkHFTtczV2Ig3BpWgK0w2cH9MLZDMEcr
         gIJH03ULtq5MgtQr81R6hOYKXBqhnvrI3pVa6e8SFh4VATGmtaH0qNbrS+6tLlEJ/hV+
         kX+A==
X-Gm-Message-State: AOJu0YzbKFgLrWHgGYzZlfDPHiPGwLua7IzvV1S4dlMGvYPHLoBLJv5P
	4gBqF+mh5Kvvt0+h499EehWxy6DPbILXVJa9fqaENchhZdq/VFoaKbkkyhGwuw==
X-Google-Smtp-Source: AGHT+IE2iyEEn9+TjU9+2CJlBZ/+NCoUhNOkaVMd24e0RKcWnT0q+i09dxDO4Bi7heFKQf1591iabA==
X-Received: by 2002:a05:6a21:6d95:b0:1a1:4da9:8d76 with SMTP id wl21-20020a056a216d9500b001a14da98d76mr7457655pzb.13.1709771937301;
        Wed, 06 Mar 2024 16:38:57 -0800 (PST)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id i37-20020a631325000000b005dc36761ad1sm10833508pgl.33.2024.03.06.16.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 16:38:56 -0800 (PST)
Date: Wed, 6 Mar 2024 16:38:53 -0800
From: David Matlack <dmatlack@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>
Subject: Re: [RFC PATCH 5/8] KVM: x86/mmu: Introduce kvm_mmu_map_page() for
 prepopulating guest memory
Message-ID: <ZekMnStRy1WwF2eb@google.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <7b7dd4d56249028aa0b84d439ffdf1b79e67322a.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b7dd4d56249028aa0b84d439ffdf1b79e67322a.1709288671.git.isaku.yamahata@intel.com>

On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e4cc7f764980..7d5e80d17977 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4659,6 +4659,36 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	return direct_page_fault(vcpu, fault);
>  }
>  
> +int kvm_mmu_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> +		     u8 max_level, u8 *goal_level)
> +{
> +	struct kvm_page_fault fault = KVM_PAGE_FAULT_INIT(vcpu, gpa, error_code,
> +							  false, max_level);
> +	int r;
> +
> +	r = __kvm_mmu_do_page_fault(vcpu, &fault);

If TDP is disabled __kvm_mmu_do_page_fault() will interpret @gpa as a
GVA no? And if the vCPU is in guest-mode __kvm_mmu_do_page_fault() will
interpret gpa as a nGPA right?

