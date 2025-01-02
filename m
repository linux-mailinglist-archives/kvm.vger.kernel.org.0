Return-Path: <kvm+bounces-34485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9F99FFA2C
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 15:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5138C3A11F2
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 14:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658281AF0A8;
	Thu,  2 Jan 2025 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vydz4Org"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BE72A1AA;
	Thu,  2 Jan 2025 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735826961; cv=fail; b=PkpdZ7AMdr/zK6iwF+L5gKtmSVQqCQl7zq5SwtYLeK3OTQ/gc5qFmGKnS4pOrxwCR0VnqAGPNPXpg/wlxzUVhqNNYeChrJrBiqV0ZK3bOJ8dSZBlfJ6s/+zzmb/mTULVGF0tJZW+F3LqnBiBD2y1TK4FZuavId4nsK/F+BWWyj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735826961; c=relaxed/simple;
	bh=n6itofPkvFx19YgACWI+qypep1PmVoCeFkzaBfOhLJg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s9syovHn0djSys8x871WuFclvb7pr+ubwaY3y7UXLz4TThtxbEUlyHZfWWc042G8Tj5Nyan8SOEYXXQl1Xe8s99jACGRf0IfuUWRJZWbCHOO3FWam+Gop39geVPG+8ABeNlK7unPKavHFNOn9NNKknF8nRJuc81U8fmSiys6j3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vydz4Org; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=esd/3ttdjCdTsVQI/2cvaLruLJEMmUa0iMjPORhKbFLBdzohb0Y6noQFrox8PR5KGGC2R+GCLPNoE4o3fjgPkL+T9ebjNK/25zDvTc5I+EnFKFUMe9pWcXco5dzGPz/HGISj6QBqNRZyS1WgTZCsSSLqkdpaJk0LfxJHqEQIbAW7jnnrej1Z5NwJXl0rxFzBh5Zg9EpvaGSRj8e+byKMcq1/fHZE0kQCd13e7SzVUAtgngPa9V6b0oT0KvAHEbDFoYknspGN3dDIwmnuFEdT62NEH7fLzww/7hY4zHEh9JYO6C847Yb3wvm4vbxF4TWxcCsUDYavjX7BKR7p3cdstQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+1NPjxcb2UkvdTBTrw+A3Ultcx0yZ6zm7VM5gUlLmg=;
 b=vtlkZuXEOLuCvCjzLc7YQIOT4zxWNcS/f8mMRAOungO2d3Tb+h7mDNYCjsJB7mLZzqxrfSgZrp/kdj+/ieIi9mLRuDDPpxZ0cAMdZMPndgS4tvXwinJ95370NZ2OlLD2JynRaovSDYYgz0HksfOiy6ATXoiPC+APgU/GffQjSbdax6oQbzD1lOtbfKoGy2yJs0dZmwEIaVvAk9QLWBl15d1jXvEP4YZX0M32v4JWehtu/V2u1Z3pmSXgR2MEyUqG+2mEoJnAG9bXEC470ldQoiTkL32ZPzcH9R9hjNAeg1hZ/nYtnHt/yybXx01/0K5Q2BSyrjHtRc/UgORhGSE9Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+1NPjxcb2UkvdTBTrw+A3Ultcx0yZ6zm7VM5gUlLmg=;
 b=Vydz4OrgrtmvvU+VKc4NaG40ZMsdG9ozWg8k1eQ4kLj6qR28Ht/BHZai9OIOk1hemuRzsvVCmZyDk1bG6hqVhNMm3WOJy/HkKzECBLQzEgmx9aEdmlG1djMWTsAYHK8HAZ+QkijcnXkzsglxiBO48Os2gNFeUj3l4GErvTZo8ds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by SN7PR12MB6714.namprd12.prod.outlook.com (2603:10b6:806:272::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 14:09:12 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 14:09:12 +0000
Message-ID: <ef8f247e-a685-4097-aaff-fa8fcafa91c5@amd.com>
Date: Thu, 2 Jan 2025 08:09:11 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] KVM: SVM: Provide helpers to set the error code
To: Melody Wang <huibo.wang@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
 Dhaval Giani <dhaval.giani@amd.com>,
 "Paluri, PavanKumar (Pavan Kumar)" <pavankumar.paluri@amd.com>
References: <cover.1735590556.git.huibo.wang@amd.com>
 <78dee5850404a2db1bf5b4ec611c286cc5bd6df6.1735590556.git.huibo.wang@amd.com>
