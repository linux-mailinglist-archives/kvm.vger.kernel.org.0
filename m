Return-Path: <kvm+bounces-14726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C46A38A635C
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 07:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C624282A0B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 05:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A333C6A6;
	Tue, 16 Apr 2024 05:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zgNG4HJW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42B23C060;
	Tue, 16 Apr 2024 05:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713247062; cv=fail; b=gldDbq5suvpP5cc+9knLl0duWJ1rzHwXh+Zcx79d1nEWtXRffvRhM2UwnMLxfXzMsnuw9s4V0buQkKxK/5JphUd3avGjrMy1AjfQvh1yg/M3wnYQgjyQMf2daZ8RsYdl5tTKEZ95uKr0iVuJ0CkizEc8MS32Ams9/95jwWDFTnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713247062; c=relaxed/simple;
	bh=7+42H2ElqM7quvXIwGPv75RTkkbHbh7zjcji0S2+x34=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j81pO6QFfHXGQxB6wv8r9E8llJU4Q2vvvUYxyC0/y9vNpudCY5ZFqtCa9qj87vbuymOa3k3HbcMu1mbdVofxbKgvF7tqOvowGORoSkqchxB9DKUDsuAcbxi0nEOVVU9m2x9B3AZZEhGuExuQK1E8DYRZR7ca+6niZK4JyniiXxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zgNG4HJW; arc=fail smtp.client-ip=40.107.223.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivHaGkFOyZZfEq1wJIiuliBLAv9eN0IGMFN8yDnq5D8vbRHKO3pOGyTh7cE8tpUYxYC7D3CqDsG/ADkQu/V5sOUm//SD3XsbDj/A+M1bJIR5R6aHdXdjgCWp4FYIikX2DvPAvU/u6fzECCNDK6rhIH/IhhdUNDVsNfmKMV5fqztqStlaN5VQjXfbONMwMDkwnsDAA2QRFMhVK09eBgYBzH1KINa2XRCwG2h71xw/9di05fDdasSEn0L3ELzEJMavPHvTDwqcKR4KZRvAoSIbtKFfgq5NN4vN8NDDtTfhvy9MkuCe7TfcxzyhuqULcJZ1TcGsa0PFR1MQuU+zIK50Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZxsrEA6nYSYwfDgfDJ4Gt/ZhG1nJIyFGmdemlZM3n0=;
 b=hZ49RzY9NeALeiQtEY9PgoHeU+P/k+1/e9z+Mx9liUXz46Oi5siD0jgJVqpgtiD/uHbSOzA0/WBW6f1rmlAA1hunYiLwRh5K/IKW23XVi3/xcKhhxCtfVaGHPDsjhSwzjqF1U+m+15gDe9XnfPlGv9ShiJPwVK1d//QCkHpmL2ZTZ5320EZuVPgAM0EAiho6WdtCrnDdpLiCg61ZYFs/eXPe4I+UzD2mfNk4giGJqcxvoEkIsX3G3TQzvVGLA5u7xjaxnIBX0W8f7z1lFhv3U6i5kYZSthY2g1mIJ7bzn6WJrauVq/PS1fTSb3R/OjoZc6e9eDj4gveRxQds9AvrPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZxsrEA6nYSYwfDgfDJ4Gt/ZhG1nJIyFGmdemlZM3n0=;
 b=zgNG4HJWAj8z9QDyHllgUTv9MjCxHwhlVH+2c9OiNZUAQoRP6sSmHmyYTrV5/TB1twYXG9os3E0SJST0RN1P471b2pn0yKKa+8OzYnzDhdl72YLEe6XgrB2EzEcuLkNxBX69Yq+f1JezT9r5bC0uWsvFOTQoFWmbEwcby02gk4Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.50; Tue, 16 Apr 2024 05:57:36 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 05:57:36 +0000
