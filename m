Return-Path: <kvm+bounces-60123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 12053BE182D
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 07:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BD00C4ECCEC
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 05:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1C422ACEB;
	Thu, 16 Oct 2025 05:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fCzvN0sY"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012043.outbound.protection.outlook.com [52.101.53.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA43215F5C;
	Thu, 16 Oct 2025 05:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760592478; cv=fail; b=WITXus/mzNmQUDeIhHA8rjxrBZXHW967Mcg2XLrQo97wZBLYNbqeKM5lPA2KUnc73JYR7ftcKzXseN93oYRHdOr9eGdx1PVBut+5Q1+l83Ku8xxhs7EbhMAmaeIkttKt9iO5TYEYJtDukyKGE9N7+UnombP8SAScjT4EW1BRjkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760592478; c=relaxed/simple;
	bh=w9T2yjhuVzddGJz1zEkvRj2KpS36DcUt6RE3RiK0KQg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CYd6THxQU78e+rw9W2HMV5e1Kz5vyqIaiGf/8TruxNEetl673lIYkjciyM7Wy1cFLRVCkxzyBvaMCJx280rv0qx9febaHlx12/1xD5u1UuRrQY24oAszO8oLs5G/AyHwclpRJ46zIJYfo5aZLVIUq+MNT4wX9hwFje1cacTKy8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fCzvN0sY; arc=fail smtp.client-ip=52.101.53.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=abfxZMFB4G0IMJxSxzoPccjomUA4+sh5As3nO3cZKrlcwvAU/9Fe78y9JX8X0CIrL8NuTsxCioYVmtmfEVXyNqjTTSe8NfLdIQ6d97IcRKeRdk6pMIgF7rX0vabd4xHXOIycU8ukRSdk+f+7PyZcO3mh7cTDIGxo7qrFT2g1atE5GgBz3ZOH/5yLxXVv9AWWjwMhgdx8iutb0Uo129J2/WdEcgcTkMomlLQbx7iS5rBrjdQ+QmgdCIrViWeStg/a2LKq9AFfI2lFIl3RwTUky0TVDoGD0sj0SbkcgweC/U48dNow5RU1vH3JhqZ5ieVq2u6bRokyHIakg9960/MfvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wta06EMsDHYuPT5h7nMTYwie3DRsHsiWqlceLA+HAeQ=;
 b=I+KbqEeiKHwBjGUCCu0I5qR0jd/iQZziHSjZOIGRqKX3rV8mZuRwOkwNgC8TMmD024I/Mi/RruZYFmWxJ71NZbkNEacr5QoRChlz+OCRoRHaBpS3il+41kUZLmcGhWWVdr6MkG36WJ3fmDlSS7QSW9B4iYctQAqmHrQ59+whyl/cgwQ4IOGvZyMYwn/VEvnHTCbBCkdY/AImoTLVZeGYwPhIUnCPK/HWyW/w3e21lWjHIZDbQJvprJjfTh7uG8BYHMLYukZagASBNLp0U5+GG4uV2H0sVwzc1MqJ+rXN1Mvb1/+WRcgwVpDJnqVV+ofJ1t5p8iL2exgP3WRyjRfciQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wta06EMsDHYuPT5h7nMTYwie3DRsHsiWqlceLA+HAeQ=;
 b=fCzvN0sYOQtG4m8FD1FM8WJscBB38PS8R8anMNmqLuzgWh/osbBMEURE3PZbo9tzG7cFaWQYgse/9Anu9MPUB8Kl+8/6EpSwrPVrqZMl1j6twO866wHtRkAQ92dSf3hsT+1SvZd06HGNH49PMa5p6nONdrSc6zCUPhHDluusTVo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8283.namprd12.prod.outlook.com (2603:10b6:610:12a::11)
 by PH7PR12MB6696.namprd12.prod.outlook.com (2603:10b6:510:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Thu, 16 Oct
 2025 05:27:54 +0000
Received: from CH3PR12MB8283.namprd12.prod.outlook.com
 ([fe80::171b:b5a:454f:a0c3]) by CH3PR12MB8283.namprd12.prod.outlook.com
 ([fe80::171b:b5a:454f:a0c3%5]) with mapi id 15.20.9228.009; Thu, 16 Oct 2025
 05:27:54 +0000
Message-ID: <3b1ec5d4-0469-45d5-9356-b00f8f007735@amd.com>
Date: Thu, 16 Oct 2025 10:57:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 kvm-x86/gmem 1/2] KVM: guest_memfd: move
 kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com
