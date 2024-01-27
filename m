Return-Path: <kvm+bounces-7266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B65C83EABD
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 04:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6A1328933E
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 03:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B73211CBA;
	Sat, 27 Jan 2024 03:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="J/vQtpU4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AB665C;
	Sat, 27 Jan 2024 03:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706327669; cv=fail; b=aFbNjR8SI2JGMNWlaOnghUx2amXM3S/8dqKqmj2hLtYbqvi3gGelEzOUhmgXCw6flui6olMqBF02g2a/mPCPwTMJ5oBESREEoUvmrENIB+TqG8et4w+EIO4jn0dCdkfhIXbZ+0kjlWDMUJpCQDt21MsYTzhog7EbERh4uSxn8ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706327669; c=relaxed/simple;
	bh=zut9fdHx+vnThw0K1+bxfzKF1CANtS/hAYbwAkonFr8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pkkeAJGDzChWFRrvMWJpFaYnwFf++GHE4BSFhBXeFD8Tsu07cvG3Ks8/8VtBgJRtON93en2HUcA+7onsjttr5ogztTtQbNfmWI1Z7iuVunK2/3cP31F5giO0JujcWPOr8jeJ8ME0hMyjGVLov+S6fP5PS6ycbZpngOwUIw95N+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=J/vQtpU4; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmCAMUAfNuiqkYZsROgtjpiGy6QJfgkr4jffWMNlk0OTYVpvhWwXPBQMWtLYjqwE/cwHu5kJI4QyUp4In3/X+JA9YxJ30+AYrmX2n2iFq8lek+b3KCra2Tzvb9sMpADNx3VhqncEg0sa80R8Qw2r9lKNq/QdAfGoARBh+rdxL100hnf82f07yZzAXxLxHk9Qhm7b7/2oiDsGDGHObzryXKu+bTieiGhhEGeYC9WkGWGVBBsxR9SN1E78XPMAkIIO3KKUqAt7w8pk544Ve+B7B9JOa/2Htq7u9RpG9zoxrVBWT3+Rm1598jxtD/B7kDnsFc5SPKrt7J5N7QC9wTMfOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20Ji+SHbtreajnnd8hFs7Q4QfwP1UVPcJQAe1ekPaxY=;
 b=L/Wu42A86bptRuIQZIZCiS7C/wOJgLbrZBXFUia4bwSC1fsrUwLbsyAg33eaTYMs/KpcJb7amOpZX5qhrj2nAXZJeCo2h/I18OnnlA8kLocpV72RqLUsjNI+MPy25hj1P625xkCi2erasQPJqsUoFUeJUjAms8tsk7ufxkHzDBQzmxVOa83VTayqcOQ5dpDrhZporific0uz6MOwmHqRTGARfDnc21Yx0GmV94BwYTj8c1kQnN/+iariO616X1pJlfKlofLtrdIhvU7KZr6weyYyTcWTAxjy9NR0f8+sVh88vIQWzp1TNkFy2OfGJPgAdyV7MNK0YMATK513RRufhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20Ji+SHbtreajnnd8hFs7Q4QfwP1UVPcJQAe1ekPaxY=;
 b=J/vQtpU4OlYmz5niYx0h7pR5xHgt+VazpOBw2GpzeKkjkqLDMO96afdTkiDDeOyC3db68+trtzzjlNDxI+2iKvMQcZKhqI/K2XKBAmKEaAD8R088OIENyfqGoxAiLNm8BoqR8yMluMhpmb1hlOOThZ1xQRgQh9/W2xwNdJdEkPA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Sat, 27 Jan
 2024 03:54:24 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420%4]) with mapi id 15.20.7228.022; Sat, 27 Jan 2024
 03:54:23 +0000
