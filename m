Return-Path: <kvm+bounces-29276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B239C9A65E3
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 13:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E2DB282F82
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 11:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFF7B1E47BB;
	Mon, 21 Oct 2024 11:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xz6vo1FS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B891E3DF9;
	Mon, 21 Oct 2024 11:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729508832; cv=fail; b=PMlcEaNr+fMk1WJAGXX7N9JEv7gtBDD++6NiatndD/BF+IqjvsITCf+hfGu+WEvk5n7rMLAOYq6Qb8nVn1QjJU6SPFYL2jGaWgohRG3jCA3CHsTwXmCDuWW9Q9/1j1Ps48P41cL+ZyQ0iPEt0NI2xx8gbwWVI9N5G3u4rvDE7bs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729508832; c=relaxed/simple;
	bh=lrCKeT3h1LY49XAoNN5Y+SpC8ZXh3oYqPHezWD5xFsg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q965/vIMrsJvg9bTTOESS8tZxOhpu/1Ftdwkm4pMgsES3TsyqJuxkA37oMReuV4WXj0v1wAcGMe/MXcclqgUo1jTAEluKnZq74/Jjlqy4zxaiEeKa2UmgeLwTCn7P6zd/GGPshtLN1PZ2d080hyF0hjn76fsHofb14+PXvGpua8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xz6vo1FS; arc=fail smtp.client-ip=40.107.220.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UMI5x+fIILN+liBCGD/vKOJ6M+pmGH227sDXoCcgIzVjjStvRpMouGvXrFKQQSApx8mVRQbE+Xg+woB7oOa/qJWnTuPOQTB6UiYQRBgdmMpUhzqDE9JeSlGDH9PDiGzOKqXiIXJIVGGtzy9bqzN1IfDhLNKxCvnuISiUEYI+SiRA6ljVurRTLmk+xnyIDp144w3y8dbRPNH9MXqPMqlgCziwCLlpBiFNLA0Uw3d91UJQulMBUAzq8NwbqQdWMa4hvgPqC2/n5F7XIo/mEmCC94whiYUfTn2pGLe1KR9PYEZtTrvEMbqIHisj6lYgv2/iwml3ls8ljFdgRFjVOyXp6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jl2vuHFQURtzRfzyAt1isi+F1hxtsws+glI54MPPW4g=;
 b=M7Q6LqP8B6yQrFmMkSibNLfY7WKhrrysVFbJW4AzV/R9XhejTn/ZyKFOFlhdf1kmXTAo1ohT/hpq6qUOEezYshJZNqHtFvJXvdyBq6n2MJfKmTusRk8Y/GimO8FWfNOxLbY12/zXxUlgRn9Lyys+YU1U7K5cCinbx6yE2lxpmNY+4W4fTKXTUoDp7+rnlajD+j/4exs6MBbhl4y1Xro4KeHf0PRRXV+glyEhxb67e0wW+sstLQ6wOVDXkBJAgTMlV55FpyNXQOkeybmmTpbY+ryRZoVDIushblbSGo1bD23aXaIHfPXhj85T2UpaHhTkVqBgIZEB1h+bEk7ZgqV5EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jl2vuHFQURtzRfzyAt1isi+F1hxtsws+glI54MPPW4g=;
 b=xz6vo1FStoDMuuXjD1qBNOllHBFBrh3FZqU6JwG9hjsZuU+8iSj0/5Ig13c/eGaf3BHH2MT8JdTITn2cr8pbos6NJvqQcMt2ErVvHnJUEdPGdC+7r6CN39mZKZrRym+0cVQxt4LE5yqvuPz6gJETf8Hp7mUEfZggrNB2HUIw8yo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by SA0PR12MB4478.namprd12.prod.outlook.com (2603:10b6:806:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 11:07:09 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::f943:600c:2558:af79]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::f943:600c:2558:af79%5]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 11:07:09 +0000
