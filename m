Return-Path: <kvm+bounces-69875-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPbXDETMgGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69875-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 17:09:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 493FBCEB32
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 17:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 56B483002F46
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 16:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D37837C11E;
	Mon,  2 Feb 2026 16:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ugqj2zz6"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013001.outbound.protection.outlook.com [40.93.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152E137BE9C;
	Mon,  2 Feb 2026 16:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770048566; cv=fail; b=s2G9Jw4IAaYlz120Hrsoyb5DgrG4PsQx/kjlv/PQ6JnenYbDTJ9JHNN2U3gkt34Kmmpi0wMWeYF+Q18x/q7WXeu0ZwFBfFjirlfWkmOfB4bFlSls3kogyb7lnz53+DmTqHBfbTXSV1ylOwkFrilxWg1lFJnbaEQXcW7IlXWMRVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770048566; c=relaxed/simple;
	bh=wHMQvQRp3++1a9x1USm7Q4YFSsp3F3KPGv2IuWQ2kU8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gXmFsTjQkqeSlnCEWrnpxiGANLpJS4kOSyewVXFAgZ0/GnDtXDBnqLZp8n8M78x0nisvaQ2sx7x39pAWFLVcd86FLAAdjACip6FYNnxGv/PTeyPusIxCX9S20jC5Spy+53A4rL8GNJ+u/CMZ4GEjFojZpC9Yo76Qr+75eNXNVtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ugqj2zz6; arc=fail smtp.client-ip=40.93.201.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kpZBl8Gqtfi6euC+qaV6DiQXmG74qU+fPxBTAAkEB9YwsEBd8MZu3rdEYeZgAHMD9rlCAPFXRQqdxzAQTo1RRXfh+JDU2e1saA4d2kMwvlWLewcFKB9PAtNeYFkqxjmy4yFQSR+B/9hM9XjWmTJrIZqng+DcViCz6v1MFRuHHmN69tgpp1ML24H7t9uSECbLCn5e4aX9P+xhlwbLpEilDsEGVBJZABz9f9fRedf7l+rZqYGxQoopwWodeaQBOTbwJh7GeGddT0lYJOFMXq+0AwrTl4Wf+ElUD21Y8JRmBcQNrsgE0bYz5vjiGUPf22a3W++i83SOXNyvijTvxbAGaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCYrsz1WOKeUq20jEZiYarn/DdptiBIt1mJB9eFAEao=;
 b=Xvm4MXyXZuUYajZglS+7h5ZNYQPdNVmX5nP2SuEmu0w0EjihR+lIkqIEVCH2Lnp/Eg1i+gRKmdgG4TN4rBFXWmzAQnhxt7gzLF/pbVRcWjRzZugwgg4pWtpRblZm99ylux/kKjcYb6XfF15FvkUcpxu3pjS8p+9olojEBma7upqrZalBzQNqIMv/FvjQc2cX+Y1r+fpXnUJVYp4twezl+an0V8uA0Q/R2xklIfwbo2PZujwtLIwq1UMa5i8h8cueDsoSxAWkQqXcNwwyBwBye7Amp6Z6wpEErGBAlEBjwjQLYip6TWOVRMomxMDPRfM/3eepAywEyiEfVEejZ/hFrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCYrsz1WOKeUq20jEZiYarn/DdptiBIt1mJB9eFAEao=;
 b=Ugqj2zz6hroW52ItSKO4fjpTBwg6rKBSG0iCdxNa+6w5+COJ2GnXpFFL2XuFNdutEF4i/ipy6LgHQt5lHKu9cbjZfV+1lG8YqsopJvs8XXhFNtAH4pabPRFglHfPx5SeC8Tkduf3OCseoRe7035GwDO5CT2CoftZLEdAZv9cHaM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM6PR12MB4041.namprd12.prod.outlook.com (2603:10b6:5:210::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 16:09:22 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 16:09:22 +0000
Message-ID: <3392d89c-ebf5-48f2-b498-a7dc532a0493@amd.com>
Date: Mon, 2 Feb 2026 10:09:19 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
To: Borislav Petkov <bp@alien8.de>
Cc: Kim Phillips <kim.phillips@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev, x86@kernel.org,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Naveen Rao <naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>,
 stable@kernel.org
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
 <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
 <e7acf7ed-103b-46aa-a1f6-35bb6292d30f@amd.com>
 <20260129105116.GBaXs7pBF-k4x_5_W1@fat_crate.local>
 <f42e878a-d56f-413d-87e1-19acdc6de690@amd.com>
 <20260130123252.GAaXyk9DJEAiQeDyeh@fat_crate.local>
 <2295adbc-835f-4a84-934b-b7aba65137a8@amd.com>
 <20260130154534.GCaXzSHgkEFnk5mX14@fat_crate.local>
 <6556bacb-2e81-4aa8-92e4-0ff8642f4ec9@amd.com>
 <20260202154936.GAaYDHkOMpjFpoBe5m@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260202154936.GAaYDHkOMpjFpoBe5m@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0348.namprd03.prod.outlook.com (2603:10b6:8:55::8)
 To DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM6PR12MB4041:EE_
X-MS-Office365-Filtering-Correlation-Id: 13d8c89d-77c9-463b-efb6-08de62756d03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?STRNUFBvYmtYU0xVbjhwN3Q5N0tvbGNVUVp2L2pZN2hGMXZKd09rSjAveVdr?=
 =?utf-8?B?ejhHSVZTMXM4WlV0MkJzbDlzS0V0M1I3Y0ZGYVpCOUR0UnpHYnBtYllVRTNl?=
 =?utf-8?B?STRPSWFJaGNKdi9VMzdGZVZPeUNDeGxIaTQ4dVZCK0liNzlQc1JKeHgrcnFZ?=
 =?utf-8?B?UWlGb2YzUlVob1kwWDlOVDRqVi9lWGYrZ2NtT2RNNm5lVWhua3hJcDhIeGYx?=
 =?utf-8?B?dk01TVgraE5wS2JWaVJCbGxzdGtZb2wvNjhjYkEwUHV2VE9iRmU2QjFJN0s5?=
 =?utf-8?B?S3hwVXhnajQ4YUZ4d0E0QVdaVWtmVW9KSm91VjgzRWhaMExlRGlFbXlUUnlG?=
 =?utf-8?B?MFpmOGx6VUI4ajUzQXRHRVo2VjBtMUZkWHFXelFFOTU0ZzJvdkFJakxBUkND?=
 =?utf-8?B?SjduNGMxdHQyYTFkM3ZmRVhJd0pxQmtpSW16SkZhLzFON2hNWm55ZTZQcTA3?=
 =?utf-8?B?ZlpGU3VadnlLcUFjbUVjZ2o0ZEYxaG42QU1WcThLZ2pMQ3IwMERGZHFSRm16?=
 =?utf-8?B?VmI0aVhXaU1IRFVpampYVnc5akZQb3N6dk56MTdWMUZsZk9tV3RnYWlGSXRs?=
 =?utf-8?B?L2w0OVRwRnprTVljdVVhVkJON1ZtaFlSV0FlUXV4bGx4b0JrWElSVXBqUjQ5?=
 =?utf-8?B?R002eG9laUFETGw0WE9kOWR6aVZMWmo4QUE0bVYzSzgrZ3ZRRVEvUS9vNTk3?=
 =?utf-8?B?a3NyTE5hNXlLdElJWnJodDBySlJyRVNCcUIxREIwVlVhYTR6YUNpNEZoSnhs?=
 =?utf-8?B?VzZBWWFtdEN4NUEvaTZGNE4zR2lwVjh1RnZ1cGlHbHBKbUt4KzV3Y2RyTFhy?=
 =?utf-8?B?c0F6NHZVVGVubVFpMWlkUWovWk9kdDE4REhiZnJFM1EvUENpR1FqQUYwT3FU?=
 =?utf-8?B?SkNtNzhaUTdKcGtRaVFoY3Fid2FKZzYzR2ZzYWVYb2VZVGRnM2RKNTQzK3FO?=
 =?utf-8?B?clIwRTV3TzVZMWxndkhkbnB4K1hTNlpUMXdOb2ZoVmtnejlZRnV4dDZPY3k2?=
 =?utf-8?B?SkpkR0t2WDdwVGxJNHpuak9yZnZvV3hFaGRDWUY1WHo1dEZCRzhqRmNqVG1w?=
 =?utf-8?B?WDRUUURzcHNMNWYrQnl5alJlczhwMmJMeWFEcHRyRWV3NUZVT1Z3TWdkbWR1?=
 =?utf-8?B?RnMyOGhjUkU4UnNsd3RvTlVyU2ZwL2s3NU5JdncrenJ4NExMSi9odnZZOHlW?=
 =?utf-8?B?WERTclN0WFNvYldaY1FleVFZUStkQy81aVdDcjdOeVRvN05aeFhkb2txbjQ4?=
 =?utf-8?B?dHoxSlgxNlMzalprYVlBeUZPUi9xS1h2cmp2bTRRVkJtdndFdzdZMFJqMEtM?=
 =?utf-8?B?RmFWajBUYjR2Tlltb2dhVjRCRzJDb2g2Uk5uRHQySUM3MmwzVVVSTFI4NWZP?=
 =?utf-8?B?bmNSVUJRUk1nVzQ0UVpmUS9EaGJFdVdWdHoxdXhlVW45c0pvaGg5ZUtQSEZ3?=
 =?utf-8?B?TGc4UDZNcmxiSVZOUnFsTlZYUkJPLzlqU3J4MEF1b3ZKOHVoYjd6aldKazdQ?=
 =?utf-8?B?VVZWK2NIaXhqeGxHMWVMQ0dYUzBWVi9rSTh6OHRpRWVyN3B0ZEIzblcra0Jl?=
 =?utf-8?B?ZGR6K1hIbEUyeGtweVpGNVhSbU9ZdnV5UHNweGNEeHQxamlwODZFVVo1V1JK?=
 =?utf-8?B?L1FSSGI1OHZlQmRadTRkZlhXZ043MXZmTDkyU050aUpqVCs3cEl1VXl4TUlh?=
 =?utf-8?B?WHRtNGhiUVdUZUV2ck5IS0xiNVdGaDRaVVZKWUt4Y2pIeTYydUhabHVVRURY?=
 =?utf-8?B?c0doWWNYdm9jQXB3VDBLSHZJVlJEeXErbjZVK3JsdVFYbklYb2NvK1Z0UE5E?=
 =?utf-8?B?MXlIY1Y3Mm9mTDZvQ2xoVlpoUHg4cVJTU1h5b2xRa2phWDBLU2NlcnNHRGdF?=
 =?utf-8?B?eW1Rc1VlbUY4R29PaFhiOXZFbWQ3VktJU2JKQ3dnaExrb1h3UzVmSkRqY0xr?=
 =?utf-8?B?LzAzOXpjRFJTdHNLYWJBbytwTlc2WE01S1dGS2Q4UU5pbjNUbzY3NUYxTmRk?=
 =?utf-8?B?RmZ4cFBwM1k3N1dMakZNNmlKV1JCWEpPZENyNEFIOGJEK1ZOcjFCQXY4MTZL?=
 =?utf-8?B?NmpRM1RaYjVnRHA4V29kaE45Y2Q5aFk4N3lKTlhGK1poMVFheWNwVlh2RjN1?=
 =?utf-8?Q?vrtI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OTYrOUZGb2MzVjNRSWNvZHdjTEdBNXVCazNnRUxTWUJuTkpKNkhBUW85V2s2?=
 =?utf-8?B?ZDcwV2NIT0Fxbm5LbkM4dHpweU1PQ2huWEI2RUpDNHZKdEVab1dXVjEvbGdk?=
 =?utf-8?B?QUViNUJtRDd3NjZPa0VGUGcxanp5ekZiaVl3dWRQbU10M3hQS3hmcUxwYzRi?=
 =?utf-8?B?dnVVcE02LytWV0xZN1Ywa0FrNThLYlZvM0xSaFk2ZlF3ZjlvTUdiL3VmbStr?=
 =?utf-8?B?Q2xhcllyb2xEL3IyaTB2THlTeWk3eWdkUjlHMFpOL2NrTUR1NHpxdmJOdDda?=
 =?utf-8?B?V01lRG5PV1BtdGpkTlFyTWF5d2pqcjBYdjBTWTFIa2dubXpKY0ZnYk13UlNV?=
 =?utf-8?B?eDcyUUpEcksyKzEycWNZYVI2d1pQa2JnYytHRncvbVl4dnZ4bXJaSXhWbko4?=
 =?utf-8?B?dWk0QjkzSHhVRXRQbE5nNFpoby9QNUN2RDUyQlQyWGNiUDBJait0NHpzVTc0?=
 =?utf-8?B?TXRBRGdObWt3ajhIZWdudjBpczZTNU8xdE9PWjZyZFZMNVZkSW1hTTd0Wjlh?=
 =?utf-8?B?a2RtY1loYW1PMmZkdDdnWll6ZzVzQzhySjRCY1E2ZzBZV3NoazhVTUU3Zmtn?=
 =?utf-8?B?MmpNWk85S3BMZ0ZFTmtFanJJbmNsWDY0YWd4ZXk5T1l3Wi8wcG1jUXFVU050?=
 =?utf-8?B?MWtRcGpJM2Nsc3NVWkhSQytZSTEybnA4SFAzSkZDdTI1Z1dvTVFzUE1lUWNU?=
 =?utf-8?B?K2JUVjBxRzVYdVE5Vzh2N0JlNWhpRzNCN2VYbHUvZndEdnlOUjZjRCtPcFZm?=
 =?utf-8?B?M3RDZzRVeFNLbGZzRXY2TGhFUEZhUWVSSGJJem5FWHRUTndmMm04OXVWWnZj?=
 =?utf-8?B?LzlSVk14cjU5R3ZQelJaZzVDdGFZOVdlMkF6ejl0VUhpckl2YWFpUkxoZ3dy?=
 =?utf-8?B?QTdTeSsrengxZUlXcW0zUnVtSDVXM1BWU3dNTGRIeFpscktrNXVzeTdTRmNG?=
 =?utf-8?B?SU5BRHFCNHo0RUtxTWdRaHFDZGpZejlyNXY2ejFzY1BTN09OUkgrcHBXVDA3?=
 =?utf-8?B?TW1yVGZBSklSY05WQ2dKOWtkR1FaUGY3Sy9ncFVDMVJyRCt1ci9nVnBvM3Jj?=
 =?utf-8?B?R00ra25oTTVudlNodWlJUmUrOWhGbnUzNGF0MFNPeUtQdzB5T2xqS2RaYnVr?=
 =?utf-8?B?WWxUQTNGUk9oT3ZnSklENXpuT0tMeW9Wb1h0R1JEVTRFcVU2YXJERFFleHJo?=
 =?utf-8?B?MHp3N1plTFdpN08xdXByemNlS0JZWGVQaW9UNS9FaER3L2g3MXE3WnhBTUlL?=
 =?utf-8?B?OTFWa1RjeFIvZTQ1Q05aQnZ0VHRtakxaR0hRcm5kTXd6aDhUQ2N3RHJERnE0?=
 =?utf-8?B?UnBtUWN3c21NeWJiZEJpdm1HZUtpMVdrYWo2R0I0NTBhTHVsb0VxbG1wOGF5?=
 =?utf-8?B?MUVOb1JQWnRLV0R4NS9OOXJjU0dmN2NPYjNab2wwZ0lTK00xNzRZT3JPcGFP?=
 =?utf-8?B?TDltS0JQakl5ZEVvaTB5dHdoUG0zY01zdnluR0VmRTRwWm02U2FBbFpma29J?=
 =?utf-8?B?dktoMXArN21IemRBaU5LeUQ2dzRockp1M1Q2U2k0RXlObXVGT05BSVdoVm5h?=
 =?utf-8?B?Y1lQRTZaQTNkRzN4TCtUdTRPd0NRYlNnbkJMZHhkQXZsbUlQV1pwS29OZHRY?=
 =?utf-8?B?eG5pMW5uQ016ZVdGKzN5Yy9ua0lSZWZ5cjJKWUtrYUthZ1FnNEtlZ2R6Z1Y4?=
 =?utf-8?B?QWNXd09oazRMOEJIaXNVd1B3c0UrVXVYR05GeFZYRVMxL2kwd3MrbzBFOFRW?=
 =?utf-8?B?TGk0MmZFU0tCRXVKVjcwUThjS0ZsK3h5elhXeDJ3UlF2MnhkdG1XUGY3d0JW?=
 =?utf-8?B?TnVxVzJUL2JDdng3L2RBNExOamZrQW84OXFDS3V5bXE5WXhxL2FLaTNUSE8y?=
 =?utf-8?B?dkM1MHRkem5sTGV1VHV6VnFiODVnSHJRQ2J3V1U3MWNSMVlEQWZKM2h6TnF3?=
 =?utf-8?B?RjV6VXBpblZrMVhSNUhGYVF5Q3FRK3JnUHcvaWVVcUcwRzY4a2kzQ3hUVFlx?=
 =?utf-8?B?bzd0RVdaWWtQSHQ4ZzFpV0R3M1NHMTk3Z1p6TUpOYXIrZHV0ZUEvYkhjaHNu?=
 =?utf-8?B?OGhlS0p6QzgrdlhNMlNhRDUvczRGU1NGOEVucXIyZjZlb29ZdGRCQkZHUzJP?=
 =?utf-8?B?UTZHZUFzb2RmYnFnYVR3OHpLUzhqVkcwc056OTNhbUJhSkE3SHJnRDZwOHVh?=
 =?utf-8?B?ZDV4NXF6Q0hvaldyVXRqMjJPenFaYWFOR3ZuZTI1SUsza0UwK1lTQkxURG1R?=
 =?utf-8?B?cEpkemRnbExITk1ieVc4dmNXcEFxU0JDWDEwVFNwejlNMUpIc3kvRkJway9G?=
 =?utf-8?Q?NDU9wQk1oxr8EaElt8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d8c89d-77c9-463b-efb6-08de62756d03
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 16:09:22.3632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQv3VSIGv1M+XxhEbyarx0zWlXGWr1TavS0fz3MhAbx3mCqhp22SHgRh5wc7FD1wVgyMxk2Z+DolgOeaoqBaNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4041
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69875-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 493FBCEB32
X-Rspamd-Action: no action

On 2/2/26 09:49, Borislav Petkov wrote:
> On Mon, Feb 02, 2026 at 09:38:50AM -0600, Tom Lendacky wrote:
>> I guess it really depends on the persons point of view. I agree that
>> renaming the SNP_FEATURES_PRESENT to SNP_FEATURES_IMPL(EMENTED) would
>> match up nicely with SNP_FEATURES_IMPL_REQ. Maybe that's all that is
>> needed...
> 
> I guess...
> 
> I still think it would be useful to have a common place that says which things
> in SEV_STATUS are supported and present in a guest, no?

But I can see that getting stale because it isn't required to be updated
for features that don't require an implementation in order for the guest
to boot successfully. Whereas the SNP_FEATURES_IMPL_REQ is set with
known values that require an implementation and all the reserved bits
set. So it takes actual updating to get one of those features to work
that are represented in that bitmap.

> 
> Or are we going to dump that MSR like Joerg's patch from a while ago and
> that'll tell us what the guest supports?

That will tell us what the guest is running with, not what it can run with.

Thanks,
Tom

> 
> Hmm.
> 


