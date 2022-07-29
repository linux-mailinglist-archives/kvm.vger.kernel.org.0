Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959E6585008
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 14:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbiG2MWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 08:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiG2MWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 08:22:01 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317216171F
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 05:22:00 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id u3so4302933lfl.3
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 05:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OnpMDbAGT3435SYeG/PuiMkkIvduYtBcbEfOdwrgav0=;
        b=KPuPNa0tPqTmVunPM8do8wBS8wNRtGFF8MmJefwl4f13rJKccVZHIkyAQjs65+AUSI
         JDdo6dbVEhU9w+traz0cPNSgP7UtRsiMVdSrVFQLphmuLKTfsBKVKodV/UhcC+ufjw5F
         qN1hrT7ndhFppAxdURuR8iKPtKuC7UlUK36CK4Kz2NSz7NA1DyM3eQExEV/43seeRBtf
         1l7sV/H32jJXW/qIMIQSyUFnm9RyeSX8XmVN+gwVavul8DG59RusrxUPsuMMftbcLaaF
         UaEGdXQFgi2RUbtG66q1o/3FxUA+jiMHzYd9eMoTqP8OlvcIGVKkH8DcxAQd7uSU1yb/
         o1lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OnpMDbAGT3435SYeG/PuiMkkIvduYtBcbEfOdwrgav0=;
        b=5a39kWFyZzmlSm0PXOSBpBst7gqkuSrTgEB5sTarLqVP8LeA25UxY8QVnsth7FGSWW
         VKKqm6/zsNDzyRF+PzXl5c10z/l2kV3TiXZ+6MUIAbAQXqxozAf6nfZIW8a+qXWwA5EO
         5mSaoG3sN8LnIAXLTRLumjgC8/242q7H7IzyTRCiIAGZwdoZvLg0kTICOMBd2RihpTZv
         6QheQH3eJ93uLSz8kXlvZh2JFi4TqAZ9n8Q8B90PFQ0B2A541cSOPd8rI9/QygN7FEe6
         dWhZtDUsUBNKDBS78FreEp1j3lZlvzBPDwydqn60++hBVnka2jYyZ6fEcYv5kQlb7hvI
         8drA==
X-Gm-Message-State: AJIora9EZd75pxw88OCnHiiSYjPzbaw15GduM4si/ltgfCo+xdeVqLkL
        zOBay+iHBvjDSsjIl9hqpMIJUA==
X-Google-Smtp-Source: AGRyM1tyP9orVFNQ9fmvaHaNYa9Y6U90Ur/dnqX1+fl4Omo5jXLdi9XiVLpuregqAemcxeF2RKiqGg==
X-Received: by 2002:ac2:4ec7:0:b0:48a:c05b:d408 with SMTP id p7-20020ac24ec7000000b0048ac05bd408mr1105880lfr.588.1659097318515;
        Fri, 29 Jul 2022 05:21:58 -0700 (PDT)
Received: from localhost (91-154-92-55.elisa-laajakaista.fi. [91.154.92.55])
        by smtp.gmail.com with ESMTPSA id r22-20020ac25f96000000b0048a74608f16sm635414lfe.308.2022.07.29.05.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 05:21:57 -0700 (PDT)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jarkko Sakkinen <jarkko@profian.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Harald Hoyer <harald@profian.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH v2] KVM: SVM: Dump Virtual Machine Save Area (VMSA) to klog
Date:   Fri, 29 Jul 2022 15:21:50 +0300
Message-Id: <20220729122150.601-1-jarkko@profian.com>
X-Mailer: git-send-email 2.37.1
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

As Virtual Machine Save Area (VMSA) is essential in troubleshooting
attestation, dump it to the klog with the KERN_DEBUG level of priority.

Cc: Jarkko Sakkinen <jarkko@kernel.org>
Suggested-by: Harald Hoyer <harald@profian.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0c240ed04f96..c91a905436d5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -603,6 +603,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	if (printk_ratelimit()) {
+		print_hex_dump(KERN_DEBUG, "VMSA", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
+	}
+
 	return 0;
 }
 
-- 
v2:
- Use KERN_DEBUG for print_hex_dump()
- Check for ratelimit.
2.37.1

