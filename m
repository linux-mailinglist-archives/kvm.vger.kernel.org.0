Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D03718AE9
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 22:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjEaUPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 16:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjEaUPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 16:15:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7A3128
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 13:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685564104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TuLnORigzINqq3/V18Wg1hq7tnbJKaGDXcMleGYPuIg=;
        b=IxraSmCdGkm61VyRnmZuYp+oFmD61CnTiwCwQhgNJmr7zKsSibkShr89/8JyfHGAcXctfK
        FWn/wfHRrz/sjVY693stY1c54A+1zOv1Qck6LoYxdmBnQPqE8OMRazBwp1JTQPGgjXsEIg
        3HmI14AcgRX2JrxEIHfl1nqRFqeYBNk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-xN_LgMj1MpOl9OgubUTt7A-1; Wed, 31 May 2023 16:14:59 -0400
X-MC-Unique: xN_LgMj1MpOl9OgubUTt7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5F9C280228B;
        Wed, 31 May 2023 20:14:57 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF386407DEC0;
        Wed, 31 May 2023 20:14:55 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Cc:     mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 6/6] arm: pmu-chain-promotion: Increase the count and margin values
Date:   Wed, 31 May 2023 22:14:38 +0200
Message-Id: <20230531201438.3881600-7-eric.auger@redhat.com>
In-Reply-To: <20230531201438.3881600-1-eric.auger@redhat.com>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's increase the mem_access loop count by defining COUNT=250
(instead of 20) and define a more reasonable margin (100 instead
of 15 previously) so that it gives better chance to accommodate
for HW implementation variance. Those values were chosen arbitrarily
higher. Those values fix the random failures on ThunderX2 machines.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
---
 arm/pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 925f277c..62d41ea9 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -60,8 +60,8 @@
 #define ALL_CLEAR		0x0000000000000000ULL
 #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
 #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
-#define COUNT 20
-#define MARGIN 15
+#define COUNT 250
+#define MARGIN 100
 /*
  * PRE_OVERFLOW2 is set so that 1st @COUNT iterations do not
  * produce 32b overflow and 2nd @COUNT iterations do. To accommodate
-- 
2.38.1

