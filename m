Return-Path: <kvm+bounces-39646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F278EA48C60
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 00:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF92A3A5CA0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFD327004B;
	Thu, 27 Feb 2025 23:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="GVohF+p1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E644523E34E
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 23:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740697603; cv=none; b=DUONcufZE9z2XtJdV5K3PN+pRsVDMYnnHLrCY48QAwljoGOLBFwt8ddd1VNvAvkja+S+2SiVnO8bOgJmP5lubNcGhc0m4JttTPYTIiCWyhjfYOyLPti+mxLTVmvK6Ct83xE7XcbP9YqrDaES8ic4U7I/pW/JPwQQPmw6l8Y0H/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740697603; c=relaxed/simple;
	bh=M28d4+Wn7pr/hD0gXlLLrtjzlf+hK02uNl/W1aSC+wo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TA1fwHGKsEDdlFM1Nv32do6ZLyGFBReCkKX9drB2TSBHwYI9Sr1JvH+t8ybJJv5qf99U3YUX4be2kFusLcGciG3nby92QUjWsWiA7dz7pzmSeI2ss7N7qBT7bfr5OSntCjBMsnBrDLOr95KNp7Z9vNJDEejnnBaMw0+XdAYYmuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=GVohF+p1; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51RMbZNU014138
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 15:06:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=HqRep5xI0C9GawO3oU
	Mn2yN3ElbHzZEQr5gFyAhMwnc=; b=GVohF+p1gh9NygR5fWp39unx3JUoOYgvtO
	OlzJXk7oCetB2LyHBB5Ic1p+J3fkjCpeveSFmePt71pSq9Q0O9GB4CVQwe+27AfM
	cBxQBm+SUQ62my0XIHo+mlH2r8Rn2D0bByUnRM+6CZFLY6LYill5ap5tA+V7Lksp
	iXFk6cwGDvgI/hLCJkNIXU6RurTgSrK3TPB+AdbdkAIdeqTUI5gipDNAlCu0kiSd
	ZHuCdEDHCRnnX/05Z4pFixQ0HuKL9r8T7zfefXjsTCHX9LjON4Ah0qacgP0iqmft
	VNfwA9MxcldIg2Y/dEwBRcgzo68/XyPmj9KC8EoC6eiW7ecBTVNA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4530vs884u-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 15:06:39 -0800 (PST)
Received: from twshared9216.15.frc2.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 27 Feb 2025 23:06:29 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 947F418885337; Thu, 27 Feb 2025 15:06:31 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <leiyang@redhat.com>, <virtualization@lists.linux.dev>, <x86@kernel.org>,
        <netdev@vger.kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 0/2] 
Date: Thu, 27 Feb 2025 15:06:29 -0800
Message-ID: <20250227230631.303431-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Q0Lu8AlDnYodlI4luZBAHLTnc6WRDfFX
X-Proofpoint-ORIG-GUID: Q0Lu8AlDnYodlI4luZBAHLTnc6WRDfFX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_08,2025-02-27_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

changes from v2:

  Fixed up the logical error in vhost on the new failure criteria

Keith Busch (1):
  vhost: return task creation error instead of NULL

Sean Christopherson (1):
  kvm: retry nx_huge_page_recovery_thread creation

 arch/x86/kvm/mmu/mmu.c    | 12 +++++-------
 drivers/vhost/vhost.c     |  2 +-
 include/linux/call_once.h | 16 +++++++++++-----
 kernel/vhost_task.c       |  4 ++--
 4 files changed, 19 insertions(+), 15 deletions(-)

--=20
2.43.5


