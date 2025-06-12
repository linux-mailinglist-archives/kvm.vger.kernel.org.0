Return-Path: <kvm+bounces-49240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EDEEAD6AA5
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F13AE1BC255C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10794223DD4;
	Thu, 12 Jun 2025 08:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GLp5AnBo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE0721CA14;
	Thu, 12 Jun 2025 08:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716854; cv=fail; b=B3Pnm+BAfz0aI9fN4A2Hw/540JUTMUtQh3vtOU933XPObcDT3YAnm97s1yaT1gN0RvbBuci8Skqce71NQ+ZkMn9t9NkUs/edQg8Lm0W54FYG3nL8zXz4cVEuZqmBh+GaRxzb1IstenQFnb0vj9csnVU+rBd9wlu7KpjVZ0VSEK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716854; c=relaxed/simple;
	bh=/xq0XmuGW2h7gKip0zBvdGpP+rJP+L+Q3vIaY896Vas=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=snMwIC3qjDPyPdxnrzWoXN0m1dt66MKAAwFtWq+VkA2xD1UGLB14VQHK+oC9GvCRKbadehZXNmm3M6ZloKsn+EOLCYZNwZe+nwvvQJTPPrBTQVkXavw0aUnkOtA9FIG9SQhe4Vo48w/0ejM4s+UvneKEZWfb5r+Jc3YEQkR/mLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GLp5AnBo; arc=fail smtp.client-ip=40.107.244.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yiJSSYRXALeQw+rZe2w0QnjAACC5elbOZjPzOAaXP8msCeprJTR54FqavTjTKl3HJEWrmF+J4Ur4I6hDRl6hTUAxNj/BjLZ/xs3SbbqgH/1suEQvCr5LK21ttWXVoTr4zvCoeWRZoIaurMo1L8M5pncV8B23lgbBK+IXdg7iTZtt9fD+quwqb6u/ZZ2Duaud+5/jzki2oV/dNBJrxzCL6BqMv9menHtKRs/b+yojahTTM1OmzDCOW/THgiO0oqzEPaQBK9OxX+Oo+7hllOm/F280SDfdFKxemIh7sJr0Gq4Hl/mOD9GTzp2PXSsHucLTjECO9m0xJ5yYR3zip74uVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBJogpDUP6MJUy5LrUvnu/baCGSbfaqrZ52dY+VJ/Mg=;
 b=Wv2wKcPvVCYcL3kuIiB7UJo1G0CWJ5QPYe9wWQHdBK8WiJfoKTwxzmAxOPq3lvRMdDM2kYbGUnQCPmSsO9NqcAuEeDHf4u3Ew2oE4plYALzTka2+TmDHOobk4amaiHCE084IohXgyZTYkWzr9dKLYHw8XblWzfplTE3ZCDbdIqO9UvZB2HOOsMVyU1y2PyPmpJkq8uArB73c0p+lyW+4GL5E1WNjXHRnfOvOQzlxHx+qLZ/7OWVaBwwrVuj4AljXxS3dtTZwPLeu9wx0KHOQKoVI6fh2aLJzKNn8xUEI54+VicJZJSSOxsnmEHXG6AUX+PDfE+KlxBg4m3oJq1pI/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBJogpDUP6MJUy5LrUvnu/baCGSbfaqrZ52dY+VJ/Mg=;
 b=GLp5AnBoqpmMkMSevS7YFaP/Y5tlK0HYbefOxdyiR5TVvmU5Wp0B0DnWh1cbACUge6I/DbhMA04XBKAs6202xSO1rwQ/VrHtXlxfzQPIyxY1hkLMobjpLH2M/toGsUKTogUJEWNre9zB57xkgkJT2lbuH+cIL50DbWrbaylckqw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM3PR12MB9287.namprd12.prod.outlook.com (2603:10b6:8:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.38; Thu, 12 Jun
 2025 08:27:30 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 08:27:29 +0000
Message-ID: <52f0d07a-b1a0-432c-8f6f-8c9bf59c1843@amd.com>
Date: Thu, 12 Jun 2025 18:27:23 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH] PCI: Add quirk to always map ivshmem as write-back
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
 David Woodhouse <dwmw@amazon.co.uk>,
 Kai-Heng Feng <kai.heng.feng@canonical.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Santosh Shukla <santosh.shukla@amd.com>,
 "Nikunj A. Dadhania" <nikunj@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20250612082233.3008318-1-aik@amd.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250612082233.3008318-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::26) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM3PR12MB9287:EE_
