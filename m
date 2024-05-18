Return-Path: <kvm+bounces-17722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E1DA8C8EC3
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 02:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E2AD1C213DF
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 00:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491372629C;
	Sat, 18 May 2024 00:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BIFBpc94"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203946AD7
	for <kvm@vger.kernel.org>; Sat, 18 May 2024 00:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715990688; cv=none; b=VSghOtfM724FUZwXsfW4ZmMdVtlQbFVc0+rdA2LLOXlegqvXPr9XG6WjwEaFOsTEy0HtYn/+WAhrKVU6WuOifHBosIM64jUrEeZuyrwrhwTx4Q1BqCFA5PVoiAwyQrXpX5LqMyGHB73rIWir0pDtQA1U3xvxdGdZ1Ec8EHLTKhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715990688; c=relaxed/simple;
	bh=UsxfZ2Znpr+evi/d9J5xPggQfQfWujjuBEirhapl2Io=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WX5rRKPkF3sUiFKWEUDZlke1QNXAwp+zWn25yC5YjHqpm0x83QltRhoXqpodtVybKr/QhOgf2K8Hmt5PUbxKlW11o2xZnJlnHVswrO1NeF26A6mJjwgE4uVaQnTE5r2DbB9K8K/o6+2vBuUvMg3JkReeGqUcSn+2D3aE59SSwj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BIFBpc94; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-622cd439764so132930137b3.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715990686; x=1716595486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GtLQWhneBIjQa9L0ZFgDjGejsgErZqZOjE88sPfbTko=;
        b=BIFBpc94IAroqArDyjMJmzGrALxbfTVAOO+80UJIqQD5ZTxcoMO0o1v9WGY5yYLb6v
         uUy0R7ehgeJZL8VHUbXGFJgOYOAsk3JHYiG4gxDsSl3QYFWPLI/jn9OHXvfeV8f+cS22
         Kfsx01G6pOFPQ+h/Fgk8J4GKjndd54gbITTqv7OlmWRzDfaJu8dOpCKy4Bi2i+5HuTmL
         Rct7qM3FgLSOu/e2aQoY31Bcd/bQZQmCaSfkhnp++McWIMk/LgbX8ycOYIGf/PV9WwlO
         ETAkix+hYcQfdgACe8wUhFOcPXyK1Io3T9OaqdQwFanSqoO5Lli0r266O18qJkT+meYf
         /fyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715990686; x=1716595486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GtLQWhneBIjQa9L0ZFgDjGejsgErZqZOjE88sPfbTko=;
        b=YgQ8haN6oeSYlLAtncXbBW7PRr66tIoEs5Eb/zOjiPNRI6dajS2azeDquK1r1r0+EP
         WeM7U9M8lUgp0FZO1HTguQ51fofGaSOPhi3ulgNSC0Kc+DUICAOIDEouoGe9yUI5k4Pr
         MeBbePG1q2VQ799VyEL7bKaRDJFPeES1A0YCumCHPskdDTmX05EHnJxdesOZZSaRue50
         ue4n7GST08XdJW+D3ZVLynGdQHdeF1PiD+g1F2fIE54Dpy9w4uBpWHTNnYE9MF5hUpMe
         MxnXLu0anSPBvOMXHuEeUUTja2/OtEBJ9yLQp47FwgMkd7PxkIsfKZmRBWCOVtehVxXM
         l9/A==
X-Gm-Message-State: AOJu0Yzq28LFcAFscWlwZWSpIor5M4SMfUlsfRhn2lVBVfPGHNAsMz+W
	hNW8XwiGQFoSsDCwnlcMjCjJzdb21Puz3+RFShaetdrWdbcXa5ovuWmpnDmEWADW6XL7v5GZA8J
	2Jw==
X-Google-Smtp-Source: AGHT+IFRNVOusb8NQXdsGL9g9hQDWm+VyTFubFptChkJmXOI5zfWn5LIjq49IRgRPhze5UG2hHk0EnpyWr8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154e:b0:dee:6866:98c9 with SMTP id
 3f1490d57ef6-dee68669b8cmr5303731276.1.1715990686245; Fri, 17 May 2024
 17:04:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 17:04:26 -0700
In-Reply-To: <20240518000430.1118488-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240518000430.1118488-6-seanjc@google.com>
Subject: [PATCH 5/9] KVM: VMX: Dump VMCS on unexpected #VE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dump the VMCS on an unexpected #VE, otherwise it's practically impossible
to figure out why the #VE occurred.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 51b2cd13250a..0c68643d982b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5217,8 +5217,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);
 
-	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
+	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm)) {
+		dump_vmcs(vcpu);
 		return -EIO;
+	}
 
 	error_code = 0;
 	if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
-- 
2.45.0.215.g3402c0e53f-goog


