Return-Path: <kvm+bounces-42503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22362A79540
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:41:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B7203A6630
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0955B19E826;
	Wed,  2 Apr 2025 18:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DPZQkoa/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBEB1DB15F;
	Wed,  2 Apr 2025 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743619235; cv=fail; b=DR0mTW69fdUuB594G2SJddOMooY0FK6psQizieLOq5l8jZcxu6pY63zVUWujO38P5YuQ0oMjiHFAOKVUcAjnBJYI9ZimAyt/pPz9HV8tPpD34ra60UQik7Z/W17gpXu17ZNgJgxebLP50wyR0RwXvfZQZ1c4gXUP7+oThixJdfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743619235; c=relaxed/simple;
	bh=6V3ztiWqC6eJpbzK0GQGNWaON8ADIxASw5aUGaq8obU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=aVu9Os2cC+oLlGTGXuN1UcZtRw/8LsxBf8OFhgPvKCcR79gKmBqtBlnRag2sUTmpWkI6f/bMZLqgYrdblfuGFSmYyJDI8ynvY2yLPj6eLk/NtMSC4OO7/TzL666c207h+kKt5xQy4YTY0AjKriy+Fp9xsilwoEiTlGrXU35IRZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DPZQkoa/; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vyd4Ibd1XlKDxUtFqmW6iLY1ikolfQ0p1rF7p+8JH4jMPPkBD7D4pBkOxAjPPbiyJBJ6UCDHE2/PHjW4yY3aZevnmksNkL6CcQ/YyCU8oAwXRJ7bBK0d9CQG1yrlLfvpfpcBt9rZNF0Z71guOnl9tDx46VZTAM7oPsz0CeVHcIVQSp15jzK1fMAh3ibvXm8zt1naai5VJdFu0ARCJYfwGmLrlR1NUV5hSuXTFj+Pms3wWauDTui0wyVyf1wATiS6BXajgX793QgMbt7FpNTSi1s6DZNZ8IxEc43a60lkA7Msp3RB0HAsH69RdUrYGjRFfk3KzreSSCWrl6Ha8RDdSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZR40h/AG03DKumgJ8iw1gSdyiRK+YlTO9SZkKRwrUyM=;
 b=VzrLkuG+dU1c/+MXBnKU9QlK98Ku0gkJbhjAA4Ss358o4w5ZJqJ7gC5bTf4NUZhF5N6xmx0A0KvrsQYA5Y9NKYLwH1vBlUP4+K7PhFppiAzAXrrDvaL4Jq1OwQnaumBZMsaSpfhqPVCGdpbza8kYn/DOroL7Oc4anXKc9fn7ym2C7DXQzxWgedHlYKJkRLKy/B6o2R2fV3mGKOUB+hQqlw0jUbRP5jTWQAdc0V+SUgE/36SDsEdoZfNnBqS5kw1iCvnLxCDIrXoZ8eZ1J832sND6FISN/iJlq8jujaNh5TsYO77sI/fQWv+K3Ef2a6VAmlG7vfCH6asHV3kOK2mCIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZR40h/AG03DKumgJ8iw1gSdyiRK+YlTO9SZkKRwrUyM=;
 b=DPZQkoa/5PtFuVhO1Htnh3euI3CB1Pmjl2wtCykCm7AyTsBfbb9BSVzKYeVlgxWUPrPZ8d1CJ53qY6q3fmLcCnHddkCnD7xXSYpEnUJIHGpYcTvEqeTy9CGMmLIxxwzeph7DA8yj/q2MAJ7ryYjlDnbaAvUjKRMs/whRkEuHGcM=
Received: from CH2PR14CA0008.namprd14.prod.outlook.com (2603:10b6:610:60::18)
 by DM3PR12MB9436.namprd12.prod.outlook.com (2603:10b6:8:1af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.47; Wed, 2 Apr
 2025 18:40:29 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:610:60:cafe::2) by CH2PR14CA0008.outlook.office365.com
 (2603:10b6:610:60::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.41 via Frontend Transport; Wed,
 2 Apr 2025 18:40:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8606.22 via Frontend Transport; Wed, 2 Apr 2025 18:40:29 +0000
Received: from [172.31.188.187] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 2 Apr
 2025 13:40:23 -0500
Message-ID: <145ddb99-025b-4ed0-bee6-e1e2c70ff0bf@amd.com>
Date: Thu, 3 Apr 2025 00:10:16 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/12] sched/wait: Add a waitqueue helper for fully
 exclusive priority waiters
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
	<paul.walmsley@sifive.com>, Oliver Upton <oliver.upton@linux.dev>, Marc
 Zyngier <maz@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-riscv@lists.infradead.org>, David Matlack
	<dmatlack@google.com>, Juergen Gross <jgross@suse.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Oleksandr Tyshchenko
	<oleksandr_tyshchenko@epam.com>, Vincent Guittot <vincent.guittot@linaro.org>
