Return-Path: <kvm+bounces-20306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 743AE912DF3
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 21:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2893A1F22C86
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 19:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF9B17BB02;
	Fri, 21 Jun 2024 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="l+/JC+M+"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E8784A32;
	Fri, 21 Jun 2024 19:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718998661; cv=none; b=gvzOMUMUndBd7PqP4grd0gZfQa7wJL4dORS5cAtdULsudwsiHjntGahaOJGp6okWe1esMem3Tuk04Omr4WeySAvoGCFqs1kU0zMNzsDwf+1fILvBZiQQrOV9UfiLICAl3T3tHgEDrvE5yKHH8YSOsOsQ4RJ0TMDGB0QRV5WWEzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718998661; c=relaxed/simple;
	bh=sTdM4/wJgWIz32F7RmoaSOOm13k88VVlhyEn7r2d0Pk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gcwyexyiycdvv6m7D4BMhZT//AFoRJZJnam9HpzWLT67wPcS0LiKCXCjhPZf9HKzHHrkpaJsCrmimTzrFV8aMU68YKqfbVYr3arYU2QjLGdUGiFDrm7hoKH9wld+QVUkcVOYpumIlYNHjAjabnE2Cn7Q7+WW1BbGh1vEn1ORY98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=l+/JC+M+; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 89995120009;
	Fri, 21 Jun 2024 22:37:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 89995120009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1718998648;
	bh=QEP9tVC7IJrIs6z3JIp7IhpStzLXbWBfPUokHOf8CCA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=l+/JC+M+jZzqnwL+juNzZitz2gGjfw5LAFeeDM2jHB924rP5Eh862bY8M6h7XBOOB
	 0I/q2tVCGPlTGtGCvfVSwYqBI5foWAJRVivlXy0WSghii9j4dvVjdI6R48xfUKdoGV
	 +mJ1IlapX5cU1E/333GBoZUb66rOtxTBWsJOjAT6xkROUzJh0LPH3EWN6yb0femwBU
	 S6rdwCh7cO4vuzWB4fEufMBp0Qe3LNJEagOAMN026pBDpTe2PpbovWjrn9wN/Uuk32
	 GIP7w8CMSrpHd76YSr13mQZc3Q9nIO4dp7ssNCF9ZvIoVLLoZPj4NColmeguCDFKgZ
	 StGZW9G2xvSOw==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 21 Jun 2024 22:37:28 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 21 Jun 2024 22:37:27 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [RFC PATCH v1 0/2] virtio/vsock: some updates for deferred credit update
Date: Fri, 21 Jun 2024 22:25:39 +0300
Message-ID: <20240621192541.2082657-1-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186064 [Jun 21 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 20 0.3.20 743589a8af6ec90b529f2124c2bbfc3ce1d2f20f, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;smtp.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/06/21 16:35:00 #25651590
X-KSMG-AntiVirus-Status: Clean, skipped

This patchset contains:
0001 - patch which reworks deferred credit update. Pls see commit message,
       it contains full description of this problem.

0002 - test which uses vsockmon interface, and checks that deferred
       credit update works as expected by parsing raw packets.

Arseniy Krasnov (2):
  virtio/vsock: rework deferred credit update logic
  vsock/test: add test for deferred credit update

 include/linux/virtio_vsock.h            |   1 +
 net/vmw_vsock/virtio_transport_common.c |   8 +-
 tools/testing/vsock/.gitignore          |   1 +
 tools/testing/vsock/Makefile            |   2 +
 tools/testing/vsock/virtio_vsock_test.c | 369 ++++++++++++++++++++++++
 5 files changed, 376 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/vsock/virtio_vsock_test.c

-- 
2.25.1


