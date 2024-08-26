Return-Path: <kvm+bounces-25078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E92995FAA7
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 217EA282E5E
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D76419AD56;
	Mon, 26 Aug 2024 20:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c3sDyybO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF30E19A281
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724704109; cv=none; b=qsb7PSDieBHlXJ1YeP3dCk6xpb8yS/92YOQjeFz83IFEa34J4isKg9w16lmZ6XBfeVET9EMl2tgn/ZQJbbdyP3GjqvE7jC57UrLaXJbc1tRR6iC6PER7jmerPtQlD9zON45M0xpc1ePplRbTGiuKvCmRrLTIiMwE5clbgx4uB3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724704109; c=relaxed/simple;
	bh=3aLGWNFml1fs6ET7vU4TR6a4dUKkunevdgnP5XM6DFU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L6dIx/Q3MWdbhLpdNercRx97MHOFVLbRC3UKnnUJ1+wo4EhPL3RXUnqxbwigjP0X4RojVrUjr0K/IkRU/PvYMXwwuS5898ZX4W6iJyeP/ajIdrVyjGOuADIXkdIqP0uoqRBJnOI3m+MNrOr5gXRz6VGesB954vpwYe2LqV/90B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c3sDyybO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b991a4727eso86234117b3.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724704107; x=1725308907; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y4CuIS2O9/fj+lBdt8ymvV+Stc9+h4xTSSAPFKw9WU0=;
        b=c3sDyybOX74t6cnLJ7vu6bytaZ/pfDV6f3RqG11bxF7Z/PuY1pYdPHkIDyxhMr5Au/
         p/uIvSzDTr5ozdbcR7n2PjR1wIwmIQY53QX3K1XS5CtrnxgO0SmhqMEriGnvyl0gWM74
         dKrPBP8W7m1aUM/jllUUs6e19cPeioW6Hj2E0M3pBSJyErI/JbUfugalnfQsfyyR3e3v
         /PpEvX7V13Ft1nGLBn1Fb6F4A1lq9zaEf2En4P/hTA8GBfB6sa49GLKAcLpyoialNNRT
         ghyHscflNlfsTnHhZxISyXT4SBDgOaj7V57SAkf+gMRXxS2dcXyFTFkxm/pLYktyY02w
         bHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724704107; x=1725308907;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4CuIS2O9/fj+lBdt8ymvV+Stc9+h4xTSSAPFKw9WU0=;
        b=vVGMFQsRMVQNxLiDxyBwwVTY6/8177S750EWVkNuPcRgy2thk/ELm3S4Cbs6EQRQ/x
         XPdaCviHjVO9PThmSPbDKGJJtnDAhLAsSvbdTHBgsTtS3x4j0UIq8sjdL85nj91OZXyX
         vdBGxF3vigKsHo3JGkCRBkZaK6zUsMZqXrueDs9x98xyndvy/6bKSdsoqQZrkaPKTITD
         +2HQGSSjfcMzEf5AC03G2mN7bZhCNPo0QSAPIRG5mrnYnmwcMygZB5vQTKpSK98FDzSh
         EPYm7RiZeFJMiqd7MyWc1CCDjFujHmo3qEnnhcKrnonJlLfqvQZRcQtYteACRCF2Y/FF
         qKhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKYB6t8dlorcsPVuurRd2v3ETLD8jEPF5/sGwThRWR0gFsce+OJ9BMFpnIFi/PPnaF6GE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnCi7qhlS2zyC3rNJawzvm4PQ2QWvQoy5mzFBAaY8FhP/+PHbp
	9vZG8z+2gza4yOJk4beEEKp2qQpuLhrXkbFU6ifH93Z8+7dDeHghzWtmnH3Bd6A9vIsAA3yTLO6
	7qQ==
X-Google-Smtp-Source: AGHT+IE3PaHVFO73GTuBHSkg/Bp1BYVf64Z5BDMiZlAp1N72Zy30VoStroBvnjGNz6tOuhVG9XuSt7nX3dw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:202:b0:e0b:a712:2ceb with SMTP id
 3f1490d57ef6-e1a2a5a664cmr12509276.5.1724704106889; Mon, 26 Aug 2024 13:28:26
 -0700 (PDT)
Date: Mon, 26 Aug 2024 13:28:25 -0700
In-Reply-To: <ZskfY2XOken50etZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-5-seanjc@google.com>
 <20240814142256.7neuthobi7k2ilr6@yy-desk-7060> <6fsgci4fceoin7fp3ejeulbaybaitx3yo3nylzecanoba5gvhd@3ubrvlykgonn>
 <ZsfaMes4Atc3-O7h@google.com> <ZskfY2XOken50etZ@google.com>
Message-ID: <Zszlab0BMPKmnOsy@google.com>
Subject: Re: [PATCH 04/22] KVM: x86/mmu: Skip emulation on page fault iff 1+
 SPs were unprotected
From: Sean Christopherson <seanjc@google.com>
To: Yao Yuan <yaoyuan0329os@gmail.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 23, 2024, Sean Christopherson wrote:
> On Thu, Aug 22, 2024, Sean Christopherson wrote:
> Intel support is especially misleading, because sharing page tables between EPT
> and IA32 is rather nonsensical due to them having different formats.  I.e. I doubt
> Paolo had a use case for the VMX changes, and was just providing parity with SVM.
> Of course, reusing L1's page tables as the NPT tables for L2 is quite crazy too,

Actually, it's not _that_ crazy, e.g. KVM s390 does this for last-level page tables
so that changes to the host userspace mappings don't require mmu_notifier-induced
changes in KVM.

> but at least the PTE formats are identical. 

