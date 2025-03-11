Return-Path: <kvm+bounces-40755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32999A5BC56
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 10:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6507A174D76
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 09:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3127225A31;
	Tue, 11 Mar 2025 09:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tSK4mao4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842821E2312;
	Tue, 11 Mar 2025 09:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741685548; cv=none; b=ppH3MlX/9AfCkCCSbCC+ZKUGt520K4Im6i5Rfi/B91gu7M7uyCIUQTyLI/TzBgk5BtqmTlumquo6IjRlaVFk0RYgVldVsLehAiWChfNrubMe+9rYFiMw6o9PWRUqceyZTm1EeCvfE2BU7ZfUaKFF/lYy6wyUXvjpsFGaxp+TiIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741685548; c=relaxed/simple;
	bh=86NBFuRadsVUmel+UiOUBCdQv1HrG0o3+CvP/y7JgRk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=V6xb/vnMbzxmwU8W2+/yMfzk+5yzAXfXeWzFEXqKp/fQjUVQTsYSygi0DC7YIHPgji5OuXABP6PDXgvf8xCchdL0CpenloQWYLZo5Wdfow4bRx/aANJKFEJ3Ri6n5i0aiSuoxrBQcP2Il7RfdSWg9h2t3VsY9qvx1ID7+Mrkdp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tSK4mao4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52B7oCeA015900;
	Tue, 11 Mar 2025 09:32:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=86NBFu
	RadsVUmel+UiOUBCdQv1HrG0o3+CvP/y7JgRk=; b=tSK4mao4KUwoOmAjNnVRSd
	metRAR4FyJ8ev6EFsKuva3J59LXbycP4ibjfxxpCODbCNN0bmJzun5tQkAXMmC8A
	JnEGR9QfDu9oa3PEct3prjLz0324Lu3hGzv/6pewsgYqg2rNih6+06whS7NA1zmV
	k9yn6ZNv5F+R5ULJh5s6XH8q+T7QstjSOoVX+FcN7/ECA44iYU7mu8Egf138U2oZ
	XlxAkYGEypf14AdOR9mby9tpgCv/4aawj3P5eUhO2TrN+OlCzBdd7Saqn1KS1gAd
	AtpVWqqgc7UIZghKaGj1rpVZWUU/e2Y1nQrz+4SNwe4kIS/9fCy6Ow+U0GRR75UQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45a1gp544n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 09:32:16 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 52B8rPk4008649;
	Tue, 11 Mar 2025 09:32:16 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45a1gp544f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 09:32:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52B6Sdi8022265;
	Tue, 11 Mar 2025 09:32:15 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45917nbddd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Mar 2025 09:32:15 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52B9WBTr39584246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 09:32:11 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BD1D20043;
	Tue, 11 Mar 2025 09:32:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DE6520040;
	Tue, 11 Mar 2025 09:32:07 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.19.180])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 11 Mar 2025 09:32:07 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Tue, 11 Mar 2025 15:02:06 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin
 <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 6/6] powerpc/kvm-hv-pmu: Add perf-events for Hostwide
 counters
In-Reply-To: <96795462-3AFA-4C90-9E63-ACB9AE3E66EE@linux.ibm.com>
References: <20250224131522.77104-1-vaibhav@linux.ibm.com>
 <20250224131522.77104-7-vaibhav@linux.ibm.com>
 <96795462-3AFA-4C90-9E63-ACB9AE3E66EE@linux.ibm.com>
Date: Tue, 11 Mar 2025 15:02:06 +0530
Message-ID: <87ikofud49.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SZrUU42cdm-4ApI_3zxQkdoYvz_n9hD6
X-Proofpoint-ORIG-GUID: M5TteZ_w2XWaQS51ysCBLLkWMb8Nzryi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 suspectscore=0 spamscore=0 impostorscore=0 bulkscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503110064

Athira Rajeev <atrajeev@linux.ibm.com> writes:

>> On 24 Feb 2025, at 6:45=E2=80=AFPM, Vaibhav Jain <vaibhav@linux.ibm.com>=
 wrote:
