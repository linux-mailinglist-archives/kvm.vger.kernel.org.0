Return-Path: <kvm+bounces-40969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6131BA5FD92
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 18:20:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEC5019C2DC9
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5141D95A3;
	Thu, 13 Mar 2025 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LTh8w06a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EY7SjHAR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDEB1C8633
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 17:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741886278; cv=fail; b=GNaK/HT5H9o2EOea4H+45AqXRbkJRiIT7/fXXy4jfI1cQ7GMEr5nD5S/GxLELG7bcmWFjuez7k902EUFB71FMamczlJyXIdxFkkUoc46z1Ptk2wcEn5n2f2/cPBHfm2Kf1OyHIxnznqKiEUquFya/1MxRQVty1dTrU07NUltFgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741886278; c=relaxed/simple;
	bh=O9q/O7lnGalfrt/iahqosq2qZmY/f0og6W4xzLmaB+c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rdV9Go1YKS6srM/XyWFgTrlAq2XQ2nLcJgut35ro0PzQ1b6mF5mbxD4DBP7/TVfAUAAgppFQH3stHxFhWzdNBmtFr4Wjho8JcuAecWvE+uUtCYcgF7Sjz7mXKQr0Yn8SEzuW8QgAR4Jejjfwnp7wGWcEaTxwKqABRBvPJ1OoX+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LTh8w06a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EY7SjHAR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DGtmwh031881;
	Thu, 13 Mar 2025 17:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=SrlAMTQIT01iGB0NV5k13Itgrvj2XPfucHKt85DtJMU=; b=
	LTh8w06an/UM4pH45exOc/C92eK1bWwwI2sBwFSTop2YXVCyl4YedjX/iOLVw4Ph
	QgKgfirtkLQn0aC7cM01CaCyxIlzVkegvhZVdf/zEspzKgoIlPtVOq6OugFuwPyh
	98JfQ9dxFnSL3fJQqHln21hdnY9XACNNkugoTTcNPhkfacIlEEWT0GA3DDECPfiI
	H6iPiMKUJusKt+yE5jJNKDSKCRLwm8cH2P1A0333YWEBGZHfgtLeIcyU1ln6Sz69
	okQiTZmIUYZmljBzAAUx1c98WNzy3kHz06tkwTAcpJyy5kfL3TTL0E831mBaFqn6
	2QHG9IGEvoyOVkCb6BgW8A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4hcspx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 17:17:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52DFlvx4019432;
	Thu, 13 Mar 2025 17:17:32 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45atn26t2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 17:17:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ligAegc2y182McJ4bEW+/Ub3sXvzt5V7zmdpCBbMmk27zReBxu+Br5OlLW9mpge4TlMmflMWKVmBUcjOGQG0gkhOlLaAvKrGhk06k/fTxwCyWl5ewkypBh/GMth7v1TDgxHlc+PMrGnHj3ghC3idgiGWZekvoRgEQ7CxnUQIfuq6/LxYHoV6Gt68RJr3dD6eu+oc6OCizyBWi0pGFBh5sDTSSqwz9TYuVvb36p3olLxtR6RzN/tiqMoLjYFKkK1fyCfSOh+jooBfUzTsQRdLiUjWwcAYlC43hjLJcLAjjHsHi8PpaEZPCedImALCl8ASrjWxEv06v6r44ODKdqY6OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SrlAMTQIT01iGB0NV5k13Itgrvj2XPfucHKt85DtJMU=;
 b=ws5/lwAJIjbcSZuZrKel6yz+vFQ+/vEcnsAxuJBHg8fwT+MFMtQeXxWtlpsP3mdITNfb5+f78acU2B2O+GGU5AYlz3gFv6pk5mbAZ6Vw9nCxT7eUL5o8w3cnWPKfEEve+HXg4RXBfQrom7TsfW+F/8YbIizWho3Gt6efLSyLu1TSxtCUfj+JG1G76RHnMPXURMaeL6ROwmTXYKDp2HjHadXWUszRhW0KIlYy2foqdvbWwkuuMC0+5TI5I/YoM0+kWdTdHSZQscIz3Xpd6trETqeCM57DelNM0rFEN83onk+CC9cU02IhzqUCGPWqbf339JFY/h9cHb211ArrdaB2Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SrlAMTQIT01iGB0NV5k13Itgrvj2XPfucHKt85DtJMU=;
 b=EY7SjHAR9lU1i31D76vreneg0atgIeBxAKbyHqM1AyqUpc2UYZPBlCNDgicNGRil0RDxzgfvN/4+y4LMFiydHkuUmV64hNoopGqA7mzjx16Yp/wVziXAaSNuee1SCOuGxhjTLAsjZ6x05Uh3qJagpxDKt+wH4Ekq34XMFLWgq98=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH3PPF87283933B.namprd10.prod.outlook.com (2603:10b6:518:1::7b4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 17:17:25 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 17:17:25 +0000
Message-ID: <d1104f67-30e3-4397-bee0-5d8e81439fc3@oracle.com>
Date: Thu, 13 Mar 2025 12:17:23 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] nvmet: Add NVMe target mdev/vfio driver
To: Christoph Hellwig <hch@lst.de>
Cc: chaitanyak@nvidia.com, kbusch@kernel.org, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com, Hannes Reinecke <hare@suse.de>
References: <20250313052222.178524-1-michael.christie@oracle.com>
 <20250313064743.GA10198@lst.de>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250313064743.GA10198@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0039.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:223::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH3PPF87283933B:EE_
