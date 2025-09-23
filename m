Return-Path: <kvm+bounces-58530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB3CFB96192
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 588413AC9F8
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 13:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648662036ED;
	Tue, 23 Sep 2025 13:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eN2qW44h"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013025.outbound.protection.outlook.com [40.93.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89B21FDE01;
	Tue, 23 Sep 2025 13:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758635738; cv=fail; b=uZrrvKQAcWk1pYDz0bcZneJy7hzBXIfpGesXXkBnD8kRmZ5+Z0Jd4z0+CzYiCsOSF99eULpm1NasJO2D6NgUuIadaz5u5B+LMVXmePQ1WYI8PdRZq2ZwPwVVxpIDDObK5v1GSfqL1mvzvcDnkq31Io6rGwUfnk6Iur4FwmH6mR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758635738; c=relaxed/simple;
	bh=vE9wAHrfQeFVzDErQBqkpA3piNvoxOi8uhSde2Ck6D0=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=TCuvELMU4xJtrRqcjHsupuEjbJ1NvlIK039Y7S1qmkYLzR0USTDGuciB3s9e2rYxLmPHvTdUDJ17RcWYClrMaFcvA/fedxrBHnzzURSbnh5neMNVtnC1i6Whtihg+2qIQD1An5GXt1NjGPUZ4J2APHpBviorPaGBM50kW+8cNZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eN2qW44h; arc=fail smtp.client-ip=40.93.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hSdyoB9Bpgb8uCnyyDr1mWjW2ojqLrWWZqFw6JsgplvmPyBKDFfnc+HdHV3bTKl6N7FsGSSMrHUy3eCkmWNo/T8Fse0eCVM+6X0oG6eHxejMY22iNv6cq4G1gtC3SooSgeInFClNGpU9nR35bfYdkq54ymbag6+Vs7CihAdT0VQnoh8HskPRNTi6TO80ZMNLEo45LJBMMcjeOvy52u6UofP5ig8vAT36rK013XRXtJc4Gv795N36jap4n8o1bqybSWlMUXDyCVn1OOrH7bE+Bv56USbGLTqCgNahjEnIO0n+GZkKVW2g1Mqbj3y5Shlb4sAQv6Hp1G6TM4wrMkA2ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0B39goFhWNZfNASQjG0gzgbTecj0gYZtkzI0VJkq6o=;
 b=W0mobvrUEk6QsOLbzLymgBS9utopWvViGIrjm6jsRmlmjiLduo3RTE6oAPR2fWqfq0mRCGYRBmPoL9bIOezC6enrZG8tVciyhDGs6Za/sEn1BKZf+P7LuWE+E9/05DETt4dfwNr+Gua0nHLWJT6/yyq1m32I5pA3+s7iT7GV+cXqy6MZ7XYrYdk9DUacsN2tD6LrQYzefGl7LJ17LfS2k17CMG2woVNmPP9Tg+KRiU5NSa84FGzTjegKMEAk4e16aS0ne5dGrIYpW/YnoHP8DrbKOKQkA2lFZopqvTI2mY5Gc1gxSciGxfyCu4yq8c+W/uiPeRmZiL03B6jUFSThBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0B39goFhWNZfNASQjG0gzgbTecj0gYZtkzI0VJkq6o=;
 b=eN2qW44hPqCStcu38xn/kpUHyf7UsxIzMxA3YRR6Zig5uK59HOZUqBZgWrow58wti3GX4xEiRSZdhw1Cb0RbHoiM5cKElPDMpOU47D0yACf5wHTlGYelGxaoxr3J4iUFabJUXfddJh+cEegl8LTI00+rwYSF9b26izzqpXeqQnA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB9515.namprd12.prod.outlook.com (2603:10b6:806:45a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 13:55:34 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 13:55:34 +0000
Message-ID: <82e85267-460e-39d5-98aa-427dd31cfadc@amd.com>
Date: Tue, 23 Sep 2025 08:55:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-6-Neeraj.Upadhyay@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v2 05/17] KVM: SVM: Do not intercept
 SECURE_AVIC_CONTROL MSR for SAVIC guests
