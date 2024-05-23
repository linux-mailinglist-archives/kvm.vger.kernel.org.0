Return-Path: <kvm+bounces-18069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF118CD8EA
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 19:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 973F71F22558
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 17:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56F17F481;
	Thu, 23 May 2024 17:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hnuYLmg5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="psWWbb/3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1731674E2E;
	Thu, 23 May 2024 17:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716483859; cv=fail; b=p5P4DDqZUFQp00i1OJ5pqi9Yp5pZxmaLkVGjib6gGceg4nf29O99z9PEXb70RSvHqzWqgSkMI/XOWMstnhkS96cRIh5u1tcrXL9tew0UGp+IPPpFGkGbCdOR45O95t1lx4Ngi5Zxc4qMOMyl7y/vl3QwqvI4KD274Z+kBBPh0Ng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716483859; c=relaxed/simple;
	bh=IOALea098O3EZLD6pJEFy+0ogbRPl/H7ZbWVpykFd64=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RGSE3b5XyPX6xgNstcTEoe+KqoElwNHwiMiWONCERYd1Ofo0Xll5j3e0h204l/kQ2ul3MNd0KEusqYwwowXH52C54Ej8q2xFGbt1z0Nc1WR0EjiTDvaykXtYTSRDN5z7voz4haCrBjaTSu7wFLWseZhw4pEgJhAtqHnWAR0MBuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hnuYLmg5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=psWWbb/3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NGscwa011918;
	Thu, 23 May 2024 17:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=YWTutBQeO7eifcng0PfekgD1pjT46LCgGELg9QilaaU=;
 b=hnuYLmg5KdK+XfjpSDMliJ7CMDRlcvVP6Y7bBJfm0ZgLLRHjKREaGptGjZCCXf0ELTw+
 UylRAftAMU/AF8UDteYfI88FuSJxqshNMvBLlKzG3C/Wl/TcPwxQ2RJLVqv4OIU8QKw0
 29GYNWaGF++1cBWpBCxAiq/yLmdKOlKH8LSsfUdP9pLsiFCw+/4kaSAh0AW2qim+DmLd
 binpyGUOM132eFfNdgi80ZCwjm1vSJkl7ul9rAMtyTfxM+jnoR4cbMGg6L4UEp1sHNHz
 iQNX82U+MJH3h6C+OOFCcR7rNdg3CcqSyDR7bY4il80GWF2aEMjPjDi3cz1VkRo5sLYN Cg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6m7babv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 17:03:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44NG6qYC002820;
	Thu, 23 May 2024 17:03:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsau6mr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 17:03:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKb5OA+v85SBJNmI9xT8qKFznJaFuJNGH5VudI9H+s4sXNMQhrCd7xy3X1l3oJvEtSSoadV/giFJgeRRaE269S+fio1mqb5voxbwxFC/11vYPo3DVa/PkfX0pa9sX4mwHMsHnlmFhSkOvOJKafMDymf4DRKOCxxnjmZmgLDgRZQ0VPft6+U/jfz+Ywf1BjACd9ctvo6TUSj1pj0QZCpO2G5cL08YhOSI64diYRUJjtwXPI9TVZqcTe06QWN7bwlzOzivRJYmmPaiZSTaQvYbdHBAzZZrEYECA9rd5IQ+Rj7HuOxGIoZsE3Xqgy9YkHXVZyBht7d0l+3PmEU8ntnlHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWTutBQeO7eifcng0PfekgD1pjT46LCgGELg9QilaaU=;
 b=csN8hmMGdENDaL+BBPfNNLfAHdPdnl6Gimw5MG5G0LeXdwUo890CtYNohoudDoa2e7VskmB69Un6UBjs3usPrCgU9u49b583RR4EYuZDHLRrFVqgXaLij0UGqevf21DMsa18NyRYATI2ZDJv8k7WxXnrOFeeVDnD4sPWiKfjNBow4ikdXEaSSf9VFq2q8i9i3eWSoNaK3ywfk9nLmU68/UoB8kSsjymAjKCcTkJ9bIyWZQS0JvaNP6Pm46K70w6h7No8fkhLTrIg2Ott2gwOK8exGNPFzuAbP4JvuXDLIm/6Y0wzrDd8wctZcft7W622r3WPjRHxMAZEohzC8p+qWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWTutBQeO7eifcng0PfekgD1pjT46LCgGELg9QilaaU=;
 b=psWWbb/3US7YVBdj9ASsIj6/RAiYXfr6YFj7YNEZVlq2G6B+9XyEFFv8rcrKTJbj4VeD2eO6jI/O8/6hwQSX4TLmuBWXsRipObtSrZcECFBoXw+Yw9XxvFIy1DpZ80F7s/AhsoDuT5CMqqhr+03Z63roRYBXjkeKHxDrllHD8aw=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by LV8PR10MB7798.namprd10.prod.outlook.com (2603:10b6:408:1f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Thu, 23 May
 2024 17:03:26 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%6]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 17:03:26 +0000
