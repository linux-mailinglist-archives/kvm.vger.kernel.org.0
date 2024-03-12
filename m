Return-Path: <kvm+bounces-11678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEAAF8798B6
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 17:14:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2050CB2230E
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 16:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D6F7E572;
	Tue, 12 Mar 2024 16:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XZdwVpg5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1D47A73F;
	Tue, 12 Mar 2024 16:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710260041; cv=fail; b=gtnpKS95rtT1Yi6VV+5M7MWZAStTeOxGK/AcmXIbACdnO9zLc/9pFgX6h3D+fS59ucO3MubzVYiC3Pu5p4Tzat2LDP2qnTRID5Nd3uzoZjC4M5p3O6LzFrjZ+k0DVq2JdLA17XcBhlu6l6OCXKLYXBQ7emmP4V464NrOpsv4um4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710260041; c=relaxed/simple;
	bh=ro7PBcXdMqLeKiMcG0lUXRiAXOOpxtCyF8Z88N1ADkY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gx4hqROueHJ32rGl7R+4+IIc7SlXKPJG/YN6lkuTOJeP+vMEo5HjCniYWlMd1LDHet/sHhGj4vUElEJ3z8mN2g0h4gUzZQTM/5mAHlXQVQhDxTpYeeQ5qL+CV7vPnhtm8uWsqQm8/bweE5atizYRkZXyFguHDwnR0ahouwyt8Sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XZdwVpg5; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YN8XaZiw4fGJjgNsyGe+cX595E2dIVB9Wx+XPNv0nTV0e0kTObsev3WSrdxxPrLYMUrwSaWxsX+6Et/NRmo9t9muGCVzBSSiJ7Qg44ACzDhWUfLnK+ezI8vng831NeIylE6E9e6TL6RIgTm8hQmakHcp5q4ZRGKz4yQJPvJOfPpenSQJ4OXfiKPKv+7I5HXWXozkE42MEOJp71BdsfIGW54N/n187z3OQB2/8HeNDG/HCxlHsYYTA7yIdnZeFwx+t5vlOdp//Z8863igVpwqaG3GgZ7grR/56ycEkC+JqDndzLnNWLpfAotxIBxU82fmxAFU02LaN8M3+AH5GeOTOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UZBWPB+3FuoUVV/SGaEt25297ShK6Qk0jQ5YVMT6wM=;
 b=XDxsuEUnHxX706oCVtAcf/22EU8kW8RWvXir+wvGT5PHUioTeSe6sLtriPtIfdXFFRnPKYPq3phZXNLPzBKsYB0Z0Vbs1umPTvB2xNa7xVayReI1EU0CKeErdaLTJJ31/aQGOdHFuqBjnO/0TmtE830Pl58eUuHawS4ywmI3CgvfUqmqli/YOlKQxIhg2Pqk5s9qCRwRGmta0/LDN+EuqrglzanakxZjrdCTWy6X9/iBSKoWYc+Osfs5ey05qu+hgFTX4EPHhG7921o8dyHP631503bCvKMx722Sub2ufi2YbqzgvKI+j8gZ7d9kzWp03y5Rt94EyHHG9DG0Cpal4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UZBWPB+3FuoUVV/SGaEt25297ShK6Qk0jQ5YVMT6wM=;
 b=XZdwVpg576ZNJQAOj3xC7uL1cHYGZURcK5D01eT7n0nyx+RqPhgtiAszfiVZsOvBhAGYSWokihRbSGfFgrFzaM3dPz1GQ0DuMMl2QDod0pVljI1+rV3PiLGAFyp88olZcyv83sbcAvhi9fgH/wXK6I59KvY6ljJr1bgPCiT/oAg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by IA0PR12MB9010.namprd12.prod.outlook.com (2603:10b6:208:48e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Tue, 12 Mar
 2024 16:13:57 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e%7]) with mapi id 15.20.7362.035; Tue, 12 Mar 2024
 16:13:57 +0000
Message-ID: <a82d24f8-d185-47a7-91df-4706658843e5@amd.com>
Date: Tue, 12 Mar 2024 11:13:54 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/9] x86/sev: KEXEC/KDUMP support for SEV-ES guests
Content-Language: en-US
To: Vasant Karasulli <vkarasulli@suse.de>
Cc: Vasant k <vsntk18@gmail.com>, x86@kernel.org, joro@8bytes.org,
 cfir@google.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com,
 ebiederm@xmission.com, erdemaktas@google.com, hpa@zytor.com,
 jgross@suse.com, jslaby@suse.cz, keescook@chromium.org,
 kexec@lists.infradead.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, luto@kernel.org, martin.b.radev@gmail.com,
 mhiramat@kernel.org, mstunes@vmware.com, nivedita@alum.mit.edu,
 peterz@infradead.org, rientjes@google.com, seanjc@google.com,
 stable@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20240311161727.14916-1-vsntk18@gmail.com>
 <f1ff678d-88fd-4893-b01a-04e1a60670ce@amd.com>
 <CAF2zH5qZKEmECy=9vG4sLmdDt5k7nC=MwjKvJLyVfPyFzt+0hA@mail.gmail.com>
 <c8c88a28-30be-4034-9fe7-9c9de5247c53@amd.com> <ZfBx2ewmB06qQajs@vasant-suse>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <ZfBx2ewmB06qQajs@vasant-suse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::27) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|IA0PR12MB9010:EE_
