Return-Path: <kvm+bounces-58315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1893DB8CDCB
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 19:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04332164E41
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 17:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D557D302147;
	Sat, 20 Sep 2025 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dh/TFcPX"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012054.outbound.protection.outlook.com [40.93.195.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1499419C566;
	Sat, 20 Sep 2025 17:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758388884; cv=fail; b=s17UgoMtGWcU6PAAqKWi2F/dSVme8RYGnDT5NKQEez23s6wvhVT9Sp/pUzFKUsHGuBs6Ah46iqXneU2rcKGdLREPdGujHEMCiHGMEnhkInmLrAQr7V5P4HNZO/PYnjq4a4kr/o6C8KDaKD5fz059MdCyU9HEY7ZxEKiMb+XJHjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758388884; c=relaxed/simple;
	bh=8YsYw5BH51FZcde1s5n2FxFhia6SK7kmnhGERuZs8V8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IGRQbLXAl/J1qFp4KlJyBJhXZ8Z9AVPjCyHNA4/jANexcLw2WUms3fwCFonGz4IYnm9n8T7AzRPwSPiV9J0SvKWngI8g8aFV05vZftvHmJ0OUnkEr8yE4Uv1pWCkUSXNXBdETk1pENcaN+IDgdo5caKzF9ZWjkKwC4ZfYqGNSNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dh/TFcPX; arc=fail smtp.client-ip=40.93.195.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rGtQu1xpy+9Xi22EdhBbhKkaixxsmtOr3iqdRmI3oMkuXkvpTc5kNulZ+/sg2kBAgg5wMtrJRzGoS6FfHRcwETrlpgeiJjqod/iJTLXm38OktHhdp1Ghd3Xvy5ZupKV61h0HAG/KvVlDLUpoBQfCUIS/NU7kthWXBVpJDGGFsdr5u87DgOhK4nETnxKl81hGVBlp45Dzw4RfazU0ZUlW3oCYBrlmCXmE8qWkA4AEh/eZa+/IYPZiyexpflrS1hL9zMYd15oC6Iea8ziVVhlO3Ps1ONbUC9OGYTuj3S0s+1E8SIh4x/tfOBiw96SGkS5MxaWLRVhk1GKJEkjXIWN8Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNL4FLrP6Iuj3NpeAPZq1iXGlkvZPuHVX/w+V4odZUA=;
 b=DpxjJfHubQ/4G7s8LE93hBX/jKF+FkoRVPEzo7gJ0z0lHVH2Du0TsBbUQphaJX8DWAAvo4kN1nX4J2HwA9R5WqTyQs5UiiZL9hvlnm/ow54QaNb3OkjmoznZYm1yUme2vzLVPC2QqyCvGicEXN+AS/0IhO8JR/9rYtMZ3ZU+W3VI5jQstGl/AxDCWpoReMdUc0+TZeDf5xGlIoxKtOsMReD/tq907w3YjV/16pGDMbQDxTOJSmtuIxEW3pimb2wGS8XObJmlTG2gBSe8R3WFYj3RS96TTEBYj2T9Rx40gdMMO79N2z3c3dWhYd6dIqN70c+L2YAossiBbHCWHo0ZzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNL4FLrP6Iuj3NpeAPZq1iXGlkvZPuHVX/w+V4odZUA=;
 b=Dh/TFcPX/PDQv/+aBPpkeXf3BmdjUvqd6zzFOJ/FJn8/bet+h2dgGHfW4klt6CrB+jdpETv7YayONDOdU8GJoD+d8lf4NxxgxBL8qVbDwXZkcbWxGvCn1prVSnxK3reWEjk65ANdwkYTYi51lET+2WX1+tRXjMjO0U3ULDwNEXg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV3PR12MB9118.namprd12.prod.outlook.com (2603:10b6:408:1a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.18; Sat, 20 Sep
 2025 17:21:20 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.017; Sat, 20 Sep 2025
 17:21:19 +0000
Message-ID: <63b7c94b-3d37-42c7-bbfb-8547d46f3b1b@amd.com>
Date: Sat, 20 Sep 2025 12:21:18 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: SEV: Reject non-positive effective lengths during
 LAUNCH_UPDATE
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>
References: <20250919211649.1575654-1-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20250919211649.1575654-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0059.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::11) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV3PR12MB9118:EE_
X-MS-Office365-Filtering-Correlation-Id: adb85091-2d88-43a5-8efa-08ddf86a1d22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVNBaXRvSFFiTGpDWlhZZHZQTk52N1BidnlZT3VCOVhWUk1aZXJzL3lEdUcw?=
 =?utf-8?B?OGtIV1l4cGI3amJzSWZWdHVXKzF5THNXNDc0QmJyZFNsWEp6ZFdIVmFscmFB?=
 =?utf-8?B?bzhhY3gvY0VlZmwwaG9EMUdPNDJ6VEluWXpodFd4TWg1OHVFYS80Z1dSbGMz?=
 =?utf-8?B?cGRobjRPdFFINDhSWmhPQ2RkeGFjKzBiQVVCTWJWTE1hUkZqRVBNMERxSGVo?=
 =?utf-8?B?cCtTcEVtRlNLOVpkVHV3STludFUzWkd1aGNORVNoMW5tL0xTUkc1SnlPU3Fa?=
 =?utf-8?B?cG1pa2FWMHBPSEh5OHZFSHRJMGNma1lVbi9vVys0TUx6eE92a1BFN0dFS3NM?=
 =?utf-8?B?TCtTMWpYbk5RT3RydmprQVFqQXdZUS8wencvUUk3SVRwNVRmaWpGMmlYWHBa?=
 =?utf-8?B?RHhJU2FJNEh5Um5Jd0Y1cENKTGtQRDYwSEwvQmRrMWtDbnJGdWdyWmM1YTR2?=
 =?utf-8?B?RUNXaUR0UHY4WE1JSWtYQnhFQ0xlTHh4aWxrS1Byb2h4RTU5eTg2NGE2RUF6?=
 =?utf-8?B?U2R4ZXZaR2ZOQTVMM01pZWRIQTVPU2czWE5hdmp1SjRwRm92U3hFbjEvSFV0?=
 =?utf-8?B?TkNzNGI2ZjdxM3l6aitnV0ZvRFF0bjNwQ25pbDlxL2wyZ1VKbGNGYVdGNFZE?=
 =?utf-8?B?LzRhbHhiRy9weEo0SytxbFJiNjRCMFdHbmRreDQzQ1lxL2J1cTh1T1VBN3Ax?=
 =?utf-8?B?VFBVVW4yUUQ1ejFFV2YzRzJ4dDdkS1dRdmswM3ZFcGkvV3J1R3RoY29GQ3lt?=
 =?utf-8?B?YzY3cFVuSGFaa2p5MGYxL1JNc3ViZmZsK3hzbzg1VmFBSWFkc2RRR2pLL3d6?=
 =?utf-8?B?M2Y2dVNSUmhFOUNua2JuVmZqaGZtbkxXaE5HSm9zRkk3ZUpyVitTNzN5UWZk?=
 =?utf-8?B?T1c0TDZiNjhVR2VIb1RYckFJZWhJMXlEeitVWUhweFkyNTdiVEZEVWwxQTJG?=
 =?utf-8?B?STErZWVqL2h4SHFlUUxOYmpRcVI4M0x4WUViRWg0UkFuVzdqV1k0T0NxZFox?=
 =?utf-8?B?bWo5Zm1ZcUpPM3ZGc28vRGtUSVhZN3F4YitsS0t6eXpVa0tORUhXSzdDUmdV?=
 =?utf-8?B?SDkrNEh4OXVHQTZRbEp3dkZqT0hLNEswbEFZMis1TkpZaG5xaDc4OVF2N0xJ?=
 =?utf-8?B?RUYyNWNSZ2VDNDNHN1FzcVEzaHgrYTFuNWlxcjBpYXg0aVZpSHphVURST0pJ?=
 =?utf-8?B?NVdxWVB6L0dBSE9lenVndUdBRkZqUk4zdEZLQ01zNml3NmxnQXdwOHd2MWdU?=
 =?utf-8?B?TE1pbGUyWExkUDkxcHJoSTJMOXo3OS9KUHcrTUJPSGQ5VjQvcFdKRGRoVjZ1?=
 =?utf-8?B?Uy9RbXl1dEJUeGVORVdkK3AzT2JHMk1PNGdJcXVxMFY0VWtuUUNwUnZYSGdy?=
 =?utf-8?B?Wm16T2dCankvcWIrYkhabHFBa0pXdkJTV0JMaStPZzY0VFlNTHd0MDA2WUVv?=
 =?utf-8?B?VGpjTEVxMzhDc2E1UVdXdFZUUEJGTnE2bmlrNW8yQWMwMVBiUTZ6bWFOajVJ?=
 =?utf-8?B?NCtWOWVjcW9ValQwaGVqd3B5Nmh3czNsNEcrQlBLTEhRTHpNQXZ1K2lvb3Js?=
 =?utf-8?B?QU1lRVJqNmlJYWUyV0FBZWJDUm9uV01UT0l2d3NWNkpWdEE5TjQvTEdGcllm?=
 =?utf-8?B?S3FSbExvOFRKR2pGRkF6clc0aUlUYmV5RWlKc3VMd05uSzBnUGI4N0xLNG9a?=
 =?utf-8?B?cUs3aHZtUWlDMWNzWWpKSnRSMmtCeEw0M1YvazRnakFXN0xzejNiWkVUaHp0?=
 =?utf-8?B?WVNIalFCYWxWalIvK1hGbG0zL2JjSTdjY2J2aUQyRnBmem9sZUE5UFpSaGxp?=
 =?utf-8?Q?y/at4EWjcMD51PLiQq+UMbwLFs+NR3WX+xSBs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zm13NExQZTZDaTJ6ejRuMDhZSU02am5ORW52V04yMnRIbGVBa21RYlFSVDVJ?=
 =?utf-8?B?WGNTZ3hoeWcvVVhQQ1kxS1N1T3B2UmhIb3hQSkw3R1AyMytPRnNiRjJtekFX?=
 =?utf-8?B?dHdxT0VIQTRHb240TEZ6U2dSbWJOcmRBUmJnaGhqUExpdWRNLzNpekpZTk4x?=
 =?utf-8?B?ZEUzdW5FbXBDZzNQZEN0QnkzSFk3OUpNaEQ4Yk1ZalpBK2hjT3ZiM0laZkNQ?=
 =?utf-8?B?YjhPL3E2bVEwYlhnbUxBcHhMMEtVSHdJWGloZk9TMGhFVXdrcUJ1S213VXZQ?=
 =?utf-8?B?V2NHajhrQ1k4T2JZMTVWaFpzZHBJeU5vNVRoWlBLRTFNV2h3dDVmT0hRNHVj?=
 =?utf-8?B?MDBlQ1QrOUVsQUZMQ0EzVVhUMit2TW1oQUZFblRkSThPVkU5TXdaYTBvQXlp?=
 =?utf-8?B?SlhnM1A1TXNzVS9mSWt4OXdJL3FETjVDRDU5UDB3SytQSXg0bElxaytoR3p2?=
 =?utf-8?B?V3dPS0YrcWZ5VjJ2akxpZWtkRk85QVpqOTA4SkdidC9tUkRnNUdWTUJIdDJy?=
 =?utf-8?B?aHFYSENkNmxiQVJUNVp1Q3p2MXBDTWNNSWIyVE9RS1J5UnJDR3BLZTVEQ0JD?=
 =?utf-8?B?U0N4eVlRdmF4aVk2RFQrV2JTMHQ0eS9vdXQwc3JFZzFnc2ZqK3F6bGJUNmQv?=
 =?utf-8?B?WW9UR0w4SFZ6SGZyOHMyWmgxLzlXK28yeUVNUlFrTjlVMXJ1YkdIcVpYakFm?=
 =?utf-8?B?RlpsakY0SGtjRnMvTFNsWkpOT0trQ2V0K0pQWW9Fd3k2VUdOUk1iREo2Qk1Y?=
 =?utf-8?B?U0pMMDJXQWZycEhCYzBjZUttRkFOc2JkRXE2OXJlS1FPa2ljdEsrVDBYSkpq?=
 =?utf-8?B?YnRabXJvNzFzK21vWW1jZGtER1hiRXcwRWtCM2pyTXVRN01tUTEwblk4Ymxt?=
 =?utf-8?B?WDR5NmRRTksrUkhXSTB5OEFaTVRBWDQ3aVlsSU5UOEcvTjNvbEVLL0NZaXZa?=
 =?utf-8?B?YnpJZGtmQmlNbEdqQUI4MzF3N2pXTjdKTTlOanVHb0dFNHRqelM3dDkzTHo0?=
 =?utf-8?B?cDA3eXpVakRRenRBcmlRejIveDkvOWJxR1I2dHpHOEZpNXhsNURtbEdwTmV0?=
 =?utf-8?B?NStJeWdEVWhUeXdqaVZaV3REczBwaDlsOUlESDhkRXkrd2ZTMFBhSkhkNjl4?=
 =?utf-8?B?NWU3VVNMNmRET05oQlJRcDN5NmxQcWtBdkdUVWZsMHJUVlVPcU1IOFhNeXNm?=
 =?utf-8?B?amc1cFM3Rjg5MEwxVXFJUEx0c2gzTE92Vm8yR3hLQytKVk83RHZFbGkvZFNa?=
 =?utf-8?B?Ukw0Rk9mRDdXcFBSYitkUG03S0lFMHJNWUhWSVZ3MzA0b3JlVWlpbGNlcVpp?=
 =?utf-8?B?WGlUc0JYbGpHODRhcE5TNDZJczRwWlM3Y2oySm5IZ1lWTU9pQnVsUTdVM1hW?=
 =?utf-8?B?UzRDQlF0TnBDb0tjSlZ0QUdWQUsxMkhKdjFrTzYwaWNyNlB0VExGUHZWZEh0?=
 =?utf-8?B?QVFaeDFOcE8zaU9Hdlg5Nk5CRE51d1IwSXJWRGhTeGlQQ0t2L0tGdXl6dWRX?=
 =?utf-8?B?ZUVHbjZocEVsRWkrdFM0MlF0Ujk3amJUVlFJeTBHT3c2V3I1NzRmN2toK011?=
 =?utf-8?B?SUwwOTNqT1ZFaGo1VGIrRTBHb3dTZjVsLzMva0NSTU54YTNWZDJJY05XMTFQ?=
 =?utf-8?B?YTNneWNtMm5ac2ZFaUtDUGRsQ2hBSVVUbGphM2w5QnhybnIwMnNFMGErUEVk?=
 =?utf-8?B?OE1pRERGa1EwWTFISlZibElTbEhkVmR5ajM0RGVrdituUWhoT3JLaGNPSHZZ?=
 =?utf-8?B?a3R5dm5ESHBqSytscFpoak5mZUljdHhiWU1tNllGR1VETmtab1REZERGQVR6?=
 =?utf-8?B?WlQ2TUtyWWpsRXlXaExqN09mZTJESWRWRGtQZHdhL1MvcmhoS3AvU0ZtOE93?=
 =?utf-8?B?Rko2MnY0NVdndkN1Yzc1eGN3OHN0clFQWmFwUlNVUWdDSjVhVVFpR1EzNDcz?=
 =?utf-8?B?b0d5aElBOE9EU2FyZ2FzV3RwUlFpUHQyOE44T1JxVGhOdXF3NWNVVWs2WDBU?=
 =?utf-8?B?Tm5YN0p5RkVzTmNmYW40U2IwNDV0UTlqS2dUVEJDNVlmYkZydmVYUmxIa29R?=
 =?utf-8?B?djNvL3NhVVVYcDd5S2RGMlp0MHlyTTJVMWZIendhaVh2RWpEUmNnbnpndlNV?=
 =?utf-8?Q?InkcuxCltPfDxhiOmcywM8ep8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb85091-2d88-43a5-8efa-08ddf86a1d22
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2025 17:21:19.7580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qihqEC87h0y3OcmqFjJhJAjFh4TLlIWsGCgP/ehEZFjryBqi9tEBb0SzBQqkbOZSYxUdNvOFx/XfDyUHXmoWfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9118

