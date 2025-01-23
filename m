Return-Path: <kvm+bounces-36361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44367A1A55C
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4F2D169FDC
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB99211495;
	Thu, 23 Jan 2025 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MpHsAt+0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2076.outbound.protection.outlook.com [40.107.102.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43386211276;
	Thu, 23 Jan 2025 13:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737640793; cv=fail; b=MGB/qwn8Iooz/VLh2biC0N26FsFfreo3ATxBiVIoVWApg+hg+Zoqd4GntnYAe64ZOsUV8MYJM0Y3lg2KaoMM9MuJ0dhazBoB2fuFnRzsSIXA1YgelLSq8ox8w3Y36qwhU0Y3D+Bev7dCqqM+Kikwzso+IJ2qgX0/IK7J1nTEJfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737640793; c=relaxed/simple;
	bh=x2knVlIKtHPGbjAATsyDm3vGSzoJhdwJ6Y4gCJt5OAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gaMt33p2ZrSQSZH9AxqmTsFqG1k1GAU7ZiO1T8LeKB/mkHrgL1yOIkrtt4l61OXCPasr95v7qqPZf4G6YAPS5H9pycne2wQbRjEjVd1f6muVYN0lIVoTZOeyDwV0umy37Rqs/vGCX3cDBv43+008Q4dijLWdQfe5pz6iQyWgmzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MpHsAt+0; arc=fail smtp.client-ip=40.107.102.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pFxorwBgRhVzChBLbmdWHODzUaDDSogEVwaLcJX4XNkvBqy0SZAYdVrGK7UqghgESAMPR9dCAUVOnkQRJCYQbb8ClTG7eryeU+JLYo4KFJCLYv3bA0F+x/1Dqq9CItljsJ+7juHqOg3na154EQQ9Q3V3tqSX4187DScJn6WLB0BpThq0yh9mx9LFO+Og2KEC4AGcrHlyHfQGip6SfOC+n2mklXZAU4FKDwwrZ1t5kZa72EnIlUqLEQ05LyqHHfDKsr8n50Frcaen0AzWj/9bDltIh2gSBfACn3Sqiwa868ZkorXDcu2iqQbl+yeaBxmjE3WYsoqHZb9MmVme1K6MXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqVhw3daTuRJ2XfVebw0ULNxkFfGJ6G9Xt8ufuSNsZU=;
 b=uGLLZKgW55OtMSIfRsssYv34Y+0mWDlQmXD61K5e7ecfTdtJ2pII+El6T/sV5OWL+aqo7OpZlLPAzqI+y4MXO+h8D95VOK/ciSnqlAU47MuMWaE7Tmv63IVfXOYkqPRU4NLQ0Bbfr1yzPSLbkMOaiHhKtu/w8p0bHiQCTvZrIvpsRC1tIxbbN4//q00GLGFXsfj02kv1S7aA4TCmvCNHu6V1om94ZE4T7JPQzWpR681nfxYxhnn+rZwnUD+vque4bd2fg4Y6i6lq8ujNK78H550OoDmDugGcQloJq5pg2L/TYjhJz6QO8JjsSHfuMonBSPyaKJiWIum0YdJF846bPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqVhw3daTuRJ2XfVebw0ULNxkFfGJ6G9Xt8ufuSNsZU=;
 b=MpHsAt+0zjMMUedRiROU31MJF8fSkDkWeibVzkabmWcXPTz7RcfYgSUXB9okN1wYbFZfpacgp7ypKgCH+ExFDpGXlN5Golic6GpCGVDrnhhR14jqJyucwE0H7HoEcrqmlRqWiQ2sW3Yrx8eciDUhe0kJshO+O8ffB2F6KEultSIItVF4rtqt6RJLO31TdPRizszP90vplaF7MCQkaDXdOuV9CM3bjxYQqygHqqn199VLSoMeEOPeiXaRFpc94jilANHJvq6oScLkr8BdF2ONoGAHGxBtwY0Nr/sVjuVRxWMtmVPx9xDkRtTyXFrWE8VakuOy77qW35IMi7CxEYwpYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8307.namprd12.prod.outlook.com (2603:10b6:610:12f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Thu, 23 Jan
 2025 13:59:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Thu, 23 Jan 2025
 13:59:47 +0000
Date: Thu, 23 Jan 2025 09:59:46 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leonro@nvidia.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <20250123135946.GQ5556@nvidia.com>
References: <c10ae58f-280c-4131-802f-d7f62595d013@amd.com>
 <20250120175901.GP5556@nvidia.com>
 <Z46a7y02ONFZrS8Y@phenom.ffwll.local>
 <20250120194804.GT5556@nvidia.com>
 <Z4_HNA4QQbIsK8D9@phenom.ffwll.local>
 <20250121173633.GU5556@nvidia.com>
 <Z5DQsyV0vwX3Iabu@phenom.ffwll.local>
 <6612c40d-4999-41a1-a4a5-74d3ff5875c3@amd.com>
 <20250122143744.GF5556@nvidia.com>
 <827315b0-23b6-4a39-88eb-34e756298d67@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <827315b0-23b6-4a39-88eb-34e756298d67@amd.com>
X-ClientProxiedBy: BL0PR0102CA0005.prod.exchangelabs.com
 (2603:10b6:207:18::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8307:EE_
X-MS-Office365-Filtering-Correlation-Id: fa50b0a5-7126-44bb-b514-08dd3bb6324b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1VPempic2pxaHpWamtNdHVpUWVYWlNDREJYS3FHVFlPNS8yTHp5VVdVV1Ir?=
 =?utf-8?B?TGNlM2Z5Nzl4RzdaaHJEQjRlbzZPclNYblFnUGI4bE5OeXk3VUxDa1J0R0N5?=
 =?utf-8?B?bjBOMWRpdm5icVMyeVQ2cnFpK0hRa21oK1piaGpMbGxvdzFkdFBta3ZDcDBO?=
 =?utf-8?B?RG16eVdVMlMyNGpOeEJqYmV1MXVwOFhKOTZwYmFZcEdjZS9VakM1aDFMbG91?=
 =?utf-8?B?eWFCSGJ4djNCZWhYSksyK0pWb1Q3NHF4V2RIRnZOSk1mOEhMZ25GMnRiS2xz?=
 =?utf-8?B?TUQwTy9zcUdSS1RFVjZ4bE1kVFVCSXFsNDVxRU11WUQyNlljWGdsRzJCdDVy?=
 =?utf-8?B?SGlBakQvUEtuWjM2LzRXMXN6QmlYNzErU3EzaHBDMWIzTDhJLzMxdm1kaWRT?=
 =?utf-8?B?QkdOTWFYYTJTNjR1Sm5DNzF2em1GTkJoZXlQSnZNbVlUeVFsMkhoTzY4YlRr?=
 =?utf-8?B?ZldLVFNhZlRDTGYzaEdKb2xZRG5LdXZlb3NrNmRKSUhtRlRub3Z5VlRJZjBL?=
 =?utf-8?B?NVVzVFVjSjZkeXRGTFJhaFZ0cmtZUUFpT1R1S0tLNFp1bnJHemVXVXpTTEhE?=
 =?utf-8?B?bkszZUt1UHpncFVieTI1dFNUNHJ6UWhiWE1zZ2Z5d2sxK3pScnQ3M2pPc2V2?=
 =?utf-8?B?cUhwZlNlazBYT0xvYjVPRmVHTWY5VTg0aCtaNTFMd2lIeVZ5dHVyaU1qSWpS?=
 =?utf-8?B?bDA1dHlnTUloWVNlNXZYWWV6Skt5NitrRElLZ3MzRzljalEyUjlGWjlOYy8x?=
 =?utf-8?B?ODdrZGl4NXNVZGR2dEFGaDRWMElBS053SjRDRTcybThDdzkyb2lOaXF3VWpL?=
 =?utf-8?B?dTMvSnpGaVNMaGp0MmIxN3ZaQ1BOQzZUOHNTNzNWeHF1eEFmTkxWenBFck1z?=
 =?utf-8?B?OGd6ZG9GbTMyaXpIbzhvR1VKS0NzOVE1UDNwbStTek1xUkJLSmJxbGxyd1ZM?=
 =?utf-8?B?bUV3NTVVVEtLVlBXUEJpZDRjTEh1dFVKWjdDSTE2bk5LV3RmSGtrU2J2S1RU?=
 =?utf-8?B?Y0M0NVJtNjRrTnZTZnZuMTByVXNPLzd5RUw5OUlLcDZsNVRzOUlMWEtNNXBs?=
 =?utf-8?B?cCtoSk9iUWh6eDJrTXVSUnZkbEpDY0NOeUNHZ0M3UUdyNFhoSVBZSjluQmxW?=
 =?utf-8?B?RTZtc2tvTjBVWEJpK2oyMkM3TXgwVGhadUo3WllibXFHSWdQbzFCY2tpN0xF?=
 =?utf-8?B?eTJzYmZnM24xbWdSbTh3VHZCSzNpdlJWU21uWCszSXplYk5uakVlRk5IcmE1?=
 =?utf-8?B?bFQ3b0h5bFd3d3o5c0Zsb1JIWVoxejhka3NaSWs1UVRwNDZXdnpjUDFlU3Jw?=
 =?utf-8?B?dXo0MWI2a3lRRENia0hRZDg3UktoNWZ0RnZwcGJTZTF0cU9lckh4RnRuTGVa?=
 =?utf-8?B?QnIrWGVkMjJPV1l5c2szbk5YbXN0YSs3UzV1NjFkbkxyTFlUTnJNSzUyejI0?=
 =?utf-8?B?amk5NXQ5cndFT0VTSlJ5anR0WDdOMXFFMDd5bnczWE5rb1hyT3FzYTJpU3N5?=
 =?utf-8?B?czRJeXViZms2NjJBSjlkcVd4ZlN1TW93MWFNa3lNSkVCRlEwVUYvUitRNFVi?=
 =?utf-8?B?WmMvZTdlMDdoN1VPaEZYYm91aDBScDB5TUtjd1hYMXNjM3hkWlRxZUJhdFJY?=
 =?utf-8?B?N0ZFZURmQW1yNWJzTHZxTVdxb1U5UUVpNnJwdDdRVEhqTzcxVmtQRWVBNEpX?=
 =?utf-8?B?WDR5aFlGN3EyTHYwblJ3RVVZNGRZa01Feml0MHc3d3hKOTJIdFJkTURDek12?=
 =?utf-8?B?cThmNHNWZGlhZmFUYUNvVHh4dUtRMERzVjAxb2d0bm9hQ08rN0UrSkd5T0s1?=
 =?utf-8?B?VVZ2eHBmdTdyNlVxUlFlZ2hCRmM2OWtyOFZSQ2ZvNVUxZ3NtNHNUSFBVM1dz?=
 =?utf-8?Q?RYVE2hZwDXY7K?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzdtSzRBRXpCc3Y5TTlKL0FWM2dGZXVzWDRRSXZ6dXJHZXczQWlTTk0xR3ZC?=
 =?utf-8?B?NnRMZmlnRXkxR1J1WXRnVy9FU29rYWlSVU5JSDdSVUc4WFZwcS9kWVcyVTNH?=
 =?utf-8?B?cEQwUUxhOXVwOGVvU3c0SDlwb09sUWczVlRKcUc5M3lYSGNtK1haQlhnZGQy?=
 =?utf-8?B?a0hZWndVZnJHQ3puQWc5Ymt0UDhqaHUvZ3VEZ0hMZFl1cmlFSHlQRVM1U0Q0?=
 =?utf-8?B?dHRPKzdrM0k0WEhLZFpZL2YzYTN3OE10QWdBbFpxQWRmalJ4emtweUh2YXJx?=
 =?utf-8?B?ajlYZFlBbnU4WkhQaThSWmtsSjdqYU9RV21CL2I5ZW55S2UrSER4aWxYSVFH?=
 =?utf-8?B?YTJ3OXcvVzJ2STl0Wm1BajBkVE5RVWdINTJzK3JSR3krcVFyM3FKQkJIVEtm?=
 =?utf-8?B?N1VOQWc1d0ZyUXlGbFZlL2ExaWh1Y2hmZ3hrMVBQemhZVTlOWVJDanU1Qmc5?=
 =?utf-8?B?MXpiN2M2YnQxaEtLN2VrTHJNdDFob2J6TUpwNW0zbklYTCtUUmh1Z1Z1enNt?=
 =?utf-8?B?QXZ5NkkvUk5pb1RIclBaK0pYbStZNHBXbmhYMUFsbnE2Q3g3L3JwYzZ4TlJT?=
 =?utf-8?B?d0hmL2dNczhhblF5eEhPT1owTEZSS1RxWEFHTnhEN1Q4UE00MnZucEFFR0Fk?=
 =?utf-8?B?UG9CQTNhV2JNUTZNU0NqZWF3RHI2YmFmejJzTjJjcWlnSnZSVU11NHAyaFgv?=
 =?utf-8?B?QnM1UUh6Z0MwQ1lOTEdsenVZWUF2Qkc1eE9YSUxDUlBlOUFxZWprSzJ5cmY1?=
 =?utf-8?B?V3V6empIUk8wdlRrNjZPQndVNldjSDhZZCsveGtJWktnKzhwWXNYWHphZ3Vi?=
 =?utf-8?B?NEFwaEw3bU1Gay9ZWGNodE1hRVRsNVFScytFN2pxSmU1UTFMUXlBRFF6QVlH?=
 =?utf-8?B?cjVKMFFNZm1nSG5QOU1xRy9nWVl6TmFaelAxdlJEVVhjYmg5MzZPV0V5N2VL?=
 =?utf-8?B?dy9iQnd1UU1iRUVleXZxV05oRElsZXRpSVZaTy9NOGl4U0pZTDRYQnl4S2I1?=
 =?utf-8?B?V0FSY0pMTHczSG81ZjFjaXVoZUwwUWRwSWRadkJtNDB2TlI4UFJNdklra3h5?=
 =?utf-8?B?dXlHdHg1M3JZV1V1L1orVVhxOUJsMTJpY1lkR3Awc2JCSkxLb05CV1MxSndI?=
 =?utf-8?B?aUJFK3lWbmdiOUs0cXl6bkwwYmNpTkdDWHBxZ0k2eTVEYURlWHJyejNLbEtt?=
 =?utf-8?B?ZytkM3NwQWRsckxHTUtzb0tYUDZBL1BWWnNLZWc3a0JTK2dOQ0l2ZHBlekhW?=
 =?utf-8?B?dmVaUHRJMU1FTTlhSENKUGJmRWp2OHVmOEVMRndZblpMbEdaQi9qZ2FabFFE?=
 =?utf-8?B?SkJHa01PM1A5Wmg1ajNpaERvc29HaEJuZmhNd0xGWVlIMk9LSzJnL3N6NzZL?=
 =?utf-8?B?dEtsZ3FrVWFhZGMrcjBDdDJvL3E4Q3dEMXBjVGdaL0ZDQTdOOS8yVkcxNVg2?=
 =?utf-8?B?WDJSMy9GbUg0M1BGTmRXTXZFQXdJdStRMnFDUDYzeTdWUUVtYWhaUEl5Uzk4?=
 =?utf-8?B?dnJyV0hMblJHS3Zia2JUNmloVDc4aTB3Um1lUnVES0VuTk5Xb2JtcGtlYml1?=
 =?utf-8?B?NUJ6dCt5bGxoZEc3TkJjSUtKYWpGOUdWTEdGcEVlRndIb2VEMDdSd25VUlU2?=
 =?utf-8?B?bUJ6Q1NhbXZXS2kyUVVhMVMwYVhqMDlWYnNiL1QxMGhTSGsyVDYxRnFsQmpv?=
 =?utf-8?B?NnJKTi9WZS9HcGxCM29QdE9oSTJ4eVJ3KzIxZGpTakp1U1lwVEZjMCszWHN5?=
 =?utf-8?B?bjQzd0EyV28rdHcxbDVRVnYyNFFaN3cweGZDamVTZEJnOTZBZHo0N2pQMVdE?=
 =?utf-8?B?ZW1lYkZqSnNDWUxKcGVRZmpUZFpORzlHMy9CSzk1dmg3Snl5OWtZMUtnWlBs?=
 =?utf-8?B?Ylk4RGJFYUlYR3RKakkxNHFwdjdncDVFLzhDcEF5UDVEaWF1ZU1PL3FBSjh0?=
 =?utf-8?B?QTF4SjBvZkdSTld5dmVYdXBIWTZpYm41ektpV0dLZmxJQ1U4WXhodVU3dTlV?=
 =?utf-8?B?d05PT3k3dUZhU3dxbHhIS0tBMk1kUnNiTWlSMHdWdE5pK2V4R1g1cFdnV0hG?=
 =?utf-8?B?YTNLS3pqalY1K3lPdk9WL3IrTWk4L0J0eEovbHdpMGtKa0ZKR1VuSWo3bVll?=
 =?utf-8?Q?mXaQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa50b0a5-7126-44bb-b514-08dd3bb6324b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 13:59:47.2669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIqI9zR186QqvO9kj8v6YW0mVVuCFAT3msm6yxCvPydBeiL0zx7syOxk6mmdBAw/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8307

On Wed, Jan 22, 2025 at 03:59:11PM +0100, Christian König wrote:
> > > For example we have cases with multiple devices are in the same IOMMU domain
> > > and re-using their DMA address mappings.
> > IMHO this is just another flavour of "private" address flow between
> > two cooperating drivers.
> 
> Well that's the point. The inporter is not cooperating here.

If the private address relies on a shared iommu_domain controlled by
the driver, then yes, the importer MUST be cooperating. For instance,
if you send the same private address into RDMA it will explode because
it doesn't have any notion of shared iommu_domain mappings, and it
certainly doesn't setup any such shared domains.

> The importer doesn't have the slightest idea that he is sharing it's DMA
> addresses with the exporter.

Of course it does. The importer driver would have had to explicitly
set this up! The normal kernel behavior is that all drivers get
private iommu_domains controled by the DMA API. If your driver is
doing something else *it did it deliberately*.

Some of that mess in tegra host1x around this area is not well
structured, it should not be implicitly setting up domains for
drivers. It is old code that hasn't been updated to use the new iommu
subsystem approach for driver controled non-DMA API domains.

The new iommu architecture has the probing driver disable the DMA API
and can then manipulate its iommu domain however it likes, safely. Ie
the probing driver is aware and particiapting in disabling the DMA
API.

Again, either you are using the DMA API and you work in generic ways
with generic devices or it is "private" and only co-operating drivers
can interwork with private addresses. A private address must not ever
be sent to a DMA API using driver and vice versa.

IMHO this is an important architecture point and why Christoph was
frowning on abusing dma_addr_t to represent things that did NOT come
out of the DMA API.

> We have a very limited number of exporters and a lot of different importers.
> So having complexity in the exporter instead of the importer is absolutely
> beneficial.

Isn't every DRM driver both an importer and exporter? That is what I
was expecting at least..

> I still strongly think that the exporter should talk with the DMA API to
> setup the access path for the importer and *not* the importer directly.

It is contrary to the design of the new API which wants to co-optimize
mapping and HW setup together as one unit.

For instance in RDMA we want to hint and control the way the IOMMU
mapping works in the DMA API to optimize the RDMA HW side. I can't do
those optimizations if I'm not in control of the mapping.

The same is probably true on the GPU side too, you want IOVAs that
have tidy alignment with your PTE structure, but only the importer
understands its own HW to make the correct hints to the DMA API.

Jason

