Return-Path: <kvm+bounces-31066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 493669BFF65
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 08:53:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C8491C2145B
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 07:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEA319AA5A;
	Thu,  7 Nov 2024 07:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TiEA/Gtd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B24F1991D2
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 07:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730966001; cv=fail; b=sMts6TFXpA+q7CgjqKE8gkF6JFqbtlz+XTa1DjYqMR8EOIl/4r685Z0CY5DKnSqSKZkmfU3wzmoW7HzG7XTJCrVkzKRVdMvTfhfUpGHn7bKbj3krEuEsEhqWoVjb2NN/2JKdC9QyAlOBikaIGNf+bSdVSSQnMvbzEuch0quY9j0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730966001; c=relaxed/simple;
	bh=XIjUyhe+BlE2ulvHPNXEkWZUfB3JcirS4Hz5eBvTwYw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nHKtt6+LwOtdRijinhTy0uVMU8j1NbA+5kpa+lIqp8ZYRkkyXHHPtPSiRNSv5nTNLVWK+6T5FWqG+SWwN/Xr232w16PjLOkz06PqOy1YvPNdenI5EFTyRkjN5UAtdgV7FWorfz4HmEvW4eLAV2H97Z8+qFjOyQwMfecG2Yc0mt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TiEA/Gtd; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730965999; x=1762501999;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XIjUyhe+BlE2ulvHPNXEkWZUfB3JcirS4Hz5eBvTwYw=;
  b=TiEA/Gtd46He8HIUroCRu+SHGELlg237m8azGj6kejwaMdzEN6fmIlFs
   vyPSOcGhtYXmjcIKNInJD92TDLLRUB9Oo4dY/PsOdo8qz+OMU5YhsvP30
   5OfXJJNLQ9v6UFYgf7evX+8LLX5tOL2dVM3iWqRGi7Nd9wnTU5a81xkid
   wYQCsgn5lvCURliEIY9c85y/hqNUZsJGYIZ+vE3jRNhONKPT4riGKdzv+
   GlolFuy/Cg1/d/J940qIoJ/MA5riA7ufbEuLm3Sps14Viyf4bnEBKCWlG
   I5xvgPwr9SepbmLsrWkMrHJBoFQU+il5FPLbFMbggxkjFaCnSPChllC8t
   A==;
