Return-Path: <kvm+bounces-7520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A1E843271
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 02:02:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2C281F227F4
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAECB63A7;
	Wed, 31 Jan 2024 01:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eAQFsPbD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F1B4C83
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706662895; cv=none; b=a7WIDrI+hgAtN9uhupeLMfpqzkxObrm4dqhyG/8PexY7TeqRu9Dfzs4WSDpJFPvwiXdtdy3EBVCV5vKLLGS67PKRuDgzvwZqF6U9OxKZDiJkkWQcINqdreng+ncmQoa1tfzO33KdjmlJo+ZsL6SHnzAZ/zXdrUCiLrGVay+3s70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706662895; c=relaxed/simple;
	bh=LZS/RznHA2w80Q+YJc17YD2As105xGzdAKqT/sR3gVc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=Hc8Wr+Natom3NVWaIrI0kWXdS/189uYBhC/KRz9cTAQDZQFKfxrcF58miZ7qOD8JxZmHYcDT+kD2P3Hy3LGKq8i2ZAppfLx6aNnTudpQOdMiOpFMKia104DZABOSPd3s40dG4VTRhF3IyRBOKAsaJsLHyYhD0TUca0fTjCPYoC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eAQFsPbD; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so758825276.0
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706662892; x=1707267692; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5cmsh1dY3TfdION5uqLFp1xP6BYZ6wiL3TvU2ef8DDU=;
        b=eAQFsPbDHMsxNIuB5++hgX4mDMyjTAunObLaLoJEYzhcPDZHjWHVa5cjfcdo/Rke9D
         s7ca1b410ra6ysGHXA3XdFs8TvMlUjZRBN1NUn0TF92CLD/mYdcIJOsWBTHpaegay16N
         NDApB17+F6vg3nk+XAyhQcUfeJEhx2tvzbJVrHY+LqAI37h5CJ64Jjlm6p39PzjT88fl
         FAIVCCy6cIZtXHDhH2ELuttfd5pJ3A4Lq5Y74xi3hHCbT7ZCHNqiv15rThxNS6Tk4E+m
         6HuehnqM4bdXivQbbBNZf1Guyxnaktz2GxnXoTJjtTq4U5T75M41JOuWu1oRDd9Ho7u5
         jWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706662892; x=1707267692;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5cmsh1dY3TfdION5uqLFp1xP6BYZ6wiL3TvU2ef8DDU=;
        b=T0kAcNAGNy3J+CpxnNV3gAilBuPiQ1nCAhE+/WG+kXL0x7030qDWPhiKkZHrlZn/qw
         5uly2H+nwWTbIlAeJ/TkmHnUII8M8pGt9IOqkqr7f4PRyVZtzfhr/8w+IzzbesXvdBcm
         +DXPs9IztC5ZCGcqMwNPKtBwn8H40/Q7QVSkhXkmb9IAjh2Cb5FKGkiln2CkYWhXphl3
         MdMqyklQe94QgHgctkcsPVUqRsxs+CKCcH9RycG7TJwci9FeaucBPrte8rnmWnyXtEBm
         QrUMus9CArHg+QSxx0UMnVhWEeykwGx/rDws4q+N98hp+KslUlwFJCvOlSY1nBkq6PnM
         35vQ==
X-Gm-Message-State: AOJu0YzIgs5iBWtOUxOchngdjhev5OrqqUFcMMhLAEDQNYdvshS9YiFa
	tDSLX6mbS9Lculue6dEZJouJdTh1ZzVWkEO1gxCJyYkczwDwLcQfKMZOmpaFeSI+UGqALGMksWW
	mZQ==
X-Google-Smtp-Source: AGHT+IGkcFCsvdPa2+/E00CAZO2WgR8qp1NlFNSKUxb0KT3F02qXgZmVBb6k7/XRECbBLd6vAlpW8VaZzZM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1188:b0:dbe:30cd:8fcb with SMTP id
 m8-20020a056902118800b00dbe30cd8fcbmr5411ybu.0.1706662892557; Tue, 30 Jan
 2024 17:01:32 -0800 (PST)
Date: Tue, 30 Jan 2024 16:59:31 -0800
In-Reply-To: <20240129085847.2674082-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240129085847.2674082-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <170666266041.3861709.9779686377817993964.b4-ty@google.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: Avoid infinite loop in
 hyperv_features when invtsc is missing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 29 Jan 2024 09:58:46 +0100, Vitaly Kuznetsov wrote:
> When X86_FEATURE_INVTSC is missing, guest_test_msrs_access() was supposed
> to skip testing dependent Hyper-V invariant TSC feature. Unfortunately,
> 'continue' does not lead to that as stage is not incremented. Moreover,
> 'vm' allocated with vm_create_with_one_vcpu() is not freed and the test
> runs out of available file descriptors very quickly.
> 
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/2] KVM: selftests: Avoid infinite loop in hyperv_features when invtsc is missing
      https://github.com/kvm-x86/linux/commit/8ad485527348
[2/2] KVM: selftests: Fail tests when open() fails with !ENOENT
      https://github.com/kvm-x86/linux/commit/c2a449a30fa2

--
https://github.com/kvm-x86/linux/tree/next

