Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4436103EE
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 23:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbiJ0VEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 17:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbiJ0VDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 17:03:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF21C95AD2
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:57:01 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36ab1ae386bso24939667b3.16
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AYcGCIjxasuhuLfXLt9s+RfUZjGAKFoU0cNeJ5rpEgQ=;
        b=dWuspeUOVCTg+NdrJ+f+5Jv+8gCf3NM4djnPu9kC2m9CnpNzFI03GpeBRF/nnogtod
         CorckZb53SpLhBOZGzjCKjzRbV0PMbCNQQsvohys4t7tfsZW9UoVras/3cYko6bpoLAq
         b3f+m8+fGe+LorhDxMbhOvvbl4jmbJAl84BqdaXB/BHXQzXmu2cEBGB0CbBVMIkt+jwB
         Y2MpN+9BWgGRPLF4KA2CIiIiCJTD63qfcMgU/vFVu0L143Govy4UkasHkasxNZFv/lhc
         /TUFWNipGr9HVhXVDGmUUx/jFEFXgqEBE/P3N7AKs2+0HyCFLRTRJ6INn9oQby7oCBRU
         BGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AYcGCIjxasuhuLfXLt9s+RfUZjGAKFoU0cNeJ5rpEgQ=;
        b=NF+Q/hOvsXaE8qM1ZJWzePohgKtCvvgVnTGONIIOIURqwjWvrOHHaHXipVzCJjicka
         7wocIlYGue+RbHBYoxB3ssZfia/pdvwuhEbBM0bbe5Gp5MN2f+TaVTWn98yjtpIz7mMd
         8Brm+5cvbvqpwJiZ4zPZLUTX2pyhmjQBMIK65UWReZ9qAMzJ1qUUHhiz5sbBYJ26Wo4A
         uQXiPj8z5D3sRfFr9FT9pDOM6s9S+KMB0S2kpIrqbbbe0Ox2dEN8F2I4x8I6CHBArcPZ
         QTT0IpKmijKHkleP1/IYIn9EaNP+B2JM/cSL9go51qFsdl1Brxc7BBR9M7HZ5/9M83Lv
         hDIQ==
X-Gm-Message-State: ACrzQf1YWiuRB6fwtuvmo1POdBLknaZIk+91YV35CwX8FpVqDX1EwLio
        +SfZnX1Va5DpZYoJNrCmFIgQqDXj6E/w1AEcOviV8rsK8SsIBjPQBScB68PXyxcU02svTrWt0v2
        ZNIlrqsTjcQ3IwNJrXfThiWZSz+ww0oGFABJb+B+g/o6uM/LbHydl0oOdU7xJge2k4BamdOk=
X-Google-Smtp-Source: AMsMyM4JlZYR1O0g9oxKMw0D8s9hJZ72enZPeO0599v8ppdz9WK8BGJvCB5X8pv6lilxHrjpl21Fxc5B4ynbVXFpFQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:c7c3:0:b0:6cb:b64e:dbde with SMTP
 id w186-20020a25c7c3000000b006cbb64edbdemr0ybe.496.1666904219909; Thu, 27 Oct
 2022 13:56:59 -0700 (PDT)
Date:   Thu, 27 Oct 2022 20:56:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027205631.340339-1-coltonlewis@google.com>
Subject: [PATCH v8 0/4] KVM: selftests: randomize memory access of dirty_log_perf_test
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
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

Add the ability to randomize parts of dirty_log_perf_test,
specifically the order pages are accessed and whether pages are read
or written.

v8:

NOTE: Ricardo and, David please look again. Sean requested I remove
your Reviewed-by tags due to changes in the last round. Main change
was the interface for the RNG.

David: I made the default seed 1 since 0 isn't a valid input for this
pRNG.

Split random number generator from use in dirty_log_perf_test.c and
perf_test_utils.c

Colton Lewis (4):
  KVM: selftests: implement random number generator for guest code
  KVM: selftests: create -r argument to specify random seed
  KVM: selftests: randomize which pages are written vs read
  KVM: selftests: randomize page access order

 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 57 ++++++++++++++-----
 .../selftests/kvm/include/perf_test_util.h    |  8 ++-
 .../testing/selftests/kvm/include/test_util.h |  7 +++
 .../selftests/kvm/lib/perf_test_util.c        | 32 +++++++++--
 tools/testing/selftests/kvm/lib/test_util.c   | 17 ++++++
 6 files changed, 99 insertions(+), 24 deletions(-)

--
2.38.1.273.g43a17bfeac-goog
