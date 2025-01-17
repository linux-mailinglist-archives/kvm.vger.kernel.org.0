Return-Path: <kvm+bounces-35721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83043A148AE
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 05:07:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1D2B188D2C7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 04:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3831F6664;
	Fri, 17 Jan 2025 04:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hUk/e1gh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B21725765
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 04:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737086833; cv=none; b=X0aBa5vL4Put4Boafw42gFIma2oyx7MrYpQ36guVx+3T3IFmP5nbOJF27GYmfwHAafWmmu/7eHFfqgHxOyo42b+wVjOoidrL13Pv4IoTKRrIeqlfK4uhK0jleeiXR7WwsqplDLeSuRKVjH+RiuIIeHhV/EvJMxsy7hfU3v5rPVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737086833; c=relaxed/simple;
	bh=uBefj5FVqCCj/JMSYgzCY3fgFsXnrA5rl7+5wbAA4xs=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=UDxrTpfqhn51jy5AEbMSbDzZ1O1xPCm3jCZ6F4JVRt/4QSY8HG+JSkMJMlvr+i+0MX/OoqXJH9qqxcXwmK6cIODp/0HuY241gK+d8r4ZcpzzIXXNTanjsIwYYR7RtwxAOpizdR/sEOWhMLVm9Fevyc6LEGYqaFZi6Er4L1IRxvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hUk/e1gh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GNJ2Ym024549;
	Fri, 17 Jan 2025 04:06:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=j2WtY7PpvfNoJKOSo3g0k1yAnYTv
	VbZe7NKspCrFzmE=; b=hUk/e1ghCQxVvf3+4TR4EXUBWq23Nxfbwr2ns7kFIRRk
	8TkYm/1E7eolZwKSUAzdXNcfF14Hh9px1UDIzkeJLOpWXmoQJrhkOZTRZAQ+dtZ4
	vlDDJtqGNgX04Sdv/pNze+bKEl8lXwrl52NLSNMcefOEKAns14N5CEyXv8ahqhLV
	Z79Nc7VA1WY1KqOzG3IR47o9Iv1nF3rXKw+ZCiBRZsPPDxGJwIIce6phwmKNUzRY
	nSZLbAhj2dRAIyAjxtuy/rVYwwAfLRmp/in/dSJLAdDtsbH8tlAVRLybVr4OC3f2
	q0uYMdxG5dRKVDjj1OrA8YsbB+OjHexkNzzJ5+JOvw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4473k5bbas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 04:06:46 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50H46kdP008026;
	Fri, 17 Jan 2025 04:06:46 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4473k5bbap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 04:06:46 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50H2HCLq001089;
	Fri, 17 Jan 2025 04:06:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456k8wc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 04:06:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50H46fDu65863942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 04:06:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA0F22004E;
	Fri, 17 Jan 2025 04:06:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F3F520043;
	Fri, 17 Jan 2025 04:06:40 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 04:06:40 +0000 (GMT)
Subject: [PATCH v9 0/2] ppc: Enable 2nd DAWR support on Power10
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: npiggin@gmail.com
Cc: danielhb413@gmail.com, harshpb@linux.ibm.com, pbonzini@redhat.com,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        sbhat@linux.ibm.com
Date: Fri, 17 Jan 2025 04:06:39 +0000
Message-ID: <173708679976.1678.10844458987521427074.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eHSmqQmNA6aQ8Jh0Kf1Enc-0RWS0su1H
X-Proofpoint-ORIG-GUID: Os9MC1TB4yqtdKEzfYBaxgkAb8FCMPA2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_01,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170028

Extends the existing watchpoint facility from TCG DAWR0 emulation to DAWR1 on
Power10 for powernv in the first patch, and for pseries in the second patch
with both TCG and KVM.

---
Changelog:
v8: https://lore.kernel.org/qemu-devel/170679876639.188422.11634974895844092362.stgit@ltc-boston1.aus.stglabs.ibm.com/
v8->v9:
  - Rebased to upstream.
  - Addressed the changes suggested by David, Nick and Harsh.
  - Added g_assert_not_reached in h_set_mode_resource_set_dawr0() in Patch 2.
  - Made SPAPR_CAP_DAWR1 default ON, so also made it off for cpus below P10.

