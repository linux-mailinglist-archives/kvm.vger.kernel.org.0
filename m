Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B3353424D
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 19:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245737AbiEYRj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 13:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiEYRjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 13:39:54 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7432FB0A57
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 10:39:49 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id a38so16597531pgl.9
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 10:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wpsndyAhNNOzvO9CfUTMYdePnrZa8th15Q/wlWX7zRk=;
        b=jJl0PLavOAjhhb135aJP1steR9OYWoZOsJHxcnRO+/S1BL/Tip+KKpGg2TNp9IlDgy
         51eX/47BNfK+VSvarAqyVcM/5efG+4y3dfoXojpU+fH22+tMya3LAWEqfLBZTZVgytAE
         JCeljJLKfPwID+oC/A5QWoTGyCdB0sGdzjJ1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wpsndyAhNNOzvO9CfUTMYdePnrZa8th15Q/wlWX7zRk=;
        b=ldhLevGZJPg3fCabLXAsidJy2LIHXmQNSk5NfHch65D736ovP8/jqjTNIpVAcDqSNj
         4KXj15JBP3Ak8OiDuvy+IfL9WNXfQ3fdc1JxEKO1DezP3DFQedj96Lq0HU480Ziqfzi+
         hSCRjE5L4+w7NoyZv18nCvH4DaToeiT/3qjntP2uYMbTyitTqX9RiHBWXq/02bH3a89l
         3jEqUeGDGbe6q8B+eDxh8mSZdsfGmsoCogEQfsZsfPS21FPjyeyozBEvHO9cl6etRRh5
         Zg+L9VHB3hQwUHv8QnkIJ4ExgJZTuu+3WllO8d17iGthQvhQvJ8vfCSXEloAbR23O9XO
         Wskg==
X-Gm-Message-State: AOAM530aKzjYxeQgta5Hot2azglcm3kk53QsA0R3Aqlpv81qkqPJs7WR
        HSsSUIy7Er/fLvYMhz+uW9fsFS2CbuARhg==
X-Google-Smtp-Source: ABdhPJwVZDZF8hx2uEWXzABNs5OLSAT3OY6GYxB2dfJUtfseLAXyiyU6z5gKLClcJNfVRfU68XSdZQ==
X-Received: by 2002:a05:6a02:117:b0:3fa:de2:357a with SMTP id bg23-20020a056a02011700b003fa0de2357amr17708657pgb.169.1653500388704;
        Wed, 25 May 2022 10:39:48 -0700 (PDT)
Received: from corvallis2.c.googlers.com.com (72.86.230.35.bc.googleusercontent.com. [35.230.86.72])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b0015e8d4eb1easm9797682pll.52.2022.05.25.10.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 10:39:48 -0700 (PDT)
From:   Venkatesh Srinivas <venkateshs@chromium.org>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, marcorr@google.com, venkateshs@chromium.org
Subject: [PATCH v2 1/2] KVM: Inject #GP on invalid write to APIC_SELF_IPI register
Date:   Wed, 25 May 2022 17:39:32 +0000
Message-Id: <20220525173933.1611076-1-venkateshs@chromium.org>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Orr <marcorr@google.com>

From: Venkatesh Srinivas <venkateshs@chromium.org>

The upper bytes of the x2APIC APIC_SELF_IPI register are reserved.
Inject a #GP into the guest if any of these reserved bits are set.

Signed-off-by: Marc Orr <marcorr@google.com>
Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
---
 arch/x86/kvm/lapic.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 21ab69db689b..6f8522e8c492 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2169,10 +2169,16 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 
 	case APIC_SELF_IPI:
-		if (apic_x2apic_mode(apic))
-			kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
-		else
+		/*
+		 * Self-IPI exists only when x2APIC is enabled.  Bits 7:0 hold
+		 * the vector, everything else is reserved.
+		 */
+		if (!apic_x2apic_mode(apic) || (val & ~APIC_VECTOR_MASK)) {
 			ret = 1;
+			break;
+		}
+		kvm_lapic_reg_write(apic, APIC_ICR,
+				    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
 		break;
 	default:
 		ret = 1;
-- 
2.36.1.124.g0e6072fb45-goog

