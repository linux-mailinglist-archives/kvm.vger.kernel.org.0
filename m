Return-Path: <kvm+bounces-71796-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJdVA/yTnmmXWQQAu9opvQ
	(envelope-from <kvm+bounces-71796-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:17:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EDD1924C3
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5B9D3049255
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E79C2F25F3;
	Wed, 25 Feb 2026 06:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iYnocOZr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E991919CD03;
	Wed, 25 Feb 2026 06:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772000227; cv=fail; b=EKcW1jj35C4iGq16eKK9oaaZtEIR+vluIQYppm8DT/frneTgoZpqCLo0UP7E7q+O380aa4+JgBmeh0WoKFExNF2sLV8qAOIo2XjihFWylid0M0Y8TDXC05Pu6Hicv6gi0XxUY2ZAYnffjnLN9Yr7G3ba8iBXxkDPbKeJLvHALEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772000227; c=relaxed/simple;
	bh=x5XJ8wgizdQ9tfregQXbdMF0vouW57LTrkA8mA0Trtw=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=bTZsVqe3Z1WgyqYBsi3IBtWtWmt6JrNAgq7dRUbHd5a0/0ZheCdcqg76CfyriYmi2Hs1tt+EYokvCNr1ryRktmkgOq1jYQdHTYlqgExdfeQQw9fQafrd+Tw7M7Ix+qTux62JRz9jEFTA62msernkiw95WwjVIOdy24w0UyQZR7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iYnocOZr; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772000226; x=1803536226;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=x5XJ8wgizdQ9tfregQXbdMF0vouW57LTrkA8mA0Trtw=;
  b=iYnocOZrQGUaKH4B364WFtBCSDAMmBKo1lN+mJZsStR5tepV166m+Iv4
   iUkVO5kA45L8BUiG7/I+qLfp5FR5ywWc+Hvrj9z5+eK64W669E+kjWHzR
   iepon1DetpMOKHLh6wrTPDQq0ekNAsVW+fqGqDtf9ch4XLgWu2vRZ/gAl
   SC995PILDhRGWfewg69HjG5/KIMgZElxG/u0a6MXBBING8nrO4eHhqMLx
   W/XwIHC1iJCF8yC4ldPeztxIBj6h/JlA2VPulIeUvMapAufOnJQrWTibT
   9oWCv1RXyCDfGoGjjZ/cJCAdW0GuzQGA2MzBVbncNmx1uokc/ucnXwfks
   w==;
X-CSE-ConnectionGUID: 9QPkBIihTBywJQwuEFS/2A==
X-CSE-MsgGUID: LFTJrvDiRBaZ2TXll2nn8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="98495238"
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="98495238"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 22:17:05 -0800
X-CSE-ConnectionGUID: WmxLIA6qSuiaHEg/7+7eUA==
X-CSE-MsgGUID: QxKWwBLRT3mPnBjHzW+mLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="243962674"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 22:17:05 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 22:17:04 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 22:17:04 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.38) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 22:17:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cdEr/eo9uG6JSjlkgVVddX+rsAka3FLnjm6ie8mjcQkhvd2dQ1whRRfBp/sjmp2bKogNCnx9tyl7DlJ8wv+di2UO6pzyqvTqQRospQDeecuW5Fg8Cr3cFOfFBRdtcKhKCggfuHtaAIKhpADVveBgq9fmxxFBsUj9hjAVGi2hINZ170gwalvVibH9B3RDuxZK/ylHCxi7Zpv+aXivA3tHU6ndS/WtySWijkR2VPEZQcC/OQDqsXWwYUhKRV7r9ZPoQRbdD2X0esWRwb6fg+HfcWvRrWWXmeHPhRIhtMgD7NLLjuvcZKP35hmv98eCu1QjZi+06pewaoefWrWpSgyyTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6RvM0Q8eZAWDEEpilPQZM4Ve0hCF97iafVTtRt14Ew=;
 b=wYdAq5OTNjn3KZi74+H5LtoSsI98feThuvcfggJ9TPfL356tmpDhFHbOyd1eNA4KInt3qTLWEAhoTW14yIYXaYu6NIpE1UozVadrMoB+sWEowUlanSU4iWNmMFlQIKotH54uLmNlHIbi8JfOUfYJjapBMeI3djMo2k23044Dfl3dajany2y3+kRT/5yAPtAsLIqQzEu0a0Un0BAyE191FzE/YgVG4WQVf8nGdIKCw/K8uh9x/3z67hKl0kgmmH0SEhv8zVnywJYiLuq0qVHo9ZuBCaB33XHGliS/9Lo6rpGTIJBsTaUM1zTFFv2AtCOyTjTq0LLRNzVsv+G+JMSurA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB7172.namprd11.prod.outlook.com (2603:10b6:930:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 06:17:02 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 06:17:01 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 24 Feb 2026 22:16:59 -0800
To: Alexey Kardashevskiy <aik@amd.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Dan Williams
	<dan.j.williams@intel.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom
 Lendacky <thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Stefano Garzarella <sgarzare@redhat.com>, Melody Wang
	<huibo.wang@amd.com>, Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel
	<joerg.roedel@amd.com>, "Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth
	<michael.roth@amd.com>, "Suravee Suthikulpanit"
	<suravee.suthikulpanit@amd.com>, Andi Kleen <ak@linux.intel.com>, Kuppuswamy
 Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>, Alexey Kardashevskiy
	<aik@amd.com>
Message-ID: <699e93db9ad47_1cc510090@dwillia2-mobl4.notmuch>
In-Reply-To: <20260225053806.3311234-2-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-2-aik@amd.com>
Subject: Re: [PATCH kernel 1/9] pci/tsm: Add TDISP report blob and helpers to
 parse it
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB7172:EE_
X-MS-Office365-Filtering-Correlation-Id: c47166fb-b5da-447e-2457-08de74357d00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a0FNV0lnTTdwdVQ3aGhTQTgxRVh6UlFKTUQvTThMTVJTTnFxU3M2YTMwZ2pH?=
 =?utf-8?B?OWhFMytyc0R2eUdRaGQrTERSZzUwdm5Lcm44d3E4cmdCbkdTRXlqaW5vcUlP?=
 =?utf-8?B?dUZrbU9BcTdnRytESkpocE9JdjhsR3RUS2xOd0s3MDF1WHZUVS9uWlpXVGZs?=
 =?utf-8?B?WWNQbzMxVm8xb241UmxmdjVqYmt3YjlmV1Y3ajdNNldHRzB2ZTVTYzJ4RENp?=
 =?utf-8?B?bGxSV0RzMzNRaXpsSlUxRG1VakQ2U1hUbGNpcGVoWVVRQjR3TEwzcGh6d1dL?=
 =?utf-8?B?NmRkcFFwNXB3aTR6VE5iVUo3UkF6REVkQ3Z1U214QTFQYXgyOXB6Zy9PY28x?=
 =?utf-8?B?YVVFRVZZQ2E1WTVpc2RGMDlSZm9aQTd1WEhVUkg0NnF3ZGVWaDF4UzlPTjdS?=
 =?utf-8?B?dzcwMG40cWRZUGFJZ1NIOU82eFBwMnkzRjgyQU1XVHI1SXpZS0lUZzdpTXhU?=
 =?utf-8?B?K0R2bmt3cXdYTXFVd3A5OWJZSXA5ZkNleXRZTjFUVXJGMXJra0p5SHhyWGxl?=
 =?utf-8?B?dFpKVTRGVDJQV1FQOThzZjlzUmVsZGxuUnpwRHYzaUlGTUFYSDg1ZFNNZEY1?=
 =?utf-8?B?bExBT3l5cnlobEZleEhIUE5sYlpUMnIybHRNQUlhVlk2SVd3NGtWenk5RVYw?=
 =?utf-8?B?Zzl6bHRtTitqcWhBQVhHYlNIbTlsTS90c3Npa2srbFY5d0hYYkdhcmRCd08z?=
 =?utf-8?B?WGIxaWFLLy9xbjlybEVCeFZQQ0djMGxvNEoyUVpFTXpteXhiVXR3UU1iVzVa?=
 =?utf-8?B?L3JYVGNRMTdXNGN0a0FQRm9KcWpuMEhYQXpUeVZ2RC9MOWNoS3FFOXJzV3Jw?=
 =?utf-8?B?TGI0UlpsSlRGeUNCRzVSK2tIMys0VTNqTjRZUzdqWEl2OXhJbjVWbkxOaVFC?=
 =?utf-8?B?Ynd2MkNzU1RxWksvNTZYK05kcEkwYjd0NzVxcGt4NVlGY3YwejlaR3ExblIz?=
 =?utf-8?B?Qlh4K1hPZnp4bmo1SWpOcS9JTXRCMXJqaEVmWXJsODFCSkJXdDdRVlovNnJD?=
 =?utf-8?B?Q0lFL3MzdEY2UUhpTDNIWm9wOE9LODlqSnVsaVNNc1gwWHMxT0dKa2xlYVlZ?=
 =?utf-8?B?ZjVURTIxTW1KeWE4dC95L3RXZXJxS2lidWlRdVIxVysrcW94bkNlUG5ZbUlE?=
 =?utf-8?B?V3hMenFjMEs1NEJLKzJMVDAxMFhzSFJSOUdRTVpKWHU1YmhUTVkwc1VoTjRU?=
 =?utf-8?B?L1FISEZtaHZVVHR3TEFGQy9XRDZhU3VUT2pBUkwrUG5OTlJqTCtSNmgvZVlB?=
 =?utf-8?B?SGR6bUdGWCsxYktrc1h0NWcyUy9xT0FSUjZTNmJXT3p0S290emlZOGx6MURD?=
 =?utf-8?B?aGIzZXNlbDFJTEd5UWtiSVV4SUdVTmRIM2dVaHBnRnRyM3V1L2RRRVF4d3Ur?=
 =?utf-8?B?VitKTWYzdnNqZTVoeXdLWnJkU1pxMEI2a1NKWkEwQS9acExvVnRtd3Q5S2hB?=
 =?utf-8?B?ZXVHWlZZUWV6d2VPYXFybUJXMVFJVHpiZCtnd3kzSUxNK1djYlJxZi8rZGZ4?=
 =?utf-8?B?MkttNitWRXMyREkyL0drNURwNzNKYmg4ZlBXNEVza0U3aXFLMm1ndWhQMmZj?=
 =?utf-8?B?bFFreTNUUGJnRFdVK3NLWnFuM0JXcG5jbTROeURFZWV4QmJmREcwVGlmNjNy?=
 =?utf-8?B?WHdoV0dzNmR6Wkg0T2RYWlFVMDlOcm9vWWJRRjkyVlpiTVlLYVdEcXZrS252?=
 =?utf-8?B?MU1wR0dYamVLZTZ6R0lJSDJMcWE3eHp3ekdGRTdxZ2Rub3gwYldlUFdpZ1pp?=
 =?utf-8?B?YlhkM1VRV2F6Y1V6cXJXZ3ZSMVBWNGcwcGNWWWRCa25ySi9aQ3lwMkVHMGtr?=
 =?utf-8?B?Vkp2N1BySzRzdmFOREJvU1ZwS0FEM3Q3eStnSXFBTXJiYnUvNjZTTElNbHY2?=
 =?utf-8?B?Zmpsd1dEZ0lHVlAreFRvTVI3WXFyejNRZUd4SDNSa2FCbTlrWXA0M2dkZ1ps?=
 =?utf-8?B?a0ZqVGlmc2FUaml0YkdRY0JsdUltK3cvZDhpckpTbEFDYzE0a3VqMS9tbEVG?=
 =?utf-8?B?RmFwQ2xTSm1rNGpEY0pnM3dOaVROVkdMMVVYTjI0MGpPTDJRN3Q1cVQvZnpS?=
 =?utf-8?B?b2Z5UzMvZ2JHVUNjakFucFY0YmpQMVNrZk1EY3Urb2pFOFdVL1NnWFUybmRE?=
 =?utf-8?Q?xEq8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnhDMmp5d1dRNmYxYVNkbzd4czFBcTNKVkt0dVphM2tiemt4RDRHZHA0cUxv?=
 =?utf-8?B?SHVxSmRWMkFKSC9JMk9ML3RmcW9NZlloRncvd0VpYTRWb1AvSVY2Zis4dWV1?=
 =?utf-8?B?YVNnM1BNeUlKakhxbUJOWjA0SFBjVW9VR2d0KzhKem9XWW93ZDY5b1pUREZ1?=
 =?utf-8?B?WnlQR2FVUUtkNWRwRzlJa2VReFJCTDdpOTBUOCs2SnZVVk14Z0JyNlYzd2Nh?=
 =?utf-8?B?OHJtVDF0OG83ZkdhS0Q5S2EzeFpPZXpPN3VCQndxWm5oVGpUQU5zN2VabjVR?=
 =?utf-8?B?cDBDb0kvbGoxUFN3ekpJUGJSeklMd3J0SmFweU43WXlianJCYjFuN2Vtd01G?=
 =?utf-8?B?eUxVOUYraHh6YW1KT0pYY1lmbVpiRTJ4RkxrQ2hKekNNaG1iTWorNlE2VTVV?=
 =?utf-8?B?V1NnMUdFK0l2TlFqTzZUQ1luNW5pdTVUMHhyU3VrOGVvT1Q0SzNleG1MSity?=
 =?utf-8?B?bnVJWjYvVXp5MVdyeldnZ0tSSDVoRVNUdys4clNtdjI0ekV0bUVyMTMvWWNw?=
 =?utf-8?B?Sk9SdFV0WkFOSGRaNExqbllydGxjV09tQndMWWh4Z3lxczlLV29veUM1Q085?=
 =?utf-8?B?M0pDT1I1S2c0TmJGNEh2VUZEZUp5OHNpeExCc0dZdytmeFRXN2Y0Z0F4aUJW?=
 =?utf-8?B?ZGQ2RnNxOEZFQURZSzBGbCsvUm9qSWtVRkRFdDE2MUV5UXh4eVVXbjRRT25L?=
 =?utf-8?B?YkQvUHFyQXh5UmVUZzBFckJZUW01Z0EyN3RLSU1NT2tKUm5YeUNhVmFBRVFI?=
 =?utf-8?B?cTRZdnNnN2tmUTV4THZ0bVF0OVQ2aFBGTWJUVm15UXFWNURQTkhJalA0ZXE1?=
 =?utf-8?B?S3RrMlJEL3NzWHBWSTh6T1lHSGs5eFJmZEVoVUkzZzZpZk4rL1R3NFgrNWpr?=
 =?utf-8?B?VGh6TmF2RDFqcXpJNkFKSEdiUkszNDhCMEdFVDBoTG9NZXdHV21vKzlwVVNO?=
 =?utf-8?B?MzFkeTlZRFFaZXpRSllKc2F4d1pOWWhjRFFyKzREZG1TZGpGRkJvLytNNEto?=
 =?utf-8?B?emtRaTBvZXNFUW95MGZhaUNXZXdrOU1pM2FDWXpkNVV0b3J2czNKd0ZzQUJo?=
 =?utf-8?B?cnl6RElpSEZmd0hjOS9PMWlxczltcHRhR3BYWWJCdUEwWklLdUZuZEpMZmoy?=
 =?utf-8?B?allZMjlKUithMzVuREdRZnZmSUx2ZE9jUEt3VGZSYitYcnowNjU5SFBrODha?=
 =?utf-8?B?eWFMbTl4UXhlUlp3SEN4NmtMODRNWEt6RjVpM21sM001SDdVRHNEdmFrQ1pm?=
 =?utf-8?B?RU13b3R3ZmNwTFFDVHFQbjR1a0gySCtQaVRBVEZDRTdCZ2NwZllSWlhUbW9D?=
 =?utf-8?B?RnNBVk1WeG9rUnY3MHhCb2paaURGL1I3cHdVVDMya0NkRFQ0dkJKbkMwR2FW?=
 =?utf-8?B?OVZlUGVtWjBnRTlSVHlTZFBqOFlIQVlGeG1rS2lubDl3ZVFrMnd4Vk1NM2wz?=
 =?utf-8?B?OXhhQjYxaG9GbWFMeXBMNjZBRFNRaDZKNXJEVjkxcTJEV1NhSEJ1RFpTeHFl?=
 =?utf-8?B?ZlpZYXhtelh3Szh2cnl4aWhHNDZ3ODhtYWNQSitMR1o2OVUzUm1JSzhTaStS?=
 =?utf-8?B?ZC9qYmNmTWxEVjVQUk51b29OMmdXK1hDRHp0c1F0S29HR3o3eFNJaWdOclpp?=
 =?utf-8?B?MS9xMmNvb3Rzbi96Y1dVZVYzT3ZpQUZGUzZTY1pEeDJSelZ2cmhmRzlHZkFT?=
 =?utf-8?B?UUZGV2UrVERtdU9NenpBazFNVUxGejAwbE0ySkRvemdQOHR6blV0TVR1WHlv?=
 =?utf-8?B?SVZ1VjVmOVcxQ1h3S1A1enBBRDBLL3B3a2dCRGVKcUticzlTYU1mMHF6VjVZ?=
 =?utf-8?B?UlpDZkhLMitMSC94SUd6UHVscUpwWGFyMWllRjd6dGRwNkhmM1JXWXQxUnJQ?=
 =?utf-8?B?bTZFOTJZaklFL1FlZU5BMUFUU0JmQVhKNDljekdheXhjQWJCU201K2lPdEp2?=
 =?utf-8?B?bmgyWTVuMlM0TDNNVGpHMG0rVFV3RUNRbi9mU0dDREkxbVloU0Rhb1o5c21U?=
 =?utf-8?B?TmpUemVrZjRFZ2FMT2F4Zkl0eUZzdGt1cUM0UWhFUXNIbHFNamZKcFVtd1dr?=
 =?utf-8?B?SEozUE5lNDY2WjdVOFpNVUQyVmRvZ3FaT2haQ1RyR1kvdDMwbzdZSXcrWFAr?=
 =?utf-8?B?eEtyS2xvQi9FQnJhQ3d3MzlHVW5CVCs1YldLZURveTZmdW8vVS9hV25GRG9X?=
 =?utf-8?B?Nm0wMFA0WS9WNDNmQnZyNHRNcGJ1c1dZYWhXbHBaYVc5UkMxYjQyeVFZMDhM?=
 =?utf-8?B?bERxS1JpMDVzeWQ0SlU1bVUwdEkvSXVkMjV3QXFFTFkzNmNPNGEyR2VZamZo?=
 =?utf-8?B?MThaVjdlYzhNNWdvNjQ3cHp2U3h1bEI5UUxvTzBtMXJHcDVyMlpVYmZDQVRo?=
 =?utf-8?Q?A6ujj302b5/Zvuss=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c47166fb-b5da-447e-2457-08de74357d00
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 06:17:01.4072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHfU3ehDHabaNk+iv0/eqw6Ce5xv4OCYP/UH3rPCDoZ2plf8mZ7D0r7nSrbiyb1lM7l4SNkHSNRwg8F672aIreGyKiGnoWM6Fo/60HoR8D4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7172
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71796-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,dwillia2-mobl4.notmuch:mid,amd.com:email,intel.com:dkim];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[59];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 60EDD1924C3
X-Rspamd-Action: no action

