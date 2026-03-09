Return-Path: <kvm+bounces-73344-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NgLI+gJr2nYMQIAu9opvQ
	(envelope-from <kvm+bounces-73344-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:56:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 06FBA23E0DC
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC7053126355
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 17:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB13303C86;
	Mon,  9 Mar 2026 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="MfdWxYUf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEFC3033E1;
	Mon,  9 Mar 2026 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.157.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078718; cv=none; b=ESKwwcAteW7bPvdq+8Kfr8o2S/F1GTHYpXrKIWmL6AWtCdHQ9nBWEF5OA7uSj5qw14j4yo81Aptw9pcUXS8xspPrmChMU3r6Dr/JVi5zdXbH11E4GSuwsUQ17V0fOCgJqaRCMb2szUzfWXeeMbXB7YEL2gzXIBmpPgcgMnI/GEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078718; c=relaxed/simple;
	bh=gQXEyf9WH0XxJmE7YloWbQ7DbKT2KKIhzze2eU3OK18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAx2CciwvAHAxOAELFY3L8Rumf1z/qM3GmnGP4VG78RGKg2vlnfGfrA6GQZ0UMiVbSeszcazun/l3fgRG8DdhMoOLdhz1FrEis2JFpWXVLSYcaEtLGreebh685voI9GprNO/2+4+niDp91pfdxvkt9IifpUyGIZktOFa5bIy67A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=MfdWxYUf; arc=none smtp.client-ip=67.231.157.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Received: from pps.filterd (m0409410.ppops.net [127.0.0.1])
	by m0409410.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 629HTUvu2133576;
	Mon, 9 Mar 2026 17:51:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=jan2016.eng; bh=HKJJE1a9/
	G6LVwmqfStU9M/AiiM+ISgsUS0KJWYykqA=; b=MfdWxYUfo8XNAm5avcphPnFg7
	utE/UxcYAlRMM9H2Yi3FtqZgVW3+gD8xUQa/mmaG+QMPgXUuCZbBxwzG7mF1AJd2
	jyDGC5222/ETxXUxfVh6NkZBXLMCl7EWqnr81C2XQzSKUkq5AXnX4F4RaLMLfFRc
	prxVLNxg3euh+DxhcoQeKIvY19iEH2r/aEXCuzkdvTPiQLFQgTKNdG20oaKxzqzU
	6sMrSiG8i5zEOZyqqqw1lRmLm2Y2lsrFYWaMEmRpdAYHSW9+qmMaHJfxoWkk/czO
	Duv8tPfYvPeA5wv4eaLTUi3rJzfA0Io7PSzuFXUzrjzVXojTU0u+TwL5DUhng==
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18])
	by m0409410.ppops.net-00190b01. (PPS) with ESMTPS id 4cryt9g9sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 17:51:32 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
	by prod-mail-ppoint1.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 629HmuAB013814;
	Mon, 9 Mar 2026 13:51:31 -0400
Received: from prod-mail-relay01.akamai.com ([172.27.118.31])
	by prod-mail-ppoint1.akamai.com (PPS) with ESMTP id 4crg7yh57e-1;
	Mon, 09 Mar 2026 13:51:31 -0400 (EDT)
Received: from muc-lhv4ep.munich.corp.akamai.com (muc-lhv4ep.munich.corp.akamai.com [172.29.0.215])
	by prod-mail-relay01.akamai.com (Postfix) with ESMTP id 50CA889;
	Mon,  9 Mar 2026 17:51:29 +0000 (UTC)
From: Max Boone <mboone@akamai.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alex Williamson <alex@shazbot.org>, linux-mm@kvack.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@akamai.com>, Josh Hunt <johunt@akamai.com>,
        Matt Pelland <mpelland@akamai.com>, Max Boone <mboone@akamai.com>
