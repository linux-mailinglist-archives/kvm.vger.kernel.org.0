Return-Path: <kvm+bounces-64363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 50006C80505
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:00:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 47BFF4E6541
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B7D3043D9;
	Mon, 24 Nov 2025 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qsGfGAdS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D26302156;
	Mon, 24 Nov 2025 11:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985390; cv=none; b=GdcZlArGshYy9/IT2ayIFUMj77oPhWvQpOsA9QqFMcuXwUIIBUrXUdcR8mxwj3hpnLOn4DfRtRT2q9L8K62mYVOWeXSjp2rKvaAQZX8ixr9nslo0ooUnkzrJS+QSjKtsXXAZGY2ymeBOOatH5VpkLEjl9d/FJX9O7zmHK5fKBL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985390; c=relaxed/simple;
	bh=smvNvMk/A78XAFU6gFZp4YeVqt+ECquADD5Pfz4z8u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWA1obszZpr+fASgBu2do/4srxurOLFkvVrWy45BkFJLteQhMOULIGIF0+GrGAkOwmBtRlTvtVirbwsHoEuYFtx6V9M+2P4tasWqQA0FV+Gfi2w+CHBRgSkmuqrGhKJhRqWPwd6R4+EqBxfzutgYQV1EUS9Ls2XXerKzdOqlC2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qsGfGAdS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ANNe12u002195;
	Mon, 24 Nov 2025 11:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=TNWGaXoNDPQVLjJv5
	F9Mh/F1oLB4sGb9MidyqxIVvF8=; b=qsGfGAdSFxfTS/Rt05Z4cZC0H1hpZL9QB
	GfIy89b1Bt7zCb1svt+iXnbSgeTd2920fMsSefBvRS0zBMWWx7emMERkucvqXbkQ
	ahNJdRYyNezIjjVLGhOme7vikMTz/7YFtO8cUJG2d0n/T5wZJzmVU5uMOORpH38i
	YlnjpM43XawDhI6ovDjD2Um0jAy6qAnYzrin8qbqPkahQaRusWU/EjwHdTgr/oHM
	FxrDZDvBpk/mbgfaM9n2K0o9F7LpOKePXDKuiMjVd33VZrfv2tUb6WBiLltDBS5V
	nANN8JVMUxtVyfgLkx9Kobq7ss/lTF7qVP+UiZe/l52nfonWK28UA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak2kpqnr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:14 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOA9b5Z000850;
	Mon, 24 Nov 2025 11:56:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akqvxnup0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBu9fS28377410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BED3120043;
	Mon, 24 Nov 2025 11:56:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 195B420040;
	Mon, 24 Nov 2025 11:56:08 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:07 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 07/23] KVM: s390: KVM-specific bitfields and helper functions
Date: Mon, 24 Nov 2025 12:55:38 +0100
Message-ID: <20251124115554.27049-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124115554.27049-1-imbrenda@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwMCBTYWx0ZWRfXw8YH8J1CrpN7
 e3d3MEVBxv+/RjPpW0nqUwK0QWwqJ02mW/4NXX2XR/+VXPRzw6FOaocNyVcXmz+L2cKoSda0s6G
 Tf+kVDHzZphyoaKM+X0HJMHzAQwGVIZycDwq632uaU/4mKnJLhxq0by9zTucA693oGAJBcbEGl3
 uKYGmO8hGjRb+czugV7kAJnho/mDBjYptQGI1phS89lX0+IbhhewJjAdssrfW/kAlp/qUs0ltFZ
 exBr+n0EJcpUCG+/OCY5LYSwtBD98ZbHyLyTGQpV3TbP5NedvKCBqItKNT5Lz8Rv4tvHNBjKtq1
 HKEXmwTuknSQpLGWsE/+nLDd16Vk1A4LjJMz+XXIIQINTGhkdciDKOL904nOboIJ/GL+UdJPBQl
 ue87jFMKtXrsvb4PNZrSLTm+yeaD8g==
X-Authority-Analysis: v=2.4 cv=fJM0HJae c=1 sm=1 tr=0 ts=692447de cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=3TdPgYH1icVPsE-fAXsA:9
X-Proofpoint-GUID: QV2YdhgxD9R6LEYdbJQKR16yiwWv6FZe
X-Proofpoint-ORIG-GUID: QV2YdhgxD9R6LEYdbJQKR16yiwWv6FZe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220000

Add KVM-s390 specific bitfields and helper functions to manipulate DAT
tables.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.h | 720 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 720 insertions(+)
 create mode 100644 arch/s390/kvm/dat.h

diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
new file mode 100644
index 000000000000..4d2b7a7bf898
--- /dev/null
+++ b/arch/s390/kvm/dat.h
@@ -0,0 +1,720 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2024, 2025
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+
+#ifndef __KVM_S390_DAT_H
+#define __KVM_S390_DAT_H
+
+#include <linux/radix-tree.h>
+#include <linux/refcount.h>
+#include <linux/io.h>
+#include <linux/kvm_types.h>
+#include <linux/pgalloc.h>
+#include <asm/tlbflush.h>
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
+#define _PMD_EMPTY _CRSTE_EMPTY(TABLE_TYPE_SEGMENT)
+
+#define _PTE_TOK(t, p) ((union pte) { .tok.i = 1, .tok.type = (t), .tok.par = (p) })
+#define _PTE_EMPTY _PTE_TOK(_DAT_TOKEN_NONE, 0)
+
+/* This fake table type is used for page table walks (both for normal page tables and vSIE) */
+#define TABLE_TYPE_PAGE_TABLE -1
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
+/* Soft dirty, needed as macro for atomic operations on ptes */
+#define _PAGE_SD 0x002
+
+/* Needed as macro to perform atomic operations */
+#define PGSTE_CMMA_D_BIT	0x0000000000008000UL	/* CMMA dirty soft-bit */
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
+		unsigned short val16;	/* used to store chunked values, see dat_{s,g}et_ptval() */
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
+/**
+ * _pte() - Useful constructor for union pte
+ * @pfn: the pfn this pte should point to.
+ * @writable: whether the pte should be writable.
+ * @dirty: whether the pte should be dirty.
+ * @special: whether the pte should be marked as special
+ *
+ * The pte is also marked as young and present. If the pte is marked as dirty,
+ * it gets marked as soft-dirty too. If the pte is not dirty, the hardware
+ * protect bit is set (independently of the write softbit); this way proper
+ * dirty tracking can be performed.
+ *
+ * Return: a union pte value.
+ */
+static inline union pte _pte(kvm_pfn_t pfn, bool writable, bool dirty, bool special)
+{
+	union pte res = { .val = PFN_PHYS(pfn) };
+
+	res.h.p = !dirty;
+	res.s.y = 1;
+	res.s.pr = 1;
+	res.s.w = writable;
+	res.s.d = dirty;
+	res.s.sd = dirty;
+	res.s.s = special;
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
+/**
+ * _crste() - Useful constructor for union crste with FC=1
+ * @pfn: the pfn this pte should point to.
+ * @tt: the table type
+ * @writable: whether the pte should be writable.
+ * @dirty: whether the pte should be dirty.
+ *
+ * The crste is also marked as young and present. If the crste is marked as
+ * dirty, it gets marked as soft-dirty too. If the crste is not dirty, the
+ * hardware protect bit is set (independently of the write softbit); this way
+ * proper dirty tracking can be performed.
+ *
+ * Return: a union crste value.
+ */
+static inline union crste _crste_fc1(kvm_pfn_t pfn, int tt, bool writable, bool dirty)
+{
+	union crste res = { .val = PFN_PHYS(pfn) & _SEGMENT_MASK };
+
+	res.h.tt = tt;
+	res.h.p = !dirty;
+	res.h.fc = 1;
+	res.s.fc1.y = 1;
+	res.s.fc1.pr = 1;
+	res.s.fc1.w = writable;
+	res.s.fc1.d = dirty;
+	res.s.fc1.sd = dirty;
+	return res;
+}
+
+/**
+ * struct vsie_rmap - reverse mapping for shadow page table entries
+ * @next: pointer to next rmap in the list
+ * @r_gfn: virtual rmap address in the shadow guest address space
+ */
+struct vsie_rmap {
+	struct vsie_rmap *next;
+	union {
+		unsigned long val;
+		struct {
+			long          level: 8;
+			unsigned long      : 4;
+			unsigned long r_gfn:52;
+		};
+	};
+};
+
+static_assert(sizeof(struct vsie_rmap) == 2 * sizeof(long));
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
+	unsigned long dtt = 0x10 | new.h.tt << 2;
+	void *table = crste_table_start(crstep);
+
+	return crdte(old.val, new.val, table, dtt, gfn_to_gpa(gfn), asce.val);
+}
+
+/**
+ * idte_crste() - invalidate a crste entry using idte
+ * @crstep: pointer to the crste to be invalidated
+ * @gfn: a gfn mapped by the crste
+ * @opt: options for the idte instruction
+ * @asce: the asce
+ * @local: whether the operation is cpu-local
+ */
+static __always_inline void idte_crste(union crste *crstep, gfn_t gfn, unsigned long opt,
+				       union asce asce, int local)
+{
+	unsigned long table_origin = __pa(crste_table_start(crstep));
+	unsigned long gaddr = gfn_to_gpa(gfn) & HPAGE_MASK;
+
+	if (__builtin_constant_p(opt) && opt == 0) {
+		/* flush without guest asce */
+		asm volatile("idte	%[table_origin],0,%[gaddr],%[local]"
+			: "+m" (*crstep)
+			: [table_origin] "a" (table_origin), [gaddr] "a" (gaddr),
+			  [local] "i" (local)
+			: "cc");
+	} else {
+		/* flush with guest asce */
+		asm volatile("idte %[table_origin],%[asce],%[gaddr_opt],%[local]"
+			: "+m" (*crstep)
+			: [table_origin] "a" (table_origin), [gaddr_opt] "a" (gaddr | opt),
+			  [asce] "a" (asce.val), [local] "i" (local)
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
+/**
+ * crste_origin_large() - Return the large frame origin of a large crste
+ * @crste: The crste whose origin is to be returned. Should be either a
+ *         region-3 table entry or a segment table entry, in both cases with
+ *         FC set to 1 (large pages).
+ *
+ * Return: The origin of the large frame pointed to by @crste, or -1 if the
+ *         crste was not large (wrong table type, or FC==0)
+ */
+static inline phys_addr_t crste_origin_large(union crste crste)
+{
+	if (unlikely(!crste.h.fc || crste.h.tt > TABLE_TYPE_REGION3))
+		return -1;
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
+	return (crste.h.tt <= TABLE_TYPE_REGION3) && crste.h.fc;
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
+	__tlb_flush_idte(asce.val);
+}
+
+static inline bool pgste_get_trylock(union pte *ptep, union pgste *res)
+{
+	union pgste *pgstep = pgste_of(ptep);
+	union pgste old_pgste;
+
+	if (READ_ONCE(pgstep->val) & PGSTE_PCL_BIT)
+		return false;
+	old_pgste.val = __atomic64_or_barrier(PGSTE_PCL_BIT, &pgstep->val);
+	if (old_pgste.pcl)
+		return false;
+	old_pgste.pcl = 1;
+	*res = old_pgste;
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
+#endif /* __KVM_S390_DAT_H */
-- 
2.51.1


