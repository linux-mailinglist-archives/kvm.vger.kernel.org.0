Return-Path: <kvm+bounces-17446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1526A8C6A1F
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 18:02:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C342A1F23130
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 16:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D913C156251;
	Wed, 15 May 2024 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2FRPYHxA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2111155A52
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 16:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715788930; cv=none; b=FWonjHWMGmEs7gDoQsMO1ljPusRrQzNDRvnJx3j7+kn1Dv4TuhqovuBRwsZdselLHajMfNQU5CaiSvpwkuTO4RTLdVok3iLZVp9IaslOmRXb0pDa7CCTouKOMYk+C+72EtKPR0A2SgtOkbprXqLz0SL/W4R1Nhb17S0VojmLXe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715788930; c=relaxed/simple;
	bh=dHp9YY0yUz81Klbcbarf2tktRzWRTMeL2ufthxa+Lvw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oI/UZI02c5tQJzgR7+T1u5WHblZU59BO4pVUyxrsbrLCr9uSPuM/vAl1uJW0yoHkRMz+YBqw4J6ckLGf0GcmaFpMjcvgpGJ8fAOsH2DMEMS+urkMFiaacbKBorY5CPEu3fVhXG5qYzrXj8er9Iql1+hF/uP1XmI93Ns1mBFvcHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2FRPYHxA; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61510f72bb3so132593137b3.0
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 09:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715788927; x=1716393727; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Leaj1hGD/l4qMnCDX6HAbzcyf5xPcTNn9ubyVFrolYs=;
        b=2FRPYHxAnZjbH4EO51l4RxbGPtkoRqqbgC7JJlJYHXO9f32/U3brEPAN3Dxqo1Fz4W
         JPwcgFCw9O0Nn1rnnIqVl7S5SUw7TC80P1EFI6mADucXWWK/4pHSL9o4xlDuC67fuJGM
         hvjwu5tikOrfJ3ul16/LAc3UoOeRNfmAuAG/3Tvxqi/EBLgSF3T5kb/sZUaKF3hVo9kI
         3F0q3XMjqdZqsCmJJcrYd8nZCgirwittdCnCypviwcvB7cXZ9tb+7zgES66xyuG974W7
         uIRAYIO7B9OVl8cu2kJSI6jSyGwNnxlw3KGYEZIPGqQGHrK19C7LeSPh4Uca+SehPpDK
         bs0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715788927; x=1716393727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Leaj1hGD/l4qMnCDX6HAbzcyf5xPcTNn9ubyVFrolYs=;
        b=uT7wI/JdQOhQiRwJvTgG8rcfqgjQiVr/xKNDfBGc156CPpsfp2r3afZIA60yGZc6Nx
         a6pplztf09SdbYoAaR/j+Y/w7ap5wnQzfncrana8IrCFfbieQRRVH/rrxmrj3QqnT205
         3MDe8Egb0U8bVakSBTGOy6clo/mvNy0qBofhoEK/COS4hae7CwwpyYu3pDWd0rhiL380
         bpdf9dxOLNa0ZHqxrv+L2KEbJ99BEGB+gGFu8yIeae0BHrfY+HFp+AbZEokh8J8q1pFa
         wegcluH9EgIVfoJAbUdTcLO37SJODnpg+R1HAPC+/R7nSRZu/h9jtvoA4jDuTC5MQgQ8
         Uelg==
X-Forwarded-Encrypted: i=1; AJvYcCW+uJqgqfiU6Vj2BX1yxd/ZnebNCt2JA+vic8HLi9rQ/rhoEAJ+6Cg4KGXW8MMC3CKhZj3Sq219wBFqvqsDSouxUHbO
X-Gm-Message-State: AOJu0YxNUEq0zXaQSRAJy817P0cfKCZdZ2We6M57Ji7L0tK7v2DNuBVk
	hVgWYuRG4cSpp2G8MZAjhF9kkYGgqXRNhE9XvSqCYSgQAWZM6V5EcbNkbbLbLSrVsJGOQa6ih0A
	q9g==
X-Google-Smtp-Source: AGHT+IGPwheN6AaZMallYW5on/mieXkwwDJnuyPkb/L15W89sdb/Xu1kDKQkw1QV4ydleb3vm7DTRtu99bs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ea0d:0:b0:622:cd7d:fec4 with SMTP id
 00721157ae682-622cd7e0027mr29802577b3.9.1715788927600; Wed, 15 May 2024
 09:02:07 -0700 (PDT)
Date: Wed, 15 May 2024 09:02:06 -0700
In-Reply-To: <747192d5fe769ae5d28bbb6c701ee9be4ad09415.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com> <ZkTWDfuYD-ThdYe6@google.com>
 <f64c7da52a849cd9697b944769c200dfa3ee7db7.camel@intel.com> <747192d5fe769ae5d28bbb6c701ee9be4ad09415.camel@intel.com>
Message-ID: <ZkTcbPowDSLVgGft@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 15, 2024, Rick P Edgecombe wrote:
> On Wed, 2024-05-15 at 08:49 -0700, Rick Edgecombe wrote:
> > On Wed, 2024-05-15 at 08:34 -0700, Sean Christopherson wrote:
> > > On Tue, May 14, 2024, Rick Edgecombe wrote:
> > > > When virtualizing some CPU features, KVM uses kvm_zap_gfn_range() to zap
> > > > guest mappings so they can be faulted in with different PTE properties.
> > > > 
> > > > For TDX private memory this technique is fundamentally not possible.
> > > > Remapping private memory requires the guest to "accept" it, and also the
> > > > needed PTE properties are not currently supported by TDX for private
> > > > memory.
> > > > 
> > > > These CPU features are:
> > > > 1) MTRR update
> > > > 2) CR0.CD update
> > > > 3) Non-coherent DMA status update
> > > 
> > > Please go review the series that removes these disaster[*], I suspect it
> > > would
> > > literally have taken less time than writing this changelog :-)
> > > 
> > > [*] https://lore.kernel.org/all/20240309010929.1403984-1-seanjc@google.com
> > 
> > We have one additional detail for TDX in that KVM will have different cache
> > attributes between private and shared. Although implementation is in a later
> > patch, that detail has an affect on whether we need to support zapping in the
> > basic MMU support.
> 
> Or most specifically, we only need this zapping if we *try* to have consistent
> cache attributes between private and shared. In the non-coherent DMA case we
> can't have them be consistent because TDX doesn't support changing the private
> memory in this way.

Huh?  That makes no sense.  A physical page can't be simultaneously mapped SHARED
and PRIVATE, so there can't be meaningful cache attribute aliasing between private
and shared EPT entries.

Trying to provide consistency for the GPA is like worrying about having matching
PAT entires for the virtual address in two different processes.