Message-ID: <74f17321-42ed-417c-ad24-8bc4e7207117@amd.com>
Date: Tue, 16 Apr 2024 11:27:24 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 04/16] virt: sev-guest: Add vmpck_id to snp_guest_dev
 struct
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-5-nikunj@amd.com>
 <20240409102348.GBZhUXND0CDk7tGv8a@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240409102348.GBZhUXND0CDk7tGv8a@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0175.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::20) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CY5PR12MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d559a0d-5742-4e5f-bfac-08dc5dda1da1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bN5ozvQuwSjZFUjvsFa7XKwKQPViKGvb4tZgWpmHTJC9q8eUwsZc2TBTENwftV/pz2SjkC8j4DX+eJa7ZQ7JdqDCPVFktG5/LtxKaod7SnCDz35ijd/5vqGDl6eH7hoXHHJCtzUsB1Re8LDikSd+RzK5ehZdS8uR41rXq6o1aY4NYkIWp91LJhRQtvFd/cXo4/+doYZ0EUFCDkLqblepfkDphTDZ3XDDcyhQyMSwpMXnlJWFEj6KVf7xuHXdtpDM25wkxPUn/X4++b2jOq2wNc547Kcqpi4fMZB8DZrtrxBdtv5HWmsit5HrwSXf3IHagost3b8KveFFHU9sjZb1vvM7w4r5kmNHqMAoh4/xU7G9xlc7czJmYoWpcB8+8YgKS62HnoAWi5MsT5E7d3VoIiIXgiuLll0su6BN1HW54aSASePwr7c7PNF4HYsK5ouhiWJGnsuJZx1QF9AxTe11RA5mhltVOZRmiHyFChfZJBr3+NBJQQqGW62IKLoWoFnOCzuSIdM+iBrcid5TSCXuZe/NKHdKYtnra0FvVz9TsyfoXFgDoLuWxOY86OCQXprC4znwHe8Au7GOd99rkV0HYXQcg7cQy+RTspGcrmA6OCc/g3VOBtyNFjfg8oIq0XqSKWyqQmclhqRH00adZSp7XIzV5oEGJ1TQJfzjWUiGeRE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajBsWU01WWhVdjZoVlJwN21ERGZpV2l3aGlrL25TTGEydlpmak44WkoxeCtB?=
 =?utf-8?B?NzNhOGFuU3Fuak5wZ0xRc05TZ3VVSVJieWZSTUlwOTUzajkxRFUyaHFKc0M3?=
 =?utf-8?B?aGJCUXpsY29BalZRL1VMUG82UFp6TVYxdHlnaUtySVpPZXVBL0laTzRPc0ZF?=
 =?utf-8?B?azFoRjRGZ2MwaUl6c0dtMnFIUmVjSzg0VCtCN2FOa2VtVHhteExIL25BQk9Y?=
 =?utf-8?B?K0x3MXoxSjlSN3RidWFXbFIzcytDQkhVbDNMekxaSDNuUmRiQUd1S3l5ZXdR?=
 =?utf-8?B?OUs1cTZFakJzc1dFWG9VRERYc1FUMTcvRklrbGJaYlF0V3A3WlpYRWN5eEVx?=
 =?utf-8?B?L3lIZU8yV2ZrcXhOZDJWKzdmSGRHQmY3L3lwTjBtTHdjRWtnL1c3RG5CWG5O?=
 =?utf-8?B?ZzVJd0hzNnd2SURNRER1eE1jR2MvMGlOT1lPdWs0VmFsdXhpMDZhNUp5L29K?=
 =?utf-8?B?VmF6b1RyNlUwbENSZ1RCdnJrTVhBS2E3RjJiK3dQMS83NjZJNzM3WEU2bG5Z?=
 =?utf-8?B?WFdmSHpwV2Z2V2NWRkRHN0wxcHNKK050T2NGcG1CKzBmOENiMGtSR1A3bEo5?=
 =?utf-8?B?aEpvdGNRenN0dCtndkJHaTBMblM4UENlaVF0UmhSMElZQWNBeW9OZlM1SXUr?=
 =?utf-8?B?WWtnQ2Q4TXBzTlQreVpPQ0ROK0w3YjhYMHVMUHRhVk9FTnduU1RBK2lYbm5i?=
 =?utf-8?B?cWhIbXk4K01BSWhaYnRMY2plQXR4aWZ1KzBlYzgvL0RvUGF3UHY3cXRVQUZw?=
 =?utf-8?B?KzA2R3J6ZkpwbzhQdGcxVmoyOUIwTG9vdm9EZmhwMVVOWWJyeElQNXdzRkZ0?=
 =?utf-8?B?NG9jbDNzMW8wZURYaFJkNit0OE56YzZncnRwQzg4SUVPRHRzSjVGUkRBZUdQ?=
 =?utf-8?B?WStnYU5IYlFIWVB6NnBaN1hRT2hzVXhwYW9ZZnd6cFZPYnpnem9jYktHL1Jo?=
 =?utf-8?B?elU4ZmlMQUJpZnk3bndDbFdSUW1Pd2Y5V0s1Wk4vaGd2Y0FEK2l5Y3dRbzRG?=
 =?utf-8?B?WlA4SnYyMk9WTTVxbVd5NEljN3gyd1doY3U2WjJzNS8yRS9FYzZJSndVL0tV?=
 =?utf-8?B?Z2lFcXdUNW5PQVlibjl0aE9pcFczWXRKMHV2VUhKeUcyT0RZaWVrcytYYXFs?=
 =?utf-8?B?QWNkRWYrZFo0UGtJaUdQbTFLYW5qNmp2dmo0dTU5Tk92dU9jclByalhDc2Zq?=
 =?utf-8?B?MFVFYUljSWdRZUdIdUFIbFVML2VtUEQ0UEZ4SmxrYWErVTNYRnhsZ1p1TkhK?=
 =?utf-8?B?YjRBL2lna3dIZTZUTllwV1hIRzZrdnlaZXU3Z3RmTk5XODhRNEtJUXVIOFo1?=
 =?utf-8?B?a2gwV3NJZlJzMjBwN04wbE5lY1pnZ2pQYzRBckJpNkpZNTFmUmthVjV0UVhX?=
 =?utf-8?B?N1NUa0ZJemhvNVk5aUFnUkt0c1h3cUF2Ny9JVHBENkpwbWZsTSsvdmd2RmhH?=
 =?utf-8?B?cFltcldZWjV4bTJSSXMxQ1NVVm5zdjQyMHU5WEZacXppajBSMFhsa2VNZ0dp?=
 =?utf-8?B?Uk5lcjNrd29xNVI5eUtaeGswMnU4MHNZMVR3a1VkemdCSDFhRFZacEQ3Mlho?=
 =?utf-8?B?YjY4QWVqd1dVeCtYZU0rZ3J5WGY3QzdNb09NbEZSQ3k4Z0tlcGRndmVHaHFJ?=
 =?utf-8?B?VXlCdkpkRE9QeUZabUcyRzFoeEt1TXN5azNKSkxaTExqL1d6OWQvSHBWcVkw?=
 =?utf-8?B?V21HQk1ybWJsaDhUbW5GUnljWnY4ekxkR3BkT0YwVjFIcXYzK3JnSE5HWlZl?=
 =?utf-8?B?UktxeDJta2xINkR4WU9LK0Y2aUY4ZWg5aEIzSW5xRjhCc0RCLyt6NTF6SmFo?=
 =?utf-8?B?bGx3MjU5SXYySGxoMWN5L2ZFTHFZQno5RXl1T3U1TUk1Z0pMSEl5LzFUUEdS?=
 =?utf-8?B?Qnh1allCSGtGOUVLMXJCaG5QYTMrYW5XYUc3RTdhYk9rVjY5UC9wRlBoUkxX?=
 =?utf-8?B?U1I2SWp1TlRVS2RGdWUwMGgvMUFYUUVkYmxETGRhZW1MV254WWV5M3Y0b2xJ?=
 =?utf-8?B?b2Jhdnltb2sxYTJNcFpONFQ1OEZJc09uc0tPRUo2TUp3STQ2Q2cweVVPSWd6?=
 =?utf-8?B?QU5pb0RGQ2pzNXRHOXlPVWw1M01PS3JFOEFxWW1MTzJHM2NQT29FRGMzMFZz?=
 =?utf-8?Q?bySc0B7Kv7SFPFHCYe+VTxL64?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d559a0d-5742-4e5f-bfac-08dc5dda1da1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 05:57:36.4682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 528J3+t/fdMsy3EnmbBDxj1WUdWIFSkM8BW0/K0zljS6HU/nwQnEfKf3a+TAwgbc9DWYqQxBnQwwBLoKLgDmag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6369