Message-ID: <8834a0d5-12dd-4dd6-bb03-2f66616db9ee@amd.com>
Date: Sat, 27 Jan 2024 09:24:14 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v7 01/16] virt: sev-guest: Use AES GCM crypto library
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-2-nikunj@amd.com>
 <20240125103643.GWZbI5u88U341ORBq1@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240125103643.GWZbI5u88U341ORBq1@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0179.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::6) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: fa717885-35a2-49f5-d0f4-08dc1eeba62b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k2LZehs4zid1FsX6mkGhILQzK0m9Q3yUz5ZFPw/AZUfzKdcsACbnkFTrjFSJBqMaEgK1swlisf/n4AHrN5mAH9qSx4yueg+LCAr9JrBRgEh1WKPW0U6EDiLpQAfbIHOeLgLvrVZxiL5ETVASki+Z1njVHa7DP2bWE5VIYwW5R/lgDJiShEvI7GyuALNtx0Nuca5DwJ5a9pzDMwVNMfWALtUXl4M3DrnA4IsYazIXKDuSHSKHegX6u3QxQPlVmMg8O+b270Yyrah/jHjTH0Plo30wm8xjqMfHwi8vd+c/dnqfKgEt2OPlr8bKdsvYCp1Jaj3z51KqLqCXgnAP2U558IPF3grri8NV2ZjFKsO4ZOtf5+pVy9/ogZeAvBO3PqxuZad3xNEr/EpEDV9MxZjTRY6P5QfGL1FOmhIXHbJM0FmaC2J+viFMBSbFNG4q9gOTskbKInb16Sj6coXwRDtBDJ4DJl6MD/3ajk1wFfALsMDaQlT3+pIy8YwfoLm1zSPb/Ok9J5IlaN17FTjPuwtAPuQBcOXFo5JGlMtp8Wmhbf2fvEIjv4yGeJN6Jz4wqyRQLLt8RYnMsoxPbaJ2rHyWKuG2zTySFDGXnLtMN3SUohbFL00pYSLTGtLrvY5yKKDFpiOo0BH2d1rpb798kXiXSQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(346002)(366004)(39860400002)(376002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(31686004)(83380400001)(6506007)(6666004)(26005)(6512007)(53546011)(2616005)(36756003)(31696002)(7416002)(2906002)(38100700002)(8676002)(6486002)(41300700001)(3450700001)(6916009)(5660300002)(478600001)(66556008)(316002)(66946007)(4326008)(8936002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTdJV1dGV2I2NFp6angxekVGWVFjei91cnF3NWtZUXExeWFCVW5Cd1k1WFFU?=
 =?utf-8?B?U1VxSGl6ZFl4QTFVUmRyUnd2bXpocnpsZno1azJ5QWFpWGdJN1BkMWF3UXAr?=
 =?utf-8?B?MlZLaHVnSUNNdWRQMWtaWXFBcmIwN21oNWMvVXkxeXRTOFdPVEpSdUE1YnlX?=
 =?utf-8?B?RlFHRmRqOHl3Q1ZxYlpkR3BIT01lVWZOcFI2TFlJV1B2OEI3UzlVTTBUeXNv?=
 =?utf-8?B?SDBreGlmbUl4akhkWGREZlU5WEdKMEYzQzdLUTRFc3BsSm1DUGNSZFJSS0hF?=
 =?utf-8?B?SHIvS3JpbnpkYXA4STk3V281QXJTUTdiUDRmUUZURmw2Rm4rT2ZwS3VWY0p4?=
 =?utf-8?B?OWZNRG1hb1IvZnAzNzk3Q2lOUGgwWkdhL0kwTk9rOUNJSmlRQUxMU0QxTTFV?=
 =?utf-8?B?cy85akNaMmtRdXU2R2lpZ2lmTXphRXBzTUNUTTlXeHNNSHJoOENCOFcwa0Vv?=
 =?utf-8?B?MkY4UDUyZWZ4NlBXazNMS1FzRFVXcjZtLzQ4QUx2WE1iU1lPWll3d0RIdmVY?=
 =?utf-8?B?YkM4SVFldUdtWXo1YXhGTWRFYW1oQXRkSUN6WXpqMWFaZlZjVzJsT0ZMTzBY?=
 =?utf-8?B?MGpHaUFtVSs2V3FWRy9xQS9RSmNoZ21USGpLd0Z0citmUTJKWm0vZUJUS0pk?=
 =?utf-8?B?R3Y3Q2I0U2I0a2pjbUtZWkdHcngwMUxMWTYzOE5USDQ1aStoN3dNWXBuTkFX?=
 =?utf-8?B?TGlDd1lHRU53dXJ1QkJaNS9BNFFWbWV5U3krOS9zK1F2Y3NmQlFBR0tBbTBD?=
 =?utf-8?B?K3pJcDd4WHcyRU92d2ZBRTBPZGVjd3lKR3d2MTFUWmY4WnBmQjR4aTlrWXhH?=
 =?utf-8?B?SncydWloNmIwS3BZQzRzeDhpOHJyWVd4TnVkb2dKeGFCek8wM1BjWmo5cHdR?=
 =?utf-8?B?U0hKbXBaMjJTbmMyYVhrM2RSR3dUOE1uL2ZjZEo3WElNeklIbW1QTWcwLzlx?=
 =?utf-8?B?a2RHOWhtYXExWTRjVTlXeEZ1Tzd5NEtiZVZLOW94RUFuYWdvQjNVTldRT0E5?=
 =?utf-8?B?Yld2bW9lSmxSM25VRmlya3IzSFAvMjA4L2dxL1FFWlNJbGNyVExEMlFkUXEy?=
 =?utf-8?B?SjVtSWZ4STgwSE1aSkZ4TURYTUNFWURGdzZwc0cvRVBVMkcrbC9wTkE2VjRh?=
 =?utf-8?B?bUI5MGRtTms2cDRsRVFvb0QrV25MY0p6VkVvWHBjQitQdkcxSGVaajRvd2lX?=
 =?utf-8?B?OVA2ZHNZSVcrTWNuZGo1dE04ODVwYkwrQ1g0V1FRUEpxdWNwakNEUUhoNnVu?=
 =?utf-8?B?STF6VjRzalo0NzJ0a3lRQWptK2xXcEsrOUI1ZGNlWHlURFJFcVZERUhvUEo5?=
 =?utf-8?B?cHJkUVlmc1IxSTZBN2FCOFd0Yk1ORDJWQ3RFdkIvWjVCUHJTUUNJTG5nWXNT?=
 =?utf-8?B?aHpYdDZQMlliNTBSaCthRDc3KzUxdHB0QzRHREszOWdadlFTbjRZa05sa095?=
 =?utf-8?B?V0EvVVFDQUV2SDBNQ3pyNGZSVWp0ZGh0S0RVUjdad2VEQWVsTXJXdVVKZGxm?=
 =?utf-8?B?RnBWYUplK0h5bmM3T2tsZGMzWkZ1cC91cHpiM3pzR3RQY25xL1Y1c0hSWkFP?=
 =?utf-8?B?bm9WRGs5dG9HVlN4NnpveTNHaFV3WFRRTzQ1SGluaDV1cE9CeHdlR2dEcysx?=
 =?utf-8?B?LzE0eFZTVWE0bDFTZ2FCWGlQbm5WRGluNVJBaThZYnVkMG5sb3RidnNsbHVD?=
 =?utf-8?B?UUlEMWU5eUVxRlRrV0d2ZWJ3NzVoTGEwVjh5OGMrVUdHRm45akE3NTVXeDdZ?=
 =?utf-8?B?dzhTU21uamNPeDBDOGVHTVNGSmRRNFdLeUIzM0hmQVk1V1FLR3docVg3Rkwv?=
 =?utf-8?B?V2I4UEo1NlVzNjQwbVF5MFRaQzRhSVZWeldLbGpiYTg4RExHcDQzZU1zd0Jv?=
 =?utf-8?B?S1hCeE02aFJaMGNuYS95K0EydFp3M2hZcjhrM2JraUpuc2FRRksrLytzUWlC?=
 =?utf-8?B?UWhFdlJMTzhJR0JUVUs5QmFnS0pUTEZmbyswT0VSK3QzSDJWZ3haUGVJeHps?=
 =?utf-8?B?b1FDK0txV2lieVFzMjBMSVNLakRWeFp6MzMwUUVYVzkrazNwMUFTN0RPODda?=
 =?utf-8?B?YWMvenVzM0NIcGljd1BadUh3VDFDeDB2QUVuNWZ2Tk02SERpV1UyNHh3Vk91?=
 =?utf-8?Q?/NYCcSvvw3bnjrbnuMLtVtJe1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa717885-35a2-49f5-d0f4-08dc1eeba62b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2024 03:54:23.7787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+l5g4xvwj7kOFVMjIVhvJ6ZYxTjwuIENhd7QZ2ZgZex6SKg0M16CqhfKjDKcsjr4448BIpcaVM+u4oAGVsW6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

On 1/25/2024 4:06 PM, Borislav Petkov wrote:
> On Wed, Dec 20, 2023 at 08:43:43PM +0530, Nikunj A Dadhania wrote:
>> @@ -307,11 +197,16 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
>>  	 * If the message size is greater than our buffer length then return
>>  	 * an error.
>>  	 */
>> -	if (unlikely((resp_hdr->msg_sz + crypto->a_len) > sz))
>> +	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
>>  		return -EBADMSG;
>>  
>>  	/* Decrypt the payload */
>> -	return dec_payload(snp_dev, resp, payload, resp_hdr->msg_sz + crypto->a_len);
>> +	memcpy(iv, &resp_hdr->msg_seqno, sizeof(resp_hdr->msg_seqno));
> 
> sizeof(iv) != sizeof(resp_hdr->msg_seqno) and it fits now.
> 
> However, for protection against future bugs, this should be:
> 
> 	memcpy(iv, &resp_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_hdr->msg_seqno)));

