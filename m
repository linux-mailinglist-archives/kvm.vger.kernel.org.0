Return-Path: <kvm+bounces-11527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 530EE877E43
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 11:41:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FAFA2825B6
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FCB237152;
	Mon, 11 Mar 2024 10:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dTdLh+72"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E5B107A6
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 10:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710153685; cv=none; b=OWoNrdoHGwKNvXE32Gw2nSF0lLUPD1HA0l1DhdrpqEq1RhTIfvP7hB6FbVgt2relkffaBhvYqUsLWed9Zfw8tBRcFdllHZqQMfdg2mVwUePSlEoijuBwUOCPJMYzcpU3GGQzH4J/SlPWVrQJQ5qYTZEODRIChZMJkeUrmrL4QBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710153685; c=relaxed/simple;
	bh=VTGePlolWvh8S4NqPXK9BBV92SOpRu4OoKWoG1yn3ek=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=p1tT8Aj/Ln/Q5os+e68ME8QBqksWzSza4HbrnXZ62vYIYYnheMQLXM0DdmQxhcIEsCALjlfDKCGAM0MDCt6YEINgpur2w2CoRorOtiQm1495YLh3cKqmTQd5B1p6AzNgINFZ/Ae7Aqd31vBEIgKIP1hz6Y2rBfBNUGB8sVC3veQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dTdLh+72; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710153683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VVkpuwY1biHZ0fAuIHhuPfEr24Y3pYms+JbF58Zwxxo=;
	b=dTdLh+72jBCRSafKQaevXEm+330Vt7CemVvO+eR4dSwZZ+BTYXc94wuC19kwPla6oOkLu6
	diBtk/vfxRaXCF9c21ihE47qVlAkhLQfAOwqpvhKRWQm1N++CtyC4STr5HyI5bMsi8JEFF
	MmBgXlSxbMz2Vm6wzZ598DO+twslIc8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-5TpMKkR7NRqbkkzNi6WAbw-1; Mon,
 11 Mar 2024 06:41:19 -0400
X-MC-Unique: 5TpMKkR7NRqbkkzNi6WAbw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CE4E1C02D26;
	Mon, 11 Mar 2024 10:41:19 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32AF640C6CB7;
	Mon, 11 Mar 2024 10:41:19 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 31B041801A82; Mon, 11 Mar 2024 11:41:18 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: kvm@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 0/2] kvm/cpuid: set proper GuestPhysBits in CPUID.0x80000008
Date: Mon, 11 Mar 2024 11:41:15 +0100
Message-ID: <20240311104118.284054-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Use the GuestPhysBits field (EAX[23:16]) to communicate the max
addressable GPA to the guest.  Typically this is identical to the max
effective GPA, except in case the CPU supports MAXPHYADDR > 48 but does
not support 5-level TDP.

See commit messages and source code comments for details.

Gerd Hoffmann (2):
  kvm/cpuid: remove GuestPhysBits code.
  kvm/cpuid: set proper GuestPhysBits in CPUID.0x80000008

 arch/x86/kvm/mmu.h     |  2 ++
 arch/x86/kvm/cpuid.c   | 53 ++++++++++++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu.c |  5 ++++
 3 files changed, 45 insertions(+), 15 deletions(-)

-- 
2.44.0


