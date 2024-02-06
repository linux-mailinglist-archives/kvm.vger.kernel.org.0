Return-Path: <kvm+bounces-8164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E332184BFEF
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 23:21:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6695C1F242A5
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52CB1C280;
	Tue,  6 Feb 2024 22:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mFpRVpzJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AB61BF27;
	Tue,  6 Feb 2024 22:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707258090; cv=fail; b=KxwqN1A5NMRYNQw/R/3KbhRtDCf0YDYnQbs4duUXhQIyEuNq/9WcuSySxKRVvPf2tJ2ktywNDRYDM9puj6o8odivuSYKtl4mIEYqyL+UhYWkFWO5zL55k+yRuYcAtg41rP4v1XzICSsppHMk+PnspFSDJyhcnPApfI/9I+7PsYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707258090; c=relaxed/simple;
	bh=arOp72g3xhmyH6a3DCuaQNs8eOrGruxtaAn7LnSVSWI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zg/A/XCDI+wXm6WiTNdwi/6xZ62CHT7qulF+VrbPFL7ElTn1jJZvnKYQ7vQuQ4B6UX6tFYOLSPzngg26wEdHbb9b6OM08/XPxvm9oL2+n4J3Y+jesQTafPDBkwQFiH233L02/V8zJFBZSbnmJL+D99M1n4kLuvcC61A8VgLeHs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mFpRVpzJ; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707258087; x=1738794087;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=arOp72g3xhmyH6a3DCuaQNs8eOrGruxtaAn7LnSVSWI=;
  b=mFpRVpzJhKxkxvTuxbxYitAh22MvpaUivGKTVDa2B+wVL9BsY8Lfy8qN
   n+ZNH07dC0UoMDjPmE85wqDKbTlnpQB7CoXPDrXrbhTS7nM6NOpj8Uo5e
   qS+cgcb9lzcm5iiXpV6wXJOWnNvCdIXl74Lpq3Xp/Cp76Ct3+QV0Jwq48
   JnUC2H87EYhlIlY5ZGL4Snd4G1vse0+cpFn4UfHAbYb9BF/GGSCvUctVv
   uSxx1JakqnSKZ0hOuePiyPYVirMwnqixcZYEN3dCeOOyNpmAYxGubLS+3
   v2E8Y3HMi4pfc5K6rwSaPCPSZ+zjX24fK3o9EI5M6ubjB5dATKQ/gWoER
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="26300906"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="26300906"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 14:21:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="5763535"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 14:21:25 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 14:21:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 14:21:24 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 14:21:24 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 14:21:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NI2apZqj86dg5JS4BPd19ugRSOg/QQrqtxTNRdAnin3qaHmg/vHE/IaS/8RiPemectWF7r5Jq7K3Hi5RVPd+rXEWnlCN5d/V2KkQ4q130YS4sVEP+FDNhMszRKUpdBYrnTiuUlmr/OiIbww1Qg5enMaAhbvwLuPF70Zsy2X5Gw0gGJoSyDkTsRdZbD0//6uRuSloj5T2i8tPbEQocIkdFAjmsHZ+7yPMHKvhSNkFpkZmS5PcY7o8OJrcwjEuoNM+5F/SjrCU4mwY+YvF6gswKhdKW2r0Hwn5wC19zTvv8JFsgbQoJfa3swxrpeNitwFuLmkGrjW5IwqQa12gqdbApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2d7RDyTj+gRcJhZAcOuvqkPiergEdm9Tbjhw3H5BgZU=;
 b=Lhy9ip7amxEC+xa74PuAlNdF0b0fyUV70rXKlXOYiJXf2vcNEibiMZfPQRGTWyUViy4UXvdtMUOSEtBBmic/fGvo3a76Q8UBG1giTfrfcOy0D3mwty+xzLG8N93pvb3P38tSAQwqJaUfvU3yjQNvXzdGlQMVvl/GtHF4nWBk6EjMKdXAwRTDVDmNSC+QPuPch1pMHcwgBC7bzPwHvBSfpYOaFpfL9k95+UtvI8oVeadTbShh2F/nEkGxGwBCBp07Gq3Kd71n6cZuE1eo0PWnGr5SbcBRF+Pu+lHRt4hEbfJQTYsfTSH3/qzk7EGYNImdwuXwIX0RUgWea8PdZzld1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 22:21:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa%7]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 22:21:22 +0000
