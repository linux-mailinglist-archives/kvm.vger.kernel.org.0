Return-Path: <kvm+bounces-72454-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WL7lOncrpmlvLgAAu9opvQ
	(envelope-from <kvm+bounces-72454-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:29:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 401D41E7203
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:29:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E01F307DB36
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D69A213E9C;
	Tue,  3 Mar 2026 00:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c7441j95"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78171DF26E;
	Tue,  3 Mar 2026 00:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497765; cv=fail; b=hU14yE30rgys5iu0FoaAxkD4ckdxJWEWkg0+zbQbGEcWKgaEav3n04bZG6cuhlYc3ARe2X774DZIPTKnOxMtsLsJGkzrJIzoIhtCSNubmuC7wnZJ6M+FDRM/ys31yNK6cbsBPjRmByXSiDd30MiKmcrAmN/SQf4VMRSqtdh2fpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497765; c=relaxed/simple;
	bh=uSzBkPI3J3UBg/Sn9R4a4smEsYVBz+TipHTYH5sYwyw=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=g/koeEVj7XV8JT2jMrfmRemD9u/WL6ILABOriG/sGuuwtP5ThfKi+JWVL4ulV4ITs5k3tZjRNxoHlJeke9/eg2T7j8SPpU9iEVFJ74Yb/tBtEhg/2+g+BoPqAVDoTam31oLvsnM0HS1pkv6l4wY99Jw731zHv1upT/8D+B2aGtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c7441j95; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772497763; x=1804033763;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=uSzBkPI3J3UBg/Sn9R4a4smEsYVBz+TipHTYH5sYwyw=;
  b=c7441j95g7J7HcDKHLXEVLGex1qgoRirkbyHSuMg20141dI94cWtacT5
   euFWE4ub1pBXtxzVojrIE5luQ6S/D9do41PfP77KMUCKZcBl8NtRv+Hyb
   JgtGIWVde++M+wscqsJhqbjogXCIUxHfz4aKiNoMNqOd56qp6IBq+pTHx
   Bn514I+Yq/MDGu6ZRSVIoHeVwdPF+c5GbbUfZ2mkMcSwYQDUZFzbkPsvD
   HW2nFQiTO1aQz9s29pbILZf2wPFN4A4ZfasueCyNBrinrg+6FFDEG/zDP
   GOw7xpc1d4/tn/Lr+tawqyVEqPr0+BC/1EjfNFoIrUI20VbM9WMnqDgvH
   g==;
X-CSE-ConnectionGUID: 4WdskgRVSOuZe1T5hV5ZCQ==
X-CSE-MsgGUID: 4cC1KoDtRzmQXk692LRKig==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84988057"
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="84988057"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 16:29:22 -0800
X-CSE-ConnectionGUID: sOrAl4qkRdW7H+M0ONsY4Q==
X-CSE-MsgGUID: GCmy5thpT/+GdaOmXBQsTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="214972540"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 16:29:21 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 16:29:21 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 2 Mar 2026 16:29:21 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.16)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 16:29:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzoYKy6WMeNUJeVAoj4lTG2ie3nvLigD3+pDeilFnMtgjw6fH2rMZb6NVI6MyI6Ddl1DJE+ZbOmTzBGZpMSwVvrLw5R1DWrVXL8oTMnDxZ7R+zEWIR0NAo6290kuvEeVvUVEmeIW8GHTU7QGlnttKK9Yw7qmI6ZM1qaF/DwZMPyNAnypzM56UBBT0cPxTVrOarvu3khib5WdrhPrGdGF5FrzX3N9fRF3ftF5Jsx6g7V+7ggh3D1uxm3II1IZtgE8ODqUWeKN0EN4eBTp1c09IEZR7omHP2vbtSnT3YvgZL1316hDdXyKNR2seutn4NR4plCDT70gURBIkrRyn2JWZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Br4jupAipxzY7wciHwvsNjpqSshZYVEcKUghN+gQxdc=;
 b=v19D84tLxwjTF2ASWcKDIEtNwroOxJ2Uln7+WAqAazS5fmcaVrYiZYxqzPLGK4hLLKuHHFoAoMiyPxSm2PQMeSzmizNTpgShtIPK3Ot+5tuRNETp8GlVihiMJuuELrEisjqN+6fwUtRpxnjpLKnqYA/NASjNxjFPOZuFwS+KgVk0NMp/fQlxavh+8jCG2e5olDxf/ZcDuFqsVU2aViK8roRCXWDfmKJaE7v0MV1qi0EpxkkaXai7YRTYQFcTJfkzunAAxcu4X0M6sVYxKKlehJeMIjO+6LKSQUkT/FK5zy8JnDdJymsyV81GW/vMYdiMoYPwD6EeuK+KKQG7zSYTRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB7384.namprd11.prod.outlook.com (2603:10b6:8:134::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 00:29:13 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9654.020; Tue, 3 Mar 2026
 00:29:13 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 2 Mar 2026 16:29:11 -0800
To: Jason Gunthorpe <jgg@ziepe.ca>, <dan.j.williams@intel.com>
CC: Robin Murphy <robin.murphy@arm.com>, Alexey Kardashevskiy <aik@amd.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>, Michael Ellerman
	<mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>, Neeraj
 Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	Stefano Garzarella <sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>,
	Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>,
	"Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>, Andi Kleen
	<ak@linux.intel.com>, Kuppuswamy Sathyanarayanan
	<sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
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
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>
Message-ID: <69a62b5714feb_6423c1001f@dwillia2-mobl4.notmuch>
In-Reply-To: <20260303001911.GA964116@ziepe.ca>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-5-aik@amd.com>
 <699f238873ae7_1cc5100b6@dwillia2-mobl4.notmuch>
 <04b06a53-769c-44f1-a157-34591b9f8439@arm.com>
 <699f621daab02_2f4a1008f@dwillia2-mobl4.notmuch>
 <20260228002808.GO44359@ziepe.ca>
 <69a622e92cccf_6423c10092@dwillia2-mobl4.notmuch>
 <20260303001911.GA964116@ziepe.ca>
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0067.prod.exchangelabs.com (2603:10b6:a03:94::44)
 To PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB7384:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ef8c81a-4dba-49b5-3631-08de78bbe50b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: IUzO9P4pUEviosfX9XrZIi6l+tEen40Z9ZjlsJ+oxPMAbdUHT3kHiqH5Qivlwcg/s2qqBDGFjsU9HA1aN+wVJLbyR31e5k0V159L09yt9r7FZXXV8wJanpta7D52wu+pv0m1TCgCB3/6tJKJAyQQzRAXuVS34s1RgMW6IjHQ9riQ3UMvOgbAZ5I2vmuq2QiaEwVONlbz8qxvz0rpamHWWFGya9S9qyeeL2GHxEHftFeKejZXtls6R2hvSbm92DYrPht2qijPlsdQJ/2dHgUKMt1jEid4mqGCze8oo1+QdpTKwUG24AQM67LCCTsrC3B1ufEQyFmNYjy+AdpLfrT7LTDkjn+MmlrJHxNupfLT/cTLZuDUPsHVZJH4oeXv6hnOSRTzAl6vnykU2cS4ERrmEQbA437rwAH9FasybsrJVtLy6q6SArW6M+r6TY9V2X2BEIeVyhc1jiGCEjvPkgECMfeQ7gW/45Uaa2SJB2JQQ+ixO/GpBuNoBrLl9e5zMpvfpOJBm92WxG5zQEP/T7stQB6tRK9SF0iKEcau/2ueKkF2oa17PLQvax1E5haQtplVbS6L7UwVycBFq3AG8xJ79akEtLZhM82mDnQpvSsW8h9Np5x7dHwKGEQVmP5//o0fBdjWoE7G2Tnf+lCeci5p8YNrYiQCUF50SvOtuZ7NlfvJHi+vVuHBZQEnUoqi6uWm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFpFN05HRTZKZUZhVlZza2x4ekh4dXBqckV3V1QzaEwrRkdpVVI0WkFoSHla?=
 =?utf-8?B?dldqQzBWUStQQ0YvQ2d6eEtISGdYaEttSE1HV2svWDlEeWRJcElURmQ3TmNh?=
 =?utf-8?B?NUw4TXRXMytGWnlNZHI4MkdtUHZOSTR6SVMvL043djRHUHNrTm96dHhta0Mv?=
 =?utf-8?B?b1dhdWdRRFMrQklXcDNGOEY5elR4bkppTXB0SnErUG1IdHdLM2liYnFpcVhv?=
 =?utf-8?B?M2lSZ3JrSEJoRXhZcjVINnBuckVLZ0QwVURvMU5sWW5vUU10WkM5Zy9mejgz?=
 =?utf-8?B?QU41eWpBTlhCSXlOVmMrUWZTN0xya3o5YWJEU3YwRmVodW9KN1l5KzMxRDNu?=
 =?utf-8?B?U2FUclZmenBIVi85SEFzY2JmalBWVGREQVJWQktIMUVkRE56eUppTzc4aS9B?=
 =?utf-8?B?ZnNJQm90dm1qZkt2ajAvUTdMV1BLNC8xelFWSnRKbnVhMnJKVGpTMG5tbmg5?=
 =?utf-8?B?VW40VGNMdHd3T0tVTzdHVldpUHYvN2VJY1JjdDBWYWhMQXJyYndrRFprZFd4?=
 =?utf-8?B?ejRVZWtZNEcvVkNwVzlZbVZkN0hHVGhlZUEyTWFzZkwyV0lCZzQ5dmROQnkz?=
 =?utf-8?B?NnVhTW1raUZOK3grNUJjNFQvNXZGWG9QR2ZPaGtxMkF6NW5UQnNESXd3N2U2?=
 =?utf-8?B?YUpWRUtBT3NVMUI5dzVNeDZ5dmpDdnBnWVRHRFhJSVQzM1pVYS9DaWxJL3h3?=
 =?utf-8?B?QjBrZHRoaWtYWVFIVnRpSUM4cXJvWDRFY1VHeUVmQ1MwZWdGaWk2Z3JwblJz?=
 =?utf-8?B?ellQS2tkZ29ZOEFIRTAwV3JkYm4rSUYxRFJHNmUyT1F1d09sdXBBY015YXY5?=
 =?utf-8?B?bVdMdURKZi9pUTJNTzYzcUhlT3QrWUFJVzYyN1o4YmlzMy9QUW4zUHVLbFFo?=
 =?utf-8?B?NVhPbEJWTDlJcGNoS0hvdmhCZjhKL1N6QkVUNnJmVTdhZ2VRSEM5N1F1MW1X?=
 =?utf-8?B?ZGFRWG1VVXZRYXlhbGE4RFRnVGNEdDhpL1ZPc0MyM2JOVVZqZ0JNa0Z4SDdz?=
 =?utf-8?B?Sy93c3cwYlZPcG5tTXRXOXVWdEQzTmd1bmVjQ0pNOUFCREFvVTh5UXVVSm5u?=
 =?utf-8?B?MElFamZ6R0IyY25iRUdkenlqSkpIYyt0L3lRTGZBVnJRVVJuRGwyYlYxYzlK?=
 =?utf-8?B?SWVZRnF1SkJKeUR1NmZVdDdTQmxtSU1IR0NlOTYvc2VSTDc0UG1kTDAzOHVv?=
 =?utf-8?B?bXFld3Z6bmMvcURRQ1h1SzkyN095RFFvTWRDMHJRc0dveFJOeThNQlRzSm41?=
 =?utf-8?B?d2pPdHdvZHhDZDNxTnVnUXFieHBWd21jM0tzOWVQNFJ2eWdVR0dxWGN0SWdW?=
 =?utf-8?B?MHpjQ0dZcERpSlExSEtvWFhoT0FiL21nQXM4RS8yamNlOEY0bVpLUTZWcjRl?=
 =?utf-8?B?YTRFTGtGK2pyMk0zYTQreURhRU9BK3dsUVN5c0g2RVhNTGd0dmNuRVVmczRq?=
 =?utf-8?B?UGdCZnJwSDd2MFMyOUM1bTBQVk4rRFVKYjdTSzZNaEVpdHZqeFlHY0tWRkFh?=
 =?utf-8?B?Y1VwdGpCc0FYdXNDVFVidXJ2Qm1IMmwwSmRtWXlneERxeElYL2NjUmIrclo0?=
 =?utf-8?B?RUJ0eUszbWxVcHYvSUdnWXpvZlE0SytlekJON3V3NHBPMGJDem5zZUtyM3Vu?=
 =?utf-8?B?Zmx2Vjl3ZFJtUlJNSjRTbFdVVk9TZVN5aGtTOHd2aWxVeHZ2eHdPSVE5bVlu?=
 =?utf-8?B?U0p0WlZBb0c4akMzWS9naUNKYzliaWVpYmx3WklIYUFuNW5STHN2T2ZSVnNy?=
 =?utf-8?B?VE1qVHhBcUZycEZ6WVZJcDk4Z3ZDczRkZkp0WGY2K3B6eldJNTZkYTF1V2tR?=
 =?utf-8?B?Q1IwV0dkeFBxcVNLMDNRdXMybmp3Y2VGZ0hsVWlFaDF4MmMrMkpwV21oR3Fq?=
 =?utf-8?B?R1VYSWE4MHhuL0t4T1ZaK2Q2R1pwOUg2Kyt4bXpiaXhHTGJrcUlYbzVyTEdx?=
 =?utf-8?B?dXAyWmVlWjFDWVVOSUV1VTgwV090T0U5T2RUSHJwWWJxTTRacHhBQmVaZmdw?=
 =?utf-8?B?VEt6ZjJUcWJ4azZwZlZYTFVqbm80SGNiamlsRU1tbjl0dUNXcXhLaWg5Uzll?=
 =?utf-8?B?dTg3aU54ZFBPRWZXTENXWkVQQUZpMld6OEtHM2Jjbk9LY1dpNTVjK3puQkdX?=
 =?utf-8?B?NTlGd2JQRHhPTlZ1RnJoUjcya2hVbXJGQms2V2xaZkdRWDFJMnhRRmY0bDkv?=
 =?utf-8?B?ejcyNTg5TTd6cnk4U2pnQUFzY1ZEbElvQ0xlUmN2SWNjZUZtRnMxV25oMC9P?=
 =?utf-8?B?NlpFdE9UWjJJemhvNEZKR3o0V1pucGNaNjVVQnJwbjQ1cDhyY0tPZDZMUVVh?=
 =?utf-8?B?U24zUDhETzZZNG41bDcxWnFlUmFGeXN0WXVBMXlzM1BwMVcyRXRJaTZpRFNv?=
 =?utf-8?Q?RXD/i/w/bxlcWTJM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef8c81a-4dba-49b5-3631-08de78bbe50b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 00:29:13.2363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eiYkbfVqNliPR5HFEexX6fgOBtfwE+Zu5NrMecoEhMfTe5cHD2a5bumpfFgr+DhL5OGNyOVHePgUx4gYJRicxtfsyaOblePSJ4XUKGG8jx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7384
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 401D41E7203
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72454-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,dwillia2-mobl4.notmuch:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
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
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

Jason Gunthorpe wrote:
[..]
> > I have a v2 of a TEE I/O set going out shortly and sounds like it will
> > need a rethink for this attribute proposal for v3. I think it still helps to
> > have combo sets at this stage so the whole lifecycle is visible in one
> > set, but it is nearly at the point of being too big a set to consider in
> > one sitting.
> 
> My problem is I can't get in one place an actually correct picture of
> how the IOVA translation works in all the arches and how the
> phys_addr_t works.
> 
> So it is hard to make sense of all these proposals. What I would love
> to see is one series that deals with this:
> 
>   [PATCH v2 11/19] x86, dma: Allow accepted devices to map private memory
> 
> For *all* the arches, along with a description for each of:
>  * how their phys_addr_t is constructed
>  * how their S2 IOMMU mapping works
>  * how a vIOMMU S1 would change any of the above.
> 
> Then maybe we can see if we are actually doing it properly or not.

Yes, this is my struggle as well. I will put this on the agenda for the
next CCC call.

[..]
> 
> I'm surprised because Xu said:
> 
>  This is same as Intel TDX, the GPA shared bit are used by IOMMU to
>  target shared/private. You can imagine for T=1, there are 2 IOPTs, or
>  1 IOPT with all private at lower address & all shared at higher address.
> 
>  https://lore.kernel.org/all/aaF6HD2gfe%2Fudl%2Fx@yilunxu-OptiPlex-7050/
> 
> So how come that not have exactly the same problem as ARM?

Sorry, yes TDX has same behavior as ARM, excuse the noise.

