Return-Path: <kvm+bounces-11729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1253987A7F0
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 13:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5A171F24571
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 12:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C21C33E48C;
	Wed, 13 Mar 2024 12:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bCIB4KbM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9564521111
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 12:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710334730; cv=none; b=kfGyAWyX42SnB+Q+9p2XX1ScT5yZb/J8lsK4WgSfn3Gwn4OCAvXYgRTz1kZ6Mo1r3xvrozrYiXXT3imsK8eSQZDXs+6/epFnpWRWnTgGaMca5Uhf9FsUPixWdZagp+jR+4MGUsHXBRLPGqdEKe1FJJpxdKE5Ens4exvUMpv7vVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710334730; c=relaxed/simple;
	bh=GCL8XXu3H623XB9YSuRnVNFWtS1HVoP7Hz77du+IkeU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Avwj+CTsG7KAYlxB06Rv7CkK3s/CbVvaGQ7/PLot3Oxc0Lk3GvS0AvejDED4DWq0UEwxugfNGYNuOAssfiQRc5/4qwJofDtCdLVyXuV2dfTUQlCF2eiV99CHD+wAggwBqTqS/4Mol71/0MJ9wa/nRKzqmwsewpGraxvve7eOd18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bCIB4KbM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710334727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nChyVl/fuZdL4IJAIgr7ddK08XEDD5pjsyErbGD8ahA=;
	b=bCIB4KbMcgffKPcyxCwLZMzTqQQ3drd+3Z0nU1pm2w5OnJte4WhAwZ15sTGE0cxIGuYue7
	SVkBvKUKIdmdlHW7QCMZYyPxP+HLeWm41eHQ1afET/4LYJ/1IBdQ25Bub9NuOwFlNytzFE
	OsZ0ecJMbN7J8DLLZ6TtgXPgGV4g3nc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-XEm5suDeMlOLPIBMfystmQ-1; Wed,
 13 Mar 2024 08:58:46 -0400
X-MC-Unique: XEm5suDeMlOLPIBMfystmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 036B81C54064;
	Wed, 13 Mar 2024 12:58:46 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B2522166AE4;
	Wed, 13 Mar 2024 12:58:45 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 9A17818009A3; Wed, 13 Mar 2024 13:58:44 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: kvm@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v4 0/2] kvm/cpuid: set proper GuestPhysBits in CPUID.0x80000008
Date: Wed, 13 Mar 2024 13:58:41 +0100
Message-ID: <20240313125844.912415-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Use the GuestPhysBits field (EAX[23:16]) to communicate the max
addressable GPA to the guest.  Typically this is identical to the max
effective GPA, except in case the CPU supports MAXPHYADDR > 48 but does
not support 5-level TDP.

See commit messages and source code comments for details.

v4 changes:
 - comment fixups.
 - picked up reviewed-by tags,

Gerd Hoffmann (2):
  kvm/cpuid: remove GuestPhysBits code.
  kvm/cpuid: set proper GuestPhysBits in CPUID.0x80000008

 arch/x86/kvm/mmu.h     |  2 ++
 arch/x86/kvm/cpuid.c   | 41 +++++++++++++++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu.c |  5 +++++
 3 files changed, 38 insertions(+), 10 deletions(-)

-- 
2.44.0


