Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408DE543007
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbiFHMND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238872AbiFHMM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:12:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F02C825BC25
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654690376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ggbC2+qLXyMIhkrl+egmbVWenv3iYa8SCHIeX6BJa58=;
        b=NBKr3Tj4jZNQ2zaLhgY0r0O+OQVIKF0Xi9Ptz4ckwaEsuJwufRNqbwpP4tvKGxqSSeUGDl
        Wd8wk303t1VKYHHfWSFycDcloxrvIhgIVGOzX6tIiDkjRLy8wD5ER8f0MFOjF3kW1B5xsC
        T8RRx23l4cQMjfj45ob0mJSdOcbu6Hw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-3brLBe_ZM4KIhFhmgCQHuw-1; Wed, 08 Jun 2022 08:12:55 -0400
X-MC-Unique: 3brLBe_ZM4KIhFhmgCQHuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 999ED811E83;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D1371415100;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 4/6] KVM: x86: wean fast IN from emulator_pio_in
Date:   Wed,  8 Jun 2022 08:12:51 -0400
Message-Id: <20220608121253.867333-5-pbonzini@redhat.com>
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

Now that __emulator_pio_in already fills "val" for in-kernel PIO, it
is both simpler and clearer not to use emulator_pio_in.
Use the appropriate function in kvm_fast_pio_in and complete_fast_pio_in,
respectively __emulator_pio_in and complete_emulator_pio_in.

emulator_pio_in_emulated is now the last caller of emulator_pio_in.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b641cd2ff6f..aefcc71a7040 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8692,11 +8692,7 @@ static int complete_fast_pio_in(struct kvm_vcpu *vcpu)
 	/* For size less than 4 we merge, else we zero extend */
 	val = (vcpu->arch.pio.size < 4) ? kvm_rax_read(vcpu) : 0;
 
-	/*
-	 * Since vcpu->arch.pio.count == 1 let emulator_pio_in perform
-	 * the copy and tracing
-	 */
-	emulator_pio_in(vcpu, vcpu->arch.pio.size, vcpu->arch.pio.port, &val, 1);
+	complete_emulator_pio_in(vcpu, &val);
 	kvm_rax_write(vcpu, val);
 
 	return kvm_skip_emulated_instruction(vcpu);
@@ -8711,7 +8707,7 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 	/* For size less than 4 we merge, else we zero extend */
 	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
 
-	ret = emulator_pio_in(vcpu, size, port, &val, 1);
+	ret = __emulator_pio_in(vcpu, size, port, &val, 1);
 	if (ret) {
 		kvm_rax_write(vcpu, val);
 		return ret;
-- 
2.31.1


