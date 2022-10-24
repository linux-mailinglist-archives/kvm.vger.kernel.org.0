Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77949609D99
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiJXJNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiJXJNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:24 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0F669BFE
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:17 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i3so8439053pfc.11
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SoScm23nDDX7JHFkbL9fpuIHnIArLeXAMMYwS7VZ3YY=;
        b=Cv1AIVMJhkLp6GyXJ78ZOLYqfoqx0pbT5xw1vZ/duXZzOUCNLP8y+snJTRCOGCfbjv
         Axv5YS4NvIM8mQHny5izQ2zEdaGH8RfuFzejpet3XH73fyfldy1hZZH6EaO09Gb8kjlG
         L8V5TxCGNaD63seu7S6gD0eewSI6ABCjhWBJQ/EfRVvUDpuhElGdBwp7zWThNK9eHb0u
         7WA2gfD7BdTVBxRKrLovgJEQqrRqqpaRcKwNwZKcmvbAEk78U4CBEDd6VdF6cYgj8lU5
         F7A2vEKNMxb0yApkN6ZuPi09WzhcSo2EYxKi5eqoXTVM+ub93hTeTbUvyhVZSnhypKBl
         DQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SoScm23nDDX7JHFkbL9fpuIHnIArLeXAMMYwS7VZ3YY=;
        b=3UfBsiAT40GNebxFDDqN0Kaw/MDXntxp/sCEmqteAjhCprAfWxLwWSaZ1GMcOSuftt
         AFVouG5MT1Or5VzmVwxBtD945kMufTYdCK7qHnyt/SwG+cD/7koTcADFFAqUxmEEOVIq
         tTROwuZnuYRAh2Ert+iiW7rewMR8iGFOm7GXDZB+il+ivOR+HFPpmhrGxjs35a0qqhJ8
         IcOJJUYQ9NpfMEubJpy+f50zACg7HXYyyk8Wjfll9hC7YjilYPnnSKko7AZvSJnogCSy
         IPxnyMUMjQPweJ4Hxuv0gNO6Bdwz9QcaFXAtIcOBNB8Pc7M7xcK5SAxpTJ0l2nOfCz4S
         sBXA==
X-Gm-Message-State: ACrzQf0dOZu9VnDhweZYUKhG+80xSg1zjDh1YRLrXoNpcu5NVyThhNt1
        4mOy1SW7eTIG49ljpMMd8eU=
X-Google-Smtp-Source: AMsMyM64Njj+AxehMevOGMPM22qPsdPAcf1dK1q7D/unw5dUFfGkkAjOS/wqfJ2JabzAT7nOHvL10A==
X-Received: by 2002:a63:6b88:0:b0:46a:ff3c:b64a with SMTP id g130-20020a636b88000000b0046aff3cb64amr27245050pgc.196.1666602796322;
        Mon, 24 Oct 2022 02:13:16 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:16 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 09/24] x86: create pmu group for quick pmu-scope testing
Date:   Mon, 24 Oct 2022 17:12:08 +0800
Message-Id: <20221024091223.42631-10-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
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

Any agent can run "./run_tests.sh -g pmu" to run all PMU tests easily,
e.g. when verifying the x86/PMU KVM changes.

Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ed65185..07d0507 100644
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
 
 [vmware_backdoors]
 file = vmware_backdoors.flat
-- 
2.38.1

