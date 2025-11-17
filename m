Return-Path: <kvm+bounces-63397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 32294C65602
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 18:12:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id B92452A94A
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 17:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72DB833DEEB;
	Mon, 17 Nov 2025 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rYpEo30R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6F330BB89
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763399025; cv=none; b=Y+RqYE723HKG0iQ6FnPuqRdPQ/bKZnw75SYcpcAsbHiaruc8y/m78CAVfFzp+6pkjMgLtVchVxVdVWyupB8QgIL7D/+rkjzVyLsqsMLImvAOHPPMrgYW4829v26LwJyc5xCb/bq+Sbu7O4SRFoXZV2Yuc50mtMlBkQ8uce62M3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763399025; c=relaxed/simple;
	bh=bkVMcDwSIQqPy3ppwR3++s+E7Tde5RHH8Gep/ihy9i8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pap21Aggjrvpmij08/NF9m+G8CmXmsg0uuOsazuWbYobSAW5SCZniWKFZ5nMX/5mrhIqNXOTOgvbsyhw/vdPVmV12Xa2KuxnyeMHFs0hc949hq9QtQX8QzrHVgYQAs9SFSBOPGr2nzyRhm8QMjPVqlL+s7FKg0vEpfkzX370Jjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rYpEo30R; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b80de683efso9450992b3a.3
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 09:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763399023; x=1764003823; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0hq6Uia9RhmITs3Fm5C1ux3TB78rTa2oGwDQ4IOSjBE=;
        b=rYpEo30RpXd7WtfTxTPw2DJWdaW4wEeNOB3FAF7M0R5noH4kkvp8HWqItfRFJOM9wq
         yDZxvZDGuh8yDkX30Qo/zsQGZWivVa9tNmS8Xnaa9Vdp6Pptcgm7+qJ9kCEBBpT8rH19
         /Y9yS5gfQ/GwfSJZLV82KQuLlRekzS+3H4k2Y81rjV2YxFZPNXqHxvTNXczrS4ePzJhq
         DEX28q03BISuirAF9Osw5xq4/K0U7B2q7H4Jwb9lJJcig/PjoU4uXGnVvqMdazCtDmmt
         /g808ppriT3eD0opreVJZklP0gYh1Es5AGYv/o3cnbKx/hk99I4PZ3Ei+oFlUavCmLor
         FZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763399023; x=1764003823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0hq6Uia9RhmITs3Fm5C1ux3TB78rTa2oGwDQ4IOSjBE=;
        b=baMyB2EBeY0bqMuEpvz29u2eH+AjVwQr0riMKDE90TdBGT3V11HQTf/cYR+lyhqcxl
         3M49n2efEJjjWyYo4l/nftEP2GciQM2ccJEhPR9Q1vlzayQOclhGT6I6IpQw88v7U6Of
         0ttSqilPBz4XG5Nniahpduwn6wvvm8db63eAmKMfaIsFxFX+oC3Dt5eSS5A2UzMhEnak
         apZOBw1S+jgZvQFOS9x1jlqYWcAyNlk07+2Dpcmcp260aC4i+wdLvkWE9LpP36uOmYUV
         A+bSGySlHMEMDXyqRmcBsAVRtIyiI6fcjVIPECZ0zbwODjWvZMMBK5oq6D/3h0g7XT1S
         RGPg==
X-Forwarded-Encrypted: i=1; AJvYcCXiwOiCJryvWMSCcHwJqYnzQGg0JDUYUuMUjETmir8z2OTFepb0W+APG8aVkijZPjZgg2g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGATbW1IhqLJy33L/imNDWu1hT1mlSipFjfhVKxA4yAjFptFag
	KJu3HThp/lAcG0qgrGleU5sduo3LBj2sdJBN6tjh3YA1m1qpqLif80rBJtQIwlBVj57uF87a4z7
	QEtHETQ==
X-Google-Smtp-Source: AGHT+IGkp5EJaeics9rfr6OPoTNm9TOyUmNPfmPd5OleLPcrSezjyK79L0sxbr8BzPRbpMbixTLjg2AYM2E=
X-Received: from pgnc22.prod.google.com ([2002:a63:7256:0:b0:bc3:7d57:2ea2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:999f:b0:35e:7605:56a4
 with SMTP id adf61e73a8af0-35e76055d0cmr7231438637.51.1763399023245; Mon, 17
 Nov 2025 09:03:43 -0800 (PST)
Date: Mon, 17 Nov 2025 09:03:41 -0800
In-Reply-To: <ei6cdmnvhzyavfobamjkcq2ghdrxcv7ruxhcbzzycqlvaty7zr@5cjkfczxiqom>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112013017.1836863-1-yosry.ahmed@linux.dev>
 <aRdaLrnQ8Xt77S8Y@google.com> <ei6cdmnvhzyavfobamjkcq2ghdrxcv7ruxhcbzzycqlvaty7zr@5cjkfczxiqom>
Message-ID: <aRtVbeVHe5ZFOPQW@google.com>
Subject: Re: [PATCH] KVM: SVM: Fix redundant updates of LBR MSR intercepts
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 14, 2025, Yosry Ahmed wrote:
> On Fri, Nov 14, 2025 at 08:34:54AM -0800, Sean Christopherson wrote:
> > On Wed, Nov 12, 2025, Yosry Ahmed wrote:
> > > svm_update_lbrv() always updates LBR MSRs intercepts, even when they are
> > > already set correctly. This results in force_msr_bitmap_recalc always
> > > being set to true on every nested transition,
> > 
> > Nit, it's only on VMRUN, not on every transition (i.e. not on nested #VMEXIT).
> 
> How so? svm_update_lbrv() will also be called in nested_svm_vmexit(),
> and it will eventually lead to force_msr_bitmap_recalc being set to
> true.
> 
> I guess what you meant is the "undoing the Hyper-V optimization" part.
> That is indeed only affected by the svm_update_lbrv() call in the nested
> VMRUN path.

Ooh, yeah, my mind was fully on when the intercepts would be recomputed, not on
when the flag could be set.