References: <20250401204425.904001-1-seanjc@google.com>
 <20250401204425.904001-7-seanjc@google.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20250401204425.904001-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|DM3PR12MB9436:EE_
X-MS-Office365-Filtering-Correlation-Id: 68190e15-3f13-4718-c0c6-08dd7215d777
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTk5SjR1YWtFUzRMZ0NSb1pyNWRUUG56QlZPT3c4Qkk3T0xSRS9BR2NuRElG?=
 =?utf-8?B?ejZvNlVRR3ZWblBoNExrNGJ1OGh5K2pWbG40Yy9KR3RuRW1weGNRamp2dUxH?=
 =?utf-8?B?c3J1UWZPaHNvdms4M0YwRWp4anE4bnNPMFZ3YzFEZnRYOC9vbGpScVVabGFU?=
 =?utf-8?B?ejVSZ21jTTdhMHEwcDVxeTJkQ1BNejNXTi85bFNwQWExc3VWV0tzZENReUdP?=
 =?utf-8?B?LzRtOWNPZ1c1dEdMWmJCWUlyOUZSUk1nTjFDekQ3U1NGdjlMR2tjbTZjZ2pP?=
 =?utf-8?B?ZTZzUXcvNWIvTnVEd2hMSG1BeU96MENHb3crRWFERE11OUdaUDZ1SEt4dFhD?=
 =?utf-8?B?RXh3dGcyeFVxZnh5d1ZGUlVXaTQ1M2syUGF2ZkZSdnNVbUJlSmwrSnpON04y?=
 =?utf-8?B?blNEektHWWZjZ3FCQXNNYWRVb1doR2hLYU5zVzh3cmdxbzNRaWt0S2VHZTl1?=
 =?utf-8?B?T3cyZ1h1ODlCemhaUno2VWhhb1ZXVWpMaEhTWVNIUldYTEYxMWtiSTk3T2tq?=
 =?utf-8?B?aGhpTlFHZ0tNaGZ0cllMZC9SK3IwQ3dKbU5wNThYSzVpcU5VOUVTdVRtNG05?=
 =?utf-8?B?Z0tQWDB2MnMvNjMyYVRSSVFPWEIvejB2aDhCblRsVGhhUUV6Mkk3WVFhYk44?=
 =?utf-8?B?UDVGVU9YYThhR3hIYTdid21ZeFV5QzZXc0RZZVZESy83SUFlMjFmVmZHTlhx?=
 =?utf-8?B?Rndza0xmam5pTDJDbS9XNnlUWDIvK2JyYUVTbnVZdzdOSEFBZ3Jsc1JEamRC?=
 =?utf-8?B?cUhNN3JuSGMvNENyYTM5WXhWNWIva3UrbVhYODBteEdSYTdsazFmK1hzQnZx?=
 =?utf-8?B?U285WXZVT3hHTC9RUUtCRm15a3hpbDNjRFBSd1BXckVTYm9aS01ibDVVcEht?=
 =?utf-8?B?RXZZeFVFK3BrdlovMG8vOEh4d1VrZ3V4YkFiUXA2ZHhpVlc0TWJvd2ZoOUdz?=
 =?utf-8?B?dWV5bWNMb0NzZ0NQQU9NOTZ6L1ZLZi9EaHhwL0dnNkl0RGd6RzVIdVkydVRW?=
 =?utf-8?B?NGN3eEYwbFFRY1JXOEpXZFhiaUxqN1FHekxHeVJORU83V2JmRUs5M1pIQmJm?=
 =?utf-8?B?dVFDOG9GS0tKRm1KcDY2YjdHbmx5ektzMHEvK0JsR0VFTHJObExkWjkzTjZQ?=
 =?utf-8?B?VndKRG56THUzaThZclgxMmgrOWczZG1qSGIxK1NSOGIxeWl2eThabk4zVnZW?=
 =?utf-8?B?NS9kbnBJdmxIUjUyWGVpaGpiRzJLNExEWXNXTkZKTCtZK3g0NW1IUmoydi81?=
 =?utf-8?B?Y2NOcnFkVC9qUDk3dVBZRDV5ejRDSFg2VXFNR2hRM3djalNKYkwvdHRCazNz?=
 =?utf-8?B?SVBSaHhiWG1CTTdoZlVhNTAvaGVLc1BwYmN5ZDd0ejlJOER6ZDc5d0FLMm5G?=
 =?utf-8?B?QlBBdGVqeHBFMzJpSmIxc2Jmc3pHZzRnYnZvRDZYSVNvSnJuWnlYVTc5VHBC?=
 =?utf-8?B?aG9HZFlUa0J0RXVRQ1NqNUpzbzF0cU90SmdVRXkvVGU0RjBpZkVXZnVlNVlV?=
 =?utf-8?B?MHpRcTRaZUg1TW11ZUNpUUUzcVdoUmpLdWRUUW5wQzZud1ZNekNGUkVnZHRB?=
 =?utf-8?B?ZTc4K2x6aXF4ck9OaDdSUkFTVHV5YmxHVlJtNU5KbytwcWFqejZmcTNTSzZI?=
 =?utf-8?B?dGVXNEJvZjJvMThuUDAyQTZiK0lBTGxiT1RxVmRGK3l4Q1NxZXlLSmZvNVhC?=
 =?utf-8?B?aWpxcHlHaEtVcW53WXhJUWpxZm1ReHBxV3B2WGUyeE9iYnpJSDVFVW04VGlu?=
 =?utf-8?B?Z1lkQ1pOcnJ0VjVHTElqRHNHZkgyNEZSaUErN3hMQ2tDN1pRMkQvQVBLS0pW?=
 =?utf-8?B?ak9hRzFIeUtlZjNVZnZMMjZKUkFmZXpqYlFsNkZXaThJNDA2RDFvU3NMc0pJ?=
 =?utf-8?B?Mm9ZNHJrSURFbGtLb0ZlOEtXc2hCOFJZTENwc3ZXaWpTamhpVVlKZ3M5L1hP?=
 =?utf-8?B?ZmJmNnYvdjF6TkRJWXl1T0plb0VlUzJDZ0wwT1RqVkJYWlQ0Wk1USEREVGRE?=
 =?utf-8?B?TVZZc0krV0NBOVU2ZFJJNjJTWWd4aFRUU09XcXdyYWZEUHBlWWF4REEvRlgz?=
 =?utf-8?Q?gPRRki?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 18:40:29.0526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68190e15-3f13-4718-c0c6-08dd7215d777
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9436