Message-ID: <5ed7d3c8-63c3-48f3-aaeb-a19514f4ef5e@oracle.com>
Date: Thu, 23 May 2024 19:03:21 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        andrew.cooper3@citrix.com, dave.hansen@linux.intel.com,
        nik.borisov@suse.com, kpsingh@kernel.org, longman@redhat.com,
        bp@alien8.de, pbonzini@redhat.com
Subject: Re: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, x86@kernel.org, kvm@vger.kernel.org
References: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
 <a04d82be-a0d6-4e53-b47c-dba8402199e7@intel.com>
 <1c69f62e-0dee-4caa-9cbe-f43d8efd597b@oracle.com>
 <93510641-9032-4612-9424-c048145e883e@intel.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <93510641-9032-4612-9424-c048145e883e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0015.eurprd04.prod.outlook.com
 (2603:10a6:208:122::28) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|LV8PR10MB7798:EE_
X-MS-Office365-Filtering-Correlation-Id: 29f91c45-f152-4b55-c64c-08dc7b4a4336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?dEdhVnNuUEhZZnBwYlJlSWRWL1lLeWxEL1NTVEdVMWpoam10ajlRSzZEYXVk?=
 =?utf-8?B?T3pidmEvSzkrU1h0U0V5MXUvQWZpUEFQS3ZxUlp2V1M4SVJ0amt0MTZ6THhC?=
 =?utf-8?B?ZzU0cTF4ZU5aMVI0T21LQnJWNE5TVDJRVE4yRENZZFIza28zSlJYREF5OEhY?=
 =?utf-8?B?UStUZ3VBdXVqdkkrOUFucGZhdXZOaVZ4WS8rS2d5dmZlenpLbTIxd0g3dHZk?=
 =?utf-8?B?TEwycUl2ZUVkR01LcGdNZ3hXT1RQUjJRa2UySjhKMndTNVB5V1RrYi8vN2xu?=
 =?utf-8?B?cnptTnF2QWNTREI0OUY4UnI2bEFyMmN1eW4yd3JlY1YzUko5QUJHdmNTbjZX?=
 =?utf-8?B?N2l1UU5oSndiOE1CZnN4a0ZqZmt6MGF4VUt4YXBBTDcyQzlEcUpneUNFYnE5?=
 =?utf-8?B?TStwclhCM3VrRDBBamFoZXYrajgzT1pCZE9UNjlHTnlydXBHb0JjNS8rWUhp?=
 =?utf-8?B?L0I1R3pIUUo1NW9tcUlNcEZrU3VVZ3pXdzhJMHQ0RXJVVmhYN2xxYmdOM0tW?=
 =?utf-8?B?VlRrNjJWREw1ZWx4ZnI4aWtMV2tZWk5pakZld0pJd096VUtnKzFwenYyNk1k?=
 =?utf-8?B?K09FbzVqckxxWE1rWWJYMXZmOGxRR3dWcHVXWjB6aHRPeitCdnBvUjVXd243?=
 =?utf-8?B?dmsxYkhpZjRoZjRiV2dtTUppemxsL3gvMjlOdlV0dllCcFBDeTdFd2tVMHg4?=
 =?utf-8?B?MTJWUU80YXVwS3Y1RTE2T3ZzMUkvMWNoVmQwcWZ1VTdIOTNjKzVVV2VKVXY0?=
 =?utf-8?B?NC9jMGl3TWhuVDZuTmF4bng3Uml1OW51QW0wdFFJQlhoTHFIWlVFWkp2aWpl?=
 =?utf-8?B?ZU5XQXFBcmNzNXZJWGM4eEpjYjlucWplRTkvZUtZU2F0cWRuTlFpcm81WExs?=
 =?utf-8?B?R1NKS3BlRWprTFNvL3JHZ1FvY082NjBUeXE5NzdXYUFwUEw0enZickwxeFMr?=
 =?utf-8?B?b3lTaXFCcUZuS014RkpYUm1oYStwQytjQTI4RFdscWJpMnBncmYvU2RtWkdS?=
 =?utf-8?B?N0pIZy9hQXR1c3NrU09ZM2lUeVYyK0E2M295ZzladXovUGFLU1B3TUdTU25h?=
 =?utf-8?B?NlN0cFlOcXNjczhJcmp6ZEVEY0tLNkpWTmVkWmdoR05icHVyYUJwT0NvclRH?=
 =?utf-8?B?Sk5Eem5HU1NxUXJ2YUZOdlo4ZzAzVFZUMlNrNU95RWFuQjYwNzZMVUl4V1pF?=
 =?utf-8?B?Q3pJckN6Nkw0ZGRRUUVWcTNlZ2JtT2lDUjdxR2IwMEVteFU1RHNRS2lWenVJ?=
 =?utf-8?B?bFU0VTZXTm1rZHFCVEFNVVEzK2tTODAvdlJwajBxN2tGcXVlZmVGMUdINVVD?=
 =?utf-8?B?OXcyVUZIaXRUSTdyVXozWFd1RVh2TGI2SFZZbW14dVZScHVFTUhGSFJ5ZDF6?=
 =?utf-8?B?UVUwd1dLUnhDWXZqc0lUMnlnSWpFaU5sWGxXdzU0aDI0ZkhJZXQ1MlZJRmV2?=
 =?utf-8?B?K09tZDU3YmFyNlNIQVNSOFNWL2ZZQ1F1OHlNcTZkc0VvaGxDSGdCTHNDSkNI?=
 =?utf-8?B?SzdycGpqTENtQkErMEo0WFI5Q1ZPMi8xUURaMUptUkNLWFNFSVlISVlLOXBE?=
 =?utf-8?B?aWZuK0xYK0VjMDlqSlIvRWY5Z2N4cHhvd2NCOTZvbXJjUHhVeW1oSnAwSktG?=
 =?utf-8?B?Mk9SeHFnL3g2ODZLYnNxQTBFNEJadEpPNncyY2JWUldCQzk2SFgxeHBZMzhZ?=
 =?utf-8?B?ckxPOG56TFo0WmJlK2laVUMwckYwdjFNTVh5RStzZjNkQ2Rwdko2VEp3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RFZtOFl3OXpvbEduRWt2aGJYY1hVeHJsSTE3OHpqSUxiZTI2ZWRIcExsZ2Z2?=
 =?utf-8?B?bVV3LzJtMEsrV1MzK0VFa1Y5S21xL08vbXowSmZBUmErNGxOMmlDQ3AvbStP?=
 =?utf-8?B?VW5QNWh2bzVrNWR3VU5OS0dtaUsxRjVRY0V0VTJ4eFlONGdzcyt2K2h5NjJj?=
 =?utf-8?B?YXlhbUdVZC9tbmRkYS9kb0tNeFFFM08zbmt0TnkyWEV6MzRWdlc3Tk5lMHcx?=
 =?utf-8?B?ZkJ4OWVieTV6eVdKSityNkE0bjFncUlyYW5GeWlSM09mN2p6ZnErdmNwK1hz?=
 =?utf-8?B?L1ZCdmRBWlZURWViaFZ0anN5Yzg3STJURys4NEFadjR1cXZKbVZnZEIvRmhy?=
 =?utf-8?B?VnlHSW9UWmFRVFdBN0hXc1lDZjgxMEZKbDJEQkJVUDJMSTg3em5pNDdQSmF3?=
 =?utf-8?B?amIyRWpmNDJOTEFZSHRtV0RXVE9FNEhjdHZlbU9LZDdxeS93eFlVS281M0d4?=
 =?utf-8?B?ZlJpajl3MTlZbVErOWJSNnZVRTFPQ3M1VWU1Z1FwcmVxVlo1aDlZWGFvNVIw?=
 =?utf-8?B?ZUVtd0EwS3BQNnhaMUVVUTFiM1Zld3FwbzBqMkJ0bElSWWhUSUg0RTJPSG1n?=
 =?utf-8?B?bUp1T2ZHc3hQVFlTVEVwa2JmRWUveGYrRmdnL2FKZS9hSithajczWVpkTTVp?=
 =?utf-8?B?SnFKako4VTU3b3RlS1l2aVBtN3MzNEhRYkNCM2ozZFU1UmlNSEpDdys3SE5W?=
 =?utf-8?B?MlkyZXlwYzdYeU9WeEJpMk1uOTFEcVRRKzhzb3FjOTJuZjU4MlEvSnN0SEFl?=
 =?utf-8?B?WCtJTE10VzYwYXNwYXlqNWgvaGQxSUZET0NtTkRqd2JLamdGM09ESTVmaGVE?=
 =?utf-8?B?dmFOZVcxVVpobFFCVkpJOW4rTDRiSklQR3M1dlVUTDdJL2xENjM2ZzY2aGUx?=
 =?utf-8?B?MTRVcm5uelVBUDFjMnNkWGNDVWNoN3owakQ1NnJLVXF4QmFmdGxISmdtZEMv?=
 =?utf-8?B?NDRDRU1GclV0cWJWWDVrMTZXN2tOc1M0R0tjY1FMSlc4TzBJODROK2JrekhB?=
 =?utf-8?B?bEszRkJKY3Z2ZHcxd0k3ekNvNDlvaTRORUZhK0VteGIwenNVMllIZ3N0UTJ5?=
 =?utf-8?B?VXJLSSsxL2JPS1hndGlVQnRqOCtVZHpFa1YzdzVoNFNiRGV5cnU0R2VQZWVv?=
 =?utf-8?B?OGE0Um5YcnpEN1J1QzVqOUp1U0FMOUxjemRVQk9TU1RhajVCaTJ5TmJHTFNs?=
 =?utf-8?B?T3phWElSbGJnZGRPMDNQc2ZWbFcrUnkxeVRITjFodXlxcDRqNmVWR1RHY1Z0?=
 =?utf-8?B?S0VaZkd1dzAvN1FWckFCcnlxSHVvTDNESTduSklvVTMwNWRQY1JNaU5sY25s?=
 =?utf-8?B?YlRoTFF3TGpTWVN4enBUUkk1ekt6M21MUU50b1lOSGJDVmdPRHlDNWdQM1d2?=
 =?utf-8?B?b0JPQkpOSGpJYmhWVk5zRmI3bGVTUHJWWUluaHRLNFlsbm5JNTl2SUt1dC92?=
 =?utf-8?B?WG52ZGlZdjV5VEZsZTIxbU9LVmFYRUw3Z1h6QU1DR2F3NTN1bDBOVWYzWGNm?=
 =?utf-8?B?MkNIUXVVUFYrSU1TY0o3YzFTUXlocjdJMzF3SGhSL0lLR2RFeVZLMzNUY1VR?=
 =?utf-8?B?c0tSWGdSdkdqNEdGYllNeW9nSEF3TldieDJEdXRZMXpvdnJ6VFZGR1dRWFMx?=
 =?utf-8?B?RUdYZzQrOEoyZGdXWmxDNjBKU0VLT2Z4cVI0ZWExMURsRytHbEM5OWxhdStp?=
 =?utf-8?B?TGp0aXU3Y0xKZUpCWXFwdmZDazBZNlRySEcwcFY0c3RyL1h4eWx6VGIvZ3RP?=
 =?utf-8?B?YTdhUzBPUWtqRm4xT3dLZ3hTNStEN0h6RkNVeWFjVFVNclVPU1NuWTgyUU41?=
 =?utf-8?B?VyszZnNKR0lWR0h0dTgwSjBJK1Vvc1YyY1Iramk5NnpVVmY1RjNCQmI0Zlg1?=
 =?utf-8?B?ZXlXOGM4R0tzNTBLMGI5QzQxZ2JydVczTzhCUVpuVnJ1Wmo2U0J5UkJxaU5E?=
 =?utf-8?B?SnVGdHQxR0tyR1ZGcUplRDgwSjlST2VRbDZDNFJNc3RyUkt2WXNTdm94andI?=
 =?utf-8?B?bVRqQTNIWkZwb282eFA4V2VjYVhmM1FTbTU5RUllZC9RejlqWU5hRU9SVTgz?=
 =?utf-8?B?WEtjZkFpbUFBbWd6Y3pScTdCMy9wQkRnL2ZndjB3VmRFVStjWnZ4VzV2dHpK?=
 =?utf-8?B?UVRCT2tYSXBOMmd3TVpnZVdWYnNKaEs4Y2M0Rk9lM0d5d2tqUDhiTndNc0Zv?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	wO4um96xsgo2Pj6QlHzVwk340J3oldvNCGx+0NJRZlvOyMrEt5fqclS5EEasa8BXkcIwUfG4uFW2lkIYOtra7DV3gjF9djfZ3osxX8mt4PZaPt4Tvy9tp8nBoSkR2e6u5HWBp03iE9dhL9FdSSiHyBbRqh12cBMMWbMfgQojNSktm5HVR5EaHPPj+Sde+ouO49+cp+3IEUgShZyIEF5fxYYGQ3IUHAtiRlC9szDnF2k7+ysSRUfXPMZWalaQ5H64KKchc2+gVI0aWFWxqgzgrrspp/Rle8f7Bh+TUS2xZFiVaSnSqwDU6lZYjvbryCkUK6MJpq39uFMTSBUGxRsabjN0KTgOC14NbfvbiLJBSEZukSdyMgMQbQzc1LHOiRj/FP/Ke1FmZi9gm7L/lTB06klWAGc0ZcAAWnH+EBXFbRFHxumeDDCN7GpDOeAJqkH8kmRv0tVb0jg7cicbEPxvLx81WKScQql5jpEDtqyEHLezBB1/HdaNkXeR2d5en+8indaBNs2IisKEX6npYzQ7flxGBGla5uicMwqzFX5LF/wlW96U3YCC3dgBoHkrGRBAfV8xTCrffWbFPlDlOm3fnEsHl5ivFaUbAzgRdhJ7ZGI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f91c45-f152-4b55-c64c-08dc7b4a4336
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 17:03:26.7554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g1xm7ZcH+iCt3iUxSwyn6lRD3bEwlhLnR4hhYf92l+wpxqhAKNYSIzqr1nmG8eszyPC0pUKkY83NC1ju4lgRsqYWLQ34sUCZwATibTtW0Fg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7798
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_09,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230118
X-Proofpoint-ORIG-GUID: r5DvVmC3vTp9V-qsrt4DzlP7Ne1-SdsC
X-Proofpoint-GUID: r5DvVmC3vTp9V-qsrt4DzlP7Ne1-SdsC


