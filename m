Return-Path: <kvm+bounces-31599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F11B9C510C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 377F4280DCF
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95FF420DD64;
	Tue, 12 Nov 2024 08:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zPatxn6d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B8E20B7E5;
	Tue, 12 Nov 2024 08:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731401037; cv=fail; b=WoBsDek30TZWkfGjBIlSjy940Dz7gLw8wdbNV13Ao9l1b9LlYS/laz6pCwK+WZSFntK+VQyVcCk1JekTvN0idGmIUUX1rORlJg9g7CToFEZwuaZt2TUU9IZnPy7RlVsLTuviDhyrL8jp5/Oiec2ixYQATOepmovuINDNVn7srSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731401037; c=relaxed/simple;
	bh=ULq4xB9zpW6MR4DGLXeMY1gbl/5+b+1SKV0pOP4PZlo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tsGJxXQo7Bm4M4LssmlZY5AOXgXjo3MzrgTcA+AIgQb1tqVYB0DFPOlqoxx1e4GNPM13gvNIyzFJk1OVjRHaojGbCRaAW+D49ZC5mTLctffwnov0yMKX5aZ27YU/j9F4/PvQLktme/rAIOF7oN6pX2KsNlg7/3MYtcGH+Kdcryk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zPatxn6d; arc=fail smtp.client-ip=40.107.236.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NnOB+7X8rPZGiens/rOUAqN6K5EqHgZcc9esO68KDR6oqy3NuPdWu0bW+ZZJ9pSrBu4Sjwgq9+tv/b3ZSotinOuAWBZU6qb2xkdl61PJ3mEHUDM8AmqehUJEyj6cuJhlAr2W5iyFGzavsBFT0dl7mWgwq9+Q+5rtvduWwm5F4NvADl1cy1vY8VLKdbG6wW9Nj0aMiVMw8UaJiyxGazpH/WoAITYyv8XLqa26E8IobZmnFSfxy1QHyYBxL1U7muqDrvv3Y8WMied0B13tSj+Xvc8DNcc7zwQJKoSJNwRVpv8sDhjHYdqSsaEt9dEaZcq57c3fp9pp/sb4fSNfxfwilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2XX3NjOWBselvIGoWIVSH6+Z+XEqWFx9BKsBtC7mIU=;
 b=kqE5jtSLRtFa81vUOBRnQXFSXME9PFDCdqrn7avW3H7X8gU2oOG+MZa7BRzmVP1s88tTOA5j8Uv3eQ9IhTYkgxtZG/IrP3TimHNjQ7Z9uwL8HnKTmflw6kJZAU1T4z7GRBWLZe7BsB8iSph1alvkEjQBFrfTdsblFIzEH5OggW8lYQ1G5VdHHCEUAxiHWsf5AP8P9km08lcCw6Gat7KegD/TcEX3jTqPl+r49X4xsVBn5im0LCezsum/3WarkHTAJ0KkvjJYrxhAviP5k4YA6CBy9NIaNx9Vg8sGRvScLqVKMeKCsV++G5RcW5E1HVmWbqrhrrkK+wFS331o1ohXlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2XX3NjOWBselvIGoWIVSH6+Z+XEqWFx9BKsBtC7mIU=;
 b=zPatxn6d6itfRYnA2nG7Hu9t2y1Xt6t+j3H3utFynwJ2a+1P49+TipWOWNcC0jup7EpDAke00FypHo4hHun/21qL/F2azcvuxoUdfKqT5gdCN6RWFU0d6XGLLu4+BP/mKAwv5AD+PKfWOXKKgNnViJGQd9HCpXsx5a7xCE0gMuY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM4PR12MB6661.namprd12.prod.outlook.com (2603:10b6:8:b7::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.28; Tue, 12 Nov 2024 08:43:53 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 08:43:52 +0000
Message-ID: <c7bd5e75-0f6f-6718-ce52-533bfad4f37e@amd.com>
Date: Tue, 12 Nov 2024 14:13:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
 <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>
 <4115f048-5032-8849-bb92-bdc79fc5a741@amd.com>
 <20241111105152.GBZzHhyL4EkqJ5z84X@fat_crate.local>
 <df1da11b-6413-8198-1bb0-587212942dbc@amd.com>
 <20241111113054.GAZzHq7m-HqMz9Vqiv@fat_crate.local>
 <0c13ab0e-ee34-5769-2039-32427ec4cf62@amd.com>
 <20241111134215.GBZzIJtw-T0mWVKG5l@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241111134215.GBZzIJtw-T0mWVKG5l@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0124.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::9) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM4PR12MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5b6daa-9385-4d7f-b415-08dd02f6228f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3NRcG1aTVRreWNPd3RRUkFkT1ZsUHpmYmdxeHhQbjIrT1dkcENDNXNqZFRi?=
 =?utf-8?B?b0VLeEFGVmpwbTJnaVRoWlhmdWZwYndjVjE0czBnMU1DQVBsc0lBL3ZybTVK?=
 =?utf-8?B?WG9NQ2pkNnhyckZtemhQdzROSnFQendJMitYUUlxUUF3bnlxcmpwVGF4MnJo?=
 =?utf-8?B?MDdzM0VmdkpkazUrckdicWZBRFBSTjNXdnh3UmhXMlFZa2NNZWI4c0FKdTlD?=
 =?utf-8?B?OWlIVjI2MzRCM05KTXdrcG5mbWt1RTdwQmZyVFA2RVpkNzBDQy9CQjhmazg5?=
 =?utf-8?B?M201dHJ2UUROQ2hJNzhyMnJRSUZWb2p0V1JCelZmYkE1ZU1oYnNDQnNWaTV1?=
 =?utf-8?B?U21SMmdoakFlTmJnZTkwZUtqVGJMdERmY3hKejJXNU45NTY3alpyWEtBZmNv?=
 =?utf-8?B?c0hZYytkNlJTa05vRVVKTGk1cm1LcHVseEVic0FOSUVxRVJ6Vnk3b3lVb0xl?=
 =?utf-8?B?K0lmdERUNEx2Vm1GZFpqSkpSMndCUTcwUEozMnZlb1Yxb2sxVGpsVmFXOHBs?=
 =?utf-8?B?d1pRUCt2VGo3VTAzVmdRQ0RJTFZaN25YOUxkeERPN3o3UlNqclVVR1JHRTAr?=
 =?utf-8?B?L09QbnFwR3U1S0J4V3NlWitPSzZuTkw4amFuYmcwTHJQaC90ckhGZWU4ME4r?=
 =?utf-8?B?bmRSN25HNUdjcjN3bzkyUG9KQnZZUzRVQnA5cUVvR2NHWFVwM0JtdVRkbldQ?=
 =?utf-8?B?L29hallMY3VRUHJENmVYSEtKdVFjV0ZiYmNyMEdkQU1iNUFiaEd1UzBmRTM1?=
 =?utf-8?B?N2ZiRjYxU0c3c01RTXIvQTlRQTkwUXl5dURYNHNjdnlwVjl0NVJhVUFNTXIv?=
 =?utf-8?B?UjczQW80MVVSWWF0YWJvL0ZIUklrQlZ1UTRZZ1laLzZlT2lVWUNPWEVBN0hk?=
 =?utf-8?B?QXZTNkJaVmlKajVWclhTc09ubEo2ektrWTJHMXBxTThMRy9pNVdyZzhCZlht?=
 =?utf-8?B?clplUGNDVkc1R1RXaGV1dnNqMk9kdTNxMVRRVkpkTmd3VGV6QjlTdDZBcTZa?=
 =?utf-8?B?M210dUwzeFFnQkphalo5MHZLM0RuSjc4dEdtTUpubnFRZEVDQTE2cU56WUY5?=
 =?utf-8?B?VHFpcVI5MG5GMlVJenNmSGt4YzZzbEFmeDNhU2dMd3NOcGRSMVozb2c5UzZJ?=
 =?utf-8?B?Z0JHbDJQWGFDa3ExSDZhck8zbE1lMEhZUi9oQlZpKzEybVAyczdoYkkycWZn?=
 =?utf-8?B?TGNGT2htaGg2QUZzRGNxak92ZjBLVUlMMVJpWk5vY3BlbEY0dXRIdURaNGNi?=
 =?utf-8?B?NFlDOVBxNW1YMmpoVkVvWjluS0p5VGxFNHA2aHZwNXoyUHVkV0FONEo0eFls?=
 =?utf-8?B?eGNaM1F3cGJSeTNSQTVpRTY1YWh5bk9GNFhUNFpQSFVONWhCYlVCc1liZnBi?=
 =?utf-8?B?d0FBUHJoK1BmdktnQzJYTTdPaTYxcWRscklVdnpleCsweHEvbUcwcENBVW8v?=
 =?utf-8?B?QmRld1RuM2YvOFg3UjBZWDRBaWJhRHQ4anB0eXI1Ymd3QnJvRHRMRVorSUFi?=
 =?utf-8?B?TlFSQUhWRVFTWHhoZ3pDMW4reSsvU081cVBMTUptekdoQi9ZcUd4UFBpWTJV?=
 =?utf-8?B?NGpjMlh2UkFOUy9RRXlaT090VDFlWTZnLzEvQVJiWE9SNjdqK09JUWRMTS9L?=
 =?utf-8?B?NGhGTk00ZDBLTW1nNWdCQnkxelBlcllTbnFZQVRYbVJZTDhBWEc3WFdsMk91?=
 =?utf-8?B?SGhoNExvcC9XUlI4UEhqNXE3Yyt3aVVRSGh3VEx0WEszVFVuNTN1bmp6RGNH?=
 =?utf-8?Q?zm7DGI6pKzGijLvkt8OPgJYaQZeiGLmKfa6X2Z5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHI2cDFKNllaMEJvZTBVZGxCVTVGTitLN0o5M2lybnV0MzRZMC9zUmVGcEl3?=
 =?utf-8?B?TmpWak5PRVUxREc4NUtvc1hCV0o3dTlYcThURWpzeUU2ZFZST2dXU1gvVk1K?=
 =?utf-8?B?Yit4RjNubDFxOEhGaGc5VVE4ci9VR01xS0NpSjBJaEVXRm1vQlUxVDZsS2hm?=
 =?utf-8?B?UFg2UjdMS240ZVVRKzVhL08vRnhRaEttUVRNbVJDWWpKQnEyYXNVejZHUlFZ?=
 =?utf-8?B?YzBONXdTcFhqblloTzZHTTc2dTNSRDU4STMrb1E5blM3aWxvMHR6ZW1yYm9I?=
 =?utf-8?B?RGZBUmZNVUhjWVpDK2U0WmVuSFhEbUhlbzRkSTY0d1YyMDhIWWhCaVdkMkdy?=
 =?utf-8?B?N1R0eG9DN2pEak8ySExidkhjU3huWXRhUWJPOUlLV0JrbkV4dzNpaHFIOENH?=
 =?utf-8?B?eVRBOUhQcUV1akRFYisvR0JMeVZjSzZESFRtL2laLzh3b01nTC9EYmFHU20x?=
 =?utf-8?B?Ujdrc0JoeHhZNFJ2MXNFak1DaHM2dnB1R2h4SlVmOTA2bWQwbzdwa3dTQ1ox?=
 =?utf-8?B?NW9teUpyNzNhQTYxWmNabjFjbk84bkNwSDJqQzB3QW82RHlqc2Z3VFg4Y0lV?=
 =?utf-8?B?TldtSks1dDRqWUJSaW5ONkxEYTZiNFpIZTZQTDNyZkRPcFJ3bmcvbExOQ01F?=
 =?utf-8?B?cTVMYjJodlFobzNXbmRHcXhOMFlqS3lyLzgwTG1pQ2ZnNVZkWjI0aHRsaTRr?=
 =?utf-8?B?S1U2dnF0dThxb1pFTmg3TG1EdndsU1Flam5QeU0rWStXVlMzald5VVhzWllD?=
 =?utf-8?B?VWh1SnI1OUE0MVdYTmcwOVlveVFNUzlzMmlCeFBkNnBjQS9aTnZ0dSs1dnYx?=
 =?utf-8?B?Z2M2OVk5TzIyNks3TEdwNzRSVThZdWxHZEtwaUVkOFlyTmZ5VDJYUE4wSktW?=
 =?utf-8?B?cnBjbmdrOVJoU25pTGtreVZ4M29LR1c4TWxaVklUeWRZbGVyeXhWNzUwMk9W?=
 =?utf-8?B?cXhUV25TQm5IZ0s0M2FPMGp6QjRKb3hXZzR6QWpiMHhWQzI5RE5iUjEvZVBz?=
 =?utf-8?B?Uks1elZWenVCZzcwaGpERUVDVHE2SGFEb1hkbFpKME5GV3JsTW44bkZSNTdD?=
 =?utf-8?B?a0FvUitJTENEYUtLQ3BKR3ExTGxKMmxscG84M05WTGkrcDhKTTFQejlOS0FM?=
 =?utf-8?B?QkNEWGJNYmF6N3dnWkRPcWQ2d25vSVVoQ0IzN29VRDZkN3FVTmtnL3JNSHQz?=
 =?utf-8?B?NXhNenhDbzZDbUV0WUdDWmRVS2ZKci90WTJvbDZQU0R0dW56SGJtZmV1eVJC?=
 =?utf-8?B?aTNjVDF4S3lHTDhKZWV3VUFxcVcrblpmYUhqc0FSQnNwd21iRGlMelJiTUgr?=
 =?utf-8?B?UlRRTGVEZ0gvU3h4VFZnZFdwcUVwUjlJa2pqaFRaam00dG9rd1lvOWlzTlk4?=
 =?utf-8?B?R00xTjlGUDRITlBWOGJBY3cybFN0N2Q5Q2JDYWlKVk9RNmFLdjRtR09wWDlY?=
 =?utf-8?B?VGhIZTc2VEVJbjcyTHR2NERLVFg3ZTVXbGZRVVZUOVFtc3JDTHVLQnR5di8z?=
 =?utf-8?B?MjJ1TWlpUngrTDdNLzNiSHRGdWNMTU9wSDNOWTBKS1RZeXREbUJPcmUvdFpt?=
 =?utf-8?B?emtQR2RPL0VIenFMT3Nzakgyd1U0VU96KzhueDZyMTJiTllVQTZ3Y1R3SG15?=
 =?utf-8?B?VzZjVUIzaGtkbVh5cjdiWUQ4eFp5dFZtV0tCSjNBWmpqYUtuN0J0S3MyZzRm?=
 =?utf-8?B?SzdRbWtvdVpCbnBHZnNkSDZSS2wwMzVodVlSaitkNHU3WEthdXpLS0txWmpq?=
 =?utf-8?B?STNnVC96V04vNmMxTEFYVEMvbklRK1l3UVJ1cmNKYk1MTTNqNHlGc2RhNzk5?=
 =?utf-8?B?TGZEcElZdXBLV3NKTFZXNTFMVDFTUU9jbUV1M3IyTWhuWTZrU25uNVhWNmRL?=
 =?utf-8?B?NktFSGxSbU0wcFNQTFZOTWVyUjY1Q3MvMDdvTzNlekNiR3RvdVROSUlIWExl?=
 =?utf-8?B?SzdJVVNWNmZ0Q1dncWJrYittVWRuREtGWk83N2ZTSEpGVi85Vy9rdE9lOVdh?=
 =?utf-8?B?L3FWUDJRKzdTVFZWdnBXUVRtd1FncHk1YWYySHg1OVpOMmJtUlJ5dUdCeVZy?=
 =?utf-8?B?K3hUUzlqR3RPc1pMK05pVWd1dU5LZldlNGtiWkFieWZBR01xK0NtQThlMXBi?=
 =?utf-8?Q?p9hJl1jhqxxbsDChb2xL8/mo1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5b6daa-9385-4d7f-b415-08dd02f6228f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 08:43:52.8772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lhKFyzOOUwxrJak2TGVYdQWtFQtU7frXdKWM53WGy9BPPJJ5Lt4pimPOtvOctKYaAs0SwKEH+khlN49lrcAoNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6661



On 11/11/2024 7:12 PM, Borislav Petkov wrote:
> On Mon, Nov 11, 2024 at 05:14:43PM +0530, Nikunj A. Dadhania wrote:
>> Memory allocated for the request, response and certs_data is not
>> freed and we will clear the mdesc when sev-guest driver calls
>> snp_msg_alloc().
> 
> Ah, right.
> 
> Yeah, this was a weird scheme anyway - a static pointer mdesc but then the
> things it points to get dynamically allocated. So yeah, a full dynamic
> allocation makes it a much more normal pattern.

I have pushed the updated tree here: https://github.com/AMDESE/linux-kvm/commits/sectsc-guest-wip/

Will wait for your comments on rest of the patches before I post the next version.

Regards
Nikunj

