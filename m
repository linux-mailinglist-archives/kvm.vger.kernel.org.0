Return-Path: <kvm+bounces-62734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 033D6C4C7B9
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 09:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E77754E7E62
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 08:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EAD92F12BB;
	Tue, 11 Nov 2025 08:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="frNFVAsH"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012059.outbound.protection.outlook.com [52.101.53.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B25A2561AE;
	Tue, 11 Nov 2025 08:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762851281; cv=fail; b=eQ6R3LJm6mfgPGAeGVp27Z74cJIv355KAJ8DAqNp4p0/nflzTo6R1cirriVeCeeBU1r41IluOwflHgGPJJD/O6awePy3s5Uh5AGKtpcu5gJGJnxqyc9qHcu6OScVx1EuJ6XPIdv16RA+16fMJjvcUeAEBigXVPKKuZ/+SMPrXTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762851281; c=relaxed/simple;
	bh=X9YPVRbu6MN3ha7CkEktdJrBueThlQ/GjNPgpUBa49w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rHpsm6pRYTjPSN35lmleR2ahZt7aFneQY8sm+B3xjYObo35Hn08MwijLHPxCzsB68hsunoJJ3MS7MOXPYrCcn5rietgn75nqvN25btDC8pT5MQwg4JA78ceLQOpXUFg9kkU6kMr4lOlki97eo9Jf8VoQrenZMNn3464jveemwMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=frNFVAsH; arc=fail smtp.client-ip=52.101.53.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vop6QVVseuXAixFOBHWnFKK1zkLiC+bhbBa/CC1w3sZVVx27edoyE1pPqDCZukv/bzFYysSmSVVSEKfM/x3rii7ub89YKWbUJi76IUbW/mPAbQJTHtgzwPNwlMAQdP/v4PTtF8Nwq+l0Y74Bv62AcTnq7sOgdV2q98Wg8D0/yTX0f+KkZhLacP2rucUndOJcEYIEi5cu2osG1+IK9VXNWyy40aQMPag0a8AxqMm1h0UoejUhiCf/uQ2JYU/Kgev8jBZbckXcceFSOtjiwTg1aM8jh686WD8PIuk5nfZ60qHfjsxt9Z8FJb+POFOh+yyB1HgXzhLEV9Se5qCOMks8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HSogeOULgjGakdGeJwHGr8EhkaVo60j5NpyI2a4FrY=;
 b=ZGFPlv0PwyE8A+sDkJmoOyZ/61n+Xr7YjgssOiva8Dj2fTwPPWmx8zq2RYVSIObrIWIh4kdTXNwvgphFw1cSbvAmERkMy2O5JuOPAoQT8lw+pWY3+uKO8HplV/7hXshiFIcV30A8zGOrVW8b+XjQ72nv4VT+CtXz3DcuqsNx7H7gyA9AdhHsimfb8b3AgHeEHiL21uZIgrwKCSjQRoup6DoU/ETH66VEc/LnrB3hnYILqHeORMRHxD0BSkRJExHUB7THBIkPab9CnPDenQ06Q3GPb78rjcQhW/Gpk5ggeLT3ol3N/aaL/09qsJsB6YRsAq+2V8akwcFZg7fVYOIeaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HSogeOULgjGakdGeJwHGr8EhkaVo60j5NpyI2a4FrY=;
 b=frNFVAsH/5ef2g+Ws2MZ2xlI1LHfYCFZWJ+2RBaodRGFZePFdm6SXrF96nifwxrgiMydEDK4OJEZ26e9hgaQPiAbECZxlmZ13GLd9CGmz3M+uSw3JkrNSjNtMuYssj0G3CmQpROsfS4ZXD3jRPGolCDfZghQgkpDvxs/IKnN/oY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SJ0PR12MB6926.namprd12.prod.outlook.com (2603:10b6:a03:485::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 08:54:35 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 08:54:35 +0000
Message-ID: <da399efa-ad5b-4bdc-964d-b6cc4a4fc55d@amd.com>
Date: Tue, 11 Nov 2025 09:54:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
To: Alex Williamson <alex@shazbot.org>, Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
 Nicolin Chen <nicolinc@nvidia.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251110134218.5e399b0f.alex@shazbot.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20251110134218.5e399b0f.alex@shazbot.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:408:ee::23) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SJ0PR12MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 2970022c-20fe-4232-9e4a-08de20fff017
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXg3aVdoaU43RWp1WGFnRG1jYS93OUwxKzZtT3dPNHVTU0JvM09ZRCtNUS9n?=
 =?utf-8?B?cDVuUHNaZkgvRlBEeWlHOUVQZlhvMFF5c0ZwWHFGZW80NkpRL3JXcEVXOHAv?=
 =?utf-8?B?ZmFoQkphTk9PV1Y4NHNKNTJhbWJSalo2bTlJbFNvbkZNSTM5TC96bDVma1Vp?=
 =?utf-8?B?Vi9oK0FSMUsvWGxnY3Q0WlFhUkZ0UE1jWEhEbWU5cUNvVEs2ZFU3Z0RGZG0x?=
 =?utf-8?B?Sng4YlZCU253YnpsM25HcTFKbjdGZGdORmkya25uR1hRRWJxNUR0bFRzYkF2?=
 =?utf-8?B?Z2dJSFlUQnZkbktaNTFlNjE2R0svTHBYS3VQVlB4Z2wzbWlnTGN5dURIOGN4?=
 =?utf-8?B?YitRYjR1b1lNVDJFR0lacmhzcitVZHpsVHQ0RjlmS2lNekZLaFRDcThWb1BZ?=
 =?utf-8?B?ZFBMYTlyK0ZCcGtGUW41V0hxNms1TERuN2gyejJ6aG1ZdFphclJ3UkpHVk9x?=
 =?utf-8?B?TnNYMklwQTBWNzhzUnc2QWY0blJKdVF2L05USmlqN1FkN0plc3JlOUVJcEhO?=
 =?utf-8?B?d01BNUtybElOdWdIbzRJRldTL1d6eDJMTStvRHJiUlBMS3pUQUFKdEtlaVJv?=
 =?utf-8?B?RElsZjBweGhTOWQ4Qi9rNFdsbVZLSlczV2dSOXZUZThtNUFKMklhTlh2QWxw?=
 =?utf-8?B?ZXlBL2tubU9RR1hIQldsYmZvUk1NU0xCUERsaEhyMWVNRzlLUGl2WU1wdXcr?=
 =?utf-8?B?NHpLYzRGSGlqQ3hXSmhyNVNDRi9xZXo5dSsyV0FGUFREakVNZG91UDFHKzJz?=
 =?utf-8?B?blFmQktsMTd0a1o1MXI2RllGc0U5K1dWdEFMME1rY2FqRFk4Yld5bVhROHM0?=
 =?utf-8?B?aXdKNFhZRE9wVXArL2FQT1M0TXI1NWM1SzlBYkJoUTNtSE9yVHpmQU8ra0Zp?=
 =?utf-8?B?aFNhYkVyWDU4WXlncWRMTGdOdkVZc24zZng4ZitFbytjM2RiQUxabUdRcmdB?=
 =?utf-8?B?ZWlrSlI0bUVodW5SKzhBMnVZQTRodTZZM3NkajRXSEpyaVJxMFY2ZkpYd0Vn?=
 =?utf-8?B?K3dWa3dnVExjVmtKSDhhdmZVajgxNUVYQms0bzJ4TDlNdDNvWlZwWFFoWmtF?=
 =?utf-8?B?NnZSem5ScVRtZy9ycW8vVUVFelM3R0lpNkpmYW9LWFNEQk5DMWJRa1dVN3Q2?=
 =?utf-8?B?OU9UNEhraTBBaVdUeFd2VTl2Vi9yajdZZm5wQSs3RFYwcHFwSjBRSCtoY3BR?=
 =?utf-8?B?WHVDSlRiaGRQQ25zRmRzeVJ6dWZUamtRc1huVkJtMGovZUtaL21MaVlmYnhR?=
 =?utf-8?B?UnBXT3ppazF5Q0Y5enlaK0dSWUI5RE11SnQ5dW5wTllveXVpRmIyVldJUDBz?=
 =?utf-8?B?UExHY0VoTkpSbkV2ZmFwQzk1SnVxenZoQ1RvT3JiWXJIZGl3Y2FpbUJvajJ0?=
 =?utf-8?B?bjgrdUxIZkFXQ1J0S1hQOSt0cS9HUGZkbUJMN21lUmk5UTF6V2t6dWhrYlZt?=
 =?utf-8?B?aWFWcG5OVUw5YTBPNENEVG1yWDNrZDI2UXV4MHlEc0o2MzM0ZlprSGFaMUgy?=
 =?utf-8?B?VGs5b05MMTFZOWRlYzJNTTBTR2N1OHpqczEwbFp6dU45SG10cTlZdDVDQ1N1?=
 =?utf-8?B?bEVyMUJoSnQvbVhmcEpuMEVpclErbUNsM0RKcGI1RlJzT3FPaXMzRTFUNzB3?=
 =?utf-8?B?MnlwSFlpMlZJUkJtQmRNZkZzNUs5bWFUZEZRU1VNamZkQmh6eUIwWXdPeTN0?=
 =?utf-8?B?eVBvSDFhRFNFZlVxS1ZENkNBbkM1MzFyaDlJb1l0cXVZNStHRDhXVGU4WlZX?=
 =?utf-8?B?QzZEZjNtRm51cDJ2dHBVTTh4cmVRTVBQK05YeFB6TTgzYytWRmVOMmcxd0h4?=
 =?utf-8?B?YmVIaDJabWlacEU1MnBnTENDbmtFZ3o1MUpXdGpHN00rekdJYnA3MG1ENTRM?=
 =?utf-8?B?aW9oeTFESHpKZkM5NUd5eUdmOWFiNjNzVE5YaEJDRTgrQUl6TUxYZkptZFFw?=
 =?utf-8?Q?qp3koc+mPao3o/Bk8RHIDpLXbwnYyzRQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUpXRWgxK1FhaTZ2MEpBNXlvVndCeGs5ditHbGNJZEJ1YTA1TWg1Z1VKa0l3?=
 =?utf-8?B?bTBpeE44dkZLNGpHL0sySm0yTzJyQWxwOFl2MHhjQWJVV0xKWHlEa2YxQ3Rr?=
 =?utf-8?B?ZmYrWU9GRk1LM2NtK0lvUGJHakZ5T1dhQnNGN1pTeGZtYWNXL3k5R1l6OU1q?=
 =?utf-8?B?NVpaRmdOcjlkSDBYZmlYMkRTdlZoUW91NzNHNStUZjVtUG1pS21NMVhxeGd4?=
 =?utf-8?B?VnMxY1lzYkE4Vm5SSTdEQUt6eDRFcGQrUXJnbmdTZEFiaWg1aWlpQnNqbjBj?=
 =?utf-8?B?dnNQLzRIUVZkbVdrR3FiTmx3NWFzaCs2cGhIU1o5UC9aVDV2Sk4vaUs4UHBD?=
 =?utf-8?B?R3J2RVVNcU8yU1JQdFJUNVhRbWN1TTlaNzExbENPRE1TcFQ2OFgyZ0ZCeFpD?=
 =?utf-8?B?elBleTBhUXAzcWYvM2tzME5laEdFVzFRc0NvekkwY2JUSXpzVUJQKytwWXZW?=
 =?utf-8?B?ZkZ4KzFYbnNHSUxTWEd5ejFmcjZmR09ReG1xLzZLdkFkUDVPOTBWZUhUdHNr?=
 =?utf-8?B?d3NCRldFeVVqamg3NWJTM2taRFUzblVXR281NmE3TTltd1JmOG42UEtDVmpy?=
 =?utf-8?B?ckVjSFEvNVErVmVrUzMvaUV3Q2lOVkpWUldCMFh0LzMyQytlZkE1Tk12cEdI?=
 =?utf-8?B?bmxiZmljM2JwelRKdDZhdDY3SGxmT0dGQS91VDF3cFRXdDR6cjRTeDlnb21v?=
 =?utf-8?B?bmR4RTN5cmdic1VSTStTZmZrVFBXYk9rSkJEU1Rsc3VETys1bDdHQ1R5Zkdn?=
 =?utf-8?B?aWtjTFczWnBlVG4vV2dTZEd2d2VZN1VMYU9XcDNxSTdDKzEzTVNJMXFKeFA0?=
 =?utf-8?B?cnptQ3RXektnbVJ5N29jSjc4anJQN3hjRXJmUnArNVZFSFRpWURwM0phQk9W?=
 =?utf-8?B?QTFBWC9DbHNZQjk0aGxGdEF2V2o0SVJFekZRUWtVRWJESzVhSXBDb2RtaEk5?=
 =?utf-8?B?emR2cy94Mm5KcUxoQUROREtZYVNCOWMreGswM1ZiUVJ1RDQ2TGNGT011OEJr?=
 =?utf-8?B?M1B1NjAvMmhHbnlwUUxiM2tKcTJDYkxMVXNjZFhWWFJIOFBVd0FMUit0bzR5?=
 =?utf-8?B?U0phdXRqYkNraVZOb0g5QzRFSlNTb2tndnhJWlNaalhESFcyZS9CRnlTSkdi?=
 =?utf-8?B?SFJqUTE5NmVCLy9kN0FjOWFTY3NFU2Q2NjBBZ1VFcklKRUJoTkxRQkVvdGV4?=
 =?utf-8?B?Q2VCS1ZTOEVXbERsZy9zSnNFTXFsVWM3dEx5S0J4NGVCZDFuTkdYSzdjcTBS?=
 =?utf-8?B?ckpBREsxQ1cwc0RtdHRaMVdJcmw3b0hKZnZManZRV2g0Q1dZOFVubzUzRFRC?=
 =?utf-8?B?WE1kcWxXRmJiV2NIdjhGcURodnJJSjJvcWhmakQ3ZUdSUE9QZ3MrTWZWMm5a?=
 =?utf-8?B?TGtvMGhRaUJMK29GZkpOaUlVSjZUZlc4UUE3eUVNTkZPbHdFTlNPdk1vU0du?=
 =?utf-8?B?S1BUUFRkVGVaSnQ3cmFsWGY1b0VDamw0UlZ4ZDEzNFdGYzA5Sk5SWGRaNndz?=
 =?utf-8?B?N2lYZ0xPRCtLTXliTHg3SFRZMmkxcDc0bjY5VVkrTmdsZHVwQUFRUXdEM29a?=
 =?utf-8?B?cUFucHlTN2RrUW5icStwS2hYUnRqVU53L1VoazgxbWtqY2tDL1F4NDJhUm5P?=
 =?utf-8?B?U0NlTWo0OC83UCs5S1VDR1NyVnU4eERINFpuNHVmUENkNTN5dXNYV3g3Zkt4?=
 =?utf-8?B?c3VHdGhJZytHcGYvR3V1N2thNHN6elowQU5pN200Sk4xY3pZSGk3ZEgyZ05R?=
 =?utf-8?B?OWFwVHlPNTZTdWJqNk5mVzJvZnRyK0had0Y0M3lpQ3FIWGgycmFFYXV1NFZU?=
 =?utf-8?B?K2Jub203VDVRZko5bkVIekhId0kvTE9WQTF5NXVEbDNEVGxNMlJpWm9XN21E?=
 =?utf-8?B?Z29hcGhIWk5SR0F1ZXRaVXJVQWJoVVFDRFdhajA1WFFwVGNSelVrdnhRR1Rr?=
 =?utf-8?B?d05PNm95MmkwNG9QYXI2ankwUDVrTG8zT0J0T2RtSC9mL1RZZUgwOFF6WVoz?=
 =?utf-8?B?S1V5MmUxKzJ5aDE1Q1BJazhFNmJxbi9vMkVxTUFUaGFHM3dlSTRkMm12SEZs?=
 =?utf-8?B?QTVpcko1N0hISjVoNFZDWmFpMWV6Umt3Z0QzVWNCdVpGVWFYa1lrRlVCaTRx?=
 =?utf-8?Q?M4cHLK3S5fcCTIX3vVT9PlA7u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2970022c-20fe-4232-9e4a-08de20fff017
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 08:54:35.2332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKHCWtDSyozt2GeTwZxTq5E0sJys9jWMYJp6opGv8Kq5WBAjVMM9o4xTBnv/HjoB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6926

On 11/10/25 21:42, Alex Williamson wrote:
> On Thu,  6 Nov 2025 16:16:45 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> 
>> Changelog:
>> v7:
>>  * Dropped restore_revoke flag and added vfio_pci_dma_buf_move
>>    to reverse loop.
>>  * Fixed spelling errors in documentation patch.
>>  * Rebased on top of v6.18-rc3.
>>  * Added include to stddef.h to vfio.h, to keep uapi header file independent.
> 
> I think we're winding down on review comments.  It'd be great to get
> p2pdma and dma-buf acks on this series.  Otherwise it's been posted
> enough that we'll assume no objections.  Thanks,

Already have it on my TODO list to take a closer look, but no idea when that will be.

This patch set is on place 4 or 5 on a rather long list of stuff to review/finish.

Christian.

> 
> Alex


