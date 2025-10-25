Return-Path: <kvm+bounces-61083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAC9C0885C
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 03:59:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E9CAD4E49C5
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 01:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819682288D5;
	Sat, 25 Oct 2025 01:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="FQB3bnab"
X-Original-To: kvm@vger.kernel.org
Received: from smtp153-163.sina.com.cn (smtp153-163.sina.com.cn [61.135.153.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8D02F4A
	for <kvm@vger.kernel.org>; Sat, 25 Oct 2025 01:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.135.153.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761357590; cv=none; b=qdhY3KslfLNT3kHa1Znvtu4NhEuTsqFus+OjV2RktVwHHu91Sq8/LXf7F+qv2YWk5KI1u7DDysUYq30RYTR0qb91FQRbdJjlUayQLjr9+fyqtmZDRYA+nJvUCR67iHL+jm471W9FcwW3OGPHiRZ4vTSLA7k40Yeqv18KX1e/DRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761357590; c=relaxed/simple;
	bh=qxghE+ooTTc14t+/aasFyp4H84R11hwsZ0dRdutw/tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T94JxVLBqygF2MT+M9yb26z9exkI/pfXFMOcA8R6+rFBpD/+Q7jfivSGGE2qgwabXH4GsZ9bbXYty+xXxkWQaX86uhx7i9zmH4393W9E1N8jLRwvsX0uAEw2veoaLJ9ko4l4DudyXQJmoAeJtYevFzQzjTW560w3aBAQoFto/Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=FQB3bnab; arc=none smtp.client-ip=61.135.153.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1761357583;
	bh=vM6Q9fe4sYgSQ+Os2WpFmDgco9sK+kyLxf0Wvs3QiUo=;
	h=From:Subject:Date:Message-ID;
	b=FQB3bnabW1snwgTIGs6nThR5/NTDCEIue+oi070CK20MIhJsDUcwwD/ZuM3wI1SEu
	 kFH05Dv1iWRDTjWOVDGS6xkFtaA8q/xU2yrb/dN0JDyxyWC02QFBf+tgXyXxpFRF2y
	 RqXq+UH1RHF5zDgdlHo+bfXnXDQopu1e7Xma4Ps0=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.32) with ESMTP
	id 68FC2EE4000008ED; Sat, 25 Oct 2025 09:59:04 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 8402664456770
X-SMAIL-UIID: F6EBC1A1F6A644E5B9FB15C559947401-20251025-095904-1
From: Hillf Danton <hdanton@sina.com>
To: syzbot <syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	tabba@google.com,
	xiaoyao.li@intel.com
Subject: Re: [syzbot] [kvm?] KASAN: slab-use-after-free Write in kvm_gmem_release
Date: Sat, 25 Oct 2025 09:58:44 +0800
Message-ID: <20251025015852.8771-1-hdanton@sina.com>
In-Reply-To: <68fb1966.050a0220.346f24.0093.GAE@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Oct 23, 2025, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit d1e54dd08f163a9021433020d16a8f8f70ddc41c
> Author: Fuad Tabba <tabba@google.com>
> Date:   Tue Jul 29 22:54:40 2025 +0000
> 
>     KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12a663cd980000
> start commit:   43e9ad0c55a3 Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=11a663cd980000
> console output: https://syzkaller.appspot.com/x/log.txt?x=16a663cd980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=67b63a24f3c26fca
> dashboard link: https://syzkaller.appspot.com/bug?extid=2479e53d0db9b32ae2aa
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173ecd2f980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14bc2be2580000

Test Sean's fix.

#syz test linux-next master 

--- x/virt/kvm/guest_memfd.c
+++ y/virt/kvm/guest_memfd.c
@@ -708,23 +708,11 @@ err:
 	return r;
 }
 
-void kvm_gmem_unbind(struct kvm_memory_slot *slot)
+static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct gmem_file *f)
 {
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
-	struct gmem_file *f;
-
-	/*
-	 * Nothing to do if the underlying file was already closed (or is being
-	 * closed right now), kvm_gmem_release() invalidates all bindings.
-	 */
-	CLASS(gmem_get_file, file)(slot);
-	if (!file)
-		return;
-
-	f = file->private_data;
 
-	filemap_invalidate_lock(file->f_mapping);
 	xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
 
 	/*
@@ -732,7 +720,36 @@ void kvm_gmem_unbind(struct kvm_memory_s
 	 * cannot see this memslot.
 	 */
 	WRITE_ONCE(slot->gmem.file, NULL);
-	filemap_invalidate_unlock(file->f_mapping);
+}
+
+void kvm_gmem_unbind(struct kvm_memory_slot *slot)
+{
+       /*
+        * Nothing to do if the underlying file was _already_ closed, as
+        * kvm_gmem_release() invalidates and nullifies all bindings.
+        */
+       if (!slot->gmem.file)
+               return;
+
+       CLASS(gmem_get_file, file)(slot);
+
+       /*
+        * However, if the file is _being_ closed, then the bindings need to be
+        * removed as kvm_gmem_release() might not run until after the memslot
+        * is freed.  Note, modifying the bindings is safe even though the file
+        * is dying as kvm_gmem_release() nullifies slot->gmem.file under
+        * slots_lock, and only puts its reference to KVM after destroying all
+        * bindings.  I.e. reaching this point means kvm_gmem_release() can't
+        * concurrently destroy the bindings or free the gmem_file.
+        */
+       if (!file) {
+               __kvm_gmem_unbind(slot, slot->gmem.file->private_data);
+               return;
+       }
+
+       filemap_invalidate_lock(file->f_mapping);
+       __kvm_gmem_unbind(slot, file->private_data);
+       filemap_invalidate_unlock(file->f_mapping);
 }
 
 /* Returns a locked folio on success.  */
--- x/kernel/printk/printk_ringbuffer.c
+++ y/kernel/printk/printk_ringbuffer.c
@@ -1286,7 +1286,7 @@ static const char *get_data(struct prb_d
 	}
 
 	/* A valid data block will always have at least an ID. */
-	if (WARN_ON_ONCE(*data_size < sizeof(db->id)))
+	if (*data_size < sizeof(db->id))
 		return NULL;
 
 	/* Subtract block ID space from size to reflect data size. */
--

