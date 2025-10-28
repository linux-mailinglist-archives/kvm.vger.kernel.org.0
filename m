Return-Path: <kvm+bounces-61295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2571C14C07
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 14:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4EA43ACF60
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 13:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00EC33314A9;
	Tue, 28 Oct 2025 13:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BdygRNTl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8711E834B;
	Tue, 28 Oct 2025 13:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761656553; cv=none; b=m6xiqp1CEybs4a/4VBT10VrCOWBRyIVsVjnOtYjvbmyrf0h5l4DGaEWWFSkUctUhNxF+zHoefuDfTT2HjreLAwx5RLPrhtQ76q7eJbyvGIeUXIuN0QTxuKR5Jm0+JllwC14bEfzO87LIfq0QgNXF8+Kkvv0Y5SjSfIyl8wbK70w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761656553; c=relaxed/simple;
	bh=y/xOa8Xh8jFmE2shEhUgqxjsZ8meX9xHnR17we9AuXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grkc0hVVMOfKz0s98RoJSGETyONDQc75ImdjEtihGRbJsUth/29wYX7YRjg9cEPS9meds8MNcwMY0utn0sOZ00i7sJOjjpXpbaAJyPNh9vFxuCTh/9h7fP21KX2jfItDZ1uP1twDb+h//Cz442exLW87RDhYwsPFzE0m/5pGTKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BdygRNTl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59S41AJ5019381;
	Tue, 28 Oct 2025 13:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+oHSK3Wn0f9C36Iap
	LRaRQi98NQen+5vx+thDJ3dB1o=; b=BdygRNTld3droNAcxcRkNVzezz3YSaotl
	tc101bYpC35KLz6GGndl9JWrswb8t4WJzj8B9y2F+e0QRWLJeWURs11TOcnk9h38
	P4Y7fu+VVZ1c6Ib1Cr/lp65nKsF9kdnPZgxHRYHgUZ5cxLvi/IhfUAfNSCDboSHP
	XU+R0hN+Gl7v9VXxotnRjWhEVVWaJCbpNCuyvq+8EM9pA27Er4HYaZgTRk8mY3HF
	XhTY6BryWOchXHZkVnCuU7dtvVx7qupv8KfWbeEaegyVZq+I5LT40ZAuPAp/HBUf
	4lmjLxJGUnWCZjS63Le7i4IOvcnn+WPb7N4fejg4eGj8QxKObnHmg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0mys3vwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 13:01:59 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59SD1w1A002820;
	Tue, 28 Oct 2025 13:01:58 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0mys3vwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 13:01:58 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBii72022886;
	Tue, 28 Oct 2025 13:01:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a198xjust-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 13:01:57 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59SD1pYn59769092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 13:01:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE2F420043;
	Tue, 28 Oct 2025 13:01:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0898820040;
	Tue, 28 Oct 2025 13:01:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Oct 2025 13:01:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: akpm@linux-foundation.org
Cc: balbirs@nvidia.com, borntraeger@de.ibm.com, david@redhat.com,
        Liam.Howlett@oracle.com, airlied@gmail.com, apopple@nvidia.com,
        baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
        dakr@kernel.org, dev.jain@arm.com, dri-devel@lists.freedesktop.org,
        francois.dugast@intel.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
        mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de,
        rakie.kim@sk.com, rcampbell@nvidia.com, ryan.roberts@arm.com,
        simona@ffwll.ch, ying.huang@linux.alibaba.com, ziy@nvidia.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-next@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com
Subject: [PATCH v1 0/1] KVM: s390: Fix missing present bit for gmap puds
Date: Tue, 28 Oct 2025 14:01:49 +0100
Message-ID: <20251028130150.57379-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <d4a09cc8-84b2-42a8-bd03-7fa3adee4a99@linux.ibm.com>
References: <d4a09cc8-84b2-42a8-bd03-7fa3adee4a99@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1IWaxgKcCbAX9g5eiUEXUSG6dBW8TC1L
X-Authority-Analysis: v=2.4 cv=ct2WUl4i c=1 sm=1 tr=0 ts=6900bec7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=MufDUWcMhQhyWPk8zPQA:9
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMCBTYWx0ZWRfX6Uvt5YQT4Rzu
 Tqc2flA5F4AywAliJ9GXPbqvkkbBuJVPyZyvNiaY7+M/pj+XSET0R0dwD2xHsc/WXb13c/R1Cjn
 Za5QtJZlG6ZTkuvrx43BGLO82Woudw/pHuSQXcaRwmg3Lw6YmJ7sjZu5i0MK7ctxfkxJQxK66mJ
 iUydtgZhoO7Sehzgvtxrb+VHYtsVaadTSVdkAjgZhCQLbaYmjKzlt8/gcOrHOVpevOPP57IYzLv
 6mfnnQJISIym2RFVnBtG8szVTssvL9luBu3qa2k8x1JLhes6sA8bMrPqrgAWSPManWYziIlF/Fw
 EzpQvpBrq58QOph5lnVIGQDcv/K9ufmZ2IfgUocUxknLybmR07ddRAZKMUmknhiqTzbK3UaP5f7
 DrTdt7VhqVn6zRemDJJ7w1VsUWz37w==
X-Proofpoint-GUID: 2WzbgKRyldG4biHvk5FucE2LQMmFKT8t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250010

This patch solves the issue uncovered by patch caf527048be8
("mm/huge_memory: add device-private THP support to PMD operations"),
which is at the moment in -next.

@Andrew: do you think it's possible to squeeze this patch in -next
_before_ the patches that introduce the issue? This will guarantee that
the patch is merged first, and will not break bisections once merged.


Claudio Imbrenda (1):
  KVM: s390: Fix missing present bit for gmap puds

 arch/s390/mm/gmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.51.0


