Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E418643E9E
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiLFIaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiLFIaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:30:12 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3961713E3A;
        Tue,  6 Dec 2022 00:30:07 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso5471066pjh.1;
        Tue, 06 Dec 2022 00:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CfGTpsEAU1sXOAt6OGjHmhhyP7PzExvQ+0gPINOh2xc=;
        b=P21jlRXL2QJU7i6t7mUF/MddXtJ1jdJoMOqBI33hjcHohQ8vO/IgdyHqYPshiuo8xI
         xuF5XDfe23o4J5zg4bWVPPsBrGhCZt9xcBitCiUViJv5UPmb9SpK++VUZBDLml1+wjqM
         dArieJpP/mLNpkbuXOHogdGtFGDL5eYCXaCBVC4qYwGWiioYZvlwvqK0uR/cex14lSIL
         SfHcyILIlOMW10I+kylESRVvSv18j1R1DJO2xqhCNos7/9Im1h2XANJSGi/tUqtOE+nm
         AEnF2NBSOluAeVTW+xLXbtJ2Il6+XWxpIMTkBSlJjf3/uSNLBEwnPCPQhEM01yht0ATm
         WEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CfGTpsEAU1sXOAt6OGjHmhhyP7PzExvQ+0gPINOh2xc=;
        b=pdrPCnM1Ym3XozWVIXqqf4vsEBF1ZXA8aP5+YgRAn1tQ/+wgIj9SPNPqImLQNS5A+C
         FieyBIqntUcYfAO08hyrmoGF5T00r1HykelqU91BF5/BI+M7ie1Lf8iFKXvlg9eSrxuz
         U8vJGCjsrKu5d50VpekKB8vT9LGQX4jAKN6ZBcg1p812BnEomS9wXMO++DmSdYHuXDcc
         ssXXU4v/SJsRhoBcyJtPPEsDZuaqhL2u0JuRN3dQTVeYdCGChhdClOP/WJXMbkmCeU1m
         pQwwB5mYGQbn8nZON5cP+Gs2BNqgn/oijaEuwxLRi65djZly09lw36qXs9Lbpi+QnquL
         9RbA==
X-Gm-Message-State: ANoB5pkFN06RLzRG6iQavHSbtVo6X92E9dV3lr3OEChsmL/sqgbIkEOu
        FsnOvn53fX2bgt5KF7c+vYCHe8a4BG6PsQ==
X-Google-Smtp-Source: AA0mqf7hVk5IoV7zaNKKIFAsMfYxtXj9MvXvwiOqbnkDIgShyEKbQzzQRAG/tjmUFyOYMmA7KSZHPQ==
X-Received: by 2002:a17:902:f609:b0:188:a8a2:f43a with SMTP id n9-20020a170902f60900b00188a8a2f43amr79665791plg.130.1670315406501;
        Tue, 06 Dec 2022 00:30:06 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h15-20020a056a00000f00b00574d38f4d37sm11203330pfk.45.2022.12.06.00.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 00:30:05 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH RESEND v3 0/3] KVM: x86/pmu: Enable guest PEBS for SPR and later models
Date:   Tue,  6 Dec 2022 16:29:41 +0800
Message-Id: <20221206082944.59837-1-likexu@tencent.com>
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

Let's see if this new rebased revision will satisfy everyone's appetite.

Previous:

V3:
https://lore.kernel.org/kvm/20221109082802.27543-1-likexu@tencent.com/
V2:
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

