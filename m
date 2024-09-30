Return-Path: <kvm+bounces-27666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB64D989A81
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 08:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C95541C212F1
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 06:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8EE614A0AB;
	Mon, 30 Sep 2024 06:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t/RlMdjl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FCF23BE;
	Mon, 30 Sep 2024 06:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727677691; cv=fail; b=HwuBke0URQNSIMOTxHMH0Ye/qQvWWAWN4/3WRW/meQck3w5C0V/tdd8Dvm44ct612yuMT8FHz7MgABcdruR8HjXW1LIDsEoSih8NF9bXwa/XeuXGLx11FRGJrj9dMW6Yyf0rxTHMpY1RUKd2G9QIeO8vmvh3OzUD5AIlLz/aYQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727677691; c=relaxed/simple;
	bh=KI5ifkprfprqg472YS3vTzZDOaf8O3infdlgIo1p/LA=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YbhHv7O2d1kloc/2kw19JMcfq8X3OxP/OgLHVJvassUTZglaibZVpynzaDf64mbpCTTWBlS3LfMdwb2c8L/fGAElmO0H9qe24bc8bHzTsgHil05c42/0dRKiRlUV0X8BiracpMEy2Rhe9bmZarx37Zt6AoJNgKpBynkqgOQeJZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t/RlMdjl; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7hK0VmYdJ3cv87DcJVh244GzEE6RD2t3CMujkyoilufXFjxn4PHNbpf3LFV+hWzlxG8AYhYElaxYGvOIuu3hb2OjPC3KuvYd5oIh+y9fwoqkstqOP2vaxSY4xfQZS7ZxCJKqJMrfh2qqJvQ50SlsgpCu1Oc5gaOWfNkv/HZisP48BSZbUcHQgSHqBwEsBvLCwJlDNbbO3kllZMF1o4mpelh6G1Trh/jJ2xDhv680XKppSno9+cNkpwsFnMMm6ttHnWI+6yDfBzUYG09zEIERoaLtgg0dspWIUxc6d08aMlrD+lovQ8LfvjTBidNHo2VAkjRUfNY3bJCYn3HsJRuiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eH2m7sJTTFq5Tpr4dytmvX44Mm14fsmoV5phvYKpbIg=;
 b=C7hxitwFTQ2MJ4eUkjOEbm8xiD5MowNkitfTB35+lE/BIDUfDYxIFlBqBXE7DH3AVUSbjHOhvTb+lBuZrdBAEIeykt8ejS6yPATtFkzzfeB7kw6NoMbevntBE5pYW8dlwUSancV/WJo72ZOZZZfG6Ll8SdFvM0OgbDmEt4+vL0L+5/dmPGgVemp/h6zS+AYbxGLs6OkI7SMVSi3nh3ErjLE9m18sQOomuiShv3GBSzsAyCLZyp6DFUuEhzGMjYsxAkwsTVdl38qHiOLB/pYVVtI5phM0qKLyg54cFrgV1Mu1d7b0YzLNFJiSbH2zHUuA85vyrT/GUt7mZdNB0RaGEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eH2m7sJTTFq5Tpr4dytmvX44Mm14fsmoV5phvYKpbIg=;
 b=t/RlMdjlfMZbb2uYT4QQl7nS2TFVHP2KLDG4tNel0qpylnRuMaelI4N085CgPXnxkt9uV0u1o/Q8MLOPAcJN/0GC4V9H2sSIlRkoHS/fIqPd/o93oWdol94lYYjk+UaKiJVOsKsMtvOP5Eu5tZkYLMiHiO8uapfVhVYFc+wg9AU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH0PR12MB8176.namprd12.prod.outlook.com (2603:10b6:510:290::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Mon, 30 Sep
 2024 06:28:04 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8005.024; Mon, 30 Sep 2024
 06:28:04 +0000
Message-ID: <64813123-e1e2-17e2-19e8-bd5c852b6a32@amd.com>
Date: Mon, 30 Sep 2024 11:57:54 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
From: "Nikunj A. Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is
 available
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com,
 peterz@infradead.org, gautham.shenoy@amd.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-20-nikunj@amd.com> <ZuR2t1QrBpPc1Sz2@google.com>
 <9a218564-b011-4222-187d-cba9e9268e93@amd.com> <ZurCbP7MesWXQbqZ@google.com>
 <2870c470-06c8-aa9c-0257-3f9652a4ccd8@amd.com> <Zu0iiMoLJprb4nUP@google.com>
 <4cc88621-d548-d3a1-d667-13586b7bfea8@amd.com>
 <ef194c25-22d8-204e-ffb6-8f9f0a0621fb@amd.com> <ZvQHpbNauYTBgU6M@google.com>
In-Reply-To: <ZvQHpbNauYTBgU6M@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0233.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::12) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH0PR12MB8176:EE_
X-MS-Office365-Filtering-Correlation-Id: caf97ef1-84b6-4fb1-0f0f-08dce1190a18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFNETzFZMzJmNUg1V2QvU0drOEltZEVhcnZPZmtJbWtXN1h5U0Vvd3JDS2FY?=
 =?utf-8?B?NFMxSnp1MjhlMXMyWkZUK09vRHU2b1Y5ZVM5MG04VkM4SkpMMFg1aTYwQ2k5?=
 =?utf-8?B?djVNYmtOV09icUxDdVQ5cEt5R2RWSVVOTFdkK25qYUt3K2xsblJrZ1NYYlho?=
 =?utf-8?B?dG5Ra2VkaHNSbjhGcjVHMVZEVlBkK0JXa0hjMElrb09LK1E5cmtsR3ljUTg2?=
 =?utf-8?B?aDVwOXNMTjZtVnBSTUlIeVBpbGtiQ3BrUFQ1b2hITDVHN3o4N0hkOEFCMElW?=
 =?utf-8?B?bDZISTYxcjZDL0FtaHpEVHdqajJxTEpiN2VieWJoY0pOR21xRDZvS1ZaeGgy?=
 =?utf-8?B?S1pianRPTEFTSy9RK3NaN1Nzb1BzTzAvRU9XaVdSY3ZyYWhHZjZKTXhCcFRS?=
 =?utf-8?B?UTNydjBrNDBoMEtuQUl2WWpad3FEdEJBamM0OVR1VU1iN3VLK294dlRSMzQr?=
 =?utf-8?B?YjI1cC9DTzN3djNqWEhWSDkzTU5uYlh4VzBjSFYyV2Y3UVhkN2diek5Eb2xv?=
 =?utf-8?B?VFp5a2FTK0ZNckUra1dnY1M5NTF6ellCSG44UDJzUm9YcVRKSDFnYWR4eFQr?=
 =?utf-8?B?V1hTOVdpbUtiQVBkcEpJQ0x0TkZJNmlCakRTdEpJMWsxRjR2ZTlTbVF5aVFh?=
 =?utf-8?B?b2dtTmlnT2krVTlpb25aVlhuaXp3bmdyenlWWU1aRlNIWk1mZ25aU0U3QkVL?=
 =?utf-8?B?ZkoyeVhndVgza2xOaEcxOGllRDMrTzRBejdieGsySGcyQi8rQWwyMGdDa1Rp?=
 =?utf-8?B?MGRmOGtHRU9JTkdxQWpPUS9rV1RTMDc2RUpQOE5RbjlCYTZtRm5oSWF5UDRJ?=
 =?utf-8?B?aU5HdWtyc3VQcjNjeVZFV1BLWndVTUJKQWJSdDJFOTBXYk5PVWFBSVlNSXJn?=
 =?utf-8?B?L2tmZ3hFNmg1eS9mVmo5QmNEaWJPT1MvT0c3c3dVUHdSR0tPSUdiOGpha2VO?=
 =?utf-8?B?aE9aWXVmZ3ltaVI2a3R3VGxQVURZaTdhSHYwTkVub1BXeE8vV0REcUpNeFJ2?=
 =?utf-8?B?ZDM2aU5wK2JUM1U0U1FJMFhxMkd5SytBOExkUGR2S3kzR2ZZMUhSN3l5dk05?=
 =?utf-8?B?SXVoTGRyNGlxWklIbEpYNGNPRkFXc1IvK1VUd0pGdUZlYlhNMGZwbW1OUGdF?=
 =?utf-8?B?MFNoTVU3M3ZCRXVlVVp3TzhYRUNwT1RWekZzU1dxdlJiN21aS3g5VG44QnVP?=
 =?utf-8?B?N29NR00rN3ptNnRaUEtVdDFoTXEwemFrTW84M3dDS1Y3dHBzeUtoenV2azgw?=
 =?utf-8?B?MzlDK013VW1kUk56SjBybkpFaTBtbE0yL1JEcTNlTHFoUHRySit1SllCUkxr?=
 =?utf-8?B?T3B3WTFXWDU2bUYycGFRbGZZSExlM3hCQ3JPN3J4ZGNZNFp5OVltR0U4QTFv?=
 =?utf-8?B?dHNFTkRiVWVBay9KRFVmVGtNdE9yQVRYMjBTOWZUbmJwdGJlRW5RaFRjY0FJ?=
 =?utf-8?B?QjN0a2Z3Q2l1UGJNa1BUSmdPVHF5VlJma05DZGdrbTZuZm5MNldUeStaNmVD?=
 =?utf-8?B?bWs2clBCaWJqUkxhL1plYmhlU3VCS1I0OStVRmdIQzEvb1NJS0tFWHZKdDZj?=
 =?utf-8?B?Ny9kZnN4UlZibHgzNnE4bnpUQmdsYUxMeER3T2tRdzFZeXJkWHVuaXpXNlE3?=
 =?utf-8?B?ajUyUk9TdkplcDRrZmxCVHhyM05aQ1BxL3JiOHV0eEFuck5lVzJZQ29Bd3ZB?=
 =?utf-8?B?d3RyWXdtOXJTcEhzc1l0UDhKOUd3ZHY3N0o0YUQzeCtpWERYenM3QjRBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFQrbmtETHBhV1ZrbUlzdXBwZGI0cTM5c3B3czVDbVJWRWYwMXB0d3JhajFk?=
 =?utf-8?B?czNrL2FTelplQ3lVNk5wYU9mZzE3eUJzNkVPV3U3Ui84cXR5dXI4eW1iM0tu?=
 =?utf-8?B?NGExcDFaYjg2Q2hvMmlxcWt6V1RJSU1DVDQrWEhzMW1NOVExSmc2ZVRNNlRP?=
 =?utf-8?B?TXlQemwwY3E2SUc3ZFk4UmdqUXhIUDZjKzV4ZkVnS3V5RzJVMjlHbGJHSE53?=
 =?utf-8?B?d1BydVljdWZNMEp1NHJVWWFiUUhDMjhsSUZGR2g3WG5pbVVNcjQ2SVNyb2Uy?=
 =?utf-8?B?dno1K1NDTE5pM1J4UzNFeVZXYXAyc3MrWmlaOXVnb2hoZHozYlp5ZEVqNy9o?=
 =?utf-8?B?WDRBbHgwQ05DMW5tVjBvUEJrMHBIV2NrQk4yS0dKRklKZldNazdESGxDZUpC?=
 =?utf-8?B?MjdrK2kveTlLS2dtNXQyamxBRGN3UDR2a2ZRKzZNeHNiVGIzZTlEM3ZmTFFB?=
 =?utf-8?B?MkM0TDRVOW81RENLcVF3bWFlOGdsT0VpclVmYkFya2lqUGw0cTdscWZUUzR4?=
 =?utf-8?B?YlRabUJaTmRwa0ZCNjZyVUE1MXJ2bVFkZXJCYzNkOFkrd1I4VkNaMzNDZTVi?=
 =?utf-8?B?ZldCOENhY05NRTEvcHdEdTBlZXFyRlkreDJkY2hCRkFlUWp4T2RPMnNQZmNu?=
 =?utf-8?B?Q3JJVzN3R1AxVnh3Nk8yM1dEdUlZdEZNYWlkdlZlQzdjOFBJOHFGZm5GbVVW?=
 =?utf-8?B?VHVOdzYrSmtMU1R4bGVxM0xqdU1CUjE1aGlJOGtESTRwbEtBUWVweDZLZFor?=
 =?utf-8?B?R2Y4T3BDZUkxMHFxaGtLRHRmeUtpMWdYbjA1b1lueEFqSFhIK2tQUVJnNGk1?=
 =?utf-8?B?cTNHY3RuTTZveWlwUzJ6WnlvVFNUdDdwL01tMitURmIvcnZPK04rZ054YW5S?=
 =?utf-8?B?UXN2eE90S0tyY1laU3haU01UV2pUM0tMc3pBbFZCQko5ZUc2RHByOG9Sb1h1?=
 =?utf-8?B?dHpiOHd3Q0tZYk4yT3BtMUxrKyt0Q2V3b3BBSHlRZXRxdnh5MWg1UmVQKytz?=
 =?utf-8?B?amxnb09OZmdpV014d2kzMHNKZEVLT0M2N3pVQm40aEZhNE1jNk9BOXRXVW1E?=
 =?utf-8?B?K2pxd1V6ZXpxT3R6Q1AyZEdLSTV6Z2lCOHZzdE1OK3IyS1RGS1cxNldDMTBv?=
 =?utf-8?B?bW1jQ3lGV1B4WWFoT005Z3YxRHpLZkZ6N1hrVmVqVnh6dE8xbitoWjlvdENt?=
 =?utf-8?B?K244QnE5QWlJQ1RCNG5PUWRWSGhOWVRPb2VidzVhZUo0NFhkdzlxcTJkM2tC?=
 =?utf-8?B?TFFDQktZaFQ3TDl6cTlwZ2RCTmNDTGVSQ0JkRUduV3ZpWnBicXdKWS9oL2gv?=
 =?utf-8?B?M1RoWlBVYVc2SmdnbTZSa29EVVJXU3ZpazUrcWVoak1zSGRuSkpMdGxTWTQ1?=
 =?utf-8?B?UWRCYzZMOXMyaFdMbTRMY3UwaEpuMFdBM0V5KzF5ZXRVNDI0OVp5aTdMK3Fn?=
 =?utf-8?B?RGdCNnU3MXZLLzdVZFJ0cXZzRzlxUG5ITkpZd1VhTHg4aWUxOUo0M28rV3hp?=
 =?utf-8?B?VGdZSTNwN1AyVnVGSGJYSG5MRlNpWjlGNU45M3ZDM0hwSVVSQUxUOTBZdSt1?=
 =?utf-8?B?M3pSNTU1UlJrRWIwQ2RDNkg5YStCS1hrRnBxVjFUNmYrVVNkQWFZT3ZpWGYw?=
 =?utf-8?B?blZabWwvTXNzNE1oc3lxQ21QdjRMTVg2SkN4TnRnSWROSEMrZ3FkdVZ4Rmlu?=
 =?utf-8?B?TFNKUHEySGpZMWF6YVdyVzhVbHk2QlNrQ2NzRUl1Z2d3ZjZXUXNRN2VvUFAr?=
 =?utf-8?B?RHVucnV6VWRDaFR4ajFmbmZVaGhMdXc1djNVbUFFem9GTUdVMy9mRCsydWls?=
 =?utf-8?B?UTF4amlLZ3lsYnBpaXdRdTJqaG55c2ZmUzJHeEU3cjNLcTdNemxVR3h4R0M4?=
 =?utf-8?B?WVhVRUdnWWZzejVDY25hT0RaU3pGL2hGOWFiWllkK2s2Yk1ubXpXdEtRbWhH?=
 =?utf-8?B?bDZIdHRHSVcxbTM3UmVvMnpCZ2NsTTFaR0tmTmN4SWc1aFcwTnpaMmNoMVhY?=
 =?utf-8?B?anlvd2JMdU8wY2syQngvaEI5ZlJFa2Z4YXZjWE1rTE1Yb0FPc1k4bVZkbHR2?=
 =?utf-8?B?NmVrMmJwdXE5czFOa0c5WEtmNEtLNXFIa0tTVi9vMzk0c0ZkVHlKWXkzaDRX?=
 =?utf-8?Q?hiQ7Dg94i798oIHtxz1LPymWY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf97ef1-84b6-4fb1-0f0f-08dce1190a18
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 06:28:04.3042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9kqvZh3oHapEGwqQVETu8K03GKGm8FXD5h10xH3D4WuOVwSyAHX+feHLzbUZ2UyyvPsbmUDofj9kdBEsSoHJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8176



