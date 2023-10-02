Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED507B4FCF
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 12:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbjJBKAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 06:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbjJBKAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 06:00:21 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513B0CC6;
        Mon,  2 Oct 2023 03:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=oaLU75npsvq/54a8Sa025V+4+WzNDRn33upnn1s6+Ig=; b=q/ykCRK8JD/cssMkft43adWnmO
        dgFcx/5EExveHYpHaN2qOKKGko25vBzWjhhf5/NVwSP5/M/WTCNqBb4ip0t0km23eeoB95Lt1bDXf
        JOulZfz2FlZxo7iEZB51Q0Ks17fLm6Vha27xljU5mmelsOkNb5XOTZS8jn+Mukq7VcrM=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qnFiq-000178-IA; Mon, 02 Oct 2023 10:00:16 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qnFgh-0000Ft-TV; Mon, 02 Oct 2023 09:58:04 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v7 11/11] KVM: xen: allow vcpu_info content to be 'safely' copied
Date:   Mon,  2 Oct 2023 09:57:40 +0000
Message-Id: <20231002095740.1472907-12-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231002095740.1472907-1-paul@xen.org>
References: <20231002095740.1472907-1-paul@xen.org>
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

If the guest sets an explicit vcpu_info GPA then, for any of the first 32
vCPUs, the content of the default vcpu_info in the shared_info page must be
copied into the new location. Because this copy may race with event
delivery (which updates the 'evtchn_pending_sel' field in vcpu_info) we
need a way to defer that until the copy is complete.
Happily there is already a shadow of 'evtchn_pending_sel' in kvm_vcpu_xen
that is used in atomic context if the vcpu_info PFN cache has been
invalidated so that the update of vcpu_info can be deferred until the
cache can be refreshed (on vCPU thread's the way back into guest context).
So let's also use this shadow if the vcpu_info cache has been
*deactivated*, so that the VMM can safely copy the vcpu_info content and
then re-activate the cache with the new GPA. To do this, all we need to do
is stop considering an inactive vcpu_info cache as a hard error in
kvm_xen_set_evtchn_fast().

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
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

v6:
 - New in this version.
---
 arch/x86/kvm/xen.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index aafc794940e4..e645066217bb 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1606,9 +1606,6 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		WRITE_ONCE(xe->vcpu_idx, vcpu->vcpu_idx);
 	}
 
-	if (!vcpu->arch.xen.vcpu_info_cache.active)
-		return -EINVAL;
-
 	if (xe->port >= max_evtchn_port(kvm))
 		return -EINVAL;
 
-- 
2.39.2

