Return-Path: <kvm+bounces-39612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB7EA485DF
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2BB627A55F4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA3E1DD886;
	Thu, 27 Feb 2025 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a7fbumPn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705B41D5CEE;
	Thu, 27 Feb 2025 16:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740675412; cv=fail; b=q0gzts84l8yjZzBXV13eE8lEnui6nJbP1VuWojH+FBJ0X7If04ic+D0YAiRDMNlLIf+k4z50vKiJS+zNQdsEtcJjelVla6G2Weh6p10aJmLdrkrndlRzYDWsL7H85QwEsZEkUY67HeHUDPL3y4nbOwQCFkyxvNV4EPRXFYbUNSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740675412; c=relaxed/simple;
	bh=qgsAp87JN4pk3d4r5VAVy0dgkJ6vSvsdgTBX9hdtxB0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BDVUmLnfykwUpHJHB1CS5iOEhc6fx2wGzXBOIzYMmrGdGh1VZZ4kifFTEEvbkgbqc/ZI2ys312DIsYOARjvwZ35TT9b47x2ZmXFhUIRMlU0l4Uzvbm+jcuBwK5D0OjZMiKL9eZbVoseg/hvDZANZx1/UzfZyTomvDTzFCo0fAlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a7fbumPn; arc=fail smtp.client-ip=40.107.220.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FAct1qXhQqrNOWAo0BtH6ux+JVCBzkGbNrXfL8duGhmDMnP6x6cCXYD16YmoVUoGSjPX90y7b7+CDF8sU01MST+HV4/2p4ys4kR4wZeHA6HPIM3u0tc6tB30P8KdhzWPmRDDqhSZtEYjr3y0b+r4IqETiX0YtDrJt7DSMwK2876EClDx1XGDmoFDuUEIveQWbYe7xZg7XmCtghA7I2d9fOgsSoGfBMloSTAmLJdhKkKWF1x3kTfO1qgb1rVff59IltXp96yMUB9j5wyEhrrm/hCOQ8Vk4AUVUzZ3e5yuemQbc3CXtc1YfgPFsvZb5nYiGX+qpHuezcTbL0XSFc3oow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdQGD1S5XtnR1wfGDicu7hU9JK8WR+wXp7E0JslNKeQ=;
 b=Lp1SVyYjhulB0HpKHcNnMWMpwmYbyyiBDyXjRljdZEmm6VGju+cqLBS1xWw0Vs9iNUyndImgdb5VENePDm51e0iopeyHxSyLwaMxFXTTUvve50u1g9fSMw80xXZC/C13FsfZalOIUE8eYVgc7usUNldV0eGBwq0Y9d8juBjDyqqHDdPmEYmJi7Yira0RGFN20KQjSPZqnNj8CA7UUIE/XCrdSLWDPlMvM6kxqSGd2tof8McQzgy7+hn3dgLY9g8R78mGDhL7BlWBTjDRz+SwPZWyg07V9umByf2IgiAcIqn7yuFIkQML7JIgTPDwl53bqTLpcju3WRl1+wjNcIjk4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdQGD1S5XtnR1wfGDicu7hU9JK8WR+wXp7E0JslNKeQ=;
 b=a7fbumPnAip1lCUKzSnX3t8Kut2TcTxSXa7ka81QPk4uzfELNo+X0QbD5jz/FCYNdHsWpSvfsfft6I0n1sB0NkTfvM48nvPxQUnuDNuRRKIdnpxQdCUAzaOw+2YYMIzXVgwJMu8jWFVUcqPF5SXc+JPpfx+XkBxRh6R0vSsye+4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SJ2PR12MB8036.namprd12.prod.outlook.com (2603:10b6:a03:4c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Thu, 27 Feb
 2025 16:56:45 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8489.021; Thu, 27 Feb 2025
 16:56:45 +0000
Message-ID: <52e5657b-6297-4e3f-a45e-88b77ef1acf9@amd.com>
Date: Thu, 27 Feb 2025 17:56:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/10] KVM: SVM: Refuse to attempt VRMUN if an SEV-ES+
 guest has an invalid VMSA
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
References: <20250227012541.3234589-1-seanjc@google.com>
 <20250227012541.3234589-4-seanjc@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250227012541.3234589-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::12) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SJ2PR12MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d5f3f94-5ade-44ca-386d-08dd574fb7af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXBia0hFM1RHQWdGUmNxSDdVQXVoU3oyRE1rcGViUWVGWUpwdVhzTzJ1NEE0?=
 =?utf-8?B?Z21XaWtERVo4ckFtKzUyZFFXUjlQTEVIWENhZGlrZFAxN2JHY01oZFQ2aHdh?=
 =?utf-8?B?SE02VDROcjZONW5SYmZScS9SdXF6b2x1MFRzMTR0SlpFRk1tN3ZvdXF6c3Ew?=
 =?utf-8?B?Z3VOdnV0U2JjOUt1ZHJYNDkzVVhHUkxkbFFtMXgxa0FQYkRSeWN6anY2Z09x?=
 =?utf-8?B?VTR2QmY4ZTFVbjVoaEJFRG1KZFp3NSt1WVY5L3pPV2RuUGFOVTFnMElmcFpa?=
 =?utf-8?B?Y2hoRitlSy9TM2J6RzNtU1NMNHFteGpmNW5YVnNlM0V2eG9BRnU5ai9NTUIy?=
 =?utf-8?B?amZJb3BUTy9UTzNVVHdPd3Fzd3pybWZscFhMLzNiU0dUUDN3NDBtb0JNMjNy?=
 =?utf-8?B?ZmJralQyVmlIRlJxZlhBdmxKWmdRb1hHTDBub3BWL0IxdEkyajUrYlFJMm5v?=
 =?utf-8?B?V1NsU0cwYWtOUmx3R2U3cUxHS1JmY01MbjhzVUkzRHpjZWpmWHpvWU5lYXBO?=
 =?utf-8?B?RFJaWTFJWHF0OUdZUEkrS2xqTi8ralpuamFSUnJKL0lzSWNxemVQbHg2VnZG?=
 =?utf-8?B?NERCbFUwYVVuWG1lTEZYVHVhQzk5eW9neHh3OXYzNWNDUS9TR1NUZEd6ZWNH?=
 =?utf-8?B?QW42Um5GbGl0VzFneTRtbEl6MldnRVg4a00wNVM0RkYvUjNUWkRpMkpoWEl5?=
 =?utf-8?B?NkZ1WG9RelQwRUZxZlFFTHh1L2VTM2IwTHBVUW50bTZ6T0crQ0tpQ2FsOHo3?=
 =?utf-8?B?elk4dGZsVDVHMjllTkRxdmJKZVNIL1ZKZlJyUW5Na28ySUtVV29HWkVZTDc2?=
 =?utf-8?B?eWl6RENnbGt1L05YVmVxL204Y3F2MTNtWjh5TjBQTER2cU00b2sxR2VJbXNN?=
 =?utf-8?B?NTduZHV1bWdKNnhFekJYOFlTWDcrOHFRQUQwVjVFNVhZYXI3ekNtcHJ1a3lo?=
 =?utf-8?B?SkkzeXNiNjNZR3Uvd1V3dzA3Sm5tUUpFeGFrSGpvN3BUSy9Jb0kxWUk2UExu?=
 =?utf-8?B?a1BUOE5ZbkFBTFI3Z0c3dy9iWkMzc1FTUTFiZGJ1blFlczR1MWlyblh1WTk5?=
 =?utf-8?B?SVJqZnJtbXh3enNGbmQxT1pSRUlzRjYxZk55T0hFdWpaeDNnVlFBSS8vcllq?=
 =?utf-8?B?Q0NWTy9ndEdmUzdjY0wzNjQ4bzRoMjlIUFlXbm9YSnoxWEQ2dFk4WmFVdWlC?=
 =?utf-8?B?bU1OaEVlU0xWYm5JcnFBeGIrNHh5ZUVtanRNaTNNdndOZ3M4ZnYwZEdoNytX?=
 =?utf-8?B?Q0pwYkZKMFpJNmRBZ0c1SkpiVWhRTDBxT29NejlGOFlwS3J6MTVrOWJJUlNs?=
 =?utf-8?B?UkFrSVlZaFk3M1FuM0pSY0lqNWZHYlI2bkVSVGRCbWx5RUJaSFJoelpqRTlC?=
 =?utf-8?B?RjNrUE5zZUQ1VnlGZnp2VG9GUUp0YUhqS0cyK2NhZFI0VVVsc1YxR2tsOXNw?=
 =?utf-8?B?YndGSnVmZjVpMDlLdmwvaVRZd0cwTFREdzRXMHRVdUtld0RHVmlESFpwVTlE?=
 =?utf-8?B?dmh6enc1Yk1OOWJmUDFJUkdWbzkyTDhLSjNxc21KcDZ4ZXA4eXE4QWw1MjJO?=
 =?utf-8?B?aVVRbnVwbWhRWFo4azROOUp0Z3Q1UXgrSmc1VkhnYWRCRmRRYWJuZDhTUmRQ?=
 =?utf-8?B?VnFyZWpNZFIrVkNDYVlKY1Zuc1BwZ3RUNnN6SWVYdWZ4WHV4ZGZUK3ExbGxL?=
 =?utf-8?B?c2s1a09wNlBNWk1JK1RGRE5IY3JjeGNDdU9GemFGcXlnU3BzdDZWMWhhc2R2?=
 =?utf-8?B?UDhiem5LUW9ZS21PaHp2K1ErY3F2TmQvM0ZkeCs3VFhBaEkvWnlaYkpMYnZ0?=
 =?utf-8?B?SG1xV1duWG9pbDNhWCtJck1RTE9DOXZ6UEwvWmpySGtuVGNYdW14U3g0QWhn?=
 =?utf-8?Q?rgws5CmHgbUWX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFpQNlhycnFhTWxMYzYzdStqaVBLaDZNcnB3Sk5waEd3R0huU21va2gxL0gw?=
 =?utf-8?B?RVN4Y0ZFakN4TmVOWXJzd0IwbUtiTlB4TzV4bFl6Wm5VaEVWMjZnemdnKzJF?=
 =?utf-8?B?WjRKVzQzK1VuaDlkbVNhQ0g3MG1TVzN6OTFCcmZPbWFQem5ZSEFPYUpmQklI?=
 =?utf-8?B?T1p5N0ZrMlMrOE9ERG9ObTJDOTBWNmNEUEsrQlM1VWYwY3RvbEtwTGJGMml4?=
 =?utf-8?B?Yk84dVQ4MVhpbTFoaXRkRWxBZHJkSEtJTUJBL0FacG9kbVNsMHVEVEdSQWl3?=
 =?utf-8?B?c2RNU1V1Ui9TZEs0dDU0U2lZUFRBRE1wV2ZTcFRyanN0aHNub1JEajhCbXFs?=
 =?utf-8?B?aGJzWE05eHJmMnhvd1pvUHZYa0tjbE90cjRaUVlqV0tPdlo0bHovRENjRksr?=
 =?utf-8?B?eFlRK0w2MkltajBoOXphYjc2ZHVvazhiWURyUHIzMVlYN3E0MWU2ckJSZzRJ?=
 =?utf-8?B?cVBjWHVoTWVRYkdhYStac1loZTVDTHZPR3EySVByTTg1SVg2VFJIM0JsSVZv?=
 =?utf-8?B?bHpEN2VTZzdIOFpXaWk3MGR4NUZKc3FHYXhnZlFxdFBJVW5pVEdBOFNPelJO?=
 =?utf-8?B?VWdubUM1U0dnck9xZk9PMVNMSHRnNFdmQ2p2Tm4yTjdGRHdjaS9VM2ErcG1w?=
 =?utf-8?B?eG1XdEM5K0FZTFNFY3VhZEFMMkduM0RvOEpibVJYR1pyMlNQUjRTUTJQUUJm?=
 =?utf-8?B?dkpMNkZMSUN0ZXVTOXZFVGVZc0ZFUTdiOG96NnIrQ2t6aXd5UTBQb0Irbitu?=
 =?utf-8?B?OTBIQnhYZ2JZZnlCNmpncXlxek53MzdxVVpxekVxNkhXUDdiMElTWGJpM0U0?=
 =?utf-8?B?dmdRK3c3d3JOYTRKS1F6Y3NiVUVYNG50VkhXUXd0UHJpK01mNEs0WFVqT2tk?=
 =?utf-8?B?alRsRXE3dWlrU01OSWYvSUVJZ2FWbHVnY0RmUTdNcjdVMDhQcTUrOTBuVnIx?=
 =?utf-8?B?L0sxMHZIUzl6ZHR4NXllWDFNRWE2OXQwSU9hOTNUVGtxdU1hbWw1aXF6bGI5?=
 =?utf-8?B?dzZ5M1l2dGs5OE5FODlWeGp3dURtWHk0ZzZBYzAwR2Y5MFp3Z2dOTWo5ejdh?=
 =?utf-8?B?eUVlbzA5UmVQZzJBU1dyV3hBYVlGN2xidDB6MDNNWGUxUkxWcHBuWStQY1RU?=
 =?utf-8?B?d3NwanNCMkQyNUUzN0hIMGcxbmwxNnVQaUVMMFZoN1llbEVvZEFVYzRWblhy?=
 =?utf-8?B?ekdNa2k5KzhHV1ZYdU1vaFV0bE9jaWxSb2EvSHk1b1lNZzd6Yy9Jak9ueU1x?=
 =?utf-8?B?dTlCKzhvYWNYajFrT1NYK1hObFpnUWhRNVZLNTM4b3pJY3ZrTGtiZ1o0cita?=
 =?utf-8?B?SzFZZ2VUSTgwOG1rUXYrRktGeG5ZVWNEdkN2RDlNeDdUSUJPdVM0YiswRjk0?=
 =?utf-8?B?aTZwUFlzZWh0a041WS81S1djSXBZOHZIdWFkeEFBU3hNVTdkc1RqVVhRTGxz?=
 =?utf-8?B?N0NkY0ZuNHByelBZZ0U2c3poSEhHRXdQVVZ2UnhPNVRFVm5yVkxGNVBSelZN?=
 =?utf-8?B?OG1zWW5aTFR1N2RKOGI2R2RTN0o5MGUyaytSV2pBQmNTeHVPZlM2M21Nekd1?=
 =?utf-8?B?K0hXa1dvYWlvVmw3VWpVQzk2aEZidTVHV21QUEd6c2hXRTdZSXB3cTgvRWdr?=
 =?utf-8?B?UmZUWXlRVlI3NUthVEtFNkJGNDNpcnZaODI5YW56b3llaEhSN2Q5Z3JqOVJD?=
 =?utf-8?B?TmRTTkppb0MxNnRJbVRUTTgwc3BxTFRSUG5KWjVoVy9uVE1vaGhNUTQ2N05W?=
 =?utf-8?B?ZzFQNFp6YVpTVGFnUDJaMUlOdXdBWUxyNHVMYlR2aGJJdnRBNXhtMUVjbXZY?=
 =?utf-8?B?RUlEakw5SFE3c3FaeW4xSURZTnBIQ0dlRkxUVXFKMFkyaXpmeUwyU2tUWHh2?=
 =?utf-8?B?cmR6ekN3TE1qUnlxWVU0K0hiWFV0b0hEbWZmT3Urc29hS0FzQjNqS2NVNjZX?=
 =?utf-8?B?cmVBbzY0ZUZGZTBwekhkSFZ0WkVsNG1nTWNCT1o3SXVCY1R6dE84R3lxUXdk?=
 =?utf-8?B?MHJmaUV3YUdiMTh1TGh6WGdPeXhkSnpwNHU1VG5WZVl4RkEvOEVMa3hSL2FF?=
 =?utf-8?B?Y3NaOHVxWFJtdjdHMDNuSGNjSUM4a2JIdFhBMG54RDdaU1NCYTc5Vm1ibUI1?=
 =?utf-8?Q?S7dg48YMShOl+9k+jFLlJVSgZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5f3f94-5ade-44ca-386d-08dd574fb7af
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 16:56:45.4016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LL8FtnvJWjS4w6RI/228tKyo1hpVvkyOLtGfJiVDc6mC4/ime8LAgXDahK26FHAI3RV0vsP0dbobdSZxszPsKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8036

