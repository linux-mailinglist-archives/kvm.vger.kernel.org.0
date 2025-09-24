Return-Path: <kvm+bounces-58699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D433CB9B8F5
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93C063B2815
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8491A319843;
	Wed, 24 Sep 2025 18:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RU4anlX0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520BF524F
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 18:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758739523; cv=none; b=AerBKNe8sPswpwVi3T5NkwIyasG5Ggt5F3O23Di2L0+QTL6jS+0v0iKEGyazHz6J7S8ayzyAoyVmpgBl1JC2SXFWGfNOykddL2JT3PDt+xPPQV2O0JDUY3LboLI9hNetUkIUtQJ5Zx5pQoUPWPEIJ4HD7komQ2rCRzSonv1zZf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758739523; c=relaxed/simple;
	bh=Lux3sbRLdDVcfZqDHkK5B3VxvEzuH7zstz9HCkeka+8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sV2fa8Fwpyhh/UFaZge56jEJJdwxjdE3GF8zhl+RPILS6mSTb00Mf7LwWXoIfh0DixaYLSvj0A6qFt8TuhmiTG9R46PMbFBbzcIG6KTgu2kVxvnp49WAOLYxpKQAqgQGyTVfY4ciP/rdeDP49GQYbcwHQGgsG4Tb18h3hY65oFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RU4anlX0; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-272b7bdf41fso1302155ad.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 11:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758739521; x=1759344321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PuRg6SNsqixaTOVmmK3uOTfxD/fSeqR6sejXpJN0UP0=;
        b=RU4anlX07u3t0wT9zF2yA18TBUbRmrS5iQ11g/kU/AkGY7TextMWSlI03OyyEgX4+Q
         yIFtrZ+qGziIJFHvkc9Dl28wldYlRMTSuWvQPjUPTBzO6E4fjUpRM1lbzNvdPd4T2mLk
         O8LGR/9ICeu//v+aSRMbxlM8BEZnG6XpL8cygS+rCIj1PkyUkfkhY1xHZb6CcMZ9LcXq
         4dDYOdP+2Qvs+VR6+pOzIjgl12JsR9xrM8E2AXblcb0G7Sm1Hxd9bbyAufVXA7JelZiI
         x0h5ForbFv+5t7yGaj9chRO69ucHV+WGMCJ3yr+COd4yKkblHVHanvgB6usYFMWRWU12
         Golg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758739521; x=1759344321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PuRg6SNsqixaTOVmmK3uOTfxD/fSeqR6sejXpJN0UP0=;
        b=wR8zJAFO7je4mr3M3NGutKNIurSiI5k5huW+uDziaOba2kUfmjLJyTqqOb2k9YSz4m
         +evuPi+7XVDzRJEKq6FSZEtZIz+Ce/FMnum8EM4PXgcdCErYVgvtjPqhJ19p3Vj+F5eA
         UOooFJQS+q9z1TtVKAjRJy2YWBEdyfbUFp/bsY3kbFmho2c6ua0yuRbRfFVGasXC6ujC
         NZ0wVvRfvAuHV9zrmhbwP5QMglVBShcJiJhkprdjld53QKFCxMfAi7eO1AD6SRcLeFGS
         KgXSevmvCSXZz5N4+8yIQOQKn7WfArQZVD3NIbYzRI1W75MnEC/3NY19GgDoGkpk3r4x
         dzkg==
X-Gm-Message-State: AOJu0YxEfingjA0OIaghjuXOBd4HJQyUeGfnEsUKisB0vtATQ6AYfyxL
	ag0fRG2PSjUnsGx9SUcG+P5EvEazjPCotVrl0sMnvZEqvyLyARuzj/pXXgxMx4cAyaQn6NCkQyQ
	QS4+55w==
X-Google-Smtp-Source: AGHT+IFKjoeIQvU+5qMuE3xLff/oP/JCX0j8XzLHJgmDk8X1MKu15hv5mG7VqGvTSem8tEiUa9GMntO5xhI=
X-Received: from pllb17.prod.google.com ([2002:a17:902:e951:b0:269:7051:8e4a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebd1:b0:267:cdb8:c682
 with SMTP id d9443c01a7336-27ed4a315ccmr8753205ad.30.1758739521650; Wed, 24
 Sep 2025 11:45:21 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:07:43 -0700
In-Reply-To: <20250923153738.1875174-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250923153738.1875174-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <175873605243.2144113.4486198413338077399.b4-ty@google.com>
Subject: Re: [PATCH v3 0/2] KVM: SVM: Fix a bug where TSC_AUX can get clobbered
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 23 Sep 2025 08:37:36 -0700, Sean Christopherson wrote:
> Fix a bug where an SEV-ES vCPU running on the same pCPU as a non-SEV-ES vCPU
> could clobber TSC_AUX due to loading the host's TSC_AUX on #VMEXIT, as opposed
> to restoring whatever was in hardware at the time of VMRUN.
> 
> v3:
>  - Collect reviews. [Xiaoyao]
>  - Make tsc_aux_uret_slot globally visible instead of passing it as a param.
>    [Xiaoyao]
>  - Mark tsc_aux_uret_slot __ro_after_init.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/2] KVM: x86: Add helper to retrieve current value of user return MSR
      https://github.com/kvm-x86/linux/commit/9bc366350734
[2/2] KVM: SVM: Re-load current, not host, TSC_AUX on #VMEXIT from SEV-ES guest
      https://github.com/kvm-x86/linux/commit/29da8c823abf

--
https://github.com/kvm-x86/linux/tree/next

