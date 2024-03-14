Return-Path: <kvm+bounces-11789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2AC887BB46
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 11:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C2232B22465
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 10:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF375A0F8;
	Thu, 14 Mar 2024 10:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bSUUkpBB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G71I13wI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC56741C63;
	Thu, 14 Mar 2024 10:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710412289; cv=fail; b=BT4cjbtz9s8Xxxur8Or1bGyhJiPTq/VdKzObuhKv6VXKUMblZGAwG3WlAQhlMzTsrXrNswl9rlypNpe/1zs/Yw5yPA0UCKMBS5rkBlonjtmvOrbEJ2LfBe1DRRDWQfJFNx+fQcOfi344h01gX7LaWLeOpsECPyqFzd4LLprGzp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710412289; c=relaxed/simple;
	bh=a+9PwkQU6tt5rHCiP+sbFRFxV+R1E4ALh8NKwwTkhRc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fEAKHl0nclqP2UeNY5mkvzeNwRSvFJAftFgavuTREU2CJA4O8J9WXOy8Gubjv8nppXOCUD/x2u8azT7Cyh6UKiyfHzwSQTpwxuRJ5OEEzaFv5s1ef+M1UsnOgyPbYMBGGMpVjH1RFQOZjtG1X2M2800wycgkGKmSPh7s+KXQSPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bSUUkpBB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G71I13wI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42E7mqDU012788;
	Thu, 14 Mar 2024 10:31:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=i/oGxaKE1VhPXh19l37asioeWukUmmRj0YSFjijl9Nk=;
 b=bSUUkpBB0Rc9rmkI/lY7DWZB9Vk11NHmZ1eTyjIcqcY1elE/PAQxiV210QbSpr/YY1lr
 nzx5105dRKWHJNjEhe5P5kits0xZ4q+szPHcbx0u6DLCG8m4K4Sr+f4LRkWADxqmyzUP
 sf2R68oqSG68NMA2lLdwXam1GuK83nYTuTWRf5hgyCks7aEfnaF/g4nLxTqDVhrv5cZj
 05Lf/l8i/Vdcd0sb5LvBSMqj/B48G57FaTe8nhFtvLOu9dQfHeb7zpfpeXxjRl7EPNcD
 7BA/tUDMBorBocli2EajQ05Mwhivn7pL4izE+Q2o7t0coWL7uwHANxLQ1SzahIIlmLjz +g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wre6ek3et-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Mar 2024 10:31:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42E9LmAN009173;
	Thu, 14 Mar 2024 10:31:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7gdhhm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Mar 2024 10:31:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1nCo4wyecTo3b1SpNsCus4U8ttbKM5KwcgYEMUEQaLqrCfpy00iyXl1QYYOV1M0hInpUU9NoNe3nQod81In1jDc5wh+jPQMRTqB7qBh8DSrQ6yNYKKJxaQ/HXC4xg3WLWYeMvo1CxSbiCrwpj4GrvR04E/+cgIfRXmR1FeMaSpGaPi6kGHVdE7oV7gJVPUjEUvYdAmkNarhNVe3g+hNri/E2Cch/TUf7ekh4bfFc7c1Dj8qPHdAboJfYrb2TiHtNP/qcTvsUlGZbMpiCwcyz4ZDE3VaI31zdpz/hjBpv+jD4hxz1BTvCFM2713ihAO5LNqvJsHmPfuL6NwCL9Czcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/oGxaKE1VhPXh19l37asioeWukUmmRj0YSFjijl9Nk=;
 b=l6iMf0PuRLO1X6Nwv/t545TQLkkvYbQRNG8pH/BmRYYygwEw4Km7o8RekSiaBzxJD6MkOZtSteFcp6DE4vFtf6ZOUkA1ka0s5rPQT0eIVjngwL2oWrEoK+DdpclyKePCn56OWgWkRhv71yC73TeUqjFqnsDw5C4LC0Gwqd6s9EEHrST18aDcOR+zqHfQcQz0WPcvXtP0N9gkXjNTvg75Ns41anzwXV9He1gWvx5zeZAsFmhsvLxGIRExoTqYqLE7oSL/LffPCD06CKWUroevLTR9KgbUHQDaBrtPRlEuokg28RRY3SaTWeBgYwF8+qvqp9XFVa++ZJJxsjw3A7J7zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/oGxaKE1VhPXh19l37asioeWukUmmRj0YSFjijl9Nk=;
 b=G71I13wIPWZ42Fm8OvCM/0864UEMOXy4bF24yodlaVepLXkePjUF74KlQjz+kF7pu0IxKfpXDi2y1TkMlJHfTS8gD+cRwZ2oHawyUi/Ph5YbotWsC8Oj0KVP2qM8D3ISmIWj+oGoCYcgKRZzFU32Pg6lGCjtMcCxzhybd0FtTOc=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BY5PR10MB4260.namprd10.prod.outlook.com (2603:10b6:a03:202::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Thu, 14 Mar
 2024 10:31:15 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%7]) with mapi id 15.20.7386.020; Thu, 14 Mar 2024
 10:31:14 +0000
