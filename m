Return-Path: <kvm+bounces-83-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A18B37DBD6E
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:04:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7103DB21031
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF44199BC;
	Mon, 30 Oct 2023 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GKeK8Wcc"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8E118E11
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:04:08 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2D4CC;
	Mon, 30 Oct 2023 09:04:07 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UFWi8r001012;
	Mon, 30 Oct 2023 16:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=47lYquhPU+Za2+tBAoBUY0BH7OxORk3ZRua3ozibYQA=;
 b=GKeK8Wccfv0xGW88Vk6GT6/nErQaYc0RR6IKK2xvSqtXluHtBOnUl63EsynxZHbBF6nM
 nARClalOmcEF819dWZY7e2KoAEN9EIELKdl6B+EBmm4uX91JXC6iim9qKWk9/W28BrXw
 QES9GTbplb4iTJMJ/Bm1Lcf1vxJOvyerKdhXoOqHAyu6t1xvi1ud5Fs+cEFag4g391ZO
 hurKu6CHl4ahtJrgt5rYW+9LsTSMbuBwmHwsf26kIRErkgSUbQSBkmlmrrV2ja8ITk3w
 8ithHF9aexYT7DOg9PcYsBjE/tGc4q/6tAUOJrJIXNmJ2wv0CDR5YvZOLniNLjjtUagO kg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2f7dh6pw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:56 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFlnob016423;
	Mon, 30 Oct 2023 16:03:55 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2f7dh6pd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:55 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39UDpF9D000588;
	Mon, 30 Oct 2023 16:03:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1cmste9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39UG3pxI28180996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 16:03:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99C1A20043;
	Mon, 30 Oct 2023 16:03:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C38820040;
	Mon, 30 Oct 2023 16:03:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 16:03:51 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Ricardo Koller <ricarkol@google.com>, Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 00/10] s390x: topology: Fixes and extension
Date: Mon, 30 Oct 2023 17:03:39 +0100
Message-Id: <20231030160349.458764-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t0qYiaa3IuIoZV6tMKPVd2de3zUkAFFd
X-Proofpoint-ORIG-GUID: bhRk_xsab8Umzidzt5BPlUJO12IbN7zg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300124

v2 -> v3 (range-diff below):
 * pick up tags (thanks Janosch, thanks Nico, thanks Thomas)
 * fix ordering test
 * get rid of duplicate reports

v1 -> v2:
 * patch 1, introducing enums (Janosch)
 * add comment explaining 8 alignment of stsi block length
 * unsigned cpu_in_masks, iteration (Nico)
 * fix copy paste error when checking ordering (thanks Nina)
 * don't escape newline when \\ at end of line in multiline string
 * change commit messages (thanks Janosch, thanks Nico)
 * pick up tags (thanks Janosch, thanks Nico)

Fix a number of issues as well as rewrite and extend the topology list
checking.
Add a test case with a complex topology configuration.
In order to keep the unittests.cfg file readable, implement multiline
strings for extra_params.

Nina Schoetterl-Glausch (10):
  s390x: topology: Introduce enums for polarization & cpu type
  s390x: topology: Fix report message
  s390x: topology: Use function parameter in stsi_get_sysib
  s390x: topology: Fix parsing loop
  s390x: topology: Make some report messages unique
  s390x: topology: Refine stsi header test
  s390x: topology: Rename topology_core to topology_cpu
  s390x: topology: Rewrite topology list test
  scripts: Implement multiline strings for extra_params
  s390x: topology: Add complex topology test

 scripts/common.bash  |  16 +++
 scripts/runtime.bash |   4 +-
 lib/s390x/stsi.h     |  47 ++++++---
 s390x/topology.c     | 244 +++++++++++++++++++++++++++----------------
 s390x/unittests.cfg  | 133 +++++++++++++++++++++++
 5 files changed, 335 insertions(+), 109 deletions(-)

