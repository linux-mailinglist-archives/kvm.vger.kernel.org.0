Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A1123EEC7
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 16:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgHGOMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 10:12:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48947 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726066AbgHGOMr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Aug 2020 10:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596809566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tdAn3ys9U2kvewBUw2A+IAMoPy0rqtTds5Mt68OPGgQ=;
        b=brelYi7yuOfFBuGVs1Z9ELciAln/xl4AtJpoyPtM4399fXRILAnKf8Cl504g6cflw/urPU
        X2lxTrJiHyrO8Ix2OubRTDWtLP4Ckz4I+x3v7Rqmz/l/6A1rcj4iXHCsi0yyDvC7NfWlnJ
        SX6Mormd1Kqezr4CAxwh2UBGxJKyOlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-mCUwJFpoNsOzgwbl7MG98w-1; Fri, 07 Aug 2020 10:12:44 -0400
X-MC-Unique: mCUwJFpoNsOzgwbl7MG98w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22CC119057A3;
        Fri,  7 Aug 2020 14:12:43 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD7BB5C1D3;
        Fri,  7 Aug 2020 14:12:33 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Date:   Fri,  7 Aug 2020 16:12:29 +0200
Message-Id: <20200807141232.402895-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
- Better KVM_SET_USER_MEMORY_REGION flags description, minor tweaks to
  the code [Drew Jones]
- BUG_ON() condition in __gfn_to_hva_memslot() adjusted.

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

 Documentation/virt/kvm/api.rst                |  18 ++-
 arch/x86/include/uapi/asm/kvm.h               |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  19 +--
 arch/x86/kvm/mmu/paging_tmpl.h                |  10 +-
 arch/x86/kvm/x86.c                            |  10 +-
 include/linux/kvm_host.h                      |   3 +
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  81 +++++++------
 .../kvm/x86_64/memory_slot_pci_hole.c         | 112 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |  39 ++++--
 12 files changed, 239 insertions(+), 58 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/memory_slot_pci_hole.c

-- 
2.25.4

