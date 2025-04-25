Return-Path: <kvm+bounces-44364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C09A6A9D525
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 504CA9C2FB4
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 22:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647AD235347;
	Fri, 25 Apr 2025 22:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XN0VELUT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4529B231A55
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 22:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745618957; cv=none; b=nzutcfOV0ktZSDHi1EAXHjAOq652er7qjlodbwtbb/lQN+T20CvOVWl4RXuVNMYbQAbjnJX36FM0509V6XF+Pe25w50NE0kY7zwav7oYO9fh3KuZai1qL30wayTnOUhgfwdO94zlEArtnZ3rc4BcKAkZX7FZtaF95xNKAL+4GqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745618957; c=relaxed/simple;
	bh=D6uCt3M5nUftHdnO587l7uapyumvFCQFOaKN0b6Chh8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KjS0OtoMKxgqhltBrjtt85OJ39x12qVh89ZxwZ8pkIWNcieA0V/hy/VcOMc7lNrP82nLtfCQ1We+uV8cXc3D3a7jUZJecjH6SWZOayHDbMJsG3SnC07nKmi8SNrsqMsttypHS3+7KlLmK7+pjxaz+it2XZKYdd0ozGfSxhy4gCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XN0VELUT; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73720b253fcso2337925b3a.2
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 15:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745618955; x=1746223755; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e2GzbD4EGM+CSzFK8kCRHdpCdCIIlXbfHT6y+sz5OQE=;
        b=XN0VELUT76uH+yHhm5VB59A9ZY8rET0N9w5MW4DIgDsBg7s0w5hheyybtqhdr/P+qd
         RmjzDAcg4tiGcj9/gfIOGGK73MtAAbIuB0YqxT/sVV6lTRvdYeqMm1UOpLYQY9dBRSxY
         FAFbjcBOom32ftQ6uLZVpKRGLncVqorMPWpfEpiZLXVtGXPVlVK7g7S1721HBeNSFCXv
         X4qQMBKkHwOeMnUrE9fQgDxvgSF+eohtdWurMTObYEDeMcT5cOnUar10NDo8Yfno5bjl
         rx+wn3MipWjvG8kYFZMbMcHIWAcm1ffqZvbEUItHOd6xYiAvnuzvpAb2AUjQLLnWQ9+D
         L6EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745618955; x=1746223755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e2GzbD4EGM+CSzFK8kCRHdpCdCIIlXbfHT6y+sz5OQE=;
        b=f8vbbrkft+fWfeSQI3T+5W0IU2AKMTgm0igsKGobn13l3X5IMka4Zi4fqOC7KzWFGh
         UQhbSiO2SkWwvDC5JBYtytxNczQPXRukME1FpjI9YyBKB4crbPFaSigZTZp4Oz+rVAHJ
         62rtL8Pu4VO9YHOmmsbmpSAFI8qU/Xpy7ynOAqQCN9VrYuRLP1mFXcwAGlUhs0PgByfM
         bXMuCkPau9rJl2JPMPKZ52dRO2OXHL4e/tgRRs0VaJTPb1lNODNI1rX04rZP1OBSuTe9
         R8ndgUKwF1UFtzXgFSrVV8VW6QKnJWhkWf5NJhlm6+2ZcDUrjUrL2EaShOeRj+RpeQRN
         493w==
X-Forwarded-Encrypted: i=1; AJvYcCWkDJAZhALfcmTki5HOWpuNPEl/t4j3RNDHEPjo4w0suse7/YVHTI/0Mhb7imBj6nqwexM=@vger.kernel.org
X-Gm-Message-State: AOJu0YySMznJ0m8SKkOLd+ZkWV9v4FQ+H7lyMn11cS3KgbNLffUXZKQ9
	aZCNJvMWKkN+QPKDp9TjU1BkG4YePg4uonKrCjB5qurzQAUlkcydQ+VI2hPlys4KNtl8mSqrP4g
	kyA==
X-Google-Smtp-Source: AGHT+IEFA0r9U63O0zZjEatvnLlSDLoztxBfWPQXiWY/NYkA4ig26Zev691zUOoFw1e1JFnipYoUwsgVtv8=
X-Received: from pfbna13.prod.google.com ([2002:a05:6a00:3e0d:b0:732:9235:5f2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9299:b0:736:6279:ca25
 with SMTP id d2e1a72fcca58-73fd9043a02mr6057722b3a.24.1745618955316; Fri, 25
 Apr 2025 15:09:15 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:08:55 -0700
In-Reply-To: <ec25aad1-113e-4c6e-8941-43d432251398@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ec25aad1-113e-4c6e-8941-43d432251398@stanley.mountain>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174559663411.890078.15043837914578345884.b4-ty@google.com>
Subject: Re: [PATCH next] KVM: x86: Check that the high 32bits are clear in kvm_arch_vcpu_ioctl_run()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Pankaj Gupta <pankaj.gupta@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 24 Mar 2025 13:51:28 +0300, Dan Carpenter wrote:
> The "kvm_run->kvm_valid_regs" and "kvm_run->kvm_dirty_regs" variables are
> u64 type.  We are only using the lowest 3 bits but we want to ensure that
> the users are not passing invalid bits so that we can use the remaining
> bits in the future.
> 
> However "sync_valid_fields" and kvm_sync_valid_fields() are u32 type so
> the check only ensures that the lower 32 bits are clear.  Fix this by
> changing the types to u64.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86: Check that the high 32bits are clear in kvm_arch_vcpu_ioctl_run()
      commit: a476cadf8ef1fbb9780581316f0199dfc62a81f2

--
https://github.com/kvm-x86/linux/tree/next

