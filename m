Return-Path: <kvm+bounces-34290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E99239FA5E2
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 15:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EAE2161689
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 14:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8300E18C039;
	Sun, 22 Dec 2024 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LMsZnBkW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F049E1854;
	Sun, 22 Dec 2024 14:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734876200; cv=none; b=NEow5HB0us/ySUhv0zpepdCQBJnXtshyeshtQDT22J/x2SyxsKFLoBBuXCXp2MUfDdLb5GgZA9OdzpOBb2GTRNse7R4SIZc8skzm6rrUS7IttAoFEZDoFCfU4zsu1+cDfTjVlIcaJ8xtzrhcvUg2DswAfMbomIGottq3nSXhQ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734876200; c=relaxed/simple;
	bh=izJ+GAUejP8VmqbYGz0NeXXUMWLD1I1/K+vljE64SoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZipCg/gLl64IlUPC4J4ivPsmxdHx44Y6tA7FrCyYkPNaQtIxARDfxDIilhcuQvGve/3WDVEhqTLSJpxDtfSaU+L/8FY7MdMskbWqluSAhdWxPKgFlOJlfm2vNuU+kUbRzDv+s6PG8B9IuLft5T3VXJGwPVpS1vWr7GdANyb3Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LMsZnBkW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BMBu1hb006119;
	Sun, 22 Dec 2024 14:03:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=f4uKjkuTzUFv3bmu8
	RaBubRIjw4jJnrpGktoOFF2mGw=; b=LMsZnBkWqGpbIaN9TbUy1r1c1Pe2ymu5i
	+cMarpAbkbViUchmFtas3p43wCGobj2eKqnKJiwljwYneA6ua4/tifhwGDITxK9Y
	1uUhjm4Pwy5jCCDKwGw15Q8WQ1jnSX6FCJyJTfaLvdQr9D0nQ3dTjmcW2vAY4epd
	eNX+elGYqWrXAd9duvhPdgGEvnPeIU7Py35shff4dwo5x+wCUn1vYh4co7M1Jiwg
	8LBUZ301CfjwISHnEqiOrSES2NqFFtdNdwNX/OcUOtkOTr7wFFjoB3he+OUVYeSR
	vU1e5FTBUrFEblrGYef0xwgQCAD0b/rHK0piEM4ES4riVBOCctqtg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ny54axa3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:08 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BME38N6019694;
	Sun, 22 Dec 2024 14:03:08 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ny54axa1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BMC0hiX020602;
	Sun, 22 Dec 2024 14:03:07 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43p8cy229x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:07 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BME34MV31719878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Dec 2024 14:03:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED4F42004F;
	Sun, 22 Dec 2024 14:03:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 445E320040;
	Sun, 22 Dec 2024 14:03:00 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.24.11])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Sun, 22 Dec 2024 14:03:00 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Sun, 22 Dec 2024 19:32:59 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com
Subject: [PATCH 1/6] [DOC] powerpc: Document APIv2 KVM hcall spec for Hostwide counters
Date: Sun, 22 Dec 2024 19:32:29 +0530
Message-ID: <20241222140247.174998-2-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241222140247.174998-1-vaibhav@linux.ibm.com>
References: <20241222140247.174998-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DcfyYVRII0xwQL93kfiuo-Jm3MzAvbsQ
X-Proofpoint-GUID: Yzf9WE5QsFQ3NHBbbViPVGbtl-ixQLyQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=810 priorityscore=1501 suspectscore=0 clxscore=1011
 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412220124

