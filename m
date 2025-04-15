Return-Path: <kvm+bounces-43337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12719A898BF
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 11:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48F96173704
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 09:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29FA628A1DE;
	Tue, 15 Apr 2025 09:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N+W9Xh5t"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B913C13D
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 09:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744710845; cv=none; b=m7OZHfS1MA47NTHdvqsiSpHNVsk+5cRl+5YauBg1DT5U4C25JiFq/3LNuzu7A4mDR4shvvxyAdk81D1cTNrllrviEgV2bvdeQ7CdZ5cEq/pUJXRMeOIe0RhtdEvBAhCTqRczau4cIGkBQhOVPQgqDGONHghFW2PwKAl8v/p0LYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744710845; c=relaxed/simple;
	bh=+drrunECYDeyWJd9yDyBjUgyR32fgBrE8jIc4uITImA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PvGxaej4UQpKx1UaqivSKrjfjie04woA2jlFiCpEs6DkJwDGP0aKuwXIFcUdYA4HIA7B0PcS6VpTfJ2Q6EaEcgckg2U62B8DTghMguprPUg727Ilp2ZVq3NVT22jVZFQk2zCVO0xTvxZQJYcOwd3W7c9NwkiFosXI34nskM5q10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N+W9Xh5t; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53F8Y7i1029519;
	Tue, 15 Apr 2025 09:53:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qn5UXS
	bPCmMWwN2GqFUSOsOAZH7fvyZaVOgEeQPAcK8=; b=N+W9Xh5tDAjodFwPGAv3hG
	elSknNvmZqdvGmVZiaoOH+gqYBioKslU2R/AC5FObWyxzxZCXkUMSWlFqs4YDQMC
	kSrfgbrdKYTu5EFUtEydDRgLHDoKjsHeK/2E2Elx6oml3m+6XR7y7Fx+exbOAURL
	utb1+AFU/us9/Lh8S2V0aTZhDItj49auc6YXA39PM6uztyiEzkXJcP9KA7N8Xkgb
	nCreGyR/0eQI4pe3Qcoj5v7Q3fTO7pQxFRjqngbC1MMGVorhnhMgNGzn1/IdDJzu
	X5qCMO5FXJPHt0IafKNgWttn6U4Fbt7iadAQIfcegRQTasZqW5r+ftWYqzviA2fg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 461agt2mjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 09:53:55 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53F9mi4F024364;
	Tue, 15 Apr 2025 09:53:54 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 461agt2mjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 09:53:54 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53F8heqT024888;
	Tue, 15 Apr 2025 09:53:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4602gtav1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 09:53:53 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53F9ro0r44237162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Apr 2025 09:53:50 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7513E20040;
	Tue, 15 Apr 2025 09:53:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B98432004B;
	Tue, 15 Apr 2025 09:53:48 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.204.206.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Apr 2025 09:53:48 +0000 (GMT)
Date: Tue, 15 Apr 2025 15:23:45 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: npiggin@gmail.com, danielhb413@gmail.com, harshpb@linux.ibm.com,
        pbonzini@redhat.com, vaibhav@linux.ibm.com, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH] hw/ppc/spapr_hcall: Return host mitigation
 characteristics in KVM mode
Message-ID: <wzlalscz5vokfev74k7hpa2pf4sk4g32famkugn5l4q36xv5re@35ck4vgr2uzv>
References: <20250410104354.308714-1-gautam@linux.ibm.com>
 <5393ff40-0e1f-4f3e-8379-8b2208301c70@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5393ff40-0e1f-4f3e-8379-8b2208301c70@linaro.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d_U3K9nWVuvK5_lX87kwZQ0GntRGs0Do
X-Proofpoint-GUID: KYqrhzF98mIniPnly1FPmhR0EkgTRiqX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-15_04,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504150066

