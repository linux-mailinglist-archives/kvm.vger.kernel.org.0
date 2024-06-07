Return-Path: <kvm+bounces-19099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 024B4900E3C
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 783A2284999
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 22:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A056155C81;
	Fri,  7 Jun 2024 22:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OKBd2Fgh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A711313DBB6;
	Fri,  7 Jun 2024 22:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717800903; cv=fail; b=ZPkQGYp1JXhjIXkwbo0op2RkhhVTBPvAnokgfiqlzLjJ4Jdv3s43eXdoi5pf4Fr/0ENAoeUPjKwn+HackeZi6Ni9vqBu5hC5EEiHjqfEGP6g/NA2CBEXNKmRNAmKoNqv9+FObuYzzrc7tmWoKEnQnAhbqpDOhGRg2K4ABdgrW58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717800903; c=relaxed/simple;
	bh=IJGfdmC2kB6+yn8lIP/ahHLbsQSmmRoxLf+v1BzzqeE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dQFxNtiblj1SL9SQeQQH4I9VGHCCrMfjGVtAClccW/8T/dpsw8i8535mGkwx0anIq9f/PcmuLbVGNqKuYgf3capzt6Bsm/mDPM1IZ6xaXS99QskMqUujplJIKpPVp2qel+lJuMwJYqHrk1Xz54c9raSI2Vdki9fyl/vttMBVz2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OKBd2Fgh; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717800901; x=1749336901;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IJGfdmC2kB6+yn8lIP/ahHLbsQSmmRoxLf+v1BzzqeE=;
  b=OKBd2FghB0xlW5YVPd1D6Jfgf438W08Ts+MKtr/G5wpM8kuBIakA3xui
   WJGA9xzGI2Zzk658vRvK35VUd+0U4OwZ9lpJ0Wtpn1r+B3F7hpdiTHTQf
   bHgLq5HmEohqDK9HWHsOjyLDSjz/2hEbhqszUa2llkf9K5Znp75a55uh1
   ZG9OM7d7hAKD5YK9yJoommSINzPI02RUNOky+QH+cY9gWZTz85bl8qW+e
   oqMHk36yqkb8kDmleT03fGzRuMc7UBVmypZ6xca1fmO2+ZS0SvVYfbv3v
   8MWfGPoaxmz5S286fUfq4jXyxAUZUr1KEPKO3FYx0ZCP2yiHkFCSNoHu1
   Q==;
X-CSE-ConnectionGUID: i3iWS5hmSy2n8bnhd14IDQ==
X-CSE-MsgGUID: yyqvVbJCR123GwIfCKUgAw==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14697887"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14697887"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 15:55:00 -0700
X-CSE-ConnectionGUID: t/hrPvygRL2rQiRX/E+0Iw==
X-CSE-MsgGUID: M7QOZ62DQ3+dqgIY47F4pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="38547828"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 15:55:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 15:54:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 15:54:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 15:54:59 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 15:54:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxkmFiF2ZIN+Ssi64J8pDFTVIn8CChs4RNt7V/zMigBXxmY21UK+1an+3SXHb49qDlhZvKk2tEPWK38jCW1lA2TTipGH7SuTGr6Kpa1IHINepis4hCM1Tb3WYXwoytcIzvUjePIvrRWWD7yjA0bGVRTZh2WEYGnWIT0KKBa2gVGQgvF/86gZsVbSaA2UaM4bFal0bG2AqnW3n3A1bMP0YIhKiCFNvQ6gntlH32cl+jaEt4AzQx9k1pSLGOrL3PKJC/Fc/RkKRgTO+uGQDG2CayIlBSeUDTx4xS+Pet0evrVIHyVcZ/6HbXYLShpTeWJO+pmWqcADluwOoPpp4Y3fHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJGfdmC2kB6+yn8lIP/ahHLbsQSmmRoxLf+v1BzzqeE=;
 b=WSu+qj/+dvB5RJx8b3ImdQQSDDaDoTzDA70MAUgpS997parGsAxdPjJg1ky0ALhlxj8wjrn7bdz1SSjaWhBXNkWtpThC1nZKRcDAaDoAeuMwh72W/eTw08gBJu2n8dsaIafzbvbrULz1V27WIffhCCAo1+TZ+z4bon6QeP9cwq+oY2N/F0hDW3ujgSs+kvxUx95KgITGDYmRGGQ70w5DRC2fYd6ksyKqg+k2+vruAWc4JBaOCRa7m/K3N8JfeVjmYYEMPyp2JA+rIf375W4BuM/Sqp8tdIqImpnQHxjucFc6ZIIkycaLKY1XJxK/Eu+Naptnip91oas75Z7ctUNSxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB8282.namprd11.prod.outlook.com (2603:10b6:806:269::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.34; Fri, 7 Jun
 2024 22:54:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Fri, 7 Jun 2024
 22:54:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 00/15] TDX MMU prep series part 1
