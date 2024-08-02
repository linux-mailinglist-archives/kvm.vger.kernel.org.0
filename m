Return-Path: <kvm+bounces-23129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B444D946441
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:14:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5EC11C2146F
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF47F6A33A;
	Fri,  2 Aug 2024 20:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mATlp4Jt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B8B4C61B
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722629674; cv=none; b=QHtCKl0MbXj5FszjnOIkvA5s2KuCyxYj03TLAIxE4Nhl8NPm7HnfSADdyrwlLCSJK48ljPjKl+mrJcXFDSsIV2UzWd6Xyk5bYBXkqj2L7DZhuABTl0FfOy1W6pHHH2eOgc7KCVKEzDN3uAj6hinCbj17oR+TlNbOISiP9F8Ub0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722629674; c=relaxed/simple;
	bh=xe5PnUuA6XU4wC83rP+yXvrEX+ZHetMhcLHOc+nWmBw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ikPJujBtL78DXW4KFa5LiAKlZakiMwtoql6FKq6whJC4G/Q4xBNLGJBrjVdGzOhkLRYv02EmS4wu8Z16GQfEHhUOfQcfUMyi7jB2MI9+HD0LkQfrQ0Ar5ulsLxVPeCqE0CXsU6kFILn9YD8BCQli77TYSQ/GzpLsuVYW4XfSBfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mATlp4Jt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc596b86a6so37639845ad.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722629672; x=1723234472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WQ+fEs3LsntUlJZqxcHJm6QlCpJ7OHbayZdrEYcxOd0=;
        b=mATlp4JtpwPe93Ysth8NLRyYWv9aLg9tLpld9gWet4SQ9zHXR67E1lZjIAKLXfHxIu
         KxVNenPJ6FSKIc5slGjqV1KmF7HZaPmlRltcy9dQ/h2lE93YO0vtjWqX2CqMDjAHY0hb
         MO2JbjE3ddVndQkQrStIhSLQMhQkbaxbCMC0eZBWRzpZOPGI7K+xviNXEbnYnkuDIQ2A
         aS/VDpNo/LoseY5HvMvjeTen5EU4srPSrywucyxdgMNCSzs84H9kvGrIUZc1kECUTL05
         vdSGGNYFfjoSZZGa0xkvXVwCqcFikbmJLUw2z8YYixVedyp3631QXK2UlCRMWtZE64/P
         L48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722629672; x=1723234472;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WQ+fEs3LsntUlJZqxcHJm6QlCpJ7OHbayZdrEYcxOd0=;
        b=WRd5SZO7Hpbt61xJUaHm+N/tLMKI5Mbf8ow4cywLn3gENZHzVWRvZdoYDj1OA8fHcu
         Z0M6m3N6WHVOYqKGZ8HZRDKi/lvmMlQSp5/4nsFH8Bpi1ZfD2FeoSTVh5u3raOS4n2o4
         x/OxHmbE80II7O6e4lYGGWD9V1SszE8cuDHCweYk8ourHjD/Ke7FEhaLcR4+1cRlexiy
         lCso00dJCC2e+29seK+xmnTjN82sgQhEzrCh1kayte39Nk6oAj+q1/eoxcEftFpiQLXu
         VmJL7tQGwgSqYHA1w8sg1SWx8l9ePxaUJfTOdw4b1o4QAVpkg/XXmR305ZbXx5fQKwUd
         y1ug==
X-Gm-Message-State: AOJu0YxD5Cjmxd9y7t21wbIs8l9z4V5g9uzyGJKtkPeeI0FfJK27X0pP
	zKtYWltIyfg1SwHm3X3Ws7l3GQseM1rW3snYJFsGNWBmsA6pCTTzNUOieGqnmyl2kT5oBzmWb8d
	luw==
X-Google-Smtp-Source: AGHT+IHDcF0qP1uJC6IVnhoZQo/YQGDSYJtI4Xt2dbbYqJZ/1Z4WIL3eIZE7tO+KB7/Cx1q3ay0AoCbiBbQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:110e:b0:1fb:526a:5d60 with SMTP id
 d9443c01a7336-1ff57b85debmr1624915ad.4.1722629671812; Fri, 02 Aug 2024
 13:14:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:14:29 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802201429.338412-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Always unlink memory regions when deleting
 (VM free)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Unlink memory regions when freeing a VM, even though it's not strictly
necessary since all tracking structures are freed soon after.  The time
spent deleting entries is negligible, and not unlinking entries is
confusing, e.g. it's easy to overlook that the tree structures are
freed by the caller.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 56b170b725b3..75f2d737c49f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -712,16 +712,13 @@ void kvm_vm_release(struct kvm_vm *vmp)
 }
 
 static void __vm_mem_region_delete(struct kvm_vm *vm,
-				   struct userspace_mem_region *region,
-				   bool unlink)
+				   struct userspace_mem_region *region)
 {
 	int ret;
 
-	if (unlink) {
-		rb_erase(&region->gpa_node, &vm->regions.gpa_tree);
-		rb_erase(&region->hva_node, &vm->regions.hva_tree);
-		hash_del(&region->slot_node);
-	}
+	rb_erase(&region->gpa_node, &vm->regions.gpa_tree);
+	rb_erase(&region->hva_node, &vm->regions.hva_tree);
+	hash_del(&region->slot_node);
 
 	region->region.memory_size = 0;
 	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
@@ -762,7 +759,7 @@ void kvm_vm_free(struct kvm_vm *vmp)
 
 	/* Free userspace_mem_regions. */
 	hash_for_each_safe(vmp->regions.slot_hash, ctr, node, region, slot_node)
-		__vm_mem_region_delete(vmp, region, false);
+		__vm_mem_region_delete(vmp, region);
 
 	/* Free sparsebit arrays. */
 	sparsebit_free(&vmp->vpages_valid);
@@ -1270,7 +1267,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
  */
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
 {
-	__vm_mem_region_delete(vm, memslot2region(vm, slot), true);
+	__vm_mem_region_delete(vm, memslot2region(vm, slot));
 }
 
 void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,

base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog


