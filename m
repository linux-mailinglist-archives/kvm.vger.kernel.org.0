Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1B57C91A
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 12:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiGUKgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 06:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbiGUKgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 06:36:03 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633812D1CE;
        Thu, 21 Jul 2022 03:36:02 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y24so1411798plh.7;
        Thu, 21 Jul 2022 03:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gDRQtRi/q/kMC+1Mbr451BbZ8n+5KHSY3o4YQBH6BZ4=;
        b=RZiQ4nF0eC6iDy4YnxcewVc4TO8dRSPbHqdWpQBYl/gJmswoium8hRY/32dzFjpr/F
         wwG+73HueMEig0tn4e4/RFEU9tK81/iMMVNbJ+um0DliNmkhdN8xzJPf0WQypRkhLvYX
         ZNEiqcBhpdyUi5t+E1r7sder7W+4SQgcCjayfmAgElNOtrpzOvvmoF3ACMRFFEeQDD7d
         IArAUR27ntGU9UtFA8UAvb4kzz+FcxavU5p6BsM7p2lNRb9lqeRJMZkpWImAH0MsyxlT
         sZuVqDnx66NQiOv9ZGfvNNJIcD9OlSBF9dj3s90fbRTM9drfN0o9j+t6adUi4Rs1FA1N
         WbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gDRQtRi/q/kMC+1Mbr451BbZ8n+5KHSY3o4YQBH6BZ4=;
        b=b7xk/aigyCANhqs8vz7wQHple/o23bC5PDRRv1K52MqC1nIZIBhGfSIgYQQmhRXuF1
         f/lJrW85YfT8SphLMNaFEcipuqFgte8DK00G42xzP7J4So0KTPM0W873d1ClFBNlQz7E
         mSgba7d3aJdngujOpngay4Wi3HN+aoD1OQS5CYbhdIuLe2N+x2JJQJ6zjyJG8ses6aAv
         QPXcF+NNqxovGENAp9Q76LmpFVxMTWs/QjUZ1W6Mg6LN+X6ic7b+jYIZZHEdYY53NAJh
         5r3oKM25BRGeRhEJQf3kiJPMOutfFD0ApYtBODLfcOD+ChhM5hGiV4PfqfEB5QrUSrJ7
         3IyQ==
X-Gm-Message-State: AJIora/HimFkQ/hY69G15GAFs3i3Hki/LqEPHWlwb9mG7mNwLM6hoT4Q
        vIqguzEZorMqoVL3+2ZxSEwQn5+QzkENaQ==
X-Google-Smtp-Source: AGRyM1uEQlbFVsHB+3J2X/Jj7VjG+qIEVzZxyu7U+D4MzljkwEKH501d7gRSg3NjBl4RzRpI2F99pg==
X-Received: by 2002:a17:902:e742:b0:16c:44b7:c8b6 with SMTP id p2-20020a170902e74200b0016c44b7c8b6mr42947535plf.140.1658399761871;
        Thu, 21 Jul 2022 03:36:01 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12-20020a65494c000000b00419aa0d9a2esm1161887pgs.28.2022.07.21.03.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:36:01 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 2/7] perf/x86/core: Completely disable guest PEBS via guest's global_ctrl
Date:   Thu, 21 Jul 2022 18:35:43 +0800
Message-Id: <20220721103549.49543-3-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220721103549.49543-1-likexu@tencent.com>
References: <20220721103549.49543-1-likexu@tencent.com>
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

When a guest PEBS counter is cross-mapped by a host counter, software
will remove the corresponding bit in the arr[global_ctrl].guest and
expect hardware to perform a change of state "from enable to disable"
via the msr_slot[] switch during the vmx transaction.

The real world is that if user adjust the counter overflow value small
enough, it still opens a tiny race window for the previously PEBS-enabled
counter to write cross-mapped PEBS records into the guest's PEBS buffer,
when arr[global_ctrl].guest has been prioritised (switch_msr_special stuff)
to switch into the enabled state, while the arr[pebs_enable].guest has not.

Close this window by clearing invalid bits in the arr[global_ctrl].guest.

Fixes: 854250329c02 ("KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index e46fd496187b..495ac447bb3a 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4052,8 +4052,9 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		/* Disable guest PEBS if host PEBS is enabled. */
 		arr[pebs_enable].guest = 0;
 	} else {
-		/* Disable guest PEBS for cross-mapped PEBS counters. */
+		/* Disable guest PEBS thoroughly for cross-mapped PEBS counters. */
 		arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
+		arr[global_ctrl].guest &= ~kvm_pmu->host_cross_mapped_mask;
 		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
 		arr[global_ctrl].guest |= arr[pebs_enable].guest;
 	}
-- 
2.37.1

