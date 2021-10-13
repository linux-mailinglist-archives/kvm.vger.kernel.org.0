Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BDE42C2E7
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbhJMOZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:25:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232784AbhJMOZO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 10:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634134988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=F8w0gr2s0p5Y9XuSghq/DT9dL9AfRquLqTdZ3zh5cAA=;
        b=NPdT0XLHOkB3RgKpHMcWUojyo6XjsiWH91jhgOd7+/bsrMzm95AEvTNQe5GlurMSwKe7g0
        UShFoKXLiC8US2tX7qkOmGb2JhjZdMwidGf5eGpc3N3mRe9Hb4NNsq8hsk5wGCtbsp1/4H
        Xv+anSsJfah9JrSKaksfosUQMj/DTsI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-tA8fSd5KMCiboKvKHrJFcA-1; Wed, 13 Oct 2021 10:23:05 -0400
X-MC-Unique: tA8fSd5KMCiboKvKHrJFcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D9CD9F92A;
        Wed, 13 Oct 2021 14:23:02 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCC9469119;
        Wed, 13 Oct 2021 14:22:59 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] KVM: nVMX: Enlightened MSR Bitmap feature for Hyper-V on KVM
Date:   Wed, 13 Oct 2021 16:22:54 +0200
Message-Id: <20211013142258.1738415-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v2:
- Renamed 'msr_bitmap_changed' to 'msr_bitmap_force_recalc' [Paolo] and
  expanded the comment near its definition explaining its limited 
  usefulness [Sean].

Original description:

Updating MSR bitmap for L2 is not cheap and rearly needed. TLFS for Hyper-V
offers 'Enlightened MSR Bitmap' feature which allows L1 hypervisor to
inform L0 when it changes MSR bitmap, this eliminates the need to examine
L1's MSR bitmap for L2 every time when 'real' MSR bitmap for L2 gets
constructed.

When the feature is enabled for Win10+WSL2, it shaves off around 700 CPU
cycles from a nested vmexit cost (tight cpuid loop test).

First patch of the series is unrelated to the newly implemented feature,
it fixes a bug in Enlightened MSR Bitmap usage when KVM runs as a nested
hypervisor on top of Hyper-V.

Vitaly Kuznetsov (4):
  KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
  KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
  KVM: nVMX: Track whether changes in L0 require MSR bitmap for L2 to be
    rebuilt
  KVM: nVMX: Implement Enlightened MSR Bitmap feature

 arch/x86/kvm/hyperv.c     |  2 ++
 arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c    | 40 ++++++++++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h    |  9 +++++++++
 4 files changed, 64 insertions(+), 16 deletions(-)

-- 
2.31.1

