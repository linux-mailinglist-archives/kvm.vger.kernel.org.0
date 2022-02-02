Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F258C4A6E1B
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 10:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiBBJv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 04:51:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245587AbiBBJvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 04:51:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643795484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u2Q5Qw3UNSacmxDmUI9wwxXXuk+9n/t8UWUN6P4flCI=;
        b=aGWHboUwlxL3XhH59IX75zZqF/wnZkGYO+qeYXpNy8X9Xn5E5uT+/zD9NVXdhqV78h006M
        OxG57cviB0LYzWaKWWx/H5dhCrCsMdRAS+1p2B3MmNxO+lO+y9hvM+qP3JkVLMjG0GR11p
        jxY+SzJC6wFapLQyh2Q8MB9L2/horfU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-DbhiCgNbPwOFGc2htHgDpQ-1; Wed, 02 Feb 2022 04:51:19 -0500
X-MC-Unique: DbhiCgNbPwOFGc2htHgDpQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 391BA1091DBF;
        Wed,  2 Feb 2022 09:51:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D3AC752AA;
        Wed,  2 Feb 2022 09:51:01 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: SVM: nSVM: Implement Enlightened MSR-Bitmap for Hyper-V-on-KVM
Date:   Wed,  2 Feb 2022 10:50:56 +0100
Message-Id: <20220202095100.129834-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
- Patches 1/2 from "[PATCH 0/5] KVM: SVM: nSVM: Implement Enlightened
  MSR-Bitmap for Hyper-V-on-KVM and fix it for KVM-on-Hyper-V" are already
  merged, dropped.
- Fix build when !CONFIG_HYPERV (PATCH3 "KVM: nSVM: Split off common
  definitions for Hyper-V on KVM and KVM on Hyper-V" added).

Description:

Enlightened MSR-Bitmap feature implements a PV protocol for L0 and L1
hypervisors to collaborate and skip unneeded updates to MSR-Bitmap.
KVM already implements the feature for KVM-on-Hyper-V.

Vitaly Kuznetsov (4):
  KVM: nSVM: Track whether changes in L0 require MSR bitmap for L2 to be
    rebuilt
  KVM: x86: Make kvm_hv_hypercall_enabled() static inline
  KVM: nSVM: Split off common definitions for Hyper-V on KVM and KVM on
    Hyper-V
  KVM: nSVM: Implement Enlightened MSR-Bitmap feature

 arch/x86/kvm/hyperv.c           | 12 +--------
 arch/x86/kvm/hyperv.h           |  6 ++++-
 arch/x86/kvm/svm/hyperv.h       | 35 ++++++++++++++++++++++++
 arch/x86/kvm/svm/nested.c       | 47 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.c          |  3 ++-
 arch/x86/kvm/svm/svm.h          | 11 ++++++++
 arch/x86/kvm/svm/svm_onhyperv.h | 25 +-----------------
 7 files changed, 95 insertions(+), 44 deletions(-)
 create mode 100644 arch/x86/kvm/svm/hyperv.h

-- 
2.34.1

