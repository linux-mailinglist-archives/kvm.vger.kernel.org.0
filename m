Return-Path: <kvm+bounces-57605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE0DB583AE
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 19:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A5D81AA3D39
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670F2285C91;
	Mon, 15 Sep 2025 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tYfRBB2j"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013026.outbound.protection.outlook.com [40.107.201.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714CC2288EE;
	Mon, 15 Sep 2025 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957553; cv=fail; b=FpuHI0zNgaQJcLjWi49soPkYDYJjqKqR7R3JlrlXm/XBJit10X+lMO2oeobo6SIaWK1jZtAovxb4dad5z5ptHMvhXjNiqrZEI21yCpC4vPMoOVsHPF8wY6iTO/sUOEyxRIXpbCWfpfptz0UGSpiYP2nUflwAF4TudvaFztoQDN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957553; c=relaxed/simple;
	bh=ZfnjohK2MKgMkfLkXgXBFhOVb2PTJDFXjKGrRQ16NQE=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=oNFZBxBEQCDY2VqCeNbUnOM5NqRrEtzaqxdFfpBCpU+sBx39Y0MI+tum0ogy47TDhOvDSe2pvroPzCfcwj3kZknQgnPbPhn/CipA+CkjsArlxt7PIGMel92ns+d+6rnGNxaHBydsJlePJrvJzCsSS0imqCr4z210SAkHlgq3a38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tYfRBB2j; arc=fail smtp.client-ip=40.107.201.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moDTPTAlPm2eAUag4bWOC8VHhDIz7fkMgnuOkU+16P4A62Bpkx/88/K14YkOEWLkg1rKURJE0umq/yjaHHnvPGxSqYIfDZ2w/uL8LIVAz1RBQ8iuun1pAxUx2eJhD9gLzjcQc0TWexNqnp3vQ+hfB0V+AF8PyXBD6AcCbgn0cdPRwi3p7bQsv1ZsIbtkitp1eaGBmiRpZKLRk8JC8JG7gHqqj6+CSELn9GHvqz0XnwCJg68vpaiUUcxxckzKYFPguIjOJZNtm3IdJ8HVJVhiNcfpYFgp1VFyExRH9Ce5rGM46KanQ6jfRag5EwE8xGLHE5BqcLrxJpr3m0apAlkL0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVn4pnBxT8LPMiIwtHF/3ayTqYkF9tZeZ9nUGRAk8e4=;
 b=EjJBTkXtlUFbYKG9FzZwywTOX4PsqXNtlv1aIb8Ta+hHcI7R3HFYbF+cexbJ42RWr6ZrDJ2QKUQYT8m9K7GYinnucwjjt/mpGPDEQkC+/vzP71ymCL0084cm2w+mB9MQKmwuR+3g7xIEU4IVHg6+aN2kPGXVXKKavB27S1gCfGXdr11hx0zxVayHvnPYwIAYgvADLUHhFGd235OK7t430uOsnY7cM1kipVwLVnmiJZUMkIx/tw/iDZl+s++hBxHeEvYwj+Htva0bTwGWmtcENlNXMJA+j7kut5XI8jZo3p3l+UGa9lRAeV5LIjGLrLXgvuNlNXg+Bk2NH+CCmAyzGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVn4pnBxT8LPMiIwtHF/3ayTqYkF9tZeZ9nUGRAk8e4=;
 b=tYfRBB2j4Gy0KIA5wT9LBgCq6d8xn6lFUOOnZxDEHjEQnOw2Nm8BIsw/QRuZ9TQf9eWTB4sKBRXNCJ3yWPkYvWk3f5AUiZz4jy1OZ4hp7wz5/TkFtVziYWIsLbeW/u3jypcGG+8wIxBH3jrBL5Mq9GoPa0ADlXvei1jbMagDNi4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY3PR12MB9679.namprd12.prod.outlook.com (2603:10b6:930:100::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 17:32:29 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 17:32:29 +0000
Message-ID: <43b841ed-a5c3-4f65-9c7e-0c09f15cce3f@amd.com>
Date: Mon, 15 Sep 2025 12:32:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-3-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v15 02/41] KVM: SEV: Read save fields from GHCB exactly
 once
In-Reply-To: <20250912232319.429659-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS2PEPF00004566.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::508) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY3PR12MB9679:EE_
X-MS-Office365-Filtering-Correlation-Id: e461ed65-e218-42ee-906d-08ddf47dd7a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHN2dTJ0ZlEyeCtWNnM0ZDl4eHZTWDl5VkVPalNJaUFuRnkyZWd0dWIrUVdr?=
 =?utf-8?B?bVcyWFVyejhYSG90Z2lVT2FVN0N0N1llT3crcjZNYktUVWNBWk5JblNBSGZm?=
 =?utf-8?B?QzRJaXVOYzNWUjVWZVg3ak1TdUFZWjFzUTBZUmM2UVNOUEkyekJUbUQ1MkVW?=
 =?utf-8?B?V1F3SUhSZlZuU2VxNEhSN2tBZ0tXT3QySGxtRjBUNkMvZFVXUkljcy9yZnlz?=
 =?utf-8?B?cmxQWUM0UEVjaUhqbkhZa0UyNXo3dE50cmw5YjIyZEI0WW1FeHN3MnZ1ampG?=
 =?utf-8?B?NXFadTdmN3pTb2g0a0o3WFVxYm9RTEo0Y2JuM2JBc3ljUWx1TWRCSXliVzdY?=
 =?utf-8?B?VDAwazMwNG03YTIwYnhHWFYzaDFQaG9LdllqS2c4dlAzZzA3WDJJN0llWWFP?=
 =?utf-8?B?Q0w3a2lmM2JORGd4TG5DMHEyYWdOditKYUYrSndsa2tYbFFzaUtRNDdDTDdy?=
 =?utf-8?B?TXNZUkkxckR4a2dXOVkzSjRiWXE2VWZjT21lbEhTVVhuNGlyaDhqN2lhK1I5?=
 =?utf-8?B?VGdWMGtXT2daZkhQaHNDYllQcHBBZEU1Wjc2cHJyQ0JMTURoQ1VBVTE5cG11?=
 =?utf-8?B?TWVleVdkRGNUS0ZGY0ZReTlZMWVPLys0ZDk4a2VNOFJKL09oZndUa0llN0w2?=
 =?utf-8?B?OGNFaXU4bHBxQVFNNjlqUXlEQ0pvRVRtcHc0b05iVkRMeTZSclVTNkJERUN6?=
 =?utf-8?B?aDh3VjYrWENTTjM1NVE1ejdlbG5WeUdtc0IxY0pLT1BCVXJCNUwwaUdRZk5V?=
 =?utf-8?B?RzF2R2tYU25qRkt5dmc3QjE5UW5aM0RiMHFBVjd5QkhnTjFBYXlEM1dzMThR?=
 =?utf-8?B?cCtveEV2VXN5YUFRYVlTWlFEVjc2RzcweEM1dFd3clRJb0NRbzZSR0M4MnlM?=
 =?utf-8?B?VVEvclErQzU1WnlHVFRkekFPaDlPVmlVbVNKSGM0WnFld1Rpa0RKdjFjR2FD?=
 =?utf-8?B?VktMcVYzc00vZWJTM3l0SHpWQjd4MXBwNC85VVJKTmNLbThydFFZNC9oMmtG?=
 =?utf-8?B?U0ZTdzJ3VkNuc1puamZac1liQ2syQzQ5OEg0K09VREhLNk5KY2FHVlVsaEpN?=
 =?utf-8?B?Z0NuMU1uc1FONXhPTUEycXRmSVJDeDEwNkJ2ZGxUOE5wcUpKV25Hdk9XTnFS?=
 =?utf-8?B?YmhCKzVIby9VM0F6UFRQcHVwWi9pQW03UDI3R3ZBMWRLZUlqVlZVWXJORnhm?=
 =?utf-8?B?bEw3UVJ2M3lQOEpRMEp3bkZZeHdncmY3TXRURk13ZjJXT094aFpxdUJlOFZp?=
 =?utf-8?B?UVFJNDFhUVVIWFdWcXhVVkIraFQyQ2RsNXd4YUpPYmM3ZnVtZHhkS1Mvc3NG?=
 =?utf-8?B?cGMzTGtYcG9TOFZYbVpxWWFNTW8xTnB6TGZNTk5lN0dUOWVxZ3VWQUFuV29T?=
 =?utf-8?B?VFUzZExiZlpKYjd3VjVyOU1ZT0RCVi8xWkRMN0pTT2xFTGMvWkZPcmFESTUr?=
 =?utf-8?B?K0txeDNrQ0YzdUZNcDUvNVh6SVQrbTBINXc1WEtyaDduNi9VOHg0YmxaRmdi?=
 =?utf-8?B?bGdhSlF0WVJBT0dTdHZrSnRYSHoxWW5NcG1xeENhOVVxVkhickRxdlQzb0JK?=
 =?utf-8?B?NHFlc1l6eWJEMlJkZWw1NFdsZ1BBMFhKajZ2Wlg1TVpVcFp4elBBMUR4cWVT?=
 =?utf-8?B?ZHc4bmZ1WVRyZHp0L0lVL1JrdGlSQkRFUjBRZkh5b2lwV0ovMGdmSk5BeVMw?=
 =?utf-8?B?U20yQ0h5NnpBM0hTa094cjFveVM5TGxaUDd4SDRzVnUyRDUxclBHeUx2N0RC?=
 =?utf-8?B?RWFEVUdWalA0QUdvY0Q5NWNxUkVMRkZkTVdNQ3NaWWdlTVFEN0kvSCt1T0ta?=
 =?utf-8?B?Ym82Q0prQWtNTzJhQzgrbWZoSWkyTFpld2RSM3FjdDh6MGRiNTA3M2kzajRG?=
 =?utf-8?B?bmJodHA1cnRXVXc4dkoyZGxhQVZnamdUZXJGWE9pRmtsTUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGJtK1dmK0VzSXVmZmNBZUFGaXc0L3FtNTBQRlBSS28yd2psQ2FXN3BlUDRL?=
 =?utf-8?B?TkpmaU5QSE1rNlFseGxRSFE5UXFkb3dVbnlNT1lkL0VXTDdHcW9lbENHZk1a?=
 =?utf-8?B?UlJ6NGxyVGpkbDF5V1RtaDZrQm5CQWZaQWVQdGN1ZHJkLzJDWmk1NGNQc3ZM?=
 =?utf-8?B?d1ZzRExTMWJxc0hrSUpVUytMUnBpdnhqbnIzdjFtWHFJcVF6azNObmpiTDBR?=
 =?utf-8?B?US9kQzVlL1BTVVVaaE1LMEpBOXF3Snd0b0hxMDRkYXNlQ3NJVC80d1IyY0ZE?=
 =?utf-8?B?SHYxSHBiZUpuaGdYUURhbDQzUVlad05IR1FkNHIrK2xGaVE3NVBrZEhrRC9n?=
 =?utf-8?B?dGZBbVMyVlh4cWVieEJkQlNWUWRaTGphclc0d2YxSytpWVYxRkgyMHZ1RUxi?=
 =?utf-8?B?dEN5VW9kenNDdnJjdjE2Q1ZEWk5aYmUrZHk4UFAvQVlreXBBVTJYb2ZJRytl?=
 =?utf-8?B?TDhvQXJUNkh0ZTlvZnpOclZHNVVzV2FLNnVSYUJuU3R6QjdaUVJxZEY5eU9I?=
 =?utf-8?B?TlZrRFBlWktOazltTEhEV3lsbW9GcTJ4c0RLSHNDTHZFLzVsdDRkdkNvenhS?=
 =?utf-8?B?RVoxc25QbHMrdXZsWDQ0OEl2OHhxV28rVWpjV3NZZktEMG5RUkIzdkJWaGRL?=
 =?utf-8?B?dC9QdnhUc05hOGhKZlhPOVZ5MUp1bEhhYXZkQS9jeEdDMWxTd3FmVVVzdVZC?=
 =?utf-8?B?NnpRVGVDbmNBVzJxK3l3a3NDQlF4b1IwQUhIb2kvaXhjSDM4V1JYUno3ejRk?=
 =?utf-8?B?bzNZczFXN0dLeThsL3V2Nk83RHFNcmh0cTFNTjVjTlBlT3A1U0ZNbU5HUEc0?=
 =?utf-8?B?NEgvdXU2R1hNekNWNmFxS0pPS1k4cDMzaitUMkEwUnB1SmhSdmRUcTRQRzkv?=
 =?utf-8?B?THFQSFErR0pDMFp6K0NuQzY4VDduS3lLSGdpbDhmdzl4dUJJMzIzQ0RNRzNC?=
 =?utf-8?B?NzJnQXdnT0N1ZWdBVm1wZDhHY0YyckhCNkpKZ0UwL0dUaWxLdGJMTUQzbWxv?=
 =?utf-8?B?Mmd4SHgzRHZHQWx1NDIyWVp2SXkxOXFlcXZYRFdtZHdab1p0Ulo3ZUYrL2dK?=
 =?utf-8?B?d2FiZWZDeEZQT1hqWWRTNisrd2ZFT0IwRXNPRXFHdkhsTnZuZlpiMXJNUm5Z?=
 =?utf-8?B?c3Rnb2NQNUs2cTFsek9BakI1U0xxa3dTbUpIZnVldE9NemR2dER2V2tseG9s?=
 =?utf-8?B?eUhYKzArUGswQ1FQNEl6Sm44blB0S0NGY2JjOXJ2V3FnNTBiNFpYM2hqWUZR?=
 =?utf-8?B?Q1E4cVV5UkNnM1NiNEQwR2YyeFFIbWV1TnBaUTJzUWlKRGNaT0FvYXl2QWp4?=
 =?utf-8?B?Y1V4TlJtU2dacFRBMXlMUGVmZFErRklLbmw5MUZDZFNtaTE4ZlVtUUxnWHRY?=
 =?utf-8?B?aTAzWVVHakZMeTA1eUk3WENFalhENjFBakZTT1BGQkQybUwvVk5oQ0JSUDBi?=
 =?utf-8?B?U2N0b1dTTHVicW9QNkNETWY4VmpsUUpnMHp2Ly91WnNrQXYyaHQ5cjhwWFlE?=
 =?utf-8?B?RmMveldnTVFSRzgxZDk2VThrVndiWGhnNVpIQlNKYVFVMzBTekF2WGxVTmo0?=
 =?utf-8?B?ZkUrQU1lTG9IMUdmZ29rQUd1T1JlZ0RaNFk1TVVVUzZSNjQyY1I2cVp2WGYy?=
 =?utf-8?B?Y0Q5SlA3dkhVQVFEcE1EdXJ6Zkg0T3k0NkRWNXppT1JnbjRlVUo0OFp4ands?=
 =?utf-8?B?eTM4ZkljWUI3dThVQjlYNnJ4Y3BYS1l0UkEzR0I3SzJRaVp6Uk40SDU4eHk4?=
 =?utf-8?B?WXFmRGFEM0gxSTV0bThJZXUwWTVmU0E1UFovUkx5OHp2YUlRbTJsUU5ydG5I?=
 =?utf-8?B?WWdnMk5YbXE2Y0RhZU1MM1V6L0JwOXFyT0JzME5DRWdPZWt3OWUyNkIrTnFS?=
 =?utf-8?B?TjhqazBrNUUxMEZoMFVWWDlQbC9qSUxNa2dJYUp1eGswbmpTS3d2R0o2Wm5w?=
 =?utf-8?B?Sld0dktYUGt0M1Y4clZXV3FIZmplQ0lJWDduZHlBbFhIMk0rcVlSRWZaSURR?=
 =?utf-8?B?ald5cW0xKzFYblBJRzdyT3MvUlJGQWR0VCtkUUNZSWk3c3ZSeE5nUFYyR29X?=
 =?utf-8?B?OGpOTzd1OHJ1TFVRWGtRbkZiMjZyNVcram91eXE3bENVRlJNbjNncHNjYnU4?=
 =?utf-8?Q?+1JEZpC8/e5AEZHUWoasml8I5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e461ed65-e218-42ee-906d-08ddf47dd7a8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 17:32:29.0558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VRgqewAD8Yc8bDlRGi3K9HWxT/qP9OkYplURb1eWoyuWTSQ2nEp2WZ+NEgj0jijvKixJCQB178X82iKa7cQUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9679

