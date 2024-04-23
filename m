Return-Path: <kvm+bounces-15721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B6A8AF818
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 22:38:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D337A1F232F2
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 20:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47828142E79;
	Tue, 23 Apr 2024 20:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OXg9+W/g"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6AF142627
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 20:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713904686; cv=fail; b=eS+2OkzE0wb7uwfTi6KY7I6Qc8OP+7tqkT9G7K8IxxWcR1+8babq4v7/SaRW0X6M0fn4OkqBirSzP0xLXznGyH80AX/XynqSBPqw06p/8DM6VJfZ4YrXvV8IVRwSQaAr8ItxaE49JKv5GfxD0R92b6DczIczgc45+WZuolRQBM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713904686; c=relaxed/simple;
	bh=50X2pBa9Kiu83oZagyhM6XQkknlCIdnK0XfhMO0MO+M=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=jrx4hQhu2QT6QXzDMfTjPBSAx8m/8hRBS7iLm6pBt0m+JQ1cbj2cL0Cmhc/JJykaPXIb0wCPwwUJdOSsvHKCN0AwjCPD2+mjhkWMKZHS3q4CtXh2QpNiK6DPrK09YdZE+XaievuZn4m1YyKn/ySp65bGQ+ALLLwWQq72y7OJEyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OXg9+W/g; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZu27l1RDD6m9xmCuLMl5meyjKWcraPhZ/CpqY7h899TsdHbvJ4sICLgQOF+dPLFu8CSIp0+0jtODGi+u0Wtm3CGALlzfKKZ+OMU6PDxzZ2cjUdZsHR8coGqNpK85nf4ETp5t5jHz5GyzXN0rrq3qdNTYS9RRZLk5E154B1/Xtsq1Uzi/ABo4tPWqLO7EKXmWnndfK7ya7fhbXIg2NlPtNPRUQbT/qmvl8Nm3QqGWhpTWifjv9VjOmNDhlxZ7IUsCccNQMRxKHHq8/0QiT5Dl4t2fDSvPYz6OuqgYICDmd0iCL+lBDj1LyN7gDfYg2PnlogqfezGunNc4n+Q9n4gYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVExMMSees/urNt8zV28Sbc7odgLHWuINw1XDMR8Oao=;
 b=iCIdFYrFJJBAzFCrX70OzJqUW1bLHoMQkzyUzIasMKG29Dv0TPMRG13Exno6tkaEhHpZySNXphqNpErGo+cKgC7dggIQM2cvfkfTwbPMC6teixxkpClu+N6LgngooMfbo9fnRp+tNrfo40Q3z3VrO6yY3IJsWNIwWyzi0zA+eLO4BYl8XYrzBaD7tpXgmnFVtNj+EkGqCznQz3LCgV/E7OsrAYvNw+Za5wmeuT87pvVEcS1ua7EZ7i5V02j79VoMxANTBXR7AiOKyl86TqSAVZH4ALhcicQbunqLaIQ6pkXAjbj1Owwl7odsL//Ot53wmv6q+eLm3MMRnqSE0cXUYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVExMMSees/urNt8zV28Sbc7odgLHWuINw1XDMR8Oao=;
 b=OXg9+W/gp939ECksGRG8ZnQDC0NR/me2zuAfipGZgnVVVf0mhGvNbCumZEDS6MByMQ8R2II9GBMO2x8Sud0Q0j1SX3UkLg1SXHHbApJyRZtSNOhSmRntn2qb51TRaFqvTVmKKyewfm9XKQpXCpkM7kihv4QywiYEN/6zAC85Nu0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 20:38:02 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7472.044; Tue, 23 Apr 2024
 20:38:02 +0000
