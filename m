Return-Path: <kvm+bounces-33452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 483909EBB81
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 22:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5010286A4F
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 21:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DAF230275;
	Tue, 10 Dec 2024 21:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fME8bNw6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FDF22FAFD;
	Tue, 10 Dec 2024 21:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733864822; cv=fail; b=aLQmzRmH7+mxXBSjD9iAUwV2SwEi7DtY2izyLMoaR+/ZZ+3XSScvrD5BdZIxCi2WQadVKspTgqNjHxarR+l3LINxmM6swogKo4W2tF3XfVuMQ3lY+k7445uw6vmvtRDyEblT/910bF9zWUXtxle2aWR+HSeGwXEPMuz5kj9tOPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733864822; c=relaxed/simple;
	bh=Z06F563VxhGhRqdhEsTOQi7PCxccv3Dsph6SFO6YxRE=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=BLI6IEV8YjkUSGoIrClj4W4Jeg3EJlWTI0D1qFnIEpnINceKucnlRQ7c8FcS1ykCbwFgnM9II7qrSCOcVn+YdDggQ3wI//X4kOB3vea0I9M+UNtK9NsTnlmeMFiywzNoXL9aq5ytjaaPSbbr3KVnaLWmrx6qHqqeAn9IkD0DzNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fME8bNw6; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EEHIYWf1dfu50vu0iignvrnvUuXJ7ZgxwMV6npOompD+tdMXGSb6l5KAfbC4EwphzMWWyJ9m3rz+KY5/kW1vxGVUxSaW6QVY/FHWP5AVamiYP6JhKjnh5sKWrGMrGcCp1aLn9yTURCeUA8+ucHC5VuAGFf937e1zpbadvu9GC2+3utxW9LUKeko3qB17VM8BVrRebF7tXeyV+Kn/Y1YW66vnwEBJ82AFLSKhzZJcacI2IDY/ZPb7VOCDwdSccgo/sWHwa8u9fG6FlH2zzZlgWCHTdNaGztGVgNeRf8W96gcuMcM1mBZ75CdFxyvtZ1oCX2bc11rJOGBJGytLWckLCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIJyaBtiVPDWvlEjCrV8pLWx2A3gH1hNgQ2AAfwySlg=;
 b=yTAdazY42t5/z+m9P19dDbaLRADSiGabloXs14580nJMYkW50HB3SDDfrr4+kQUL/oBGjA4Tk1JFVuY+l44iUZ001xXj2Tt7SsG83ACSlEZqGwjcHAY5yRxGXqPKBL2yM8wuzLQV2oKVmBcuhUSHkxZ8lc4XOIzl1VoGAC7NCPCYpe6iPUx8UAjlcY5OKje9Uhi6QXcgjeQNqmMClaANhuz5OhUeFtVLbqetNZ+Zpj6cozEwwGjTIDuOFkP9Os3cOR7lB68l7tEK8kRvZzRSnNVeFkwwZzyWslT9UD01cF5vhmWGA4QSzkn9D5dVHsA7oD1JvxJmGmoqqBwsk7R+bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIJyaBtiVPDWvlEjCrV8pLWx2A3gH1hNgQ2AAfwySlg=;
 b=fME8bNw6sPHI3BtLpvQWHrg+f4yliER6OQlX2rHJd6oIMoozxuVKI+KbspWUlW7Otb+ls4eOvbvRnGxsiDzPVgCvszblcYwalDehG3luEuqh5JGcpdiFSFJm4OKh+cZFawwKsnfBQ8m9rzzo7YfEEygHpc/imFL6Y/HjwADgbE4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB8114.namprd12.prod.outlook.com (2603:10b6:a03:4e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 21:06:58 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 21:06:57 +0000
Message-ID: <9e827d41-a054-5c04-6ecb-b23f2a4b5913@amd.com>
Date: Tue, 10 Dec 2024 15:06:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Simon Pilkington <simonp.git@mailbox.org>,
 Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 regressions@lists.linux.dev
References: <52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org>
 <Z1hiiz40nUqN2e5M@google.com>
 <93a3edef-dde6-4ef6-ae40-39990040a497@mailbox.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [REGRESSION] from 74a0e79df68a8042fb84fd7207e57b70722cf825: VFIO
 PCI passthrough no longer works
In-Reply-To: <93a3edef-dde6-4ef6-ae40-39990040a497@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0017.namprd05.prod.outlook.com
 (2603:10b6:803:40::30) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB8114:EE_
X-MS-Office365-Filtering-Correlation-Id: be69ab0d-3242-4422-b2ae-08dd195e952f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QnJ4TWk2dHhxR1QxZHFMaXd1dEdENklkdDQyYm1jTnFxWVltVlY4M3Vib3lF?=
 =?utf-8?B?MTZHQ0tWaXpwbGx5NG92YkI1WmdkYjM4TFRwWnVXMUZWeXExckhPRG4rMGw5?=
 =?utf-8?B?WjRESTFDVkdrUmpsRDQzdTk2SVJ0eVAzaXgySWd0RW5UYlJOZjVhTU9WNTZ5?=
 =?utf-8?B?MjQxRFFiamFvK1M4N0IvaXpSQUhvamptL0xjUHZNRUt1UkZxbGFMVmlxemtW?=
 =?utf-8?B?Nm9RY09ETEpibjIrWWxZTXlxZVZHOFdqSzJhU3BmUThMZGx4RHFvUDBuUHZt?=
 =?utf-8?B?bHRlYXo3TVczVU90bVhQSGlYYWVaZEZwcHJZa21NUHd6aDdKMHkwVDA1NG56?=
 =?utf-8?B?WUcxbVozRXlEamhXbkhOUi9hM1U2cmNRZjNjaE5DVnVWengycW0rS3l2Wm4w?=
 =?utf-8?B?bldFYUNaR1RQVEpuaXVYcEpQZFFZMis3Zm9nMkpVN0c4S2VKL0lLZTdJSU5p?=
 =?utf-8?B?dHdLVmJkcmdhSVJhci91eXRTR05uZ29IaXhWeDhaRWNqSVVJWTk2L1BOUzNN?=
 =?utf-8?B?cGRqNDZGWVZkUC9mclJpNzZvRnJpRFBUUDRBUlJzNThZUzNUby9FK2o1Tk4z?=
 =?utf-8?B?RE44SS9nTEx0OG1BbVdrNlhZK3dqRDB5RURtSDdWdnpnY3A1R2U0eWN6cDhz?=
 =?utf-8?B?RFV6dW5vVTlHZ21PN0FoVWVNODRiRVNLaHVrbEk4RE5RWFk5UTV0U1diSk1U?=
 =?utf-8?B?RDNKY1NhZ2I5Q0MxUUsvUVhmaW5aa1VHZG1uWElKKzI1VlBKcFhyaS9URXk2?=
 =?utf-8?B?cGg2ZTZjWHA3em9zZWxrYmFMYTk2eWNQdjJ6Z3ljVmdHcGRPZFJFWVF6STA0?=
 =?utf-8?B?NmpxbkVtUFlpZEtxSW5kOFp6TFJON2FBUkduLzU3MWplc2FyTlo0UXJTRWlI?=
 =?utf-8?B?OFFIcXQxK0VZOXl2RjA4QS9UNFJrUm9XcG8zbG5hb2VBaVFrK2Q4c0xnbDJo?=
 =?utf-8?B?RjRKSE4vZU9EekZOeldvTGxqeTA0MXBWV0Vwa2FTTUNOL1FtQStIa0pLRzE5?=
 =?utf-8?B?dkNJK2U5czRDRlhzZmprWmNQZUFESjRBalYzcW9zRTFxWWxXQUI5eWZaK3pm?=
 =?utf-8?B?a2t5NTZ6azdjbSs1NDZPR21JV0ErZXpuWEF1blVFNWF6V1QrekJ2YWNqTzM0?=
 =?utf-8?B?ZGlSa2grcHJjcm0zWWN6eUlzaFdWWjRBTC9oTHhlSGswWU45TUhrMEg2Z2ZC?=
 =?utf-8?B?ZUxTMmJGL3R3NnlRUUxoVzB3NHJXWldXMHFiVk5kVjVFODlQclZIYjVFUzc3?=
 =?utf-8?B?dlplZXdlRSt2QnkyOU55UVdwcDdTUWljSmhUMldGOHBBMHBOZG13bzdWYlls?=
 =?utf-8?B?WFRVbXZ0Tk5rbGNSaldVRFA5a2c0Vk5FZFgyUGpEVDJGUm1XOFlyVUdLMk9Z?=
 =?utf-8?B?ZE5rQ00wOG5yMTc0aW9RTUk5Sm5FMXpDaHpEQTJtM1VNekhnOTZuSjBrUDBp?=
 =?utf-8?B?d0thcGpYVEJZM2cvQVFZVEk4d2ZHMmlCK0luWHVhN085NWxwc3RURDRzT096?=
 =?utf-8?B?N1l3QmZIZkw1cHhqRWhncHdMUG1FaHp5cmM2elhBYnRrdkZEWUk0YnJMRE1Q?=
 =?utf-8?B?UHF3Sk5ncEN3bGE2R0xMbWlQSk1pa1RxS2VrNHFZWnVUVS91ZWJXeGlXTXow?=
 =?utf-8?B?bW95Y3M0S2NVaTZIMCt4aVJieDRJQVg0Um4vK3FJK0djVEliQXhtN1l4NkVU?=
 =?utf-8?B?TEZSZExrMitaK3lEcElja0EvQ0pLYkRxKzllcDhIQnRPR0o5Wm1lckE1emEz?=
 =?utf-8?B?bFI3YXBJUCtUR1JEcjNZQVZjVW1hMWl3aWx6VDNVK3QzK1VpcDJQeWVYclZl?=
 =?utf-8?B?VzVpcm1iaFRZajVHZW81UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eHVRMFFNQ1pkeUF4elgxRFRCVWlJa1BKajltenNlcFRtaEdkYldKa0xGR1Bn?=
 =?utf-8?B?c3Y4azV4bm13emNyYXUvZGdwMVFpaTMxMTQ1M0pEZUxGMkxEWHpBN3RPeHFo?=
 =?utf-8?B?REQ2d2hCZzVLZElaUDdQbjU4cVhYbkFLNUVpZFpXTTVSem1sSHhXeGx6cDUv?=
 =?utf-8?B?NWZzd0lqNkJzRktkeTVHckxuOWxJZTBBeU5QTWlteFI5dmVLcnVNdENiYk9a?=
 =?utf-8?B?cGpNT0dkSG5WTlppNVliSnRrc2N4QzhMZGxRbEJhOFhON3MwbDZSYWxydzZD?=
 =?utf-8?B?Z0VnSnRZb2NxTzR5SFBCUVNoV1ZGYVNpRVpscy9nd3ltSm5jbXloRDhqTm5t?=
 =?utf-8?B?VEQ0Rk1FSytkQ2VGVEd1NTJDbG1Id1l6T2loMi9sMmpNYmluVGpRWU5uTVBR?=
 =?utf-8?B?ZjhBNklqQnlTNzl0dWkvM0tMN1BpZnVRc0k1ZkJQeGxLcHUvTEhvMzhDQ00v?=
 =?utf-8?B?UW1mUEFyOHFoVHVOdXVrL2JmRmEyOFFHa2cvaUpvVE1hQmlQSTFOSEhaV1Bo?=
 =?utf-8?B?RWRHWTZrYlA2eWtiQmFGRjdSUWo1V1UvT1Z1cDUvaUpYd0VhQmZVbGlvc1hn?=
 =?utf-8?B?UUs4NGhrUkx2MnB2MjJ6WEpqSWM3a2lpUDE4WTNha09uQi9OVVhlYWpPN2lT?=
 =?utf-8?B?eTlTb25zd2tGUmNKaXJJNitCeEJibkhab3NPTmVBdWt6b0VuSWNhUXcvT0Jk?=
 =?utf-8?B?Y1FJNjdaeUJvWnVWU2pYbnNCeENjSWhsdTVoQm9BbHg2Q0FsSE5WemNsYU9v?=
 =?utf-8?B?OGg1MVRVSm9SeEM5SVE4VmVjS0JlMmxaalZ2UzNtSm9sTWlqdWxiSDlGV0hm?=
 =?utf-8?B?WlBTUDJYcUFiNUh6Tmp4b1FtbTBlVUdoVWpJQmZqV2xPRWNoaWkvN1AyRFhr?=
 =?utf-8?B?WVVQNFp5aGVneW1pT3hmY1ZCZk1xdHpoOFh1bVhBa3V6ZDMzbS9lSFU5QllJ?=
 =?utf-8?B?ZVBreUFuTi8waThYaXp3Sk5razY1UUxMVmV2bEpRWUx3QnVqNGdxbEVPbUZr?=
 =?utf-8?B?d3NKdmFzUnU3anprbEx3U3M3L2s1OG9JaWQ4UG5udzl0ckpDWVgzRytMaWVN?=
 =?utf-8?B?SXlzTEViK0toYmYrYWFPY0hTNE1MNiszTk5lOVdkOXJndlNLY2FiTTZ6Umxi?=
 =?utf-8?B?SllMdXNlUmF2R216bnhiWDZKUXA0NEdyYi8vZFFJcHVhRWVzaEM4ZFNWTkF4?=
 =?utf-8?B?dXUxRUFsZmdhOEpXYkpINk9PMjI4eEZHUHNFaEZudkNiUGlyaEEyOHh1UFVD?=
 =?utf-8?B?RGlFNzdXVmpIUTREV1JiSTdVeC9qRmd5cUpqeHFmczZteEFqMWNhdEErV3By?=
 =?utf-8?B?S2xrZFVoMVVKb3VqY0lFQW8wR2EzWEU4VGJaMFlCNHJlVVYyS2ZCcGVaWlRt?=
 =?utf-8?B?RW9XTmp6aUYzVi8rdGFqUjJJT0tiUktVdjNVTFlNb0dWNURhVUVuYVdLb3FU?=
 =?utf-8?B?cndLc0VOUHNlaEZJNkpFQWF1ZnRCS2RINHJPWkV5d2FNdTRtT1J5cWJqOTNH?=
 =?utf-8?B?STNMWC9MTDlRL1ZMV2xESmdxUTk0eVpIS2kvd0ZNaVRaNXlIV2taanUycTRr?=
 =?utf-8?B?Yzd3blRpUC9TYVduTEdTeHQ1S1NVVGdxeDFGRWxVL24xK1FDTW1Yd0I0b0I2?=
 =?utf-8?B?MVpmcTdZdzRldWJXK1ovM3BsZzRTR3I0V1djdGdmdDltcERBbkJTNGpHRjl6?=
 =?utf-8?B?cGIybWpFRHlrR0FUOVBwNnl0SVl4SjZkTndNQUhMNndRV2ZveWpReGlPTkxM?=
 =?utf-8?B?M1hsbWhtV3BoUFE5SVROWC92bnBNaGtxSUNLSUJzS3JHaXhuUGhnK0lQZTVo?=
 =?utf-8?B?NUV1RzJyYkhOak1qZXIrNmFoMUdHUFg4SW9nMGJVQUxkN2hHNkxISDlVakR0?=
 =?utf-8?B?KzEzcjN0SXd6MTRlSGRNMjBZTzFjUFpXdGtMdWdGdVlkaWJJUTU3SU16b1RY?=
 =?utf-8?B?aXJxamZzbFJ0UCtEYUxBakV2U1ErZHhobVVCR3R1T3V1VGxCMzdWTDc4cG5K?=
 =?utf-8?B?TFM0VFoxSHduYWJMamF6TlRROGZOWUR1NEhldmRXYmNrVDhJQjhZa3ZFZ2dJ?=
 =?utf-8?B?TzFBYXVTSVhLY3QvZkVrR2srM0ttMEplNlJ1UnoyT25mOGpZRldPMHlSQ0lI?=
 =?utf-8?Q?qcpcseQ3W8IbW7N0FQULkjvFs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be69ab0d-3242-4422-b2ae-08dd195e952f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 21:06:57.8785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CoBFksvFhZEeje+Pj7PjUK2bEf/GmbMBdPwaRCacPmzgYnjdk9GV/5y8UGFYi25CQAqlQa0cUPEebl3LbEuspA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8114

On 12/10/24 14:33, Simon Pilkington wrote:
> On 10/12/2024 16:47, Sean Christopherson wrote:
>> Can you run with the below to see what bits the guest is trying to set (or clear)?
>> We could get the same info via tracepoints, but this will likely be faster/easier.
>>
>> ---
>>  arch/x86/kvm/svm/svm.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index dd15cc635655..5144d0283c9d 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3195,11 +3195,14 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>  	case MSR_AMD64_DE_CFG: {
>>  		u64 supported_de_cfg;
>>  
>> -		if (svm_get_feature_msr(ecx, &supported_de_cfg))
>> +		if (WARN_ON_ONCE(svm_get_feature_msr(ecx, &supported_de_cfg)))
>>  			return 1;
>>  
>> -		if (data & ~supported_de_cfg)
>> +		if (data & ~supported_de_cfg) {
>> +			pr_warn("DE_CFG supported = %llx, WRMSR = %llx\n",
>> +				supported_de_cfg, data);
>>  			return 1;
>> +		}
>>  
>>  		/*
>>  		 * Don't let the guest change the host-programmed value.  The
>> @@ -3207,8 +3210,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>  		 * are completely unknown to KVM, and the one bit known to KVM
>>  		 * is simply a reflection of hardware capabilities.
>>  		 */
>> -		if (!msr->host_initiated && data != svm->msr_decfg)
>> +		if (!msr->host_initiated && data != svm->msr_decfg) {
>> +			pr_warn("DE_CFG current = %llx, WRMSR = %llx\n",
>> +				svm->msr_decfg, data);
>>  			return 1;
>> +		}
>>  
>>  		svm->msr_decfg = data;
>>  		break;
>>
>> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
> 
> Relevant dmesg output with some context below. VM locked up as expected.
> 
> [   85.834971] vfio-pci 0000:0c:00.0: resetting
> [   85.937573] vfio-pci 0000:0c:00.0: reset done
> [   86.494210] vfio-pci 0000:0c:00.0: resetting
> [   86.494264] vfio-pci 0000:0c:00.1: resetting
> [   86.761442] vfio-pci 0000:0c:00.0: reset done
> [   86.761480] vfio-pci 0000:0c:00.1: reset done
> [   86.762392] vfio-pci 0000:0c:00.0: resetting
> [   86.865462] vfio-pci 0000:0c:00.0: reset done
> [   86.977360] virbr0: port 1(vnet1) entered learning state
> [   88.993052] virbr0: port 1(vnet1) entered forwarding state
> [   88.993057] virbr0: topology change detected, propagating
> [  103.459114] kvm_amd: DE_CFG current = 0, WRMSR = 2
> [  161.442032] virbr0: port 1(vnet1) entered disabled state // VM shut down

That is the MSR_AMD64_DE_CFG_LFENCE_SERIALIZE bit. Yeah, that actually
does change the behavior of LFENCE and isn't just a reflection of the
hardware.

Linux does set that bit on boot, too (if LFENCE always serializing isn't
advertised 8000_0021_EAX[2]), so I'm kind of surprised it didn't pop up
there.

I imagine that the above CPUID bit isn't set, so an attempt is made to
set the MSR bit.

Thanks,
Tom

