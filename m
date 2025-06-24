Return-Path: <kvm+bounces-50570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D50AE70E6
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28A1E18832DD
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889A225745F;
	Tue, 24 Jun 2025 20:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QC6P5WTN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3F52F3C14;
	Tue, 24 Jun 2025 20:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750797074; cv=fail; b=XMMPdaCFtz9L1IuerWkzBIh9GZMDeEmugJIScdFYGTpce7i+dof+LVlVxxz+1Uk9d4I2I1iJgeGmjw6AlHk1k12WfxomcpiWUlp7vwroW7k0RYqA0oVo5wUCiMV2qTS53GK35OjRHSEWPBM6OOrMK3JDwPIO6VdJiHcM+mIz+gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750797074; c=relaxed/simple;
	bh=n/zLSlPrCjwibvKzIDQqhHn/7qd/lMwUU1O+U0S8vdY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PtTfEgmmEcfhjB72d46PRIlI99xHQEqwQwjy1gU4b4HGZzdYPYqOZNKebgXZvH7D18r87GlZGgd+SVewauxXyKkgyrf24O0KB+LmOD8ufHuwiTaF32nLCSfYKR1oh8yRRtEipjyjkNqyaJA6eRilx8u3yBjT0SOraaIJDQeJ8HY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QC6P5WTN; arc=fail smtp.client-ip=40.107.95.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bu5FT6H+WQZTIBtXRPaZc5ojn2ktoklja6lX+C2MGhDkFOVSrL5apXa1gBd7rp0f+G3xcYA8kIggPY15r6/BntzHghm/qE4UuvLcLNj7kLRHyP2BfiTeTmAJDydKgYVD/uMeT2dS0Z7QpaKB7ud/p0w42Fp4q6jBQIvRJjZcWnKqIR4vdjC73jeNfV3MwkmEEwu8voDSQvMoBjx8NXMxbWKHVrohC5ttTuMfIpt48e+UmczUHfp1AGqqGOLzEfzv8AtRjg+13e4zNEfn4m7486Ouoq/qS7UITRFOQiHtCDaoxoYTY1U+Bgpah4a3x52NAM9lFYS66d8j89B1kfdo0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVe8ATUgpT3NMIYOtyVgoTdId3+Ym2XhF0/MjO4IfIY=;
 b=LElePZtlXnaoQ0XiuMn1nocjOM95YTtJcvpKw48fRHvL5Bf+YxODy5WILd3Lt9TBY2D+7t1cJtvvANiTJQ/5V1N0ZxfaZNSVLM7RWpY2btxaGGnwb+V4S8F2MM190SH8oAfuJUM0tCJmkzo/aXplIYHR+EucxSzdTMkLpsrOc5BCfj0L952NLo6Pg8ELnv87Zc843nzIVcTOipgr9SMF67Cr+GuIy7L8duxb/zlLhSF2qe4hr7vhboCMdlRfO/WN+1tJktzRtLke3WHnf3EJn1loBgABmkzd2ZLt9Gym6lxQ0Icd5eJhWlo796kVXr2j7az/oY9Mz0ucBF/+tZyj2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVe8ATUgpT3NMIYOtyVgoTdId3+Ym2XhF0/MjO4IfIY=;
 b=QC6P5WTNN4CXD1a5vDEDfFeWNa0ftrhxxul+t8jmHlV74Z4hw2myqnY/ABjjSMvGYTbo9MqdaZlyKb/mJs8iBCpKHp28EfJZNRzmGCTrh+xUqM3CWPMf49ENlEBb8dWBZHkLi/b+vsqZxuAOnCUV1SDL5VJe0OLmk/7cfZjuXII=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB6215.namprd12.prod.outlook.com (2603:10b6:8:95::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.19; Tue, 24 Jun 2025 20:31:10 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8857.019; Tue, 24 Jun 2025
 20:31:09 +0000
Message-ID: <691a453e-768f-1302-1db7-225b1086391d@amd.com>
Date: Tue, 24 Jun 2025 15:31:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 0/2] Remove some hardcoded SEV-SNP guest policy checks
 during guest launch
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <cover.1748553480.git.thomas.lendacky@amd.com>
 <175079224437.515260.14294578957654984603.b4-ty@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <175079224437.515260.14294578957654984603.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0173.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB6215:EE_