Message-ID: <73c670d1-0301-49bf-472c-97ae8d1b6c7c@oracle.com>
Date: Thu, 14 Mar 2024 03:31:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/5] KVM: x86: Remove VMX support for virtualizing guest
 MTRR memtypes
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney"
 <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, kvm@vger.kernel.org,
        rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
        Yiwei Zhang <zzyiwei@google.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-2-seanjc@google.com>
 <5ee34382-b45b-2069-ea33-ef58acacaa79@oracle.com>
 <ZfCL8mCmmEx5wGwv@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZfCL8mCmmEx5wGwv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:208:c0::42) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|BY5PR10MB4260:EE_
X-MS-Office365-Filtering-Correlation-Id: b2c5715b-8f1a-48f4-f8aa-08dc4411e041
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	D1qVYXchorjTeWnb2OUUV74VAUTd+YXv4TxMPKoHix6XLd0LKoMnNxsxI2lUhPFuk7uPCgc7UalWdKkfVCQ1dSDVvaZw8dsjjKFIPS1vXw99h8FzTH1pk6TGg8zf2vw7AnouYoAF44G8j1/scYppoCnKkJW4h5UDDUmDrMSCGNdehr/C3a1cTDdNZMI75Yd1nKD1irR30CFJ5iVUfaEH/b+qDbFZbgvvHIYt9nHUxAXaLtLH3fsqu/pz+3uxtmH7UcoWkc9zsuubm2KGsgeX8LXexDujumDVy+xRaKn6iGamh2jjj+bk54y0oi/lOWRAvva1NFI2WdXMLI0YbqZsxhlxon4yDJq6UIhKDef4SjSELOmvI0+kmD9P4UShXCYt7gLfbWq+QHEnEHNJosTszdQnDyZ7ehQIgghGJmn3GMqf7eGt65kaL/sfY5IYu/KuMPtKUJKgH4TqIOVQIGQLvCj2COcjj5Pg8CnLDrVTaOcAyRdOJZAwL2eT8FHQCYlAhoI0qNNX84xYA8hRcnvONBxqCZjVUG7XkZAI6L/US9KSY9ajgJw9rtLerDDlhUZ30Y8Q3pYzdBDjTPnBnbkjt9n08KMvU++5q8pjROCMrPepCklDyd8GkFTM6Arj5BcgfDMejG9isp0kvRZk0hd2eYR3uFMPIez1FQglpDsTFb4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Qlo4Um9WZW1RQ01xZWNYa1B0S21oeFpya2JpaWVFQmNvVHZ6dTVkSUkyZjZX?=
 =?utf-8?B?b1VESUZtL1dVcjYzY1VOMDdZYTJDR0xhb0FXb1E0N2xtckxlRW5zRlZrdEJ6?=
 =?utf-8?B?MlhoR2xyMXJGVWEwZmhnUXZyZXJ0b1B2RzU1TTJ0UXdHMTh4Mlh0VnFWWkVG?=
 =?utf-8?B?V3l6OGRiMFY1d0FQNXhaNkFQL1JrNkxLNkpXM2FHTG9OVnFiTnZZcENNMkk1?=
 =?utf-8?B?ZzkxOVROc0lkTGI2YjJmeDlrZEJoejlhZk1iamhsckZIL1ExbnhtWk5iVTdY?=
 =?utf-8?B?cEJoUENJVG1JVmxuQ1pqSEg0Qkx0SXFaS1lOb2lzV0phYmFCT09ZM3N2dVRC?=
 =?utf-8?B?c3FzeGs3OWdGV3pCQnBESFdza3FtYzRiUXdkbm5sd1BpOGJkTGRVN0xOdVVo?=
 =?utf-8?B?a3JYbC9RUW5xMWt1WU1UL0RyK3docGRJZkNYdUh0RUFUUzNRdElNR1ZIUjFZ?=
 =?utf-8?B?VmVVdnMwQmtSSlNYZWdLTmYzaW5vTGs0TnBSRENNeGRKbkFXa2Jqc1hrNCtE?=
 =?utf-8?B?YkZyQ0NGMHdxc2t4dWtyM09MSUMzZFF5MzZSRUtDdmtUQ2xXdmpISjJ1UTdS?=
 =?utf-8?B?NVNPYXhQNFBZVlF6RnduV2N0ODg3RDkrYWt0VGJtNkRYRXNPR3hKMGI4K2Z1?=
 =?utf-8?B?Wnkydzlpb2trMlpncllJK3dmSXR0eUpPemdidmJoWFZmOEpWbTNRM0w2ZGRz?=
 =?utf-8?B?WFBYOFlTaWtDRFNiK0pNYUhDdmVwZ1VxMERZMkdiRndGSDR6MGZ2V01OZ1Zn?=
 =?utf-8?B?cFV4TXZrTzJGMUVEYzloODgyU2thOHVsTmp5NUExS2t1Z3ZZOUJaSmhpREd0?=
 =?utf-8?B?SURGZ0lUekY2Zm1NTXhwLy9OL2xzeWIxUFJKRUVIRUtEc0JVT1QydkF4SDk4?=
 =?utf-8?B?bngvVzJvcERxb3JCMnlYSVcxR0E4UitzV0p3T1lobnJ4MmwyTDJsK3c4cEg0?=
 =?utf-8?B?QWFlUGFtQ1prSUMxd1U5WUdmaWlnS1hQZHBIV3NvOElIWXpNb0ZFcnZOd29n?=
 =?utf-8?B?RHphNWhBbG9Db0RBcC9KZnI1QzFucllhUklqMkFHbEMwdmY3dndOMkNpUUNJ?=
 =?utf-8?B?TWFhTVMxei9aZDV3dFg4UTZvQjFUaFZ5YWIzYUtSVXc0Tk1qb2QvOHZUdkI3?=
 =?utf-8?B?TGFnRHhBYzU1dkV3TTQ0TnRUZ3dWeDJoNXhKdE5yR003MmdueEtoMW1tcVN2?=
 =?utf-8?B?WTFoUEQzaHpxRU85LzhIYmk3TmhmbUVCQi91V2dwbmc2OFB1UFdSOHFod2lu?=
 =?utf-8?B?ZGpEUURtYTNHWlM0amhzU0NoYUlEOFMvVzQ0aEM1OStkT01XRWxjdnVCQ0hC?=
 =?utf-8?B?WkJvQzhHUFBXRGhZbXhmYUxSVXIrRnZwK2pXQm9sNUhiajJBaDNPSHpZZzh4?=
 =?utf-8?B?anptbmVuS2pXbmNiT3BzQXJMZHIwNkJpYTMzWHRHSXB5WVhZbGNveUtBYmVX?=
 =?utf-8?B?VmpKMkdSWitYbXZvaTBxSEtueXJlQ09MSmRlMW1jWUU2MmhFUzFyUnh0Ykgz?=
 =?utf-8?B?YkswOEhYNFZwb1U0OWNLVTF4MlZxMWRjTHlxWVVSNVJYeHpIWVNSTkRIYWd0?=
 =?utf-8?B?TFp4cUVpNTlOOW1zTWZESkMrZ2FTMVN1bDB1SEtVVWp0UVFRTnV6U3oraWhw?=
 =?utf-8?B?eXdkdU9iMzdmRVlybEpYZ2lSRGhYN1ZCU21aSHhMeFlXdE1pRDdHbGk2RjlD?=
 =?utf-8?B?eERWeDRZdDU2MnVOVmpWa1QxN0dlL3BqYlljTzcybmtTOFRwMU40ZzN6anZh?=
 =?utf-8?B?blRRV21UelNzSmxvS1Mya1NwK1N1d3R4Tk5oZVRkU0tFL3BWNitBcUREZy8v?=
 =?utf-8?B?NjRnMHBiOXpLL2F5RktTVFZhWU1UcXpvZTRvVFJNaTFYOTV4MDE0V05OZWtn?=
 =?utf-8?B?bGV3WkE1UlJQWjhDVWRFd2hzaXFmR2pkOXZmNkQxa1hqQytyMXlITks5S2NJ?=
 =?utf-8?B?aWNxVDZudDlIUHN5ZW9qOE8rY2ZHc0hFSmJXOWFkeStCaHJLSUJoWnFsN2NG?=
 =?utf-8?B?bEdNSGpyWmJFdVZManhOUDhHalpDSnhuYW55RnN5cVE2bFNtWjQxMmFvYlBS?=
 =?utf-8?B?UTF2blNnUjdJdElkQWN5aFFBc3IxbkhqMDRaM052eS9yTVBRN1pVeERSY0xP?=
 =?utf-8?Q?12U2UYygX7DR2SjwlBOGLUzMM?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	4UJS+yTOlA6nxsg7tu2BBsaycte53eoIe0CaxRvSxzWCxu/M5ZFOpSrsONGnXOMosH0hZuAHUmze3lheqkU3Hx/ClNgOSC43Qml6rVeHT6xKNsB+zbQM1JZ+JpxcMGE7eM8V6F1UPPSd0y+CWgjspwKbwmsAnHerCDhOHOmUUtzwspz3BJpJLDC0rkskmps5VnsDWUSwhL7bMSXrZDG5s3uB4mgJFElVMCQi1Cqi9H+eyp3a+yWJ1pM0ge6WAOC/CTIWlTQLUuAzlxSogn1bPExFLpHuDz01oHbXRsq7YGVG3TueVMmWKtETm8wS0/Pl8tlLYcWRJpdERoBBMhaZy4UqHhGxVxxzjyX+uretkCsxzryjGM/HctmXhIxkdLIAPDboLvAcSG1BhBtVB+2MBFLj5ZckNiF0WB/QKx1cxMWtS1IjlkLjZZjYeImItJqZ/4QkGaMxQakXsDr9sg/8HaG7qi04HnmK0IozI9l+IzpgMNF4EdHnN9tjYvmgONGQHI6O0ybbXecE8ITvY0eJ3Ykk/Xu8zr67/x1wRmuJEvi+QH1Im3wp8YEIaXWxnJo3NlChYkt38tiOSKRudQvrg8V2hRl6JrBUmveFxvZNO5U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2c5715b-8f1a-48f4-f8aa-08dc4411e041
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 10:31:14.9211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wA5NbcVdjEbtwRovkiBwMMUYgrbOZmVZwuXQguuRBZHA5bnrp9X4VA4Y5W/hIh/IF/WCAWbAFHJnOoD9RyzIng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4260
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-14_08,2024-03-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403140074
X-Proofpoint-GUID: LqbD3E7HzrP6IgqhLrsx3r8Qx9OEG5XK
X-Proofpoint-ORIG-GUID: LqbD3E7HzrP6IgqhLrsx3r8Qx9OEG5XK



