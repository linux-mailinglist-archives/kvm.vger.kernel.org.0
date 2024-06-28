Return-Path: <kvm+bounces-20702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A70CF91C957
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5198A1F242BC
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD38282480;
	Fri, 28 Jun 2024 22:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h00hyica"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF82D8002A
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719615373; cv=none; b=PCaWVjBqmM9gqAV3LnwWa9qGm+gzt143+wKywmrTG2dkBsuOwZLkA0ET5E8+s5w7NUFrJoiYJlijpq/JuXeNaCGsf8aaF7XHepQ9tko/AT+IdphpPWgBDmhDvt7qO4UBDppcSojeNHSFdx4E5QbSQWWRg6AQvCsCt9K+v6YBiAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719615373; c=relaxed/simple;
	bh=L+fOIAr4AA2NeSFEj4Yztvg+DtC6WUPFs/UC73gr4ns=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FVJ/PjDvS0SprHJFMhleBKfaD181VZXQHypc6QCcNe6aEir4Fked5Izht8P9WjcXl+p26BsJwf3tfBD9ilCL9KeuKYZblPHqHmMlx9XXK/1KnhOwCm7cKdMfM5iLiGRlVDtGDgEYy4pO7h333YjRfCJRhulHP4JN+w5HG18680E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h00hyica; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-64a6cda8ba1so19741697b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 15:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719615371; x=1720220171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ett8EUgkCChBBFZPNOi8YRDRFZwYWqwN5UfqzbKYiro=;
        b=h00hyicaW24OuX+g4MVMtVQYch09u7dzLT1VfG38TU3PdVKDc5/zTaozT927zcihg7
         bfJkhtpTR7PnRchlRJSb7DwKEPDJGNlAEneU6kNBNOnkkq+nwjSw0MQbd8w5/fCR0Wk6
         KJCP7QKtdUqwigwCnDSdF75oFG/K+fw104FAq1/4NEGQB/ONX3h7TuWMFJBiKkKqRc/C
         4frhLuuawoWJPQbizDEyQPeLXTfnXjvM0IpuJXJGOdLr/fzzxYdAZXAnYdgQSpNvIQsA
         ZmXfVVOeuT8KX9e1vV/iJrWuDk9V7cZIVe6otzDvZO1Dv4AgtZze2wANvtQgEIP3LJsz
         4pRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719615371; x=1720220171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ett8EUgkCChBBFZPNOi8YRDRFZwYWqwN5UfqzbKYiro=;
        b=PkdiZLtybtrSFriPVs4bCfxaGfl/p5ZxZEyhmb6i4qhBtVgELT/pAWxERVvx1FJCmj
         y6xZuPOrIebS3QR/4UwjaTBxw9uHH7eBs9RcPYLQACXhtv3O6bq/M38wf+SkGkjqtEtX
         LJmBizCYeX7ZWxCNjGfQE4nIUiNW8cN+2Ub/mN6dcM3XwIbtMuQA6I8iDAI7nHv+6ryq
         PbK4G160Qg9PaX5Th0U1s1zupld+tYxIJwNG9ldhd0gX+nuUl0zDVIPLJzsdLlEyFIUm
         1jSAF/8mRK6BiRVmF0Sf9hRtJ/GCXbx7ABvSBugwrQdKG4XkLM7RsuVeiyB37+MzvwlQ
         dMzw==
X-Gm-Message-State: AOJu0YzmaJ0MCq3rshIcpbbybe++g33/Y7aevnzBoLHefaySW9Mgqmfc
	J2j2ZIMmaEZbbAg2rGRczULL8+2lxBhEJ9rvyQBg0LejVcQNBwfks05LD5dBu1ww4OYqAoKmVFa
	+fw==
X-Google-Smtp-Source: AGHT+IErHV0m/rgbDyGw/iYSe33elKPccJcr4ocbrNmlvHFRBLK9zesZOHth0AxILsW58uGLoMQ9wkIB0YI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:7201:b0:62c:f01d:3470 with SMTP id
 00721157ae682-643ad4ce738mr2573057b3.6.1719615370836; Fri, 28 Jun 2024
 15:56:10 -0700 (PDT)
Date: Fri, 28 Jun 2024 15:55:24 -0700
In-Reply-To: <20240624012016.46133-1-flyingpeng@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240624012016.46133-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <171961453123.238606.1528286693480959202.b4-ty@google.com>
Subject: Re: [PATCH] KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for
 temporary variables
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, flyingpenghao@gmail.com
Cc: kvm@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 24 Jun 2024 09:20:16 +0800, flyingpenghao@gmail.com wrote:
> Some variables allocated in kvm_arch_vcpu_ioctl are released when
> the function exits, so there is no need to set GFP_KERNEL_ACCOUNT.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for temporary variables
      https://github.com/kvm-x86/linux/commit/dd103407ca31

--
https://github.com/kvm-x86/linux/tree/next

