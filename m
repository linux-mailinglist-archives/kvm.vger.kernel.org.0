Return-Path: <kvm+bounces-12588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F7488A9A1
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:39:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A184F1F3F880
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 16:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D0714BFA6;
	Mon, 25 Mar 2024 14:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PDXOmLm2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DB113C8FA
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711378057; cv=none; b=nK+0N4NOlf4HoqEopY56+X34RrD1Znsub3K0INnDrpx0Li//J8D3R6IrbCo+iUs/Eqn/18phVghpHT76+pMPb9sru6K5tFBpA78DodNrpdLDVxvMRoRClRJfCpL+p95eX2DP4WaSsVod85qiowQyzTOb6FJhE/wBZWhgFtxdgvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711378057; c=relaxed/simple;
	bh=VeNdlVb4i3e7ruc0NFCHazp7QyK4GNoRPPiqyA19OKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=beBclq3bRwIWocIqN98R6OUOoCGom0pScLNg0c8KYE7WOtPdgzlx0yaEQXmTjFTgjsqR22oPJybnlVqOGtCftpM7tNdBRl4W562/6adZxauGxJ4KZhzYZwjKXFZKzn6OWxr2nu01LqueFnAEUZF/kBw5hP8+azHgf/schdDiFgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PDXOmLm2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711378054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WM1+IU0xNyrYhER5wVdwgTjr8eQSLSe1Sd7ZFSpQIc4=;
	b=PDXOmLm2Sw2h6VMLtzB+DUoMN9yjl666+Q6rpumBC5l8gXiABfSe57K9RXFVraVzt2sV3C
	nQbYRj6DI78z0cVo88GeYDH6X+6EXLKNyMhuGVMpvncGHhBg70oFqKffQnOW2PRyTwx/LX
	CDnkAU6DlaZbWgwNOAvbxoCJU3w/juA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-BdP2kmpgNAa2m7Afp3y_wA-1; Mon,
 25 Mar 2024 10:47:31 -0400
X-MC-Unique: BdP2kmpgNAa2m7Afp3y_wA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C79C11C004E8;
	Mon, 25 Mar 2024 14:47:30 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.158])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67EB8492BC4;
	Mon, 25 Mar 2024 14:47:30 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 2BB961801497; Mon, 25 Mar 2024 15:47:25 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v5 0/2] kvm: add support for guest physical bits
Date: Mon, 25 Mar 2024 15:47:22 +0100
Message-ID: <20240325144725.1089192-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

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


