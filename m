Return-Path: <kvm+bounces-4813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C2D818962
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EF14287742
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 14:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F4A1BDED;
	Tue, 19 Dec 2023 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NfsifMQH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C4C1CA8D;
	Tue, 19 Dec 2023 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJDbmLX029429;
	Tue, 19 Dec 2023 14:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=EYkyNfCrQ+NFELmVV6hFywFIc03TtXSogL33lUhiYOw=;
 b=NfsifMQHFajf97dmVhyE/xY/tBPtd2naptlw/wA52aLXbCK3A8hbey1IQKBbDY5uhslZ
 4O/UFGxzq07/fHgnR8gxtadIW6LBSztwcSLG8deJQ7XY7/XVCssoExrj2QGPrpny2M/c
 QHY9cCCELhdLdlYE1gN4zmjqJ02QLZ2hXyE4E+/KQcMZXzPKjhmKlJ7PDRqUVcFN/xPb
 IeY33NhWKLSILG7v02V773gLw1SZgmerfg1YcRY/Q9tdUaI3aJ5xBFuhsEsA6CiN1PJD
 gzA3ugd3Lv160jseL9trO9svVLBqKuV7IOhzv2fqJWAn3Q8fuTfk1hPUWupAgn7Xuxf7 ig== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3c7f8vym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:09:00 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BJDdcGb002649;
	Tue, 19 Dec 2023 14:08:59 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3c7f8vy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:08:59 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJBsY0a012342;
	Tue, 19 Dec 2023 14:08:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3v1rx1qp1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:08:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BJE8twB38273724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 14:08:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F9D32004E;
	Tue, 19 Dec 2023 14:08:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3286C20040;
	Tue, 19 Dec 2023 14:08:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Dec 2023 14:08:55 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: kvm@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v4 0/4] KVM: s390: Fix minor bugs in STFLE shadowing
Date: Tue, 19 Dec 2023 15:08:49 +0100
Message-Id: <20231219140854.1042599-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AdCxsKq7ewqOrFi4lIS7Nyif-tUwytpF
X-Proofpoint-GUID: 8YHoHmHrkFungdw-Uv_hvGf-lEZJi4b8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-19_08,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312190105

v3 -> v4:
 * pick up tags (thanks {David, Janosch, Heiko})
 * changes to commit messages
 * flip lines and add comment (Janosch)

v2 -> v3:
 * pick up tags (thanks Claudio)
 * reverse Christmas tree

v1 -> v2:
 * pick up tags (thanks {Claudio, David})
 * drop Fixes tag on cleanup patch, change message (thanks David)
 * drop Fixes tag on second patch since the length of the facility list
   copied wasn't initially specified and only clarified in later
   revisions
 * use READ/WRITE_ONCE (thanks {David, Heiko})

Improve the STFLE vsie implementation.
Firstly, fix a bug concerning the identification if the guest is
intending to use interpretive execution for STFLE for its guest.
Secondly, decrease the amount of guest memory accessed to the
minimum.
Also do some (optional) cleanups.

Nina Schoetterl-Glausch (4):
  KVM: s390: vsie: Fix STFLE interpretive execution identification
  KVM: s390: vsie: Fix length of facility list shadowed
  KVM: s390: cpu model: Use proper define for facility mask size
  KVM: s390: Minor refactor of base/ext facility lists

 arch/s390/include/asm/facility.h |  6 +++++
 arch/s390/include/asm/kvm_host.h |  2 +-
 arch/s390/kernel/Makefile        |  2 +-
 arch/s390/kernel/facility.c      | 21 +++++++++++++++
 arch/s390/kvm/kvm-s390.c         | 44 ++++++++++++++------------------
 arch/s390/kvm/vsie.c             | 19 ++++++++++++--
 6 files changed, 65 insertions(+), 29 deletions(-)
 create mode 100644 arch/s390/kernel/facility.c

Range-diff against v3:
1:  de77a2c36786 ! 1:  69599bb38487 KVM: s390: vsie: Fix STFLE interpretive execution identification
    @@ arch/s390/kvm/vsie.c: static void retry_vsie_icpt(struct vsie_page *vsie_page)
     +	__u32 fac = READ_ONCE(vsie_page->scb_o->fac);
      
      	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
    -+		fac = fac & 0x7ffffff8U;
      		retry_vsie_icpt(vsie_page);
    ++		/*
    ++		 * The facility list origin (FLO) is in bits 1 - 28 of the FLD
    ++		 * so we need to mask here before reading.
    ++		 */
    ++		fac = fac & 0x7ffffff8U;
      		if (read_guest_real(vcpu, fac, &vsie_page->fac,
      				    sizeof(vsie_page->fac)))
    + 			return set_validity_icpt(scb_s, 0x1090U);
2:  e4b44c4d2400 ! 2:  cba3c32a8db7 KVM: s390: vsie: Fix length of facility list shadowed
    @@ Commit message
     
         The length of the facility list accessed when interpretively executing
         STFLE is the same as the hosts facility list (in case of format-0)
    -    When shadowing, copy only those bytes.
    -    The memory following the facility list need not be accessible, in which
    -    case we'd wrongly inject a validity intercept.
    +    The memory following the facility list doesn't need to be accessible.
    +    The current VSIE implementation accesses a fixed length that exceeds the
    +    guest/host facility list length and can therefore wrongly inject a
    +    validity intercept.
    +    Instead, find out the host facility list length by running STFLE and
    +    copy only as much as necessary when shadowing.
     
         Acked-by: David Hildenbrand <david@redhat.com>
         Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
    +    Acked-by: Heiko Carstens <hca@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## arch/s390/include/asm/facility.h ##
    @@ arch/s390/include/asm/facility.h: static inline void stfle(u64 *stfle_fac_list,
      #endif /* __ASM_FACILITY_H */
     
      ## arch/s390/kernel/Makefile ##
    -@@ arch/s390/kernel/Makefile: obj-y	+= sysinfo.o lgr.o os_info.o
    +@@ arch/s390/kernel/Makefile: obj-y	+= sysinfo.o lgr.o os_info.o ctlreg.o
      obj-y	+= runtime_instr.o cache.o fpu.o dumpstack.o guarded_storage.o sthyi.o
      obj-y	+= entry.o reipl.o kdebugfs.o alternative.o
      obj-y	+= nospec-branch.o ipl_vmparm.o machine_kexec_reloc.o unwind_bc.o
    @@ arch/s390/kvm/vsie.c: static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie
     +	 * -> format-0 flcb
     +	 */
      	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
    - 		fac = fac & 0x7ffffff8U;
      		retry_vsie_icpt(vsie_page);
    + 		/*
    +@@ arch/s390/kvm/vsie.c: static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
    + 		 * so we need to mask here before reading.
    + 		 */
    + 		fac = fac & 0x7ffffff8U;
     +		/*
     +		 * format-0 -> size of nested guest's facility list == guest's size
     +		 * guest's size == host's size, since STFLE is interpretatively executed
3:  8b02ac33defb ! 3:  4b52e432d736 KVM: s390: cpu model: Use proper define for facility mask size
    @@ Commit message
         Note that both values are the same, there is no functional change.
     
         Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
    +    Reviewed-by: David Hildenbrand <david@redhat.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## arch/s390/include/asm/kvm_host.h ##
4:  a592be823576 = 4:  9e551ba53b14 KVM: s390: Minor refactor of base/ext facility lists
-- 
2.40.1