X-MS-Office365-Filtering-Correlation-Id: c59ce8f5-0e02-4541-d660-08ddb35e0d17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SEtGZW8xWVY5V2hHMzN4Y3RvcllUVS8rdk0vTFpUWnRrdG45NmtrT3I3UlV1?=
 =?utf-8?B?U3hQU1NKb3cySkZKelZHUjF6V1h2TFNWWWRhWFBVVFZnQU40N0ZhMThEUkpO?=
 =?utf-8?B?VFF0dCtHNVhwdERtbFY2dDBCSnd3M01Ld294U1RmOUJyaWxqOXV4Qmh1a05r?=
 =?utf-8?B?SUQwTlQ1NGVBOFNNVjR4Q0RyQUhLUDRtSnFXU0NmQlhnZ1VybVB3VGlDbFZa?=
 =?utf-8?B?Qi80VE5RMDM1TFRPa0VRdmcrSStYRktMTHdBL2MyVlRVWlR1b3BDcnkvSExa?=
 =?utf-8?B?MVplSVFLd2RPZmd2SEVxQm52NTZhWUxJQjBQSHdKRDcwbHIrT1pzTWJTN1RH?=
 =?utf-8?B?QnJEL3NHWXhBN0NSQVZvUlVad0crQVRSejZGeXBjcmExaGwrbkUvZGFoV3ox?=
 =?utf-8?B?TnFLNWs5bGJWejQzZmNJdTRTKzBwYlhGVWUvREJsMWljd1dMNmJmOUVlWlM2?=
 =?utf-8?B?Z0NHRVdjVkJkbW55ZlFGSU0vcFJXWVNkZDA4RkJQOVRRZStsTG92UXp6NVBn?=
 =?utf-8?B?N1NaZVdnZDlKQmdPMWFOY3M4emY4VU4rU2ExUU50OUtkV1pFODREbVhLYVdQ?=
 =?utf-8?B?U3BDWUkvV2IrWFZSbWttNEk0YkNScDFENVZEZmZmdWtFUExkVEtnNExac1BZ?=
 =?utf-8?B?ZkJaYi9nVXZKOVVBaGIyT1hHMEJGai8yT3dpME9PY1hYOGtKc2hENkdsZWtQ?=
 =?utf-8?B?MFQ2NXQ1ZVB1TDN0Y05XSUlCTm8zb253aUVGMXNNNUZGb25YYzJBWW85T0FM?=
 =?utf-8?B?ckZ2MFRzQkZGRUdDc1lGTTNwR0VhTmp2OWhleUNxdVV6MnhNdXdKamhrZGxV?=
 =?utf-8?B?SkM2VmlWbDFiK2lnWHh3Y21JWnB3bzdYRlFrZUVkenVwNVc2b0tZVXlmbkpU?=
 =?utf-8?B?N0llMUxGMHloTDQ1Tm13WHVJQTh5U0pES2V0VFR5N0k2VTM1azR2SDZFUU03?=
 =?utf-8?B?TG9mT053MDZhUkxNemVDTHNoVFNFRXJRcEtTakNqZEphZ05jcU5DUnFTcVJM?=
 =?utf-8?B?TjJwbVpYWUd6b3JxaWtIT2xvMkdhWEttVUR4S0pUcEg2bDB4RWo1N1dhcFlm?=
 =?utf-8?B?RmVCN0x2NEVFOWtvY0ZLZ3FKOC96aTJZeDZKNHliZEtndjh3cWw4dTdNKzd6?=
 =?utf-8?B?bDgvdmRWV09yTkhtN0RGZytXQ3lKa2lSdE94S2tHY1RTV1pXbHRaY2tsWWN0?=
 =?utf-8?B?ZTNjWTg4dWJIWWIvanFhWXJSbTlKZ1FpQmZlK3VIL2RhYjFwdEhjTlBUc1p0?=
 =?utf-8?B?bEMvcDQxZm5CZS9TeGNqVkFNYjk2TVVuS3VwaThNSVJRSnY5S0dqMjVCalBj?=
 =?utf-8?B?RmZlRDVEeHREVW8wR1NzRVpZL3Vwc0kwUkRMaTBRQWNZNXFRMWlGTnI3a1RT?=
 =?utf-8?B?ZnlWOEJDcWFBWHdRaW1zVzNobThhYllqR0J6RHdVUHl0WXhEWFd3bklHTHQ5?=
 =?utf-8?B?YW85c01LSWFNcitlR2FNT2VaMjQrMWFxbitlTTZnZVlYdmE5S2wrdldPMEZJ?=
 =?utf-8?B?YVdTV0l4MEFNQkF4WlBOVE51K0FsU2VTaWtJZFg4SjNjR1BkbjJxVDc3d0Rq?=
 =?utf-8?B?TXUrd3VFMnV2YnAxWFhOZ21JVDIvTUhHZ2lOZWR0cW9wWFVGQUM2VjF6c0g5?=
 =?utf-8?B?WFY2Z3Raa2txcTNrakZTRXBTVjhySTRVVHNhSVFxS1hseG9PU1VIL2tKaTdi?=
 =?utf-8?B?eEIwVVVETkJ3STBNa1FpOExoMG5oa1R1SnpGVGpXQUZEUC9kMkIrZHhTeGNh?=
 =?utf-8?B?eGhoZVFHS3lZMVFmd0k5QVM5dWZNOUY1cUt6dldRRlR5bEhoWGdNMit5QVZL?=
 =?utf-8?B?OXdkUUlHdk1mZzNQQXRTK0FmN2lycWtSQldxQ2dnQlZaS0dwRHBnaW1ldUNS?=
 =?utf-8?B?RE1reGhOQ1luZnhNMkpmN0tCWnBqeGdwK0NTWkFSNWxITkxvcmw3NDY0YkdZ?=
 =?utf-8?Q?Y96Gtf7AJrk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d25XOUFrSDErRTg0ZWwvc3hQOWxmVkVNZW41WmE2UTJkL2dJRk9MVGF5UTMv?=
 =?utf-8?B?cmdoeXU0aVFDcm9SMjc0STZYWXBOT09sUExERStPZzE4aW5ZRlovakVaMm1i?=
 =?utf-8?B?aFNidWx2bFdTZWgxdEN5MDhRN0U4VTFiWkVmeGgyUGIyMnNRNHFHdDBXNEFx?=
 =?utf-8?B?aEdtekc2U0FpMUdPbXptWHVaMy9ac3VzT1hzc1k1RmE5eFdKQXNtYmpZQ0Y2?=
 =?utf-8?B?S2NLdUtBMDBJZ3JCK29LK1o2QzlCS21JbGF3QndGVFZzTG9hQmJ6Y0pmUTk4?=
 =?utf-8?B?N3B4QXpQTnBoOFdpa01NN2NvWWFtTE5iL0FneVlqaWFrUjVEWXA1VHl1SXVx?=
 =?utf-8?B?T3QvU1VXbmpSUXZpL3oxdm5OZlVBa0E1TVlCQ0taR1lZeEg1QU5DQXFYaFN1?=
 =?utf-8?B?ZGhIMFROcmxZN0M4WFRoL2RMaXNqMFhEMXk3Ym9rKzNRMnF6dXAyQW0rbTl0?=
 =?utf-8?B?RjRYa1VwYjNWR1E1d3hIVUF0YVVnaDM4NTVkWGhma1ZBb0tLeW9iUUJUSW9n?=
 =?utf-8?B?TEFaV3dVU2ZNMlloYWh4aWdBdXhmWlhRZFpNUW9TWlBWRHVQWHVYYmt1UEtx?=
 =?utf-8?B?SitDV3hrZkJpVGl0SUdwclJCaXR2eGRySy9UVDhFZmllWDEzT0FIZjBjSkc3?=
 =?utf-8?B?T2MxZWczakZHUTJHRFdFTmRIZVpIQTdMZTZtUmN2QmVzL1ZVMENmeFhUVU9j?=
 =?utf-8?B?bkhqN25UMy96U05LcWI0TnlUVlFZMjFzcGJQajlRZk1vcWtvR3hvWUlOVSt4?=
 =?utf-8?B?eTN5TlR4MUR2ZUZwRE5CMXMrOExOMFl6cCtwRFJ1NEY1RFp5ZTArM3hmMG5Z?=
 =?utf-8?B?SVhxbkFsU05YeW4rdmJDM2w4YmxIcnhuNHBBRzVsL2FNT3oraVlaZzQyZ0FE?=
 =?utf-8?B?U2t4cXBjNVVBTG42ZU9vMHlmOEREUDNqVEpxNS8xWlRQSE1lSWNFOHBrdHVu?=
 =?utf-8?B?T2xZNEY3TXNYNWN3bk9iZ29Iekt1OGZKSzFUcFU0NE1jZmJXMk11Tml5S1Zp?=
 =?utf-8?B?MjBmczM4WWpXbG1pS0pUVHVKQmlXZ00rSDhGcGN3NzBMUTRLNWNtMUtjeFdS?=
 =?utf-8?B?U1NwRjNtYVpnazVZdWtoWmRpeUhIQk4rellVNnVHRlVWSUtnYVB1anE5U3M2?=
 =?utf-8?B?Qyt1bWhaUDdEMHlrRE1nU09HVHIvR1FQNkd6VHlBWUxZYkdsWDR2Y1llSlMy?=
 =?utf-8?B?ZHV1b05zdTdTQ0lOeHVPenh4OVRsZHJNemFuelJKblRhMnFMMFc1WUowZ1F4?=
 =?utf-8?B?WlhORWlCeitwaXFDdHpoYXNwUVhFMk52dWk5YXdjZUprNk1DVVFhSURjcStp?=
 =?utf-8?B?OVBXeXFnT0hLNWRPTDhnK240MXVmYUd0SDdhWnNBTWwycWd1WXhRT3lUaU5i?=
 =?utf-8?B?akVyRzdhQjZjNmIvcHVKZWNVZEM3aURXRjZRQm01eXMzdmd0R1ZCRVFwREZx?=
 =?utf-8?B?RG9LTGRzbTJ0Yno2ak9Rek9SQXFvZ2hhV1FybGhFOERqb3hEZ0p5VGNFK2tD?=
 =?utf-8?B?aTl5S1VhYnVSZWxOVElvaTlMSUJkZkxmcWVUcVRWdlpQR3EyS2Y5MHZuK01S?=
 =?utf-8?B?TjhBSDgwbklKN0lNdnVUcExnNG80S1NBYWJ5T0Q1ZXl5UERtZWduVGJTL0JG?=
 =?utf-8?B?OTZhdUZlU1FYWTRKS0lzcGdOR0hJbDJ2UDZlRTdrcCtLc2N6azJGZ2YwVjhP?=
 =?utf-8?B?ZG5qSVpBTS9nNk9GY21Ta3VseFc4UTlVZHI1MkpxdWtHNTJjMDBPOURwUGFP?=
 =?utf-8?B?MDV2ckJTVlJxbmZqVUo2RVhObW0zZTI0OVV2a3pOaEhiNzExSzNzcm9lVXUy?=
 =?utf-8?B?aWwwcDFwRnNGaGJWZ0QwREczWWxSeGtGUjZ1Zk1kUmhyOUhqbWRMRmFLVm5W?=
 =?utf-8?B?eWZaUVY2N3p1T1JycVRkV0did2dXb01yemRxejFWbTZpOGIyK2NtQURYekVN?=
 =?utf-8?B?WFovb2twOWZOdkJ4TURQWERVUU5KK3ZSRk1SRFBIUlNkaWZTcENsWXdsOWVH?=
 =?utf-8?B?MEdoNE5LQ1hnb3FkOHB3cFVXK3RpOHlqbWNSaDd0NmdZN2hvRlB4bUhkNUQz?=
 =?utf-8?B?Nk0xV1F5UjYvWnRKaFlyWDhiYzIrOCt0RmZFN2UvRmR4RUp2TEZrbHNMV1I4?=
 =?utf-8?Q?rhAcY5dHE3ghLfenygwSnL4ud?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c59ce8f5-0e02-4541-d660-08ddb35e0d17
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 20:31:09.8144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z40qYAigLL9b/a6dCUYb1pJxEV7nW2Dbhf9AVO5yz72a+dd/Kx8s7H3np2yP9zZMJB530q8HxCY92TM7J0sG8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6215