In-Reply-To: <20250923050317.205482-6-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:806:a7::11) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB9515:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bc90738-94fb-4f05-7a84-08ddfaa8dd95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d2pZY1VUY1E4M2N5Y2lId3RMdjBJUFk2a3JWT2hhZnBOZjdpZVV3akI4SDB6?=
 =?utf-8?B?TlJGT3RQKzBhN0p1anR3N0ZYdEFXTlhLSkcranp4YUFzM3FNODJyTS9IRXpQ?=
 =?utf-8?B?Q0IzQnlaU0VieExjSVVjZE5PeGZqNDZZUjNQQUtnbFFWbTRPOWNMbWtEZUk0?=
 =?utf-8?B?aXg3VjNnTkNsUE5zS29TeStUUzhsRFhyOVJ2RE5nVENma2RmK2U4NlBOZlZl?=
 =?utf-8?B?cEpNK1NuWTJhSUxxVjRIR2ovanY3VFlhM2JzUGRzemtOak9DWDJ1cnkrS1Qv?=
 =?utf-8?B?VnBHSGZZN1dFNU9rR1RMc0ZHcjBkT0wrQkdqcy84aDdXalR6cnJYcWZHc2Jz?=
 =?utf-8?B?V2tqeHJQVHNTaFA0VzdpSjVObXAwcnRGbTByZmE2SXdCQVB0VVZiMWxhM25V?=
 =?utf-8?B?YmVSMEQxQ1JPRUg5Z3pKOENVUnU2dUllTFFCNUtXNlZ6YXlMVXVORS9LTGE4?=
 =?utf-8?B?ZlhTMVA5ZzJTRHhySlRDYXppNXQ2b2l6V25rSVp3R3FQbjQxcUJpeU95RXlQ?=
 =?utf-8?B?QmY0WW4zRmNnZm1GTElpOGMyL28rNC9BajFuNGN0N2xNb2dqVXN0RVJMSUkx?=
 =?utf-8?B?WDhxL3E5U3RYZCt4bC93dHcwZTNVdlY0NDYzcENUYzJOcGxpVGtKQTF4WSs5?=
 =?utf-8?B?MHZkR2ZxVVg3dlk5THNrY1FwOUtUMzMrd254V0hmb3I4bmF6S3o1MlZybC9u?=
 =?utf-8?B?cks1QUxheTViVG5XWnpuUU9oVmZQOHBrNERkanVMekdNbXduMFBDZ1BrdFo1?=
 =?utf-8?B?NTR4Nm8ra2I5dzJmaFQ2QmVCM3hvdmlzM2ZTTFg1cDF0SzMvSUVxR21YUXlh?=
 =?utf-8?B?aTk4T29XbnNleUpPaGwvc0sxVHJmVHRpZ3N1d21iaVJJZmhnZjZoQVVQaFdh?=
 =?utf-8?B?TGlMSVFleGhkZThXNWRZeXJVcjJBMkIvS0E2Q29WbkY2VjB6b3IzaWwvYjZC?=
 =?utf-8?B?eitpdUhJNDNFa25YNVB4U1hNUmlsdDlFUXo3UUZoWnhlNnNHUW1FOVl6MGd2?=
 =?utf-8?B?QmpydWY1ZHRId0k3L295VGNCYnYrMzNud0luV01uak5YdWNNRlB1NGlZWnIz?=
 =?utf-8?B?QWF1K1F5MFFOMURCdHRMTk9nV2YzazhJcitvV3U1SzQrQ0orSXMyMWJmeWl6?=
 =?utf-8?B?UkJVUXpiY053Uk1XMmwyV1FvZ283YVNKR2lBZ0pyMXVOWGJPWUxvYVdsbndo?=
 =?utf-8?B?SmhnREJQNldBWWM2UUJZbUVvSks3NUVBZUhHV1NYSkhsbEMzSTlSZWJsbXdL?=
 =?utf-8?B?OUdZUndWMHQ0RzFBWUVsN21kT0lTRmpTWHUwWENCRmJBRDVocTM2cVdoOWVP?=
 =?utf-8?B?R21ocGFlY01GTHpVclVFRWk1SzNhRTV2d0hnVk4xQTVXd21TMWtoT0dpMG1w?=
 =?utf-8?B?S29nTjZWTW9GaGtRLzZDaFpOUUlVS2RRK0t3aGZhc2R5M21aaHZuMXltOHZW?=
 =?utf-8?B?SHVoWWxVRlRndzJSUWcwS05ra3dkNDBSN2tMYUFralRjUzczWEhMeXVHa2Fl?=
 =?utf-8?B?YUgxODlRTWhyMSt4cXJoVzNkUXZVR1dVTTRwdFpZTEFhTlZ5emFwOUZoTGR2?=
 =?utf-8?B?NzJQSFVvRVdncTFFU2RrRVVlbVZzKzBhMDBtcG5qY1pyMGZ4STdkNkd5TW9r?=
 =?utf-8?B?YXZPVW1TSE5SU3kyaDM4dzlDME01cVIvUE5SdEV1OXZkL1lPMUF2aXZ5a1pa?=
 =?utf-8?B?SFpEVGx6OW5CbU9XRHpnTXRtSnV1dXl4MS9GRHhtTmJvcFZHNG43ZVRIUU9Y?=
 =?utf-8?B?RDFTcUdtMmp1ZUNHbXhSMExiV3hKQ1gxYnk3UGxZMEJ5NUpvdERnVE10bkxn?=
 =?utf-8?B?ckttODYrbm0xajNhd0JDR2dFWE1zSjhxQUVrckRiVUN0MEpKLzArTlp5K3BH?=
 =?utf-8?B?YU8yUTJqSkhadVdkbjl3ZmF3c2VNQURxaHdQT3dyS1M2bGRWTUR1UHEwWEtB?=
 =?utf-8?Q?7+DlNNA9tAM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUhKZ3pObks3dk5ERjR2Vms4cTB2V1N1OWFESE1rMk9nYVh0ZXRtR3MxQTFi?=
 =?utf-8?B?Ym1GejcraElRZ0pJQk93OFBlZGhTMWFKQ1BWZk9QQTFHYWVlN3Z4anVkTnNF?=
 =?utf-8?B?NldueWxnVGFOdlo3YjB5VEthN2xXOS9ybEVUbDRXeXd0SDIyTXlVZnBYTzZh?=
 =?utf-8?B?N01VekdiRVhpYk9PTXpXSTN1Q1BWVXB5NVVmT0tUaW1uMHREQ3FvRzA0c2ZK?=
 =?utf-8?B?OU5tRXhhNFo2OU9pRWxhc1FiUnZGMnVPT0ZhaDllRUM2Z0JBNHU3ZTlRWGRu?=
 =?utf-8?B?S0lwL04wd29WajRaNW9MQjB2NmhGb2Q1citDaWtabUo4dnN4VXN6cUhwMTBK?=
 =?utf-8?B?c3ZHc2U4YUdxU0ZxVkZueW03bHEzTnVvdldOZE1qdGJkYXNNdjBTaU5Sb1J4?=
 =?utf-8?B?N2tzTXVUdnVGTnNKU1RpWmhUNEJ1RWtUWmp1YzVNN3pBSVVGNmJXWmNkY0R1?=
 =?utf-8?B?V29uOUV4ZUM0K1BYSkYrQ3NDMFgvNmJpeDRXV2xlOTlzdHB2cWl3bmxNdFI0?=
 =?utf-8?B?NXRrZlBIV1RFWVQ4Tk9iMmZtWGNYaXdNMFFvZ1NidFhxM29lL0tibzNHZ1lm?=
 =?utf-8?B?dmxQNGNCOVE1RTJyUldIRWRBTWNnNjFOODZ2dTRNRHcvOWxTOEw4MVNCVWVm?=
 =?utf-8?B?dVlCNFVCaHZ0YUU0WXhJcGIzTStmTVlmVzdTVjVadjk5Y1RuQkM3TkpSL3dO?=
 =?utf-8?B?RnpkejJVNGE4VWdwaVQyaXFUL2VBNVFjbGVSeEhkQUMxbWlLdW1rL2grQzNz?=
 =?utf-8?B?bnFaaGNOTWxEZ2RoRmpNbXB4ZFpvZm1XdkowajdiYkY5L3N5bzJsV1VxV1pi?=
 =?utf-8?B?NnRnOVQrNStkSkVsRlppd3B6S0t1TnZkWjN6RGFtRnJOT1graXpTQ1ZmZkdI?=
 =?utf-8?B?Qi9oOTFaaWxHbkFSWEI5VzN6aTZyWXUyL0dZRytySmMrRnhlU1dPOGpzTWZW?=
 =?utf-8?B?L2JmQWdCUkFDK3p0ZjQycXcvSU9vcDB5d0hPeGdGNFJhVHRDZEh2bGY2LzRR?=
 =?utf-8?B?dFdrSUxCRTRLT0pRMjNWamJFMi8xNzdUdEl1bmVoaTE5MU8xTU0zeS8ybkRm?=
 =?utf-8?B?NGhpQlRDcVJtUHJoRllUSlZrNGpFZFlEbG5wZ3Nud3l5cWlCSmxsQ1N3NjJY?=
 =?utf-8?B?a1ZKOVZpTlFEaHhjOFBBdG1mK1ZXMTFhdkNZcjBCVi9hZm1HN3lCNTJ6REMy?=
 =?utf-8?B?RnhoaUdiZk9IQjZIQzBybTFIQ1duT3NZblA3TXhQS0RPMDhPMDhXc01QemM3?=
 =?utf-8?B?Vlgzczl5aFUvZHF3MmpPcVJZb3NqM3Bqa3pHWjhtL09sNTdieDF3MUYvVjBH?=
 =?utf-8?B?N2QzaUhOMlk5MlAyTU1RZTBFaHQyRlBNVmdNR3VjZVRHci9PTmkwZ3V6cTVT?=
 =?utf-8?B?ZEEzMFk0M0lWSTVzdGNGZlkyajdzcWEwaUN6U29JQ2VYZzcva1QzaTNNQXFC?=
 =?utf-8?B?MWNnazRlcVpxUEVXSmc2R3BuNVFCRDVHZVVUblovQmxyeGhsa25HckVaRUpD?=
 =?utf-8?B?T3hrNVI2MFhsbm5mV2NUbXkwM3Yrazc4cHE2SFc0LytGdklLTWZlWVlIczJF?=
 =?utf-8?B?ZkpLOVZWU2NVQ2dtcXRpYnNxemNSdmltMmRwbDROVlFlQzhEK0loWnFndTZw?=
 =?utf-8?B?dmhOdDRCVXBmVDJXYWpBUHR3TGVTVDFMbXNqeUUvaDlBeXZIaXl1MjFPSitI?=
 =?utf-8?B?QU1DY1pWZmlGQlEwbitwaE9UQVM5YlJsODgrV2JWaDlOS2FtTXYzNlR1VVl5?=
 =?utf-8?B?QVVqRUFRa2xXSy9LY3BzY2lsSEs5Um8rcDdZck5KOVVpSjc4Y1dvbk5MUHN1?=
 =?utf-8?B?aEg3bDdoRnA0QTBnV1Bhbzg0Q1NHNXZIZ2Q5L083aVVKdjJ4RGxEYWhMS09z?=
 =?utf-8?B?enZueXg2NGhQRVMwbGltUlZLQUQyN0RBbFNabytJanBRWEVYbFJ6am42V0Jl?=
 =?utf-8?B?RFlOL1hHbFZNdVlMV09pNldLdzZqZUVRNVVVdnhmV1lSMTNrakh4QjNpY3d2?=
 =?utf-8?B?T1YrYVVhR3JNWVZUTzdMcG1DbUhBODR5LytQUDlLeEc1V2wrQ3cvdlkwZDRm?=
 =?utf-8?B?Z2p5VGQyM2h4ZFJOUWswYnAxSnVaejJ3NW5leWJ6UDBjWkxMMmVacEpWbzFj?=
 =?utf-8?Q?wwNWIwQC44WPDb2unveh6qqhC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc90738-94fb-4f05-7a84-08ddfaa8dd95
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 13:55:33.7944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +G8ALPTw7f1m2ha3ypjg+nCVB5BzBV55xJSmfZr+wiDDSYHgBAGlzwDkCOfE/ILdd5kzS0Ko3gI9hQVtHKm4QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9515

