Return-Path: <kvm+bounces-9231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E51C85CA41
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 22:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F035F1F22832
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 21:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F26B152DF8;
	Tue, 20 Feb 2024 21:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VdCP9G0O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ezPJOo15"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78115151CC0;
	Tue, 20 Feb 2024 21:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465842; cv=fail; b=d8pg+LlPBVXyw6UI/1zsvUSB9OA35bUd+d5JVBqxY1ws3ZFLGRHGTucceZHt4PpFgw8lI7C59y/uwjJ66aS2IFC+5gqN2hB4ekSd27iHHpiL4FWHgckqFW7CKA9iWwOgnumYBCQhMzSmApOOVtMgfYxD9os3mM/iVtwXgCOi/+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465842; c=relaxed/simple;
	bh=cuqasKsdIEnm8ntp/ZyvkjqpRpQeLEbmA4GRINlZs/I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hIqxY5ljRFQM7DSzLKczTGOtHFKMgIHwy4dDfJDejFtVzNgWKmgl3b0NqPIPuiMWhBW9UmJ/qvCptz8Gck7+LNiRCGYQau9TOOgHXV0QmCA0zpzr03B7oCdyzYzrFZeG2geEHuNRSFkNv+U3AdxRW+HIfsIxN8Y/WuktG2ry8N8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VdCP9G0O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ezPJOo15; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41KKT8tV005986;
	Tue, 20 Feb 2024 21:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Z/mt97XYqNiO9Cj48t3q7QN5EPXBa9LBq2edHbbGuqk=;
 b=VdCP9G0OjBXmhSyw56Ru/ITXkelnznErITtRRSKhYixLhBc0SFikm0+Hojx98VcrE3Bq
 MzQLVkjDn/WLE2YxwnXlLJKCvxRax1Tz/GnLoOsTR4U50M7rzG6QiBYT2iT1pBM3Ug6y
 yasd/mz7W4bEQOnIF17fSGJ0WpBhDJwpAsqwgyaK3QXJI60e/v5yLwezJM1OCK/xl1hH
 l4eSpANsfN3d9BVHNpDHjmlSTbt58vRonFavKbyXc9JFo64dXLmLh9XBVeC+jAN7jpEn
 yYe3LS+3AG3h9Jw1IAMWHQ6mCzrSom9BXIYldx6RWQDvMKNGv43vva9pYTVVmhtCSXDV CA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wakd286qp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 21:50:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41KL83Op037798;
	Tue, 20 Feb 2024 21:50:35 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak87y7um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 21:50:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mgrgh3byeXuZD4qwK2ciHKYJFnAJTd1ueCjGP4OGQ/25iD73bmW3Nn0AqnVgM646HIncwFPeRDqltGTrLJZuk/nVj50AWpWDiIwQMgnGk5Fs3IM/ZnWPUtySBEibFV8uFDbwGb8fgoZodmD5YUfWAL8ZVvoQIx9ULUd1w8UAvRiv8T3QSTVTnciTqN+Q9PUknnqyK0/2o4ae2Q3HoxcuWCi9mdf0V5PSM5078gTJs0iwHarlKElA7iMjQFq/R4afXr3x+1YmFfmM/eX9S2FppiiMxSTdHJUXVgfJcCJGWOeJae4+eYFiAh/xrvSk4AE/a+hi8veXIGJ6ATZjxQn2dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/mt97XYqNiO9Cj48t3q7QN5EPXBa9LBq2edHbbGuqk=;
 b=V9KGL41oEfgeNQTCrUo5VZAL7IRKy0qyIJK8hr4P2K0KqQFngdzoxyw38EJj5isIjAz7/ZQed5XWRTjkcMe2eUvPnznCyQCF3ALTjgJxAz2IdvnXhZezNPCkrWsMbknBhY4QUYiMmXxJEKwX8Z3K2ASFb+XUb4ubC2/6Ap3xyx5BNqzIOMTQQgbEqu5emobLmvD5EJxYGRoxbTuM0iKsq+hOIrNW19Dn7Zn9mKBXnIOIvv6906QbD1n7VfVQWohpJ6IQkoomiPjOJFmkGz0NArBPWKgENJrkSTrJzRkrSzSozV5kPF2OtVlWsa+AS+rAq3ibbCVZ0hIWb1FsEI0rcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/mt97XYqNiO9Cj48t3q7QN5EPXBa9LBq2edHbbGuqk=;
 b=ezPJOo15EyN/L/Fx16mn0QArQ3+ZuofBykkxH8nP22DOllhU+t4cjk+3I6wGMuKmlBNbPeOC8TA5oRpS2oRC30D9O9RjmostblMbR84l82dIlbr7Jg+7dYUzke8Rz6IVDMhOo3NEh/AWPstBxdEscAo71+BJX2kSHZW0P4lHuz8=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH3PR10MB7864.namprd10.prod.outlook.com (2603:10b6:610:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Tue, 20 Feb
 2024 21:50:33 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 21:50:33 +0000
Message-ID: <05571373-5072-b63b-4a79-f21037556cfa@oracle.com>
Date: Tue, 20 Feb 2024 13:50:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 3/3] KVM: VMX: simplify MSR interception enable/disable
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org
References: <20240217014513.7853-1-dongli.zhang@oracle.com>
 <20240217014513.7853-4-dongli.zhang@oracle.com> <ZdPXTfHj4uxfe0Ay@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZdPXTfHj4uxfe0Ay@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0192.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::17) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CH3PR10MB7864:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f6f3b02-002f-450e-a314-08dc325df677
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	fr2KkQb1/tCTOawA6ou9JfX0kk1xoJmnXyBbWafaNkMjcUd3ukSDDor0tBLyJPPhkxrjeVzOGwP55TXsMVlSVzigEmbhzYWVHZdcv6gJBZDS0UcsA3Rlw3eK+RO2XFPF23ymJKWLpFYOv742rQKGVFHcA5hCF8KjCAii2ogV+yhLeooCCt26IX7YH5XINEdYH3dU6rgwp6UgTNevP9DhojfxckVJLXiZKL/Trih6BXYHpJg37DL/cB1RpIJMIrtWjZO9JcHs0dPS7YKG2Ccg8F4nwb6JEgWMlvo3N//b/t1T8ws7xbAQn7VkWJsK3UMULXf2Vm9Lfy/UwAFSAy643r7/NEeqMeRzmp8oGXSMUR3Dju1k6IhZxoT2czrTA7yr3+J4qpMnUQCYgPlmntCspQnBsOJDdjXfHXcLgoi2uJ00lm9tGriMzNCd5k0FrMIg9Ec/t13t2bwpQLzlHJpTHZ68WYbvXP11ovlyNMK2+8KNirwqHEcSW8QuPLtSZs/ADWNUwcs1RAg3nYEuzIGIQ7VHjnunNTPHSHE7rfRR1ZU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TkczY25UYjJxMnBrcXBXKzRDdm5CQjl0bVZERGE4aW9vS29WTzA1QTZKL1Ix?=
 =?utf-8?B?VjFyK1A5YTZiNSsvb1dVZ0hyV3d5Znh6TkNNenVLR09FRzEwWFhhRFBoeHM3?=
 =?utf-8?B?dVk0eU5mS0pYWko4TGVJSjF6OGIvejZzTGlVQUMvSzVIQUlLcTJIMUpaeSta?=
 =?utf-8?B?NmVIdjVFVDFLeWhrZmtrQU9LSG50VTFmZVdPdVpQZG00MkhXSzQ4RGkrYTdl?=
 =?utf-8?B?blZpSnI0ZFl2dGdDV3gzMVFaUndxMWFSWWl5aU5TWWR4SFFPK3k5R0REdHNR?=
 =?utf-8?B?UVRVSGtMSkJnUkNKWXd3US9RNU16cWZ4TUZJZ2NncElBTFFBbDFEVWNjWDFh?=
 =?utf-8?B?N2V3UnVQZTlZOVlkMzVvTU4zSEJaQWpDaTVTYVhKcFFiYWJHYW1qZHFNUzJ0?=
 =?utf-8?B?Ym8xUmxkbW13UWpuUjE2UWxxbEhvY0cyU2R0U3pDSkJHb09NWkpsYWVDeE52?=
 =?utf-8?B?eksrRG95U1A2NFJmdHNFZkJMc0ZRMmJWT2daak8xVkF3OG9Ca3BxUldyb2Zr?=
 =?utf-8?B?RG5mTDJ5VnVNR0RQS0txelhBcU9BOWlVTFlvbHV5RWcrVWVnbDdIOW1TeEtp?=
 =?utf-8?B?dGFpR3RrVUJ0eFN1OWhSSUgyTStJV2hRYVYvemR5bWJwTGlNbjRzbTJUYWNE?=
 =?utf-8?B?b0tsWU1MSzhyUkJUZHE1Z3lDQ2xsSEhiMmppY1k0WmtVb0NxdVJvb3NTU3FC?=
 =?utf-8?B?WDI4ZVVkbTNicVVCRktRQnVtRnowbzA1ZmN1U3VmdlZmcUtwY2RXa0ZNaUkw?=
 =?utf-8?B?LzZJUUVBYzVuQzB3dlpRc1BpN0N3bktGREc3WWF5OU1GZTZ3b3IreFBaSVpH?=
 =?utf-8?B?ajNvSXQxRHRXK0JsNEh0b0VFTWY0eG44bE1vckQrNjlUSEVVVXRTQTdLN2Q4?=
 =?utf-8?B?am50Q2FrQmhYZTdpY3ZrUUdjS29xQ3dZWEZFYStBdzVKM216YU02aXZlN3FB?=
 =?utf-8?B?Qld4b1RCL2YySUl0NVNlek9pdzV4VTkyWU1ta2x3N2puTW1HQ2lRdDVlMWVm?=
 =?utf-8?B?ZHZPY0hYQnVKU3pZUXFudCtVWWVMcmlLaFVxb2Y1K3ZlYmJhUkxITUJzSTBU?=
 =?utf-8?B?VHlrVXo2cXZjekk2RTBkZThYOWhwd1FoS0xGNjE4RHZwNEJMSkJEWTAwKzZS?=
 =?utf-8?B?RWpRS2FhSHUzUThYVlJjYlhsS2lBMGhpR1BNcDRTZUJXUU83THVHeldiR0d3?=
 =?utf-8?B?K3NPRmpTaGxPY2xYemhXS0tFNmF3M3lQUGJzbTVoNW5NVysvOFVHdVhKbm1T?=
 =?utf-8?B?RTdCN3JDb29hSkNRVzliaWFzMHdMVWRyc2JTZDdwZmdzNlYrMU5ZTW1LN09J?=
 =?utf-8?B?TmV4YW9CQmpqMXBFa0hieXZtYVR1ZHRxSDNkRWNONi9MQk15MWJjOWdQMkNU?=
 =?utf-8?B?bTYrbkFySjFaa1V4OGN0Z3I4WGhQbnloTUtMT2ljbFhkenJpMjFLdTFDWGpT?=
 =?utf-8?B?MWpBZVFHOG4ySnRpVHEwUnhkSnltTmdCbFBibkdtbmZPczZCR2p0U3dRRE5j?=
 =?utf-8?B?N1ZKSVZNTUhWeHAyQWpTMGdOVStnc0RsbEtMaUJJUWdPUTh1dnNQVzZ2QWFi?=
 =?utf-8?B?QUhNdjNSWWN6Ym1rUk92YW9RMnpFZ3M1RGZoWk5MWnRXS3BiRnlSZ202VVhC?=
 =?utf-8?B?K2ZiSEY4OFlabWt2TGc5UGY3YUc4SlF5NUl2VGZ2S1VaUHBWTktySGdGNVFx?=
 =?utf-8?B?Tkx2Y3A0RkIvSkNMT1pCM2Q0cXE2THdFVS80WmM0S1hldjlkTFN3aUdKeFM0?=
 =?utf-8?B?c04yUjJEVVRsRHdQMk5lYUo2Z0kvTC9MLzRIZ25Kdm1wMndkTXh4UkJVbmJq?=
 =?utf-8?B?OVZWNGh3SG1Jd252OGZpRWlpRk1jY2RLenFhb3VjQjEwWE5DMC95T2tNWVJX?=
 =?utf-8?B?eGVYSDcyQm5zanVjSFlTVmRFM016bS84cGxBUU1hT2t5aFJtRVZidjh2VlpY?=
 =?utf-8?B?aWRaZU5sUy9nMDIwN2JqbnJ2QWgxTWU0bk44TWJKUnNIbHVWb0RNdkxla2Ri?=
 =?utf-8?B?R2VoQ0x3MERxUzN0Z2tUQ0Mybk9ybVk0bXZiT043WG5lS3pnZ0d6TXdQTWRF?=
 =?utf-8?B?T1Q3TFZnclBJUWtIUlMvRVRja3lldXZxZ3dybFN6cVZDYU9qS21FSFIyeFpK?=
 =?utf-8?Q?DplPNbbaJwPYn3E8JGVl6AkIS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PimXYyE0Lq0U6PVFCSKE52de32CbhYNo0KN2ymAJtCEUZeUKVfvZ9nXaDOiJNh/LgRFN4zdpldtQXZ8L8na5vZRcm3vIqxHSOxS4p6aAmXd5vGgjvgPGjmExOuu89KaFtMnadtVRPrV5OkMDXUMFSudDHuccwhDpRIV8deyRbohNYfOfXJ9oZ+tgZa20lt94/I5vv9h5be7r6IWzePhK+XlK43moGTZ5XWwfK192yEdm/u4YzNhNFLFyyp1L91YSKhsPKaaasybQvCpw2N++062kjmui8zeKrVaLvhYRl0oAlAbDnRlaJQgVdfojmxuTmOp3jjJsxp1hQnopozApMNLsoBvHukL6dk/kvkWjEkngpUWFHg1O0UA/2XjxMNMXeoOihdu1BPgkISMec8y9N5G/y6/Gay70RvnZz1DngbroH96dA5qkLaRtGrK0jrURRqLYkfgy6PmaPtrBCv8dIDhRHiadLLVQDLWq92SL2ez3AwKjPpPt5UAOlrJdFZ/jEuc42J1HpCQ7Xw5zRyxxNVXGQAG5LYQAn8nE6PnB9vgI03HYkyxYA/ojgXPawhnhBhK+1xcubWFzrbzcjAnlqAMSYnBQIlwxKnaKDqla+Xk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6f3b02-002f-450e-a314-08dc325df677
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 21:50:32.9376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7H2YoHDWK0SD3u5PuFp7FHB2dcAwFUfsuQQh1xVQUWpUHMWayy0EHbbJdb2eolbY0m8bKm0gNdV488eLqfR1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402200156
X-Proofpoint-GUID: 7kxHjwmQyKn79SQPz3AVVoGj5YWCBCzH
X-Proofpoint-ORIG-GUID: 7kxHjwmQyKn79SQPz3AVVoGj5YWCBCzH

