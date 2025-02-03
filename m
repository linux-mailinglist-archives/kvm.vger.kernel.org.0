Return-Path: <kvm+bounces-37111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 644D2A2548D
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F42073A40F5
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E52D207DEE;
	Mon,  3 Feb 2025 08:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Pnhzu7yM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6D02066DC
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571810; cv=none; b=o61fugAVTrz0ylgmRtSCpVPMrFNj+5uTRRCICatrys7LuojF9AXnwgsWaQiVEPlQL6YDGXgAr7SroXKQCAAwpDpgZkQpGRHOpZyJoOtR4keleIbBYNa2tGr9j6oyLRaG1ljeC6ruv4xOEDl83H2hh65+SnPVEDpqPhOsumEZ6bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571810; c=relaxed/simple;
	bh=fKumqxNAa62hWFXFFkG5i6fQMIrHgXBnMTlNdwgwo84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhWBDcJsV7llz966ueNph1WpIzhVQ7uXa7qsV8IM1cd4Fx4nNoyVYooRAJENTdE8WSou22tW48tM6al0ESeETC0MgaOE4JUKIvLd3aFTFlNAMlCPT0G4zG8qe7ENQIbnLePLOspnKgaq31R6XwMAB5SmCehLekw3VGbR3XYUEzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Pnhzu7yM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5138HbaO013869;
	Mon, 3 Feb 2025 08:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HB5LBycd+LciFtaDJ
	vDUYLFDWAezLuL3wzSwWoYU8CE=; b=Pnhzu7yMA3nLitePJF/3r820UiwO0GY10
	IoIvHe5OCmMYUfXN7M7QLW0OXBIAd5s3dmVUs2Qo82OBXzbVhhO6C68FFpbzzXOF
	KRG5jXMryIyeoUO1S3o2j+51y1i/ZBaBKs7wevOhe8d8zQZ25+3hS8LLUEF9WOm6
	+UvlfacpGUIzC8ufWCPxqofpNLLEtvzYz2C17JZlhIcN49kWA99sNtcTBLNwrQh8
	S5kt77xUjp1SyBd78jwWIy3XE6LKIU+ays/9ta9T2oHCdYePVnSF4a7osXdXSLli
	7aUNbW/9A8k57RyV7j18A9adDmf4BElSICSsLqqhVeL3yTE4CFL3g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jbht2xct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5137laen024533;
	Mon, 3 Feb 2025 08:36:36 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxxmwe5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:36 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aWeb20185538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C61A20040;
	Mon,  3 Feb 2025 08:36:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E23EB20043;
	Mon,  3 Feb 2025 08:36:31 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:31 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 15/18] lib: s390x: Split SIE fw structs from lib structs
Date: Mon,  3 Feb 2025 09:35:23 +0100
Message-ID: <20250203083606.22864-16-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lVtbiVkfTApMH-lGnb-U8JseY04B-TEC
X-Proofpoint-GUID: lVtbiVkfTApMH-lGnb-U8JseY04B-TEC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 impostorscore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502030068

From: Janosch Frank <frankja@linux.ibm.com>

The SIE control block is huge and takes up too much space.

Let's split the hardware definitions from sie.h into its own header,
so that sie.h will only contain library functions and structs

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240806084409.169039-5-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/sie-arch.h | 238 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/sie.h          | 231 +------------------------------------
 2 files changed, 239 insertions(+), 230 deletions(-)
 create mode 100644 lib/s390x/asm/sie-arch.h