Message-ID: <c4d508d8-539b-c09b-eeb4-693d76845a26@amd.com>
Date: Mon, 21 Oct 2024 12:07:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Content-Language: en-US
To: Zhi Wang <zhiw@nvidia.com>, Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>,
 "Schofield, Alison" <alison.schofield@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "Jiang, Dave" <dave.jiang@intel.com>, "dave@stgolabs.net"
 <dave@stgolabs.net>, "Weiny, Ira" <ira.weiny@intel.com>,
 "Verma, Vishal L" <vishal.l.verma@intel.com>,
 Andy Currid <ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>,
 Surath Mitra <smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
 Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>,
 "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
 "zhiwang@kernel.org" <zhiwang@kernel.org>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
 <BN9PR11MB5276B821A9732BF0A9EC67988C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <75c0c6f1-07e4-43c1-819c-2182bdd0b47c@nvidia.com>
 <20240925140515.000077f5@Huawei.com>
 <5ad34682-5fa9-44ee-b36b-b17317256187@nvidia.com>
 <20241004124013.00004bca@Huawei.com>
 <aed9bc24-415c-4180-ad5b-192a7232d10d@nvidia.com>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <aed9bc24-415c-4180-ad5b-192a7232d10d@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7P191CA0016.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:54e::26) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|SA0PR12MB4478:EE_
