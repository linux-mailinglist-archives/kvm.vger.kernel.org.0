Return-Path: <kvm+bounces-15751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A58998AFFBA
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 05:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE648B21D72
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 03:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE5813B78F;
	Wed, 24 Apr 2024 03:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PrghOUuk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F30139CEB;
	Wed, 24 Apr 2024 03:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929665; cv=fail; b=TdT/E5h69nVUCouzs0qETBPrBXrmymENR0uCY9OLnnf0ykSr9cAOaKubo5uEmO2DjlgUBWgAufv9Gl9JZZ+y68LYdiYob87VNsU4RVPnL3+AJn9vv2l4+61+UBVzvBpti84xV4K2bpCVCddA+FY0SktzB2VeiId9CHJSWu0ogts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929665; c=relaxed/simple;
	bh=5v+dmgGRcOP+H27gxCSEy3yifmL2B7Z950CUk0t1tac=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s9VUl0Lj5e1YfRDUtO+otMImDPlQeSoPjMK5af7GyhMvrRuYFLXGgp+uCxhcM1Y9x4eZHIlEcLferqDd9SUZOf2kFH+KlbVTp7VpLE2HOZzEHkO1gOii4vWY3147Pkwf0vvSVmhQYbm+77J7iMhe3xpTIK1ipQI3sTjjHB0MsJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PrghOUuk; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713929664; x=1745465664;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5v+dmgGRcOP+H27gxCSEy3yifmL2B7Z950CUk0t1tac=;
  b=PrghOUuknh+T4+5WyVUxASg5HHGkk1+nM7Sut1U2UTtsO6rZDjpQQhqX
   wUUrmu+eAqWNRFKYdsmMZJmW2Mt4JQCxCIzYc7Lt+5aRMS0zX0rtCll/4
   gLDMNZOMvspp4fJ7QhG3SxhAJj4uYE+QxbZcg538o05KJyo90VyoIt2Tx
   0/jVH3nx7lFu1HRIhcFlJik3G7jgosCxcaGjczg7sPsLoK/+JFfVM6fG4
   E8kt7oUJbe8sf8cpfW7tempzlz6cYHWu5waaOxegMhYqsENx96hZpS8lV
   wdvfy+OWNwzg9tDHEdhtiEXXzwIvLAHLkfHPH3HkGChjNZ5A6aIsBspqo
   g==;
X-CSE-ConnectionGUID: 7zpt55giQmC9UutM5jPsTQ==
X-CSE-MsgGUID: DzQsxpfHQq22wZ0y0zTqjw==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="13331482"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="13331482"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 20:34:23 -0700
X-CSE-ConnectionGUID: AARJc3nbQlusZcKZgHaw6w==
X-CSE-MsgGUID: ohk5LJurTSilxguSYLUzCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="25087638"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 20:34:22 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 20:34:22 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 20:34:22 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 20:34:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E75Lu2JS5zlAbkY26JR3UK85KGKYkKOllGWoqIw+K6NkTQ0HQfegEbMT3NThzTth/iCnqP/E9NCByJbfkpjF2u86xd9IR7eryP8SQDDPh1CKiw1ligB7A7VEzAdwYgT5M0FjWr6BzEjNVvz4ItyOF8JeU3TlkAnrmoTjlBKWy66pnRZalEh8yxj+BT/euwP15z4jnpAxO2m5dD9dfhoq+rOR+ycVd/3Hba9kCrF/mseAWUdJ0AvfQDEead6M1eYXdp94nVVVP2BzrqzIXYyXb1g2aYtFMQ3xB/zdWO4PRdVuL1T00EEGToDZHALf6IOyTpZ9DTz6IDk8jdQ/vTEmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5v+dmgGRcOP+H27gxCSEy3yifmL2B7Z950CUk0t1tac=;
 b=iuM6NulEUKCDHu4JBSCjrXBQimn+lSCkd6G9rouZQJxSfVGjLSKf9nqki3XXM79ZL6brUU45KLjw64gjL7/MHN0AFMBpQIGuu5AZgnaxWOa7A/P2VKIo7N7rEVwk0xTi+gwxc2tgWCHPhSauJP1YxmzXeVR0cfS+KCE0XnvXAgX5VzDCYWLVbKoX4RWfOrYHOjp1eo+XPABaHi1szgcYG6g4eGo/S1p8nQY/62pOUJcenvznFXT+4vl3tTbUDkvzLajMC5TXI33uMxu/hhr8bY+dhvTggACbGImIl2VMSNXMJrs5Efe6lcPYEuuXG8XdM5OExdTxZh+fyupByI6a8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by DM4PR11MB5969.namprd11.prod.outlook.com (2603:10b6:8:5c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7519.22; Wed, 24 Apr 2024 03:34:19 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3487:7a1:bef5:979e]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3487:7a1:bef5:979e%7]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 03:34:19 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>, "Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH v6 1/1] vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV
 VF devices