Content-Language: en-US
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <78dee5850404a2db1bf5b4ec611c286cc5bd6df6.1735590556.git.huibo.wang@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0045.namprd13.prod.outlook.com
 (2603:10b6:806:22::20) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|SN7PR12MB6714:EE_
X-MS-Office365-Filtering-Correlation-Id: 67c30b37-759a-477c-8eca-08dd2b370892
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qm5jQ0QyN0N5cndwKzlyTTMwRjViUGZSQ1pJSE5FeHhZNjRuNkY1NUZwd1JY?=
 =?utf-8?B?WXJRVjlac3IvWVJlTzVlaWZVbHo4TEdkS1EzQUhMQXZLaXV3UlIrbGpCSnZx?=
 =?utf-8?B?eXArbjN5VEp1cUVWWjhQQVRPdXlLNjQyeXFoVmM3anNxSklhTFkzaDEyRlNx?=
 =?utf-8?B?V1BOdEU2QUFZMGNRUC9yallLQXgwVXpHTlZ0aFUxaDIzY3MxSVVYTzdmM3h6?=
 =?utf-8?B?eURxODg5eklreXJRRHZRUDJEYVV2aHpITW4zbTdwL0N6WGVpMENaenR5Vi94?=
 =?utf-8?B?TmxURnVRMzNpbUVsZzJKY3FhMjV2RVVjSTNMaDJ5RVdTMHJJWTY5VjFTZGt5?=
 =?utf-8?B?RFdhZ1FHbVArYmRNZHdocjdZZEw5VjQwbENublNaUXA4OHorUTJHakhSNHNk?=
 =?utf-8?B?ZTJzcjFweWNxRkYvaTlEU2IyTUpPV0owdnNJQ3V3Z3dHRElUbm9XSHkyeU1x?=
 =?utf-8?B?Q0w4MjZyTDJ3ZS90a0NYbHI4TjBwS1RHSHdVL2ltY3QxWk9QKzBzaWJENUI3?=
 =?utf-8?B?enczemxWaTNRSXpFWC9OaThyc2lka0U2TWxqTVkyNGxlMFZ1eEUvQXRJVUd4?=
 =?utf-8?B?d3JUOWpRYWU5aEU3Tk5WbnlMVTZqc3MzZktyVUJHTFlTUnN2NkpyZnhtRVlC?=
 =?utf-8?B?KzhSY0dPS2R0VjJGdUp1OVU3QTdVN1hqWnNVYjFTV1VBZW9nN0EybmM0ODlX?=
 =?utf-8?B?OWNKZ0psNURiM0RJQ21pQXZ2Wm80d25RVUNibWx2K0s3cGVNb1gydFVvd3du?=
 =?utf-8?B?c1k5RWFJTm5zQzRnYS8vaW5WZHZ2RUV4TTVrWUUyd3Nrd3FudmVsM291Y1VO?=
 =?utf-8?B?YklQdHIwN3NUazJ0QzlnaVdCTUdtWlhYQ3FHNjRmR0J3YnpLWnBvNE9xWW9S?=
 =?utf-8?B?c1FuWGlHU3QrSGRpUDVxZ0dnWWRtd0UvSm1Oak1XOFhqWml0QWxNdi9BQ1Bh?=
 =?utf-8?B?RDRicXBkcHVNU1dEQUpGeEN5YXpsVWQ0K0UzYnVMNGpTSlRNbjBicG9PekVZ?=
 =?utf-8?B?WjNhTC9LWkZwYms4QU80V29tc2t4dHZka2VGWk1hRU5WMjJ4OUdXOVJCRm1X?=
 =?utf-8?B?UjY5NjhNTFVMdC96TmtVY0ZPSVBIWU9oLzltSUlRdTJPMEEreWgzSHFBVlNq?=
 =?utf-8?B?dHp3clMzSDRXVXlwZExvd2VtYVI1TG9ialBONG51L0NSMkw3bTIrdFdoN21T?=
 =?utf-8?B?QlcwaDBqWWlGNWtkU2RZNW9aWVRmTkVQNStneWpEOVE3UEZkSm5kTkNDV0Zw?=
 =?utf-8?B?NzhoNWZwcHhSbVFibWVnZWduYXBUa0NTbS9COWw1YnVUVGtWQi9QaWZyclZP?=
 =?utf-8?B?bURISnpGdkVOalRtNmlFd0RGanp4M1grVVFYeXdjbGo0cmo5YXFWS0pRZ0li?=
 =?utf-8?B?NTVKM1h0WnlQYlBycG8wU1F6UnJacUJwclNaQTg1a3BXeHZIcThkeElCK2hw?=
 =?utf-8?B?d0FBRHR1S0U0bE8rUmkyUXd3Z2dvdUc1U1FRZFpGNmZIWHdSOXF4blppQUk5?=
 =?utf-8?B?bXhLUE92NU9MajBIb0drVUJnYTZjZnN6SzBSQksxQytiVkFVZDJJT0ZZS1Br?=
 =?utf-8?B?ZHpyYlE4VDF6eW9ML2tRaDhTejdMS1NTd0I3SGUzRng0VW45amxSMEFPckVY?=
 =?utf-8?B?d1NMUkVuK0V4T1dweDhaTmhwbUM4eUpUOXh1Mythbmw2RUZvR2E5N0VhUnpx?=
 =?utf-8?B?MndYZGwxdDZsUUU5eW5ZdnJ5QS84TWhCZVZRTXFwWFkwbHU5VmJ4L0hQS0pF?=
 =?utf-8?B?cWh6TUdkV09xZ3gxZFN6VHptaE80OEhJeVVUd0NRak55UTlrZGp3SWRwbExI?=
 =?utf-8?B?NnR6K25jazBVRGZpMEFTcDdPWWkxSFYwLzdidnVBVmV2c1Z2SkVrVVFUanZn?=
 =?utf-8?Q?qDepsIO6pDErh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amVUVjRQVk41YUZjOUhTZHNldnJJV1FXTjdOY1ErMTZxTlVGb1NYRi9ScS9Y?=
 =?utf-8?B?K0RBeDdzNXpPQ1JkZHZTblVWZjg5L2NxRUFrUUswU2gyeUYzVkhOL2lXdFow?=
 =?utf-8?B?U0ZVb1ExQ2VBSUd2VGFJOXg0ZTJYb25mR2pJSWx5d2ZzdDZQSHplTEZaV2d1?=
 =?utf-8?B?SEp1SkR2SWdvc1QvZTlaaXFjN1JKNXJWeGJiVTVCend6b2QzeFZ0a3AzQVN1?=
 =?utf-8?B?UExRWXZLVU5xSkFndmRKZkI1MEo2dVFBMDhzQXhOeWN3b2gvQVJxNU8yZmZv?=
 =?utf-8?B?dEs0QUxuUHVMWnVzR1lyN0Y4anN6Si83NVNZdUJmS1AxQVVrLzM3MVFDU1N3?=
 =?utf-8?B?RWhUWFhlYVQwM2ozYXNmRklmYUk1OWExbEp5NVEweCtEbnVvWmx6YzhiM1FL?=
 =?utf-8?B?TGRMVmVsa0ZBOURCMzZpeDU1cXNuVS9vYXNvTHpxdDlVZGdCNktBMjRsZFhW?=
 =?utf-8?B?NGhXWHprTk9XNTJjWlFkM0owMkxEcGpaNnBhT0tQcHFiL2l5V2xMTFVqWVdE?=
 =?utf-8?B?YXBCelp1K29vT0xWMFEzcXlOblNtVWxVNmFWVEFuQUc2eWtldlFtbXcxUmQ1?=
 =?utf-8?B?RVhDbVpmZ2dJUFZPSzJZVStSajlpZUJMRU0vQjhLOThUdzl1aFJsMUZaQWVI?=
 =?utf-8?B?VllEZ25DbDhUOUx5SmpLdGNQSTlMNTd5Umh3bkpybk5SbnR0WnhsK2M0YmR2?=
 =?utf-8?B?SDJ2Zk9SR0liRnI1OE9HYlBNVG9uUE10blloM0xIZnNMSENFV2IxRmFrK2RI?=
 =?utf-8?B?VVI2Z0k3dWc4Tk1BWUR0dEd1dlJSbXlIMHRIZElZM2ViY2hlV01OUHFSeHpq?=
 =?utf-8?B?R3JHbVg2RERLa1FxYmVoU0ZpQnpESkxMOFN6cVhjVm9yWWRkYmtleXl4TXlv?=
 =?utf-8?B?b0s5eGNoTlQxU29qVElmTXZpSncrVjRTYldlTHdBeDE1T2t2ZkN6Y1JjdjQv?=
 =?utf-8?B?NjlVUGpkM3pwUTNyZ3J5L1p4aUMwYnZ6MTJTeGg2MTdyQVRBQ295djRGNkkx?=
 =?utf-8?B?cVZMeHVnZjFWNjdTbFZXTC9uYzR6N29KU0VJeHlMNDNtUk1pbDd5YWJIYjRO?=
 =?utf-8?B?K2tzOFBRTzk3QkhnNXFxQW9ITzA0ODViU0tMMytzQTZvaGdpTlBQSTFuWW8x?=
 =?utf-8?B?dW5DMUtHSkl4SXlmejdlSDg4ZjFpQ0xDa3dzdTRFTmMrMlZWS3lwTHF5OGoy?=
 =?utf-8?B?WFFVN2M2SUN3QUhZc1IwcDhoczhIejNPaHhLUUNsaXhQeWxpWTU1OGZkaGJG?=
 =?utf-8?B?NEhIU3RvUThqRzRVZk5LK0dvandCT2UwZHdTZXpSMUtQNVZob1hmR2xET3Mr?=
 =?utf-8?B?ejRMeFN6b0twcS9Ha0xvQ2ZhN0VuTmUrblhFeWJYYVgwdVVjWkxyd3h2T2hW?=
 =?utf-8?B?VTNXbDBoY0cxSkJZTjVKbmg4dldIajRQU0xBckRMaDZ5OVkwWVp2YjdSQ3Jj?=
 =?utf-8?B?NjN0ZStSbS9MRGFaY0VhM0wzdTFGVGVYZ3U2b1RRdzk0Sk5ObTBzZ2hCYStO?=
 =?utf-8?B?SktGdnl4ekoybjVkL1dsZkI4VHhTMlFldTJobFZ5SHBZbExQb3UyaWtXMDlQ?=
 =?utf-8?B?WS81a0hRWGtqOVlDSlFWTDZCNXBMZWlkWGRLSEhZSThRWUd3RnpLM3ExbXYz?=
 =?utf-8?B?ZEViZ29rMnlaNXM1ZXdMSkIyYUxYMXBQRmkzUmpFTVNWM2lTcmxyOTdzQzBW?=
 =?utf-8?B?NXlDT0I3R3h0UDc2WnVCQXBOL1ZnT2JjcjArRm5rQ2FlZmprME9YSkR1NDY2?=
 =?utf-8?B?T3VyTmJrVVNMWHoxczFlWjArT0FJbkZHSmgxcnNKTE4yUnNoRHF3dy9YSzda?=
 =?utf-8?B?RXdqK2xYbjRtVzlkY1dIZzIxbXhSRnlJT1Rvc1E3Q1FXMWNzbHkrWHMzTTJI?=
 =?utf-8?B?TkJ1S2k1dlZsOU5EcWd0elM1a1N2c1E4WTQwdFg3TUxrQ3IxZWF1dUJRYjFR?=
 =?utf-8?B?VURoN3NXMjZwMGl3Z3RLOThXUXFvQUhVQkVHOWEramJXeHJDV2VaNVJwYnpG?=
 =?utf-8?B?elJMNGRWMXFoaDNZMUVIT2hVY2pQdlhXQnJNRUx0YUIyV3dlS2hLYmlaWDZh?=
 =?utf-8?B?TlNwQ2cwSzdjbSt3Z21sRG5FbDc2RzMvODZWY3pnM0owS1NTRU5GbnRnMldu?=
 =?utf-8?Q?ZgfzODHBpRLdomq6j9Z+XDImL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c30b37-759a-477c-8eca-08dd2b370892
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 14:09:12.5021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAOaSpfj7+QivMKyWd65P024TKr/gzYWX0WKy6wVWAAyXOfvtSRvx45DUOYB6A4jvcDEpHg3RqFxdsybUh5FzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6714