Message-ID: <73afcdcf-8836-41b9-a3c4-ed4abbf877fd@intel.com>
Date: Tue, 6 Feb 2024 14:21:19 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/17] vfio/pci: Preserve per-interrupt contexts
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1706849424.git.reinette.chatre@intel.com>
 <d6e32e0e7adaf61da39fb6cd2863298b15a2663e.1706849424.git.reinette.chatre@intel.com>
 <20240205153509.333c2c95.alex.williamson@redhat.com>
 <6cef4f69-e19d-4741-9cff-a9485dd58d89@intel.com>
 <20240206150316.66e24a8d.alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240206150316.66e24a8d.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:303:16d::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7925:EE_
X-MS-Office365-Filtering-Correlation-Id: 4db264a8-99f4-425c-3ba5-08dc2761f2d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ktAM+jMdRWDV4367EFI20F3TB3gsYc+tGtkjc/mIFZtaAJZdQLm5LGvvRubBgmVWcb4Tr8zCmmXBZk66bVdRxdkpQ1hSfIxLefFS6tDdkNyYjBOM39kXoIyHvfv5EoSMSJBDOVO9WGkXXq203z/fYz7Yu7oIvM80pvwDdTWp97xJKjwTu+cy7gR2kL31pfT5PepDKvR8/aKb87vYi6hvHafKBiVAdzBAIgiwDe9WEpP0vm8z26liWIoIFgHangGnIoagQg/chDM9xqGWv7lLUhIKU95yg+10pckCgGx9HJvIq4BCiJRiNnZclSK3b9Oyo/lYVLjEZaFsQR8L78VVe7S64vOaieey/IBMechJA6KVJkar3YOBACqZomPioqjx63zZEriot7M4oGHs8MVhPqAraVxwaMCXJWfyh+UZ7b0NvMjkR4oov2JzRK1tKQeCnMxZVxW+eU9EQtJqAPzTnnL8xTPq18VEGFHhzxNzpw+HPniikgdHkq3X1RD7CFI9fsIGvxhyq7coDA1Os1SJ9jzfs/n/NObGYkqJZqm4kxY7m06Dk9Xm5Gs4UMx1u7UpZzJkk9+tQFG3d4zSa6T8wPiJw2/sAUUK4zythoDFvcvfQRMcliLnKoUrvX+b3QnrIMGHt1ZhGPK8vCVOrXSD9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(396003)(136003)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(6666004)(53546011)(6506007)(6486002)(478600001)(83380400001)(26005)(6512007)(2616005)(5660300002)(44832011)(2906002)(66476007)(6916009)(66556008)(316002)(66946007)(38100700002)(8936002)(4326008)(82960400001)(8676002)(36756003)(31686004)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXNMMUxnNy9JeXpTTHBFTStLMitBKzlFRzNzakJiVU4rR0NKTlh6VWF4MDZR?=
 =?utf-8?B?N1cxN3ZHRml2aiszWHc4SFJVU2dRd1FSSGFBallaZitzUlNLKzhGNkpOQk1l?=
 =?utf-8?B?a0lucnBoVzZvMEtrOStqSk9yZzBlMFg0QU8ra1FtY2xXRHk3SGRwc2RWWHRC?=
 =?utf-8?B?Smc3ODlXbVJqajRkZ0xIcVVob0dJUjhIM2psZkIvL1BUckUwZEtUL25lZlc0?=
 =?utf-8?B?R0FEYXlVTjJyL2FBYlg4a0JvcXpvL0lPVHFnc0UzUUhHY0Jpc0VQYWJ2THNy?=
 =?utf-8?B?TzFEM3pLdFRjZlZrQVByakE5cS9mdEtZeXdEZ3pGT01FclZPNTN4ZnBPVXp6?=
 =?utf-8?B?bjB2UExIc3JmV29DQ2EzVi9CVDJTSnUxakJzVGpJdUZncnFvVXZ0SFZWTkxQ?=
 =?utf-8?B?RW5RZDljMHM1NlZDaUxqUDgwVlBOYWthVDIrNENrbER3Qmo2bmFQelJMT2Jx?=
 =?utf-8?B?UDVXdFEzaHI1ZFF1OEsxVkNVckhWTEpBSVcvY3FlT1RZaG84aDhzZGd6TU4y?=
 =?utf-8?B?NDB4WnRueE9pM0J5UEVDUWZDU08xVjZBZUdGcVo1VzZUSmxlQnhETlE1Szcz?=
 =?utf-8?B?VWxrbDZDNFFxbkVaRTV1d09PSi8ybC9UbTdwYTNFNXcwdUwzZW5YdlFBa1pF?=
 =?utf-8?B?SHdrV0xTM2R6QlBNeUtJaW92WFltTkpyYXVqVnBDVndLTU4wRHFpMDBrTkJm?=
 =?utf-8?B?QWJWdEMvaXlUTmFETjRtblpGU2UyeWFmb2x2NTZLMVR5WEpJZjFReERiZmd0?=
 =?utf-8?B?d3dxOTIwcVhuM0pxaUpVaUtFMGpBc3NSenJoTVZtbUNILzZqdjNiSEhCYk5O?=
 =?utf-8?B?anZOMVdGejV1NzBjVWVHVEhoQ0lyVEI3MS9SdDBGQ3VLTXlRZjhMbjlBUHZv?=
 =?utf-8?B?Q1JWV3B2azVtYW5aSmJFcGNJRlZhR2o4bHdVcWhmUGtXK2pLaW53ei9Eck00?=
 =?utf-8?B?TWE4Qnk4bStvUUtxTjE1NUtlVVlMeXk2aU9ETmhBUk41NGN6bHlVSTFqWWFC?=
 =?utf-8?B?NzRIVVpmLzh5bGtJTW11dkk0c3E3V2RnVUFYYU52cTZXNVhxMDNXcDhYaDln?=
 =?utf-8?B?Zm45c2dUcjg2RVBiNER0STJ2TnpKdm85YWROSGpIZHFWRGRiQ2NoaitwWTFT?=
 =?utf-8?B?R3VvaU1WWHdrSVhOQndadVZITUdFYmlDK1J4bWlFY1ZHMWVYTWk5WVVIZVlX?=
 =?utf-8?B?UDU3UGwzdnBqL3Q4Q2NHMjdqc01GWVovRzV3amN4THFWNXNkVlJzT1FWejBV?=
 =?utf-8?B?Ti9CUlJrVXN3cmZ5VitzTzJsSGgwTUU5Q3V1U1FOdFBMZFNiNmYzcHRabWc2?=
 =?utf-8?B?Z3F3cUk4TWxyMkhVd2l5MzViYlVLMnhZNW9SVDh3ZzBkY0E2VElJaGVKSk8v?=
 =?utf-8?B?SUZ5ZXhBNUFkUFVpaXQ5VTdxS3pHdGVOZU5oY0o4Z1I1UUxUTDdkQ013RjZG?=
 =?utf-8?B?UTdOMTFhVStDcnRqZzdXL2ZTNkVJaWlRaGtUS0lpSUM0blU1RmNQa29hNnVO?=
 =?utf-8?B?UFRvUUhhYkNiNTlHcFdYRlMyN1JmN3dDNGxBMWxxOG8rYzRnSVhBSm1qM01R?=
 =?utf-8?B?djU1REpzbVRGRXhFR2VlY3lCc3ZnU1FxSVdhN203bEdYQllmZGlDYjhBY0Vn?=
 =?utf-8?B?c3ZOc1FiTGxHTHFLb3B0ZDdUMEI0eWlNSjIwVnB3c25mV1JOZGFXdk43djhr?=
 =?utf-8?B?cXRIanQyT1F3eWF5ZmFIU256SGM2ZGhNbEJLT1pVSTc5Z1RxeW8xS05KWHJn?=
 =?utf-8?B?TXhzK2RzNERHOHU2Kzh2MHZqQkNNMUQzYXpnc2VVV3FZTmdUaEZOZ29JcThL?=
 =?utf-8?B?RmFjQmFramJLVjVIaFZpUWV1dmcxR2RMVFliNzFJT0dqMVYvTHprUTlpVUdM?=
 =?utf-8?B?V0paaUl1L3ZWekZ6TlEyOVF3ZlN0eUF2K1ZWT1hscFJ4SmppMW0wSGJGeVAw?=
 =?utf-8?B?eUJnbTVDTTc5WGNtRThmWHNMUXB2bk0wRy9RODFOSGEwQXdBcU9xK09ud1Qx?=
 =?utf-8?B?RHlGYld6OWtqS1BlSXdxY1B0dTBiZXhhZlJmalVCemRhVlZ3S1R0VTFMMHRu?=
 =?utf-8?B?WFVvTnNjaDVoTU1JZnlMVSswaEpnSjNaR3FyZ2FoazcxNG05OHZCRHlFRzBT?=
 =?utf-8?B?eWVnckVVT1lBYy9MZythZ2ZTS1VHdXNzS1NYaTE2RlZIcTB6L3daTURBUHJZ?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db264a8-99f4-425c-3ba5-08dc2761f2d2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 22:21:22.0156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V4THCvqBmj97GnmEtQCabtD3kIOoHcL90pSaI3z0fAvUsiztBfrBlMRDPGBHYwyERp5Hi9zGXKMU5RE/rI6/7VMHva9AP8SKP/Y3dnG+mKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7925
