Return-Path: <kvm+bounces-25971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B4E996E757
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 03:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A57EB23CAA
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 01:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B56B1DFE1;
	Fri,  6 Sep 2024 01:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OOr7bMxM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88056186A;
	Fri,  6 Sep 2024 01:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725586910; cv=fail; b=eGx58a4yDLRNPEHP85s48XXX1aWJYTwbyxr88FGRrKa0fJ6QqAifod0vSMcoCZdCrwr6P3N8n9F8X7mx8P5Pxw2FuhNd9xQcRseiicwyc7A8Rvynx4D4iPlnnU+rZci+2cR0r/LXBFaUM0dZWTq3E/7P1Z5XibApH+nle1MND/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725586910; c=relaxed/simple;
	bh=qNmMys9LYUrW+dscjPj7I84ovrG9MOcOXcktbB84EkI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IQJrCB8A1bwyQAgQt4ESD9wbYIUfvm8Qz2zTMoG0iq6GfKGpVS4qIpWtPyjzR10S0lYYdRb8qVdGMTMtjP4Ara49J+Am/JSrAI29EI7ipWZbbph5sOiwwo+d/XoT7qY5QRMWu7TLJw2kaZWBhyrPGdiopv9Vg+XUJarPjqbxn+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OOr7bMxM; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725586909; x=1757122909;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qNmMys9LYUrW+dscjPj7I84ovrG9MOcOXcktbB84EkI=;
  b=OOr7bMxMP9zSSWWGIZhksfKE4HpmjI5jmlus8F0MrQ4VLCBLlHQirX7m
   CGif23koOw28XbiD1CcNgMpOkOrszYLNk3OUPR8kod66qQ22cYOGDk0PZ
   0FZsDNrRe3uaIfvloxfET1TVtMmI4TJ/ZH6Xa/i/jTQZYZRZtPAhHDLJV
   TlVZms6ZwXsiFAZMIAClKyKMD94EsHm7wMmqwtQCZU1oCrkqphxL7VQl1
   PSMnaClJr6lPQuD7O3r0CWW4CY7W3kIhsjjf5srra54uEbITJxqv9pfdf
   qSPb4MzJp+X+x0Wn7HhnCe3oKlXEeQWvYLxO+K2btvcszjGwHS3pozv3A
   g==;
X-CSE-ConnectionGUID: PjLtff4JTz6IKxcjD7WE6g==
X-CSE-MsgGUID: GkaFYWs/TXGDkVbt/509Tw==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="28219318"
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="28219318"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 18:41:48 -0700
X-CSE-ConnectionGUID: ZKg4Wb7ER8qJE0gM1/nN1Q==
X-CSE-MsgGUID: glJQJV4CQbebmmQwZGhJGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="65517315"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 18:41:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 18:41:47 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 18:41:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 18:41:46 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 18:41:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mFHW7eYp5tXSftydTe6LXHOp2wMwlF4o2HgkS+YNRhWf3MFIgH/H1/gvP2ojHif3c1nHakcF8d6tNUKiw9KZDvekNWyzvYcVzSPG8bToqCmXTpFhzkEtx9t/CM8RpqUn+Myt0A6cPKMxpyuNdZhYW0edrjBOpz4VpexN6E3wh/23DnSj3snu3PRiSULTbOCqK5ia8oWTNY2fVus4CCAfCpXh3UHh5GCtO+H62a5Yg3w7pyf4ch49GqFUUDPzXQpaw+YmBWL1M7CfCiPU5kMWDVlTFmR2eNll5tJcr0+QDioFDQIziHJYHPkTL0VsifSPCAipnl5v7wzh32gPkJSRYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I27r8HUYNsh5QorudbMMYjNteLVw/k4eWym9Dvy4KqE=;
 b=ctzUK5c6ovIuqRgefRCZcV6f1pUXbjG8lTaz8R0LZqFq87/+QnQvBWog6K8pMC+UTOVDGqfit025oiiQme7sq//RXsD6D30HAtRaJGv8++NI4F9PL8RIYYN2e1XJyuSLlzTPqmf3FzeQcD6BwOVnJ1OjS5vwSvl6LeB5wcj0bzji4DMaTRw6ddu+MZwhVuN5W0naMhUNJQ7iaNU26f0879zvtkeWmzuVcXm+uP8k6yhIdqiXF/xJ33VRPaV/thbTngmqF7FDOKUa/AJ/USkXwd4ifG7setsHQq6Ugn9Fnnw+PtYtKoTJKV6d8/zNYgabBRWfn02SuDklPLAl5YldIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5313.namprd11.prod.outlook.com (2603:10b6:610:bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Fri, 6 Sep
 2024 01:41:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 01:41:44 +0000
