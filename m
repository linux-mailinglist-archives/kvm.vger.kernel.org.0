Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C3A6D7146
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbjDEAbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbjDEAbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:31:38 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1BC3C15
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:31:37 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id o188-20020a62cdc5000000b0062be61a5e48so13696760pfg.22
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680654696;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NelSuLftcb2FUtXcB/iSEqqJ8vcX9VxoHM93inJvC9w=;
        b=MjoNWq0c7xGjg9s5xeXIyeT1YhTDsXw16xVOuRJzCEFfyaxj4a4O54taMNZ1ggOEVN
         Ax1J+fMlL8oh+w4ebA+uirZWFaEZsoCkB8ot7dEL99FHiIdbfU7S6DrRVoFvqk9GLW4Y
         l/9OAUZ/RoM6XatRXsL7jw0zrxwQVevzOUP7xRPsOIzSnz/bSNSu1FW21VvQACRExZMY
         OuuuzZstjR0q7lDFtGsc0oOT+2RNs4hi1B8Gf/4nLY5mfDfV9Ke8N0TSs3rjwtRnw2wr
         gpxJ6nJ2JcigFaZtcwmurtCETGVrmRRemE44EmQlug+0G712ICkWZ0RXF1HARTmcywUZ
         dutA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680654696;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NelSuLftcb2FUtXcB/iSEqqJ8vcX9VxoHM93inJvC9w=;
        b=g2TUosfMsGsShc3W5ZVO3Jn3J9r8Y6ZfFsvTaZgvSBoAGyHKLsIDKPoy38z9BqdCsO
         r0hgLDLQu8DaFR1Sg8AYDcLL6JXVtx5xwchc5XWfyIoLSvIVOkgSJ3ot9zM4hDWIyFHt
         4Jq/Q3N2ZfSs8PzEHzqbZe2z3hpMx0mVI5AX7D3gdc3WVkjHjxVsPyMphbjMwl9VYDX7
         J3u7cfLaLfewF+z9MbE40iDrkTbWldxFB5UQQv0MNxTpCTCKbQE6eeiVdQnr8ijlwc2V
         CdpFOTt2Tng7q9VQ8qcW67qWxT11Api35sRAK8fOOKIcaK74Q/OpFOa1xrH+ZZMh3UOD
         Wyqw==
X-Gm-Message-State: AAQBX9dA0PaBGD9NZFYX6CJwT2XB4xN6kwq9CwATbvr6SR6fCSgsh/Aq
        LkWrTZ64AS9kTYZZn3vthK0iJm6igWI=
X-Google-Smtp-Source: AKy350a4PudZE0acBPofUXf6EP+Qmr0Ec03FGWoC3xC/vSIqe7QIY0/WNCKNwTg9iUm8TpuQwW2XmbcHZLM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f950:0:b0:50c:a00:c1fa with SMTP id
 q16-20020a63f950000000b0050c0a00c1famr1333484pgk.7.1680654696598; Tue, 04 Apr
 2023 17:31:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:31:31 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405003133.419177-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: More cleanups for Hyper-V range flushing
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

More cleanups of the code related to Hyper-V's range-based TLB flushing.
David's series got most of the names, but there are a few more that can
be converted (patch 1).  On top of that, having Hyper-V fill its struct
provides a decent improvement to code generation, and IMO yields a better
API (patch 2).

Sean Christopherson (2):
  KVM: x86: Rename Hyper-V remote TLB hooks to match established scheme
  KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper-V
    code

 arch/x86/include/asm/kvm-x86-ops.h |  4 ++--
 arch/x86/include/asm/kvm_host.h    | 15 +++++---------
 arch/x86/kvm/kvm_onhyperv.c        | 33 ++++++++++++++++++++++--------
 arch/x86/kvm/kvm_onhyperv.h        |  5 ++---
 arch/x86/kvm/mmu/mmu.c             | 18 +++++++---------
 arch/x86/kvm/svm/svm_onhyperv.h    |  5 ++---
 arch/x86/kvm/vmx/vmx.c             |  5 ++---
 7 files changed, 44 insertions(+), 41 deletions(-)


base-commit: 50f13998451effea5c5fdc70fe576f8b435d6224
-- 
2.40.0.348.gf938b09366-goog

