Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97E67D4CB
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 07:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfHAFOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 01:14:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37782 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729371AbfHAFO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 01:14:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so46988174wrr.4
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 22:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lW0RHrkUqApLquoqHBaQ5OfrV+rmiadrYX9W4LRi2U4=;
        b=N6FvZioPgimuehqZW58Y1C4DF550iKxDFrlioNYcwkoXMkiMRIRR9rOhULvE0alZIJ
         f56NlPLf3vzPlWvUPAvc+TSy1DHKPKmifDeYBwGQbEOs2+kgXY4U0EGj61XD5rySGlEM
         AXtedkuJKbJsnmBrZCxUBVTJMLrPwS/0b2UNHvXk4EETR66NOlT818pXxZ+ZtdXV88gR
         RVRGhJrkn5PipRKhM51i3YsPXjeJ3ixLSS6deORlK2+MAkxbpi30vw+0SrSnjNF6wDIn
         H550AULoFJq2PNKpev2+03BMlrE1zhCBB5/1u86g8AhQPi3P8WCNDVIXfZGoXZO1zQV8
         ciCQ==
X-Gm-Message-State: APjAAAW2aMcYcKkAmYyZN4Osmo6V/SlnwhSRk3TYwd/d6Tpf+R/g+yYd
        woX07n+GtjV+/cF+zkhdzc+Wf7DX2tY=
X-Google-Smtp-Source: APXvYqwzdq14++WQOuAsiG7JqsnQ4Ca3E3y8fhSOYWjN1aZAp8kI/MSMpScbD5ELoO6WQl4HHOe0/g==
X-Received: by 2002:a5d:52c5:: with SMTP id r5mr117453218wrv.146.1564636464751;
        Wed, 31 Jul 2019 22:14:24 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id a2sm73855351wmj.9.2019.07.31.22.14.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 22:14:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 3/5] x86: KVM: svm: clear interrupt shadow on all paths in skip_emulated_instruction()
Date:   Thu,  1 Aug 2019 07:14:16 +0200
Message-Id: <20190801051418.15905-4-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190801051418.15905-1-vkuznets@redhat.com>
References: <20190801051418.15905-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Regardless of the way how we skip instruction, interrupt shadow needs to be
cleared.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 80f576e05112..7c7dff3f461f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -784,13 +784,15 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 				EMULATE_DONE)
 			pr_err_once("KVM: %s: unable to skip instruction\n",
 				    __func__);
-		return;
+		goto clear_int_shadow;
 	}
 	if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
 		printk(KERN_ERR "%s: ip 0x%lx next 0x%llx\n",
 		       __func__, kvm_rip_read(vcpu), svm->next_rip);
 
 	kvm_rip_write(vcpu, svm->next_rip);
+
+clear_int_shadow:
 	svm_set_interrupt_shadow(vcpu, 0);
 }
 
-- 
2.20.1

