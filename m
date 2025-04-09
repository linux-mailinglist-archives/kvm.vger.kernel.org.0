Return-Path: <kvm+bounces-42991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C67ABA81E18
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 09:18:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94ED51BA3B8B
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 07:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4388B259CBC;
	Wed,  9 Apr 2025 07:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rNP9VZWU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6FD82899;
	Wed,  9 Apr 2025 07:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744183080; cv=fail; b=lk5HIfD/lVuyjglaBXV4rzcXdafXxzKkzhUHBj6rVb9m5MClPwk1acOyiNi/rOgxHwARedJGw1/H8MY1rRa/S4cAeXXbxCJCEUwPUg+Dbn6Dpxk3WxV9shud7vIXCBSD45ELRkw1ZQ9yX605PHNeCR5TlPeq/cAcmOsEEc6nZNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744183080; c=relaxed/simple;
	bh=QCRKSmUXxotVcoJ0hGP4V0iCy1EJQ2K7tGDHmSEi6d4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X2bnm+MvqE/uKiICMwl2gaNSQtuABSZpySyTh7gPvl0uVB0rqwE9gaaqZTBnVZDdcZp3iEDA8zp0Ob6OzwNx+cCOmrHGOd1Ri7Z8xTDURP6j1gge2Wma8PXlDPnKdolS2mRH3R1ApAsjWtSBMNQAkHkNT5GkK/VflFpA0/v8wFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rNP9VZWU; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SyhsZOPnu1W/qaViQrH0TRYRiMCiNdnlu7kJ+b0FPFr5lr3pn7j1BLhZVEUJNjXi4TcHPGSmEk5CehXq6gGkvYn40TWxJU9vsVoxEHeaFgWEUo26UgrwpN3C+dLvFkRX5XqkGzI1LGfPamWn2R6besKtr+d2PPH6K3QZL1FGvet8tgMt8vpq2JeQ6ft7HJKkMS+BlIglucv3KlNB6vJLkCTxQVya0T9ewlipkTlyST7ue9I3emURMyZI12yKywZFHsdIjHKxQWOT/eWG6wtBoibM20Eh3VRVw9VdDM5l3svPS3LPY7y0QjG56ChHucDRnosk1Gk8PRZHbvxizb4qSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIlzQGZNldBft4p1/u5+F4oyg0WFRB9s40rsqOzVsDM=;
 b=f6kuDOhwmDEo/fTQmh42+33H3SMvSUXOx/i3A/XfOcEdlBcPhQMfLMJadOSMKngSeZRCEudpsxNQ6s+EW7W+bQCCPiWohuFRZsAYdYnXviLE4aR03hk27wrmVP4NMvI22sXRwoKV8h0HFXql7ev4hxDidJyH/8mL+TeiyxxxRv/SBLzZFxcqlkkQ16e2O9JWyM3F/XUvQ0OypbGUnWuikFAY/SuXNsfAa0W1DmgztvNsUeRWiM+D182JaP6VazMItQOIzqRzRxxNKtpWbfRsOzhwFc9WQ4DidKhlu/H3o36VD7D5MjxVqtf+IXCJnBF4rvvlH03WeOvOU2Kz6mSHjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIlzQGZNldBft4p1/u5+F4oyg0WFRB9s40rsqOzVsDM=;
 b=rNP9VZWUvjTuB4xMkIQr1VyKpWH6EzxeVtd0jTp2RXCLj21tcRdGxbDKhbcxlOLM4dc2pu461w3dtluruGTMmA3lYF64MjcCGc2tZOnzdZnipnKG1F0cRywVwLL8kSu2cNhpV9pvLmMUSJb5pycogT3OmSe0mCklzf60oJH/3OU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by DS7PR12MB6215.namprd12.prod.outlook.com (2603:10b6:8:95::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.21; Wed, 9 Apr 2025 07:17:54 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%4]) with mapi id 15.20.8606.033; Wed, 9 Apr 2025
 07:17:53 +0000
Message-ID: <d5942725-2789-4626-bee1-81d69ed794f8@amd.com>
Date: Wed, 9 Apr 2025 12:47:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/9] KVM: guest_memfd: Allow host to map guest_memfd()
 pages
