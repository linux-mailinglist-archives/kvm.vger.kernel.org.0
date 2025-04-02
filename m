Return-Path: <kvm+bounces-42512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E919A796B1
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 22:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 718883B5312
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E09851F1319;
	Wed,  2 Apr 2025 20:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="49oT5tto"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F21A2E3385;
	Wed,  2 Apr 2025 20:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743626493; cv=fail; b=LN3wxHRCdG70Wb1Mn4c6vNMo/5GOud3aArX2v+h/5xY+StRplywbiAzJFzYvF3cap19B5THpUO2hdTiHSrkf0wGkb8/Drq8YLRbjOFNyjmhKst/KzftXUHfWVcS7BsMDZRLkhUz0p29s66PHvQzz/foWQ2eCxHf4tsD9ylmo3BI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743626493; c=relaxed/simple;
	bh=Ml9nXAZR+NdbUEk6/jXzazGdRDq6ij6b+3Gixn7eo9I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LkjReyvuYXac+CrNZvvt7Jwd37CaZOUbEA0GDqZb5+BntVvmLIM267+0Au+ijyBqN0PsKP+w9gcB/QQ0VZDaKOGvKV926E0mRS33XGNegoAI0SbdbnVXaTGCFawfHb22s04lr+iWH+D7YDvSkYA8vNGJjNNLdP6g+Bouk5s/LhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=49oT5tto; arc=fail smtp.client-ip=40.107.244.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XFixyvp9Jn9plIZB/IAxobW02GP0fp2WGMZJYISTDcu64Tg8bLWNPLZF5aHW0A/HgqIY1k6uf9ofNoqGLRQxHrY8Xckw5sFulMX67ah+8LHKJNMBz1uXWCoFBB1/1yqm2qSjzg7pjjM6hEio9pBgFglPY/+ADVRPBuEStOtNl89FsBwIKOkQk5J2I6ek5TDCKU1sn1waNTeShjROj4AU9ZBXJCcCK24eXKMAZNb5WjaTcuRlxRqFE+q9XThAZvJsX23qTnGVNFUrvqSrf79JGV7aGgTKnTnOQX+2ywmcH4rJogyCcbQTK3QFo/JBhFJ8Ul3qkv4ERdxBI0YmGeQjmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nb+uYFTeXzWIpsVYdwipIGw62rVAFwPgCJ2y3U3rY1o=;
 b=PXYLdJZYKKuTjeTtSy4BUs0KyN+EpfBgOh8ZOcF5h5L1jStvxM4ImeXBEbAqyGWe5QZpuHqYD+SuT0wW7Y+QYJ2E6FThpJSBTH5K82dVDmSci8DzYAHP4vaB8AT3U9QTAiwOYMh7GR4wqMjs6/9Mmyl7iF9D7WMC0/sALTucCw5mRGHbcTojze5ZRrPqEnZxLt8+RxAg2Pne28F6pBCeSHh5RgnDgQ+IaQQSEBnnSVqMBHVehXVB5jBpbfSHPAyHNopYWfNANe/LosBu2IJzSzyr5orvtb6x8y9Tlx56PuQSThb0xljEgYxOFEb0ZMRsav+DyVA8GTG5obnJtFMdNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nb+uYFTeXzWIpsVYdwipIGw62rVAFwPgCJ2y3U3rY1o=;
 b=49oT5ttofIenxDEArA1ajL2eiYk9WsaiKmCnnTkkZeq5917jRaTOgsqU3F7lbkmFfcH8L6pVeloneSB738HyG24FiQEAro5lgVNmnh0pGOhmus3BL5WtdOLYMN87GJTenjv7ZLZARh05qUkViW44XrlkWOuPrXuzrxG/uLMedCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB7614.namprd12.prod.outlook.com (2603:10b6:208:429::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 20:41:29 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 20:41:28 +0000
Message-ID: <1e34033b-3e3a-bd23-af5a-866e68d5a98a@amd.com>
Date: Wed, 2 Apr 2025 15:41:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 2/6] x86/bugs: Use SBPB in __write_ibpb() if applicable
Content-Language: en-US
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
 amit.shah@amd.com, bp@alien8.de, tglx@linutronix.de, peterz@infradead.org,
 pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
 pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com,
 sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
 david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <df47d38d252b5825bc86afaf0d021b016286bf06.1743617897.git.jpoimboe@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <df47d38d252b5825bc86afaf0d021b016286bf06.1743617897.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0033.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB7614:EE_
