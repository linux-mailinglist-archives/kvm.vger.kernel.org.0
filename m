Return-Path: <kvm+bounces-14909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C852E8A78A0
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 01:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D281284422
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 23:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C3713A898;
	Tue, 16 Apr 2024 23:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BrkjVEhY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EJalaol8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477384AEE9;
	Tue, 16 Apr 2024 23:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713310643; cv=fail; b=VKaZmuZjAe2m4Zt5PTs/mJ/rcbfZZ0CqU9ajA3EYd7/zXkIHaW9HYo0H2F6/RXU3do5+wEr3tLDkLhiwjYAvayrAirhE6aqBBbwHZQ/HdDcYi1BgkJ9Pfxb2q8Es5Gqo/uHZxLBklRs8VW1cTsK3yAEpX2qjHkW4y+8ZsTOm8w0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713310643; c=relaxed/simple;
	bh=bygoIPQHEqxB/RTSShBnPtAQQZe5pOukiU1do4CISbw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hRkWj6jYUoczYYZ2NrEyTau9WDyI16vf+xeoxo1/3V7LfjiR6s7DMPTT05Bp4nVf708rQ08ODNmsFSoYcEbIHjfdmcJqcmaRFRaj3ltZF/eOKnSkUkKWcZkoND5zDVAGzsiiJsmn8PRMyrC7XMX97P1fyg0PpCLrlyyxsb9hFMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BrkjVEhY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EJalaol8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43GJjnIM006411;
	Tue, 16 Apr 2024 23:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=x3f2vMSDGiVcqqvgomTEZWUEtbv/CntgBclsRjvEfSo=;
 b=BrkjVEhYcPtg0a/kasfowHrWw+JW6zy5Ncl3jNhytfAts+rsl8OxXZc01GG5gTw9rbeu
 5rIntnJooJUOmKzfXafhEWlKM/sVl0tZmI6mmw21RgPGEdLzU/I9emd3LAsO8vW6Gljf
 uEMQV4mOSi+vaGBgfqNfFrbdN6Kd16qPbrxxDNhiuVpwVE7j8eHgpa/mk7HiZjZMoq6k
 VM0TPEpSrNHDfYqvlINwEsZ84/f1NUV+DJOyml2n5SjzU1elgJoJuMG3wHj1cbyEFv9C
 pMKMTdFVohDLN9nhQwHLmzg4Ht1Uvmbo3Q40wl3DRDFCPz8wuSb8Bj2CJahTcbBkwVeg VQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgn2pj1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 23:37:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43GNZTwd014286;
	Tue, 16 Apr 2024 23:37:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xfgge802m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 23:37:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQCU7JIgsq6SwSPcJ7PrZmvFS2b6h3ZKELRpUVT+nGJu6/SaSLi/EzbwhfGKn0OiN+wuKi3WMqc1yyPziR9XO/Q7hTlWr8CkZ6D8uCK6Co57G9ttPwiz01hWrKlKJ+N5Mm5ziNacnGyoGdRspxKEnxbu+w4xW2RlU6v/QP9kOtCMg5GAivAnfPar2OS+2Eex1d+5CQ3CAAbnQ4zeLFYfa7JEk1fvhjr9TZExH1ajAFTOZ/hZ3Mp/hz/1LeqvMYoUM6LOrufBBsK7Y8V3ynqw4OT0ZzephEE461TxgUVnlrhRlVD8L+1a73ACd1QAWM03L/nSBmsgm5pbgCPu93/sxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3f2vMSDGiVcqqvgomTEZWUEtbv/CntgBclsRjvEfSo=;
 b=Lu1o1aOyEiLt+mvbOw0bkz+jkssYTlkHsKMfUJBRi9PxRXwbPQng/pvjLtx92ijJdXIWGC+Au36cksLP8jyhwUn4OM5mf1Hef8m7jXoPM1uVxYqla/cPutER16YgQHr26Qhde2VHn6mddSG1mEgp+iQKVkCQ/ss2eFjZVK7E91o72gl84+tk1jaQ2Fe3yNyDUaUqLowHbfetOGiyzNZ7WpokGb7FwAcTjED68LdEae7QdNjJQ38adaMO5myucsqKOULQvOwwUXpTx9oEaT3O8JStInXrmaD92MBPtWdETvyuaD3vd7boL7Z2o8SDR8WdBrxOg7i7DYZjdwmjQ1+QaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3f2vMSDGiVcqqvgomTEZWUEtbv/CntgBclsRjvEfSo=;
 b=EJalaol8q7f8FYTeWhUEYAa6gRMrEqTmqGoXpBfy+Wen8e93s+KMu1etW5IyYxwdIXfkj60NeyYXCCX70zuAVvnI28EydUYz/nsFVKSX+ebIjnSpHpLPqTjInPPvFMRakwFrSVIHZba+1lvXpSrO5erEuEbwLgA41IcyBGaDOYc=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by DS7PR10MB5928.namprd10.prod.outlook.com (2603:10b6:8:84::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.43; Tue, 16 Apr
 2024 23:37:12 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 23:37:12 +0000
Message-ID: <77f30c15-9cae-46c2-ba2c-121712479b1c@oracle.com>
Date: Tue, 16 Apr 2024 19:37:09 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
 <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com>
 <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
 <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
 <77fe7722-cbe9-4880-8096-e2c197c5b757@oracle.com>
 <Zh8G-AKzu0lvW2xb@google.com>
Content-Language: en-US
From: boris.ostrovsky@oracle.com
In-Reply-To: <Zh8G-AKzu0lvW2xb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH0PR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:510:f::30) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5009:EE_|DS7PR10MB5928:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c260b5b-cbaf-4cf8-9aa7-08dc5e6e242f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QWrxTf1ULNDULJneFdP/h28DsQUHRJQ1j+HHragkDw7NdBqy8T21AmVLJHlTLzgz6y2MTA8LcX6ExoW9Ew4zyS4vomAFqDN/kvMMprpBPigVOOC34d+YL+nIvina4bOXiJy8ALtbXF2o4ottAcfY25zl1e2p8azkHnzVz9Bc4cYTWHHzZOg4B7dLWeej5LkAWJVsc5Bln9FB493JqUC/mIK/Ktvq5M2kqTa5PlMoGx/qxNJc6Z3n+mBOuQK8qCKYMkHvNscMExXasRb1UG3FChkPd0NyJSQnKzWfB1AK1mkxpKNC4DHk1YRLIe0vusRZmdFhEZGJdJhS0w5kSkzN2VU8HBEdIpe4k13X137Igpf9XXl6PwyFy81Ym9fiYGSQAMxvX9/1vLDiUzqFdqkxYMT6YiqiIIIy6v1+s9c2YMk+QvyG8XTu8uxTQVED7ussONNBiMRotgnjYLH6I+zlufY4rmtMmYj7erin/0xTfOPJEPhn15al61sbWywoVvP0jItb14gP7iYaHXRfpSnwaW8SCBMY09POWeKeAnUyaeS9pHsk+L/4PrRBxe3hBMmsne/wlj5ITS0r8Cl3LBQRsOG7sG07FIqwlK8km+zShI4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZWZSRTV1M2J6VmRTRnZuSWdwZ2ZyczFwTy9BTzZnU3l5bzFJa0N5SG8vMjg5?=
 =?utf-8?B?aysrY3hlSjlLWlVzR0VFOWp3N09hM2l3RnFtaExKR3BDZ3RlRXdDOHNiNFZG?=
 =?utf-8?B?ckpXSHhRRlpRTHIxZ0VvbFJsZDdGSEp3UW5XOXdVTTZoQWp6R2lFR0FFQzll?=
 =?utf-8?B?M000NkIxTEprcXFldVdxOE5pWkkybEN5eG9sazZZSndZc2dONElxdTZ2VW15?=
 =?utf-8?B?ZkNHWUErUG1nL2xsb0haclc5dDJDYzVnK3pPNENBR0w4YTY0eEtCR1lYUWlC?=
 =?utf-8?B?MS9Vdkh3dVBWYzhNT0xzV2NBK3dudHlIdVNZNzRVQ3o4aitnWmJYQkJzM25Q?=
 =?utf-8?B?d3JydjlVRFpTVGRPVkJoNUdrTHNma0VGSXFlcld5VEc4OW5WaFZieW5QYU0v?=
 =?utf-8?B?RmFZRFhiaVhlWGJkdWg5cXBtYm1DUDBEY0ZxVHk3YjlKdytmOVd1aWFTTGdh?=
 =?utf-8?B?Q3JYME9sK0dQd25ic1BjOXBiQUV3Z0x2Ynhvd0c1WlNsWmFHWVZyWFUydWRr?=
 =?utf-8?B?M1JaN0ZMRmpRa3NXemFvOEoxVzB1QVBoQnZQTi80V1o5bDJoZTJqZkFCZ05n?=
 =?utf-8?B?QVpuaHhLM2kyRGRWR0tBL1FFYmMyeVdDZmRoOUwzcVM4L2FhTWRtU2cyQmkw?=
 =?utf-8?B?ejJQcmpUa2RDdVE1SHRZcUhIV2l4QThQUWREU1I3MGUyVVMwemtKRm9ZYkxo?=
 =?utf-8?B?SjlqZHk5VXlPU0JTd0ZoamJ6V2tqaS9wRVgrT1gzK29FQVF6U1ZkT2V4TTNk?=
 =?utf-8?B?bWE1TEl4SHpEQ2RJTHJxMjgwQWZxMXlQU0NwaGZ5Y3VobnNJN05BMmNxUHlm?=
 =?utf-8?B?aVdMb25FcjZnRGdQTzYzQjhvTXRUVFA0aEpzcFYxS1E3U2Q1Vk02aXVIVlFK?=
 =?utf-8?B?L21sUjRYam9wMmZCaHkxZHZMc2ZlWHNvMlViZzFESUJ2aXZPVkVXa1FhVEZv?=
 =?utf-8?B?N1htNk1LTDhjVTBCcEhGampkYzlBNm9qUytWdS9jWTZEbjhrUENoYWtUOWo5?=
 =?utf-8?B?eWlhVWFiQy9ORHUwb25DM3JweFhVdUx6MU5vNFZISEJiV1A3aWdIMEhlNjhF?=
 =?utf-8?B?b3EwM0ZObzZMZVJEMm5VYTJNZ1RCbE1CZWpvOFVWMHNoSTNMamZxWXEzeHYv?=
 =?utf-8?B?NEdQMVl2Y0NFaklSU0NQN1BEbmJnbW9vdzZkbllxNVZUUHhiMU5oZ2dST2FP?=
 =?utf-8?B?aFZXdnNPblBoZ2VoRTQ5cWhVcEpkZWtSSEZ6UXdGK2czRG9waW13K2c5c3E2?=
 =?utf-8?B?eS9SVFRMbmJkZ2xjdXZNRVY1eGxpR3JXam82eHZ0cnoycXhaSW4yc1NOU3pS?=
 =?utf-8?B?TUF5eXJGWmFPbnRpbkJoTCtaUkI0b0dXSE4rK1hDUGgvMS9WY2IyVDdDWkNm?=
 =?utf-8?B?dFlqY3BhWGduRGVOMDY3d0JDdjFLMDV2MURpWTcwZ0FyaTRGcnZ1eGIwa1RT?=
 =?utf-8?B?eU90YXNSMnc1R0szRWNTMzJ4SHo5Y1UwWkZ1TWV1SHZmSk9sUk5LOUprZjI4?=
 =?utf-8?B?QS9wbkJFMm5iZi9tbHlHZ1VEVHNMaFZ2NG9VRzJrRnpBTVlUMTRKWGQ1Vzlm?=
 =?utf-8?B?MjdITHE0bmZlTUNxTGZuM1NQZ3JCeWFrbE93ZVV0aXhGZFFBL1VXMHpTWkN4?=
 =?utf-8?B?b3NDd2lzcEZTaldMemFMSlVyc1YweDUzeWJtNkl5bmQ0S0ZHYzFDcGxDUmRP?=
 =?utf-8?B?Zk9CSGVRWVBNbkx2WTRCaW1NUkZrd2ZCR05BRjdzSlhSUDZDcUtGQ2l0bnB0?=
 =?utf-8?B?dWlCZmVYTzQ2dkdabGx5NmdKbkpyNlpsaHkwUlY4MTdjUm9YL01vS0RZMlZN?=
 =?utf-8?B?d0hRV0JjYi9MR0xKTk1OVERPV3pnRzlKNWEvYTNPWndSV2Z4S3hQaTg3Q1Z5?=
 =?utf-8?B?S3gxbFR5ejZZb29sQU1XYzBOYklQczcrVlRGNWN4RTg5V1pGcGFoa1FzWVdu?=
 =?utf-8?B?NGNJdjNyaGdkVW1iaFp5aGNEQ0J4dm8wY2RYampLOG5ENm02aVlpMkxtejJv?=
 =?utf-8?B?TlZFUkpaTVpxZWwwR3ViOVJnT0ZUQ3JycnBvbFpPVXpwcmlZOWVYS0ZVOHVt?=
 =?utf-8?B?Z2xRbG41cFI0SFZaVVFycFBqei84Y3VYWlZTbkIrRWNtOUppbm12bjkwa0ls?=
 =?utf-8?B?MUxTV1U5UzI3NmIwQ2t2d3d1RzBkVVFsNmJUTHY2RmM2OVovNEZqNmRJSGlw?=
 =?utf-8?B?a0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Alh1E6zY0RgDHEZpwqt8Zfsoe6D/INa/uiWiH4ViewNT8U2bS+bL7m37a17sy73qzD7zZ0BNz76KJuiSreDPZ1+WNwz12i0qaBweGnWjpXIlENEHjXm4L7EVGrpHifAOxNEpiIoukKI4GxOoH7yGvf6XPAGLh70QsI7ilHRs8DL5ULOj1MHLvuU9YdVOFcOb8zTSGH69YLN3VX6u/1ZG5nwE1PYxg+gzVweGbFGcXmRhlW3i2XmXrJ+0YyQltHttyAXKCadSQ0QRvHdSMovnGdT6Be+DDhsm4I+Jil8WyS9GE31993bimlHrLtz38na+t+29ERNPT+AxsWYbrTlvVcdGXqmOrgyOBc5fjHNPTwLEhRdIUtESU/UFdtv7uCFe1MD8RCtmyl7y4VIHHQpmuqewcJr0dKZ9OV3BZ+cax3wrP1197YK1Kne9gCCTdhvRt1gnUv1avDOaMUAW6i1WrnHwt/OXngjdBt8fU/mAQ7lQRYIpQLTv1Bpt0qtQv4AMvEC2mwfTdt+B+rQLsv+FIQQmw8elIluS9IvnZ3ML0mZw7ozRbL1vJEiWRWDtuGebd6PjZ/alIiOZA0PFivhn7JvFHMfXo+B5cjTOK4x7u5E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c260b5b-cbaf-4cf8-9aa7-08dc5e6e242f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 23:37:12.7595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VMwx71BMzSjciO7v0JmK9F9MvmGvAMlL47G45hDHglY6v/PGJ13R1bAQ1VrCqlXgopTzdVgiHmNlKScMrfL4ReQRNB+q5CZG1KaB/xJLdtw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5928
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_18,2024-04-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404160154
X-Proofpoint-ORIG-GUID: dCMyYrefxudGNjEoDurQErCPfTZSD7au
X-Proofpoint-GUID: dCMyYrefxudGNjEoDurQErCPfTZSD7au



