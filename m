Return-Path: <kvm+bounces-48859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 145D5AD430E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:43:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF5013A4239
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD46264A65;
	Tue, 10 Jun 2025 19:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iISNZh24"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95573238C20
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584609; cv=none; b=LwVCcDczEjrXN5msm3JD1th1wj08flcVu+aG7AHd+qwjI/jTROu8n1Adk8LeBMcYrQEGvthlK7lPGJ/mlwTZ1V7aKdLzbi0hdr482VlAsFes5rEPc1vNwe84A2D5vlI4+Wo0LSsYBEad0pjH8aGPf2ON63t2ec2oLMjCSoCIhsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584609; c=relaxed/simple;
	bh=EDJBS9T152wNLom3DaUU0B084NyWDFLWux5PKe8FnHI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z0f9/PQ/mmbIZfdRBNPOmb5s/fe86SSRht2KRG65j7Nnui7XAiJcyht7ZjbuePYiBfslkxvwwAnThxqo6o6QUZkLjpjzZLAaHe4kkrsCK8H9uQBWwv2DQyiF9HRYwpbc/SFPdfUmnIuNB6vRBslxDQcsPgqCUUDFEhe/h9SmLjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iISNZh24; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-740774348f6so5015608b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584607; x=1750189407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lqa3tWEOJqLNTjVF/tXgpu07+v6EAYg8U103GU74Ybk=;
        b=iISNZh24aAJKMi/eV9Fq0OnX//6sk2O22yGcAdxB37v60S0AQItTdSe1QtNfqTVwBz
         BtDijcR9l5SRMF0E9KFxAgGlcc3Vj925d55JYENBGThYYIcDJIm5727BNWxnb70xrO+9
         nEXeBZzcJQrnBbQQf6gB+wRmm+RbGiX+wE39GYXFKqicyeOLjgTXpSvHewyOGyDzgjuo
         MjLxKj3r+RU0+egJlCdvd+/L2RlkDMMTndchwveMJhIkJKteB2QhzKguJfM1/hj17QL/
         AMLja4UebKf4fXzHZ/vSSQmjiFdIOPYgOET0xCCzB8giQUIhm/LFmvgP+jDK5AdH/ZSZ
         DYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584607; x=1750189407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lqa3tWEOJqLNTjVF/tXgpu07+v6EAYg8U103GU74Ybk=;
        b=EyXA+yQ6amf+p35TrAa3YVVh4IISlVfzp4QgjxwNAku6fZMBB7OrqdvTujrs3q7iYB
         rWvTk7npLa03n6GYMsFwl8t6wFnZxepvUw0Ny6jcxlcki88DA3oemWV0eEl0UNqF4brJ
         ZdJCz3AGBVLP3ZfBB6oA+Y0aPTgk0AIUrP7x/NK3EY6bVXBC8TYCPZiCiNMjo0xHw62K
         WkdAYWq31+M+vvzBaqggv9g4lHvAW3w0uQ0MHvipQf35FTprKwPbq8j8836Mp2yJUKW9
         RNJSVsyeQioj4a43SvXZDdiQB0rM/IQDGYZPkoMFGoAlpFDVd3pShd0uU0pVYh0g3jp1
         lVIA==
X-Gm-Message-State: AOJu0Yxs8qMyRCfcSolXZZlhKKPuV0llH7IbtwHFFVbUlxY/TuYoO82V
	gP7TtZ6jnqj5hwjkYKcVlHgKTDZuk0vH9ltg+PSHhcV3MZC0icsBRYU3QqMWG66r9FxPFA51BjZ
	NBLBx0w==
X-Google-Smtp-Source: AGHT+IHsW4KUy8wsZ8ekMGekB+UaecO1PLmiQibaIvX0Xtvzuj4YAoQd8g8zZSPah52npdwXtPzu0lD4iiE=
X-Received: from pfbdw19.prod.google.com ([2002:a05:6a00:3693:b0:748:34d:6d4f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9287:b0:748:33f3:8da3
 with SMTP id d2e1a72fcca58-7486fe7a2dfmr60173b3a.19.1749584606903; Tue, 10
 Jun 2025 12:43:26 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:26 -0700
In-Reply-To: <20250605192226.532654-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192226.532654-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958166664.103414.4678286267318991320.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/8] x86/svm: Make nSVM MSR test useful
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 05 Jun 2025 12:22:18 -0700, Sean Christopherson wrote:
> Fix the nSVM MSR interception test to actually detect failures, and expand
> its coverage to test:
> 
>  - Out-of-range MSRs
>  - With all other bits in the MSPRM clear
>  - {RD,WR}MSR with interception *disabled*
>  - That L1 and L2 see the same value for RDMSR when interception is disabled
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/8] x86: nSVM: Actually report missed MSR intercepts as failures
      https://github.com/kvm-x86/kvm-unit-tests/commit/27eeac46fac1
[2/8] x86: nSVM: Test MSRs just outside the ranges of the MSR Permissions Map
      https://github.com/kvm-x86/kvm-unit-tests/commit/573d62c697fe
[3/8] x86: nSVM: Clean up variable types and names in test_msr_intercept()
      https://github.com/kvm-x86/kvm-unit-tests/commit/165c839cc035
[4/8] x86: Expand the suite of bitops to cover all set/clear operations
      https://github.com/kvm-x86/kvm-unit-tests/commit/9fb56fa18056
[5/8] x86: nVMX: Use set_bit() instead of test_and_set_bit() when return is ignored
      https://github.com/kvm-x86/kvm-unit-tests/commit/a594bc6120d5
[6/8] x86: nSVM: Set MSRPM bit on-demand when testing interception
      https://github.com/kvm-x86/kvm-unit-tests/commit/1c7e7d1c7b57
[7/8] x86: nSVM: Verify disabling {RD,WR}MSR interception behaves as expected
      https://github.com/kvm-x86/kvm-unit-tests/commit/1e2a6424a1d2
[8/8] x86: nSVM: Verify L1 and L2 see same MSR value when interception is disabled
      https://github.com/kvm-x86/kvm-unit-tests/commit/bbafc5776737

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