Hello Sean,

On 4/2/2025 2:14 AM, Sean Christopherson wrote:
[..snip..]
> diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
> index 51e38f5f4701..80d90d1dc24d 100644
> --- a/kernel/sched/wait.c
> +++ b/kernel/sched/wait.c
> @@ -47,6 +47,26 @@ void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_
>   }
>   EXPORT_SYMBOL_GPL(add_wait_queue_priority);
>   
> +int add_wait_queue_priority_exclusive(struct wait_queue_head *wq_head,
> +				      struct wait_queue_entry *wq_entry)
> +{
> +	struct list_head *head = &wq_head->head;
> +	unsigned long flags;
> +	int r = 0;
> +
> +	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
> +	spin_lock_irqsave(&wq_head->lock, flags);

nit.

Using "guard(spinlock_irqsave)(&wq_head->lock)" can help you get rid of
both "flags" and "r".

> +	if (!list_empty(head) &&
> +	    (list_first_entry(head, typeof(*wq_entry), entry)->flags & WQ_FLAG_PRIORITY))
> +		r = -EBUSY;
> +	else
> +		list_add(&wq_entry->entry, head);
> +	spin_unlock_irqrestore(&wq_head->lock, flags);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(add_wait_queue_priority_exclusive);
> +
>   void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
>   {
>   	unsigned long flags;

-- 
Thanks and Regards,
Prateek