On 9/25/2024 6:25 PM, Sean Christopherson wrote:
> On Wed, Sep 25, 2024, Nikunj A. Dadhania wrote:
>>>>>>> Are you suggesting that whenever the guest is either SNP or TDX, kvmclock
>>>>>>> should be disabled assuming that timesource is stable and always running?
>>>>>>
>>>>>> No, I'm saying that the guest should prefer the raw TSC over kvmclock if the TSC
>>>>>> is stable, irrespective of SNP or TDX.  This is effectively already done for the
>>>>>> timekeeping base (see commit 7539b174aef4 ("x86: kvmguest: use TSC clocksource if
>>>>>> invariant TSC is exposed")), but the scheduler still uses kvmclock thanks to the
>>>>>> kvm_sched_clock_init() code.
>>>>>
>>>>> The kvm-clock and tsc-early both are having the rating of 299. As they are of
>>>>> same rating, kvm-clock is being picked up first.
>>>>>
>>>>> Is it fine to drop the clock rating of kvmclock to 298 ? With this tsc-early will
>>>>> be picked up instead.
>>>>
>>>> IMO, it's ugly, but that's a problem with the rating system inasmuch as anything.
>>>>
>>>> But the kernel will still be using kvmclock for the scheduler clock, which is
>>>> undesirable.
>>>
>>> Agree, kvm_sched_clock_init() is still being called. The above hunk was to use
>>> tsc-early/tsc as the clocksource and not kvm-clock.
>>
>> How about the below patch:
>>
>> From: Nikunj A Dadhania <nikunj@amd.com>
>> Date: Tue, 28 Nov 2023 18:29:56 +0530
>> Subject: [RFC PATCH] x86/kvmclock: Prefer invariant TSC as the clocksource and
>>  scheduler clock
>>
>> For platforms that support stable and always running TSC, although the
>> kvm-clock rating is dropped to 299 to prefer TSC, the guest scheduler clock
>> still keeps on using the kvm-clock which is undesirable. Moreover, as the
>> kvm-clock and early-tsc clocksource are both registered with 299 rating,
>> kvm-clock is being picked up momentarily instead of selecting more stable
>> tsc-early clocksource.
>>
>>   kvm-clock: Using msrs 4b564d01 and 4b564d00
>>   kvm-clock: using sched offset of 1799357702246960 cycles
>>   clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
>>   tsc: Detected 1996.249 MHz processor
>>   clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
>>   clocksource: Switched to clocksource kvm-clock
>>   clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
>>   clocksource: Switched to clocksource tsc
>>
>> Drop the kvm-clock rating to 298, so that tsc-early is picked up before
>> kvm-clock and use TSC for scheduler clock as well when the TSC is invariant
>> and stable.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>
>> ---
>>
>> The issue we see here is that on bare-metal if the TSC is marked unstable,
>> then the sched-clock will fall back to jiffies. In the virtualization case,
>> do we want to fall back to kvm-clock when TSC is marked unstable?
> 
> In the general case, yes.  Though that might be a WARN-able offense if the TSC
> is allegedly constant+nonstop.  And for SNP and TDX, it might be a "panic and do
> not boot" offense, since using kvmclock undermines the security of the guest.
> 
>> ---
>>  arch/x86/kernel/kvmclock.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>> index 5b2c15214a6b..c997b2628c4b 100644
>> --- a/arch/x86/kernel/kvmclock.c
>> +++ b/arch/x86/kernel/kvmclock.c
>> @@ -317,9 +317,6 @@ void __init kvmclock_init(void)
>>  	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
>>  		pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);
>>  
>> -	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
>> -	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
>> -
>>  	x86_platform.calibrate_tsc = kvm_get_tsc_khz;
>>  	x86_platform.calibrate_cpu = kvm_get_tsc_khz;
>>  	x86_platform.get_wallclock = kvm_get_wallclock;
>> @@ -341,8 +338,12 @@ void __init kvmclock_init(void)
>>  	 */
>>  	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
>>  	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
>> -	    !check_tsc_unstable())
>> -		kvm_clock.rating = 299;
>> +	    !check_tsc_unstable()) {
>> +		kvm_clock.rating = 298;
>> +	} else {
>> +		flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
>> +		kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
>> +	}
> 
> I would really, really like to fix this in a centralized location, not by having
> each PV clocksource muck with their clock's rating.  

