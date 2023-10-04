Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8047B86E7
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 19:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjJDRqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 13:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjJDRqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 13:46:44 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889BF9E;
        Wed,  4 Oct 2023 10:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From; bh=9gqPmyTqMnaI5p/Yo2lWX8v6irfTkiQJyeLI3Y/+zIE=; b=THUEtc
        unQCDvOdaaGMv//tZS+KnFKrjVgqVmY1Oz4phjWFwdFVFTpf8/tgOSvx7ptevmVImLFQv6sMrm5+l
        gx/dQCoi+DH2YtY2UJQK54HKlLwcwKTOa9ZiDNfX5WiksD2v6bdmeuKtfwrCnGAlUAPqDLNbP+pB2
        Gvs2CZjh53Y=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qo5xA-0001tA-NQ; Wed, 04 Oct 2023 17:46:32 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qo5xA-0003xm-CC; Wed, 04 Oct 2023 17:46:32 +0000
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
Subject: [PATCH v2] KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag
Date:   Wed,  4 Oct 2023 17:46:28 +0000
Message-Id: <20231004174628.2073263-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

Upstream Xen now ignores this flag [1], since the only guest kernel ever to
use it was buggy. By ignoring the flag the guest will always get a callback
if it sets a negative timeout which upstream Xen has determined not to
cause problems for any guest setting the flag.

[1] https://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=19c6cbd909

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

v2:
 - Amend the patch subject line
---
 arch/x86/kvm/xen.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 40edf4d1974c..8f1d46df0f3b 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1374,12 +1374,8 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
 			return true;
 		}
 
+		/* A delta <= 0 results in an immediate callback, which is what we want */
 		delta = oneshot.timeout_abs_ns - get_kvmclock_ns(vcpu->kvm);
-		if ((oneshot.flags & VCPU_SSHOTTMR_future) && delta < 0) {
-			*r = -ETIME;
-			return true;
-		}
-
 		kvm_xen_start_timer(vcpu, oneshot.timeout_abs_ns, delta);
 		*r = 0;
 		return true;
-- 
2.39.2