X-MS-Office365-Filtering-Correlation-Id: efbb4da5-f054-468b-261a-08dda98af841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXh0bEtxWVE3Q1R5Zzk3amIvMGE3R0tnYTdqYS9vd2w4OGpQT1NndjRsb0RV?=
 =?utf-8?B?bjNTOGd1R2UwUUU2aTRUVzdScnNLcEgxbkszQlNGZVNtSjBCbWtSbHdPcHl4?=
 =?utf-8?B?U21kRzM1Q01zWm9hRm5nK2E2aG9VRy9JczZUMlc3UkNoT080YkNHSDlZYXBT?=
 =?utf-8?B?Ulh0QUMxd1RZdDBIMTBUSXBWTUZabS9lNk9PN0NQcXJqOWNEMW5pSjVsd28r?=
 =?utf-8?B?NkM0NnRsZmFOdVB5U2J1cCtnSW9RcGtzUFFicHVqUlpNeldKWUpRY1B6ZFRU?=
 =?utf-8?B?NkdNNkdpNGk2cFRiYlJpalFRKzhEa3dJbVpGcjlYOHp0TDl0QVFlL1g0OVda?=
 =?utf-8?B?ZHVNMjhsclpNMHNYelVna3lmWFEwbjkxUHpSWmcyOVo1R3pqYkkvOWRoSGs2?=
 =?utf-8?B?MXJweHc3MjNrUmdIK0k1SXhucGR1WFpoUitxYVlhcnhrcDV4d2t0U3VmekJQ?=
 =?utf-8?B?RzFFVUFud0QwZ1gyR05OV3NkNkJSSnBUQnVJS3RXQTNMLytmSHc1YzBnSGd4?=
 =?utf-8?B?a2tYVi9qUHVUZWdMWTlZcUJSUzJnL2h4WlRzcDdudmorNFgxdnhxN2ZaK0Vp?=
 =?utf-8?B?LzcvM0E0bGo0QW5rb1dqUlV5bmhxcFg3MENmVDNmeENIbjRIaUY1dUlpNE5Q?=
 =?utf-8?B?VTlGNEQ5akRrZWpaZVI4Ynpkdy9ReTloK3M3SlBWb1FvS21NQjJiQWYrYkxY?=
 =?utf-8?B?TVdLR0FSdXpDdWRWaVgrWlM0OEczb1RlUStHdG9iNTJROU5nalFOU3JOY3Iz?=
 =?utf-8?B?eU1KZG1pNWgxdStlUjVIZzY5M0owQ1dLM0FNOElrRnUwai9ISG4yL1QwZXR3?=
 =?utf-8?B?b1hnZVNodDVpMWU4WlVTd0kyR0ZNd05Oc3luM3BOcUJlTFJ5ajVZZHpsZlV4?=
 =?utf-8?B?d1E2YTc0Yk1oUFNZRWxxbndRQmNoTUFKM0I0ZXQwSmFrcnREbS9kaGZuTzRC?=
 =?utf-8?B?RmFTY0Z6TFZQSWJub1EzbGxCT3JVdHRic2FicHV3VDZuN3BoTTROUnhVMXlQ?=
 =?utf-8?B?SkNENHN2RS9pS09pOGhGRWNZTDRHWEEvc2hwT0N6c0d3M09YWUJoSWRxdldO?=
 =?utf-8?B?RGlIWXBQWGJXU2E0aGtTVkpRK1hBVHRBckVrbFVpTWZ4RHFSM3RYcUdHUTVH?=
 =?utf-8?B?U0VWNFZVWkhOcFdWeFRka1o5WGhCd0x4Z1VHUWRYVzdSc0tUWjFlTVpRZisx?=
 =?utf-8?B?MVV2TGtXd3A0d1V4aDRYYUt0MWNaUzVqbTFoaW9BQlNmek51U25RNVVqMGNO?=
 =?utf-8?B?dFZ3VDhYWC9tYjM2dERIcjF5cnhWSEp2M2R0LzZuNzdFYVd5bkpIcCtvNHpq?=
 =?utf-8?B?ejJ0RWVqbU9kdThIL3JCSDFhcW1IMFRnSXZqRUQrcXpFcmlLVEZSTE8vKzBI?=
 =?utf-8?B?K2V5NGxVcHBaWW4reEV4NC8vNUtJcHd5TmM4RUZrV2toUTVibjFCd2ppS1Fh?=
 =?utf-8?B?YWJnSlpLd3dkWk45QlJxL3d1TFBCaVNrV3V4NG5OaWxvYUNSVmkyNWdaS1k5?=
 =?utf-8?B?K3FvN21UUmE5N3lyYmszZFpWcXZyaXR3ejJqUFBjZ1BSLzJOeFRwZU5QeVg5?=
 =?utf-8?B?S25aS21lTGY2cHNXZmdtdjZMRHhrRGZQdmIzN0E1S1l0OWFRaVpVeXVxRnln?=
 =?utf-8?B?QlhLSk5qMkNqdmx4ajlQd2RtdDhiVlIzL0hpNTZPT05KcDEzdnBubFJiSktr?=
 =?utf-8?B?RkNsTU5JZTM0MmlDem5VTTI0UzNjOUt1cUU2N0FZeVA2eWs1SHU4dzBSMitx?=
 =?utf-8?B?TGdvb2tOaUlHT25MU09MZldBZkd1c0FqSE4zcVlEUUZqYS8xNm10RHRiTGZE?=
 =?utf-8?B?a2txekZHK3JwZGsrMmdvZ2lyUUlKV2RzK3laVGpoTk44NFhUbkpPZHZKdGxl?=
 =?utf-8?B?VEMyTGtTNzZ3bGVTazc4OVJyRUFTdnUvWXY4N0dtdmczbWhuMTc0REZKSDBD?=
 =?utf-8?Q?5EjaS60oWEE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmQyYTcrUFU5TVJSOXV2dUlOOTZOZ2tScVVYQXY0UmtmWURGNnBGYUFLQkgx?=
 =?utf-8?B?RGRWS1BEaVJ4NUdsY0EwQ0ZrdWVYTkpXeGo1SmNmL2xhNVBwTGMwbTlyV3g4?=
 =?utf-8?B?SVBRMWRnb1RrRTJORWljU0piS2RWdVRnRGdtaVF2WjhFSUtVTjJhVkU2Znlq?=
 =?utf-8?B?ajljbi8vMVhuSlJDS2U1NVErK2k5cmhuR0p0eWJtdjYvdXRHOU5kL1ZJR0pJ?=
 =?utf-8?B?K0dDdnVvc3locWY5WE1ISDIrN3E1WHI3MzZMQ3U2Uk52SHp1WkJjTjN5enpI?=
 =?utf-8?B?NDBUZFV2T3AzcngrbmJkVlRsQS9jcUZwK2U1bVhleGhYYm9KTGN1WU9lME5N?=
 =?utf-8?B?d2l1TzkycS9NUFlsZjV1SlBURUJrdzlicmJXZ3pacDRUSi83NllOV0ZUaFlC?=
 =?utf-8?B?Wmd4UzR4RUp1WG1HSlBMYTkvRFVCN3hwM0tpOXZ5ZHl2ZytadlZidWpZZDRK?=
 =?utf-8?B?RHRTNjg5bWdZWm1MTWgyRWpXRXJjQmUzR2dsOUNqYjJrZUF5UkRhR2J6YXBV?=
 =?utf-8?B?SGwyMENvZnAvdXQ1dHdvWlZ4M1AxckpqS0txZHdPbWt1NGNqdmYyZ0hKTFZZ?=
 =?utf-8?B?RnFjblVBMGhTSm83eWRYWVJWeWJGbXlWMFJDK1RlSXB3b0gzcGNnZTNMeXQv?=
 =?utf-8?B?Z0YwbkZKMExEWFRwUU1RUDlNalJKSWtEYlovSnV0cVdiWkRSdmwyVWJOYk9P?=
 =?utf-8?B?eXdKOGFnT1k2SzlZRGxZYWI1UjhJWWgvT0ZsQmFwZldSN01uQ2U3NWwvbWxS?=
 =?utf-8?B?YVVDUGtOVzZsWmM0cGlHWG5VWW9wem84ems1Vk9HcUlmdDdLTmtjc0lveXBG?=
 =?utf-8?B?RDVpL2NEZHBDckVqRlFna3ZxcVRXODBidUtkR3pldVRsdXYrK1ExN3hpVVhx?=
 =?utf-8?B?VWpOU3Y1ZkZ4eFNmMElxbDVlaUFXbVpBeHdQdWl3Y0t4cTZwdVBYVHFOYU9X?=
 =?utf-8?B?ZUhpYmVhU0xOcjdGU3BvdGJvUDRucC82Wmt3c0V0L21Sdm1pWjl1LzVHelUv?=
 =?utf-8?B?QWhUZDRsZzdJZk8rZEJ3cThibVVGd3FzVWUwU2taOXB1bFJIRnNjZGJRTjlZ?=
 =?utf-8?B?TDBQRCtHY2dpZlZyc0EzNTQyZkd2ZGFaajNhanZ6eVB3ZnpIcFZUSVljRzg2?=
 =?utf-8?B?VDUxak9aTGh0T3cxNlJCcWxVM1BKRzVIbG4zdlV1MWwxU242YUZkcGtjNlU3?=
 =?utf-8?B?YjdtTHA2a2c0ZkozS3RwSmtMQUpSVHdBS21GWVdGd3g3Mm82UUZvVFJzSm5w?=
 =?utf-8?B?dVFmZ1FMbHVwMWRtbTFGZkNsZ2ZVVTlicktVT1JncWE2NW1seEVmNUloVWx1?=
 =?utf-8?B?Z0hJT0xESHZ4cFZRcFo5Q3BETzh3amNJNU5HSG5xK0Z6aWV0MDZWbWtxYzRF?=
 =?utf-8?B?TUdmc0RqZFh0Z0NSVXVTNUxzaDhqaXJDR2xwdzJnUG9WOXdWeThrMnBkamxl?=
 =?utf-8?B?SUZtakdVOVY3bWtDeWRlSTlFRzBHL0NMeHdhV2xPclMzOXRKVXJQcXVoUzNM?=
 =?utf-8?B?Ty9XS3l2MUxaT2FzSWduUjN6L1JKSitQbnBRTldNZkNrZFZTbDYrNzlOOG52?=
 =?utf-8?B?dkZpNnhhQWNQUVozMEhVSjVhSEgrdm5iUm9aVVlXTzROck43TndtckFTUEpm?=
 =?utf-8?B?SmVqcytjVGxhdElvRVI2aUNXaWVreDA4YjVBV2VpUzIyNTFYM0VndzZIaWFR?=
 =?utf-8?B?K1F0cFJYdXdzdU5HWlFJdHBlRGIxQm9RTkRuVVM1ZERwaTJGQkRTL0VIQ0Y0?=
 =?utf-8?B?aFhTNWd0NXBNdUZXZjA3RGhVNDl6VWRzdFBqeWc3SnJHbWNlaEl4MUorOWRH?=
 =?utf-8?B?L3JHVHYyTXdqR2RoUDRhQTdnNjU5cVNLTDlER1NXbFQ0anhQZUJhNHpGdEZo?=
 =?utf-8?B?T1RoeDF5U0Uvei9DV2Fia1g5bXhjMWUwWTlmSU5jcUdMREtqNCt0eXM5VmxG?=
 =?utf-8?B?NmhCYkFWbUdwQk13bjJocXBUVFUvN0x5TmFOQzF2VXF4KzJUMUxRZWVsYWE1?=
 =?utf-8?B?UG1STFhCb0tvcm5oUmhyc2taQUVFbWxWbUlxWXZWUVlsb1BwUm1zNVhWRFlY?=
 =?utf-8?B?Tm5BMG5oM3Z4SnYyZS84blJIb1pZMGwrbnFDV0NNMmtPTWU0QVRaMWN1TFE4?=
 =?utf-8?Q?4K7YzoqT0Z2jNxRt9ThZe1re9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efbb4da5-f054-468b-261a-08dda98af841
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 08:27:29.3980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bEeQtHfXGp8m1kGeK/h19BZsmXsPmPdXXhshWj9DJRJUqfldESiHNWD+J36RjVxIf8jQO8m9BvbaY9SJ6EItlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9287

