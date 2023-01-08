Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80725661943
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 21:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbjAHUYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 15:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbjAHUYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 15:24:20 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E19FF5A4
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 12:24:19 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id v25so9979114lfe.12
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 12:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9RKhBj64YrGDgXaenCnk38khEC4PTOlAR4b5SORehLE=;
        b=crYBvuwx12qdFGVvrOl8neMcQdVhQqr4cNtM4ua/EAUTmz34scR0o8RS3bqgt+nLwP
         2UI+Euz+1y7j6bKfkCXMhCwkMl32Y8xts17IAgYYt6w0Td+nd7mcLJHByn44gDwCM2Ek
         SYE6adNKxCxeBB630mbJF+xM5YZZpZQFYRgG29iCW9EkICfeoxFlljkyK9d/mN/j5a73
         QrZuBhXO1I4LdLILxPJY4wK/LrQcZDcKxpE6PM+wXuKfwL+ntm3JCU1jGKqa2yc2ic4C
         g2qKeDDYONNoxXjhz2xVifhrGnEN+qN6RWo0YTx2eN5LwU+6MLnP9C1MvGpWqC6e/Ydc
         2eQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9RKhBj64YrGDgXaenCnk38khEC4PTOlAR4b5SORehLE=;
        b=2z8ZbVLkVicy6At06mlCxUXWtyzOogjKsudn7Wc04M9VCf9L0E9muPwWrl4dyKRq0/
         fFL+QlTXLAJayLDbiEvErAgpBRAjOGODvU+HUJf+vLdr2ACQsg36E1iG0rmaIMAb7X8y
         buXKnVZ45GPNKSpVqilvtLp1PDksCPSJ4avXkTSqDCga07dgPYck3Lo2uXN5wT59X29C
         Fzqln0/C8ViHGfdmZ42qs+7LpXOW6/mVuQBekRiXd3ncg8n1sUDkRnv3iJG4leNA+0xu
         8VDvAjVNUVeajvH42hv+CeJ81HUNmxqFCrzF6RERgzoVkV/9TwBPfM+SHlmIEZQOVnZd
         ajfw==
X-Gm-Message-State: AFqh2kooUQ3ubHn8gf/6+6j8i9oyD1XMkBoCp3FGdQqM8JDMV7JQMaaU
        GdId81r+jTVSyKj2cYWxuq8nFg==
X-Google-Smtp-Source: AMrXdXuhcg3GB/YJ2ZoVGa+/QfQ8Ub5XkF/qxTJtW1ugMW8laWqeK9Eh47TMdV/0NgiXYCuLiMnb3A==
X-Received: by 2002:a05:6512:22c1:b0:4cb:783:54cd with SMTP id g1-20020a05651222c100b004cb078354cdmr15534958lfu.17.1673209457817;
        Sun, 08 Jan 2023 12:24:17 -0800 (PST)
Received: from localhost ([85.202.81.211])
        by smtp.gmail.com with ESMTPSA id u7-20020ac258c7000000b004a100c21eaesm1213445lfo.97.2023.01.08.12.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 12:24:17 -0800 (PST)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     David Rientjes <rientjes@google.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR
        (CCP) DRIVER - SE...)
Subject: [PATCH v2] crypto: ccp: Sanitize sev_platform_init() error messages
Date:   Sun,  8 Jan 2023 20:24:05 +0000
Message-Id: <20230108202407.104963-1-jarkko@profian.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following functions end up calling sev_platform_init() or
__sev_platform_init_locked():

* sev_guest_init()
* sev_ioctl_do_pek_csr
* sev_ioctl_do_pdh_export()
* sev_ioctl_do_pek_import()
* sev_ioctl_do_pek_pdh_gen()
* sev_pci_init()

However, only sev_pci_init() prints out the failed command error code, and
even there the error message does not specify, SEV which command failed.

Address this by printing out the SEV command errors inside
__sev_platform_init_locked(), and differentiate between DF_FLUSH, INIT and
INIT_EX commands.  As a side-effect, @error can be removed from the
parameter list.

This extra information is particularly useful if firmware loading and/or
initialization is going to be made more robust, e.g. by allowing firmware
loading to be postponed.

Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
v2:
* Address David Rientjes's feedback:
  https://lore.kernel.org/all/6a16bbe4-4281-fb28-78c4-4ec44c8aa679@google.com/
