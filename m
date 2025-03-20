Return-Path: <kvm+bounces-41547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF4BA6A24C
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 10:15:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADD221898499
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 09:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59826219A67;
	Thu, 20 Mar 2025 09:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QfpC0FH+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44B91EDA27;
	Thu, 20 Mar 2025 09:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742462111; cv=none; b=LpSSnOC9htVpj6CEytY0jUuTWImo0SP/hCY7bcqlsj6VXsojHM8dRQ2ucEEMRd7sAvxBdyTj4kMJRLO2r2pmoExKZ/yuoemJJBSn/eftvEGCADXcDL9bjHhUpsi1AThsXdFIHcZZQsI/TYU9MAm7lm4nCQD7yI4OwLX994UxbxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742462111; c=relaxed/simple;
	bh=9c2KsvgWRUAPh6owXxe+tla9TE3unmNvI9VT56yT0Os=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=pjt2KL7kF/6E4q09FvSvKO5pbU759WZaTkXsSbhDHP+g7OjtxnjfJQGTNOa1zPSr2hn/pY/GlxKRsFtffqVKuGhWaIzsCqibW8V5xgGQ3cCmGZJ6UdMecGEDFGZMHN2vA14TMaiMuO/SQcSatfVY/m6rQEC88EFe1z2EZSr2lmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QfpC0FH+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52K7fQNe011884;
	Thu, 20 Mar 2025 09:14:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9c2Ksv
	gWRUAPh6owXxe+tla9TE3unmNvI9VT56yT0Os=; b=QfpC0FH+oLXEmDJ7ijoOC5
	X0+ZTGDj74UVPjiTFsRTDKhzyz0758mv6lVTNWW3Omqfjwu5nxLaTHHZXsMXgDrG
	6kZL7DR7T+1n0I0+5/1RPtHRkocQExjVCkjZYzq72bMlZNjyoTsawRlVgMVUYDqo
	lQJdvz75buqQlKu9ddtYBOJUuwBfhWNV9AkiEFYBEa0R8BCDpKvHlDRqILSclwtg
	TnX54T3lOXwTj8bojvQz8JTyAplpwfncHZWm3wX5luz88cGKIW9SUgUhKbPGvMVz
	xlR0V8gfuX7tAzNqLlvFSjqHkkLtkAYu/zkEklnxI2Wh+MBVqcQ3nJuGg7TeS72A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45fwy25wf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Mar 2025 09:14:58 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 52K9EhAn032342;
	Thu, 20 Mar 2025 09:14:58 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45fwy25wf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Mar 2025 09:14:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52K85Xkm012350;
	Thu, 20 Mar 2025 09:14:57 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45dmvp72x0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Mar 2025 09:14:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52K9ErZt40829334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Mar 2025 09:14:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1479C20043;
	Thu, 20 Mar 2025 09:14:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2374320040;
	Thu, 20 Mar 2025 09:14:45 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.61.250.131])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 20 Mar 2025 09:14:44 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v5 6/6] powerpc/kvm-hv-pmu: Add perf-events for Hostwide
 counters
From: Athira Rajeev <atrajeev@linux.ibm.com>
In-Reply-To: <20250317100834.451452-7-vaibhav@linux.ibm.com>
Date: Thu, 20 Mar 2025 14:44:30 +0530
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B0FA3AB4-52CA-4DBB-8F7E-3838CB0F400F@linux.ibm.com>
References: <20250317100834.451452-1-vaibhav@linux.ibm.com>
 <20250317100834.451452-7-vaibhav@linux.ibm.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>
X-Mailer: Apple Mail (2.3776.700.51)
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vcMmGWK0zxr2Q04aSx4ooKAc3JvORBac
X-Proofpoint-GUID: 3FFBHcuvPudiFgRqQdh3EgPhbqmjLEj6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_03,2025-03-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503200053



