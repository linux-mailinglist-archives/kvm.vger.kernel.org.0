Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D186167DC65
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 03:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbjA0CxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 21:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjA0CxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 21:53:02 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E9C18B08
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:52:59 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ss4so10141820ejb.11
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kGR72ilt2gtK78L/01GDQFic4BE6v4opXftOgadBZmM=;
        b=Lf3jMVkLYEooxOFsQ2UBYZ7oTLwkWaXYk4tOLe6s3JsN3C77zcAjpvXAn70onXf8aI
         pJVXZyluvJ9dCN0OyyMQxZq9gWneQ6KR6XnY/N5nJE7Q3TloRfG17rhl9s4gNf4nCTmb
         r24GTgiayDnc7Dm0HdQT4rSE5GJd3sclsvUM9mMt9YdNqHxvy5CYiarzSMgkppqwDtWS
         1mW9r/B1IL5wW//yCuHE0dOkURdYDtR/+KoeBX9lgBh32gm2HiM0J45bb8BrLQYDwUlT
         We7kQesXgNwG59l6Ag5eEAO9ZydgPdrSVGgmiY4oLyDg49GLbWLf8ecDvLU9BxLYCJdA
         0Cqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kGR72ilt2gtK78L/01GDQFic4BE6v4opXftOgadBZmM=;
        b=P/LgJpyhY0oxDZ5afh86F662by40YH+iqHi6GPVcw8rvT/iqZECp+9Z6RIxqSehJTb
         b5AgwGoK+mXKyrCyDoKDKEWKD7E3uBz5y72bLWO+in0lAlB1UJAGaCb3JgdjU+q66rLe
         g9lg35nZHEO+z5LmUTQWrdWaJcHyM/01bZK0ESa3az+DZGf27c79eAUf5Aj+mRXPrmFq
         cSf/6P0XywBBCiVjl+dCollL//oAS9egjJQB7YiNfB2vlDOKnEmoFOPvDY5oZe/cNtlI
         piAUxI2ZamXnrfU90vNtbOHNvCv4yH7wzZeCrXCIMJwKrUKLgNzOtOgaqV7JH5Rgl20N
         lpHg==
X-Gm-Message-State: AFqh2kqFwrjpBhh2k0s5a/bFivIvzSlGsb7rfuhdwmxUL0CGccbpseYK
        ondxkftTrcsjkmpso2VAFKSj7w==
X-Google-Smtp-Source: AMrXdXvH6K2KIVQ57HXDPFWTIupQQmzKHOj9PFBD+BFxcDAyzsbuY15PV1cK4uSsBwYoAKV9ae35sA==
X-Received: by 2002:a17:906:744:b0:877:9eab:118c with SMTP id z4-20020a170906074400b008779eab118cmr26664836ejb.68.1674787979362;
        Thu, 26 Jan 2023 18:52:59 -0800 (PST)
Received: from localhost (88-113-101-73.elisa-laajakaista.fi. [88.113.101.73])
        by smtp.gmail.com with ESMTPSA id q23-20020a056402041700b0048eb0886b00sm1591026edv.42.2023.01.26.18.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 18:52:58 -0800 (PST)
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
Cc:     Harald Hoyer <harald@profian.com>, Tom Dohrmann <erbse.13@gmx.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR
        (CCP) DRIVER - SE...)
Subject: [PATCH RFC 8/8] crypto: ccp: Move __sev_snp_init_locked() call inside __sev_platform_init_locked()
Date:   Fri, 27 Jan 2023 02:52:37 +0000
Message-Id: <20230127025237.269680-9-jarkko@profian.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127025237.269680-1-jarkko@profian.com>
References: <20230127025237.269680-1-jarkko@profian.com>
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