Message-ID: <4cd18b6e-5e64-4b7d-9dbc-fd4c293cb4db@intel.com>
Date: Fri, 6 Sep 2024 13:41:37 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <dmatlack@google.com>, <isaku.yamahata@gmail.com>, <yan.y.zhao@intel.com>,
	<nik.borisov@suse.com>, <linux-kernel@vger.kernel.org>, Yuan Yao
	<yuan.yao@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-10-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240904030751.117579-10-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::26) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH0PR11MB5313:EE_
X-MS-Office365-Filtering-Correlation-Id: 156ed420-15db-4681-f81f-08dcce151078
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cEUrNlN3UStJUUtuc1RUa29ISTVXTEs2cmNqc3lFSEtTMWRKaU5pQ3VGYTlm?=
 =?utf-8?B?eEdud3oxeUFsWU9PTTMrcHcyTk1yNW5TdDBjNFUwZ0hRTzNkMTVVQWlNNXBO?=
 =?utf-8?B?MjRCUWM3SWZ0ZnFvMS9oelpUSlRUM3hKTlFOOFJWTk9ZdTVTL3JxbFVWc0Fh?=
 =?utf-8?B?NzNMVXlrR1FYUUExQWJzbG9ya3hCOHRiS2VKTzJQeE5ha1VsRS8zRWRCZWdU?=
 =?utf-8?B?N2d4S0llZlQydjZpZ3Y1Zk9pTFpjSENuRlRkNFVDOFk3a24yZnl3amp6Ynhk?=
 =?utf-8?B?Z0NXeDNadG9KU1pSclYzcDR5d2crZ1FVckYrN3g4SDB1Vnl6Wk5nY2RsK1VP?=
 =?utf-8?B?MEdGZXBEUGlLdUEwWjRvM0w5OHN4djdSUWxkNm45RTBIWW9LalFXZkhvZ2Rn?=
 =?utf-8?B?MTdjYzlXejRDMXlLTHd0UElwaUgyMzN5K2tVUUNoakQ4M3oxbWUyZTh1VjF3?=
 =?utf-8?B?dm4zZG9oei9rOVNzY2JZVFpxMUo2NUJqQTIyUmlWOUdLdkVXSUQyYVFjTVkr?=
 =?utf-8?B?Nk9PNDhIck9acTlpb2V4aFhtdnVPbjdlWUdKclljbFAzS1F5eUJvMzgxYnVn?=
 =?utf-8?B?c2tMVTJvSDlWYVdEdDZjekFnbkNBL0hOOHZIK0tnWEZLNWlEVElxWExWaVBD?=
 =?utf-8?B?Y2ZCV0FjVk8wRzkrYktoL2N3SDF2VS9vN1ZNNE9GZGd6U1Q2aXYyeHB5bWJz?=
 =?utf-8?B?Z1E0ZEhndWV3MmJPclB2SjIyY0kycyt4K29VeWlmNWVWa0JxMzNrK25EN1ZJ?=
 =?utf-8?B?MzBhZC9ZM0VOOHBsUnQ1ekpyM2hQaWVMQlFWRWo0eTArK2VtT2pLNHQ3QjQw?=
 =?utf-8?B?S29ldFdJK3ZPTW5LRmRNb242aXJKamxTNy9EdmU2amt5bDIyWnB2VW5tNzBL?=
 =?utf-8?B?d25FWFJRdFI2T0hmd0tESHFvdWNRd2VLOHZxT0RMWEVRMndHNGxhQ0kwRHJQ?=
 =?utf-8?B?RUpyNDcxNDJqT2w1VXBEOEVxOWJhTlVrWHZZYlJjMURjbi9hQjdsNE9LL0Fa?=
 =?utf-8?B?VnlmTkpTOVdxc2VNWnBjV2dSU01lNDZlY1NCUkZXTjNKQUZGaHVIWmRiK1p5?=
 =?utf-8?B?TUx4WHJYN2NBUWVhT3RmMDBOOFdlTzdzeUZ1dS9hTGU0eFdiZEljVkVKcmUv?=
 =?utf-8?B?QjUrbXhhcTZuVkoxZTNvdEdUV0s0TGFrT3lwV2tqY2NsaldzbW1FRUxFSHRO?=
 =?utf-8?B?cjhhZmVIdFFJVVV0UzBFK2phWmFRUlJlUTExUmZzV2RIeHg5OXZBcmU2L1J0?=
 =?utf-8?B?cmlJYmdyLzVkYk5ka2V4YnRJVFJmUHJHUHhTZFczS3JSMEVPekpKWGJuVjZD?=
 =?utf-8?B?cnd0VFFhakpRQjV0TXNub2pjdlVsWWVrRkhJU2VTQTZxOG9aZkZrcXJGV2o2?=
 =?utf-8?B?czI5dkVxV0hNUFZ3dFRKWWg2cXBwanFtZEM1aEpqcTJRRTZpTjd4MDZzVUY5?=
 =?utf-8?B?U1hLWTEyWEYrdTRnOHFqMU1OdWVzeEd1Yk5QVXhQQ2E5WlhoaXk1SkgxYkYv?=
 =?utf-8?B?dit5Q0VlTWNSRHIzTENHb3NMMUhjbkxYOEFxNFlRUlh0dDRQSUt4WjJDdVdm?=
 =?utf-8?B?cHAydDlwcW9Qdk1VUWxkR1FON05oT2phbzhrV2IrMGlIWEZvREVOc0tOTG1m?=
 =?utf-8?B?dzhUTGN4YkQrRFNQMEJtaXd3TTM5SXdWWjJVQ1NyOGk5TGxFTmtHbUhDdXls?=
 =?utf-8?B?WTNQWEo2bHpTQ0U0czdkRElqQjNvdEVqV29kZk8xZjg2TWJZd2c3QWVZcms5?=
 =?utf-8?B?dTZ2anpjeCtPQ0xUY05La3NRT2xoaGtMSFowMDhsbDhNTzJSZk9BbDYveDBD?=
 =?utf-8?B?QzJhWHV3SXVtVldDS1A4QT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mk1yYXVLdVd1Wi9yWnorRU1OK2NTTUxUKy81WkFoK3RtVUZQTzJ0VkI2TnpD?=
 =?utf-8?B?czJsV0NLWnAyTUlHbnlVWVNyRklLOW1XWTlxUWxpanRQK0h0UTBnUkRvdUVY?=
 =?utf-8?B?YXNTeS9jUzZBdnV3V2J1Z0Q0T1hKUExncmNRaTJOWGdQdXdNVHdid2hKRTVk?=
 =?utf-8?B?eU15RjAxd1YxaEJoSDhrdmlvT3A5SGZoMDNidWJ2TzdJdzVxc1R6Ly9Xa0Nl?=
 =?utf-8?B?Q2ViZzgxY2lhWk1QNi92V1c3eEZ5T0NTd0NNNWJjcTh2SzIxQXlMeXFSOG9z?=
 =?utf-8?B?MnFkWXRyWlowdktRNFlGZ0lCOTlKUWNROU5CdmQ0ZC85S2czZ3daVis2WjV5?=
 =?utf-8?B?UlFjcU5WclNqU0FST3RoMkFFSXFNbmhMRmVoV0xCYWV0bkdQZTBERTY4K1Jv?=
 =?utf-8?B?dmZ1bWJxSmZMekREV29oS1RGSDZLQnowMHhFczAwVXVoRkNrTmFQVGw0RWJY?=
 =?utf-8?B?TFptOWR1blgraTdOWGtIV01KUmVESlJtaEtrQWlTZW1VQ0NmQStJVHJkakdP?=
 =?utf-8?B?NFRndDJMOElsVlpSdUZkNWpwMG9UbG1wQlRWTk1hNHRIZ0pRZnJMZmk5dThi?=
 =?utf-8?B?RzNoSGR4dXVvZk1jYjNILzlWNGUyTkpJYk16R1dtRzZMMDVuM2JpNmtEMkNJ?=
 =?utf-8?B?aENrRXUzSmNJYXQzWldoelhFV0dmaEhTTXF6OXV4UDN5cmlKdnh0c1R3Q25m?=
 =?utf-8?B?TktoZisraVFJU1RDQlJHckVhdmMzNHQ3cWpLSnBqalJtbmNsb0RqS1M4dmVN?=
 =?utf-8?B?YU43SVh1Y0dSemEreUl0YWlDSW5jdWMrdjFub1E4SlJDekhxMlkwZGFtOU1s?=
 =?utf-8?B?ZDJzNEJXZ3NOMkJsdlN4QVFLdU9tZ3pzUDFva2dOM08yUGNjYWtmUmhYZjBW?=
 =?utf-8?B?d05EeUUxS0x3VG9MZytvdFlDWmdoaFFBd3JpZ3BDbkVDT2NtbHVwVHJPckRT?=
 =?utf-8?B?VTc1dmtyYWt3aENQL1FZaXM1eUYzT05BK1haYkRNRDlTaGNlUXRjZmVuV2Yv?=
 =?utf-8?B?SnM4Y29ndFFOeDlaTG5TQ2k3NGpSL0lIUytlN3RNVEhFRWFoWTdPcDI2NXhp?=
 =?utf-8?B?RlpISU9XS1l0OGVycFNJMVlLVDhvOG9vdGRwYWZyMFV0TlBqaURVREFZdktk?=
 =?utf-8?B?a1BBamVqeVBrVTJOT05Ja3RNaXdMZnRMUGJQLzZ4NUduYlpRMmd6Z3RkRFBh?=
 =?utf-8?B?Nk4xQTZoZXA4K0JsRXNvNXRub2RrSEpEdmZsZjE2M3RiMGF5cVloZ01OQTNP?=
 =?utf-8?B?YXFkV0pUbXF2Yk45N3JSTHZpQUwyS2VtV2g3UVFwOEg4N0RGOGJjZW16Rmp4?=
 =?utf-8?B?djVTWkpYZG90ZkRYS0MrSWJaK1lEYWg5dU1lSTZlaXdKbTd6Z3o0VEtnV0hs?=
 =?utf-8?B?eURFalI2U1l4c3BEMzZJM2N0aUo1VlVSSm5zQUxteTgwbHkraUNycldNK04v?=
 =?utf-8?B?S2o4VDFyUzVhbm1HblZGbVlXQlBCU2xqakVBeVg2UklqQ0tPNGhZWlZhWG1u?=
 =?utf-8?B?bTVKRldFMUk5Qlp5eGtycnE5VUVmMEQxVkRIVllybG00cW1kYXlRMWRCUWZk?=
 =?utf-8?B?M0JVTFVkV3FqcXBvOVgraVFnQjdtNmVqSFhOeWhWUDFISWhxTlVKR0Q0MGk0?=
 =?utf-8?B?MS9uTnV4ZE5uNmJ4cDNybFJSNmdrWkkyQkZGRG1ENlRsZEovdEw0VjM2b0JC?=
 =?utf-8?B?bE9LT29PWXQ0WGJHV0tuaVBTSVUrNS9PeUM1cUJTL1dpOVdiY2tJcmhPRk9u?=
 =?utf-8?B?dHdNd1k0NDM5Z0VnelgyOFBsOEhaeHRYcXRmZWlSZlZPRnNZaEFJdFFWRDhu?=
 =?utf-8?B?cGJwQ0doclBUV0tDdFdSdjhnaWQ4VVNKMGk0Uk5HaHhnZUZXM2o1QWVMVzdK?=
 =?utf-8?B?UFArdFdzYlRXWm9MbEhsOGVWN0FsNHdpMFBqajBkeXJVTGljQ2tqb0E5a3RF?=
 =?utf-8?B?Tk1tMk9GSy80ME9oRmJ2b3IxWFRGT2xmbzd1bkM5M2RCSHVMZUdldW8vc3pE?=
 =?utf-8?B?TWt1Y3BDUFJ6em9NTFF1dE02RTkyaEJsMHBqNUQ3cTFrei9ld2REN0xhaSto?=
 =?utf-8?B?U01oZk1BcWNVSmx2TXIzekZLZnVvUEpQQk9VM1VDZW9XdEZRSlFiTlVObEVu?=
 =?utf-8?Q?oD5zBR1IM03+6lh0qKBsHPX97?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 156ed420-15db-4681-f81f-08dcce151078
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 01:41:44.6730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0orUdjYvOm0xvxWNSM+ONgD6dtSj5Znyfo+kgmkan4JcETRAxNqjooHUsSnQcojKqQHAEzkDFKtyOv4Wr39rVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5313
X-OriginatorOrg: intel.com



