Return-Path: <kvm+bounces-58576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB98B96D61
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:32:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16923162CB4
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D37D327A36;
	Tue, 23 Sep 2025 16:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r0QC28qk"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012032.outbound.protection.outlook.com [52.101.43.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C87327A22;
	Tue, 23 Sep 2025 16:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758645158; cv=fail; b=C3xrR3X/lbIqfCeb1MOzl7TLYBtWFh1T3jEXbd1k0HdBMmuS+T9HcaZofltA7kXqis9GwXDybgXa/iCeCIoViJNEoz7S9HbQjUgTnGrX/oCHQZjR2buA6J+X1rUWamlBN/lhkSwiHuf4Sqiw3obAt7gjmf9ft8kxXV+FpyQSDuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758645158; c=relaxed/simple;
	bh=DFGKS6hPswIhAPieUQCw9LIPEk9H3eycdWMPvvECxhY=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=ZVqx0ARmZUtjyvZqlfKIpaOL+3quW2AfJN1SpKsATumZBHu2Xw0PM2Fyf6xpQRMIjTGNeFREVvy6AV6T5py9eJdEFUVyimEaZnoZmh8F7l9qhxLqVfrdKH3ZZzN9LGBrTODhhsYZWIddft6TX0HFyGJDoFvjK30Nc7Z5S+BSAUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r0QC28qk; arc=fail smtp.client-ip=52.101.43.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IfOP+9FER8s9g9d9o2g6KPFjXnEWnzGdICIsKd1n6FrQkf+et40ESYRxd/BgT8R3TFLXveSZsfID4QCpnydwJ1SBz19AKVCqeG3BjM4z+Hbwt9w0lq6fZsE0soyGGsBQoL83MPQG3hvjnjTRG07r0WXcRsw8UC8s173DPK8Q6ACATdi3kU65poB+73hQ7RT3brKIOwoz8Jtalg94FBrBs16veGoM63bToxOTxgqiqjwFegfz4MfqzTSbFVVN91nB1IqOb6KXRejN3QtJXtA8MohzYXgee7gIA4hj7oCpbusi2ACP8q4EzQyXaG7PO9GIPGGkhkjmKJTEQG4iQiobLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywdnhuxb7B+5tDyG6tPQuKTat/VBdIu/qFh7wdpYCUM=;
 b=nJkaDYKlPHCavulU9SNq+6uNNKSQ0uOi3SWIb9/KkeTiZ3JWndGao7V0oDtB2Wy0KeHfMrrhrZiHyF4pLo2bz9soAyhTPhGriTZqS4CSvZp0gnV1NlJ+aFl29g04emd1c8zXetdHv4bgzqtNpW934pUkp6MLIBy7/soIBG7XxpBmPAKeDIU/7HY4YchtBUspVjTqL58i8mtPdvVfyVEjebjzzJxHDqtVwRoyN1VDDvG85ucHreNcX0Cp8TExihTy/BPh0gCc/GHGp/gBBX3yaMLEc/lfsVpmiKz50jh2VxOp+aqFwv4rduwCSNThG6r5li2jsRxptqoxKVQTFgky1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywdnhuxb7B+5tDyG6tPQuKTat/VBdIu/qFh7wdpYCUM=;
 b=r0QC28qkrkW/J+bGN8UBvV9gA0Pui2RaQCXD3yo1nOlxw8lnYEDj0z/1tc2Ob+0Mr/dH3yl7uDq4oggXqtIXPtKJybn2u25PyiNEGvg19hu/41r+/yJavxSKfblvvF4i70iGh+zvRDOF5fsu0yeSt6oYWR3LCJ8HnfG9U8NwcP8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB6977.namprd12.prod.outlook.com (2603:10b6:510:1b7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 16:32:33 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 16:32:33 +0000
Message-ID: <d2f7ae16-6326-3f62-ac0b-c83b68decc1a@amd.com>
Date: Tue, 23 Sep 2025 11:32:30 -0500
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
 <20250923050317.205482-16-Neeraj.Upadhyay@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v2 15/17] KVM: SVM: Check injected timers for Secure
 AVIC guests
