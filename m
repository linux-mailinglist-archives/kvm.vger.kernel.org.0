Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA82A6279C3
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiKNJ7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236970AbiKNJ61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:58:27 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB16B1FCFA;
        Mon, 14 Nov 2022 01:57:09 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso10143097pjc.2;
        Mon, 14 Nov 2022 01:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bB9HJirhisx3kp/ZaMEke/U77Qzx+ccScf9+6dZL8Nk=;
        b=CKgu1TtBXStLVDqtwlA/m7sYxkPhNeqIHQBcTqq1ULx84QTN75Ai3t+vXNZGdnkARM
         qaIqJiK+iuRtvLEsQmI7uRv8wUkPMdJquaHd+bLQPEqfPsjD07CxpLGGy/IYxzakWhHT
         aPDuQs9yrgV1+/32PksGzrhPpAyCKlRgB/x8xh3kEIKX+mAS5HGkbcarKCpHF8NBJH0V
         V5uvnzdHXVjiuK6R/qLYdAaB2D29YZfPBy1N7/3ruvUxKFd/SMk4/SF42cFkVhV9n5NU
         PjmK4b2eBcqFDOwLxK1LP8C5J5t0N1tgkryHNGGjcPqDqwe66pmwpLWuirDJsKSFa8w3
         +gbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bB9HJirhisx3kp/ZaMEke/U77Qzx+ccScf9+6dZL8Nk=;
        b=jz9w7nVfNCx6I449vjygJmG6HCynyw08tnYohzri4IpUy22N8wd54w6OmsVunT7+Kg
         fYlig+7+aZ8BJkuHOWZn08rzS/FjO4uHKdHpQBPMKpVjCz5DpUBSXXhd8ib0xAnvSJfK
         ryHjDSqJD+N2KOIG+HTRWhc50HGLWKwjYNqMd60jMJ2wEjHKIf5PMw3udAZuuRGFUYwA
         zppky+DddigpdeBE+neQ988LV4BZ9CBQRFmxP5iaapgBLIRZWcY9r0Yn63NHIjiVKxDD
         LLa9dJEYyKKthhbSW9Tr7ahawApy3epN1AzrgmZECXmnbHjZxuPiH8l62XppkDV5O1IL
         eSSA==
X-Gm-Message-State: ANoB5pkvu2f1ZeO0g818uV9rSNSyTxTgSndPo4fJjXSLvrTBZn6gxnro
        HXbI2QuOC1sitvK6tQ/YwBY=
X-Google-Smtp-Source: AA0mqf7kwrRosWCRmtuNPi4Yx6pfZ0CV447TytTF6RF1n3H/CBY+hnwRssDRzaR5W/05fyPt3XDjZA==
X-Received: by 2002:a17:90b:24e:b0:212:c6f4:fa5 with SMTP id fz14-20020a17090b024e00b00212c6f40fa5mr13278473pjb.49.1668419815362;
        Mon, 14 Nov 2022 01:56:55 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:55 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] KVM: x86: Remove unnecessary export of kvm_lapic_hv_timer_in_use()
Date:   Mon, 14 Nov 2022 17:56:05 +0800
Message-Id: <20221114095606.39785-14-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114095606.39785-1-likexu@tencent.com>
References: <20221114095606.39785-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Don't export x86's kvm_lapic_hv_timer_in_use(), the helper isn't used by
KVM x86's vendor modules.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/lapic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5243e619fb0d..f59e7db2af2f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1913,7 +1913,6 @@ bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
 
 	return vcpu->arch.apic->lapic_timer.hv_timer_in_use;
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_hv_timer_in_use);
 
 static void cancel_hv_timer(struct kvm_lapic *apic)
 {
-- 
2.38.1

