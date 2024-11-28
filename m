Return-Path: <kvm+bounces-32666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 543FB9DB0E3
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:38:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6825916194C
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E69419067A;
	Thu, 28 Nov 2024 01:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G5RgidBp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA949158534
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757701; cv=none; b=Kw1SAYojdJxud0YNALYQy8o0lgstpRVnvec60x7heqSOlB4jGzYP9zkJfaZ3O9wr6aQnGr2r7w+L/oe0Z1TaFi7dT6pD72lj2TJt57wbC7hBDQ8Wtw+CnSLkv3Dm1SbNGvoQalu9M1/eEQkXhVCR1kp90HW/BC4F0L3+l0f87W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757701; c=relaxed/simple;
	bh=Tc8LIiOIRM3QxaxI7g2HZv8WVUrEZKdFo0OMioOb8C0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WOu9ln7za+WXcMcpTNWy4IpgM74o0hEpYHLrQeIBKYJeBaagG3biCi7iTC0oZHkXvuXmRGseIWHo0RSu8hK+KtxBX0WRepCByAnlsuYDgIx+aIvDp0+YxeRQryTxutfBZFNMHjt6N2LfdSgATAZmMTmVxoprdsAYAZiOxl/hTW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G5RgidBp; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fbcfe197d1so232805a12.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757698; x=1733362498; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WU83/DfF7T0ds1+fthR3W+eEtQHUVkaSLt/xQXIjOoQ=;
        b=G5RgidBp4Smax495yQK+ifwCBDsN4yrGOEC52Es0bufU/SUSSj6idwevrovN2a+c8u
         8tTc0XRtNKM+SzIza2vSN3PvngS4Cy4KLigW29+DdjoLBG5pYXr9hABkvISLKKcrzrQy
         ykTVmUEYVbAnGqyQ6CPr1jT989zDah7REOmF1ZEt3jQWwL19RZ5Ub5WAGVcCjgAj3Oz3
         eB0Beef/GC5ebrUsgyzzAgaACrTg4vR/h1/lmxXWj0XwWbSGQLv8A04poAjxTnNHstrn
         hdzepW+cgjccw155Phtdf/scMeADxJy+cOgR1p+NbGrFfw0eEJ32kJ8VdTjYFGd3tIB4
         cIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757698; x=1733362498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WU83/DfF7T0ds1+fthR3W+eEtQHUVkaSLt/xQXIjOoQ=;
        b=aLmb2aTEMt+guTdt++XruiQs0vBlOiv64A/3byUK6RlrqoaGQhtOPRtycZeeT5CbdI
         BMhJvA0fkf8zlEYWrFoi9gMHheSmuHUgUIhvafOtIYlUujgYH9V8dh/UfLNjl8bBiJHW
         FcOgXohspVzRAe3D434CAml7fHhB3mU34JHRuBA/Vr7k56XVhilH4MISIfGCJNzSZml5
         UIQ1knbY78pYQBQUBlCelbN/LueCFaPmbpZ8zOb4Tpis4TXE8gdHXC1q4r/Km4+oI/rC
         EGt+1swimWobpA31RbW3hfo7nJKE88KzHre+UJUAR9QpKtciF9vzeHC5cfqEsrgxSqIE
         g1eQ==
X-Gm-Message-State: AOJu0YxkCbIkeoWR6c0pwiuxFLV7SpkSgxO3ac55gWHlIiWpXJQ17vYl
	M2On8WYIWoyaYpKxg1A93D08IsvUqIym4Z9vAz0UKac5uiplz8nZWqk6zP3u12YZYdY+wHm12kM
	6fg==
X-Google-Smtp-Source: AGHT+IEJCs9N2XclscA1jtpo8yGvgCHz9DiT6omS7XIoj+KtuSKV1V8k6WtPz+JiSgyWErvjoDkzmWslk0Q=
X-Received: from plblk8.prod.google.com ([2002:a17:903:8c8:b0:212:45f:e087])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a105:b0:1e0:c89c:1e04
 with SMTP id adf61e73a8af0-1e0e0c5cc36mr7869843637.43.1732757698381; Wed, 27
 Nov 2024 17:34:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:42 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-16-seanjc@google.com>
Subject: [PATCH v3 15/57] KVM: x86: Drop the now unused KVM_X86_DISABLE_VALID_EXITS
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Drop the KVM_X86_DISABLE_VALID_EXITS definition, as it is misleading, and
unused in KVM *because* it is misleading.  The set of exits that can be
disabled is dynamic, i.e. userspace (and KVM) must check KVM's actual
capabilities.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/uapi/linux/kvm.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 502ea63b5d2e..206e3e6a78c6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -617,10 +617,6 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
-#define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
-                                              KVM_X86_DISABLE_EXITS_HLT | \
-                                              KVM_X86_DISABLE_EXITS_PAUSE | \
-                                              KVM_X86_DISABLE_EXITS_CSTATE)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
-- 
2.47.0.338.g60cca15819-goog


