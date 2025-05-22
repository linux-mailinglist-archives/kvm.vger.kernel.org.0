Return-Path: <kvm+bounces-47420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C418BAC16F6
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 00:45:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2546F1BA8388
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 22:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1170A28B411;
	Thu, 22 May 2025 22:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v+mAW5sB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D762C279340
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 22:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747953948; cv=none; b=RBoPCJt9JQQWP6vJC/9KaPXRaBU6Ld4LTixIR71KwyJk6AC5XHWAAMvirjWbq/7Cd+R1ImWQJfLliWdiSwewl6qBvD9yaZcJpclifjYCDQC41bBm6A2hr4mnqEJPTur2pl9SSn8PO7cUeqspPqWfBA2hy3ZQMuuUWo/DyVQFbcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747953948; c=relaxed/simple;
	bh=/4BQCi3jvtdajWus3hg8cgl7J4SS003mjq0vewuYalU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eUKd9Be3T+F7XOeXDD/RSemsTNSLLt1vD6h5UnLXOmuW7oORU+uc1OOMckzSgf6/vsg5/Gigk6JdTmHzg1Tmoyw6A1VfUyjJfBZqd2xvjQaPHAntCORRc6szZgj5efFgpbSFx7fl4NSR1dO4S1V9WzyTrnRtHdYDe4M4EmTpSug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v+mAW5sB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e9e81d4b0so8116211a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 15:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747953946; x=1748558746; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3AxTb6qkauANJSLdkn2Rljd6hCnTnUjzlT97QXyndHU=;
        b=v+mAW5sB08j8mcvPFv1etBdGmFTXF+tdNSqKzpIpP5PjfLhbNj4ayMDx3u1XwERfEo
         exB629+dvS3UypmzpkZL5FNmBu4ucDdrTYOdk+ODGw53ba0S6hBN2PV+bkqRen0o/MrB
         xILTh5r2U40UKdvarjrYe4orlNKiFMdMc7+n2+PbstsVI1DTOh234Ak4Zfdsi5nzmrTD
         UIEhVLYo9K57Ht1yqfdaOq8oLfuuYuSGtzQahHI7soJrXKqgf3tWOoqJ3OUXK4jkAFpT
         Zq7ao+GnLdyalnA05grjWnIPHQdK7hocRgf+/YE7mNpWPiPCfKUwLB6bR7XBN65XU+hP
         PN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747953946; x=1748558746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3AxTb6qkauANJSLdkn2Rljd6hCnTnUjzlT97QXyndHU=;
        b=elgrk56+g/HKh6YDKRY/BH5mS0PAVKHkUu9zYht2hQWNHvbdH3itTklSQxiE98WdRF
         pdO3e0/o6bhQbQZ3AoK1L5rDW9J60V62xQfV7jqVYmae1d4qgBY38l0ZU1yHG67CSD2k
         xecEgN9SZblaI+H85UNWV8ofg5EXJKjext00gKuPcg/S9cXZDmYOd+Z02ZTtX/LHNL2w
         soT2lyY5hFQLN1SuOP3RmxoWow0bkT5y81XNp1GoobvsMOBUtMfuZFPghufrYJuXNhXW
         qTNYMLjCj8CwpF8Zi9A6erKb1R+5bnriTdMCHJcg2HM4R3lp3LSwk91QLtwJmcNEUYuK
         2rng==
X-Gm-Message-State: AOJu0Yy7xnURuPBukJbAUbRVb7uiT5HvjuS85dqkoRUYHZrgm2alw9sV
	rILEtWZhiBwG7pp/Rv2fOC+PBZABZ9+K5ci3sF5KTdN2SHUi8kZpwTE/2Nj2DBECh8KXVWJr07V
	aIVJroA==
X-Google-Smtp-Source: AGHT+IFNKqqHdblFbUk9DQFGyS5wY/y/pndJWF/GWniPdnZ6giU/V86VRHJVAeoJpjay+iWJes8jG/Z7ph0=
X-Received: from pjbpm9.prod.google.com ([2002:a17:90b:3c49:b0:308:64af:7bb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c90:b0:2ff:6af3:b5fa
 with SMTP id 98e67ed59e1d1-30e8322592emr33592948a91.22.1747953946139; Thu, 22
 May 2025 15:45:46 -0700 (PDT)
Date: Thu, 22 May 2025 15:45:44 -0700
In-Reply-To: <aC9npqQAAdowxfsn@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522005555.55705-1-mlevitsk@redhat.com> <aC9npqQAAdowxfsn@google.com>
Message-ID: <aC-pGA3Xv3O6STuJ@google.com>
Subject: Re: [PATCH v5 0/5] KVM: x86: allow DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM passthrough
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 22, 2025, Sean Christopherson wrote:
> On Wed, May 21, 2025, Maxim Levitsky wrote:
> > V5: addressed the review feedback. Thanks.
> 
> I'll send v6 later today.

This ain't happening.  See the conversation I'm having with myself in patch 3.
I do have a refreshed and tested (ignoring the nested mess) series prepped, i.e.
no need for you to work on a v6, I just won't get it posted today.

