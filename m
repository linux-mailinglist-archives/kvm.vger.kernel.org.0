Return-Path: <kvm+bounces-54542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89456B234DC
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 20:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9707E1AA734E
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 18:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950DA2FF14E;
	Tue, 12 Aug 2025 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qr1/vcov"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EE22FD1AD;
	Tue, 12 Aug 2025 18:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024023; cv=fail; b=Hh/0nXjOFjRU/o/SX+tJYXp6dfsC3TttMp03RvqtGNHy0vb6vxdHJMv4dAgjrR3i5FmABMRUCZAu31ICbfgDhzewjasEItPcSDSBAoSbpqEhIdKVvBAucWaU2cx+Uz2r4NmvT69Ig+cdayWqDi2Sb0KBu1mG6RB5EGVP8q/mhfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024023; c=relaxed/simple;
	bh=achMz8D6QeR2l0ydNYjAHBALzyvn7kI7+L08PVdZftM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NbZuR8L3JViGCrULrKfr0sicBXGyf5vERDn3Wi6d0eEp8hQ0XxSxA8JicnoqmOJNppfI1Hy3ju/KA3/t/4Z/6Uvix+chIE+DZ7VCQwkWfsOmgNCV98EK3Ia1Isr+gA0gTFMXEk323I8Xzby1ypBWXA8JnmRahP5V52Q7qwxDiIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qr1/vcov; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M1j0UGUl/PjW204CWlfa1+o0ks/UKPR2oBhZ+BPWfFZPeUsiClpkPnOhO1MjkFHRUUjArmNyRU93ys045cVH4crZnQ1Cpfun1BGKGw7YHX2/S2Hw2d4utwxzrg956uvSkufVHon9U3YWQYGbTnCtLi683C7YfmKmr4ab6LMm5cX34UnbicVxVuqforPAQE4Il60Vd0/LNgXt3fwhVDbBqEurIvOWZzlh1OgxGtgSLfBa+6vBPNslc9Se7WyDCh7H2SclXWPN+w2ZFUNmLHGeSMBH6rfKRqdsQvda2sVUWlxS8EKc1RbJsMSdj9ghf7XQh8RtQFrBwdPEgmAIxI9fGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hi49HjYht3VdRzedYQdw5Rfxd2KL7qE4My2LjFtAii8=;
 b=Hgvpm19l0MgY4NmO7b+lseszol+7HftNBDXQ5LqxKq0OobCa3udqebu/hArtgz6WSMFjo9nDM5jBmB7govjrD8sdWugFm75+DZAK5pnBbK9E/TbnKopqApr5ZTtLvPtWF3s2o9wyNOA6Iys/Umo2FhaFTvA8nEg3dNsFN6NugnpTGymzuuVTBIHmf3YmX0DYVOh0nE1E5sJSc3dQ/5KW7xR/vGpMysoFxzG+CK9z75vcG6UxcublAORZt4TpgIiq34dKbZ5S/D51w/FZLWBBmEbH2jt3U9PFd+FMQg2P/CGQDerVjLn+3SIWJp1D0B7W+bttv/5j9wbTeAoy3G/soA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hi49HjYht3VdRzedYQdw5Rfxd2KL7qE4My2LjFtAii8=;
 b=qr1/vcovgprsTMtBPiVK2dkacJRKUhKh05VnCmL+EASXeMiD7JC6xGDKd8cXvZDeaNdi/Kh7Nhq9np1p4HysUt/rbpCSYgYpPX7FnHKcMzv05aHdffB4+mZfyYPjpmvMj78Bn+Icv/eAXgGMqEbyHeYJR0jheoSN5GEgdoK7FCg=