X-CSE-ConnectionGUID: r1/2A5HlRKe+AVioGq5/ag==
X-CSE-MsgGUID: yY+njWtiRVCRRK7hR4j7lA==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="30218311"
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="30218311"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 23:53:19 -0800
X-CSE-ConnectionGUID: W8UTrpQUSoykL68B8hE7yA==
X-CSE-MsgGUID: VE3fb5VSR5GGAJeVsULv8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="89772148"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 23:53:19 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 23:53:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 23:53:18 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 23:53:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JGRN7n6ZN7Zf4le1KFpmFog9l3PT3XiV/uvULIm4rlL8eSXObkKcly/w5PdtJzcnGGFe51LbRlfjDpIOsYO+FeeuQhxzECbOUsRUnBxBwC+NpKdlliYMJrAfCpntQs70msnsI8aiEvLZYqPuQvVxBD/QnjDzsfCKAiGWkByNXQH8jfjlYurWdSlsEkEYGIpl/TFolBuTlFmtT73YC45aWe9RGHw/13in9veYVgy5jUIG3WpBWjdsdFGBHfiv6stEgAu7zWAiKnRT5BbxBjl59m5kpuNR0YAkgCD5hGSpnfmhLRVnOjAEVc0wYQkoNjv3MnoGYVJIb39Ijw1N9qM0oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5OZgHUkXDPlnU79+F/I5nHL/+41zTK4ZMExNoWHoGw=;
 b=MDyEFeYgflG+v2QyDrC4WSKwt66tzIoTHK8mNe9lkeMQORHVgZ7BCLhWOzgaflwMwGVEGU9H++0+ijHdHQkajmuDuZv2aINJJBjQ19JqUvBjP0RFF5+yZ06HEpUNmMqUMg0EUID+DK/Yl9iedMTQo+UQHpG+e2HA7GbcXbL3NB7QMhkbqv7rbPFtlWZgsxO3tM2PgDPwCgXOPpbK6JeJb3mYkGd+EDe3qExt6VvTNsJWZ+86aWqxI3artO8wCD/41o11v7iOlzmVOUfc5DpRFnNOP/9LB+x1FXGgBs3+tJ4REwr0WKDcQ3RNmyn+RUA+LauuUNCcXuwX6Pis4e5UAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB7102.namprd11.prod.outlook.com (2603:10b6:303:22b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Thu, 7 Nov
 2024 07:53:10 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 07:53:10 +0000
Message-ID: <9cc98d30-6257-4d9c-8735-f1147bd1d966@intel.com>
Date: Thu, 7 Nov 2024 15:57:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/13] iommu/vt-d: Add pasid replace helpers
To: Baolu Lu <baolu.lu@linux.intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"willy@infradead.org" <willy@infradead.org>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
 <20241106154606.9564-5-yi.l.liu@intel.com>
 <268b3ac1-2ccf-4489-9358-889f01216b59@linux.intel.com>
 <8de3aafe-af94-493f-ab62-ef3e086c54da@intel.com>
 <BN9PR11MB5276EEA35FBEB68E4172F1958C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7d4cfaef-0b3e-449b-bda3-31e3eb8ab300@intel.com>
 <8d015a7d-fa64-4034-8bdb-fffb957c0025@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <8d015a7d-fa64-4034-8bdb-fffb957c0025@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MW4PR11MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: b4bf5836-1e6e-4a5b-9f84-08dcff013962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U3lNRUVQbmRWYWFyRzhmVW91TXk1aGJqWFE4bG43bXJSZy9WMjEyK29ENWRk?=
 =?utf-8?B?T0hEREl3bStWc0ZrOUkrTGJIYnVkZnUyRWdCUk5zZExFYTdNMkJMdWVMdGFD?=
 =?utf-8?B?eU0yRWVhaThnWldIZkZiaU1rUDY1YWZnaXhKZjNsV24weXVtazQvSDY2NnAz?=
 =?utf-8?B?SVNDd3c1OWg5WnI4WDFZMjM2blE0REhwUXZ1aklnMXkyZ2Y4a3lTMHpCYm84?=
 =?utf-8?B?dkUrSHgwcTk2TG43OXVlUFgvWW83b1pydFMzbE12UlFva3ZFUUVXZVlrN0hu?=
 =?utf-8?B?dURhd0NuaUwwbVhMQWVUSmdqdkd2VFF0cEI2ZC9BODh5ckJZNWpneTN2cHpY?=
 =?utf-8?B?cllDalVGWklEa0hBakRKNHRPcmhKYVlGdDkxdmp0eWlLdThwSXVWVDZUN2xu?=
 =?utf-8?B?Zzl3d2NWTGFHcXdTVTJ5cWc0VHI1amZHWHZlRDZuY2xScmp6S2F5SjY4QlZO?=
 =?utf-8?B?Vm93a2k5Z1EvM2VYcWNkM0NOVElKc1VPcHFhbXFnSXJRUlMwb29WaHc0M3NF?=
 =?utf-8?B?NTJ5RFVLOFBFUDNJbFdHbWREejF1ZHZQNVNLdzRmekgwRFRTRElraXlrTmY4?=
 =?utf-8?B?VmNrOUhtdlltazkwbGxZVjI0cTdHZkFLMHhtZ3NReGhsYnBKU2hlQldVQ0NM?=
 =?utf-8?B?eHpzQjhBVXVoc3N6VGtKT1p0NEMvV0VkT2ZsMjV3SG9iRThQNC82MHBrUkxy?=
 =?utf-8?B?aWh1aE1YNy9sQ0RrQUV2ZlpNaXJOZzdNQ2VXQ3BIRU00UHBlbFFYZ1ZtT3k4?=
 =?utf-8?B?dnhTWWtHV2QvZzAzZmVhcG5pRHFEeFZEanV1VVFORDYxT0VPb3FLQ1dzbHJD?=
 =?utf-8?B?QjBFamdlTFNiendQRGllMUFaRldHRXdmTlp6UERMTGo3QkphSzdYOEVuZVlK?=
 =?utf-8?B?c3JYN3pmLzc4ZWF6Wjg3b1J0NkxBVk9OYUp0RzdZUTMvS0pkRU5rR09wTnVi?=
 =?utf-8?B?SG11NjFEa2x6bVRZbUVMOE9vaC9iOHJ5Y2JQS1lLb1VGZ1FkelB6WHFSTzNq?=
 =?utf-8?B?YWQ1NktEZ0lLNitBem94cmw4Ni9XQ3RGOThYNzhXc3V1MkRaZUdOd2VSOHE4?=
 =?utf-8?B?aGNaT0dWSlZtM2pkN0NnSW91aHJjVm9rTmU1cEZtSzlKQ2Q2ZzBGQTBiSVph?=
 =?utf-8?B?ZVlFZVVKY2dWM3RDVnMrRUlweW9NK0tPQUUxUDBKWUl6MnNDSmw0K1M4Tm8x?=
 =?utf-8?B?eS8vSjJZVC9MY0tGWVZ0bWx4dStabkV4bkhVN1QwNDZOQmk2dVhlS0VsZmU3?=
 =?utf-8?B?ZTJlM240NmZUNGxWZEdQV09vemZBd1BocGtuVXltcitqWEJQRGo3S0VONlMv?=
 =?utf-8?B?ZjQ3Rzc5a0pXWVpkTTh4ZnFtQVdJbWNvdUliY0N2ZDFjVHFiSjBsYnpCODN2?=
 =?utf-8?B?VGREK0grdGkwTnpURDU3TUE2aS9yckg3L0E3elpBRU9LSHNkQk5KWmcrT2wx?=
 =?utf-8?B?NE03dDgvNnRLTDJZaFJrL01UUklSYW9JL0h1Y1N3WEJ4dUdsTmVueHJTazFX?=
 =?utf-8?B?aW16SGpjS2JsdmhtemY5N0ZSWXF0Vi82dCtEL1Nybk0xWHZiUDdXZSt2WmZQ?=
 =?utf-8?B?emdZR0VvZ2dGVEpRZ01EWXFaWExETlhtOFVlcGN0UC9iSGM3R0FDNVh3ZEY2?=
 =?utf-8?B?SS9uOVNTeTdLVjA1U2JNUnhHbkExRGROa2JIMlZNcXlqV0Z3UzJWVjhxTUdI?=
 =?utf-8?B?aTZIRWgvN1pTaHA5T08zVDR1TDk3WE1QeCsxSEE1VG1TbG0xK0tIYjVNcHow?=
 =?utf-8?Q?BuncWOTB25yl2O4+uQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWprV0xiRURTemxEWHExMWNHaXhpV0hGQ3hUeHZaKzk3czlaMjlWZXl0TTdn?=
 =?utf-8?B?VzhMbTNhOC81SlRndVpRdGVCeU11bnVyeW9qNlRtU1prNzdCbXBZV2tPdUM0?=
 =?utf-8?B?cEdoMEsyMEdOOXI2TXN2RXJwTmhFMG9JaUQ3bjJ3RUFXQUlPNmFoVWVnS01j?=
 =?utf-8?B?RERzUXRFSWZqeDF3RW92UWIvS0ZHeFhVVkJVcUxIdUNIVFArWUlpbjN0cEFC?=
 =?utf-8?B?NGxjV2p1VnB3NzlvYTMxeklOWDNiMWhIUzFqOFE4K0E1QzdIbmZ0dzdFckZE?=
 =?utf-8?B?MFhNN05vTitxYlV5Rk5JRHBYbFpnaEV0UWZ2YWZnc0pyNHhlUVpqcHppOVVk?=
 =?utf-8?B?TG5oVGVkYlVZbnJuUGVxVVdYcXVHdzVGODlHOGE3OE51RURkN1k0Ni9rTlJH?=
 =?utf-8?B?eHFXejdvUlBxaEtFbXYyTmlKZGdsajJONVl5dkc5cDg3UlNvQ3NxTEVjRnYr?=
 =?utf-8?B?MUNEa2RLRlB4L0ZIMGxpZDByT3M4bkFkSG5mY2c2L1JjQ0x0bzJpN1MwRzc2?=
 =?utf-8?B?bXBQUjBLejNyVm1qaWV6UmVwdEV5TTIxaWRlWExsZDEwb2I3eTZaUXJsY1M1?=
 =?utf-8?B?SkRPV2pDanQ4aDNoQVpQSnVqeklYSXpvMlV6VVIrU3NhT1FEWkhyK1hrVkkx?=
 =?utf-8?B?dmc2WlczQ0d5QjR2bFFWQVVMdnUvdTZJOWp2MFVGdGdmZmRpbFp0cEd4OVJn?=
 =?utf-8?B?bDVadUhzcDRzekNuU3NQSCtrSXc4V2lBM1o5VzgyMG43eGZONmVodDhsVDdx?=
 =?utf-8?B?c0p5VHpHRmNBcmVzZ2tDTGg1UFc2QlRJYW1RRnpkZkNHVXJjcUlTckJvMEdY?=
 =?utf-8?B?N2VERGJNWnpTUVZoWlhJZk5Eb0hvREwzb3hJRkdKOGZlRDRBU1ZyYmNUeWtG?=
 =?utf-8?B?SzNxcFpyRkcyMENyRnpwOEYxWmdNeHdpbkFNWEJydDRrR29LdzhwUWFoSHds?=
 =?utf-8?B?OFo1cXE1SXJsMHVXdDFOSXpzQ01ZOEo0ZnRNNElnZjZMaHhZWks5MUo4d0Ix?=
 =?utf-8?B?V1dVNnJ3MVJuckFGejUyU0cyaDFYR3djR3J4dy9ZSmJCK1JRVHNXS2dKYlpZ?=
 =?utf-8?B?RjNWM0hnZDJ3WEEvYmJacVVSY2xUd09KU1JSK2p6NGVGZ3BVSFRwNC9DN24v?=
 =?utf-8?B?eTdGaFQzcVF6SXA2c1RSMDZRbnhVL3Zlc3hoRWdEcjYvWWd2ai9wT3pOcFdK?=
 =?utf-8?B?WkFqa2wyQzY0V0ZReVZDYWJoRk9LMUkwMHNaOG05UVAvNEhMMEcwTlk3TzVP?=
 =?utf-8?B?aWcwaDNWNUttVkFrb3JqaUhZRS9RRkhJUmZCS01WcHpoOGtBRDk5Nm1LU3k3?=
 =?utf-8?B?SnhEMDF3U1lnbVdFQ2xvLzRCNXZld3ZMb3BEbXJEejVUNEZydDZoeDdQYVRh?=
 =?utf-8?B?ajFUQkZKdXB4S0tQaVYwOHF6RTRkKysvSERjOXFYczhUUEQ5LzBPWldzSURK?=
 =?utf-8?B?Zi9WNVZtTHBUaFJQeGN4ZGEzNnNHdFpYK2JNbURJVU9RTHBSZkE3MVRPM010?=
 =?utf-8?B?bmxlRGE4NGpvK2xQV3Joc2w4Q0E0S2VVWHN0SlduK1B2ZTVuUVhhZjJPeGpP?=
 =?utf-8?B?QjdzR3RabXVkMkJ6ODV5L3NWdG82MGR0RmNZRkhuekRwYk9FYStVZlR1cFc0?=
 =?utf-8?B?MERVZzRVVm1jNUpFR2dlcEQyOEdIS2Y0ZDA1UTNpODRYOTRDOTY5cUZQVDZW?=
 =?utf-8?B?MGUzNXVXR2xLVmRDVkNFWDVHYW9Uczk3SE9haDcvVWV6NWN0ZGFpZlp0ZkdO?=
 =?utf-8?B?VG8rZlhvYUozMXhSSFpEMUZRMHMySE5WYlRWSTJkdGUzYTI0dUQ1SUhmT1ll?=
 =?utf-8?B?RE5qa1NxdWgrb29lK1lmWXdkc1NobTYzSVpDUUJoWlN0am90QmNpS2ZXSUhV?=
 =?utf-8?B?NDVpcjJNbWxncEFHS0V0dGs3YnZnZXJYbWhENUp2bDlzQmJXOFFBU3B4UjBE?=
 =?utf-8?B?MGVmVHhGTGVHMlBDTFRHQmlhZTFaVDVtZ2ZvMkZoVzFGdm1EOVZpTjFyRnAx?=
 =?utf-8?B?VGMrK2dDTEx1Q3dCWFR5c01wR3BvRFpDeUgrallaTXpMOUNpdy82TVpFeHJZ?=
 =?utf-8?B?bHVYRktOMXJZcEdqYmc2a0NkQk1Sdm05V3hORENxZ3QxUXlOWWthSk9ydnZz?=
 =?utf-8?Q?vTVOqF3/tGvQ6T3OTP9EQwxns?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bf5836-1e6e-4a5b-9f84-08dcff013962
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 07:53:10.3800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ws2wGfxdhd/iFcB8H33kH92OVVoDNMt/ZlSgdGtiZC345vyNeXHWHjLVLL2G4O30BwBeum91Y4W2r3gIPZ2r4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7102
X-OriginatorOrg: intel.com

