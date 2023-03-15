Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320AE6BBDA1
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 20:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjCOTxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 15:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCOTxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 15:53:10 -0400
X-Greylist: delayed 90 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Mar 2023 12:53:07 PDT
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F297CD539;
        Wed, 15 Mar 2023 12:53:07 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-11.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-11.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2cab:0:640:424b:0])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id E61F05EA33;
        Wed, 15 Mar 2023 22:51:35 +0300 (MSK)
Received: from d-tatianin-nix.HomeLAN (unknown [2a02:6b8:b081:b711::1:2a])
        by mail-nwsmtp-smtp-corp-main-11.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id Tppha50fxuQ0-tgCuJSe1;
        Wed, 15 Mar 2023 22:51:35 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1678909895; bh=Gw2gGaMBR/kL++RD1Kxfdvw3JCgSYG8IVp4wdEhSV38=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=C/aVTJuJ9Y8LoATy0YhpqZpI3gEKyo5EduCRA6y6MbCNz8jmZPIcsOxClrHydUWIp
         i0ftgx0ObaHdm4VjfQtDoCkhJbzOkqiCOvbMkOYsjEAQJq+AG2jZlyrEwvH2xkAy5Z
         o/W9xEqnj1ItvZe25tuUGFVUJXED3hKrukONr3fw=
Authentication-Results: mail-nwsmtp-smtp-corp-main-11.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm/x86: actually verify that reading MSR_IA32_UCODE_REV succeeds
Date:   Wed, 15 Mar 2023 22:51:09 +0300
Message-Id: <20230315195109.580333-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

...and return KVM_MSR_RET_INVALID otherwise.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: cd28325249a1 ("KVM: VMX: support MSR_IA32_ARCH_CAPABILITIES as a feature MSR")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7713420abab0..7de6939fc371 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1661,7 +1661,8 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 		msr->data = kvm_caps.supported_perf_cap;
 		break;
 	case MSR_IA32_UCODE_REV:
-		rdmsrl_safe(msr->index, &msr->data);
+		if (rdmsrl_safe(msr->index, &msr->data))
+			return KVM_MSR_RET_INVALID;
 		break;
 	default:
 		return static_call(kvm_x86_get_msr_feature)(msr);
-- 
2.25.1