Sure, will change.

> 
>> +	if (!aesgcm_decrypt(ctx, payload, resp->payload, resp_hdr->msg_sz,
>> +			    &resp_hdr->algo, AAD_LEN, iv, resp_hdr->authtag))
>> +		return -EBADMSG;
>> +
>> +	return 0;
>>  }
>>  
>>  static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
>> @@ -319,6 +214,8 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
>>  {
>>  	struct snp_guest_msg *req = &snp_dev->secret_request;
>>  	struct snp_guest_msg_hdr *hdr = &req->hdr;
>> +	struct aesgcm_ctx *ctx = snp_dev->ctx;
>> +	u8 iv[GCM_AES_IV_SIZE] = {};
>>  
>>  	memset(req, 0, sizeof(*req));
>>  
>> @@ -338,7 +235,14 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
>>  	dev_dbg(snp_dev->dev, "request [seqno %lld type %d version %d sz %d]\n",
>>  		hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
>>  
>> -	return __enc_payload(snp_dev, req, payload, sz);
>> +	if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
>> +		return -EBADMSG;
>> +
>> +	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
> 
> Ditto.

Sure.

> 
>> +	aesgcm_encrypt(ctx, req->payload, payload, sz, &hdr->algo, AAD_LEN,
>> +		       iv, hdr->authtag);
>> +
>> +	return 0;
> 

Thanks,
Nikunj