Message-ID: <ba2c1d9e-ad14-4e68-20b9-6aac97f09925@amd.com>
Date: Tue, 23 Apr 2024 15:38:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Yosry Ahmed <yosryahmed@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Peter Gonda <pgonda@google.com>, Li RongQing <lirongqing@baidu.com>,
 pbonzini@redhat.com, kvm@vger.kernel.org, Michael Roth
 <michael.roth@amd.com>, David Rientjes <rientjes@google.com>
References: <20240418030703.38628-1-lirongqing@baidu.com>
 <ZicA3732THkl-B1u@google.com>
 <CAMkAt6oP2CM+EtSNtCw7+V72UsPTHRZ04t7d21j0jQsj8wkW8w@mail.gmail.com>
 <CAJD7tkZzHQUOH3EiJ_Zn33dya+pumnohoKA7AnnVm4GE+WcOhg@mail.gmail.com>
 <ZigBYpHubg00BnAT@google.com>
 <CAJD7tkafCAP=qx2H=U2taxPL-5eqrVTqPuSUxQZKSPA-qAjyvg@mail.gmail.com>
 <ZigFQPCL7S_VtxFs@google.com>
 <CAJD7tkZJQLHN5vK_3LpUy-dFHtH3c4sJ3JHFwyfdVOUn=WJW3A@mail.gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] KVM: SVM: Consider NUMA affinity when allocating per-CPU
 save_area
In-Reply-To: <CAJD7tkZJQLHN5vK_3LpUy-dFHtH3c4sJ3JHFwyfdVOUn=WJW3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR01CA0031.prod.exchangelabs.com (2603:10b6:805:b6::44)
 To BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MN2PR12MB4358:EE_
