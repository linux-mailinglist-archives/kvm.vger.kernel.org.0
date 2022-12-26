Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21A9656261
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 13:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiLZMDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 07:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiLZMDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 07:03:39 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9821630B
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 04:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hpSTj81T7VQFWhZJUH3ju9ct0rByvUkHLq1nRl5GL9c=; b=hSO/n+6yc4sjxw/6NREXOSPLJ0
        iWJyVRD4Xw1u+oh3v6JbWHeY2MpilZ26zHlcz6P8ozCglMtdT4WJ06301xGB8itQC6D98anFkrBxH
        5/eh4AVEQkGTbgqyAJmkBNCBaJFgUe+acBaMVNun/s3AV3BMclS4OoP8mY7IimIPFULP6nAsqC2vv
        QyC7WTh/uMflTGnyQ92i6jrqODQh+eG4thu1ecjmftb445+pMCKlK1YcdzevfvHmClW4nQtOuIoc0
        sOFWeD/pmWfkSv/i7hst9q7n6TI15VH7KMUJbbJbCsArQTsg/AlxCePSviO3//k9R0m9I3M8U5emZ
        Odf5qDeA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p9mCM-00FJcN-1A;
        Mon, 26 Dec 2022 12:03:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p9mCO-004ilj-O3; Mon, 26 Dec 2022 12:03:20 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        Paul Durrant <paul@xen.org>
Subject: [PATCH 1/6] KVM: x86/xen: Fix memory leak in kvm_xen_write_hypercall_page()
Date:   Mon, 26 Dec 2022 12:03:15 +0000
Message-Id: <20221226120320.1125390-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <b36fa02bc338d6892e63e37768bf47f035339e30.camel@infradead.org>
References: <b36fa02bc338d6892e63e37768bf47f035339e30.camel@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

Release page irrespectively of kvm_vcpu_write_guest() return value.

Suggested-by: Paul Durrant <paul@xen.org>
Fixes: 23200b7a30de ("KVM: x86/xen: intercept xen hypercalls if enabled")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Message-Id: <20221220151454.712165-1-mhal@rbox.co>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d7af40240248..d1a98d834d18 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1069,6 +1069,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
 				  : kvm->arch.xen_hvm_config.blob_size_32;
 		u8 *page;
+		int ret;
 
 		if (page_num >= blob_size)
 			return 1;
@@ -1079,10 +1080,10 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
-		if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
-			kfree(page);
+		ret = kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE);
+		kfree(page);
+		if (ret)
 			return 1;
-		}
 	}
 	return 0;
 }
-- 
2.35.3