On 5/23/24 17:36, Dave Hansen wrote:
> On 5/23/24 07:52, Alexandre Chartre wrote:
>>> Should we wrap up this gem and put it with the other entry selftests?
>>
>> It looks like tools/testing/selftests/x86/single_step_syscall.c tests
>> sysenter with TF set but it doesn't check if the kernel issues any
>> warning.
> 
> Does it actually trip the warning though? I'm a bit surprised that
> nobody reported it if so.

single_step_syscall does trigger the warning:

$ ./single_step_syscall
[RUN]	Set TF and check nop
[OK]	Survived with TF set and 26 traps
[RUN]	Set TF and check syscall-less opportunistic sysret
[OK]	Survived with TF set and 30 traps
[RUN]	Set TF and check a fast syscall
[OK]	Survived with TF set and 40 traps
[RUN]	Fast syscall with TF cleared
[OK]	Nothing unexpected happened
[RUN]	Set TF and check SYSENTER
	Got SIGSEGV with RIP=ed7fe579, TF=256
[RUN]	Fast syscall with TF cleared
[OK]	Nothing unexpected happened

On the console:

[ 1546.656252] WARNING: CPU: 124 PID: 8413 at arch/x86/kernel/traps.c:1009 exc_debug_kernel+0xd2/0x160
...
[ 1546.656352] RIP: 0010:clear_bhb_loop+0x0/0xb0


alex.

