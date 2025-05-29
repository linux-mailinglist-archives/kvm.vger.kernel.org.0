Return-Path: <kvm+bounces-48038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 138FCAC8514
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41BB09E7235
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9342258CFA;
	Thu, 29 May 2025 23:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yuk2tuF5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665BB255F57
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562022; cv=none; b=dKNRwQg0njQ/HFQYg/Vs+6tWJ+Gm2qT6qiOwsFVEpkF0INSOxQg5hPYl7HyltUOCfuYe4AGiK2vFfRYV21PK2EzcoBJs2c5MBCkd0+i1kRKQ4Cz+4s1mxfI4t4GVaWL52uVnYygEGH4gdGy/vH/e8PeZhN7FnxLFZhGZcq6uNHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562022; c=relaxed/simple;
	bh=oA5mIwWnWVZGa1VRqZsbYKhTebJt0ccotJH59gL4CN4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K7N1aMk6UueoA1+m3VnyG82+PDiAJ8DZGYZ1SVBrdQHOnEW8EIqL1hqjm2Yz65boJKmjGDEvY+u3oBM4fBR4g+xDJlNNSyAxsRcJj5zBeD91g0dsRW6UmWAAvJYam5715G2HYNXJpKAlpBZjSF3z8PtggEGrgkMGQiamdvJtxp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yuk2tuF5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-310a0668968so1332484a91.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562020; x=1749166820; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=phkDMYd9+r063lx2wsvT2RvF4yzzenvwRrvfntVBbTY=;
        b=yuk2tuF5B4yf2m0y7JDpGH+/0pyJVKBzBVeBpaRGgmXtmVTr+pfAiyAuzBvI7GMPhW
         3JSwtFBCQ/z/LPKGfqmajZVunmu4350Kbg7EoErmDqwYFhVeLVfjHsThvPAKzqc3Fpy2
         rChNGKSNOTJe471XJI6oNbGY4uFOdTkl1rsV67q02lxlPHuvZ1olIhCs2oQBxR147ISi
         L1ypCkY2MsH2AnBhGRKPR0AKp1TU8LBa3TD49Uhc/tfpxQRW8ID11lQFjBjbN49cIJLC
         2U9V2D1Cx3IumZx1LAYx9btL6PvnOEwBVJ0q6RZBgKfhof0a3LmNk9ZuHllJ7Q+YxJcC
         h5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562020; x=1749166820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=phkDMYd9+r063lx2wsvT2RvF4yzzenvwRrvfntVBbTY=;
        b=ckB6TZe/bGBIUIAzeDRp/TDfXI0hf52UANpJZt3I15E6aMnJWaBbou+Y02pQ8kEHkJ
         X93YOhsCQMrosOCCC1B6tW4xJPOAL+gSyjd0Uf5dBB4wgbX882Vkerm2/V8wUfjEsc/L
         ECM968OX32xkG0B9LETgTUdmwvZPK1zxdBonKulHfThzbs1FqqXqmc1uEc2bclNPX5qI
         FW2JSpknig7yLIff3hZx0+oF8PN6S9V2zg0lovecOcgXVA2G+oOqoQgCZ3EhrZ3tYwqy
         b4JFA7t9TwYAcYSyBzxMTliShlsvw2CWc7pdWUdb8DD4fAfEv7uPCvtEbjTGRsCQpINb
         at+w==
X-Gm-Message-State: AOJu0YxqAOM3t4XX888Ku1Li3lIf6SPTVnqbwH0BUaBJckUxgz4STjCc
	ESbMHi3/yqSPXqIcjknLSTsjEv813zCAIXgnMzLmGeqlkvrtMFI0WtNDDO55Ktd7V2bL/pyJVQT
	O2sBrtA==
X-Google-Smtp-Source: AGHT+IFQOlSYGltmai4IibO2+vegdOPkobvy+HaORjla/oWfdPWJdtFoLn10L6mMJII6JYzD7yJABkE/Stg=
X-Received: from pjtd7.prod.google.com ([2002:a17:90b:47:b0:311:ef56:7694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d448:b0:2fa:157e:c790
 with SMTP id 98e67ed59e1d1-3124100ca00mr1764491a91.5.1748562020565; Thu, 29
 May 2025 16:40:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:47 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-3-seanjc@google.com>
Subject: [PATCH 02/28] KVM: SVM: Tag MSR bitmap initialization helpers with __init
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Tag init_msrpm_offsets() and add_msr_offset() with __init, as they're used
only during hardware setup to map potential passthrough MSRs to offsets in
the bitmap.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bd75ff8e4f20..25165d57f1e5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -945,7 +945,7 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	}
 }
 
-static int add_msr_offset(u32 offset)
+static __init int add_msr_offset(u32 offset)
 {
 	int i;
 
@@ -968,7 +968,7 @@ static int add_msr_offset(u32 offset)
 	return -EIO;
 }
 
-static int init_msrpm_offsets(void)
+static __init int init_msrpm_offsets(void)
 {
 	int i;
 
-- 
2.49.0.1204.g71687c7c1d-goog