Thread-Topic: [PATCH v6 1/1] vfio/qat: Add vfio_pci driver for Intel QAT
 SR-IOV VF devices
Thread-Index: AQHakNVVABwGPuSs6E2JDlTdIeFIVrFupRgAgABsqgCAAJNfgIAFiYyAgAACkbA=
Date: Wed, 24 Apr 2024 03:34:19 +0000
Message-ID: <DM4PR11MB55029F7EACB6EB257DCF37BA88102@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240417143141.1909824-1-xin.zeng@intel.com>
 <20240417143141.1909824-2-xin.zeng@intel.com>
 <20240418165434.1da52cf0.alex.williamson@redhat.com>
 <BN9PR11MB52767D5F7FF5D6498C974B388C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419141057.GG3050601@nvidia.com>
 <BN9PR11MB52768D9ADA48E18CB99BCB768C112@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52768D9ADA48E18CB99BCB768C112@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|DM4PR11MB5969:EE_
x-ms-office365-filtering-correlation-id: 39d0404e-3251-472c-d836-08dc640f6d22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?R254M25CTm9sN2xlUWpNTGROR2ZXVGtadGlTYTdXS3p4WXNiSTlOYUFRRUNn?=
 =?utf-8?B?SXBVRk1xaXpHanFTRDZITmFCRmRrL3pIWXpkb1pZOHo0cTFMb1NkeW5qblR0?=
 =?utf-8?B?UU4vMGg1cnd4ajd5Q0Y4L3lBOEh0R2tyR1Vrd3NlM1VJZVl4UkV3S0RTamw2?=
 =?utf-8?B?V1QxaXIxR2Zybk1FRi9ORXhYRVNFUHFKSmNVcHg5d05ZSUErU3A3TmNLeHVT?=
 =?utf-8?B?UjN5YVVoc1ZTQzVUZ2wrNUxyTUJMbUVBSForZldOdnMySmVqWGdMMEhQL1Jz?=
 =?utf-8?B?V3pJWkgzZ01yWWVyT2ljU3YyeGRxZzJTUFpxMEhXM2gvTW4zSEQzVndOSUtz?=
 =?utf-8?B?bE5TMTZoWHVNcnJRQ0V3Q0VOMExQTm85aEtSNjlmV2dhOXdvWGVDWmFWVVFy?=
 =?utf-8?B?Smx6eUJUK0xVWFowb3dnZStBMUpOQ0NuaTM0bnhkT1F5bW1VRFp5dDBTUmVR?=
 =?utf-8?B?K29VKzlmMlpIV2o3d3lTK3IvZnZPeTNwM0RObC9WMS9ZWnRmWDg4ZDVMTVlC?=
 =?utf-8?B?WHkzS1pUKzdUUTUxWkFpVHFzdFhaVHE0SFJFT0xoeC93RkZzRWhNM0d3eHVW?=
 =?utf-8?B?SnJMTGo4b2J4Q0RUS2xsbHM2KzJyempFMThqdHpwSlNtYkFwZWZYbHpYWlE3?=
 =?utf-8?B?dXlVaGppdTFPK2x0TzRGblBGU1FScWlaQTUvTzVPWlVPWmJaOFJ6REZUM29Y?=
 =?utf-8?B?SUphQ3BQbjRFSCsySnlFYmxlR0VUZ29CUmxLS2JvV3hJWXdLa3BZVDVxeXFn?=
 =?utf-8?B?eUdxWlE2bTdqLzdEV1hHdngxOXZYdHhsbU1VOUxMSHVkcGdwTGFKSElVTkdW?=
 =?utf-8?B?a0Q2RW45aHZGb29qTTJmV0d4eU92LzI1SkNHL2pKaG5WTHhNMHBIaE02UmtH?=
 =?utf-8?B?dHAzY1R3R1o2VTVyVnZEU21xcGR3WUlLekd4RGZoRUJmR0o5T2dSRnJnN2Qy?=
 =?utf-8?B?aWNvVXpLT1VrNDNReUI5enh5bFdQVFovVVZXcHVRYWxZYUNjUXFGZEpYZHIr?=
 =?utf-8?B?OUJNQm1kNXREYWMrSWxVSTJkdHlSUjBEWE95Q0hkYUEvc2hCQTNiMW5sZVp0?=
 =?utf-8?B?OUUwblIxVmJQeE1BUXBCUkIrcCtNZUF1cWdYc2cxVGptbnl2SzFsSkJTL1Fr?=
 =?utf-8?B?enIxNFhLYnhFMUViUmJZWTE4czcrV2w5WkJ2eXFxd1lEcWlLVGVmUFUya3l0?=
 =?utf-8?B?OTlVb1pCKzI0QkNaVXN2ZG1QdStNMEdJY3k3bTRlU2tJRWNNbDBzSmxXbWJv?=
 =?utf-8?B?K1ZzY1V5ZFk4OU81dXZRVWZoeUJKQ0o3SXhiZjZrSlJSejYyU1RocmFYNTgx?=
 =?utf-8?B?MVI4UVhkMndkVSt6RE12MmQ5ZkUvNGVjd0dDbnJzRGswd0ZMSnpEZmhsR3VO?=
 =?utf-8?B?OHY2cHBiWDV1M0dzZmlISkNaZW5BK3FyNDB0VEFFdS9Bbm1Icm1zVDZqZGNW?=
 =?utf-8?B?T0g5M2dMRGRHMXg5WmZ5VE94V0VKVlJTYUt6SW5RVU9kL3lJTVdwbE1tNVBK?=
 =?utf-8?B?VElqb1ZiRHIyYVZYZHdxZWcxcHZpa2NXWHdZTS9Yd3VPaldBclFWZjJMTHFa?=
 =?utf-8?B?cnk5QXpYM3NCbEF1aXFISC9XTFdlMHFYUldDVHNKalIram8rUlRxdm5FendH?=
 =?utf-8?B?WGpVbEw5citoaUh1WWNjb0MzMUxReTJZOUZhbEcvQzlzSkFid2hTNFhCSmxF?=
 =?utf-8?B?eEttQndwSnFsQzJHbzZ1NzhVakY2aENFK3VwUjBsWWpXZFNKdEttRVhRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlFPRTFhbVdIUDJiZWRiQ1l3UVFVZld0VVg1RzlsczMrUTdQRUpTMVBGSzVS?=
 =?utf-8?B?TTZZRVlCMk1wVkZWTFFyMkZjVXpqSEdHUW1QRmQxN1dJZE8wRjROK1pzeng3?=
 =?utf-8?B?WDgxcTdhRW0wemNUV1lBQStUdW5xUWtSNzlqVDVLL3E0OTN3ZUM5enEzL1hP?=
 =?utf-8?B?c0FlRmxkUm1Vb3ZCWjU1Y1ZTK000YVFUd3Z4c0wzSVc5UU9aV3RDOVVYQjRi?=
 =?utf-8?B?d0tXVGdIcVZZVXk5TytiWXFFVnU5Q29LSVJ0Wkc3WHVJQ0VJWkFKWGxhSEtV?=
 =?utf-8?B?R092VUdpY0lXRmNTa3pNRHRRaTkwRGtsL2JIVy9WVEM1Zzc3RlNvb3FqUW4v?=
 =?utf-8?B?dnBNWXpoQXF4Ry9rd2RhT3ptYmJqdGNseHBsOFU0Z1E4Rm54K3dCeWsyWmhC?=
 =?utf-8?B?NTN3K3c4UTlBS3ZFcjhWK2YwT1gyeWZ6dnEvdHRLbzdOSEd3eWoyRElPbWti?=
 =?utf-8?B?YUNRRDJ6YzVBa1UyQ0dnQThMU08wRkRkUTNKY0VYRVpoc3NpdTJUK2J4SFA4?=
 =?utf-8?B?cmpuTFlvck9RaWVVMHVFeUJ6K0hrdC9JYTVBZlV4NEdESy80d1RYSUFRS3Bm?=
 =?utf-8?B?L1hPeXdHU05TRStocHp1TldIKzdDV2RhTnE0WEJzQWdOQ1N4a0RsM0pzdWh2?=
 =?utf-8?B?eENmeDFCWlY5NFpzRXRNSnhpbVVGMVR3a0YrLzlOZ21UZlJFODB4TVpWdXAr?=
 =?utf-8?B?NGhmUU8zbS9QTWZmOFVvK3lqY0phTTNkZFVqME8rd2p0cG9xaC9WYm5sZFNm?=
 =?utf-8?B?TjljbURsS0E0cCt6dW82UGk1WHZWbjZreGt2VERHZ2p0aTdBTmd2ZFYvMVJp?=
 =?utf-8?B?a3VJdkhhdFR2c3lSajdYRElhZWUyM3kwU01xZHFzZEZEUDk0OVpsMGVBVkc4?=
 =?utf-8?B?SkNoQXhEejJxMUVFTlhmUGNENjYyTUlqL0F4SUtwaDBsbWl0YkRpVWxlOVNl?=
 =?utf-8?B?SVlLUVgyRG5Qd29Nc0JSZkFZVk80UXA4RXlRNFJoelN2UUxpanFESG5DbW8y?=
 =?utf-8?B?cnVKT2NON3QyeDVUNzRwbVZyT20xak1lTW8yTTBqQlBjNG5rNGRYWEdlb3Y0?=
 =?utf-8?B?VHQ4ck5vODFKSkdrbHIybEFHNU9kSkdsbG1ZQWFzT3M1SFVjRG1DQVllcHRh?=
 =?utf-8?B?Vll2RHpDWGtxTHYvZW4vcHZyV01NRGpjMCsraUhVWjJVMXhkTjY5V2xqSjJj?=
 =?utf-8?B?b2NvRjNlWHJQYjlrNFJpL1BrdWc4d2pDTURlSERET1NIUU5IVDluZ1hIcUpN?=
 =?utf-8?B?ZFBjUWdEeDBwbmw5TGJlTVJIZTVtMnJTekZIaGZTQWhyZnZHNDRyUFRzZHkx?=
 =?utf-8?B?b0E2UWZLZXk3OWtQL1c3cUUzc0F5M01SclZTc1VCWFBOK2o5L1UwdnhDNlFO?=
 =?utf-8?B?Y0ZORUtsRkFhS3pFTEM4RGRGRkFJai9aMDBsMTVXNnF4QWhkcFZmeVRhczJm?=
 =?utf-8?B?bFRaU2c1eFFDQkI3OHFydktJbEFRRXFNcWVMeU0yOGpFekh4cWY3UHVoNTUw?=
 =?utf-8?B?K3EyOHJVVzRtelM2TXVGQWo0VmRsQm1Oa2MyT1hwM1cxM21HelJGTzBUVitD?=
 =?utf-8?B?bEFER3VlMEFhRWF0Si9xTDVBVDdkTmkyYUhIaDArN29IcC8zYWVwRUI0cFJT?=
 =?utf-8?B?aVBXL2xIMzJ4ekJCbldqUkptYUhBQzBJMTVKZU5rOVgvdjNtRVcvVHhFcEpM?=
 =?utf-8?B?bG0yd2lteUhhMTFmS2lvVjduSFA4L1RtRTRyWGs2REpPRTBxenNtcTMrM3JD?=
 =?utf-8?B?UEpNYXlIYllFQTNHS2JLd1UycVJ5Ym44ald4MUg3K3lFRGRRc3ZSZVhSUXl0?=
 =?utf-8?B?Z2FSUnFyR29FWXAxZkFyalZEckJ1eXpIMXJnT1RscTAvdUcwMGhSTDFILzJr?=
 =?utf-8?B?MlRENTdqZEVXMTZtU1dpMmZ4RWJaSTlTOTNCSE5CcXVSNzVWQWhpRWs3bW4z?=
 =?utf-8?B?TUVkMDUyc252cGNvVnFDNm5ydGc1NHVROHVMYXBXN1k2YWlLT25YbEt1OWRS?=
 =?utf-8?B?NjJ2eTEzRUVQY1VMeXdsZERTcFZ6dmxWUlBUdGpadEFjWmJpaHZOSVpKWEhr?=
 =?utf-8?B?N2Excm5mSHF0SEV0RWhsdURlWG5oZE5JdXZTRHZRRmd5bUpaWWJ2eGtEQitj?=
 =?utf-8?Q?2Pwu0IwykS/ygCLkiMPAcoxbV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d0404e-3251-472c-d836-08dc640f6d22
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 03:34:19.7800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SMaNwSMtjBbeGVNw0VFWLzQlGuNJk8xpzSLEyM2y9L1VtVLGPGXvGDqnz5QyZxqK8c1WoVba/tKyM5oGNWXRWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5969
X-OriginatorOrg: intel.com