diff --git a/lib/s390x/asm/sie-arch.h b/lib/s390x/asm/sie-arch.h
new file mode 100644
index 00000000..4911c988
--- /dev/null
+++ b/lib/s390x/asm/sie-arch.h
@@ -0,0 +1,238 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _S390X_SIE_ARCH_H_
+#define _S390X_SIE_ARCH_H_
+
+#include <stdint.h>
+#include <asm/arch_def.h>
+
+#define CPUSTAT_STOPPED    0x80000000
+#define CPUSTAT_WAIT       0x10000000
+#define CPUSTAT_ECALL_PEND 0x08000000
+#define CPUSTAT_STOP_INT   0x04000000
+#define CPUSTAT_IO_INT     0x02000000
+#define CPUSTAT_EXT_INT    0x01000000
+#define CPUSTAT_RUNNING    0x00800000
+#define CPUSTAT_RETAINED   0x00400000
+#define CPUSTAT_TIMING_SUB 0x00020000
+#define CPUSTAT_SIE_SUB    0x00010000
+#define CPUSTAT_RRF        0x00008000
+#define CPUSTAT_SLSV       0x00004000
+#define CPUSTAT_SLSR       0x00002000
+#define CPUSTAT_ZARCH      0x00000800
+#define CPUSTAT_MCDS       0x00000100
+#define CPUSTAT_KSS        0x00000200
+#define CPUSTAT_SM         0x00000080
+#define CPUSTAT_IBS        0x00000040
+#define CPUSTAT_GED2       0x00000010
+#define CPUSTAT_G          0x00000008
+#define CPUSTAT_GED        0x00000004
+#define CPUSTAT_J          0x00000002
+#define CPUSTAT_P          0x00000001
+
+struct kvm_s390_sie_block {
+	uint32_t 	cpuflags;		/* 0x0000 */
+	uint32_t : 1;			/* 0x0004 */
+	uint32_t 	prefix : 18;
+	uint32_t : 1;
+	uint32_t 	ibc : 12;
+	uint8_t		reserved08[4];		/* 0x0008 */
+#define PROG_IN_SIE (1<<0)
+	uint32_t	prog0c;			/* 0x000c */
+union {
+		uint8_t	reserved10[16];		/* 0x0010 */
+		struct {
+			uint64_t	pv_handle_cpu;
+			uint64_t	pv_handle_config;
+		};
+	};
+#define PROG_BLOCK_SIE	(1<<0)
+#define PROG_REQUEST	(1<<1)
+	uint32_t 	prog20;		/* 0x0020 */
+	uint8_t		reserved24[4];		/* 0x0024 */
+	uint64_t	cputm;			/* 0x0028 */
+	uint64_t	ckc;			/* 0x0030 */
+	uint64_t	epoch;			/* 0x0038 */
+	uint32_t	svcc;			/* 0x0040 */
+#define LCTL_CR0	0x8000
+#define LCTL_CR6	0x0200
+#define LCTL_CR9	0x0040
+#define LCTL_CR10	0x0020
+#define LCTL_CR11	0x0010
+#define LCTL_CR14	0x0002
+	uint16_t   	lctl;			/* 0x0044 */
+	int16_t		icpua;			/* 0x0046 */
+#define ICTL_OPEREXC	0x80000000
+#define ICTL_PINT	0x20000000
+#define ICTL_LPSW	0x00400000
+#define ICTL_STCTL	0x00040000
+#define ICTL_ISKE	0x00004000
+#define ICTL_SSKE	0x00002000
+#define ICTL_RRBE	0x00001000
+#define ICTL_TPROT	0x00000200
+	uint32_t	ictl;			/* 0x0048 */
+#define ECA_CEI		0x80000000
+#define ECA_IB		0x40000000
+#define ECA_SIGPI	0x10000000
+#define ECA_MVPGI	0x01000000
+#define ECA_AIV		0x00200000
+#define ECA_VX		0x00020000
+#define ECA_PROTEXCI	0x00002000
+#define ECA_APIE	0x00000008
+#define ECA_SII		0x00000001
+	uint32_t	eca;			/* 0x004c */
+#define ICPT_INST	0x04
+#define ICPT_PROGI	0x08
+#define ICPT_INSTPROGI	0x0C
+#define ICPT_EXTREQ	0x10
+#define ICPT_EXTINT	0x14
+#define ICPT_IOREQ	0x18
+#define ICPT_WAIT	0x1c
+#define ICPT_VALIDITY	0x20
+#define ICPT_STOP	0x28
+#define ICPT_OPEREXC	0x2C
+#define ICPT_PARTEXEC	0x38
+#define ICPT_IOINST	0x40
+#define ICPT_KSS	0x5c
+#define ICPT_INT_ENABLE	0x64
+#define ICPT_PV_INSTR	0x68
+#define ICPT_PV_NOTIFY	0x6c
+#define ICPT_PV_PREF	0x70
+	uint8_t		icptcode;		/* 0x0050 */
+	uint8_t		icptstatus;		/* 0x0051 */
+	uint16_t	ihcpu;			/* 0x0052 */
+	uint8_t		reserved54;		/* 0x0054 */
+#define IICTL_CODE_NONE		 0x00
+#define IICTL_CODE_MCHK		 0x01
+#define IICTL_CODE_EXT		 0x02
+#define IICTL_CODE_IO		 0x03
+#define IICTL_CODE_RESTART	 0x04
+#define IICTL_CODE_SPECIFICATION 0x10
+#define IICTL_CODE_OPERAND	 0x11
+	uint8_t		iictl;			/* 0x0055 */
+	uint16_t	ipa;			/* 0x0056 */
+	uint32_t	ipb;			/* 0x0058 */
+	uint32_t	scaoh;			/* 0x005c */
+#define FPF_BPBC 	0x20
+	uint8_t		fpf;			/* 0x0060 */
+#define ECB_GS		0x40
+#define ECB_TE		0x10
+#define ECB_SPECI	0x08
+#define ECB_SRSI	0x04
+#define ECB_HOSTPROTINT	0x02
+	uint8_t		ecb;			/* 0x0061 */
+#define ECB2_CMMA	0x80
+#define ECB2_IEP	0x20
+#define ECB2_PFMFI	0x08
+#define ECB2_ESCA	0x04
+	uint8_t    	ecb2;                   /* 0x0062 */
+#define ECB3_DEA 0x08
+#define ECB3_AES 0x04
+#define ECB3_RI  0x01
+	uint8_t    	ecb3;			/* 0x0063 */
+	uint32_t	scaol;			/* 0x0064 */
+	uint8_t		sdf;			/* 0x0068 */
+	uint8_t    	epdx;			/* 0x0069 */
+	uint8_t    	reserved6a[2];		/* 0x006a */
+	uint32_t	todpr;			/* 0x006c */
+#define GISA_FORMAT1 0x00000001
+	uint32_t	gd;			/* 0x0070 */
+	uint8_t		reserved74[12];		/* 0x0074 */
+	uint64_t	mso;			/* 0x0080 */
+	uint64_t	msl;			/* 0x0088 */
+	struct psw	gpsw;			/* 0x0090 */
+	uint64_t	gg14;			/* 0x00a0 */
+	uint64_t	gg15;			/* 0x00a8 */
+	uint8_t		reservedb0[8];		/* 0x00b0 */
+#define HPID_KVM	0x4
+#define HPID_VSIE	0x5
+	uint8_t		hpid;			/* 0x00b8 */
+	uint8_t		reservedb9[7];		/* 0x00b9 */
+	union {
+		struct {
+			uint32_t	eiparams;	/* 0x00c0 */
+			uint16_t	extcpuaddr;	/* 0x00c4 */
+			uint16_t	eic;		/* 0x00c6 */
+		};
+		uint64_t	mcic;			/* 0x00c0 */
+	} __attribute__ ((__packed__));
+	uint32_t	reservedc8;		/* 0x00c8 */
+	uint16_t	pgmilc;			/* 0x00cc */
+	uint16_t	iprcc;			/* 0x00ce */
+	uint32_t	dxc;			/* 0x00d0 */
+	uint16_t	mcn;			/* 0x00d4 */
+	uint8_t		perc;			/* 0x00d6 */
+	uint8_t		peratmid;		/* 0x00d7 */
+	uint64_t	peraddr;		/* 0x00d8 */
+	uint8_t		eai;			/* 0x00e0 */
+	uint8_t		peraid;			/* 0x00e1 */
+	uint8_t		oai;			/* 0x00e2 */
+	uint8_t		armid;			/* 0x00e3 */
+	uint8_t		reservede4[4];		/* 0x00e4 */
+	uint64_t	tecmc;			/* 0x00e8 */
+	uint8_t		reservedf0[12];		/* 0x00f0 */
+#define CRYCB_FORMAT_MASK 0x00000003
+#define CRYCB_FORMAT0 0x00000000
+#define CRYCB_FORMAT1 0x00000001
+#define CRYCB_FORMAT2 0x00000003
+	uint32_t	crycbd;			/* 0x00fc */
+	uint64_t	gcr[16];		/* 0x0100 */
+	union {
+		uint64_t	gbea;			/* 0x0180 */
+		uint64_t	sidad;
+	};
+	uint8_t		reserved188[8];		/* 0x0188 */
+	uint64_t   	sdnxo;			/* 0x0190 */
+	uint8_t    	reserved198[8];		/* 0x0198 */
+	uint32_t	fac;			/* 0x01a0 */
+	uint8_t		reserved1a4[20];	/* 0x01a4 */
+	uint64_t	cbrlo;			/* 0x01b8 */
+	uint8_t		reserved1c0[8];		/* 0x01c0 */
+#define ECD_HOSTREGMGMT	0x20000000
+#define ECD_MEF		0x08000000
+#define ECD_ETOKENF	0x02000000
+#define ECD_ECC		0x00200000
+	uint32_t	ecd;			/* 0x01c8 */
+	uint8_t		reserved1cc[18];	/* 0x01cc */
+	uint64_t	pp;			/* 0x01de */
+	uint8_t		reserved1e6[2];		/* 0x01e6 */
+	uint64_t	itdba;			/* 0x01e8 */
+	uint64_t   	riccbd;			/* 0x01f0 */
+	uint64_t	gvrd;			/* 0x01f8 */
+	uint64_t	reserved200[48];	/* 0x0200 */
+	uint64_t	pv_grregs[16];		/* 0x0380 */
+} __attribute__((packed));
+
+union esca_sigp_ctrl {
+	uint16_t value;
+	struct {
+		uint8_t c : 1;
+		uint8_t reserved: 7;
+		uint8_t scn;
+	};
+};
+
+struct esca_entry {
+	union esca_sigp_ctrl sigp_ctrl;
+	uint16_t   reserved1[3];
+	uint64_t   sda;
+	uint64_t   reserved2[6];
+};
+
+union ipte_control {
+	unsigned long val;
+	struct {
+		unsigned long k  : 1;
+		unsigned long kh : 31;
+		unsigned long kg : 32;
+	};
+};
+
+struct esca_block {
+	union ipte_control ipte_control;
+	uint64_t   reserved1[7];
+	uint64_t   mcn[4];
+	uint64_t   reserved2[20];
+	struct esca_entry cpu[256];
+};
+
+#endif /* _S390X_SIE_ARCH_H_ */
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 53cd767f..3ec49ed0 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -4,236 +4,7 @@
 
 #include <stdint.h>
 #include <asm/arch_def.h>
