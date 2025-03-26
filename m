Return-Path: <kvm+bounces-42080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 201DFA723ED
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 23:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76458174697
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 22:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D7E263F59;
	Wed, 26 Mar 2025 22:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cH6fPq04";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hD9FoYb1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38138263C80;
	Wed, 26 Mar 2025 22:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743028051; cv=fail; b=F4PjwpHyJRPGWodyjVm9tBF3OtXEvmMjyu2xY9TZCFMd2YhOC9ql5y61iTUtAxH1CzVk9jt4kooZDzS4ryIb6iMMc8ipKvOGnT+5wv6Dl2K5x0rQMCdOpMW+QcZo14UTBkLQ3h0PYYyQGhx0RtkVoah/lCG1Ay8fTj34isIWM0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743028051; c=relaxed/simple;
	bh=DnxmyymYqwP+2HO28CDvJS3klttXXrxMEwmY6laUwo4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r4+ZE+gt3dxKELBJ8OUWmMkS7qjrwbp43XLNoWaf/A5Hpx0C3HhYCtNNyodyCMCDp2wzfBHZwoFuNwEK0xP2wsyii/tRzcV8UFoKNR+ygHygIJ5NCG0UDECYF9qW2/LpJYXL1k9+VeJA6/pcenNVHA/H0jPpyYp1jiSdj6W7OR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cH6fPq04; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hD9FoYb1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QK0Xog024413;
	Wed, 26 Mar 2025 22:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=qQUMfTlPTjgWGEH/tqmA1BxFrqUG/zdhEM4wyaB1O+8=; b=
	cH6fPq04qJqpnheTCHRzc0Cr1CPlak5hZg30pZPgWC0bZQ4G5Fbd0lo4p3oit4TG
	0OyGMfmpXToScXICHKgINFEx4iAvFKEbGdj9w9SZERgl+PD3RM6faT+nGwlN7PME
	aUEnaRwKUZ/AK1HW0O2pIplXf0bBR9INrJhW+0INS/WrhukV1z1DVVAND+UikCvx
	3k5ws3tlRMhsXy8rZZhhmBIYcL3fCpn9cOLBLqupul45u2reP5k86NB+ragXWylk
	BI8O87Ohk4zd8LbvZfyGf+R+h6diqZ45VA/lQ/NYdS+sKZY43pLJnKcO8lrVCFKB
	WVqWJVWGoKDgmOvXir1kVw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hn7dtwhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 22:27:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52QKbGQ2015144;
	Wed, 26 Mar 2025 22:27:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45jj943a5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 22:27:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XyQWg/5SHSyZBawklS2yGbAYY3v/EUtLttY1wLMcVMuuPkgpe5tJ3/Od4VTrdU88iFPx82Y4cQ3QfzQs0CXrJf4JQjaepyQxaPMbn177m9WJLzGk6dTWcvBTkXwG+EFgEmo7Z2IqOo2n4XHh/HybsV3jFtF7HtprvNQyx6opbB9BmONUj9DtVfBHxspITjcfJABINedJ4CJeiwHcpFSCDuonRmDzKJ5phrelh8giCYFvnHM+oVHLfCQXmAtm2BCrdf5D9+44Al0ovOnfcPwA//8S2IWVTNUCESkaj+kymicqGR8jmc5Hy/ACWneRXSC2sP4vBn7VLkKUBwFZfArfwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQUMfTlPTjgWGEH/tqmA1BxFrqUG/zdhEM4wyaB1O+8=;
 b=Lc458ywKrl4HuGHfcHmsydClFStUtSCgCsJQR6eFTxRYXbbFB25RdkFVwszBmuaRq4b7z1HvNYI1QYz+Gp2jza4uKuGsPi3Rb4Ei+5KoIsScOzcDDbHqvZIP/+0yjp6cvCLkIltw8gfSKI1Z4BviWtAYJBcMjsIDPanzM1wT4GMdCDWjMBrP6khrLWKA95RMhSs0x5oVqe5odqAjw+8xqcFjqTtrzeRkHhXEqmHmGg70ELOiImjtBs39C47FBfsJ+JmecaAnp3/whpdD9mISDOk4hwPQvAw30AGW4I/e2SCEqofmLFcsLEVxTilyG6ub2gxxGucN8PWegM/b6Qe8oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQUMfTlPTjgWGEH/tqmA1BxFrqUG/zdhEM4wyaB1O+8=;
 b=hD9FoYb1ZU3x95zb8gcpZU3uvvWLlXPY3C318xBXmpswEAEGTQ/sF2+27qBfKjGrQhSPIXkHZF2Vs9bzqyjbMhlJhf7JoRkBdbLNG4IVl0SuJdB+7KOVoohNnNy07z0yPchox/V1fIXq99/8/NERymIja7+GeUMXpvSHAkVihUI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB7956.namprd10.prod.outlook.com (2603:10b6:8:1bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 26 Mar
 2025 22:27:21 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 22:27:21 +0000
Message-ID: <3705e572-774e-4e40-86a1-5ec1d4e83576@oracle.com>
Date: Wed, 26 Mar 2025 17:27:19 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/10] vhost-scsi: Fix vhost_scsi_send_status()
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-4-dongli.zhang@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250317235546.4546-4-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:5:190::31) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: f3b656ce-234a-447b-80b2-08dd6cb55fd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEJycm5vaTB0SFRnL201Q0gwVUZPYjNodWdJNG9BeDM0S2FLeVhCYzBzWFBK?=
 =?utf-8?B?ZmVtZVRVZlp3TUhScnRaVk5ncEp4T1d5TndOTlVOaVgvK0pUQnFFNWdySEhp?=
 =?utf-8?B?NEZmL1Q3VWJDYW1ZVlprZnlGdUJNaWN3QjBOVHlMbjNJT3UxSzV3ZS9XVUNN?=
 =?utf-8?B?SE5VRmlJTFBrclpxNWFPZy8rd1QwMlJaM1NSYi9CN09mRU5mSmQrVklyMk9D?=
 =?utf-8?B?VGd0S2V1QTFPK0dZdE5yZUVyelljV3lMb2VKR2F3YWtjSzR0QjNnczVrVFJR?=
 =?utf-8?B?VFQza0JucFcvUEZiS0FHNDVMOERsSDJNOUM4Nyt3QWxNRGFCZ3BqTitjdG1C?=
 =?utf-8?B?WU9oQTFmaXhnQ0svUzdUUVVHbU12NExoMUg2ZkpnUkxkakk2eWdQNWxBVmFE?=
 =?utf-8?B?ejRyR1U4T21razdIVUM5aFRNTERWbVJ6REI5SDB6LzFKVDVBRnVnTkdtTWo2?=
 =?utf-8?B?UUVZUGlOOEhHK3lEcGU1aTJENlZBLzZjQkJmVVl2MUpFcmc1dHhYL2k2eVdv?=
 =?utf-8?B?Y0s1b3BKNjl3WGdOZG5TWStFL2greU1GNDBpcVh1V28ycWF2OVFoNWY2T3Yy?=
 =?utf-8?B?OXJhblhDY1kwT3o1Q2E5VGs3T0VueUNLS09qNWFXWDIxSXNNUTlnK0lQN2Nq?=
 =?utf-8?B?Vmlialp1a3BtUDl4TFM5Q254MnR4QXYvaWZMOTBUQ05TOXgzdWhKQ1R6OEhI?=
 =?utf-8?B?MFlWWjFJYkVPWS9zR1o4eEVMYm5DOUNqMDBpYmZ0QTR6OTY5K2UrVDJJY1l6?=
 =?utf-8?B?TytpUXdqL0tlcXZDWnFya3FDVXR3c2p4aXEzZW9sTC8vb0hrRjVkY25sNnZP?=
 =?utf-8?B?d1hDUitOV3VHc0hLS2tvbXgrUldmUWorekJLekpYcFM1WHN1Ymgyc01rVFF2?=
 =?utf-8?B?VjlpS3R3WGpDaWJYcW84MnhFU1I2djNyLzQvVzQ2N3VKSXNEQUdDUEViOStB?=
 =?utf-8?B?US9kYUpxWTM5SEVvYlc0UEJPeWNycTI2S2lDcTU2ZjZrSi9SM1R6MlZvaVQ4?=
 =?utf-8?B?d0RVVEhJTmRSR1hyK3ZKNDJuaXJNbkNwOHVON0xCM0YvY1cyMHhDY1hGTGNk?=
 =?utf-8?B?T3hPS2hsOCtXQklvbnpUb040ZCtEWnVQTEdibm5nZDljUXpFWVp2SHN5eldY?=
 =?utf-8?B?NFlnVDZ4a2pkR0pEYTYxNUhHRWdUVXduNGZKRzM4WWxjOWsyQklXd0RVdlUr?=
 =?utf-8?B?VTE4eDNhMFY3RXZtWGdkWDI1OWRaNkpGQUFmM0xYSTFoY3Y3OFVDWkMvUGd4?=
 =?utf-8?B?VGEwV3JQMjZlcUxUdnpBVXlWOGJZc2VPQWVQSEVtbG9xZjFaVVJQbXVGSnNV?=
 =?utf-8?B?YTlqMGpYdFM0SkR4N3BHZ0RTci83OTV5QzNlWG9GK200dHJ4Q2VaTStYS0JS?=
 =?utf-8?B?a3V4bWQ0ZXhaVWxLek84ZGV3czJDM3c5T0ZpcHcvNFpTTDhKTDI0dUxVRGJN?=
 =?utf-8?B?ZUtPUnA4bmRJeDNuK1IyR0xacTdSL2swZE5KTXFrdVByNEQ5a3ZXMjZiMFpT?=
 =?utf-8?B?N3hibk9lbVhWcHluZjlGeExXSWdoREpjZCs2SmhSbXE4NSt5dW5CVG1UdGd4?=
 =?utf-8?B?M3pkT2ZVZVFMTFZrYmhLZ0JjZFdiUmRTU2RQYUYyRTlSdEdSYngrajNkcVdV?=
 =?utf-8?B?TUh3ZXkxc1ZXZE5kN1ZhRFdMZXduNU5aaERsWkI1SFF6RnRtcTJHRkpTYVZS?=
 =?utf-8?B?Zm9hWVJ5anVDYWhsdFBIajNpY1VmdXBPMGxtOTUxYU1FVTI3VUlISFpmc3pK?=
 =?utf-8?B?dWtMMWRnL2hwdDF2WVp5cmpwbDRHczJGQm4rVDRERUM2SHlqMm1lb2plc0ll?=
 =?utf-8?B?U0JpSjJTamM5dUU4WFV2d2g3UStTd1ZOcjFNVkd5MkV6b1gzaDViR3NYaE1S?=
 =?utf-8?Q?qQuzeP3LFdJ0x?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3d6ZkZoQVlxa0NkLy9VR1dwMHhFQjBpRjFFbHcvdmRhcWZjalJBZkhBK2Zn?=
 =?utf-8?B?MWNUSDdjZlRyZkRDQW1NQWdiOHI1SWEzLzdUSlRUc21WZTlRdCtoRXZ0bW4z?=
 =?utf-8?B?amg5QXl6bEhraGtjdXNWVGJkZ0Y1R0RkeXBsR0NzSUErVkp3U2w0TnBYNnkv?=
 =?utf-8?B?UkZGQjNXbEhubnNrUEppWi9CNVFiRzYySUs1RHA5U0VYRWpWVUlpTXArdkpr?=
 =?utf-8?B?a1NBdmF0cDVwTWlJaDJTYjRDYUozWEhaTU9VY1hMS21lN0lKbDBzUkNBdVo0?=
 =?utf-8?B?QWNiMkoxY2RLV1hBa2JpQlQ1T1B5TkFtNktBQWpQcmk3bUFmcmVBUGZMNzRZ?=
 =?utf-8?B?S0hBcjZydHYwd0pLclBoRUJVQ3M5bkRHZ0F4NllQZkhMQ0pDK3Z0N1BkcFQ4?=
 =?utf-8?B?QVF0ekxPakt6dlA5di94YmlpZkR5anV3ZSs5aStONlUyUmVpcDUyNEFWdjNB?=
 =?utf-8?B?c2RXb2dxblhPc1BLcmo2S2ZvMHpXOW9rRWoweXl0RzZJZnF0dXBsTHN6Zmhq?=
 =?utf-8?B?OUk2NGFBVElrSVZWN1E5WTNBZlV0ZWg2YU5UamZEdUZqd2RGL2N6d0FXVnNs?=
 =?utf-8?B?cVpnR1NOTU5DOEk1ejhhV3RTRTdFdGtpbGlIOFBCRlpMckcySmtCSzEyVVp2?=
 =?utf-8?B?YTh1WXBCT1BTWXFpQ3liOEVSRTlTZmY4SEV6SU9oRXJrMHdtcWNwQ0dJcVR6?=
 =?utf-8?B?N1RCTEhQUDRjaGpFNXVNenArVnMzT2lSMW1iRmpnNEFISGJWTkRWS2JjNWJT?=
 =?utf-8?B?NzFXY0RxbWZIN0xUZjBQMklQaUxaUGxnMWFLUVdzaUJSSjEvV3dnMzBLcHVh?=
 =?utf-8?B?VzFlVWh1ekZrTVJVRlp1OWVFL3FaSFgycDlKeVNJUE0xZ1YvNVg3VDQzZTIv?=
 =?utf-8?B?NE5icHUwS012dDA4MUllcndJTkVsd0EzNTZFazBHb3BoSHZQV2diRnJmdENw?=
 =?utf-8?B?dUdWSFdYVXZaNXRtM2Ztb0Nsc055M0NnNFd0N21kU0VYYitxWDFCRncvRnFC?=
 =?utf-8?B?dVdiNXd5UUM0Nlk3d1VQaFE3MndYL3lUVXJRTDBBdndNeVhzbFlHelJBeUF5?=
 =?utf-8?B?b3N0eHZaWU01dTJRcXJyTFNiL1VaYTdMWGRuSGptYk9iVk9lRU9zT0JoNjA4?=
 =?utf-8?B?eWVIMlpkN1M1VlFyYXl4MlZWWWlFMmhXa2V0S3ppYTlDaS9KMlRPem5CZVRs?=
 =?utf-8?B?YVd2L3UzREx2MTVUcytTZEZLUmxhUGYzU0h6VjFya2E4QUpvQjlscklKWFB2?=
 =?utf-8?B?ZTNuc0E3SE9rdVg5bC9CY1J5Y2tIU3NnNUZZQWJ3TDFjeisxL0dhaWg0VW1a?=
 =?utf-8?B?c1IvdEV2ZkIxZU51T1VpMFYvMm45UHFHY0dsem4zWG5ISnU1STlxcmdmcy91?=
 =?utf-8?B?YTRnWFBCVitwemtYSWc4SXpjd3NyZGRMakJMOTllOGdOMEpSQ2JINU9pSGtv?=
 =?utf-8?B?NEhXSXR6ZVJzeFdkUjZSTWRPQUgyUFFHVXQvaVczTngxYm1SOUw2d29KTVp0?=
 =?utf-8?B?TmV4bkFrWnR0SHpuQ1JKdW1YQnh0djljWVRsdTEvaWM5a1lidEJKd2hmakww?=
 =?utf-8?B?c0YvRnNpZnFFRFNlZmxvcVp5NW8xK0plSHhTR09aQTIxYzhvbXZONDUyRlZQ?=
 =?utf-8?B?UHJGV1pOTGxXbE9haWR3d3NqOWE0Wi9IbE9JMXg2SXkvYVk4OGRjaEtJVnZn?=
 =?utf-8?B?eGZHak9EeHdZcVBacGMyS1I2VEdJSzYrc1ZnZzE3Y25UM3pSTnU3NmI0cnV2?=
 =?utf-8?B?d24wcEJQVndqVTZlZG53YWR1WHNUWWtNUEFJTUhHR1M5ajZTeTZwZ0FoQTJG?=
 =?utf-8?B?Vzh1dG1Xc1lraW9qSnhSN2xoa011cVo2UVJGNll2R3M4MDdZUFFqeUpwSitY?=
 =?utf-8?B?R1BFcXdFbmFMdXh1WlpqMFZvYU92M0hKTVc0UUowYU54ZnlQT2tNeHZ2azQ1?=
 =?utf-8?B?SmwwYUQvS2RueStsdlB3YzBCeFZ2OUsrRjczTlg0MzlPT1BOckQ1cXJDZElQ?=
 =?utf-8?B?dkJ4WTlBbjhPcW9HcjBTTnRQbWNkYkEyUk1TN3pWYm1hVXh1SHdxaDA0ek96?=
 =?utf-8?B?TWFiQ1F2MlR3UnhhaU4rOEwvVUVQeVpjZ0NLaVhzTmVSQnU2VDlHUGtwNjhV?=
 =?utf-8?B?V09YNGpMcXFRUzJRVDVLTDJmN1NMdjBzRHRralRITkt2SldvdHhTL2Qvak9H?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CvPRyhKKS6j52KKPJ1FdX7s1fGDCFCdK42eOfYgadoNjS7VEZVhy38IF12UW4rQVGZKEY8umQK+JAETxJmVMP5TNjr3w1rQdgn4M9WHC302h+hdC8Al/YsGtBMO7bBLxIQawEl2fA4poMkiC5iEOwhhqba6lVLr4z7Sg6hiRX5pw0ZpASQ1LT9oRgJ/dnMXbgMRVvpRaXzVcLKRETI8+ML0gVmy1bvtpUcGj8tkRK8wONSgMDTMNyP6HXrrtKdF4uZygLUM+Ib81ZqE2d6Lpwxd8OnPguWlBy7378rCQKqvjAgGRRCC/qbrIG2kX8b3Hioz9+PUvcLppmJS8XWYf1BO//aUq/WkqObWYJSbuHCprKwJ54fcC8OP3bBoklNIKCGJHcWNsdpN8qWWxPBVmWGFw3QyMCKKcaHPy/wl4Omp1ZQE3qeFmybDSPNdHUSGacQNaFYpIB20NjTOH3KEE11Kuk8g1FCILOY685toNO1z4nKiaN8+oyJWhMIzGAcmxU/tJaARqcqjKrWw2DZ2HcdVffoI4xpNY2lZRu7S6HNW9KF0anJB5X1D0Q0UopAnTMQOUHwD4ovy4vTs15xqNV9WzeA+4HhllZAusryxC4W0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b656ce-234a-447b-80b2-08dd6cb55fd6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 22:27:21.0573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Nn4Z1eXS/VLI+6DlaTb4CilH1lJuALEueoDi0zzA5WpMwZHkt1Nv43JM7/W8R8+IEv3pfsDJovV8AbvXsDRmfbe7JVybL2/0R5GBUlmDUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7956
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503260138
X-Proofpoint-GUID: PzOsVsMymVbb7Z8Au4yJ86dTjYpH8oz1
X-Proofpoint-ORIG-GUID: PzOsVsMymVbb7Z8Au4yJ86dTjYpH8oz1

On 3/17/25 6:55 PM, Dongli Zhang wrote:
> Although the support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 was
> signaled by the commit 664ed90e621c ("vhost/scsi: Set
> VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits"),
> vhost_scsi_send_bad_target() still assumes the response in a single
> descriptor.
> 
> Similar issue in vhost_scsi_send_bad_target() has been fixed in previous
> commit.
> 
> Fixes: 3ca51662f818 ("vhost-scsi: Add better resource allocation failure handling")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>