X-MS-Office365-Filtering-Correlation-Id: e421ed1c-86c2-4d14-2c72-08dd7226be04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3N0NGhqV3RWSDFFTEJCczMwbFpzdEFSZ243U2FwYUF1UmJ1YWVqZnpwck10?=
 =?utf-8?B?SHRWdFU5K3JTMm1OZ2RkcUM2NDlkb3pZUnFqWkFvMFpwcy9wcGU0ZlA1SFVu?=
 =?utf-8?B?WU9xRE1IRUNRZDZtbVU3MjY2c3RqTFBxUU41MkhRb2VHR2FvczhwZHVlbUtY?=
 =?utf-8?B?Ny8vMTNuREZLNTMrTFprMWlYM0F2VVlxdmFZcG16L0RMNUNQRzVwS2ZubFcx?=
 =?utf-8?B?NnN3Y0krZGgzK0YvWU40bVFsY1lHVXhGYnZZdWFnZXkrVVlheW91VVU0UUl4?=
 =?utf-8?B?TjdxYTZYTjZQb3hWNmZrN2prSVg5WmNZVkZTNGkzRG5OQUxFanZxbHdZWUxF?=
 =?utf-8?B?a0ZCMVVMS201SHdIMStiSU1IbEtZbk5NTng3TStQL0Q4M09EVFZyaTVjVXY2?=
 =?utf-8?B?WDlNQ1F2YU1zTTUzdmxhVUw0Qk1Jdm9kbkw4Q21qc3JJNlhTbDB0bHM0cStL?=
 =?utf-8?B?SVZwcnpVRGxDYU5NU3dXcUt2OTVvaWErZFllT09tdXRWakE5TnlBNFY4ZnhJ?=
 =?utf-8?B?RWxMemowT1J3OHphSkxKSGRuY2JXT3VhTWM0SFFzb0Nlbzc5YzBLa3hUcFFK?=
 =?utf-8?B?bG52L0ZzTjFYZlJTbWpTakIzSkZici93bm1oZmpxTkxtY1lxTWczZmhSNWZm?=
 =?utf-8?B?Mk1pdTZSTXhucS9SVnV6bGVCc0ZXYXJLYVAvTjNZNWRwTVM1UzJKSXREL29y?=
 =?utf-8?B?M0prVDB4SENvR0E0ck1vbFdwNi9LRDIvcTVyN0RUbTIyUURielRkMFlnM0sr?=
 =?utf-8?B?Tmw4dUhOTnV6Y2xzeE9vVG8yM3laVk5CbVl1NlVnUFowN1UwUnE4NDhjUE93?=
 =?utf-8?B?NjRzejA2SGlSZEY5UTk1b2Yvd0ZPb0pxbzJCRHlsTkppL3U4cElTOHZRSU5k?=
 =?utf-8?B?aDZaN2tqcXhHV3ZhbWY0djFRNnMxWTRCQThyVFIxYi83ODBXc1hXd1FpQTNy?=
 =?utf-8?B?OGJxMktlNXRYL2F0YVpxRWMwcENVL1dVeDVUWlF5RmtuenNRdlR1SkY5WU1C?=
 =?utf-8?B?YUlrclR2U1BtcEYvUUxkNkRLRHVwSlp1cmplN01PdGJNZk8veVdnMWFLUnRM?=
 =?utf-8?B?UmtjZm50NkFZZ0Jvbnd5K1dscWpsY1JqOUpCU1UvTkZManpvYUM0YThKTVVV?=
 =?utf-8?B?SklOcEJTTW9EQkV4REc1cnZhZUVKdUx6ZzArZEFBajlrcS9lZlRBb1ZEeENo?=
 =?utf-8?B?MWU2L0NYOWpuV1I2dHI1aHJ4bEpkb2ZINWk3bkFGVUZkMGJUTU1RcUMyTXZO?=
 =?utf-8?B?MEQvK0laK3JrYWdEZGl2ZFQrcTdGTzFkOWsrZkpiRlYwOHg0VjlMaGtZS3VM?=
 =?utf-8?B?WVVpZVMrTFZIb3FSbzJvZXZramJFV1lKY3lIRVJmQkF1SkNySU9QeU1xRGg5?=
 =?utf-8?B?VGpRWnlFTFBJNHA0ZEpWNjJNSkpIUitVcDkxSGZhZnE1eXBXaTl2czYraVRQ?=
 =?utf-8?B?b083OWR4bE5udWdNb3I0RHVhd3NTN2ZlaGNWekpFZUlISFIrd1ZEMjM4NzVQ?=
 =?utf-8?B?Z2hZRG42L2FWbmZVQ0FncDlMY01xQkQvb0Foa2JzbDhRQytQN0hjUUR3OUo0?=
 =?utf-8?B?ZjJGQXROcEMza3VoWXZRVk5mMWR5K0lrazRuQkZ6eEt5a0NVWVNVSjI3Nko4?=
 =?utf-8?B?RGlaK1VyZUlNMlhFTzR2QVA5UDlpR2ZCUUxBRGUxdW0wdDRoeW1sVEN2S1Ur?=
 =?utf-8?B?b25KZWVTQ0dzNEFUYnVVSzN4Z1REajVNMjRDVXJuN0hiOGVYWHBNY0gycjRu?=
 =?utf-8?B?d0dVNElxVmlRNGRzWTZ2Z0NMVERjNE9JMEFYZVNMT2h0WVk1VDVNNUg4cFlq?=
 =?utf-8?B?TXZSNld6Z0ZKcHBock51ODdieG03Tk5jbEppR0tCR1lsUmNlaXF6UFc4dzd2?=
 =?utf-8?Q?xGjvTPy6E4bCY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWNPQnFHZVllbG9NSXZST2JwaVZhZmwvVkxVb2FaUzMrQTNzbjhiUndqZ1NV?=
 =?utf-8?B?WXliUit0VzhCTlRjRThrYktoMVIrN0FROEI2TmVBQ3ZKYXBTOCtIWTRaSjJM?=
 =?utf-8?B?eXpRbTlFRXVjQWkrV090bmYzaVg4QjRNb1VUdUJ3Zlc4WUo0a0FGN3hTTngv?=
 =?utf-8?B?RHBnaTZOQnJqQmRnMnpaUXVPT0swdWJWUGRuU25IMU9rajlZaG5aNm9FZEpY?=
 =?utf-8?B?bUtCMWpIdjhkZXpVNitnMEpZMFJqaW5CcWZjUS9wQTlmcXBzaXRwdmd5M1J5?=
 =?utf-8?B?MW1MV3hhTzN1YWJraW45THZmN0NDRThDOVpsSGFCa3dLbzF0c3JCbDV1OEkv?=
 =?utf-8?B?YW1nRU5iZWNwOC96VzJPRHdnUzdtN1hIb3Y3dlU0OU05cWUxQnN0OXNxaTNZ?=
 =?utf-8?B?RGJodFNKa2tGV0NzVHFmekN6Zit4MGs2UHM4VStnT2o1RWJzTUVhMm0rWnRW?=
 =?utf-8?B?dVl1MXQ2OWpxVWZRdXhDL3ZlamM0d3pXdlp3cXF0WklBYlpXRXBvMFlEeUJm?=
 =?utf-8?B?bmk2Yy9uaHZHbWs0bXdhQ0RxaFVUUVVlVlowWDU0cm12T09XOWMxMUtMNlFz?=
 =?utf-8?B?R1BvN3ZodzhDTjIrcUdZZ0Q4cG40WnFlckVIMGwrZmxWek5yNmcvRXgrVGI5?=
 =?utf-8?B?dGF5SnBYUHV3clMxUWlmVXBHNWdKaTJ0R3NkaFhUV2VZSFBDZXNEeFBTVFQ5?=
 =?utf-8?B?SStKTE80MjlQNi80d3R6RWhFaU12ZUl2ckU1MmJEQWdXclpQYTAralpjbktU?=
 =?utf-8?B?eEg0YUxDZWlZTTBGY2taRUp2cFVHYndXVXg5d2VSTXkyRTQ0S1EwaVNEb1VZ?=
 =?utf-8?B?OGdCV0pGRUtYZWpyN3F5RnZrR3dDb2FHbjdlaktjZlhOaDV1RE1qcjFSZ291?=
 =?utf-8?B?MTlyc0xsMjRJU2l4L1BJMklmZHBTZ0ZwTHZxSGR0Rkc2Qld6TzRWTW55SXFJ?=
 =?utf-8?B?Y2lGa25EQjJlWHpsazZBbCt5MWIxbmk1azI5OGpBWnZMajBvVVRUTS9JTUFO?=
 =?utf-8?B?YnJtTVBGeTlwcTExcUVBemZQVTRLU2YwNXFrY3p1Q285SDZnOStVc1l6YXJa?=
 =?utf-8?B?cmJNeHZBUC9ZOXRGMkVmNTRUQm5PdUw1bHlBNVZDSW9TR0hIeGdib01NQlN1?=
 =?utf-8?B?bnJjdDRwMWxJQ2FZMldheFl1YXlDeWNMa1Rhcy9Yb0VsYTUrNU9yNGgrTUd3?=
 =?utf-8?B?QWZiWlliMnRzRjYyak9JejlrY1BNT0xjTlhwWEhqV1FqSHc5em1Od0JiRjVU?=
 =?utf-8?B?Y1lHTXBZQjlFRXg5Ym4rT1ljaXVSUXZWNCtaRXExeXQ1S3dPMHdhTlVWWFpa?=
 =?utf-8?B?Szl0VXFuTHhaOFhqZHBFeDdMSHRNcWxyZm95bVhiZWhHT1pLeTRaSERkS1RK?=
 =?utf-8?B?VTVsdjJXU01OZTg5em9CYS8zenc3dk5KanNVbEhBZ0drZjJHRjdXaHVnMlNq?=
 =?utf-8?B?bEZoekk2K2pCNzBJUkdSNjFIR0daMHRNbzB4eC9LVUhBN3oyYXJudWRUaStQ?=
 =?utf-8?B?U3JQeU5Id3VJN1lDcE9lcVdWbVdjcExCK0h5TEoxNWdLdHdac3FIS29uU3Ba?=
 =?utf-8?B?cy9SMlNycTM1WnJ0UnRpMWJuSXAyTzBNRGdjUFQzeitsNUd2M2FSSUI0ZUl4?=
 =?utf-8?B?eFU1aGlCcFlURFZMSURhdUpMT2s4YUVkZWJDVEVaUitiQ01USUhWeE93TlJO?=
 =?utf-8?B?dEtaTnBwaDh2dmR0SlNXb1Ixc1pnRERJT2luRGp1a3plWld1S1o1R0VqRWRL?=
 =?utf-8?B?MGc5cmcwM1V2ZUpYYTIybERqeGlqL0lRRTZoYm1JUk9pL0RLa2k5aFlkM0xY?=
 =?utf-8?B?c09EbDFNWXFYbFc3d1d0TGdHY041bVgyK3QxVHRROUpFMXkzMkRCMTN5RGl0?=
 =?utf-8?B?NmZaL3RheXhQMEorUDdBVUErVCt6RTI5R3JLVjF0MDhiSnBxMnJtM2NwaXQ2?=
 =?utf-8?B?OTdkRDNVdjEyeFNQRGpFTE4yMVNjQ1RuNWJhNm9PcmhpMHdvV1RDQVFzT3dL?=
 =?utf-8?B?ZE02QTZaQUtybjUzRy9nQ3p3WC9ZWDJCSVNHWUFMSUpvbUZnV01UejVqdURj?=
 =?utf-8?B?M01jTTVMbVdMUnNhNDJpMXFPeVdNL3YwNDFqVDJEemdZdzlpdkovZGlJNTVl?=
 =?utf-8?Q?kf448M1FA2ZWpvEtBaPaQxY/u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e421ed1c-86c2-4d14-2c72-08dd7226be04
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 20:41:28.0201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ndO6oimLmpRczQQFshw6jPjxVl6pQCoMH/tQiXU4Uy/xULKWE4tYfPzSR/nwP9DSOU695mVo465k/AOWY6B0ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7614