In-Reply-To: <20250923050317.205482-16-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0019.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: 960a0610-bc08-45c1-36fe-08ddfabecbe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M1hsNEZQTEFFaTUwMDdFa1piajdWenBUaVovUGptREhZa3dSUVVTN3RWODZw?=
 =?utf-8?B?aTlKOFljMWNHRGRHQ1dhQTVBK0NjK2VZZVJaTEkzN010Q1FZRDRoN3Y5RUtR?=
 =?utf-8?B?YXZlMklaV0pZeFBHNG1ORmFDWm5MeVVOQkQ2N0FyS0FLRGdkdDRLTXA1NWhQ?=
 =?utf-8?B?NW81Z2ZZcitxOVdNeFo1aTVaS2JrWkVRdUNqaVFhamNiS3Vma2pRNTJTZWxi?=
 =?utf-8?B?MnZVNytsTmtTT3lUaXlhanhhcktZS1VQaEpObkJNMW9WKzZyWVFSN1NvVXNs?=
 =?utf-8?B?endHdm0wL0VJU1BiYWxHbXVpMytuaGhxNEZhM0NuYUFmWk9PYnVlYTdVa01v?=
 =?utf-8?B?K1p5SlVDRUNXT2tNRk9rdERTcFROb2NRYnVEaUtYc1pwNXMvZnRGWHJyUjI5?=
 =?utf-8?B?RXhnU1FWZ1NnY3hvbGQ5clROUk8yU2NxdFc5TCtUZ05ndUlpQ00vaG5CZ3F3?=
 =?utf-8?B?SzJlRDR5VWNhdTJZelNieFZRUEtyMEJRdk1MOG5Nd21BeHBYT3JDaWtSWkNL?=
 =?utf-8?B?R2FTUVE4ZjVSVWp4U3prK1MzWDNSbzBpTGlQYjlIcnliY2p6cFpVajVweHhW?=
 =?utf-8?B?aFo5WmxVeVY1NHM0eDRibVBuUTB3d292QUp2cFJXN3RCTUlVRFVwaGU5eE9w?=
 =?utf-8?B?dUZFRUxUd0ZwN0hRNisvSys1MXkvdFVHYklMNWFFOSt4Tmt6VWJvcUhRNUlY?=
 =?utf-8?B?U1prbFJCbGZHVk5Pc1JIY3FkL3M0cCtmamN4dUdDK2dZaVhBQ3pHakUzZjlH?=
 =?utf-8?B?QUZoZXkwZFVxSUJLMmlxVEFNMVZra0VWTFp6Y1dZRWRHL3hnS1d6SVR5bVF5?=
 =?utf-8?B?YjdMVFMwV1ZxTjBjbVNjd3h2alNRLzY1R3pockdLbElId1NxWVFhWURlZFBG?=
 =?utf-8?B?ME9SR21IL01kbERwRTB0d0pFc2R4SllOb0NsYlkrT3ZGcUsweHd0QTBMUGlM?=
 =?utf-8?B?bkdwMEtMOXZveWhVVkxWU1lqSHl2WC9PeDZJc041c3lSQTMrc2RzSVNDQUZJ?=
 =?utf-8?B?T2o1UjNqU2hKK2dmQ0Zua0RkMWpHQWZyb3pmaC9xSWRtTjJ5VzNtMWg0UE9o?=
 =?utf-8?B?Rzg3T0p0MjBKSWVhYWpub285Z1MyUWM1K1JVYURkdVJ3MFhGaUUrWGxzKzlN?=
 =?utf-8?B?R2tucjgyQjcwOGI0YnJUOFZuN05XSi9ZSTBnZ1kxV0xKMXBUQ1AweHkvM1V6?=
 =?utf-8?B?U2tZSlhxcVZFMjZucmxDVW9Sa3JKTkF1ck5kNFFjV000dUVtUVE1NXVCTmlQ?=
 =?utf-8?B?QkJlTTdOMGpDWjZIc0pOaU04YnB5S2REeWhXUUtIWWFQbXd0d0Z5SGtNNTBp?=
 =?utf-8?B?VUdhWnJnUTB5MktZcTlOR1lYWGt3UVNEOFUwTE9WMWszc3ZKVHIwT0JDR2c4?=
 =?utf-8?B?azB3WjVVNks1cXZONnFKV3gxenRKbS9obkEwVWsyK2xRbGxndWJZUkpKVGVz?=
 =?utf-8?B?YUw0UVJQbFZURFRFZ2R6NVg1UVp2bjVRdlFYRU9MbjF6MU5hc08wMjNyMDV5?=
 =?utf-8?B?Q2d4cDlEK0tucG9IeFI5YWQxVlZscGV5V3U2Y29BZnEwS2JSRmZLcElsOVM2?=
 =?utf-8?B?ZEYxd252YkVwTUQ0MUIzSWgrajBCY3BTbDQ3MWd5MlBrK1VLOFc1ZzB2UEgr?=
 =?utf-8?B?VlN6Y3Y3dCs3T3VLZm5rV0lTdzZRMFlOb1RtemtERFVlTGRld1V0UyszUEpD?=
 =?utf-8?B?azY4dlJ3QVRlOERXQklUUHU1SXRNekZ4UWU5cXVkdW95dEs3SUdvSlhnV0Zi?=
 =?utf-8?B?akphY0xiNGx4S0g3cThuK2FIMCtyL3lkQXNrUDNlcEgwd3Y5M0g5WTNtSzRE?=
 =?utf-8?B?alozMG5ZSFZaWGlXMURpVVpWc2pyL0VITGFKUGJKNEtqU3RudEFDR0ZFbmhh?=
 =?utf-8?B?dmpDWDBOR2ZIRmt1bFUzMVVCQUc1ZDlnYzVaYitubWpLd0ZlQTV6WTNRUEVW?=
 =?utf-8?Q?h2mHqwkEMBk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vit0VUpNeUtwNHlNMlVGZEQzTDV6TkVtR2ZEeURRRE1YYnAxbUNrYjJ4dTRF?=
 =?utf-8?B?T09kRGFJZWs4a0ZGTmxaQmxWRURHSndvZS9kOWlDMzFVS28rSFRuOUtBczdj?=
 =?utf-8?B?T29sSi8zZ3doa3p2Wm5vN0N4WlV1V21hZGVJcUgvOXRXVmVjWHliRGl1N0Ru?=
 =?utf-8?B?dVBIOFE0WGhvVkFacUZ0cDQrV1JWUFVHMW1Od3JSR0pUM3dYb1BEeGxnQzFX?=
 =?utf-8?B?Y3BvamZIY1Bmc0Z3K2ZmTTl3TTBzNHdsdjA5blFOaVArcEgrckF5NUs3YTMw?=
 =?utf-8?B?ZXltOFRXOEVyQzhQbFkxUVNwTWpCb0ZMWXVqNTRvUm9wZnZtMUx6c1R0SXFC?=
 =?utf-8?B?RnVLS2ZSSDZCVmllbUF3ZW9LSTJQM25KeUFQUXBUZzg0SW9TWi80dXRFTkZO?=
 =?utf-8?B?eStpRkRscUZENEpzdklYTlJHbytOYUtjZEJsRWMyaVBJNWpLMmU3ZnU4YWtu?=
 =?utf-8?B?RW1TT0pJSXdsaGM5ZEZjbi9YcXpqSThMUUsvV09ORVBpM25hb0FGc3p6Sitw?=
 =?utf-8?B?dEJhS0NsaDZvUlFvYjBJWDkvTTRoOUdJcXRsMVJWTEpac0ZUdWgySnJ3T1FV?=
 =?utf-8?B?UTUrZ0M1OWttRm1USzZzTEdPcVZrWTh2RTZibk55SExIM2ZlbVpMTXMvZS9H?=
 =?utf-8?B?M05aZWxjSElqTWZSZFRhU3NuaklMVFJhSktlSGgram1vcXROcVFIbkZ5OUht?=
 =?utf-8?B?eVRKQUVGNHdUeDl0MzU2QnhXclh0YW9QQzEzUGgraEt3U052M1FEZ08yRldr?=
 =?utf-8?B?dWJBRGRsYWJWajZxOHVkOWdiYUZwMXI4aGJmWk01cmNYbVFTekhEQ1NGTzAw?=
 =?utf-8?B?cGprbERzenE2MXlNVFR3L256M2lqUE5PUFJlYmVBa3k1UGI1ZjU1S0M2bFRI?=
 =?utf-8?B?N2NwelFvd2RaZEtaQzAxNC91bnJiNy8rY0kwWXV3VW1tLzRxKzRKVDcwWkpv?=
 =?utf-8?B?NmlKczBhMWVacjJjMUxYazlDQjdJV0V4RStkeFhIVU4vTURVRFJPeGNIa0Zr?=
 =?utf-8?B?d25QVHVYbEMrQUdvaGtVSklUTlJlZkU0bjJjSTJoMjdkNmtjYlNRVWdaZm5I?=
 =?utf-8?B?SThkdjRFUHV6MGJMUks2THJ4RmIxL2ZDTkowQWJBNEdlRkVKNjRHak1Ebzkz?=
 =?utf-8?B?SU9DeFBEd2xMMWxXcTVJN1E1UDR2aGdNd0lyOXRrOHBTU0FRdE0wV3RvVVBt?=
 =?utf-8?B?aFh3UTBlS0RHQzlXb2FqYjZBYUpHYVVxMG5Ba0djUDViY2RpRG5YRGNWK01S?=
 =?utf-8?B?K1UvSGZRelNhZUg1KzBMNkUrK01vK3BzcFkrUSsxYWMvb1JjRHV6V00rb251?=
 =?utf-8?B?UWwwL3hqTk9ZSDl1UW9nVGdmeEUvTTc0eDhjUnhVb2ZSU2RPbm9IUjN4U2ht?=
 =?utf-8?B?ZVh2eHd1dDQ1OEJQSnZZZEMrMm5aU2kydkxZMHFkWkdvc2o5VU1HeVN0OFlN?=
 =?utf-8?B?eW5zQUF3eDdnWEwxUXhpbG40elZkUjRKeHkxWjdFejM3SU9mRnF3NFU2Wm5k?=
 =?utf-8?B?NEd5Tm02MG54cnhIM29JTGs0dUdKbWY0dzl2MWwvNklxRkdrd3lZajlqd25y?=
 =?utf-8?B?NjRmN0I5TC9kbnNKL0plYUZJSWpLR2x4UHR5bFhXMTY3L2pCWWg4d2ZRakov?=
 =?utf-8?B?M1JmMGt0R0o1QStUN3E4TmZPeGM5Z3ZZcjFyYmlkdGpXeUpaRkRzTFFIYnZE?=
 =?utf-8?B?b25DWmptOWJHSFE1ZEx1YTZ0dGNWbEVNUFA1WVZHRURjelJCckpZQ0xvOG1X?=
 =?utf-8?B?ZWY2U1o3akhzYmh0d1VpTXBVQTJyQUhjNFJ1NnFDOWQxL25oZWQxREtrVTJP?=
 =?utf-8?B?MGgzVk0zbVB0NnFCM1FOQUdIck5vR2VxQVoxUi93L29KZEtldm1NUXVnZGIx?=
 =?utf-8?B?RVd4ZjNJT0ZnTHdkUVRDZTVENkxCRzdGUCtsQXYvTERtYkNlcGNaZ3FTc2s3?=
 =?utf-8?B?cnorZ29TNEJHR3JVU2Ivc1ZCTzdubXUxZ0wrTEUxVC9tQVN1dTEzMndISU96?=
 =?utf-8?B?UXpCelkrUXRCQmtxZCtnYksvc0FlU2pWMXovZFE5TzhwNG9nUWJVS3JSdS9B?=
 =?utf-8?B?QVd1dW5QNU1ObzVrbk0wZWJEYkcxK2lLOVkzbzhwZTdwY2Z3L0ZBRzUrQ1dT?=
 =?utf-8?Q?gVDXF4aziCxMVYutFHX1lSsDI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 960a0610-bc08-45c1-36fe-08ddfabecbe4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 16:32:33.0121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A1dyx/yUTvk6yMaM/J4kGDu9tIBZBIHVSefttXJ7xtz0S8fkyDS2Z5qUwHXVlgNDjy2o/jDv5k2ZrMAH2+Q9gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6977

