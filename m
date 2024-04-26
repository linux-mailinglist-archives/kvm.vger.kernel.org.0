Return-Path: <kvm+bounces-16063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C64F8B3D1A
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 18:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF71F1C22765
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 16:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564291581F6;
	Fri, 26 Apr 2024 16:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UL62sLzf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292DE1DFED
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714150197; cv=none; b=EA+IzO9gVy5EeQEQCW/ex8xFj79b+jNNm96SIn3FVDmHVAu8sE39pwqv87Bkw4gJ4Ra9HJQhN3hejEBW7F0Tv9afvcaVxnp+qQJ7k1+ojWJnYh4cBlEwJPneHSLQQA/+Atj/cURO2HELGnk/8r0EXN+t5bGVufj3vy/BLdGhxXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714150197; c=relaxed/simple;
	bh=dAIh0mYrFaN2fm+UCmMxFACIbmH36yeNdbSzckFjm1c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WeD5AFscNxluoo8XAA3lUpa4N1XnVJDhlUeyBMNjGnF3OI4UHgZ34osgdcp6DkX7Ak0LwXH18MZGJl/2XBsF2J9ohfH/Dqfp93i7VXJ3csGwkHZ9wxPwG9kXtw0/lcqT1M/RtMmyxNuoEuBx3B6M+qgj9koepuTod4BePABXDqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UL62sLzf; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61510f72bb3so45657367b3.0
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714150195; x=1714754995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ewX/DowDnqHcwiaRF/iXxVQlOHg+443y/+RR0GCm0w=;
        b=UL62sLzfBcQm3mdNRySbmOaGEkFhscXij4Yz4mV73nsZN1Syw75WkBPF9mTPot+s4R
         OZk7rQLuiHzojKIxe5iibiE9MKGfb1JQtcEvnZRx5lvtq6xohGzfM2FtRAAwYfT65thM
         +R1OPa2S4AWDo1GH2egMGpEvM4wzLBKEM4/kdRMrxgtfLn/0B43SksWWFUZ91gdJIP46
         8efeJovSrJOGpQkqMMen/aoq+DJSqxJm+ww+yConRK/CHpCw/X7QWiDh3Ox8PYff21WM
         w7WH35KfqNv8K0xK/AgXi/Su/x8opg5HHHlcrhOWn3YsnlJ6ZWsbZyUeu4ZR1Po9VKHG
         WIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714150195; x=1714754995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ewX/DowDnqHcwiaRF/iXxVQlOHg+443y/+RR0GCm0w=;
        b=S+m27Db42ESoWiO5DcJX4wWgqaTtACdT37xPvo7APS1ouf6H8TuWNqnDHS9F/DyK1w
         NbSaA0as88lJ2FBvrykS3i63F7j6S0AaJxJnaA/FKVSZBR7QzIUNQRdM/nTy92K3TYog
         PNuLZZHWZDn4zRXXVtft2YSrTG548d4Xr9Auy3v9KO+deLFvtzajl3ChaZ4GoGSb26nL
         eapuuB1PyNzFG87E5SJRMgNBSFABUCa4KXUD1m3eVG+MaagcslvyPSx7XNs1scel6Ktj
         jXewLysYJ6w5A3dPq+V2rbBq/fFObtSmq9F58FZhSa5npQpzhS1JLE2f8Xktaz/4gYCL
         4CPw==
X-Forwarded-Encrypted: i=1; AJvYcCWo6O4eVOM3j9igaNy98tjm27fZlOLnEqY820eRFsOo2Dp+PTOHxKqi8Pd+fhzj9x2JyHLEtbZkJfwyxQntu0s2JnP/
X-Gm-Message-State: AOJu0YyTdKRBmBhiupPrZLBLHh86LldhqbeYDegXvBAz7Rdh/qVvzghD
	HcFPAnri0y9u51QFvyX7cbfjKNLeuc2A63UH0oIiOPxBcZTyuz24ZzlUtYjV78E7NIuJgoclbe9
	0Yw==
X-Google-Smtp-Source: AGHT+IErOpsXYuqKrycMnqqvdiscCxh5dYOEbzYBM+0/tFZOu07aaZY0igiIEOsj02AJwMtScSS7N0P/6uY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:8488:0:b0:615:19db:8ee0 with SMTP id
 u130-20020a818488000000b0061519db8ee0mr664141ywf.1.1714150195245; Fri, 26 Apr
 2024 09:49:55 -0700 (PDT)
