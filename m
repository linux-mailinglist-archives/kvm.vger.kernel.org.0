Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFA27D3FFE
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 21:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjJWTPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 15:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjJWTPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 15:15:37 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B0F103
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:35 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7ba10cb90so52023787b3.3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698088534; x=1698693334; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PBa3LO20B78eYRbamEnUaes0InscBX8rE+JS4NaZ5k8=;
        b=11bwIvZmoqV8nSju/rjkAosKs12JH0uzx9dQH867EfgwgERUXI+apOOeb4+MKvI0W3
         yuiHKhUZazSMra3MH9CGYd61M4XQP//TYiEzZ0cYLakbcjCvey4hJOZOJ6pkWMgUo6Sr
         Z4Kc3k9AUOLA9hdMPKjPsahjrz7WnCiDaS0K2aMrx3UdZ9aBHc3FFtSbama2z/4tj218
         MLEfKPGwMTJ3ZC4I23OsWTrWf9Fud4sDetfp6S7xAZKr1O1P0o6jnDbZyBXxQt22y9GF
         +YoEFqR6OGnr1+ayLMJzFkVSi/h3ewlokTqiJoIY1Q3X/WUKGZft211WtFA3yzmKs/sg
         kAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698088534; x=1698693334;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PBa3LO20B78eYRbamEnUaes0InscBX8rE+JS4NaZ5k8=;
        b=uPjYEmfdKCckSmC8At6nxJB+HKX5HzhaAwnMGiqYGrO3ePg7YUS4m1z15sjjE7tuPj
         vhkunX2U7jQzpHjZJSPM7YmrVT4Ffdy4IPVWWY5lMwV20XL8qNJFAtleTohWPP55uBiN
         GPt2p+tsGDF8uXUDFcz8aE6yJeBta2QU65BKDjGwpNRafSeCi7i8clgL9LVl/AYspeOd
         ZypOgHxySYtMlYGO8wtUskWTBrQm46mvLHz0rsMcQWSmm/fNuYc9Sv2WeUmhebUg75rK
         mxQh6t7UogTsdw5G9bFgSCnwmol8Ltp3k48e6TGZpmiS2rA6mEhJ5gOsRkAAYn8PnuPV
         GUcg==
X-Gm-Message-State: AOJu0YzjBhcZjwkqb+5aO0mdGkZ75VFrQ3EUWbg9sudh1Z1aRxaiwI+n
        0vLu1lqm8BrZzpLkAjZva8vJZDH6JXE=
X-Google-Smtp-Source: AGHT+IHaefRJBXlJssDrvGK2iPVIDeDMHyE6U4j2WgVuUxAPCCt18T/sEXXjlWcU09eowm7qZtH4dwlrLM8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ca0c:0:b0:592:83d2:1f86 with SMTP id
 m12-20020a0dca0c000000b0059283d21f86mr207260ywd.4.1698088534353; Mon, 23 Oct
 2023 12:15:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 12:15:27 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023191532.2405326-1-seanjc@google.com>
Subject: [PATCH gmem 0/5] KVM: selftests: Fix multiple memslots in conv test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>
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

Rework the private memory conversions selftest to allow the user to specify
a (somewhat) arbitrary number of memslots instead of testing only '1' or
"nr_vcpus" memslots.  Creating more memslots than vCPUs is particuarly
interesting as it results in a single vCPU's data chunk being spread across
multiple memslots, which in turn results in the test changing attributes
across multiple memslots in a single KVM_SET_MEMORY_ATTRIBUTES.

This also fixes the issues reported by Mike where the test would crash when
run with multiple vCPUs and a single memslot.

Sean Christopherson (5):
  KVM: selftests: Rework fallocate() helper to work across multiple
    memslots
  KVM: selftests: Handle memslot splits in private mem conversions test
  KVM: selftests: Let user specify nr of memslots in private mem
    conversion
  KVM: selftests: Use dedicated pattern for testing that mem is shared
    by default
  KVM: selftests: Verify default pattern was written in private mem
    conversion

 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 ++++----
 .../kvm/x86_64/private_mem_conversions_test.c | 87 +++++++++++--------
 2 files changed, 69 insertions(+), 52 deletions(-)


base-commit: 911b515af3ec5f53992b9cc162cf7d3893c2fbe2
-- 
2.42.0.758.gaed0368e0e-goog

