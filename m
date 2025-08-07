Return-Path: <kvm+bounces-54223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF3CB1D41D
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 10:13:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E874F162FAE
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 08:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1566F22068D;
	Thu,  7 Aug 2025 08:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b8KgzNAU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49F21442F4;
	Thu,  7 Aug 2025 08:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754554385; cv=fail; b=Gcs+GFGMyBjr6RelxrH00zDMotrbJYFOSFLOJ2wMH/dC4QuB/pTWQig2DnyPSfChX5Ssxk4RpUJhvF69vZgrN0aKkhoUUxnCoP9cppOqYjohnAIDlAwFzaeKtmRrqlc5ZUY4N74+sZ195ex326eKzW8mMQwRIner/jfcBlTE5MQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754554385; c=relaxed/simple;
	bh=zpDflRvzWxHsQmhRxujAWpx012VSt0SJqEL0c9iB7O8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sB5s4kwfw41znPFo2h6JfbQVBCXQHHUBHyKzH+kpDPL9K0mtOzjBxlVpKuJkqmo6X+Up97slLmzW7ldGOK2J8Dn2FqrmMCwTuMSCBFw4Nl2aKWV3I+AIl0G2COtFGZtq5/WEKXCtApKF0H479VfH9H8H5lknfE8xg+K8/Hg5dmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b8KgzNAU; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPl8wB9yccg1RtFsoLW4l45C1ozSg7Bj81HoN00fcTb6+w6RuTXGrjBuWCEf7o69o/p7vBoWKxTC1zMOD7lXSzNKp55ASKxqv4TVicxg5THyoS26ETGp7O/8z5HT+8dZreHSpoMlEaFfMJEuw88OdmnT3b7UPDt8+gRt06Efwa6UfIISRq/HeqUPnTrjiWQCvtH1k46E2wLsqKjwlpyDVZ1yIo5PAcceY9fogIb26Uwg8UoI4/emAYTMAJEQLOzr3dVi233RI3v/3CkApN1IuA41r5od8mXRFPeEG8ewhjdBBBgbY0WSS6dLpuw059eYrhf0glpHY9pD4DkFpFeE4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56nwS/xxtMxuKuiAXybOsWkWrH4FQboSZTGGzWFLgTY=;
 b=ky/w2iLXXbilw4BbuQ7A4h1MVy7gyoRRpdykj/zhkMPkG5IVis8z6k4vSX2r+fGM8lR4t5gWVq5DB/98+fX8YEbc2FLNHB1yUIjzyUWb1tFSLbZMDWk7T+ycaAABbzMj0OIDN9GeL6hl+ORNGDjFkE98kfZkLmbtovKllGIfP3ZehOdCMP8atHegTcQumF235JpCljUkWzgfmkQ380IQT1gJA+qkt7zfw/HMwyKFbtFKrtOXEVXAacI3eYox0RP8XURGaCfx78FWF95exTl3X5JZ6r0qJv4H6sixJKjN95oCawYeTCznBMICX7/TskwWxskePq6SeYKJkBqVDd9eiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56nwS/xxtMxuKuiAXybOsWkWrH4FQboSZTGGzWFLgTY=;
 b=b8KgzNAUQMS5JGU34P39qChGu1eTtUViAusUHVYMjFqxiaqTKpB4NSSrJC38MfqOYtrfrtVFxaNI5dhLruxRSZMdRW+4i5vYLz6MQyWPzXm5AIB/oGg4Kw3ePKFywMNmS7V3LGrgXRFg2keAG2UyFVo0FJDGisSvbjp+OwBHAb8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 (2603:10b6:a0f:fc02::9aa) by PH7PR12MB9222.namprd12.prod.outlook.com
 (2603:10b6:510:2ef::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Thu, 7 Aug
 2025 08:12:59 +0000
Received: from SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 ([fe80::40bb:ae48:4c30:c3bf]) by SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 ([fe80::40bb:ae48:4c30:c3bf%8]) with mapi id 15.20.8722.031; Thu, 7 Aug 2025
 08:12:59 +0000
Message-ID: <aafe6087-bf26-4ab6-8ed7-823c366c9650@amd.com>
Date: Thu, 7 Aug 2025 13:42:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 23/24] KVM: selftests: guest_memfd mmap() test when
 mmap is supported
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
 Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>,
 James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-24-seanjc@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250729225455.670324-24-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0024.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::25) To SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 (2603:10b6:a0f:fc02::9aa)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPFF6E64BC2C:EE_|PH7PR12MB9222:EE_
