Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CFA543003
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbiFHMNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238876AbiFHMM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:12:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D534525D5FF
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654690376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GO+EJ1aLPgZO8T1Z66MtdKjDRuL7ln6n4VX5hpJLuQA=;
        b=GRPFUMtW5wVDHQvDH47OoE/rltmlBtKIsCBqofRA1Lvd7t4qqTX884VxidUwrw95zQc+G2
        SvsuNHdEL6LTwHFKMhzmQiJ1wNlDkI3hSAJ3kr0kqZEqY/9XsozFFFIoqMgr8sWRSuUNSr
        Edl6SUG6MFwLPajz18rAoer+bgMGrrY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-kqWRqFtzMOSH1D9dfVpCFQ-1; Wed, 08 Jun 2022 08:12:54 -0400
X-MC-Unique: kqWRqFtzMOSH1D9dfVpCFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5072E3C02B75;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33B821415102;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 2/6] KVM: x86: move all vcpu->arch.pio* setup in emulator_pio_in_out
Date:   Wed,  8 Jun 2022 08:12:49 -0400
Message-Id: <20220608121253.867333-3-pbonzini@redhat.com>
In-Reply-To: <20220608121253.867333-1-pbonzini@redhat.com>
References: <20220608121253.867333-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For now, this is basically an excuse to add back the void* argument to
the function, while removing some knowledge of vcpu->arch.pio* from
its callers.  The WARN that vcpu->arch.pio.count is zero is also
extended to OUT operations.

We cannot do more as long as we have __emulator_pio_in always followed
by complete_emulator_pio_in, which uses the vcpu->arch.pio* fields.
But after fixing that, it will be possible to only populate the
vcpu->arch.pio* fields on userspace exits.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/trace.h |  2 +-
 arch/x86/kvm/x86.c   | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index fd28dd40b813..2877c0e92823 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -154,7 +154,7 @@ TRACE_EVENT(kvm_xen_hypercall,
 
 TRACE_EVENT(kvm_pio,
 	TP_PROTO(unsigned int rw, unsigned int port, unsigned int size,
-		 unsigned int count, void *data),
+		 unsigned int count, const void *data),
 	TP_ARGS(rw, port, size, count, data),
 
 	TP_STRUCT__entry(
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2f9100f2564e..8e1e76d0378b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7416,17 +7416,22 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 }
 
 static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
-			       unsigned short port,
+			       unsigned short port, void *data,
 			       unsigned int count, bool in)
 {
-	void *data = vcpu->arch.pio_data;
 	unsigned i;
 	int r;
 
+	WARN_ON_ONCE(vcpu->arch.pio.count);
 	vcpu->arch.pio.port = port;
 	vcpu->arch.pio.in = in;
 	vcpu->arch.pio.count = count;
 	vcpu->arch.pio.size = size;
+	if (in)
+		memset(vcpu->arch.pio_data, 0, size * count);
+	else
+		memcpy(vcpu->arch.pio_data, data, size * count);
+	data = vcpu->arch.pio_data;
 
 	for (i = 0; i < count; i++) {
 		if (in)
@@ -7454,9 +7459,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 			     unsigned short port, unsigned int count)
 {
-	WARN_ON(vcpu->arch.pio.count);
-	memset(vcpu->arch.pio_data, 0, size * count);
-	return emulator_pio_in_out(vcpu, size, port, count, true);
+	return emulator_pio_in_out(vcpu, size, port, NULL, count, true);
 }
 
 static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
@@ -7505,9 +7508,8 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
 {
 	int ret;
 
-	memcpy(vcpu->arch.pio_data, val, size * count);
-	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
-	ret = emulator_pio_in_out(vcpu, size, port, count, false);
+	trace_kvm_pio(KVM_PIO_OUT, port, size, count, val);
+	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
 	if (ret)
                 vcpu->arch.pio.count = 0;
 
-- 
2.31.1