Received: from SN7P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::27)
 by LV2PR12MB5750.namprd12.prod.outlook.com (2603:10b6:408:17e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 18:40:16 +0000
Received: from SA2PEPF00003F64.namprd04.prod.outlook.com
 (2603:10b6:806:123:cafe::10) by SN7P220CA0022.outlook.office365.com
 (2603:10b6:806:123::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Tue,
 12 Aug 2025 18:40:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F64.mail.protection.outlook.com (10.167.248.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Tue, 12 Aug 2025 18:40:15 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 12 Aug
 2025 13:40:13 -0500
Message-ID: <96022875-5a6f-4192-b1eb-40f389b4859f@amd.com>
Date: Tue, 12 Aug 2025 13:40:13 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, <corbet@lwn.net>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <john.allen@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <akpm@linux-foundation.org>, <rostedt@goodmis.org>,
	<paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
 <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
 <03068367-fb6e-4f97-9910-4cf7271eae15@amd.com>
 <b063801d-af60-461d-8112-2614ebb3ac26@amd.com>
 <29bff13f-5926-49bb-af54-d4966ff3be96@amd.com>
 <5a207fe7-9553-4458-b702-ab34b21861da@amd.com>
 <a6864a2c-b88f-4639-bf66-0b0cfbc5b20c@amd.com>
 <9b0f1a56-7b8f-45ce-9219-3489faedb06c@amd.com>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <9b0f1a56-7b8f-45ce-9219-3489faedb06c@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F64:EE_|LV2PR12MB5750:EE_
X-MS-Office365-Filtering-Correlation-Id: f8803186-5972-444e-33c2-08ddd9cfadfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1dkcnFGMTZYdDNNRVJDSzg4dExoaHk4cVFjWnhnRXVmZk1iODRYRVZraTlu?=
 =?utf-8?B?ak9RTEtsQWJrT1BxVCtndVE0aTBFbHIwZDg2OVBIaktQTzhZODhhWEhQcVR4?=
 =?utf-8?B?UmFLMFRtby9sVCsvM2F4VXZ1VExzbFprbzJod1pqeEhva0RndlF6cm1Scjl5?=
 =?utf-8?B?VzhpKzJCTzRIOVhKbHFhaDdWSzR2WlgrRGRNZGhYQ3RCT3kwRFlHU20xSkMx?=
 =?utf-8?B?K3Q0YVlqSU1PMERZOTVodVdEVlRPWXVPSXo2NzdETTJCcG5NSGFXZFA3dDBC?=
 =?utf-8?B?Y2JuWTN6SFlvb2x4UUtLL2ZMQXZzTUY5MmVpQmZBVERLRzEzTU4vblZDbWMr?=
 =?utf-8?B?dGV2MTduVEZkZDNCQkNCVk5GcER6ZGFKeDN5M1d4WENqQkI5UHBkN2tNemZB?=
 =?utf-8?B?MzBDb25CbWJwL0srTjQvcXJYd3k0bUwraEovbCt6amlhZFB3QXJnTUp1Tit4?=
 =?utf-8?B?YlE1amVCR2dqYnJ4WktGYzVNUm81UU1HeXNNTi9nQUNsOGFPMjVsVlRoQ1VW?=
 =?utf-8?B?blROaDV2VEpCeEJ2Z2UrRm8zOEtjQUVmamlzYVB0TmRkYWRLREpuZDlNVHl3?=
 =?utf-8?B?WnlvS3VxZTcyeC9NbEJCZnBocmc0d1ZxNGtoeTZvZW9jbFBvNWtSRmw4ci9Z?=
 =?utf-8?B?aU95aFlodWZWVzdRUzUzWTZTNWpETTFGWmJaZ2JtN3dZT05zOGsweEcySGNG?=
 =?utf-8?B?ZnhpQXRscUVkNjZvU3NKNG8yNXlpcjNlZVJ4eVIrZ3VLQkwwR0lwYXE0NWVQ?=
 =?utf-8?B?ZnhvTXd4M3BSTkVGU1phU09EdFE5WWwxbkZid0dpQXQwODdzOGI4Tkl2UGds?=
 =?utf-8?B?azBlUjhBTTA1WjVMQnJReDFuUlcwOElhNUY3ZWljMWp3Qm93RzV0Z1dqTUZL?=
 =?utf-8?B?ZDZYTVVjdG4rL25VMi9ZeEFjZU5STWdBcmo3RVJpbE9hUzlCYnpRazRkRWl2?=
 =?utf-8?B?MHNZaVhrTGlXOUVvTlRweThuU0ljYVp2Yko5WWk2aEE4TExMUnRqK29PVkdt?=
 =?utf-8?B?WEFEL2pWNFhxUCtpVUoyaDhEQWZkUmR0Wk9oK3pBNzBqdm5kKzBwY0NqREl0?=
 =?utf-8?B?c1lxLzYxaUNUTnZCT3Q2WnNDNi9LYjE5VnQ4bDJSdmVHd0dsYUxKLzAwL05T?=
 =?utf-8?B?WmYyVzM2U2dIc3ZHbU1RTjl3bG5EZVZpNlhiSG9BWmwrcWc5VVFRY2NoenFp?=
 =?utf-8?B?OXFpUnE1Tkl2WDYwWGQzNEhoWEhLeEhMeU1yYlZpMitXdzhxU1U2MEtuaE9r?=
 =?utf-8?B?cURoWXFwUkJYaTBQTU5UdkpUdm9vYnJXK2FrWHFRNXQ1b3diZVhkYTg0aURz?=
 =?utf-8?B?UzFuaGJaMXJYblRxM1k1NzJSVi8zNHNTT2xONVJBc3NhcGM3ZmpIaUwxcUx2?=
 =?utf-8?B?SVIzY1hWTVpZOHU0Nkp0TTBoTFpWQmpXQ3JjaEk4TlBaZDZHTzB3SXdzS3Zu?=
 =?utf-8?B?YTJHTnhoM2pieVQvN00vRlU2ejU0ZzV5VWsxTDZ1eWVhbGFwdmg5TGFWM3dV?=
 =?utf-8?B?THdpU2JKbHpPNG1DdkE5bWp3ZlI4QkJvV3NkNzM5cVVOemticHdMQnQ1djFS?=
 =?utf-8?B?SEp2V3pyVVRQTW5ub1liR0pzclNkN0E1NGhId2Fzcm9SbWo3dkRiVHM2eUVS?=
 =?utf-8?B?bnovbyt5NUlsdVMyYklUNDI4c2c4RTN2ZGg4RGsybHp1cXNSZks2OTVqVUxT?=
 =?utf-8?B?WVF3THZuV3UydENlVG9mVmxiRXQ0bFBQdFlObFZ3aUdLN05PVVQxdkV2UTlr?=
 =?utf-8?B?S0RZQ3FMK0phd29vSHVHekRBMmYxNWU5UWZLTE1jdzhET2VWcjlCbkxQMlZ2?=
 =?utf-8?B?RnZEYXJjV1pWWlllQ1dxQVF3SFp4UEl3czlnYkR2OUZvU3pLa2RXRllLc25O?=
 =?utf-8?B?ZjBEbFREdzBvencvNW41VWg3c0l2NXZWZnVnV2hIWHVOQlQzbFpHeDdGb1Rr?=
 =?utf-8?B?UUZhVGJTMlRjWktaQno2OUR2SmdlTExjMUVVM0xacjlQcGJtVFdIOGc4cnNN?=
 =?utf-8?B?Zkl0WGxPSmdMQy80TzNUS0ZLc2dBRXJJWDJQTVkvOERvb0xQRFptU2lwMFdZ?=
 =?utf-8?B?UStvQVB4TGxSdjYyWm9KNm9hV2RoNmNFQXhwQT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 18:40:15.6068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8803186-5972-444e-33c2-08ddd9cfadfa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5750

On 8/12/25 1:29 PM, Kalra, Ashish wrote:
>
> On 8/12/2025 11:45 AM, Kim Phillips wrote:
>> On 8/12/25 9:40 AM, Kalra, Ashish wrote:
>>> On 8/12/2025 7:06 AM, Kim Phillips wrote:
>>>>    arch/x86/kvm/svm/sev.c | 47 ++++++++++++++++++-----------------------------
>>>>    1 file changed, 18 insertions(+), 29 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 7ac0f0f25e68..57c6e4717e51 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -2970,42 +2970,29 @@ static bool is_sev_snp_initialized(void)
>>>>
>>>>    static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>>>>    {
>>>> -       unsigned int ciphertext_hiding_asid_nr = 0;
>>>> -
>>>> -       if (!ciphertext_hiding_asids[0])
>>>> -               return false;
>>>> -
>>>> -       if (!sev_is_snp_ciphertext_hiding_supported()) {
>>>> +       if (ciphertext_hiding_asids[0] && !sev_is_snp_ciphertext_hiding_supported()) {
>>>>                   pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported\n");
>>>>                   return false;
>>>>           }
>>>>
>>> This is incorrect, if ciphertext_hiding_asids module parameter is never specified, user will always
>>> get a warning of an invalid ciphertext_hiding_asids module parameter.
>>>
>>> When this module parameter is optional why should the user get a warning about an invalid module parameter.
>> Ack, sorry, new diff below that fixes this.
>>
>>> Again, why do we want to do all these checks below if this module parameter has not been specified by
>>> the user ?
>> Not sure what you mean by 'below' here (assuming in the resulting code), but, in general, there are less checks with this diff than the original v7 code.
>>
>>>> -       if (isdigit(ciphertext_hiding_asids[0])) {
>>>> -               if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr))
>>>> -                       goto invalid_parameter;
>>>> -
>>>> -               /* Do sanity check on user-defined ciphertext_hiding_asids */
>>>> -               if (ciphertext_hiding_asid_nr >= min_sev_asid) {
>>>> -                       pr_warn("Module parameter ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
>>>> -                               ciphertext_hiding_asid_nr, min_sev_asid);
>>> A *combined* error message such as this:
>>> "invalid ciphertext_hiding_asids XXX or !(0 < XXX < minimum SEV ASID 100)"
>>>
>>> is going to be really confusing to the user.
>>>
>>> It is much simpler for user to understand if the error/warning is:
>>> "Module parameter ciphertext_hiding_asids XXX exceeds or equals minimum SEV ASID YYY"
>>> OR
>>> "Module parameter ciphertext_hiding_asids XXX invalid"
>> I tend to disagree. If, e.g., the user sets ciphertext_hiding_asids=100, they see:
>>
>>       kvm_amd: invalid ciphertext_hiding_asids "100" or !(0 < 100 < minimum SEV ASID 100)
>>
>> which the user can easily unmistakably and quickly deduce that the problem is the latter - not the former - condition that has the problem.
>>
>> The original v7 code in that same case would emit:
>>
>> kvm_amd: Module parameter ciphertext_hiding_asids (100) exceeds or equals minimum SEV ASID (100)
>>
>> ...to which the user would ask themselves "What's wrong with equalling the minimum SEV ASID (100)"?
> I disagree, the documentation mentions clearly that:
> For SEV-ES/SEV-SNP guests the maximum ASID available is MIN_SEV_ASID - 1.
>
> Which the above message conveys quite clearly.

The point of clear error messaging is to avoid the user having to 
(re-)read the documentation.

>
>> It's not as immediately obvious that it needs to (0 < x < minimum SEV ASID 100).
>> OTOH, if the user inputs "ciphertext_hiding_asids=0x1", they now see:
>>
>>       kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < minimum SEV ASID 100)
>>
>> which - unlike the original v7 code - shows the user that the '0x1' was not interpreted as a number at all: thus the 99 in the latter condition.
> This is incorrect, as 0 < 99 < minimum SEV ASID 100 is a valid condition!

Precisely, meaning it's the '0x' in '0x1' that's the "invalid" part.

> And how can user input of 0x1, result in max_snp_asid == 99 ?

It doesn't, again, the 0x is the invalid part.

> This is the issue with combining the checks and emitting a combined error message:
>
> Here, kstroint(0x1) fails with -EINVAL and so, max_snp_asid remains set to 99 and then the combined error conveys a wrong information :
> !(0 < 99 < minimum SEV ASID 100)

It's not, it says it's *OR* that condition.

> The original message is much simpler to understand and correct too:
> Module parameter ciphertext_hiding_asids (-1) invalid

Which is wildly different from any possible derivation of 0x1.

>> But all this is nothing compared to the added simplicity resulting from making the change to the original v7 code.
> I disagree, combining checks and emitting a combined error message is going to be more confusing to the user as the above case of (ciphertext_hiding_asids=0x1) shows.

I don't, but nevertheless, it can still be differentiated and still be 
cleaner code than the original v7...

> Thanks,
> Ashish

Thanks,

Kim


