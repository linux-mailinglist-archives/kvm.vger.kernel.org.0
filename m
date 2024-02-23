Return-Path: <kvm+bounces-9573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EAC9861D79
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:22:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6284F1C233FC
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C46E146E7E;
	Fri, 23 Feb 2024 20:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="USxebXXe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2048D1448FE
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708719668; cv=none; b=RkiSnRM9RgwVm3Oje2v17JtIowqB/NFxHBOlbDC3DuD5D4i12l+ZvcnvdKOetO/pbNyRVvfy3nM1u4vUZ13OJ5Cq27AP+TM7Me6qoEIGc4K4+XiGJDsQVLJbJGh/rvYvXokARbkII32ZiZ7bvTdYHasiwGb/BIFCC2HetOeiy3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708719668; c=relaxed/simple;
	bh=1bmnyFrNrxcCLjE3S/+oXjFKsestIbMgUBvvfSSy+OA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IS2yOyMqgnW4u+5dR4kxdsWGRCx+KTQfn16Kc3lYdVcUCb5VgcNlf9A5pvuL/3Ww+Ddk3QbE3feJzh/7DodaYAMiDo6+MNCnuxQpYzZYMFwPv02jzH/SeGgzQapDMY+PlZGJbbcv/igA2QKq8ZkvAVNptYa1icUHw8OekHRdKZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=USxebXXe; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dbfc059751so10703415ad.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708719666; x=1709324466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMOKrbIKnJ6TKtSp5dRNn05/ENEXJGPDCIutix2Nmno=;
        b=USxebXXerT99qzSHcujpnpMzyGBUM8k2BxQbJd2jwZFxX+o4lcuxA9mVSpnWg0rJVY
         Kh7u8oj5ILoFJpTL+XbWBtSsYonNzWRV2qLiZPAQrxgoxLc+fcuunZqiOpzhw8Z8ZNgB
         13qvrO1s2o1WFuV+7cobjzrIwSHjv+EUKrS1IpWJZ9D+yGvCfXy86HvnQpWhWEK6xKuE
         RHftZI8TQWvxYxJkl6ZTPKLwNu0zwEJazYa03xKVda1Vh5vPqgaWzMyWlY7cY3kGrXlf
         RsywgVZpe4xgc+JgMI0RUMOfGhAD1HMeMK6+gcIqxsnFBLHBx+flFHi7d6ArGxoWxd3h
         XjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708719666; x=1709324466;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uMOKrbIKnJ6TKtSp5dRNn05/ENEXJGPDCIutix2Nmno=;
        b=tx/QHTf63n/J/JQkwguurD3wp5T6t+jROeM+115JTN4BpScrG+yXGoliVCdVtO2LGF
         nJwYJDP0xYBBCgeBKrC8Rj0ZdzeIM3jznTa11aNWaefqaF7s/xtw6pCqIDKt+hFos1c8
         nKKb+uOTtEoZQ6xg9FJEh5gVSG9ixfr4wvQNDClLksUv6E+OBnsXPQZsQAvA2gcSRIT/
         UZCTNbi8fkRLqMvqsZLqzetGugS7zuAx6rPIZMUbLarOVspVOTox1Il/O4SCpgz88b4h
         ovwOeq+pK31fI/6H7eCHhEiOntNpBopDHVSXdeg3VfXFcIKqoeCSTbEsKzBR13t3TtXN
         NmIw==
X-Gm-Message-State: AOJu0Yw9Fiero1xaG4450rqmo3Kh6oNzm9Ncwvp+FCnO6SppxU1wIcBo
	W5tMTAUSYb76fVjYsk9hcizFeikRH8ses5dEYyaIdVYFoK/ljOvYRcIpjnX8ofmLBrDdIqA4nna
	3pg==
X-Google-Smtp-Source: AGHT+IGAiiFLABQHhdRPopaK/78IVe7JcLUV+v80lMlmvMheOafreGID10sjMpfQSo848B2ZgsL84/ldoM8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d50b:b0:1db:cf63:b87b with SMTP id
 b11-20020a170902d50b00b001dbcf63b87bmr56644plg.7.1708719666432; Fri, 23 Feb
 2024 12:21:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:21:01 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223202104.3330974-1-seanjc@google.com>
Subject: [PATCH v2 0/3] KVM: VMX: MSR intercept/passthrough cleanup and simplification
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Clean up VMX's MSR passthrough code, in particular the portion that deals with
userspace MSR filters (KVM needs to force interception if userspace wants to
intercept even if KVM wants to passthrough).  As pointed out by Dongli, KVM
does a linear walk twice in quick succession, which is wasteful, confuing, and
unnecessarily brittle.

Same exact idea as Dongli's v1[*], just a different approach to cleaning up the
API for dealing with MSR filters.

v2: Combine "check and get" into a single API instead of adding an out param.
 
Dongli Zhang (2):
  KVM: VMX: fix comment to add LBR to passthrough MSRs
  KVM: VMX: return early if msr_bitmap is not supported

Sean Christopherson (1):
  KVM: VMX: Combine "check" and "get" APIs for passthrough MSR lookups

 arch/x86/kvm/vmx/vmx.c | 68 ++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 39 deletions(-)


base-commit: ec1e3d33557babed2c2c2c7da6e84293c2f56f58
-- 
2.44.0.rc0.258.g7320e95886-goog