On 2/27/2025 2:25 AM, Sean Christopherson wrote:
> Explicitly reject KVM_RUN with KVM_EXIT_FAIL_ENTRY if userspace "coerces"
> KVM into running an SEV-ES+ guest with an invalid VMSA, e.g. by modifying
> a vCPU's mp_state to be RUNNABLE after an SNP vCPU has undergone a Destroy
> event.  On Destroy or failed Create, KVM marks the vCPU HALTED so that
> *KVM* doesn't run the vCPU, but nothing prevents a misbehaving VMM from
> manually making the vCPU RUNNABLE via KVM_SET_MP_STATE.
> 
> Attempting VMRUN with an invalid VMSA should be harmless, but knowingly
> executing VMRUN with bad control state is at best dodgy.
> 
> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 16 +++++++++++++---
>   arch/x86/kvm/svm/svm.c | 11 +++++++++--
>   arch/x86/kvm/svm/svm.h |  2 +-
>   3 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 719cd48330f1..218738a360ba 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3452,10 +3452,19 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>   	svm->sev_es.ghcb = NULL;
>   }
>   
> -void pre_sev_run(struct vcpu_svm *svm, int cpu)
> +int pre_sev_run(struct vcpu_svm *svm, int cpu)
>   {
>   	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> -	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
> +	struct kvm *kvm = svm->vcpu.kvm;
> +	unsigned int asid = sev_get_asid(kvm);
> +
> +	/*
> +	 * Reject KVM_RUN if userspace attempts to run the vCPU with an invalid
> +	 * VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after an SNP
> +	 * AP Destroy event.
> +	 */
> +	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
> +		return -EINVAL;
>   
>   	/* Assign the asid allocated with this SEV guest */
>   	svm->asid = asid;
> @@ -3468,11 +3477,12 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>   	 */
>   	if (sd->sev_vmcbs[asid] == svm->vmcb &&
>   	    svm->vcpu.arch.last_vmentry_cpu == cpu)
> -		return;
> +		return 0;
>   
>   	sd->sev_vmcbs[asid] = svm->vmcb;
>   	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
>   	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
> +	return 0;
>   }
>   
>   #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b8aa0f36850f..f72bcf2e590e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3587,7 +3587,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   	return svm_invoke_exit_handler(vcpu, exit_code);
>   }
>   
> -static void pre_svm_run(struct kvm_vcpu *vcpu)
> +static int pre_svm_run(struct kvm_vcpu *vcpu)
>   {
>   	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3609,6 +3609,8 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>   	/* FIXME: handle wraparound of asid_generation */
>   	if (svm->current_vmcb->asid_generation != sd->asid_generation)
>   		new_asid(svm, sd);
> +
> +	return 0;
>   }
>   
>   static void svm_inject_nmi(struct kvm_vcpu *vcpu)
> @@ -4231,7 +4233,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>   	if (force_immediate_exit)
>   		smp_send_reschedule(vcpu->cpu);
>   
> -	pre_svm_run(vcpu);
> +	if (pre_svm_run(vcpu)) {
> +		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> +		vcpu->run->fail_entry.hardware_entry_failure_reason = SVM_EXIT_ERR;
> +		vcpu->run->fail_entry.cpu = vcpu->cpu;
> +		return EXIT_FASTPATH_EXIT_USERSPACE;
> +	}
>   
>   	sync_lapic_to_cr8(vcpu);
>   
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5b159f017055..e51852977b70 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -713,7 +713,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
>   
>   /* sev.c */
>   
> -void pre_sev_run(struct vcpu_svm *svm, int cpu);
> +int pre_sev_run(struct vcpu_svm *svm, int cpu);
>   void sev_init_vmcb(struct vcpu_svm *svm);
>   void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
>   int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);


