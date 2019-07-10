Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377F56431F
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 09:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfGJHu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 03:50:58 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45173 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfGJHu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 03:50:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so806551pgp.12
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 00:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RCpVeCE/4Pt0egKaRjLWSwkX7/NNLaFYtjzmc1Za6/E=;
        b=T2hStThq0FgYyFRRjedpmgyn5E+TZAM84iHvjsi8QvDBFk0Q8Me6QhYCPGNbWqEfdy
         u2rJ/LcoHIZ+4KxilotNFcZiL6DIhOw1A95YXKL/c2oqlyFjH7+e2on4hUq52k1hv26F
         QAlG7glS93v9GSjlMtiTSwfg5B/7bXMOKENB227CIy8MRg824FHF1zvxr3jOjEfVoq4y
         DITfnSSlvGpb0/zTX3EPhU8Gt63K/LV95bTrpD7hxQpsSCH1RxfLI7bFr6Hu48gcZQTy
         Rywp8uW1f1ivdVCtNERrKQt9pLVDfiFKDd/o50AoyApeJYqD7IrD2mF/AVacoUyY9jYm
         P9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RCpVeCE/4Pt0egKaRjLWSwkX7/NNLaFYtjzmc1Za6/E=;
        b=HdV2tMKNlay6yzXomgrosJmNa4ztFtr2xdzb21G6efVZWkay59jcVOfvj6gtynP46c
         8dIh/2xr7WfdasJ6wGpDWY8pobWFZRZj5oS3ulPSVVloy0K5WuaT6xeoZHZJF4g2ofCV
         Xs8FpiLra3zpoMAYoIZlcpr/PkKgA0T1WvZow/IRVzFKyvzrEMSnw8QzxrwASzdtzfkM
         NaLBDDwWPTd2yM40HNOm8H7wSUXQdfFdKTFTdKP/nCKb8/kdmYSFJL27Xol/k+zAlmf/
         FyLgg38Ky/+sIziXljZjepHaOS3uE625joolozE2jrbL3ur2CdCVsJnnLJh5+S3rLFzB
         NvKw==
X-Gm-Message-State: APjAAAVeKnb7YB1ufuJQaNtuDyNfVv3ti/Vj9fvplRZaVvmQn/eT9jiC
        lBjnN2OW6S9gKARCN2fjsDlqls1gEyY=
X-Google-Smtp-Source: APXvYqyhz2MmI/imwh9JuV0s5ORV8jPe9Asmu6yP3GXced+Otgzqw9r9su1YQIRIHXIgoymkjd+eKQ==
X-Received: by 2002:a65:504c:: with SMTP id k12mr36003400pgo.252.1562745058006;
        Wed, 10 Jul 2019 00:50:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id i124sm3098615pfe.61.2019.07.10.00.50.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 00:50:57 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH] target-i386: adds PV_SCHED_YIELD CPUID feature bit
Date:   Wed, 10 Jul 2019 15:50:44 +0800
Message-Id: <1562745044-7838-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Adds PV_SCHED_YIELD CPUID feature bit.

Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
Note: kvm part is merged
v1 -> v2:
 * use bit 13 instead of bit 12 since bit 12 has user now

 target/i386/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5f07d68..f4c4b6b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -902,7 +902,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock",
             "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt",
             NULL, "kvm-pv-tlb-flush", NULL, "kvm-pv-ipi",
-            NULL, NULL, NULL, NULL,
+            NULL, "kvm-pv-sched-yield', NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             "kvmclock-stable-bit", NULL, NULL, NULL,
-- 
2.7.4