Wrong email for Nikunj :) And I missed the KVM ml. Sorry for the noise.


On 12/6/25 18:22, Alexey Kardashevskiy wrote:
> QEMU Inter-VM Shared Memory (ivshmem) is designed to share a memory
> region between guest and host. The host creates a file, passes it to QEMU
> which it presents to the guest via PCI BAR#2. The guest userspace
> can map /sys/bus/pci/devices/0000:01:02.3/resource2(_wc) to use the region
> without having the guest driver for the device at all.
> 
> The problem with this, since it is a PCI resource, the PCI sysfs
> reasonably enforces:
> - no caching when mapped via "resourceN" (PTE::PCD on x86) or
> - write-through when mapped via "resourceN_wc" (PTE::PWT on x86).
> 
> As the result, the host writes are seen by the guest immediately
> (as the region is just a mapped file) but it takes quite some time for
> the host to see non-cached guest writes.
> 
> Add a quirk to always map ivshmem's BAR2 as cacheable (==write-back) as
> ivshmem is backed by RAM anyway.
> (Re)use already defined but not used IORESOURCE_CACHEABLE flag.
> 
> This does not affect other ways of mapping a PCI BAR, a driver can use
> memremap() for this functionality.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> 
> What is this IORESOURCE_CACHEABLE for actually?
> 
> Anyway, the alternatives are:
> 
> 1. add a new node in sysfs - "resourceN_wb" - for mapping as writeback
> but this requires changing existing (and likely old) userspace tools;
> 
> 2. fix the kernel to strictly follow /proc/mtrr (now it is rather
> a recommendation) but Documentation/arch/x86/mtrr.rst says it is replaced
> with PAT which does not seem to allow overriding caching for specific
> devices (==MMIO ranges).
> 
> ---
>   drivers/pci/mmap.c   | 6 ++++++
>   drivers/pci/quirks.c | 8 ++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/pci/mmap.c b/drivers/pci/mmap.c
> index 8da3347a95c4..8495bee08fae 100644
> --- a/drivers/pci/mmap.c
> +++ b/drivers/pci/mmap.c
> @@ -35,6 +35,7 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
>   	if (write_combine)
>   		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
>   	else
> +	else if (!(pci_resource_flags(pdev, bar) & IORESOURCE_CACHEABLE))
>   		vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
>   
>   	if (mmap_state == pci_mmap_io) {
> @@ -46,6 +47,11 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
>   
>   	vma->vm_ops = &pci_phys_vm_ops;
>   
> +	if (pci_resource_flags(pdev, bar) & IORESOURCE_CACHEABLE)
> +		return remap_pfn_range_notrack(vma, vma->vm_start, vma->vm_pgoff,
> +					       vma->vm_end - vma->vm_start,
> +					       vma->vm_page_prot);
> +
>   	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>   				  vma->vm_end - vma->vm_start,
>   				  vma->vm_page_prot);
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index d7f4ee634263..858869ec6612 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -6335,3 +6335,11 @@ static void pci_mask_replay_timer_timeout(struct pci_dev *pdev)
>   DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_GLI, 0x9750, pci_mask_replay_timer_timeout);
>   DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_GLI, 0x9755, pci_mask_replay_timer_timeout);
>   #endif
> +
> +static void pci_ivshmem_writeback(struct pci_dev *dev)
> +{
> +	struct resource *r = &dev->resource[2];
> +
> +	r->flags |= IORESOURCE_CACHEABLE;
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1110, pci_ivshmem_writeback);

-- 
Alexey


