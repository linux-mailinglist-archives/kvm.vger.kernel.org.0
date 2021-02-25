Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45F13250A2
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 14:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhBYNk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 08:40:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231881AbhBYNkW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 08:40:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614260336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lAJU+Kapx1ZmAfsicjpeIBV3nVtHSrGbB3aXfXZpnYs=;
        b=cgjIF9YvDlqbVObmssjce2iX27ELXCB1SG34Pbt7cbFbdjVUCuPRbyyygVyBz0Vb86o4mF
        IyscW2WqQGgr/dIajMkRaZDZNTpT0hM16aJK1zioV45KjHUhGRGxSywxfM5PtT67KXmJuG
        Q6FSnoikvE6PRmfbXFy8RW5KKs29iZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-MZzIy0qFOxenNFcSu8XFbw-1; Thu, 25 Feb 2021 08:38:52 -0500
X-MC-Unique: MZzIy0qFOxenNFcSu8XFbw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A4CCCE646;
        Thu, 25 Feb 2021 13:38:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5ED819C48;
        Thu, 25 Feb 2021 13:38:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] Documentation: kvm: fix messy conversion from .txt to .rst
Date:   Thu, 25 Feb 2021 08:38:50 -0500
Message-Id: <20210225133850.7946-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Building the documentation gives a warning that the KVM_PPC_RESIZE_HPT_PREPARE
label is defined twice.  The root cause is that the KVM_PPC_RESIZE_HPT_PREPARE
API is present twice, the second being a mix of the prepare and commit APIs.
Fix it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 69 ++++++++--------------------------
 1 file changed, 16 insertions(+), 53 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0717bf523034..80237dee7a96 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3856,49 +3856,20 @@ base 2 of the page size in the bottom 6 bits.
          -EFAULT if struct kvm_reinject_control cannot be read,
 	 -EINVAL if the supplied shift or flags are invalid,
 	 -ENOMEM if unable to allocate the new HPT,
-	 -ENOSPC if there was a hash collision
-
-::
-
-  struct kvm_ppc_rmmu_info {
-	struct kvm_ppc_radix_geom {
-		__u8	page_shift;
-		__u8	level_bits[4];
-		__u8	pad[3];
-	}	geometries[8];
-	__u32	ap_encodings[8];
-  };
-
-The geometries[] field gives up to 8 supported geometries for the
-radix page table, in terms of the log base 2 of the smallest page
-size, and the number of bits indexed at each level of the tree, from
-the PTE level up to the PGD level in that order.  Any unused entries
-will have 0 in the page_shift field.
-
-The ap_encodings gives the supported page sizes and their AP field
-encodings, encoded with the AP value in the top 3 bits and the log
-base 2 of the page size in the bottom 6 bits.
-
-4.102 KVM_PPC_RESIZE_HPT_PREPARE
---------------------------------
-
-:Capability: KVM_CAP_SPAPR_RESIZE_HPT
-:Architectures: powerpc
-:Type: vm ioctl
-:Parameters: struct kvm_ppc_resize_hpt (in)
-:Returns: 0 on successful completion,
-	 >0 if a new HPT is being prepared, the value is an estimated
-         number of milliseconds until preparation is complete,
-         -EFAULT if struct kvm_reinject_control cannot be read,
-	 -EINVAL if the supplied shift or flags are invalid,when moving existing
-         HPT entries to the new HPT,
-	 -EIO on other error conditions
 
 Used to implement the PAPR extension for runtime resizing of a guest's
 Hashed Page Table (HPT).  Specifically this starts, stops or monitors
 the preparation of a new potential HPT for the guest, essentially
 implementing the H_RESIZE_HPT_PREPARE hypercall.
 
+::
+
+  struct kvm_ppc_resize_hpt {
+	__u64 flags;
+	__u32 shift;
+	__u32 pad;
+  };
+
 If called with shift > 0 when there is no pending HPT for the guest,
 this begins preparation of a new pending HPT of size 2^(shift) bytes.
 It then returns a positive integer with the estimated number of
@@ -3926,14 +3897,6 @@ Normally this will be called repeatedly with the same parameters until
 it returns <= 0.  The first call will initiate preparation, subsequent
 ones will monitor preparation until it completes or fails.
 
-::
-
-  struct kvm_ppc_resize_hpt {
-	__u64 flags;
-	__u32 shift;
-	__u32 pad;
-  };
-
 4.103 KVM_PPC_RESIZE_HPT_COMMIT
 -------------------------------
 
@@ -3956,6 +3919,14 @@ Hashed Page Table (HPT).  Specifically this requests that the guest be
 transferred to working with the new HPT, essentially implementing the
 H_RESIZE_HPT_COMMIT hypercall.
 
+::
+
+  struct kvm_ppc_resize_hpt {
+	__u64 flags;
+	__u32 shift;
+	__u32 pad;
+  };
+
 This should only be called after KVM_PPC_RESIZE_HPT_PREPARE has
 returned 0 with the same parameters.  In other cases
 KVM_PPC_RESIZE_HPT_COMMIT will return an error (usually -ENXIO or
@@ -3971,14 +3942,6 @@ HPT and the previous HPT will be discarded.
 
 On failure, the guest will still be operating on its previous HPT.
 
-::
-
-  struct kvm_ppc_resize_hpt {
-	__u64 flags;
-	__u32 shift;
-	__u32 pad;
-  };
-
 4.104 KVM_X86_GET_MCE_CAP_SUPPORTED
 -----------------------------------
 
-- 
2.26.2