Thread-Topic: [PATCH v2 00/15] TDX MMU prep series part 1
Thread-Index: AQHastVnCrlKNLpteEu+gVS/gsyBM7G8OOyAgAC80AA=
Date: Fri, 7 Jun 2024 22:54:51 +0000
Message-ID: <1fdb2533412513078a92398d5ae0a0159d08647e.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <CABgObfZigjQHxdHHhU3n1oP=wq-G2rS=AYaSzmPdP39qCUmrGg@mail.gmail.com>
In-Reply-To: <CABgObfZigjQHxdHHhU3n1oP=wq-G2rS=AYaSzmPdP39qCUmrGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB8282:EE_
x-ms-office365-filtering-correlation-id: 4a151390-220a-4dc7-762b-08dc8744d6ee
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Rmk2QnZJenhiUXNabVF4Zm01ODd1VEV2SVQrWjhjeHlOSVlLL2wzbndEemFU?=
 =?utf-8?B?ZGx0YWlrQXpuNVBUa1ozdXNnVmR4ZWkxYWp5VnczdkVsM0QyNG1rSlNhY3Fr?=
 =?utf-8?B?aDNNWDgzN085NHVGZGY3V1k4bW90enNCQXBrdlFvQ1ovRUZ0aG5pMlJGS29k?=
 =?utf-8?B?ek1nMDNPYWRGOThocElMYU9pUjdHdGEzWWdzQlRyMlJ6dDJwYmtUUUsvd2lY?=
 =?utf-8?B?V1NmNnJjc0M4cHhQbm5kQnd2YXNsTm1QUTNNbjlUeXo2bmRxci83aEpLZ1A4?=
 =?utf-8?B?Ukp0d3U5OHNYUjRJd21nbDZqZHM5ZXhmamVnenUvVnlvTm15allPRTV2TVBy?=
 =?utf-8?B?VDZOMFlMNE1TVFd1bURLU0greUk1TS92RXZQRUZOczcrdExkY2tyMUVKakc3?=
 =?utf-8?B?Mys4OEFYMXVKNWtMTEVmOWVvM3IrWWJrem5kOU5zOGZxaEdVYXEvK2RRTldt?=
 =?utf-8?B?YzlYdmxBblllclBkTlp4OVlIN0NIUndRUVBkelNHYWVla2tIYmtTbDJlbDVX?=
 =?utf-8?B?ekhBa1plOWdiQUUxZWJEOWQ1cDQ3TDdTYzhNTS81WGR3QWYybDNnVGcwUmNx?=
 =?utf-8?B?aWFqalY3MjJlemMwVEVoN0tZbGh1cHl0NXQ4L3FVU0Z3cW9LN3BLTUR4Q2h0?=
 =?utf-8?B?WWQ4YmJ5U1NjekE4QlhWMzdJd3diQk4rZWxmWjdjdTJ6TGpjN2xJdFJPVlpZ?=
 =?utf-8?B?M2NLT1IxL0gyTC9HdVRyYWY2enVwMEVxWkdhc2kxQy9GS0t0NUpzcnRGM24w?=
 =?utf-8?B?VnBKUUovWmowcmFhRDRjbm1sckFyaG5FOThxRlJpK1l2cC9jcFhLdlQ4Z05K?=
 =?utf-8?B?ZnRmRytYR29NME5Dbnk4QlpYZDRSVmdQTW5Ua215TUZBUzRwbFBJTGtLU2RS?=
 =?utf-8?B?MmhqVnJsaG93RVNyWHNCQWdFTTBYUklQby9LM2pwblZWNU5BazlCc3dWUWlI?=
 =?utf-8?B?YVhZM2JDNGh3ME1QQ254S0I1UXNGQzJETUUrU05KU2VTU01kU01QcDRwSFhO?=
 =?utf-8?B?Qm5IaEJ2WjV6NDROQmhTSWFtaFpqdEVjYWV2RE5YZnc1K1VXV2hmeEhJSDRB?=
 =?utf-8?B?WGhFM25Nb0xjV2hoZG5lV3JpbXQyNVpuN1Y3WUlVcDh5QnZiaysvRFB5YUlk?=
 =?utf-8?B?QWNqN2pjMm02Tm1qMXZuZEdUMXVpcXAxeGJDZTFnOFhpSUtyUEt3WGxiTGJ6?=
 =?utf-8?B?MzdIU1dzcTdXZ2FtLzlOdEVKUnNKSlNocnJOSnUvdjdPQSsrSHlQcVZLZmNr?=
 =?utf-8?B?RFlVRnlFSE1DOFBrZUh6dStvcThCZCtLOERWV25hNWlQb0lLeUlUMFlUVkVx?=
 =?utf-8?B?bWFSSnJSWkVXeEoxZVZ1RktzR0xwZms1dnpVVlFXa0Z6bThvUDJ3dnNEYUdw?=
 =?utf-8?B?K3k1SGp1K2VGQWRGMDhHY29VWnAwTFRTdlVndUJzNGVXNXArNXJNY3NTY3hm?=
 =?utf-8?B?OU5kbUFxdThGeHRTQVZ3eXBzandINS8wWlZOUmJ5aDdvOEdPVGIyZC9VRUVD?=
 =?utf-8?B?bWU4RG1HQnMxMWE0TElMMXBSdjJ2dGVCOW41WDZJMlMvdEYrYXkwSnA0bU5l?=
 =?utf-8?B?SHQ5elJ4SHBOelVsMytIelpwQkpWSkpROStCRHptdmQzZGlyZDhOeGt2a0w3?=
 =?utf-8?B?cEFPQnkreW1Jd2Q3THo3eHFzbGphaktESW9oaWJZS2srLyttUks2bUpoN2dG?=
 =?utf-8?B?eTVTTDJ2S2dtSXR5MnF6T3A5cVJsUVAwT2ZQOTA3K1A5Nk9oTE53K1FBRjUx?=
 =?utf-8?B?QjFWRlpoeXE3N2Jiblh0bUd1Y2pPOGEra3NpcjVENTU0UTZqd3NmV3IrNllr?=
 =?utf-8?Q?aOB3v/HPWbxMFk5S8b9Z2+V2w+uSc6Iz/sbTE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MEIrM3oyR1pUc0JpMk92YTdKdkR2OU5MSVBPWm5nUXV2eGJrSWpwWDI3L1RF?=
 =?utf-8?B?ZmE1MldUWnk1aXRiVDgzWW5xZk1lbkdVZnNaSHo0clVSdzE1L09od3lNcGE2?=
 =?utf-8?B?NFQ1ZmlhWS9tcmV4L0tEOW1EYnpIQWEwN0dTcDFmeWRXN040R2tyQXR5Mld2?=
 =?utf-8?B?RE9Yb21LZ1RyUzA5M1FydU9aQVFaSTlVSC9XYnFhWXFCM2JDdVNTdjErcjhN?=
 =?utf-8?B?MG5WT3E3K0pvWUhaRWI5dTdmQ1JGem4rTWsycTVDVlRqNHBEK2VwdFlac2ly?=
 =?utf-8?B?Tm5NSkRxT0JQMmFvVE1ka21SR1NEUkdDYnlnZkpUTUZJM2licGtLaVFYSjJ2?=
 =?utf-8?B?OWNEendnM05DYlBFdGtkWmJ0YVRDeUZaY1JwNVhJSDlsTVd0bzA5N3pLS2Fq?=
 =?utf-8?B?ZU9OU1BOZW53SGRhbnJIdlRBY1BpZDFUaHErQTJDWk1Rd05TVHlpa1l6TG1V?=
 =?utf-8?B?cE96c1RybHE5aldZeTRBRzZRSXROMjdJdEpPSzZlZXVmRWwrNExuVUpjbWY5?=
 =?utf-8?B?YmE4bFBiOXVtWHBJQUtvWkVOdStBUklKL0hIUXRwZDdHRUM1QTJhMjdneis3?=
 =?utf-8?B?SGZWcit3WGZZSkVXT2c0eHNsT1hPakYrczY1MXNaWTU3eXhTYjVlZCtrbnlr?=
 =?utf-8?B?alBqQjFjZEowOTJKSkxCc1BJa0M0dndXRW1ZTjRHeTJ0N3hMM2hBbjZSVzkw?=
 =?utf-8?B?b0xEUWUveGVHZWVZZ2EyNEhpakdZNnZiK1A3RytSWlFMTFJXVEoyYmEyZDNH?=
 =?utf-8?B?MFFCRk1hbXpEN0ppUmNVUk5iczZWUlpLcWNlcTZvKzl1VHNYTmNtRDlaSng1?=
 =?utf-8?B?Vi9jRW45aWJ5ME1LNjVsR1VWNWZyam52eFVHTi9LTHlzVnh3QVdvZ0E5SXZQ?=
 =?utf-8?B?NitDb0tMK3hUNTNrZ3JrRFZBQlppWFEvY3F5QWtyZ2JzTW8yYjc4Z2prVXNB?=
 =?utf-8?B?RElxTis0QUhuWklIVFhFcWV4MkJXT2FDTCtaVXhrWjBZdmRqMk8zT3dkeXFP?=
 =?utf-8?B?MkRhWVZFTnBheEJCZnR1emtnQjU5bVA4cGpSS3pWUXVNZXZJbUdlTkRkb2ht?=
 =?utf-8?B?dHVvMklmNTByNWlzaXJQdXd6azZXM0xmRVdHUEtkVGFlU25MU0hoQzlRMWF1?=
 =?utf-8?B?V3JwTy9tSnZQVDA1Z0RqZzZ1WDNES2szRUVyb1VuZzhnRkxidGRvSXJSeWpz?=
 =?utf-8?B?OEtYN1J4U3hPMWllNVhiQ2Fqcjkzemp1L1p5a0dnTFdmKzFPZGdaT01RMkpH?=
 =?utf-8?B?bVRuQmsyU2p3UElra0JQVVVJYkJrS05NUEpLZEJLTnhtdEhPNzUxZTNhV2hC?=
 =?utf-8?B?a0RTRHVHdUY4T2FwaWsyZE9YRjRmRFVMWFgycnlRckl4TXZ6cEpRSG93VmxT?=
 =?utf-8?B?ZGtIOGxsS3RZb08rUS9LbWszY2FKZXp4bU5NYlc3dUs2RTNTQTJjaXFPRnFE?=
 =?utf-8?B?OVU2K2tMUFpma2ZzcHlEQjI3VEh1SmZOTDUyQW9IQzB1U3M4ODJYTWpTbWV3?=
 =?utf-8?B?c2I1b2pZRkxCdkFJblhiWlFlZEk5SFBTcVJKbk9GSVBMMkx0SUZ2QU8vNzRs?=
 =?utf-8?B?TzNrMENUV0hvR1ZXbzRZaDNYc3lDUHFiKzJyRU1aUytnem93Y3ZyQll2R2ht?=
 =?utf-8?B?bk80bEdwK1ZxS0ZOSXJjK3FneDM1N3haTjBWc2VvbWZaSEdIYU5VbDFEU1Rz?=
 =?utf-8?B?aklvd091dncxbjdGMDc2SXBYZkMrTFg0UTZRelp5U1VJRndnVDM5YmdZU0Qw?=
 =?utf-8?B?cmVqRmZ5SWFNaE9yWkh3bk4rWlFYVEVPWFJabEMzekhzckRIMWljUitPVGV1?=
 =?utf-8?B?a2pDMU1UZ05nWW1wbzRVLzRsNXpuaEVnTkEwMGZzdUxZY1J2bG5oZkt6NVZS?=
 =?utf-8?B?NjN1ZTd0bi9ObDgzYnU2MjdvRVQvSW05Z05iellYZGVCU3hHSXBxck83SGY0?=
 =?utf-8?B?d2NYRVMwOHdUeGhCTkRONDVXeEF3OUVCcVVpL2dWLzUxcnNWMWErSmtlZExv?=
 =?utf-8?B?WGplSVFoMmhQYjhFSGNtMlRuRlorK2RNNW1WV3lRWWJlcUtQRXU0MmM2ZUxU?=
 =?utf-8?B?ekNBMjlNM2JxNFFYdVB3N2xkdGh1bU85Mk1qdjhoMnZKQkJkVGp5MjNtZXNZ?=
 =?utf-8?B?eXl6WUlIdFlKUHpRQVNvWFJ1cUtIUlo1cVNTMWhsbjFRMkZ1bWRiV0dtZGN2?=
 =?utf-8?Q?9oMN+mD8y87PlIQliJ69wy0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E1364604D489743BAEB8D482C203E47@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a151390-220a-4dc7-762b-08dc8744d6ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 22:54:51.3148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a9YdqxbsKta3jQ4lQ83zyV0A+cAqlnfyjTt2dpzbXrnEA7NV0liB+084329Ko8Z3onT/ixGWLLDoxb0Hraa8yPtvNgwO8BSEvEj4fm+Zaws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8282
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDEzOjM5ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiANCj4gWWVzLCBub3cgd2UncmUgdGFsa2luZyBpbmRlZWQuIE1vc3RseSBpdCdzIGNvc21ldGlj
IHR3ZWFrcyBvciByZXF1ZXN0cw0KPiB0byBmaXgvaW1wcm92ZSBhIGZldyBjb21tZW50cywgYnV0
IG92ZXJhbGwgaXQncyB2ZXJ5IHBsZWFzaW5nIGFuZA0KPiBhbGdvcml0aG1pY2FsbHkgY2xlYXIg
Y29kZSB0byByZWFkLiBLdWRvcyB0byBldmVyeW9uZSBpbnZvbHZlZC4NCj4gDQo+IEkgZG9uJ3Qg
ZXhwZWN0IGFueSBiaWcgaXNzdWVzIHdpdGggdjMuDQoNClRoYW5rcyBzbyBtdWNoIGZvciB0aGUg
cmV2aWV3LiBXZSdsbCB0cnkgdG8gdHVybiB0aGlzIGFyb3VuZCBxdWlja2x5Lg0KDQpJbiB0aGUg
bWVhbnRpbWUsIHdlIHdpbGwgbGlrZWx5IGJlIHBvc3RpbmcgdHdvIGdlbmVyaWMgc2VyaWVzIHRo
YXQgd2VyZSBzcGxpdA0Kb3V0IG9mIHRoaXMgb25lOg0KIC0gTWFraW5nIG1heF9nZm4gY29uZmln
dXJhYmxlIHBlci12bS4NCiAtIENyZWF0ZSBhIHF1aXJrIGZvciBtZW1zbG90IGRlbGV0aW9uIHph
cHBpbmcgYWxsIFBURXMuDQoNCg==

