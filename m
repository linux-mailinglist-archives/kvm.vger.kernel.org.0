Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C308599AC3
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348705AbiHSLKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348702AbiHSLKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:09 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA9FF6196
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y141so4027612pfb.7
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ql4Rh8J556MPf2Buydi+F1rT3HDm+TzYYIHtdS57x/8=;
        b=hWiHFMXb6+MFVTZZmTw1b9P4JoH/CDLCxcyA1O8o6MnJUQ3hweHY87uCtMDs0UGVw8
         D2wba4Vd7I85zoki8pPHyybY8iUjl8fCNCPlloWyi0DrPwEL2eUahYzZnVCSxq60GeWI
         O7D/PtUqo0fa99QxfbOx6UR0oSfZEeGg9hqh/yRiJYgSknOC8QQa2ISSQVUDcBQYAFds
         SZcvP2sWcJAw0VfKbx9HBe18qSOiBA7IRo4T9am9ExVVOEuEDDlSAwNmCeHTUq9cYT5/
         CCMIEiqwXB1zVNnvEmd5XppXaho0JN2nDWZt84h5/pc7Amvi8j0vYPgXPby9o97C7U07
         ARng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ql4Rh8J556MPf2Buydi+F1rT3HDm+TzYYIHtdS57x/8=;
        b=BuYrAEw3JC59sP4n4jTjq9qDRS9h+XEWMaz3cllqqvGXMrnRqRl1oB03KAD79p0JWQ
         Qhz0mruWWmr4etJZpSVW/zzCteoQcbpoPR8knXQNfWhqLlfaLXMc4qNVhuLN8vNbS7Gn
         RsiNkKD9E9waAGe7mPwY3cwLZfMCjbPd+PAaQ1DgL/cl+qO2EdUkMfPYkJoV23uOLaEk
         5FOtBTwXJyUssBN4SsQcKg7zNsCO84A/8jOhW3QkgH+wr5JAn2zkZRruqrNmi5iIMMck
         LAiEysUHdHEi5d9J8sEKM29PFUKK3y9XMr8e/65sOcWtwvhQMDg8A7p69WkXSpXIP/gH
         Yh0A==
X-Gm-Message-State: ACgBeo02TjbJRezxaTvCnK5b/PjwJDmiy8ak8A83A77pw9Xt8GJSW3ch
        T9vzqE0ibx1StHRYIaSKqQ8=
X-Google-Smtp-Source: AA6agR6GHDYB2k/X8SDCiZT+zsVh22Jp3c/OSBri0Tw6naniRZ90C1BDGcFO9VG/6/+RUEcYFOSipw==
X-Received: by 2002:a05:6a00:1813:b0:52d:cccf:e443 with SMTP id y19-20020a056a00181300b0052dcccfe443mr7332139pfa.81.1660907407360;
        Fri, 19 Aug 2022 04:10:07 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:07 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 05/13] x86: create pmu group for quick pmu-scope testing
Date:   Fri, 19 Aug 2022 19:09:31 +0800
Message-Id: <20220819110939.78013-6-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819110939.78013-1-likexu@tencent.com>
References: <20220819110939.78013-1-likexu@tencent.com>
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

