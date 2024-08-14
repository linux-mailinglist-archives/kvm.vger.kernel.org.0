Return-Path: <kvm+bounces-24149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78325951D80
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC041C21DAD
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2AA1B581C;
	Wed, 14 Aug 2024 14:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ypS4pgAz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12D81B4C56
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 14:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646483; cv=none; b=oZO1DF4jV3sMbu3jXu1ZI2Vd6EDFg/KmjQT+3txkCn5JmLq06FuAKjumJCzqSbLxo8QtCWOx4CP5pJ5DD1V57wrRVuuw5FLglCbj6BG6mZBpx9yazrGgg4QvdnO7MEHhWCDM9RMy5064DDqKxpUhEL3xjXG3xcuvL1gEcaT08tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646483; c=relaxed/simple;
	bh=5ImcRxK8U/xz9H4dT7jDuX40K0+TLGa4BxIod0uQ2O4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HGB6KBOsp/AXYSJQLSn1t6ldUxS47BwSgAMS2MBpI12I3QWmblCWCFT5fvqt1ymrY2WJsJg9g3Wf3L8iGFRUcgr+9Ngpggr9GJkoI58LiS+vjxcyxvUDqid3+2uEabd/2PuhRVAHIpfMLrB2D6IUy0hbWDy8dof8tS8FzJvcem0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ypS4pgAz; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7b544c7f7b3so6466124a12.2
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 07:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723646481; x=1724251281; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8eQppPywlRD4zJK4Qw8n4TAMnHmhGHJxgJ7aSuitxnw=;
        b=ypS4pgAzxxeJc6yB+7mM9XmhckNbT+j/raN0l7h4fUWtpd0Xo/4bIWLvnbxKhDsG1j
         +JFUkolIKIavcujeUVuR4oU1r7o1lBcidXj3dyCQrVo0H8NJ+7Czo3+yaRwGjzOIpP3r
         Br3ffYd05kiegkGLB3v6aDYBvYsdib3gVrolZI6bmf66B8dS4ciaY1uSTz8eQNPhwynp
         Qe34pYx8Ly0Sz71OKk3Ekdq7apYpOPbJ937nTRIawHfy+LWr44EoxVM8Skbi4D2xUwk6
         M4+yi5/Il7z8HIpUBc5TLfiH/y7w61CD8jHqmmdXE2mFvU5XJE283BeJnqb0cMMEWYP7
         cVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723646481; x=1724251281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8eQppPywlRD4zJK4Qw8n4TAMnHmhGHJxgJ7aSuitxnw=;
        b=be2cXOhlPqfhooNik96mzmikeFMcURfVQ9AoyvQauEJreGJD8HouRBjhVfnzt7Kdpv
         sYtqD+osXJxCwX4/ioCuG2YfRyNV9G3HV5Nyua17I1eZs+wlwAqhALs61y1C4q+cp874
         gRPt0uPJ9jdOyEkpqY7sYTlU3oMMBZeFhMSXBPuPh02cHd9e7Rp19072PTEfEDT9KGhc
         J6TvRGHPKAczshTLY8q/aQCyAo11RwHsdrmoya68eKCL6T9eFdhw8nB/UBhLA0OIs08l
         QIHcQQ+m1K7evc9FROSSshhoi0brmxCOnZRQWj4pzFxF9gQzLsOMqNu05Els6u8Fm73d
         EYMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyCKEuzTT2ngDvfjLW8cA4Ix3y5DNlD29bODS2ZZHm2yO9NPuUjZAGtuP9hIOb1RasTdHZFWpnNxueei97tiUvD6qQ
X-Gm-Message-State: AOJu0Yy78TjJsoNATWkHBcIGKVxIHfSTeZABVrAx0Z/kgXrtr6Xx4RmO
	i7sJitUiT8DumP0UTE5ZBk1FbUAOH9lTYukOl3J8BctPulJ2HkRLNHDAzBibrJ3ga7Bv999WRHr
	szA==
X-Google-Smtp-Source: AGHT+IEy2cdq4eY82Sr3/toVMEJW3Z58+QsUSZW/hGAjFtu/nicstNFLzHq0qN99erPdDJJRMnIO+Smljz4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6818:0:b0:719:8067:6bca with SMTP id
 41be03b00d2f7-7c6a568c52emr5913a12.1.1723646480836; Wed, 14 Aug 2024 07:41:20
 -0700 (PDT)
Date: Wed, 14 Aug 2024 07:41:19 -0700
In-Reply-To: <20240814082302.50032-1-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240814082302.50032-1-liangchen.linux@gmail.com>
Message-ID: <ZrzCD-cL4N1DsRaO@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Register MMU shrinker only when necessary
From: Sean Christopherson <seanjc@google.com>
To: Liang Chen <liangchen.linux@gmail.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

+Vipin and David

On Wed, Aug 14, 2024, Liang Chen wrote:
> The shrinker is allocated with TDP MMU, which is meaningless except for
> nested VMs, and 'count_objects' is also called each time the reclaim
> path tries to shrink slab caches. Let's allocate the shrinker only when
> necessary.

This is definitely not worth the complexity.  In its current form, KVM's shrinker
is quite useless[1], and there were plans to repurpose the shrinker to free pages
from the so called "mmu caches"[2], i.e. free pages that are guaranteed to not be
in use.

Vipin/David, what happened to that series?  Are we still working on it?

[1] https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com
[2] https://lore.kernel.org/all/20221222023457.1764-2-vipinsh@google.com

