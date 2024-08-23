Return-Path: <kvm+bounces-24983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56DFA95DA03
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DE7A1F249BD
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2F11C93A8;
	Fri, 23 Aug 2024 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EBtOR7v2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531141C93AF
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457478; cv=none; b=QCoJ85V99gXf6uVdjKVoliUEARC+ichTAV+9Pput+a5gWr7QqtTUQGEOjXC1MQ/8wajB2Q8GtX2GhQQvPgBkSG3rhNL+pEVrxR3OzlE10/xG3kV5BgRLOpRMUf2OzkTT2KN5zWmGe4pWTciqSr5sSQzsu3/mmD2b+O2y79IqtHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457478; c=relaxed/simple;
	bh=LkldNvaKdcvU9URYXgrYnfMMfcgINQ+YF+K2hOt7k1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KYV0EyPHHTTmLbxLmwr2O9Rkc0+6UcqFENS6qN6onWIi883nZyTYDuCx6DYTZ5NkErfVbtA+sCPkSVvRi12cioMfhmNrTXQ6O4Z1Tc+A52tJvrWXTS7QeB4SplXOrldwgLhRuvAUNr4KYDVHDH1yDFODS9a+GVte+fLVdzd91T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EBtOR7v2; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b46d8bc153so48949157b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457476; x=1725062276; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n0PRyqHKJT2UMyjcGE7BkDjtVBvmp/URnSvR97Vs1IY=;
        b=EBtOR7v2m2h0sg1UB0wu+H7pKhYaUudl7peAfcfREDdjQ8fS+34f9r0DWwQLkYmI03
         JI9GZMBrd+9+/QTecr7xOTNV6S+x9dFIRV8WH7k2OudXJMGhBIT76gD6ovatNs1Jp2g4
         MSmXK9Gg8UATPKhv/Du8O1ScbcysYXANOI7bwz/RRwx4O3D3wn6n1NGv/2MStP28xeqx
         h1j/kIdoJWOb96eMBUz5imtFN+EB/R6mA1XD7DgA3bDNw3p6vcehhuJWWfenzzBaoICh
         Mj3Tw69Ys1Wb3aYetjrB16SucQQqolIA9eJhssxDYEM1uYYg6oikDNLqAtmSIglH5spq
         OIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457476; x=1725062276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n0PRyqHKJT2UMyjcGE7BkDjtVBvmp/URnSvR97Vs1IY=;
        b=oqPi+F7QL0m3UnDlkiVoqnMuGsfkc96+U2MLzJ+lajqGs7XZTR4RH5kw8bNj9oyNZz
         LJJn8Uz354l0hFdTQA98F2Ug+zfKupP1EPCUGMOIgeULGt5zYecZpM3ktFKnPXYraNPX
         3w2E2G/N2yE0ESfpMNytPQPuC+g0bgSK4VYrH14ff7i0+o08uP2aq+qA0lTJeDGghyRF
         AI1DptmCedD+GjfpNRjZsHvvw9SUgVP3eoRrXuc04YdOpm+ZJtlbI59kAbmf5umHcTWF
         ij1ys77fqAnTijIKnqGk9H7rywhogL0a5pNl857RvS+qazYaOTJJt+s3p6HpxHJ+QTXx
         6k0A==
X-Forwarded-Encrypted: i=1; AJvYcCVS5fZPhfrrvQKDxRVtYaRur3xXoUNwGXAZnwslYpE+OlsTV6s+6qUZyPh2caA6kMYRer0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB8E9b3f2aFOwfmCYPFqB6Cq9l++LTWsNkXvL//cB1Fb4ko912
	sjyPrXd+6HkxwqsT8+YxSD6BDUthXxkId3t9GyKkh3j+02xOC7ot9df5KAHFsyd5EmQTgKMfJTN
	ndA==
X-Google-Smtp-Source: AGHT+IEhuXYoftZjIkqydGWvHFl93y9jXPqChtTH0PTtaoI07HbHm0nhX8vddvzrzWs/4pPsQIwOPtePySk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ee12:0:b0:61b:e103:804d with SMTP id
 00721157ae682-6c61e8fc817mr685157b3.0.1724457476392; Fri, 23 Aug 2024
 16:57:56 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:59 -0700
In-Reply-To: <20240821112737.3649937-1-liuyongqiang13@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240821112737.3649937-1-liuyongqiang13@huawei.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172443887397.4129316.13296385938289953192.b4-ty@google.com>
Subject: Re: [PATCH -next] KVM: SVM: Remove unnecessary GFP_KERNEL_ACCOUNT in svm_set_nested_state()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: linux-kernel@vger.kernel.org, zhangxiaoxu5@huawei.com, hpa@zytor.com, 
	x86@kernel.org, dave.hansen@linux.intel.com, bp@alien8.de, mingo@redhat.com, 
	tglx@linutronix.de, pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"

On Wed, 21 Aug 2024 19:27:37 +0800, Yongqiang Liu wrote:
> The fixed size temporary variables vmcb_control_area and vmcb_save_area
> allocated in svm_set_nested_state() are released when the function exits.
> Meanwhile, svm_set_nested_state() also have vcpu mutex held to avoid
> massive concurrency allocation, so we don't need to set GFP_KERNEL_ACCOUNT.
> 
> 

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Remove unnecessary GFP_KERNEL_ACCOUNT in svm_set_nested_state()
      https://github.com/kvm-x86/linux/commit/c501062bb22b

--
https://github.com/kvm-x86/linux/tree/next

