Return-Path: <kvm+bounces-21418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F8B92EB94
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 17:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C601CB22FA4
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 15:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4493D16C857;
	Thu, 11 Jul 2024 15:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HZ55JdPF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44D216A94B
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720711414; cv=none; b=dDDf+wWIbdza+6ctZjs09gLYDymHVg5cMnw1cZFf7XP3NP9CQG+7S6c3TWO/PiE+3Iz9jUbru+oNeJaenRy+z217UQUiDAMClktvaCr9uueZDX030K2LvegQdpYeRu4YLdPDwt9GjSMs8Ov67li8aG5WIZIMCRfQFHr815AeFTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720711414; c=relaxed/simple;
	bh=3Wn/GxQ0NHfPCFbxjx3KlFCa+8NIG1RotlGrhinnev4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W31aK3aCVMgCl2gusYkJe0CgV8H0hWATDO8UWwgf8lf1GuRRAj6djwL1RRa5ZiAi03tjuIGfSafde6OfoOTHXpebubzkiJE9h5G0ovM6gzX2XsBkgXmpgQw7+pRqoaRrnxv0XCLRXiICE2NY71M+sViRB6DOLV6R3bDopjGyNSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HZ55JdPF; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-58c0abd6b35so15900a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 08:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720711411; x=1721316211; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fBJvc8j2q1vfKURWwRE2Qa2GxAWgYuXKShoXDnQ45TU=;
        b=HZ55JdPFw7qbzYzb4Q6Xh8LCgdQ8oVU7WHRx8WDLcsJFhqMPmNihXmp2anpeAVIhK5
         kcttWuvFjuHeWU/Yqgr/pJ2j76k8cHGH7nMYS9Tq42WlqddTSWSKEgd8iUL+LgvXBfnw
         b7KUGhdSIqw+VvNyAgJO7ml+s/vPns+WbjcNn6vKezEl+IT4mf3MMc/CYrQr59dLsMS5
         Ti/6UUQZP5dX9ljO4Scl7fLlfXROYNqIXWOZD+CRnwy7Kb/xLbi5RtFMfQz2VRmLYH7L
         fFg59qe/zdRqqbixcZfiPgZYTtTSsj0cbdP3kx/6udWpD1/1dL7Zd9CsFXt9RHX4yJR+
         8HOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720711411; x=1721316211;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fBJvc8j2q1vfKURWwRE2Qa2GxAWgYuXKShoXDnQ45TU=;
        b=k1Tm8iZYU+YD8J5Gc8f3ixFr26QuNk8LAFlyv2w0U43mn1KVXsmpgbQfYsrU/pdtHr
         2gaRA0FaaI5JarFWUYBIqR9snX0/JxNQmj4l6+Zg8w8GgyCqkmcIa3QFfZcIcg/NOiZw
         6/ejChKBYAeYECJntcHVEZSJx0OLI66Lnisis+9DVQQAw6n1TrvLw1RFuSED3QFeY+vK
         2IoMPZIqZNoEsinhVMwxsBcAW0Fx3DGMZvqq21xnH0jNVsp3sGEMM3Nz0JJTqTwSmswU
         rOsTUI7dUqovHOlgraO1Yti95H6Sgbp2jIft11RkbU6FqPA5lJK4GoTVUG5xqg73EP1D
         4lsQ==
X-Gm-Message-State: AOJu0Yw5ePLaXtonvP6roVBoY0fu6iRmkXKF3lHcUzsGf7gGr8Dv/oyu
	VvhiSPE6j08bbi810jUCAXjTvaEyf0aBIHbjvKJfMp2h7OBD44l4Q4NpmAINBlgJC2wsCaDyfGQ
	0vHoe72FJEgm4X+qRx7av1J7f8WDhv6kGhH+X
X-Google-Smtp-Source: AGHT+IEOxeNUMoVtd5IuyGwu46w6e22QHj0Z3iAcvoNRcQXN/KEiL6s1GbkJ6jWVGOyatwv0RnPe6b30/vqNRJM8/xc=
X-Received: by 2002:a50:cd8c:0:b0:58b:93:b624 with SMTP id 4fb4d7f45d1cf-5984e03cb73mr185790a12.1.1720711411001;
 Thu, 11 Jul 2024 08:23:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710220540.188239-1-pratikrajesh.sampat@amd.com> <20240710220540.188239-4-pratikrajesh.sampat@amd.com>
In-Reply-To: <20240710220540.188239-4-pratikrajesh.sampat@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Thu, 11 Jul 2024 09:23:19 -0600
Message-ID: <CAMkAt6qxaJwobxesMyg8vssgVDCH+fBLb_vW_vARxAcRFQQQ4g@mail.gmail.com>
Subject: Re: [RFC 3/5] selftests: KVM: SEV IOCTL test
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, shuah@kernel.org, thomas.lendacky@amd.com, 
	michael.roth@amd.com, seanjc@google.com, pbonzini@redhat.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +
> +static void test_sev_launch(void *guest_code, uint32_t type, uint64_t policy)
> +{
> +       struct kvm_vcpu *vcpu;
> +       struct kvm_vm *vm;
> +       struct ucall uc;
> +       bool cond;
> +       int ret;
> +
> +       vm = vm_sev_create_with_one_vcpu(type, guest_code, &vcpu);
> +       ret = sev_vm_launch_start(vm, 0);
> +       cond = type == KVM_X86_SEV_VM ? !ret : ret;
> +       TEST_ASSERT(cond,
> +                   "KVM_SEV_LAUNCH_START should fail, invalid policy.");
> +
> +       ret = sev_vm_launch_update(vm, policy);
> +       cond = type == KVM_X86_SEV_VM ? !ret : ret;
> +       TEST_ASSERT(cond,
> +                   "KVM_SEV_LAUNCH_UPDATE should fail, invalid policy.");

Isn't the reason we expect all other calls to fail here because we
have not successfully called `sev_vm_launch_start()`?

> +       sev_guest_status_assert(vm, type);
> +
> +       ret = sev_vm_launch_measure(vm, alloca(256));

Should we free this buffer?

