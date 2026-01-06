Return-Path: <kvm+bounces-67177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E78CCFAF60
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 21:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EF746304F512
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 20:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907CF345CDE;
	Tue,  6 Jan 2026 20:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="PaS27nJh"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBF53446C8;
	Tue,  6 Jan 2026 20:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767731904; cv=fail; b=fQfRIYJiIOWmk2VEl8R//9O8b5kN1U+eXA3xaaALIzCCZuutJzyrZ4AkRz4Olb0RtK6nGAWVO0qPNZaC+LC+GUdu8fQtSSB58PDFIISTM/Nc1xuYTMAIpvnY2sD+Q1a2x9pWzr3KeCN+TJ/is84DYVz1vor44d9JU8DvkYcKbI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767731904; c=relaxed/simple;
	bh=4vxRD2PIlJyaOmF/SXnPrDWlXb1VIi+EILueEvbyzYw=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ON0r3cRZ6QLQI6XsD7Ad+0rY3klB9qL3E4IZZ7kJHFZkBCxuWFdLtLv6XCoXvXSMRGxuv9tJjD8fIcXMLiVaTVYCOLpdvW263FK/lzxw/c+CwDVWvHTvbJUc5W73RVY2Bo/sHCshLZoE8DWFziYQsuKSn9KrtiehRwUeuL7qwOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=PaS27nJh; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mbUlW01kN4suRmOWlcgBECVQiwx4ImhNSl3er2TWCD5LUiLg/XivYzSmC0cjLi2g8USrNYKa1Q2FeQvW87Nn41BBJrbO3QZ1oV4a+WygYcWmXsxd9CObopD3H+hM6d+WwOasPUJSkBUBWaHY6Sv7BPrEnzw/4DoU3iGlK0+gEgk6pX+Y/6M2HS28SrNv4f9k8QnGIoxK7TyeBpGTfRvIJodX2L4Igjvr43w+uxW+8VYiD+XNEF29ZMiY3HCUCFtCiE1FfVDPPNuh5LA6CXNri8hdVX3TRzvadLGFeTHXHlflcGbqsw3dRjwSNVFCKiGL5calMLigpnqOcUUb1vHbfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D3vr2X+EwfyG3Mm1JbZycYL1rBPZkxMN2Sl0XEd2d0o=;
 b=cM/hOVYfan2RMlarfofd0WiVMg6u6/BxED0XR+Y1hjABFxm0RTgQRQatUEux5VWwVfq8uSaiaZeIIudx+qmpMqjkzzp3oUH1jue45mdC/9yD+RQCUcn+zv/5Hq2W4OIdFyeZO2K8dFmSj8O16Z4lLTH5L8PnsMSvstxlWOguR7nooYKVvfH5lwNr9j4K9h6Ajxwyr4atZh/TxLKMTfS/izmzVxFLdYHrLrSHay9kEy3eF7VZOm9rkjqnDnX3M0al1yQpJqrs5LU0t0OLaEe+ERkWe7WsyvTaadFAiOQxAgw7MQGf/76fIDZTr0xTMOqyW0pImCTO3x42tZhBIc0aIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3vr2X+EwfyG3Mm1JbZycYL1rBPZkxMN2Sl0XEd2d0o=;
 b=PaS27nJhZib2zqyUofqZeO4GwurE/zYATcOpW4RsxBxcW6RK4avBQqQn0sGYPh+qwY8Z9u0xJ5JWUPiWXxX3TnAzgwa2wkRCNsfDs9OoUfurnAw5AcwFEJXgDYpPpVktz0MFCgoG1Nuv8oJQuKLHYV6uUNnUkzVbHr3pibJwJbI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by DS1PR03MB7967.namprd03.prod.outlook.com (2603:10b6:8:21a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 20:38:20 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%4]) with mapi id 15.20.9478.005; Tue, 6 Jan 2026
 20:38:20 +0000
