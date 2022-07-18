Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DDD5786B2
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiGRPtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 11:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiGRPtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 11:49:18 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF45265D
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:49:18 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id l71-20020a63914a000000b00419deb1ba88so3955941pge.5
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cmJ2PM63bOnylY+PhF6moARZAV6IMnlTPoAZtyO2Gn4=;
        b=CtWk6HRGLzw+0N7cur63mkAt7Igfoix9q+cH9JMaZKKYjXJT1/B142/0+zAj9ZBg7q
         L8TfOyUC6CKGDVRk1pgcruXZt+1i3ePtiWWyJcl5tOL/hnogF/688Jok7Y8kgKFGE7Ev
         ZhoJgO46P65kapB0S4U/iYmNXuCQOGD7pI/7pwY/WOivkdJkEnKID4dh0KJZRZi+M3wA
         lFu6p3ALSgN82+zUqp316tY4YxeiDTqHECMJk78qPh7RRuIy/0pInJ7RbJx8ueyuWZ0n
         Uc/77odm+I6spCmJ21Mj7CSzxZDptZkxUG/yFkILbJ36TLAF0wUzbxnF+49zGgw2vhbC
         P5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cmJ2PM63bOnylY+PhF6moARZAV6IMnlTPoAZtyO2Gn4=;
        b=wk9Js6iq0GDqDbxVZNYScXMR8FgfYEk3VRNGqE4jMOAb5KcH0S966rzWtiYTgnK7QO
         f61EjjfBcy0xSj4+71U59N7vqKUTqbAdsK48j9defgjyjZk2PhNs65BhbP6pTMyYCxlw
         Mavekd4DTuKrqgAq7D/IxXNwQpYfB7iJLY0va+bVa88wqYrvdhq9Y82g1HEeFtolxZ1Q
         jjmlwbeSMxpa2Xb1GxT4QgezvHg/tv2WWzz9Y4US3eOmpISgeZK1LhDHAOln5J4taoEd
         aTlmSrfUJsoKEeYcXfTeRDNvVTbRg2pWcrAPU4VC2Kqumv4NMIlqS/Hol90FIGvaScPy
         jf4w==
X-Gm-Message-State: AJIora/LPdMb/73/jeIH63+BH3+2z+LBiurj+ehcNx8qTc5NsD7AIy0E
        rWYQOLoqbbydn5bfj5lTmKIaKhD45ky+8neu74+voZz6wubMT9pqojv8jTKtg33HbsKoXcD5psJ
        UAvpHdxgKHmeh2vaCt4OWXB/KRUzm9uXg8akGcfZqzB2gs2LjRxGaJhEg6DU4k6o=
X-Google-Smtp-Source: AGRyM1vRjKRJK0biQU71Mf3Gei7WSM/6ywPga2c58wN1Z4pm6Iwg/dCB70UwDq41UZuhntEmYbWJJPEovZ9JvA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:88d5:0:b0:52a:ea1f:50c6 with SMTP id
 k21-20020aa788d5000000b0052aea1f50c6mr28429498pff.81.1658159357794; Mon, 18
 Jul 2022 08:49:17 -0700 (PDT)
Date:   Mon, 18 Jul 2022 08:49:09 -0700
In-Reply-To: <20220718154910.3923412-1-ricarkol@google.com>
Message-Id: <20220718154910.3923412-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220718154910.3923412-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [kvm-unit-tests PATCH 2/3] arm: pmu: Reset the pmu registers before
 starting some tests
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Some registers like the PMOVS reset to an architecturally UNKNOWN value.
Most tests expect them to be reset (mostly zeroed) using pmu_reset().
Add a pmu_reset() on all the tests that need one.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index fd838392..a7899c3c 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -884,6 +884,7 @@ static bool check_cycles_increase(void)
 	bool success = true;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
@@ -938,6 +939,7 @@ static bool check_cpi(int cpi)
 	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
-- 
2.37.0.170.g444d1eabd0-goog