X-MS-Office365-Filtering-Correlation-Id: cefa7b9f-c1ae-45a9-2e4a-08dd6252ec69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z2h0R0laQmszM2h5M1lTRktkY2RGVDd6OHVQSnpuZ2EzNWY1UzdDSEZwdkhM?=
 =?utf-8?B?Z0ZkRlFXT0FNMVJVKzFRendXeEZKZGN1Y0xaS1JGN2Rxek55SHZpS1p5eE9l?=
 =?utf-8?B?RTI1ckhEYzJvUnhRLzFYYnlUR3ZPYTdTOGxXQVY0ekozWkl4RjRNcWh3UWxX?=
 =?utf-8?B?SnE2ZldBQmgvTElPK0diblRjQk5jc0RNeEVJRytSckpQcFc3RnFDN3A0clVB?=
 =?utf-8?B?YXpOeWVqOVBTRisyVE5BelBDcklrd01WWGN1WFFKdzlqSFB0SmptSTNacW9S?=
 =?utf-8?B?WU5jemNod2xHNVNGdU9BbXFXTEMzWE4vVjFLWDJmSkVpY3ZiWm1OSFB4amlm?=
 =?utf-8?B?WXVsUktDZGw4YUlBdFJBeE5LS1JjRVUxamNkaHNLbFQ4R3FDZGtORVFFbjJU?=
 =?utf-8?B?TTNRV2VacXQyemZRbCtGYjFaam1GUmkwU3hRYlJlK1V2UlJ3Q29jc2F5elhU?=
 =?utf-8?B?MFhrRk9XanRkQlA4R1BGOFBvOHJaZnU0Z1dTcDUwR3NjVFhZNXJIczlJQ0hM?=
 =?utf-8?B?dERVekMyQmkvL2VVbUdqUW1TT0FxRUZoZ2VWRmN1TjJlelVrL1NyQnJpakhE?=
 =?utf-8?B?VU91NFJwR3Jld3VadzVGRWIvYkJ4TkpZMXZpN3BjbFJNTDN3WmNLMTVNUkxF?=
 =?utf-8?B?RjBOcmg4b0lubDY3YXBlNEdjRXh0aUtOMUhHWUxnUGwxdGRkUFpkaHJMbGkz?=
 =?utf-8?B?OVZkZFpNb0tGa0IzNThKcURRb2hkTVBVTUdRVzNpZk4xZys1Y0swNm5LdEhB?=
 =?utf-8?B?ZExOaHB4d1lUMjhmbHNGNTljZUZkMDFpcjIzM29QVERUaXNrdnJlNGZQNWJV?=
 =?utf-8?B?M2xnRW5DM240UlVvZXIzUjhFODhJVEp1TGFsa2lZY3hOalFRZkZTZXV4Y29k?=
 =?utf-8?B?QkZpVDgzbjlxRXZteUFYeVNKTjBRbGdNSXpGdFkvNVhlVlpPbngvRzk1NDlW?=
 =?utf-8?B?RDNhNmNMTnRsUVVxUEx3anhGeGY5SC9SUEg0MDVyRTVSTlJTdUV0N3gzNjV3?=
 =?utf-8?B?Tml5MzVkbjljRzBPODJsQkMxSG9BUWtCVWRQdUlzb3AyVUkvMkdXNHk4dXdF?=
 =?utf-8?B?MnZFS1diZ1lLUytCczRjcW1TSDJhZ2pma2NBdm9udUUwREUyVmd0bVBLN3pn?=
 =?utf-8?B?a3o2c2l4UU0xMmdXdEpYQXFuZllCa01zbjh1S2c1T0g4ZzF2cTZpOTdBcW82?=
 =?utf-8?B?NnIxL2ZZZ2Yrb1lBdEg5TGFCSEFyV2hTZ0NPRXBoZG04UUx6aFcrcnpQYUlk?=
 =?utf-8?B?bVhBK042bzZTZjZwK1VHOUtXc0dkQ3dycU5IaTdNTW1YNGF2QWdZb3J1d2Q4?=
 =?utf-8?B?OTg0T2RBYUJtYldFb280cXViLzJOWStpNmVCc0dlYXhyS09udlRlZTV2M1Rv?=
 =?utf-8?B?dHFUT2JzTkU1YU9uWTh4K2RDTUZFZCtOY2JnVGlEUGdKdzUyT1k4UEpoNmdu?=
 =?utf-8?B?cnU4Vkkvc3kxMDVWSVltNHVTakhGaDR4bmRlc090cW1JRW5VZXAwMTV2RmpY?=
 =?utf-8?B?RWJ5Y3BQZlZoVlBNTHBqZVJoMEpCRkhPSHZQcXo4N2ZJN09maGc2bnQzVVVQ?=
 =?utf-8?B?UUF4SWNPVHhZdmI4ajVpbTRWM3gxcFV1cnFzZEhFZE1DMG54SWZRcTllNTd1?=
 =?utf-8?B?a2xlcitDZHUwNU1sUHdSZjFTb3Y3MXJZWWRsRGpBNFFXSEUrSzNEVXd0YUQ4?=
 =?utf-8?B?NDFPbkVUUXRCOUJFdGlUM3VTUnpseHlxL0FwQzltYjRIWHdOSW5IRjNsbWdL?=
 =?utf-8?B?enZtS2RLdEJCU1V0OXg5VTBUcmNnaTRvUDRPU2lJZlZ5clNBbTl2ZmZYYUV2?=
 =?utf-8?B?UWhwSyt0RXoweFRYRmpOVExEWnJJa01tZVYzcjRlc1FKemQyeWdvNUFoVk1p?=
 =?utf-8?Q?U0m9v4fh6gRob?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHErUWg5OHRTMDk2R3BGek9iY3dFaWJ5enJ4c3YwZGlxZ3VPWlJyYWZvenVY?=
 =?utf-8?B?Q3N1RWQvUjRuTWZMK2plclpqWmJlQ3hON29IZStWUFVrVDNhWmRGOXgvUnlx?=
 =?utf-8?B?T1ZiNEpiZStjcGlLNU1Jd2d2RWdrNi8wRkdidnBDVXE5OU5sNklqZFNDc1dB?=
 =?utf-8?B?ZDQwcFVERzYvQWZIS2ZnVDExQmtoSUhMMWtIN3FTa005dG5oUGs4eHBscEtN?=
 =?utf-8?B?SkFCaTM0ak1QeXBxbzdVOWEyaFdxY01rMjZqWTZrZmJyOXdhbHZvR1pCVC9z?=
 =?utf-8?B?R3NocXVMTXdnelZ5WkRqY0xLUDNjbkZuTlJGOExLZDkyUmhJWHQxNEhKR09k?=
 =?utf-8?B?amQrUUpwYzRuSmJQYXpuQVVPczJ4eGVPaWgya0FqdE92MTJuWGxSVVhLMmhi?=
 =?utf-8?B?NE5xS3hHaW4xYUh6MFZUV3RWOXFIb2VlRmZFN0NxWXVUbWVGTUsrTjZ5MlZh?=
 =?utf-8?B?T05FZXluT3gvYktCSDlpTDdINHJsa0QxOGtTSkM0TEgvdnc2RlU1UDh4R0tV?=
 =?utf-8?B?MHlLV2lWM2J1aHdVaGpIUk9GQnpMbGlBME1jait2eWcvSTNjaU9NKy80a2g2?=
 =?utf-8?B?Q2dRanVvVi9IVjV6L3o5UFUyZVYrdTRxWjdFVG01c3d2dGVZcHBGaEdZMUJn?=
 =?utf-8?B?OGNGMEVDL2lIQXh0aEhrbFJuekJnRjVzSVVYUHR4VmdjcnJXM0JReUlXNWI1?=
 =?utf-8?B?S2lwZjh0dFhXYS9wWXk2aksrb3h2Nkw0bFpMK1U0RXk1OW05S09aWkgvTVNJ?=
 =?utf-8?B?VnloV1dMS2kzMzRNNmMvNngxUGlldGNtZWpXQXRnMllyaDcvbmNaUm5sOVlJ?=
 =?utf-8?B?bjdMZFlpbkRZdSs3cU1jb0dRVWo4cTVSOHFZdG1ZTzJ3U3dGUDJOZUZ5NlR5?=
 =?utf-8?B?L2tLT1R0VkRtaVlDWmVZczJKZXRDT0EvMWVlNXZsbGlkU251Y3Y0R1hxdUJL?=
 =?utf-8?B?MG9ZVFExcHByTlZKNmF2ZERJalNZS3l4eUxYNThXUlpMdU1jWFBtQUkyaUxT?=
 =?utf-8?B?dmNhdFR4ZnZrSHBuY2ppb3V4T1BMZXNOVG0yeW05cWZvbkZLMWMzblI1SmJa?=
 =?utf-8?B?NmlmeEFwU0pPdXFIcnRZNDhTaStQeGsyaFZaNlNBMnpDVCtXQlRpZ3FiZ1Ni?=
 =?utf-8?B?QnFWM1NLTUVqNWJ4dFh1djFWekZWNzVPZ0JwL1NNdnh3OSs5SC8ySEVQVm1z?=
 =?utf-8?B?dkk5T2h4NDl6emthcFFMZE5mSTVXN0k0aTZuSThBT0kxY3VWMzhZYlZqVGJS?=
 =?utf-8?B?QUhrckI1RTdCd0k3MnltM3BGZEpOb1hIeGlLVmdyYkV2Q0RFSXJuTWpuRlFy?=
 =?utf-8?B?VnZ2VmI5RFZrNDVsaHd3Rm8xQWlYcW42SWpYRHBQYk9CWEE5YkJTMmdHbk9L?=
 =?utf-8?B?aTIxS3NBTTByaDNrUlZMV1BHL0wxcnlKWkZjVnE0YTl0bU9oamtrVUVtQ1ZC?=
 =?utf-8?B?MnhmTUpnVVUwSXJZUW84Sm16NnRFZmNkT3ZJRXg1aFlDYlRmSElpaXRHOXB5?=
 =?utf-8?B?VWVML3dXVThpMEpVdmtQUDZLTnVIYlJaRnlsem92YUorZEFWZXh5Z0ZyMnZi?=
 =?utf-8?B?OHJ2MGlRY3lsanVZQ1IrYjVRemczUVJZOGtMNjJGdmZqN2FsTW9uSDVRb0kw?=
 =?utf-8?B?czhzOVhPNG43U0xZL2FyV2JFbUF4V1ZmVitnNzIvNFA2QVNUZmVQV1VYVlNa?=
 =?utf-8?B?Ry84QTkrQXVuaVJGSkNtai9VbHZWLzd0T0FRQWIwVHkycEtOZnBtQ1NnOVBU?=
 =?utf-8?B?YWRreWVWUlBGQ3ZWMDRtbVVMdHlXdUp3cmxzMjFYTE04MW1RaU5kQjYxTmNk?=
 =?utf-8?B?SVJpVGlLTlA2T1p1VkdLdVpRME85YzBTRHNiU2VTSlc3bGxUL1QwM2cxVDNp?=
 =?utf-8?B?WlgwVDVZSEN4TUVwc2ZnS2ZWZnl6ZWlZNnRVaTZqNDUyTXdmdjhjZGJzUmlY?=
 =?utf-8?B?TDJwNmhJOUxwQ3BEVGg3YngvR3JpY1diTldnekxtcFZOMUxKY2VtdzBNcHdk?=
 =?utf-8?B?NnNFNUV3cGZnRWdBWGNvTUdxM2pWbDJkaXVPWlVxa2o4WnRQWHZMVnc0MHZN?=
 =?utf-8?B?ZENGMm9vc3dOVmpGWUtQZnlmdHhleXhvaFhzS0NvZW00ZkNGbkpTdlgxOGxl?=
 =?utf-8?B?Q1ZRQmRnQmxOVGZQMW5yeDJCZXJWQk1XT21BNjhnRCtiMzVlYi9JZldTaWlp?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1OHeb4mV8OuwtwNCAwKknf1nFJEL9iqYOkyiatgQ3ozf3yzCU4LMb3wLCk7f0qkGrfYbwYLcnkpi6bbuxHQrhdEi7CEGuO4jlNq+GmN8AGjf7ImFtBG0b40lsqbQqc1nzkLgaFt8AAh6r02afhUri8b3s0QTTqSGKz7yyU4hUWraguOhY212t8IYBcW0TD2ATqlg/SEc3fIAwtFXvOk1bhh3qi5xwmI/w3BORTyVvcH7sAPo8ytY6RsR6uC9I3bTRAtIhPBXjBiOslLExwARFwLxOdc1/5BNWxqnV8ZWi6UdtCCjZ1220v55LbaaBla34RIqjqxuTl9umz99km64EoCBoYotRsOy1QRTU5wmDHmLBOpIwi5fjNuEcfDUpv7ahIuvHZH/dltmbPipoG7O3XI565PdVw6RUjGF1e6GladN3jcXkaoNDvPZThs+lkF+hezzhuUr9gsqA1GSZWbZxv6/3r367PmhfdqrzxERHkt5I44s3U7EiSOk3O3z6Pjvf2KCF0K0o3saLU09KKN07sJgQQmjejka90OT9ce3BTNzw9Z0cCR43K3NDln7NUyUTQ7dszxa2r5bBN3H3pyUC6rxdueg3czaBGraWXOFncY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cefa7b9f-c1ae-45a9-2e4a-08dd6252ec69
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 17:17:25.1249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wl6A1mZFzoe1l3nqfo300SWAVkGX+/dFU4coaaOew7oM0SKwQW4rgEcqQGzAycUKmSv4JqNGXqArSADD1M6gWhv/Av2r8qZDppwC4QgPpOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF87283933B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_08,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503130131
X-Proofpoint-GUID: WSrh0k9hb9HKmGAY-DJWZMhLPXtXwQo-
X-Proofpoint-ORIG-GUID: WSrh0k9hb9HKmGAY-DJWZMhLPXtXwQo-

On 3/13/25 1:47 AM, Christoph Hellwig wrote:
> On Thu, Mar 13, 2025 at 12:18:01AM -0500, Mike Christie wrote:
>>
>> If we agree on a new virtual NVMe driver being ok, why mdev vs vhost?
>> =====================================================================
>> The problem with a vhost nvme is:
>>
>> 2.1. If we do a fully vhost nvmet solution, it will require new guest
>> drivers that present NVMe interfaces to userspace then perform the
>> vhost spec on the backend like how vhost-scsi does.
>>
>> I don't want to implement a windows or even a linux nvme vhost
>> driver. I don't think anyone wants the extra headache.
> 
> As in a nvme-virtio spec?  Note that I suspect you could use the
> vhost infrastructure for something that isn't virtio, but it would> be a fair amount of work.

Yeah, for this option 2.1 I meant a full nvme-virtio spec.

(forgot to cc Hannes's so cc'ing him now)

And you can use the vhost infrastructure for something that's not virtio.
Hannes's did that for vhost megasas:

https://github.com/Datera/rts-megasas/blob/master/rts_megasas-fabric-v6.patch

but perf is not good, it's extra userspace code and I think it's
just a little more messy because it requires the extra
QEMU code which I know those engineers didn't want.

