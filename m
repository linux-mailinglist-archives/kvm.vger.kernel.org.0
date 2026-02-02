Return-Path: <kvm+bounces-69859-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIF9G+C4gGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69859-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 15:46:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D8321CD908
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 15:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5484C300463E
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 14:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FCF4372B34;
	Mon,  2 Feb 2026 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OaDZDqKa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8C436F423;
	Mon,  2 Feb 2026 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043576; cv=none; b=cW8cZls4fuHa0edDshNwECvGgHda8P3J1gT/kwM+fptOQPj9k209XnHLlGS2cMIE0n4Lk4phSNzTwFRi+MlzL+4XG2/ebIZN7jy+9OFqfZK7CwIFZfTz+jT6tTNqH4DVfQJbMh3z5YppQYmnklMEIvEdYSZUP6Zq+fB21oF1E1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043576; c=relaxed/simple;
	bh=pgCy+AuXuiYhkjXoMXGBVeIPTNx1RfelmcKotLa6pe4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q19Pry6KibYEF8pxlIFrpbxoiz3zCidfIJpYaqPruusp8LAWSXbpUW/RdPqfLdCgtMJ1qyVmBOfepYi284tr+RiiphszJ0PFaFB6ONVCTPWHYz2P9Nm1D+jf/eOB/eGDbUqOKebQZvHWL67te3TcNr1jVW6EQIuyU4t0OCpmSy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OaDZDqKa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 611LjYP8001160;
	Mon, 2 Feb 2026 14:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=zatfqsRcy/TxR++YtMjFBcjEygPpHfI2DtgYQnt5D
	+8=; b=OaDZDqKa34JNtwYjZNXMZ8SosPmzADfyKKj8xTuTSnGYdD3QuFh72b851
	+9H949stt90cw3bbakcok9P2JRtgtR3qN+lo8W/EXzphBktgO4acyWLV7E/9YN/u
	7ONLk5oECA90BV3hUxweFN15apAqA+dgaCyBq/N/vnot/W5uPEglwU+k7aJppjh0
	3e3OzJyEGKi07pBb0ost5sz2qC7FQJ9D3R02xT76Y1EcKBXfd8Us9QOJI/Iuv3Gl
	56cwBLo18cGivfWD/SJry7xjynJ4rfF3WGsseLJIzz4KwobIcpjLEs3T3cNz8hgd
	535dYlvXyMGarv7vP7dHfSYgwQZGQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175mqjfc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 14:46:04 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 612E7b1O004428;
	Mon, 2 Feb 2026 14:46:04 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1wjjnc6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 14:46:04 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 612EjxvM49021420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Feb 2026 14:45:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C08ED2004B;
	Mon,  2 Feb 2026 14:45:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B141320043;
	Mon,  2 Feb 2026 14:45:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  2 Feb 2026 14:45:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
	id 87C30E0B7E; Mon, 02 Feb 2026 15:45:59 +0100 (CET)
From: Eric Farman <farman@linux.ibm.com>
To: Matthew Rosato <mjrosato@linux.ibm.com>, Farhan Ali <alifm@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH] MAINTAINERS: Replace backup for s390 vfio-pci
Date: Mon,  2 Feb 2026 15:45:57 +0100
Message-ID: <20260202144557.1771203-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L4Gpp0NhLO7WIcdsBKqm18pKCHF7qn7h
X-Authority-Analysis: v=2.4 cv=VcX6/Vp9 c=1 sm=1 tr=0 ts=6980b8ac cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=oNv3vKmlw4bC7Cr8AvsA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
X-Proofpoint-GUID: L4Gpp0NhLO7WIcdsBKqm18pKCHF7qn7h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDExMyBTYWx0ZWRfX6sOG2u1DGbje
 ZeRz9sl/G+X89bGtsab949G7DHuf9T7H/FD0fdu8fFTKUTEktXyEqUkU7KRLorEPV017ZIbaJ97
 IvJkvdo9lpQEpylt04dHFCfuSZdvpQlvxOvaviAmQf4hskkGe0EzRuzjldPyaF60ohmG7lFl0Oz
 BgLjshEPGyI28zPFnqfIq4uuhIJTLXQbeM3Cm1esHCR+rho6Dg5YsKVa3P4JBLzRBQMsPODPZ5f
 qIQgC/AWchvEF3dzXmYzoOAYjOiLNztuPP1ti1uxkBHM6alxcu8DS4DVeGf/JZPcDnF6AjjPzw2
 J5a1TjxJEoqZTdXBMB+5VdDKTEUMHyIYD6pEKJOY4FWw3LJDdQIcY1hficESYcKN0bLqFE0u0V3
 ZBMzBxnK7138qXKnH4eiLYTvHj23YbsGZ0t8oGZ5cFaYNUbHttT8Fd/U/cLVHjcK6sMwS55FSTl
 yxcUwxds3AImcW2MlTg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602020113
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NEQ_ENVFROM(0.00)[farman@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69859-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D8321CD908
X-Rspamd-Action: no action

Farhan has been doing a masterful job coming on in the
s390 PCI space, and my own attention has been lacking.
Let's make MAINTAINERS reflect reality.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0efa8cc6775b..0d7e76313492 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23094,7 +23094,8 @@ F:	include/uapi/linux/vfio_ccw.h
 
 S390 VFIO-PCI DRIVER
 M:	Matthew Rosato <mjrosato@linux.ibm.com>
-M:	Eric Farman <farman@linux.ibm.com>
+M:	Farhan Ali <alifm@linux.ibm.com>
+R:	Eric Farman <farman@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 L:	kvm@vger.kernel.org
 S:	Supported
-- 
2.51.0


