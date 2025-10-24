Return-Path: <kvm+bounces-61081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E022DC08586
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 01:44:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8B60D355542
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 23:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A3030E853;
	Fri, 24 Oct 2025 23:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="KXBDUYoT"
X-Original-To: kvm@vger.kernel.org
Received: from r3-17.sinamail.sina.com.cn (r3-17.sinamail.sina.com.cn [202.108.3.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8C8303C86
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 23:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761349488; cv=none; b=mxldErL2Lup6lP6kc9DsMZ7anFetci645/FodJEx9iivir1C1s3CBwVvYY7poqka2t3lkl6K1edplm4yfZRYKpfAe2iXLJIotlh0V7kh6cJzBA1wmAinCS8clJMNZUr3AlKZyQpi3GGaPGmiVaysBlxsHi7wkTsSOlTmOVeIESE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761349488; c=relaxed/simple;
	bh=+HwySPOLzZkjbWIuZ/CLZqnVGlvCqx64TKi3BoQhzkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqyyR6+cy8GDbo3oIEWdpgvwzeeDRHfwFHijFbe/ty4ayD69Og/XyBJ2earBKoD4fxeZjRFdkkigoWWS50OzzeYPgQGys2zw52FXAvq/NzmelSKLAYnbPNZABLMWxsJDN+tc5dcVUZHFZcD7ya1U9E1MuPuRHVJrPWy3xy7+CEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=KXBDUYoT; arc=none smtp.client-ip=202.108.3.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1761349483;
	bh=bG18YqAyheR8FAmAtsnw1Hx7+tojOHAi/Jxsv0Yhpwo=;
	h=From:Subject:Date:Message-ID;
	b=KXBDUYoTarUQrxyw0ieYLIUBm0l658OeMsd4Y1XG5bncjtaQndSJlz7xOBZb9tin1
	 FKPTPHmzDSalhkK0jNZg6+N1XOvBrv8Vsxt4CfBJzIum6GqXWj4q6oVvePlyI27gzk
	 9d/PZNuFyB+mh3aWxymT2PS0EFO9Se/YSGH+OidQ=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.34) with ESMTP
	id 68FC0F4100004C72; Fri, 25 Oct 2025 07:44:04 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 3966296291935
X-SMAIL-UIID: FDCEACB35A5243D5AD8A5D0593E870BB-20251025-074404-1
From: Hillf Danton <hdanton@sina.com>
To: syzbot <syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	tabba@google.com,
	xiaoyao.li@intel.com
Subject: Re: [syzbot] [kvm?] KASAN: slab-use-after-free Write in kvm_gmem_release
Date: Sat, 25 Oct 2025 07:43:51 +0800
Message-ID: <20251024234353.8746-1-hdanton@sina.com>
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
--

