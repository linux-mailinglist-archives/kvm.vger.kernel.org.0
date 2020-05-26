Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2271D38D0
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 20:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgENSFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 14:05:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726075AbgENSFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 14:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589479550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LLFv8mqHtnrI3q8vZushlb2smHCADXuknkmWKektqUM=;
        b=IWhLAZ3kQVdoXKwrtg/WuFUCzPYIqEFeG7TGMt6DIDxMfR/JU316ImwC1Emdn3ObRQvXLM
        +XmVkyz0FZIVEW7Txo39TPQ6mAYlQyTrrDVEx6wbC61HV0o4fyofAO7g7w8hN0C+Bp1IOm
        7ruJKi1BmauEou1ZwcYqQHR3fdXdJ2E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-1kpvXTpgMCi_hSasxGTFTw-1; Thu, 14 May 2020 14:05:48 -0400
X-MC-Unique: 1kpvXTpgMCi_hSasxGTFTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C6731005510;
        Thu, 14 May 2020 18:05:47 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 412E55D9CA;
        Thu, 14 May 2020 18:05:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: [PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES memory
Date:   Thu, 14 May 2020 20:05:35 +0200
Message-Id: <20200514180540.52407-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The idea of the patchset was suggested by Michael S. Tsirkin.

PCIe config space can (depending on the configuration) be quite big but
usually is sparsely populated. Guest may scan it by accessing individual
device's page which, when device is missing, is supposed to have 'pci
holes' semantics: reads return '0xff' and writes get discarded. Currently,
userspace has to allocate real memory for these holes and fill them with
'0xff'. Moreover, different VMs usually require different memory.

The idea behind the feature introduced by this patch is: let's have a
single read-only page filled with '0xff' in KVM and map it to all such
PCI holes in all VMs. This will free userspace of obligation to allocate
real memory and also allow us to speed up access to these holes as we
can aggressively map the whole slot upon first fault.

RFC. I've only tested the feature with the selftest (PATCH5) on Intel/AMD
with and wiuthout EPT/NPT. I haven't tested memslot modifications yet.

Patches are against kvm/next.

Vitaly Kuznetsov (5):
  KVM: rename labels in kvm_init()
  KVM: x86: introduce KVM_MEM_ALLONES memory
  KVM: x86: move kvm_vcpu_gfn_to_memslot() out of try_async_pf()
  KVM: x86: aggressively map PTEs in KVM_MEM_ALLONES slots
  KVM: selftests: add KVM_MEM_ALLONES test

 Documentation/virt/kvm/api.rst                |  22 ++--
 arch/x86/include/uapi/asm/kvm.h               |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  34 ++++--
 arch/x86/kvm/mmu/paging_tmpl.h                |  30 ++++-
 arch/x86/kvm/x86.c                            |   9 +-
 include/linux/kvm_host.h                      |  15 ++-
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  81 +++++++------
 .../kvm/x86_64/memory_region_allones.c        | 112 ++++++++++++++++++
 virt/kvm/kvm_main.c                           | 110 +++++++++++++----
 12 files changed, 342 insertions(+), 76 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/memory_region_allones.c

-- 
2.25.4