On 9/12/25 18:22, Sean Christopherson wrote:
> Wrap all reads of GHCB save fields with READ_ONCE() via a KVM-specific
> GHCB get() utility to help guard against TOCTOU bugs.  Using READ_ONCE()
> doesn't completely prevent such bugs, e.g. doesn't prevent KVM from
> redoing get() after checking the initial value, but at least addresses
> all potential TOCTOU issues in the current KVM code base.
> 
> Opportunistically reduce the indentation of the macro-defined helpers and
> clean up the alignment.
> 
> Fixes: 4e15a0ddc3ff ("KVM: SEV: snapshot the GHCB before accessing it")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Just wondering if we should make the kvm_ghcb_get_*() routines take just
a struct vcpu_svm routine so that they don't get confused with the
ghcb_get_*() routines? The current uses are just using svm->sev_es.ghcb
to set the ghcb variable that gets used anyway. That way the KVM
versions look specifically like KVM versions.

> ---
>  arch/x86/kvm/svm/sev.c |  8 ++++----
>  arch/x86/kvm/svm/svm.h | 26 ++++++++++++++++----------
>  2 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index fe8d148b76c0..37abbda28685 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3304,16 +3304,16 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
>  
>  	if (kvm_ghcb_xcr0_is_valid(svm)) {
> -		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> +		vcpu->arch.xcr0 = kvm_ghcb_get_xcr0(ghcb);
>  		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  	}
>  
>  	/* Copy the GHCB exit information into the VMCB fields */
> -	exit_code = ghcb_get_sw_exit_code(ghcb);
> +	exit_code = kvm_ghcb_get_sw_exit_code(ghcb);
>  	control->exit_code = lower_32_bits(exit_code);
>  	control->exit_code_hi = upper_32_bits(exit_code);
> -	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
> -	control->exit_info_2 = ghcb_get_sw_exit_info_2(ghcb);
> +	control->exit_info_1 = kvm_ghcb_get_sw_exit_info_1(ghcb);
> +	control->exit_info_2 = kvm_ghcb_get_sw_exit_info_2(ghcb);
>  	svm->sev_es.sw_scratch = kvm_ghcb_get_sw_scratch_if_valid(svm, ghcb);
>  
>  	/* Clear the valid entries fields */
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5d39c0b17988..c2316adde3cc 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -913,16 +913,22 @@ void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted,
>  void __svm_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
>  
>  #define DEFINE_KVM_GHCB_ACCESSORS(field)						\
> -	static __always_inline bool kvm_ghcb_##field##_is_valid(const struct vcpu_svm *svm) \
> -	{									\
> -		return test_bit(GHCB_BITMAP_IDX(field),				\
> -				(unsigned long *)&svm->sev_es.valid_bitmap);	\
> -	}									\
> -										\
> -	static __always_inline u64 kvm_ghcb_get_##field##_if_valid(struct vcpu_svm *svm, struct ghcb *ghcb) \
> -	{									\
> -		return kvm_ghcb_##field##_is_valid(svm) ? ghcb->save.field : 0;	\
> -	}									\
> +static __always_inline u64 kvm_ghcb_get_##field(struct ghcb *ghcb)			\
> +{											\
> +	return READ_ONCE(ghcb->save.field);						\
> +}											\
> +											\
> +static __always_inline bool kvm_ghcb_##field##_is_valid(const struct vcpu_svm *svm)	\
> +{											\
> +	return test_bit(GHCB_BITMAP_IDX(field),						\
> +			(unsigned long *)&svm->sev_es.valid_bitmap);			\
> +}											\
> +											\
> +static __always_inline u64 kvm_ghcb_get_##field##_if_valid(struct vcpu_svm *svm,	\
> +							   struct ghcb *ghcb)		\
> +{											\
> +	return kvm_ghcb_##field##_is_valid(svm) ? kvm_ghcb_get_##field(ghcb) : 0;	\
> +}
>  
>  DEFINE_KVM_GHCB_ACCESSORS(cpl)
>  DEFINE_KVM_GHCB_ACCESSORS(rax)

