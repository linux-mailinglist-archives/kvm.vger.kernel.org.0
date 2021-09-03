Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49C740075A
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 23:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbhICVRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 17:17:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235751AbhICVRH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 17:17:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630703765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DGhICUvul4bltoPSVdhrANIkXlMFC6PEWLGz0kCVtQ4=;
        b=C6F4va2ilXO/BuDWtBZTR4O3N45CZGo15QazwbGavLjAKCMRa+XFVDI1lIyQavbOHt3ZDP
        tti+3NzkonXfMdbSfuno4qFDSTl29cXofim0pz4OH6bvlH01tI/fBT9iBpHxkCzOvH8Ihl
        p1pSC8cgLVB5j70fB2S++u5iQ46d/zg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-juPxDQe2MtWsQ7D4iQw9oA-1; Fri, 03 Sep 2021 17:16:04 -0400
X-MC-Unique: juPxDQe2MtWsQ7D4iQw9oA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B64081883520;
        Fri,  3 Sep 2021 21:16:03 +0000 (UTC)
Received: from localhost (unknown [10.22.8.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6261D5D9F0;
        Fri,  3 Sep 2021 21:16:03 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2 2/3] kvm: x86: Increase MAX_VCPUS to 1024
Date:   Fri,  3 Sep 2021 17:15:59 -0400
Message-Id: <20210903211600.2002377-3-ehabkost@redhat.com>
In-Reply-To: <20210903211600.2002377-1-ehabkost@redhat.com>
References: <20210903211600.2002377-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Increase KVM_MAX_VCPUS to 1024, so we can test larger VMs.

I'm not changing KVM_SOFT_MAX_VCPUS yet because I'm afraid it
might involve complicated questions around the meaning of
"supported" and "recommended" in the upstream tree.
KVM_SOFT_MAX_VCPUS will be changed in a separate patch.

For reference, visible effects of this change are:
- KVM_CAP_MAX_VCPUS will now return 1024 (of course)
- Default value for CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX
  will now be 1024
- KVM_MAX_VCPU_ID will change from 1151 to 4096
- Size of struct kvm will increase from 19328 to 22272 bytes
  (in x86_64)
- Size of struct kvm_ioapic will increase from 1780 to 5084 bytes
  (in x86_64)
- Bitmap stack variables that will grow:
  - At kvm_hv_flush_tlb() kvm_hv_send_ipi(),
    vp_bitmap[] and vcpu_bitmap[] will now be 128 bytes long
  - vcpu_bitmap at bioapic_write_indirect() will be 128 bytes long
    once patch "KVM: x86: Fix stack-out-of-bounds memory access
    from ioapic_write_indirect()" is applied

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
Note: this conflicts with:
  https://lore.kernel.org/lkml/20210903130808.30142-7-jgross@suse.com
  Date: Fri,  3 Sep 2021 15:08:07 +0200
  From: Juergen Gross <jgross@suse.com>
  Subject: [PATCH v2 6/6] x86/kvm: add boot parameter for setting max number of vcpus per
          guest
  Message-Id: <20210903130808.30142-7-jgross@suse.com>

I don't intend this to block Juergen's work.  If Juergen's series is merged
first, I can redo this patch to change KVM_DEFAULT_MAX_VCPUS instead.
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f4cbc08b8d4d..e30e40399092 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -37,7 +37,7 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
-#define KVM_MAX_VCPUS 288
+#define KVM_MAX_VCPUS 1024
 #define KVM_SOFT_MAX_VCPUS 240
 
 /*
-- 
2.31.1

