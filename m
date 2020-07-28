Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8216230C8C
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 16:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbgG1Oh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 10:37:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53599 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730451AbgG1Oh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 10:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595947075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8QXSO/i3jp95ipr7aX72WVFqXrse1Eq2BTavylZNpEE=;
        b=S/AS6QzhbunpS8am5UDnjZqHK2Wg4Ha1Gm1LxYfejkn093SoJpg6mxJI702M5ueNNLVRlk
        +5tevpTQpczZBem2pQ/FHfXJQOPyopnFJAnLoZGG6R0ghCdx+11WW/CtQWyhVnDJkQ5lXG
        yZeGQhWWwkoywPcJwOT9bnC6FIvlM5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-w2s9GueHMyORLL8X2rDX-Q-1; Tue, 28 Jul 2020 10:37:54 -0400
X-MC-Unique: w2s9GueHMyORLL8X2rDX-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0DFC1932480;
        Tue, 28 Jul 2020 14:37:52 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D47DE90E84;
        Tue, 28 Jul 2020 14:37:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Date:   Tue, 28 Jul 2020 16:37:38 +0200
Message-Id: <20200728143741.2718593-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a continuation of "[PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES
memory" work: 
https://lore.kernel.org/kvm/20200514180540.52407-1-vkuznets@redhat.com/
and pairs with Julia's "x86/PCI: Use MMCONFIG by default for KVM guests":
https://lore.kernel.org/linux-pci/20200722001513.298315-1-jusual@redhat.com/

PCIe config space can (depending on the configuration) be quite big but
usually is sparsely populated. Guest may scan it by accessing individual
device's page which, when device is missing, is supposed to have 'pci
hole' semantics: reads return '0xff' and writes get discarded.

When testing Linux kernel boot with QEMU q35 VM and direct kernel boot
I observed 8193 accesses to PCI hole memory. When such exit is handled
in KVM without exiting to userspace, it takes roughly 0.000001 sec.
Handling the same exit in userspace is six times slower (0.000006 sec) so
the overal; difference is 0.04 sec. This may be significant for 'microvm'
ideas.

Note, the same speed can already be achieved by using KVM_MEM_READONLY
but doing this would require allocating real memory for all missing
devices and e.g. 8192 pages gives us 32mb. This will have to be allocated
for each guest separately and for 'microvm' use-cases this is likely
a no-go.

Introduce special KVM_MEM_PCI_HOLE memory: userspace doesn't need to
back it with real memory, all reads from it are handled inside KVM and
return '0xff'. Writes still go to userspace but these should be extremely
rare.

The original 'KVM_MEM_ALLONES' idea had additional optimizations: KVM
was mapping all 'PCI hole' pages to a single read-only page stuffed with
0xff. This is omitted in this submission as the benefits are unclear:
KVM will have to allocate SPTEs (either on demand or aggressively) and
this also consumes time/memory. We can always take a look at possible
optimizations later.

Vitaly Kuznetsov (3):
  KVM: x86: move kvm_vcpu_gfn_to_memslot() out of try_async_pf()
  KVM: x86: introduce KVM_MEM_PCI_HOLE memory
  KVM: selftests: add KVM_MEM_PCI_HOLE test

 Documentation/virt/kvm/api.rst                |  19 ++-
 arch/x86/include/uapi/asm/kvm.h               |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  19 +--
 arch/x86/kvm/mmu/paging_tmpl.h                |  10 +-
 arch/x86/kvm/x86.c                            |  10 +-
 include/linux/kvm_host.h                      |   7 +-
 include/uapi/linux/kvm.h                      |   3 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  81 +++++++------
 .../kvm/x86_64/memory_slot_pci_hole.c         | 112 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |  39 ++++--
 12 files changed, 243 insertions(+), 60 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/memory_slot_pci_hole.c

-- 
2.25.4

