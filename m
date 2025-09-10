Return-Path: <kvm+bounces-57236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A24FEB51FE2
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD92816ED10
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47C133CEA0;
	Wed, 10 Sep 2025 18:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nWSH+S5d"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24A9343D7A;
	Wed, 10 Sep 2025 18:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527688; cv=none; b=DH+QcI8Z3yF9t8dCWOg5ayhHQPG18EgWL3z6sanFW73h1I/DmtGBJK9HFDm28JIgYLeGZR5yF6AVhy0xBDxAmBlaVTXYYZw34EOwXZaqv+8SI+mOAN2ltXxGknEnUFnj6+/YIsVp9Bltl7xGqqKL9u+ImmOaCWXYqGeBYax2nVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527688; c=relaxed/simple;
	bh=yS3QDDw9EUncTM6vDccI7YBQuaehWcpa7FfZg9mbsug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZT2jwCj+NwSCfyJJPcFBGcHgJIWmyx1EEQKdc2j7zsPINWOMVhTqEX3e6yamoUco4PBhlNLrBIzrt/gkAgPKSnNQnuuxmRQWVopknw9N6KD5qMbH4GnjM7OA6oX7PXPvj9TYrZLuAAZh5r6IEwS6YWQZPosYpZy9kxzGBVMsCB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nWSH+S5d; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AGQeHA019188;
	Wed, 10 Sep 2025 18:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AlvXECOKzeIgvozWY
	qXz9PlxNGXnDKZJqcqhWZskD0o=; b=nWSH+S5dSso4mn0SNeRjGrODja+aRij9C
	82J1XliNr2VWCIAJ+lfV1V1cQ/WIrXaZYW0OfSbY8RPuBFFjby/xpxljcKkGrur8
	zi53QofSRnKpXxiRzdowtnvWqME1jwLMVGhfZDyG75vTgXl2Ky2yQnoDGUEptzZU
	ipeH3PA6B4ythuXhhwQX6gcLHfXWPxKS0eyu81VE3TscrP3ATCQE5vGwj1X7h4Tx
	2uuKXuZMQtSnSyR4XtBUUiubZfZT3J/SCGeUPqqbpl/ylYV5qmcAExw6yUgJ7/B5
	YhkLqKO4pvZw+0L09iKH7zrcUm7XAL5f4Er5LoiAWp4OrfBDWgNcg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcsygea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:53 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AHn8mL017188;
	Wed, 10 Sep 2025 18:07:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmhnjn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7miu43843988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9637620040;
	Wed, 10 Sep 2025 18:07:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E0BD2004B;
	Wed, 10 Sep 2025 18:07:48 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 18:07:48 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v2 07/20] KVM: s390: KVM-specific bitfields and helper functions
Date: Wed, 10 Sep 2025 20:07:33 +0200
Message-ID: <20250910180746.125776-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910180746.125776-1-imbrenda@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX9P35pKgqDnQD
 qcncRj77Tm9bN7aYbbXNrf6xOdk09O9KgKv4pkWRLnPZrwv0eUjjmAy8sfKX7szq4iZ3bjf7f4T
 SgaX1fPj9eAnIa/e1zs4ezwFrjnOd4oKjry7kNuWtmL8PsPgaMl61blT6Vl+PQtdseeH2XfBOjx
 1Xv7HVMMy3/yUTN6mnVEyyZYyAOgr5EZdJnbdMe7YOHUlZ46tuRuKv1PA0aBeuWzqfKy0i7SDf5
 hd8HaOv/K0D+bXjRISmGK+i9zGEJ07q6cyeO3HhPUwViKZRCWeLqX9n2fG9G62+Si9TrtFe5X00
 maMeyjpT53lRPjLj4HGatj9ZnNA7YiZemTZzZ+7gXZcKmbUzTcXyUuDVnrg2euBG/AngAVStY4F
 R/+MqTeY
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c1be79 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=Nv02F_6oUC5gXk1Lt5IA:9
X-Proofpoint-GUID: uzG3bMnuWEoIl8jMyYDYiqajNCMUzMrC
X-Proofpoint-ORIG-GUID: uzG3bMnuWEoIl8jMyYDYiqajNCMUzMrC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

