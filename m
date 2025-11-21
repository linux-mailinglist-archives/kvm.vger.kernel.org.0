Return-Path: <kvm+bounces-64266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2565BC7BE20
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 23:37:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 25FD74EF95C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 22:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55B43019C4;
	Fri, 21 Nov 2025 22:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pSuv5mXO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A96C2FF155
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 22:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763764501; cv=none; b=Usjj1R/3VdDy7NIjjE0TcPUv3g5igNYp/3YiwaCwKFD44uxOgKDv15IryQ0G6ao0QMSP9BrLtLXmO2ehrGqLVxZwnJwH0W2qHu7anwJSZUV3PJI0xWczhLEwypnDzfOjxlnjgr+prHnnZ+eIpRWBQT4ni5DWYmRCWDKKjyDf92s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763764501; c=relaxed/simple;
	bh=yz0/RGPQhgUuawce+VsL4GeCp7piSee5icPYDy8cV6c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lfZqxbl3h52o8uzKys/hmQjVVMPXhGYOBLa0ZrvzHECIsxOGivu/vTJu1h9CLmefVF15HXxgrNzuSekekv0cWubCu/Uk5h7lfXJ3Mz3/YeZo/ZIXRpREgAkt91s0fQFXV+QXfdeCNmFji+oBOaxEjjds/kySfsFvHw6vQ1nWxsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pSuv5mXO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3436e9e3569so5378558a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763764494; x=1764369294; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=InBo93G5HI4PVLH9iAiwY8b0qujoTNU9yFW4BKVHb7c=;
        b=pSuv5mXOF9dHdZsdTevp90hvORKV5rqBdjKHc6BF0y9t2Ka/AEVrxzBjqIOIB0zppO
         XesYZxa0Hw/1wiz/QErAGtR3euTqw06fYINsuU6Sj1qXwSi/3lbTfSfKUZ3LaDF7g/7z
         EEZ+pWbAohf4E4QQL3ydd6qi6vCAgcbHeoyuTqu38cs5l5P8ta/NYEAs1O1ONzVkTx0L
         VkK/9xFpLIW7e7sYVZ2vP9q2D5ZVwh48yiJ241DkoFQ9iPg+5Ji5frUltyvwsU3I61kv
         IeiSGdM0n2X5KywZ5FfD1dXD4NfsHZfiTPa4+lSwWNT5dFhpzsEWZ+ATE10PJ6sr6cQm
         GquQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763764494; x=1764369294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=InBo93G5HI4PVLH9iAiwY8b0qujoTNU9yFW4BKVHb7c=;
        b=CSz4h2t3+DIO1eEAPUlUS4pw0HvwIJ2buE7o4mBLX+EIBaPTb2GaeqmfpQv+kP1HvA
         7L77KsWsecL7kqQQQAC55SxYMs2Okg5lXeRs8D1xX8Xt+NOIWgVJ+MCffRy14tLBTr1P
         KrNOfTQNkDGanrbN2VK1IimUGpwbEuMy7iYm1UosN36xqhUEbdWnwWStdTXSQCkjPQtp
         h4UFH1k/9GybVznfSqBTYacSPzMR1KUY9r9tztsRJBqL6vpWuQHYDMD2gZ5xT9KFmDpb
         pYzu3qrPNh7G39Bl30xCG84zBqsCzKD8AKz0AxD06IT7KeuT9s6pLCaFUTTe5VqTSLun
         kEyQ==
X-Gm-Message-State: AOJu0YwVV6XeZjSgpzYjbqmXo6D/venJN1SxnlU7Oz4Ornx+t5WKjWM+
	q3PrS8GKYyCiVKesq5BOT7jMIcuVoWaO3XnOiD7HkQU7xAzjb0su6OHu4cYd9aKAjDmdvNRBsst
	xBttXkQ==
X-Google-Smtp-Source: AGHT+IG/fkRkERFnKO9mGUfex1cS5KDldCvz0Sp1ylkSk1r8aqWB94jzs/m2QrXXVQ0EDvIltYU6m1G5OK0=
X-Received: from pjbmi9.prod.google.com ([2002:a17:90b:4b49:b0:343:65be:4db2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c85:b0:32e:38b0:15f4
 with SMTP id 98e67ed59e1d1-34733e46dc6mr5204222a91.7.1763764493765; Fri, 21
 Nov 2025 14:34:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 14:34:43 -0800
In-Reply-To: <20251121223444.355422-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121223444.355422-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121223444.355422-5-seanjc@google.com>
Subject: [PATCH v3 4/5] KVM: VMX: Move nested_mark_vmcs12_pages_dirty() to
 vmx.c, and rename
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fred Griffoul <fgriffo@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Move nested_mark_vmcs12_pages_dirty() to vmx.c now that it's only used in
the VM-Exit path, and add "all" to its name to document that its purpose
is to mark all (mapped-out-of-band) vmcs12 pages as dirty.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 13 -------------
 arch/x86/kvm/vmx/vmx.c    | 14 +++++++++++++-
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d0cf99903971..97554eda440c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3980,19 +3980,6 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 	}
 }
 
-
-void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	/*
-	 * Don't need to mark the APIC access page dirty; it is never
-	 * written to by the CPU during APIC virtualization.
-	 */
-	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.virtual_apic_map);
-	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.pi_desc_map);
-}
-
 static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cbe8c84b636..cc38d08935e8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6378,6 +6378,18 @@ static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 	vmcs_write16(GUEST_PML_INDEX, PML_HEAD_INDEX);
 }
 
+static void nested_vmx_mark_all_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/*
+	 * Don't need to mark the APIC access page dirty; it is never
+	 * written to by the CPU during APIC virtualization.
+	 */
+	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.virtual_apic_map);
+	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.pi_desc_map);
+}
+
 static void vmx_dump_sel(char *name, uint32_t sel)
 {
 	pr_err("%s sel=0x%04x, attr=0x%05x, limit=0x%08x, base=0x%016lx\n",
@@ -6655,7 +6667,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		 * Mark them dirty on every exit from L2 to prevent them from
 		 * getting out of sync with dirty tracking.
 		 */
-		nested_mark_vmcs12_pages_dirty(vcpu);
+		nested_vmx_mark_all_vmcs12_pages_dirty(vcpu);
 
 		/*
 		 * Synthesize a triple fault if L2 state is invalid.  In normal
-- 
2.52.0.rc2.455.g230fcf2819-goog