TSC Clock Rating Adjustment:
* During TSC initialization, downgrade the TSC clock rating to 200 if TSC is not
  constant/reliable, placing it below HPET.
* Ensure the kvm-clock rating is set to 299 by default in the 
  struct clocksource kvm_clock.
* Avoid changing the kvm clock rating based on the availability of reliable
  clock sources. Let the TSC clock source determine and downgrade itself.

The above will make sure that the PV clocksource rating remain
unaffected.

Clock soure selection order when the ratings match:
* Currently, clocks are registered and enqueued based on their rating.
* When clock ratings are tied, use the advertised clock frequency(freq_khz) as a
  secondary key to favor clocks with better frequency.

This approach improves the selection process by considering both rating and
frequency. Something like below:

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index d0538a75f4c6..591451ccc0fa 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -1098,6 +1098,9 @@ static void clocksource_enqueue(struct clocksource *cs)
 		/* Keep track of the place, where to insert */
 		if (tmp->rating < cs->rating)
 			break;
+		if (tmp->rating == cs->rating && tmp->freq_khz < cs->freq_khz)
+			break;
+
 		entry = &tmp->list;
 	}
 	list_add(&cs->list, entry);
@@ -1133,6 +1136,9 @@ void __clocksource_update_freq_scale(struct clocksource *cs, u32 scale, u32 freq
 		 * clocksource with mask >= 40-bit and f >= 4GHz. That maps to
 		 * ~ 0.06ppm granularity for NTP.
 		 */
+
+		cs->freq_khz = freq * scale / 1000;
+
 		sec = cs->mask;
 		do_div(sec, freq);
 		do_div(sec, scale);


> I'm not even sure the existing
> code is entirely correct, as kvmclock_init() runs _before_ tsc_early_init().  Which
> is desirable in the legacy case, as it allows calibrating the TSC using kvmclock,
> 
>   	x86_platform.calibrate_tsc = kvm_get_tsc_khz;
> 
> but on modern setups that's definitely undesirable, as it means the kernel won't
> use CPUID.0x15, which every explicitly tells software the frequency of the TSC.
>
> And I don't think we want to simply point at native_calibrate_tsc(), because that
> thing is not at all correct for a VM, where checking x86_vendor and x86_vfm is at
> best sketchy.  
>
> E.g. I would think it's in AMD's interest for Secure TSC to define
> the TSC frequency using CPUID.0x15, even if AMD CPUs don't (yet) natively support
> CPUID.0x15.

For SecureTSC: GUEST_TSC_FREQ MSR (C001_0134h) provides the TSC frequency.

> In other words, I think we need to overhaul the PV clock vs. TSC logic so that it
> makes sense for modern CPUs+VMs, not just keep hacking away at kvmclock.  I don't
> expect the code would be all that complex in the end, the hardest part is likely
> just figuring out (and agreeing on) what exactly the kernel should be doing.

To summarise this thread with respect to TSC vs KVM clock, there three key questions:

1) When should kvmclock init be done?
2) How should the TSC frequency be discovered?
3) What should be the sched clock source and how should it be selected in a generic way?

