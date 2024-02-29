Return-Path: <kvm+bounces-10474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9400686C69F
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 11:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD9EA1C20C38
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 10:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B883D64A8E;
	Thu, 29 Feb 2024 10:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JpWVaIZT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FhocB7WZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5665D63503;
	Thu, 29 Feb 2024 10:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709201774; cv=fail; b=rZiHDqeEdz7At2sGKpOF+mXcFfYLGUWWXzJgGwBW3ZZy9dO/TTD0DHdEBO5fh3G9t0caN6zAZmziH04+pYj+qUpbe9nSqO5bJ5mahf+NVfZ5qiS6evkk5huI1sVBtFhb/W6GfWofPgPgZEne0MqmDqDx5DCxZXbZsHmCoW/mb1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709201774; c=relaxed/simple;
	bh=F5nCStwWVQ2lfkSz+apnB5SF6sAK2yGzjN19zyYgrrA=;
	h=Message-ID:Date:Subject:To:References:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IBN0qMqOab+Esxo2wHnVNscRt+jXCqO5SySwxT6kOOGMyD7sG4cqfqKUNH7uyyuQi9Bt1nxSDFZQm5eNdyvRD9PtD0F3xn8mXiagaC2cjXWDaHSY/CfM2UmhA+T0l+nmBD1b4gERyOkRS3lBEe/5lpTifMi+nDlo9dZSkUPIeTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JpWVaIZT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FhocB7WZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41T9WwJw012305;
	Thu, 29 Feb 2024 10:15:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : cc : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Ew+IzW66uz2lUx3AtP+L8gYOIW8YVYwILRQsJa1C2M0=;
 b=JpWVaIZTn2wzB4AVXbua5cu6S2U11BK/pa8sdvU9+U0+WDTykV1CgXnHIysqV3oMa0Rb
 eePiDvK/fkyaBBOq+wWZEmFzyEnpIaoYaE2Jx0LGTEP3T6I+ybEWOQex3fOxCgOpN2gG
 MC0ywiDWfWWLc+cZxCVV8e8sTHV6TsW7mfoAu+QQ2HGdkCREZAGFM+veI/kfXjyZ+QR5
 I7SIexrmNWe+XP/11vJeqJ6U/v8DV1ylvDMEiGcsAq4RW1fHCN6xbUrtcjV8LGxZXXWO
 n7BVs2mCJAwqa6+XIt8CqM67KQHIesj6a7wYKbAJhRb+ez3owicKygCO1K0POXv95gvF wQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8bbcutq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 10:15:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41TA39uZ010066;
	Thu, 29 Feb 2024 10:15:18 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6wa886d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 10:15:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4ZQbbzLBMFKJ1sNTrKxCqU0mFMmEsrzKpj4ojgJH9vkCr7Wky3WAcBg1NxydhmCZ1GGA1/n1I7WI2MPZ6AHAGlWVJeEw5fINkB/EW3Txqs2NSxM2XXACkKehmS9Ylnkid3lAMvvIuwPTkwp7LMkzNWJza2vtpJokPCqSTL02pe+teToJOsrm+huw60IrF90R12/gwWOKz00boNHFj9rCimRbNIROCsIiAIXrG4ZUJ2te1avGzfvuRLVMpqefJeG2upUItkNBsruf6Nk+t5mA2ty74wdazs1zvET/BU7CEgY83eq02c9ItFo0ntsZIifHIP9JvEEQheOkvN7dD8W9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ew+IzW66uz2lUx3AtP+L8gYOIW8YVYwILRQsJa1C2M0=;
 b=SzdKXla/F2neSWuSmyYXLGvffBVcEkCeZCjCgAwXmHHnkVducKn5syhbQUiYFTTRjXZcXSCW6SZXWgp52OEV3+ph/7LEzoLK9sTTb0tymlfhI3hFRbeQ5gvi5fH8lfQMWzYnNCW+ypjV3VNQW4dgL1Z/vzNna/+ylH9oh+l2DA7Jibrut0M5od2alX1ysG28TpzEnGPutHwgND1B8FdpEuSa87Zk3EGKbqqX9pLlDWlNzeniBn9RZKMSjRlmrtyzYud36Skm99Whvi5lPR/pzB+vC1sCDXtue7x97w79nVrrdxYV1e5IhgyqLxGVS9N4+XxXskJSicJeqd6t/DVZjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ew+IzW66uz2lUx3AtP+L8gYOIW8YVYwILRQsJa1C2M0=;
 b=FhocB7WZaugfxYpgkCmBwGWTbKTyb8Og9pmIiGgX5bXN3x96s/MCWon+6VXOkuab8uaYsZxFVWlmRG9BjbarbUpeHwqx1/U5yxAdx2LFmTDMQm1bk22ctbq9CaT3UxJ0egHKx50WnYYCrAoleSOlp+ELS/aOexHGuAuS2Vc2qb0=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM4PR10MB6911.namprd10.prod.outlook.com (2603:10b6:8:101::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.39; Thu, 29 Feb
 2024 10:15:16 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 10:15:15 +0000
Message-ID: <5e35c8e1-5306-8ee9-300c-2426d6a0f050@oracle.com>
Date: Thu, 29 Feb 2024 02:15:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RESEND v3 1/3] KVM: setup empty irq routing when create vm
To: Yi Wang <up2wing@gmail.com>, kvm@vger.kernel.org
References: <20240229065313.1871095-1-foxywang@tencent.com>
 <20240229065313.1871095-2-foxywang@tencent.com>