* Remove @error.
* Remove "SEV_" prefix: it is obvious from context so no need to make klog
  line longer.
---
 arch/x86/kvm/svm/sev.c       |  2 +-
 drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++----------------
 include/linux/psp-sev.h      |  4 +---
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index efaaef2b7ae1..42e6bd637896 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -254,7 +254,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_no_asid;
 	sev->asid = asid;
 
-	ret = sev_platform_init(&argp->error);
+	ret = sev_platform_init();
 	if (ret)
 		goto e_free;
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 06fc7156c04f..3b66cb1495d4 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -440,7 +440,7 @@ static int __sev_init_ex_locked(int *error)
 	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
 }
 
-static int __sev_platform_init_locked(int *error)
+static int __sev_platform_init_locked(void)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
@@ -476,19 +476,21 @@ static int __sev_platform_init_locked(int *error)
 		dev_err(sev->dev, "SEV: retrying INIT command because of SECURE_DATA_INVALID error. Retrying once to reset PSP SEV state.");
 		rc = init_function(&psp_ret);
 	}
-	if (error)
-		*error = psp_ret;
-
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: %s failed error %#x",
+			sev_init_ex_buffer ? "CMD_INIT_EX" : "CMD_INIT", psp_ret);
 		return rc;
+	}
 
 	sev->state = SEV_STATE_INIT;
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
-	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
-	if (rc)
+	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &psp_ret);
+	if (rc) {
+		dev_err(sev->dev, "SEV: CMD_DF_FLUSH failed error %#x", psp_ret);
 		return rc;
+	}
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
@@ -498,12 +500,12 @@ static int __sev_platform_init_locked(int *error)
 	return 0;
 }
 
-int sev_platform_init(int *error)
+int sev_platform_init(void)
 {
 	int rc;
 
 	mutex_lock(&sev_cmd_mutex);
-	rc = __sev_platform_init_locked(error);
+	rc = __sev_platform_init_locked();
 	mutex_unlock(&sev_cmd_mutex);
 
 	return rc;
@@ -610,7 +612,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
 		return -EPERM;
 
 	if (sev->state == SEV_STATE_UNINIT) {
-		rc = __sev_platform_init_locked(&argp->error);
+		rc = __sev_platform_init_locked();
 		if (rc)
 			return rc;
 	}
@@ -653,7 +655,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 cmd:
 	if (sev->state == SEV_STATE_UNINIT) {
-		ret = __sev_platform_init_locked(&argp->error);
+		ret = __sev_platform_init_locked();
 		if (ret)
 			goto e_free_blob;
 	}
@@ -849,7 +851,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 
 	/* If platform is not in INIT state then transition it to INIT */
 	if (sev->state != SEV_STATE_INIT) {
-		ret = __sev_platform_init_locked(&argp->error);
+		ret = __sev_platform_init_locked();
 		if (ret)
 			goto e_free_oca;
 	}
@@ -973,7 +975,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 		if (!writable)
 			return -EPERM;
 
-		ret = __sev_platform_init_locked(&argp->error);
+		ret = __sev_platform_init_locked();
 		if (ret)
 			return ret;
 	}
@@ -1335,10 +1337,9 @@ void sev_pci_init(void)
 		return;
 
 	/* Initialize the platform */
-	rc = sev_platform_init(&error);
+	rc = sev_platform_init();
 	if (rc)
-		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
-			error, rc);
+		dev_err(sev->dev, "SEV: failed to INIT rc %d\n", rc);
 
 	return;
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 1595088c428b..2f8681b753d0 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -536,8 +536,6 @@ struct sev_data_attestation_report {
 /**
  * sev_platform_init - perform SEV INIT command
  *
- * @error: SEV command return code
- *
  * Returns:
  * 0 if the SEV successfully processed the command
  * -%ENODEV    if the SEV device is not available
@@ -545,7 +543,7 @@ struct sev_data_attestation_report {
  * -%ETIMEDOUT if the SEV command timed out
  * -%EIO       if the SEV returned a non-zero return code
  */
-int sev_platform_init(int *error);
+int sev_platform_init(void);
 
 /**
  * sev_platform_status - perform SEV PLATFORM_STATUS command
-- 
2.38.1

