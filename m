Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B54EF4CC85
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 13:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731394AbfFTLCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 07:02:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731328AbfFTLCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 07:02:48 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1704A30C4F41;
        Thu, 20 Jun 2019 11:02:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AC765D9E5;
        Thu, 20 Jun 2019 11:02:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 2/5] x86: KVM: svm: avoid flooding logs when skip_emulated_instruction() fails
Date:   Thu, 20 Jun 2019 13:02:37 +0200
Message-Id: <20190620110240.25799-3-vkuznets@redhat.com>
In-Reply-To: <20190620110240.25799-1-vkuznets@redhat.com>
References: <20190620110240.25799-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 20 Jun 2019 11:02:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we're unable to skip instruction with kvm_emulate_instruction() we
will not advance RIP and most likely the guest will get stuck as
consequitive attempts to execute the same instruction will likely result
in the same behavior.

As we're not supposed to see these messages under normal conditions, switch
to pr_err_once().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 982c6b9bfc90..68f1f0218c95 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -781,7 +781,8 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	if (!svm->next_rip) {
 		if (kvm_emulate_instruction(vcpu, EMULTYPE_SKIP) !=
 				EMULATE_DONE)
-			printk(KERN_DEBUG "%s: NOP\n", __func__);
+			pr_err_once("KVM: %s: unable to skip instruction\n",
+				    __func__);
 		return;
 	}
 	if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
-- 
2.20.1

