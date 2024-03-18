Return-Path: <kvm+bounces-11990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6CF87ECB8
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:54:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C4181F214D7
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 15:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63267535D2;
	Mon, 18 Mar 2024 15:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g8EPvD/z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CC4535C1
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 15:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710777227; cv=none; b=Mx3j+3nhYzsXJqEM0ATVvcIeSzqWkLx4k6hwUteAR4hcbVGn2uZG6UOrQZxkHYnxkL4tA+rdeld+xcqHXnLA1AvpPEgPaJ8NGeBwCgZCvXiXGC7Ltpb5qXCIaa+fgJR9DaxxS+fi1jHUC428+69yAzvzBM7m6UUAMnDsccC9Jng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710777227; c=relaxed/simple;
	bh=VeNdlVb4i3e7ruc0NFCHazp7QyK4GNoRPPiqyA19OKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QABPXRPUgC4bJg3luuEFwkBI1NMxdmb8EOW1YHqrk8KON7dGUijQMPiXTTCTYA9/5poOc1ghxwYzUreH4G4OucIS+/+QuwBbuORpxtLQ1vnNO1CoWk+o2TiyK4mPwC+zEaEFI3QhT6hR1u6YJUDl1MTPJ+iHK/rY3TJeiASfsI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g8EPvD/z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710777224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WM1+IU0xNyrYhER5wVdwgTjr8eQSLSe1Sd7ZFSpQIc4=;
	b=g8EPvD/zXqdt6NEGVAQ6XO9Ed1QIANLR95uFd6EI9gKUFZmvkhGXpVErKLhz/2RQkT3V2d
	d8qhxU7aHOxIg+Uo5JUYqW9TJTJemloWTDt6FeQgtVWE4jnjE7Nnl2KsCZbS4B10Y7dS/I
	+MPmvTmH304bVvpDmh5hXrbRCWKN9KY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-d4fQ15GcPKmfSSTQZQEFiw-1; Mon, 18 Mar 2024 11:53:42 -0400
X-MC-Unique: d4fQ15GcPKmfSSTQZQEFiw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 014C7101AA62;
	Mon, 18 Mar 2024 15:53:42 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.254])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A3982166B32;
	Mon, 18 Mar 2024 15:53:41 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 7FAA31800D54; Mon, 18 Mar 2024 16:53:36 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v4 0/2] kvm: add support for guest physical bits
Date: Mon, 18 Mar 2024 16:53:34 +0100
Message-ID: <20240318155336.156197-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

The matching kernel bits are here:
https://lore.kernel.org/kvm/20240313125844.912415-1-kraxel@redhat.com/T/

ovmf test patches are here:
https://github.com/kraxel/edk2/commits/devel/guest-phys-bits/

Gerd Hoffmann (2):
  kvm: add support for guest physical bits
  target/i386: add guest-phys-bits cpu property

 target/i386/cpu.h         |  1 +
 target/i386/cpu.c         | 14 ++++++++++++++
 target/i386/kvm/kvm-cpu.c | 31 ++++++++++++++++++++++++++++++-
 3 files changed, 45 insertions(+), 1 deletion(-)

-- 
2.44.0