On 9/19/25 16:16, Sean Christopherson wrote:
> Check for an invalid length during LAUNCH_UPDATE at the start of
> snp_launch_update() instead of subtly relying on kvm_gmem_populate() to
> detect the bad state.  Code that directly handles userspace input
> absolutely should sanitize those inputs; failure to do so is asking for
> bugs where KVM consumes an invalid "npages".
> 
> Keep the check in gmem, but wrap it in a WARN to flag any bad usage by
> the caller.
> 
> Note, this is technically an ABI change as KVM would previously allow a
> length of '0'.  But allowing a length of '0' is nonsensical and creates
> pointless conundrums in KVM.  E.g. an empty range is arguably neither
> private nor shared, but LAUNCH_UPDATE will fail if the starting gpa can't
> be made private.  In practice, no known or well-behaved VMM passes a
> length of '0'.
> 
> Note #2, the PAGE_ALIGNED(params.len) check ensures that lengths between
> 1 and 4095 (inclusive) are also rejected, i.e. that KVM won't end up with
> npages=0 when doing "npages = params.len / PAGE_SIZE".
> 
> Cc: Thomas Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> 
> v2: Check params.len right away. [Tom]
> 
> v1: https://lore.kernel.org/all/20250826233734.4011090-1-seanjc@google.com
> 
>  arch/x86/kvm/svm/sev.c | 2 +-
>  virt/kvm/guest_memfd.c | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index cce48fff2e6c..31b3e128e521 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2370,7 +2370,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
>  		 params.gfn_start, params.len, params.type, params.flags);
>  
> -	if (!PAGE_ALIGNED(params.len) || params.flags ||
> +	if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
>  	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
>  	     params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO &&
>  	     params.type != KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 08a6bc7d25b6..1d323ca178cb 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -716,7 +716,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  	long i;
>  
>  	lockdep_assert_held(&kvm->slots_lock);
> -	if (npages < 0)
> +
> +	if (WARN_ON_ONCE(npages <= 0))
>  		return -EINVAL;
>  
>  	slot = gfn_to_memslot(kvm, start_gfn);
> 
> base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4


