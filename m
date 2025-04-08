Return-Path: <kvm+bounces-42930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22AB8A804CF
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 14:12:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CBA91B650B1
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 12:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B0626A1B6;
	Tue,  8 Apr 2025 12:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dQIAneK5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3987C26A0FF;
	Tue,  8 Apr 2025 12:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113879; cv=fail; b=i7E2HNpYlemezJo7F9m4IB/OdunPrPedd2Moj1mrcB9L053mmnj332nV8EzYMDvb8o++I9Vpe30J1JXBKOe+o3/8Te7CoVIdB+zgjaVf3P+nuzzXSYj8qwsjRzu/ELOF/cGPI91QHmTU1l+QuyzLs3UM2UMh4RyLCGJtdvEQHGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113879; c=relaxed/simple;
	bh=sS/7jFDp+XwHZ18jzRtB6pLY4FszWHTo0qRtHUikZ8Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=giWJYZt0RRWhzEitLFcMohwSUILyWLrjmCc2xZ0a8OXKn1Tj3GpaqxTcYpoR5d2nLyCAac/dfUiFrfsmbcu2Uc/j8Uqmkn4XuhP3/6FO9zOWubnMRjMChkpvGNJ7IoZzUYj892K74HWXO7zcaal69g3LMrRMZVUt4mwwsxHUnDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dQIAneK5; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P6e2Qd8YnxyAZpE1F1n+kTYc4JCPQOArxigvV1zZSxliyP0UcSEn8xG9kwrKbGMIBzy8dGoDJSC3GeUVPrkBlMoqjpNIPtfpuOq8T+TTk23bFDsmx8QQSuTvdugwOodTRSJdXYHiAoQJgwZ4r1/b2//gSuRu0+vSovt8sovMqW5tOGj7ikIQqr0ofJ1mKFKu+ovMl23zznGa3m8ctXjAkl0yuPrTG3w6+fZ76A4I8BNMUVn4+7v145B2pddmyjwNlN6s/eQF2lF4U8MmxYDKmMWUlgqAUFLNiGBRf6AaG5wZpfkXis7o/DsajdHA0pj4Ds0rmAbsOf4rRePOVJH2EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyG7EaYy69nvp0JIo6K1IlgwMrb+lSrukslBRJRPb2w=;
 b=CoQ0O1JalVzL1WGRmxjhdm5yjeykJfrP9L2WzPX4B5dUxTSAg4LEcYP9svXnY7M+KpRsQfaYg6QPC8oBUIN7+fAHAdSwUCf4yXrutoZNgiTf8YLxebnh9zBRaFBVVvsRtDeuLuMX8KkrD32yBY4Basz2aDUGtFQhF+TswBqYxMQM38uHUyB2kxgFJDiGwXzEOLEkmeu3S78RWwHEuVDg4etM5906Gf2ptFxauvmyyjuc6bh53YPodiHVDD57BincgjGSDxVzmWNFVhkh+qbM+5LqvJm5ltMiXybQkye9gkHE49tKavR/sbMWc4cY4fw+1Ab8I86hB0+fpYgErYZL2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyG7EaYy69nvp0JIo6K1IlgwMrb+lSrukslBRJRPb2w=;
 b=dQIAneK5gi6aajzGRVS9Ptw/JLiBTY0WOkuKCtc8pYm8Gc8Hl8N81iepD/EuEf1JE7uBPQZqK8vKN5smxKpNYJ+uLEQi8ImETzUcoD1qyKd6QIhNZp/dzlfPA6JLiIF6pmhLSCila67W4sIkHA9H9XtcfGVdAzRMxv6sq2IMulE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by DM4PR12MB6136.namprd12.prod.outlook.com (2603:10b6:8:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.46; Tue, 8 Apr
 2025 12:04:34 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%4]) with mapi id 15.20.8606.033; Tue, 8 Apr 2025
 12:04:34 +0000
Message-ID: <aeed695d-043d-45f6-99f3-e41f4a698963@amd.com>
Date: Tue, 8 Apr 2025 17:34:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/9] KVM: guest_memfd: Allow host to map guest_memfd()
 pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com