Alexey Kardashevskiy wrote:
> The TDI interface report is defined in PCIe r7.0,
> chapter "11.3.11 DEVICE_INTERFACE_REPORT". The report enumerates
> MMIO resources and their properties which will take effect upon
> transitioning to the RUN state.
> 
> Store the report in pci_tsm.
> 
> Define macros and helpers to parse the binary blob.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> 
> Probably pci_tsm::report could be struct tdi_report_header*?
[..]
> +struct tdi_report_header {
> +	__u16 interface_info; /* TSM_TDI_REPORT_xxx */
> +	__u16 reserved2;
> +	__u16 msi_x_message_control;
> +	__u16 lnr_control;
> +	__u32 tph_control;
> +	__u32 mmio_range_count;
> +} __packed;
> +
> +/*
> + * Each MMIO Range of the TDI is reported with the MMIO reporting offset added.
> + * Base and size in units of 4K pages
> + */
> +#define TSM_TDI_REPORT_MMIO_MSIX_TABLE		BIT(0)
> +#define TSM_TDI_REPORT_MMIO_PBA			BIT(1)
> +#define TSM_TDI_REPORT_MMIO_IS_NON_TEE		BIT(2)
> +#define TSM_TDI_REPORT_MMIO_IS_UPDATABLE	BIT(3)
> +#define TSM_TDI_REPORT_MMIO_RESERVED		GENMASK(15, 4)
> +#define TSM_TDI_REPORT_MMIO_RANGE_ID		GENMASK(31, 16)
> +
> +struct tdi_report_mmio_range {
> +	__u64 first_page;		/* First 4K page with offset added */
> +	__u32 num;			/* Number of 4K pages in this range */
> +	__u32 range_attributes;		/* TSM_TDI_REPORT_MMIO_xxx */

Those should be __le64 and le32, right? But see below for another
option...

> +} __packed;
> +
> +struct tdi_report_footer {
> +	__u32 device_specific_info_len;
> +	__u8 device_specific_info[];
> +} __packed;
> +
> +#define TDI_REPORT_HDR(rep)		((struct tdi_report_header *) ((rep)->data))
> +#define TDI_REPORT_MR_NUM(rep)		(TDI_REPORT_HDR(rep)->mmio_range_count)
> +#define TDI_REPORT_MR_OFF(rep)		((struct tdi_report_mmio_range *) (TDI_REPORT_HDR(rep) + 1))
> +#define TDI_REPORT_MR(rep, rangeid)	TDI_REPORT_MR_OFF(rep)[rangeid]
> +#define TDI_REPORT_FTR(rep)		((struct tdi_report_footer *) &TDI_REPORT_MR((rep), \
> +					TDI_REPORT_MR_NUM(rep)))
> +

