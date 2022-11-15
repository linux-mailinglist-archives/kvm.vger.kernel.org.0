Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CA1629700
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiKOLQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiKOLQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:03 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB261C92C
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:15:57 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id d10-20020adfa34a000000b00236616a168bso2686889wrb.18
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O/NNSbnKNScLxQezfUEJjKeiglH5FHoDcqljUqXxi7g=;
        b=Mc7Ipzvl2EBGkxU/sF2iYiRh9YfNLbDn67MEPFVJegy3GCKjVsv4CIABfNxxvDHrNv
         Qxrd7LuxSTz33HdPYUI7cwpbL328VSHmfS7qtN4aKQw5R8PEGlmTtW53b+wjwJ3p/HQk
         DM90uhNiZ3wTecjmmZNdVYuk9a0RGD1HhJhS6Ggw3H+wdpkralqG76K0gjZ9SWEjR+Qb
         0qgKnLNH+KsfBh99Z+itkRANz3uzN4516GPIXukDax77Z5IPFUZBE2B4k9YWGecxtEf+
         rc1vKhNMdqk8E40na64eo49rM7NhIwrlm6AX2iAweRaKnw2hx3+nPi4A6rbAEjrvGuUe
         r1zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/NNSbnKNScLxQezfUEJjKeiglH5FHoDcqljUqXxi7g=;
        b=2qAlLY18AMI2eOoze3gws7cX6ks3udPKqml+rzrFAmhjF3XZ/IMKKk8cYpzXB+J6OS
         hrbrpfh/fIoPtxwk7TFYEA3RSS8AeJJftCKHuE/l4N3O14JDialcNh6BdRptvAwCFPq1
         460tyLYlf92iOSdTZWXG0h9RCvyyc59a5x1BE1HqKv23z41kd+wbKfjWajm50sIL12f/
         k0QuCxaRl0mQIU57bnfAGBowXO+8MUSYttX+vY026ebANLAU5IAFWQ2xWQAVg0C5Lbmz
         ud7jX6dYa+8IBaGoCMVtBNWwTwqywsD1kD4gnwIwemkCIUGwvl/bctptqT73Wcxju9xY
         jzJA==
X-Gm-Message-State: ANoB5pkdyx9mndclNzGEAGHFdql/a1B1So7Pq0UDzPTqBzSRcdvF0hwO
        g2PRkQkPqd7fyhRlHaMplFH/kTbss3BfXEUSgKg9JrOfPkuCfsh2HoS/GZD1wRM9z58B85tvDU7
        DqutlMQyZTqTaqSq/uEKwEam/kxExXoUVVdPBGxqOBIMauLUTExU5Wrc=
X-Google-Smtp-Source: AA0mqf5DK9hK8xKAZ8Br3M0Yd3LumBnZIQrrzZgrZsK0e9SbArG8LHPO+Tkph6cVRX/IuREm4iOyg/DqYA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c013:0:b0:3cf:90de:7724 with SMTP id
 c19-20020a7bc013000000b003cf90de7724mr55230wmb.18.1668510955400; Tue, 15 Nov
 2022 03:15:55 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:34 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-3-tabba@google.com>
Subject: [PATCH kvmtool v1 02/17] Make mmap_hugetlbfs() static
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function isn't used outside of util.c.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/kvm/util.h | 1 -
 util/util.c        | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/kvm/util.h b/include/kvm/util.h
index b494548..b0c3684 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -140,7 +140,6 @@ static inline int pow2_size(unsigned long x)
 }
 
 struct kvm;
-void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
 
 #endif /* KVM__UTIL_H */
diff --git a/util/util.c b/util/util.c
index 1877105..093bd3b 100644
--- a/util/util.c
+++ b/util/util.c
@@ -81,7 +81,7 @@ void die_perror(const char *s)
 	exit(1);
 }
 
-void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
+static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 {
 	char mpath[PATH_MAX];
 	int fd;
-- 
2.38.1.431.g37b22c650d-goog

