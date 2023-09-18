Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F4C7A4E38
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjIRQJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjIRQJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:09:01 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD42A4490;
        Mon, 18 Sep 2023 09:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=5dx9h7SGIgzZx3McRPLzAIAziBr0OX4wLMeK0R+Vbo4=; b=Gnf/zoQr0L3d+R9LPNsUGbq9bn
        HzG3qkJHEhds8QKj4zCEfDn9lyoFzW4/0jEq/L93y57iXD3UO6VvyudUojAEt+NWCqbmkqFrQNtR1
        WVAXGfWxzW/NRzKTCxp++ExLwZpbUFO66gw8qeGAwZfdq4DWdPDAKytgz9W7wqkxkyHY=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiFRG-0003RQ-Lf; Mon, 18 Sep 2023 14:41:26 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiFRG-0006IJ-E8; Mon, 18 Sep 2023 14:41:26 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v3 08/13] KVM: xen: prevent vcpu_id from changing whilst shared_info is valid
Date:   Mon, 18 Sep 2023 14:41:06 +0000
Message-Id: <20230918144111.641369-9-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230918144111.641369-1-paul@xen.org>
References: <20230918144111.641369-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

To further prepare for automatically using the vcpu_info structures
embedded in the shared_info page, we need to ensure that the Xen vcpu_id
cannot change under our feet. We can do this by simply returning -EBUSY
to any attempt to modify the attribute while the shinfo_cache is active.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org

v3:
 - New in this version.
---
 arch/x86/kvm/xen.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 7fc4fc2e54d8..459f3ca4710e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -752,6 +752,18 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 	return r;
 }
 
+static int kvm_xen_set_vcpu_id(struct kvm_vcpu *vcpu, unsigned int vcpu_id)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
+
+	if (gpc->active)
+		return -EBUSY;
+
+	vcpu->arch.xen.vcpu_id = vcpu_id;
+	return 0;
+}
+
 int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 {
 	int idx, r = -ENOENT;
@@ -941,10 +953,8 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID:
 		if (data->u.vcpu_id >= KVM_MAX_VCPUS)
 			r = -EINVAL;
-		else {
-			vcpu->arch.xen.vcpu_id = data->u.vcpu_id;
-			r = 0;
-		}
+		else
+			r = kvm_xen_set_vcpu_id(vcpu, data->u.vcpu_id);
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
-- 
2.39.2