Date: Fri, 26 Apr 2024 09:49:53 -0700
In-Reply-To: <21d284d23a7565beb9a0d032c97cc2a2d4e3988a.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
 <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com> <20240313171428.GK935089@ls.amr.corp.intel.com>
 <52bc2c174c06f94a44e3b8b455c0830be9965cdf.camel@intel.com>
 <1d1da229d4bd56acabafd2087a5fabca9f48c6fc.camel@intel.com>
 <20240319215015.GA1994522@ls.amr.corp.intel.com> <CA+EHjTxFZ3kzcMCeqgCv6+UsetAUUH4uSY_V02J1TqakM=HKKQ@mail.gmail.com>
 <970c8891af05d0cb3ccb6eab2d67a7def3d45f74.camel@intel.com>
 <ZivIF9vjKcuGie3s@google.com> <21d284d23a7565beb9a0d032c97cc2a2d4e3988a.camel@intel.com>
Message-ID: <ZivazWQw1oCU8VBC@google.com>
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hang Yuan <hang.yuan@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "sagis@google.com" <sagis@google.com>, 
	Bo Chen <chen.bo@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, "tabba@google.com" <tabba@google.com>, 
	Erdem Aktas <erdemaktas@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 26, 2024, Rick P Edgecombe wrote:
> On Fri, 2024-04-26 at 08:28 -0700, Sean Christopherson wrote:
> > If the choice is between an enum and exclude_*, I would strongly prefer the
> > enum.  Using exclude_* results in inverted polarity for the code that
> > triggers invalidations.
> 
> Right, the awkwardness lands in that code.
> 
> The processing code looks nice though:
> https://lore.kernel.org/kvm/5210e6e6e2eb73b04cb7039084015612479ae2fe.camel@intel.com/

Heh, where's your bitmask abuse spirit?  It's a little evil (and by "evil" I mean
awesome), but the need to process different roots is another good argument for an
enum+bitmask.

enum tdp_mmu_root_types {
	KVM_SHARED_ROOTS = KVM_PROCESS_SHARED,
	KVM_PRIVATE_ROOTS = KVM_PROCESS_PRIVATE,
	KVM_VALID_ROOTS = BIT(2),
	KVM_ANY_VALID_ROOT = KVM_SHARED_ROOT | KVM_PRIVATE_ROOT | KVM_VALID_ROOT,
	KVM_ANY_ROOT = KVM_SHARED_ROOT | KVM_PRIVATE_ROOT,
}
static_assert(!(KVM_SHARED_ROOTS & KVM_VALID_ROOTS));
static_assert(!(KVM_PRIVATE_ROOTS & KVM_VALID_ROOTS));
static_assert(KVM_PRIVATE_ROOTS == (KVM_SHARED_ROOTS << 1));

/*
 * Returns the next root after @prev_root (or the first root if @prev_root is
 * NULL).  A reference to the returned root is acquired, and the reference to
 * @prev_root is released (the caller obviously must hold a reference to
 * @prev_root if it's non-NULL).
 *
 * Returns NULL if the end of tdp_mmu_roots was reached.
 */
static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
					      struct kvm_mmu_page *prev_root,
					      enum tdp_mmu_root_types types)
{
	bool only_valid = types & KVM_VALID_ROOTS;
	struct kvm_mmu_page *next_root;

	/*
	 * While the roots themselves are RCU-protected, fields such as
	 * role.invalid are protected by mmu_lock.
	 */
	lockdep_assert_held(&kvm->mmu_lock);

	rcu_read_lock();

	if (prev_root)
		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
						  &prev_root->link,
						  typeof(*prev_root), link);
	else
		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
						   typeof(*next_root), link);

	while (next_root) {
		if ((!only_valid || !next_root->role.invalid) &&
		    (types & (KVM_SHARED_ROOTS << is_private_sp(root))) &&
		    kvm_tdp_mmu_get_root(next_root))
			break;

		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
				&next_root->link, typeof(*next_root), link);
	}

	rcu_read_unlock();

	if (prev_root)
		kvm_tdp_mmu_put_root(kvm, prev_root);

	return next_root;
}

#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _types)		\
	for (_root = tdp_mmu_next_root(_kvm, NULL, _types);			\
	     ({ lockdep_assert_held(&(_kvm)->mmu_lock); }), _root;		\
	     _root = tdp_mmu_next_root(_kvm, _root, _types))			\
		if (_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) {	\
		} else

#define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)		\
	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, KVM_ANY_VALID_ROOT)

#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)				\
	for (_root = tdp_mmu_next_root(_kvm, NULL, KVM_ANY_ROOT);		\
	     ({ lockdep_assert_held(&(_kvm)->mmu_lock); }), _root;		\
	     _root = tdp_mmu_next_root(_kvm, _root, KVM_ANY_ROOT))

