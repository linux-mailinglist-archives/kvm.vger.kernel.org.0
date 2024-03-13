Return-Path: <kvm+bounces-11770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA2887B371
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 22:27:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A05AE1C23E60
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 21:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E12553E2D;
	Wed, 13 Mar 2024 21:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PalzTqyB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FnTzcKcB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D2352F7A;
	Wed, 13 Mar 2024 21:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710365269; cv=fail; b=LvppFQpos63f7/PcvCn46jQyfS3T+9N/VuFfsRsEQVaRSc7E5je9kLmNN0+U2P5oleHqK0Xxg+46PkdUltxI8wyi7fdeNcKbNJ+jtR80RTdpyXOtPyPlWLltOrZX8ftRuWJA89ingugQogb+p2riABx1TKYI5ecGF9GoqxkKYVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710365269; c=relaxed/simple;
	bh=g/A7vvQRlEY1MYwW5kNgZ0IGsfDbzSos0le34mGNJ8A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KbMzvoz6T5gWohITqw1GK8yg8vk128WtUVrX4KW8Icyq6VOuXOfHDDl3pR8y/XyzAe5DClxAbiSOn3AHdKdUG+pR/CMIt5WOP2q5YQIsQi3jP1/3iX699dpF5ZuXI4GR+9U4ovrOIuJCZKEUAdAsRRcBidWMFw7L75FyHW3XXLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PalzTqyB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FnTzcKcB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42DKxNGj007099;
	Wed, 13 Mar 2024 21:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=G17Yn8F94pJ9GW0RwcLRsCfim24i33JOXliH7vMtiIU=;
 b=PalzTqyB/UBbwXyU4MbltCMSUixEvAxAacZ9n7LgX6IjueWT126AFyPWA7iW8tVeG5/7
 MPFC5uDSMXRLnNUjxDkk0j2O7KfPluwPyNmSii/LxUVn+YdSXL00MPbanqOeTRylWkCS
 d5Zx7dkFwhViQF6+kK+/zGcxjE02kSxS/Dfau/UIc9UdH8ALraS/tpm/juoZp8hJndrI
 n19VZH6z564OGSDdph8qGIvUBE92XzzGMYf2R0kJvYLljPoQm8YpHizbblDa0bQnBKTH
 2dBlCshnV7p+ZBP6cpr/+Y8LWE1Nczhe8VwNXsQuclap7Jxs0RZqX4dDqjWEFoHh+d5Y kw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrec2hy4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 21:27:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42DKg3W4037575;
	Wed, 13 Mar 2024 21:27:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre79fhqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 21:27:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jbfwin+b15AH3E0ndjSiW/KpbmkDEUR3IyPErydr4d5hu/puFS8FFbDZx++CA6lrcaWmYp0Q0vMY42lYe5TiFdqldoIIWqxxu6cHA0zTQbzuk/m+Cd3BCvR5pocqhA3BY0/lhTdjhbGkiKALK0VD1Mk4XwkndGofQarpxSBVhYE7eTbWXPf4UHAhakRzYyPq8dp7JyL6quaVPnr/aukAHIKVaTzqZg5bVHIgv8ydEQ0wk5zGAlf6zu5DJ7EgyMTLkxPq/JJgibuQuL88b+4JdCOvI5dUozoEmeZQbdn3ga/V2VLbqvYge/zzMVyEk/6swKF81oq5D6iR3lm7Vggw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G17Yn8F94pJ9GW0RwcLRsCfim24i33JOXliH7vMtiIU=;
 b=cC2Su5C2jWY545/YCY7WD2XTgTzkG4Gxt5WKnDEkmdV0kEUjnGUIGfdhjtViwVI3JuftaFgm+Z5NBhUoM9jbIc7JWoxe3pvaArNJZZm0iJX5qZd/ESdNyd//JtYtSs6E7TACxn6sxkyrBzr1FZD/ynQZdfT2gdPwtKg+2y1Wt9W/HLifA8047gyQ/tWaknS4gJLuu8lwe4hnxUacJW/UDJOdgLVpkLcWVclmCuZquHHGHwgknk4lh8OZYqqz2RQYJ1OfBON1Pg63j91K5BwgopLJHbD+IqvB/NcKhPEctGSxs3rnrGS8N4p+584Hk1FXzeVRYKispG12GO4syGFpGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G17Yn8F94pJ9GW0RwcLRsCfim24i33JOXliH7vMtiIU=;
 b=FnTzcKcBmT5Ti+f86WNymaa3eqBOTc+pwOc5xG9JmY3w++XWtQPRc+5GV57YmW9EUgSUVpEd1y++ha0b9zUK1ESFiuLuc+9wx9Dzw51aJ9qp40RdkYDW4Z8lRhtOjTOjp6XF15cq9iEAbrys0aptaLB9igLBfXNBqVMgq+JllOI=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MN2PR10MB4189.namprd10.prod.outlook.com (2603:10b6:208:1de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Wed, 13 Mar
 2024 21:27:39 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%7]) with mapi id 15.20.7362.035; Wed, 13 Mar 2024
 21:27:39 +0000