To: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com
References: <20250318161823.4005529-1-tabba@google.com>
 <20250318161823.4005529-4-tabba@google.com>
 <aeed695d-043d-45f6-99f3-e41f4a698963@amd.com>
 <diqzr022twsw.fsf@ackerleytng-ctop.c.googlers.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <diqzr022twsw.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0220.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::18) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|DS7PR12MB6215:EE_
X-MS-Office365-Filtering-Correlation-Id: e71f49ec-ed13-46dc-efc5-08dd7736a4c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azVMKy96ZVRiNVpLS3BYTWxocTMrQlA0TkR3YjBlUGRKT0tJeXB1M1VyMkN2?=
 =?utf-8?B?VjVYdFpKZ3ZJclAvdzFCNEpKRHNEa2dCUzduTE1NckpFZitLZ0NYMGEzRVhC?=
 =?utf-8?B?RDdtN0VxWmZpcEIwTDl3TlpidjRrWld2RTRuSmFBQWQzWmo1UkZ4L2NRamdu?=
 =?utf-8?B?Znl4eDl4QkZpaGEwK3VTcFlqQm1HWVNRczg3Q1o2aFhMRytjOW04MzFxWUtt?=
 =?utf-8?B?UEFPT1JHV3BkU2twemF3ZTV4Q1FLRC9udnZPOHVoaGlUdm9YdXFncG9ZMDVD?=
 =?utf-8?B?MCsrc3Exbkk0UXZhdlhub2piQ05LQ1FhV2h3WjZKVkZpSEFUbFhQZjEwZXBk?=
 =?utf-8?B?K3V0NGJtNUFzL1dGUVFFK2dHQnlqa1U1aWlLZ2lQQnBVSGI3clRST09XN2du?=
 =?utf-8?B?Qmp0V1o3Smp6UVkrYnA2eU5zeEtSVGpMdVl0UUhoQTNiU1hXZk43eS8vdmlT?=
 =?utf-8?B?MnprTHJEeVVyYjBVM2gxQzZQYTlONzNUekhubmVmVllzQ3pxbDRweHU0WVRN?=
 =?utf-8?B?VFB4RVJDQ3ZFc3N0SFM4VzdSRlZaUEN5MXlteTYwQjZCTjRKa3BXWVNDTXZ0?=
 =?utf-8?B?NmdjV015UmdNelFCa0lsdFYvMnFyR2pCTStkK2RSRDNoTGVyWkFOZVZwK1BC?=
 =?utf-8?B?bDh5S1dueHRQT3FqYllVU1EvYm10d01paGtrNklFZmcrSSt1Wi9QSUZ6UTla?=
 =?utf-8?B?SXB3TVBjVVRNTS8vYjRCU1UvMVgxdmZlOFpWWkJNdUVtZVBLKzE5VXhvdTNp?=
 =?utf-8?B?RXBsa1R5Z3AySTdzdUZIU1RrbTBjcHBUSEtiMDN4VzdjeFZkVHZiTDF3aUpF?=
 =?utf-8?B?RlBjeEc2amE3STJEYmowMEZkWnl3UDBONHp2aUhjS0dHTUt2Z1NURWNub0R0?=
 =?utf-8?B?ZWpGVHpqQWRyVWRrNUZ1K0VsRk1vaCtEdTdxYWNpdXcrWDhoRmdPa0NEZmZL?=
 =?utf-8?B?V09hOUVHTkNVazN0RkRpd1A2K0Yxb1J4T0FtMXFUMnZPQlREaXJ3d2VWc2R6?=
 =?utf-8?B?WENvWVVpYnhSRTlSZG1HVWtNaGNIMFVHWWdjVFhBR2hLVFZVekxFaHhjb1lr?=
 =?utf-8?B?Y0pqMkNVVDFLRjJoTHI0dmpDM0dycGl0dkVvWk1GZHk3VlVTUjM5WHpKcUhI?=
 =?utf-8?B?TmNQSkNGNkRSUm9xSTFvc2xSSi9DcnQ4M0hmbFMrU284K0p2YmNlNkZ1ak8w?=
 =?utf-8?B?RjdwZnNoV0lrN2tKVVYyYyttUlFBUXJJZ3RNYktvRHp5QlpzTVVuYURyTUd2?=
 =?utf-8?B?WHI5ZFcxZnk3OStFcTFHN1JuZlZYbWlCb0hxQ3lTT2U1TFVjMVZqVzlkeWZn?=
 =?utf-8?B?UGJnbDFVZzQ2MnlCSDhZV1ZzeHNUQ3FFT1NmMG5jZEJsL0g1cEhaNFJ2cFlO?=
 =?utf-8?B?dzArUkNtRmUxaXU5ZkJSMVlrUUhGSHFPS2tQY0tVaHUzdnlHMHBPTTFhVEQy?=
 =?utf-8?B?U2I3aHh2cktWYzZFTXZybUxUWmlnRlA2SkFFR2lSVTh5NGMwemtvNG16eHFH?=
 =?utf-8?B?Z0dZNktKQ2RKZnMyTXQ0OUJnY0xBekxZd0F1NlpxcGliWFRRK0NrM1pibUNE?=
 =?utf-8?B?ZjRMVFB0V1NwTGpKbkxNR2cybE5mcjFrM2pCRDJleUJ5TWxFUE1mZTYzTFRY?=
 =?utf-8?B?cEpjNnJSR0NFK2NyZ3NaUFFLVzZsUy9henBXTkEwRjdGb05maGdST1dtdTlH?=
 =?utf-8?B?SVc5ZWlGeEt4b0FxZ1pGNEluOEVGc1IvWmp5VmZ5a09ydXlLVnNHaUxmREpa?=
 =?utf-8?B?cDM3dENVWXNoTTN4NzZXNXVhYkNRVVljY1Y1Y3J1d0FES3dZaDZ5R3FrRXlq?=
 =?utf-8?B?WHFqZXMvdDBwTmNPREhhelZUSlVVZ05QWmw1NnUwdmtVdmJFNGdiZ2VnUmNI?=
 =?utf-8?B?ZHl1YWMxTDlVdE9zYk9HdDhxTjhmYkYrMVNzcmZlZy94QWtUMFlHa1pEMXll?=
 =?utf-8?Q?Sip22OwBeO4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjdtemJuTWo0Mms2UWJPd0hZeDB4cFAxU2kwbHhSY1dva2M5aW5kazdlWlU2?=
 =?utf-8?B?dEdOVEo0YmNTV2o4ZDZxdVMrYkRnaTVVbVJYczRFaCtEU2dlTWtadk1ZQk56?=
 =?utf-8?B?VXhmczJ1WUNqYXM5alppd09MZHZhMytlcEc5WHNQMG1MdEVwNlQ0TGpMQUxo?=
 =?utf-8?B?Ukh6SmJxWUdIN3dmUmFCSEovZzREM1VxNHRxS29EVnFTTTVNNzJaa3pFaVE3?=
 =?utf-8?B?NHQ0MldYMGJHbGpmcXAyOTRoUWd4T0gvYnEyR2VQbkJmSFc1TG5NOW1Cb0FO?=
 =?utf-8?B?eWhSallZd0NYVWF2bzJoaEVlY3RHTkFCaEFVejBGdXJCZktIMnVyT1ljTzIv?=
 =?utf-8?B?bGM1aTRvNHorQzBaVy8yTDVDMmJNR0thVStlZGVQRVZYYllGRWhkdFhxOG95?=
 =?utf-8?B?ZGozYXk1ZUMyTitKNVRoSEQyUlpkSU02aTVTWE5DUTBZSzVQdEdqWnM4ODZo?=
 =?utf-8?B?WWhMUDNrdVVXVUlYaUhaNnZ6Z1YwZFp1OEpqc0YvRHBiUU1qU0VvQUVPeEcw?=
 =?utf-8?B?ekdEVjFKaEJMamdiOEsySXNKZmNIUjdPM2NuUmk4TVAyS1hEdUgzOGhYOFp6?=
 =?utf-8?B?dVhzZjhrMzk4M3lHZXZNdWpIbHdVcVhyeCt2UFBpaS9CSGx1MkNjWGdjWmRI?=
 =?utf-8?B?ZG5HWi8rRS9mKzZvYTRjQS9NMUo3eWNncGxmbFUwOXRLTjhPcHF6M1dzVml4?=
 =?utf-8?B?K0RJU2JUOGprVDRwalU3WUNhR2c3YkFsK0RpNXpRait0ay9PUC9WNkVISUpl?=
 =?utf-8?B?SngxeHlEcGZPVVFlM0l3UmRXazJENGNLSjV5N1BaaS9NMHl2UFNHSUFDZGIz?=
 =?utf-8?B?QlY0WldsT25RTTZqSXY5TGNuTS8xaS8wM3A1d1lmU2RndUdQeUE4M3VEMSt6?=
 =?utf-8?B?QzJKZytlVk9TWW1LV0pMbmtQNkUrd3E2SkpmNHhhWHZYUWJhK01HRHkzUVB0?=
 =?utf-8?B?UkpJWk5mRXVXeXFkUVBLYXIvUHJ3b2MwSUZqTTcwQWU3ZXBQS0lwSjhJQnlG?=
 =?utf-8?B?SGVEQTkrWTE4VngrZU1BNEg2Tk9EWTltNSsyNWVabmc5aUt3Y1A1anpNdTJ2?=
 =?utf-8?B?aG1CNytPemdGWFFrSVVpTXF6S2FvUlRBVlkvYzFSVDVlaExRN1NVZG5zV2FZ?=
 =?utf-8?B?TmwrNVdJS3c1VzZycVVuczdGZWRvSVFKNXBNQ2RwSVVEN2NoQ1h4V2JQVDEv?=
 =?utf-8?B?TDdqZHRBUVRKb292TWdmakUzWVp2bmlWdlI1bk5SVmRqbG9SVWdCQURMeHNk?=
 =?utf-8?B?NHN2L3c1L2QrUWQ4SkljbTJEMGpkZExpUVE1Sk90QlVVYzBvVDJrNWx0bzJ2?=
 =?utf-8?B?OVdzTDhweWFJM3UxWThpd2VWemN4RHdoY2I3MDdpUmU3S1VSOTZ3SXY1Q0lo?=
 =?utf-8?B?WWUyeUNlZGdYY3g3enNMWlhYVy8xdUNFLzVkM3VrTTZjajdpRHpwNXFJNDMv?=
 =?utf-8?B?Y1N4cGlRUzlFUmlZRU1Fa2EvamNoSVpIRS9ROTA5T1ArYkpKYm9mMHlFeXlr?=
 =?utf-8?B?WElOeUU4dVVSSmx2R1o2R0d5cFU2bmVSY0lUSlJjNmRhSDF3WFVERFpOU3hR?=
 =?utf-8?B?cWpVbDN0cGRlNytJMVk5VHVnZ0txT3d0Zy9GeHpJaVhBeVQzbHRHYXlVSU44?=
 =?utf-8?B?RklONnNOeTUwZjc5b3FPbXdJNzdaeU9CSnNkRDV1RW9ZTm5YNEZKRm81ek0x?=
 =?utf-8?B?WU1NalV2WTJnUTdRbTFYSFhYcWZmeEFldnhJdVlEcGlqTWJRalNJenB6bEg5?=
 =?utf-8?B?d3hVZWt4UFZvU1FGemdPdmZURnpnRWRDWTJad3U0cTE5SFI2OVdabklzK2h0?=
 =?utf-8?B?WVBlL1VrRnl1cVV5WGJhb3lXTEFOU08vdlJPUUxpNTFGMXFKdU96bEhPZDVS?=
 =?utf-8?B?OFNxckI2MytScXJzSVIrZXVmWmJOd0Jmc1hNWjBGbWdxdC9sc1poUXNack03?=
 =?utf-8?B?UkFWdmRYWkwyMEpJOVdCUURmMTA5UzhRRjluL3plVVVQclVLNGh4TUNoam5l?=
 =?utf-8?B?OGVWMjJYMUdMelYzNmVtYkVDVTc4NzJMSjRQdzNjRzJzVzAvL2JIY2hoN2px?=
 =?utf-8?B?TXZXdTR2WEN4UnJqaHo4RHFrVmNBT0E2eFNiUnJab08rUVo2VWNPM0VxM3dz?=
 =?utf-8?Q?YJiEMW73JtOrJTnDJ6jzJdFLH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e71f49ec-ed13-46dc-efc5-08dd7736a4c1
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 07:17:53.7538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZmYa5P21MnWrofRuTdbAvZI9rgbD20z0MGwgsy3EzPm1kFjXtuQR1LknbQADoT98qmq4sdI6GITvxb6PnkVIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6215