On 4/16/24 7:17 PM, Sean Christopherson wrote:
> On Tue, Apr 16, 2024, boris.ostrovsky@oracle.com wrote:
>> (Sorry, need to resend)
>>
>> On 4/16/24 6:03 PM, Paolo Bonzini wrote:
>>> On Tue, Apr 16, 2024 at 10:57 PM <boris.ostrovsky@oracle.com> wrote:
>>>> On 4/16/24 4:53 PM, Paolo Bonzini wrote:
>>>>> On 4/16/24 22:47, Boris Ostrovsky wrote:
>>>>>> Keeping the SIPI pending avoids this scenario.
>>>>>
>>>>> This is incorrect - it's yet another ugly legacy facet of x86, but we
>>>>> have to live with it.  SIPI is discarded because the code is supposed
>>>>> to retry it if needed ("INIT-SIPI-SIPI").
>>>>
>>>> I couldn't find in the SDM/APM a definitive statement about whether SIPI
>>>> is supposed to be dropped.
>>>
>>> I think the manual is pretty consistent that SIPIs are never latched,
>>> they're only ever used in wait-for-SIPI state.
>>>
>>>>> The sender should set a flag as early as possible in the SIPI code so
>>>>> that it's clear that it was not received; and an extra SIPI is not a
>>>>> problem, it will be ignored anyway and will not cause trouble if
>>>>> there's a race.
>>>>>
>>>>> What is the reproducer for this?
>>>>
>>>> Hotplugging/unplugging cpus in a loop, especially if you oversubscribe
>>>> the guest, will get you there in 10-15 minutes.
>>>>
>>>> Typically (although I think not always) this is happening when OVMF if
>>>> trying to rendezvous and a processor is missing and is sent an extra SMI.
>>>
>>> Can you go into more detail? I wasn't even aware that OVMF's SMM
>>> supported hotplug - on real hardware I think there's extra work from
>>> the BMC to coordinate all SMIs across both existing and hotplugged
>>> packages(*)
>>
>>
>> It's been supported by OVMF for a couple of years (in fact, IIRC you were
>> part of at least initial conversations about this, at least for the unplug
>> part).
>>
>> During hotplug QEMU gathers all cpus in OVMF from (I think)
>> ich9_apm_ctrl_changed() and they are all waited for in
>> SmmCpuRendezvous()->SmmWaitForApArrival(). Occasionally it may so happen
>> that the SMI from QEMU is not delivered to a processor that was *just*
>> successfully hotplugged and so it is pinged again (https://github.com/tianocore/edk2/blob/fcfdbe29874320e9f876baa7afebc3fca8f4a7df/UefiCpuPkg/PiSmmCpuDxeSmm/MpService.c#L304).
>>
>>
>> At the same time this processor is now being brought up by kernel and is
>> being sent INIT-SIPI-SIPI. If these (or at least the SIPIs) arrive after the
>> SMI reaches the processor then that processor is not going to have a good
>> day.
> 
> It's specifically SIPI that's problematic.  INIT is blocked by SMM, but latched,
> and SMIs are blocked by WFS, but latched.  And AFAICT, KVM emulates all of those
> combinations correctly.
> 
> Why is the SMI from QEMU not delivered?  That seems like the smoking gun.

I haven't actually traced this but it seems that what happens is that 
the newly-added processor is about to leave SMM and the count of in-SMM 
processors is decremented. At the same time, since the processor is 
still in SMM the QEMU's SMM is not taken.

And so when the count is looked at again in SmmWaitForApArrival() one 
processor is missing.


-boris