Message-ID: <7a82aeec-7db5-4e06-abb4-9f041aaf2fb0@citrix.com>
Date: Tue, 6 Jan 2026 20:38:17 +0000
User-Agent: Mozilla Thunderbird
To: seanjc@google.com
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, chengkev@google.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 yosry.ahmed@linux.dev
References: <aV1StCzKWxAQ-B93@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Generate #UD for certain instructions when
 SVME.EFER is disabled
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <aV1StCzKWxAQ-B93@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0225.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::14) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|DS1PR03MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: 12a5cb0c-161d-4023-64c9-08de4d638775
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWxhVTIzL1hMWk15a1MyZXVJMlJiWFpOWVVJN2xveVVPVUdENHhHajcyWG5R?=
 =?utf-8?B?bmZpYXhWUDUvQXZiS2ZrckhJRXQvL0FQZVBMc2Y3N2MrRnNya2xYdDFzNU5Z?=
 =?utf-8?B?T0JVS1hwTzYwYzBoT29mc3BFUVVtN1VIekJwcWlFaG5MWGNXbWNnb1hJc2VO?=
 =?utf-8?B?T2syS0lNNEg2RTBSbGVxMXpPT29XZk1IQ2tYOFZrWjI0VlZLRUZlQW5UUHU1?=
 =?utf-8?B?NGxxaGhrbUJNLzVmSXVKN1pxQ2tXeGtUTVMzZWd5UzhJTEtpYURvMnNFUFhJ?=
 =?utf-8?B?TC9pNFRiUXBpZmdwbVhXU3A4c255VldoUnFDOVRERXMydkh4TUpFRnBkTkZt?=
 =?utf-8?B?QTVIUXdnV1NYS3hxbTZTOEJBYXVuWmtQckxGSjVOTE55R09yQW9IaTh5RGJl?=
 =?utf-8?B?Q1dIOFVJVndQaG12YVo4YmowcWFvQVl4YWFVL3lOcU9weFpoWS81RDBqVnZq?=
 =?utf-8?B?WGszc2p6WXlHSEg5Qkwxa2Q0SjFwL0hRVHEycTZwa0IrbFlLV3o2VTMrQk5O?=
 =?utf-8?B?d0RMbVhKNVlpbEtaTXhhKzhMenRuVkMveS9yKzVZbmlqUkNiakUzenY1VlZP?=
 =?utf-8?B?WDEranlXNDVmMjBwakVNazlPS0UzYjZPU1B5cHF2N1dtQzNkeWNnZXRiNUgy?=
 =?utf-8?B?YU1aZjF3T1hMVVRSeGYyZ0Y3UXliMENhU2FPdVY2NGtoZ0FmbUJBaW5wRU41?=
 =?utf-8?B?bWNwLy9vYS9kbkZVcmdJT21pN01Ua0VidjZCVWRrd2dYWEswT3dxNHZkcHBD?=
 =?utf-8?B?OWdvcUx6YnlZekFoNVFTU2hUMms0YlltWkFsR0gyVjBxL3AxUnN3Z2d3VDlt?=
 =?utf-8?B?NEl6eHZNWldLWmFEZUk1Q2xrYlRxb1JJMmV6WTR2VVpSSSszRTRiM05kUXlr?=
 =?utf-8?B?ZlF5bFQ2NDJSWi91L2xZUEc3RkFmYXdYczlLVnJlcE03ZDZrTmFKQWVGaHBh?=
 =?utf-8?B?OUlWR2FKNXN0NXFQSlhkY0VXTUZxeUpoZXg4SkZJYkpKUGZ1L1hMdEdaZXhj?=
 =?utf-8?B?V2dmVkt2RTR2aTZtRm0zdDV6Y1YyNmQxQ09PVDVLN2VPZGdTcGh1UjlEZ2g5?=
 =?utf-8?B?TzMxQlE0V3BGTTNJMzcxcURYZ0hmTXlqK1EwT2o3WmtnZWlFbU1sZFVpSXdr?=
 =?utf-8?B?YndLWGpLeVJ1aCtQMlVjbXlDbG90NjhjSXUwS3FwWTR1UXROcThZMEZvK3ZD?=
 =?utf-8?B?WWdRZmVLODl2dVdrRlJQWDBFLzVlZFFnalJkVmtRVFVOcmg2L2JPK3pxWEN6?=
 =?utf-8?B?dUVablkrZ1g4Q0pmZkFYOGpmaVkxSFQvSSs2VTNUK3hKVVhSNEgzTVdwTDJs?=
 =?utf-8?B?UW0wWXBBSXJCaCswQjkyaVJNVzE2WkV3L0FkTmdqZ2REL0tIYmVYekROcWkw?=
 =?utf-8?B?TDV5WHdRWUx3SzdsdGJjeWFYZG4xMnNHcGFyUUVsRTlXbVNjL2czWE5RT1Nq?=
 =?utf-8?B?bWJwVkpHWUQ4NitKVEsremNRa2Q2c2NzMlhFbXBwc05iSDViU1ZtSENZVEpD?=
 =?utf-8?B?eHBYLzNSUjNOWWZpMHV5TWlSS1kyQk5FUjdPY0Y3MmVqdXhXQjNjaFdZNDQv?=
 =?utf-8?B?QnJFdEFBYVlqdnpsSDJhNVZtcFVGTVlXNUl2aStqeCtmQzdBTVM2RHN5c0lm?=
 =?utf-8?B?S1MwcVBXeTdzaUIwcUExbFZrR0xEcmpYd3NiV0VoYlJUTjNnODdHK0Q1Tkgr?=
 =?utf-8?B?djYxbm9TV21RcjFEOGNQdTV6Y0M5SEl5aXJFNHM2eWtUb2gwN2RTNVZnYVFt?=
 =?utf-8?B?cHBScDIwTGxDT1FMRi9hUEZSSEVoUXI2eFJSYUdiU3dzZDJ4dHNRRlkxMk0v?=
 =?utf-8?B?anJON3hVeFNuTE1vYmIrM0NxNVAyRmFyRVEwa042ZXJZcTlNV2lKZXFHZURx?=
 =?utf-8?B?VXowc1V3SDBFSHNsbnNxZUxhR2d0eXVxd0RvOEtpOGtjZHViTEQ0UHpOcmVP?=
 =?utf-8?Q?JA2NmKj0rnO4c/GuWtjiOFa4yjTGT8hn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aytQVHJ1eGpGS3VQdmNBWXVhckh1MWlzNkxCTnhidVZodkxWV0xTbkFGbTRx?=
 =?utf-8?B?MDRKS2NMRjdXQTQvaWRKQy9jUUk3ckJFMEFMUU03UDNpRnprRlNXdktHQndL?=
 =?utf-8?B?TWNkS0VuL1BNWVU4bjk4a2NRM3FwTXczdmlPY1J0WE9mdzdNT2hvcC9WZVdz?=
 =?utf-8?B?dWZxZm5qZWN0dmR4Z1NiYnFQRkR4b1lJQUI1c1paYVNqOThURkhKSUpJMytz?=
 =?utf-8?B?RFg2SC81SzBLdjI4T0oyd1k5OXNRSTJJWXNyYk5pbnR5YVR0QmRmU2IzcWdL?=
 =?utf-8?B?SytGUXd3ZktDMTlkSG5va2h6TmFicXZMNWdFakNCaExDZGlOVy84T0M3VkVy?=
 =?utf-8?B?WXE2eWVBdlBaOFVUbTJjRmpZbjhjQ04yZWtRVktFbDRlbnhRdzBsRGFtYzgw?=
 =?utf-8?B?MzlDeTZvQURuSC9Fbk16L3ZtVkNYTGZOUGdobHhaUGt3eDA2YVNzZ0pBdHpu?=
 =?utf-8?B?MnNJbWR4UFBZdXpNVHlJN1JiQ3pCTGJESVBuSk4yei96RHBrWnA1Y21XTXdv?=
 =?utf-8?B?YXNtZkRJcVd2N25DS0hmUmV1SmdCKzM5WlNMcnJmSlA0QjlReVJ1SG5NcFZu?=
 =?utf-8?B?akNlZ1RWbTZLdm1SeENwUm1qSVhmMTJEZFUrZ0E5TGlsSUZKNUJWUjZrMjZ3?=
 =?utf-8?B?RHVBTldRQ0p2VDNiYzZocVJVSXVtenJSY0FlNmNnVjlOcWFvcnZMYTBFSFVS?=
 =?utf-8?B?M2ZOMHgvYmtaRDVMY2JoQ3ZMUHh1TGhwOVNvZFd4SFowbGpJNUtQNGdTLzFG?=
 =?utf-8?B?TlA4b2E2QlM5NHU5RmU0bS81QThCM0g5VVpFWmNwTzc2aE9wRlUrOTlDSTZ4?=
 =?utf-8?B?eGZGK1dzN1BLejd5bU9SRklPWHVTdnJ5NEl3WGF3TXY2Zms2SDNMZHNXdVRj?=
 =?utf-8?B?Z0d5MHVGS2NRVDczMkwzMFhRZ0w2djJCaFlHRnZkZVNBcXNlZGl3a1FHckxj?=
 =?utf-8?B?K0NmTVpodVVjUDlMMkx2bU40ZlB2Q0JOa2J0dkZ0czloeS85Q2ZUTENhSGJh?=
 =?utf-8?B?Q2FnRi9uNjFYR1NtdTQ0YXB6WTFUTUQ0Zklndi9FRkh0WmVvUlZqem9xSkxE?=
 =?utf-8?B?WXVyL1k0emdNSWpWYWxhM2d2cGZCMWRPLzVvY2N5dHBrMkxwMEE3bHhCZ1h3?=
 =?utf-8?B?aFpPT1hnRVdEVzE5bWtoaG1xN3VBSitoQVgxZWRnd2NpS0tja0dWQ2d4WTdM?=
 =?utf-8?B?WU5DbUY3U1lIUWd0VFI2cmlhN2VvdXpoUUpYUzk5ZWtEczNtMHkxQWliSXh1?=
 =?utf-8?B?VXhVQ0VwbGlPTDRTUlEwM2UzclFiMkNlSTg0ekExNmIxVmhjRWVoTVFURjZy?=
 =?utf-8?B?Z2dZM21zQzdaOWRxTUtaMWhCUVY3WmhaWm5ZbzJrdTdIcmJqRHUybCs4a2Jx?=
 =?utf-8?B?aUsrR3JobFRiV0F0eDBFRnFnRlFkUG5KN3c4NVlCaXdnVFBHQkpSWHA1WGIx?=
 =?utf-8?B?cEhzZ2NzTFg4dFNFTmNmZkk2TC9vaWpOaGp5QUpTWEdMY3kzS01iUVdyeTl4?=
 =?utf-8?B?eTZBWkRMc3FsbEpjT0NTRFdVK3U0WDFwYk5kTmZHK0IrMFlKTE80cHZuSzYz?=
 =?utf-8?B?b0g5SkNoVlFVdDl1c1djb09UdHNtTkZBMnRwdUU0amUzMkNEd1d2Y0JDVHdX?=
 =?utf-8?B?Q01OclExLzBxQk01YktzT1BJWjAzOGdNVDE4ZzVGUWNKWXRXVzdRQUhBeVll?=
 =?utf-8?B?VW5aQ202K2sxZU5TNExIVFZDUTdXTTFBMmx2Vk1QWlYzaktaQ0FhYTZaT3Yw?=
 =?utf-8?B?NElsRXp3RG94VncyS05yYVAxblEzVlVzMEdrbEp0NlIwMmlJTkZuMnNoZUZh?=
 =?utf-8?B?azMrekp2bjQ0Nmd5RStZc0YvMy94NzlNTnMvTFQxUWhZekxxZDdUTEZ6TFNt?=
 =?utf-8?B?aU9pdUhDeExJVFRRaERWdGFRNnhJMUxwRmNMamxScGtZL1doN2xnWVN6NUdw?=
 =?utf-8?B?VVJmdDd5UkdGUjlINGNKcVhTSzdEL3N0eDlGUDI5MHpabmplQ1J0NnhvcXNS?=
 =?utf-8?B?WU85NWdXaldNNkp6RDNNbmo1UThaUWFxTnBHYTdpdFpMOUdkLzVTejNMZTRi?=
 =?utf-8?B?ZHNnTEJ5ZzVuSWgycFdkN1pRL3FmclZpT2RYRnUzZXpDVThhaXhSemE4dlIr?=
 =?utf-8?B?S1AxNUJ2a3F6U0Z0bEo1M0psZjl3Zm9WN0ZwRGs1OFJDMkN0dVQrbDQ4UjNw?=
 =?utf-8?B?NEo1c2JGcHUxM0IzK2tLeGtONk5US01iTUZCNXc3UldhblUySWY4cno1aVFn?=
 =?utf-8?B?KzE0RERRYUNvQnlHQ0pPME1wY2hwNzVFUzZ4VmJlTzdQcTVVTm9XaUpKb2ps?=
 =?utf-8?B?Zm1TRzIwMCtMNjFyaWJqMXBuT3ZlNWZZVkRvZTk2YWQxNHh1SFN4VCtwTVhM?=
 =?utf-8?Q?52VDxDiylH9lry60=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a5cb0c-161d-4023-64c9-08de4d638775
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 20:38:20.4462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXbpK9Omu/qw16hlTPDxgwIvouuwuO0zRyS8EZ/Q7exmO4yx9Eg3HhwI8NcKXj/hrP2lt64J9ke7zZnFZV/0bS6chwFz+pza9ABVtQOA614=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR03MB7967

