Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC976A0005
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 01:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjBWAV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 19:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjBWAV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 19:21:57 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF492069C
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 16:21:56 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536a545bfbaso117626357b3.20
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 16:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4NJB/r/mOfYYjVweVLa4A4aCovzd7WVcQHlkU8Q3eU8=;
        b=abyOJRxxWpEdV9cL0CS8IzOm4+TwFYAtikiQ+czurdh5EYi4btFo5N7wA++4B/BzjM
         SwagfR228bDQSHHA0Mg27CCuNarEzwMC0Was/mrKwG0Y9+dcD7gxgS7Ub+QHiBbZNXNg
         P5hY1vb8mMdm76cz/YIrrESBhQmVQMizTQ90yasijpXMOEJclrn1EDYD4OrMYVkxXFED
         8099wENMmXRM/S0rTuYQiD9eXR/oRGuEyEW7hW3/ohMXJFGMv8bM43oT63NF9A33rZsR
         +VUrjBvW2yxUdVbT6XIdcpWtc7lF2G/MO+MDTSuCzngRZvHaJtge1974wGOSQ84wAVWu
         FUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4NJB/r/mOfYYjVweVLa4A4aCovzd7WVcQHlkU8Q3eU8=;
        b=79xGMY723N32UI9iJifx/avTx/5qhzgSaGf4/eUe+p/l6eBfo7sSrGuacXBcRwZ1oa
         zSQVeYMsUKIGbUV9ZPsBO6g2yopR9YpC5zP8A6svG8yQwA4p4AtXBLkAtZA5O90bLF/5
         GJVla2YLAsundP/ZHkeo6076yh6Nrh79c63l4tQZYJ9GFFuZpDFfnF0z6dM+nI+nnSA8
         cvph1jkCERnmodnuNCvOt2VPX6nbwi/j6DoOs7S7JjkR5M/WQWCOfDchDuF7BCaYLm1p
         6N3jBzibMbNR/im/qsPa+Fu1OQFq8K9k2t0eRIhiKmt81VSymClXc2hFX8ExqysfAFdu
         eRfw==
X-Gm-Message-State: AO0yUKVbZKEo7OyjSyBp9fBsFkcxF/eRfEvvY6aqFMuTGQn6hwPSHvU6
        UdEvJsZ9/9HBXHY7AMj5mG2PSlBY6fAb0WCLU3IRLw7Ow61rn2LukDVp0tiO5079oPdIr7XUvOQ
        pTbBc6uJFPSLHGFTOL0oX4H0j750IsEoir7m8CFtaV8+/4jipDMCMcV2Jn89LqkA=
X-Google-Smtp-Source: AK7set+3jIM4bIuEzRn2UCI7FN4dZCglNTHaHSfX7m99uByBm2LiHAkA8tnG0o51ER9P8sR3Inw1KMMUrAKdBg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1608:b0:8bd:4ab5:18f4 with SMTP
 id bw8-20020a056902160800b008bd4ab518f4mr1802304ybb.6.1677111715827; Wed, 22
 Feb 2023 16:21:55 -0800 (PST)
Date:   Thu, 23 Feb 2023 00:18:05 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230223001805.2971237-1-amoorthy@google.com>
Subject: [PATCH v3] KVM: selftests: Fix nsec to sec conversion in demand_paging_test.
From:   Anish Moorthy <amoorthy@google.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, amoorthy@google.com, oliver.upton@linux.dev,
        James Houghton <jthoughton@google.com>
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

demand_paging_test uses 1E8 as the denominator to convert nanoseconds to
seconds, which is wrong. Use NSEC_PER_SEC instead to fix the issue and
make the conversion obvious.

Reported-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---

v3:
- Add version number to patch
- Correct "KVM: selftests" tag in shortlog

v2: https://lore.kernel.org/all/20230216200218.1028943-1-amoorthy@google.com/
- Change to Oliver's log message

v1: https://lore.kernel.org/all/20230216200218.1028943-1-amoorthy@google.com/

 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index b0e1fc4de9e29..2439c4043fed6 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 	pr_info("Overall demand paging rate: %f pgs/sec\n",
 		memstress_args.vcpu_args[0].pages * nr_vcpus /
-		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
+		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
 
 	memstress_destroy_vm(vm);
 
-- 
2.39.2.637.g21b0678d19-goog

