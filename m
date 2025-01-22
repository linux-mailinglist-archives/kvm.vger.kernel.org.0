Return-Path: <kvm+bounces-36271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCC4A195EC
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7999C3A4C8E
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331BD214A6A;
	Wed, 22 Jan 2025 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C2tNmEsq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9637214205;
	Wed, 22 Jan 2025 15:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737561501; cv=fail; b=PyRrIFHna4d7tTzG68haXh5Lbatl1Iaq5Lj/Bu1Lilyi+kKpAD+4cG6mPTzNL5P9oBuRAs6rd37XBdIW+Nt7Zl2iRodfQKIj2542F03ZEAOpmUfzTPNFIzkgHZpjQZtOjEKE3iT/hdX3cU5J8c/klDxH2NkW8/4tiDD1ujIG6wM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737561501; c=relaxed/simple;
	bh=OvQVU5XhA5WQ9uXi7UhmgEY23yAldZwadWEv/N+QVKo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ngx9moGjZV8oj38MinVVdhMDpJiJalsOLj1sehtJRQKkm6+SsHQHC44DclxrVvSCjCdizQY5vs0C/XTEkQg6nfMayW0UYQwVjIZhQUzocIILoE+bJCe64kyibphPV9S6jQNfEEnD35P8LZQo41BrZKvNtBp34zKOIFBqb5w4SQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C2tNmEsq; arc=fail smtp.client-ip=40.107.244.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PhqAfpb+S8TRqvTfeF5ryH2jFrAvjzHzzSTcA2ap3Vx8wetFRysrxur7QQt28I0gp2TnoJashtc6vFIHFbCKi9DlSsi7Ft34ibaZbw9Ps1Py9yk7KhxiN8XjqI72zvbHXL6nHwgz/k71y4AbgR+e61+Bk1ny6vhL6hEFW+V/shPl2bVtH7rreLFSCundu0N78oc31x0dk01qWgRgczSDeMpjbUuAYgZ4iGf1V4dtLlLEHk6bL5sQtqpnIS0ydlnnM6iKzBbtZ26Di1BCcMMcscdvgE+iJ5kqUHB9IEaCg0LjVFsAMjgwOvtEHrQCuEE7QjXmjHMOzVK/+eqmsB4dZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nls8L0pk08421mX8lwNWu+2siamZyLv5Y7TfvpcaNOc=;
 b=ZFR6GC4g/6rsXjIDtjMbWbiq7qHDEXm7tXWVjUAvYM9je7wydj7RIpoR7yxyH2l3mZgqiJt1k2GDOKsrwFB6s9HiPhqDiZFqsoqHXR5iBiyKte1Ie5kKa9IKWOoxOKaGpPVQIF2nPc7uedvD0Ss2owIj8QwYPpPSgDcu0lyPAIMecvl/UCBmZ+J7VR5g9dLo9pc/LMEv9imCEgy4+xPpal+6Gia6A8a1CKwiev8ONv846SQkD3VsuxGI8PPtFebxy1bzQXaiB8jMf5UEpBL2GHS1zu39gT/Dhx3h3d/6ZAonT3MnyOdrqPdZ8pRUFqhAgvoaLaC5bHNMqv/zHCjCdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nls8L0pk08421mX8lwNWu+2siamZyLv5Y7TfvpcaNOc=;
 b=C2tNmEsqboWC2Z+pMzaOeSwU75CD9NJZdAgdhBC9ggZyA6lbj0yefjTPHW8uuK50pUQ578UgAEgSiHDOU/YZJlAwvfMF91jmml/HrACdwDyJpW4Af0IhGGrDP4Upf6shCUYBI06grH5565sQfo41uY2Vq8sBEnonuBSftTNqm54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW5PR12MB5652.namprd12.prod.outlook.com (2603:10b6:303:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 22 Jan
 2025 15:58:17 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 15:58:17 +0000
Message-ID: <6a18b6bc-d350-0aca-9a68-d819552ef91f@amd.com>
Date: Wed, 22 Jan 2025 09:58:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 3/4] KVM: SVM: Ensure PSP module initialized before
 built-in KVM module
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com
Cc: michael.roth@amd.com, dionnaglaze@google.com, vasant.hegde@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1737505394.git.ashish.kalra@amd.com>
 <9aeb32dc2b7080c534e7894d35ee8ad88dcc2c6e.1737505394.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <9aeb32dc2b7080c534e7894d35ee8ad88dcc2c6e.1737505394.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:806:21::26) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW5PR12MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd92c49-c53f-45d9-bfcb-08dd3afd9595
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTM0b040MUNuU1hNTWxCTEVLb2N0REpnRXZyVXZXd1JRUGw2RFVtalp3L0t0?=
 =?utf-8?B?RU5BTWl5VjZwdnRwbzJXLzhRaEFIMTNjd0pMQ2pxbXRnWE82VUpsUW9laWU5?=
 =?utf-8?B?em9WODFpUncrM1RDUEJGQW5DcTl1RFN0bDVSaGlPeVFXd00ySmhJQVVKSEFM?=
 =?utf-8?B?NXFVOFlZcW1RY3dpQmtDS2pxUWpYNjI0eVgyeHpXRjN4QnFTUmVnSXJrV09j?=
 =?utf-8?B?YVkzQytYOXFzRGFyY3lwbHBhVVNHYUs2RFozM2lOaDN5ZHdaVkIwNC9VdGla?=
 =?utf-8?B?dHlWMUNwTkljTGhoeU11bG04NlQ4WE9oaVVCaTdMQkVpZ0J5UlFkUzdZZFRm?=
 =?utf-8?B?R1NxTzVrOU1KTi9NdFZoVDZzejlUVzZNSEU1eDJjTlpPU0RCM0QvN3kvdGNu?=
 =?utf-8?B?bWFBa3B1RU9qTzFLbkRkVHhyYUl5WWF2N1Q3bk9vbmhSL3o4bzg5NkNKd0hV?=
 =?utf-8?B?ZUxKaS9OYWRCcjlrd0EzNTd6TTNYTU00TzZPZ2ZSM0FrZHN0VGhVSXBadmxP?=
 =?utf-8?B?Kzl4UGRMUUpWeE0vTkFrMUZFZWduOTJKcjdEMWtPd3g0RzJ1ZzRZcWp6K0sx?=
 =?utf-8?B?YU1KRFdmQ0FObUE3eWUzb2FXYTRnT2xYSm9YUFNVOWlNb0g5TEZDNUszUkxP?=
 =?utf-8?B?SzJJU3Y2dGdKc2gzeDdSakdnZnkzaEY4V0lGem54aE1xU3R3bS85RDJDeXVY?=
 =?utf-8?B?TEJrZHIzRHNPcVBqc0xBOWkwNjJ1emdjaTZJdHMxdGVFcWpnNWNRRVJJUmhx?=
 =?utf-8?B?bmIwWU9MQTEvNzdBdlYycDM2dFRnU1d1OUM0NUFwUFptOHhRREJFT1BITmxZ?=
 =?utf-8?B?bFA4RzM4OTMvVXkyTjVzSjByK0U5Q3JRYll1MEtsTUFXRUNWY3VqQzgrRFkz?=
 =?utf-8?B?Tm03QTVvck1uZkR1Mzk5NzdDU3lXYVZHcW9xZ2pYU3VUZUVPODdpalJpeFZK?=
 =?utf-8?B?WFFnUE4zS2JaNDZpdXZRS1ZPRXRrVmVDbFQzTmFYaElQQTNFa3lYc0FBWHFL?=
 =?utf-8?B?ZHB3ZkREMk1uTlllN0p5OUpZZWp4VGkrcUwyYS9rSWNyMGdybFE5NUxiSllv?=
 =?utf-8?B?bTA5a0U2aFU0bXdLK3kwY3k2M1c3bms4UC9vVGtxQ3VKSm9MSVFGYW9oZG93?=
 =?utf-8?B?WDMvRVUzK3NJZ3d4K0x3L1cvRjFqTXZWK1RaU2dHVi9IMm9ZaS9GMUJBZHgz?=
 =?utf-8?B?NWxubFJNbmNHaktQd0ZFNGZ5NlBUeFVZWnVJOEZKcmFmaTJUQ090cFg1U2Vv?=
 =?utf-8?B?ejRiV2xMcjF5Sjd6NWJnMEtxMmpvaDF6TDlsdXFZVkcvL0lEWXVPWEdoQ04w?=
 =?utf-8?B?MFlwNlVYVmFIemxBSFBXMk5lNjFUbFhyb1dqKzZaZjIrNkpEcjh2VGhMVGV1?=
 =?utf-8?B?anM0WTlyYTMxdTZIaEhQb2RjbEZJS05kakNmdHZiSFFBYTNyczhBSXFCZzRq?=
 =?utf-8?B?SEhaTXVuZGRHb0FRNTh6ZkhsR1ZwME1heFNKNlJMSWlBc3hTMUlFYUVXSmMw?=
 =?utf-8?B?cG9kK0ZVelJIN3VRZWpoSjFPRmNYcUJGVmp2Z0J1WFJldWhoWUZBZHFYMU1u?=
 =?utf-8?B?ZW1ROXFsd2RXTUlCZG9FNlYwMXh4LzRvbUFuSlI4RTRaV0JtZzF2dGVRSTh4?=
 =?utf-8?B?bkRESldEV1BXbFN0VjJyN1pzamdkMjFlWkJ2ZzE0UjFReVkxRG1TRldHUnhn?=
 =?utf-8?B?K0g0eHY2V1RwQWhQNi9JOUZsS1VESWd3d0hvVVBpcUJyUnVNRUppZWs4S01o?=
 =?utf-8?B?UG1xV3VMSUh0Z2NwSEE2S3FMdnpoQnhRSmlzTTJiekhoM05rZnRPU1NkVHpk?=
 =?utf-8?B?dEJTT1k3WVJPNEZ6OUIzdDVYbWR2eGlRSUN1N3gwVSt6dnZlMVplZkdRdVJH?=
 =?utf-8?B?aUErNGxYVkIzL1NVUHZmNEtac2ZlU1ZTSEJ5bWcvRWlIZTQrSlNxV3Vienpa?=
 =?utf-8?Q?eAu5WlPfBiI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UG12UzVjZEpBYWUybVN4TjNHUy9FTll4RGEyWmFGOFUrWVdzT1ltVng0SEdv?=
 =?utf-8?B?clhmZXpsb3pNWGZmUUs3MWI4Y3RIVS9vMlN6eDlnOHBtWS8zYjNQMVdOS1NM?=
 =?utf-8?B?WGVvZlNiSlY3RmtZZ0ZVZUtiMUduYlMxVTJYcTVDZEJoSU9iSVp1bkcyb0xE?=
 =?utf-8?B?V3RBeHZzcVlnMUdRbVRmcnpmYWFzYWQ1OEJCTEgrY2FLYk5IdHlXZzFEb2l4?=
 =?utf-8?B?QmNlS2RXWS9WMFU0aEY4TFRMQ0l2Z3VzeGlKMmd4ZHEvUGhHWWtBZEVja0ps?=
 =?utf-8?B?M3FyNlV0QW5BdEZvZkg3YmFoYUpJVytjSEN4bUxUdzUvenVFVDFGRDRpdU96?=
 =?utf-8?B?dkJ6ZCtBZGVkMVEvUkRiaXJOK3pydFIxVlQxYk9USjlMNSs4SkNrY0Izb0VH?=
 =?utf-8?B?NUJ4Sy8wdlFLZythTVQ5OTBDWjMzampicWc4WkJiYkVHcXA1cTRjLzYzb0Fr?=
 =?utf-8?B?cTJPRDhqeHQwUnNJT2wvSm1TbGhTRHFiaDNocmxmOFUreE1wcWdsNEh2aXNp?=
 =?utf-8?B?NGJvRW1qM09KbFltWVJiOG8zeno4aEhBMlVERUhkMU1sL2ZGM0xpWHZ5NzM1?=
 =?utf-8?B?N2puYUoweit1TW9NeStwZ0pvb3hDSlNtaXNCR05adDJlb1pHT3JjT01heENa?=
 =?utf-8?B?cHhHcHFQNGdiNjlpQWF3eWRrODdQcS9CTS95dVl6NmF0TGticXZyUE9UTEhl?=
 =?utf-8?B?elVJbldGKzZzajFoYXh3d1FjOXpJQU8zNXhqaWN4RWdILzNnR1pyUTFCUnpS?=
 =?utf-8?B?MjFYdnRGNFdkTmxOZXpTS0VaWkg1VTkwa1U1UDNXUFZnVzh0Q1JQMVc3Y0Za?=
 =?utf-8?B?WXNsK05OTVdjcldEUXdHalo4T2w5Z2ppYWNqTTdKdnFDMnNYRElJOFRaNDdn?=
 =?utf-8?B?dFZYbDRnZnIwK3A4YnFwZkI1UVVIMzdJeHJyMTZEQXNMUnlDZ3pZVFliL2dZ?=
 =?utf-8?B?QXE5Z1cyazhjZ1k2bFRiY3AzT28vVXMrb0NFTldBR1ExWWFZKzRqRlgxMmFG?=
 =?utf-8?B?ZzFiZWtwTGcrQmUzZ01UUVVDV2ZXSWhGTjR3ZkpJQSs3QTN3cVF5Y2VxTVlB?=
 =?utf-8?B?SmhwTEtTdUd5YWEvaElFS2g3dkc0VUtCZmxSTSsvVVd6OFNDZFI1RVRiL05m?=
 =?utf-8?B?andXQWtHam1TR3ZlK0l2MW1xZzhSdkhEL2pOZDBlV2RXQTlZY3hnNXZxeXdo?=
 =?utf-8?B?a05UYWs3dUtySXI4LzRrTHB2V3FJUkhvMXVuNkRBMFhuUU1ZMy9QaDNqa2J6?=
 =?utf-8?B?a1gwQWwwT1NnRk9rSWxBNS95M0djYmVsK2NjbkN5MU5UTXpNbEhUa3FpZzIy?=
 =?utf-8?B?Rm5HcE8ra1djK3V4Q0YycmptNVlzbk50VTFKSlRMVVlrREJVa3paMktDWDVa?=
 =?utf-8?B?aTJqWXhJNUZsTmFob0VJbjdJemgzTW5sSmxGb0xpTUVLV0JMcnRKSVRkTlNV?=
 =?utf-8?B?bTZVMkxzYnlKcUtvQ2hkeDdRRzlNbXM0c3FvWnY4eXNvTnl2VVhtMFUrOGNp?=
 =?utf-8?B?S3BkeGhlMmtHWDZqZUxJUkR4RDJFaE5PajBrQTVWUVQwSHU2Y0pxUlYvT0tG?=
 =?utf-8?B?MjYvb2RzekRHK3RoeHBzNHJ3S3RrcXlKNHdTWWxmK2lGUERaaXFtRzNEbi9P?=
 =?utf-8?B?bHNjb0RuMlpCUEFSZlNqWFl4R0NZOTZyNkp5MkhKaTFPUC9GOHpDNFcyZmo3?=
 =?utf-8?B?SXFTaWQ0U3dkdS92UGpUanBTNHVMLzkvakV4NEp2czBiYXFsNVJnQXFhaHU5?=
 =?utf-8?B?a0NaRFQ5djgvL0xBMStpZVlvVC8yT200QWM5N3VHWW9qa2NFek43eWc5dnFC?=
 =?utf-8?B?ZDVtQ3NJYXFETXErc2dQUDBNRG9yMm5PYzlPbHF3YkNtZ3RUcjM5MXVKMXhs?=
 =?utf-8?B?NkZKR3BVSG1OS0doMW4xU3IzUFZ4eFgvVjZHT3JFTUxjbFBQRXNMYVVYby9W?=
 =?utf-8?B?M3Vqd1lYSkNnWVNwZWJiZDdqR05vSlc2WkN5azc1Q3g0VWVxNjdqVlNIVnlF?=
 =?utf-8?B?cGF1aXRHVWIwYnlMQW15bDJpVnlQenJyN0dnaTZNalVEaUVVVXRDc2RZODlr?=
 =?utf-8?B?OUZ1SnR4UzNkZzk1RDIzbWxHVkxyeFlzMzJnN0lPR3M5RmFyUFNLWEJBbUhU?=
 =?utf-8?Q?4RI/dmdvUHor/fc5Ii1Uyo8Jg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd92c49-c53f-45d9-bfcb-08dd3afd9595
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 15:58:17.0614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VyUR8U8OHvCRYKv8Ner3HiFtUOzzRagaN2yawvQ8WT2rS2klozJuXj2jpMgajJSRJ3l7bbcnLPmv/U5x5RRb1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5652

On 1/21/25 19:00, Ashish Kalra wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> The kernel's initcall infrastructure lacks the ability to express
> dependencies between initcalls, where as the modules infrastructure
> automatically handles dependencies via symbol loading. Ensure the
> PSP SEV driver is initialized before proceeding in sev_hardware_setup()
> if KVM is built-in as the dependency isn't handled by the initcall
> infrastructure.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Requires your Signed-off-by:

> ---
>  arch/x86/kvm/svm/sev.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 5a13c5224942..de404d493759 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2972,6 +2972,16 @@ void __init sev_hardware_setup(void)
>  	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
>  		goto out;
>  
> +	/*
> +	 * The kernel's initcall infrastructure lacks the ability to express
> +	 * dependencies between initcalls, where as the modules infrastructure

s/where as/whereas/

Thanks,
Tom

> +	 * automatically handles dependencies via symbol loading.  Ensure the
> +	 * PSP SEV driver is initialized before proceeding if KVM is built-in,
> +	 * as the dependency isn't handled by the initcall infrastructure.
> +	 */
> +	if (IS_BUILTIN(CONFIG_KVM_AMD) && sev_module_init())
> +		goto out;
> +
>  	/* Retrieve SEV CPUID information */
>  	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
>  