On 4/09/2024 3:07 pm, Rick Edgecombe wrote:
> From: Yuan Yao <yuan.yao@intel.com>
> 
> TDX module internally uses locks to protect internal resources.  It tries
> to acquire the locks.  If it fails to obtain the lock, it returns
> TDX_OPERAND_BUSY error without spin because its execution time limitation.
> 
> TDX SEAMCALL API reference describes what resources are used.  It's known
> which TDX SEAMCALL can cause contention with which resources.  VMM can
> avoid contention inside the TDX module by avoiding contentious TDX SEAMCALL
> with, for example, spinlock.  Because OS knows better its process
> scheduling and its scalability, a lock at OS/VMM layer would work better
> than simply retrying TDX SEAMCALLs.
> 
> TDH.MEM.* API except for TDH.MEM.TRACK operates on a secure EPT tree and
> the TDX module internally tries to acquire the lock of the secure EPT tree.
> They return TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT in case of failure to
> get the lock.  TDX KVM allows sept callbacks to return error so that TDP
> MMU layer can retry.
> 
> Retry TDX TDH.MEM.* API on the error because the error is a rare event
> caused by zero-step attack mitigation.

The last paragraph seems can be improved:

It seems to say the "TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT" can only be 
cauesd by zero-step attack detection/mitigation, which isn't true from 
the previous paragraph.

