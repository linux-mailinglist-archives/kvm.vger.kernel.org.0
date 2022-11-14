Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2510A6279C5
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbiKNJ7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbiKNJ6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:58:24 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8890C1FCF1;
        Mon, 14 Nov 2022 01:57:09 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso10143027pjc.2;
        Mon, 14 Nov 2022 01:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8/1cVZ8FDNH+FL7lpDPpqS01r7LahosMaqUYnakKkmk=;
        b=Ajmk7nuU+z/i0n1/2VymsUa+kQ7uUdedQzTsN89DhaXeyYw30pRmM78V9jh49Wow/4
         fnspVMLTVg6b/AXkzLiOsTLBTOkBt5xCU9pA7xobaCBMaF4NbF5n7oG70HHWU4KmYnzZ
         i4bger8/RpHaD8efPAmmyEYDUqI835bjLVKClgb7CcmaTw0+ja6rrnuUlxhGsvoWdd+/
         CQQUpDPUJIv1Uu8q9/LW3vvQkQ4jUHBu2Q/AGxn0bh9s5METx71eP6rfKIxZVcnt/o4S
         s/+UMytHKCaoiliZlju09wsUs5dBe/xev/LTJ3opdJdOU6bGpucREIZuPVSpSdDyaW+u
         xmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8/1cVZ8FDNH+FL7lpDPpqS01r7LahosMaqUYnakKkmk=;
        b=oNtUMPYDoJRGGUTRkcWFFCzjNlgOWlfgJrDitveYWNRgNlTZ09Qnl7DnOTmS7vU1lR
         AC2ni+aJ9zEOF8X089X5AtpikPXVR8D0oUZ4g39yqhw/D2mDYUaU7VIwUxkUkB6YDvIS
         Kdl7oQGVdwJz+A90OT8Iw8XtxOb2b/8a6oxG8uHKUVQqff0TJrVAZ9/Kiw7kAIwGYcJP
         DavBuc75lkxm9PjftKtzpQCgWn2E+oGGTOejJhy3W+Sc21eKBnwVF5CdQKipGFpbZAIZ
         f4eLltWSzlY4fCpzxSaDGQ90UI470CT3x5ere6XNYeaZgzfKP3CcBaBrohtFa+Cy3azM
         5wAQ==
X-Gm-Message-State: ANoB5pkLd2YY/baQuSc3kOz+R3pqNVNsm75OaqJyPmDoZR98VkYK8mTS
        yNuKhnHXsCkUvM+KJqAsrjawgZcxyaBPLt2t
X-Google-Smtp-Source: AA0mqf5v9ZZ1BgBqRBmyaVFWllOj6FKTuvTPK6gKKLCip/fGxpOjImT5/y9wBPguaLXB/wqKyf/nlw==
X-Received: by 2002:a17:902:e848:b0:186:f1b6:c3dd with SMTP id t8-20020a170902e84800b00186f1b6c3ddmr12271978plg.20.1668419813701;
        Mon, 14 Nov 2022 01:56:53 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:53 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] KVM: x86: Remove unnecessary export of kvm_can_use_hv_timer()
Date:   Mon, 14 Nov 2022 17:56:04 +0800
Message-Id: <20221114095606.39785-13-likexu@tencent.com>
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

Don't export x86's kvm_can_use_hv_timer(), the helper isn't used by
KVM x86's vendor modules.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/lapic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1bb63746e991..5243e619fb0d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -160,7 +160,6 @@ bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
 		    kvm_can_post_timer_interrupt(vcpu));
 }
-EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
 
 static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-- 
2.38.1