On 2024/11/7 14:53, Baolu Lu wrote:
> On 2024/11/7 14:46, Yi Liu wrote:
>> On 2024/11/7 13:46, Tian, Kevin wrote:
>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>> Sent: Thursday, November 7, 2024 12:21 PM
>>>>
>>>> On 2024/11/7 10:52, Baolu Lu wrote:
>>>>> On 11/6/24 23:45, Yi Liu wrote:
>>>>>> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
>>>>>> +                    struct device *dev, pgd_t *pgd,
>>>>>> +                    u32 pasid, u16 did, u16 old_did,
>>>>>> +                    int flags)
>>>>>> +{
>>>>>> +    struct pasid_entry *pte;
>>>>>> +
>>>>>> +    if (!ecap_flts(iommu->ecap)) {
>>>>>> +        pr_err("No first level translation support on %s\n",
>>>>>> +               iommu->name);
>>>>>> +        return -EINVAL;
>>>>>> +    }
>>>>>> +
>>>>>> +    if ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu- 
>>>>>> >cap)) {
>>>>>> +        pr_err("No 5-level paging support for first-level on %s\n",
>>>>>> +               iommu->name);
>>>>>> +        return -EINVAL;
>>>>>> +    }
>>>>>> +
>>>>>> +    spin_lock(&iommu->lock);
>>>>>> +    pte = intel_pasid_get_entry(dev, pasid);
>>>>>> +    if (!pte) {
>>>>>> +        spin_unlock(&iommu->lock);
>>>>>> +        return -ENODEV;
>>>>>> +    }
>>>>>> +
>>>>>> +    if (!pasid_pte_is_present(pte)) {
>>>>>> +        spin_unlock(&iommu->lock);
>>>>>> +        return -EINVAL;
>>>>>> +    }
>>>>>> +
>>>>>> +    WARN_ON(old_did != pasid_get_domain_id(pte));
>>>>>> +
>>>>>> +    pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
>>>>>> +    spin_unlock(&iommu->lock);
>>>>>> +
>>>>>> +    intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
>>>>>> +    intel_iommu_drain_pasid_prq(dev, pasid);
>>>>>> +
>>>>>> +    return 0;
>>>>>> +}
>>>>>
>>>>> pasid_pte_config_first_level() causes the pasid entry to transition from
>>>>> present to non-present and then to present. In this case, calling
>>>>> intel_pasid_flush_present() is not accurate, as it is only intended for
>>>>> pasid entries transitioning from present to present, according to the
>>>>> specification.
>>>>>
>>>>> It's recommended to move pasid_clear_entry(pte) and
>>>>> pasid_set_present(pte) out to the caller, so ...
>>>>>
>>>>> For setup case (pasid from non-present to present):
>>>>>
>>>>> - pasid_clear_entry(pte)
>>>>> - pasid_pte_config_first_level(pte)
>>>>> - pasid_set_present(pte)
>>>>> - cache invalidations
>>>>>
>>>>> For replace case (pasid from present to present)
>>>>>
>>>>> - pasid_pte_config_first_level(pte)
>>>>> - cache invalidations
>>>>>
>>>>> The same applies to other types of setup and replace.
>>>>
>>>> hmmm. Here is the reason I did it in the way of this patch:
>>>> 1) pasid_clear_entry() can clear all the fields that are not supposed to
>>>>      be used by the new domain. For example, converting a nested domain to
>>>> SS
>>>>      only domain, if no pasid_clear_entry() then the FSPTR would be there.
>>>>      Although spec seems not enforce it, it might be good to clear it.
>>>> 2) We don't support atomic replace yet, so the whole pasid entry 
>>>> transition
>>>>      is not done in one shot, so it looks to be ok to do this stepping
>>>>      transition.
>>>> 3) It seems to be even worse if keep the Present bit during the 
>>>> transition.
>>>>      The pasid entry might be broken while the Present bit indicates 
>>>> this is
>>>>      a valid pasid entry. Say if there is in-flight DMA, the result may be
>>>>      unpredictable.
>>>>
>>>> Based on the above, I chose the current way. But I admit if we are 
>>>> going to
>>>> support atomic replace, then we should refactor a bit. I believe at that
>>>> time we need to construct the new pasid entry first and try to exchange it
>>>> to the pasid table. I can see some transition can be done in that way 
>>>> as we
>>>> can do atomic exchange with 128bits. thoughts? 🙂
>>>>
>>>
>>> yes 128bit cmpxchg is necessary to support atomic replacement.
>>>
>>> Actually vt-d spec clearly says so e.g. SSPTPTR/DID must be updated
>>> together in a present entry to not break in-flight DMA.
>>>
>>> but... your current way (clear entry then update it) also break in-flight
>>> DMA. So let's admit that as the 1st step it's not aimed to support
>>> atomic replacement. With that Baolu's suggestion makes more sense
>>> toward future extension with less refactoring required (otherwise
>>> you should not use intel_pasid_flush_present() then the earlier
>>> refactoring for that helper is also meaningless).
>>
>> I see. The pasid entry might have some filed that is not supposed to be
>> used after replacement. Should we have a comment about it?
> 
> I guess all fields except SSADE and P of a pasid table entry should be
> cleared in pasid_pte_config_first_level()?

perhaps we can take one more step forward. We can construct the new pte in 
a local variable first and then push it to the pte in the pasid table. :)

-- 
Regards,
Yi Liu

