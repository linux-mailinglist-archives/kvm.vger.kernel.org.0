Return-Path: <kvm+bounces-35554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1560CA12639
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 15:40:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 299B6168B08
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 14:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CCB712EBDB;
	Wed, 15 Jan 2025 14:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="P17m1bDD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CAC433CE;
	Wed, 15 Jan 2025 14:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736952022; cv=none; b=o//bm6ii6OYVIbgUHt21Fk134Ps9fXi2QWms6yLNsv87KWhtZ0//8us962Wk//QXUJ6RVVGNsGN1Yb4H5fynu4dSN0BSRiQCowCRrNKRVbrzYIgwvE+lPHji4/TGXco5jtAAX0nDl6/yjCrpP/qYmbkE86W5P0DtgBESPNjMKss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736952022; c=relaxed/simple;
	bh=fzWJcXtJI1bkM2KbN6na9K34CQd0PiD6zDBS0cmM1u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6Fs2jUTlGAgk1g5vEh53Wn6y91IRQGv/4h0LcFyTuQSBMiFfCHuNzNtcmLhK1hHRZrn4Cajv/lCgacBtQva2PLxg1ci62O2hEXWFPdgJI3SG4cWpT0195MEEqKSVID98quLMFcF+3vAOWF7sMSzW75eCy//SgULy3MPDNY3nFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=P17m1bDD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50F86GGe018784;
	Wed, 15 Jan 2025 14:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=XMD8DcQepmbC4VZAg
	1w6LNvrqXyKOl6oRAKxgD+hnIo=; b=P17m1bDDAliUtU5PAo6HNhtTtGqF7OwlR
	cA7V0j0MRgEJxuxMWhP62yxofZ78uRLQcvFblg5vs++rDUL3c5WjD8h6Ki4blzOi
	Ay0i/vigA1bu/x7RZZMflzOtixTnbc/WXcz5KCp9VlS+lt4iqS6Nm9I3bFJsMdvQ
	5HByjBay6azFvy8Oi/XMjCOplMbMt6aFTr1UaQEXyl3zVqkm09olrgAznAovhOu9
	U8AuDLu4Op4FE59NePsRlfDTfTUO6o6T9naKwhLRZTll7ShJafdyy9gdKSQq+4E8
	ZlyOMPTXP/fDhBUeupIY4G3BnKppiLJ1iSySADt5rxcxhav/5Z8uQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4469731rc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:05 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50FEY75I032452;
	Wed, 15 Jan 2025 14:40:04 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4469731rbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:04 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FAwfpQ017014;
	Wed, 15 Jan 2025 14:40:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fk8q70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FEdxDi39125272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 14:40:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D309220043;
	Wed, 15 Jan 2025 14:39:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1526420040;
	Wed, 15 Jan 2025 14:39:56 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.24.117])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 15 Jan 2025 14:39:55 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Wed, 15 Jan 2025 20:09:55 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com, linux-doc@vger.kernel.org
Subject: [PATCH v2 1/6] powerpc: Document APIv2 KVM hcall spec for Hostwide counters
Date: Wed, 15 Jan 2025 20:09:42 +0530
Message-ID: <20250115143948.369379-2-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115143948.369379-1-vaibhav@linux.ibm.com>
References: <20250115143948.369379-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FtzLwsj3zMRaPoSy_N798VVJzVDHhJOe
X-Proofpoint-GUID: P0bka3CnZ8z8hA3SDucP4D0LQVe-i3zf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_05,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 suspectscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=988 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150110

Update kvm-nested APIv2 documentation to include five new
Guest-State-Elements to fetch the hostwide counters. These counters are
per L1-Lpar and indicate the amount of Heap/Page-table memory allocated,
available and Page-table memory reclaimed for all L2-Guests active
instances

Cc: linux-doc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

---
Changelog

v1->v2:
* Reworded section on GSID [Gautam]
---
 Documentation/arch/powerpc/kvm-nested.rst | 40 +++++++++++++++++------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/Documentation/arch/powerpc/kvm-nested.rst b/Documentation/arch/powerpc/kvm-nested.rst
index 5defd13cc6c1..8e468a4db0dc 100644
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
@@ -406,9 +402,10 @@ the partition like the timebase offset and partition scoped page
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
@@ -434,6 +431,29 @@ table information.
 |        |       |    |        |- 0x8 Table size.                 |
 +--------+-------+----+--------+----------------------------------+
 | 0x0007-|       |    |        | Reserved                         |
+| 0x07FF |       |    |        |                                  |
++--------+-------+----+--------+----------------------------------+
+| 0x0800 | 0x08  | R  |   H    | Current usage in bytes of the    |
+|        |       |    |        | L0's Guest Management Space      |
+|        |       |    |        | for an L1-Lpar.                  |
++--------+-------+----+--------+----------------------------------+
+| 0x0801 | 0x08  | R  |   H    | Max bytes available in the       |
+|        |       |    |        | L0's Guest Management Space for  |
+|        |       |    |        | an L1-Lpar                       |
++--------+-------+----+--------+----------------------------------+
+| 0x0802 | 0x08  | R  |   H    | Current usage in bytes of the    |
+|        |       |    |        | L0's Guest Page Table Management |
+|        |       |    |        | Space for an L1-Lpar             |
++--------+-------+----+--------+----------------------------------+
+| 0x0803 | 0x08  | R  |   H    | Max bytes available in the L0's  |
+|        |       |    |        | Guest Page Table Management      |
+|        |       |    |        | Space for an L1-Lpar             |
++--------+-------+----+--------+----------------------------------+
+| 0x0804 | 0x08  | R  |   H    | Amount of reclaimed L0 Guest's   |
+|        |       |    |        | Page Table Management Space due  |
+|        |       |    |        | to overcommit for an L1-Lpar     |
++--------+-------+----+--------+----------------------------------+
+| 0x0805-|       |    |        | Reserved                         |
 | 0x0BFF |       |    |        |                                  |
 +--------+-------+----+--------+----------------------------------+
 | 0x0C00 | 0x10  | RW |   T    |Run vCPU Input Buffer:            |
-- 
2.47.1


