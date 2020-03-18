Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7BAB189C20
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 13:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgCRMlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 08:41:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33511 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgCRMlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 08:41:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so30200031wrd.0;
        Wed, 18 Mar 2020 05:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=8f0u3uYCqa658PohJX3v+iK274a06tw/ySj5+mHDlzA=;
        b=lA1QKFmtAJu0DF/Qp0x2qESDwbw293Dcduj0/ib0aE+immiOhwJmlzB1eZWgO5InGO
         Cs6Lp+afJwVMKya4VJnd5VIxIoChV/u1OHZG8PfaC5AvBE5rC5U9G7UDIUJG2EOgUZOw
         YeV1Lgp2av+pMr3ivDZMQhcBaoW5sfVNpBILRq2h179PcXqTJo/ZK+auFlCYGwx5g8Ox
         N5cwJgLWny1ryZ0ieImVqtUwY3zOmou6fQ4mZ41u/goOl5nS04t/ZSwWxXxkG94+/b/n
         VdhcdhR/nyoDGmDtFha4sM6dfD8UKjku/NtaL9qi7bjjmCAvLspw7JypZOZZsYfDLUkS
         GmKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=8f0u3uYCqa658PohJX3v+iK274a06tw/ySj5+mHDlzA=;
        b=rdSlXMN4VnlUkL/dkfftzGYA+Eo4BWBrwjtuuU4GzR9UIjHP/5AtkoHRkcs9zOpIMg
         0Pm1Etq2Exm7AlCI5fuB3f2VbXOBb7APBq20fwtc0IeVOnTbG6iAfnAaDDOVKj390XyQ
         XmUUg8zi280srBT4M29Y8U1vZzOu34uvwhV4alw14uQecH+jidojyqOZFCo6HpYF7H/y
         yKdMJQL8m9x2hYJl+boaLqYTUHhWPJg93GD10jXPVxmn2RuIe0sDTvpk+jh3cvgVxo5N
         yZTadtaK3byEbeixNBW4R/iIo3GShtWKIPbIuSS3oujeZIs23ISivzm4KeuEOdlP+jfx
         qUvw==
X-Gm-Message-State: ANhLgQ1D4HulFLV4PtJafEi9kDLjYiNh5dkNXJ7a2R95YHKnSOXhvRMU
        I2a9k4jmznT6iEBYlNIWG/IuFheJ
X-Google-Smtp-Source: ADFU+vtf/D6MSULsPgcg3Ot8TazUpuJrBwQkuucH5iTNC5sbpCrGZMb1ZWS0I4LKHjIVMYRC8yzdNg==
X-Received: by 2002:a5d:69c1:: with SMTP id s1mr5711074wrw.351.1584535304261;
        Wed, 18 Mar 2020 05:41:44 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.174.5])
        by smtp.gmail.com with ESMTPSA id l8sm3752726wmj.2.2020.03.18.05.41.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Mar 2020 05:41:43 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: nSVM: check for EFER.SVME=1 before entering guest
Date:   Wed, 18 Mar 2020 13:41:40 +0100
Message-Id: <1584535300-6571-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EFER is set for L2 using svm_set_efer, which hardcodes EFER_SVME to 1 and hides
an incorrect value for EFER.SVME in the L1 VMCB.  Perform the check manually
to detect invalid guest state.

Reported-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 08568ae9f7a1..2125c6ae5951 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3558,6 +3558,9 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 static bool nested_vmcb_checks(struct vmcb *vmcb)
 {
+	if ((vmcb->save.efer & EFER_SVME) == 0)
+		return false;
+
 	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
 		return false;
 
-- 
1.8.3.1