On 12/30/2024 2:36 PM, Melody Wang wrote:
> Provide helpers to set the error code when converting VMGEXIT SW_EXITINFO1 and
> SW_EXITINFO2 codes from plain numbers to proper defines. Add comments for
> better code readability.
> 
> No functionality changed.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Melody Wang <huibo.wang@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++-----------------
>  arch/x86/kvm/svm/svm.c |  6 +-----
>  arch/x86/kvm/svm/svm.h | 29 +++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 59a0d8292f87..6e2a0f0b4753 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3420,8 +3420,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  		dump_ghcb(svm);
>  	}
>  
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
> +	svm_vmgexit_bad_input(svm, reason);
>  
>  	/* Resume the guest to "return" the error code. */
>  	return 1;
> @@ -3564,8 +3563,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>  	return 0;
>  
>  e_scratch:
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
> +	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_SCRATCH_AREA);
>  
>  	return 1;
>  }
> @@ -3658,7 +3656,14 @@ static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
>  	svm->sev_es.psc_inflight = 0;
>  	svm->sev_es.psc_idx = 0;
>  	svm->sev_es.psc_2m = false;
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
> +
> +	/*
> +	 * A value of zero in SW_EXITINFO1 does not guarantee that
> +	 * all operations have completed or completed successfully.
> +	 * PSC requests always get a "no action" response, with a
> +	 * PSC-specific return code in SW_EXITINFO2.
> +	 */
I feel you should make this more clearer by mentioning "no action"
corresponds to SW_EXITINFO1.

