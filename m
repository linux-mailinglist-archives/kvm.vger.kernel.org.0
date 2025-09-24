Return-Path: <kvm+bounces-58613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B69B98608
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB3AB7B03C5
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 06:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290E3244670;
	Wed, 24 Sep 2025 06:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oLrScnQ5"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E41D24679A
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 06:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758695207; cv=fail; b=MDR/tmy1OyQLRNgkkIg8ERzb6vFgvK6j+CK3Kwq5HN+HxB4oo1ewB/slkaeJBVnoRNbiEECNWMIR3bnUyEdDB7f/oQb5oNZt56Qfy1mxh029UVgE0gM/ZqS1RX6ttUm3M0ooh+VD+64AsStWWPBjeCXq/PwkgdmBjgmYyfwCRQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758695207; c=relaxed/simple;
	bh=hIkKrI7t3zZt6B4AmRr2TPRfnvDgEIb9LkAd87Wgb/8=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=u9IwdYWaIDFCbpNjuA3sgZvFy0uKIK/CPER2B59ulpT1fcRt280ic/hFb7tBUWbBt+xf3q3/6hppNQBOEnz1QY2SAw7W4t6j4476z9r6EFcKDE+69FLDU+R8knzF7+e8VhPrsBZ1TvqqHxD6CIzAwiqCL5yrBNgONrge6ofon8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oLrScnQ5; arc=fail smtp.client-ip=40.107.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rwSbvMuMAK4GyX48j2i4UY0bDoyHYcb04v6co+eKBAGpr5S9WDagE36QXy82j7P94598Mi4Y40CF7CxMsCydq1nom/lhCtJDJkmiGVZ+2AErxkkfA1HWla0L/r9N2ofk7khbYqYR3bIJnyY3nyiBwXkPUModv0zVdHCebdR5Z7UClsPy3R2e8SKvQpw80EzTs2b8CIgb99Cwnlz/cbKKDx+doxtDmtgWkKjUiKun09VWKvdvAqq6JoiIBWXVTrc3Wg7Ct5LIxtzDeZgmbvEyap6mS0eyXFaD+vivYCwHzmbugrxB2kFIXOej0IjSYXhfRpDRZB/fCt2aRCbCtpz+vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jY8ftjMxavweKov8AcrmY4tliBGquhOjSG5ZLRpLShY=;
 b=pLfZB4dZw9zJxWJU/k4ltSeFlSnHLf1HgxDagrOkqzP7ypUpt4Bnv2FXQWf6Ce2cfNz05FnEWRGJSH/zHR24XMvACCGCdbnZr4PUFvSrWNGyi0naHXqoJjUmPpuUALJTKVqUw/1ieHxNSt6Au8GbGUJeI8rjo5AbvzaHRHVLWHoN7RGq0se29O9AnUjsS8h7AkXGoiuib/TpGeqXB9LZIjarcc7WscAHdz48VX7pKAp+K5OhG08RtYFNusJe/jrgF9yD7+KcteYxIBFBqZDn+pTcVaSrFDA3fKK16jhEhIkCdzBFl1R4cj2938P3uh6SZ054jeIurmdn1Tt910Iuiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jY8ftjMxavweKov8AcrmY4tliBGquhOjSG5ZLRpLShY=;
 b=oLrScnQ5zDYQX7/Jg6iY9Tqo9HcrmgYWbeaJQ+D82Aj2sHuHbYDX7mWZjvQ3qOXbPCzfn0BPOCQXxiY8ijOxSl6t/e8l4BfCJc337btNm5If/A4eapP0pyCFZBq7x1P2OBIgPiZK/syHBWHu8cQ9JCtjZ1LudkbdQMSLQnOU6KU=
Received: from MW4PR03CA0266.namprd03.prod.outlook.com (2603:10b6:303:b4::31)
 by CH1PR12MB9717.namprd12.prod.outlook.com (2603:10b6:610:2b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Wed, 24 Sep
 2025 06:26:42 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:303:b4:cafe::f5) by MW4PR03CA0266.outlook.office365.com
 (2603:10b6:303:b4::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Wed,
 24 Sep 2025 06:26:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Wed, 24 Sep 2025 06:26:41 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 23 Sep
 2025 23:26:37 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v2 4/4] KVM: SVM: Add Page modification logging support
In-Reply-To: <85ecs4nva5.fsf@amd.com>
References: <20250915085938.639049-1-nikunj@amd.com>
 <20250915085938.639049-5-nikunj@amd.com>
 <4c9e02133992661190b644d93a393f5f2d6bb32c.camel@intel.com>
 <85ecs4nva5.fsf@amd.com>
