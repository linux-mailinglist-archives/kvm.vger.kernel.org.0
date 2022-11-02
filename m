Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8362B6170E1
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiKBWvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKBWvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35423BC3E
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:20 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3735edd4083so772797b3.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0KFr9Y8Bkobvim11bxjxGXR4w41czOzgx7YyAgL15Zc=;
        b=C4n4QKVSf6yxBj4NoU2dCOFtrQndCF9Y7ZvlK0qdmE4wzuQbYIKWp88ip2ULv7whQt
         CApHSEC1HFKUQwQtMYS9dpzFJrh87LLn6eHaiGxVHa1MG2EqAQ87Qq2GVONKJOrHiVSu
         IybjsZSohGQ7RevH+zwcqtDHjkd4YAIEPPDkPmcnIjE3MJsNbF3DtMLV53pI8PaH9mfJ
         2WXhMWFRzifM3BUA4p9BEjn3jRcQ66ZqUUfdC+yXdBQl8NeSC70f24rC1Hg+0bMCXiD/
         LX7QszL8s0sWM4GB6AQtKYhp+BnS8FDnFzXafH6u0c0Al5VfDprGrlgP9NAOtyea+9Ti
         QMMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0KFr9Y8Bkobvim11bxjxGXR4w41czOzgx7YyAgL15Zc=;
        b=j31Av/8oRYr7YbqUvmTZm4POuooMXAyCUUT0lrNB0uf/ze2zqHEFwqsyYuiKcKABNR
         eceg4+cxLED5bjPHrf5rmReeJcaZ3lVQX6RxG0LhzKQaJGRH4b0kNunpNtR0sJ6EcAoy
         8WLN/Ypb2HvIZWMrnyXaldRvhDWQvMVn1FkWL0iMKZyn8d4hIIkEj27X9xygWrFYE/Ti
         716xD0CzEokTu/VvDO4+02NprPpkET+GtiBP23gxgNH7qGS32zXLsGm9nY5oHInDHH3J
         75AedwyxmoY4R1C3g4XwVNPqslhx0UXJo1hlz5ciAZ+7FB5kz4gBEEOkLiavrn9rr6/7
         rtvg==
X-Gm-Message-State: ACrzQf3Tnav6W8319dP3HCvo+ffhD1XrauwQgl6/sHcWOALjIloOPvY8
        aa+iU+EUnLZ0G2+Nl6jT77k70iOd9XI=
X-Google-Smtp-Source: AMsMyM6d04X/cYw1+U1EQGe3R1Lcgfi9r4yrBFX0YqXmzRew+DniyFW8s+xWjIjsbEwF/ZuBtMgJvZ9nzGs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e207:0:b0:6ca:268b:10c3 with SMTP id
 h7-20020a25e207000000b006ca268b10c3mr24724191ybe.407.1667429479531; Wed, 02
 Nov 2022 15:51:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:46 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 03/27] x86/pmu: Pop up FW prefix to avoid
 out-of-context propagation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The inappropriate prefix "full-width writes" may be propagated to
later test cases if it is not popped out.

Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 308a0ce0..da8c004a 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -665,6 +665,7 @@ int main(int ac, char **av)
 		report_prefix_push("full-width writes");
 		check_counters();
 		check_gp_counters_write_width();
+		report_prefix_pop();
 	}
 
 	return report_summary();
-- 
2.38.1.431.g37b22c650d-goog

