Return-Path: <kvm+bounces-18974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0061C8FDA5E
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:23:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 099A61C2188D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8BB16C6AB;
	Wed,  5 Jun 2024 23:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4ogO40aX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2929816C43E
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629705; cv=none; b=QEjjxKJNd+DH/mvAGB0Nfvkfj/32gY4ztVfEMdhutoUwDymAD0I7bZDWVbnnZ7yAKg4t2L4+H3Khq8s0ja2WPRNrCxMOi4vtKpEWjE3dGzHyLTBnUpErjV9RxIceD9uUZ5Wq9U/ivGEUmZc+9qR/kqoyoTvLdWHK7af1etU7A3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629705; c=relaxed/simple;
	bh=egs6XIXRtcuWKVP1+iXEnRPXKKckQ6RfnGclV9cDrRU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=ArGD1Zuo02GruRpOALC7pRZ55rtU46qcy8OIy5IaDyPgujP7vU1Uuu235gwLHwFQOyjf45cZh7h9QlOhpqGn8HNJ9OO0OqL+jH/q4v2uR6MNrcY8MUB7+HJtVL0XVOAgtw0tQdIDIDW70r9VBRSFq0+6YzDgLW8zYVsqC5kcl+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4ogO40aX; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a084a0571so5125157b3.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629703; x=1718234503; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8di8EvmuYfVuKTnQqlep1bQDw/aaxrSP4CfLnqugpdU=;
        b=4ogO40aXWecLsH0OYXr5sDLZYb0FlSmt9p9lPGSezDkrkWdDkpx4TpPJ9vvoTfnfkZ
         KuFQv0Bdw6HcviyDiiPriy9CiLONre9pZcq3s+1lu84fZ019wd5R0nU4NSSdjpzefMTI
         78AioFllLpTzPn4s1kjwP76lN/V+s5gpVz3hDZbf2CjjjxO0ovxulD3NPY6B4UwHKKiY
         VdHZx85YZOJ00ZAZenagqWWGJr9PUh7RSovcaDCNExom8uud+qIvTf6jY9VTEUd2y49K
         Vby3MdsQvOteby0bXBx35x/q3l65mA4ovAj3c6bE+Da6CI0EtY7UHxSUcxiFxXlWSFtM
         VTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629703; x=1718234503;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8di8EvmuYfVuKTnQqlep1bQDw/aaxrSP4CfLnqugpdU=;
        b=j21NjdnafE6vKAEgh1uy/caxu1Ch2FdBdIi/2U346A3ZJK5UE3jIOk5XpM2WtTaxMJ
         lPii0UjrxlRo77r9EEe2RN8NFRCwPJAUCI6xgA0VwdY9tiL7/bd+OvRB02YkjQJDuedM
         kPjiVQ3ZEf0vD3QODhTtfbFvDagySqyP/Sk9H8OpY3a0R0cALZFt9lXA9DYhfWrA2UYU
         vP2cBFYKiW6zLr78RGAH0jT6fhJfLSxSKRqWvW0JreelrG4lW0eQHBJ57s0ciWHhXk4l
         n/YREUTmmRC4lXQvGyi/UbxDnRg89NQ4fiSq1YSbOxPL9nt6lRtovDq2lDuTldU6RQRQ
         wb0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXdxn+JyG6x6Wo5Q7QKddoML065AezY1EbhU4TWF7FmFTBEYa7INtWLGViBFhjoLwD/qvhqw0Uc0PvfAH5IvfWDjQ8E
X-Gm-Message-State: AOJu0YyPN9CSejouqZZTAxKnRAZHS2ky8wPE8eOyQZ8IaQpW5jGK4iL7
	leeMFD3Tn3fc46WJgnoKS/2mNBWM0oTClSZJAqbPWIM5d2hjDGqi6ZiqUBAxvKIsL+qmGLXhetr
	ljg==
X-Google-Smtp-Source: AGHT+IGjWqtybWnZhvCr1aTYakBUhpB5H7vrAQAq95wsmH4jqd90mGA/ZdZLhqGaZQLXR6xf5rpx30SO8GQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4a13:b0:627:a7b0:3c9e with SMTP id
 00721157ae682-62cbb4a8c11mr10672157b3.2.1717629703197; Wed, 05 Jun 2024
 16:21:43 -0700 (PDT)
Date: Wed,  5 Jun 2024 16:20:42 -0700
In-Reply-To: <20231211185552.3856862-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231211185552.3856862-1-jmattson@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <171762873399.2914135.15218619020791299377.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/5] nVMX: Simple posted interrupts test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 11 Dec 2023 10:55:47 -0800, Jim Mattson wrote:
> I reported recently that commit 26844fee6ade ("KVM: x86: never write to
> memory from kvm_vcpu_check_block()") broke delivery of a virtualized posted
> interrupt from an L1 vCPU to a halted L2 vCPU (see
> https://lore.kernel.org/all/20231207010302.2240506-1-jmattson@google.com/).
> The test that exposed the regression is the final patch of this series. The
> others are prerequisites.
> 
> [...]

Applied to kvm-x86 next.   I tweaked the commits to exclude the new tests from
the base VMX test, i.e. added:

   -vmx_basic_vid_test -vmx_eoi_virt_test -vmx_posted_interrupts_test

to not duplicate coverage, and so that only the dedicated vmx_posted_intr_test
config fails.

I am hoping that landing vmx_posted_intr_test motivates me (or someone) to
actually fix that issue.

[1/5] nVMX: Enable x2APIC mode for virtual-interrupt delivery tests
      https://github.com/kvm-x86/kvm-unit-tests/commit/eef1e3d21e5a
[2/5] nVMX: test nested "virtual-interrupt delivery"
      https://github.com/kvm-x86/kvm-unit-tests/commit/a917f7c7e1e2
[3/5] nVMX: test nested EOI virtualization
      https://github.com/kvm-x86/kvm-unit-tests/commit/d485a75d8c52
[4/5] nVMX: add self-IPI tests to vmx_basic_vid_test
      https://github.com/kvm-x86/kvm-unit-tests/commit/3238da6bc526
[5/5] nVMX: add test for posted interrupts
      https://github.com/kvm-x86/kvm-unit-tests/commit/765b349b6c4b

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

