Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2263882B65
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 08:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbfHFGCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 02:02:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43788 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731748AbfHFGB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 02:01:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so11999783wru.10
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 23:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k0Ev3p94bFZcOBtAj2tXYSUGySXDoFmcSIvRC97mli0=;
        b=ddbO2kZcz5sjZ4wnUTTKMm5ncm3ezHPkmla4g02GCsIY9fM96dkUgPMn2AwWUlyMXj
         ah98KYaTX3ABlnIYXtG2UeLz9Efo/01GWDnGw+MkKoky9Y1gACl76arSS6wphzc3ax9E
         azZ0fiwoM0b/eFV6kkNrKQHon4opUVkNlycG2yHRD3/RhaRSD5S1BQg5zGx6hB9dsMg/
         63qbPebdnsfGnpk9eLx3bQEcsGqmO2Jz0y/xhCbrBCF3Uha8tnvVhX9eLNB5cveXfvo6
         6uH4raZs9nBn2AJohmnIwdPxqoUWnKT+fnsiHJWJj5xrMAE5wthaZ/qhU0KxHD1pBaGy
         Zzsg==
X-Gm-Message-State: APjAAAVg4ZIB3y57pdGcEmfCogvnuUcWu8M+PeWi+hEGeXRXveSOWlLk
        QNeR/8Vc9TsKzSWzj9pqvyeuB60Aqp4=
X-Google-Smtp-Source: APXvYqwP9Zzy60aDGWWgds+ahxo2L68kGsBd9jl629Unyb7waA9fRwq/O3Jk3pB0tas0oMMvz4jHlg==
X-Received: by 2002:adf:8364:: with SMTP id 91mr2255022wrd.13.1565071315768;
        Mon, 05 Aug 2019 23:01:55 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id r5sm94216756wmh.35.2019.08.05.23.01.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 23:01:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 2/5] x86: KVM: svm: avoid flooding logs when skip_emulated_instruction() fails
Date:   Tue,  6 Aug 2019 08:01:47 +0200
Message-Id: <20190806060150.32360-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806060150.32360-1-vkuznets@redhat.com>
References: <20190806060150.32360-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7e843b340490..80f576e05112 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -782,7 +782,8 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
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