On 4/9/2024 3:53 PM, Borislav Petkov wrote:
> On Thu, Feb 15, 2024 at 05:01:16PM +0530, Nikunj A Dadhania wrote:
>> Drop vmpck and os_area_msg_seqno pointers so that secret page layout
>> does not need to be exposed to the sev-guest driver after the rework.
>> Instead, add helper APIs to access vmpck and os_area_msg_seqno when
>> needed. Added define for maximum supported VMPCK.
> 
> Do not talk about *what* the patch is doing in the commit message - that
> should be obvious from the diff itself. Rather, concentrate on the *why*
> it needs to be done.
> 
> Imagine one fine day you're doing git archeology, you find the place in
> the code about which you want to find out why it was changed the way it
> is now.
> 
> You do git annotate <filename> ... find the line, see the commit id and
> you do:
> 
> git show <commit id>
> 
> You read the commit message and there's just gibberish and nothing's
> explaining *why* that change was done. And you start scratching your
> head, trying to figure out why...
> 
> I'm sure you're getting the idea.

Sure, will reword the commit message and send the patch.

> 
>> Also, change function is_vmpck_empty() to snp_is_vmpck_empty() in
>> preparation for moving to sev.c.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
>> ---
>>  arch/x86/include/asm/sev.h              |  1 +
>>  drivers/virt/coco/sev-guest/sev-guest.c | 95 ++++++++++++-------------
>>  2 files changed, 48 insertions(+), 48 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 0c0b11af9f89..e4f52a606487 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -135,6 +135,7 @@ struct secrets_os_area {
>>  } __packed;
>>  
>>  #define VMPCK_KEY_LEN		32
>> +#define VMPCK_MAX_NUM		4
>>  
>>  /* See the SNP spec version 0.9 for secrets page format */
>>  struct snp_secrets_page_layout {
>> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
>> index 596cec03f9eb..646eb215f3c7 100644
>> --- a/drivers/virt/coco/sev-guest/sev-guest.c
>> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
>> @@ -55,8 +55,7 @@ struct snp_guest_dev {
>>  		struct snp_derived_key_req derived_key;
>>  		struct snp_ext_report_req ext_report;
>>  	} req;
>> -	u32 *os_area_msg_seqno;
>> -	u8 *vmpck;
>> +	unsigned int vmpck_id;
>>  };
>>  
>>  static u32 vmpck_id;
>> @@ -66,14 +65,22 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
>>  /* Mutex to serialize the shared buffer access and command handling. */
>>  static DEFINE_MUTEX(snp_cmd_mutex);
>>  
>> -static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>> +static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)
> 
> static functions don't need a prefix like "snp_".