Add KVM-s390 specific bitfields and helper functions to manipulate DAT
tables.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.h | 693 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 693 insertions(+)
 create mode 100644 arch/s390/kvm/dat.h

diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
new file mode 100644
index 000000000000..1e355239247b
--- /dev/null
+++ b/arch/s390/kvm/dat.h
@@ -0,0 +1,693 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2007, 2024
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ *               Martin Schwidefsky <schwidefsky@de.ibm.com>
+ */
+
+#ifndef __KVM_S390_DAT_H
+#define __KVM_S390_DAT_H
+
+#include <linux/radix-tree.h>
+#include <linux/refcount.h>
+#include <linux/io.h>
+#include <linux/kvm_types.h>
+#include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
+#include <asm/dat-bits.h>
+
+#define _ASCE(x) ((union asce) { .val = (x), })
+#define NULL_ASCE _ASCE(0)
+
+enum {
+	_DAT_TOKEN_NONE = 0,
+	_DAT_TOKEN_PIC,
+};
+
+#define _CRSTE_TOK(l, t, p) ((union crste) {	\
+		.tok.i = 1,			\
+		.tok.tt = (l),			\
+		.tok.type = (t),		\
+		.tok.par = (p)			\
+	})
+#define _CRSTE_PIC(l, p) _CRSTE_TOK(l, _DAT_TOKEN_PIC, p)
+
+#define _CRSTE_HOLE(l) _CRSTE_PIC(l, PGM_ADDRESSING)
+#define _CRSTE_EMPTY(l) _CRSTE_TOK(l, _DAT_TOKEN_NONE, 0)
+
+#define _PGD_HOLE _CRSTE_HOLE(TABLE_TYPE_REGION1)
+#define _P4D_HOLE _CRSTE_HOLE(TABLE_TYPE_REGION2)
+#define _PUD_HOLE _CRSTE_HOLE(TABLE_TYPE_REGION3)
+#define _PMD_HOLE _CRSTE_HOLE(TABLE_TYPE_SEGMENT)
+
+#define _PGD_EMPTY _CRSTE_EMPTY(TABLE_TYPE_REGION1)
+#define _P4D_EMPTY _CRSTE_EMPTY(TABLE_TYPE_REGION2)
+#define _PUD_EMPTY _CRSTE_EMPTY(TABLE_TYPE_REGION3)
+#define _PMD_EMPTY _CRSTE_EMPTY(TABLE_TYPE_SEGMENT)
+
+#define _PTE_TOK(t, p) ((union pte) { .tok.i = 1, .tok.type = (t), .tok.par = (p) })
+#define _PTE_PIC(p) _PTE_TOK(_DAT_TOKEN_PIC, p)
+#define _PTE_HOLE _PTE_PIC(PGM_ADDRESSING)
+#define _PTE_EMPTY _PTE_TOK(_DAT_TOKEN_NONE, 0)
+
+enum {
+	LEVEL_PTE = -1,
+	LEVEL_PMD = TABLE_TYPE_SEGMENT,
+	LEVEL_PUD,
+	LEVEL_P4D,
+	LEVEL_PGD
+};
+
+#define RADDR_LEVEL_MASK 0x7
+
+enum dat_walk_flags {
+	DAT_WALK_CONTINUE	= 0x20,
+	DAT_WALK_IGN_HOLES	= 0x10,
+	DAT_WALK_SPLIT		= 0x08,
+	DAT_WALK_ALLOC		= 0x04,
+	DAT_WALK_ANY		= 0x02,
+	DAT_WALK_LEAF		= 0x01,
+	DAT_WALK_DEFAULT	= 0
+};
+
+#define DAT_WALK_SPLIT_ALLOC (DAT_WALK_SPLIT | DAT_WALK_ALLOC)
+#define DAT_WALK_ALLOC_CONTINUE (DAT_WALK_CONTINUE | DAT_WALK_ALLOC)
+#define DAT_WALK_LEAF_ALLOC (DAT_WALK_LEAF | DAT_WALK_ALLOC)
+
+union pte {
+	unsigned long val;
+	union page_table_entry h;
+	struct {
+		unsigned long   :56; /* Hardware bits */
+		unsigned long u : 1; /* Page unused */
+		unsigned long s : 1; /* Special */
+		unsigned long w : 1; /* Writable */
+		unsigned long r : 1; /* Readable */
+		unsigned long d : 1; /* Dirty */
+		unsigned long y : 1; /* Young */
+		unsigned long sd: 1; /* Soft dirty */
+		unsigned long pr: 1; /* Present */
+	} s;
+	struct {
+		unsigned char hwbytes[7];
+		unsigned char swbyte;
+	};
+	union {
+		struct {
+			unsigned long type :16; /* Token type */
+			unsigned long par  :16; /* Token parameter */
+			unsigned long      :20;
+			unsigned long      : 1; /* Must be 0 */
+			unsigned long i    : 1; /* Must be 1 */
+			unsigned long      : 2;
+			unsigned long      : 7;
+			unsigned long pr   : 1; /* Must be 0 */
+		};
+		struct {
+			unsigned long token:32; /* Token and parameter */
+			unsigned long      :32;
+		};
+	} tok;
+};
+
+#define _PAGE_SD 0x002
+
+enum pgste_gps_usage {
+	PGSTE_GPS_USAGE_STABLE = 0,
+	PGSTE_GPS_USAGE_UNUSED,
+	PGSTE_GPS_USAGE_POT_VOLATILE,
+	PGSTE_GPS_USAGE_VOLATILE,
+};
+
+union pgste {
+	unsigned long val;
+	struct {
+		unsigned long acc          : 4;
+		unsigned long fp           : 1;
+		unsigned long              : 3;
+		unsigned long pcl          : 1;
+		unsigned long hr           : 1;
+		unsigned long hc           : 1;
+		unsigned long              : 2;
+		unsigned long gr           : 1;
+		unsigned long gc           : 1;
+		unsigned long              : 1;
+		unsigned long              :16; /* val16 */
+		unsigned long zero         : 1;
+		unsigned long nodat        : 1;
+		unsigned long              : 4;
+		unsigned long usage        : 2;
+		unsigned long              : 8;
+		unsigned long cmma_d       : 1; /* Dirty flag for CMMA bits */
+		unsigned long prefix_notif : 1; /* Guest prefix invalidation notification */
+		unsigned long vsie_notif   : 1; /* Referenced in a shadow table */
+		unsigned long              : 5;
+		unsigned long              : 8;
+	};
+	struct {
+		unsigned short hwbytes0;
+		unsigned short val16;	/* used to store chunked values */
+		unsigned short hwbytes4;
+		unsigned char flags;	/* maps to the software bits */
+		unsigned char hwbyte7;
+	} __packed;
+};
+
+union pmd {
+	unsigned long val;
+	union segment_table_entry h;
+	struct {
+		struct {
+			unsigned long              :44; /* HW */
+			unsigned long              : 3; /* Unused */
+			unsigned long              : 1; /* HW */
+			unsigned long w            : 1; /* Writable soft-bit */
+			unsigned long r            : 1; /* Readable soft-bit */
+			unsigned long d            : 1; /* Dirty */
+			unsigned long y            : 1; /* Young */
+			unsigned long prefix_notif : 1; /* Guest prefix invalidation notification */
+			unsigned long              : 3; /* HW */
+			unsigned long vsie_notif   : 1; /* Referenced in a shadow table */
+			unsigned long              : 1; /* Unused */
+			unsigned long              : 4; /* HW */
+			unsigned long sd           : 1; /* Soft-Dirty */
+			unsigned long pr           : 1; /* Present */
+		} fc1;
+	} s;
+};
+
+union pud {
+	unsigned long val;
+	union region3_table_entry h;
+	struct {
+		struct {
+			unsigned long              :33; /* HW */
+			unsigned long              :14; /* Unused */
+			unsigned long              : 1; /* HW */
+			unsigned long w            : 1; /* Writable soft-bit */
+			unsigned long r            : 1; /* Readable soft-bit */
+			unsigned long d            : 1; /* Dirty */
+			unsigned long y            : 1; /* Young */
+			unsigned long prefix_notif : 1; /* Guest prefix invalidation notification */
+			unsigned long              : 3; /* HW */
+			unsigned long vsie_notif   : 1; /* Referenced in a shadow table */
+			unsigned long              : 1; /* Unused */
+			unsigned long              : 4; /* HW */
+			unsigned long sd           : 1; /* Soft-Dirty */
+			unsigned long pr           : 1; /* Present */
+		} fc1;
+	} s;
+};
+
+union p4d {
+	unsigned long val;
+	union region2_table_entry h;
+};
+
+union pgd {
+	unsigned long val;
+	union region1_table_entry h;
+};
+
+union crste {
+	unsigned long val;
+	union {
+		struct {
+			unsigned long   :52;
+			unsigned long   : 1;
+			unsigned long fc: 1;
+			unsigned long p : 1;
+			unsigned long   : 1;
+			unsigned long   : 2;
+			unsigned long i : 1;
+			unsigned long   : 1;
+			unsigned long tt: 2;
+			unsigned long   : 2;
+		};
+		struct {
+			unsigned long to:52;
+			unsigned long   : 1;
+			unsigned long fc: 1;
+			unsigned long p : 1;
+			unsigned long   : 1;
+			unsigned long tf: 2;
+			unsigned long i : 1;
+			unsigned long   : 1;
+			unsigned long tt: 2;
+			unsigned long tl: 2;
+		} fc0;
+		struct {
+			unsigned long    :47;
+			unsigned long av : 1; /* ACCF-Validity Control */
+			unsigned long acc: 4; /* Access-Control Bits */
+			unsigned long f  : 1; /* Fetch-Protection Bit */
+			unsigned long fc : 1; /* Format-Control */
+			unsigned long p  : 1; /* DAT-Protection Bit */
+			unsigned long iep: 1; /* Instruction-Execution-Protection */
+			unsigned long    : 2;
+			unsigned long i  : 1; /* Segment-Invalid Bit */
+			unsigned long cs : 1; /* Common-Segment Bit */
+			unsigned long tt : 2; /* Table-Type Bits */
+			unsigned long    : 2;
+		} fc1;
+	} h;
+	struct {
+		struct {
+			unsigned long              :47;
+			unsigned long              : 1; /* HW (should be 0) */
+			unsigned long w            : 1; /* Writable */
+			unsigned long r            : 1; /* Readable */
+			unsigned long d            : 1; /* Dirty */
+			unsigned long y            : 1; /* Young */
+			unsigned long prefix_notif : 1; /* Guest prefix invalidation notification */
+			unsigned long              : 3; /* HW */
+			unsigned long vsie_notif   : 1; /* Referenced in a shadow table */
+			unsigned long              : 1;
+			unsigned long              : 4; /* HW */
+			unsigned long sd           : 1; /* Soft-Dirty */
+			unsigned long pr           : 1; /* Present */
+		} fc1;
+	} s;
+	union {
+		struct {
+			unsigned long type :16; /* Token type */
+			unsigned long par  :16; /* Token parameter */
+			unsigned long      :26;
+			unsigned long i    : 1; /* Must be 1 */
+			unsigned long      : 1;
+			unsigned long tt   : 2;
+			unsigned long      : 1;
+			unsigned long pr   : 1; /* Must be 0 */
+		};
+		struct {
+			unsigned long token:32; /* Token and parameter */
+			unsigned long      :32;
+		};
+	} tok;
+	union pmd pmd;
+	union pud pud;
+	union p4d p4d;
+	union pgd pgd;
+};
+
+union skey {
+	unsigned char skey;
+	struct {
+		unsigned char acc :4;
+		unsigned char fp  :1;
+		unsigned char r   :1;
+		unsigned char c   :1;
+		unsigned char zero:1;
+	};
+};
+
+static_assert(sizeof(union pgste) == sizeof(unsigned long));
+static_assert(sizeof(union pte) == sizeof(unsigned long));
+static_assert(sizeof(union pmd) == sizeof(unsigned long));
+static_assert(sizeof(union pud) == sizeof(unsigned long));
+static_assert(sizeof(union p4d) == sizeof(unsigned long));
+static_assert(sizeof(union pgd) == sizeof(unsigned long));
+static_assert(sizeof(union crste) == sizeof(unsigned long));
+static_assert(sizeof(union skey) == sizeof(char));
+
+struct segment_table {
+	union pmd pmds[_CRST_ENTRIES];
+};
+
+struct region3_table {
+	union pud puds[_CRST_ENTRIES];
+};
+
+struct region2_table {
+	union p4d p4ds[_CRST_ENTRIES];
+};
+
+struct region1_table {
+	union pgd pgds[_CRST_ENTRIES];
+};
+
+struct crst_table {
+	union {
+		union crste crstes[_CRST_ENTRIES];
+		struct segment_table segment;
+		struct region3_table region3;
+		struct region2_table region2;
+		struct region1_table region1;
+	};
+};
+
+struct page_table {
+	union pte ptes[_PAGE_ENTRIES];
+	union pgste pgstes[_PAGE_ENTRIES];
+};
+
+static_assert(sizeof(struct crst_table) == _CRST_TABLE_SIZE);
+static_assert(sizeof(struct page_table) == PAGE_SIZE);
+
+static inline union pte _pte(kvm_pfn_t pfn, bool w, bool d, bool s)
+{
+	union pte res = { .val = PFN_PHYS(pfn) };
+
+	res.h.p = !d;
+	res.s.y = 1;
+	res.s.pr = 1;
+	res.s.w = w;
+	res.s.d = d;
+	res.s.sd = d;
+	res.s.s = s;
+	return res;
+}
+
+static inline union crste _crste_fc0(kvm_pfn_t pfn, int tt)
+{
+	union crste res = { .val = PFN_PHYS(pfn) };
+
+	res.h.tt = tt;
+	res.h.fc0.tl = _REGION_ENTRY_LENGTH;
+	res.h.fc0.tf = 0;
+	return res;
+}
+
+static inline union crste _crste_fc1(kvm_pfn_t pfn, int tt, bool w, bool d)
+{
+	union crste res = { .val = PFN_PHYS(pfn) & _SEGMENT_MASK };
+
+	res.h.tt = tt;
+	res.h.p = !d;
+	res.h.fc = 1;
+	res.s.fc1.y = 1;
+	res.s.fc1.pr = 1;
+	res.s.fc1.w = w;
+	res.s.fc1.d = d;
+	res.s.fc1.sd = d;
+	return res;
+}
+
+static inline struct crst_table *crste_table_start(union crste *crstep)
+{
+	return (struct crst_table *)ALIGN_DOWN((unsigned long)crstep, _CRST_TABLE_SIZE);
+}
+
+static inline struct page_table *pte_table_start(union pte *ptep)
+{
+	return (struct page_table *)ALIGN_DOWN((unsigned long)ptep, _PAGE_TABLE_SIZE);
+}
+
+static inline bool crdte_crste(union crste *crstep, union crste old, union crste new, gfn_t gfn,
+			       union asce asce)
+{
+	void *table = crste_table_start(crstep);
+	unsigned long dtt = 0x10 | new.h.tt << 2;
+
+	return crdte(old.val, new.val, table, dtt, gfn_to_gpa(gfn), asce.val);
+}
+
+static __always_inline void idte_crste(union crste *crstep, gfn_t gfn, unsigned long opt,
+				       union asce asce, int local)
+{
+	unsigned long gaddr = gfn_to_gpa(gfn) & HPAGE_MASK;
+	unsigned long to = __pa(crste_table_start(crstep));
+
+	if (__builtin_constant_p(opt) && opt == 0) {
+		/* flush without guest asce */
+		asm volatile("idte	%[r1],0,%[r2],%[m4]"
+			: "+m" (*crstep)
+			: [r1] "a" (to), [r2] "a" (gaddr),
+			  [m4] "i" (local)
+			: "cc");
+	} else {
+		/* flush with guest asce */
+		asm volatile("idte	%[r1],%[r3],%[r2],%[m4]"
+			: "+m" (*crstep)
+			: [r1] "a" (to), [r2] "a" (gaddr | opt),
+			  [r3] "a" (asce.val), [m4] "i" (local)
+			: "cc");
+	}
+}
+
+static inline void dat_init_pgstes(struct page_table *pt, unsigned long val)
+{
+	memset64((void *)pt->pgstes, val, PTRS_PER_PTE);
+}
+
+static inline void dat_init_page_table(struct page_table *pt, unsigned long ptes,
+				       unsigned long pgstes)
+{
+	memset64((void *)pt->ptes, ptes, PTRS_PER_PTE);
+	dat_init_pgstes(pt, pgstes);
+}
+
+static inline gfn_t asce_end(union asce asce)
+{
+	return 1ULL << ((asce.dt + 1) * 11 + _SEGMENT_SHIFT - PAGE_SHIFT);
+}
+
+#define _CRSTE(x) ((union crste) { .val = _Generic((x),	\
+			union pgd : (x).val,		\
+			union p4d : (x).val,		\
+			union pud : (x).val,		\
+			union pmd : (x).val,		\
+			union crste : (x).val)})
+
+#define _CRSTEP(x) ((union crste *)_Generic((*(x)),	\
+				union pgd : (x),	\
+				union p4d : (x),	\
+				union pud : (x),	\
+				union pmd : (x),	\
+				union crste : (x)))
+
+#define _CRSTP(x) ((struct crst_table *)_Generic((*(x)),	\
+		struct crst_table : (x),			\
+		struct segment_table : (x),			\
+		struct region3_table : (x),			\
+		struct region2_table : (x),			\
+		struct region1_table : (x)))
+
+static inline bool asce_contains_gfn(union asce asce, gfn_t gfn)
+{
+	return gfn < asce_end(asce);
+}
+
+static inline bool is_pmd(union crste crste)
+{
+	return crste.h.tt == TABLE_TYPE_SEGMENT;
+}
+
+static inline bool is_pud(union crste crste)
+{
+	return crste.h.tt == TABLE_TYPE_REGION3;
+}
+
+static inline bool is_p4d(union crste crste)
+{
+	return crste.h.tt == TABLE_TYPE_REGION2;
+}
+
+static inline bool is_pgd(union crste crste)
+{
+	return crste.h.tt == TABLE_TYPE_REGION1;
+}
+
+static inline phys_addr_t pmd_origin_large(union pmd pmd)
+{
+	return pmd.val & _SEGMENT_ENTRY_ORIGIN_LARGE;
+}
+
+static inline phys_addr_t pud_origin_large(union pud pud)
+{
+	return pud.val & _REGION3_ENTRY_ORIGIN_LARGE;
+}
+
+static inline phys_addr_t crste_origin_large(union crste crste)
+{
+	if (is_pmd(crste))
+		return pmd_origin_large(crste.pmd);
+	return pud_origin_large(crste.pud);
+}
+
+#define crste_origin(x) (_Generic((x),				\
+		union pmd : (x).val & _SEGMENT_ENTRY_ORIGIN,	\
+		union pud : (x).val & _REGION_ENTRY_ORIGIN,	\
+		union p4d : (x).val & _REGION_ENTRY_ORIGIN,	\
+		union pgd : (x).val & _REGION_ENTRY_ORIGIN))
+
+static inline unsigned long pte_origin(union pte pte)
+{
+	return pte.val & PAGE_MASK;
+}
+
+static inline bool pmd_prefix(union pmd pmd)
+{
+	return pmd.h.fc && pmd.s.fc1.prefix_notif;
+}
+
+static inline bool pud_prefix(union pud pud)
+{
+	return pud.h.fc && pud.s.fc1.prefix_notif;
+}
+
+static inline bool crste_leaf(union crste crste)
+{
+	return (crste.h.tt <= LEVEL_PUD) && crste.h.fc;
+}
+
+static inline bool crste_prefix(union crste crste)
+{
+	return crste_leaf(crste) && crste.s.fc1.prefix_notif;
+}
+
+static inline bool crste_dirty(union crste crste)
+{
+	return crste_leaf(crste) && crste.s.fc1.d;
+}
+
+static inline union pgste *pgste_of(union pte *pte)
+{
+	return (union pgste *)(pte + _PAGE_ENTRIES);
+}
+
+static inline bool pte_hole(union pte pte)
+{
+	return pte.h.i && !pte.tok.pr && pte.tok.type != _DAT_TOKEN_NONE;
+}
+
+static inline bool _crste_hole(union crste crste)
+{
+	return crste.h.i && !crste.tok.pr && crste.tok.type != _DAT_TOKEN_NONE;
+}
+
+#define crste_hole(x) _crste_hole(_CRSTE(x))
+
+static inline bool _crste_none(union crste crste)
+{
+	return crste.h.i && !crste.tok.pr && crste.tok.type == _DAT_TOKEN_NONE;
+}
+
+#define crste_none(x) _crste_none(_CRSTE(x))
+
+static inline phys_addr_t large_pud_to_phys(union pud pud, gfn_t gfn)
+{
+	return pud_origin_large(pud) | (gfn_to_gpa(gfn) & ~_REGION3_MASK);
+}
+
+static inline phys_addr_t large_pmd_to_phys(union pmd pmd, gfn_t gfn)
+{
+	return pmd_origin_large(pmd) | (gfn_to_gpa(gfn) & ~_SEGMENT_MASK);
+}
+
+static inline phys_addr_t large_crste_to_phys(union crste crste, gfn_t gfn)
+{
+	if (unlikely(!crste.h.fc || crste.h.tt > TABLE_TYPE_REGION3))
+		return -1;
+	if (is_pmd(crste))
+		return large_pmd_to_phys(crste.pmd, gfn);
+	return large_pud_to_phys(crste.pud, gfn);
+}
+
+static inline void csp_invalidate_crste(union crste *crstep)
+{
+	csp((unsigned int *)crstep + 1, crstep->val, crstep->val | _REGION_ENTRY_INVALID);
+}
+
+static inline bool cspg_crste(union crste *crstep, union crste old, union crste new)
+{
+	return cspg(&crstep->val, old.val, new.val);
+}
+
+static inline struct page_table *dereference_pmd(union pmd pmd)
+{
+	return phys_to_virt(crste_origin(pmd));
+}
+
+static inline struct segment_table *dereference_pud(union pud pud)
+{
+	return phys_to_virt(crste_origin(pud));
+}
+
+static inline struct region3_table *dereference_p4d(union p4d p4d)
+{
+	return phys_to_virt(crste_origin(p4d));
+}
+
+static inline struct region2_table *dereference_pgd(union pgd pgd)
+{
+	return phys_to_virt(crste_origin(pgd));
+}
+
+static inline struct crst_table *_dereference_crste(union crste crste)
+{
+	if (unlikely(is_pmd(crste)))
+		return NULL;
+	return phys_to_virt(crste_origin(crste.pud));
+}
+
+#define dereference_crste(x) (_Generic((x),			\
+		union pud : _dereference_crste(_CRSTE(x)),	\
+		union p4d : _dereference_crste(_CRSTE(x)),	\
+		union pgd : _dereference_crste(_CRSTE(x)),	\
+		union crste : _dereference_crste(_CRSTE(x))))
+
+static inline struct crst_table *dereference_asce(union asce asce)
+{
+	return phys_to_virt(asce.val & _ASCE_ORIGIN);
+}
+
+static inline void asce_flush_tlb(union asce asce)
+{
+	if (cpu_has_idte())
+		__tlb_flush_idte(asce.val);
+	else
+		__tlb_flush_global();
+}
+
+static inline bool pgste_get_trylock(union pte *ptep, union pgste *res)
+{
+	union pgste *pgstep = pgste_of(ptep);
+	union pgste tmp_pgste;
+
+	if (READ_ONCE(pgstep->val) & PGSTE_PCL_BIT)
+		return false;
+	tmp_pgste.val = __atomic64_or_barrier(PGSTE_PCL_BIT, &pgstep->val);
+	if (tmp_pgste.pcl)
+		return false;
+	tmp_pgste.pcl = 1;
+	*res = tmp_pgste;
+	return true;
+}
+
+static inline union pgste pgste_get_lock(union pte *ptep)
+{
+	union pgste res;
+
+	while (!pgste_get_trylock(ptep, &res))
+		cpu_relax();
+	return res;
+}
+
+static inline void pgste_set_unlock(union pte *ptep, union pgste pgste)
+{
+	pgste.pcl = 0;
+	barrier();
+	WRITE_ONCE(*pgste_of(ptep), pgste);
+}
+
+static inline struct page_table *dat_alloc_empty_pt(void)
+{
+	return dat_alloc_pt(_PAGE_INVALID, 0);
+}
+
+static inline void dat_free_pt(struct page_table *pt)
+{
+	free_page((unsigned long)pt);
+}
+
+static inline void _dat_free_crst(struct crst_table *table)
+{
+	free_pages((unsigned long)table, CRST_ALLOC_ORDER);
+}
+
+#define dat_free_crst(x) _dat_free_crst(_CRSTP(x))
+
+#endif /* __KVM_S390_DAT_H */
-- 
2.51.0


