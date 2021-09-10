Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83B44070EF
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 20:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhIJSdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 14:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhIJSde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 14:33:34 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D32CC061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 11:32:23 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 70-20020a370b49000000b003d2f5f0dcc6so17017548qkl.9
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 11:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=YlwJHJMh2bFF+3hFji05e3iWsWMwUqbd64h+Z7Bxs5M=;
        b=ioZoNuAlz7cfTX1k5y8m9lO6Xk7f78CUn6azVXQsTdJXQ8DkbpTtuQh45NqG3BGDni
         Y4CMRdkCkj5H4u2YyP1SGIOHXCya707iYNCKz7YOlC6bUZ81HT6ItWBK63+lNdygQOFN
         pqEVMo9cTxN2gqW1LN3YDd3kWkW6vzPHKmMsx0fJUNJEVpo5SQ5lIVe6s9Kwo2vKBFBp
         yYuIsNnQP2ffT3P3YdG2zt1jwJqTyIeyrTFwVx2wd+1BBJG6bA422YYQkq83hn73XzeI
         zK9rslV1gIZLHet3LiaXBPspSRwsDMjH0rCbD0vfyUGsaKJS5q2fZtgeRhsp+ljMrkKo
         wibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=YlwJHJMh2bFF+3hFji05e3iWsWMwUqbd64h+Z7Bxs5M=;
        b=N4R+9dRBbeoAMEN0RBFaoQ73NEoLUvacgTfTY81b5A9wMXUL23TbUDYS3yUZeO/Rdd
         qtcx5lbwYF/iycaQdH51S8+tvo2dL5oLowvGX/JTbc+/wZusltHcwSrEq+pOF9lZAsLh
         P74kUleUTUZtCOznfGf9CQf6ndJzHPcjQR27Vg8jae0B3yXZqKZQpAOVSob17UXmisOr
         MCH3W6FIqa+FxgGzgEKCsXrw9jkL7OdmC/jgRsut2xPD52i2pE4hx2v9XPNsBJOBVUUa
         OOPWXcVAhjjN6S+y/hfvRiaz7z22Z9SVgqO0cY9tMB1Farb4+VhKATLeFYMjBtjQM94c
         dkUw==
X-Gm-Message-State: AOAM531v5m1MPTSpcfpGkoMYlmy4an4XscywM/v1JWkxoRdIUrjaantV
        OjR9+sQvjbA8zl5xi6zWt2AIA2Jz6EI=
X-Google-Smtp-Source: ABdhPJzWExSuF+MjinbVRsxwC9Lyp9zTdd7mBSpwQ7g/RjOIoI5vTwLJq6p1qkJiusmgX6RQUF/8wgxepIU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:d1d5:efd6:dd3d:4420])
 (user=seanjc job=sendgmr) by 2002:ad4:5990:: with SMTP id ek16mr9653194qvb.30.1631298742637;
 Fri, 10 Sep 2021 11:32:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Sep 2021 11:32:18 -0700
Message-Id: <20210910183220.2397812-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 0/2] KVM: x86: vcpu_idx related cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop KVM's obsolete kvm_vcpu_get_idx() wrapper, and use vcpu_idx to
identify vCPU0 when updating guest time.

Sean Christopherson (2):
  KVM: x86: Query vcpu->vcpu_idx directly and drop its accessor
  KVM: x86: Identify vCPU0 by its vcpu_idx instead of walking vCPUs
    array

 arch/x86/kvm/hyperv.c    | 7 +++----
 arch/x86/kvm/hyperv.h    | 2 +-
 arch/x86/kvm/x86.c       | 2 +-
 include/linux/kvm_host.h | 5 -----
 4 files changed, 5 insertions(+), 11 deletions(-)

-- 
2.33.0.309.g3052b89438-goog

