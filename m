Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0961BD85C
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 11:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgD2Jgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 05:36:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41450 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726423AbgD2Jgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 05:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588153003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YqX8OZzl6x7aX0kjunMJb9gmMH7onlmLMnzmB4yGxPk=;
        b=aygvl/kroBBB0RwENTEq7jl463YT7Iy81hVIeMijVrbQGM6DK25rjiNBppmmXZeG4ANyeA
        UM7RiDNSwzek4Dy+t/5lJpSshc7F2oHtf6N6QaiPYe3ACNRULfIe4vHN5wpFyCz9pCxR30
        LGEwW04nTr/NjRTj/nQW7zG5fTIy66M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-cP-seqnhMPWc9DjOrXQJKg-1; Wed, 29 Apr 2020 05:36:42 -0400
X-MC-Unique: cP-seqnhMPWc9DjOrXQJKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B728835B41;
        Wed, 29 Apr 2020 09:36:40 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54E4F5D9C9;
        Wed, 29 Apr 2020 09:36:36 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     x86@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 0/6] KVM: x86: Interrupt-based mechanism for async_pf 'page present' notifications
Date:   Wed, 29 Apr 2020 11:36:28 +0200
Message-Id: <20200429093634.1514902-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Concerns were expressed around (ab)using #PF for KVM's async_pf mechanism=
,
it seems that re-using #PF exception for a PV mechanism wasn't a great
idea after all. The Grand Plan is to switch to using e.g. #VE for 'page
not present' events and normal APIC interrupts for 'page present' events.
This RFC does the later.

Please let me know what you think about the idea in general and the
selected approach in particular.

Vitaly Kuznetsov (6):
  Revert "KVM: async_pf: Fix #DF due to inject "Page not Present" and
    "Page Ready" exceptions simultaneously"
  KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
  KVM: x86: interrupt based APF page-ready event delivery
  KVM: x86: acknowledgment mechanism for async pf page ready
    notifications
  KVM: x86: announce KVM_FEATURE_ASYNC_PF_INT
  KVM: x86: Switch KVM guest to using interrupts for page ready APF
    delivery

 Documentation/virt/kvm/cpuid.rst     |   6 ++
 Documentation/virt/kvm/msr.rst       |  52 +++++++++++--
 arch/x86/entry/entry_32.S            |   5 ++
 arch/x86/entry/entry_64.S            |   5 ++
 arch/x86/include/asm/hardirq.h       |   3 +
 arch/x86/include/asm/irq_vectors.h   |   6 +-
 arch/x86/include/asm/kvm_host.h      |   5 +-
 arch/x86/include/asm/kvm_para.h      |   6 ++
 arch/x86/include/uapi/asm/kvm_para.h |  11 ++-
 arch/x86/kernel/irq.c                |   9 +++
 arch/x86/kernel/kvm.c                |  42 +++++++++++
 arch/x86/kvm/cpuid.c                 |   3 +-
 arch/x86/kvm/x86.c                   | 107 +++++++++++++++++++++------
 include/uapi/linux/kvm.h             |   1 +
 14 files changed, 228 insertions(+), 33 deletions(-)

--=20
2.25.3

