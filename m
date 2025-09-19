Return-Path: <kvm+bounces-58167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE966B8AA10
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:45:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7CFE17EFC0
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA023218CC;
	Fri, 19 Sep 2025 16:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vvZ+yi/q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D960E32126C
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 16:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758300328; cv=none; b=Ewwr2jWfVy+tBKyTftoVzJtnxCt7VVlRk1Lj5ya8J2rjNBwm6gYUES1I/qcijexYS8jN95fJH+UxoBzyWZJ3YNS2bWAoekHGSRz7Eg3nThU4411qMqWdI+Tsl+sAKrvS1/BQEvoT66MxM66EN8hCy6UNyE0I1wftYKf4sDjFJGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758300328; c=relaxed/simple;
	bh=4Jl4b+TQt1iBgCuwjRa1X6WzJpTuiAvPCOLECxwMuQA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=coNif50WkqhrSJiApz/Fra8imdqI0kvVcVfWyYdBpqh3BqlF6Z7ToLNacuKKeCV/7B3oA+WnGQCLmYS+TUjjVOEgT41Ymr+mdjK8GvuidzgMe9B0TXtHEWEL7xp6zkSmESFQE5TWrN5OTNq0zrz2FwhX4+Kl3BOe4leBfjt7sVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vvZ+yi/q; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so2342377a91.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 09:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758300326; x=1758905126; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X1nnJthUex3LxXClf3ZWBj/Urv1NZBBRzKkjcWwYkE4=;
        b=vvZ+yi/qmVrT2zkfby2cZKe2K+LmB6pZT89bJBzaQwrAvOPWWtZpC32z2mA/38NPwM
         fAelpUrwS3V9H3XOVMO1K41Vnb3i+lHvpJnn6TtFVen//qa6L2Rd9/LqLqRMGodkxh0t
         8otyNuew7FAP+EFzjvI5m0JTybQc7vvnM/Bg+/ylwiZ/bSEqvyHsYZt6NKS1fPGtqQ1f
         acSfLinn05jVvevEePDQMimk4HKh8su+dA7qUojnWphihmciI6WbhtMK2aRg/NaqmN0E
         SNp5IF2ZzOaLM1Nu5uzLPiUZgrybvE8Eh1k/cuH4DtSGUmpDKL91nOW03s0ywCbfVv3x
         amRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758300326; x=1758905126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X1nnJthUex3LxXClf3ZWBj/Urv1NZBBRzKkjcWwYkE4=;
        b=xD904Ve/e2LYk2OcgF7GyTKf9xOa6mtKi2CV7DzGXoQN6wj7SSAQ5pl5nVkzShN0MV
         Zfb1p09OkWLYAmeFrJkuGQxtcH3rQr2hyob/RYyc5yL/ma0ynXY5/rwciPtpbBYhN4rp
         u/P+BXmGkBdeQTQEJe+g+kzR5lEauDXLJVy4pn16cbxnGEmt3fXccj9wqPippp0+e2Ip
         49nr3s/2AxvcYh//Ed/t1We8cScrX9WOc34QuILYNAliz6PAvJtV0fjBpV2mISu39wOX
         BfRLY5YI2ZoNgU21tCYKJzt/M9g8ZYXR7Zx3rst3r3mljmKZlZNCSU/jYvpMb/2xIPW7
         lDlQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5QOPf8/eRorSGkJStp/3TA6I131gdQkGoZ3TjjPiI8Fj2/gjTJpKGBoVkHDNva8TC558=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMG15s08k1Q9V2guQ1SH406AkTYzWaiyzYuuwBO3isDni21RzK
	vynQgrr2cvean2E7m2UevqIr93BK1+65JmlkE5xkzuWOOhjKPtXo8XHEC26j4WbVvoJ0+aYXyHo
	v5d+ZpQ==
X-Google-Smtp-Source: AGHT+IEkeqaBv11XZ/Y8nTBa0aollD9HhQyqe0axcVy/GRH8URrHRuMPybcd6MXLv6t3NLWbsZy8inMIMFQ=
X-Received: from pjbhl3.prod.google.com ([2002:a17:90b:1343:b0:329:7261:93b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3949:b0:32d:dc3e:5575
 with SMTP id 98e67ed59e1d1-33097feda0fmr4385119a91.5.1758300326133; Fri, 19
 Sep 2025 09:45:26 -0700 (PDT)
Date: Fri, 19 Sep 2025 09:45:24 -0700
In-Reply-To: <aM2FQiC7_8tLgKgd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <05a018a6997407080b3b7921ba692aa69a720f07.1758166596.git.houwenlong.hwl@antgroup.com>
 <9da5eb48ccf403e1173484195d3d7d96978125b7.1758166596.git.houwenlong.hwl@antgroup.com>
 <9991df11-fe7c-41e1-9890-f0c38adc8137@amd.com> <20250919131535.GA73646@k08j02272.eu95sqa>
 <aM2Dfu0n-JyYttaH@google.com> <aM2FQiC7_8tLgKgd@google.com>
Message-ID: <aM2IpICmTm3gEeqR@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Use cached value as restore value of
 TSC_AUX for SEV-ES guest
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 19, 2025, Sean Christopherson wrote:
> On Fri, Sep 19, 2025, Sean Christopherson wrote:
> > On Fri, Sep 19, 2025, Hou Wenlong wrote:
> > > On Thu, Sep 18, 2025 at 01:47:06PM -0500, Tom Lendacky wrote:
> > How's this look? (compile tested only)
> 
> Almost forgot...
> 
> If the suggested changes look good, no need to send a v2, I'll apply with my
> suggested fixups (but definitely feel free to object to any of the suggestions).

And talking to myself...  On second thought, I'll officially post a v2 so that
there's a better paper trail.