> +	svm_vmgexit_no_action(svm, psc_ret);
>  }
>  
>  static void __snp_complete_one_psc(struct vcpu_svm *svm)
> @@ -4055,7 +4060,7 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
>  		goto out_unlock;
>  	}
>  
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(0, fw_err));
> +	svm_vmgexit_no_action(svm, SNP_GUEST_ERR(0, fw_err));
>  
You missed out on Sean's suggestion to add the following comment.
/*
 * No action is requested from KVM, even if the request failed due to a
 * firmware error.
 */

I feel this comment is necessary since you are calling
svm_vmgexit_no_action() that sheds light on SW_EXITINFO1.

Thanks,
Pavan

>  	ret = 1; /* resume guest */
>  
> @@ -4111,8 +4116,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
>  	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
>  
>  request_invalid:
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
> +	svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
>  	return 1; /* resume guest */
>  }
>  
> @@ -4304,8 +4308,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		return ret;
>  
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_NO_ACTION);
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
> +	svm_vmgexit_success(svm, 0);
>  
>  	exit_code = kvm_ghcb_get_sw_exit_code(control);
>  	switch (exit_code) {
> @@ -4349,20 +4352,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  			break;
>  		case 1:
>  			/* Get AP jump table address */
> -			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, sev->ap_jump_table);
> +			svm_vmgexit_success(svm, sev->ap_jump_table);
>  			break;
>  		default:
>  			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
>  			       control->exit_info_1);
> -			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
> -			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
> +			svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
>  		}
>  
>  		ret = 1;
>  		break;
>  	}
>  	case SVM_VMGEXIT_HV_FEATURES:
> -		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
> +		/* Get hypervisor supported features */
> +		svm_vmgexit_success(svm, GHCB_HV_FT_SUPPORTED);
>  
>  		ret = 1;
>  		break;
> @@ -4384,8 +4387,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  	case SVM_VMGEXIT_AP_CREATION:
>  		ret = sev_snp_ap_creation(svm);
>  		if (ret) {
> -			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
> -			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
> +			svm_vmgexit_bad_input(svm, GHCB_ERR_INVALID_INPUT);
>  		}
>  
>  		ret = 1;
> @@ -4622,7 +4624,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  		 * Return from an AP Reset Hold VMGEXIT, where the guest will
>  		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
>  		 */
> -		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
> +		svm_vmgexit_success(svm, 1);
>  		break;
>  	case AP_RESET_HOLD_MSR_PROTO:
>  		/*
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 0de2bf132056..f8c5c78b917e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2977,11 +2977,7 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
>  	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
>  		return kvm_complete_insn_gp(vcpu, err);
>  
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_ISSUE_EXCEPTION);
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> -				X86_TRAP_GP |
> -				SVM_EVTINJ_TYPE_EXEPT |
> -				SVM_EVTINJ_VALID);
> +	svm_vmgexit_inject_exception(svm, X86_TRAP_GP);
>  	return 1;
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 43fa6a16eb19..78c8b5fb2bdc 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -588,6 +588,35 @@ static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
>  		return false;
>  }
>  
> +static inline void svm_vmgexit_set_return_code(struct vcpu_svm *svm,
> +						u64 response, u64 data)
> +{
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, response);
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, data);
> +}
> +
> +static inline void svm_vmgexit_inject_exception(struct vcpu_svm *svm, u8 vector)
> +{
> +	u64 data = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT | vector;
> +
> +	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_ISSUE_EXCEPTION, data);
> +}
> +
> +static inline void svm_vmgexit_bad_input(struct vcpu_svm *svm, u64 suberror)
> +{
> +	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_MALFORMED_INPUT, suberror);
> +}
> +
> +static inline void svm_vmgexit_success(struct vcpu_svm *svm, u64 data)
> +{
> +	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_NO_ACTION, data);
> +}
> +
> +static inline void svm_vmgexit_no_action(struct vcpu_svm *svm, u64 data)
> +{
> +	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_NO_ACTION, data);
> +}
> +
>  /* svm.c */
>  #define MSR_INVALID				0xffffffffU
>  


