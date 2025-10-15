Return-Path: <kvm+bounces-60064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 645D5BDC89B
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 06:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C2E91351E66
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 04:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82FF52FBE18;
	Wed, 15 Oct 2025 04:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3XiwkUT4"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010030.outbound.protection.outlook.com [52.101.61.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29E71DE3A4
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 04:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760503449; cv=fail; b=PyVYM8uNQMHTRFHAEW03AJHJUj96+K5Xe1EV79KVOWlg60YRzN260iiCvtzWC2+W4qXeCV1zsu6N6MR6irCuyXcWYGS7ElZ3q5G5cqrJzUHsTUF9Pq95Tg5RJuXE6p+9kMjytb7hvdszjPZanirDMVlMp59Iquq2itm9uL36Ij8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760503449; c=relaxed/simple;
	bh=L7rO1i00fLXHNIzbXRJYWmAm0Lkgj03uo6vMx8yPdOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=S7naJlbpCbcx+Ph/mSpAJBtxKZrGyJ628ZvBaBRNWGOYJw5VVw2ARrhLzijiIyOCpexYM8EHBw4wMdtQE1Q4jkrbfte58vPh8k9sXyugEzgQxUa2J8t7125F5h826e6fCUY5EY4JPLener4sdg/0D3TVJl0yw5IpEoQQJy3TtRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3XiwkUT4; arc=fail smtp.client-ip=52.101.61.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uzwo2QIUJMIWl/XAqNqfWdgFZu5qo4ZWIOK7fHtC3CipgK3maLebHPHydbsHPdDsW7DlcCKiuoH9sFYiIkNFooN4RV/5MzTQvqauvF0VoLr6BqHQzO9uHslrkvabaLqlqcDpO8r4XZn8VObcXQDhEl1xFE21uQELRuGUg0eMzeM24GhpNSDFallLVN+QUqv/74XXNOy0R2Xv4ab0bHHnMCreVH+OCu1nVoV8gER13Z89Qs0hFCqSZ6+0H1Py8ylQLtn2cAqJcjA0PXFW2nFV0Gdl7KZrFN5heDzcRHS1Eu009ANzrVmXYzYOZXKlw+hhtW9j10HTmucGlRXbWHGBKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P41kYo3Yfwvnv+DJcZjbA30ZVJPtsW4t9Us0sQsWRI0=;
 b=rLBqTPHFNUu5L8xIy7PCo/EWjhSG3xr2yVCgokZg9VBluTnQSGRoYMxB/jT516+ksk1ijCrdnjzSgHO6IC1OYdetA4EKDDyAdUsP82iTFTKlac6ky0prfIfJOEqvdMDBP0DBtnVACHoXKzyjbGXQ1xsDVwLReNzihr+Kobr9vWT4ebQfm6NX3Ic8ejphzYtoDGw7G4tBJ7wl2LgyIM1Lf2DkkBOkpFRtqMP9hBkSfca01KJOTlbUYvKT+ob71Oes/GG9l9ZAW4sYZ7TxlgobUIaEcvYMojsEe23mj1GXjPmRxzqdEjjee7R7ZLseuGF5J/QbideRIg3xXr2dFz7Tvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P41kYo3Yfwvnv+DJcZjbA30ZVJPtsW4t9Us0sQsWRI0=;
 b=3XiwkUT40v373dv5f+o4XLo7KrdnXJqAYUI35twhtx5sYfQ+Kft79fyJN6x3yffOYGCnOAMc3op3wawFwjfP7NiYv92EZr2Kic+Z0RUM4ej8JkTDAW+9JeXlE2PR9t190+6wNA5DYcWZBLkwODOIx/c4Q7MmqoC5g6Rz8mjuo1o=
