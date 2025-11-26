Return-Path: <kvm+bounces-64661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0EF0C8A0FE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 14:38:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D45D3AFE74
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 13:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623BD328B69;
	Wed, 26 Nov 2025 13:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJdOM6DG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BWNegSZC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1CA2F6578
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764164316; cv=none; b=nDN73AiAZCKwScaZb+JW07isMQ9Y2U04VXgNbWBpMSm0tePm3DnJ67KKprFzipUxP9s3hshnHKWtEnEG8P3q58K7jGesiyGMCnrMc9zOiFilYFRTwccJZvQrBHmg76HIJc2UkB25Ex5rFby8TwyPV9CMbmaRhAzAdHVZDKBKvto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764164316; c=relaxed/simple;
	bh=qVWDhyzeG/Z8JL3F0OP9m69Cq46/dVVMczXqz8KQbOw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cuyvaSLuaH9X+5DwW/+c0fnypHs/z5vKyGFlGyfsjaSUAYXTN41TgJ81j9SNttmLjsYBO/dVP+uvSbAJCNxcF3xI6bevGlYXBy/t+BFBFFLB5toUQoYPzc535TAqx8IOZqR8NFS37qeRgZWl/Xct1A0G29C6/fqW468jCMcw1ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJdOM6DG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BWNegSZC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764164313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Mhs6sooJ56Q3btp7R+WL1sLMwD4EfCJBflvbYxzesYo=;
	b=cJdOM6DGJ5FpTHMRr/l9xEAjdJpX2RiRagA37jjr7fO1RfyGOhAMQqp0yylzUmhhq/FT7G
	rgdmPbmPS83H1vFsH0tvND9j5HPHpx/Oq1sR1vf9WXMIF3fOVrdsUz+S6yOjVSfh8J8CSU
	sAjY5LrQ0PhRscJ7wwblgtU5o3bqqn0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-_ABMGrElPkm7UFHD3J8_og-1; Wed, 26 Nov 2025 08:38:31 -0500
X-MC-Unique: _ABMGrElPkm7UFHD3J8_og-1
X-Mimecast-MFC-AGG-ID: _ABMGrElPkm7UFHD3J8_og_1764164311
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-640cdaf43aeso6890819a12.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 05:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764164310; x=1764769110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mhs6sooJ56Q3btp7R+WL1sLMwD4EfCJBflvbYxzesYo=;
        b=BWNegSZCjvVnxBuohBOpTKo1i7A71//bLcAANQcZSGqNkcfDXOTK7H8IxJxPPnzCy4
         Dzj46okhhDfWt/aThc9CTXmMskdsa3Vy2ndIaAkJbF53lIMyKFfCNVGVF32WtqIevz3Y
         mlKtJcP/YL9Zl8N6cwfwuOfqGN5sgzVJp2rk5EZtk2KT6slMwxa1Vp/vxxxKh2x50oL5
         iKp8zkcmU9bLqiw63PYQBuTLuST8yyYbuojKabdW2AiTbNKeJsbckQuZT+lxUldpBHUQ
         QwQrUmYWNO5F2rDwiD1Wl49Df0LAF3HPtA3ebGAtvk3gsZH0Iu2+p+WYeG+xH5eUTYL/
         bUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764164310; x=1764769110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mhs6sooJ56Q3btp7R+WL1sLMwD4EfCJBflvbYxzesYo=;
        b=QiQH1hMEovzIOe33RmJhH7gMPPqrkomAFS6DQE5EXsmjBeWD5COWj4dSNKphJOejtQ
         VP0nc0kL0ofrNNRA81BHCPV5h87+8ihjm2uvRMgVoTY6vSP/dQeZMpXhK20gjSCyJ5nN
         ckjD5GKe319oBnSUsT8J1Z21F2gOKruLHMOcZ6P9OS8hu/8AhEG/hHPmOfVWF+tUEHU4
         w0EN1ZLW33TeiE3SINqFO9DzQON678AoEPQREwnEbpEFs5hrHO2PUZYAWzafeLfYkMUg
         U+8g6x1ki3K4JealNcfgqCKob7eFUlMkAPKeQ2iqcX3y9thnWXm2angK/lCs+z4TXA4E
         wNow==
