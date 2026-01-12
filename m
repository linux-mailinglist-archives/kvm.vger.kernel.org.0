Return-Path: <kvm+bounces-67732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4CAD12C7E
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84D9B30C2FE3
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5643596E6;
	Mon, 12 Jan 2026 13:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jGBocpfg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WKwYpMaV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE213587A1
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224212; cv=none; b=lLbMv5+nx0XUKZ3ZWEfth2Zfe9YPVl33fYMSKLQwrS8hG2VRxdI2ih87D7makJU11MOtUEF1MV6ZxkFymu7b7+D9LwInS5aKab+1uu7B4pvHw7sekEoD7Eq+AKzrmrx7jOFuQotAMpqTX0ds8cMVqhZzdw/XP6GwmakvEbnPt+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224212; c=relaxed/simple;
	bh=bm79w2PJYnuKL5B43j7eXO9kPpjmW1vbDan2MVWOKQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4Crq1YzJWuYxxQINr/G7NLaQ4T+kuxwqrDwNGYC8fpraq2klY6PDX7s4OR1VJxQ5f7fwNufas1uwPPF0VjDXOFF4CfhsY+wC7f/ZK96auIbkez8AL+iWT90EMa4Z+woEIRH8I93zgwUVE21jUSrVqVdfZfSXY009jYMTKn3sGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jGBocpfg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WKwYpMaV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g+khot+OVhL5+e3tOQKUptJ6m/mk7Ksd4tDhst7pTHg=;
	b=jGBocpfgf8Iuwk27A5bx/dpY5xdFBmnsI2NPyVZK86uLKn/tYenPuUBQ0Tl6cThccXa1SB
	DgQOkhmynjY0S/zLdcWlA7kiSJfYRFI0nRinUJActZ0DEB5+iDM2wB1mZMuVYHS7lFWlkl
	5IjbpWTuRyov481qeIvcCKN9ifoM7dU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-drXhWvmcNSSw-tXoNB24Cw-1; Mon, 12 Jan 2026 08:23:26 -0500
X-MC-Unique: drXhWvmcNSSw-tXoNB24Cw-1
X-Mimecast-MFC-AGG-ID: drXhWvmcNSSw-tXoNB24Cw_1768224206
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c196fa94049so2961636a12.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224205; x=1768829005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+khot+OVhL5+e3tOQKUptJ6m/mk7Ksd4tDhst7pTHg=;
        b=WKwYpMaVMeNoSAU8bryc0ke3mda1D3L3EbdweAEMBIQwSyyqIuQe7TDU07hjvNkk1W
         DckmoL/F8rEZ++o9CVLy194ZCgTidrloKiupD7V2kELwbOBgMAQQJFPNwo4K6tuI6Ktx
         2A7Hp1nrCkLM4t+5EJmSz4QDW47/vDKSLzpd5FQp5JMzNILP8gsXmUHG6BL4kX98bOLB
         K4v7Y4MYnlUkQrvQs8xvmPqePppO681WQiJv8Pe14EPaA9Y6WUCD/GwIVjryKhN0n8zE
         IvAHpEQXRVF6maz6DnhSlGxXu7wzhRD6bpm2FnDCj2WsHP1rTB0znFFAvLPGG/3VXGN1
         Hdiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224205; x=1768829005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g+khot+OVhL5+e3tOQKUptJ6m/mk7Ksd4tDhst7pTHg=;
        b=ooPLLOtFJliwPyjwq0PLYQ/GGvvRIBYLXNNuBZsIutQQ+V9PvvhIb2Vo1VDaYevMIq
         pWk8UlqYXs5kadIPTdvV15jjfERf9+BKyZ26Jr6DM7X2qBzilSDJcA35QusOjBRLdY9h
         U6nSmXvlSRXUyTQxPHmdqpifh66UuG1WF+h21tFH6ygp3hUTjiKnRjg3cIq0boMXVwZN
         wDIaCIu3KgNa5er3nl/SIzw41b+09EGeXK6j4YzM4POezDglM7DzWS3ErhOn52tqrLFB
         4lZpZtw+K+h93BsL2gfvNNJFfSgAdRdYqOUdM4QbYXJaJQhZf3NMrf+r1PnFJnzDiS3P
         Q5Aw==