Cc: david@redhat.com, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20251012071607.17646-1-shivankg@amd.com>
 <176055115910.1528299.15660583671377559341.b4-ty@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <176055115910.1528299.15660583671377559341.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2P287CA0010.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:21b::16) To CH3PR12MB8283.namprd12.prod.outlook.com
 (2603:10b6:610:12a::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8283:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ec5cc16-30cb-4459-d11c-08de0c74c12c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3NOV2xOMzhFKzlOTlA4RGU5TGVDWnMrb0VZYVRiMEQzU25BZEhSWlFiZEkx?=
 =?utf-8?B?bklaUlNIZUZIb2FhSStxbkdqdUJqd2hjNUpMTzhzL1F2Z0tydUZ3MmtzeUFx?=
 =?utf-8?B?RnhmaS9kcmZ0cThFNHJha2pseXJXcWxaVEZkRkdSK1h4M3JrMVV4SHZhRWtj?=
 =?utf-8?B?WUlqZ1JOblhMcE1FaURYS1Q4a2hKUTdYSUw5RkdzVklsZUdrbVQ5b2dvM3Jl?=
 =?utf-8?B?SXdKYWl1T0JtVEpUeTVyLzZlQjRBRDRCVkVXbTBvSDViaVA5cFV5MjRkeUxU?=
 =?utf-8?B?dGxNUEFNdGdHaloxaFNnaDdCNVFrWkZKSmNlNWNQSytzZ0l3YXdKVGFnWS9P?=
 =?utf-8?B?OVpJZnVYbG9lU2FSalN5MWIwZGtZYS9MSTJHaHVXd3lxVEdEcTFqazJzVzhp?=
 =?utf-8?B?L3VTS1cvc3Vkb01mQjhxdEcwbURwT0ZKR1RjZHR3b05vY1Q2eFBIbHQ0czVs?=
 =?utf-8?B?S2dKYUxCOS8ySHpHa3ZMS1ZFRFhVT3RxSE9KcldMV05IVUd0R1RLaEZ1QzNx?=
 =?utf-8?B?NW5QVG9qSDcwT0lpZ3I5OFpTeEtHdHp2T2N4K3ZyMitoYkN0aGFFMWRwQ0R1?=
 =?utf-8?B?UlhLUko2VWZBY1N4QjJmTU1PRGwzMzhIdTVROHBqUC9Gd1o0Z2lqaDhPNC84?=
 =?utf-8?B?YjhUelVNOUF4TjVzOHUvSzFaeDBpcWk1MDVOWTNvRTNodGVMTkovemdUWlZz?=
 =?utf-8?B?YjlkSCtsUGRrU3BadFFRbVF2WFo2VjhMalFwTFZGOFp0cVJMeEQvSGhTL1Jy?=
 =?utf-8?B?dGxiWTNsNzJVYkt5NVFOd1FwT3ZONHVTSUxxcUVNRG5ZbmJXc051bWtqdDAv?=
 =?utf-8?B?MFBRWFNpUzZUdU1mSFdjbUlnaWZOVzhZQnZ6RytnajN4QnpuaTdEZ2ZDSXNs?=
 =?utf-8?B?d1ZoZkp1dktzQVNvZktTRFBtbGdmM2ZSUWhnT2d0a3JraEt5MlFZci9abDJG?=
 =?utf-8?B?c0dyNGZsT1NTYW95YjB5MlZVVTljcEVZOUZleVJJYUMza2o4clp4SnQ1NklT?=
 =?utf-8?B?QmduRnJEc1JsaUluUnhmRllFS1RBSWFhSjZEM2RZVlFCMVQ5Y0MxQ2lmNzI5?=
 =?utf-8?B?d2RtL2xsRkZqR0ltM0pwa0pXWWE1a2ZmcmkvQis1d0tjVDVQamN0ZmZUeFNO?=
 =?utf-8?B?dXd1Rm1XQ0h3b0dSS1ZRaS9wUWpraW54VnRsbW0xQ0FiU25yZHVOWDY2bTVD?=
 =?utf-8?B?QWhHWVlvUXVSSWMvL0F4b05BdUMvVDhmeDJ6TUJNTzFLb1pwT1dwczU1VXN1?=
 =?utf-8?B?WHNDaThmMGQvY0JaRExQRUEraEE0eXY5bUExNEMvRi9wQmlUME5xVHdOeldz?=
 =?utf-8?B?QVhKRkVFU1AwVGxtWGRwWCtndDBwQXBORjJRNC83TjIyeFM4ZmVLQ3VRR0Nw?=
 =?utf-8?B?K3NLelRsK21LejNtVms0c1N3cjl5S05Uejk4VUNwaTJWYVNCSkQyZk9oY011?=
 =?utf-8?B?T3JqcW4ycWNPSlZCMHk4dlJOTTE3L0xFTm5IMTk2RmhjUUE5N2VZN1VaTWxN?=
 =?utf-8?B?a1RCcndUNHUrYk90L1B3MTNIT1BzclBXRTdGTm95S2tqWEhTNHRLbEViVEpl?=
 =?utf-8?B?WVBlNm1HOXUrd0xBUjM2a24yOEJLanhRZkVaa0hwQ0ZjTGZtenNJa3d0d0FR?=
 =?utf-8?B?a1V3UzdjWEVsenlOeERMbk1NV0dPRGhhcE16QmxROExTcXgvNncwbjJZMkFI?=
 =?utf-8?B?Ry90bmNpd0lsMXluekwzTGtseFM0L3RJSWZYekQrTUZRUnF0RTNVeXBMTjNP?=
 =?utf-8?B?NUV0Vys3NEpXYVNpMlBJLzZvNmFyUHlTakhLYVUydlJCQlJ2R21pNTJBcmxH?=
 =?utf-8?B?U3o0UU5Vck5kbFQ5Ni9ZSTFvalhCYUFZb2FVM1IwRFNTREJ6eDVSM2JIa0RR?=
 =?utf-8?B?VTIxQ0R3MnJmaWZibUNSQjVQN1JaY1N1RTZvc0VqWlk4bm9qRUNUSXB3dEd3?=
 =?utf-8?B?OW8vdnpGRHdKb2NJbEhhTzU2VE01NXdNY3FrQVZjbCtqQStPQ1p1L0pMd3Zx?=
 =?utf-8?B?S1pjK0dUaWRRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8283.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXd4ZkE2UThiNk44Ty90RWp3VmNwWExxcXViRTRuMzF3bERTR0dqM2E2eHcr?=
 =?utf-8?B?eUxBdzBrclp4T2srR2lMbGZESWx6OE5UNE95aHNaTUFWMnEwOWoyb29YTnc3?=
 =?utf-8?B?RlVscjkvb08wRmNqRXlEeHRRYkdpK0RBbkFtM3ozVHFKZFFKN01sZ0MxN3FS?=
 =?utf-8?B?L1V5MHFJbGV1bkg2akVFVUF4dnFJUXllRzVFdmNmNDlPMmZNQitvTUtwZzdZ?=
 =?utf-8?B?S2NMWjlpZk1sVWxONEk0aHdQWGVSdVpPalZzTWJiS20wR21kSEF5enhRYldB?=
 =?utf-8?B?Vk5hSDM5T3YzN1RNTXJnY2RzRlN3b1l3N3JnT2ZwTXd1VGtCc3ozZTNzZ1Js?=
 =?utf-8?B?d0RLSDBZMWdyMUx6YkVsVzEvaXBMNlR1cjRiVXZvSjZsZEkzUm10UzlNakpS?=
 =?utf-8?B?MHdSMGtJV2RqVVRhOHNOUjNiSXNVSXEvUVluY2JLaUdsbnk2TXQvMXNiWEkv?=
 =?utf-8?B?QmMwd1ZTNTd3TnlvTFhRTDhRN1JUd3ZKU1dUdDRBbzhoSWtQM2h6SDZBUnE1?=
 =?utf-8?B?ZkY0VW4wUVlueEo2ZjUxTkFPcERHU2kxSiswb1NRc3dvbkgrTXVwZThuYVlm?=
 =?utf-8?B?UnBMd3BtSGFscUQxeDRoeWJ4emt0Zk9mYVR6aURtakdNTzRHTFVOS240ODUv?=
 =?utf-8?B?RW9BZW44SG5sKzFNKzVoY2dueDMyQ0ZzUmcxZkdmbUZRaGtsRUJ6ZGN3MGxv?=
 =?utf-8?B?OU42VlphREpab1VFQlErdVJvQmd0KzVIcVRjRkhZeTR4dW0wVUFtbVFtSEQ2?=
 =?utf-8?B?RC9VVnlHcitBTDlWcUZXbzcwTERacE9mV09QNVBSRGptOCt0VWdCRjRMZ3lQ?=
 =?utf-8?B?QnNjckN5LzZIM1RmSkZQcnVsVHVSQmpCb2VEeEhWQTluN1lFQ3NlY2F0SnVW?=
 =?utf-8?B?VllYVWdid0V5LzBRU3VBMjR3RFcrNXkxVDFvRm83aVMycVRlb3p6WVZMVDdE?=
 =?utf-8?B?Y3NFZytUN0tSSHh3b3FkQ1NqbzF2QVJ3dEhIREZVWTNlTE5BRU5sakY3RWZR?=
 =?utf-8?B?ZWZwOXVSUEFkN3ROeXlKQ2t0bW9UOUl2UHU2VzVrQjdqMytjYmJNWXhocjRH?=
 =?utf-8?B?ODc4TlBFdWloY2xGTWllTkxJL2hEbmd2aFF6OUM0eXN3NFRhVTdOamp2ekwy?=
 =?utf-8?B?ZFFYSGFFUUxvUE0rTDVYNTBJRlVxTTBZMDY2MThIdUxETW55dnJrQnZ6dlFE?=
 =?utf-8?B?d3U1WU9aYUpIZ3NVenpIZjYyOVBSUS9WZGdBNjZCbHFxWmRKaG1jMlIzKzBy?=
 =?utf-8?B?SktLRnowVkhDVzA1OCtEUmZJd1dGTkY4Q1FQWmZaYjVHUUNmQUJvUmduUmRM?=
 =?utf-8?B?QlJqR1Exa3NLU1VMdGY0VllpZnRpQWsxSHpWM3hqZ0ZhKzlHNENkZXY2Zi96?=
 =?utf-8?B?ek0vU3pqb1VvSzI4WTMzZzNvNktPQ2NUaEcrWkdlbUNuTTJuQ2pyZzk2Zlpj?=
 =?utf-8?B?Q0FYOHVFV3Z2bDhmV3NNZkxlM1NoaXUrWklrK3R3SjBFMGdQVzZZRWk1THBt?=
 =?utf-8?B?R1F1UE42dGMrV1ZaOElRVzZrM1VzZ2tVWHQxc3RTendNUVRzMklhY2J1MmNs?=
 =?utf-8?B?eW03U1BMd1BtT080OHZ0RkZpOXR5d3JRRVFIVVR5OFk5bjdOenRiRnRVbml6?=
 =?utf-8?B?ZlFQOU9LOXFwN2NHSzVqTkhYQ0hLVUlSY2JFbVVmdUpwRHladGtWSEpXa0tp?=
 =?utf-8?B?ajY0TVBaMjBQNStzcm1PTDAxOWdOVElwdWxTb3BCRzNzWmFpbFNSYWZjNTIy?=
 =?utf-8?B?ZWhsOHRuZWNNR0xybDVZeXRIMUJpU0NMMlpNNFVHTjhoamtPQnM3cVNDRDBj?=
 =?utf-8?B?QUIreUZYdmZicUV4ZC9CamthMXhPa2JzR09kWHkxTCs3L216bUlKMm1penZW?=
 =?utf-8?B?Skk5T1hDQkVoNjVNbittcmlKY21oRkc3eTFUMXFVYldNTDM5SVk1b0R2V3ZO?=
 =?utf-8?B?aFZLMXBXOTB5Mk1GaXlQcGlwVHVobytKdXB0RlA0bU96V3lIVGlNR0ZUQmxm?=
 =?utf-8?B?cFNuOWFESy9DTXQ2emFPdExSWUVSR2tIUFhBZHVDSjlxK25ZdWdzUTVWNElW?=
 =?utf-8?B?Zk1iWUFZdllld2k0Rmc4SUVkYTNVWDUyTldOdDFCM09seVVvVk12SWlnMlY1?=
 =?utf-8?Q?Ih15xGwZTc5IIVSLKm2i6/Vxm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec5cc16-30cb-4459-d11c-08de0c74c12c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8283.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 05:27:53.8680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmCMI56QMxXjlxv/vW/BDatS8AxR8fUmHYNn6MeXc9ES4tNizcgDqxFHtZfMuFbPVe/dez745wErnOT40TKVcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6696



On 10/15/2025 11:32 PM, Sean Christopherson wrote:
> On Sun, 12 Oct 2025 07:16:06 +0000, Shivank Garg wrote:
>> Move kvm_gmem_get_index() to the top of the file so that it can be used
>> in kvm_gmem_prepare_folio() to replace the open-coded calculation.
>>
>> No functional change intended.
> 
> Applied to kvm-x86 gmem, thanks!
> 
> [1/2] KVM: guest_memfd: move kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
>       https://github.com/kvm-x86/linux/commit/6cae60a1f507
> [2/2] KVM: guest_memfd: remove redundant gmem variable initialization
>       https://github.com/kvm-x86/linux/commit/54eb8ea478b1
> 
> --
> https://github.com/kvm-x86/linux/tree/next

Thank you :)

Best Regards,
Shivank

