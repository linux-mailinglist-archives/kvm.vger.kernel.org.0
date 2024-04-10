Return-Path: <kvm+bounces-14152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE6298A0116
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9431C1F258B5
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 20:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A60181CE9;
	Wed, 10 Apr 2024 20:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sXBQMsjo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BE031A60;
	Wed, 10 Apr 2024 20:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712779974; cv=none; b=ZhMlO+6johCTf1xfvww4gelfZUBCUV0T+t39ohpSuBr5pJ7xkUjE3ONPfB0PCAyI+dSjoO6YMkiCbICN07xuFdviKYS1Z7x41ZHBLkvTlPTAvorPKVTAIsA2P/3NIfK4yiQi4YOrlyE42j9A0i72QO24jFfaLbNiP55iCww1AYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712779974; c=relaxed/simple;
	bh=bKXTwEG9V/7gGFzi/nyfEqGiaBgclvN4MQublr5sz80=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=SCSERQU/MvL99EzH/D5Ot8N55qLRUWvoJ3Lj17jmK5Jh3RGcodpD7VcORNSIKJ3jBe7/Nl1igjRD5IG5Dh4I2QTz9nG80uOW0jHNs9MDiigSrY/cEUgwET6vOZoXq/Hsq8hcRiDK2PZp0j+3C9ujuy9jqkQuAcU7cTi7+rYbFLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sXBQMsjo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20D2C433F1;
	Wed, 10 Apr 2024 20:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712779973;
	bh=bKXTwEG9V/7gGFzi/nyfEqGiaBgclvN4MQublr5sz80=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sXBQMsjoj5uKsr9LmT+OooLDlwYt4YcTHKM6vzXBNrCG67rEEi7TQ0JN6rZ0WY8hn
	 vd+WikGTb95drIxuerlIJJsUEPwInCKguinDAK3geNfIlKkGVTtrHZzqT+atKs2XkF
	 /8T8Y1KtIpOeTdFjZLGaNwKYWKzWq/s5npDtdbmg=
Date: Wed, 10 Apr 2024 13:12:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org, Yonghua Huang
 <yonghua.huang@intel.com>, Fei Li <fei1.li@intel.com>, Christoph Hellwig
 <hch@lst.de>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko
 Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Alex
 Williamson <alex.williamson@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Subject: Re: [PATCH v1 1/3] drivers/virt/acrn: fix PFNMAP PTE checks in
 acrn_vm_ram_map()
Message-Id: <20240410131252.3ff0e92cfeccc4435bcdcdd2@linux-foundation.org>
In-Reply-To: <20240410155527.474777-2-david@redhat.com>
References: <20240410155527.474777-1-david@redhat.com>
	<20240410155527.474777-2-david@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Apr 2024 17:55:25 +0200 David Hildenbrand <david@redhat.com> wrote:

> We currently miss to handle various cases, resulting in a dangerous
> follow_pte() (previously follow_pfn()) usage.
> 
> (1) We're not checking PTE write permissions.
> 
> Maybe we should simply always require pte_write() like we do for
> pin_user_pages_fast(FOLL_WRITE)? Hard to tell, so let's check for
> ACRN_MEM_ACCESS_WRITE for now.
> 
> (2) We're not rejecting refcounted pages.
> 
> As we are not using MMU notifiers, messing with refcounted pages is
> dangerous and can result in use-after-free. Let's make sure to reject them.
> 
> (3) We are only looking at the first PTE of a bigger range.
> 
> We only lookup a single PTE, but memmap->len may span a larger area.
> Let's loop over all involved PTEs and make sure the PFN range is
> actually contiguous. Reject everything else: it couldn't have worked
> either way, and rather made use access PFNs we shouldn't be accessing.
> 

This all sounds rather nasty and the maintainers of this driver may
choose to turn your fixes into something suitable for current mainline
and for -stable backporting.

If they choose to do this then please just go ahead.  Once such a
change appear in linux-next the mm-unstable patch "virt: acrn: stop
using follow_pfn" will start generating rejects, which will be easy
enough to handle.  Of they may choose to incorporate that change at the
same time.  Here it is:


From: Christoph Hellwig <hch@lst.de>
Subject: virt: acrn: stop using follow_pfn
Date: Mon, 25 Mar 2024 07:45:40 +0800

Switch from follow_pfn to follow_pte so that we can get rid of follow_pfn.
Note that this doesn't fix any of the pre-existing raciness and lack of
permission checking in the code.

Link: https://lkml.kernel.org/r/20240324234542.2038726-1-hch@lst.de
Link: https://lkml.kernel.org/r/20240324234542.2038726-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fei Li <fei1.li@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virt/acrn/mm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/virt/acrn/mm.c~virt-acrn-stop-using-follow_pfn
+++ a/drivers/virt/acrn/mm.c
@@ -172,18 +172,24 @@ int acrn_vm_ram_map(struct acrn_vm *vm,
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, memmap->vma_base);
 	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
+		spinlock_t *ptl;
+		pte_t *ptep;
+
 		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
 			mmap_read_unlock(current->mm);
 			return -EINVAL;
 		}
 
-		ret = follow_pfn(vma, memmap->vma_base, &pfn);
-		mmap_read_unlock(current->mm);
+		ret = follow_pte(vma->vm_mm, memmap->vma_base, &ptep, &ptl);
 		if (ret < 0) {
+			mmap_read_unlock(current->mm);
 			dev_dbg(acrn_dev.this_device,
 				"Failed to lookup PFN at VMA:%pK.\n", (void *)memmap->vma_base);
 			return ret;
 		}
+		pfn = pte_pfn(ptep_get(ptep));
+		pte_unmap_unlock(ptep, ptl);
+		mmap_read_unlock(current->mm);
 
 		return acrn_mm_region_add(vm, memmap->user_vm_pa,
 			 PFN_PHYS(pfn), memmap->len,
_


