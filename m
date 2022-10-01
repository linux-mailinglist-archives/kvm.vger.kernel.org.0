Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C815F17FE
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiJABOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiJABNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:13:48 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C0C1EEF2
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:03 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id g24-20020a056a00079800b0054b1a110543so3610202pfu.2
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=geKRKiybPkfXT/kXvnqZhRT7ybJlb9HVgi1YJwmiH/0=;
        b=qtiTrciNxGZDvWPoxZlLLNIdLXMBxrSKtwlyQo9TvfWyto5G95uPyH++1MhHbv1bir
         zegK6gLuY/6cVVgOqrkBNzeCRRdCgXGtKffPdSHEu+DxojiRYtL1dmi/hqG6xbslLSjJ
         3xUoUeoYoagNtXPMCsTsX6TXm/1Wlhs9aeG6mkTqwauuT24dvXeohzlHVIAx0Zx7BcMT
         BxO8qzERGDoa097pViSK2skI66OHIo93GL5WGO9SztzgS52YE8OW0hEAM3ZxEnzQfi3k
         VRWuJVl/lJVVUS0kQ8scwlJwZ/fZ773/NnwEoRrONuL+j/KtQMj77RK1XpGXFHXB7J+5
         on3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=geKRKiybPkfXT/kXvnqZhRT7ybJlb9HVgi1YJwmiH/0=;
        b=rwsEsLOiobZIHUUzD7P25E9LisXhZ7wadSZc0DnDfykIr4uF7vhT3Pk/ozWZVp26Fm
         SrqXSrzyqoXm/mVRTDzF9EUdIGJSdzHh6rs4yOM7E+ejd9QkjG6R7xiz8Hz9Dilv5WN+
         KFZ+a/zlg5EEUPy8KiN7fUFhSvpo614gzjc+CSTECkzsNXl77gBLawuMbrJy0RmZdrJK
         nWfhfslia04oYNRU7O90yK1ka/DNFRER0LFc0DQrgPIOjjYlSTvxzKN+EieXjOJxeKF5
         fg+vehTmyTIDHtCzf6gYmF8yqw+sZWmMZeUj9WGTgXxJPbwoj71EFsPpoblOpitzzLPX
         6CnA==
X-Gm-Message-State: ACrzQf39t6a8DvnGK7XGQUEQ37UltWlGNm59+/i3ji10DpnKGwxAQgJ3
        uL4elFCxuJyw01McKvVuQulIhKYhAAc=
X-Google-Smtp-Source: AMsMyM6QnPHGs2FNKoZ8+O/uesetJ1rX2V6YckQowiqxdI9UIa+656b7C/hduxnOMHFRiLUltQSjwrrkCnk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d506:b0:178:3599:5e12 with SMTP id
 b6-20020a170902d50600b0017835995e12mr11486823plg.70.1664586783375; Fri, 30
 Sep 2022 18:13:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 01:12:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001011301.2077437-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/9] x86/apic: Cleanups and new tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
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

Clean up the APIC test, add a new config to target AVIC, and add new
sub-tests to verify IPI delivery when using logical mode, and when two
vCPUs share the same xAPIC ID.  In other words, add tests for edge cases
that no real world user cares about.

Sean Christopherson (9):
  x86/apic: Add test config to allow running apic tests against SVM's
    AVIC
  x86/apic: Replaces spaces with tabs to fix indentation in apic.c
  x86/apic: Add helpers to query current APIC state, e.g. xAPIC vs.
    x2APIC
  x86/apic: Assert that vCPU0's APIC is enabled at the start of the test
  x86/apic: Restore APIC to original state after every sub-test
  x86/apic: Enable IRQs on vCPU0 for all tests
  x86/apic: Run tests that modify APIC ID and/or APIC_BASE after other
    tests
  x86/apic: Add test for logical mode IPI delivery (cluster and flat)
  x86/apic: Add test to verify aliased xAPIC IDs both receive IPI

 lib/x86/processor.h |   1 +
 x86/apic.c          | 940 ++++++++++++++++++++++++++++----------------
 x86/unittests.cfg   |  15 +-
 3 files changed, 615 insertions(+), 341 deletions(-)


base-commit: d8a4f9e5e8d69d4ef257b40d6cd666bd2f63494e
-- 
2.38.0.rc1.362.ged0d419d3c-goog

