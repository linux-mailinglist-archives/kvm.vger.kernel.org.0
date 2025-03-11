Return-Path: <kvm+bounces-40759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A64DEA5BCE3
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 10:54:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D01F31898394
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 09:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63BD822DFBB;
	Tue, 11 Mar 2025 09:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jrmGrWJ2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B883622B8A5;
	Tue, 11 Mar 2025 09:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741686873; cv=none; b=sT1wmhRSZpJqhC39QFoI7ZEO8tuuMRyGVHM7LlLufmE0iYwNMLTjDoDZz2eYXzoEvGOB2V7bibUXabJFYFbBboBdaFm2cuxq5q9a8juinELXkym445Iy7Leenhey3153fyqB0RhLxu+y7xgLt4//E24cIyBqyr7PNB7JO4Mabj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741686873; c=relaxed/simple;
	bh=J3SDCWfDn129im/t+dJeqRcrxJZNa7WgD+pqZgNycSE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=STx7BO7uJ7a94J23tFonT3uX7wbERGFX2F7HQnyFFnr0cpBZJvLBY74CNFsddRLr78pV0QPYOkJzSJulDFN7nRkmBUHhxw+qpNTvKy8ETSDVbBApftuGcjL7JvrFcL5FarIaJzNp76dlvh1sZsB78i8y3qg0M+5qJnGQMdAkZ34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jrmGrWJ2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52B7tx54004745;
	Tue, 11 Mar 2025 09:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/DIkiA
	1y3b3BeMSQwdDxisMeDsiK/ud30bXWYI3WYds=; b=jrmGrWJ2IC40DdQVtyBFTY
	/BS804AIqFARkdATfwWQY+GHEFkDSPWjtB9OYA1TriZ3nUTsObYTy4dEv+0QdJgJ
	DW2Qp//KDYMOv8WV7maN9Fhlz4x6yFhLpGDJU3ejnzwbyVa0D8pwqX/10bckf8/0
	V4p6uIfQPGXWWgT+qIblBWZsl/icLGCkmBCAktR8Bbr/GbA9G58wL+sPiuxijZNa
	CUg7ecDh92m9YO2d2UY08HyBFnXhNVIrSiBdJEtKdeTsjWDp5VCWw/hmWR9lHuyQ
	04FDjLeiuQHjKX+oxY2NIWUD45vJhWJGQ31uBfoEoUB45nmlDXDTL3vXYs2NFvaw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45a78qu1uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 09:54:19 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 52B9s3Q2015191;
	Tue, 11 Mar 2025 09:54:18 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45a78qu1ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 09:54:18 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52B7X8TG014921;
	Tue, 11 Mar 2025 09:54:18 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4592ekb76k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 09:54:18 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52B9sEhR34275834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 09:54:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A082E20043;
	Tue, 11 Mar 2025 09:54:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B3FC20040;
	Tue, 11 Mar 2025 09:54:09 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.61.245.182])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 11 Mar 2025 09:54:08 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v4 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv
 specific PMU
From: Athira Rajeev <atrajeev@linux.ibm.com>
In-Reply-To: <87r035tl4s.fsf@vajain21.in.ibm.com>
Date: Tue, 11 Mar 2025 15:23:55 +0530
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DE5EF999-8B8A-4026-838B-05E10CB79453@linux.ibm.com>
References: <20250224131522.77104-1-vaibhav@linux.ibm.com>
 <20250224131522.77104-5-vaibhav@linux.ibm.com>
 <BF8AA073-AEBD-4B4A-9C1E-970942C29345@linux.ibm.com>
 <87r035tl4s.fsf@vajain21.in.ibm.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>
X-Mailer: Apple Mail (2.3776.700.51)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A9KAmDCsgnY-uET_IA6-KO9iDTQq_fv9
X-Proofpoint-ORIG-GUID: teLtUHA1mSR-cTo59w_pPNG1-V8FN2xI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2503110064



