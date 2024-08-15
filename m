Return-Path: <kvm+bounces-24311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5933A953878
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDA811F24965
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0675E1BA875;
	Thu, 15 Aug 2024 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QHMXQqqp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B601714BB
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 16:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723740173; cv=none; b=RJR/NEcBzbo9eDOTtYsUFqG0KsLGtlxRcu/QrGGprG7+skeqiQ3sPEVtdgYNA+EGYMeUBA0V/uasemhYQ8Is9GsvD7nhmNOtJpfgh92iUcDrDj5s/UtVFClW95rNIkWT5AniADh2djTa51Nrzeai7BrBqpDy/pRfoRN3VjP2lOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723740173; c=relaxed/simple;
	bh=1zRUFULarkTq6LPHVNJ0pkCLjhF3gvttZE7Jb/DKsk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=irw3c6A7KwXWaNaAgra3fAIwilU1Pc8VGjma4WwAP64Bi8E12c3sU9vAo0xAZqJx5mdnVAiPftI9Rn8qV66zv5xHacoY+zRBRhZHvlHhcwcrp4qX8NXTig+WfSY2CDrGs6kmql+7cAkP0PRHWCyyRN3ldcz3SeuZgpJwGz+ZUTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QHMXQqqp; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3db18102406so614238b6e.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 09:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723740171; x=1724344971; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f9XWOzgA/HPz/G4P1h718yGI+VzmZbkZwfnQInlVNGo=;
        b=QHMXQqqp0faOlKAPErne6hqqOve9t3QxZ8ty67nwkIUROLh34MGXfI7bliG0RtkeSF
         9rCCO8BgHeAeHGqg63hvu+VuAYE6DdLuhpQSeStjC2dYjBEGB4SXUCYP2686IP7FFcpR
         rh3Tq9cK1xqctLKQ3WWKIaMmqvl50QLfwsKfxX5MgPydR7XuCIEH4KYvekPCOk7lSprA
         XHAttpT48PZFtEHpO8npLkq+WhvmrlTJaMkrU8Z8MUvAvYn9N4TXUgAc1YtrO5ubYa/x
         NJFCwFezWMx+eGY0UnLmVO3IoINGl/j/ZmEsAa7KJFbvOqAPG4VpHJK6/eNaRQrQp1yF
         rL4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723740171; x=1724344971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9XWOzgA/HPz/G4P1h718yGI+VzmZbkZwfnQInlVNGo=;
        b=RHAuBQbVdRJ8EH7hNAT5Ycv+VisiU+Tm4X46Hy9cM1bniR6JcKHEv4A5iE6bIjhsc0
         TLUVX3z+tdFLlMeAGwOYfg4xzuWrdJO7Ypih8UqdOIWADiYC0x8tcgdXWzuJrBlhFtbr
         UXWX9DuvYXlFZ1nqhqS9QpGjqcOV95uKj7MyTJsMbJVb/IDdxfdyTdXKdV7Y4weLyr9T
         s2o/JDp6byfcj4ihC9w7FiQw9wP34cdtumu+OX/2zLjPQaIcvswNF58+n6MmHDGHRFU2
         TUaCf8mkJJV+bK0cCCmokJ/RRNxnuM4uU+6oCrYLvDC7jNE9IqFlGTETYwX0VFlIVLJh
         xtdA==
X-Forwarded-Encrypted: i=1; AJvYcCVMuZRp1Ib1vB5VYr9T45cMHn8Er+StUYBKmhVdw0FkjYxDErdmp/09Xq5hnHSd+N2bFO8ymVeE8MNtB0TpTXhknwNh
X-Gm-Message-State: AOJu0Yztf9aciDXwmyCkbeUcB5o+vllyBLK3teRQloNY428Klsxco82Q
	M9mwFcMyFN+6CIRz+/jf19S3oG78wTO/N9Eo2ZM5cgqePnk6xfZkv73ZzYJyfg==