On 4/2/25 13:19, Josh Poimboeuf wrote:
> __write_ibpb() does IBPB, which (among other things) flushes branch type
> predictions on AMD.  If the CPU has SRSO_NO, or if the SRSO mitigation
> has been disabled, branch type flushing isn't needed, in which case the
> lighter-weight SBPB can be used.

Maybe add something here that indicates the x86_pred_cmd variable tracks
this optimization so switch to using that variable vs the hardcoded IBPB?

Thanks,
Tom

> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/entry/entry.S     | 2 +-
>  arch/x86/kernel/cpu/bugs.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
> index 3a53319988b9..a5b421ec19c0 100644
> --- a/arch/x86/entry/entry.S
> +++ b/arch/x86/entry/entry.S
> @@ -21,7 +21,7 @@
>  SYM_FUNC_START(__write_ibpb)
>  	ANNOTATE_NOENDBR
>  	movl	$MSR_IA32_PRED_CMD, %ecx
> -	movl	$PRED_CMD_IBPB, %eax
> +	movl	_ASM_RIP(x86_pred_cmd), %eax
>  	xorl	%edx, %edx
>  	wrmsr
>  
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 310cb3f7139c..c8b8dc829046 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -58,7 +58,7 @@ EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
>  DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
>  EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
>  
> -u64 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
> +u32 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
>  EXPORT_SYMBOL_GPL(x86_pred_cmd);
>  
>  static u64 __ro_after_init x86_arch_cap_msr;

