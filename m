Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0735A7487
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 05:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiHaDfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 23:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiHaDfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 23:35:48 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555DE6AA2D;
        Tue, 30 Aug 2022 20:35:46 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id c24so12409891pgg.11;
        Tue, 30 Aug 2022 20:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=aZHvtwv2XnuRZengAlGS32mVmp48gK9Mf0I2+nyLx2U=;
        b=ozg/V1kVrSGAnHM9e5iJ5XdEDXdwPJUKf3Sb5EGVsApTZ13vLm1exUfTrb8vSa+WGX
         V7EuIRag+z/anLgaPR4pYIMn0RkoJNJOPnxs5NcDkm4bFHgTwyKhRmE4WYWzDvnHxYys
         ZtBZbQScDGTPs9XGNXrwgl2gW4p/gdNLBTEEVLMSnqAEQckSqzDJflE9iEqni92iS/Iu
         WUGM/5KBotgYVUiRdB+aWnDwdO3mzvQ7e/cnR87ioDuqAUu3Rl99GoXr/2i8u5UVAV5n
         Y1CSaT6F0Kh2lODmw78DImNoJUWEKcPvsD9OZeKF/JS0RdGJlGZh0xvzwkgl1IuVvPUz
         uolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=aZHvtwv2XnuRZengAlGS32mVmp48gK9Mf0I2+nyLx2U=;
        b=xU8YTRfeGKcnHNqjpNltDvPeXhMQmb9PmGbynFdsf/vjfghu+JZbVXyuVwLCCzcbIf
         cU4h/n+cZW3zaACBmRzoqgWfAJYzbOdNPOYXqVFh38UeaOe78Nc+D9smPXweHYNaeqNs
         tyT8A7ODZ8hyw3/nySZRLqxNc4NikoEys0g7xxdKMcrCgJX3bm7dK7cjUjyMGLq5u8ND
         Ba7hko8zFHJobLAsCbLswY4aTOYFv6pZXhfMNxPK7AesoJXucTKPf29+wpaGdyN3gjan
         7eFse4A27xzpaCsah7gi5Btti0q40I0prIwaoO5n6GWBsqloPuav4BaSa3axzNF/7b8l
         PXhA==
X-Gm-Message-State: ACgBeo3OUwt9rjywNVo5OSqyEyaPkn/GknKJs9Z3s4J7D5PtD3vz8cWc
        GeIqVoK+wW0J5HCijulyaTU=
X-Google-Smtp-Source: AA6agR4bcTmeiwN76VrnVSJbzcK//92qn7CdQi9FhPqYvV4O7mvQXTQh9g5csfCI8dri5xyq/V+hVg==
X-Received: by 2002:a05:6a00:180b:b0:536:816b:f770 with SMTP id y11-20020a056a00180b00b00536816bf770mr24652171pfa.3.1661916945757;
        Tue, 30 Aug 2022 20:35:45 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q63-20020a634342000000b0042bea8405a3sm2347022pga.14.2022.08.30.20.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 20:35:45 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "'H . Peter Anvin'" <hpa@zytor.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] perf/x86/core: Completely disable guest PEBS via guest's global_ctrl
Date:   Wed, 31 Aug 2022 11:35:24 +0800
Message-Id: <20220831033524.58561-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
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

Cc: linux-perf-users@vger.kernel.org
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
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
2.37.3