Content-Language: en-US
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, bp@alien8.de,
        hpa@zytor.com, imbrenda@linux.ibm.com, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com, atishp@atishpatra.org, anup@brainfault.org,
        maz@kernel.org, oliver.upton@linux.dev, foxywang@tencent.com,
        wanpengli@tencent.com, linux-kernel@vger.kernel.org, x86@kernel.org
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240229065313.1871095-2-foxywang@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::18) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DM4PR10MB6911:EE_
X-MS-Office365-Filtering-Correlation-Id: a5643d22-4b3b-4929-98c2-08dc390f52b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hX6snwv8CBMlKpSGv0UUYAO7tdp3kbUS5p8LErztviW+q4sQ+XK+O3UWrxC6sYz6hoIYgIsajvRZaWovj9Y2+78/azzuTlMh2lMbyRBkkoM/r19+7KHiRaI2Utc7Gt0GSrE5xdoLAN3+WthpIL8pUUsnR447ZVhovqipDWglJs2lqA7qH4GjM9eYUz3xYBtLGM9kYHIE3rLdSU5S8SqRlCw4LImg9BCTaHmU5XmxcX0FQGVkMcw23hLa1qHPZYAty9JOCGqbK0Sx5gfBw+hVFlOEhY3pHX6XQjcO7GbuymtVYpzMss1gY8F9BMkYJYF+6SfyHmTkg7vTavqEsmmaL9/mPLO6Ra0lLLs4ZTyHboc+7lfyJlkM17iswRem7zJG7jDsOhIgjMEcK4wXrwDSzMh1Pzquy+mKvSRdTVm+MFOm2q3pD+gUbb7IRxRiKbedVF4OdGlgkC3AmM89U7gFHTg76k623UY/98HuJuTToB9TLd5UARMZVxo+nAAQibh/ozPFiD0sbOV2t9dukCHBGTT7YhU3q8Kk/XH8efs8Dlq7frSMj3vo8ni4HHizq6L5jFExYfT2Q1z2GocKyXRrfyFl3a/th9Mg5rJRAKeEousp74GWGYESFyyzmrL84mm2JCu2dpGLzfXNRE1TfFifxw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?V1RlTlVVR203RGh0ZnJMR3Q3TmwvNlJoZlpjYjVmNHQxV0hueDduZllqVnA1?=
 =?utf-8?B?K2UrZlpIRU42aXRXOWhvbXUyQUNYVUc4ZmFnMGs4MjBaYjZPRytmYjBUK3lJ?=
 =?utf-8?B?V3R3endsMVVLWmh4RllYbFRUdloyRERWSmRLbDQ2SUphRGhrUlRqZUdNdUZj?=
 =?utf-8?B?L0RRZ0l0ZjY2bHNQNXpmdVRTbFY0eVhvZDFuN0VjalZ6bk5rR2NNU3BPRzVy?=
 =?utf-8?B?aEZBM0htVjJsc01lTHdrcDZKM0MzTFQvTkhrY3ZSTUkyMnRXRWlYam5YVHR5?=
 =?utf-8?B?K1ZHcUdjQzlZZWZ2Wms4NVFteW44bGRqUGUrYWxkeS83eDVGcU5zZzdvWVhy?=
 =?utf-8?B?aDlhYkdaT0pWWkhiUkNkTDV0VGxqSUtyWnZFQnVoazlQRlFNSFdIbXd6S1U4?=
 =?utf-8?B?UFV0Wmw4c1U0K00zYXArSUt5bUN5cWhyQVk1Z2RCRG9uTVhELzFRMUpZWkJD?=
 =?utf-8?B?VXVtVUlZT25rWkxMRURhRDJMVjFUWTFla1Y0TTg1WHBjbHgxN0JObjJaQ1M2?=
 =?utf-8?B?TFp0cTIzZ0FEZjl1NHZQb05TeWN2S1F6MUpxT25nN1c5SFkzbjFYVUFjV0Iy?=
 =?utf-8?B?VE0ybDdMYVl2RnJWU3Zpa2U2ZkQ1QjR4bktlM3M0VE9aQU82NzdyNzVkeWtw?=
 =?utf-8?B?aWRPQyttUkFVVzBhWWtEK2tzRW1Uck9GNVpYQ056RW84OWcySjZHV0FaRjVv?=
 =?utf-8?B?eGptNmtPVE5ZeUxZUy9lVGZHTEUzQndmMXZCMkQvSHFsWk8rK1hmMjVCZ1ZO?=
 =?utf-8?B?ckZQd0Y2TzZRVmdkbHFqQUtMdUNKRXV1ZUpOV0F6RlZnSlFMZmMzMEhSSmYv?=
 =?utf-8?B?TFl6aDkzeEZyZzZ1dmJBeHowOXdFYWZPYm90R1NKbWtBaVZXUnpzYy9FbnZv?=
 =?utf-8?B?OW5JczY3MUllQW1RQXVQdk5uNXlNcDROeEJaTjMvY0p4MVM1K2ZZM05JNUVW?=
 =?utf-8?B?emZHNDA0YTNobmNHNVNmSWFaOGZIOG1vbU52ZFRnZmZ2QnJEcVI0QU11a09I?=
 =?utf-8?B?RzQxTGtrS1dsNEZlV21WUUNzYVY3QkowVGZvV3lSMWwyc3d1d3QwdEZYV3Mv?=
 =?utf-8?B?elZGb3hLT3NpRklRNVNtTUk4dDBmbnNtWXE3VlBRZUhKWXY2YnRTcVRHZTN5?=
 =?utf-8?B?VUdTQ1pRTHhHYkJmbzZJNTVlSUlJREpPNlQ2VVR3N2NrZmtKZVlRWDNDdE5L?=
 =?utf-8?B?eWtCUDM4dzFjeTBNTzNJZE9IcTY4bHg2aVd5cHF5TWJNaWhBSG5Pc0NGcGgx?=
 =?utf-8?B?a1NJVW5IN1IrNUJ5YldEemg5ZnZwWUdKSVhYN2lIcWk4OUk0Rk85QXpwK2JH?=
 =?utf-8?B?L2hlODZhZ2wyMnZOeFVtRkJaNmwwOGRHVHJrRTc0TW8vaFd5UlZKYlpSc0Jr?=
 =?utf-8?B?L0xLckZVaTluV1NOaEk2dVFJUXJPRTFVTFhheTlLSWZEL0RzcVZRWmlFOUJ0?=
 =?utf-8?B?T1NYRkxRNzdJdzQrSWQxSUhtRmd0OHBlWktpaEViWVl6Vnp1RnNVdVgvc0lK?=
 =?utf-8?B?QUJ4WkorRmdRZjBaQ3JtSHVKZWtmNVAyb0kwbllYNXlpZVRoVzhnWTA0YXJk?=
 =?utf-8?B?YlU2MFdPWGtYbFNkVUNUdHZYWlhLcGp5TmFEeWUrczBqbGN2aEZFMk85cGxn?=
 =?utf-8?B?S3drT2FVekVROFFuWXRxanZ1WlFnYWxkdFpyYWlGdmI0U1I4RHJoc1hUQmNu?=
 =?utf-8?B?aFlwZHBGa1lQaEdSWnprZDVGMWJyQ2xKUFduTUdBTGZvMFpVVzU1bDFWRkFj?=
 =?utf-8?B?UDdEUHBQdk94NGNGQ09veFhueUQ2aUtGellWMkV1MzdTY2l2Nkw0L3U5RzRr?=
 =?utf-8?B?eGVGTU1USWsrYXh1bkw1RkxlSkRhdnRxYUZWREZLMUR2V2JGSXdVNTBSVytR?=
 =?utf-8?B?NldJeFkyTUhTR1paSE1RNnJabEZnQTRDaERXdzRPeHhtbmV1OGl5ajhmdGt6?=
 =?utf-8?B?Wk12QXdaRSsxNjlLdUZKKzdaVEJha3JVclFnVFhWL2ppWGo3ZVF6MHVLUWR5?=
 =?utf-8?B?amVteitGaVA4ajFld2lleS9OdzVZbFovdHRiTXhHcnhHQXZyVkhxTkRYUzA1?=
 =?utf-8?B?LytPM3VHSjBPd084cXNPdVdFVTgzZ2JyUWg3WC9aTy8rVE9Hb3pYMUJZV2cr?=
 =?utf-8?Q?phm1PUinlsDckRElsEl4EiaBr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	L/UgmzpVBP5x+ndo7kcZtqFHrGDK+sVHmrL+K6sH41KRT0wzv5qZUkjBUoD1RvRO46pBUJMBO6625Si7FlRtsbHfkV1RXmncG2GG07TkMfPWa1KuWU88WKzgwfLGmKRLT/xHAapv+0AvLULMOtRsXQRuTUdtovPUNqtn6eZAQI4bFFumHyxbmXXTT+uiNhCgWmITIyXvwuL0tmOwg8OooVDkLCGGKyvxgHSukEj9Ze5IWzq/RmrXdT5JDsI8I5FjNHHXSNAnTHbofr/QHnS4lok0S/qocb91E2ybbfOyRpkGnY1zIy9/i7geN+UGkZbfqKVtBwbdmIoOnNvLhh1aEVBWiN6Sq7A057cEGQPpD04Gxzmk7xlXDxAXjQpESPCEYtHFUsUZvc0iPQoikLiqCeYx1DaPnmriA/1MT2EA11bpIt8cwKAKgl3SxOd6M8pV4aXGQYjhmsnqV7pcQCPudvtrez1vBBbsBhPS9t0xZeiQfggnVTjbRF3hUZNZwOkA7yjrkoF8NSjn5tYyrTxgV63OCBGh+PK2sGtrjEXB1OCuUO7w7J36mncVl5CaKRhQ1lH7ZkvNC34OJMArvb563rf0KjltL6bN9LoeJfXhNEg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5643d22-4b3b-4929-98c2-08dc390f52b4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 10:15:15.5927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XQGNFsayOGLVa9LJyljT8mH8fZJcxpS5QkbwsP4SwHUM8H7epwJUfl9AzO1gZyPfFVWt9FzBknyvNUJo/VtMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6911
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-29_02,2024-02-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402290078
X-Proofpoint-GUID: D1r6ikx4IWwbUIvuMaP5JtOGars5-XcN
X-Proofpoint-ORIG-GUID: D1r6ikx4IWwbUIvuMaP5JtOGars5-XcN



On 2/28/24 22:53, Yi Wang wrote:
> From: Yi Wang <foxywang@tencent.com>
> 
> Add a new function to setup empty irq routing in kvm path, which
> can be invoded in non-architecture-specific functions. The difference

:s/invoded/invoked/

Dongli Zhang

