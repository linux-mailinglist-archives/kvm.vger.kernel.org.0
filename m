Return-Path: <kvm+bounces-38995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E37A42044
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 14:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7793A7A568F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 13:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC18623BD1E;
	Mon, 24 Feb 2025 13:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PLI52Z8H"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B96823BD17;
	Mon, 24 Feb 2025 13:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740402956; cv=none; b=rVMdUamG69YmXMlOUQH8WBUw8G8gtd6HKXPfq5W8C0K2gikzViTo+CWobknEvpvBSxxym91MXefurisKs+BrIdh4vqEq+nq91BQXNsZtW3Kh+2Sm9YPh66v9aWoEp5Ocmwjd1g4LzmJcb6vMA5vRZpzM81zRaprzAkC07i6zHqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740402956; c=relaxed/simple;
	bh=AJW0u040ggEYVZ5PHIvC9dFojwQnVN9i/lch6oVqWR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBRfK9dpd4fHc4soP3sR2BCq1+VDaSUCnxU12fs///l0sVwSsKaiEOzlTkoKi8ApdlBjTExrSgnLdX0Lu0W0HqQVmM95GjS6Z4mVtMzqY5n1v1+ujsowZ2XrV3PKWRHNpxppWHYwNFIDilhekCHeA8jwZ3j/3yBDqt7OUYSF6ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PLI52Z8H; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OD6X6g013044;
	Mon, 24 Feb 2025 13:15:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Brg9f0gFk+YRpmjs+
	z2a4fs20M2McnUvJojPWBxOg8Q=; b=PLI52Z8H7B5mfm1fYklKSfn5AQVha++51
	Lc9I2qpwcUsDlI9+7UZAP+qY41dz+O5TQ4v2BGIy1vHcmguuUoJgdYYQkA1eYbp4
	LjuRUnfbnL3VIBhfbjBQIOQ9tGW8gJdGkQpnNSq8a6MBBf6Xpd8V9RFKd1eEznEX
	9YCXnmytB2nAaD52/l70Wnp4jOum9ML5uulDYMgmIARBdZMS3gm5QLlrcoecXC0Y
	SxEZAp9zJmFUP5MLqdzJ4O+fBKCpcDdZIbQGUp2c0C8iVRIAktbNbJiXB4SysTKk
	4a8WLWs+Yi5Kx5r9qRs30rstkxzeEZgwYvBtyfiwjDtUiCRwy1nNg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 450fm02gng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 13:15:42 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51ODFg4a005678;
	Mon, 24 Feb 2025 13:15:42 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 450fm02gnd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 13:15:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51OA8Ort027376;
	Mon, 24 Feb 2025 13:15:41 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yum1puh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 13:15:41 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51ODFcno56230384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 13:15:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFF982004B;
	Mon, 24 Feb 2025 13:15:37 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F3C620040;
	Mon, 24 Feb 2025 13:15:33 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.210.32])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 24 Feb 2025 13:15:33 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Mon, 24 Feb 2025 18:45:32 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        linux-doc@vger.kernel.org, Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v4 1/6] powerpc: Document APIv2 KVM hcall spec for Hostwide counters
Date: Mon, 24 Feb 2025 18:45:15 +0530
Message-ID: <20250224131522.77104-2-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224131522.77104-1-vaibhav@linux.ibm.com>
References: <20250224131522.77104-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: M3Aa98DSh3-x9YdSQ1SNJdL1Rqr67K46
X-Proofpoint-GUID: _fU_MH-0DYwgDDtGE8v8VGT8qtTieLbN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_05,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502240095

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
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

---
Changelog
v3->v4:
* Added reviewed by [ Bagas Sanjaya ]

v2->v3:
* Minor reword for the cumulative reclaim counter [ Gautam ]

v1->v2:
* Reworded section on GSID [Gautam]
---
 Documentation/arch/powerpc/kvm-nested.rst | 40 +++++++++++++++++------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/Documentation/arch/powerpc/kvm-nested.rst b/Documentation/arch/powerpc/kvm-nested.rst
index 5defd13cc6c1..574592505604 100644
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
+| 0x0804 | 0x08  | R  |   H    | Cumulative Reclaimed bytes from  |
+|        |       |    |        | L0 Guest's Page Table Management |
+|        |       |    |        | Space due to overcommit          |
++--------+-------+----+--------+----------------------------------+
+| 0x0805-|       |    |        | Reserved                         |
 | 0x0BFF |       |    |        |                                  |
 +--------+-------+----+--------+----------------------------------+
 | 0x0C00 | 0x10  | RW |   T    |Run vCPU Input Buffer:            |
-- 
2.48.1