On 9/23/25 00:03, Neeraj Upadhyay wrote:
> The kvm_wait_lapic_expire() function is a pre-VMRUN optimization that
> allows a vCPU to wait for an imminent LAPIC timer interrupt. However,
> this function is not fully compatible with protected APIC models like
> Secure AVIC because it relies on inspecting KVM's software vAPIC state.
> For Secure AVIC, the true timer state is hardware-managed and opaque
> to KVM. For this reason, kvm_wait_lapic_expire() does not check whether
> timer interrupt is injected for the guests which have protected APIC
> state.
> 
> For the protected APIC guests, the check for injected timer need to be
> done by the callers of kvm_wait_lapic_expire(). So, for Secure AVIC
> guests, check to be injected vectors in the requested_IRR for injected
> timer interrupt before doing a kvm_wait_lapic_expire().
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 8 ++++++++
>  arch/x86/kvm/svm/svm.c | 3 ++-
>  arch/x86/kvm/svm/svm.h | 2 ++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 5be2956fb812..3f6cf8d5068a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -5405,3 +5405,11 @@ bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu)
>  	return READ_ONCE(to_svm(vcpu)->sev_savic_has_pending_ipi) ||
>  		kvm_apic_has_interrupt(vcpu) != -1;
>  }
> +
> +bool sev_savic_timer_int_injected(struct kvm_vcpu *vcpu)
> +{
> +	u32 reg  = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTT);

