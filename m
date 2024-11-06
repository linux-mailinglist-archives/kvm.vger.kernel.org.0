Return-Path: <kvm+bounces-30899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 825269BE354
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:58:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 139111F23320
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DAA91DD0E2;
	Wed,  6 Nov 2024 09:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M3exVCHr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63391DC07B
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887115; cv=fail; b=NGQTMrsVgpKWScpCXF+o70Dc+aw1qYaTsQJM+xsVygSfVDSyYnLr03ITtwiEhfGoK2lIdI42CJ5lsJf+rzD3Q+WiQbNYufg47rA4u6UrMQR6oW08qkmWe1Qpcvsv0R4ei6o8lx3DKjpVUaH9Y1+jZpLgM3aFfW/hAEbW4kWLNPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887115; c=relaxed/simple;
	bh=OHVayrwGByYoqq2yuFydInGZJhgp3XrTUFr7i33dERE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D5O8sDAidVPEDXlAlzwDl3IyaJOgnstlGFq9l5PB9GAp7vfgi16aIBMPp488ziBWx+IG6fPLyWFRPIAnvbCO37y5Ii2flGlChDs0CN7cAH+TnIDfUfOPKtqygW0NtYe90UF9xJ7d9z49JSGXVenqDSdzoCAr4xeZs2zhn9tVRXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M3exVCHr; arc=fail smtp.client-ip=40.107.223.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iCs1GOEwd8oWECEo8EtVl1PMqGfX6BgP/Zjb5i8EH81s0CfeHXwM9NiV01Rxj842/7JWMBg4vSSaMaXlyXhUrfGciYPkSLIlfbJBOVKKw25niuXCraJBfG9kuV8C3tbKnjoN7yq8D/L1QwV10N+yRQuFocR/J3pH0TAFdOPyt2uosauWY6H1RtYXzsV3WdY4+Oc9Odu0QrK8cUAEUnucB8UKMi8wZe47KS3TNpUBQAv5SwBhGUTSkqWEvhxArM7K/z/2WunO/mN1aED7vrEC4dJeoDEdX2tkyHol/dZJ6vI2ZiOyfVC3pWjDI9rZpkQqg7HwJI8bEw7LvY4EWf9BGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hu008fubdZvJjYb5lXWtnLYtN7NPEzlBukRboRP1YjA=;
 b=Y/rgMMVeAWi14ILwgvQjTbEaEzuCrMd4YdJS3vkadRnPczZHiXSdGQrBpH1E9fvCO6HTLn+vKNN7VK/BJh2bwlI2Z3LiTwWyyGSpBHQIHxXzh+bBVJYuQlP39Q6D1FUhNP5nhA7w/XITzNTGvn/fysiCo3huOTJshL4j5qyxnfTNM3ANVjvIi6W55K9RUUECxxrnV+yyCZc95N8ij2By2GSP0b5bAppjdjDaXgcATITZvr+K70++RqO0BuXp1GD8/GON22bTtk1jxQoOBhOTtlZ6qSY9ZNtqS1FjOatK8yGlHJeVUWPWvyOunlhmA5cEJKelK0k+3NjnZRMunhfzKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hu008fubdZvJjYb5lXWtnLYtN7NPEzlBukRboRP1YjA=;
 b=M3exVCHrzt5PYgbTRJbCmRW+P0p3qRDgC7lkhwtZkB5m5VFM0y1YNTIX0NwhKBMBD8kUZtVNG7Go9v5yp4d1s+ozzZg7MwA8+q9t7yNifsFQlG1zZLKgyiQuW4WaOv9lbBwUBLkbp9sEXBx/qfaFMx1hyC3R7cX8K39qof8UKME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by IA0PR12MB8373.namprd12.prod.outlook.com (2603:10b6:208:40d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 09:58:31 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%5]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 09:58:30 +0000