So we all have a version of a patch like this and the general style
suggestion I have is to just parse this layout with typical
offsets+bitfield definitions.

This follows the precedent, admittedly tiny, of the DOE definitions in
pci_regs.h. See:

	/* DOE Data Object - note not actually registers */

I have a patch that parses the TDISP report with these defines:

/*
 * PCIe ECN TEE Device Interface Security Protocol (TDISP)
 *
 * Device Interface Report data object layout as defined by PCIe r7.0 section
 * 11.3.11
 */
#define PCI_TSM_DEVIF_REPORT_INFO 0
#define PCI_TSM_DEVIF_REPORT_MSIX 4
#define PCI_TSM_DEVIF_REPORT_LNR 6
#define PCI_TSM_DEVIF_REPORT_TPH 8
#define PCI_TSM_DEVIF_REPORT_MMIO_COUNT 12
#define  PCI_TSM_DEVIF_REPORT_MMIO_PFN 0 /* An interface report 'pfn' is 4K in size */
#define  PCI_TSM_DEVIF_REPORT_MMIO_NR_PFNS 8
#define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR 12
#define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_TABLE BIT(0)
#define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_PBA BIT(1)
#define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_NON_TEE BIT(2)
#define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_UPDATABLE BIT(3)
#define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID GENMASK(31, 16)
#define  PCI_TSM_DEVIF_REPORT_MMIO_SIZE (16)
#define PCI_TSM_DEVIF_REPORT_BASE_SIZE(nr_mmio) (16 + nr_mmio * PCI_TSM_DEVIF_REPORT_MMIO_SIZE)

Any strong feelings one way or the other? I have a mild preference for
this offset+bitfields approach.

