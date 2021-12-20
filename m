Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5C047AFE8
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 16:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238639AbhLTPWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 10:22:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239663AbhLTPVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 10:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640013707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Lw5slxjixiems1mI2kUAJ2ICdnSN+YeINpTB5Htz2PE=;
        b=UYTaV1NXyR5QHgUDzTPtrP3euxFdO5Kr1OMF6XRhiSNGyjnJoRVwCF+D4es478bZ0WgTuj
        LkLMwb0bPE6/XNmG1V/fvajlbz703rQ3GYJy4eq8pN3HAtcQUpVNi08wnvT+eIg2peGq6P
        OyB+ctWlu0PCdg4OhMfEy4pBJt8wh1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-_H-GiVkiOwmbHHLi1_mefg-1; Mon, 20 Dec 2021 10:21:46 -0500
X-MC-Unique: _H-GiVkiOwmbHHLi1_mefg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A14CD1006AA9;
        Mon, 20 Dec 2021 15:21:44 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 052C57B6CE;
        Mon, 20 Dec 2021 15:21:40 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] KVM: SVM: nSVM: Implement Enlightened MSR-Bitmap for Hyper-V-on-KVM and fix it for KVM-on-Hyper-V
Date:   Mon, 20 Dec 2021 16:21:34 +0100
Message-Id: <20211220152139.418372-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened MSR-Bitmap feature implements a PV protocol for L0 and L1
hypervisors to collaborate and skip unneeded updates to MSR-Bitmap.
KVM implements the feature for KVM-on-Hyper-V but it seems there was
a flaw in the implementation and the feature may not be fully functional.
PATCHes 1-2 fix the problem. The rest of the series implements the same
feature for Hyper-V-on-KVM.

Vitaly Kuznetsov (5):
  KVM: SVM: Drop stale comment from
    svm_hv_vmcb_dirty_nested_enlightenments()
  KVM: SVM: hyper-v: Enable Enlightened MSR-Bitmap support for real
  KVM: nSVM: Track whether changes in L0 require MSR bitmap for L2 to be
    rebuilt
  KVM: x86: Make kvm_hv_hypercall_enabled() static inline
  KVM: nSVM: Implement Enlightened MSR-Bitmap feature

 arch/x86/kvm/hyperv.c           | 12 +--------
 arch/x86/kvm/hyperv.h           |  6 ++++-
 arch/x86/kvm/svm/nested.c       | 47 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.c          |  3 ++-
 arch/x86/kvm/svm/svm.h          | 16 +++++++----
 arch/x86/kvm/svm/svm_onhyperv.h | 12 +++------
 6 files changed, 63 insertions(+), 33 deletions(-)

-- 
2.33.1

