Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D7659E286
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358638AbiHWLxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358545AbiHWLwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:52:24 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1501D51C7;
        Tue, 23 Aug 2022 02:32:45 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 1so5738958pfu.0;
        Tue, 23 Aug 2022 02:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=4phw6l5mgqEwcOD/rVR9pFicMsLaOxr6psvCJQqo8lE=;
        b=foZPvnATL0PWGTTfZeKbiLnnHznuv0OFDeaiOO1r2Sp4MnALv6bT26zsJaBpwqIjTM
         nvp9ITmlnjpc1xVO4TUw6Hx11a9EWy+eghMF24cHJ3ankqqNLvZyWbfnayFbVHtUv+W9
         MRwuG1KOd7xIoRtW3hvc/3S91QvV8HydPw7wLWgV8HDrxI6sSRxKTpi1nruFHe3MKtvH
         tEr2yUFnsG52eTwh+fF/JV4R+sZ9v0f0gXHtLeiTV0uqp6rp9JU9CTdXdyvqqkXezM1/
         bsrGGwqMuYy3SrLQeFy3oB8fKTpSNhI+hDLE4GFtPAtYHN3Rz4EirOx5TnykMIAd70Be
         AXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=4phw6l5mgqEwcOD/rVR9pFicMsLaOxr6psvCJQqo8lE=;
        b=EEaBdVy51Kzo9KQSPxFxq7hgiBrF51CETQIK1LNnakpWy+FYPcYnMiNkcF5JOR/Ao+
         7t4YWKP/oO5p08oN89knW1uAEmTiR8DAflST5cNpTmrX0a7uWsELCn70hHKpxLM0WPE0
         O3KWWIhQctQmOoHcu5qcZl3kiN6kgvJn6nlogm6hmZD3Lui6/8ZIHj0D/7YE4o6WPDd0
         wvsRQ+34VZwcwyBybRGEQbulIlioOhkUM6Qm1L1DaI+VBiinZv79/LwD5eLV3OE46CYC
         41MvFfQ0i595ISQqqW16jE0Yf8bZPepIUXdcgSrGvUQxGYlKKcY73ffDQgWONcIBXRQi
         qZvw==
X-Gm-Message-State: ACgBeo3B2rqu1C10bOr3LXCE7U23SkoL94zhwbZ4xW5NaoQGjmtMcW7k
        XsGhtwc5PUlo2z1fe6SvrHI=
X-Google-Smtp-Source: AA6agR7IXtimM8dnxDTdAkgMHDcvJcIiqdkbaUB3wJWRkUW39tkD/2LhybfQJOfqQpo85flgQoGYig==
X-Received: by 2002:a62:cdc2:0:b0:536:5c11:c342 with SMTP id o185-20020a62cdc2000000b005365c11c342mr13453688pfg.42.1661247164457;
        Tue, 23 Aug 2022 02:32:44 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017297a6b39dsm10057212plg.265.2022.08.23.02.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 02:32:44 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v2 1/8] perf/x86/core: Completely disable guest PEBS via guest's global_ctrl
Date:   Tue, 23 Aug 2022 17:32:14 +0800
Message-Id: <20220823093221.38075-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823093221.38075-1-likexu@tencent.com>
References: <20220823093221.38075-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 2db93498ff71..75cdd11ab014 100644
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
2.37.2

