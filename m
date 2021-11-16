Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551E645379B
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 17:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhKPQhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 11:37:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232505AbhKPQhy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 11:37:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637080496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H98AZZt3YXueDbe06DAd9PZXKaVwBHPevQBi7cG9ec0=;
        b=akSusBRJ6xJ9GP2/XhcLxu3VUFyX8rOYwD8jv0RU/u6MZkNZmQkJ6rfzaQUUJPLXhSoxdj
        hcMz+xJoBeZMxc3VKjXkvoxAmBc2Pq/nyLIFcyl46f77l1a3dZAUdFt8ggKx6V3CGzDG3F
        7UeZ6Op8F8BkunLUf4uuovkRJRJmvOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-FaBZdD75OCuo2_pGh_WFDw-1; Tue, 16 Nov 2021 11:34:55 -0500
X-MC-Unique: FaBZdD75OCuo2_pGh_WFDw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5B8487D544;
        Tue, 16 Nov 2021 16:34:52 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AE0C60C7F;
        Tue, 16 Nov 2021 16:34:44 +0000 (UTC)
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
        Michael Ellerman <mpe@ellerman.id.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] KVM: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS and re-purpose it on x86
Date:   Tue, 16 Nov 2021 17:34:37 +0100
Message-Id: <20211116163443.88707-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
- PATCH6 for s390 added.
- On ARM64, do not make KVM_CAP_NR_VCPUS return value dependent on whether
  it is a system-wide ioctl or a per-VM one [Marc Zyngier].

Original description:

This is a continuation of "KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS"
(https://lore.kernel.org/kvm/20211111134733.86601-1-vkuznets@redhat.com/)
work.

1) Enforce KVM_CAP_NR_VCPUS <= KVM_CAP_MAX_VCPUS rule on all 
 architectures. [Sean Christopherson]
2) Make KVM_CAP_NR_VCPUS return num_online_cpus() and not an arbitrary
 value of '710' on x86.

Everything but x86 was only 'eyeball tested', the change is trivial
but sorry in advance if I screwed up)

Vitaly Kuznetsov (6):
  KVM: arm64: Cap KVM_CAP_NR_VCPUS by kvm_arm_default_max_vcpus()
  KVM: MIPS: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
  KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
  KVM: RISC-V: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
  KVM: s390: Cap KVM_CAP_NR_VCPUS by num_online_cpus()
  KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS

 arch/arm64/kvm/arm.c            | 9 ++++++++-
 arch/mips/kvm/mips.c            | 2 +-
 arch/powerpc/kvm/powerpc.c      | 4 ++--
 arch/riscv/kvm/vm.c             | 2 +-
 arch/s390/kvm/kvm-s390.c        | 2 ++
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/x86.c              | 2 +-
 7 files changed, 15 insertions(+), 7 deletions(-)

-- 
2.33.1