X-Forwarded-Encrypted: i=1; AJvYcCUmgCbCQWlsyBeZPIc/Mqo5PH9ekRuXr5V90Z3HR7/088YxW3EcO1Wx68UIrSX6XDisXY8=@vger.kernel.org
X-Gm-Message-State: AOJu0YytbxGm2kS/SMny8rScNw3WSDW5FTtxfOR6ZDJTCHS0pYharjFT
	bj6z+5KmqPwdtLOVmgzQOhNX+TwIdF2nYX4WtIvamSgsjZKZIU+SsJA3wP1prrxWrCEO1SqEENu
	MJglU+jKDcvvEcj/J+PnY5IpNdCmJ8lFLDFqwp7rcRVim9Iudw2+IL21EtDUGkg==
X-Gm-Gg: ASbGncvnZLSCXFDYVvfRf2SWfF9OPk6DShKcPkgHDv2pXDXefEof3u30FVG4b/M8Dkw
	cizOcYbv97FIEW4Krx1+VVf2h9T6Skukevw3TKQRZlA9/2DIWX2edlDErfBu0YvIeHOgrmauzYj
	Mh4Nv8cx/73+mADhc03VPr8EQSbtJBVjCpqI7cC1CQAfFYBd/DZKGacCxD1Yki9xbJ1LyGUiTER
	WsgzB6HA81jU4+pkVc1j/w5y9TJsgt17i34mesf2cli9UcLZVtdxgAp9LTwcHuh/yXjm6qYkArJ
	39pgBHcSyLt2RJ5RGu4jeJk7Sa0/DdTAuHGvV7Cm2G1RJgXQnmmelKZLTQdJJJnXDfLkqzxiekJ
	acGmLARa0pSu6QtjLSxIMxU0Ydc0iHITO0gzVPPspuLLrPH/T
X-Received: by 2002:a05:6402:3489:b0:63c:4da1:9a10 with SMTP id 4fb4d7f45d1cf-645546a3c05mr16378918a12.31.1764164310128;
        Wed, 26 Nov 2025 05:38:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHmZrPvuLqorBQCW4M+q1Ph2pYbinZMaUldcA+WNpMkTP4ojfgz3kplNRhWLiwfo17xPIT7cg==
X-Received: by 2002:a05:6402:3489:b0:63c:4da1:9a10 with SMTP id 4fb4d7f45d1cf-645546a3c05mr16378881a12.31.1764164309584;
        Wed, 26 Nov 2025 05:38:29 -0800 (PST)
