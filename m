Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC7D44DA62
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 17:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbhKKQav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 11:30:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233945AbhKKQau (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 11:30:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636648081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CF3Hv1Bl+ogsp2j/RVKC+aJzOVJPQU9lGZ+gEbRRDTY=;
        b=anSynQYbf+WCSdgpcY3RpdZ/vkV45I1a8YUVxMoQ4Pr1+mYQ2ZFQw1v2/CmvH/xsxmIvoJ
        hoNUC1JBh9fPIy6RvkPaMXEqCX1sGKavPpsJAxMjx8iW6S7ujrdqwl6AC1T3D4h9dC9fni
        fn6Vc9P98fdMES0NLjKVk6F1H7QMAis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-9nC3unzeMd2Fx6h_nH8MfQ-1; Thu, 11 Nov 2021 11:27:57 -0500
X-MC-Unique: 9nC3unzeMd2Fx6h_nH8MfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E4291006ABF;
        Thu, 11 Nov 2021 16:27:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 981871017CE3;
        Thu, 11 Nov 2021 16:27:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] KVM: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS and re-purpose it on x86
Date:   Thu, 11 Nov 2021 17:27:41 +0100
Message-Id: <20211111162746.100598-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a comtinuation of "KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS"
(https://lore.kernel.org/kvm/20211111134733.86601-1-vkuznets@redhat.com/)
work.

1) Enforce KVM_CAP_NR_VCPUS <= KVM_CAP_MAX_VCPUS rule on all 
 architectures. [Sean Christopherson]
2) Make KVM_CAP_NR_VCPUS return num_online_cpus() and not an arbitrary
 value of '710' on x86.

Everything but x86 was only 'eyeball tested', the change is trivial
but sorry in advance if I screwed up)

Vitaly Kuznetsov (5):
  KVM: arm64: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
  KVM: MIPS: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
  KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
  KVM: RISC-V: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
  KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS

 arch/arm64/kvm/arm.c            | 7 ++++++-
 arch/mips/kvm/mips.c            | 2 +-
 arch/powerpc/kvm/powerpc.c      | 4 ++--
 arch/riscv/kvm/vm.c             | 2 +-
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/x86.c              | 2 +-
 6 files changed, 11 insertions(+), 7 deletions(-)

-- 
2.33.1