On 6/24/25 14:38, Sean Christopherson wrote:
> On Thu, 29 May 2025 16:17:58 -0500, Tom Lendacky wrote:
>> This series removes some guest policy checks that can be better controlled
>> by the SEV firmware.
>>
>> - Remove the check for the SMT policy bit. Currently, a check is made to
>>   ensure the SMT policy bit is set to 1. However, there is no reason for
>>   KVM to do this. The SMT policy bit, when 0, is used to ensure that SMT
>>   has been disabled *in the BIOS.* As this does not require any special
>>   support within KVM, the check can be safely removed to allow the SEV
>>   firmware to determine whether the system meets the policy.
>>
>> [...]
> 
> Applied to kvm-x86 svm.  FWIW, I'm not entirely sure I love the idea of doing
> nothing, e.g. it'd be nice to enumerate support to userspace.  But adding a
> bunch of code to regurgitate information that's likely available to userspace
> (or more likely, the platform admin/orchestrator) doesn't seem worthwile either.
> 
> I'll make sure to flag this for Paolo's eyeballs.

Sounds good, thanks Sean!

Tom

> 
> [1/2] KVM: SVM: Allow SNP guest policy disallow running with SMT enabled
>       https://github.com/kvm-x86/linux/commit/9f4701e05fae
> [2/2] KVM: SVM: Allow SNP guest policy to specify SINGLE_SOCKET
>       https://github.com/kvm-x86/linux/commit/24be2b7956a5
> 
> --
> https://github.com/kvm-x86/kvm-unit-tests/tree/next

