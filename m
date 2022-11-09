Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E55A62256D
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 09:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiKII2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 03:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiKII23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 03:28:29 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66CD1EAF7;
        Wed,  9 Nov 2022 00:28:21 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g24so16453702plq.3;
        Wed, 09 Nov 2022 00:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=78wOAFoq040DHfWfXhuh/eRfSwCY7cV0LLdcrbr5FpQ=;
        b=m96a2T6TKlcIdHb8fBTDV8Ljo0gCAxle4TIb+xgJhjUtNsnipBU161Rvd5qfngeEL3
         7VnhjOOY6oS08a7qcBDvzu81yJ2FstGiSfAGo0Vd8TpzAnGjrQFxKCmSnlrR78KbPHI1
         wOV+3PAx512qGAI7bGyQ3icOrZeDTJwKJquUReuB3ELj0Rb3LDW84+KlESwZ9CMR9nhu
         XIifOILTrYemXJSzkpKpVtuZi7ZUO52upwmWZZZVxJc4m2wVDL1nPc6wHIIJz+/x/Rvo
         5bzrqgL6cvUYMdL94X/DLFIobtaa/MQvcXTNqqvAu4X+za0B12bHzjeHk4xlfue/EVkC
         hduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=78wOAFoq040DHfWfXhuh/eRfSwCY7cV0LLdcrbr5FpQ=;
        b=yy6QrD+5ZH1Sb+m88OdW6MAgRrxaslRyowE1nTjsrO+pi0EM8DEFyiaLx5OQTA+Kfn
         NVJU+hOlAeDcq1Kmw9Gq95FYUEO/QbqtiOIbbWeh92VDw5u0dqm7UWawSzDD1gbrK0qx
         Zu7cSIRMNywo1zaHsB+t3MpbU4U0Gfg5X4D9VfkwZcODm1pz+WDdHVws+oTz1Yc6TSJm
         xfrHqR5YXSgX5ypBns1GvW9EZtrRsUQJ8biH9vyr5uU/Wyma4nKtOCWdJuN7oEW19E+S
         aU6I3JQ/FXhpHuEZxZ/IAArlgYLETwr2o3uFmFnlBGcib6Jj1Iv3Xe94El/wa8PKqnM7
         b2Dw==
X-Gm-Message-State: ACrzQf3NqnrwrSM3a//L2KedvkWQpU/SFYaxdKFYHHkKGRRdBB9CwYKK
        y5ffIBWDlDB6HfRVSazgRuE=
X-Google-Smtp-Source: AMsMyM6+kaEaUqFPyoNFoqcePxx2Kg0eH4CXtBBYEy+c2noTQGJWOK0zmu1mH0fZc6kvrWslkqG5kQ==
X-Received: by 2002:a17:903:289:b0:186:a8a8:e99a with SMTP id j9-20020a170903028900b00186a8a8e99amr59617639plr.104.1667982501170;
        Wed, 09 Nov 2022 00:28:21 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b14-20020a63d30e000000b00470537b9b0asm6587700pgg.51.2022.11.09.00.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 00:28:20 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v3 0/3] KVM: x86/pmu: Enable guest PEBS for SPR and later models
Date:   Wed,  9 Nov 2022 16:27:59 +0800
Message-Id: <20221109082802.27543-1-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
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

Hi,

Finally, SPR will go live in early 2023. Virtualization support for SPR
PEBS (kvm.x86.vpmu.pebs_ept) has officially available in the Intel SDM
(June 2022), and this patch set is validated on a late stepping machine.

Let's see if this new revision will satisfy everyone's appetite.

Previous:
https://lore.kernel.org/kvm/20220922051929.89484-1-likexu@tencent.com/
V2 -> V3 Changelog:
- Add more commit message about the pdit/pdir stuff; (Sean)
- Refine confusing comments on event precise level and TNT+; (Sean)
- Use pmc_get_pebs_precise_level() instead of need_max_precise(); (Sean)
- Move HYBRID_CPU change in a separate patch; (Sean)
- Land KVM changes before perf core changes; (Sean)
- Aalign code indentation; (Sean) // VScode is quite good for kernel dev.

Like Xu (3):
  KVM: x86/pmu: Disable guest PEBS on hybird cpu due to heterogeneity
  KVM: x86/pmu: Add PRIR++ and PDist support for SPR and later models
  perf/x86/intel: Expose EPT-friendly PEBS for SPR and future models

 arch/x86/events/intel/core.c    |  1 +
 arch/x86/events/intel/ds.c      |  4 ++-
 arch/x86/kvm/pmu.c              | 45 ++++++++++++++++++++++++---------
 arch/x86/kvm/vmx/capabilities.h |  4 ++-
 4 files changed, 40 insertions(+), 14 deletions(-)

-- 
2.38.1

