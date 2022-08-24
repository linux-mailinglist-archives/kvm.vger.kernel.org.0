Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8DA59F1B4
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbiHXDEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbiHXDDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:21 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BF37E300
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:03 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id f186-20020a636ac3000000b0042af745d56cso1424708pgc.17
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=BhHbocrPKCWrtEgUryiu/9kNor55gzFknz0ME1ugK1U=;
        b=GdyV6ryiD6+jGe1WAZaLwuIhhmQ8KqAtUicnDl0rWQeIc0xAXQv09Vy71WfT2vmzsy
         nTzloS+eXroDISBxlzv4KSAJEvAzffQXqYGO6L6btdh/Xa35lcdACO8gmB+wq9yyn/rK
         CWydCdGrjKshSbsqlHvNFh0g6IsI9sn48GpD4MUEgBMAJrI0yTtaqStl1kcsV+fIkR2v
         mRfvMQtor2hkyDGLM5jzjkTXOrbazu564xC4khA5aWrvHxlUwmMhQkT6WvJxv6Vq5r9V
         a4avCZvbeDx+moLix68MIR4R5jtVyu4wk3xV5Iq/KBKbPGG0hcT8WRXwByB0qRJYXxOO
         VCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=BhHbocrPKCWrtEgUryiu/9kNor55gzFknz0ME1ugK1U=;
        b=s65WKATNvuvDJ6CL4rtH5RaW1jnjfqEeJC14QB12GDuflPQ9/FmwZrpYMzjnSMcYbe
         6/m+/oagN9mM0VlvV6KHyTddZa76qa3y3F6H1aUHSmM2wCbijL3pfGzEHqTDYvvmijwP
         Zqos9sBvPpxo4gQT8axgllAD89w79Okk7myndgYMzVNoFZcW4h68D/P74qfUCrHYHW3o
         2t39zEXQsLEw6anqQ6v3QEX667fF8sg6mytDqay5pCCyc0vtHrOAzsH2qgO64hPDtTNv
         kFDD5DTps6GDU8p/nJ2O1nByrA8hV9mVE6jwCi/Euw9ySbagrFOCkJaUJ1odh3hOxpgc
         9DYw==
X-Gm-Message-State: ACgBeo04ixy66ag7pdfm6fkQ1ANJFdgIP5EePWOFT/wQlBOjXwJeoyFp
        Q9NHxpHrLEqaf6WKh7gAKxGPnJeshfQ=
X-Google-Smtp-Source: AA6agR4a++a1oBNhujPKbHTusT/JgWAG6Egywox/TEzvKrfPBkCALsz3eeF3RwqS8wXfur/ONmoMgrVxTp8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c9cc:b0:172:e18d:4703 with SMTP id
 q12-20020a170902c9cc00b00172e18d4703mr14050554pld.41.1661310123220; Tue, 23
 Aug 2022 20:02:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:15 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 13/36] KVM: selftests: Add ENCLS_EXITING_BITMAP{,HIGH}
 VMCS fields
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

The updated Enlightened VMCS definition has 'encls_exiting_bitmap'
field which needs mapping to VMCS, add the missing encoding.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/vmx.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 99fa1410964c..7d8c980317f7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -208,6 +208,8 @@ enum vmcs_field {
 	VMWRITE_BITMAP_HIGH		= 0x00002029,
 	XSS_EXIT_BITMAP			= 0x0000202C,
 	XSS_EXIT_BITMAP_HIGH		= 0x0000202D,
+	ENCLS_EXITING_BITMAP		= 0x0000202E,
+	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
 	TSC_MULTIPLIER			= 0x00002032,
 	TSC_MULTIPLIER_HIGH		= 0x00002033,
 	GUEST_PHYSICAL_ADDRESS		= 0x00002400,
-- 
2.37.1.595.g718a3a8f04-goog