On Thu, Apr 10, 2025 at 02:46:47PM +0200, Philippe Mathieu-Daudé wrote:
> Hi Gautam,
> 
> On 10/4/25 12:43, Gautam Menghani wrote:
> > Currently, on a P10 KVM guest, the mitigations seen in the output of
> > "lscpu" command are different from the host. The reason for this
> > behaviour is that when the KVM guest makes the "h_get_cpu_characteristics"
> > hcall, QEMU does not consider the data it received from the host via the
> > KVM_PPC_GET_CPU_CHAR ioctl, and just uses the values present in
> > spapr->eff.caps[], which in turn just contain the default values set in
> > spapr_machine_class_init().
> > 
> > Fix this behaviour by making sure that h_get_cpu_characteristics()
> > returns the data received from the KVM ioctl for a KVM guest.
> > 
> > Perf impact:
> > With null syscall benchmark[1], ~45% improvement is observed.
> > 
> > 1. Vanilla QEMU
> > $ ./null_syscall
> > 132.19 ns     456.54 cycles
> > 
> > 2. With this patch
> > $ ./null_syscall
> > 91.18 ns     314.57 cycles
> > 
> > [1]: https://ozlabs.org/~anton/junkcode/null_syscall.c
> > 
> > Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> > ---
> >   hw/ppc/spapr_hcall.c   | 6 ++++++
> >   include/hw/ppc/spapr.h | 1 +
> >   target/ppc/kvm.c       | 2 ++
> >   3 files changed, 9 insertions(+)
> > 
> > diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
> > index 406aea4ecb..6aec4e22fc 100644
> > --- a/hw/ppc/spapr_hcall.c
> > +++ b/hw/ppc/spapr_hcall.c
> > @@ -1415,6 +1415,12 @@ static target_ulong h_get_cpu_characteristics(PowerPCCPU *cpu,
> >       uint8_t count_cache_flush_assist = spapr_get_cap(spapr,
> >                                                        SPAPR_CAP_CCF_ASSIST);
> > +    if (kvm_enabled()) {
> > +        args[0] = spapr->chars.character;
> > +        args[1] = spapr->chars.behaviour;
> 
> If kvmppc_get_cpu_characteristics() call fails, we return random data.
> 
> Can't we just call kvm_vm_check_extension(s, KVM_CAP_PPC_GET_CPU_CHAR)
> and kvm_vm_ioctl(s, KVM_PPC_GET_CPU_CHAR, &c) here?
> 

To handle the IOCTL failure problem, we can make these changes on
top of the main patch:


diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index 3f7882ab34..d6db1bdab8 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -1402,7 +1402,7 @@ static target_ulong h_get_cpu_characteristics(PowerPCCPU *cpu,
     uint8_t count_cache_flush_assist = spapr_get_cap(spapr,
                                                      SPAPR_CAP_CCF_ASSIST);
 
-    if (kvm_enabled()) {
+    if (kvm_enabled() && spapr->chars.character) {
         args[0] = spapr->chars.character;
         args[1] = spapr->chars.behaviour;
         return H_SUCCESS;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index ad47b70799..4f64d392a8 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2500,7 +2500,7 @@ bool kvmppc_has_cap_xive(void)
 static void kvmppc_get_cpu_characteristics(KVMState *s)
 {
     SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
-    struct kvm_ppc_cpu_char c;
+    struct kvm_ppc_cpu_char c = {0};
     int ret;
 
     /* Assume broken */
@@ -2510,11 +2510,11 @@ static void kvmppc_get_cpu_characteristics(KVMState *s)
 
     ret = kvm_vm_check_extension(s, KVM_CAP_PPC_GET_CPU_CHAR);
     if (!ret) {
-        return;
+        goto err;
     }
     ret = kvm_vm_ioctl(s, KVM_PPC_GET_CPU_CHAR, &c);
     if (ret < 0) {
-        return;
+        goto err;
     }
 
     spapr->chars = c;
@@ -2523,6 +2523,11 @@ static void kvmppc_get_cpu_characteristics(KVMState *s)
     cap_ppc_safe_indirect_branch = parse_cap_ppc_safe_indirect_branch(c);
     cap_ppc_count_cache_flush_assist =
         parse_cap_ppc_count_cache_flush_assist(c);
+
+    return;
+
+err:
+    memset(&(spapr->chars), 0, sizeof(struct kvm_ppc_cpu_char));
 }


This change will preserve the existing behaviour when the IOCTL fails.
I'll send a v2 if this looks OK?

Thanks,
Gautam

> > +        return H_SUCCESS;
> > +    }
> > +
> >       switch (safe_cache) {
> >       case SPAPR_CAP_WORKAROUND:
> >           characteristics |= H_CPU_CHAR_L1D_FLUSH_ORI30;
> > diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> > index 39bd5bd5ed..b1e3ee1ae2 100644
> > --- a/include/hw/ppc/spapr.h
> > +++ b/include/hw/ppc/spapr.h
> > @@ -283,6 +283,7 @@ struct SpaprMachineState {
> >       Error *fwnmi_migration_blocker;
> >       SpaprWatchdog wds[WDT_MAX_WATCHDOGS];
> > +    struct kvm_ppc_cpu_char chars;
> >   };
> >   #define H_SUCCESS         0
> > diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> > index 992356cb75..fee6c5d131 100644
> > --- a/target/ppc/kvm.c
> > +++ b/target/ppc/kvm.c
> > @@ -2511,6 +2511,7 @@ bool kvmppc_has_cap_xive(void)
> >   static void kvmppc_get_cpu_characteristics(KVMState *s)
> >   {
> > +    SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
> >       struct kvm_ppc_cpu_char c;
> >       int ret;
> > @@ -2528,6 +2529,7 @@ static void kvmppc_get_cpu_characteristics(KVMState *s)
> >           return;
> >       }
> > +    spapr->chars = c;
> >       cap_ppc_safe_cache = parse_cap_ppc_safe_cache(c);
> >       cap_ppc_safe_bounds_check = parse_cap_ppc_safe_bounds_check(c);
> >       cap_ppc_safe_indirect_branch = parse_cap_ppc_safe_indirect_branch(c);
> 