Message-ID: <50c2e774-999a-4103-94a8-55243c695dfd@amd.com>
Date: Wed, 6 Nov 2024 15:28:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] target/i386/kvm: reset AMD PMU registers during VM
 reset
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
 mtosatti@redhat.com, babu.moger@amd.com, zhao1.liu@intel.com,
 likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
 groug@kaod.org, lyan@digitalocean.com, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
 davydov-max@yandex-team.ru
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-6-dongli.zhang@oracle.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20241104094119.4131-6-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|IA0PR12MB8373:EE_
X-MS-Office365-Filtering-Correlation-Id: 3298064f-d79a-48b3-e3cf-08dcfe499157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L28zQ0NSOEdiQ29rQWtXeXdqSGQrZjVEWm54dFI4OWI4eXAwNnVLSUtEUFRs?=
 =?utf-8?B?SERLT1UwaEsrVnZ3ck9leGRTYXlaUHFreTUrVXFuaVI3YXVRTWhOV2hMUHJ3?=
 =?utf-8?B?aWRoR3Q2K1NmK29yUUFpUXZCL0JYWEI5YWsrcFV1U09WMkZ3WVYvZ00rNGRh?=
 =?utf-8?B?Ry9tZGJGVC95Y2tQZVV5YW9ydWlobEF1SkJyMXZzRFJNMjZDaFY3bjgwMnBG?=
 =?utf-8?B?Mm16b0VnNERUZ0p0ZC9JVUs5RUlick9PRXF5cDBzTnNHV1lKQXBkWmpEbjBH?=
 =?utf-8?B?MzhQNkszZjZqZTZPYXNsdU56K05xL05SbkdiUG1scEhmb0VRL1FXL0VBMDdX?=
 =?utf-8?B?ZmFzK3R1aEZ6aTBIZkYzVXNWZlBmK2tncWxsQ01EeWl6ZmcrNlh3Kzk0ODdR?=
 =?utf-8?B?bjNJWUxiNitrYlZMb3ExQjJ2eVFaZzU2dkZKazdjbGpDSWdrVGhyblFGUGRZ?=
 =?utf-8?B?Zm8vUXNaUVJQakk5djg5RG9uWWR0QXhUOTBrSmVoYXdWVXM1OTlHbXFtVjV0?=
 =?utf-8?B?RlZnMFM0SjY1dWZwQVY1RzM4eEkrN2QvTTEybkxlaGFtSGtqdVFPUkN6SjZP?=
 =?utf-8?B?cDFrTW43aHJQcTh1dFBjc1MzUWdKeks5eHBNNlVFN3ZTYnpVZVFuUml2QnNS?=
 =?utf-8?B?Y0RoZzJLQzJCZUh6b0tvMHJqTUQ2T1lJZGMzaFkzdmZYTVpYVUl6OURDVTZQ?=
 =?utf-8?B?bW03RTcvLzJqdVVHR21wSEZYTGVqaGpGMTYyMytiR3JMVStRTzYyclZyY2xm?=
 =?utf-8?B?dHRXU2czMzRJK3R3eE0wYi9Xa0VLb2dsblh2QnE5Si9Hd0xCZTlTUVlnYjln?=
 =?utf-8?B?VW9weUFxcUtzOGdyNnNUOGpTWWxnYTVFUkdtaW9yQkJzcjRFL1J1SkNXQnhj?=
 =?utf-8?B?eHdCamF2V28vdyswN1JBZ0JveWNrWk1UcTVFYm1SbEdCYTYrRytMUFZ6bWxS?=
 =?utf-8?B?MUFLWlFHSDd1QzVHMFYyVmpVNDMrN2RrVnI2ZWFhUHUyTkhERE5nV2daeDFB?=
 =?utf-8?B?dEZVY2xjMXBZMzE4YVZ3Y0JYY2lIZUlwb1hGdWpmRnFRYlQ3WXBLSlc5Sldp?=
 =?utf-8?B?eHJrWU9RWWFrczJ4SE1FblV4WndoMWxjZ1lQa091Z2RDYlhPWGRjeXJ6aWVP?=
 =?utf-8?B?dUswcHZpZEZ3dFVQeTdkSDcwS0VlcmFWSHQ1K0c2MWtNRys0WGlVZ05WdGN0?=
 =?utf-8?B?SmV3VXNoSUVvNVFSdWVkbWdIUG83TzNEWG80U3pNZ1Y4SmpYWk1RWVVXNnk4?=
 =?utf-8?B?Q2RWTTBOMVZKYmVmaW5lUTFzRFZqVUZjT1J3UG9GZ3FGVXZLNVd5ZHpNbFM5?=
 =?utf-8?B?d25sa2hmQTdvaGlZM3FFSzhXQ0dqTGVpQUVxVGxCNTVNSld2WDgxM2FBVHFi?=
 =?utf-8?B?dUlhdWIvNm50QzdhcEp5aFNCYzJnNjVRdTlnSXVEOFZNT0VDUCtBL0VqUjNv?=
 =?utf-8?B?UG8vL3lYWHp0TVRZRGNaK3lCREg1cnNlYUNYTjkrK0F5Skt1WlQ1NXdRSjhu?=
 =?utf-8?B?R3lueUlHTEoxcjNBZ0Q5SiswTDdIQURGdHVyc29JMUJKeUlLTml5YVR6bUN4?=
 =?utf-8?B?UUFkOUVUcDByZ0U3YWxTZXJvZGE2aUwvOGlsRnllOC95WFJXVGNRWndDRUhh?=
 =?utf-8?B?MHhEWVBKYmdlQ3FaY2s4aUFQck5qcXpMV0F4K1JoVzQ3UmNZdnA3OW9Oam9p?=
 =?utf-8?B?WGVLem9QRlE2OWdkL0Z1R0RXZFY0K05NdGhOd25FNC9HWnVDVjc1N202SWpo?=
 =?utf-8?Q?saiuHGGX1iot6XMs4A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1JlOTd0RllqUmUrRlFpNVY5ZTdtYzFDd0ZNbjdUUHhZWVZwTXl0alErVnJQ?=
 =?utf-8?B?NWJMVmFiWnAwVk5JdHJBQlMxaGxMVjk1UnBUUy9vT09QazdKMHhpM1I3ZUR4?=
 =?utf-8?B?UXRlZHlCekNMZFp5ZmgyNDBZaVlvc2hKc29ubElUdkVuNUZLcUZUSVlGTkhU?=
 =?utf-8?B?V0hkYi9ndUwyeWJvU25lMWU2R1NKZUw3N2IxV20yMW15NkxpMmc5UlFmdk1N?=
 =?utf-8?B?NVB1eXByTmlKLzNubndBZUZIQ1VGeHNHYWozNHVmOEg0ck50NisxeWFzWmtW?=
 =?utf-8?B?YmFtaE1CS1YxRGtKMEcwWUN1ajUyZXdISEZDemhkalRFNm9NbnRWV3d0ZlFw?=
 =?utf-8?B?S1dOUlRuNXJDcW9jK0JNelhERUY3TCswdGMzbE5HRTM5S2kwNXhWVVdjKzBW?=
 =?utf-8?B?aHQxS2hJZjFvRU5GSXRmSlVJY3dhNXhMNGZOYlN3aHo3RlhVRXQxOERWOGhC?=
 =?utf-8?B?MGk0bjhtaDNwdS9aVkZSdEkvRE1JOUVkaGx3M3I0THBhZXdZd1NQZmd6bDNN?=
 =?utf-8?B?TTRkT0o0Ym8xSGEzZGMxb1ZyYnlxMVhHazhiYlBScVFpb1pkY2xkcEVVcFdE?=
 =?utf-8?B?blovZmpPMHFacXVqc1cyREJ4bWgybi8xSmFEaXc1SDNBTmljanhvT1VPQlBW?=
 =?utf-8?B?cFNrOUlnUFVFdnJaTFZ0SEhJMzYxNktNeFBGckg3UUIyeXhCbU9KOFcrSnVz?=
 =?utf-8?B?RXdMRlJxQ0ZNNG5jcWpHOGtMbG9UZkVaczdyY1RVbk4wVHVBM2l6citvUTZI?=
 =?utf-8?B?SFNZOEVvTVg3bGNQZFdIdUs5YmovMWFuTWYzeFRPVUsrTXRGMXlzUWhnY1pm?=
 =?utf-8?B?Z0V1NG5HSnRrUDYwV0ZsSWhxcjJpREVMNWlnRldndUFZc3NJT1JhWFNIK0s5?=
 =?utf-8?B?NmdwN3dTd1B1bU93dGhyMTA5N0lBdzB0d3FpOGlUU05Sc2t1eXBLR0lLSmpZ?=
 =?utf-8?B?ZWxneFZoWWtURkpjVmJRVlIzdUhzUmZCMTdZZnNVcHdQVWdoTW5RQWh5SlVq?=
 =?utf-8?B?N1lCWlhuYm1Hck45MUpHaXdnU0RmR3pobVJZS2ZSb2Qyelk0cXZ0OUxPQVJV?=
 =?utf-8?B?Q1VSRHJRVjFMSXEvdGxPSGMydnBKUGtrMWUxMUJEemhFcE5JUnJDMlVyV24w?=
 =?utf-8?B?KzQ2K29DdmVaSEIvTmZkWWJKc0YvRUxpY1UwV0JaTFVPcUVVQU4xWlB2Vzhs?=
 =?utf-8?B?UHpNU3F0bGx4M1d5QkNIYnpXSHVFRFc3N0pKSEVKRUFGVlI4am41UmtyWEEw?=
 =?utf-8?B?dE84V2xrRlZMUlB3R2JlQkppeFpjdFdNck5aSzdDY2I3MW53NDR1YjhvblZN?=
 =?utf-8?B?ckFoZTZ3NXpOR1F6TTJLdFNUM3pRK2MvOGdudGhTN3lBdzduVENEVmVUb0or?=
 =?utf-8?B?d0xnaWRPSU15WkFHLzkvZ3U2dThKUG11UkpNQmpQdkc2a3l1b0pqcHd1ZGJ5?=
 =?utf-8?B?TmJtdldMN1lwSU1tYTllQmd1aVhRTksxc2hWTjZYcFprNndmUG1CNURab3Va?=
 =?utf-8?B?Z2o1a3ZnQUpZOTdJL3hscHpLZFBTSUVFNlpTRVhxeWFUZEl6cmZDUTA3dDN5?=
 =?utf-8?B?Slg3c1NOMk1jN0ZQK00zOWpKd3ROZGpVUjR0NFN0eWVzdGJvQmJ5b09JTCtN?=
 =?utf-8?B?ME5TRHNPUGRoZG41dS9UaVo2Y1NMTzZTYmZJS0ZSMDkyNWdDTXhwUzFqbUNT?=
 =?utf-8?B?SXVkVVdGbWY4OUs5UW9FbUJTRmVvbndQL3hVS3RiNmhPeWVLZTFQclhJcjFl?=
 =?utf-8?B?aE83SnVsTVZoQnAzZmJhL2ZhWUJHdkN0Vm10VC84aWJrZjBPM2RLUHNpOExI?=
 =?utf-8?B?UlFLbkF4dEIvTUxZMURqL1l4OGpqemRLOGppZFQ2enVrMkZiVlZVL09tUXZy?=
 =?utf-8?B?WmEvY3NMSnpUZU1MTVFFNHhOOHNPUFhwQWpOb1dic05NaUJ1ZnRrMEF4QW1y?=
 =?utf-8?B?dXp4aWxuVCtYVm5OcjR6R0RSK042VzE2QW04ZG50NTM4VWlBbTBucU1lemZt?=
 =?utf-8?B?RHVOTFNZMlhiQ1dIb1lrUDZld0Jja3hRU0FPcjBwODlDVlV1V3pGYWJVc0tS?=
 =?utf-8?B?bUpHY240QmdNdDA5T3JLRFVFY2JiRjhHby9ITzFheUg3cnRZWFROdjZ1QnNk?=
 =?utf-8?Q?u2XbsALdK2OBp4LZsiUdjCseu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3298064f-d79a-48b3-e3cf-08dcfe499157
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 09:58:30.7669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwlAjs4kihFD2F9ziFKNjKTrNj4AFQegMlJzU6j58KDw/cytWA3rhnsghKuEtlkaF1NiIevOy/lhMeZ8Imjdew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8373