Hi Sean,

On 2/19/24 14:33, Sean Christopherson wrote:
> On Fri, Feb 16, 2024, Dongli Zhang wrote:
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 55 +++++++++++++++++++++---------------------
>>  1 file changed, 28 insertions(+), 27 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 5a866d3c2bc8..76dff0e7d8bd 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -669,14 +669,18 @@ static int possible_passthrough_msr_slot(u32 msr)
>>  	return -ENOENT;
>>  }
>>  
>> -static bool is_valid_passthrough_msr(u32 msr)
>> +#define VMX_POSSIBLE_PASSTHROUGH	1
>> +#define VMX_OTHER_PASSTHROUGH		2
>> +/*
>> + * Vefify if the msr is the passthrough MSRs.
>> + * Return the index in *possible_idx if it is a possible passthrough MSR.
>> + */
>> +static int validate_passthrough_msr(u32 msr, int *possible_idx)
> 
> There's no need for a custom tri-state return value or an out-param, just return
> the slot/-ENOENT.  Not fully tested yet, but this should do the trick.

The new patch looks good to me, from functionality's perspective.

Just that the new patched function looks confusing. That's why I was adding the
out-param initially to differentiate from different cases.

The new vmx_get_passthrough_msr_slot() is just doing the trick by combining many
jobs together:

