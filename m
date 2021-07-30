Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A0F3DB888
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 14:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbhG3M0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 08:26:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230355AbhG3M0j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 08:26:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627647994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Rrhyyvp0zkFQtrfd/3DV5heIe5kJo0eO//g6b1U7eNs=;
        b=PPYOkXVkpx+AEWHDBhTVyL1sHyt1C1ZBTuJcVaLuXdLCnTgz8qPuIKh7adp6nJNLUbt3Ex
        CTJ/NyA5atlm6K9U+wi4KL2xoAzpTcstZCVS2YC2h6ogKxxQ2lT6SBlCejwFBPef4bV47z
        HyTvCuOwlnyXU2l2iYwV2Ic9HIPwgm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-DCfAMmnqMcupEaG5ApwhTg-1; Fri, 30 Jul 2021 08:26:33 -0400
X-MC-Unique: DCfAMmnqMcupEaG5ApwhTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F156018C89DA;
        Fri, 30 Jul 2021 12:26:31 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DD0B18C7A;
        Fri, 30 Jul 2021 12:26:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: x86: hyper-v: Check if guest is allowed to use XMM registers for hypercall input
Date:   Fri, 30 Jul 2021 14:26:21 +0200
Message-Id: <20210730122625.112848-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"KVM: x86: hyper-v: Fine-grained access check to Hyper-V hypercalls and
MSRs" and "Add support for XMM fast hypercalls" series were developed
at the same time so the later landed without a proper feature bit check
for 'strict' (KVM_CAP_HYPERV_ENFORCE_CPUID) mode. Add it now.

TLFS states that "Availability of the XMM fast hypercall interface is
indicated via the “Hypervisor Feature Identification” CPUID Leaf
(0x40000003, see section 2.4.4) ... Any attempt to use this interface
when the hypervisor does not indicate availability will result in a #UD
fault."

Vitaly Kuznetsov (4):
  KVM: x86: hyper-v: Check access to hypercall before reading XMM
    registers
  KVM: x86: Introduce trace_kvm_hv_hypercall_done()
  KVM: x86: hyper-v: Check if guest is allowed to use XMM registers for
    hypercall input
  KVM: selftests: Test access to XMM fast hypercalls

 arch/x86/kvm/hyperv.c                         | 18 ++++++--
 arch/x86/kvm/trace.h                          | 15 +++++++
 .../selftests/kvm/include/x86_64/hyperv.h     |  5 ++-
 .../selftests/kvm/x86_64/hyperv_features.c    | 41 +++++++++++++++++--
 4 files changed, 71 insertions(+), 8 deletions(-)

-- 
2.31.1

