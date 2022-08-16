Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576C459578A
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 12:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiHPKHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 06:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiHPKHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 06:07:13 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F8C7757A
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:10:19 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d16so8516719pll.11
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ql4Rh8J556MPf2Buydi+F1rT3HDm+TzYYIHtdS57x/8=;
        b=QlXIPk1tnsd/zpFN6hx30gy9IddpPd972R7XiCXk/QO5HZqnL7w+WLw8PfmqEbnF7k
         8tOHqeALgK7l4K2dZlkqB/is5fCm911IpN31elSAU4ausVzKSDJ8Ngt2R0jiXlg+7mbK
         HAMz/mkBtxVrxvioMTaoSzTbyYt4ZgoRd3vV+HdmItFMCY4pEiG/okub0N7rGVi8YG8/
         Zc9JUraJpbcR+uj1SBWj6osq1TTDQqW/O9jjLB9n40vWlpyaNJdc0yMLWFUj71ayjmrz
         Vn9dMuZHzdR3gaFKST6GMZCDgLCF3w/t4yCP87ziPcXrYGpv0z5RApbI5SuRWNuU0ENm
         jRHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ql4Rh8J556MPf2Buydi+F1rT3HDm+TzYYIHtdS57x/8=;
        b=W2bSK1mD/kT16ozFc9lridm+teqZNLGQiO8Ci2KchMXhCj6nOkkBRCoZLWbfzr7y0L
         MMX6IyiVq4eRi43GEFgkFPwrysbRL76gYGlI3Um2N1jje7uGEP/Xj5HBK0t9+/XgkvWm
         bywzmKqByGWuaoWSDOvZa2jUkOh2xq/HzG/RnOxK1+Dmru4zVLDbtpgQeQ3G0L06TX0X
         prnirshtHl6NLaNJ6hDMAjDALFhL9hqEv0gv4fJP+YjojVE0jl7keZPCx9yUj1z6cFIQ
         rcnFQuOl4ZHlJHAoN6ZkhVI9k2Gdpz+mhe9GOWqxYupFEHv2tC9WrZH8UddPNxfOR1L8
         JGZw==
X-Gm-Message-State: ACgBeo2pbSFRp8yk2CBlI/UDHDXuRRWFVJlXwelvABoBqDIEfL9QeIDg
        V0lY1D5Hi8nmMFPnOQvWe7c=
X-Google-Smtp-Source: AA6agR7+pKsXuERDxAOvvLf6ypBbENtc17iJHdcIDjZC9cM6sHMog5M8OtfIf5ZukQDXfwFioSRTUg==
X-Received: by 2002:a17:902:ebcb:b0:168:e3ba:4b5a with SMTP id p11-20020a170902ebcb00b00168e3ba4b5amr20815261plg.11.1660637419209;
        Tue, 16 Aug 2022 01:10:19 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902db0c00b0016d7b2352desm8400920plx.244.2022.08.16.01.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 01:10:19 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 5/5] x86: create pmu group for quick pmu-scope testing
Date:   Tue, 16 Aug 2022 16:09:09 +0800
Message-Id: <20220816080909.90622-6-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816080909.90622-1-likexu@tencent.com>
References: <20220816080909.90622-1-likexu@tencent.com>
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

Any agent can run "./run_tests.sh -g pmu" for vPMU-related testcases.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/unittests.cfg | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index c5efb25..54f0437 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -189,6 +189,7 @@ file = pmu.flat
 extra_params = -cpu max
 check = /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
+groups = pmu
 
 [pmu_lbr]
 arch = x86_64
@@ -197,6 +198,7 @@ extra_params = -cpu host,migratable=no
 check = /sys/module/kvm/parameters/ignore_msrs=N
 check = /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
+groups = pmu
 
 [pmu_pebs]
 arch = x86_64
@@ -204,6 +206,7 @@ file = pmu_pebs.flat
 extra_params = -cpu host,migratable=no
 check = /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
+groups = pmu
 
 [vmware_backdoors]
 file = vmware_backdoors.flat
-- 
2.37.2