1. Get the possible passthrough msr slot index.

2. For x2APIC/PT/LBR msr, return -ENOENT.

3. For other msr, return the same -ENOENT, with a WARN.

The semantics of the function look confusing.

If the objective is to return passthrough msr slot, why return -ENOENT for
x2APIC/PT/LBR.

Why both x2APIC/PT/LBR and other MSRs return the same -ENOENT, while the other
MSRs may trigger WARN. (I know this is because the other MSRs do not belong to
any passthrough MSRs).


 661 static int vmx_get_passthrough_msr_slot(u32 msr)
 662 {
 663         int i;
 664
 665         switch (msr) {
 666         case 0x800 ... 0x8ff:
 667                 /* x2APIC MSRs. These are handled in
vmx_update_msr_bitmap_x2apic() */
 668                 return -ENOENT;
 669         case MSR_IA32_RTIT_STATUS:
 670         case MSR_IA32_RTIT_OUTPUT_BASE:
 671         case MSR_IA32_RTIT_OUTPUT_MASK:
 672         case MSR_IA32_RTIT_CR3_MATCH:
 673         case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 674                 /* PT MSRs. These are handled in
pt_update_intercept_for_msr() */
 675         case MSR_LBR_SELECT:
 676         case MSR_LBR_TOS:
 677         case MSR_LBR_INFO_0 ... MSR_LBR_INFO_0 + 31:
 678         case MSR_LBR_NHM_FROM ... MSR_LBR_NHM_FROM + 31:
 679         case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 31:
 680         case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
 681         case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 682                 /* LBR MSRs. These are handled in
vmx_update_intercept_for_lbr_msrs() */
 683                 return -ENOENT;
 684         }
 685
 686         for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
 687                 if (vmx_possible_passthrough_msrs[i] == msr)
 688                         return i;
 689         }
 690
 691         WARN(1, "Invalid MSR %x, please adapt
vmx_possible_passthrough_msrs[]", msr);
 692         return -ENOENT;
 693 }