X-MS-Office365-Filtering-Correlation-Id: 020a5c5c-3efd-43a3-40ed-08dcf1c08176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b1hnMVovcmdTUUZiUkpaV1lJQjVYM0hNSVpaUGdqQkRoaEhxODFwNURSWFN2?=
 =?utf-8?B?Y0JYTHJDL0RiRjJHbGNHOE11OC8yN0ozUWYrRzFiKzBxczUya1g0NHZ0Y2FL?=
 =?utf-8?B?dVo3aElVTHBZckY1SGxscVRSOXRKcE5XUGJRVEVzcjFZL3ovVEF0MDJBaFF1?=
 =?utf-8?B?azVlc0ZQeEoxMldsbjNaeS9Bc1dKU0w3R054Qkp3MnhGOHVETUhWUVRGdDJJ?=
 =?utf-8?B?Z3NLQ01UT0c1b3lnWUg4eGZMZkF0WC9LbFB3MGd4VEZ1WTk5T2xUbWkxSGNt?=
 =?utf-8?B?ZjgxRTViMG9STkhOeGZtbm5aU0FqU1YrSENXU3V1RVhKUmNsUHg2YTNEbmlw?=
 =?utf-8?B?TktJZlhXY2VSblI4NlQ0bTh1OEtlUzhnNjJQR29wbmhkdXJRZkNWMmlXMHJK?=
 =?utf-8?B?WUFERWsxSVFXSG9BT2NkbERxMUxNUEp0UXZSdGxXK0ZOMjdwbGJKa1huaGll?=
 =?utf-8?B?OUR5TXFqZkZodlVtbHZ2aDJLSUhTdzBBYkZyakUydVY2RzVRa3Vkb3BXR005?=
 =?utf-8?B?OTN0cFFpcXJYZHRYTTJGa2dlQUJyMm14V0swYzR3Tkh1Qm9OYTNva2JqSGtR?=
 =?utf-8?B?S1R5SmxoTEp3Yi8va0VWcDl5UEt0ZDdIRnpXWnpNbEtUaFFieHE2UitRcHlF?=
 =?utf-8?B?OTlOWFo2T1g4WnllVjc3ZEpjSDkzSkZRUG5OV21LWmFTdWs1UlZSdGhFZEEw?=
 =?utf-8?B?R2d4WndUNEhLTjVqMmc2WWZIdGptRkN4bnRtWkl1WDdhaXNhSnYzeEg0bzZ0?=
 =?utf-8?B?VnZrdU0vV3lkQTdKWHIva01OcFN3RE9ORWJTVmlteERFUmFUOCtyY2JDQU90?=
 =?utf-8?B?QU1NKzloTVI5UERiYVVkM0w5VEV2Syt3NDZzVkp0N0tOWU8vNmZjQVZ5L3dy?=
 =?utf-8?B?TDNodHdMOTdIZ2RybUJPTTBLNUVPWTNZRUhVWGRXMGN4UmptUWNmTnNSV3hl?=
 =?utf-8?B?QkwvMEhEUG9Xb3pjNkE2SVVQKzMzU2ljYkFpeFV4ZmtUK0E4UUZsMmFmcWpj?=
 =?utf-8?B?SVJmUEZvK1o2d0pENElsa1NFbCtkVGNvU2xDd004YkpVUVlUaXNzaEhNRDV1?=
 =?utf-8?B?SEZlLzhlZzQ3NDVVRkgzZkVSbnR2dHVJOTA1L0JGSmN0UHFtbkVaVzFnNVRJ?=
 =?utf-8?B?S21BWXpRL2ZCdjZhdDN2cnJybzZVRE1OT2ZDb3ZUejZKdXRtOWR6T0wvdElL?=
 =?utf-8?B?T29BbTJlNlBuN0Y2blFkSHhPdEgzU1RyU3hWRnBVS3FLc2g3TzhDZHRRcTYx?=
 =?utf-8?B?dDBSdUZwKzNuV2l1b3lzRHJsL2JOQ2ZSc1Z0SnNRSmdOS1hFamlnampNSzlJ?=
 =?utf-8?B?VmsrRVBHdkY2Zk9jb0Z5cW5ZcWJ5aVluNEdiU05VTFRWUUFCbTFzZW90MDkv?=
 =?utf-8?B?TmtWZE43SHZZaWt5Wi9mYm9wNnpQeE9kVmRCOTkySmhTbElCRXdvZElrMDRm?=
 =?utf-8?B?UzJGQUd5VGZKK3NHVjRLbUUra043MW1KczNBb2FBTGVlYVkrdXJnRkNPWGMx?=
 =?utf-8?B?SDNrTG04djJWU0t2S1lrQ254TG5jYi9zamt0bmhrT1owdGFzV2hpYXFad3pG?=
 =?utf-8?B?OTgwVVExS0RZSk1IeFhsWGFwb2c3ZG0xSmVQdnNUVFlxRCtoZWhCVEZDOEJ1?=
 =?utf-8?B?NEZ4SUlvTnc4emRJUmtKVHlJOFROYnZ6ay9YQXpsc1ltTWk3ek41Nmd2Z3NB?=
 =?utf-8?B?cFh6bEhHS0cyWTdzUHh5NW1aTERIRHJiUDRzbkFKQ3R5L1hKR3ZlVGpDbUlm?=
 =?utf-8?Q?hSQVyezF7P3Wl1zaloe8CEPCeJ3llgUhuDeepNX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkxvbzdRQVpWcUhwaDFSaWRRUnZVZlBLam1xUzdDdkM4cDFmN1ZZd0hVSE9E?=
 =?utf-8?B?R0xNQkkvZlFwcDUrWE5kRTFjL09RRGRNdTBUVXBXMUd0N0YwSVZ6bGJGV1Ez?=
 =?utf-8?B?cE9iVitGamJZalMxNlk2TVpBM1h1MkdnWEtES3F6ZDQyWUZubjk3VFlycXFC?=
 =?utf-8?B?MHdDME5mK3k4VmM4Y3UyaTMxQ0pKOUhyS1FmaitjbUE1NkFkM2xQU2RyOVoz?=
 =?utf-8?B?c2RlR2NWMEY1anZIV3VoU0lzMjFlVmRHT0w2RWt5dWNOcWhoRDV3U2U1Nlox?=
 =?utf-8?B?OURBQm9OUXJJeFFGZ1l0dzlvZk5wNnNuWnB6SVMrY2RoVlpFMWpQT3dkR1VV?=
 =?utf-8?B?RVhZVW5uWmU3WUhLalZWZm5pNlNVNmRmWUZ6YThIU1F3RkFhWHhKNThlWUVC?=
 =?utf-8?B?cGRKMVJrLzBGcnZpVEM4U0d6cU10UmhibldqdUI0VDJxVnR2MTk0KzNEb01u?=
 =?utf-8?B?Y2VlSTBOYUh6UmNsTU5rMTFKTzhXb3pmS0N1QlJVaTNwZUpxaUNZb2ZQdTIz?=
 =?utf-8?B?eUFmYzE4VHc2R0pKS2hTeWp2eEwrTVVvVjdxYXNyYmZLeTRXRmRDNXRiOFps?=
 =?utf-8?B?RlJLajFucWt4TU5PZWVyV2lKNGdBVmtUMUJQQ1dkSnFsdGt1aFQremJqbitW?=
 =?utf-8?B?S29xYUZMMk9TdU5FR3NXci91NXJTNzJUclB5OERDQisrbUxZSyttM1JHcGVv?=
 =?utf-8?B?bmg1OWIweEJjcXo3alQxbjFESEZDN0VwV3VYaFB4SC83d1NvaVJEN2R3QUVy?=
 =?utf-8?B?RVR3YkwvZDliQkJrNi9kOGRhZ1JhcXM3SkxibGFjSTExZmNjT3o1aFo4RDQr?=
 =?utf-8?B?LzFXcXlFMGxuZ0JLVFFlamdUdmVybjF0ZG8vcEpwZkJMK2E4Q2RkMTNQV1Bv?=
 =?utf-8?B?KzZsTG9FcVFjM0xSdGZ4SlB2RGh6VGZRMStucnEvL0FxbitOMlJqYkpsNHdh?=
 =?utf-8?B?SktYdDh1aDIvTmVhQkNaYlQyNUgwbHNodThXSWNxa1V4S1lrUlRnN0o0c2JE?=
 =?utf-8?B?S2JKYVQ0QlRVRlBOd1ZJWnViNkdUMlBaREErWXA3elYyc2V4ZHNSa0ZOV3Av?=
 =?utf-8?B?Q0YwOHVJdExHd3FMY2JNVDhhOUxXT256YkxjYWtDb1VWREg1RHFrUEFxTldJ?=
 =?utf-8?B?TTVVdnBHV0pUSlVuK3pFRHVsbE5iT3N5RE53OFFPdDUwZEF2cUFwSVVPTXR1?=
 =?utf-8?B?dEFtRnU0YVEzZkw3U0c1UG1zNWFoc1lMOHpPVll0eG5LTktOUVprTnRubFVs?=
 =?utf-8?B?QVdSbjJIbVE2dENyQ3AyRGwwTnRweUhwWEx0bm5NVlRCZlRwakRxVXhvRFVk?=
 =?utf-8?B?S3loaEErUU4wb0NqSzdTMEFScW1ST3FNOUxybWYzQ2QvaTVGMVRPOWI1V2Fo?=
 =?utf-8?B?T1FFcDd3a28xSDJzVVY5QVJSRGd4TkROdXphM1NCek9HOFVuZnhaR09odHQ4?=
 =?utf-8?B?NnBYeWxDLzBLcXhjYk1CbU8xaFZFM3lvSXJOQmRnbjl0bnJrL2lrSndaOVMr?=
 =?utf-8?B?NEg0czIrUlp4VTRWSm01MUc1SmY2R3F5RFdaYjZjUUFnOENCWGt0UFJtRkNz?=
 =?utf-8?B?UHlEV3dvaVV6QmRaRGFUTjlPdm9vQ3Juc25HeGxpdFJ1a0tWa2w3alJEZ2FQ?=
 =?utf-8?B?UU5jdU5JRnFuSjB4NEpRQzc1dnYvOVlUUWFRQyswRWZLZlp6MlpaQk9tcWtw?=
 =?utf-8?B?SnRtTTUxMStlOERlYnZ4VkFuOU9wR1dVZ01EclNUd0thQWg4SDdMOUVub2tY?=
 =?utf-8?B?YzhVaklFZVZLSXM4bm51dDR6TWpabVh0ei9kV3RhaTNPazZPYW92UEh1UWtu?=
 =?utf-8?B?SWNFaDVhRDcvV1dQMDFzWFd1YTVSc2xyWGppN2k5dXhneWRVbWdlOW9yaXkr?=
 =?utf-8?B?SUViRWUzMktaVnlpZDhVSW1mR1pqcUxsSmtQTlZ1SE45MjNmNmZsNkdVckpR?=
 =?utf-8?B?eG1CK0RoaldzTG9Jc25McUU4dWN2ZWg2MFV6dWxMZi9xUUpXRGNjNHd5TXdX?=
 =?utf-8?B?enZtaWxzSXVVOUZaNHdpVldETEN5K3JoajFjS2xVK2tQS0l2NWNyTWJOWWFm?=
 =?utf-8?B?djVHdVl6aXRvTjFxdGx0d21VQnhtdmhGNDZjaXRNRjlBckFGZ2RKczA5eFlr?=
 =?utf-8?Q?iCB4P4QiD6xXn46z5urCjN7CJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 020a5c5c-3efd-43a3-40ed-08dcf1c08176
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 11:07:08.9742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUtp9d7UWJXWIe8FTniESXYms2glcp+8O79mPM3tnKE2vxh94mTkYEMPrfsI8GSN01Rf9mVbnWJCODiCmwz5sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4478


