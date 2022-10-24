Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC021609D90
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiJXJNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiJXJNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:06 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FC05AC4F
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:05 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id 4so2040905pli.0
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4vcz7CUnuVPDIxBcYX4dnZVgkohHXNFdn+dJEZQQ7c=;
        b=pw+uT8VonT8IRH3tB69/PoWI88/eDpGGTIpMR050zex9Y0lh6e5aW8CZIlpm0/OepK
         T9cta8xtWnlaCN+kjgooFo1Cvbpa5/8M1PiCPQIy6TwBxSMp3jZZxQh2ZW+q/DNVWVuv
         XjoD9cxzTZKBvRdE3Hb56TbZOeVr0bEFH9uhLO0TUaZIqtDb0Yq4LbSlRzi9NnAuDgee
         s0lwESp2ko0qYKzw2hf2/o9i+/szwz08PmQz90ejL41fmmufpfQvhu5ecamIyjdlIjry
         zF0Cj62CktnvX27u1usWHBkY4UAmXPR0VCl44xKxalFfmmIPB+uhZFHbkw5KblTe45pi
         EyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k4vcz7CUnuVPDIxBcYX4dnZVgkohHXNFdn+dJEZQQ7c=;
        b=4IHaEo+exYLkWZjwTRfMve/iZ2cu8efE0s5ORYAdBT+5/Meas6gf8jb16QAZs8nK9z
         R13JWTfqm+ktdpxgjmCLplLoJvxnpEnjwS633DVVSqjFPDsQWdQluQQ1FaFPJ3lLjZy0
         MOzlUEMT0SAG6XAKBinPaacm0f7xqwnDxkSrd8qKLfUDGtTQcpLyMBU1ycyZjMqqfKV+
         wYU3rSOf1M6ZpBStSwxm3Pl7B+Gbpn+TUB7FJcPrXA8uDcqZhzUqAu/YuSUFC1b/3asV
         oFZzzGMkedq78B8DQzASllSgoKo+XXI56+DdxM84STJPlh1gFTiBnzsf/XxX4EirhlZ6
         fw0A==
X-Gm-Message-State: ACrzQf0ec9VnuWYPDfRbC1Pr8viWM8smZTyFNZlNECnTzYB3mUTKCIxi
        zUmmvvaamSagyhwLMHMuwzk=
X-Google-Smtp-Source: AMsMyM4XJXy7Fo+ZEccYTOK3Z+EwpiKBoRMlihpV2qDg6Q0JY88sifNVXu/OxjE+XAYhPU9Zs0F6IA==
X-Received: by 2002:a17:90b:3b4d:b0:20d:7844:64ba with SMTP id ot13-20020a17090b3b4d00b0020d784464bamr36744628pjb.136.1666602784937;
        Mon, 24 Oct 2022 02:13:04 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:04 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 02/24] x86/pmu: Test emulation instructions on full-width counters
Date:   Mon, 24 Oct 2022 17:12:01 +0800
Message-Id: <20221024091223.42631-3-likexu@tencent.com>
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

Move check_emulated_instr() into check_counters() so that full-width
counters could be tested with ease by the same test case.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index d278bb5..533851b 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -520,6 +520,9 @@ static void check_emulated_instr(void)
 
 static void check_counters(void)
 {
+	if (is_fep_available())
+		check_emulated_instr();
+
 	check_gp_counters();
 	check_fixed_counters();
 	check_rdpmc();
@@ -655,9 +658,6 @@ int main(int ac, char **av)
 
 	apic_write(APIC_LVTPC, PC_VECTOR);
 
-	if (is_fep_available())
-		check_emulated_instr();
-
 	check_counters();
 
 	if (this_cpu_perf_capabilities() & PMU_CAP_FW_WRITES) {
-- 
2.38.1