Received: from stex1 (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6453642d267sm17573469a12.22.2025.11.26.05.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 05:38:28 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: virtualization@lists.linux.dev
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	netdev@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vhost/vsock: improve RCU read sections around vhost_vsock_get()
Date: Wed, 26 Nov 2025 14:38:26 +0100
Message-ID: <20251126133826.142496-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefano Garzarella <sgarzare@redhat.com>

vhost_vsock_get() uses hash_for_each_possible_rcu() to find the
`vhost_vsock` associated with the `guest_cid`. hash_for_each_possible_rcu()
should only be called within an RCU read section, as mentioned in the
following comment in include/linux/rculist.h:

/**
 * hlist_for_each_entry_rcu - iterate over rcu list of given type
 * @pos:	the type * to use as a loop cursor.
 * @head:	the head for your list.
 * @member:	the name of the hlist_node within the struct.
 * @cond:	optional lockdep expression if called from non-RCU protection.
 *
 * This list-traversal primitive may safely run concurrently with
 * the _rcu list-mutation primitives such as hlist_add_head_rcu()
 * as long as the traversal is guarded by rcu_read_lock().
 */

Currently, all calls to vhost_vsock_get() are between rcu_read_lock()
and rcu_read_unlock() except for calls in vhost_vsock_set_cid() and
vhost_vsock_reset_orphans(). In both cases, the current code is safe,
but we can make improvements to make it more robust.

About vhost_vsock_set_cid(), when building the kernel with
CONFIG_PROVE_RCU_LIST enabled, we get the following RCU warning when the
user space issues `ioctl(dev, VHOST_VSOCK_SET_GUEST_CID, ...)` :

  WARNING: suspicious RCU usage
  6.18.0-rc7 #62 Not tainted
  -----------------------------
  drivers/vhost/vsock.c:74 RCU-list traversed in non-reader section!!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by rpc-libvirtd/3443:
   #0: ffffffffc05032a8 (vhost_vsock_mutex){+.+.}-{4:4}, at: vhost_vsock_dev_ioctl+0x2ff/0x530 [vhost_vsock]

  stack backtrace:
  CPU: 2 UID: 0 PID: 3443 Comm: rpc-libvirtd Not tainted 6.18.0-rc7 #62 PREEMPT(none)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-7.fc42 06/10/2025
  Call Trace:
   <TASK>
   dump_stack_lvl+0x75/0xb0
   dump_stack+0x14/0x1a
   lockdep_rcu_suspicious.cold+0x4e/0x97
   vhost_vsock_get+0x8f/0xa0 [vhost_vsock]
   vhost_vsock_dev_ioctl+0x307/0x530 [vhost_vsock]
   __x64_sys_ioctl+0x4f2/0xa00
   x64_sys_call+0xed0/0x1da0
   do_syscall_64+0x73/0xfa0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   ...
   </TASK>

This is not a real problem, because the vhost_vsock_get() caller, i.e.
vhost_vsock_set_cid(), holds the `vhost_vsock_mutex` used by the hash
table writers. Anyway, to prevent that warning, add lockdep_is_held()
condition to hash_for_each_possible_rcu() to verify that either the
caller is in an RCU read section or `vhost_vsock_mutex` is held when
CONFIG_PROVE_RCU_LIST is enabled; and also clarify the comment for
vhost_vsock_get() to better describe the locking requirements and the
scope of the returned pointer validity.

About vhost_vsock_reset_orphans(), currently this function is only
called via vsock_for_each_connected_socket(), which holds the
`vsock_table_lock` spinlock (which is also an RCU read-side critical
section). However, add an explicit RCU read lock there to make the code
more robust and explicit about the RCU requirements, and to prevent
issues if the calling context changes in the future or if
vhost_vsock_reset_orphans() is called from other contexts.

Fixes: 834e772c8db0 ("vhost/vsock: fix use-after-free in network stack callers")
Cc: stefanha@redhat.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index ae01457ea2cd..78cc66fbb3dd 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -64,14 +64,15 @@ static u32 vhost_transport_get_local_cid(void)
 	return VHOST_VSOCK_DEFAULT_HOST_CID;
 }
 
-/* Callers that dereference the return value must hold vhost_vsock_mutex or the
- * RCU read lock.
+/* Callers must be in an RCU read section or hold the vhost_vsock_mutex.
+ * The return value can only be dereferenced while within the section.
  */
 static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
 {
 	struct vhost_vsock *vsock;
 
-	hash_for_each_possible_rcu(vhost_vsock_hash, vsock, hash, guest_cid) {
+	hash_for_each_possible_rcu(vhost_vsock_hash, vsock, hash, guest_cid,
+				   lockdep_is_held(&vhost_vsock_mutex)) {
 		u32 other_cid = vsock->guest_cid;
 
 		/* Skip instances that have no CID yet */
@@ -707,9 +708,15 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 	 * executing.
 	 */
 
+	rcu_read_lock();
+
 	/* If the peer is still valid, no need to reset connection */
-	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
+	if (vhost_vsock_get(vsk->remote_addr.svm_cid)) {
+		rcu_read_unlock();
 		return;
+	}
+
+	rcu_read_unlock();
 
 	/* If the close timeout is pending, let it expire.  This avoids races
 	 * with the timeout callback.
-- 
2.51.1