The patch looks good to me.

Thank you very much!

Dongli Zhang

> 
> From: Sean Christopherson <seanjc@google.com>
> Date: Mon, 19 Feb 2024 07:58:10 -0800
> Subject: [PATCH] KVM: VMX: Combine "check" and "get" APIs for passthrough MSR
>  lookups
> 
> Combine possible_passthrough_msr_slot() and is_valid_passthrough_msr()
> into a single function, vmx_get_passthrough_msr_slot(), and have the
> combined helper return the slot on success, using a negative value to
> indiciate "failure".
> 
> Combining the operations avoids iterating over the array of passthrough
> MSRs twice for relevant MSRs.
> 
> Suggested-by: Dongli Zhang <dongli.zhang@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 63 +++++++++++++++++-------------------------
>  1 file changed, 25 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 014cf47dc66b..969fd3aa0da3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -658,25 +658,14 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
>  	return flexpriority_enabled && lapic_in_kernel(vcpu);
>  }
>  
> -static int possible_passthrough_msr_slot(u32 msr)
> +static int vmx_get_passthrough_msr_slot(u32 msr)
>  {
> -	u32 i;
> -
> -	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++)
> -		if (vmx_possible_passthrough_msrs[i] == msr)
> -			return i;
> -
> -	return -ENOENT;
> -}
> -
> -static bool is_valid_passthrough_msr(u32 msr)
> -{
> -	bool r;
> +	int i;
>  
>  	switch (msr) {
>  	case 0x800 ... 0x8ff:
>  		/* x2APIC MSRs. These are handled in vmx_update_msr_bitmap_x2apic() */
> -		return true;
> +		return -ENOENT;
>  	case MSR_IA32_RTIT_STATUS:
>  	case MSR_IA32_RTIT_OUTPUT_BASE:
>  	case MSR_IA32_RTIT_OUTPUT_MASK:
> @@ -691,14 +680,16 @@ static bool is_valid_passthrough_msr(u32 msr)
>  	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>  	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>  		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> -		return true;
> +		return -ENOENT;
>  	}
>  
> -	r = possible_passthrough_msr_slot(msr) != -ENOENT;
> -
> -	WARN(!r, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
> +	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
> +		if (vmx_possible_passthrough_msrs[i] == msr)
> +			return i;
> +	}
>  
> -	return r;
> +	WARN(1, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
> +	return -ENOENT;
>  }
>  
>  struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
> @@ -3954,6 +3945,7 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> +	int idx;
>  
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
> @@ -3963,16 +3955,13 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	/*
>  	 * Mark the desired intercept state in shadow bitmap, this is needed
>  	 * for resync when the MSR filters change.
> -	*/
> -	if (is_valid_passthrough_msr(msr)) {
> -		int idx = possible_passthrough_msr_slot(msr);
> -
> -		if (idx != -ENOENT) {
> -			if (type & MSR_TYPE_R)
> -				clear_bit(idx, vmx->shadow_msr_intercept.read);
> -			if (type & MSR_TYPE_W)
> -				clear_bit(idx, vmx->shadow_msr_intercept.write);
> -		}
> +	 */
> +	idx = vmx_get_passthrough_msr_slot(msr);
> +	if (idx >= 0) {
> +		if (type & MSR_TYPE_R)
> +			clear_bit(idx, vmx->shadow_msr_intercept.read);
> +		if (type & MSR_TYPE_W)
> +			clear_bit(idx, vmx->shadow_msr_intercept.write);
>  	}
>  
>  	if ((type & MSR_TYPE_R) &&
> @@ -3998,6 +3987,7 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> +	int idx;
>  
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
> @@ -4008,15 +3998,12 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	 * Mark the desired intercept state in shadow bitmap, this is needed
>  	 * for resync when the MSR filter changes.
>  	*/
> -	if (is_valid_passthrough_msr(msr)) {
> -		int idx = possible_passthrough_msr_slot(msr);
> -
> -		if (idx != -ENOENT) {
> -			if (type & MSR_TYPE_R)
> -				set_bit(idx, vmx->shadow_msr_intercept.read);
> -			if (type & MSR_TYPE_W)
> -				set_bit(idx, vmx->shadow_msr_intercept.write);
> -		}
> +	idx = vmx_get_passthrough_msr_slot(msr);
> +	if (idx >= 0) {
> +		if (type & MSR_TYPE_R)
> +			set_bit(idx, vmx->shadow_msr_intercept.read);
> +		if (type & MSR_TYPE_W)
> +			set_bit(idx, vmx->shadow_msr_intercept.write);
>  	}
>  
>  	if (type & MSR_TYPE_R)
> 
> base-commit: 342c6dfc2a0ae893394a6f894acd1d1728c009f2