On 3/12/24 10:08, Sean Christopherson wrote:
> On Mon, Mar 11, 2024, Dongli Zhang wrote:
>>
>>
>> On 3/8/24 17:09, Sean Christopherson wrote:
>>> Remove KVM's support for virtualizing guest MTRR memtypes, as full MTRR
>>> adds no value, negatively impacts guest performance, and is a maintenance
>>> burden due to it's complexity and oddities.
>>>
>>> KVM's approach to virtualizating MTRRs make no sense, at all.  KVM *only*
>>> honors guest MTRR memtypes if EPT is enabled *and* the guest has a device
>>> that may perform non-coherent DMA access.  From a hardware virtualization
>>> perspective of guest MTRRs, there is _nothing_ special about EPT.  Legacy
>>> shadowing paging doesn't magically account for guest MTRRs, nor does NPT.
>>
>> [snip]
>>
>>>  
>>> -bool __kvm_mmu_honors_guest_mtrrs(bool vm_has_noncoherent_dma)
>>> +bool kvm_mmu_may_ignore_guest_pat(void)
>>>  {
>>>  	/*
>>> -	 * If host MTRRs are ignored (shadow_memtype_mask is non-zero), and the
>>> -	 * VM has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is
>>> -	 * to honor the memtype from the guest's MTRRs so that guest accesses
>>> -	 * to memory that is DMA'd aren't cached against the guest's wishes.
>>> -	 *
>>> -	 * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
>>> -	 * e.g. KVM will force UC memtype for host MMIO.
>>> +	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
>>> +	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
>>> +	 * honor the memtype from the guest's PAT so that guest accesses to
>>> +	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
>>> +	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
>>> +	 * KVM _always_ ignores guest PAT (when EPT is enabled).
>>>  	 */
>>> -	return vm_has_noncoherent_dma && shadow_memtype_mask;
>>> +	return shadow_memtype_mask;
>>>  }
>>>  
>>
>> Any special reason to use the naming 'may_ignore_guest_pat', but not
>> 'may_honor_guest_pat'?
> 
> Because which (after this series) is would either be misleading or outright wrong.
> If KVM returns true from the helper based solely on shadow_memtype_mask, then it's
> misleading because KVM will *always* honors guest PAT for such CPUs.  I.e. that
> name would yield this misleading statement.
> 
>   If the CPU supports self-snoop, KVM may honor guest PAT.
> 
> If KVM returns true iff self-snoop is NOT available (as proposed in this series),
> then it's outright wrong as KVM would return false, i.e. would make this incorrect
> statement:
> 
>   If the CPU supports self-snoop, KVM never honors guest PAT.
> 
> As saying that KVM may not or cannot do something is saying that KVM will never
> do that thing.
> 
> And because the EPT flag is "ignore guest PAT", not "honor guest PAT", but that's
> as much coincidence as it is anything else.
> 
>> Since it is also controlled by other cases, e.g., kvm_arch_has_noncoherent_dma()
>> at vmx_get_mt_mask(), it can be 'may_honor_guest_pat' too?
>>
>> Therefore, why not directly use 'shadow_memtype_mask' (without the API), or some
>> naming like "ept_enabled_for_hardware".
> 
> Again, after this series, KVM will *always* honor guest PAT for CPUs with self-snoop,
> i.e. KVM will *never* ignore guest PAT.  But for CPUs without self-snoop (or with
> errata), KVM conditionally honors/ignores guest PAT.
> 
>> Even with the code from PATCH 5/5, we still have high chance that VM has
>> non-coherent DMA?
> 
> I don't follow.  On CPUs with self-snoop, whether or not the VM has non-coherent
> DMA (from VFIO!) is irrelevant.  If the CPU has self-snoop, then KVM can safely
> honor guest PAT at all times.


Thank you very much for the explanation.

According to my understanding of the explanation (after this series):

1. When static_cpu_has(X86_FEATURE_SELFSNOOP) == true, it is 100% to "honor
guest PAT".

2. When static_cpu_has(X86_FEATURE_SELFSNOOP) == false (and
shadow_memtype_mask), although only 50% chance (depending on where there is
non-coherent DMA), at least now it is NOT 100% (to honor guest PAT) any longer.

Due to the fact it is not 100% (to honor guest PAT) any longer, there starts the
trend (from 100% to 50%) to "ignore guest PAT", that is:
kvm_mmu_may_ignore_guest_pat().

Dongli Zhang

