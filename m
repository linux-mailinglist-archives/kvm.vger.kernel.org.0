Return-Path: <kvm+bounces-17667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A64AF8C8B67
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:44:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2BB92B22948
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCF213E3E1;
	Fri, 17 May 2024 17:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s+9kuIVP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D1A143872
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967614; cv=none; b=nhMRkD08O6JFp+nURh+wCTB3N9130FwoNzBHppy1gdl1yKd9cQhf/u/zl8Jbmc1aSQtMPI8yNXlaH/LsgrgUTaEveSKANfzQ3vFAWVwQI+cN+2Yx+6GzL9q0g2v0lvg+RDJSl2dYmxnpUI8jdv78o0hG7kQe1IYPWtA26j+OFoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967614; c=relaxed/simple;
	bh=JWFYm3hzYs3OhfFjHKQqDUvFKX5QGqdvk4KVBkOltW8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iJaHWle3/1JRNRUsF8aTD2nOYpNkXfLf0ltvSxqVvp6VepxJNojJcOAMqrEzFvYvY0UGYfepUOrQ8woLaD/PuwUtDrNxh+nOmNVptzaQVDIIKckZRQby8+L7R2KRcrZKJV50XYLBbn3KvMo/1KNy9lVrZGYyrnICwjfGB68mLD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s+9kuIVP; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f46acb3537so6689667b3a.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967612; x=1716572412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+xzcZH1oX82o+qOCBsf3LxtdbYVe7tXAJ4CjGFkhZ1E=;
        b=s+9kuIVPvj7qjbEf5NbiNyiqCOlCCPfuNSmvSaafb3/N/d9trIE9IsKqTxPGVBnf0B
         h9t2gVrPJDvnBATNw1Wvb7V0RzUPKrCM3wI6Q84jpeiVxHYgB8Xdv/k58HLvmjaMZJCb
         YHAsxhlB1RDJEznXSjEdrXFFzK+YeWX8A8fdLxSrfK5/7HYjo7o/KvX7j+idKeX3KRei
         8vq8ijyGJbb1XUZHWNnAYSrP2ykBBBGu9xEfT6nyVIazzYnPILudcQYMosFlPfznbh7M
         Hf7h5ZDdhcF3C9/WjpdsPb8bAqF9aWDaqw1IB+2wpt4EfReiMQLJiiRE3SERNGkhAQvH
         oxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967612; x=1716572412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+xzcZH1oX82o+qOCBsf3LxtdbYVe7tXAJ4CjGFkhZ1E=;
        b=t+Yg9h6LJy1zH56S/vPGP10tswzjmGulZXFGplgyBmJNjV5mPjIujQbC7ne79RhzAn
         OoOhIRl/O7KrV0jxDiKnvYO63znKkEDf379AE5MsOZDVVt9MY+ykMp+UYphUOs+bCU7n
         mWFQsMk3D02SeZC/xKEgqs2/DHupL3oNsIjxMwwyx0qHxTfbNxW0VJiumPi5iDcfFk7X
         SKamdgJYW72CLD5wyh9itpEirqXt74XtDNVY+N67MmIzFxMwOjGQWVR9KXwPccIvEUJU
         F7S7nVS/p95kM1zoc/q2C/a7FSjfPxk04MQnE/rg2GGBG15qEg1rN/cMGoC1DqZi+Mq2
         tViA==
X-Gm-Message-State: AOJu0YyD8Zq+Qb3BHC7XTqxDyrLhDtuFR0Vfh5O821LEGPPLNgTN3m2o
	YUGgSyEKRfenZRY+vU+4iRZ1Ryu6NpyHrqB+W+pY8kn6aH54YndylNDEyf6ICjxvCT3lNaGR8yW
	VdQ==
X-Google-Smtp-Source: AGHT+IGsN6Qh61VqtBf96frE+hd3CwAur9vrPpJuALwxwHlbxVPzVF/y8P8dpbLdPI8ksAq7YkoDW5FYIR8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:390d:b0:6eb:1d5:a3a with SMTP id
 d2e1a72fcca58-6f4df3b1c35mr975367b3a.1.1715967612089; Fri, 17 May 2024
 10:40:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:52 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-16-seanjc@google.com>
Subject: [PATCH v2 15/49] KVM: x86: Zero out PV features cache when the CPUID
 leaf is not present
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Clear KVM's PV feature cache prior when processing a new guest CPUID so
that KVM doesn't keep a stale cache entry if userspace does KVM_SET_CPUID2
multiple times, once with a PV features entry, and a second time without.

Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f756a91a3f2f..be1c8f43e090 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -246,6 +246,8 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
 
+	vcpu->arch.pv_cpuid.features = 0;
+
 	/*
 	 * save the feature bitmap to avoid cpuid lookup for every PV
 	 * operation
-- 
2.45.0.215.g3402c0e53f-goog