Subject: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
Date: Mon,  9 Mar 2026 18:49:49 +0100
Message-ID: <20260309174949.2514565-2-mboone@akamai.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260309174949.2514565-1-mboone@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2602130000 definitions=main-2603090160
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE2MSBTYWx0ZWRfX+lTaKK7/VWFw
 RX0cFG8smkSdrmeSg5bQ4tgQUcfySS33Ev9vGzp26TewWJoSEpLSan4TUFnG2lgGRm7G4xQKZyV
 eL8vcIVF/QDZ49X76BQ570AX2jNO1AucbJoxm8jYH5lR+uB4ssqmZdaJvd0FFa6aFjV9NxlfKI4
 DdFjPeF36unKLdgkFUsVi740c014VX+4nBpK3l1TDfahS3mPei7DZTEAWTFmGwWksR/kWMtDNeV
 4pa91v1w0UV4QDVggJzOjRMKtQy5RgXDIHoNbHffxMvkM6eKjkEIgQ4cQxfrv2P4uADhF+bs0oi
 mjVDCiHg+asfGLYI8jXChGbUpfSz5QkgbWUUTPNGc4CkVVCU4J+7H3vq2w5J2zHai+218oMvt6f
 /JjHyfOJIRR3+xaamLU5Ta1txRMNIAOQnGAA+BSk/yFZzlQqW04qIpOw4XGyaM/KacVJ3ToQisQ
 azw6/LjW0jpbMtpTZ0Q==
X-Authority-Analysis: v=2.4 cv=bahmkePB c=1 sm=1 tr=0 ts=69af08a4 cx=c_pps
 a=StLZT/nZ0R8Xs+spdojYmg==:117 a=StLZT/nZ0R8Xs+spdojYmg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22
 a=KDzEjHMMTas96-nIEKpj:22 a=X7Ea-ya5AAAA:8 a=TWRbNayY-KqUAGRnHQoA:9
X-Proofpoint-GUID: PQGRm8GX1GzudYyVcHmOtKlfYD8YwBf-
X-Proofpoint-ORIG-GUID: PQGRm8GX1GzudYyVcHmOtKlfYD8YwBf-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603090161
X-Rspamd-Queue-Id: 06FBA23E0DC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[akamai.com,quarantine];
	R_DKIM_ALLOW(-0.20)[akamai.com:s=jan2016.eng];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73344-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[akamai.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mboone@akamai.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,akamai.com:dkim,akamai.com:email,akamai.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Action: no action

Don't split and descend on special PMD/PUDs, which are generally
device-backed huge pfnmaps as used by vfio for BAR mapping. These
can be faulted back in after splitting and before descending, which
can race to an illegal read.

Signed-off-by: Max Boone <mboone@akamai.com>
Signed-off-by: Max Tottenham <mtottenh@akamai.com>

---
 mm/pagewalk.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab..d1460dd84 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -147,10 +147,18 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 				continue;
 		}
 
-		if (walk->vma)
+		if (walk->vma) {
+			/*
+			 * Don't descend into device-backed pfnmaps,
+			 * they might refault the PMD entry.
+			 */
+			if (unlikely(pmd_special(*pmd)))
+				continue;
+
 			split_huge_pmd(walk->vma, pmd, addr);
-		else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
+		} else if (pmd_leaf(*pmd) || !pmd_present(*pmd)) {
 			continue; /* Nothing to do. */
+		}
 
 		err = walk_pte_range(pmd, addr, next, walk);
 		if (err)
@@ -213,10 +221,18 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 				continue;
 		}
 
-		if (walk->vma)
+		if (walk->vma) {
+			/*
+			 * Don't descend into device-backed pfnmaps,
+			 * they might refault the PUD entry.
+			 */
+			if (unlikely(pud_special(*pud)))
+				continue;
+
 			split_huge_pud(walk->vma, pud, addr);
-		else if (pud_leaf(*pud) || !pud_present(*pud))
+		} else if (pud_leaf(*pud) || !pud_present(*pud)) {
 			continue; /* Nothing to do. */
+		}
 
 		if (pud_none(*pud))
 			goto again;
-- 
2.34.1


