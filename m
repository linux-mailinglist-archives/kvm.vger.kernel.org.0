Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AEA45159C
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 21:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352249AbhKOUoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 15:44:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347671AbhKOTlO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 14:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637005093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jvsTDbSkpArzLNDx9ej91qEx5bE3E1FzwXhbMgPLJjE=;
        b=MwbvrQ0zpuxPYVWZKUzh6DkF7m+x83ZLn6DGeZ/5PJxwPo56trQPFKPz+0bBjCix5xyGkO
        AxrUjCUwZFM3ELVSeMcHIaZpDHr4p9+bkQMJVjcPEY5cX4QZhp1BA8fODjDAtCd0TYJqgN
        u48K99FjA1W+25RQJ+sAVh7DHfDR4nk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-LRfy3_uaNz6pD4YnZMAzjw-1; Mon, 15 Nov 2021 14:38:12 -0500
X-MC-Unique: LRfy3_uaNz6pD4YnZMAzjw-1
Received: by mail-qk1-f199.google.com with SMTP id bq9-20020a05620a468900b004681cdb3483so6871567qkb.23
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 11:38:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jvsTDbSkpArzLNDx9ej91qEx5bE3E1FzwXhbMgPLJjE=;
        b=OtBCIgCQj+NT4ioNUQXpJkjImrhEjqL5OU+Dlj0KA34lbvMF7KjszNg6okfT6MTDqu
         nfSgNVdm2W/MelIMXn3Szrcf34cm2GtpcQEkhAqJlL3S5ccfMQ+sZKYozlEyNTIq+wn1
         Piy9ZlOy0oQNMgCkgC8EeQZpDYh7dJMgJCkcXsZmw+9fJwfBLvp/qY2FDXJHjggaTnh3
         ex7GTHsaEGdzxxhP2waC+fAlH7WrCDGUcGwlULwSMbKjYlsLRCBmDLa4JcphNgTAKI09
         KrBSiJeupsEreLag1bsUxNlzQ3wan/XFjEUPTIs935ENEHA0z8jfWuxJfiymV2/BAe/h
         qHbQ==
X-Gm-Message-State: AOAM530+ZYeRXMarUCiY/wbxnKqhrzMuL8DtTDecUgmBRtzo7BYOPcNj
        ddPqbfxp42riTUavKEF2O4ecTtFTypFIQOnDcf24HfIXxh0+qBS034Pn6n2bR027+Y4IuPRoIyj
        PM1G9aXjhkJ6M
X-Received: by 2002:a05:622a:1050:: with SMTP id f16mr1438611qte.311.1637005092245;
        Mon, 15 Nov 2021 11:38:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQTZIZ+FxFZ6dwOuu7ePVqgoQBxNcWiErRyPXiahT0HGiP6naPvYDQlT4HNQYMJuPyVLoOSw==
X-Received: by 2002:a05:622a:1050:: with SMTP id f16mr1438591qte.311.1637005092057;
        Mon, 15 Nov 2021 11:38:12 -0800 (PST)
Received: from fedora.myfiosgateway.com (pool-71-175-3-221.phlapa.fios.verizon.net. [71.175.3.221])
        by smtp.gmail.com with ESMTPSA id l1sm2929724qkp.125.2021.11.15.11.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:38:11 -0800 (PST)
From:   Tyler Fanelli <tfanelli@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        eblake@redhat.com, armbru@redhat.com,
        Tyler Fanelli <tfanelli@redhat.com>
Subject: [PATCH] sev: allow capabilities to check for SEV-ES support
Date:   Mon, 15 Nov 2021 14:38:04 -0500
Message-Id: <20211115193804.294529-1-tfanelli@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Probe for SEV-ES and SEV-SNP capabilities to distinguish between Rome,
Naples, and Milan processors. Use the CPUID function to probe if a
processor is capable of running SEV-ES or SEV-SNP, rather than if it
actually is running SEV-ES or SEV-SNP.

Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
---
 qapi/misc-target.json | 11 +++++++++--
 target/i386/sev.c     |  6 ++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index 5aa2b95b7d..c3e9bce12b 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -182,13 +182,19 @@
 # @reduced-phys-bits: Number of physical Address bit reduction when SEV is
 #                     enabled
 #
+# @es: SEV-ES capability of the machine.
+#
+# @snp: SEV-SNP capability of the machine.
+#
 # Since: 2.12
 ##
 { 'struct': 'SevCapability',
   'data': { 'pdh': 'str',
             'cert-chain': 'str',
             'cbitpos': 'int',
-            'reduced-phys-bits': 'int'},
+            'reduced-phys-bits': 'int',
+            'es': 'bool',
+            'snp': 'bool'},
   'if': 'TARGET_I386' }
 
 ##
@@ -205,7 +211,8 @@
 #
 # -> { "execute": "query-sev-capabilities" }
 # <- { "return": { "pdh": "8CCDD8DDD", "cert-chain": "888CCCDDDEE",
-#                  "cbitpos": 47, "reduced-phys-bits": 5}}
+#                  "cbitpos": 47, "reduced-phys-bits": 5
+#                  "es": false, "snp": false}}
 #
 ##
 { 'command': 'query-sev-capabilities', 'returns': 'SevCapability',
diff --git a/target/i386/sev.c b/target/i386/sev.c
index eede07f11d..6d78dcd744 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -506,7 +506,7 @@ static SevCapability *sev_get_capabilities(Error **errp)
     guchar *pdh_data = NULL;
     guchar *cert_chain_data = NULL;
     size_t pdh_len = 0, cert_chain_len = 0;
-    uint32_t ebx;
+    uint32_t eax, ebx;
     int fd;
 
     if (!kvm_enabled()) {
@@ -534,8 +534,10 @@ static SevCapability *sev_get_capabilities(Error **errp)
     cap->pdh = g_base64_encode(pdh_data, pdh_len);
     cap->cert_chain = g_base64_encode(cert_chain_data, cert_chain_len);
 
-    host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
+    host_cpuid(0x8000001F, 0, &eax, &ebx, NULL, NULL);
     cap->cbitpos = ebx & 0x3f;
+    cap->es = (eax & 0x8) ? true : false;
+    cap->snp = (eax & 0x10) ? true : false;
 
     /*
      * When SEV feature is enabled, we loose one bit in guest physical
-- 
2.31.1