> On 17 Mar 2025, at 3:38=E2=80=AFPM, Vaibhav Jain =
<vaibhav@linux.ibm.com> wrote:
>=20
> Update 'kvm-hv-pmu.c' to add five new perf-events mapped to the five
> Hostwide counters. Since these newly introduced perf events are at =
system
> wide scope and can be read from any L1-Lpar CPU, 'kvmppc_pmu' scope =
and
> capabilities are updated appropriately.
>=20
> Also introduce two new helpers. First is kvmppc_update_l0_stats() that =
uses
> the infrastructure introduced in previous patches to issues the
> H_GUEST_GET_STATE hcall L0-PowerVM to fetch guest-state-buffer holding =
the
> latest values of these counters which is then parsed and 'l0_stats'
> variable updated.
>=20
> Second helper is kvmppc_pmu_event_update() which is called from
> 'kvmppv_pmu' callbacks and uses kvmppc_update_l0_stats() to update
> 'l0_stats' and the update the 'struct perf_event's event-counter.
>=20
> Some minor updates to kvmppc_pmu_{add, del, read}() to remove some =
debug
> scaffolding code.
>=20
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

Thanks Vaibhav for including the changes in V5. Changes looks good to me =
in patches for perf events.

Reviewed-by: Athira Rajeev <atrajeev@linux.ibm.com>