Sure

> 
>>  {
>> -	char zero_key[VMPCK_KEY_LEN] = {0};
>> +	return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LEN;
>> +}
>>  
>> -	if (snp_dev->vmpck)
>> -		return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
>> +static inline u32 *snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
> 
> Ditto.

Sure

> 
>> +{
>> +	return &snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
>> +}
>>  
>> -	return true;
>> +static bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev)
>> +{
>> +	char zero_key[VMPCK_KEY_LEN] = {0};
>> +	u8 *key = snp_get_vmpck(snp_dev);
>> +
>> +	return !memcmp(key, zero_key, VMPCK_KEY_LEN);
>>  }
>>  
>>  /*
>> @@ -95,20 +102,22 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>>   */
>>  static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>>  {
>> -	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
>> -		  vmpck_id);
>> -	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
>> -	snp_dev->vmpck = NULL;
>> +	u8 *key = snp_get_vmpck(snp_dev);
> 
> Check whether is_vmpck_empty before you disable?
> 
>> +
>> +	dev_alert(snp_dev->dev, "Disabling vmpck_id %u to prevent IV reuse.\n",
>> +		  snp_dev->vmpck_id);
>> +	memzero_explicit(key, VMPCK_KEY_LEN);
>>  }
>>  
>>  static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>>  {
>> +	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
>>  	u64 count;
>>  
>>  	lockdep_assert_held(&snp_cmd_mutex);
>>  
>>  	/* Read the current message sequence counter from secrets pages */
>> -	count = *snp_dev->os_area_msg_seqno;
>> +	count = *os_area_msg_seqno;
> 
> Why does that snp_get_os_area_msg_seqno() returns a pointer when you
> deref it here again?
> 
> A function which returns a sequence number should return that number
> - not a pointer to it.
> 
> Which then makes that u32 *os_area_msg_seqno redundant and you can use
> the function directly.
> 
> IOW:
> 
> static inline u32 snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
> {
>         return snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;

This patch removes setting of layour page in snp_dev structure.

static inline u32 snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
{
        if (!platform_data)
                return NULL;

        return *(&platform_data->layout->os_area.msg_seqno_0 + vmpck_id);
}

> }
> 

> Simple.
> 
>>  
>>  	return count + 1;
>>  }
>> @@ -136,11 +145,13 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>>  
>>  static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
>>  {
>> +	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
>> +
>>  	/*
>>  	 * The counter is also incremented by the PSP, so increment it by 2
>>  	 * and save in secrets page.
>>  	 */
>> -	*snp_dev->os_area_msg_seqno += 2;
>> +	*os_area_msg_seqno += 2;
> 
> Yah, you have a getter but not a setter. You're setting it through the
> pointer. 

I had a getter for getting the os_area_msg_seqno pointer, probably not a good function name.

> Do you see the imbalance in the APIs?

The msg_seqno should only be incremented by 2 (always), that was the reason to avoid a setter.

> 
>>  }
>>  
>>  static inline struct snp_guest_dev *to_snp_dev(struct file *file)
>> @@ -150,15 +161,22 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
>>  	return container_of(dev, struct snp_guest_dev, misc);
>>  }
>>  
>> -static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
>> +static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
>>  {
>>  	struct aesgcm_ctx *ctx;
>> +	u8 *key;
>> +
>> +	if (snp_is_vmpck_empty(snp_dev)) {
>> +		pr_err("VM communication key VMPCK%u is null\n", vmpck_id);
> 
> 		      "Empty/invalid VMPCK%u communication key"
> 
> or so.
> 
> In a pre-patch, fix all your user-visible strings to say "VMPCK"
> - capitalized as it is an abbreviation.

Sure, will do.

> 
>> +		return NULL;
>> +	}
>>  
>>  	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
>>  	if (!ctx)
>>  		return NULL;
>>  
>> -	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
>> +	key = snp_get_vmpck(snp_dev);
>> +	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
>>  		pr_err("Crypto context initialization failed\n");
>>  		kfree(ctx);
>>  		return NULL;
>> @@ -590,7 +608,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>>  	mutex_lock(&snp_cmd_mutex);
>>  
>>  	/* Check if the VMPCK is not empty */
>> -	if (is_vmpck_empty(snp_dev)) {
>> +	if (snp_is_vmpck_empty(snp_dev)) {
>>  		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>>  		mutex_unlock(&snp_cmd_mutex);
>>  		return -ENOTTY;
>> @@ -667,32 +685,14 @@ static const struct file_operations snp_guest_fops = {
>>  	.unlocked_ioctl = snp_guest_ioctl,
>>  };
>>  
>> -static u8 *get_vmpck(int id, struct snp_secrets_page_layout *layout, u32 **seqno)
>> +static bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
>>  {
>> -	u8 *key = NULL;
>> +	if (WARN_ON((vmpck_id + 1) > VMPCK_MAX_NUM))
>> +		return false;
> 
> So this will warn *and*, at the call site too. Let's tone that down.

Sure.

> 
>>  
>> -	switch (id) {
>> -	case 0:
>> -		*seqno = &layout->os_area.msg_seqno_0;
>> -		key = layout->vmpck0;
>> -		break;
>> -	case 1:
>> -		*seqno = &layout->os_area.msg_seqno_1;
>> -		key = layout->vmpck1;
>> -		break;
>> -	case 2:
>> -		*seqno = &layout->os_area.msg_seqno_2;
>> -		key = layout->vmpck2;
>> -		break;
>> -	case 3:
>> -		*seqno = &layout->os_area.msg_seqno_3;
>> -		key = layout->vmpck3;
>> -		break;
>> -	default:
>> -		break;
>> -	}
> 
> Your commit message could explain why this is not needed, all of
> a sudden.

This was replaced by two independent APIs returning pointers to VMPCK and seqno pointer.

static inline u8 *snp_get_vmpck(unsigned int vmpck_id)
{
        if (!platform_data)
                return NULL;

        return platform_data->layout->vmpck0 + vmpck_id * VMPCK_KEY_LEN;
}

static inline u32 *snp_get_os_area_msg_seqno(unsigned int vmpck_id)
{
        if (!platform_data)
                return NULL;

        return &platform_data->layout->os_area.msg_seqno_0 + vmpck_id;
}

I will add more details.

> 
>> +	dev->vmpck_id = vmpck_id;
>>  
>> -	return key;
>> +	return true;
>>  }
>>  
>>  struct snp_msg_report_resp_hdr {
>> @@ -728,7 +728,7 @@ static int sev_report_new(struct tsm_report *report, void *data)
>>  	guard(mutex)(&snp_cmd_mutex);
>>  
>>  	/* Check if the VMPCK is not empty */
>> -	if (is_vmpck_empty(snp_dev)) {
>> +	if (snp_is_vmpck_empty(snp_dev)) {
>>  		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>>  		return -ENOTTY;
>>  	}
>> @@ -848,21 +848,20 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>>  		goto e_unmap;
>>  
>>  	ret = -EINVAL;
>> -	snp_dev->vmpck = get_vmpck(vmpck_id, layout, &snp_dev->os_area_msg_seqno);
>> -	if (!snp_dev->vmpck) {
>> -		dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
>> +	snp_dev->layout = layout;
>> +	if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
>> +		dev_err(dev, "invalid vmpck id %u\n", vmpck_id);
>>  		goto e_unmap;
>>  	}
>>  
>>  	/* Verify that VMPCK is not zero. */
>> -	if (is_vmpck_empty(snp_dev)) {
>> -		dev_err(dev, "vmpck id %d is null\n", vmpck_id);
>> +	if (snp_is_vmpck_empty(snp_dev)) {
>> +		dev_err(dev, "vmpck id %u is null\n", vmpck_id);
> 
> s!null!Invalid/Empty!

Okay

> 
>>  		goto e_unmap;
>>  	}
>>  
>>  	platform_set_drvdata(pdev, snp_dev);
>>  	snp_dev->dev = dev;
>> -	snp_dev->layout = layout;
>>  
>>  	/* Allocate the shared page used for the request and response message. */
>>  	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
>> @@ -878,7 +877,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>>  		goto e_free_response;
>>  
>>  	ret = -EIO;
>> -	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
>> +	snp_dev->ctx = snp_init_crypto(snp_dev);
>>  	if (!snp_dev->ctx)
>>  		goto e_free_cert_data;
>>  
>> @@ -903,7 +902,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>>  	if (ret)
>>  		goto e_free_ctx;
>>  
>> -	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
>> +	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %u)\n", vmpck_id);
> 
> Yet another spelling: "vmpck_id". Unify all those in a pre-patch pls
> because it looks stupid.

Sure
> 
> Thx.
> 

Thanks for the review.

Regards
Nikunj