Extra space before the "="

> +	int vec = reg & APIC_VECTOR_MASK;
> +
> +	return to_svm(vcpu)->vmcb->control.requested_irr[vec / 32] & BIT(vec % 32);
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a945bc094c1a..d0d972731ea7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4335,7 +4335,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>  	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
>  		update_debugctlmsr(svm->vmcb->save.dbgctl);
>  
> -	kvm_wait_lapic_expire(vcpu);
> +	if (!sev_savic_active(vcpu->kvm) || sev_savic_timer_int_injected(vcpu))
> +		kvm_wait_lapic_expire(vcpu);
>  
>  	/*
>  	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8043833a1a8c..ecc4ea11822d 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -878,6 +878,7 @@ static inline bool sev_savic_active(struct kvm *kvm)
>  }
>  void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected);
>  bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu);
> +bool sev_savic_timer_int_injected(struct kvm_vcpu *vcpu);
>  #else
>  static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
>  {
> @@ -917,6 +918,7 @@ static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
>  static inline void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa) {}
>  static inline void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected) {}
>  static inline bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu) { return false; }
> +static inline bool sev_savic_timer_int_injected(struct kvm_vcpu *vcpu) { return true; }

Shouldn't this return false? If CONFIG_KVM_AMD_SEV isn't defined, then
sev_savic_active() will always be false and this won't be called anyway.

Thanks,
Tom

>  #endif
>  
>  /* vmenter.S */

