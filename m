Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B479EF9E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfH0QEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 12:04:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31955 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbfH0QEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 12:04:09 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D043012A2
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 16:04:08 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id t9so11678550wrx.9
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 09:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wTmTh7xa6ZjBJ+aMQDQrAGuc/LFXChDSJhLsWUK+WTw=;
        b=n41V3yLiYJRY3/KFMIQXU/2F3O7ZGA4zWi3pA7g1se+L6w1Ev3/41462yN503+BLe6
         vIiE8yi+bTCl0Q2QlFquOS8dPMoNgZ4YcBC1zr9SXaGnEUvDu1c7LRC2MTdLQSEVxgjI
         GidWgw0Ij/cl0OZ/AhMphlaYNgI1UpptodMTTTa3zXWQsVAD/P50YU6TncAD89h/1D1y
         wFrwzsi+vzfVtsmoJs4BFXPFfItpt1TGRmfO2wdYwAR2IDjQ6ZMrDw6G2cySebDGR8XT
         0YD4aGZEVf72Ln58IgfLDaHADo/9L9yq2f4NNDuLnkGbv0I5JpB+Mvj6WUGoZ8236mqX
         y2SA==
X-Gm-Message-State: APjAAAVXRTmkaS9fbpNXqeW860na6q1iU2hprCDEllzvDJkubrq0uVUJ
        kWVenuRYEOT+IN3sNp2JU1MFzJAP9gnecODN7dkmie4s/NT6wuhnCLWc7CcA9SQjFTxscarDsxT
        w77Rhxf+SkzzS
X-Received: by 2002:a1c:c5c4:: with SMTP id v187mr29313150wmf.30.1566921847299;
        Tue, 27 Aug 2019 09:04:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzJHNnJawjO+y0F2tak8NF6NDyr9x8KCsDnGG8but4Gv7XNoZibGMzwkLEL53g+R/qOWuQihw==
X-Received: by 2002:a1c:c5c4:: with SMTP id v187mr29313126wmf.30.1566921847093;
        Tue, 27 Aug 2019 09:04:07 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n8sm13461246wro.89.2019.08.27.09.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 09:04:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH 0/3] KVM: x86: fix a couple of issues with Enlightened VMCS enablement
Date:   Tue, 27 Aug 2019 18:04:01 +0200
Message-Id: <20190827160404.14098-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It was discovered that:
- hyperv_cpuid test fails on AMD
- hyperv_cpuid test crashes kernel on Intel when nested=0
The test itself is good, we need to fix the issues.

Vitaly Kuznetsov (3):
  KVM: x86: hyper-v: don't crash on KVM_GET_SUPPORTED_HV_CPUID when
    kvm_intel.nested is disabled
  KVM: x86: svm: remove unneeded nested_enable_evmcs() hook
  KVM: x86: announce KVM_CAP_HYPERV_ENLIGHTENED_VMCS support only when
    it is available

 arch/x86/kvm/hyperv.c  |  5 ++++-
 arch/x86/kvm/svm.c     | 17 ++---------------
 arch/x86/kvm/vmx/vmx.c |  1 +
 arch/x86/kvm/x86.c     |  3 ++-
 4 files changed, 9 insertions(+), 17 deletions(-)

-- 
2.20.1

