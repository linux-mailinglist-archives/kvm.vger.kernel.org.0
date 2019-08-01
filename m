Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB097D4C4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 07:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfHAFO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 01:14:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42366 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729314AbfHAFOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 01:14:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id x1so22167815wrr.9
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 22:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k0Ev3p94bFZcOBtAj2tXYSUGySXDoFmcSIvRC97mli0=;
        b=fuqiLmJwCsh6T4PRhlAQ0QnKWR3bNqQbT4MKdljI3WTgtxBQLv9M1iecaiMp7atA3R
         araS1F9eJ01sr68mYgcIMgeSQ9kUbmOLtSI21B0iywV9MLR+QC0felRXWHB7h5u8U9ij
         PbDiUb/yS7dSI9VYEFbCxHxfknjSPhLYh29XG3nmdkrJiA5/m4210UZC8WC66TDBBt2t
         FEdA8wLkFDQGZIQRirShVo/rgFWaiMT2gxFxKWYRQ59HIdegUdZPPybJTlnyo2WoNkgr
         7eNT0KNoZ2fBZF3xz0oCLKDBtcz3DTahOlvMtNZIVXkbIoVGfphHEtT4RyuoM9KQ7p9o
         vEvw==
X-Gm-Message-State: APjAAAVq6TvEyLIbt/KUfVJ3mGaq6aP9ZJ8iXBLba/f5LutGRJDS7+Y3
        O2IdYWQ06bth8lNZ3ncdUGmxMHctKuI=
X-Google-Smtp-Source: APXvYqxFMKDgaHVtw5HXmLs+H9FxYBBsQIrfWfc/Wtqd3xYMD85MvLpK0srCqZOwviF6l316rS7CQg==
X-Received: by 2002:a5d:5448:: with SMTP id w8mr137051859wrv.180.1564636463692;
        Wed, 31 Jul 2019 22:14:23 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id a2sm73855351wmj.9.2019.07.31.22.14.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 22:14:23 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 2/5] x86: KVM: svm: avoid flooding logs when skip_emulated_instruction() fails
Date:   Thu,  1 Aug 2019 07:14:15 +0200
Message-Id: <20190801051418.15905-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190801051418.15905-1-vkuznets@redhat.com>
References: <20190801051418.15905-1-vkuznets@redhat.com>
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

