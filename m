Return-Path: <kvm+bounces-20610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2016C91A9B8
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 16:50:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64609B26DBB
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 14:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DDF198E60;
	Thu, 27 Jun 2024 14:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wqwF3MRr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA52A198A33;
	Thu, 27 Jun 2024 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719499719; cv=fail; b=bqNQzTyKeUvBn0+zwlLrMJ1rtV8XspPf6vSNWa1DcjjgF0gVmEzkeMWPyET66tRDW8yRuGbFblJ/6j2UkGn26WEwX7SisujCtZ19atNf3mONk1LbsrFCfJ1yOht7U15LVDmXE75V0kSrQYRCOqRZY/GwbYYxUpcUwBF3uWbKyFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719499719; c=relaxed/simple;
	bh=txGXWDstyYBIp+fmf4ApJ8QnkObBoh6bv1kLODML/uU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BVhWzlBPsCPnQ3k4cnXKM5xlFHHphukshZtwYD/UHVJ7dPp9c8sG3V1kayGeLfULoa6+F923iA5Y7haXQ0fModoCmcNprOx5c3OMn+9LY7yY0fJdXX9w/aV/twVYQ0oFsronmuLjL5iFp2Ld6/Ge7B+KO5h7Tyr9K3PyrgZBxE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wqwF3MRr; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cr9OGw/WqvZIWjxstVaV1eYEyMCjhgPKZOPvhyshKEKZKQLl1Dkg84z4K0NOSWtFqCNVz1E9R9XJEQH0fF5HxR2LTGnXzDcweHZ0V3/8HwphxP9cqUPRnd+7c0uiHp7DX36UHGE4iFoc2bBDIc/JRW7o3KmEA2/FRq4y9PKcoF8bX8IU/g7fX8hYNHs3bw+Ettwp47GlX8+Ff8Db4QtclM9Aoh6T7dXxNdWyy86iX6l+ruHrDvZT2NsiDNqlRzeIz2OUBIsSm3rf2CLj0meVkERO80BctSU2sGwUde3aPDgdyaO1QoQ9zuOgidwObsgrxagzEQ6QK8SgWebhABCKMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5US8jzrz/gB8B3rmrDc/HkcN7O5uPWIs7YE3LOhXdJA=;
 b=nWMEfbL8WvZp8qLb+q0Pfupvfft4egDCM5w79MaByxLrOr5FZu2zMTmaBiqx1jzLghu3EjcJrdarnWcrnnhFz7kiiTEdCHrhBYfJ1dVM/qz43Yc0HLxHfxtIax01ahmXK19EkfQ5Mui4jlnqUSUHwfTwR22sQvd18orJh2st22WmoqSJwu1pYJ6cR52z9e76jdkAmDQP9vFgG9jJrgBW90dt1ijWZ2kC0xvKrtpyejcZOtbZF601ihT14lVz1UjdsvszudnEehXWdb/ZudCE+Z+n+42ceNWfSC33dN4ML04zU0ruID9ysQordTW6K5uaGjj+LqdfUMseAwylGq1R2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5US8jzrz/gB8B3rmrDc/HkcN7O5uPWIs7YE3LOhXdJA=;
 b=wqwF3MRrYKFGLBX7Fh7xnu7Y8QSSRWGYWFz9NIKdMuGIi+BAzaMqkwfM2SoFe0tzaQ/KjdPI27zXBAlER3fXFr/bPNcSD8kdhrDyuaB326DPCXaADWCKuippYRPlCdxztq7z+NbhKWTMWjXe2VD7HcaGhuzrKYS6hJlFmy0DgVs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DS0PR12MB7704.namprd12.prod.outlook.com (2603:10b6:8:138::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 14:48:34 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 14:48:34 +0000
Message-ID: <87320ee5-8a66-6437-8c91-c6de1b7d80c1@amd.com>
Date: Thu, 27 Jun 2024 09:48:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
 jroedel@suse.de, pgonda@google.com, ashish.kalra@amd.com, bp@alien8.de,
 pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-2-michael.roth@amd.com> <ZnwecZ5SZ8MrTRRT@google.com>
 <6sczq2nmoefcociyffssdtoav2zjtuenzmhybgdtqyyvk5zps6@nnkw2u74j7pu>
 <ZnxMSEVR_2NRKMRy@google.com>
 <fbzi5bals5rmva3efgdpnljsfzdbehg4akwli7b5io7kqs3ikw@qfpdpxfec7ks>
 <ZnxyAWmKIu680R_5@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZnxyAWmKIu680R_5@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0023.namprd12.prod.outlook.com
 (2603:10b6:806:6f::28) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DS0PR12MB7704:EE_
X-MS-Office365-Filtering-Correlation-Id: e757b920-272c-42be-d662-08dc96b8384d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emg0OFBsVURvVzlTdnRiWFJxK2Nnam5PYm9iQWRYZlppQkhXMWpWVThkMngr?=
 =?utf-8?B?RjZkWmtDZElkbnM5Wk5VOFA1aVZLSEY0MXY2YURacjdrOGFCR2dOcEJJQm1X?=
 =?utf-8?B?YmNwenZZd25hR0l3VGdZQWF6RDVpVXhKOGlYbGhEVzlVRHFicnNJYXVMSnRV?=
 =?utf-8?B?Ykw4ZUx5M3hkbnl0d0FNSXQycWNXYkhjMTVXbElnYUIrQlEyN1RqaFM1OEZU?=
 =?utf-8?B?ZG9DRU9HQXRRTVZwQm5lK3dlMG5hWkVyNmFUQmwya1ZpSmpRekpHc1BsMGRo?=
 =?utf-8?B?VTZBV2ovaGkzUjcxTi8rSGVjVFBsVHppLzRQemt5VDVBTUhlcktzS1lRZ0tP?=
 =?utf-8?B?cXZwOE05WE9LMi9IYnFzZS80U1AvNWlxNkEyUDJVYnZDbm1jcHNzRnp4L3dl?=
 =?utf-8?B?Z0IzMk4xbU1XL2kxd1JmbjFxdS90TU9YTlVJQ2JoTFA4QS9jRnNvTi9vZk9a?=
 =?utf-8?B?Y25oUk5udVVsLzMySDRlRUFRcmt5NTQrS3d1WGg3NW9reUhwb0xvd0FLRm83?=
 =?utf-8?B?OERaL3huczRhSWNxNUhwOCs4Ui9BWFlhUFNCaGcwbmo4akxsbklyUUJvOWJE?=
 =?utf-8?B?Q3pQRGxqeVZMWUo5NjRSUmFiMnZ0V1NublM4WDNoZzlNUUhqRDFObVdXNUZl?=
 =?utf-8?B?TlpycmZKY0s3MVZydDN1amNrQVFiVnJHYzE4ZlNHK1pialRyUFgrRXZWVXIy?=
 =?utf-8?B?ZzZDbTFQSnpPdDZkWjFjZTZEQVowc0RaYnJNemhSUW1yZWN4WGdMWXdoZGFX?=
 =?utf-8?B?S2k3N0xzNlNuby90dGFlWHZJVFV0dmx2amQwQzk5MXNZVCt2K2FtQnZlN2RO?=
 =?utf-8?B?ZmdmcHpqV1RtOFVDbFB3TXo0MkI2T3dZaENNK09WcXJhaDNnaVYzcEVhUVBW?=
 =?utf-8?B?Mjk0ZFY2bVRDd1RVcVhscGM4UGJSc3FhejZGOFRYWGxGbjBKbVJTM3ZuVnkv?=
 =?utf-8?B?TC9kbEpiY0E0NUw2YWU0RVNRVVhlRUovZ09jb1dUNjFxK0dwWlNWTzJPTjhD?=
 =?utf-8?B?c2gxeitTTkxRdG1tYmdNdjdYTzYwWjcvTGpCVFpjWFZNei9rb1pMblphU2xs?=
 =?utf-8?B?YjQvNFFPeGFJb3p1RmNKMHNrWEVrVEJadkxsZmtDQkFHNHlOVzlRMngwTEht?=
 =?utf-8?B?VkFBeDZZak9MM3FMbGZQNk01MUlVcTVwT05mMWU5aXJRbjhJR0RXZGFETTJD?=
 =?utf-8?B?bVFkcEtGaHJjZUNkWDZXMXpGQUNobHdKdVk0enJsbzVVT0VDaVI4Umk2eXJq?=
 =?utf-8?B?bnFlTkcycG5KTWtIUjVNNkdOSlk3Nm1XZlNOTVVLdjY3VVQzZloxamlLZ0ky?=
 =?utf-8?B?bkZTWDgzbTZ2cmg4RnkyQkNoS2pJRDNDVmxrTStuUmtXbXI5bis3azBLUERo?=
 =?utf-8?B?aTZobmJsbUJKOHo1TFRzZTJPUERmOUVxUUgxL1BNUENVbi9ZNXNJMFZqOFBh?=
 =?utf-8?B?K2Y5aHRBd2xOUzl0cXdwNGJaSlhyVmdEKytPWGgwK2tnclBXM3Zrd1d0Ri95?=
 =?utf-8?B?TmpMUERVWnVjVm9NaFNsb3hrWDZKRUhnZVNVMjZyU0IzdHkzbnNyU0tXblNC?=
 =?utf-8?B?WU1wNjBtc29oZllGTzk3OXRwak1DWUdqRGZoa1JYMFM0SjA0VzJMT0dUOVhn?=
 =?utf-8?B?NXp4MDEzUURQMWRKVmRZVE9CbkovK0dUSFZtbFdWc0Zab3QrekxYd29STXpX?=
 =?utf-8?B?V0FGdmh5SjF5ajY4VUcwZFhuWlU4V0tiZjdablBjTFphNFcxOEpYelJnSjNX?=
 =?utf-8?Q?T9USEH9waA4MaP5ixweWA3ZnxPd8OcmPV9Q5E7v?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmVGRDZEVXkrdzI5dFBBcVlpd2RBWWhPNzJFM1pmSURDRUNuQUVlOE9sUnFr?=
 =?utf-8?B?VGRiN2x0bW0zVkM0VFJaeUMrYVRLcTVySXdydU00bDRmUXhHVTI5eE11dnNs?=
 =?utf-8?B?REtuRE1kNXVqckhSZzBRdUpLYkdWS2RXekFIUGN6TStFL0NYQkFvMGlUT1dG?=
 =?utf-8?B?akJRa0t0YUV5Z0FTeHE2TDZ2dTFWalNlaDhkQVhMV08zRmFEc3N6bjFLeHhn?=
 =?utf-8?B?Zzdjbld4bHRqVDcwYUpUOGNZTlZXamRXNGRDemVOMnBZVWF2MFBvSlVjMUxq?=
 =?utf-8?B?RUZwQVkzem1aNlBIc0FuamRheVVWcVh4YUk0QXZLbDNOZndZU3FGdHdLR3lw?=
 =?utf-8?B?Y2NtcWpTV0hpbnNvVGZUWEVxMDNBVGZoUXRTbU9TdlN2WmNKVHBnSnVyNlgw?=
 =?utf-8?B?L2o4MEh2QTFRbVNvbDhhenBVSDk5b2ViTmQxc3hCQ1RtVDR3Rjlvck5XWTJp?=
 =?utf-8?B?SXRURzVGSUFYRkxTbGtDSGYvcmdvVkEyZm9EbksvTWN3dmd6NzF3bndISm9v?=
 =?utf-8?B?bW9DNFBhbTlRR015UzBuMUswajlrWWFZT0NUTXJha2lzRGtGTHdPWENxaS9j?=
 =?utf-8?B?QkJLU0xud2NUSjVqekVOMWRzMnd2Q0gvUmUxWFFPdXlGTFF3VFpZKzVXSWRO?=
 =?utf-8?B?Sk5sS2NVa1N6TmJHeEdpS21lV2FlMWNvV0lraEpIMU0zU2txY2IzbzBHTDRH?=
 =?utf-8?B?V2tVWnBoS0NhSkxqc0kvREJnZnVrRDIzY1VvOUEwZ0paWEdZdEQ2SjJoTGFK?=
 =?utf-8?B?RWJzZTF3OTljNTJoQ3dZSHhKUm5LcXhIakJHd2NOa1ZLa1FmVTkzMFNoQXlD?=
 =?utf-8?B?TW9kcldjZUFrejh3M2dSYVFqdFpITmcrTFl1TE14VXRQVWg4dkZMZlZkVTBD?=
 =?utf-8?B?WFBJelRoQ2lISTd4a2RNOU5hellEWW5RV09ENHJWd1h0aThZbm9GUGVlSFhs?=
 =?utf-8?B?dUZUc243V0dsbTFNSDM5dktxMkZNK0Q2RS92TnhlRXV6b005cmRMSXdhb2U0?=
 =?utf-8?B?UzJUenhPS24wWEhUd3laa2MycE1yakJKdmFJdG5jS1Vhd2VSY2tCaXlQVGsr?=
 =?utf-8?B?RWZ2elVaV3dmbHA3WWtLM1J3UkIwSHl3M1grUi9PYks2WklXSlo0SThJRkNE?=
 =?utf-8?B?bzVHQkZJSm9oNXJyRUlScDJMSDI5Yjg2VElPTm1mVU1mc24wQnljUXZTSTBu?=
 =?utf-8?B?bVR5WjlVbllCUkY4RDJxZklpVkd0Y2x0c0JEY0xBdnJzSVVXVG9HM0hxdFZr?=
 =?utf-8?B?NGdOYVd2cHR6dkJjaTVYOXhFQWJhRjVpRCtUSjJNTlJKNHRFRXlxNldOVDRu?=
 =?utf-8?B?RTJPQ0hhMHA0bks2czFUR3hCa1cyKzZQYkI1L0NIdXZGVVUzWGNyUzErZWRW?=
 =?utf-8?B?cXQwQ29MSmtiMFR4L29wWTJsMnBNd2UxT293cEhhYTBHcDNyODNRSjQwdmJP?=
 =?utf-8?B?SGRzWDRYYzFYcVRPNi9xSkhuZXFYUm9QNlB3N2l6Z2F4VzBlbzFWSHlZbTBr?=
 =?utf-8?B?WkJYZ29lb2JYdmpkMEZqSVhDYTl3TVVJOG1ybTA0dlBNdDNvQUxuQjBLaWlJ?=
 =?utf-8?B?SG9tWFQrSWxNN2x1U2VjendJaFJMQkNaSWRhaTR6ZlE4WEQ0VHZuT2t1R0tt?=
 =?utf-8?B?bGg0RGFnT0VkaWsxRzJQaXNPa3RiMHp0dlBONGlFSVptNGNsQ0RtUHZEYWlq?=
 =?utf-8?B?Z3dwdVAxUDR5c3V2YlI4NFBwT01NZnh2K3V2ekRITlRZWnNtQ0Y0WDhXOGIx?=
 =?utf-8?B?czJxWWFLdUNmWDNqMnRKMmQxOFFXcnpPSnNnTW5lL3VEWEtpdE1Wdk1vYjZs?=
 =?utf-8?B?MWpIQXhtUHR0aXF2NkJoRGFmcmZoS091V3hjU3p2WUdvbzNUZEs1L2tRUExJ?=
 =?utf-8?B?cVZWS1NxQlo0aysza0tOYWdBMm83ZTg1NVZDTEhvdkozLy9qaXBSdEJSRjB5?=
 =?utf-8?B?M0k5Q01YVHVsRXhwalBUaEgrb1FYNHhGRjhndmYvNzAwczBXRnZDaEI5d0xE?=
 =?utf-8?B?NUFnL1dHY00rc0RudWVNcjVORDRneWpsTlRMc0VvRXhTS2pESXNhU0xPeVh1?=
 =?utf-8?B?UlFEMnpOcW1FQ0pBSi9ybnZXMTBoRENjQkMzWmIrNHJNSWo1dlBpMXA3N0R5?=
 =?utf-8?Q?dheEDxoPvRmKz6gudY17+5HSI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e757b920-272c-42be-d662-08dc96b8384d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 14:48:34.4265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bMh1TUAEdgZy8l9TqCqZv+niG3dFAcq5rjHVyh9efXTS6oPPMLHMmluvgEh///9CM9rCoiXhJHJAW8hXW5U6ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7704

On 6/26/24 14:54, Sean Christopherson wrote:
> On Wed, Jun 26, 2024, Michael Roth wrote:
>> On Wed, Jun 26, 2024 at 10:13:44AM -0700, Sean Christopherson wrote:
>>> On Wed, Jun 26, 2024, Michael Roth wrote:
>>>> On Wed, Jun 26, 2024 at 06:58:09AM -0700, Sean Christopherson wrote:
>>>>> [*] https://lore.kernel.org/all/20240229025759.1187910-1-stevensd@google.com
>>>>>
>>>>>> +	if (is_error_noslot_pfn(req_pfn))
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
>>>>>> +	if (is_error_noslot_pfn(resp_pfn)) {
>>>>>> +		ret = EINVAL;
>>>>>> +		goto release_req;
>>>>>> +	}
>>>>>> +
>>>>>> +	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {
>>>>>> +		ret = -EINVAL;
>>>>>> +		kvm_release_pfn_clean(resp_pfn);
>>>>>> +		goto release_req;
>>>>>> +	}
>>>>>
>>>>> I don't see how this is safe.  KVM holds no locks, i.e. can't guarantee that the
>>>>> resp_pfn stays private for the duration of the operation.  And on the opposite
>>>>
>>>> When the page is set to private with asid=0,immutable=true arguments,
>>>> this puts the page in a special 'firmware-owned' state that specifically
>>>> to avoid any changes to the page state happening from under the ASPs feet.
>>>> The only way to switch the page to any other state at this point is to
>>>> issue the SEV_CMD_SNP_PAGE_RECLAIM request to the ASP via
>>>> snp_page_reclaim().
>>>>
>>>> I could see the guest shooting itself in the foot by issuing 2 guest
>>>> requests with the same req_pfn/resp_pfn, but on the KVM side whichever
>>>> request issues rmp_make_private() first would succeed, and then the
>>>> 2nd request would generate an EINVAL to userspace.
>>>>
>>>> In that sense, rmp_make_private()/snp_page_reclaim() sort of pair to
>>>> lock/unlock a page that's being handed to the ASP. But this should be
>>>> better documented either way.
>>>
>>> What about the host kernel though?  I don't see anything here that ensures resp_pfn
>>> isn't "regular" memory, i.e. that ensure the page isn't being concurrently accessed
>>> by the host kernel (or some other userspace process).
>>>
>>> Or is the "private" memory still accessible by the host?
>>
>> It's accessible, but it is immutable according to RMP table, so so it would
>> require KVM to be elsewhere doing a write to the page,
> 
> I take it "immutable" means "read-only"?  If so, it would be super helpful to
> document that in the APM.  I assumed "immutable" only meant that the RMP entry
> itself is immutable, and that Assigned=AMD-SP is what prevented host accesses.

Not quite. It depends on the page state associated with the page. For
example, Hypervisor-Fixed pages have the immutable bit set, but can be
read and written.

The page states are documented in the SNP API (Chapter 5, Page
Management):

https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/56860.pdf

Thanks,
Tom

> 
>> but that seems possible if the guest is misbehaved. So I do think the RMP #PF
>> concerns are warranted, and that looking at using KVM-allocated
>> intermediary/"bounce" pages to pass to firmware is definitely worth looking
>> into for v2 as that's just about the safest way to guarantee nothing else
>> will be writing to the page after it gets set to immutable/firmware-owned.