Received: from PH2PEPF0000384C.namprd17.prod.outlook.com (2603:10b6:518:1::70)
 by DS0PR12MB7769.namprd12.prod.outlook.com (2603:10b6:8:138::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Wed, 15 Oct
 2025 04:44:02 +0000
Received: from SA2PEPF000015C6.namprd03.prod.outlook.com
 (2a01:111:f403:c801::5) by PH2PEPF0000384C.outlook.office365.com
 (2603:1036:903:48::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.10 via Frontend Transport; Wed,
 15 Oct 2025 04:44:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015C6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Wed, 15 Oct 2025 04:44:02 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 14 Oct
 2025 21:44:00 -0700
Received: from [10.252.207.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 14 Oct 2025 21:43:57 -0700
Message-ID: <48e668bb-0b5e-4e47-9913-bc8e3ad30661@amd.com>
Date: Wed, 15 Oct 2025 10:13:51 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "bp@alien8.de"
	<bp@alien8.de>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
 <20251013062515.3712430-5-nikunj@amd.com>
 <30dd3c26d3e3f6372b41c0d7741abedb5b51d57d.camel@intel.com>
 <8b1f31fec081c7e570ddec93477dd719638cc363.camel@intel.com>
 <aO6_juzVYMdRaR5r@google.com>
 <431935458ca4b0bf078582d6045b0bd7f43abcea.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <431935458ca4b0bf078582d6045b0bd7f43abcea.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C6:EE_|DS0PR12MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: fc6ff761-5552-4276-a71c-08de0ba576b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MCtqcGI4WFgzZmQ1WVg5Rzd2S0hZNUEzWXhPdVBlQ0JxL2o2Ymo1aDJVYW5V?=
 =?utf-8?B?REFxenRLSGhSbmVid2xmRXhIeTZZQ0lWZ0YzbE9makJvQ1NwcFhweEQ4em9F?=
 =?utf-8?B?ZzZPZkQrb05rM0ZkelY3Rk5tdm82MmxKRmpOb3NNdGZqaGpOeGlIRUYvZEty?=
 =?utf-8?B?cDF2Vm5Vd0VEWExMQ1Y2RzVybzJRZ2Z0VlBUajhleXo1NUREZmp0eWp4MGRO?=
 =?utf-8?B?cEpWZXpOL2g0eXJ4RUNEczBwNjByU3pLS3F5V2hCeFV5UFRoWXN2QlFGeXhX?=
 =?utf-8?B?dzhyMFR5U0o5M2RVQVdFRW5kNXVVUlhXYjQ2WDE4QnczZlhvVGFqN2lFS21J?=
 =?utf-8?B?ZjZLKzFaTEhhaVduZUJQc1gyNnZZNEJyV0VaZ3kxa1hkNDhzaTlROHN2MVM3?=
 =?utf-8?B?b2h0UU0rVlMrY1d6NDBBc21Sb0l3VllrejREUlE2WmVlWEJxUlVLS1ZRM0ox?=
 =?utf-8?B?ZTR6eTlENkZLYzA0YWVtbndzUjJXRTdlSGNla3hyeHdGeERvbE1DNFd1QWhC?=
 =?utf-8?B?ZGs3dlFSOENFNGdvMlpmUG0vR0ZtTWhLMFVPZENIbHozbVR2ZlBheGNPVFIz?=
 =?utf-8?B?Vk82S2hOb3NQWlRlZ24zNDlWNTV3SVA4bUtibDVMMFd2OHoxTGtPekZkVWVh?=
 =?utf-8?B?eHN6eUd5ejhHL1RBYlorbC9pS1A0Vlg4OWVZNlEzUTBYdWZGSmJ1V3dreVIz?=
 =?utf-8?B?cW15K0g1MU02Qmw1VW9nNE1OUUxGK0k0RzgwMzhOdk12WDNrUUJtZFJFc3Er?=
 =?utf-8?B?TlBvZER2dXE1SnhTbTAvRlhxUnRTTG5lZmtORTFuNGpWY2NNVTlBNkRFTURs?=
 =?utf-8?B?c0JYekllS1NxejloTm52VUdKS2hVVmhWVDdMbzRLZ0lnOVF3bkUrcDVMYWhv?=
 =?utf-8?B?SUFPVDF3MkQ2bUZhNnlRS2VYTXI4WEh4Zko2b1dGTnFPS1A1WXlqbmp6aXI1?=
 =?utf-8?B?RXIzSTk3SUw1ekQvaHcwdUtkMGNNYUtwV2FQb1ZUYWQ1d0hBbWluVTh2V2l6?=
 =?utf-8?B?QmZaYmVrVmxiaHUrWnZQKzd0a29GTkF5SVZLc0svMyt4KzRMV2tlSTFIM21o?=
 =?utf-8?B?eTJJSDJxTFVxTVJyWHRTeFNDajExd1F2eU51emlpYTE0RVFpRFY2aTZILzJt?=
 =?utf-8?B?S3ZzRndmWnZwZHZoQ0EvVWMvQko5Vzltd2V3ZDlFc1hXdTJJYzlzNnIyaHI4?=
 =?utf-8?B?YmZTTHFYRTRXaFdycW4yR3liVDcyZ3dSZGI4bXVnaWduVXpMNlZhdG1WbENh?=
 =?utf-8?B?MWZCYVZVSGkrTVlRalhTSXc4ck52K1lqZldBNXdyNHBJWko5NmFkYkVBTnVR?=
 =?utf-8?B?dE00OVVkanZIN3BEcXkyTTBua2MwK2Z1Zkt3bHUxVC93bVVkS1ZLN0VMK2pU?=
 =?utf-8?B?YW9ER1NmWE9FekNPNUZlRndjMUdDNHU0SGFiQThpa3Nva09qS0QveFpya29I?=
 =?utf-8?B?b1NzenI5QTNtUzFYaERsVHlydlRPMStrYjVsRDdSQkJ6aSttSUhCVGd3bzhx?=
 =?utf-8?B?akU4UnNuN3lGbUpqM09DUUJUWUYva0NFcVFmNmdVYThkWDhvNmRJQkora3lT?=
 =?utf-8?B?cWx3aWVHQ290TERjOVBCTWI0QnpzUENLblNsU3MxeENleEJCd045MGIxaXpp?=
 =?utf-8?B?dlRsTEo3YjVWUElQZEpmK2hxdURxMWxVakR6L1o0WVJhQ3crYTBLUTlQTitk?=
 =?utf-8?B?b2J2VE9FelR2cXpHL25uR010VDhiTTBNZjBtN3FOcittRm9ybEhnVm1SODVG?=
 =?utf-8?B?alJwSkpnckdhekljT3BTNmlwQjE4Z1p1RmRqNU81U3pJQ1VCOTBFMHFCZi9P?=
 =?utf-8?B?ZW9acHIyTDZwSFc0aVhWd2xqWGJ2SCtZd2d0L2ZydlRsem5ybVJrcmpxQS9S?=
 =?utf-8?B?MEoxMzJyN2RFd0xjTzk4eHV2Yk1PWHJQY29rR1B6MXNqK25GSUdOOW05dTh4?=
 =?utf-8?B?NjlOTDhWbUx6cFFnbElxU01MVkQ5RThUWXdibzYzWUZuUnJ1ZFVoR3FvRWp6?=
 =?utf-8?B?ZGdpWTM0Ty9lWFVOZ1I5RTV1QnFKcEUyTVJOZDJZc3pIcE52NVJEaVk2cUls?=
 =?utf-8?B?MHFzMWFQWVhvWCt1U2xzRTRwUERBd1BNUGRsRHIzV2VnaEwwb0t1NnB1MGF0?=
 =?utf-8?Q?PR1k=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 04:44:02.1639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6ff761-5552-4276-a71c-08de0ba576b4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7769



On 10/15/2025 3:07 AM, Huang, Kai wrote:
> On Tue, 2025-10-14 at 14:24 -0700, Sean Christopherson wrote:
>> On Tue, Oct 14, 2025, Kai Huang wrote:
>>> On Tue, 2025-10-14 at 11:34 +0000, Huang, Kai wrote:
>>>>>   
>>>>> +static void kvm_vcpu_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +	if (WARN_ON_ONCE(!enable_pml))
>>>>> +		return;
>>>>
>>>> Nit:  
>>>>
>>>> Since kvm_mmu_update_cpu_dirty_logging() checks kvm-
>>>>> arch.cpu_dirty_log_size to determine whether PML is enabled, maybe it's
>>>> better to check vcpu->kvm.arch.cpu_dirty_log_size here too to make them
>>>> consistent.
>>>
>>> After second thought, I think we should just change to checking the vcpu-
>>>> kvm.arch.cpu_dirty_log_size.
>>
>> +1
>>
>>>> Anyway, the intention of this patch is moving code out of VMX to x86, so
>>>> if needed, perhaps we can do the change in another patch.

I will add this as a pre-patch, does it need a fixes tag ?

>>>>
>>>> Btw, now with 'enable_pml' also being moved to x86 common, both
>>>> 'enable_pml' and 'kvm->arch.cpu_dirty_log_size' can be used to determine
>>>> whether KVM has enabled PML.  It's kinda redundant, but I guess it's fine.
>>>
>>> If we change to check cpu_dirty_log_size here, the x86 common code won't
>>> use 'enable_pml' anymore and I think we can just get rid of that patch.
>>>
>>> Sean, do you have any preference?
>>
>> Definitely check cpu_dirty_log_size.  It's more precise (TDX doesn't (yet) support
>> PML), avoids the export, and hopefully will yield more consistent code.> 
> Yeah completely agree.  Thanks for the feedback.

Sure, thanks for the feedback.

Regards
Nikunj