References: <20250318161823.4005529-1-tabba@google.com>
 <20250318161823.4005529-4-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250318161823.4005529-4-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::9) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|DM4PR12MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: 560c49f3-81dd-421b-61f1-08dd7695864d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tml3b0tXRlpvQldkd2kySzRLMnI4NmRFOE9LNnJNYmNYZDFSZXhaQit2QXY5?=
 =?utf-8?B?T3lVN0xBdSsxL3Z2VUZJT2RUbnYwYTRDZ2NJWUpXamwwbjBXL2g3blI2emFv?=
 =?utf-8?B?OWU2bEZ6T1A0MSt6MFI4RVhyYVoxVHhjbm1EUVE0ZjhQZjZuY3l0WEw5b2xN?=
 =?utf-8?B?eTVpaUtPc09JQWxZT1hDRG9sMDQzTmxTYytLWDBiejBEM2ViT3lHWkxjWS9B?=
 =?utf-8?B?YkJWWEhnMmFzbStyK1ROYU9lcFJzVjRNcnVxM1k1VHhCK0hNbXRiVXlkbHND?=
 =?utf-8?B?ZVlVL3diVzZxOHlIelY2aGYyeGRza2s0WUU5Q3RQTUJ1UWNjaXd5Q01hTWpF?=
 =?utf-8?B?RmRnbUJGV1Exc09qKzZVS2QzRElQMkVUbTl1UjJseERuYWxvQTFJOHQ5a2t0?=
 =?utf-8?B?WjRIeXNMODVJTHQxK2xodHJBVXA3ZEc1amRuVEl6TlJKdTF6NWNPdHJQeElK?=
 =?utf-8?B?cWU5WWJSWjNCUGlkZ1RTTlViNDIyMVVjSkNxMmxwSU55b3RzVk45QzV6L01t?=
 =?utf-8?B?THQ0WC9qTzEzYkdId0RaRzgvaWo5b1ZhbzQvSDQyV3BMRStYUlFSNUk0ZDJT?=
 =?utf-8?B?VkVMUXBYRGxReEpSR3lONHZJcUdtUlMweFJrdzR5aG5TemdZR1JKQUxGbWZZ?=
 =?utf-8?B?QzNvZU9nT05MQVE0eUhqMEQ2SGF5WlVhQ1hLaDlMVkVBdWpqWklWQThST0JP?=
 =?utf-8?B?Z2tnWFM5N29MdVkvSTFuMWFNMm5wVnhHYWNwMjgydFcyLzUzNFJpSlk5MFEx?=
 =?utf-8?B?OG1mc1E5U25nZ0ZuemFYWjhSZExNZTNKYnlxWWM2ZkhzeGNnUllBQWxyL2Mw?=
 =?utf-8?B?Y29DMWZDOE9ZZXZsMndOeEZQKzVBcTZmSVBpL3hRNXBZMjI4RVNERHg1VldN?=
 =?utf-8?B?aWgzM3ZxTnpwVHhsR2JDRDgyQm5Qb1dIVTVoVmYyRkFLcXMrcGhMTVhxNDFR?=
 =?utf-8?B?SVlHOTg0aWdUU1ZZRUVVN05vMnJyTjMrQlQyaldLTlE0YmxITU5JaWFjZFow?=
 =?utf-8?B?VUdxN1BPSW41dTkzeUtKUVdHRGlJMTVWYVpQYmNVM1ZVOXR5cnpDOFpMbVN6?=
 =?utf-8?B?OFdYZjNiTzhFUmUyQU91YXJEbERkeTV2dXBNVlBJZkpxZXhJQWRuQUh5MVJQ?=
 =?utf-8?B?MnF6V0VXNGEvZmZmbjRLNGlLcE1NMUJrcmJvVURFQXZSRHpTUXcvVjUwc2Ir?=
 =?utf-8?B?NW5TNnBaSjFyRHg1VTcwOFluNWhKcUhrcmI3TDAvdXFjV3JodENneEN0V3lW?=
 =?utf-8?B?cWcwdCthNmVoN2tqQkJvYnp5NUZqc0RGUHF1MkJKeDBSanUyTkE3Rk9FTjND?=
 =?utf-8?B?K2lGdTRQUUJuenN0Q3BGdEI2Q2JVZTI2MUlnOEVRYjEveG0yZ1YzRk1UNFlk?=
 =?utf-8?B?QlRaeUFEVngxZHRuTmhXajZ4S25YZ0NLQjc3Yk5BVG5vekVSZWJKME9mMEZF?=
 =?utf-8?B?aFhIK3NZVUdTbVZNeEVhSXNrbEZCRnc4MVY5NWVoMEF2VVpGSjJOL1RhdTFH?=
 =?utf-8?B?bkpodU40UzYwaEhsTVFpT20va3NONmFWODlqTjh6R0RQSkxDYmMxY0NZd2xO?=
 =?utf-8?B?ZUh6a0gveGNReWluT00wcTlGU1lvZDZGSXpEZDVPUjgvaTE3b2lOU21NRysr?=
 =?utf-8?B?K3prSS8zdnNOMkJTbDZILy9pdnAybjJWYzl6UlZlVkZXMFNpT2U1Y2luWUtm?=
 =?utf-8?B?bGVYYU1RY1J2R1drai9PNXZteGtIZE9PN3lWYUd0U2t3MFlheVlvVHZJUXVM?=
 =?utf-8?B?T3p5N3JPNlZIZHhZMDZjM0dVcU1YY2R0dlk0eHd2T2VFTmxYRVN2am1iU3Ns?=
 =?utf-8?B?L2VVZ0c3OGxRZ001Y2R4VHZhTTNzU2htamh6R2Fyckl4ODhiTU5DLzByWGFZ?=
 =?utf-8?B?RHA2QVZCamlvNVNKYThxM1RUVTdocVM3Mi9sM3YvODhlTGZMY05qaWtwdVJh?=
 =?utf-8?Q?dx/+PAO8phw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFVlN2hyMGpCSGJZUklXa0owU09xM2VGbVVySldjaEsxMUJ4L1plNlVZUmI2?=
 =?utf-8?B?L1NFb3NGWkFBSGlkRzJCVUJyb0RLeEovWitwRnZIc2x6SVZMQ2dBcUpRSXBa?=
 =?utf-8?B?eE1waHJKVXlrRG9qdUx5bW9ucDAxUUpjYWhQckZYNkNxZVk2SmtyNmRFNDN3?=
 =?utf-8?B?MUdFYldMVW9yZ3BuY0hhdzY1OTRnRDlXZnNtTmFYM1RvR3EzOENOYktKUXUy?=
 =?utf-8?B?Y21PY3ZENXk4RW91QXc0V0tiYmRrN2xpak9PSU9HNGgrNFp5cmhNc1dta2tk?=
 =?utf-8?B?S1Aya21TMHJ6MEVuc2FPWHBWeVpUejVMMWZXZXNIenMvVTNENXF4SS9yN0dS?=
 =?utf-8?B?T25BUEl4V1N1QW8xVmhuWUZpa1hKbi8vSFdtSG83M1BkRW9iUGt0RUhsRkhz?=
 =?utf-8?B?Y0pDNmdobTBQV3F3WmhsZEZTb0Jmam5rUUREcEljajFZcW1FbGVyanJiY3hh?=
 =?utf-8?B?NnBDOVQ2RlJjblBkLzlteWNRTGVTY1BMZjlMbHkzUmtVZzIwL1FrVzFEbVht?=
 =?utf-8?B?YzdSeHd4WW9vbGlKOUlxRTNpelFwSWNyUGJHWjlxK3FQcjExVEU1alllV1Zx?=
 =?utf-8?B?cjRIVXgvL09KS01oMDQxL1lYN0VTc0dvSDNkbWtBMTlVVk9aOE1XQ3VQa3ht?=
 =?utf-8?B?THNnTDJtWW5leFVWejBQUlRIWTZmYmNDc09WOXY5amh0QUdVRHloYmVhK1pD?=
 =?utf-8?B?RWJYNEJuaExKMHRhcXBUWXgwU2FNL3ZZbnJpSVNpSnd0aVdkckphYjV0Q0h2?=
 =?utf-8?B?bnRmdWNvZjZieEMxSDFJd3pqU0wwN1RJaGl4Y0pJeFFKTngzLy9sWGlVeDR3?=
 =?utf-8?B?NU5kZG9YN1ZhanVsWktVeGM4RThXTkxWYkZMK1ZYdmNrbngzUU5uaWQrQk55?=
 =?utf-8?B?T3c4TGtTNXZkaXVnenBEVUZIeU1NOXQ5WlJtb1hPMGQ1NEoyQW5PdVczczc0?=
 =?utf-8?B?VFBhTzJ5SlhHY3A0OFZ5UFhPSnBkUWVnVDFMdFF4V3RZUkJVWlRnNmliSm41?=
 =?utf-8?B?amRSOU9CeGZqRjZ6Zlh1d0lSMTJSaEp3Q3RZeGVuaDZZT212dW1TZkFRWUI4?=
 =?utf-8?B?ZHFGemlrdko0dC8wUkthMk4rSUNPY0NNaTcrdkxONlVsajVnaTRNUGFLakQ1?=
 =?utf-8?B?UGhBVTR4bXNsTVNvZzV2c0RnVVYzUFNaL0lpRHBod0p1NG9uZmZNMEROL3lB?=
 =?utf-8?B?b2F1RXBpRm9uZ0ZyMzd6ZG1vZ2JLTDRNV21LeldlR25lZlNaSU5IVG55RERX?=
 =?utf-8?B?NStzc0ZOZ0prVDJXVzJkTVc2UkJna1R6NnlBUHl0eWY4ajZ1MU9NUTNxMWFV?=
 =?utf-8?B?ZVB3SXVjdG5QRW95d3JES2NDTlh1VFQvQTZWRmFNUCtKWmMyL0duemwyV3Ez?=
 =?utf-8?B?THJUd25aV0JtejNtSDFxb25TYzZ4SlAxbHZCRzJaai8yanhqL3lYZjI5Y3la?=
 =?utf-8?B?aGcvbDRDOEcyVW8yV3NTWlZOVWdzMWFTM3l5d2ZhekNOR3doencvME9pSzR3?=
 =?utf-8?B?WjQvbDJsZmpHUk12Qm1pRmcrcHhFc0diTEthK1I4em9Kdm56RDMwOVRWZGFU?=
 =?utf-8?B?TkVDK255SjV2ajdSSk9XaXNTb1VJMHVackMwYVJtT3FoekxOZEM2ZXc5NnFP?=
 =?utf-8?B?SVBONnJ0RitIUEJuaDMxT1kvY090ZkxpWUlHbEZuN3YrN0FkZ3BpYUorK3V4?=
 =?utf-8?B?WnNoSUtwRlJzbWMwSFRFUlFhOHh1QTZTQUNzOEJkNGVjc3V2a1lFRTJheUdn?=
 =?utf-8?B?ZG5HUGVpOCticHZBNnV4QUJpUWV4cHp4bHlka0o3VUl0dlNVZXJXTHc4ZHk1?=
 =?utf-8?B?dzBLRk1BMk5FbEkzYjdobXVYZVp3bTFNUE5uNFhNM3RNWVVKYUtQSDNMTUNG?=
 =?utf-8?B?Zy9uZmZYODNtclZmQWxVOFpTUmxPUTIwdFlKZXExcnl3TnZNeml2MFN3OWJV?=
 =?utf-8?B?WDhOYzVRY25SUWt4eG5EQklsdWNTQzVEeHM0MTZOL0JVcWczdHhJaG5UdmRq?=
 =?utf-8?B?QmpuL2ZqWlE5Z05ySFdLYU9PRUNkdnF6d0FvV2J1WkdZMEtRZkh0WTBsMzdw?=
 =?utf-8?B?RFlhMGtyNnZIVXN4TDFiK3U2S09LcSthdFBLa3Y2dE01MzJCaENWYXZtZVBT?=
 =?utf-8?Q?8fUQA/K0+nGxl3NWRHDFxuWpM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560c49f3-81dd-421b-61f1-08dd7695864d
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 12:04:34.0687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQRZbiJNXePVD57N1ZZdeI/HUEjBV8DlRWpUTQWehJm4SUvUxgzR1kKHUmywTxzaeePnLMG1LkSni2BXaw7HVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6136

Hi Fuad,

On 3/18/2025 9:48 PM, Fuad Tabba wrote:
> Add support for mmap() and fault() for guest_memfd backed memory
> in the host for VMs that support in-place conversion between
> shared and private. To that end, this patch adds the ability to
> check whether the VM type supports in-place conversion, and only
> allows mapping its memory if that's the case.
> 
> Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> indicates that the VM supports shared memory in guest_memfd, or
> that the host can create VMs that support shared memory.
> Supporting shared memory implies that memory can be mapped when
> shared with the host.
> 
> This is controlled by the KVM_GMEM_SHARED_MEM configuration
> option.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

...
...
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct kvm_gmem *gmem = file->private_data;
> +
> +	if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
> +		return -ENODEV;
> +
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {
> +		return -EINVAL;
> +	}
> +
> +	file_accessed(file);

As it is not directly visible to userspace, do we need to update the
file's access time via file_accessed()?

> +	vm_flags_set(vma, VM_DONTDUMP);
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +#else
> +#define kvm_gmem_mmap NULL
> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> +
>  static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,

Thanks,
Shivank