X-Google-Smtp-Source: AGHT+IGcK7SGE8EjW4QiHlEKJJHDBb8NIW/RbvoYkf19zDjo/HtqxIAEn4/qp/U2DyWRmGixwywMhA==
X-Received: by 2002:a05:6808:1b13:b0:3da:57b8:22f3 with SMTP id 5614622812f47-3dd29971d90mr8649806b6e.43.1723740170612;
        Thu, 15 Aug 2024 09:42:50 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b636ca92sm1324086a12.91.2024.08.15.09.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 09:42:49 -0700 (PDT)
Date: Thu, 15 Aug 2024 09:42:44 -0700
From: Vipin Sharma <vipinsh@google.com>
To: kernel test robot <lkp@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, oe-kbuild-all@lists.linux.dev,
	dmatlack@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
Message-ID: <20240815164244.GA132028.vipinsh@google.com>
References: <20240812171341.1763297-3-vipinsh@google.com>
 <202408150646.VV4z8Znl-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202408150646.VV4z8Znl-lkp@intel.com>

On 2024-08-15 06:50:04, kernel test robot wrote:
> sparse warnings: (new ones prefixed by >>)
> >> arch/x86/kvm/mmu/tdp_mmu.c:847:21: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    arch/x86/kvm/mmu/tdp_mmu.c:847:21: sparse:    unsigned long long [usertype] *
>    arch/x86/kvm/mmu/tdp_mmu.c:847:21: sparse:    unsigned long long [noderef] [usertype] __rcu *
>    arch/x86/kvm/mmu/tdp_mmu.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
>    include/linux/rcupdate.h:812:25: sparse: sparse: context imbalance in '__tdp_mmu_zap_root' - unexpected unlock
>    arch/x86/kvm/mmu/tdp_mmu.c:1447:33: sparse: sparse: context imbalance in 'tdp_mmu_split_huge_pages_root' - unexpected unlock
> 
> vim +847 arch/x86/kvm/mmu/tdp_mmu.c
> 
>    819	
>    820	static bool tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>    821	{
>    822		struct tdp_iter iter = {};
>    823	
>    824		lockdep_assert_held_read(&kvm->mmu_lock);
>    825	
>    826		/*
>    827		 * This helper intentionally doesn't allow zapping a root shadow page,
>    828		 * which doesn't have a parent page table and thus no associated entry.
>    829		 */
>    830		if (WARN_ON_ONCE(!sp->ptep))
>    831			return false;
>    832	
>    833		iter.old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
>    834		iter.sptep = sp->ptep;
>    835		iter.level = sp->role.level + 1;
>    836		iter.gfn = sp->gfn;
>    837		iter.as_id = kvm_mmu_page_as_id(sp);
>    838	
>    839	retry:
>    840		/*
>    841		 * Since mmu_lock is held in read mode, it's possible to race with
>    842		 * another CPU which can remove sp from the page table hierarchy.
>    843		 *
>    844		 * No need to re-read iter.old_spte as tdp_mmu_set_spte_atomic() will
>    845		 * update it in the case of failure.
>    846		 */
>  > 847		if (sp->spt != spte_to_child_pt(iter.old_spte, iter.level))

Hmm, I need to wrap spte_to_child_pt() with rcu_access_pointer() before
comparing it to sp->spt. Following patch makes this Sparse error go
away.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7c7d207ee590..7d5dbfe48c4b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -820,6 +820,7 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 static bool tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
        struct tdp_iter iter = {};
+       tdp_ptep_t pt;

        lockdep_assert_held_read(&kvm->mmu_lock);

@@ -844,7 +845,8 @@ static bool tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
         * No need to re-read iter.old_spte as tdp_mmu_set_spte_atomic() will
         * update it in the case of failure.
         */
-       if (sp->spt != spte_to_child_pt(iter.old_spte, iter.level))
+       pt = spte_to_child_pt(iter.old_spte, iter.level);
+       if (sp->spt != rcu_access_pointer(pt))
                return false;

        if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))