Only sev_guest_init() and sev_pci_init() also call sev_snp_init().
Address this by calling __sev_snp_init_locked() inside
__sev_platform_init_locked() before any other initialization.

Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 arch/x86/kvm/svm/sev.c       |  4 +--
 drivers/crypto/ccp/sev-dev.c | 51 +++++++++++++-----------------------
 include/linux/psp-sev.h      | 15 -----------
 3 files changed, 19 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5e4666b79689..2dd56f59fc50 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -343,11 +343,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 			goto e_free;
 
 		mutex_init(&sev->guest_req_lock);
-		ret = sev_snp_init(&argp->error, false);
-	} else {
-		ret = sev_platform_init(&argp->error);
 	}
 
+	ret = sev_platform_init(&argp->error);
 	if (ret)
 		goto e_free;
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 50e73df966ec..be040926f66a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -102,6 +102,7 @@ struct sev_data_range_list *snp_range_list;
 static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;
 
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
+static int __sev_snp_init_locked(int *error);
 
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
@@ -965,7 +966,8 @@ static int __sev_platform_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
-	int rc = 0, psp_ret = -1;
+	int psp_ret = -1;
+	int rc;
 	int (*init_function)(int *error);
 
 	if (!psp || !psp->sev_data)
@@ -976,6 +978,18 @@ static int __sev_platform_init_locked(int *error)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
+	rc = __sev_snp_init_locked(error);
+	if (rc < 0 && rc != -ENODEV)
+		return rc;
+
+	if (!sev_es_tmr) {
+		/* Obtain the TMR memory area for SEV-ES use */
+		sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
+		if (!sev_es_tmr)
+			dev_warn(sev->dev,
+				 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
+	}
+
 	if (sev_init_ex_buffer) {
 		init_function = __sev_init_ex_locked;
 		rc = sev_read_init_ex_file();
@@ -1373,6 +1387,9 @@ static int __sev_snp_init_locked(int *error)
 	struct sev_device *sev;
 	int rc = 0;
 
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENODEV;
+
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
 
@@ -1457,24 +1474,6 @@ static int __sev_snp_init_locked(int *error)
 	return rc;
 }
 
-int sev_snp_init(int *error, bool init_on_probe)
-{
-	int rc;
-
-	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
-		return -ENODEV;
-
-	if (init_on_probe && !psp_init_on_probe)
-		return 0;
-
-	mutex_lock(&sev_cmd_mutex);
-	rc = __sev_snp_init_locked(error);
-	mutex_unlock(&sev_cmd_mutex);
-
-	return rc;
-}
-EXPORT_SYMBOL_GPL(sev_snp_init);
-
 static int __sev_snp_shutdown_locked(int *error)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -2319,14 +2318,6 @@ void sev_pci_init(void)
 		}
 	}
 
-	rc = sev_snp_init(&error, true);
-	if (rc)
-		/*
-		 * Don't abort the probe if SNP INIT failed,
-		 * continue to initialize the legacy SEV firmware.
-		 */
-		dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
-
 	/*
 	 * If boot CPU supports SNP, then first attempt to initialize
 	 * the SNP firmware.
@@ -2341,12 +2332,6 @@ void sev_pci_init(void)
 		}
 	}
 
-	/* Obtain the TMR memory area for SEV-ES use */
-	sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
-	if (!sev_es_tmr)
-		dev_warn(sev->dev,
-			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
-
 	if (!psp_init_on_probe)
 		return;
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 970a9de0ed20..ef0c6941a8f4 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -794,21 +794,6 @@ struct sev_data_snp_shutdown_ex {
  */
 int sev_platform_init(int *error);
 
-/**
- * sev_snp_init - perform SEV SNP_INIT command
- *
- * @error: SEV command return code
- * @init_on_probe: indicates if called during module probe/init
- *
- * Returns:
- * 0 if the SEV successfully processed the command
- * -%ENODEV    if the SEV device is not available
- * -%ENOTSUPP  if the SEV does not support SEV
- * -%ETIMEDOUT if the SEV command timed out
- * -%EIO       if the SEV returned a non-zero return code
- */
-int sev_snp_init(int *error, bool init_on_probe);
-
 /**
  * sev_platform_status - perform SEV PLATFORM_STATUS command
  *
-- 
2.38.1

