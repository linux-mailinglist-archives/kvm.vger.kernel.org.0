Return-Path: <kvm+bounces-23600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1708D94B6F3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 08:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B07F1C21E2E
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 06:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB15187FE8;
	Thu,  8 Aug 2024 06:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="azB0+uHy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EjXWWGxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0C25228;
	Thu,  8 Aug 2024 06:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723100007; cv=fail; b=FUXhZqu38dTmoGzx7xB6KfPp/dvaS/qTwrUa+lAxOkCYhqIKtFGSa6oOy3lOYwPDlds3D5rgqtLOtqVmz8aqUZi5Kbasr/lRW//vD8FbWGIN17Sr6P7j9on1QJK30HIkiX1wJtReplM2hFPutTnXKQiaiOid9XldgEROCkxxBzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723100007; c=relaxed/simple;
	bh=YrHnIWYOnp1+gMVsZiVzBW+oeV//9YXuAI1jBQ1lUKI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f3tt8hiEzpDn8IYqMWsh2SpWgXCKS24MuLt+98JNhGg5qWWPUZKGDDM9Calh3NX9aTj3Rrb3olHNTGyBA0yOeQl8U1KSIvYh5ljTJeWXxLldcKKNfT7Nksn+BFewttah3NVCwEbycXAvbRMefY5fVjhmm/RM4VctbfZcKCmLOEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=azB0+uHy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EjXWWGxZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 477L3P1A031112;
	Thu, 8 Aug 2024 06:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=YrHnIWYOnp1+gMVsZiVzBW+oeV//9YXuAI1jBQ1lUKI=; b=
	azB0+uHyAevYx9KEyVcGX2D0VHCvFX8Lm9L6/2VPUTQ7U28hd7AvntV1KCtSDCUE
	8Chwr3Obwb9JC057FgIlQs/V+m08gBjSFV7BxVqU6NuWwOnUfUUgXtNaN6SeweEw
	18OF8TNuA3vXhQJs1bp5htgjRTm9mti6XxYCSyTxoTdg0eY4uwwR8MSmgxftvXiO
	Qy1zkRWwRWKxpv5ilIU6ZDVYt6m/xNVVa/DoTFlrWbCbtHvFqLPmvvDm1rHBCmFI
	VAJW+OBoHyr6Bv54PLpqPKU7qHrVHEq2ixoVfBWRIpF1R10NI+YPABs2bvdAWB28
	bH9Dx+t2hRQN7VbIjnYBqQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sbfas73c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Aug 2024 06:53:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4786aCLB019711;
	Thu, 8 Aug 2024 06:53:14 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb0awgcc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Aug 2024 06:53:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+BT7bYDBZtzlbVKoqSt9lXScn982KFgKv+6l212sKf39him/E5dUo1t3Fj2B8fK0um13hUQnLr1l0g2HaAKHW9AEqBy99ah9dbHTctEsXYB6Z9BQdQLCosA5df9ELB3R4zs7geV1D88ac/lFi3pHbAOenpSpriQiGlrJTPTqSAc03Hjxf6BmrpdZ1YbeeaeUzG8bs7CP3A2xzMPbGz2U4pHOtebMTbe9+mmc05Ra7fH0GHkUMteTLCNCuCfaz8ddNqGBSLH5iDDm8AuUbzA2Rf8hfSDTIS2Qi0Wx30TDUcwImwQa7EoV7xj1fSwc/XcjMEbi0Q/BHVTloTvPhQvKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrHnIWYOnp1+gMVsZiVzBW+oeV//9YXuAI1jBQ1lUKI=;
 b=k25aYNb0fvAdWFrBZAXSIZJzd8CwrcDkrQGtgmv56+Ykwtbpvby1vYBgYTWfEasJ378aRfAi7JxjuY1xOk4DGZMvgY177lYiY4fc4ZkQrSz+csXbvU29dc35k4EWvMsyrD0K7w6NE/4ANFC0Ii363twggin4B0GaPgvVnRP5FsHlwy/w05iMAegarvwo6JqLAKCmmFJ60spKPqZ9DEzPKrlkvIn1d4vmx2+EcAVY0um+thsvOmYhwUosJ0B2KUbpYGGvwNfA2Ix5M0NTd4Uq2YlnL7C3dc0qo58HdlWQfRj6TQfhxQbYda3UPWMKx07nHr74uG7oxl/Katkg85zCeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrHnIWYOnp1+gMVsZiVzBW+oeV//9YXuAI1jBQ1lUKI=;
 b=EjXWWGxZHGZ39TnsU7nuEiukSTJ/EvzddKma4pPsGUzC7UDOE3mZZsevYprGcEUniAAdp5veRnl++HyMdkAArf30k9lwPbjA0CG9dHVGNHer/fMqg4oBaMp+0DukyrC1p6MOcXxbHis5U6quCHbwE9SKy+X7xhZSFNMzG6YFHwk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB6698.namprd10.prod.outlook.com (2603:10b6:208:442::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Thu, 8 Aug
 2024 06:53:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7828.023; Thu, 8 Aug 2024
 06:53:11 +0000
Message-ID: <9fb68fce-1757-4aa9-bd46-3508be9f65b6@oracle.com>
Date: Thu, 8 Aug 2024 07:53:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio_blk: implement init_hctx MQ operation
To: Max Gurtovoy <mgurtovoy@nvidia.com>, stefanha@redhat.com,
        virtualization@lists.linux.dev, mst@redhat.com, axboe@kernel.dk
Cc: kvm@vger.kernel.org, linux-block@vger.kernel.org, oren@nvidia.com
References: <20240807224129.34237-1-mgurtovoy@nvidia.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240807224129.34237-1-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0012.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: 20a8c309-b306-4f2b-9d57-08dcb776c4c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnpaZklPbm5nWGlrRzllM3JkNG1LM3BuZHhHcmlMMGt2ckpocXRqU0ZHckxS?=
 =?utf-8?B?NnE3c3I0azFOQk9YNSs5OTZEaWJlQXJzdUdCalROKytLRnFCNWVyNmRkY3BZ?=
 =?utf-8?B?VjlMYVNMY3Rqa2xqRU9hcWJkRVdRS0IrRnlZVlZ2VkRxMHF3WmIrbjdSalhz?=
 =?utf-8?B?UHJoKzdsMWFsK2ZtTnFwVENMWG52c1ljMFN2eTJhLzBnc0Y0QmhaV2I5aGVL?=
 =?utf-8?B?RUY0aGJaeDd4d2RwOXlDU2IrY21RZnVHY2hoWVhXMnkzNFhVa2ZvR04xMVZD?=
 =?utf-8?B?MFdhR1NwWGJGeTVmQ0FPUXVLNDA3SEp4ZjM4SzFYREk5S1gyV3c2aVNCZHIx?=
 =?utf-8?B?V1BTcEFqU3Z1WWZnT1l3emdUL2JkamZPZURWRE1lREZrN1dJY3pab2xDU0Fx?=
 =?utf-8?B?RjVZWTY4UjVYWXBMZUtmYzNVcG8yTmNaTFZvRkF0RDh0S1RKZFY2OG16Mzdr?=
 =?utf-8?B?YXcvdkxqLzNaM2VneHRiMzd5dC9oYUUzNXJmQ3g2NUZNTDNCSjBkRjB3TTRv?=
 =?utf-8?B?VERoSFc5ZklOaVNEUWFPNFFmaWREK2VxQ0FHL2hiTHVoL3ZkL0gzUmhtQm5U?=
 =?utf-8?B?TVNvZVNSMTRQanBudW8wdUM4eFRyT0JsWll5ejliYU9LWmtZbGVUTEk0WmEz?=
 =?utf-8?B?dFlOb0llNm45aXFxTEY5TlB1Q1NmazlMQy82ZUxzWkJBZENTY0FCSnZmTkpQ?=
 =?utf-8?B?azZUZ29JMDR3aEp1TkpUTGo4TlMxY2MxRm10NHA2cEhGSm5MTjFOOGpoOFZJ?=
 =?utf-8?B?b2tOOWNzMHpBOGpJUHphYnYwR0xIZmlMb2N1SVBIU05tNy9RK2pLNUJIZmR5?=
 =?utf-8?B?TzZnRmxldGZia0htb2dndGIzRGg3OURHczNHemIyOU5GUzdQNFEwU2J5Z1Ro?=
 =?utf-8?B?ZktrQ0ZKQmNOQ1F3Z0FsMUJ4ZThQZERtK1ZPK0ZiM3RpanNtQWR0UkNrcG5h?=
 =?utf-8?B?UHNYQWxKNVZBb1VaeUtjeUg0SGZaM2hyZWt3K2ZQekVMaG1IZ2xwb0VoMzVB?=
 =?utf-8?B?cFAyMjBzWXRRMHJ4dkRiMFQ0ajJncThSRE45UmhkYUN3VHk4WjdBRkdpZTZP?=
 =?utf-8?B?MWVyQjdyNmp1U0JPdkhTdnQzc2xRZXlOQzhhc3RDOU1TSUVjaWJsS0ZmRW1Z?=
 =?utf-8?B?VEJHbmM3a0JHcysvNHBlc2FMYUk3ZXNMZmdZNXR3NzZBRlY0UEhjVGhMZURV?=
 =?utf-8?B?REw5MFgycTdlSW82OVpYWkdGOTFlZS9tOEZvMnQ1cks4K2YyT0MwOUdnYjFF?=
 =?utf-8?B?NlZCMU83S0dMQm9FZFVZRGpQUktSelJ5cTd1ZHVnbW51OXVDUERYTVBlSHp0?=
 =?utf-8?B?Y05Ld3BLQU5oSzBIaTVwY2g2QXo0cDQvcmZzNml3SnBpUzhkWUJaQkFzdWRH?=
 =?utf-8?B?MFYwZkJmZ3JwUWMySkJDOUowcVBhdTJ5a082VWt6RzBLNm0xK29xS0llV3RZ?=
 =?utf-8?B?N3Y5bURoNjQyYmo1VnlSTGw1dmN6cE04VmtYS1lTY0R2enlqZjdSU1NoNjBz?=
 =?utf-8?B?TzJJNENPM0ZmbGtUWDM0WHZNMzZTSzRXaExsbHlZZERtVkZIZy8zMzV3NkRn?=
 =?utf-8?B?MExUNTFrZ2JPc2NyZk9rM3ErcHBnRTZtVkZRanRvUW5VUjgwSlZXaU1zcG5t?=
 =?utf-8?B?bisrQnQ5TDM0a2lNUm43VWk2QXBtamtmTVAzd2JueVJrQjczb3lkN0ZYU1hy?=
 =?utf-8?B?RURtc0k1NzVvb2lHWURpeWw3QUVMOTc0dC9EbVRoaTJTbTBKSGJHaWx5V241?=
 =?utf-8?B?TFo4N0lLWWQvdWZKcS85c2xOK3RTM0tqQmtPekJGazF3cllSbEZWVFRnZzZy?=
 =?utf-8?B?VTRkL0ZZditHWWt3eWt0dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2w3ZkFyMS9HUkFWV0tuVUdhS1FWb1JQNTl6NllTSk40MnFZdFR3aDNwZHg0?=
 =?utf-8?B?bWM1ZmZITU5zWWZSNWwzYnN0K3BLTklnZ204SXZpTjRaUFhnN1RKbWpkQUVL?=
 =?utf-8?B?ZnRad2NJVTRiTFdaeENVQ1NucHcrTTV3aXZGUEVlZVRyS25wVkxYNHh5Uzds?=
 =?utf-8?B?K1I2WVNvRE02ZllhU2kzOGFEdnh0RGdPNUlnMktETHhaZ1RhWHkrTXJWZ2ht?=
 =?utf-8?B?UWxHUE8vcG9EQ2JQM21BZ29uaXVFK3lzUXpQSnRsYmtnb1NremhRYThlRHdo?=
 =?utf-8?B?TUlwUFRZcGkyWWM4d3pwNkhuWUNPMmR3Q0ZVVGFpS2MzY0lHb0tqaytsRDVI?=
 =?utf-8?B?K1pTU0dxZWhjNldiRDB1WXVqUlJCNjVTWmxUOFVHbnlmZ2tHZUd3UDZqMXYz?=
 =?utf-8?B?alRvYTJ6SjJnSXNqbDdURXFVbVhGRTI3c0FZYUJ6TUJFdE5RcXZBM1g5Y3FM?=
 =?utf-8?B?UzhPVnlEREIzdkppUE9sMXZ1SzZNa1RTMEhxWEJkODdLcDcvVFd3TVZkOHZL?=
 =?utf-8?B?Y0UxZStMRUxvK2REWGpURkNPN3J3c0tMa29pVGN6NlNZWnkya0ZpT2QxeERZ?=
 =?utf-8?B?WGxhS3duY2FucmkweXJFRVVoK0RkSTdEQXp0aEpqbkVlK3dkVCtCU3JNN0hp?=
 =?utf-8?B?ZzFGUTRQRS9uU3VxaUJkKzc5SEkvT1J1Wk8yNUNBbWN2d2xNMnhOYVd1eWZm?=
 =?utf-8?B?U0hQZ3ExL09CVGV1OFBUU3BHdGRlYkpUR0N2ZFRuZjdpTEJyOXduMzlETWl1?=
 =?utf-8?B?S01sQTFkU0RwbS90TExoNWtuVWMvWWRiSXZPbFFWOUVWVG16ckJyd3hyQzZ1?=
 =?utf-8?B?NmJvd29vaFZiR0xTcHVlUks2UzAwWUhXVlpsTlVSV0dJLy8wTUFHalhjK1Jt?=
 =?utf-8?B?c3ZFTEZKTUZGOGFKbmZUNWgzODhUM0VVS0MvUXU5YjJKZllmazVscThGNVJR?=
 =?utf-8?B?amRPSHRQZkxWQkxBOWJvUzREU3JNUkYwOFBmUU45MGd0by9sZHZoUU5RWTNs?=
 =?utf-8?B?R1hPNUhvdkVQTVVRK216ZnhmbXdvQTJESWxqaWw4SS95U08vTlhUc2lIV2lN?=
 =?utf-8?B?aEg4dUVNQ0FSRzJVMkNUVCsrYVMzV0YyRmFXMTFNQXNGaERyVUxaTkxHMU9y?=
 =?utf-8?B?bUZ2YXUyUWdLYW1wVHE5a081WW8xQkFJQ29HdXp6UkhNR1ZHc1F5N2h1UHdv?=
 =?utf-8?B?S3NHSXBWNjYwcmNFWVZ6eCtSNVVYWUwrQjFXRzNPa1A5UUhLM01uVTlNeVFl?=
 =?utf-8?B?VTRnVmloT3d0bko5ZmFSY1VuVHRya0hUS1htNnpRNFFCSEY3Y2pEeWpwbTJE?=
 =?utf-8?B?VTV6dkhtdFNKMkVnK1l2OGl1d1YxMWxnSTVFbEZsaDdGSi8yTGlQb2Q0d1VQ?=
 =?utf-8?B?VXVoM0N1cjA5Wml5VVJtcGl1ZjFCc2x4d29tMVJpbFQ5UFhrU2pVS0txOTZh?=
 =?utf-8?B?QVhUZnJCYTFPaVZ0U2lVbHBtcCtxcmVxVTFXVVBQNlY0V21admVvU3krYWdh?=
 =?utf-8?B?R3BNcFJjV0JLbmxoa21QQ2dCNWltQXhzQkFHd0JKMDNpMkVpaDREVlNTZmUz?=
 =?utf-8?B?bUNUYlA2a3ZCY0VwbmtRUkEzSkxFbENsb1pjWGpaN0NzZzNHNitMdTN0eWlY?=
 =?utf-8?B?RFh6a053Sk1MbUdSdHhLbW52bUc3Ly93K1BUeVlsNmdqclArbkt4NmJaTCtm?=
 =?utf-8?B?TjBUbXNaQjJYb0JLSWlqMFFEL0hZNjlQZDF5aEZUNHNrWWFDSGMvd2dtaG54?=
 =?utf-8?B?N0kvVXI5cVdGR3J1RGpmMWhSSE1YRWlwL1pZdm92SVprY3hsbzVNSmdYVGVx?=
 =?utf-8?B?SXQ0UFd0UjNmNVplcmI0VEpubGpQeHVJdno2azhUamxTdmJleHVGQTJOUzQ4?=
 =?utf-8?B?VFN4Ri9xRVpLcDFmaHl6RXB3T1NQVTA2d09pN0ZJUkp4cWxvay8walJ1cGZW?=
 =?utf-8?B?M01yeHhxSmZTdE43NzFWS3gvR0M0djFDdGxIZnh5N1lyZzY3aUVXRTUya2Nh?=
 =?utf-8?B?RC9lUGtZQS9sa2RFR3NDZWk3MWhTTFdHQnhKbW56WGpBd3daR1EycitseGlW?=
 =?utf-8?B?QTBHOFVhR0xGUi9TMzhWR3JMZkVDSDlUNUdKZ2d5VC9yMUpWNjFmOElod0o0?=
 =?utf-8?Q?nm+H/4pBlCjbhg1SX4jceQYdj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nJULJ5HG1g15zvbfHgdIwEdWD2jK1oJtoUKqaEu/L9onVDll9/00gxJfVZE1xnrB7zhU2CtshB67ZzuoZOOWp0R64xgJaJYguCjhGp+If4670IyCwP9dHnVgn8KeY5TnSwFZaJy8zeaJDqBgX5LTl5bXSr1unA5fFzzL4Sm7nYY4EDNG9XRbTF0TohHKctwIj8HzF9hF6E6LLCNWcx/Q1aD80obDLbOv/18/Nim65VUb6099AfzwB7TGty03rEKz6DxOX5LkvlzTaVziiUhYatyhc87q/CGYd3I3VjUlkY9grcewp04IdFW6aRRkMMh0IUD00AnhT2PyAIzVbxFx5CUlZhIjht/eZEK1puvWi+PJ1xLucyfx4b0qHKrIHHXzvwBZY2ioUevRrfVL/slVc4zOqytgg9gVDXY7AEL/Fn1dnzAtCoYUXRDYQCsiQ82ZNr2K9aKj4vz0mBaazyfdC8/Nfjw5KgZG4TSqFARd4E8ghb/eGHiaEtBBKOCHSBKHWJSlUClqHTsZmJUVsitxDVWNjs5uFC0dRigta6/i2k5H8p+WKumwb6tI67y6YqiPCbwtERTND56sXNAhTXm5k6E1elA+ri9lgXzyZq9xhpY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a8c309-b306-4f2b-9d57-08dcb776c4c2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 06:53:11.7549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6zk3ucwPY2lwnY6yJmfrEqeoWelYTta8Oa1/VwHNOqXkXQUu+2zdK/NxfGfKnIz1bB1QOEdzgbRd7TJSWwI+QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_07,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408080048
X-Proofpoint-GUID: StX7PWRnSBsdFkIOZai3qm1BLGSUReoE
X-Proofpoint-ORIG-GUID: StX7PWRnSBsdFkIOZai3qm1BLGSUReoE

On 07/08/2024 23:41, Max Gurtovoy wrote:

Feel free to add:
Reviewed-by: John Garry <john.g.garry@oracle.com>