On 11/4/2024 3:10 PM, Dongli Zhang wrote:
> QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
> and kvm_put_msrs() to restore them to KVM. However, there is no support for
> AMD PMU registers. Currently, has_pmu_version and num_pmu_gp_counters are
> initialized based on cpuid(0xa), which does not apply to AMD processors.
> For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
> is determined based on the CPU version.
> 
> To address this issue, we need to add support for AMD PMU registers.
> Without this support, the following problems can arise:
> 
> 1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
> running "perf top", the PMU registers are not disabled properly.
> 
> 2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
> does not handle AMD PMU registers, causing some PMU events to remain
> enabled in KVM.
> 
> 3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
> preventing the reclamation of these events. Consequently, the
> kvm_pmc->perf_event remains active.
> 
> 4. After a reboot, the VM kernel may report the following error:
> 
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
> 
> 5. In the worst case, the active kvm_pmc->perf_event may inject unknown
> NMIs randomly into the VM kernel:
> 
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
> 
> To resolve these issues, we propose resetting AMD PMU registers during the
> VM reset process.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  target/i386/cpu.h     |   8 +++
>  target/i386/kvm/kvm.c | 156 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 161 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 59959b8b7a..0505eb3b08 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -488,6 +488,14 @@ typedef enum X86Seg {
>  #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
>  #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
>  
> +#define MSR_K7_EVNTSEL0                 0xc0010000
> +#define MSR_K7_PERFCTR0                 0xc0010004
> +#define MSR_F15H_PERF_CTL0              0xc0010200
> +#define MSR_F15H_PERF_CTR0              0xc0010201
> +
> +#define AMD64_NUM_COUNTERS              4
> +#define AMD64_NUM_COUNTERS_CORE         6
> +
>  #define MSR_MC0_CTL                     0x400
>  #define MSR_MC0_STATUS                  0x401
>  #define MSR_MC0_ADDR                    0x402
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index ca2b644e2c..83ec85a9b9 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2035,7 +2035,7 @@ full:
>      abort();
>  }
>  
> -static void kvm_init_pmu_info(CPUX86State *env)
> +static void kvm_init_pmu_info_intel(CPUX86State *env)
>  {
>      uint32_t eax, edx;
>      uint32_t unused;
> @@ -2072,6 +2072,80 @@ static void kvm_init_pmu_info(CPUX86State *env)
>      }
>  }
>  
> +static void kvm_init_pmu_info_amd(CPUX86State *env)
> +{
> +    int64_t family;
> +
> +    has_pmu_version = 0;
> +
> +    /*
> +     * To determine the CPU family, the following code is derived from
> +     * x86_cpuid_version_get_family().
> +     */
> +    family = (env->cpuid_version >> 8) & 0xf;
> +    if (family == 0xf) {
> +        family += (env->cpuid_version >> 20) & 0xff;
> +    }
> +
> +    /*
> +     * Performance-monitoring supported from K7 and later.
> +     */
> +    if (family < 6) {
> +        return;
> +    }
> +
> +    has_pmu_version = 1;
> +
> +    if (!(env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE)) {
> +        num_pmu_gp_counters = AMD64_NUM_COUNTERS;
> +        return;
> +    }
> +
> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +}
> +
> +static bool is_same_vendor(CPUX86State *env)
> +{
> +    static uint32_t host_cpuid_vendor1;
> +    static uint32_t host_cpuid_vendor2;
> +    static uint32_t host_cpuid_vendor3;
> +
> +    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1, &host_cpuid_vendor3,
> +               &host_cpuid_vendor2);
> +
> +    return env->cpuid_vendor1 == host_cpuid_vendor1 &&
> +           env->cpuid_vendor2 == host_cpuid_vendor2 &&
> +           env->cpuid_vendor3 == host_cpuid_vendor3;
> +}
> +
> +static void kvm_init_pmu_info(CPUX86State *env)
> +{
> +    /*
> +     * It is not supported to virtualize AMD PMU registers on Intel
> +     * processors, nor to virtualize Intel PMU registers on AMD processors.
> +     */
> +    if (!is_same_vendor(env)) {
> +        return;
> +    }
> +
> +    /*
> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
> +     * disable the AMD pmu virtualization.
> +     *
> +     * If KVM_CAP_PMU_CAPABILITY is supported, kvm_state->pmu_cap_disabled
> +     * indicates the KVM has already disabled the pmu virtualization.
> +     */
> +    if (kvm_state->pmu_cap_disabled) {
> +        return;
> +    }
> +
> +    if (IS_INTEL_CPU(env)) {
> +        kvm_init_pmu_info_intel(env);
> +    } else if (IS_AMD_CPU(env)) {
> +        kvm_init_pmu_info_amd(env);
> +    }
> +}
> +
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -4027,7 +4101,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>              kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>          }
>  
> -        if (has_pmu_version > 0) {
> +        if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>              if (has_pmu_version > 1) {
>                  /* Stop the counter.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> @@ -4058,6 +4132,38 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                                    env->msr_global_ctrl);
>              }
>          }
> +
> +        if (IS_AMD_CPU(env) && has_pmu_version > 0) {
> +            uint32_t sel_base = MSR_K7_EVNTSEL0;
> +            uint32_t ctr_base = MSR_K7_PERFCTR0;
> +            /*
> +             * The address of the next selector or counter register is
> +             * obtained by incrementing the address of the current selector
> +             * or counter register by one.
> +             */
> +            uint32_t step = 1;
> +
> +            /*
> +             * When PERFCORE is enabled, AMD PMU uses a separate set of
> +             * addresses for the selector and counter registers.
> +             * Additionally, the address of the next selector or counter
> +             * register is determined by incrementing the address of the
> +             * current register by two.
> +             */
> +            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +                sel_base = MSR_F15H_PERF_CTL0;
> +                ctr_base = MSR_F15H_PERF_CTR0;
> +                step = 2;
> +            }
> +
> +            for (i = 0; i < num_pmu_gp_counters; i++) {
> +                kvm_msr_entry_add(cpu, ctr_base + i * step,
> +                                  env->msr_gp_counters[i]);
> +                kvm_msr_entry_add(cpu, sel_base + i * step,
> +                                  env->msr_gp_evtsel[i]);
> +            }
> +        }
> +
>          /*
>           * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
>           * only sync them to KVM on the first cpu
> @@ -4503,7 +4609,8 @@ static int kvm_get_msrs(X86CPU *cpu)
>      if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
>          kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>      }
> -    if (has_pmu_version > 0) {
> +
> +    if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>          if (has_pmu_version > 1) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> @@ -4519,6 +4626,35 @@ static int kvm_get_msrs(X86CPU *cpu)
>          }
>      }
>  
> +    if (IS_AMD_CPU(env) && has_pmu_version > 0) {
> +        uint32_t sel_base = MSR_K7_EVNTSEL0;
> +        uint32_t ctr_base = MSR_K7_PERFCTR0;
> +        /*
> +         * The address of the next selector or counter register is
> +         * obtained by incrementing the address of the current selector
> +         * or counter register by one.
> +         */
> +        uint32_t step = 1;
> +
> +        /*
> +         * When PERFCORE is enabled, AMD PMU uses a separate set of
> +         * addresses for the selector and counter registers.
> +         * Additionally, the address of the next selector or counter
> +         * register is determined by incrementing the address of the
> +         * current register by two.
> +         */
> +        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +            sel_base = MSR_F15H_PERF_CTL0;
> +            ctr_base = MSR_F15H_PERF_CTR0;
> +            step = 2;
> +        }
> +
> +        for (i = 0; i < num_pmu_gp_counters; i++) {
> +            kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
> +            kvm_msr_entry_add(cpu, sel_base + i * step, 0);
> +        }
> +    }
> +
>      if (env->mcg_cap) {
>          kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>          kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
> @@ -4830,6 +4966,20 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>              env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>              break;
> +        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + 3:

The upper bound is very unlikely to change but rewriting MSR_K7_EVNTSEL0 + 3 as
MSR_K7_EVNTSEL0 + AMD64_NUM_COUNTERS - 1 may be more readable. Same applies to
MSR_K7_PERFCTR below.

> +            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
> +            break;
> +        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + 3:
> +            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
> +            break;
> +        case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTL0 + 0xb:

Same as above except this one needs AMD64_NUM_COUNTERS_CORE * 2 - 1.

> +            index = index - MSR_F15H_PERF_CTL0;
> +            if (index & 0x1) {
> +                env->msr_gp_counters[index] = msrs[i].data;
> +            } else {
> +                env->msr_gp_evtsel[index] = msrs[i].data;
> +            }
> +            break;
>          case HV_X64_MSR_HYPERCALL:
>              env->msr_hv_hypercall = msrs[i].data;
>              break;


