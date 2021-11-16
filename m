Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F238453BCA
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 22:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhKPVoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 16:44:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhKPVoX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 16:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637098886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=c1XcR1lgQisttXwWaF7KjLI8WftPbhuxF3FmagGOsqA=;
        b=R+t0jy7ai/4djIGDy9P8MwoKRdF4bv7uhdpwQShhkUu/ysEErP+hu6+WMWk8nL/3ChfrKK
        U8lzgxEFrNClvlpzGIFl1zDSFb5x4jP91ETGXUWsJ/8pk46oj3B2CiHt0Gt5hWPnJtHk1y
        KFBdXNdH3FZZ23j4ORr8H+PXSGCbFVk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-fXmtldV0N3Kc2P68502i8g-1; Tue, 16 Nov 2021 16:41:25 -0500
X-MC-Unique: fXmtldV0N3Kc2P68502i8g-1
Received: by mail-qk1-f199.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so292653qkd.0
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 13:41:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c1XcR1lgQisttXwWaF7KjLI8WftPbhuxF3FmagGOsqA=;
        b=q5r+yTV5eQoFId6v2nSKbeDXRpQlTypHczdZHvG2uktJUeljLPn99wKpVVXRSBqMhT
         e9VaAHu5P/+viD3QM9QIiLHbDXosEY53rmf4Y7bYGDtl7vxUzJhSQzdGsPCViYFiGRLn
         CWm6ZvwF48TeriSjaFeHdxXRSinMz+IegHx1fcPYufTFFPu++AMdeYm0dW5qzO/RD5cH
         8fFT/Cao1FYxPJYudci3w2+ML6mwW03sczZXdv8/d/zs2NJGnp3p5E3LPZ5YUMX5onk+
         RkyFB4+gZ90PKJsl9RdcwJePY18z59tY+ytnG57J/LVQHIAQz+wkh+7xS00l+PgLCLrv
         XsRg==
X-Gm-Message-State: AOAM530u3a4+mrEYAsHDWaTfO2qQJq8TbYe+6Gv5UivVEAgMKpiMCyhH
        DvCv4bC6T3aDJ0/opr+c61S//l5LgSA8lLPqM4OPDkNL8rJhs4LZA7yzWbYELgWyOUq3GMUzqZj
        jeyo+CQq2vx5x
X-Received: by 2002:a05:620a:2589:: with SMTP id x9mr9064283qko.454.1637098884340;
        Tue, 16 Nov 2021 13:41:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwoK77BQgdC+mkfcZYlYgHvo0X/I00SgFa12PkUpKpwiadMtlERa/KaqLqPLXryzH0FchpoIg==
X-Received: by 2002:a05:620a:2589:: with SMTP id x9mr9064261qko.454.1637098884153;
        Tue, 16 Nov 2021 13:41:24 -0800 (PST)
Received: from fedora.myfiosgateway.com (pool-71-175-3-221.phlapa.fios.verizon.net. [71.175.3.221])
        by smtp.gmail.com with ESMTPSA id q185sm8885891qke.64.2021.11.16.13.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 13:41:23 -0800 (PST)
From:   Tyler Fanelli <tfanelli@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     berrange@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com,
        armbru@redhat.com, pbonzini@redhat.com, eblake@redhat.com,
        Tyler Fanelli <tfanelli@redhat.com>
Subject: [PATCH] sev: check which processor the ASK/ARK chain should match
Date:   Tue, 16 Nov 2021 16:38:59 -0500
Message-Id: <20211116213858.363583-1-tfanelli@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AMD ASK/ARK certificate chain differs between AMD SEV
processor generations. SEV capabilities should provide
which ASK/ARK certificate should be used based on the host
processor.

Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
---
 qapi/misc-target.json | 28 ++++++++++++++++++++++++++--
 target/i386/sev.c     | 17 ++++++++++++++---
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index 5aa2b95b7d..c64aa3ff57 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -166,6 +166,24 @@
 { 'command': 'query-sev-launch-measure', 'returns': 'SevLaunchMeasureInfo',
   'if': 'TARGET_I386' }
 
+##
+# @SevAskArkCertName:
+#
+# This enum describes which ASK/ARK certificate should be
+# used based on the generation of an AMD Secure Encrypted
+# Virtualization processor.
+#
+# @naples: AMD Naples processor (SEV 1st generation)
+#
+# @rome: AMD Rome processor (SEV 2nd generation)
+#
+# @milan: AMD Milan processor (SEV 3rd generation)
+#
+# Since: 7.0
+##
+{ 'enum': 'SevAskArkCertName',
+  'data': ['naples', 'rome', 'milan'],
+  'if': 'TARGET_I386' }
 
 ##
 # @SevCapability:
@@ -182,13 +200,18 @@
 # @reduced-phys-bits: Number of physical Address bit reduction when SEV is
 #                     enabled
 #
+# @ask-ark-cert-name: The generation in which the AMD
+#                     ARK/ASK should be derived from
+#                     (since 7.0)
+#
 # Since: 2.12
 ##
 { 'struct': 'SevCapability',
   'data': { 'pdh': 'str',
             'cert-chain': 'str',
             'cbitpos': 'int',
-            'reduced-phys-bits': 'int'},
+            'reduced-phys-bits': 'int',
+            'ask-ark-cert-name': 'SevAskArkCertName'},
   'if': 'TARGET_I386' }
 
 ##
@@ -205,7 +228,8 @@
 #
 # -> { "execute": "query-sev-capabilities" }
 # <- { "return": { "pdh": "8CCDD8DDD", "cert-chain": "888CCCDDDEE",
-#                  "cbitpos": 47, "reduced-phys-bits": 5}}
+#                  "cbitpos": 47, "reduced-phys-bits": 5,
+#                  "ask-ark-cert-name": "naples"}}
 #
 ##
 { 'command': 'query-sev-capabilities', 'returns': 'SevCapability',
diff --git a/target/i386/sev.c b/target/i386/sev.c
index eede07f11d..f30171e5ba 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -506,8 +506,9 @@ static SevCapability *sev_get_capabilities(Error **errp)
     guchar *pdh_data = NULL;
     guchar *cert_chain_data = NULL;
     size_t pdh_len = 0, cert_chain_len = 0;
-    uint32_t ebx;
-    int fd;
+    uint32_t eax, ebx;
+    int fd, es, snp;
+
 
     if (!kvm_enabled()) {
         error_setg(errp, "KVM not enabled");
@@ -534,9 +535,19 @@ static SevCapability *sev_get_capabilities(Error **errp)
     cap->pdh = g_base64_encode(pdh_data, pdh_len);
     cap->cert_chain = g_base64_encode(cert_chain_data, cert_chain_len);
 
-    host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
+    host_cpuid(0x8000001F, 0, &eax, &ebx, NULL, NULL);
     cap->cbitpos = ebx & 0x3f;
 
+    es = eax & 0x8;
+    snp = eax & 0x10;
+    if (!es && !snp) {
+	cap->ask_ark_cert_name = SEV_ASK_ARK_CERT_NAME_NAPLES;
+    } else if (es && !snp) {
+	cap->ask_ark_cert_name = SEV_ASK_ARK_CERT_NAME_ROME;
+    } else {
+	cap->ask_ark_cert_name = SEV_ASK_ARK_CERT_NAME_MILAN;
+    }
+
     /*
      * When SEV feature is enabled, we loose one bit in guest physical
      * addressing.
-- 
2.31.1

