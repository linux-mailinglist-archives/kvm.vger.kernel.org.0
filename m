Return-Path: <kvm+bounces-54528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11A0DB22E37
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 18:51:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46D63684B7D
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 16:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B872B2F90F1;
	Tue, 12 Aug 2025 16:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ri9UvlLi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2048.outbound.protection.outlook.com [40.107.96.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0348D1E501C;
	Tue, 12 Aug 2025 16:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755017115; cv=fail; b=NCkA+DUBN/l4kDZFdKqz+KO5ATl2v4eDngO2vn3uzufDt9xrWUwjo4Jg/SUwTCwl3hihDGQpbIo8kovkkTxRaAON5hN7Z4cSTGceGQU2LZdI3YqhS0D73w5UW5nDAeK7wDS1FYZoxeCteIoJGQ0JO0UAUfcQi2N7S4oUIjDVgQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755017115; c=relaxed/simple;
	bh=z3jkT+36Z3Y9K7lbTozYPsZE18K3g76tHbHllbY4ufk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=P/+Zz3z1AXGj2tXpw7Y1dhPzCa81Xf9iGmamyFRKlWnXJmnlhw+vbnPdJRT8xWr3TgnEuZYkoHkj2mGeUVl7dlS5rI4Sg6GZYkZ6BP5sjeb7aeJy9ge3U4LKJ/dZJJ9BfTPJJIeOESnx3RGoAq58XkdLjaaGTOi81pL3DkoaFHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ri9UvlLi; arc=fail smtp.client-ip=40.107.96.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Du9YqNhD4AtOlQX25RqV5zQWU5Gj4swS3eYlX0fW77GJywTZiJ/dWT0pcca0dW6PbwaTVy3Z5i4p40Gsm5fUBfwUsgzcemTFEiUeAGCw6h+A9dznvnjiAKiQQfGGgysXJ/0hBBHYAzTetsGJzQF1Chr79ZAvImbN9z175x5eEGzn5zjBUdWpuoWvcu8twJ8UTw++1COJL9yrDc4Ljbes5Vz6M3XhE/0E51Gol5Flqr9mJsoz2m8ikGZocidNb4KuhIZ1WNbQl2K7slljAXfyUuFswvEL7k7zBrkh1YChh0gg01FQAoUKeSQnpHtIOPH/rhrDljUR3EfWPFKG13TeXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sr0IVXpWluZCVS6P5XLYx+AuVFBsOYWbkoDMAA7klg=;
 b=ME5DVacphOTYGYlPOdv3dQdd8xX1d8iwLPbbtMtyCgPdNTOHmt8y8kx0VotSBn1hLVG/o9j+MrWQ7CVjEABk8FZo0epKsq28i3Y0rsgg7OwFSiJE5+uCAlW53YIYMo4sWTVdNt+J57bOhUjxt8FaMkjZazNrAMBTvSdxQ6udB+jAWhzLU+qyJ4gz+V2F98PmbTkXmp3ki+RwiRwXfH+y/Ev9MNUtzxZ40jyvqZtzKqqtGgpC97s80hUJWhwsnM1mAkbtN/fHci3PTfN3b+A1tpLtg99PiPf8XYLqXOPf93jlE1wGkY/wDHIfTjckk88y0yRRicb4vdJByDgBvfmxfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sr0IVXpWluZCVS6P5XLYx+AuVFBsOYWbkoDMAA7klg=;
 b=Ri9UvlLiYZGsh4HXNfb+GHfngI2ZZuinPwOFOtetH9ateAnuO//u0XT+qbwOWXt6EyDWmSO87rSohz+rr7R+EBRYxAJipJW1junT1Usdfto4qTmvGoDtAECkDqZYCNRoZyjNTKQWilZEPactK/zS6uqgicnFsjq6Gubkh+dY/Ao=
Received: from BY5PR13CA0019.namprd13.prod.outlook.com (2603:10b6:a03:180::32)
 by DS0PR12MB7559.namprd12.prod.outlook.com (2603:10b6:8:134::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Tue, 12 Aug
 2025 16:45:09 +0000
Received: from CO1PEPF000042AB.namprd03.prod.outlook.com
 (2603:10b6:a03:180:cafe::ee) by BY5PR13CA0019.outlook.office365.com
 (2603:10b6:a03:180::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.14 via Frontend Transport; Tue,
 12 Aug 2025 16:45:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AB.mail.protection.outlook.com (10.167.243.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Tue, 12 Aug 2025 16:45:08 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 12 Aug
 2025 11:45:01 -0500
Message-ID: <a6864a2c-b88f-4639-bf66-0b0cfbc5b20c@amd.com>
Date: Tue, 12 Aug 2025 11:45:00 -0500
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
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <5a207fe7-9553-4458-b702-ab34b21861da@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AB:EE_|DS0PR12MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: 531a50a1-1775-4eb2-5137-08ddd9bf9951
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjJzbnJaRGV0b2Q0ZlRQZWVFbzFBMWVZZ2FpQTZJYkNMcEszbzBSRTRJcTV6?=
 =?utf-8?B?UTBtcjRFWkdoRSszc1MveGppcU9jdVB1ZzQxRDl4WjE1TjI2Z25lbmtHUlJQ?=
 =?utf-8?B?Z2JaaHJxeWRUalBZNFNKaEd0RmVHbFkyUEtvVzFNTEJ5ZlVPUktxUm5jblZv?=
 =?utf-8?B?czAwWnRpaXZpTksrMXZqcUFmYTFzeWFmK0MrQlVQcm5NRGNhS1VLdjZuMmx5?=
 =?utf-8?B?T0tUUldDbm50V0tsYStZNFJLRnNYcWZWNXI5eTMrTFIxazkyekIveElJbXZY?=
 =?utf-8?B?Mlo4c1UvZ3czTTNtM0xrTlNUd1Jrc2h2RWNGRUhsUW9tMUdMeGVJNmNkUlp2?=
 =?utf-8?B?Z2psUjB2WVVGNFYydDZnNmRvKzFSR3VJMUU3WElDSGZWV2hQQzFjbFZYVGMv?=
 =?utf-8?B?ZFVzRituQVNEbUVRWmNKZmkzcUJCT0s5YU5lYTJGN3ZYRjVXSVdZOEU3R3FG?=
 =?utf-8?B?QjVBTkpSZ0JWN2QzQ3JDUGI5U3UxcUJyNVBEaGFpdEdWY2VPcXE2bWlyci9z?=
 =?utf-8?B?MVgxVnNCeHJXek04SURtcHJCc2ZuYm5rcWcyRkpSWVllWC9JL2p6WG84cS9w?=
 =?utf-8?B?MC92cWFGU1Btc2VSa1FJNjJHNGh3aGIrbjNxY1pjbTdWTGVUdnM4U0dadkl3?=
 =?utf-8?B?Nk5tUGVoY2JuNENqTjJMU01EdGtDVE16aWFxaEpkT3hwaDFXckFMZ0E2aVN3?=
 =?utf-8?B?SndZRU9QT3M4WEh3aWRLUDBMRVdsN2Y1Q21MVDRrYWtqQ0pHVnBoSlpEV2N2?=
 =?utf-8?B?L1k5R2MvWWRXMDR2Z1NKS013clhKWmhaRXNaWFk0M1g4VkdMUVJBZmRKWitn?=
 =?utf-8?B?T1g2UDJqNTBrRE9BMi9NaWVBcVhwQU41SlFZMTlIdFZTK2x1K0Q3RkQ5YytG?=
 =?utf-8?B?KzhPZUtVcWdENDBjN2RtZDdZdG45NTFjTFpQWS9zOVpmSUZINzlGZkdEc04r?=
 =?utf-8?B?WWtqMjhkeDZTazNxb0JwZmNUZ3JQbUxTRE9xSjN2SC9STzV1OHc4N2hMZ094?=
 =?utf-8?B?MkNXNmV4UzVMWVY0WmtUU0ErTUJEdFVDU21Od0h2c1dScDhsSFVFakRlWHgx?=
 =?utf-8?B?b0ozbXJ1SDlqeSswUlZINjlZNFRsVlpKdmlaRDVLU3YySDdHdmdoWlg5cmNJ?=
 =?utf-8?B?VXkvbERHVnRYSFBRSjd3aEhXZHg1WHhDN1ZINW13a1NJWTA5aXM2SXEzdURi?=
 =?utf-8?B?SExLN2laWVFxZEl0MU9JNTFFZ3k4Yk5sNkNNdWVIcEx1Z2NyNDJNRjlxTUJH?=
 =?utf-8?B?VjBReWxsTGJURnBYRUNPeWx4ZG03RzY5Q3EvZkZYTjFVNGZZRTh4UG14bjhY?=
 =?utf-8?B?TWlWSWEwZjZCdlY4em1xZzZEV29NZWozOUc3eUdXWFNLTEFmUVNWMW5Fbi9Y?=
 =?utf-8?B?b3pKSUJ4TUt5WUduMS9HQ04xRGFBTjJIN21YdEJhNGxhVlo4elR3ay9NWHVn?=
 =?utf-8?B?N3lGM0YySDZEOHQ5eXU5S3J4VEc2OU1OOUNrUm9XaDNSeStJaFhmejhhTkhG?=
 =?utf-8?B?Q1l1TDlqc1gwajZqVEdFSzJUYWZ4RlVyUDVsNDhGdGlOM2RUdXFiTjhtcjQ4?=
 =?utf-8?B?eVZjTTkwcXV3ajBhR1BvNHVReDg0U282U3d2WjZjSndndXhHL2Q0VjdCeHpl?=
 =?utf-8?B?SWVQUHBNckxJMkFydzZINnplRDlLTTJrYVBXMVZZTktUN0Q0UDZxVGNwS3Z6?=
 =?utf-8?B?R2VEcWRrKzU3a2dQcndpQWpGc3pXc3lxN3UyRW4zNTJBcVBJcWhjWWlrMVBP?=
 =?utf-8?B?ZnZJbHRyU1JDREM0Vy9lTG5ocm1DRFhNN0RqOVlxRDJ5dG00Vll2Nm1KNExz?=
 =?utf-8?B?aUt5L3dmVWhhcW1UMit2TTRXWnBvTVFvV0RnV3ZDR1hhWnZObGR2ZmExK3Bt?=
 =?utf-8?B?ekpFRUlsZENHZ1licklZai9ZSmxVclhzSFF2dEtRdXZVL0ZyQVFCd1RoWW5Z?=
 =?utf-8?B?enNrSlZTWHRPK3RtSHNwYWVTZ3dpcTB5V2xVekVDQlYzQ2hnOUpQSlRoQldk?=
 =?utf-8?B?cHA2SkFBNjBBZVRxaS9EbEZ6Y2tTMWo2ck5hQ1lrY0N3OE5aZFltaUxBVzha?=
 =?utf-8?B?UjFuVlh3NnNjZEx1Ty8vRVhlVjFOZlltN3Y0QT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 16:45:08.9353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 531a50a1-1775-4eb2-5137-08ddd9bf9951
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7559

On 8/12/25 9:40 AM, Kalra, Ashish wrote:
> On 8/12/2025 7:06 AM, Kim Phillips wrote:
>>   arch/x86/kvm/svm/sev.c | 47 ++++++++++++++++++-----------------------------
>>   1 file changed, 18 insertions(+), 29 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 7ac0f0f25e68..57c6e4717e51 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2970,42 +2970,29 @@ static bool is_sev_snp_initialized(void)
>>
>>   static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>>   {
>> -       unsigned int ciphertext_hiding_asid_nr = 0;
>> -
>> -       if (!ciphertext_hiding_asids[0])
>> -               return false;
>> -
>> -       if (!sev_is_snp_ciphertext_hiding_supported()) {
>> +       if (ciphertext_hiding_asids[0] && !sev_is_snp_ciphertext_hiding_supported()) {
>>                  pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported\n");
>>                  return false;
>>          }
>>
> This is incorrect, if ciphertext_hiding_asids module parameter is never specified, user will always
> get a warning of an invalid ciphertext_hiding_asids module parameter.
>
> When this module parameter is optional why should the user get a warning about an invalid module parameter.

Ack, sorry, new diff below that fixes this.

> Again, why do we want to do all these checks below if this module parameter has not been specified by
> the user ?

Not sure what you mean by 'below' here (assuming in the resulting code), 
but, in general, there are less checks with this diff than the original 
v7 code.

>> -       if (isdigit(ciphertext_hiding_asids[0])) {
>> -               if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr))
>> -                       goto invalid_parameter;
>> -
>> -               /* Do sanity check on user-defined ciphertext_hiding_asids */
>> -               if (ciphertext_hiding_asid_nr >= min_sev_asid) {
>> -                       pr_warn("Module parameter ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
>> -                               ciphertext_hiding_asid_nr, min_sev_asid);
> A *combined* error message such as this:
> "invalid ciphertext_hiding_asids XXX or !(0 < XXX < minimum SEV ASID 100)"
>
> is going to be really confusing to the user.
>
> It is much simpler for user to understand if the error/warning is:
> "Module parameter ciphertext_hiding_asids XXX exceeds or equals minimum SEV ASID YYY"
> OR
> "Module parameter ciphertext_hiding_asids XXX invalid"

I tend to disagree. If, e.g., the user sets ciphertext_hiding_asids=100, 
they see:

      kvm_amd: invalid ciphertext_hiding_asids "100" or !(0 < 100 < 
minimum SEV ASID 100)

which the user can easily unmistakably and quickly deduce that the 
problem is the latter - not the former - condition that has the problem.

The original v7 code in that same case would emit:

kvm_amd: Module parameter ciphertext_hiding_asids (100) exceeds or 
equals minimum SEV ASID (100)

...to which the user would ask themselves "What's wrong with equalling 
the minimum SEV ASID (100)"?

It's not as immediately obvious that it needs to (0 < x < minimum SEV 
ASID 100).

OTOH, if the user inputs "ciphertext_hiding_asids=0x1", they now see:

      kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < 
minimum SEV ASID 100)

which - unlike the original v7 code - shows the user that the '0x1' was 
not interpreted as a number at all: thus the 99 in the latter condition.

But all this is nothing compared to the added simplicity resulting from 
making the change to the original v7 code.

New diff from original v7 below:

  arch/x86/kvm/svm/sev.c | 42 +++++++++++++++++-------------------------
  1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7ac0f0f25e68..a879ea5f53f2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2970,8 +2970,6 @@ static bool is_sev_snp_initialized(void)

  static bool check_and_enable_sev_snp_ciphertext_hiding(void)
  {
-       unsigned int ciphertext_hiding_asid_nr = 0;
-
         if (!ciphertext_hiding_asids[0])
                 return false;

@@ -2980,32 +2978,24 @@ static bool 
check_and_enable_sev_snp_ciphertext_hiding(void)
                 return false;
         }

-       if (isdigit(ciphertext_hiding_asids[0])) {
-               if (kstrtoint(ciphertext_hiding_asids, 10, 
&ciphertext_hiding_asid_nr))
-                       goto invalid_parameter;
-
-               /* Do sanity check on user-defined 
ciphertext_hiding_asids */
-               if (ciphertext_hiding_asid_nr >= min_sev_asid) {
-                       pr_warn("Module parameter 
ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
-                               ciphertext_hiding_asid_nr, min_sev_asid);
-                       return false;
-               }
-       } else if (!strcmp(ciphertext_hiding_asids, "max")) {
-               ciphertext_hiding_asid_nr = min_sev_asid - 1;
-       }
-
-       if (ciphertext_hiding_asid_nr) {
-               max_snp_asid = ciphertext_hiding_asid_nr;
+       if (!strcmp(ciphertext_hiding_asids, "max")) {
+               max_snp_asid = min_sev_asid - 1;
                 min_sev_es_asid = max_snp_asid + 1;
-               pr_info("SEV-SNP ciphertext hiding enabled\n");
-
                 return true;
         }

-invalid_parameter:
-       pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
-               ciphertext_hiding_asids);
-       return false;
+       /* Do sanity check on user-defined ciphertext_hiding_asids */
+       if (kstrtoint(ciphertext_hiding_asids, 10, &max_snp_asid) ||
+           !max_snp_asid || max_snp_asid >= min_sev_asid) {
+               pr_warn("invalid ciphertext_hiding_asids \"%s\" or !(0 < 
%u < minimum SEV ASID %u)\n",
+                       ciphertext_hiding_asids, max_snp_asid, 
min_sev_asid);
+               max_snp_asid = min_sev_asid - 1;
+               return false;
+       }
+
+       min_sev_es_asid = max_snp_asid + 1;
+
+       return true;
  }

  void __init sev_hardware_setup(void)
@@ -3122,8 +3112,10 @@ void __init sev_hardware_setup(void)
                  * ASID range into separate SEV-ES and SEV-SNP ASID 
ranges with
                  * the SEV-SNP ASID starting at 1.
                  */
-               if (check_and_enable_sev_snp_ciphertext_hiding())
+               if (check_and_enable_sev_snp_ciphertext_hiding()) {
+                       pr_info("SEV-SNP ciphertext hiding enabled\n");
                         init_args.max_snp_asid = max_snp_asid;
+               }
                 if (sev_platform_init(&init_args))
                         sev_supported = sev_es_supported = 
sev_snp_supported = false;
                 else if (sev_snp_supported)

Thanks,

Kim