T24gVHVlc2RheSwgQXByaWwgMjMsIDIwMjQgMTA6NDUgQU0sIFRpYW4sIEtldmluIDxrZXZpbi50
aWFuQGludGVsLmNvbT4gd3JvdGU6DQo+IFRvOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEu
Y29tPg0KPiBDYzogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT47
IFplbmcsIFhpbg0KPiA8eGluLnplbmdAaW50ZWwuY29tPjsgaGVyYmVydEBnb25kb3IuYXBhbmEu
b3JnLmF1OyB5aXNoYWloQG52aWRpYS5jb207DQo+IHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlA
aHVhd2VpLmNvbTsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4ga3ZtQHZnZXIua2Vy
bmVsLm9yZzsgcWF0LWxpbnV4IDxxYXQtbGludXhAaW50ZWwuY29tPjsgQ2FvLCBZYWh1aQ0KPiA8
eWFodWkuY2FvQGludGVsLmNvbT4NCj4gU3ViamVjdDogUkU6IFtQQVRDSCB2NiAxLzFdIHZmaW8v
cWF0OiBBZGQgdmZpb19wY2kgZHJpdmVyIGZvciBJbnRlbCBRQVQgU1ItSU9WDQo+IFZGIGRldmlj
ZXMNCj4gDQo+ID4gRnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiBT
ZW50OiBGcmlkYXksIEFwcmlsIDE5LCAyMDI0IDEwOjExIFBNDQo+ID4NCj4gPiBPbiBGcmksIEFw
ciAxOSwgMjAyNCBhdCAwNToyMzozMEFNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPiA+
ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4g
PiA+ID4gU2VudDogRnJpZGF5LCBBcHJpbCAxOSwgMjAyNCA2OjU1IEFNDQo+ID4gPiA+DQo+ID4g
PiA+IE9uIFdlZCwgMTcgQXByIDIwMjQgMjI6MzE6NDEgKzA4MDANCj4gPiA+ID4gWGluIFplbmcg
PHhpbi56ZW5nQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+ID4gKw0KPiA+ID4g
PiA+ICsJLyoNCj4gPiA+ID4gPiArCSAqIEFzIHRoZSBkZXZpY2UgaXMgbm90IGNhcGFibGUgb2Yg
anVzdCBzdG9wcGluZyBQMlAgRE1BcywNCj4gc3VzcGVuZA0KPiA+ID4gPiB0aGUNCj4gPiA+ID4g
PiArCSAqIGRldmljZSBjb21wbGV0ZWx5IG9uY2UgYW55IG9mIHRoZSBQMlAgc3RhdGVzIGFyZSBy
ZWFjaGVkLg0KPiA+ID4gPiA+ICsJICogT24gdGhlIG9wcG9zaXRlIGRpcmVjdGlvbiwgcmVzdW1l
IHRoZSBkZXZpY2UgYWZ0ZXINCj4gdHJhbnNpdGluZyBmcm9tDQo+ID4gPiA+ID4gKwkgKiB0aGUg
UDJQIHN0YXRlLg0KPiA+ID4gPiA+ICsJICovDQo+ID4gPiA+ID4gKwlpZiAoKGN1ciA9PSBWRklP
X0RFVklDRV9TVEFURV9SVU5OSU5HICYmIG5ldyA9PQ0KPiA+ID4gPiBWRklPX0RFVklDRV9TVEFU
RV9SVU5OSU5HX1AyUCkgfHwNCj4gPiA+ID4gPiArCSAgICAoY3VyID09IFZGSU9fREVWSUNFX1NU
QVRFX1BSRV9DT1BZICYmIG5ldyA9PQ0KPiA+ID4gPiBWRklPX0RFVklDRV9TVEFURV9QUkVfQ09Q
WV9QMlApKSB7DQo+ID4gPiA+ID4gKwkJcmV0ID0gcWF0X3ZmbWlnX3N1c3BlbmQocWF0X3ZkZXYt
Pm1kZXYpOw0KPiA+ID4gPiA+ICsJCWlmIChyZXQpDQo+ID4gPiA+ID4gKwkJCXJldHVybiBFUlJf
UFRSKHJldCk7DQo+ID4gPiA+ID4gKwkJcmV0dXJuIE5VTEw7DQo+ID4gPiA+ID4gKwl9DQo+ID4g
PiA+DQo+ID4gPiA+IFRoaXMgZG9lc24ndCBhcHBlYXIgdG8gYmUgYSB2YWxpZCB3YXkgdG8gc3Vw
cG9ydCBQMlAsIHRoZSBQMlAgc3RhdGVzDQo+ID4gPiA+IGFyZSBkZWZpbmVkIGFzIHJ1bm5pbmcg
c3RhdGVzLiAgVGhlIGd1ZXN0IGRyaXZlciBtYXkgbGVnaXRpbWF0ZWx5DQo+ID4gPiA+IGFjY2Vz
cyBhbmQgbW9kaWZ5IHRoZSBkZXZpY2Ugc3RhdGUgZHVyaW5nIFAyUCBzdGF0ZXMuDQo+ID4gPg0K
PiA+ID4geWVzIGl0J3MgYSBjb25jZXB0dWFsIHZpb2xhdGlvbiBvZiB0aGUgZGVmaW5pdGlvbiBv
ZiB0aGUgUDJQIHN0YXRlcy4NCj4gPg0KPiA+IEl0IGRlcGVuZHMgd2hhdCBzdXNwZW5kIGFjdHVh
bGx5IGRvZXMuDQo+ID4NCj4gPiBMaWtlIGlmIGl0IGhhbHRzIGFsbCBxdWV1ZXMgYW5kIGtlZXBz
IHRoZW0gaGFsdGVkLCB3aGlsZSBzdGlsbA0KPiA+IGFsbG93aW5nIHF1ZXVlIGhlYWQvdGFpbCBw
b2ludGVyIHVwZGF0cyB0aGVuIGl0IHdvdWxkIGJlIGEgZmluZQ0KPiA+IGltcGxlbWVudGF0aW9u
IGZvciBQMlAuDQo+IA0KPiBZZXMgdGhhdCByZWFsbHkgZGVwZW5kcy4gZS5nLiBhIHF1ZXVlIGFj
Y2VwdGluZyBkaXJlY3Qgc3RvcmVzIChNT1ZESVI2NEIpDQo+IGZvciB3b3JrIHN1Ym1pc3Npb24g
bWF5IGhhdmUgcHJvYmxlbSBpZiB0aGF0IHN0b3JlIGlzIHNpbXBseSBhYmFuZG9uZWQNCj4gd2hl
biB0aGUgcXVldWUgaXMgZGlzYWJsZWQuIEVOUUNNRCBpcyBwb3NzaWJseSBPSyBhcyB1bmFjY2Vw
dGVkIHN0b3JlDQo+IHdpbGwgZ2V0IGEgcmV0cnkgaW5kaWNhdG9yIHRvIHNvZnR3YXJlIHNvIG5v
dGhpbmcgaXMgbG9zdC4NCj4gDQo+IEknbGwgbGV0IFhpbiBjb25maXJtIG9uIHRoZSBRQVQgaW1w
bGVtZW50YXRpb24gKGZvciBhbGwgZGV2aWNlIHJlZ2lzdGVycykuDQo+IElmIGl0IGlzIGxpa2Ug
SmFzb24ncyBleGFtcGxlIHRoZW4gd2Ugc2hvdWxkIHByb3ZpZGUgYSBjbGVhciBjb21tZW50DQo+
IGNsYXJpZnlpbmcgdGhhdCBkb2luZyBzdXNwZW5kIGF0IFJVTk5JTkdfUDJQIGlzIHNhZmUgZm9y
IFFBVCBhcyB0aGUNCj4gZGV2aWNlIE1NSU8gaW50ZXJmYWNlIHN0aWxsIHdvcmtzIGFjY29yZGlu
ZyB0byB0aGUgZGVmaW5pdGlvbiBvZiBSVU5OSU5HDQo+IGFuZCBubyByZXF1ZXN0IGlzIGxvc3Qg
KGVpdGhlciBmcm9tIENQVSBvciBwZWVyKS4gVGhlcmUgaXMgbm90aGluZyB0byBzdG9wDQo+IGZy
b20gUlVOTklOR19QMlAgdG8gU1RPUCBiZWNhdXNlIHRoZSBkZXZpY2UgZG9lc24ndCBleGVjdXRl
IGFueQ0KPiByZXF1ZXN0IHRvIGZ1cnRoZXIgY2hhbmdlIHRoZSBpbnRlcm5hbCBzdGF0ZSBvdGhl
ciB0aGFuIE1NSU8uDQo+IA0KDQpXaGVuIFFBVCBWRiBpcyBzdXNwZW5kZWQsIGFsbCBpdHMgTU1J
TyByZWdpc3RlcnMgY2FuIHN0aWxsIGJlIG9wZXJhdGVkDQpjb3JyZWN0bHksIGpvYnMgc3VibWl0
dGVkIHRocm91Z2ggcmluZyBhcmUgcXVldWVkIHdoaWxlIG5vIGpvYnMgYXJlDQpwcm9jZXNzZWQg
YnkgdGhlIGRldmljZS4gIFRoZSBNTUlPIHN0YXRlcyBjYW4gYmUgc2FmZWx5IG1pZ3JhdGVkDQp0
byB0aGUgdGFyZ2V0IFZGIGR1cmluZyBzdG9wLWNvcHkgc3RhZ2UgYW5kIHJlc3RvcmVkIGNvcnJl
Y3RseSBpbiB0aGUNCnRhcmdldCBWRi4gQWxsIHF1ZXVlZCBqb2JzIGNhbiBiZSByZXN1bWVkIHRo
ZW4uIA0KTU9WRElSNjRCIG1lbnRpb25lZCBhYm92ZSBpcyBub3Qgc3VwcG9ydGVkIGJ5IFFBVCBz
b2x1dGlvbiwNCnNvIGl0J3MgZmluZSB0byBrZWVwIGN1cnJlbnQgaW1wbGVtZW50YXRpb24uDQpJ
ZiBubyBvYmplY3Rpb25zLCBJJ2xsIGFwcGVuZCB0aGlzIHBhcmFncmFwaCBvZiBjb21tZW50IGlu
IHRoZSBkcml2ZXIgYW5kDQpwb3N0IGFub3RoZXIgdmVyc2lvbi4NCg0KVGhhbmtzLA0KWGluDQoN
Cj4gPg0KPiA+ID4gPiBTaG91bGQgdGhpcyBkZXZpY2UgYmUgYWR2ZXJ0aXNpbmcgc3VwcG9ydCBm
b3IgUDJQPw0KPiA+ID4NCj4gPiA+IEphc29uIHN1Z2dlc3RzIGFsbCBuZXcgbWlncmF0aW9uIGRy
aXZlcnMgbXVzdCBzdXBwb3J0IFAyUCBzdGF0ZS4NCj4gPiA+IEluIGFuIG9sZCBkaXNjdXNzaW9u
IFsxXQ0KPiA+DQo+ID4gSSBkaWQ/IEkgZG9uJ3QgdGhpbmsgdGhhdCBpcyB3aGF0IHRoZSBsaW5r
IHNheXMuLg0KPiANCj4gTm90IHRoaXMgbGluayB3aGljaCBJIHJvdWdobHkgcmVtZW1iZXIgd2Fz
IGEgZm9sbG93LXVwIHRvIHlvdXIgZWFybGllcg0KPiBjb21tZW50Lg0KPiANCj4gQnV0IEkgY2Fu
bm90IGZpbmQgdGhhdCBzdGF0ZW1lbnQgc28gcHJvYmFibHkgbXkgbWVtb3J5IHdhcyBiYWQuIFRo
ZQ0KPiBjbG9zZXN0IG9uZSBpczoNCj4gDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2ludGVs
LXdpcmVkLWxhbi9aSk1IM0RGN25KK09HOUJKQHppZXBlLmNhLyN0DQo+IA0KPiBidXQgaXQganVz
dCB0YWxrcyBhYm91dCBsYWNraW5nIG9mIFAyUCBpcyBhIHByb2JsZW0gc2ltaWxhciB0byB5b3Ug
cmVwbGllZCBiZWxvdzoNCj4gDQo+ID4NCj4gPiBXZSd2ZSBiZWVuIHNheWluZyBmb3IgYSB3aGls
ZSB0aGF0IGRldmljZXMgc2hvdWxkIHRyeSBoYXJkIHRvDQo+ID4gaW1wbGVtZW50IFAyUCBiZWNh
dXNlIGlmIHRoZXkgZG9uJ3QgdGhlbiBtdWx0aSBWRklPIFZNTSdzIHdvbid0IHdvcmsNCj4gPiBh
bmQgcGVvcGxlIHdpbGwgYmUgdW5oYXBweS4uDQo+IA0KPiB5ZXMgYnV0IHdlIGhhdmUgdG8gYWRt
aXQgdGhhdCBleGlzdGluZyBkZXZpY2VzIG1heSBub3QgbWVldCB0aGlzDQo+IHJlcXVpcmVtZW50
LiDwn5iKDQo=