X-OriginatorOrg: intel.com

Hi Alex,

On 2/6/2024 2:03 PM, Alex Williamson wrote:
> On Tue, 6 Feb 2024 13:45:22 -0800
> Reinette Chatre <reinette.chatre@intel.com> wrote:
>> On 2/5/2024 2:35 PM, Alex Williamson wrote:
>>> On Thu,  1 Feb 2024 20:57:01 -0800
>>> Reinette Chatre <reinette.chatre@intel.com> wrote:  
>>
>> ..
>>
>>>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
>>>> index 31f73c70fcd2..7ca2b983b66e 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>>>> @@ -427,7 +427,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>>>  
>>>>  	ctx = vfio_irq_ctx_get(vdev, vector);
>>>>  
>>>> -	if (ctx) {
>>>> +	if (ctx && ctx->trigger) {
>>>>  		irq_bypass_unregister_producer(&ctx->producer);
>>>>  		irq = pci_irq_vector(pdev, vector);
>>>>  		cmd = vfio_pci_memory_lock_and_enable(vdev);
>>>> @@ -435,8 +435,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>>>  		vfio_pci_memory_unlock_and_restore(vdev, cmd);
>>>>  		/* Interrupt stays allocated, will be freed at MSI-X disable. */
>>>>  		kfree(ctx->name);
>>>> +		ctx->name = NULL;  
>>>
>>> Setting ctx->name = NULL is not strictly necessary and does not match
>>> the INTx code that we're claiming to try to emulate.  ctx->name is only
>>> tested immediately after allocation below, otherwise it can be inferred
>>> from ctx->trigger.  Thanks,  
>>
>> This all matches my understanding. I added ctx->name = NULL after every kfree(ctx->name)
>> (see below for confirmation of other instance). You are correct that the flow
>> infers validity of ctx->name from ctx->trigger. My motivation for
>> adding ctx->name = NULL is that, since the interrupt context persists, this
>> change ensures that there will be no pointer that points to freed memory. I
>> am not comfortable leaving pointers to freed memory around.
> 
> Fair enough.  Maybe note the change in the commit log.  Thanks,
> 

Will do. Thank you.

Reinette


