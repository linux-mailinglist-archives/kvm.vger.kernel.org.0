Return-Path: <kvm+bounces-58915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3C89BA5993
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 08:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D8A82A7D0D
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 06:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD073265630;
	Sat, 27 Sep 2025 06:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TeG5ezhk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5554258EE9
	for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 06:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758953358; cv=none; b=l97DInIXyQ39XjUfi91vGm2n1ZPeJo1cIbzyKz+WBKXmx16KsOKZayzvaZFCBsNFhzLa7VwhiNRIehH03UM1ciKCdMGuvfEwfAr8n4rbHnoI+ThW0TucRn4iQLgyUJTe1JUshIX5FF5fyQSdHThx6VmtxRzAnrxJvJNRJZZKsaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758953358; c=relaxed/simple;
	bh=y2yws3+NpcsaTB6NXd3/JOBV3hDkvgOsvG+qlp0uA74=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TU2DWvVrY1mYEPkqpaylt3xpXGGRUrL0/3hwjqdNCqiIExbi+jhIovA9ORpYWWBspEQCHSRG6aCLqL6lFCGfQ6a66cnahv+RkeqharIhWPo3dwmfRk/f18N4f/CYbtpR6Alw4RcBLI2m3BI7D23jxmJtA8K8X8klChRbdxNqIi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TeG5ezhk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb18b5500so4684044a91.2
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 23:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758953355; x=1759558155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2km8KKp/bEND7YFyu16DgLGx/owQo7hlqDHBsMlmrXs=;
        b=TeG5ezhkUrxub1OjKzUdMKjRYqdwk78DmQZj9IAEVSHzHI1XKt+TOKGlCOiL/R+Fzv
         kvj2fo/nVtTTe7e8d36D6ajDb21+EyS2T/2slkDtnk0X1qtTpZsBSpivrJfoimb2faWE
         1IP8ha9tns5pSKqg93/STh6/SKS3HIoCKLGolR0r7GzucnDOA4Nktk+lCpjrNIXmZnlU
         /H01f1gPfMacAzAQd7bv9vCS1O6qCM+6DvdBsy2tltSi/A4qH/crclENW9QTYrzqnD8y
         ZeZ0Ahx8laXc5kT7iy3mvWWGO+RQ50DLj50y20N1xcx/XNLl8xrPFP/FxKakfYMyKl1A
         f25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758953355; x=1759558155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2km8KKp/bEND7YFyu16DgLGx/owQo7hlqDHBsMlmrXs=;
        b=Mb5ey41KFkPObGcVpNDI4/IBkleBj5Vcs+kzeHyyGdGyNYOABfzPK1+UolvsvUTywe
         E5YMH/Ru/FoSCOVc72RdHJBDZi6n/mRLGA3RJ4lDz7RjOIiXZlzQ0BntgO8B3N7FE8pM
         2Pf64yxStZsqZw9zOTkDiQSu8E+iyACjN9MGMbFY2nfzhvuh0lSB8VsDUV7NAmVR9uUQ
         uRZijAcBk+T1DOEspqeszuT7nHtJEt+GBh9pyHz5yJY27XxsgraPxXSORQ/mVEjAnTC2
         KSiPU/K6a+HKS7X6GtaprlsHfp2GcVxrDWu17Pyl59VX7+ogZvfiBqT+hKDzT7Bp3of9
         KenQ==
X-Gm-Message-State: AOJu0Yx3XmWiF1yah2kU4EpztFjf+bQ4R5gaOcHBqEyD+XCXOAWz3/6r
	1WSQhjOuwCnz9OZ/ipbbiSoctQnsjuxaeOjeNKNFGsBLNDB8cHkIkVHd/9hC51IvOO4/14yWCUJ
	rzyIDIA==
X-Google-Smtp-Source: AGHT+IEW7d8Bk+rK1+7DyLeplN4ydtI1La8p+qsrv2c2Z716HNwcYwqLW8xk/5sEAErJLTlOdoPr0UMkiwE=
X-Received: from pjsd18.prod.google.com ([2002:a17:90a:bf92:b0:32b:58d1:a610])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:582f:b0:32e:749d:fcb6
 with SMTP id 98e67ed59e1d1-3342a26b3acmr13022312a91.12.1758953355122; Fri, 26
 Sep 2025 23:09:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 23:09:02 -0700
In-Reply-To: <20250927060910.2933942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250927060910.2933942-3-seanjc@google.com>
Subject: [GIT PULL] KVM: One lone common change for 6.18
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Tag says it all...

The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.18

for you to fetch changes up to cf6a8401b6a12c3bdd54c7414af28625ec6450da:

  KVM: remove redundant __GFP_NOWARN (2025-08-19 11:51:13 -0700)

----------------------------------------------------------------
KVM common changes for 6.18

Remove a redundant __GFP_NOWARN from kvm_setup_async_pf() as __GFP_NOWARN is
now included in GFP_NOWAIT.

----------------------------------------------------------------
Qianfeng Rong (1):
      KVM: remove redundant __GFP_NOWARN

 virt/kvm/async_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