Range-diff against v2:
 1:  334fec11 !  1:  c9bf5572 s390x: topology: Introduce enums for polarization & cpu type
    @@ Commit message
     
         Thereby get rid of magic values.
     
    +    Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## lib/s390x/stsi.h ##
 2:  e3fabae5 !  2:  038330af s390x: topology: Fix report message
    @@ Commit message
         A polarization value of 0 means horizontal polarization.
     
         Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/topology.c ##
 3:  95c652d4 =  3:  37cc2bb5 s390x: topology: Use function parameter in stsi_get_sysib
 4:  c3d2eabb !  4:  d4fcb174 s390x: topology: Fix parsing loop
    @@ Commit message
         Without a comparison the loop is infinite.
     
         Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/topology.c ##
 5:  3bab8b7a =  5:  ac883c6c s390x: topology: Make some report messages unique
 6:  3aac2b2d !  6:  744a15b7 s390x: topology: Refine stsi header test
    @@ Commit message
         Also minor refactor.
     
         Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/topology.c ##
 7:  c2cdd5ff =  7:  f6eea5d1 s390x: topology: Rename topology_core to topology_cpu
 8:  95e9a32f !  8:  55eb47bf s390x: topology: Rewrite topology list test
    @@ Commit message
         This improves comprehension and allows for more tests.
         We now also test for ordering of CPU TLEs and number of child entries.
     
    +    Acked-by: Janosch Frank <frankja@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## lib/s390x/stsi.h ##
    @@ s390x/topology.c: static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel
     +{
     +	void *last = ((void *)info) + info->length;
     +	union topology_cpu *prev_cpu = NULL;
    ++	bool correct_ordering = true;
     +	unsigned int cpus = 0;
     +	int i;
     +
    -+	for (i = 0; (void *)&child[i] < last && child[i].nl == 0; i++) {
    ++	for (i = 0; (void *)&child[i] < last && child[i].nl == 0; prev_cpu = &child[i++]) {
     +		cpus += check_cpu(&child[i], cont);
     +		if (prev_cpu) {
    -+			report(prev_cpu->type <= child[i].type, "Correct ordering wrt type");
    ++			if (prev_cpu->type > child[i].type) {
    ++				report_info("Incorrect ordering wrt type for child %d", i);
    ++				correct_ordering = false;
    ++			}
     +			if (prev_cpu->type < child[i].type)
     +				continue;
    -+			report(prev_cpu->pp >= child[i].pp, "Correct ordering wrt polarization");
    ++			if (prev_cpu->pp < child[i].pp) {
    ++				report_info("Incorrect ordering wrt polarization for child %d", i);
    ++				correct_ordering = false;
    ++			}
     +			if (prev_cpu->pp > child[i].pp)
     +				continue;
    -+			report(prev_cpu->d || !child[i].d, "Correct ordering wrt dedication");
    ++			if (!prev_cpu->d && child[i].d) {
    ++				report_info("Incorrect ordering wrt dedication for child %d", i);
    ++				correct_ordering = false;
    ++			}
     +			if (prev_cpu->d && !child[i].d)
     +				continue;
    -+			report(prev_cpu->origin <= child[i].origin, "Correct ordering wrt origin");
    ++			if (prev_cpu->origin > child[i].origin) {
    ++				report_info("Incorrect ordering wrt origin for child %d", i);
    ++				correct_ordering = false;
    ++			}
     +		}
    -+		prev_cpu = &child[i];
     +	}
    ++	report(correct_ordering, "children correctly ordered");
     +	report(cpus <= expected_topo_lvl[0], "%d children <= max of %d",
     +	       cpus, expected_topo_lvl[0]);
     +	*cpus_in_masks += cpus;
 9:  d7317d8b !  9:  8099ad07 scripts: Implement multiline strings for extra_params
    @@ Commit message
         The command string built with extra_params is eval'ed by the runtime
         script, so the newlines need to be escaped with \.
     
    +    Reviewed-by: Thomas Huth <thuth@redhat.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## scripts/common.bash ##
10:  fe527ddb = 10:  5e667461 s390x: topology: Add complex topology test

base-commit: bfe5d7d0e14c8199d134df84d6ae8487a9772c48
-- 
2.41.0