Thanks
Athira
> ---
> Changelog
>=20
> v4->v5:
> * Call kvmppc_pmu_event_update() during pmu's 'del()' callback [ =
Atheera ]
>=20
> v3->v4:
> * Minor tweaks to patch description and code as its now being built as =
a
> separate kernel module.
>=20
> v2->v3:
> None
>=20
> v1->v2:
> None
> ---
> arch/powerpc/perf/kvm-hv-pmu.c | 92 +++++++++++++++++++++++++++++++++-
> 1 file changed, 91 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/perf/kvm-hv-pmu.c =
b/arch/powerpc/perf/kvm-hv-pmu.c
> index 705be24ccb43..ae264c9080ef 100644
> --- a/arch/powerpc/perf/kvm-hv-pmu.c
> +++ b/arch/powerpc/perf/kvm-hv-pmu.c
> @@ -30,6 +30,11 @@
> #include "asm/guest-state-buffer.h"
>=20
> enum kvmppc_pmu_eventid {
> + KVMPPC_EVENT_HOST_HEAP,
> + KVMPPC_EVENT_HOST_HEAP_MAX,
> + KVMPPC_EVENT_HOST_PGTABLE,
> + KVMPPC_EVENT_HOST_PGTABLE_MAX,
> + KVMPPC_EVENT_HOST_PGTABLE_RECLAIM,
> KVMPPC_EVENT_MAX,
> };
>=20
> @@ -61,8 +66,14 @@ static DEFINE_SPINLOCK(lock_l0_stats);
> /* GSB related structs needed to talk to L0 */
> static struct kvmppc_gs_msg *gsm_l0_stats;
> static struct kvmppc_gs_buff *gsb_l0_stats;
> +static struct kvmppc_gs_parser gsp_l0_stats;
>=20
> static struct attribute *kvmppc_pmu_events_attr[] =3D {
> + KVMPPC_PMU_EVENT_ATTR(host_heap, KVMPPC_EVENT_HOST_HEAP),
> + KVMPPC_PMU_EVENT_ATTR(host_heap_max, KVMPPC_EVENT_HOST_HEAP_MAX),
> + KVMPPC_PMU_EVENT_ATTR(host_pagetable, KVMPPC_EVENT_HOST_PGTABLE),
> + KVMPPC_PMU_EVENT_ATTR(host_pagetable_max, =
KVMPPC_EVENT_HOST_PGTABLE_MAX),
> + KVMPPC_PMU_EVENT_ATTR(host_pagetable_reclaim, =
KVMPPC_EVENT_HOST_PGTABLE_RECLAIM),
> NULL,
> };
>=20
> @@ -71,7 +82,7 @@ static const struct attribute_group =
kvmppc_pmu_events_group =3D {
> .attrs =3D kvmppc_pmu_events_attr,
> };
>=20
> -PMU_FORMAT_ATTR(event, "config:0");
> +PMU_FORMAT_ATTR(event, "config:0-5");
> static struct attribute *kvmppc_pmu_format_attr[] =3D {
> &format_attr_event.attr,
> NULL,
> @@ -88,6 +99,79 @@ static const struct attribute_group =
*kvmppc_pmu_attr_groups[] =3D {
> NULL,
> };
>=20
> +/*
> + * Issue the hcall to get the L0-host stats.
> + * Should be called with l0-stat lock held
> + */
> +static int kvmppc_update_l0_stats(void)
> +{
> + int rc;
> +
> + /* With HOST_WIDE flags guestid and vcpuid will be ignored */
> + rc =3D kvmppc_gsb_recv(gsb_l0_stats, KVMPPC_GS_FLAGS_HOST_WIDE);
> + if (rc)
> + goto out;
> +
> + /* Parse the guest state buffer is successful */
> + rc =3D kvmppc_gse_parse(&gsp_l0_stats, gsb_l0_stats);
> + if (rc)
> + goto out;
> +
> + /* Update the l0 returned stats*/
> + memset(&l0_stats, 0, sizeof(l0_stats));
> + rc =3D kvmppc_gsm_refresh_info(gsm_l0_stats, gsb_l0_stats);
> +
> +out:
> + return rc;
> +}
> +
> +/* Update the value of the given perf_event */
> +static int kvmppc_pmu_event_update(struct perf_event *event)
> +{
> + int rc;
> + u64 curr_val, prev_val;
> + unsigned long flags;
> + unsigned int config =3D event->attr.config;
> +
> + /* Ensure no one else is modifying the l0_stats */
> + spin_lock_irqsave(&lock_l0_stats, flags);
> +
> + rc =3D kvmppc_update_l0_stats();
> + if (!rc) {
> + switch (config) {
> + case KVMPPC_EVENT_HOST_HEAP:
> + curr_val =3D l0_stats.guest_heap;
> + break;
> + case KVMPPC_EVENT_HOST_HEAP_MAX:
> + curr_val =3D l0_stats.guest_heap_max;
> + break;
> + case KVMPPC_EVENT_HOST_PGTABLE:
> + curr_val =3D l0_stats.guest_pgtable_size;
> + break;
> + case KVMPPC_EVENT_HOST_PGTABLE_MAX:
> + curr_val =3D l0_stats.guest_pgtable_size_max;
> + break;
> + case KVMPPC_EVENT_HOST_PGTABLE_RECLAIM:
> + curr_val =3D l0_stats.guest_pgtable_reclaim;
> + break;
> + default:
> + rc =3D -ENOENT;
> + break;
> + }
> + }
> +
> + spin_unlock_irqrestore(&lock_l0_stats, flags);
> +
> + /* If no error than update the perf event */
> + if (!rc) {
> + prev_val =3D local64_xchg(&event->hw.prev_count, curr_val);
> + if (curr_val > prev_val)
> + local64_add(curr_val - prev_val, &event->count);
> + }
> +
> + return rc;
> +}
> +
> static int kvmppc_pmu_event_init(struct perf_event *event)
> {
> unsigned int config =3D event->attr.config;
> @@ -110,15 +194,19 @@ static int kvmppc_pmu_event_init(struct =
perf_event *event)
>=20
> static void kvmppc_pmu_del(struct perf_event *event, int flags)
> {
> + kvmppc_pmu_event_update(event);
> }
>=20
> static int kvmppc_pmu_add(struct perf_event *event, int flags)
> {
> + if (flags & PERF_EF_START)
> + return kvmppc_pmu_event_update(event);
> return 0;
> }
>=20
> static void kvmppc_pmu_read(struct perf_event *event)
> {
> + kvmppc_pmu_event_update(event);
> }
>=20
> /* Return the size of the needed guest state buffer */
> @@ -302,6 +390,8 @@ static struct pmu kvmppc_pmu =3D {
> .read =3D kvmppc_pmu_read,
> .attr_groups =3D kvmppc_pmu_attr_groups,
> .type =3D -1,
> + .scope =3D PERF_PMU_SCOPE_SYS_WIDE,
> + .capabilities =3D PERF_PMU_CAP_NO_EXCLUDE | =
PERF_PMU_CAP_NO_INTERRUPT,
> };
>=20
> static int __init kvmppc_register_pmu(void)
> --=20
> 2.48.1
>=20


