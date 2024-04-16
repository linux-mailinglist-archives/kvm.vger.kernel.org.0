Return-Path: <kvm+bounces-14894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 478298A7603
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:58:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2BF2281AC7
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998915A0FE;
	Tue, 16 Apr 2024 20:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GYte/SPG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y1JuF56c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AD044C6B;
	Tue, 16 Apr 2024 20:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713301078; cv=fail; b=INIEK9Nh/BCMjEd4ozMg4MntjNHs964fcQicposdBNwhlpMFR+PFkzTP4xilxW7r+ZCbO/eBFt7J6hMaDLeUuS4L2xvL14PwGNsw5qKYljM0l6lMKTA9yW+HAJqZ2v4iiuuq21QoHZzYSgaRRn7DKM8TzXOHC+NLgUsViDbIWHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713301078; c=relaxed/simple;
	bh=GK+TKLM8Bp+/qLvlhstYyQ7UHQHJ7byt+O0rclmctAA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D5hqJqR3w7IPLAS90rhYqXoTG0sqpsv0nGxa2G9ZXQU3/KxNlQESpVY45bWzFMZxIAlifsf8SDIUtfubc7l5Rj7FEb6hVYhzhAKviWrxXsQx2h11va/pOcPPRLYlZ/LZhqL5flqgcpeJJj+ZzI/nk4AO9z4JesUBzhQUyXpHj1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GYte/SPG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y1JuF56c; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43GJjwsP011991;
	Tue, 16 Apr 2024 20:57:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=oClJINgcqTA2Ty8jW4yqGKmL9QDXwJu8HE3C78QZ6Kk=;
 b=GYte/SPGJ6P1XG3Vm+8SXzge9EgdJZmLfPTQ9YnULIeId2Zzdvoabq7qGSjyFyTtlU5w
 VXhpRoYXmoH9XAXpG/qqoq+4TBkM3HM23Tmkd3ws3LZhlxUBQbiV5MDBQEpgjIXGpLOI
 QRmh4da3NB2ugukXclm49UTAyEWFQNvFxnIVTs1wHgHG7yd++YmwWadTbl4YKZWoIXyp
 27P8JEmii59Cc1e/1zycCKa3M6qR1k5vWTGiwg6WIgIvPCZQnMnqxl+lFjPkGlgLQuPD
 4XDiz1UuaVatBjeLg4LGVzsICVxzGl77mXaWHkXR6Ubol0pxW2agp2IV+6JBAGpjzhK8 5Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgycpc45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 20:57:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43GKCU79028845;
	Tue, 16 Apr 2024 20:57:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xfgg7trey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 20:57:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsuarNbIHlIbg6uTywiTbB3QUZzgZwXvXlXB52t8QUkusj7ujmC2jBhbI6MQZd9Lf2cZ2dTFHaDMQjHuXAmdE7anx1CPB3YLssdLDeCv1sUpFbvR59o2HwTuQP4LaC2Tb5DpWe7+btWCQdnaYd/38YMtugwRRqyMjEpt+9ZRRB/jLlIzJU4YEIvRkzY/PS6x8fIR/DYnydmBoJiRCk+kKfd3TFDgsf4AJfGATX9TO/WinAi+IMeCPj4ppFHbZMtKrhHUenwQksC+vog6c3kLIu2IgzIC9LEeQL02t9Ys1fc+gLeQ3+0/GKaJyuDHvdXHFa3yAkS/LPwTqm/5w+DuWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oClJINgcqTA2Ty8jW4yqGKmL9QDXwJu8HE3C78QZ6Kk=;
 b=MNVwSg9Y3JoFITvTRBykGkBAFDKyAgq9/xsdhcMp933izvC2Qp1vVT3cZSjY6/oC4252/2W8Gk1Wmvn1Dm/kzcvDXNmzDjX1gIDaRYtTsIibaOEbcqTVDSsMNx9f/ANiYNQYn4Ar5H2Ez2ypshNEXr03v5+KIJshqV14Jt2t2skMwPtHNGB5nEkSXH3OwdP9Qa+CqZQFiKN7Kd+l7HJwHqSpM4C8oibltMNu9Ib/I3VhNXP17yRRe+P1ZucPm/n/7LyTqdQmaK0y1v5yLwgBOOlcMq/u7Ad5qPmGLs3K+j3eU3KCNSygfyOQjQn8iDhkqT5N7YSQI7nNC3XkZb85WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oClJINgcqTA2Ty8jW4yqGKmL9QDXwJu8HE3C78QZ6Kk=;
 b=y1JuF56cH7GKEWo218HxnbBFicD7aAxI6vbNsb8bK3IVKwrqcPdMA2udFz/0ht96j2bb+fubtuRo4+F+TTF3wd0ZRaFR2wK4iGDBFiysKFy/HW97BEyGaLhcd/t+i04X3ZUemjb5RSmvqlZfq9iWprk83hO3W2lqZy6CP8XmMBs=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by SA2PR10MB4571.namprd10.prod.outlook.com (2603:10b6:806:11d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 20:57:46 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 20:57:45 +0000
Message-ID: <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
Date: Tue, 16 Apr 2024 16:57:42 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, linux-kernel@vger.kernel.org
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
 <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com>
Content-Language: en-US
From: boris.ostrovsky@oracle.com
In-Reply-To: <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::10) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5009:EE_|SA2PR10MB4571:EE_
X-MS-Office365-Filtering-Correlation-Id: 10629171-8cdb-4a6e-0b95-08dc5e57dde2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	iMu4v9iEaMGX2T1HzrOTzuDXLv377PRuZncnTTIIANXFSFuRNiDIJuba4Lmp3MhblFU+rg5+/elx2AD4omFsgzmKovRsSHR+GOPDheI6DS+tvAORbUl4n0NkDOew2rNCiEO5Dbr+qMg0LHjRGsLHKyTub63yyaPuVZxalo7/Ta8FCoKb4UCKmGOWPd6ZIP1Xq+KUVnwprJ5x+WeJJYMUHSnBfhJDeojPJ3WysTb7UVGT7JbPwmv/fK6bDKJz+/kPFlZEIjwQwgtsjDNI30JRC2BOHJ7LlCVG/y72/aRWZS1N/1fSq66/SfTxDrWdK6dln+sgqb8QqjuIaoM+KqjniXrPq/Qervy3gwrwnFy3zbzoA+aHuAOrbOgmvgg/UR5vjjsZRTaSumWVqw/D1xrs1MwJQSe91cSwBPFoHeRxhnK5ozb+5Gf1mJlNhgO7ezwuK3R4apvgge2dRUiKfpWYzOjHJrnuVQOKNV2URv7QXTbe+WuwgTQLa9EEDV/wi0DrYf3y0ke/5oo2fd3eHfcyJ7c8isF8tePjkYMg6v0/lK+C1/wLSsecxFfh6swRkzt4wdKsYBrlW80Ts9Oh3076S4W4CVQ1q19juetA9lZuiEpjsUhOXxJxpy1lJs0GhhTSVwvtWN1GLVHsOmvoWCBuNlSZ9CtqXvvpSndNcqAK01c=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cW5scjFuMzBFRWk4NWJpWUVHTzFZb1QzR0M4UzducTU1NGsrRm1iOFdnekRq?=
 =?utf-8?B?NW93QzlraWtKOWIvdUZIN0x3cUpRUUlPNEdUVjAxL1FXYnY0OXVIbHlUZm1F?=
 =?utf-8?B?M3p0VU1CbHZQSk1GazlpdWVFZENReEdNdjlMVkpuZWsrTldFbXFqTVpNa2tF?=
 =?utf-8?B?NmkvTWxQNE1UaFhleTVvUVhEL2gvTlVBQnNyKy85NFJNVVYybU9iNlBWTm5v?=
 =?utf-8?B?dkx2MU9FN3llNGM0Rkt0SStjWksrcVVBWkkrbUdrN2pzTE00bHZQVUljNHFV?=
 =?utf-8?B?VWJ2dlZpaE5EalB0bXNQU05IU0Q4Ymc5Qm9vVFhQVXI3THdvQngwVGdSUmQ3?=
 =?utf-8?B?YUxaaHN3d1VsekhCQU9RU1lsWWRPZ1lrbWFkVzNzZ3pDajBFL3d2RG45TU5i?=
 =?utf-8?B?V1ZncnVIbjhyeTdaQ3pFUVEwWDg0U2UzQ0pOUjZMOWZ4L0g5bkxpNmRYQVZW?=
 =?utf-8?B?T3hoRVU0d1VsN2ExazBvK3RseEM3cEI1UWhGM2lIdlY0U3pDQVBHbDkxWkxK?=
 =?utf-8?B?ckl2UUpnSGc1bldOOUV2dXA4TWdZWXlFTWlXYWpoZ1hYWll2RGdGeW4rU1cx?=
 =?utf-8?B?NG96QlNjQmJObERjQzNjT3pGOXVBRU9SOVM1L3ZDNTJQQnlwYmxEQkxxM0Nn?=
 =?utf-8?B?WXR4c25wSlpISDdQcWFieUlSZENWV0c2WHZiQlVabmtneWlrUzZ5TDJGekRT?=
 =?utf-8?B?L3dmZ3pHdlc3UWJINGtsemRyRzJPSVNHV0hPQzFxdWVwMDhhVlM1a09rNGUx?=
 =?utf-8?B?dHM2T3NvY3dtREFEREhjWTFhZFpPQzRsSzJXb1J5Tk9NMno4MS9lejZsU1BZ?=
 =?utf-8?B?SEc2SS9sd2RVb05lMVVmWE1sbk1MaDZ3ZkpMZ1crdG9xSzlwTE5jNUl3Tk0v?=
 =?utf-8?B?UzVMajlyYmhrUzYrUWlpbFFzeWkxWXpGQnZKV3ZaV2ZybzdWRFZVWjUwcVhr?=
 =?utf-8?B?WXV3VlBTNS9TRW13S2taRE9uandKNlJKV2V4anVyMlN0K0IrMmVGaENqUjJ6?=
 =?utf-8?B?TXAwa250RkRBaklkVXlXMHpFeS8rd2RRZkVBM1k4L1Jxa3QxblJlS1orMk9u?=
 =?utf-8?B?NGpQV1lqYUVEUE1Wck94TnRnMTFKb3cySzVOcFBkcGFyWnQzUXNCNUZ6V0VZ?=
 =?utf-8?B?dnBOUzVKTkhKZWFPckV6c295UWxFS01FaitsQ0tXck9FYUJLMmxIOG9KS0dK?=
 =?utf-8?B?RW8wbVhrajdybmhMWnVuTXBuQ3E4RStiZFIxcjdYeVk5MFM2blJYcytyNDFr?=
 =?utf-8?B?RHZsMTVMWVpscGdLZC9sdlpTcURXZ1NEcVdWb2x4Q3lBU3ZsLzlwTDZGY0J4?=
 =?utf-8?B?UXRTMVAxMXRORXFLa0JUTDBvQUlSeUNlQmRIcmlHTmZrSkhvb2ZTdkh5cm56?=
 =?utf-8?B?d3p0VDFlQUU0eVVGS1hWanZJVXo0WndzT3QwdnkwckZRc0x3cEE0YkQzekhO?=
 =?utf-8?B?cVVNLzdVWUZRZzRZbWVPYWJqY3QydjV6VFB2TFNVYVN6VkFlamNmT012b1FW?=
 =?utf-8?B?WDdwd2JONHZIN0d5aTNUUHlyRC9CNU56ZjUrTHkxOUphTnkzOUovNDVlaUVJ?=
 =?utf-8?B?TnhHOGkxOTIxMUhFaTlIVUY2NFZkVE5JVEdPcktZRS9hVFhOMzhvMjcxcDJ6?=
 =?utf-8?B?SHZaTWlqei9MazdWMXU5R3EvcjVIVmkycUdGcDFFK0UyTVlaZFJKK1JlQ0N3?=
 =?utf-8?B?WU96ZTdlYlAveGdZdXlXVFh2dEcxbU1OZmhINHRRT0RlSVpmRUE1bXdmT2hl?=
 =?utf-8?B?UlkyblZXMlBib0h1M0hjUlZKY0xxZmdVUlQzbTZpNTY2cWtOa3grN0hKZmVq?=
 =?utf-8?B?TnV2Tk5HaTJEVTVhd2RScGQ3d25Cd1I3a0JQSm1EYm9tSHdiNGlkUUR6U3lH?=
 =?utf-8?B?UnFIeFlLb3ZMOVlmcTdxczZNYmJkYUEyOHBHRmhOcDFJeUVTcm50SFZLVjU5?=
 =?utf-8?B?WE5XSkxWemdPcThrQys5MjljUzUzUVNXU2M0cmhXb0c3RDB3bGlvWkFoZzNk?=
 =?utf-8?B?WDVYQmtZSklsVS9IRkV3cEZjVWl1TGVBR3dNWTZsTW9aazAyN0FIb1F0K1ZK?=
 =?utf-8?B?WDdlTTZRanFUWlRYcHE3WHZycEprb3MyOHJrUzdMUG1ManZnTm03cU5ZMm1r?=
 =?utf-8?B?L2xvVStnN2c2UE1kWm9QMmNKZVlPU05pZVpZaFliVVBEWXY4Z29Ma0tWc1Nl?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	YlEXbIoHrAMM5zNiahX8l6z3LQvyWqDUOki4vYyF8wa+Oc7pBX5E5YQDjBnQwhO+XmiOYlMNYmrazj/mTEfPypBthFv7ad6tDKFqn9aXRPzQovqnjEYCEOSV85dfYjD6ZiPQBPDGysb4ClFLN9bUbq/AmoOIVwVtG+WgyQMjaiwBegbiqn1ToGaOY1AozQve8b5Ynv5Uie7f/Gs/I3moSs8Jw6cibMKupdgXvQdu08i12eOhzOIDexmkAChVY4UBcm8wlFBn4A97J0UoiMA4FObjoFpfxmHhbXkpcQBVnI51hDS8/cfypiJDQdP5D1MPVQssow2roHJeERrLHPDmJ7IV6Kcq2vnJILo4+B649nUrpZgqTkwQMuo9PI+gC1/Sjw17YqI1a9gZp3OQsDln6MX3CC+I+roFzuWIaEFXsW4WPcRN0pbXvAsIEJs5DU/XY8N5Qs8N/sIXgUkuTfU/lNpyw2KvWQgqVyzlvHGSX9IaGkhG372r0eNGFXJzgZcIG+567qHbhvrASlxROh7cZXYgpUsV5GWXJUARVocife9Fix3waYll0K8SXYclITta/t2b603VK5YLS0lut2EBIcryHX2wPD+sVQHweuMHpME=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10629171-8cdb-4a6e-0b95-08dc5e57dde2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 20:57:45.9097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +CrpEs85SnHmYiSphOJTatVSFxGkuYHdd6NoSovbvDVTZiVNWy+r4mkM6B5qJybXfT2XOh0cM+MfDHB72jEWr77XLjEunKVmVo7csxSERIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4571
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_18,2024-04-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404160134
X-Proofpoint-ORIG-GUID: mEi8LRUlAww14aVtlPxaoRAQJ2_nD1Gs
X-Proofpoint-GUID: mEi8LRUlAww14aVtlPxaoRAQJ2_nD1Gs