>>=20
>> Update 'kvm-hv-pmu.c' to add five new perf-events mapped to the five
>> Hostwide counters. Since these newly introduced perf events are at system
>> wide scope and can be read from any L1-Lpar CPU, 'kvmppc_pmu' scope and
>> capabilities are updated appropriately.
>>=20
>> Also introduce two new helpers. First is kvmppc_update_l0_stats() that u=
ses
>> the infrastructure introduced in previous patches to issues the
>> H_GUEST_GET_STATE hcall L0-PowerVM to fetch guest-state-buffer holding t=
he
>> latest values of these counters which is then parsed and 'l0_stats'
>> variable updated.
>>=20
>> Second helper is kvmppc_pmu_event_update() which is called from
>> 'kvmppv_pmu' callbacks and uses kvmppc_update_l0_stats() to update
>> 'l0_stats' and the update the 'struct perf_event's event-counter.
>>=20
>> Some minor updates to kvmppc_pmu_{add, del, read}() to remove some debug
>> scaffolding code.
>>=20
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> ---
>> Changelog
>>=20
>> v3->v4:
>> * Minor tweaks to patch description and code as its now being built as a
>> separate kernel module.
>>=20
>> v2->v3:
>> None
>>=20
>> v1->v2:
>> None
>> ---
>> arch/powerpc/perf/kvm-hv-pmu.c | 92 +++++++++++++++++++++++++++++++++-
>> 1 file changed, 91 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/arch/powerpc/perf/kvm-hv-pmu.c b/arch/powerpc/perf/kvm-hv-p=
mu.c
>> index ed371454f7b5..274459bb32d6 100644
>> --- a/arch/powerpc/perf/kvm-hv-pmu.c
>> +++ b/arch/powerpc/perf/kvm-hv-pmu.c
>> @@ -30,6 +30,11 @@
>> #include "asm/guest-state-buffer.h"
>>=20
>> enum kvmppc_pmu_eventid {
>> + KVMPPC_EVENT_HOST_HEAP,
>> + KVMPPC_EVENT_HOST_HEAP_MAX,
>> + KVMPPC_EVENT_HOST_PGTABLE,
>> + KVMPPC_EVENT_HOST_PGTABLE_MAX,
>> + KVMPPC_EVENT_HOST_PGTABLE_RECLAIM,
>> KVMPPC_EVENT_MAX,
>> };
>>=20
>> @@ -61,8 +66,14 @@ static DEFINE_SPINLOCK(lock_l0_stats);
>> /* GSB related structs needed to talk to L0 */
>> static struct kvmppc_gs_msg *gsm_l0_stats;
>> static struct kvmppc_gs_buff *gsb_l0_stats;
>> +static struct kvmppc_gs_parser gsp_l0_stats;
>>=20
>> static struct attribute *kvmppc_pmu_events_attr[] =3D {
>> + KVMPPC_PMU_EVENT_ATTR(host_heap, KVMPPC_EVENT_HOST_HEAP),
>> + KVMPPC_PMU_EVENT_ATTR(host_heap_max, KVMPPC_EVENT_HOST_HEAP_MAX),
>> + KVMPPC_PMU_EVENT_ATTR(host_pagetable, KVMPPC_EVENT_HOST_PGTABLE),
>> + KVMPPC_PMU_EVENT_ATTR(host_pagetable_max, KVMPPC_EVENT_HOST_PGTABLE_MA=
X),
>> + KVMPPC_PMU_EVENT_ATTR(host_pagetable_reclaim, KVMPPC_EVENT_HOST_PGTABL=
E_RECLAIM),
>> NULL,
>> };
>>=20
>> @@ -71,7 +82,7 @@ static const struct attribute_group kvmppc_pmu_events_=
group =3D {
>> .attrs =3D kvmppc_pmu_events_attr,
>> };
>>=20
>> -PMU_FORMAT_ATTR(event, "config:0");
>> +PMU_FORMAT_ATTR(event, "config:0-5");
>> static struct attribute *kvmppc_pmu_format_attr[] =3D {
>> &format_attr_event.attr,
>> NULL,
>> @@ -88,6 +99,79 @@ static const struct attribute_group *kvmppc_pmu_attr_=
groups[] =3D {
>> NULL,
>> };
>>=20
>> +/*
>> + * Issue the hcall to get the L0-host stats.
>> + * Should be called with l0-stat lock held
>> + */
>> +static int kvmppc_update_l0_stats(void)
>> +{
>> + int rc;
>> +
>> + /* With HOST_WIDE flags guestid and vcpuid will be ignored */
>> + rc =3D kvmppc_gsb_recv(gsb_l0_stats, KVMPPC_GS_FLAGS_HOST_WIDE);
>> + if (rc)
>> + goto out;
>> +
>> + /* Parse the guest state buffer is successful */
>> + rc =3D kvmppc_gse_parse(&gsp_l0_stats, gsb_l0_stats);
>> + if (rc)
>> + goto out;
>> +
>> + /* Update the l0 returned stats*/
>> + memset(&l0_stats, 0, sizeof(l0_stats));
>> + rc =3D kvmppc_gsm_refresh_info(gsm_l0_stats, gsb_l0_stats);
>> +
>> +out:
>> + return rc;
>> +}
>> +
>> +/* Update the value of the given perf_event */
>> +static int kvmppc_pmu_event_update(struct perf_event *event)
>> +{
>> + int rc;
>> + u64 curr_val, prev_val;
>> + unsigned long flags;
>> + unsigned int config =3D event->attr.config;
>> +
>> + /* Ensure no one else is modifying the l0_stats */
>> + spin_lock_irqsave(&lock_l0_stats, flags);
>> +
>> + rc =3D kvmppc_update_l0_stats();
>> + if (!rc) {
>> + switch (config) {
>> + case KVMPPC_EVENT_HOST_HEAP:
>> + curr_val =3D l0_stats.guest_heap;
>> + break;
>> + case KVMPPC_EVENT_HOST_HEAP_MAX:
>> + curr_val =3D l0_stats.guest_heap_max;
>> + break;
>> + case KVMPPC_EVENT_HOST_PGTABLE:
>> + curr_val =3D l0_stats.guest_pgtable_size;
>> + break;
>> + case KVMPPC_EVENT_HOST_PGTABLE_MAX:
>> + curr_val =3D l0_stats.guest_pgtable_size_max;
>> + break;
>> + case KVMPPC_EVENT_HOST_PGTABLE_RECLAIM:
>> + curr_val =3D l0_stats.guest_pgtable_reclaim;
>> + break;
>> + default:
>> + rc =3D -ENOENT;
>> + break;
>> + }
>> + }
>> +
>> + spin_unlock_irqrestore(&lock_l0_stats, flags);
>> +
>> + /* If no error than update the perf event */
>> + if (!rc) {
>> + prev_val =3D local64_xchg(&event->hw.prev_count, curr_val);
>> + if (curr_val > prev_val)
>> + local64_add(curr_val - prev_val, &event->count);
>> + }
>> +
>> + return rc;
>> +}
>> +
>> static int kvmppc_pmu_event_init(struct perf_event *event)
>> {
>> unsigned int config =3D event->attr.config;
>> @@ -110,15 +194,19 @@ static int kvmppc_pmu_event_init(struct perf_event=
 *event)
>>=20
>> static void kvmppc_pmu_del(struct perf_event *event, int flags)
>> {
>> + /* Do nothing */
>> }
>
> If we don=E2=80=99t read the counter stats in =E2=80=9Cdel=E2=80=9D call =
back, we will loose the final count getting updated, right ?
> Del callback needs to call kvmppc_pmu_read. Can you check the difference =
in count stats by calling kvmppc_pmu_read here ?
>

Yes, agreed. Will address this in next version of the patch series

> Thanks
> Athira
>
>>=20
>> static int kvmppc_pmu_add(struct perf_event *event, int flags)
>> {
>> + if (flags & PERF_EF_START)
>> + return kvmppc_pmu_event_update(event);
>> return 0;
>> }
>>=20
>> static void kvmppc_pmu_read(struct perf_event *event)
>> {
>> + kvmppc_pmu_event_update(event);
>> }
>>=20
>> /* Return the size of the needed guest state buffer */
>> @@ -302,6 +390,8 @@ static struct pmu kvmppc_pmu =3D {
>> .read =3D kvmppc_pmu_read,
>> .attr_groups =3D kvmppc_pmu_attr_groups,
>> .type =3D -1,
>> + .scope =3D PERF_PMU_SCOPE_SYS_WIDE,
>> + .capabilities =3D PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
>> };
>>=20
>> static int __init kvmppc_register_pmu(void)
>> --=20
>> 2.48.1
>>=20
>>=20
>>=20
>
>

--=20
Cheers
~ Vaibhav