-
-#define CPUSTAT_STOPPED    0x80000000
-#define CPUSTAT_WAIT       0x10000000
-#define CPUSTAT_ECALL_PEND 0x08000000
-#define CPUSTAT_STOP_INT   0x04000000
-#define CPUSTAT_IO_INT     0x02000000
-#define CPUSTAT_EXT_INT    0x01000000
-#define CPUSTAT_RUNNING    0x00800000
-#define CPUSTAT_RETAINED   0x00400000
-#define CPUSTAT_TIMING_SUB 0x00020000
-#define CPUSTAT_SIE_SUB    0x00010000
-#define CPUSTAT_RRF        0x00008000
-#define CPUSTAT_SLSV       0x00004000
-#define CPUSTAT_SLSR       0x00002000
-#define CPUSTAT_ZARCH      0x00000800
-#define CPUSTAT_MCDS       0x00000100
-#define CPUSTAT_KSS        0x00000200
-#define CPUSTAT_SM         0x00000080
-#define CPUSTAT_IBS        0x00000040
-#define CPUSTAT_GED2       0x00000010
-#define CPUSTAT_G          0x00000008
-#define CPUSTAT_GED        0x00000004
-#define CPUSTAT_J          0x00000002
-#define CPUSTAT_P          0x00000001
-
-struct kvm_s390_sie_block {
-	uint32_t 	cpuflags;		/* 0x0000 */
-	uint32_t : 1;			/* 0x0004 */
-	uint32_t 	prefix : 18;
-	uint32_t : 1;
-	uint32_t 	ibc : 12;
-	uint8_t		reserved08[4];		/* 0x0008 */
-#define PROG_IN_SIE (1<<0)
-	uint32_t	prog0c;			/* 0x000c */
-union {
-		uint8_t	reserved10[16];		/* 0x0010 */
-		struct {
-			uint64_t	pv_handle_cpu;
-			uint64_t	pv_handle_config;
-		};
-	};
-#define PROG_BLOCK_SIE	(1<<0)
-#define PROG_REQUEST	(1<<1)
-	uint32_t 	prog20;		/* 0x0020 */
-	uint8_t		reserved24[4];		/* 0x0024 */
-	uint64_t	cputm;			/* 0x0028 */
-	uint64_t	ckc;			/* 0x0030 */
-	uint64_t	epoch;			/* 0x0038 */
-	uint32_t	svcc;			/* 0x0040 */
-#define LCTL_CR0	0x8000
-#define LCTL_CR6	0x0200
-#define LCTL_CR9	0x0040
-#define LCTL_CR10	0x0020
-#define LCTL_CR11	0x0010
-#define LCTL_CR14	0x0002
-	uint16_t   	lctl;			/* 0x0044 */
-	int16_t		icpua;			/* 0x0046 */
-#define ICTL_OPEREXC	0x80000000
-#define ICTL_PINT	0x20000000
-#define ICTL_LPSW	0x00400000
-#define ICTL_STCTL	0x00040000
-#define ICTL_ISKE	0x00004000
-#define ICTL_SSKE	0x00002000
-#define ICTL_RRBE	0x00001000
-#define ICTL_TPROT	0x00000200
-	uint32_t	ictl;			/* 0x0048 */
-#define ECA_CEI		0x80000000
-#define ECA_IB		0x40000000
-#define ECA_SIGPI	0x10000000
-#define ECA_MVPGI	0x01000000
-#define ECA_AIV		0x00200000
-#define ECA_VX		0x00020000
-#define ECA_PROTEXCI	0x00002000
-#define ECA_APIE	0x00000008
-#define ECA_SII		0x00000001
-	uint32_t	eca;			/* 0x004c */
-#define ICPT_INST	0x04
-#define ICPT_PROGI	0x08
-#define ICPT_INSTPROGI	0x0C
-#define ICPT_EXTREQ	0x10
-#define ICPT_EXTINT	0x14
-#define ICPT_IOREQ	0x18
-#define ICPT_WAIT	0x1c
-#define ICPT_VALIDITY	0x20
-#define ICPT_STOP	0x28
-#define ICPT_OPEREXC	0x2C
-#define ICPT_PARTEXEC	0x38
-#define ICPT_IOINST	0x40
-#define ICPT_KSS	0x5c
-#define ICPT_INT_ENABLE	0x64
-#define ICPT_PV_INSTR	0x68
-#define ICPT_PV_NOTIFY	0x6c
-#define ICPT_PV_PREF	0x70
-	uint8_t		icptcode;		/* 0x0050 */
-	uint8_t		icptstatus;		/* 0x0051 */
-	uint16_t	ihcpu;			/* 0x0052 */
-	uint8_t		reserved54;		/* 0x0054 */
-#define IICTL_CODE_NONE		 0x00
-#define IICTL_CODE_MCHK		 0x01
-#define IICTL_CODE_EXT		 0x02
-#define IICTL_CODE_IO		 0x03
-#define IICTL_CODE_RESTART	 0x04
-#define IICTL_CODE_SPECIFICATION 0x10
-#define IICTL_CODE_OPERAND	 0x11
-	uint8_t		iictl;			/* 0x0055 */
-	uint16_t	ipa;			/* 0x0056 */
-	uint32_t	ipb;			/* 0x0058 */
-	uint32_t	scaoh;			/* 0x005c */
-#define FPF_BPBC 	0x20
-	uint8_t		fpf;			/* 0x0060 */
-#define ECB_GS		0x40
-#define ECB_TE		0x10
-#define ECB_SPECI	0x08
-#define ECB_SRSI	0x04
-#define ECB_HOSTPROTINT	0x02
-	uint8_t		ecb;			/* 0x0061 */
-#define ECB2_CMMA	0x80
-#define ECB2_IEP	0x20
-#define ECB2_PFMFI	0x08
-#define ECB2_ESCA	0x04
-	uint8_t    	ecb2;                   /* 0x0062 */
-#define ECB3_DEA 0x08
-#define ECB3_AES 0x04
-#define ECB3_RI  0x01
-	uint8_t    	ecb3;			/* 0x0063 */
-	uint32_t	scaol;			/* 0x0064 */
-	uint8_t		sdf;			/* 0x0068 */
-	uint8_t    	epdx;			/* 0x0069 */
-	uint8_t    	reserved6a[2];		/* 0x006a */
-	uint32_t	todpr;			/* 0x006c */
-#define GISA_FORMAT1 0x00000001
-	uint32_t	gd;			/* 0x0070 */
-	uint8_t		reserved74[12];		/* 0x0074 */
-	uint64_t	mso;			/* 0x0080 */
-	uint64_t	msl;			/* 0x0088 */
-	struct psw	gpsw;			/* 0x0090 */
-	uint64_t	gg14;			/* 0x00a0 */
-	uint64_t	gg15;			/* 0x00a8 */
-	uint8_t		reservedb0[8];		/* 0x00b0 */
-#define HPID_KVM	0x4
-#define HPID_VSIE	0x5
-	uint8_t		hpid;			/* 0x00b8 */
-	uint8_t		reservedb9[7];		/* 0x00b9 */
-	union {
-		struct {
-			uint32_t	eiparams;	/* 0x00c0 */
-			uint16_t	extcpuaddr;	/* 0x00c4 */
-			uint16_t	eic;		/* 0x00c6 */
-		};
-		uint64_t	mcic;			/* 0x00c0 */
-	} __attribute__ ((__packed__));
-	uint32_t	reservedc8;		/* 0x00c8 */
-	uint16_t	pgmilc;			/* 0x00cc */
-	uint16_t	iprcc;			/* 0x00ce */
-	uint32_t	dxc;			/* 0x00d0 */
-	uint16_t	mcn;			/* 0x00d4 */
-	uint8_t		perc;			/* 0x00d6 */
-	uint8_t		peratmid;		/* 0x00d7 */
-	uint64_t	peraddr;		/* 0x00d8 */
-	uint8_t		eai;			/* 0x00e0 */
-	uint8_t		peraid;			/* 0x00e1 */
-	uint8_t		oai;			/* 0x00e2 */
-	uint8_t		armid;			/* 0x00e3 */
-	uint8_t		reservede4[4];		/* 0x00e4 */
-	uint64_t	tecmc;			/* 0x00e8 */
-	uint8_t		reservedf0[12];		/* 0x00f0 */
-#define CRYCB_FORMAT_MASK 0x00000003
-#define CRYCB_FORMAT0 0x00000000
-#define CRYCB_FORMAT1 0x00000001
-#define CRYCB_FORMAT2 0x00000003
-	uint32_t	crycbd;			/* 0x00fc */
-	uint64_t	gcr[16];		/* 0x0100 */
-	union {
-		uint64_t	gbea;			/* 0x0180 */
-		uint64_t	sidad;
-	};
-	uint8_t		reserved188[8];		/* 0x0188 */
-	uint64_t   	sdnxo;			/* 0x0190 */
-	uint8_t    	reserved198[8];		/* 0x0198 */
-	uint32_t	fac;			/* 0x01a0 */
-	uint8_t		reserved1a4[20];	/* 0x01a4 */
-	uint64_t	cbrlo;			/* 0x01b8 */
-	uint8_t		reserved1c0[8];		/* 0x01c0 */
-#define ECD_HOSTREGMGMT	0x20000000
-#define ECD_MEF		0x08000000
-#define ECD_ETOKENF	0x02000000
-#define ECD_ECC		0x00200000
-	uint32_t	ecd;			/* 0x01c8 */
-	uint8_t		reserved1cc[18];	/* 0x01cc */
-	uint64_t	pp;			/* 0x01de */
-	uint8_t		reserved1e6[2];		/* 0x01e6 */
-	uint64_t	itdba;			/* 0x01e8 */
-	uint64_t   	riccbd;			/* 0x01f0 */
-	uint64_t	gvrd;			/* 0x01f8 */
-	uint64_t	reserved200[48];	/* 0x0200 */
-	uint64_t	pv_grregs[16];		/* 0x0380 */
-} __attribute__((packed));
-
-union esca_sigp_ctrl {
-	uint16_t value;
-	struct {
-		uint8_t c : 1;
-		uint8_t reserved: 7;
-		uint8_t scn;
-	};
-};
-
-struct esca_entry {
-	union esca_sigp_ctrl sigp_ctrl;
-	uint16_t   reserved1[3];
-	uint64_t   sda;
-	uint64_t   reserved2[6];
-};
-
-union ipte_control {
-	unsigned long val;
-	struct {
-		unsigned long k  : 1;
-		unsigned long kh : 31;
-		unsigned long kg : 32;
-	};
-};
-
-struct esca_block {
-	union ipte_control ipte_control;
-	uint64_t   reserved1[7];
-	uint64_t   mcn[4];
-	uint64_t   reserved2[20];
-	struct esca_entry cpu[256];
-};
+#include <asm/sie-arch.h>
 
 struct vm_uv {
 	uint64_t vm_handle;
-- 
2.47.1