○ Legacy CPU/VMs: VMs running on platforms without non-stop/constant TSC 
  + kvm-clock should be registered before tsc-early/tsc
  + Need to calibrate TSC frequency
  + Use kvmclock wallclock
  + Use kvmclock for sched clock selected dynamicaly
    (using clocksource enable()/disable() callback)

○ Modern CPU/VMs: VMs running on platforms supporting constant, non-stop and reliable TSC
  + kvm-clock should be registered before tsc-early/tsc
  + TSC Frequency:
      Intel: TSC frequency using CPUID 0x15H/ 0x16H ?

      For SecureTSC: GUEST_TSC_FREQ MSR (C001_0134h) provides the TSC frequency, other 
      AMD guests need to calibrate the TSC frequency.
  + Use kvmclock wallclock
  + Use TSC for sched clock

After reviewing the code, the current init sequence looks correct for both legacy
and modern VMs/CPUs. Let kvmclock go ahead and register itself as a clocksource, although 
registration of the sched clock can be deferred until the kvm-clock is picked up as the clock 
source. And restore the old sched clock when kvmclock is disabled. Something like the below
patch, lightly tested:

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..7167caa3348d 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -21,6 +21,7 @@
 #include <asm/hypervisor.h>
 #include <asm/x86_init.h>
 #include <asm/kvmclock.h>