On 4/8/2025 10:28 PM, Ackerley Tng wrote:
> Shivank Garg <shivankg@amd.com> writes:
> 
>> Hi Fuad,
>>
>> On 3/18/2025 9:48 PM, Fuad Tabba wrote:
>>> Add support for mmap() and fault() for guest_memfd backed memory
>>> in the host for VMs that support in-place conversion between
>>> shared and private. To that end, this patch adds the ability to
>>> check whether the VM type supports in-place conversion, and only
>>> allows mapping its memory if that's the case.
>>>
>>> Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
>>> indicates that the VM supports shared memory in guest_memfd, or
>>> that the host can create VMs that support shared memory.
>>> Supporting shared memory implies that memory can be mapped when
>>> shared with the host.
>>>
>>> This is controlled by the KVM_GMEM_SHARED_MEM configuration
>>> option.
>>>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>
>> ...
>> ...
>>> +
>>> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>>> +{
>>> +	struct kvm_gmem *gmem = file->private_data;
>>> +
>>> +	if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
>>> +		return -ENODEV;
>>> +
>>> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
>>> +	    (VM_SHARED | VM_MAYSHARE)) {
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	file_accessed(file);
>>
>> As it is not directly visible to userspace, do we need to update the
>> file's access time via file_accessed()?
>>
> 
> Could you explain a little more about this being directly visible to
> userspace?
> 
> IIUC generic_fillattr(), which guest_memfd uses, will fill stat->atime
> from the inode's atime. file_accessed() will update atime and so this
> should be userspace accessible. (Unless I missed something along the way
> that blocks the update)
> 

By visibility to userspace, I meant that guest_memfd is in-memory and not
directly exposed to users as a traditional file would be.

Yes, theoretically atime is accessible to user, but is it actually useful for
guest_memfd, and do users track atime in this context? In my understanding,
this might be an unnecessary unless we want to maintain it for VFS consistency.

My analysis of the call flow:
fstat() -> vfs_fstat() -> vfs_getattr() -> vfs_getattr_nosec() -> kvm_gmem_getattr()
I couldn't find any kernel-side consumers of inode's atime or instances where
it's being used for any internal purposes.

Searching for examples, I found secretmem_mmap() skips file_accessed().


Also as side note, I believe the kvm_gmem_getattr() ops implementation
might be unnecessary here.
Since kvm_gmem_getattr() is simply calling generic_fillattr() without
any special handling, couldn't we just use the default implementation?

int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
                      u32 request_mask, unsigned int query_flags)
{
...
        if (inode->i_op->getattr)
                return inode->i_op->getattr(idmap, path, stat,
                                            request_mask,
                                            query_flags);

        generic_fillattr(idmap, request_mask, inode, stat);
        return 0;
}

I might be missing some context. Please feel free to correct me
if I've misunderstood anything.

Thanks,
Shivank

>>> +	vm_flags_set(vma, VM_DONTDUMP);
>>> +	vma->vm_ops = &kvm_gmem_vm_ops;
>>> +
>>> +	return 0;
>>> +}
>>> +#else
>>> +#define kvm_gmem_mmap NULL
>>> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
>>> +
>>>  static struct file_operations kvm_gmem_fops = {
>>> +	.mmap		= kvm_gmem_mmap,
>>>  	.open		= generic_file_open,
>>>  	.release	= kvm_gmem_release,
>>>  	.fallocate	= kvm_gmem_fallocate,
>>
>> Thanks,
>> Shivank