X-MS-Office365-Filtering-Correlation-Id: a8a6b064-b460-427a-e799-08dc42af6ba8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BGKESYdxVcQeML7fBVvR0wde25vqrAg21ml8W1H9fu4yrmlriSpfQfGnAfbL4xJqX9YuQIqAj+sVs+idWto7A/uYCk2PxVe6ri6+jagbU2B6oJb3ghnARWQxXi7Ie+kXZPtqYkZS+H5gzlaQtpyQWYQpq9Qe6DsZMSovwvGYLATrbf/SJ+jy19y1XUFyDvM5waUwrjcXmBVGG/syJhHM1MjwfgZGfscbYhS8YGIaiGFeo6LtTqybtmdeTGjHqZ6TIEc85q27sMjXNzUXe4IjAKC12qazzroOG5mVN6WzCdK/IVPyW/wYfjcFcf9j7Wq+FSLD1UCXpOzeH82U4z2Lzv57VFC3iRmoTNl1oY14tO0vpWP6pUQByxa79GH4FdhGKpyiBoicyGQ4FkBpfzerJMmivrt4RPo5fB3PoWYnfG9u7pn0CTBFPXk8MuDWoxL9n22dlsQp682XKdlnzH6YoCWZbFcKKyZUeBARUZwRjYhKyqjFAxG1cb6qxN9my43vU67fO8Oqyk9OrTz30hN8ZKF2aRWCfzNimVYfOHHJqDi5TpYoNPXWmdRkFArg38k4DL2NphJQIq07DbIoQfmyVRgvnEdxnynz5rxSc7nLJMoxU3hy/uC+R6GUN+EgiF8BKSAreAdEahbcmdepZqrX+o6igwqWPFqLyclw8+lI7YQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVFHeUQ3K0NodEZZZkh5MmM2NFVnUFNxczFCK1FCZHZ1QkRLMUNWQklsRmJD?=
 =?utf-8?B?Nm5PeDFCdWV0V3BJd3pBcllldnhZNzFIc2xlSWxoU1V2d3VadUtTRmRzTVRt?=
 =?utf-8?B?dzNKd2NBbEdUNGs1ZWtCOXFhRGhKVzhvMUFOQkJqejRiRm9kZ3hMQk94RDRC?=
 =?utf-8?B?NC9tYUZPV0xTeHRmby9iV0t2QTY5UXNEY1E2dVcvNzE5U2NDYVBSS1lHYXVJ?=
 =?utf-8?B?MEVrVy9rTUNDS0QxTVBCdFUwZW1yRGlobFcxYUxpaHZPOHJUTVZuUDVvYlkw?=
 =?utf-8?B?K0xwNzZBRHBsbDh6SUZRb1UrSTJzRFA4TWx0VzhjVXdXYytHMW5HejE3NTFj?=
 =?utf-8?B?TFZhdC9PNVQ3N2Z3V2sxUXZlYllYM0VDSURid0h2SWo4Sk9XUWlVNWp6Q0VZ?=
 =?utf-8?B?aUx4MU05WTl4YXpsSWROYTRjK3dXVTlKT3lzTnQ4b05XZVZqYVZUZWQ1OHZ6?=
 =?utf-8?B?NlgzZGU5ekxybmxtN3IvY0pWZkMrUHNqeTNqUDBGTjZZUlNVZGh6cSt6YWtD?=
 =?utf-8?B?ZXlQN09jQkFQUjg2MHBpc3hyOGFCeWdwb2pjRlVQZU9lZm0vQlZNampWYUlu?=
 =?utf-8?B?SlNpYlpJRTNtdk42bmNxUmVUMnh3Z0NXR1prQ2doWG5mVUdQaEYxckJkUWMy?=
 =?utf-8?B?MllhMEJaREt1VTJYU0dPZjI3MDcrNkRNZjNRUStHeS9oUGdPaVVYU2VSbTdz?=
 =?utf-8?B?UTFYQW81UncwYWFtV29iODEvNnpyS0p6ejZzOURYVmU5ZmdhQXRXVUJiSVZC?=
 =?utf-8?B?SHVhQ3cxT25Fb28xUGI0TzRwM1lPQVErUzlMU3lMb0RFVW92SjkyYkowdm9W?=
 =?utf-8?B?RXpSQksrQVRkYjdWM202bGdmNlkvQzdkaWtsV3NudURoSmtsUDZnZHlLTkdC?=
 =?utf-8?B?VmcxVFFjMmRLaERoM3gxanYwajVrK0ZTZk1ENndXRFBSRVE3OXRkcklBNHpD?=
 =?utf-8?B?QS94cU5XT2NOUE1GeUEraHVPcUpIOWRlRVp0YzJoak9INlNNMnUzdW85blJJ?=
 =?utf-8?B?TGd1eGtkMWw1NmtEN2xiTkZ0dWNqcGI0WHd1ZmZoWExNeTlPRjZJRGJheHRO?=
 =?utf-8?B?RmdqREtYNFZXb0w5bmV1dHVwaFFOU0VxMHIzM3ZDZUtXSVZpK2FVYTFPMU1Y?=
 =?utf-8?B?WmI0Tnl5S3d2OFFxVVpEU1FacFpMMmVjNHZpSlVmYXRadHI4ck1zOVh4NkRz?=
 =?utf-8?B?cTdLenBib2RkbncxQ1pyS2hwNWhmVHFpbTBWRjFXOENkcHovMHUzbmp3dU9k?=
 =?utf-8?B?eDFGUnNWTlBrc2lXaEplYUJ4cW9sVVhpc2VmYThnck9qRlNqTnZhRHR3Y3dX?=
 =?utf-8?B?QnZCa1d1eStqbU14cWQvTnd6dmpET1NpNW81ajdMZkxMVzlmQ3FjOWQzL2lH?=
 =?utf-8?B?U0E1cWVhWlNjNVhNSkt4OHNyVXFZQm1FWE55Z1ErRENlT0puZWgwM1RlZWtQ?=
 =?utf-8?B?VUZkTzVxNTk2RHFhTnJIMkFIRzRwR2Y2STNBem1yTlJYKzAvTUVVcktZVjkv?=
 =?utf-8?B?NXZMQ0Z3OFRyZDhENllLbms3cFF6dUNiYWNMYzJLaWh5Q29PbERTRTZDNGxt?=
 =?utf-8?B?dGFWS3l4bi9RSFpUeGtQTFB0TFRsQjhvem16ZzV4a2ZVeC94YUhQYjNqbjR2?=
 =?utf-8?B?OTBBZEUyd3pOcC8rUWdCUUdtNlVWNnN5SkVnRmxsV05TUitvbDUvWHQwcWJm?=
 =?utf-8?B?UGFvejhKN2s5WlNRMmgxV3dpdTdvKzhHQi83VTZTa3p3Z05NRjlmME9GK2xF?=
 =?utf-8?B?a3J3b1dmTldhemM2S2Y5eEFOT1AwUW9Pa21FQVhSamNpUDJiRnhpNlhtYzZV?=
 =?utf-8?B?T0tCeXZDdW9ZTmpDSWk4RkhWN1owcUYyQmh6QWhDRTFIcjBDUTFDK1Byamww?=
 =?utf-8?B?TkhxRUtrVzNTQ1NGNXorSml2N1VZUlZRWjJEREt5Rk5kcC90akNFbnhldE1E?=
 =?utf-8?B?S0NRanlzK24zbWJjaHlseUFXdm4wMTlqUTg1TGZiQjZzT0xlVE9ac1BQSWtT?=
 =?utf-8?B?UU9LMjl3dWxSUVdCeWkvak9wbmhFNG9wd01BTmF3enZabEhpZDJSdW5aejlO?=
 =?utf-8?B?Y0tIRDhmQzBwMjE3dTAxaWFQN3Nad2xRdm52Q2hKN1lpREtPaVk0YjZ5T0Rt?=
 =?utf-8?Q?2yxkCr/cmqViQxDeRtKlI+Sz2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a6b064-b460-427a-e799-08dc42af6ba8
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 16:13:57.4319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2DriZNFDIPUYN9//6Dgyn7v8IB2cEhegm7uBVPHpIXJhYwRouJfg/i6mmZKQ6KeJErlM8OKj0VMBRAHUFjdsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9010

On 3/12/24 10:16, Vasant Karasulli wrote:
> On Di 12-03-24 09:04:13, Tom Lendacky wrote:
>> On 3/11/24 15:32, Vasant k wrote:
>>> Hi Tom,
>>>
>>>          Right,  it just escaped my mind that the SNP uses the secrets page
>>> to hand over APs to the next stage.  I will correct that in the next
>>
>> Not quite... The MADT table lists the APs and the GHCB AP Create NAE event
>> is used to start the APs.
> 
> Alright. So AP Jump Table is not used like in the case of SEV-ES. Thanks,

Right. It can be, but we don't use that method in Linux.

Thanks,
Tom

> I will keep the changes in the patch set exclusively for SEV-ES then.
> 
> - Vasant