On 4/16/24 4:53 PM, Paolo Bonzini wrote:
> On 4/16/24 22:47, Boris Ostrovsky wrote:
>> When a processor is running in SMM and receives INIT message the 
>> interrupt
>> is left pending until SMM is exited. On the other hand, SIPI, which
>> typically follows INIT, is discarded. This presents a problem since 
>> sender
>> has no way of knowing that its SIPI has been dropped, which results in
>> processor failing to come up.
>>
>> Keeping the SIPI pending avoids this scenario.
>
> This is incorrect - it's yet another ugly legacy facet of x86, but we 
> have to live with it.  SIPI is discarded because the code is supposed 
> to retry it if needed ("INIT-SIPI-SIPI").


I couldn't find in the SDM/APM a definitive statement about whether SIPI 
is supposed to be dropped.


>
> The sender should set a flag as early as possible in the SIPI code so 
> that it's clear that it was not received; and an extra SIPI is not a 
> problem, it will be ignored anyway and will not cause trouble if 
> there's a race.
>
> What is the reproducer for this?
>

Hotplugging/unplugging cpus in a loop, especially if you oversubscribe 
the guest, will get you there in 10-15 minutes.

Typically (although I think not always) this is happening when OVMF if 
trying to rendezvous and a processor is missing and is sent an extra SMI.


-boris