X-MS-Office365-Filtering-Correlation-Id: eea29e6e-d59e-45bb-c3f4-08dc63d54577
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlB4LyszMWFIaFg3VExqYlhWKzdwR1VpcUJ6TEFlZ0VoQ3cyVXB2TzdpTnZl?=
 =?utf-8?B?K2xOUW5Hb0FjVFFjS2IvVlNJWW1rVVovR0hNTFlRNHBLWU14NVhGNTVRM1lK?=
 =?utf-8?B?Q1JqR3YwUkl1NVRWOFdWb0JjU1VRUkpLVXJ4Q3poN0x3WjIzVlQ0eWJrdVhU?=
 =?utf-8?B?QWZuUENnQ3ZYcWViSDg4UmxrdjhycUtOTks2bFlGcWs0RjFZTFNheUdWT2Zs?=
 =?utf-8?B?VUFmejJFYWxuTzJpOG5MbjZXaXpnSVh3c2w5SlJoUCtSdEN5WmQwV2lJcHVZ?=
 =?utf-8?B?a081dVg2Wmx6UlU2QXN1QUNyYU1jRytoZldjR3F4MmdmWFkvL3BNVVhNSkFp?=
 =?utf-8?B?cDNUcmx5UWZiY3lZR3l3UUFHMXAvZWVRa1BZT1NORWR1c1Rvc3NiNVQyZUFl?=
 =?utf-8?B?cEsxOEpTMVF1ZmRZd21tbEZzdnUvWkxPQml2NU5DSFRNcS9WNktWVHdHeE5C?=
 =?utf-8?B?RzRuTTRBVE9peG9GQ2JwQldOU1F1ZEpSMWlIN2Y4aitVR1F5c2Rzb2RBR0sv?=
 =?utf-8?B?WE1Ha0ppUUcyakp1Q3d5U0FGTm9LcDB0Ykc4NXBWOWlKRFc2cEg1Njl2aERy?=
 =?utf-8?B?ZzgvNy9BSUNJdU1nZHVCRGxqWWlicTdrc0FzOTVET0ZLQVF4TXlhVklscXU1?=
 =?utf-8?B?YUpyY092cVZ0bVVpU0tKSHNhbWd0YWxIOTFCZ1daQ3dFYy9yN1RuNVFxU3dI?=
 =?utf-8?B?QjJNY29aWEJ3M2xsaDRlT0M3SnVuSUtLSDZtSXMvME9mTFFLSWZmZHJ2VzRy?=
 =?utf-8?B?Y1ExUzRRRkVpTFdqZjRxTU1oUUZ0bUlySmNwemRNSjF2RzBxS3NLdFJnNnpU?=
 =?utf-8?B?NFJ6NFo2RmpLVWdyYTFuWkFtNys2alNlVFZ4WlU5MjdOaHFhUlljalA3UGlt?=
 =?utf-8?B?ZW9GbHluZUg1bWdneWFDVXV6ZFI2SmE1UXE5cm8yL3FyNjFLcTc1azdTRDBP?=
 =?utf-8?B?cGYzbnAxSjlyYTZJSTU5L2R3Y3VSUlN4QlJWVjZHd0NWQlVOR2Y5eDZ0NGdW?=
 =?utf-8?B?QUhvNmZQUEdSTGpiaUVxSVhqMHMySG1tWVFHKzdNWHZUdGlENHNrMkNBS1dn?=
 =?utf-8?B?cmgyYmJSdWhRZjQzaURwMW5SOVBKSXlGVzkvZ2xTMUtPS3c5ZG42VC96UkRL?=
 =?utf-8?B?MTFoTVZYR2Z3UUFMNUxkdnAvanVjS0NZVFFBSExybG5Pd2R2am9VbVBxNkdQ?=
 =?utf-8?B?S2ZpSHUyRURQSU55bzJaVFp6NGswNjhOV3BZK1VKU2FWbGs2RU5VVmRQMmJv?=
 =?utf-8?B?aXdXUmJxUVRDbFFvMmtpQjBZQ3J5NEo0bUVtUWNLczZGSlhhR09LUms0aTRw?=
 =?utf-8?B?UWg3cG1vTnBiUWR0WVNRV244MzJpYjF5bHYramo1RU5hSnA3Y1BDbjlQcXRK?=
 =?utf-8?B?Vzdtc3NMdUU0WmhYK3BNTzhOanRuM2xzcVQrZWF3VUZ1MUxlSnFlNE9ZQzUw?=
 =?utf-8?B?SVhsVVBING5wL2xPL0ExUEc0TnRlQVY0Tlk5bnFCeFpJaFNoNnhGQ0dPSTNQ?=
 =?utf-8?B?YStoK3hiZTV3ZG45RmNwK2ZzZFZNWGhMeXJnMGVUVVo4cnlKR3UvUEQvRHdD?=
 =?utf-8?B?SVRhSDlxU1pYdFhoSGRpaC9wVThSS0w4cjFUVkVlN3NGeFF0Z3NQYmlmZ1Bt?=
 =?utf-8?B?R3RyYkpodWxKTXRlcjFNblZ0VmtlSXc5M21JbVhsN01lbVpuWnQ4eVFKOFB3?=
 =?utf-8?B?NDR6UkFmUE5JY0JqUTgrT0s2UklQQ3JuOWM3Rnd5Q1RPUE1HeHlkQzdBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3F0czFhNE4wSkdqdUJkd3ZYa3p3aDVIWFlaRlhpakdTZGpZeFdGMnQ1L21a?=
 =?utf-8?B?c3dRMWN1Q0w5c2NFK1lJZ2cvdGY2N2c1bC9teDNJRUxMNk1Db0NNT2J2dCtB?=
 =?utf-8?B?cWRRODhQNWROWGJrcmJPak1XK1l5RXZYNTRsR3c1SVVtamVha0M2ZVBRbHgr?=
 =?utf-8?B?NytyQlQxeVYrcFM4SEE2VWc5Y1l2YW9YU3MwRE9Rbk9JdjdtYk5wOVQ2KzFO?=
 =?utf-8?B?RTdMT1dNc1AybUppTlIwbWFNd0tPTmFQaW0zSGNBWStkMUZObFNsM3lhTHpr?=
 =?utf-8?B?TlRIRTRoZzB6S2tvWjR0Q2QrM0d4ankwcEkwZG5Deko2cnJwR29jZUQ2WCto?=
 =?utf-8?B?ZUFLMklITzVRLzJBL0M4VERyRi9sRndmMUVia2VjS3F0b0lubXpLMzhXdkxD?=
 =?utf-8?B?Z09VSmgxd0wxQ2dDR1daSVNWNnR0aUY1TFRnY3Q0MXdRRUtGT1lodjh3aUs5?=
 =?utf-8?B?TzBHa3FUZnlyOVo3QUVYTHVIZCtqVWdRQ0JQQldVVXkwWVI1MWExUCtXUzJR?=
 =?utf-8?B?cCtjMWlzaHhQRzV1NEtZU05oOWtRVXZDQk9lYWdzUzlkK3NOd1AveGhLQVhJ?=
 =?utf-8?B?YUx1cjdka3B2RlZoTytvMzZpSldMRG4xVzdzZ1VLT1A1NGh3aWVtaTdla1E1?=
 =?utf-8?B?M05pOWk3SE9heVMrVXZvUlZ5UjFFYktUTGlYc2tJMlJXZEJQbm5OVVB2SUMv?=
 =?utf-8?B?OGhJQWpjMTg5Y0I1dmFQTDhPdkF3a1NVbTdWaFk5d2FzeUVldWpZa1k4R2FO?=
 =?utf-8?B?a3hOUlNhdC9SKzI1cWZTT1hhSjY1NmthdVhSNXdFQldCVVNBamRXVTd3YkhG?=
 =?utf-8?B?eVJQQ0FHK2dxWnZLazhrU054RFU5WnJhY2ErLzlmVTI2ZGZ3bkEyRGQ0WkNN?=
 =?utf-8?B?WnB1cWpBM09aV3U2cUMxSFltQUFCVlF1eVJMaklJcDk0SjNJREQ3Y3B1ZVQz?=
 =?utf-8?B?amVwQU9XdnA2MEdWQmNoU1VyY3I3ZDJWZDlYY05pUGk3U0FwcVczWGZyeXJi?=
 =?utf-8?B?V3VPVElEYnQ0QzJRbGI5NEk0TUUwenhxSW9xMUlZaHlXekgwcFNMTDFuZXIy?=
 =?utf-8?B?QUt4TGd2bFp3TFZWUjcyclpnNGdwWkd0NzI1QlRtNUxUbGVMa0dBUkJqMjRW?=
 =?utf-8?B?eWM2TjIrT3k4Y0pkSDFLMXNhNElFVjJnZEFBUEZLeHF1UUhSQnFGbWp0QW1N?=
 =?utf-8?B?VG84TVRkbW96MkxHeGdPeXpwcHNIUXJ4cUR4MXY1aVF5Q291Ylh6cFBnWE14?=
 =?utf-8?B?cUUrcmNpUEtzbEM0SlpsL1N0dXhmRUxjc2hPNEkzQnVBSkxCS01lNzVqZjZ6?=
 =?utf-8?B?T0pveENsd3N1aW9XTmZXZGJiOWUwcDJZQnVXcXR2M2dFVnljY0ZuUWNST0ln?=
 =?utf-8?B?VUFUMUtKWlUvc0l0UE1BNWZTV3Z6T0hvcWhZeVE0ODZkb2VxTXdPUERPdmho?=
 =?utf-8?B?aWVGd2YyWC9SYVpDcVYzQ1c0d044M24zM0svWGp6dmxHTGZHVWR4aXhjVXZv?=
 =?utf-8?B?V0FYMlBWakp2c2Q2Z0VicUp6RmpxUUtZdHdOS1kwcCtleStYaHcrNVR1NmlF?=
 =?utf-8?B?UzlNRExzc25CU0ozTHpOdTNmK01SUHd4OFpHOXVSREkzdUxQQVowOTlMd1pm?=
 =?utf-8?B?WFVubjhnQm43Vis2WDRxU0QrMm41TzJ6WGZxV09xQWV2Ny93SlRWSkJmSzBV?=
 =?utf-8?B?R0RNeXQ4SE9wQmkrRVFBVDFrZU4vZ0VWT0w4QmVSWTNmZHFwTE9VMEtJbFA4?=
 =?utf-8?B?WXEyT1hLUlArdG1zenFtemd3R2wwdWdGcDhFZnhtbjI5QkxHampla0N5U3hC?=
 =?utf-8?B?Wi90YnZSZjRXdnJQREVCdG0yZnE5YjN2d3dLZE9yeGdQQ2RqVFNCakNNNlVr?=
 =?utf-8?B?MFdkRFZXalpkNG56bTVwaldQN1F2eno2RGp1ZEJuMWVHdUlWaDdTWktnWXlr?=
 =?utf-8?B?WkdUUXdDOE1Db0FkNjJhMkxMdUVEQ0ZiZ1JFVWN6K0RHS2EzcnIrdmxwdWYr?=
 =?utf-8?B?V3RGZGp2ODhRMzRIZG9XdU9VeXc0VERkZGw5dVdvOTRHcVlQMzlMM3RuOGlV?=
 =?utf-8?B?d2dUVG1mWm5Uc3lmSkVTOEZLaTlEUStIdGo0ZkU2RllZMmRKQ1hLbGVEM09I?=
 =?utf-8?Q?RAwhJ0IABq73gHY8xIdfxpzyL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eea29e6e-d59e-45bb-c3f4-08dc63d54577
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 20:38:02.6046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yvYsQQmLyXh/z9IrDRkqneOHWtxePROTm9CeehVX70BLShha+A5CNllWQ8mpbZwzuBrLmT01rAjfgB5adXp2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4358

