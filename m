Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F88579923D
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343880AbjIHWaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343924AbjIHWaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:30:05 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F6A1FF0
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:30:00 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59b56dab74bso13127527b3.2
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212200; x=1694817000; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=43OsBVzgibsjHQzcaxYrViWOyyh57gKn8UrK+ylhvCI=;
        b=PcdZFQhQDmCOjiQprgu9Z4o0fwgazqXfJ6H3LNBGOfQeFxl5nBxlt4whbzmyX88uP2
         6QrV0mE9bdIcdj5w2peGgiVA+MhnVWiPZ17kzezi/lt2BvMV4nhcw+q2x5t2BYfxdHLu
         Jvu0bMrn2uESCWTCzO4m7uSmi9NFAZ1OQNsJZ12uoxM4Nus8QSHyGU+zilDin9CmtpMZ
         +khVX/s0UVQ/kEz6CLvXJrdJDADPFAainXrBmBb4TF08T75wMWwoF91FPbjmiFbWPoLr
         FasrQ6OxyjMmxSMgfiHpzjw8CTOSBF5mlVmqChd4lokBsWjlvyaq+BT75++bkQHLi3wR
         CCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212200; x=1694817000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=43OsBVzgibsjHQzcaxYrViWOyyh57gKn8UrK+ylhvCI=;
        b=W0ZRrljWUoT+pA3nHxxvFcq2T/BQ+tedq9C3RxN9V2qmwxPox4+KG2864NTjSLHkkw
         8wFmAcGy7kPZp5C2ZTvXDaKu+gVQZp2bbvbeWmQP3Xwz4PAhZdzJ8g8lrDd7qCpaA7RS
         98Wv+NdFEnGjf7vQUyJTR/ITX072xfM/v4Dnyl1zmh6sBUYiWAype0LL124oUGiguKYz
         uK7b5KwJBaUPkvG26+W59WxO/cn1iH46q79fM8RZ4w/u0R1zNjHqrEh0yajj7tMs2AJ0
         UspwQMZTpDF7ffT25C+Ntlmst4ZsMDejW0CVhwTmF6bAcJ36K2cZ3utgNyMmiI5B7gY4
         3/vA==
X-Gm-Message-State: AOJu0YwM9xm4t6ft8ZEv88K05OQtHMdij9PZxMoz4ygmLBrFqnZoMPR3
        +fUeUmbCD6rzi/z7kV/QcGVHqzLImIo+pw==
X-Google-Smtp-Source: AGHT+IG2K9vYapHGZteSKcwo3I41HEOYuLvqUgZ/ljkv2g4SRllJC/MiufE8PmX5pJDyOTUwONJY/zrQWnN7Kw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1022:b0:d80:1250:89bb with SMTP
 id x2-20020a056902102200b00d80125089bbmr87935ybt.7.1694212200222; Fri, 08 Sep
 2023 15:30:00 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:59 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-13-amoorthy@google.com>
Subject: [PATCH v5 12/17] KVM: arm64: Enable KVM_CAP_USERFAULT_ON_MISSING
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The relevant __gfn_to_pfn_memslot() call in user_mem_abort() already
uses MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/Kconfig         | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a74d721a18f6..b0b1124277e8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7788,7 +7788,7 @@ error/annotated fault.
 7.35 KVM_CAP_USERFAULT_ON_MISSING
 ---------------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 83c1e09be42e..d966a955d876 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -43,6 +43,7 @@ menuconfig KVM
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select INTERVAL_TREE
 	select XARRAY_MULTI
+        select HAVE_KVM_USERFAULT_ON_MISSING
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.42.0.283.g2d96d420d3-goog

