Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71246FB40C
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbjEHPp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbjEHPpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:45:23 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BA993C3
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:45:11 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9659c5b14d8so756145566b.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560710; x=1686152710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5JxpeNv6qbTU9zC3rqfXpj11om/jws4aem/MiaJtYTQ=;
        b=OziIEurhzuO54Ro9HxfZiU1jDhDkcUj3+WL0IMO9JvZziVeuVpoZMuL6UlgDWtmtqZ
         5znzxbJfh154l3Y938OCC6xXLJnOXsjtHl5k5xv3GdqJnCv4tfStBNErRW5RBg39peeu
         TVb/i4d1FG38k/0ySqKUHexJZfdzYa9ZfGN+0/vAyXifwH771kUkrNzmgnapwXzb8I1Z
         W/L2CNPAs7RYoUKdS8M8VNLkjhlfUuppAClYY3EHCLFIxsKvqLjdGVhZXSHWfzI1JJVr
         UjGygtCIiQJqtRPa181r3gJNme1q3a3JH43p+9Q+pcQmDHhfzZI84N9bsVBGhKtpv3uc
         DKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560710; x=1686152710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5JxpeNv6qbTU9zC3rqfXpj11om/jws4aem/MiaJtYTQ=;
        b=AH0pnQh6xmEZ7LWNkrtkW3pMxpBvrcepuOwLtSb3iboz9hCEb+mhK+Z7wcpDzlt5cO
         eOfPfC/CyAWiRqvgJjEtybxSd4Hm/SONaBrf+0m9QNb9OilTDYssWeJcYRsPl/okdAay
         hj22Kk0cYAGD9uPW9mNilzBA2GQYHbONhAp7rabELRS2WBj5khc12yiuI48IxuSOebir
         jBeD3M63BmMtprIguS+ryDhhV7a2tetHEB2OvnmnfRNNrFS+cKYA1Pzsf6eK0JI64Nef
         MTODA6YMjxVa0H/jpsmhAUYW18zohMVB+ulQjIget2x+Db+FUFXwkhEwPkPuDmcHZ9sN
         sWIg==
X-Gm-Message-State: AC+VfDyFhJ2m4/9SVcwWtw6vi3pA/bmPqmiFhMJh+7IniHHIuIWGnx7M
        XjiD9MgJiQZN4QGc1XHHcI04yA==
X-Google-Smtp-Source: ACHHUZ4LE8lOflSNZyO5u0s7aq8OifqkUPlsywPLlMWWmB+DrKnoqrKi2aSWtW9/8/v+5IOHZQ2keA==
X-Received: by 2002:a17:907:6289:b0:961:8d21:a480 with SMTP id nd9-20020a170907628900b009618d21a480mr8586041ejc.58.1683560710167;
        Mon, 08 May 2023 08:45:10 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id kw3-20020a170907770300b0096621c999c6sm121758ejc.79.2023.05.08.08.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:45:09 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.2 0/5] KVM CR0.WP series backport
Date:   Mon,  8 May 2023 17:44:52 +0200
Message-Id: <20230508154457.29956-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a backport of the CR0.WP KVM series[1] to Linux v6.2. All
commits applied either clean or with only minor changes needed to
account for missing prerequisite patches, e.g. the lack of a
kvm_is_cr0_bit_set() helper for patch 5 or the slightly different
surrounding context in patch 4 (__always_inline vs. plain inline for
to_kvm_vmx()).

I used 'ssdd 10 50000' from rt-tests[2] as a micro-benchmark, running on
a grsecurity L1 VM. Below table shows the results (runtime in seconds,
lower is better):

                        legacy     TDP    shadow
    Linux v6.2.10        7.61s    7.98s    68.6s
    + patches            3.37s    3.41s    70.2s

The KVM unit test suite showed no regressions.

Please consider applying.

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
[2] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git


Mathias Krause (3):
  KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP
    enabled
  KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
  KVM: VMX: Make CR0.WP a guest owned bit

Paolo Bonzini (1):
  KVM: x86/mmu: Avoid indirect call for get_cr3

Sean Christopherson (1):
  KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission
    faults

 arch/x86/kvm/kvm_cache_regs.h  |  2 +-
 arch/x86/kvm/mmu.h             | 26 ++++++++++++++++++-
 arch/x86/kvm/mmu/mmu.c         | 46 ++++++++++++++++++++++++++--------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/pmu.c             |  4 +--
 arch/x86/kvm/vmx/nested.c      |  4 +--
 arch/x86/kvm/vmx/vmx.c         |  6 ++---
 arch/x86/kvm/vmx/vmx.h         | 18 +++++++++++++
 arch/x86/kvm/x86.c             | 12 +++++++++
 9 files changed, 99 insertions(+), 21 deletions(-)

-- 
2.39.2

