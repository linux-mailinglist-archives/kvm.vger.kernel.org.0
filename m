Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE29387B82
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 16:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236482AbhEROpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 10:45:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236137AbhEROpF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 10:45:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621349027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SnOgIuG0QI+D7+cp//iQj6D3t7PXPlfIr3EDmLUD8cw=;
        b=WNsxYLOrvagJF5/1NSYAbRwqFEKmLT4o6qT4fAKFEQo6Qa5/SyPcmG7CEtzPNT9XMNOATW
        DpSEaTAfXScUxAwYNj27LqEpfFdVwbvvnMZ00Hc2mV6jrMAZAGe5DNw/I7AlbSGbyK5dm7
        g6n4IBNQBUxgJrIm9hx2dNKNZD3jKs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-WW7pL-ltMkez6h8FlYudqw-1; Tue, 18 May 2021 10:43:44 -0400
X-MC-Unique: WW7pL-ltMkez6h8FlYudqw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 327C9188E3C1;
        Tue, 18 May 2021 14:43:43 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B22671349A;
        Tue, 18 May 2021 14:43:40 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] KVM: x86: hyper-v: Conditionally allow SynIC with APICv/AVIC
Date:   Tue, 18 May 2021 16:43:34 +0200
Message-Id: <20210518144339.1987982-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1 (Sean):
- Use common 'enable_apicv' variable for both APICv and AVIC instead of 
 adding a new hook to 'struct kvm_x86_ops'.
- Drop unneded CONFIG_X86_LOCAL_APIC checks from VMX/SVM code along the
 way.

Original description:

APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
however, possible to track whether the feature was actually used by the
guest and only inhibit APICv/AVIC when needed.

The feature can be tested with QEMU's 'hv-passthrough' debug mode.

Note, 'avic' kvm-amd module parameter is '0' by default and thus needs to
be explicitly enabled.

Vitaly Kuznetsov (5):
  KVM: SVM: Drop unneeded CONFIG_X86_LOCAL_APIC check for AVIC
  KVM: VMX: Drop unneeded CONFIG_X86_LOCAL_APIC check from
    cpu_has_vmx_posted_intr()
  KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
  KVM: x86: Invert APICv/AVIC enablement check
  KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
    use

 arch/x86/include/asm/kvm_host.h |  5 ++++-
 arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++------
 arch/x86/kvm/svm/avic.c         | 16 +++++-----------
 arch/x86/kvm/svm/svm.c          | 24 +++++++++++++-----------
 arch/x86/kvm/svm/svm.h          |  2 --
 arch/x86/kvm/vmx/capabilities.h |  4 +---
 arch/x86/kvm/vmx/vmx.c          |  2 --
 arch/x86/kvm/x86.c              |  9 ++++++---
 8 files changed, 50 insertions(+), 39 deletions(-)

-- 
2.31.1