> What about STGI?  Per the APM, it #UDs if:
>
>   Secure Virtual Machine was not enabled (EFER.SVME=0) and both of the following
>   conditions were true:
>     • SVM Lock is not available, as indicated by CPUID Fn8000_000A_EDX[SVML] = 0.
>     • DEV is not available, as indicated by CPUID Fn8000_0001_ECX[SKINIT] = 0.

15.31 states this more clearly.

"On processors that support the SVM-Lock feature, SKINIT and STGI can be
executed even if EFER.SVME=0."

SKINIT is AMD's version of Intel TXT.  The Secure Loader (15.27.1,
equivalent of the TXT ACM, left as an exercise to the programmer) is
started with GIF=0, and is expected to execute a single STGI instruction
when it's in a happy state to start taking interrupts.

SVM-Lock is a rough equivalent of Intel's
FEAT_CTRL.VMX_{IN,OUT}SIDE_SMX.  I still don't understand why the TCG
insisted on there being a way to lock out hypervisor support when using
DTRM, but if you don't implement SVM Lock and SKINIT, then AFAICT STGI
has the same fault behaviour as CLGI,

Be aware that SVM was added in the K8 RevF, and SKINIT was added in
Fam10h RevC, 3 generations later, so there were CPUs which had SVM and
no SVM-Lock.  It's not clear if there were CPUs with SVM-Lock but not
SKINIT, but given that it's enumerated separately, I expect there might be.

~Andrew