On 10/19/24 06:30, Zhi Wang wrote:
> On 04/10/2024 14.40, Jonathan Cameron wrote:
>> External email: Use caution opening links or attachments
>>
>>
>>>>> Presumably, the host creates one large CXL region that covers the entire
>>>>> DPA, while QEMU can virtually partition it into different regions and
>>>>> map them to different virtual CXL region if QEMU presents multiple HDM
>>>>> decoders to the guest.
>>>> I'm not sure why it would do that. Can't think why you'd break up
>>>> a host region - maybe I'm missing something.
>>>>
>>> It is mostly concerning about a device can have multiple HDM decoders.
>>> In the current design, a large physical CXL (pCXL) region with the whole
>>> DPA will be passed to the userspace. Thinking that the guest will see
>>> the virtual multiple HDM decoders, which usually SW is asking for, the
>>> guest SW might create multiple virtual CXL regions. In that case QEMU
>>> needs to map them into different regions of the pCXL region.
>> Don't let the guest see multiple HDM decoders?
>>
>> There is no obvious reason why it would want them other than type
>> differences.
>>
>> Why is it useful for a type 2 device to be setup for multiple CXL regions?
>> It shouldn't be a performance thing. Might be convenient for management
>> I guess, but the driver can layer it's own allocator etc on top of a single
>> region so I'm not sure I see a reason to do this...
>>
> Sorry for the late reply as I were confirming the this requirement with
> folks. It make sense to have only one HDM decoder for the guest CXL
> type-2 device driver. I think it is similar to efx_cxl according to the
> code. Alejandro, it would be nice you can confirm this.


Not sure if how sfc does this should be taken as any confirmation of 
expected behavior/needs, but we plan to have just one HDM decoder and 
one region covering it all.


But maybe it is important to make clear the distinction between an HDM 
decoder and CXL regions linked to it. In other words, I can foresee 
different regions programmed by the driver because the way coherency is 
going to be handled by the device changes for each region. So supporting 
multiple regions makes sense with just one decoder. Not sure if we 
should rely on an use case for supporting more than one region ...


> Thanks,
> Zhi.
>> Jonathan
>>
>>