Date: Wed, 24 Sep 2025 06:26:33 +0000
Message-ID: <85a52k1i3q.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|CH1PR12MB9717:EE_
X-MS-Office365-Filtering-Correlation-Id: cdb1ab67-307d-4e01-26b0-08ddfb33535c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZjRZTys0UHhESGRJbmRET09nSXhPUEhLUWZ1OGFqemFpV2xvbWxuWnVRWEI3?=
 =?utf-8?B?cUk3SnhrcnhTL2hmU2JCZnVTZjZXU1pRUWZScm43Y0FoajVnN1JOcVcwUTlP?=
 =?utf-8?B?amRKMDZVcmFWLzhyMTBnaVFxRzFCRmdQN1hWYkVPT0VIaW1TRDNRc2oySmto?=
 =?utf-8?B?RFVPMXdURkNPeFh5UFlGenFqaXlVaXFEZ1p5U2x6amROVzZiMUtiOVB2ZUFT?=
 =?utf-8?B?MlBuQVQ3TVJiN3hDZ1VMRUkxbnRUY0trNitzL01ybE1KeG0vVW10TmNQMDBI?=
 =?utf-8?B?SFFaaGVvdklUUTlmQ05WY2htVUFBMHA3bHJXUlF1Ymx2YUtlWG1rMU91K1F6?=
 =?utf-8?B?S3ZQVzJSeUhTV3AySytUdjF5UkZVbWxBVWQrTFc4RjR0YXhqNmlRbUhaVldn?=
 =?utf-8?B?dU10U09HV1owd29pRW5nMXQ5MTdKNXJqRTRwdnlFRktmTlY4VGdXWFFxaFR6?=
 =?utf-8?B?MnhsbTVnYWRWNitIR2d0YUtpNkFZU2tiSHJoQXd4WUt2cDhSK1Z2SGRsUnJt?=
 =?utf-8?B?YWMvbGEvUkJNK3MwMkNnUS9PVEgvSkprcmxSamhJcHgybTlabWs2OElSY25U?=
 =?utf-8?B?ODhRMW80aGZkUlJSTXB2ZnRjTDVETlFUWjZBRVIyajdRa0k0cyt1TC9FSGV2?=
 =?utf-8?B?bTMzVDdsTHNxRVpScjNIRVBKanZRdVFFMkVkZXg2Q2tEYmMybiswODFBZkVW?=
 =?utf-8?B?UWJOSHdDaW5Fa20vNjQzUzZXQzZnUTJUQ1R6N1VIcU1uK2poWmN1Sy9DL0c2?=
 =?utf-8?B?RHlVYnIybDU2SVN4R1JaelJxVlZzVWVJSXFFOWJ2bUpsMmp6c3krL2czYzZS?=
 =?utf-8?B?S2dzMjhjc3dPZTRlbEZlcnlSQUI5VHVxWWkxWWZmVkFveUxPaitadWUxYW8z?=
 =?utf-8?B?OFJESUkzVEcvbVFra2NlS2NZVHdhOGJzOE5zMitiekkwVUVkRXJCblRqVmRW?=
 =?utf-8?B?SDVTa083ZWt2V3pwa2JkLzB0cVM4cnBWcEMwQXpCSkxGUTVEWFlYcFNKeFJQ?=
 =?utf-8?B?TlBHUUxBSTFjYnQySEovODhhbXl6YjdCZmN6WVNMcGJ2Wnk3K2NLZlJyRGxo?=
 =?utf-8?B?TitsR2UyemNXalRRWmRQenJFT3BGa3JCdStBWkdzYVUybms4K21lZEd3cjJJ?=
 =?utf-8?B?WmsxRldXUEZwbWFMNUdsOUtrTTgzbzBBdEN3YS9ESVBqYU05UjNCRnJqb1pw?=
 =?utf-8?B?eDNlRnhwd1ZsdHFieUtValZDUmNiY3llSk11SlMzVElzTG9udDFoTHFLL1Fs?=
 =?utf-8?B?NG5tSTl3VWZ5cjBpRFRMTlRQbmtPcXVCbVlQM0dwamxhdHFsc2h5TEZlQmI1?=
 =?utf-8?B?TjUweTh6eitiMml4dmRpMlVBWjdoMkQrbDk5Umt1TnNrVDRVRExWdi9IWHo0?=
 =?utf-8?B?ODl3cmd3Q0tiTjVOMUFCTzdDcUNhOTJPQlN3UUx5OHlYVzZUNGNIb0xWc0pM?=
 =?utf-8?B?QmVFUzdMelVxaVQzN3BtemVDalYzQ2tGNXQwUDVUUXpKY0t3bTl6RHlYOUVL?=
 =?utf-8?B?V2tDU1FWdHVSMnBzb1BRTUNxRHZNT0ZXajJhbG5USnN4Um51M2FITzNPWWJX?=
 =?utf-8?B?WjltNWJCb0JmbGxRaGV3UVMrTVBWbjlzQUU2QUpEV1hhMDJPa0Nsbk5DaGUx?=
 =?utf-8?B?RWVneHlDQVUzK3JFZWQ0dkE5VWNCdi9mM1hCZ08xdndNaXVseDJ1eUVzRXdu?=
 =?utf-8?B?RUV6V2QwL21pZU9XbTVPeEZ6eTNiYnA5bERjd2EzU0tqUTdydzVCcVZCVFhC?=
 =?utf-8?B?dFF4dms5eXh5QVFyY2cyWXI0RXl1aGxIelpZdmxoeE1KOUMwV0pOa0J0V0pv?=
 =?utf-8?B?cXRBNVcyc0N5SHpMZ1FPV0pPTUFYYTBHc3FvNitzbWVMREY4WlJTSmk4dUxy?=
 =?utf-8?B?TWlWUzQ4WlA1OWFvVEs1RVhUYzAzelZTdll0c3ZhM3JPaHZEcVE5Qkl6TVFU?=
 =?utf-8?B?czFwU2ZYMncvMzdGb2xNbmJQajdnWHJiRlh5b3A5L2xwMTRqMnlmbThJN2RH?=
 =?utf-8?B?K2thTXZHblNtNVRlOGNwcTE0UGZTNVBpTTdmb0E0N0lGLzUxVGM5Qm54U003?=
 =?utf-8?Q?C1yKme?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 06:26:41.5590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb1ab67-307d-4e01-26b0-08ddfb33535c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9717

