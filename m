Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0915EFCBE
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 20:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiI2SMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 14:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiI2SMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 14:12:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344A31CE144
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:12:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j3-20020a256e03000000b006bc0294164dso1784153ybc.20
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=WucjadfXEvAkmeE4GNUqom1vLYZ+D2MfRUOKmk+CJnk=;
        b=PYRLsy7jgBf1XvDscqYUi5ykEjKL7w3c7jQQHA8P/s8+EstWxT2tK93d9qKZyESgnV
         yvwr/x8jVva2tXi5/3wcpvwBr0JH41CWV8fYD6Cfb15zDL5nlRvvaqrgCy1RkzyFpyN+
         DJpHzIb4W8aXzeJvqGSg1CrMWvnqRDmy3frVYGgoS6ZhddgpqysysTlfuTE+Vdd5jnWG
         3UGbuxhJ4PCoMM/lLf94SlSeFGtzMZm9SDWfgy7lJSig+AilUpoZiL2wsMJOiraaw5zX
         v9jbN05LoS53fceiZJwMHX33RqR0b22VrV47twWp0ZiCmw7pPWZWrf67/Zm3MsgFwFxN
         FfUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=WucjadfXEvAkmeE4GNUqom1vLYZ+D2MfRUOKmk+CJnk=;
        b=Dr5bwKCj0xd0OFcKXETH+2HIPF91prVIfp3xGOw4Geoua2F6b+fbKEg9KKu8v8PhD0
         003olp11ig1qEEgwc1lDXiHrEAQIU2ZrZGzyEXsNI71emOnhKlsJxfyULoVjyhCWoqER
         69EHRkXvc0uiskTC6kMEylRNTVMMP7ZIe8M49+9t1m2184I+FZAwMnjoPoALW8UR6tlH
         4U69wpO+o/s3ldG+dnUBr5moNx3RcLMJTTB0zZSPGRGSQmOb/hbN556sBL5yKAjJ2pM+
         zwLx46JWFlq6b1e8yrdVJr91TM0APtdzqWrx5Y/lWUb20rk3RXqoOKZ3I1MQ8XGQ1vs3
         MpXg==
X-Gm-Message-State: ACrzQf3Mune2cuoFzmTAprjNIwtx5T0z/N7nn/idcT6Flrzu3CvkrZ22
        zkFK9KgX1iW6fxpbU2IPqmqzeO5g/rbwkA==
X-Google-Smtp-Source: AMsMyM6cZrRfpXNgubpRYpDoA01wTmA43PB1QkQEu1y12EORGuWf1VBMm+By9/PxO1tTwwdUZy6XEwXNVCmLoQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:4ed0:0:b0:353:cef1:aab2 with SMTP id
 c199-20020a814ed0000000b00353cef1aab2mr4520087ywb.502.1664475132489; Thu, 29
 Sep 2022 11:12:12 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:12:04 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929181207.2281449-1-dmatlack@google.com>
Subject: [PATCH v3 0/3] KVM: selftests: Fix nx_huge_pages_test when TDP is disabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org
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

Fix nx_huge_pages_test when run on TDP-disabled hosts by mapping the
test region with huge pages in the VM so that KVM can shadow it with
huge pages.

Patches 1 and 2 are precursor patches to add the necessary
infrastructure to check if TDP is enabled or not.

v3:
 - Skip the selftest if a module param file cannot be opened [Sean]
 - Add wrappers for reading kvm_intel and kvm_amd params [Sean]
 - Small renames and error reporting cleanups [Sean]
 - Decrease sysfs path array from 1024 to 128 bytes [me]

v2: https://lore.kernel.org/kvm/20220928184853.1681781-1-dmatlack@google.com/
 - Still use 4K mappins on TDP-enabled hosts [Sean]
 - Generalize virt_map_2m() to virt_map_level() [me]
 - Pass nr_bytes instead of nr_pages to virt_map_level() [Sean]

v1: https://lore.kernel.org/kvm/20220926175219.605113-1-dmatlack@google.com/

David Matlack (3):
  KVM: selftests: Tell the compiler that code after TEST_FAIL() is
    unreachable
  KVM: selftests: Add helpers to read kvm_{intel,amd} boolean module
    parameters
  KVM: selftests: Fix nx_huge_pages_test on TDP-disabled hosts

 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 .../testing/selftests/kvm/include/test_util.h |  6 ++-
 .../selftests/kvm/include/x86_64/processor.h  |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 39 ++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 40 +++++++++++++------
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 19 ++++++++-
 6 files changed, 96 insertions(+), 16 deletions(-)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
-- 
2.38.0.rc1.362.ged0d419d3c-goog