In fact, I think this patch can be dropped:

1) The TDH_MEM_xx()s can return BUSY due to nature of TDP MMU, but all 
the callers of TDH_MEM_xx()s are already explicitly retrying by looking 
at the patch "KVM: TDX: Implement hooks to propagate changes of TDP MMU 
mirror page table" -- they either return PF_RETRY to let the fault to 
happen again or explicitly loop until no BUSY is returned.  So I am not 
sure why we need to "loo SEAMCALL_RETRY_MAX (16) times" in the common code.

2) TDH_VP_ENTER explicitly retries immediately for such case:

         /* See the comment of tdx_seamcall_sept(). */
         if (unlikely(vp_enter_ret == TDX_ERROR_SEPT_BUSY))
                 return EXIT_FASTPATH_REENTER_GUEST;


3) That means the _ONLY_ reason to retry in the common code for 
TDH_MEM_xx()s is to mitigate zero-step attack by reducing the times of 
letting guest to fault on the same instruction.

I don't think we need to handle zero-step attack mitigation in the first 
TDX support submission.  So I think we can just remove this patch.

> 
> Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU part 2 v1:
>   - Updates from seamcall overhaul (Kai)
> 
> v19:
>   - fix typo TDG.VP.ENTER => TDH.VP.ENTER,
>     TDX_OPRRAN_BUSY => TDX_OPERAND_BUSY
>   - drop the description on TDH.VP.ENTER as this patch doesn't touch
>     TDH.VP.ENTER
> ---
>   arch/x86/kvm/vmx/tdx_ops.h | 48 ++++++++++++++++++++++++++++++++------
>   1 file changed, 41 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index 0363d8544f42..8ca3e252a6ed 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -31,6 +31,40 @@
>   #define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
>   	pr_tdx_error_N(__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
>   
> +/*
> + * TDX module acquires its internal lock for resources.  It doesn't spin to get
> + * locks because of its restrictions of allowed execution time.  Instead, it
> + * returns TDX_OPERAND_BUSY with an operand id.
> + *
> + * Multiple VCPUs can operate on SEPT.  Also with zero-step attack mitigation,
> + * TDH.VP.ENTER may rarely acquire SEPT lock and release it when zero-step
> + * attack is suspected.  It results in TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT
> + * with TDH.MEM.* operation.  Note: TDH.MEM.TRACK is an exception.
> + *
> + * Because TDP MMU uses read lock for scalability, spin lock around SEAMCALL
> + * spoils TDP MMU effort.  Retry several times with the assumption that SEPT
> + * lock contention is rare.  But don't loop forever to avoid lockup.  Let TDP
> + * MMU retry.
> + */
> +#define TDX_ERROR_SEPT_BUSY    (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)
> +
> +static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args *in)
> +{
> +#define SEAMCALL_RETRY_MAX     16
> +	struct tdx_module_args args_in;
> +	int retry = SEAMCALL_RETRY_MAX;
> +	u64 ret;
> +
> +	do {
> +		args_in = *in;
> +		ret = seamcall_ret(op, in);
> +	} while (ret == TDX_ERROR_SEPT_BUSY && retry-- > 0);
> +
> +	*in = args_in;
> +
> +	return ret;
> +}
> +
>   static inline u64 tdh_mng_addcx(struct kvm_tdx *kvm_tdx, hpa_t addr)
>   {
>   	struct tdx_module_args in = {
> @@ -55,7 +89,7 @@ static inline u64 tdh_mem_page_add(struct kvm_tdx *kvm_tdx, gpa_t gpa,
>   	u64 ret;
>   
>   	clflush_cache_range(__va(hpa), PAGE_SIZE);
> -	ret = seamcall_ret(TDH_MEM_PAGE_ADD, &in);
> +	ret = tdx_seamcall_sept(TDH_MEM_PAGE_ADD, &in);
>   
>   	*rcx = in.rcx;
>   	*rdx = in.rdx;
> @@ -76,7 +110,7 @@ static inline u64 tdh_mem_sept_add(struct kvm_tdx *kvm_tdx, gpa_t gpa,
>   
>   	clflush_cache_range(__va(page), PAGE_SIZE);
>   
> -	ret = seamcall_ret(TDH_MEM_SEPT_ADD, &in);
> +	ret = tdx_seamcall_sept(TDH_MEM_SEPT_ADD, &in);
>   
>   	*rcx = in.rcx;
>   	*rdx = in.rdx;
> @@ -93,7 +127,7 @@ static inline u64 tdh_mem_sept_remove(struct kvm_tdx *kvm_tdx, gpa_t gpa,
>   	};
>   	u64 ret;
>   
> -	ret = seamcall_ret(TDH_MEM_SEPT_REMOVE, &in);
> +	ret = tdx_seamcall_sept(TDH_MEM_SEPT_REMOVE, &in);
>   
>   	*rcx = in.rcx;
>   	*rdx = in.rdx;
> @@ -123,7 +157,7 @@ static inline u64 tdh_mem_page_aug(struct kvm_tdx *kvm_tdx, gpa_t gpa, hpa_t hpa
>   	u64 ret;
>   
>   	clflush_cache_range(__va(hpa), PAGE_SIZE);
> -	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &in);
> +	ret = tdx_seamcall_sept(TDH_MEM_PAGE_AUG, &in);
>   
>   	*rcx = in.rcx;
>   	*rdx = in.rdx;
> @@ -140,7 +174,7 @@ static inline u64 tdh_mem_range_block(struct kvm_tdx *kvm_tdx, gpa_t gpa,
>   	};
>   	u64 ret;
>   
> -	ret = seamcall_ret(TDH_MEM_RANGE_BLOCK, &in);
> +	ret = tdx_seamcall_sept(TDH_MEM_RANGE_BLOCK, &in);
>   
>   	*rcx = in.rcx;
>   	*rdx = in.rdx;
> @@ -335,7 +369,7 @@ static inline u64 tdh_mem_page_remove(struct kvm_tdx *kvm_tdx, gpa_t gpa,
>   	};
>   	u64 ret;
>   
> -	ret = seamcall_ret(TDH_MEM_PAGE_REMOVE, &in);
> +	ret = tdx_seamcall_sept(TDH_MEM_PAGE_REMOVE, &in);
>   
>   	*rcx = in.rcx;
>   	*rdx = in.rdx;
> @@ -361,7 +395,7 @@ static inline u64 tdh_mem_range_unblock(struct kvm_tdx *kvm_tdx, gpa_t gpa,
>   	};
>   	u64 ret;
>   
> -	ret = seamcall_ret(TDH_MEM_RANGE_UNBLOCK, &in);
> +	ret = tdx_seamcall_sept(TDH_MEM_RANGE_UNBLOCK, &in);
>   
>   	*rcx = in.rcx;
>   	*rdx = in.rdx;


