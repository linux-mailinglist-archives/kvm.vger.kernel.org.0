Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EE9609D91
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiJXJNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiJXJNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:08 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C0E5C9FA
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:07 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m2so3680248pjr.3
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O5Lq2G1/MyyEIMKYQdIKipDnUvzN9ndLiGp8vugwH/Y=;
        b=Xg47FrsXWbYWjpcPJMZ8CqmSz3we+c3KAO9n9aTM0wDM6I68HwxXQzlZH99RjEyPUm
         h3G3F2iZgYLt9+vjY1Kqxxb+hDVXX1TCY2yL5R9RorKS8OBZBnlIWb97njXfRzKUieI0
         QY0xjvZIAm9ZnByj3e+Sm7ZXIAhym15O+cumsQr7r9FxF0rvXEJbREs2Ja6Ro+1KmKs9
         tbVXh9Lq2nk4Uns+W+be8w6CIXJad2EOgfrcrLnlh9iQCgUq8TKg9i+IL9jGX8KC53VB
         GzIjNQxLtoMyLe+5dHoWqdqoQpcbCHP/T8zw2Kn0V4AqrbeRthV0KpfTTjYRFk5qiQA7
         IanQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O5Lq2G1/MyyEIMKYQdIKipDnUvzN9ndLiGp8vugwH/Y=;
        b=teAnWpz0a1aA+7fUEtIdLUqQ8ywPyLpK0qb2hlWCgT6l464i1XENfZdNV3gVOKZd7v
         i0wK9gA/nAMYM2dCuaBiv0e2BwfFYGJlMLWjf+bK9jJSu9dZxFea1D/UYgaPfkvouVhD
         ShQnEvEnujXGEBAhhPviQsohWzwoo61kQ8xlwzWnwR8K0KQ05HOz0pqNnlrlPCFYnGlc
         F4e6C3TuA9ONl/fwPRue8qGRUylEcQ5vf3+6e7ZSwvtN2t5bf7guSw+WkQ5OUUFVcq3X
         VSdYsB2ywwVQQYjIzL+YS+5W32JV78XdHDYPfVdxDK2h1hXa4lbqsVtEbAmP0ANGBtfQ
         q4rw==
X-Gm-Message-State: ACrzQf2RUxhds5iprmEMDc54w93Doo0gdx1HfMVnImizmG5nZLsD5khY
        zyX5xsR4t/V+Cm8e2roFND0=
X-Google-Smtp-Source: AMsMyM4yxKCwI70y65bo83JZwfS6ygjY/fiGXFwMQc/nnneqnwDA5wxtQ/Lm4RQTqXEj6aAJCYW7+A==
X-Received: by 2002:a17:90a:ad08:b0:212:d5f1:e0c6 with SMTP id r8-20020a17090aad0800b00212d5f1e0c6mr16551665pjq.228.1666602786513;
        Mon, 24 Oct 2022 02:13:06 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:06 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 03/24] x86/pmu: Pop up FW prefix to avoid out-of-context propagation
Date:   Mon, 24 Oct 2022 17:12:02 +0800
Message-Id: <20221024091223.42631-4-likexu@tencent.com>
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

The inappropriate prefix "full-width writes" may be propagated to
later test cases if it is not popped out.

Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 533851b..c8a2e91 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -665,6 +665,7 @@ int main(int ac, char **av)
 		report_prefix_push("full-width writes");
 		check_counters();
 		check_gp_counters_write_width();
+		report_prefix_pop();
 	}
 
 	return report_summary();
-- 
2.38.1