Nikunj A Dadhania <nikunj@amd.com> writes:

> "Huang, Kai" <kai.huang@intel.com> writes:
>
>> On Mon, 2025-09-15 at 08:59 +0000, Nikunj A Dadhania wrote:
>>>=20
>>> PML is enabled by default when supported and can be disabled via the 'p=
ml'
>>> module parameter.
>>
>> This changelog mentions nothing about interaction between PML vs nested.
>>
>> On VMX, PML is emulated for L2 (for nested EPT) but is never enabled in
>> hardware when CPU runs in L2, so:
>>
>> 1) PML is exposed to L1 (for nested EPT).
>> 2) PML needs to be turned off when CPU runs in L2 otherwise L2's GPA=C2=
=A0
>>    could be logged, and turned on again after CPU leaves L2 (and restore
>>    PML buffer/index of VMCS01).
>
> I get your point and I see that when nested VM entry, PML is set in
> the nested_ctl for L2.

As nested_ctl from L1 was getting copied into L2, PML flag was also set
for L2. I have disabled this now.

>
> I am trying to create this scenario, and couldnt get the L2 GPA's.

L2 GPA's were not logged because PML_ADDR and PML_INDEX of the VMCB02
was not populated.

>
>>
>> It doesn't seem this series supports emulating PML for L2 (for nested
>> NPT), because AMD's PML is also enumerated via a CPUID bit (while VMX
>> doesn't) and it's not exposed to guest, so we don't need to handle nested
>> PML_FULL VMEXIT etc.
>>
>> This is fine I think, and we can support this in the future if needed.
>>
>> But 2) is also needed anyway for AMD's PML AFAICT, regardless of whether
>> 1) is supported or not ?
>
> I see your point, we will need to disable PML for L2.
>
>>
>> If so, could we add some text to clarify all of these in the changelog?
>>
>>
>> [...]
>>
>>>=20=20
>>> +void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct vcpu_svm *svm =3D to_svm(vcpu);
>>> +
>>> +	if (WARN_ON_ONCE(!pml))
>>> +		return;
>>> +
>>> +	if (is_guest_mode(vcpu))
>>> +		return;
>>
>> VMX has a vmx->nested.update_vmcs01_cpu_dirty_logging boolean.  It's set
>> here to indicate PML enabling is not updated for L2 here, but later when
>> switching to run in L1, the PML enabling needs to updated.
>>
>> Shouldn't SVM have similar handling?
>
> Sure, will get back to you on this.

Yes, this will be required as it is handling a case when there is a
dirty logging change for L1 while L2 is running. So this variable is
used to record such change and when L2 exits, the pending change needs
to be made in L1's VMCB.

Thanks for the detailed review.

Regards
Nikunj