On 4/23/24 14:08, Yosry Ahmed wrote:
> On Tue, Apr 23, 2024 at 12:00 PM Sean Christopherson <seanjc@google.com> wrote:
>> On Tue, Apr 23, 2024, Yosry Ahmed wrote:
>>> On Tue, Apr 23, 2024 at 11:43 AM Sean Christopherson <seanjc@google.com> wrote:
>>>> But snp_safe_alloc_page() should again flow alloc_pages() and pass numa_node_id(),
>>>> not NUMA_NO_NODE.
>>>
>>> alloc_pages_node() will use numa_node_id() if you pass in NUMA_NO_NODE.
>>
>> The code uses numa_mem_id()
>>
>>          if (nid == NUMA_NO_NODE)
>>                  nid = numa_mem_id();
>>
>> which is presumably the exact same thing as numa_node_id() on x86.  But I don't
>> want to have to think that hard :-)
> 
> Uh yes, I missed numa_node_id() vs numa_mem_id(). Anyway, using
> NUMA_NO_NODE with alloc_pages_node() is intended as an abstraction
> such that you don't need to think about it :P
> 
>>
>> In other words, all I'm saying is that if we want to mirror alloc_pages() and
>> alloc_pages_node(), then we should mirror them exactly.
> 
> It's different though, these functions are core MM APIs used by the
> entire kernel. snp_safe_alloc_page() is just a helper here wrapping
> those core MM APIs rather than mirroring them.
> 
> In this case snp_safe_alloc_page() would wrap
> snp_safe_alloc_page_node() which would wrap alloc_pages_node(). So it
> should use alloc_pages_node() as intended: pass in a node id or
> NUMA_NO_NODE if you just want the closest node.
> 
> Just my 2c, not that it will make a difference in practice.

Pretty much agree with everything everyone has said. The per-CPU 
shouldn't be GFP_KERNEL_ACCOUNT and having a snp_safe_alloc_page() that 
wraps snp_safe_alloc_page_node() which then calls alloc_pages_node() 
seems the best way to me.

Thanks,
Tom

