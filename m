Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F4B597909
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 23:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbiHQVmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 17:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiHQVmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 17:42:18 -0400
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820E2A7AA6
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:42:17 -0700 (PDT)
Received: by mail-ot1-x349.google.com with SMTP id x22-20020a9d6d96000000b00636eec5dcb3so9257otp.9
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=FsIWvgrdJ0IkK8c0ypetT848kCEFw2zr6rdtinhCIaI=;
        b=ml3zvq9hHFoaayckrrOOo50cHm5QEkXBxg/HVDHZgu7hRz8PeqJWkoVgN/u7lFIfFs
         jpf9FGGgurVF7EeCuSFhISVwc48/6NSHbR7YQGsfat3GP5drAKwMkMUjSuCn/zO79gXT
         ijbQ+DGd1iUr1IoZxdbeEzh1OIq+iYN/+qZ/gSPZR/RkIj/Qpy2u3gojcNQCWFpq9+g7
         Zio44HJpZzllSBB/P48zZbj+MsFrlTS5LjxkIz46wdSSZotKrY6V7DBec9abbgg0mQGt
         8UTAOKRrnNYe9MoYYzUI/E86+y+iGlXzZIPtWiFZfTBLSKVj7DiMssViAc0wr+aRUE2F
         GOpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=FsIWvgrdJ0IkK8c0ypetT848kCEFw2zr6rdtinhCIaI=;
        b=5kTyfb+LhbDqTP3iruPIjK/Z4RAWpm+AnMGDPNWicdJfrLr9LAvWPZpsR7dRp4s6wf
         Ypi8XaxhCAc9WqtZEHqeIpQDGXbYdYUwsqB1cdBL+p5lvvyQ7Fwg5gNtwCkQa5BZARP6
         utXbk3fjznecAtlt4ofjdMQRYP4seYkBl4E+rnAO3GFIBJy+d/tIMO5WTlqgyJ6dI8r1
         VBxGrMmCUEBzUfvAIm1iUW3p5ddfUCpi49akU81AcAx0gVg3OlP423fSodoffP0Q/1hp
         s13UtmEkQqPvvXylBY9jLQ6r96Yk65U7IRyYUCpptzPwLm2yIn16i1SCLergwEC0t0y9
         l+jQ==
X-Gm-Message-State: ACgBeo0j3Fc6TT29dL7fIoqoPbQVHxtZacRMOZF+rhTfPYHVjSay6FT1
        7+q8VB+vVvatK1t0nd6vkhAGXBxn0KAmIQN8BDkYCfMih39L4HXZsynHHf+ahBZLU5fXjhPvdX5
        fDkjYVBWxkMnrlUFPqO1wusMIi7idBrV5Z7fkZcKIQyNsp9FWO6VH3e9McmFhAVM1lMdWTxk=
X-Google-Smtp-Source: AA6agR5p5f1rmwH99ZhKaDteuWNxYD1CVO1xj11yHP7cKKX9xsE7TDeg/UvCcr7eUHWI6Ca6myv4ZJQSR25qbg0T3w==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6808:170b:b0:335:1807:e4a2 with
 SMTP id bc11-20020a056808170b00b003351807e4a2mr18341oib.89.1660772536776;
 Wed, 17 Aug 2022 14:42:16 -0700 (PDT)
Date:   Wed, 17 Aug 2022 21:41:43 +0000
Message-Id: <20220817214146.3285106-1-coltonlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 0/3] Randomize memory access of dirty_log_perf_test
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds the ability to randomize parts of dirty_log_perf_test,
specifically the order pages are accessed and whether pages are read
or written. This is implemented through creating an array of random
numbers for each vCPU when the VM is created.

Colton Lewis (3):
  KVM: selftests: Create source of randomness for guest code.
  KVM: selftests: Randomize which pages are written vs read.
  KVM: selftests: Randomize page access order.

 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 47 +++++++++-----
 .../selftests/kvm/include/perf_test_util.h    |  9 ++-
 .../selftests/kvm/lib/perf_test_util.c        | 65 +++++++++++++++++--
 4 files changed, 99 insertions(+), 24 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