v7: https://lore.kernel.org/qemu-devel/170063834599.621665.9541440879278084501.stgit@ltcd48-lp2.aus.stglab.ibm.com/
v7->v8:
  - Fixed the missed out ppc_store_dawr* calls.
  - Removed the macros and split the patch into 2 one just enabling the
    facility for powernv and the next one doing the same for pseries guest.
  - The macro removal barely increased the number of lines by 12 as against
    the previous version.

v6: https://lore.kernel.org/qemu-devel/168871963321.58984.15628382614621248470.stgit@ltcd89-lp2/
v6->v7:
  - Sorry about the delay in sending out this version, I have dropped the
    Reviewed-bys as suggested and converted the patch to RFC back again.
  - Added the TCG support. Basically, converted the existing DAWR0 support
    routines into macros for reuse by the DAWR1. Let me know if the macro
    conversions should be moved to a separate independent patch.
  - As the dawr1 works on TCG, the checks in cap_dawr1_apply() report a warning
    now only for P9 or P9 compat modes for both KVM and TCG use cases.
  - 'make test' passes for caps checks. Also, as suggested by Greg Kurz, the
    'make test' after making the DAWR1 default 'on' and updating defaut cpu
    to Power10, shows no failures.

v5: https://lore.kernel.org/all/20210412114433.129702-1-ravi.bangoria@linux.ibm.com/
v5->v6:
  - The other patches in the original series already merged.
  - Rebased to the top of the tree. So, the gen_spr_book3s_310_dbg() is renamed
    to register_book3s_310_dbg_sprs() and moved to cpu_init.c accordingly.
  - No functional changes.

v4: https://lore.kernel.org/r/20210406053833.282907-1-ravi.bangoria@linux.ibm.com
v3->v4:
  - Make error message more proper.

v3: https://lore.kernel.org/r/20210330095350.36309-1-ravi.bangoria@linux.ibm.com
v3->v4:
  - spapr_dt_pa_features(): POWER10 processor is compatible with 3.0
    (PCR_COMPAT_3_00). No need to ppc_check_compat(3_10) for now as
    ppc_check_compati(3_00) will also be true. ppc_check_compat(3_10)
    can be added while introducing pa_features_310 in future.
  - Use error_append_hint() for hints. Also add ERRP_GUARD().
  - Add kvmppc_set_cap_dawr1() stub function for CONFIG_KVM=n.

v2: https://lore.kernel.org/r/20210329041906.213991-1-ravi.bangoria@linux.ibm.com
v2->v3:
  - Don't introduce pa_features_310[], instead, reuse pa_features_300[]
    for 3.1 guests, as there is no difference between initial values of
    them atm.
  - Call gen_spr_book3s_310_dbg() from init_proc_POWER10() instead of
    init_proc_POWER8(). Also, Don't call gen_spr_book3s_207_dbg() from
    gen_spr_book3s_310_dbg() as init_proc_POWER10() already calls it.

v1: https://lore.kernel.org/r/20200723104220.314671-1-ravi.bangoria@linux.ibm.com
v1->v2:
  - Introduce machine capability cap-dawr1 to enable/disable
    the feature. By default, 2nd DAWR is OFF for guests even
    when host kvm supports it. User has to manually enable it
    with -machine cap-dawr1=on if he wishes to use it.
  - Split the header file changes into separate patch. (Sync
    headers from v5.12-rc3)

Shivaprasad G Bhat (2):
      ppc: Enable 2nd DAWR support on Power10 PowerNV machine
      ppc: spapr: Enable 2nd DAWR on Power10 pSeries machine


 hw/ppc/spapr.c           |  7 ++++-
 hw/ppc/spapr_caps.c      | 43 +++++++++++++++++++++++++++++
 hw/ppc/spapr_hcall.c     | 27 ++++++++++++------
 include/hw/ppc/spapr.h   |  6 +++-
 target/ppc/cpu.c         | 45 +++++++++++++++++++++---------
 target/ppc/cpu.h         |  6 ++--
 target/ppc/cpu_init.c    | 15 ++++++++++
 target/ppc/excp_helper.c | 59 +++++++++++++++++++++-------------------
 target/ppc/helper.h      |  2 ++
 target/ppc/kvm.c         | 12 ++++++++
 target/ppc/kvm_ppc.h     | 12 ++++++++
 target/ppc/machine.c     |  3 +-
 target/ppc/misc_helper.c | 10 +++++++
 target/ppc/spr_common.h  |  2 ++
 target/ppc/translate.c   | 12 ++++++++
 15 files changed, 206 insertions(+), 55 deletions(-)

--
Signature



