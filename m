Return-Path: <kvm+bounces-35795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D55DA15315
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC3FA16750A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 15:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA716194A6B;
	Fri, 17 Jan 2025 15:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Lsgx64qm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689DD13AA20;
	Fri, 17 Jan 2025 15:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737128777; cv=none; b=Hw74yPUHPqJMUNprvjxmmr7qq8ATruFyUEuf38WMBUyWoOpDMxWz8IoDPra5Z/qyC1UtA7lRMM+0CwMZB9UXD1KM2GjpeO2QNrFb+0gSU4hRhgmVRjUG9T/ds7IeIJihTag6A8w+pQRwfV01HxFytvpTEv3d5cu6iIoPwYN5nJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737128777; c=relaxed/simple;
	bh=YZkmvvsyrZR/u00rbPGWdwgCLQCF+tb7pj8Rw7J+ZAQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=elJjH3DUtYFo/6sKz1lwKqvqiL5mM960CTJzP9bJS+JKfi6lbKD/Exo2c0acxBvlrV+yX48ZmLcZkxWZNO4VRhIUfAOND0jjXeYmLLLamDsCSh8cKfR1Xrt3x41EIbn6sbVelHJydohZhHZG23mBYj/Wc4Wq8rJ/Czn8WHVbZCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Lsgx64qm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50H8600r001111;
	Fri, 17 Jan 2025 15:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=A7Ty/9NQyE3CfKlPT2iaAh4gNzSw5K
	mkJP28VJu35dQ=; b=Lsgx64qmAA+JVg2PGUe4GeXSdj6YT1PZUtmyM5ZQtN81W4
	3UlY5SLrBiForFkCUS3+zBzzlAxYfWYEzWjZ+0UIz71rAe3A5PLeHg0e2c+DHRFD
	1B6u3LcxOsSQdoQ1mC+CHboF4DMoJiMCz00j4PXxFLruAdF0KUXKq3hHMi03Vw1D
	IerBEiILFMuUhjpFvK5O3SN/WuolGFoUAUOlypQhxBQJ4QTwEqGjlTlMQyGQNdGm
	TKUHnApyEVv7GNOUHLJqXhSnXAHYO0i29/1EFOrVj3MXweRSm+7EMOdAZjjSy4zk
	e1v7jgj2AI4EaJdOdMhJ6guVWs9hUZ01F9Vw5zVQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447kd3j0xq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 15:45:59 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HFjwAO031312;
	Fri, 17 Jan 2025 15:45:58 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447kd3j0xn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 15:45:58 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HDrCGa004540;
	Fri, 17 Jan 2025 15:45:57 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4442yt3qbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 15:45:57 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HFjsJm56885592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 15:45:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4017720040;
	Fri, 17 Jan 2025 15:45:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 93C082004D;
	Fri, 17 Jan 2025 15:45:50 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.213.54])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 17 Jan 2025 15:45:50 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Fri, 17 Jan 2025 21:15:49 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: kernel test robot <lkp@intel.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas
 Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan
 <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com
Subject: Re: [PATCH v2 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv
 specific PMU
In-Reply-To: <202501171030.3x0gqW8G-lkp@intel.com>
References: <20250115143948.369379-5-vaibhav@linux.ibm.com>
 <202501171030.3x0gqW8G-lkp@intel.com>
Date: Fri, 17 Jan 2025 21:15:49 +0530
Message-ID: <87zfjpfnpu.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _iqpKkcXATZ7EQwhnF6QjJJQQHuLyUaA
X-Proofpoint-GUID: ntbkbz3ndUoZhF4YF4PHpDcoQgNI3bXQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 impostorscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501170122


Thanks for catching this build warning kernel-test-robot. I will
spin-off a v3 fixing this.

kernel test robot <lkp@intel.com> writes:

> Hi Vaibhav,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on powerpc/topic/ppc-kvm]
> [also build test WARNING on powerpc/next powerpc/fixes kvm/queue kvm/next mst-vhost/linux-next linus/master v6.13-rc7 next-20250116]
> [cannot apply to kvm/linux-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Vaibhav-Jain/powerpc-Document-APIv2-KVM-hcall-spec-for-Hostwide-counters/20250116-024240
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
> patch link:    https://lore.kernel.org/r/20250115143948.369379-5-vaibhav%40linux.ibm.com
> patch subject: [PATCH v2 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv specific PMU
> config: powerpc-allnoconfig (https://download.01.org/0day-ci/archive/20250117/202501171030.3x0gqW8G-lkp@intel.com/config)
> compiler: powerpc-linux-gcc (GCC) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250117/202501171030.3x0gqW8G-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202501171030.3x0gqW8G-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    In file included from arch/powerpc/include/asm/kvm_ppc.h:22,
>                     from arch/powerpc/include/asm/dbell.h:17,
>                     from arch/powerpc/kernel/asm-offsets.c:36:
>>> arch/powerpc/include/asm/kvm_book3s.h:357:13: warning: 'kvmppc_unregister_pmu' defined but not used [-Wunused-function]
>      357 | static void kvmppc_unregister_pmu(void)
>          |             ^~~~~~~~~~~~~~~~~~~~~
>>> arch/powerpc/include/asm/kvm_book3s.h:352:12: warning: 'kvmppc_register_pmu' defined but not used [-Wunused-function]
>      352 | static int kvmppc_register_pmu(void)
>          |            ^~~~~~~~~~~~~~~~~~~
> --
>    In file included from arch/powerpc/include/asm/kvm_ppc.h:22,
>                     from arch/powerpc/include/asm/dbell.h:17,
>                     from arch/powerpc/kernel/asm-offsets.c:36:
>>> arch/powerpc/include/asm/kvm_book3s.h:357:13: warning: 'kvmppc_unregister_pmu' defined but not used [-Wunused-function]
>      357 | static void kvmppc_unregister_pmu(void)
>          |             ^~~~~~~~~~~~~~~~~~~~~
>>> arch/powerpc/include/asm/kvm_book3s.h:352:12: warning: 'kvmppc_register_pmu' defined but not used [-Wunused-function]
>      352 | static int kvmppc_register_pmu(void)
>          |            ^~~~~~~~~~~~~~~~~~~
>
>
> vim +/kvmppc_unregister_pmu +357 arch/powerpc/include/asm/kvm_book3s.h
>
>    351	
>  > 352	static int kvmppc_register_pmu(void)
>    353	{
>    354		return 0;
>    355	}
>    356	
>  > 357	static void kvmppc_unregister_pmu(void)
>    358	{
>    359	}
>    360	
>
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

-- 
Cheers
~ Vaibhav