X-MS-Office365-Filtering-Correlation-Id: b1670a81-2480-4962-26d9-08ddd58a384d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NTZCcno3blNjM3NLNzQzWG8yME1kam0xWWhvbWViRUZDOWN4bjlPaEh4RHFP?=
 =?utf-8?B?TERMSG9LdmZuSXFNYkNkTG8xdG84ajVDTDBwd0ZiSFUrNVlZVjZTS2dnb1BU?=
 =?utf-8?B?TUdsWFhGU3JvWUI3bGFrMEhBaldxajFMSklPL1FRcmR1eEJsQWh3bFc5TU1S?=
 =?utf-8?B?bjJ2Y084OVNhOEhEVC9ZVWlkTUhzblhPWTNxbDlyZHFJS0s1UkZDOFUyb2h2?=
 =?utf-8?B?aFRpVk55dERaZjliRkJSbE1iYytuUnhzS2RkMTkxdU1DcFdlTjlGRXdvcDR3?=
 =?utf-8?B?ZEViVEFMc2ErZmZtMDdzejcrVnZ5bHVtcXJhWGkyNHVlamVWczl0b2lEQVNE?=
 =?utf-8?B?ejN1c2doWTNwbTN5SG12YTcvVmU1Rm45L0MvNTlYOUwrV1ZFemJLSjhURFFU?=
 =?utf-8?B?MXZsSkpsLzB1cnN4d0NRWFFWN0V2Si8ycFdzTFlZWVY1ZDhGTUFHaVM4Unhr?=
 =?utf-8?B?UGticlJyYi9MTlJmYXlXb2tUTjl0eTE5V0F0OHd6M1U1bGc1TTdhOCtKZUds?=
 =?utf-8?B?RndyeXVZY1k0bjl6TC9lb0x5ZnZHRVhGSjBqMm5pVWptM3FDS1NadG13cERk?=
 =?utf-8?B?eWJKdG1GcXczWUhEWTNGT09LOVhOZHhwaVBHanJpVXhIOUt2R2szTk5vRzMw?=
 =?utf-8?B?K3hQTlA1elI4bzMrOGNDTHc0L3F1ZmJhU2VZc09wYkRiUHZONk5CUWNQVE56?=
 =?utf-8?B?UXczTzZWRituOEROZTZRMngrNGlSa05yeEtzOW9jM3ZNOE5vZW9ObUxHTVc4?=
 =?utf-8?B?ZlFxL2RYanZzaWtEZHdnOFpLSXJoQkJJTC9QcTdHUmN6UG9IYlU4Y3l4d3Va?=
 =?utf-8?B?M0hGVjhLcjljYmowc1RVYm14S1l0dFlHTnVFSW9Sc3RmMXY1bjBrVkVWdXZ6?=
 =?utf-8?B?aWZGZXBxYVFGa1k4RWFQWUp1bjJqckN3UWpQblI2bmg3bUN1NkhrZXRITGpE?=
 =?utf-8?B?Qkh6Y3U2WFhkTUMyVnBBZEVhNHpaMmd3TGJzam1MRzIxakIvOGlMU0h4Qy9S?=
 =?utf-8?B?SmdPWHQ0M1o2VDRuY1h1VFBKQXZ0U01HYVZ6R3VRQXRaa3l2a2pGU2I1dGlq?=
 =?utf-8?B?MkZYN0RCejVSelYzTzNBUzFXaGVIRkFwY29SYzBFMEh3L1RGclRrOTVJVHFP?=
 =?utf-8?B?THVtQ1BtZitHTWIrZnNtdFVUS0FCYzU2ZHd3a2hvejZqTVh5N1V3NzdEZGIx?=
 =?utf-8?B?Y2xxN2tucFJHZVVMOVpqajRqRkY1bCszdUV5RkFtQnZsREp3UXBUM1pGYUJV?=
 =?utf-8?B?a1c2K1JQa1c4UVFvS04yN1VoNzVxSUtrdWJwVXcrY3g4MlgzbStDQUNSU3l5?=
 =?utf-8?B?eE5kYzhrZXJZUTc5NkJjNHlHSFVxMXluM2NFZTZrcDRHdnpVK2dENEtPV3NC?=
 =?utf-8?B?MUN6bzZwRkdEclhBWlo4YUFJM3pZdjI2dHZQT3QyR294VzJHMzRHZEczd2Zp?=
 =?utf-8?B?T1lsV3pNUnZ1V2FTOUx1Y0FEUDc4TmVUZmZka3R4VUE1bFZwZ2g1VjJPVnEy?=
 =?utf-8?B?WGRoRkVTdzEraXpPaDNXVlpLMWV1Y0ZQdTVUK2Y4SjFHV3VmVElHdDBzSWln?=
 =?utf-8?B?Q0hVNmgxSUdVWU85VGR3RVIrRnp3SUtnSEthUGxDa2VqYnN6L2JxNXhqVHhV?=
 =?utf-8?B?U3o3aldFNEdlc1NBM3VLd2phOU5MMnllV1lGS1IrNVFqZytwTTZNLzRXU2Jp?=
 =?utf-8?B?OVZ2djBvekxLekFIa2RmeVY5VTk5ZFlOa2loUk1tQWxTRFhneE5NejhOQWJz?=
 =?utf-8?B?RW90OEtaUjlxNklmdzhpSWErTWY1WFpieFhUVnJZZi9ZQVB5OXJuK1gwVWJn?=
 =?utf-8?B?c2VUZDlTRmlxOENLSThVdFlBSUFidXp4UDRINzNUUnI4cGtHTTdwSnp2OFJ5?=
 =?utf-8?B?QVc0ZzYzSjFjS0FpQVdxeHNPVzVIMmlJR3I1d0JoUjhHT0M2eVNDTkYzRGx4?=
 =?utf-8?Q?XYIwRmXwyBE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPFF6E64BC2C.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0RkQmhNNEVaQUlKSlRCZkczTXhaNG5VR2xBTGlqVmN0bWVSdG1HVmcrK0wr?=
 =?utf-8?B?MlpvSTJmRFAveFVEekc4V0c2UkxYa01JZ1FrNEsvbkE0ZjJ5UFdJc2VkVEVC?=
 =?utf-8?B?eWpmM3BLdG5uQ0R3dEErTzB6NUxIWUI4SVFxTVdWNXJuL25UbFNkYy8xZTNy?=
 =?utf-8?B?VlhmQkVvS2NTR0d1ZVVaTmhvMlRBbm1kbWRyV1MyTWJNT0pFZEVlVGVXNzkv?=
 =?utf-8?B?MmpkWDltUlZLTUFBWHNFU0NneW5weU05L0VnQVY1MUh3SmlHNzZzQW9XVUln?=
 =?utf-8?B?OHVsamRrQ2krbWZuS3RIcmphNlFRbmhNS0R1RDd5aUNwVWozYUlHVVVZV25q?=
 =?utf-8?B?bFozMUZneUE1VzdkYkkva3FOMVJPYWh6NncxVUpyYW1IaE0vTnkxaEdHWFZB?=
 =?utf-8?B?NGVicnByL1VPL3U4MWtWVlI5VmFHTlNhYXJSWGRpMWV6NHNDMGE2TEJXVERt?=
 =?utf-8?B?KzNsYXMvRWIrUjErb0kwaTh6YktNaklRcDc3MWwwSmd3WXdhcUcrVUhMZ0JP?=
 =?utf-8?B?VjVnWWttQ04va0ppeExOQStVRFhQN0FTYjVzcitubmROL0ZXOWwzUkhwVWNS?=
 =?utf-8?B?bDRqejYvMkZPSXRKL1dyUFQyOWE1T2pUWklNcTUyV0I5VjdOZVlBaWppdWdx?=
 =?utf-8?B?ZDdnbzkrcXhEbnhnZC9tdnU2b1lwM1VKTXd2NzZCUGdoT2g4T3psMTYxS2hr?=
 =?utf-8?B?Z1RMVDN2UUtSTkYwS3lZN1ZWeHZQZlNQVFkyb1RyOWxVZ211c1FFcjN6aCs1?=
 =?utf-8?B?aUJIdmJscjNscmljQVJtQ0ZPSTdTdVpIU2NmRVp5K1FlM1VJZDVtVDR0d3ZO?=
 =?utf-8?B?NENFRTNSeXB4Y3ZPeG9jakpUd2h2MVA2MW1DSTVYVXR2eXY1aHA2QTdhR3Nr?=
 =?utf-8?B?WkFFL1RWbFYyci9jS2NuemptQXVINjJDd2FORi9Wc2pjR1p3SVBiZURQNHZx?=
 =?utf-8?B?bytBb0V6V3F0U09VVU1OUW5oWHkxdzBIU3pVMVRWSG04ZExhUStxRjV3WnFu?=
 =?utf-8?B?QUh1RkRTNENSUTdaRllhb0JWK2NQczcraTVGU01lY3BFY21ncnVGNFFNcG1v?=
 =?utf-8?B?WlNiMGFXNDRqenBpV0VYZUFKWTFFV1ltVng1ZTlnYWptWVg2c1pkQUVHM1RQ?=
 =?utf-8?B?MzlaT0lYUUZxV2JCUm1LN3pxWjM3anpvOUNKYXVwdjBVRHYxNHNFTEo0YTVT?=
 =?utf-8?B?eU5HaGJjbkZEbkFSTVZCaG5lMUJIak8xS0pXOEVaUUZlcCs2NGJOMzRCWFVj?=
 =?utf-8?B?ak5qMUxlSmltRWwyUWpjTldad29XMTd3T3lQVkl4S29OQUp4ck9zYkIzN0cr?=
 =?utf-8?B?NTZ0aEUvcE9temlJS3F5c3cvRGd3OTZmQVBlbW94Z0lHM2RVZDJLaEVPSnZ6?=
 =?utf-8?B?M3VwUGJKd3JvbFM1ZHQ0K3Y2SU9SUllLVWdib05EMlduN3ZRZnY3bStjN1Q3?=
 =?utf-8?B?aTVSbkhuVzhGOXA3RHVmMmhhTnRRbUc1WWh6d1pVMmY5TnpRaXEwVWIvZDhy?=
 =?utf-8?B?ZHBPcXZTRWRNNDA4Vi9wN1FuTk9FU0FNeXZHWThaaElEa3I4c1FnMWs2QWNT?=
 =?utf-8?B?V3BBYWFzdGVHRVFaQ2tydWlwT0ZKY2ZFSXFKR0IwYzN6ZkZwc3JLQzcwLzBq?=
 =?utf-8?B?NjZHeUdic2gvTDQ3cFE3WXB5bHZPbzlmWnlCdDg0MG54ak11ZnBKdFZxalRZ?=
 =?utf-8?B?QWN0TW5pY0lVN2JLT21ua005aC9mY1lhMkM2aEpLR0VhUzZxNTZ0OTdoR2lo?=
 =?utf-8?B?NmlhTmJoZ0M1dVZaaFJFVEJ2TXdGenA4NFY0U2pYTHVtNmxwcGRpenBGbEY0?=
 =?utf-8?B?K3VzT2RtcXJaZkZhdWlWTlpxc2hhc0JiYmtHbjE5dXEyVGZITHdHakM0d0xE?=
 =?utf-8?B?UExsWTM0d0tZRnNYK0IyRmNOOGE2WU12eGR0cHAwR0VNYnZoQjJ4TUFJSEdM?=
 =?utf-8?B?TW5QL0o0VGs4UjJTMFFEZi9SM29qSlhGWTJybTIrTEpseStFeGUvclVhQk5M?=
 =?utf-8?B?Y0ZpRVpvYUZNankvMnpCSXRxK0NFTzBUbS9TRVRjQ2NQOWJGaFZDTkswNVk3?=
 =?utf-8?B?YnhpNFN2SVR0bHVTMUdFa21mYkZiWERBNUxqZ0lBMEZHem9RbmdORXo0dkxi?=
 =?utf-8?Q?zcyIBNaYnaosRYczALmtQfcUR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1670a81-2480-4962-26d9-08ddd58a384d
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 08:12:59.1112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jj6625eOJL1EmaT+Ob4a6vl95Jh5uJdw/0aeWn8E4x0TA82RSjtTiouNZ1omsgdmT8VpjPpm+oG8gus/QXDTrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9222



