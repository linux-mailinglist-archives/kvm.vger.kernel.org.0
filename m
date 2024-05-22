Return-Path: <kvm+bounces-17971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0F3F8CC4B1
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 18:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4B0B1C2151D
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 16:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2361913D617;
	Wed, 22 May 2024 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cLu+4wFk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qK6MPqvt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B7F1420B0;
	Wed, 22 May 2024 16:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716394248; cv=fail; b=OYGjTH94/K2wezYXRtST5WHVo/y3EtOM+M50OTT9WTBprzlRQdHqDgrS9NxuQ7Cmv4bj873QJPh6nz7zTXrQ5rrqsoKzEDWcTTeefdUjEkaMclMeJy12CeXRw8iw1mbLVtog20xbNAh7SugpRhjF9jrwPdFRs/AqJnP6LW+JQQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716394248; c=relaxed/simple;
	bh=2R9cuJLoaLyf7/NtYuMA6CKqWbInHUdsfAZb7R8878Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RjpAj4HRp4hanF8XOmDk2Hz7iq9/yZIYRb/ILQ1NDZ4/V1kFX3A+wMKxdXt2rLmaZFVwSHnCbUxT7OtfrN+yTnnFfsScWAcVJ5WVeVvSft4BEbPX1/DbeXf1cQ/OpQNiI4o4pNEiLzH8cXorM5yyA2TrUSKuTrhfSS0Rz4x8xEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cLu+4wFk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qK6MPqvt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44MEnxED019056;
	Wed, 22 May 2024 16:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=YKwuzvr0F3sTvmfY+Zq4JsgVB29As/mhwt3KlI0/zRo=;
 b=cLu+4wFk7Jnu3544qQnHf/363GsYrJR3xXOBDziI8ZUpNvK6z91WEHezUTK/PsLJ5BSE
 8Fi7Qe/+58/dJLkWNbvlhkLJyYv2KvU4jjMGBGmeNaqSfKMW5rhheU4BpBiSdsVbJ8cZ
 eUkWWBKIZ2/gBIhFEIjZgSF+AkeH1A0gvPQSv7t5xBvAwprQRwutu7hxGlF5KqiafPoK
 K3MG/PPF14Z6ec7lgIfga/5AIzSQyZdHbkttBhHV106xj5bK8SnWahpo9WPDqj+V17is
 q/2WjHvccbQiSa+LH6b4pQs/ebd2pgeQrD+bzOgSFYXr7JPdPISET94mMjkro9+8wwG4 +Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6k8d83v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 16:10:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44MF2TmM036054;
	Wed, 22 May 2024 16:10:11 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js9dbwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 16:10:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCzN5eApj3uchuuVX2XY1CAbEOVq+ONmAA13ZLJHNhhMMWk6/Kd9yGu9Byc01pFrTUhUBQiduNvHebFXAmbs54dHcZW4hEg5YF+w2I8BZsSu60ebFuK+6pwQA9+CD/qYS5CwfAV1A/phLhGcayUB3lDIv6uh9YE4Vrt4HMXqNXIMSGSV6QyKJk141+egjYygEP/UIOpM62IIn981PHEoypJS84QxWw9257Fu+kmoNWgeUMA9RgNPIdgxpVk5o9OsROkVceKp+8C83xeovZjbQiFu6+4Ov8MAyimuXPfWBDQI2rCIVAjVlfQTVllj9yRlWrUU2utX1eXBurSlKOSksw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKwuzvr0F3sTvmfY+Zq4JsgVB29As/mhwt3KlI0/zRo=;
 b=F6FOFvaI7+wH2Egr5hQKrxYxbVd73zNlfpKVr8agygZ/c9ssKPE2kjAOsIboDlysC7H/rZhom/8Lf2LBmkQ6INfsnk0O/sLbkJasY9sZnHp1YC5yzWUFYzgdzrMDIutZy2LZhg0wnpn8MWyBhjG7A/HuiHDzxYUccWnVRyzKEnLkQfgq7sfDtkEzbSTyENNIk40fIFPkHOJvtiQ66G6BDeRbWPdExlXJSz28JwTMXNAd9RhpMFQ3TvcpcqyuI6bu5iETWvY4po8Uz2kS6YDxXnTuG9Oxb2hn4YzYUFCXJJ73/0GQP6f8pSZ3aL5PXiiUKVmbqlsNIuIxa2M+Aq06wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKwuzvr0F3sTvmfY+Zq4JsgVB29As/mhwt3KlI0/zRo=;
 b=qK6MPqvtorwqwO1PzmsxVKSD1UrRarEqxXDglHwDusves3Zwu/MU1p35zRM+3741ai67WfB/+caOMfTZ43N20l7mGHsYw1eC1M37XgvXSmCl9P2REbu+9Rt6yDjbScc7ly3AJqjEpfirymcq1lNl0Rj8iYgUoKe2PXGQSm8SX98=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 16:10:09 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%4]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 16:10:04 +0000
