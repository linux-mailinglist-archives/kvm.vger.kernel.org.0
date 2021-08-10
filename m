Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAE13E7E19
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 19:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhHJRUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 13:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhHJRUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 13:20:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0026C0613D3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:20:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b4-20020a252e440000b0290593da85d104so19144ybn.6
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=YA3NF9DMKc4I70AnuyD5YSitWTMbp+95cgR2kKH7sPI=;
        b=UvFYvCNAIwQvbkNWFM3GdZql943uYgfXwguHeOAJ+UsQM8ZY9SGKlpaiNflMIK3bvf
         HUhTog+Dt5dsbesRt67SUtqUmiHwWrYhAjPueqBfYpgDNYpEJLuNdWRm6UYiMNo63bQb
         V1uVSSlcjPx22mOMsFORuHQsUL5a0xcV6jqNi9uQyRF9klQk2e5D+7Mm0W9OTA7r1LjU
         gmikpInhxCnYhVu1ItTPXo9Jpm7xhLpGUUCQLru5N9X3muCjoBLQ+L9c8jleCV7DHMGG
         T0g1cUS8H1HsiFSmeWqV6z4cyKpt5m7Rv8WkUyU6z8zIyUWqN0pAFIbKmutXSZS1iRL8
         1SEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=YA3NF9DMKc4I70AnuyD5YSitWTMbp+95cgR2kKH7sPI=;
        b=stclxnoHhe7yP45h7aEDUfwtNL/cjZcNaRNNACXfb9qyVbZPKspv4VpiCS+m6soZMA
         Bg5RuvgpWi4fSbk6BtGzLgrZgk0euVooTK8xzFr6jLB+d7nmwuoykJr2CFBwq0GuxnnE
         9lRe5BTCkbfqBZEJ6A+KK1EoKLreGnsbedON8ngshgNqR/yeMzS3kga3kEjwRijzV1DB
         dwGuMqApellHlcAgoFueBwtTnQrcot0nx7gfQZ/BNFLRgRasFUe16w96YEOSnsdmCLY+
         PkaAvoSNh2lnjCgxkBL2AMQcIwIk42luLbtQCel0HJujMZNhUtKalJ41luSfudiSUfCz
         ATGA==
X-Gm-Message-State: AOAM532BA3FOnGfbspgaV6sa+oIDh1ti57eWlenGlchPykNWfDaq6y0d
        zMTAfmf+Mk97YIKPnxCUu3mqunTEtKY=
X-Google-Smtp-Source: ABdhPJygJe6rW5Cj2N0CH1AW0Ag2OJztzlMQVaL2LT2y2lLWfiBVxyZiy0tfd7Qo74zvVo95E2Oipv2h3Hg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:de69:b19a:1af5:866d])
 (user=seanjc job=sendgmr) by 2002:a25:dacc:: with SMTP id n195mr21698801ybf.283.1628616002055;
 Tue, 10 Aug 2021 10:20:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 10 Aug 2021 10:19:48 -0700
Message-Id: <20210810171952.2758100-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 0/4] KVM: nVMX: Use vmcs01 ctrls shadow as basis for vmcs02
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The goal of this series is to drop the vmx->secondary_exec_control cache
without degrading nested VM-Enter performance.  The cache is effective,
e.g. saves ~1000 cycles on nested VM-Enter, but confusing.  The worst of
the confusion could be eliminated by returning the computed value from
vmx_compute_secondary_exec_control() to make the calls to the "compute"
helper more like the other controls.  But, the nested VM-Enter path would
still have special handling for secondary exec controls, and ideally all
controls would benefit from caching, though the benefits are marginal for
other controls and thus difficult to justify.

Happily, vmcs01 already caches the calculated controls in the
controls_shadow.  The only issue is that the controls_shadow may have
dynamically toggled bits set.  However, that is not a fundamental problem,
it's simply different than what is expected by the nested VM-Enter code
and is easily remedied.

TL;DR: Get KVM's (L0's) desires for vmcs02 controls from vmcs01's
controls_shadow instead of recalculating the desired controls on every
nested VM-Enter, thus eliminating the need to have a dedicated cache for
the secondary exec controls calulation.

Sean Christopherson (4):
  KVM: VMX: Use current VMCS to query WAITPKG support for MSR emulation
  KVM: nVMX: Pull KVM L0's desired controls directly from vmcs01
  KVM: VMX: Drop caching of KVM's desired sec exec controls for vmcs01
  KVM: VMX: Hide VMCS control calculators in vmx.c

 arch/x86/kvm/vmx/nested.c | 25 ++++++++++++--------
 arch/x86/kvm/vmx/vmx.c    | 48 +++++++++++++++++++++++++++------------
 arch/x86/kvm/vmx/vmx.h    | 35 +++++-----------------------
 3 files changed, 56 insertions(+), 52 deletions(-)

-- 
2.32.0.605.g8dce9f2422-goog