On 7/30/2025 4:24 AM, Sean Christopherson wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Expand the guest_memfd selftests to comprehensively test host userspace
> mmap functionality for guest_memfd-backed memory when supported by the
> VM type.
> 
> Introduce new test cases to verify the following:
> 
> * Successful mmap operations: Ensure that MAP_SHARED mappings succeed
>   when guest_memfd mmap is enabled.
> 
> * Data integrity: Validate that data written to the mmap'd region is
>   correctly persistent and readable.
> 
> * fallocate interaction: Test that fallocate(FALLOC_FL_PUNCH_HOLE)
>   correctly zeros out mapped pages.
> 
> * Out-of-bounds access: Verify that accessing memory beyond the
>   guest_memfd's size correctly triggers a SIGBUS signal.
> 
> * Unsupported mmap: Confirm that mmap attempts fail as expected when
>   guest_memfd mmap support is not enabled for the specific guest_memfd
>   instance or VM type.
> 
> * Flag validity: Introduce test_vm_type_gmem_flag_validity() to
>   systematically test that only allowed guest_memfd creation flags are
>   accepted for different VM types (e.g., GUEST_MEMFD_FLAG_MMAP for
>   default VMs, no flags for CoCo VMs).
> 
> The existing tests for guest_memfd creation (multiple instances, invalid
> sizes), file read/write, file size, and invalid punch hole operations
> are integrated into the new test_with_type() framework to allow testing
> across different VM types.
> 
> Cc: James Houghton <jthoughton@google.com>
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: Shivank Garg <shivankg@amd.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 161 +++++++++++++++---
>  1 file changed, 139 insertions(+), 22 deletions(-)
> 

Reviewed-by: Shivank Garg <shivankg@amd.com>

