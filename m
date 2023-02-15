Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F3069734F
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbjBOBQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjBOBQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:16:55 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425E534004
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:32 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-52ed582a847so137760477b3.1
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=75a28QXTJaFdsjx6g4R+wdHT2tgt6NGnmqWStNNEkpo=;
        b=Iw8Q2vdwA/noAgSu5p+I2tng2TkLFWwFmMLMDpqhCZUJH6FHLrlVwnGqZC7E+T+c++
         WwVqgLiQAkzWOOFOG7UworKsK6kWnyfHaBaQ9jBKGItUwk7wbg5nGqmMKHgVoUDG6M0d
         HRrSP3LzAhDUv+h1V5wMna8A+rUBR+vv8I5e97PA7WksgkZ5bI8XlBxD+zLSVLDL1aCu
         4p1ICp0e0xEnENttjWn7BOCDURaGSl3Z7du6q7F6PYE4UnjLZFSME/Ki8si4qX1zSJP3
         cnfsgw8BSj/Cpp0pCwDyE36AMmllKJ58JMmqaAQOR9mVwOxJFx5a/rR78syL3Gy95QX5
         mwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=75a28QXTJaFdsjx6g4R+wdHT2tgt6NGnmqWStNNEkpo=;
        b=Im5FteZsoTFWF9oItwOBDoEutufynFvS2a5X3vuZSTXwp+xpfXoKgtlaVvITIvR3D6
         GByXUh479jOl5jFMh0fDoUe8y4symoFlytczDBJxlaGQDpn9v/C6sy5/LwMdGhHDc9kw
         lVsxJ8wPvAX+LZDd4WNS4497H+gBQd/RkUWGoCwKjusFrjYPkGB1BcADXCfynepwvRaU
         +fcHqDH5GAMikiWFA5O02o3TgVzw2xPov6rA9ZKCSF/EEbgEVZ5sJvwiuQG7zPC2kRZ4
         4rWeZGzcaxY1u/R9pxFKVKotAwLZpbuXd9dTnIg0Je5QUWgjynlTh2LdTyHCicFfAFZh
         M/MQ==
X-Gm-Message-State: AO0yUKUPj9HP/ivn0vRUl/Ilq002LqGIsg29aLjyPkGIUEdFub7qL4yl
        nes0ghFysBUoFruPSHATp//Xj5LKByVGZQ==
X-Google-Smtp-Source: AK7set8jyzjZ/w7zGwihP0Af5Tw20Rh/Yrccj44g/TtOWlS4X6Kbr4whsu8IPoI5Z6begZB8p5TvMHZofkLS+g==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:388:b0:902:5b5c:73f7 with SMTP
 id f8-20020a056902038800b009025b5c73f7mr0ybs.12.1676423790329; Tue, 14 Feb
 2023 17:16:30 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:16:07 +0000
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-2-amoorthy@google.com>
Subject: [PATCH 1/8] selftests/kvm: Fix bug in how demand_paging_test
 calculates paging rate
From:   Anish Moorthy <amoorthy@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
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

Currently we're dividing tv_nsec by 1E8, not 1E9.

Reported-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index b0e1fc4de9e29..6809184ce2390 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 	pr_info("Overall demand paging rate: %f pgs/sec\n",
 		memstress_args.vcpu_args[0].pages * nr_vcpus /
-		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
+		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 1E9));
 
 	memstress_destroy_vm(vm);
 
-- 
2.39.1.581.gbfd45094c4-goog