+#include <asm/timer.h>
 
 static int kvmclock __initdata = 1;
 static int kvmclock_vsyscall __initdata = 1;
@@ -148,12 +149,41 @@ bool kvm_check_and_clear_guest_paused(void)
 	return ret;
 }
 
+static u64 (*old_pv_sched_clock)(void);
+
+static void enable_kvm_schedclock_work(struct work_struct *work)
+{
+	u8 flags;
+
+	old_pv_sched_clock = static_call_query(pv_sched_clock);
+	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
+	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
+}
+
+static DECLARE_DELAYED_WORK(enable_kvm_sc, enable_kvm_schedclock_work);
+
+static void disable_kvm_schedclock_work(struct work_struct *work)
+{
+	if (old_pv_sched_clock)
+		paravirt_set_sched_clock(old_pv_sched_clock);
+}
+static DECLARE_DELAYED_WORK(disable_kvm_sc, disable_kvm_schedclock_work);
+
 static int kvm_cs_enable(struct clocksource *cs)
 {
+	u8 flags;
+
 	vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK);
+	schedule_delayed_work(&enable_kvm_sc, 0);
+
 	return 0;
 }
 
+static void kvm_cs_disable(struct clocksource *cs)
+{
+	schedule_delayed_work(&disable_kvm_sc, 0);
+}
+
 static struct clocksource kvm_clock = {
 	.name	= "kvm-clock",
 	.read	= kvm_clock_get_cycles,
@@ -162,6 +192,7 @@ static struct clocksource kvm_clock = {
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 	.id     = CSID_X86_KVM_CLK,
 	.enable	= kvm_cs_enable,
+	.disable = kvm_cs_disable,
 };
 
 static void kvm_register_clock(char *txt)
@@ -287,8 +318,6 @@ static int kvmclock_setup_percpu(unsigned int cpu)
 
 void __init kvmclock_init(void)
 {
-	u8 flags;
-
 	if (!kvm_para_available() || !kvmclock)
 		return;
 
@@ -317,9 +346,6 @@ void __init kvmclock_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
 		pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);
 
-	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
-
 	x86_platform.calibrate_tsc = kvm_get_tsc_khz;
 	x86_platform.calibrate_cpu = kvm_get_tsc_khz;
 	x86_platform.get_wallclock = kvm_get_wallclock;

Regards
Nikunj

