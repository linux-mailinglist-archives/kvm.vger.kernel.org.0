Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E7757364B
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 14:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbiGMMZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 08:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbiGMMZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 08:25:33 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC43BAAAE;
        Wed, 13 Jul 2022 05:25:32 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 73so10270234pgb.10;
        Wed, 13 Jul 2022 05:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TaYxKDKezkeJqxjAzRgb2Y2a2mg+MWcpNMKzdnJpiyQ=;
        b=OWtM6Kd1CxThMkelwGOXdvT0MbLgJ2lngvcGR3sxmKVPqgG6dnYenJStdePoSX95NZ
         1q5tcEGuzIJqNs6MiirgdI/5Jm2THMsvBD7acYsXKsCSJmgXFk0VGTUsh9VgjRWgSuzQ
         wl9ZzBWbRLCcY57/Ud2rZfrkaD7p5kY7yCLtXtZSm1kXcxWFVSEnS8bUzsPiLAox0Y4z
         9c49iCP7ERS3MEy+1Zo3R+aLllxEPesE1WKOANTNbIQkg7m04SSy7o96SVup2m2A96P8
         0k/mHRFzCtYHCLkdg46h8n+5nCLsm1xCiQ2h3DqkYLNH2bs1XWlGMHqjK8L2lQIzkYpF
         UMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TaYxKDKezkeJqxjAzRgb2Y2a2mg+MWcpNMKzdnJpiyQ=;
        b=2cEv8dv/ftn593URpMJU7yHm1tee/+JEJEiVm5qiktov48gf931OUgjSbYCqbJoPwh
         5dUIBSEUDjVJ/vMdywfC88XFcVKsfVh3YpjOlY24AEPr465mgM1IUBjLFA0m0v3IUwLt
         b0YLaYBqPAe2NzpCBW6H6KXGKLF+izoHqqvv7L+oWvLZa3SHY8Owq3T+UJiPSNuXuQj2
         EFfU2Il2cNRtsCLKsh52hjJAzcudYjxxDJqlR+jI5eM8Bl5K4Suk3VGl5XdN8hMReU3u
         Px/0Sg3Mb6FcUMNTlYKCHm7gNt9G+Po8xpFJY9uRx+qEuemm+XIVXj4I13wiWa5evQL3
         T5TQ==
X-Gm-Message-State: AJIora+IEMoBh6sqVcx5aeYvS4v7GPtefxQVsvmiCEVmqXCs6eo4NAYq
        psRRZjtoFGZ0XZ/aoezCwFErhr8DXH4=
X-Google-Smtp-Source: AGRyM1uxgBT+0EwaomlXbLBJGUhNRBB5BPqvi/YuDSDzAts81IV3eAeOpSvpHwPdpVMdwEu9DHJ5Yw==
X-Received: by 2002:a63:6c81:0:b0:3fd:4be3:8ee9 with SMTP id h123-20020a636c81000000b003fd4be38ee9mr2682106pgc.188.1657715131789;
        Wed, 13 Jul 2022 05:25:31 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902bb8700b0016bf1ed3489sm8719233pls.143.2022.07.13.05.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:25:31 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 2/7] perf/x86/core: Completely disable guest PEBS via guest's global_ctrl
Date:   Wed, 13 Jul 2022 20:25:01 +0800
Message-Id: <20220713122507.29236-3-likexu@tencent.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713122507.29236-1-likexu@tencent.com>
References: <20220713122507.29236-1-likexu@tencent.com>
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
2.37.0