X-Forwarded-Encrypted: i=1; AJvYcCVFirS5WgRaJ9D8t93aErvQ84GCfkAV9y2Pd1CDkQqXE3X5n5Z1MTWLdEh7SwAfNRNc3s0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9fQ+8uvpY2K2VS1w7BKiEcxZDypJW+JE+4n8AM014EIaEGiAl
	5k4MO71ymtKPlHVo+jBPmUOiCChdOCpiXRZbcll9HexTCVdzfBadiWVf+jyWsL7+KkZiKH6t1Hc
	YNRK321Jgdx5vQFqjAz+9k4yoELSJ59Y8tk5vJ2tK9n9aO8tNA6VUoQ==
X-Gm-Gg: AY/fxX5ZRQwqW89qNO2Do8dzjkqI7Txf1GIxPx4rQvCRNSRUuOA2eE66JgNExUoLtSe
	lsmXrFGKk2d1tNAfAZiWuMwpPWqotUYk+jM3Tabcy9UEm54Swd5W76kMPcVk1B38GcVSlytcqEF
	ko/wPc89R/yMZ7xFKzBRYAP6DkTOC94y5e50TnktjhI20CaVeoh4/b6ev0veLAsJcTlvVvoZRhz
	PFUI4rkmkhfOKxaoqAkYDqr18VYKjGqqdxZiEqOIpZ0pP0MB4YKGSiSTsN+u+AO11sau6xKEtBq
	M4pWwSHNL+lTl5xv39XJT7vuS2DGCk1/AGhJ+AnPJAImdGiiUoPoNSqo7rtnfeRqrnDYlXA8P63
	4XevxQ/Dbgub5ForlNFKY97s6TPe3ErfOU6mx7aKDPYA=
X-Received: by 2002:a05:6a20:6a04:b0:389:8e40:a150 with SMTP id adf61e73a8af0-3898e9c82f9mr17456671637.6.1768224205501;
        Mon, 12 Jan 2026 05:23:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFi4Zg7KdOtP8qLyP1McM4GBBuhCcQb94iIzKBNrcIfxcUavjuesbrpptymmYu05SfJOoquaQ==
X-Received: by 2002:a05:6a20:6a04:b0:389:8e40:a150 with SMTP id adf61e73a8af0-3898e9c82f9mr17456651637.6.1768224205076;
        Mon, 12 Jan 2026 05:23:25 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:23:24 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 01/32] i386/kvm: avoid installing duplicate msr entries in msr_handlers
Date: Mon, 12 Jan 2026 18:52:14 +0530
Message-ID: <20260112132259.76855-2-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260112132259.76855-1-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_filter_msr() does not check if an msr entry is already present in the
msr_handlers table and installs a new handler unconditionally. If the function
is called again with the same MSR, it will result in duplicate entries in the
table and multiple such calls will fill up the table needlessly. Fix that.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7b9b740a8e..3fdb2a3f62 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6043,27 +6043,33 @@ static int kvm_install_msr_filters(KVMState *s)
 static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                           QEMUWRMSRHandler *wrmsr)
 {
-    int i, ret;
+    int i, ret = 0;
 
     for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
-        if (!msr_handlers[i].msr) {
+        if (msr_handlers[i].msr == msr) {
+            break;
+        } else if (!msr_handlers[i].msr) {
             msr_handlers[i] = (KVMMSRHandlers) {
                 .msr = msr,
                 .rdmsr = rdmsr,
                 .wrmsr = wrmsr,
             };
+            break;
+        }
+    }
 
-            ret = kvm_install_msr_filters(s);
-            if (ret) {
-                msr_handlers[i] = (KVMMSRHandlers) { };
-                return ret;
-            }
+    if (i == ARRAY_SIZE(msr_handlers)) {
+        ret = -EINVAL;
+        goto end;
+    }
 
-            return 0;
-        }
+    ret = kvm_install_msr_filters(s);
+    if (ret) {
+        msr_handlers[i] = (KVMMSRHandlers) { };
     }
 
-    return -EINVAL;
+ end:
+    return ret;
 }
 
 static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
-- 
2.42.0


