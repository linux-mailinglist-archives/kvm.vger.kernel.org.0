Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663B16170E2
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiKBWvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiKBWvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:22 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69FBBE17
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-370624ca2e8so73167b3.16
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RHEXg6DrwxVtBtu2trES1x34pmY2ZOuzxOxhdrAW3VE=;
        b=d8EutVIlQ16kzy0dl0DDsaqaGf8e8Y6W6UwVTPpEbcwQhZD6L322qM3Cr1aZGSvBRB
         pQ+NPAb/mcL7UEQTIe44AIn/+i69QNK7MhgjczkM5atKD/WbCXw52M5ZrfUqDXrkLFVU
         Nahm/1ST+yUT+gnu3g32ltuchIwxB6bJvyHfS4QfRIqOPIPStol//yPlvtKAbUo4Dt2J
         8M4oddtyccn7aB0vwlogidkZWL2abi1IhBS7m1PQea8gXmnOa8sJkVC/D+QUSbxwULeU
         cHjrJKpbDG41a+QkxlitS9EkiYkcULDXDr5uK5D2IcWHPMoReBj7mDHPWejnmgOPAJst
         XprQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RHEXg6DrwxVtBtu2trES1x34pmY2ZOuzxOxhdrAW3VE=;
        b=coJDCFoKxhUv37jPBeKnTvVoAHsAQ5axdCK6akKCHLFS8cbwl7ko1n4Ttie4h7uU4u
         eYqK65vfkZ00b8vXfk66AJhR0RobHDZS7Obv4ZKuy/rzemr1N45GEQiZsgLZV4Zt5jN5
         4MsivnpwVnAgmXs+IiQQ9OLavMxY7wZUSbJB0wgBLJGfvJ4rgvoDUfrIIk+PDJGV9F6V
         oBBf7L2yyDrTdpzDqgI4TQQvCRy6cFlMGqg+DJYR3gX5T3CrTdpbySGuWaoOiyt3rgBi
         tp3h7wUasglMCFe+nUuEnrad6cvqt2TrNv6Nji/SPvzvkTKBDwHLtBTDINRPAkvpMHGE
         Mssg==
X-Gm-Message-State: ACrzQf0FptDQHpp8dnczUC6BmokTmCtZDCR0tjs7xgfGfn1lcxH8Zds5
        Pq80QYXpNN6ZGGvpAIWYXEROQ6SMQDI=
X-Google-Smtp-Source: AMsMyM5/oOZ0N2F3mSQj9Bdo+FQc4/5G7KjbQsEorOx6blo++72NVE6T0aUZFn30EDZrAk1X+Fz9GUpIp30=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c08b:0:b0:6bf:b095:c192 with SMTP id
 c133-20020a25c08b000000b006bfb095c192mr25494000ybf.143.1667429481069; Wed, 02
 Nov 2022 15:51:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:47 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 04/27] x86/pmu: Report SKIP when testing
 Intel LBR on AMD platforms
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

The test conclusion of running Intel LBR on AMD platforms
should not be PASS, but SKIP, fix it.

Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu_lbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index c040b146..a641d793 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -59,7 +59,7 @@ int main(int ac, char **av)
 
 	if (!is_intel()) {
 		report_skip("PMU_LBR test is for intel CPU's only");
-		return 0;
+		return report_summary();
 	}
 
 	if (!this_cpu_has_pmu()) {
-- 
2.38.1.431.g37b22c650d-goog

