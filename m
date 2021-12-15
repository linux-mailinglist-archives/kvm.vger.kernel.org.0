Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC451475972
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 14:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242740AbhLONKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 08:10:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51102 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbhLONKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 08:10:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B091AB81EE1;
        Wed, 15 Dec 2021 13:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9817BC34604;
        Wed, 15 Dec 2021 13:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639573844;
        bh=cSCHf08gNddSPudJMuHhsja3lVVsLg6htioa9itM0kg=;
        h=From:To:Cc:Subject:Date:From;
        b=rqpMEzO4BPigITRsCG3cE7IjJQAdbqfFpwM2mlK0tb6a3ZOHeUT+rFKHu4tTqnBAn
         OSznOAsGaePpqjUxqw7mVCIo0P56W1JXjVcPjZs1zBmpXatW6lpUu8z/SuII7gKGRn
         0n5W131UJFUVIbm/zvNyeSgD2MGi5iKOOGRwlXVJGbqz0T7fB3bcSAkplpowfoTOGh
         XjsqcMtE6d53cvrXvGvxtViPiEXzce/M9DgRGdYJNAvL1mOOqEOY3WnC0yYuE7mAvA
         Z3s85YGIeooGyJylTQs4j0AJNPCqy+0oSrLT2IOhJeYmZmITLDdeojcW6X3Fn3XsN3
         SvofUVtQF3vdg==
From:   broonie@kernel.org
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm tree with the kvm tree
Date:   Wed, 15 Dec 2021 13:10:33 +0000
Message-Id: <20211215131033.2541027-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/powerpc/kvm/book3s_hv.c

between commit:

  511d25d6b789f ("KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots")

from the kvm tree and commits:

  537a17b314930 ("KVM: Let/force architectures to deal with arch specific memslot data")
  eaaaed137eccb ("KVM: PPC: Avoid referencing userspace memory region in memslot updates")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc arch/powerpc/kvm/book3s_hv.c
index f64e45d6c0f4c,51e1c29a6fa08..0000000000000
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@@ -4866,21 -4854,17 +4866,22 @@@ static void kvmppc_core_free_memslot_hv
  }
  
  static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
- 					struct kvm_memory_slot *slot,
- 					const struct kvm_userspace_memory_region *mem,
- 					enum kvm_mr_change change)
+ 				const struct kvm_memory_slot *old,
+ 				struct kvm_memory_slot *new,
+ 				enum kvm_mr_change change)
  {
- 	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
- 
  	if (change == KVM_MR_CREATE) {
- 		unsigned long size = array_size(npages, sizeof(*slot->arch.rmap));
 -		new->arch.rmap = vzalloc(array_size(new->npages,
 -					  sizeof(*new->arch.rmap)));
++		unsigned long size = array_size(new->npages,
++						sizeof(*new->arch.rmap));
 +
 +		if ((size >> PAGE_SHIFT) > totalram_pages())
 +			return -ENOMEM;
 +
- 		slot->arch.rmap = vzalloc(size);
- 		if (!slot->arch.rmap)
++		new->arch.rmap = vzalloc(size);
+ 		if (!new->arch.rmap)
  			return -ENOMEM;
+ 	} else if (change != KVM_MR_DELETE) {
+ 		new->arch.rmap = old->arch.rmap;
  	}
  
  	return 0;