Update kvm-nested APIv2 documentation to include five new
Guest-State-Elements to fetch the hostwide counters. These counters are
per L1-Lpar and indicate the amount of Heap/Page-table memory allocated,
available and Page-table memory reclaimed for all L2-Guests active
instances

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 Documentation/arch/powerpc/kvm-nested.rst | 40 ++++++++++++++++-------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/Documentation/arch/powerpc/kvm-nested.rst b/Documentation/arch/powerpc/kvm-nested.rst
index 5defd13cc6c1..c506192f3f98 100644
--- a/Documentation/arch/powerpc/kvm-nested.rst
+++ b/Documentation/arch/powerpc/kvm-nested.rst
@@ -208,13 +208,9 @@ associated values for each ID in the GSB::
       flags:
          Bit 0: getGuestWideState: Request state of the Guest instead
            of an individual VCPU.
-         Bit 1: takeOwnershipOfVcpuState Indicate the L1 is taking
-           over ownership of the VCPU state and that the L0 can free
-           the storage holding the state. The VCPU state will need to
-           be returned to the Hypervisor via H_GUEST_SET_STATE prior
-           to H_GUEST_RUN_VCPU being called for this VCPU. The data
-           returned in the dataBuffer is in a Hypervisor internal
-           format.
+         Bit 1: getHostWideState: Request stats of the Host. This causes
+           the guestId and vcpuId parameters to be ignored and attempting
+           to get the VCPU/Guest state will cause an error.
          Bits 2-63: Reserved
       guestId: ID obtained from H_GUEST_CREATE
       vcpuId: ID of the vCPU pass to H_GUEST_CREATE_VCPU
@@ -402,13 +398,14 @@ GSB element:
 
 The ID in the GSB element specifies what is to be set. This includes
 archtected state like GPRs, VSRs, SPRs, plus also some meta data about
-the partition like the timebase offset and partition scoped page
+the partition and  like the timebase offset and partition scoped page
 table information.
 
 +--------+-------+----+--------+----------------------------------+
-|   ID   | Size  | RW | Thread | Details                          |
-|        | Bytes |    | Guest  |                                  |
-|        |       |    | Scope  |                                  |
+|   ID   | Size  | RW |(H)ost  | Details                          |
+|        | Bytes |    |(G)uest |                                  |
+|        |       |    |(T)hread|                                  |
+|        |       |    |Scope   |                                  |
 +========+=======+====+========+==================================+
 | 0x0000 |       | RW |   TG   | NOP element                      |
 +--------+-------+----+--------+----------------------------------+
@@ -434,6 +431,27 @@ table information.
 |        |       |    |        |- 0x8 Table size.                 |
 +--------+-------+----+--------+----------------------------------+
 | 0x0007-|       |    |        | Reserved                         |
+| 0x07FF |       |    |        |                                  |
++--------+-------+----+--------+----------------------------------+
+| 0x0800 | 0x08  | R  |   H    | Current usage in bytes of the    |
+|        |       |    |        | L0's Guest Management Space      |
++--------+-------+----+--------+----------------------------------+
+| 0x0801 | 0x08  | R  |   H    | Max bytes available in the       |
+|        |       |    |        | L0's Guest Management Space      |
++--------+-------+----+--------+----------------------------------+
+| 0x0802 | 0x08  | R  |   H    | Current usage in bytes of the    |
+|        |       |    |        | L0's Guest Page Table Management |
+|        |       |    |        | Space                            |
++--------+-------+----+--------+----------------------------------+
+| 0x0803 | 0x08  | R  |   H    | Max bytes available in the L0's  |
+|        |       |    |        | Guest Page Table Management      |
+|        |       |    |        | Space                            |
++--------+-------+----+--------+----------------------------------+
+| 0x0804 | 0x08  | R  |   H    | Amount of reclaimed L0 Guest's   |
+|        |       |    |        | Page Table Management Space due  |
+|        |       |    |        | to overcommit                    |
++--------+-------+----+--------+----------------------------------+
+| 0x0805-|       |    |        | Reserved                         |
 | 0x0BFF |       |    |        |                                  |
 +--------+-------+----+--------+----------------------------------+
 | 0x0C00 | 0x10  | RW |   T    |Run vCPU Input Buffer:            |
-- 
2.47.1


