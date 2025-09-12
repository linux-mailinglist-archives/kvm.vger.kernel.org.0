Return-Path: <kvm+bounces-57365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0E2B543F9
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 09:34:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2E8204E15E3
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 07:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290832C2369;
	Fri, 12 Sep 2025 07:34:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6BA25F96D
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 07:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757662454; cv=none; b=c+hf3i9VUocJoSGDc66yZOMGoG+qAcAIpRrDykia6/Cct54Wn7al/GDXL0iB0zlANJocPHRa1uU2TrIJjLSibsNGVNti8z6NLq+IR+EX7eIe7o0AeYhKEpeMKv7SUTjPo9gmeO/e/1Z8zrrBRXwXSD8IUeIiNtm5c+ENHTF/lzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757662454; c=relaxed/simple;
	bh=QpWLKBe0dAsw2cpDNFEzC2BDvmUf0cls2aPYrgkWR1s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GYeek88BMTpcpMANLzO/lvLM9YVoC6gkVRNFIxxDtoJVtKWBFfAHTb6QKrIsELzT1Qa1IdHanCAfYMpvzEu5iYkVnZkqvJbHmo6aP9g/vUimPg2qrydWozujdPkKCG9VSQF5s2GjqhESHNv8+8OsZ0Aol/AkiRWwtQzR3f1F5Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A369D16A3;
	Fri, 12 Sep 2025 00:34:03 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.4.234])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4AC593F63F;
	Fri, 12 Sep 2025 00:34:10 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: kvm@vger.kernel.org,
	Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH kvmtool] net/uip: Avoid deadlock in uip_tcp_socket_free()
Date: Fri, 12 Sep 2025 08:33:57 +0100
Message-ID: <20250912073357.43316-1-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function uip_tcp_socket_free() is called with the sk lock held, but
then goes on to call uip_tcp_socket_close() which attempts to aquire the
lock a second time, triggering a deadlock if there are outstanding TCP
connections.

Rather than call uip_tcp_socket_close(), just do the cleanup directly in
uip_tcp_socket_free().

Fixes: d87b503f4d6e ("net/uip: Add exit function")
Signed-off-by: Steven Price <steven.price@arm.com>
---
 net/uip/tcp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/uip/tcp.c b/net/uip/tcp.c
index 8e0ad5235240..2a6a8f5265d9 100644
--- a/net/uip/tcp.c
+++ b/net/uip/tcp.c
@@ -109,8 +109,12 @@ static void uip_tcp_socket_free(struct uip_tcp_socket *sk)
 		pthread_join(sk->thread, NULL);
 	}
 
-	sk->write_done = sk->read_done = 1;
-	uip_tcp_socket_close(sk, SHUT_RDWR);
+	shutdown(sk->fd, SHUT_RDWR);
+	close(sk->fd);
+	list_del(&sk->list);
+
+	free(sk->buf);
+	free(sk);
 }
 
 static int uip_tcp_payload_send(struct uip_tcp_socket *sk, u8 flag, u16 payload_len)
-- 
2.43.0