> On 10 Mar 2025, at 12:42=E2=80=AFPM, Vaibhav Jain =
<vaibhav@linux.ibm.com> wrote:
>=20
> Athira Rajeev <atrajeev@linux.ibm.com> writes:
>=20
>>> On 24 Feb 2025, at 6:45=E2=80=AFPM, Vaibhav Jain =
<vaibhav@linux.ibm.com> wrote:
>>>=20
>>> Introduce a new PMU named 'kvm-hv' inside a new module named =
'kvm-hv-pmu'
>>> to report Book3s kvm-hv specific performance counters. This will =
expose
>>> KVM-HV specific performance attributes to user-space via kernel's =
PMU
>>> infrastructure and would enableusers to monitor active kvm-hv based =
guests.
>>>=20
>>> The patch creates necessary scaffolding to for the new PMU callbacks =
and
>>> introduces the new kernel module name 'kvm-hv-pmu' which is built =
with
>>> CONFIG_KVM_BOOK3S_HV_PMU. The patch doesn't introduce any =
perf-events yet,
>>> which will be introduced in later patches
>>>=20
>>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>>>=20
>>> ---
>>> Changelog
>>>=20
>>> v3->v4:
>>> * Introduced a new kernel module named 'kmv-hv-pmu' to host the new =
PMU
>>> instead of building the as part of KVM-HV module. [ Maddy ]
>>> * Moved the code from arch/powerpc/kvm to arch/powerpc/perf [ =
Atheera ]
>>> * Added a new config named KVM_BOOK3S_HV_PMU to =
arch/powerpc/kvm/Kconfig
>>>=20
>>> v2->v3:
>>> * Fixed a build warning reported by kernel build robot.
>>> Link:
>>> =
https://lore.kernel.org/oe-kbuild-all/202501171030.3x0gqW8G-lkp@intel.com
>>>=20
>>> v1->v2:
>>> * Fixed an issue of kvm-hv not loading on baremetal kvm [Gautam]
>>> ---
>>> arch/powerpc/kvm/Kconfig       |  13 ++++
>>> arch/powerpc/perf/Makefile     |   2 +
>>> arch/powerpc/perf/kvm-hv-pmu.c | 138 =
+++++++++++++++++++++++++++++++++
>>> 3 files changed, 153 insertions(+)
>>> create mode 100644 arch/powerpc/perf/kvm-hv-pmu.c
>>>=20
>>> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
>>> index dbfdc126bf14..5f0ce19e7e27 100644
>>> --- a/arch/powerpc/kvm/Kconfig
>>> +++ b/arch/powerpc/kvm/Kconfig
>>> @@ -83,6 +83,7 @@ config KVM_BOOK3S_64_HV
>>> depends on KVM_BOOK3S_64 && PPC_POWERNV
>>> select KVM_BOOK3S_HV_POSSIBLE
>>> select KVM_GENERIC_MMU_NOTIFIER
>>> + select KVM_BOOK3S_HV_PMU
>>> select CMA
>>> help
>>> Support running unmodified book3s_64 guest kernels in
>>> @@ -171,6 +172,18 @@ config KVM_BOOK3S_HV_NESTED_PMU_WORKAROUND
>>> those buggy L1s which saves the L2 state, at the cost of performance
>>> in all nested-capable guest entry/exit.
>>>=20
>>> +config KVM_BOOK3S_HV_PMU
>>> + tristate "Hypervisor Perf events for KVM Book3s-HV"
>>> + depends on KVM_BOOK3S_64_HV && HV_PERF_CTRS
>>> + help
>>> +  Enable Book3s-HV Hypervisor Perf events PMU named 'kvm-hv'. These
>>> +  Perf events give an overview of hypervisor performance overall
>>> +  instead of a specific guests. Currently the PMU reports
>>> +  L0-Hypervisor stats on a kvm-hv enabled PSeries LPAR like:
>>> +  * Total/Used Guest-Heap
>>> +  * Total/Used Guest Page-table Memory
>>> +  * Total amount of Guest Page-table Memory reclaimed
>>> +
>>> config KVM_BOOKE_HV
>>> bool
>>>=20
>>> diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
>>> index ac2cf58d62db..7f53fcb7495a 100644
>>> --- a/arch/powerpc/perf/Makefile
>>> +++ b/arch/powerpc/perf/Makefile
>>> @@ -18,6 +18,8 @@ obj-$(CONFIG_HV_PERF_CTRS) +=3D hv-24x7.o =
hv-gpci.o hv-common.o
>>>=20
>>> obj-$(CONFIG_VPA_PMU) +=3D vpa-pmu.o
>>>=20
>>> +obj-$(CONFIG_KVM_BOOK3S_HV_PMU) +=3D kvm-hv-pmu.o
>>> +
>>> obj-$(CONFIG_PPC_8xx) +=3D 8xx-pmu.o
>>>=20
>>> obj-$(CONFIG_PPC64) +=3D $(obj64-y)
>>> diff --git a/arch/powerpc/perf/kvm-hv-pmu.c =
b/arch/powerpc/perf/kvm-hv-pmu.c
>>> new file mode 100644
>>> index 000000000000..c154f54e09e2
>>> --- /dev/null
>>> +++ b/arch/powerpc/perf/kvm-hv-pmu.c
>>> @@ -0,0 +1,138 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Description: PMUs specific to running nested KVM-HV guests
>>> + * on Book3S processors (specifically POWER9 and later).
>>> + */
>>> +
>>> +#define pr_fmt(fmt)  "kvmppc-pmu: " fmt
>>> +
>>> +#include "asm-generic/local64.h"
>>> +#include <linux/kernel.h>
>>> +#include <linux/errno.h>
>>> +#include <linux/ratelimit.h>
>>> +#include <linux/kvm_host.h>
>>> +#include <linux/gfp_types.h>
>>> +#include <linux/pgtable.h>
>>> +#include <linux/perf_event.h>
>>> +#include <linux/spinlock_types.h>
>>> +#include <linux/spinlock.h>
>>> +
>>> +#include <asm/types.h>
>>> +#include <asm/kvm_ppc.h>
>>> +#include <asm/kvm_book3s.h>
>>> +#include <asm/mmu.h>
>>> +#include <asm/pgalloc.h>
>>> +#include <asm/pte-walk.h>
>>> +#include <asm/reg.h>
>>> +#include <asm/plpar_wrappers.h>
>>> +#include <asm/firmware.h>
>>> +
>>> +enum kvmppc_pmu_eventid {
>>> + KVMPPC_EVENT_MAX,
>>> +};
>>> +
>>> +static struct attribute *kvmppc_pmu_events_attr[] =3D {
>>> + NULL,
>>> +};
>>> +
>>> +static const struct attribute_group kvmppc_pmu_events_group =3D {
>>> + .name =3D "events",
>>> + .attrs =3D kvmppc_pmu_events_attr,
>>> +};
>>> +
>>> +PMU_FORMAT_ATTR(event, "config:0");
>>> +static struct attribute *kvmppc_pmu_format_attr[] =3D {
>>> + &format_attr_event.attr,
>>> + NULL,
>>> +};
>>> +
>>> +static struct attribute_group kvmppc_pmu_format_group =3D {
>>> + .name =3D "format",
>>> + .attrs =3D kvmppc_pmu_format_attr,
>>> +};
>>> +
>>> +static const struct attribute_group *kvmppc_pmu_attr_groups[] =3D {
>>> + &kvmppc_pmu_events_group,
>>> + &kvmppc_pmu_format_group,
>>> + NULL,
>>> +};
>>> +
>>> +static int kvmppc_pmu_event_init(struct perf_event *event)
>>> +{
>>> + unsigned int config =3D event->attr.config;
>>> +
>>> + pr_debug("%s: Event(%p) id=3D%llu cpu=3D%x on_cpu=3D%x config=3D%u",=

>>> + __func__, event, event->id, event->cpu,
>>> + event->oncpu, config);
>>> +
>>> + if (event->attr.type !=3D event->pmu->type)
>>> + return -ENOENT;
>>> +
>>> + if (config >=3D KVMPPC_EVENT_MAX)
>>> + return -EINVAL;
>>> +
>>> + local64_set(&event->hw.prev_count, 0);
>>> + local64_set(&event->count, 0);
>>> +
>>> + return 0;
>>> +}
>>> +
>>> +static void kvmppc_pmu_del(struct perf_event *event, int flags)
>>> +{
>>> +}
>>> +
>>> +static int kvmppc_pmu_add(struct perf_event *event, int flags)
>>> +{
>>> + return 0;
>>> +}
>>> +
>>> +static void kvmppc_pmu_read(struct perf_event *event)
>>> +{
>>> +}
>>> +
>>> +/* L1 wide counters PMU */
>>> +static struct pmu kvmppc_pmu =3D {
>>> + .module =3D THIS_MODULE,
>>> + .task_ctx_nr =3D perf_sw_context,
>>> + .name =3D "kvm-hv",
>>> + .event_init =3D kvmppc_pmu_event_init,
>>> + .add =3D kvmppc_pmu_add,
>>> + .del =3D kvmppc_pmu_del,
>>> + .read =3D kvmppc_pmu_read,
>>> + .attr_groups =3D kvmppc_pmu_attr_groups,
>>> + .type =3D -1,
>>> +};
>>> +
>>> +static int __init kvmppc_register_pmu(void)
>>> +{
>>> + int rc =3D -EOPNOTSUPP;
>>> +
>>> + /* only support events for nestedv2 right now */
>>> + if (kvmhv_is_nestedv2()) {
>>=20
>> We don=E2=80=99t need PVR check here ? Description of module says =
this is
>> supported for power9 and later.
> The hcalls this module depends on, are only available to =
LPAR/KVM-Guest running with api-v2 support hence this is needed.
Ok, I understand we need kvmhv_is_nestedv2()
Doubt is whether we need PVR check here.

>=20
>>> + /* Setup done now register the PMU */
>>> + pr_info("Registering kvm-hv pmu");
>>> +
>>> + /* Register only if we arent already registered */
>> Not sure why we need this=E2=80=A6 Have you seen any issue without =
this ? I don=E2=80=99t see any similar check in =
arch/powerpc/perf/vpa-pmu.c ,
>>=20
> This check is taken from the previous version of this patch which
> prevented struct pmu initialization multiple times. However with
> now a seperate module this check is probably not needed.

Sure, Please check and remove if this is not needed.

Thanks
Athira
>=20
>>> + rc =3D (kvmppc_pmu.type =3D=3D -1) ?
>>> +     perf_pmu_register(&kvmppc_pmu, kvmppc_pmu.name,
>>> +       -1) : 0;
>>> + }
>>> +
>>> + return rc;
>>> +}
>>> +
>>> +static void __exit kvmppc_unregister_pmu(void)
>>> +{
>>> + if (kvmhv_is_nestedv2()) {
>>> + if (kvmppc_pmu.type !=3D -1)
>>> + perf_pmu_unregister(&kvmppc_pmu);
>>> +
>>> + pr_info("kvmhv_pmu unregistered.\n");
>>> + }
>>> +}
>>> +
>>> +module_init(kvmppc_register_pmu);
>>> +module_exit(kvmppc_unregister_pmu);
>>> +MODULE_DESCRIPTION("KVM PPC Book3s-hv PMU");
>>> +MODULE_AUTHOR("Vaibhav Jain <vaibhav@linux.ibm.com>");
>>> +MODULE_LICENSE("GPL");
>>> --=20
>>> 2.48.1
>>>=20
>>>=20
>>>=20
>>=20
>=20
> --=20
> Cheers
> ~ Vaibhav