Message-ID: <ac660a62-a596-4454-96f7-aaef2da6c33b@oracle.com>
Date: Wed, 22 May 2024 17:09:56 +0100
Subject: Re: [PATCH 3/9] cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        linux-pm@vger.kernel.org, arnd@arndb.de, lenb@kernel.org,
        mark.rutland@arm.com, harisokn@amazon.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
 <20240430183730.561960-4-ankur.a.arora@oracle.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20240430183730.561960-4-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P192CA0019.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::8) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|PH0PR10MB5777:EE_
X-MS-Office365-Filtering-Correlation-Id: 18b833dc-fd13-4635-a90d-08dc7a79a3f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?dUlWMkIvbHlCQzlzcC9QaTlLMXEvbGVrSDFiSlpqU1RrS0hIb0k4UE44aVJr?=
 =?utf-8?B?c3YvbWJpT01pQ1FwcC8rd0d2T3VVSGxkRTFkTm1KWktDNmNYS3E4Y3FaMDBS?=
 =?utf-8?B?NTFla05wajlTSnJDZThTN1ZBV2NKVHdYbzdUWjBrKzlkaE9NQWxzbjRvcWtD?=
 =?utf-8?B?N25VMHdPNUFiOVhFN2VRMG9HTEZ0eGxoQ2R5SzVxYUVTUUxxWGkrYzhvdHpN?=
 =?utf-8?B?NFl4b2RnY2RlNklnL1dENWRoQlBTUWZBMG5HTEkrM0paT0syaHFyK2VDalRh?=
 =?utf-8?B?Q3U5VnNERWRKNldONFUveVRQQVh6NURiL1poNHlLRjJZREpXaDRFRitDeEVV?=
 =?utf-8?B?eTFWY04vdHI1dzhGVm5ya1k2V0cwRWZCSVhGR2JidWNjazRrRGVrZU4weUhR?=
 =?utf-8?B?cVBoVlNwN2lGdDRwK2J0VGt6SEVRZjJnbkZsSk9DOVhGb0hnaGMwRkdKZVhM?=
 =?utf-8?B?b3VuT3k0cjVEZm5QTW1TZTdrWkpuc0pwMlRjUzlkOXhoallxTCs5SExYdmcv?=
 =?utf-8?B?bSszb0JGL2UrK0t0Q1NVRHZwUGxPWjdJZFJKWHpETEJuRjhQWU4rTkJjd01J?=
 =?utf-8?B?UG5VM0tvTmdlMkZITCtVSE9sSzZVZU1xWTdCTnBMUEZYYkt1elNLZ2dqSlBE?=
 =?utf-8?B?RFNtRnRjY0FWTDN6NmtKWTNwQ3VaUmVvYko2amtVRnUzeFlvcDNwMS8xNlFN?=
 =?utf-8?B?cmNOcGpZSUpaeEtBc3VidU5uVjk4ejBjQVdweVBDS0tLbTFLNDFBc1ZYNmpC?=
 =?utf-8?B?MThQdWxsSzgrSmY2endyaVRTUEZLMkRuUUw2QWNlYUtlZysrUmczSUhuUnFK?=
 =?utf-8?B?cjM5VDJtWjlENFQwRm1rYS9Rc2dVbjZwSXNacFpIZ1N0b0lvQnI0cmtFSkdt?=
 =?utf-8?B?VVlzeUhjTU00RlNKamVKWjdVZDZycDI2UFpoLzRaNDEzdWVuZmYxNWU5N3d2?=
 =?utf-8?B?bEVoWnYvY2JYSzg1Sm13MmMwVTVPZk1PdHNrVmEwUXpmeG94Y0hVa3k2dGRB?=
 =?utf-8?B?WGhYWG5mVVE0U1diTXJQVm5EamVHUG5EZVMwS3RYRmhBODJwaThrM1VBU1Qx?=
 =?utf-8?B?QWt1RWdOKzhEOXo2Tkdsaysvcm01RWZtSnlZNlZhb2FndDhkUjczUnNHeWJ1?=
 =?utf-8?B?ZHFCckZwQnMyeWRoLzNBb0pjUDJkMnVuS1AveFp0d1RSdUtWRHhwY09aUkxR?=
 =?utf-8?B?VkZCUS91Mkw4ZUI3V2tFYnc0aDBLZ3JwU1YwR2IvY1dDeFpxSW5Jc0N5VnF1?=
 =?utf-8?B?NStsenBUTzZMbGg4WURiN1FzWU9jekhuSW9tdzZEVCtKRW5rVkp6VEErMlI3?=
 =?utf-8?B?cnpxZS9WSk51di9VeXRQUmdPM1FHZHZLNktUOTJuZ1luRVlHNWh4bGtSMGhE?=
 =?utf-8?B?NzhOaE44Zmk5LzFEYTJjSVJzYkN2eVFtTFJPY0RCSnZ0NDFoMGh6a3Arakdy?=
 =?utf-8?B?cVJMOFRmTG1CcW0wbFMzcERjWjV2U2pYblQxUjdZdC9aZDB5MnVxSm4zYXFv?=
 =?utf-8?B?ZmI2MUp2VUllQTc5RHEvWUUyZ21rdXZ4T1pUYW44dk1tamFvbDlCeS9Mb3JW?=
 =?utf-8?B?MXVqcjViYm1GQ3RRR3Y2RW5oTUxuMEpLdUVGbzl4NGU0T0w2L3ZiTVFtUDUr?=
 =?utf-8?B?Vnp3R2FEdXJjZGlRQThlSUE1QkREbkI5K0QrQ0dtdXcyYmtlbTBrb2dESDdn?=
 =?utf-8?B?YTNmWUJCTENtZDBnSWtvVW1nV0dWb1NjYnVwQ0QzdUh4TDg3NlBqdGxRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QVdCWCtoVDNjUXcwc0tQSk56ejY3Rkx6M2VlTWMrbzMwZDlISEptc2pPTXNj?=
 =?utf-8?B?U0lreS9iOERaL1c5aWE5cU9VS2NHejFsMWVTRm5XZDUxUGs4QmFOZjNXcW1w?=
 =?utf-8?B?RFMyTzN0WmtGS0FlQnE4SUNCKzF0cmF3RnBDaTZiejg4NGoyRFV2cDBHQmo2?=
 =?utf-8?B?SHVIdVNDazV6dzBqQmJ5WDk4MUwvV2srUXRCcmNsZnd5SkJhTXM4Sit3ejI2?=
 =?utf-8?B?VDl1aXJTMG00WHBGMXhlQjMwQ1dEMnc1Tjd1cHVDZ2t1bEVnSFVVcjRBM2xP?=
 =?utf-8?B?V3BkWlMvR010dkl6ZzBRSXN6RzNlNjFmYzBRUWtSbTdrUDFIblNpby9McEZn?=
 =?utf-8?B?R1hITTRpSVpxeHhaUGo2a3B2YkY4NnRQdGxvTU1KT3JoYytyTmZFdENXQkRV?=
 =?utf-8?B?NHphWVkzdC9jci9qNmw3dDExeE5pKzNVMFlZVG8xMmx0Q3JnTnhoU0RYWGpF?=
 =?utf-8?B?eFRYUnhYQ1JzaytzeU5lMVA3VnREV1NRV0YxN2FVRjdPME5CSUt0OUF3SXJS?=
 =?utf-8?B?VFY2OXRBYVRVT0FCRDBaMm96UWpNL2xFTWRUS1YzZ042YWNVcEpyUXEzTlRY?=
 =?utf-8?B?dS9iYjZIZUtodjhIOVQ1dVZJbUw4M1FMMHdzRmkrY3A0WkFSUFUySGlrNDlT?=
 =?utf-8?B?dEhrSXdTK0l2cUhWVzgydkY1S1c2WGIvL0d0MXgydDV3ME1SMVNzRWFELzlt?=
 =?utf-8?B?Y280aXQ0UjFHTE4vN0R2SVRqRzVBNTN3NG1Sd1lJK3ZOMDdURzNnM0FkNzla?=
 =?utf-8?B?dGYyTnJ5NW9xellTbElDcFRhdUFmRWE4NTJBejBnQlcvclFPSEFBWkpjQ3N4?=
 =?utf-8?B?ekpQZnQ5ZVEyVG9Ldkphb0x5L1g0QzhLSWl4aVRNQjlRZHJHL2lNU1R2Zytk?=
 =?utf-8?B?dEVTMGNQWWhkY1NqYkwzcC9tdDV5ZFk0KzdqK04wbnVOOUprZ1ZCU1djYlZ5?=
 =?utf-8?B?RnZYbFFjT3Jtb2ROb1BoUXZGbzF0Z1htRSthOHJacWNDa3RmcnZyWEo1OCtZ?=
 =?utf-8?B?bjZiOHB6SUJHYXc2VThlU0FueHQyZHhhVGdodXVhR0tnT0pQWlE1QWl3VmQ0?=
 =?utf-8?B?K24zSW51UCtJMkVzSkxXOGpadkNpT0ZCcjJiU3RDVENiemY5OVNOdjNKVzhT?=
 =?utf-8?B?R0JXS05tNm9kNTR2K0UzYkRpUHJCQnMwMnhucmlaaFRpMXVETEVFM0hWSnd6?=
 =?utf-8?B?TXJQaVBlTXBDT0xmMEVrQ0ROVEp1NzNpenFJQWVGYXY0elhSUkIyU2dqemhW?=
 =?utf-8?B?Q1ZWcU0rUnZiUnJPcHMyNXJZdko2ZnFyRE9mbFltM3V0OHRyUUlwbzl6Z2o2?=
 =?utf-8?B?WXBTOUUzdEMwQ1YwN0hjcnFML1N5ZExmVThCMTlFb2xlYmEya1Q0UG5FeXcv?=
 =?utf-8?B?VWRNWG04Z01PMUNHa0dPempvNndNVXBKWjEvU1lnaysxYXZaeWxUNEpuWWxn?=
 =?utf-8?B?SUlZY3Z5Nkg4N2pLbDlXYzk2VWdkMTlMZGhSNlJ6TEFyZG5VYStCM2w1OE9O?=
 =?utf-8?B?RU16YUYxVE9TdDhGRkUzMkpGQWxMT3Brd0p1OVFseFFGbUxFcTBPczN0Y3Y4?=
 =?utf-8?B?YXYzaFp4bFlzeVFRRzlqUXhTZ1hKSDBSMjhicDJDcEtSMGdZNkM4a3FZZzZj?=
 =?utf-8?B?V0tobThvNlMwNFhpWnpmUlVjSTVNaEhiemlaUGhMYm5RZ3YzVWJQVktIaXVP?=
 =?utf-8?B?dTZGemg0RTR4TW1ONEYxM1I5K28vYXZwak1qQ2h0YmNram9XdjYvUVFlaEZT?=
 =?utf-8?B?R3lkQU1SRThqdkxtSEFnTnh3c0V5N3RkbWRkZlh4eXFiTkViYW0ya2FTYUlq?=
 =?utf-8?B?V2g5djNKckdqUXNvTndRVndVWTd3M2FISUk1MWpvL1ZuT3NPMS9RZ0twRjYw?=
 =?utf-8?B?RE4yWGh6MU0zUFlDS0tYNU9MUGd1M1RMRCs1cnlaSEtybEZ0anNHckJ6aHRD?=
 =?utf-8?B?ZmxTRnhyaHd0OWZhVlhmeDZDV3crT1JMWHlKYmhaTDdORVZmejdEb3VOaW5i?=
 =?utf-8?B?MXF1N08xV1ZmamZkRUVYNUtXNVN5bFJJMUQ4ZStQbDdIYU95eXljai91Z3Jl?=
 =?utf-8?B?eXJZMUJNMklnQjBheWJkNHBpc2VuZ0s2RERCY1dDMjA3QTFHZ01CZEdZYXVZ?=
 =?utf-8?B?ZGRFZWY0elFyT3NOVjBValdFd0Q3MWcxamtvbFoxdkREc0VaY25NNllsd2xD?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	b6D5l2zvCSICwJ9aSV0HLO1S7Z2jic3EHBTXfP0RglrUE5YqOEIWIJkcbrO1uKN1IqkGBQats3r5gLPDUdgp3M+ahQrWr0XV6aTZO2xi8IefQgeV/HI2BRj9yhxfQzP2R4A1TwuNVeIwQfCucIwCoQGfgXMZQtMlqiKdHiCxSqW9W74pfRamyZgSeqMjsG59Qo+e5wMMwX4dyQHovLAA6go6quwATYa6LjaUNBEhIy3cKRFHeb8BWhEdVPQbIX0E5VymKDPC7yqgNggScyOP7sUTjGagLb7p/YBSa8UmL/WkXjwfIP8UanNRpxsHcWbTnGXmTYQcYUXwAa/pbkPZEngkUHdTcFOgG4XkP41XWJV7OkPtYJ2riMUbysYskxngA6nvZ/Xce43C5adApYaURe+4oOw4YnBXTYuuuH/w4tgEJb8j4BlJSD/hyb8LuH+1M4mEW1to1Qf6jwBmG/wPco37NNK3DLJOzLJ50XaSw9i92UWCtcdjQ2rkNz/QSVIEQXLoPQnN/rVcEoqwIjc4od89CMPDRdquq91/ErOOW5ffq5q8MtZt4OenmnDxjvgam8nLKbr97BuvtmGdZYCsY/JV8VwTEDeF6kbPryzlZfI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18b833dc-fd13-4635-a90d-08dc7a79a3f8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 16:10:04.3027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e3HzaJlBRq/NRu+7Gp/vkQHTmzpaqi4P5BLhggnn3UIg3frBLSsVrTcGRgIeAeCPkpInF0Vr851dZqJl1c4A7rUX7z+MlyVF4tXlkQtkjVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5777
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_08,2024-05-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=872 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405220110
X-Proofpoint-GUID: 0bcwVDCt4d2Z0WcKEhR5emOCgcrs_9Cj
X-Proofpoint-ORIG-GUID: 0bcwVDCt4d2Z0WcKEhR5emOCgcrs_9Cj

On 30/04/2024 19:37, Ankur Arora wrote:
> diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
> index 75f6e176bbc8..c1bebadf22bc 100644
> --- a/drivers/cpuidle/Kconfig
> +++ b/drivers/cpuidle/Kconfig
> @@ -72,8 +71,8 @@ source "drivers/cpuidle/Kconfig.riscv"
>  endmenu
>  
>  config HALTPOLL_CPUIDLE
> -	tristate "Halt poll cpuidle driver"
> -	depends on X86 && KVM_GUEST && ARCH_HAS_OPTIMIZED_POLL
> +	tristate "Haltpoll cpuidle driver"
> +	depends on ARCH_CPUIDLE_HALTPOLL && ARCH_HAS_OPTIMIZED_POLL
>  	select CPU_IDLE_GOV_HALTPOLL
>  	default y
>  	help

I suspect the drop on KVM_GUEST is causing the kbuild robot as it's
arch/x86/kernel/kvm.c that ends up including the arch haltpoll definitions.