On 9/23/25 00:03, Neeraj Upadhyay wrote:
> Disable interception for SECURE_AVIC_CONTROL MSR for Secure AVIC
> enabled guests. The SECURE_AVIC_CONTROL MSR holds the GPA of the
> guest APIC backing page and bitfields to control enablement of Secure
> AVIC and whether the guest allows NMIs to be injected by the hypervisor.
> This MSR is populated by the guest and can be read by the guest to get
> the GPA of the APIC backing page. The MSR can only be accessed in Secure
> AVIC mode; accessing it when not in Secure AVIC mode results in #GP. So,
> KVM should not intercept it.

The reason KVM should not intercept the MSR access is that the guest
would not be able to actually set the MSR if it is intercepted.

Thanks,
Tom

> 
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/include/asm/msr-index.h | 1 +
>  arch/x86/kvm/svm/sev.c           | 6 +++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index b65c3ba5fa14..9f16030dd849 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -707,6 +707,7 @@
>  #define MSR_AMD64_SEG_RMP_ENABLED_BIT	0
>  #define MSR_AMD64_SEG_RMP_ENABLED	BIT_ULL(MSR_AMD64_SEG_RMP_ENABLED_BIT)
>  #define MSR_AMD64_RMP_SEGMENT_SHIFT(x)	(((x) & GENMASK_ULL(13, 8)) >> 8)
> +#define MSR_AMD64_SAVIC_CONTROL		0xc0010138
>  
>  #define MSR_SVSM_CAA			0xc001f000
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b2eae102681c..afe4127a1918 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4487,7 +4487,8 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
>  
>  static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  {
> -	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
>  
>  	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
> @@ -4546,6 +4547,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  
>  	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
>  	svm_clr_intercept(svm, INTERCEPT_XSETBV);
> +
> +	if (sev_savic_active(vcpu->kvm))
> +		svm_set_intercept_for_msr(vcpu, MSR_AMD64_SAVIC_CONTROL, MSR_TYPE_RW, false);
>  }
>  
>  void sev_init_vmcb(struct vcpu_svm *svm)

