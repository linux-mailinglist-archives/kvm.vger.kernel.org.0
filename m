Return-Path: <kvm+bounces-18827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 736EB8FC007
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:40:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6BC81C21C20
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF8114F118;
	Tue,  4 Jun 2024 23:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NXObW4fa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B0D14E2C6
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544354; cv=none; b=tgq/q1peOZl9hm27IQ/ziBhniCpr+Dnzyu5NPL9EWaHPNm6YYt7/+qkSyKScIkIPnLCszBwgIZHKzfBJ4+v/5rgfLBencQTV0AQ8vauDNCD4cXaAO+8q/m6+/sWi2cKfQj3LZwJUwO4nAmanL7ZU19B6mGPwvGWDKMgT7Oj5Sg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544354; c=relaxed/simple;
	bh=tc5YRbRUYPY+/00t3JTvQTTKwaovHAJSw/HYHTn3amA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DBZZNs9O1VygJzFTiCpay+cp62uP/ciNxH9CnVkx3MDZhn7gllrT0DiPxsKQksCLLfZnwjm+vFpaL/i7dEF6nDIWlO5lMw/ubkEUa77/GnFdaibUABGZH7chqwXnurJUzaI8k+OrhXgADz4W7j6Y6DGXv610lAcGdlftkk8Ujc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NXObW4fa; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f64b60a92eso40913795ad.3
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544353; x=1718149153; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lxmsXq1UCpp+mv5yCq9klzI3ABcFo4eNxvaBO5sGMZw=;
        b=NXObW4falrZf8Lhd6WscrLbVALj5C0nXimLXI8BmX0EgKIAoKoJkXdvRNyoz4Vwrwn
         TQqk8QfCHuvtbRzHlz20s4qd8pBTKMIMgojhw+ktVmfp6z8yYlWK36NoimtGSUVXAQjo
         YSmhT71+cy+SZ2mD9NDuXuNWtWQ78w3lN1rzqALOxspbq+sKM9baRyCNz3X2W+s27LkQ
         +bSDewQp9oeIlIC7k+5/ZJZyd7Xn5srWzMAQg6vF6//DQYC6bjhgE3Wuj8nC9iTe50SU
         gSB6YCldXQZus9NHHB/k4u2FF7amAWOvhyWODC+OQJEwaKO65/On2JYOJkZaMSBLbkNm
         xJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544353; x=1718149153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lxmsXq1UCpp+mv5yCq9klzI3ABcFo4eNxvaBO5sGMZw=;
        b=f12qdOW5JgIiNDPKtLPkm/WoEANIzxZuMRE/v4KLN9pzdPrDORUslguLaGXQM/z9j+
         VkScobcfX9b3LWm+PtSkY0XJ7WwjQRfjZhsyHXSrZb+tzYsEyI0ErIj/7+8JLiz7X2Do
         xtVfETV3RvNvl8H4qixMSkYN7m6PtYh9UQky/wZnyjqREVCYnwguiZkWrRFGQiFnsUty
         nibVLFNhuyoTRjhLuwrdzaGDKgJWonbjBHeLtq4/yzb6/U1OUHxscPCRV5GsQqADhc7b
         lqJN++WMCOBk1ScGcirtDbG0GDpVlkZ3b0HKQ/P4dsqxcmqqHYUYKxesvEzEy+/OJa6E
         AVPA==
X-Forwarded-Encrypted: i=1; AJvYcCX0bpMNNZL+YEWQQFHDU1MLnEEXOi5m0cOb7PRBfpRtpcJUJ3AQslCCelQqJIQjuU/SMy6u5GMg/Z8CxglbMIUxn34G
X-Gm-Message-State: AOJu0YzLjgZ8A5lg9XAaQ8mYsUBuAQ7c/WG5kGWWCb+XKRUOLqaCYbt9
	RuG3Kwa4T7m7vQpnSQMg6ZQHRUi3z0nvLNFfDRv4ighmXq5D6Im/z6V/Wpy52hUV+Zzz8cZefc0
	nbA==
X-Google-Smtp-Source: AGHT+IGi9VcD3urQpHRnfl4foRRWR69R9CgO8s0kDtQF+wZ+BFmNdzCihgxx6/x3us52yJ+fbuZMoX6Ng2k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32c6:b0:1f6:6927:1034 with SMTP id
 d9443c01a7336-1f6a5a7a273mr693975ad.11.1717544352657; Tue, 04 Jun 2024
 16:39:12 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:45 -0700
In-Reply-To: <20240528102234.2162763-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240528102234.2162763-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754258320.2776676.10165791416363097042.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't save mmu_invalidate_seq after
 checking private attr
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>
Cc: pbonzini@redhat.com, chao.gao@intel.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"

On Tue, 28 May 2024 18:22:34 +0800, Tao Su wrote:
> Drop the second snapshot of mmu_invalidate_seq in kvm_faultin_pfn().
> Before checking the mismatch of private vs. shared, mmu_invalidate_seq is
> saved to fault->mmu_seq, which can be used to detect an invalidation
> related to the gfn occurred, i.e. KVM will not install a mapping in page
> table if fault->mmu_seq != mmu_invalidate_seq.
> 
> Currently there is a second snapshot of mmu_invalidate_seq, which may not
> be same as the first snapshot in kvm_faultin_pfn(), i.e. the gfn attribute
> may be changed between the two snapshots, but the gfn may be mapped in
> page table without hindrance. Therefore, drop the second snapshot as it
> has no obvious benefits.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86/mmu: Don't save mmu_invalidate_seq after checking private attr
      https://github.com/kvm-x86/linux/commit/f66e50ed09b3

--
https://github.com/kvm-x86/linux/tree/next