Message-ID: <d91a8363-df75-78a1-467e-878a04859ace@oracle.com>
Date: Wed, 13 Mar 2024 14:27:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "hao.p.peng@linux.intel.com" <hao.p.peng@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240312173334.2484335-1-rick.p.edgecombe@intel.com>
 <ccb21523-54b8-770a-bdac-c63f9c8080db@oracle.com>
 <60d6242e12030c744ff88322b84d0aa586e2d43d.camel@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <60d6242e12030c744ff88322b84d0aa586e2d43d.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P222CA0021.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::26) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|MN2PR10MB4189:EE_
X-MS-Office365-Filtering-Correlation-Id: a1c64328-de2c-46dd-19d9-08dc43a4689f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	eNSQdEnJsq08WZITh2S3kgbtOC/REnzlmeWBumP/2x0CMl0DPK3n1QmNJOSJW+nFclkYP0CUAQJJUUqEiYHFXy5sHbkGVEO8O8dGbvODrM3ywZkSKlql42YPrgippepmtiRFxXPLShwZrpKGmPZWSRu9BfCvGESjSeRFfyHG7a9/EEMf3RWwCFC4oGY5UDNLRGx8ktFmPdAlAC5tfVyw7JdarYdLSrwB1QDMpPEd3e7gkNcXmLMxeauf1adiWA0I5vY1I+rzp5PjSk30f7I+jfnZfEl1aRwvpu9k7Am3nLdzP5Sg9IMLvE/MNaL9j5aWcDARqCx6uEAELXNcrhtHZdyyqY27vDGbwF5+MkLfQdP+bU/+pA5A7PJ2g1ljSiqNysOTebqkWOtHi2XgHmP+IwmAUHMMh+qkcQkhFwC8S8/aTiR0wxO9v7nXlQSW9GeHEnn7T0ckCwK0X77Eur8HUi0K/I7RKOFO1z6hKyb3z/fPpGluRJnlCxVr69GxnIH2H/eP4dOw5aP6H5asLDe/oFf5sHgfdsbXPC2iqgMO7riupqBAwFrhCU4Lg3z4larNLTy0YOz6lwX7sB42BuKa7AHDQs23ncGOmS4SF7K8LUPmULa6xCF9w3ZOyymTq4gAMn1UbVu5z3bHolyMcIgUp/zKnMvI2gd742/5zE88QRw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?alpsUzZBemZtTDVtRkg3OEFGMUsyQjB0NmNoeFA3ZHdKdnQzYXVXMDFFUmQr?=
 =?utf-8?B?dW1HMlAyeTlOckNacnExRlZaL1RhN2pvS1U1U0kreDdJRmJVWGpZQ0FKSUJa?=
 =?utf-8?B?TGtIK2VqMkorZG1rRFFndE9qdCtXTnIrMitHeStIUldpWlpZWEFvVWMrNmtL?=
 =?utf-8?B?VWhuYUE4MXFuc3BCM3Z1WDNUS3J0akJOOFdVU0VjYVBxcC9WZ3poY29LcGQ5?=
 =?utf-8?B?ODBFdHBiQ29waHlUR3g3dG9zMG5mRDRZMjBOS1VMRVlIcTVzWjdJbEY0eFcv?=
 =?utf-8?B?Z1lzblJFcUl6WVpEQnZ2ZDNhWm9WT3o0bS9rRDM0S2RURk1GLzJBR1JYeXlm?=
 =?utf-8?B?cklzdDMxMXF4U2Z6RllnTWJsbndFOXFZMERPbmZsZk50ZVJhclJEOUVOTHFs?=
 =?utf-8?B?UkdxbmFiRmZGTHJpSkxSZzNvUUlwYVpmbmJoMUZHc2tIK05EYWxSUTRBcW5O?=
 =?utf-8?B?WFRsZEYxUE9KUWE5bC8rMXRWNnJOcFZWb3pxeGlBV1F1TkNqV3VOL0FHcVla?=
 =?utf-8?B?UTdKbDJ1VktjOW11VmxZZUk3aitNMXM0c0QzQ3N1TFNpYUtxMFp2dWc0ZjUx?=
 =?utf-8?B?MXhvM2JGRkZ2NzcyME1ZZjloWUZnZGlJaEo0REJhTXlGYnlLU1FRK2owclF1?=
 =?utf-8?B?cDE1T0tXd25wSXJqVW5NQ2V2bXpJK0ZCQzVTOGk0YlNRZFBockZabXYvcHRW?=
 =?utf-8?B?dkhLMWNRU2thbUVBN3JOTjAxTVBaRmRPOHpqSmpmaWdlZEd4RXNnYTd6UlZj?=
 =?utf-8?B?UGFSTXU1VUUxTGxOaE5RVnR4WUtNNkE4Zm5EY0pxS2JOeEpiL2doTU5QZlI1?=
 =?utf-8?B?SHc0UndkTUFYdk1xTWZVM1VJakZBcWltSm1xR2JBSVNGWmpBV0Noam5JOExo?=
 =?utf-8?B?a3FuSVc4dm10SW5zNjBDdzhZZjdXbkpYNTF4a1B2UjhqcDArWi80dUJDdFlN?=
 =?utf-8?B?V00zQ2VoblQ1TFlSQXRVcS9ScUVxRmFsOElKY3BlbXFtb1BubWpHM3RJWFRt?=
 =?utf-8?B?cnlZSC9hYnk3alR1RUdWbU54MkpRSlI3SlEwUmZiVitmZTJKcTJoR1B6NXZr?=
 =?utf-8?B?ZTdBaFFDUlBsL1VjSlM4T29uL1ZxQTdybXNzSFBYMWhwemxzY3Bob0w5YUVY?=
 =?utf-8?B?WUliY3lYcHA5emI3cllCZVBLNW1wcE1kbVV1YUNsWEJCNlRCT2xsUWpXWEFi?=
 =?utf-8?B?YkFuaDFrLzhtek0wSWJ4UW5ETUhIZ0JqWE9GOFhqWEVSbU1xVFpaMW9ISkRt?=
 =?utf-8?B?ellFc2FBQkNYRXZ3M21IZzNDQnVEbnFxeWozN2o0WnNXajk4NklZOWowSFlV?=
 =?utf-8?B?czRlSXlRT25rVGxEcnkrSmNXeXU4dEhUNW5SRVNLVlBGYm10RWRMeldubzIv?=
 =?utf-8?B?ZmtUTWJpaytDVEMzQmlZMkhSaDh5RVdZcWhyUFBpRjlOT245K2U0MzlCSUND?=
 =?utf-8?B?SlphKzJnMm1NQzljdlBUYmg1cXpETm9nOFdteXRPZzd4WG5pRWxkK2dJM0Ri?=
 =?utf-8?B?TTRyUGZ6c3BiWkE2NUlFUEhQZEtjTmxySWpPNEs1VmIrTG1BTXpPWFd3SkpG?=
 =?utf-8?B?NHNUc1l6SFVrTFF4VWozRmlFeHUwSU0rQk80Q0hHUVB6SE1lQ2tPWVFvUDFo?=
 =?utf-8?B?SjZtMStLYmZEVWVFWURNOXRjN0thRllmUXVGaytPWnVSd1FuaFFoU0xHVytO?=
 =?utf-8?B?Ull4QytzSDZHQklsN2xHcmUxemozZG1BVVdXeXQ4MjhPc2JocEJtaW5hOCtl?=
 =?utf-8?B?MXhDZWwyQ0d6UGdQQXRPcU11SXpzQnlSSmJOVEt2NkxCRGIvTHpJbDhteE9t?=
 =?utf-8?B?S2d4aFNoMFlTQWFUTUlob0pqZXRuZ1pqY1NGa0RMVDZtKzdkeVMySjVXeVpY?=
 =?utf-8?B?V1BMT1dwcFlobWdFekZEWGRFMzhBUVhETUk1YytjUHNrUE1xQmlLaUFXakE2?=
 =?utf-8?B?K2V1RExtdVdPZlByM3VEdXhtWlFPWXMxNjdnM2lFOTlxRWlpL254TENVbmhR?=
 =?utf-8?B?SjhtYU9IWGd4NTNvaGRwUlRJcDRVR1VFVm9hVDVDMUNudWdwbFQxK1pqTUtx?=
 =?utf-8?B?TUhyQ0VGQWJIVmxxVkFRS0NORmV3dnlsTnpTTVBuUVNNVXpxMklaSTNqSGkv?=
 =?utf-8?Q?akAVSP9EYtd++IZDV0hb/sRMP?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GZTrARDp4BuQc6+udYj3UCt0kdslIqYAIxyjSYlnBt1WMoUIxLGc6aHQ2vPH0lH2IfeFPZsTBTeumTOgDzTV0cG7Y9w1XsuJqdiqsgY8Y5uHmqgUcu9nFly5anmVzrzNNrTOCmiWN4VmHLYlLpNkwo6yIb1nzn7mmeINdZzwD2A07wDiJFVzxnKTZn+tciA1hrhu/mXC+rC/JB38F3iOqgVdIE+ZF0QPGXv/N2kj1kMdCJ12cXWJSK2DZkWvG8O06xjMrzPLHu0riMBxnVkPc/o1XEC5/xOzNjDNVrSUSP2Lba7AvA0Qv1EqK0l5gmr0ES88oeJS5952QSLFrmEIxFNZG118lYPv9BLft6sx7JhPs2hodOtZgNwHK5Uv7KvzZYQyHxJ87VF/7Pde+TDCRyrX+gjBHZSyVU58rUzmrT9VV3m+LLPogIazNdjzTcFxAnvpSYwmrn1KzjD5ZJ6MQQa6HXwy4lDZD30LnN6oCbNZZCyp17WvX0dK7l+DZDz0EqHIj3KtKCfJBycv/N+kfYZylf+K7sMplZ/oC5465z0u7qm3d2DxJfcbbUNMlc5lo7DL/Gm0BCZY/0+BrTtkKyM6hjR0Lq5UeSE6TzvmSg8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c64328-de2c-46dd-19d9-08dc43a4689f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 21:27:39.0673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGgay8L9a2DnoyWBAmY+FDVdYj6+6mUAztY4nwW0doawdB99Rf1KRjaGImRrqThzQElckLzNe3+zL0YjtqIXPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4189
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-13_09,2024-03-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403130164
X-Proofpoint-ORIG-GUID: gLurLdo2Nqkl_gpb9NvR4fl6lHHnFuUH
X-Proofpoint-GUID: gLurLdo2Nqkl_gpb9NvR4fl6lHHnFuUH



On 3/13/24 09:25, Edgecombe, Rick P wrote:
> On Wed, 2024-03-13 at 02:49 -0700, Dongli Zhang wrote:
>> The memslot id=10 has:
>> - base_gfn=1048576
>> - npages=1024
>>
>> Therefore, "level - 1  will not contain an entry for each GFN at page
>> size
>> level". If aligned, we expect lpage_info[0] to have 512 elements.
>>
>> 1GB: lpage_info[1] has 1 element
>> 2MB: lpage_info[0] has 2 elemtnts
> 
> 1048576 GFN is 2MB aligned, 1024 pages is also 2MB aligned. There are
> 512 4k pages in a 2MB huge page, so size of 2 for npages=1024 looks
> right to me. One struct for each potential 2MB huge page in the range.
> 
> I think overall you are saying in this response that you didn't find
> any problem in the analysis or fix. Is that correct?

I do not find any problem in the analysis or fix, except the same curiosity on
KVM_LPAGE_MIXED_FLAG.

Thank you very much!

Dongli Zhang

