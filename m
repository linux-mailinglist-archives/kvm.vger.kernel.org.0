Return-Path: <kvm+bounces-27544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4382986CB6
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 08:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 367BA1F23233
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 06:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80C91891B9;
	Thu, 26 Sep 2024 06:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eMPNXDaf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66D0282FA
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 06:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727333031; cv=fail; b=gdNcizHyhrX/EpHgf06p3k9G0hquXAS1OSAWuv7f6pPqr+Qea2N2hldxrk55YjT4fRvQamDGvL9QRTWMBFFTL8cPND4ctIG2FJROXT49H2NylHV6F58/9HydQaSNko0tIZ/mu1kxlhpbMz96hvDgG7yiFtPPNKUTVgcvYD4wuxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727333031; c=relaxed/simple;
	bh=5rE2hAo88poNtv+ynK4gO9OXrQfLR4XmQcPMDx3Hg64=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YFTh991PMIPN26VBLUV2TSxPh5MmwSwmNKWqqO3MoNgNo/W1UJeI+VmKQl++66TRyJRW5gvhX3H8sINTSM2eYF9CIMZuaE8oggxl2LY/pZI3v5/7emkwxeC+d0esXzKAZ4Elj2GfctgIiqkbvLRKBdf3Coq6wiyXB36fTqteQSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eMPNXDaf; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727333030; x=1758869030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5rE2hAo88poNtv+ynK4gO9OXrQfLR4XmQcPMDx3Hg64=;
  b=eMPNXDafaQFYvp2Z7Wu0iivGXU+MWzJGcjlE01nhFRi/fn28Rj9Lrp8o
   62+bzSzVQuMpELyn3NGziE7dvCu3oU8uLkrQ6XRhepMdjdK80yUqDdw8D
   w31MoTwz3DrrO1MXT6c836K45PYQawLm+Wsc61EjMXOEWKJC88P77ll1u
   qTdQHRiXFPpVQBYUzzTwqOCtTU8f8TtmFVBytf2D5zhdXOxAmO9vs4U1v
   z9T011uUQIVcQTTOtUDhnNRPQiurGApr4lMHkLCvNIEJRJgaNXC5XCUDr
   N1SaWt2NCw+lnx2WxAwjXw0OQMJ/CapugTpv1CHUaOntdQPEIcbddj/qp
   g==;
X-CSE-ConnectionGUID: ZgMBw0MBQ/K/Gy8tGA4a5Q==
X-CSE-MsgGUID: /sP9ex23QW6BsFlp0xup/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11206"; a="26279223"
X-IronPort-AV: E=Sophos;i="6.10,259,1719903600"; 
   d="scan'208";a="26279223"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2024 23:43:49 -0700
X-CSE-ConnectionGUID: 94qfuafrR/K+tS4geGhZdA==
X-CSE-MsgGUID: ACC7Wm7dQQOekX6HKglkmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,259,1719903600"; 
   d="scan'208";a="72828819"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2024 23:43:49 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 23:43:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 23:43:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 25 Sep 2024 23:43:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 25 Sep 2024 23:43:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lx3k6Gs73cuVF2nGOAXE01jcSBzUpYubStCt+jT0QrmtH7DSBhkv35xmZiV3WxDzYrMMgKM2T2/OORrwhWAaBmF8xRH7gKS+YdGAgqkj2piLMg/DBsJ4H7/CB0M+MVFok4VBBjMuw4fsCdqoHgOtHtW96avnyh7G+vbpkb60eAugC/MD6v12AcSDkTmxjtSgrzTmAy8XdPxE/8CM3ph/J+6NwHjPTInpbgliYqKksRAFZfsf1AxQ8SIkh4HnItO/KrwlAh5ydqanA+lf81jlfbiRmHfhriTs3BFlaWec5kVnmQoCYSSAeZ0dq3hPZ2pfQ8Iy3ZBWDsgd8R9R4Ag3cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wHeCLc74WSuO5TZFVbd790Sc0iIVWTjr8L6AtRqF+aI=;
 b=hUfoL6PcWLw4dEz1FpPnoDjBqTkWyCINNudAMGHkE9WZqO/34K2K3jOb/JdiTiSCHRwRyMCQOa5csQ5H8PCOOukydiNFCPzCGn9MKkTK85d/uOaBs5Iq9r3A8HhYbXAtk4R2d0eHoobpo0S7unr3qQcLA7WY7YTO7BY3IywQyZXuAegTYfnFFq7sOQPxh4gKQk3jkKhg2RVQ8kRvJUrhCq2h8jZwzWNUVcXGPmvVYEZo9AISB8qmBNKnNkZpW7UX/dkLr7sLHlFJ0XAMGcznlbPqJmNfOwL4bBLyrRnONDjYO6pqEwD0rJmA5+mRU3bqYv3Mb3XsLK7rdCDEQvuAOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4853.namprd11.prod.outlook.com (2603:10b6:510:40::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Thu, 26 Sep
 2024 06:43:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8005.021; Thu, 26 Sep 2024
 06:43:44 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"airlied@gmail.com" <airlied@gmail.com>, "daniel@ffwll.ch" <daniel@ffwll.ch>,
	"Currid, Andy" <acurrid@nvidia.com>, "cjia@nvidia.com" <cjia@nvidia.com>,
	"smitra@nvidia.com" <smitra@nvidia.com>, "ankita@nvidia.com"
	<ankita@nvidia.com>, "aniketa@nvidia.com" <aniketa@nvidia.com>,
	"kwankhede@nvidia.com" <kwankhede@nvidia.com>, "targupta@nvidia.com"
	<targupta@nvidia.com>, "zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: RE: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Thread-Topic: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Thread-Index: AQHbDO4JkHnxGOPNCU2lsdYB8MwR7bJk5jyQgACTGoCABCOw4A==
Date: Thu, 26 Sep 2024 06:43:44 +0000
Message-ID: <BN9PR11MB52768D78EE4017A90E7CAE408C6A2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <BN9PR11MB5276CAEC8170719F5BF4EE228C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240923150225.GC9417@nvidia.com>
In-Reply-To: <20240923150225.GC9417@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4853:EE_
x-ms-office365-filtering-correlation-id: 7e5b06a3-c7bc-4132-19e1-08dcddf69111
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?rkA0rFKe5B66EAAldAIIKVFFOhRmwgxvaKj3zkHE+3J3h6j8vGfZvLjiabrJ?=
 =?us-ascii?Q?0H8LmWteZtpFf53HCTC+KKGuBg5PnPS2eu84wCo6VAyCXcQf+1rh9i1VKIE9?=
 =?us-ascii?Q?QO4WITaVgjPXlNRvVFs3FlAEL/4ZH/ujO+JEZ1ZgWH1dArZL0Upod7nUvtIF?=
 =?us-ascii?Q?OgpVw9DLpp/11uRIokQMusNtqedTfMjHRq4VbDLI25gUrvWFc0GX6d7PIwLP?=
 =?us-ascii?Q?8jGDOwVofgIa5PwGvUxx8W21CQhy/mY8oYoca1zj3/y4jfCUMO5Kn7pGVh0h?=
 =?us-ascii?Q?+91JqQU7XIxz7rp+x/NkEAXA+QZfLm6rz2m1+SiqPtWNmyXaphpczx+0Ky4T?=
 =?us-ascii?Q?jfeFg1PJxJVGCJFyDWsgxRp4dNx3LNhlVQTWcVvf3u0lCsrjRKgqvFH3Q/ku?=
 =?us-ascii?Q?f5wJj01kSXOS0J3J9Y7Nt+veq49nxv2r072xT9sWVGtkiCaw9fUvYHveIcCo?=
 =?us-ascii?Q?DErduU+I1JwRTk4yWoSV88RdsvIG1240SqJmJvVSueedyBNLl8vo8QjeB7Uu?=
 =?us-ascii?Q?0WLss5INIAOjXUjxwnPtfwPUSq6DXO/b8ZTAXBHPrIcXPoJhBCeP9BUjpuJQ?=
 =?us-ascii?Q?zyFEl6U9C5f4MLcR7SWHIRjIvGkDzaPGOMCBLEty+LquYYLjrJ0FjGTIe0xW?=
 =?us-ascii?Q?0jYK27OHKAqGC5tjpqlExcPy5mbspVi8MYjoWggTTab/FVdjhE/We8lp6TPz?=
 =?us-ascii?Q?bWaanXGp1W53TE35pUWczYUoDnAMI3dXW5+VVP3C5qgO092CFW4ZksTn/jzg?=
 =?us-ascii?Q?EekBUbjRLclG1vAUV//RnCItEqEHR+BQtfAOP0pKX5yht7232+pTkKa2L8dz?=
 =?us-ascii?Q?II1pOUzYskNnSLtJTIfU/hWDi4PoU1ce+YydUgvsFBy2BDzLeBJfrXEP4B8I?=
 =?us-ascii?Q?J2fKOsVvJ3/pLRTp1RwRAGk4+UHL53akSCz7/Pr+wTygLtBLGJFJnxSnHq8E?=
 =?us-ascii?Q?WUQnRf4R6/6wxQapZnS8//bWMYDltf/IUcHXM9h4FwOvf/oXViQBm3aRdIAe?=
 =?us-ascii?Q?MQvrbqr9pOVz7hg263mGj3ceEl4YWqJviFLOhwFxawBLRNkOz9M8ujgphbEw?=
 =?us-ascii?Q?eweNxScEKWU4X9LdQy9gjQIP7ITTYLt9MfP3X9ktrRDPIiyb1RTop+fY4br2?=
 =?us-ascii?Q?yQyO8+ehCBprsWXXNCRtv0uxZaHGZPDz0JTTe4sH2UFGkla3Cvi3o2L7XwWS?=
 =?us-ascii?Q?xJxQaw+bV972cNARAzdOI5pOgn6t0qCN96H8Rt0GNXMrQ9PnwVrMvmYs3j8Z?=
 =?us-ascii?Q?IHxN2WaJy6s4YxP5x0GBnB4X7jI7VtJhbodY8HpNKy48CqNSJqg6/Q8zm9Q8?=
 =?us-ascii?Q?Yj5W5Rexo5wlmW2GkFA64fOpHMQ5GREipnrSn3XVfEWX5mQZ/qe7iOwEpPRj?=
 =?us-ascii?Q?DhbzmyCAFsLvehMkXbM6wkiFNyUQhOT/W2+ZH/AiGdKoF0CCvg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qqVaFh4RFHXKhw3JZMEFnWpbG2dG0ygAfrs2SU6on+osibOvE5qRnMiUwMVt?=
 =?us-ascii?Q?TWOTc8UTpkrKM/WYoMog3HdEptFiI0/2Z8CXoUItONYiRvUhwxMaE8IgOE1p?=
 =?us-ascii?Q?mqR3SlxnI27sox/JLurfBXb/vAkiSVeMWCs8nthUvDWtTL+0uqn3pOOcirrx?=
 =?us-ascii?Q?1FQaKSyhSMHjNijcjDFXBFfrbeopVyRuQXtxlA63IaauDjJeiuQmLdCTqw+l?=
 =?us-ascii?Q?qdfLB62Bm+tzCAw2Xd2O43UzEHNRLqIirXW7YLjJ56tGQmJgpoChcfBHwNw0?=
 =?us-ascii?Q?EP837sjkyRPI5JT1rBIcfw4RTKsgBXABVZpioJAGGEyh/3Q/ue1r0TVx8N0R?=
 =?us-ascii?Q?pssJx/EY4IeaZxq0kHXSYfaTrx1swKxwWzK7pYQ3cubwQQDvVZNqAoJtb2Oz?=
 =?us-ascii?Q?DPCHPAn/RZR44Wd315GI4D+wKl/yRO5faLgZPDzhS9pSOwdSZ+Dv0b2VyEX3?=
 =?us-ascii?Q?47BrEMiSxmNzEikmYx6Oa9Pc419XPz+wMirB3+f5nK9gutrsXs2cIHXiIcUQ?=
 =?us-ascii?Q?cAYALgqYp7p5H3gvQYDhABnPCSFsH8GBfVSBe9Q1lA26PaSJBtnKEAoJ9sqb?=
 =?us-ascii?Q?oLz6waAttvPneW4q/03UbpJRRH9WA7t3R6psc+NgNPYfy3ZEUZX0u+53c5sc?=
 =?us-ascii?Q?qLOIs1d9tJNnm+ojJKytGMYzSpPAAFW9/pdPqAkmhI9ukYDUDRKSxdnnGkDz?=
 =?us-ascii?Q?Ye7DfFuzlEMKBpLXj/rrWT5XUdJKr8fjwv9X95KZld6V1zuv3IxyMKsjUjWW?=
 =?us-ascii?Q?QuLigCs+c9EmiRUXvU0wv5M72A9H5T6eDIblUXvCOT3TukUjCSn9lIlPhto/?=
 =?us-ascii?Q?fVUiVptEMWWRCfigooaU6fJtvjcDcVDzvxTcGbrp0STzinZLUBAAlFXvBfUW?=
 =?us-ascii?Q?j9WYydN3dhs2XxZLp5DnYi5bNtLazrmNTzQl6Rri0Se8BbkyZwaBGDzTLH4u?=
 =?us-ascii?Q?tRmPdkro4ox+zH+hwNNzB/fLDMro+NidIAskCHjlea8TFTQDrN4s0ldpsNCJ?=
 =?us-ascii?Q?2f5MuEL4wzqJ541EFJ1yjVkOyOOUU67udcUF2H6K5wlFcaT42iGF8c8WD0P2?=
 =?us-ascii?Q?pCM8NAi05witjU7iVLqF1pl6zs8xfpKXR4LFp13PGdTWE5pmZxnV99lZqKyI?=
 =?us-ascii?Q?1CPVCsTeBIxFCtmD+utSUo72UUH0VLFa73CHPppkH6ySopCveY5feMye9Yoy?=
 =?us-ascii?Q?yI8ABxTjpx4pb0Xth9YjA5LBtb3BTpYnD23GeP+sdC/u05fsJiTeAIlm4kkc?=
 =?us-ascii?Q?F2qnh/6yjlsHBZlf+G2w4bzPcHNVauIa4x7dRdpZW8PAvlUCBipAyqPVT+QJ?=
 =?us-ascii?Q?3dKLjnzQvYgJUIoHxzbG67HAU/ymUDX9qE5uZTqJiDyCx+8rpLoAo3yxPueS?=
 =?us-ascii?Q?znLinQPxIb1x+4YEGtCqZPdyBqwaKl3QLHCOwVvfC5lUCF7gFa4VnJVRZVRk?=
 =?us-ascii?Q?r+ueADXCaRI1P4fjEP+M7G3zcyL+hFxVfCjeW1nOizvqczVMOPHYz+SU67oF?=
 =?us-ascii?Q?4WJXpDletuluRfiI1ZZMRbt8VRI7bOcJeudYUUiZ66WnwoRxZIb6vWip51O7?=
 =?us-ascii?Q?xSYEurTfVUNbUAXgAFw4jy8i03/0ScAsjp3wKxw6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5b06a3-c7bc-4132-19e1-08dcddf69111
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2024 06:43:44.4915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wokLdJGeRavlpOPGlz7hHpLlJIvSv1FMEhD/SWlXqfnzd8Py8wMVs4I9jDT+9Bk78vsaBR6YHLPJEfW1bdS1rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4853
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, September 23, 2024 11:02 PM
>=20
> On Mon, Sep 23, 2024 at 06:22:33AM +0000, Tian, Kevin wrote:
> > > From: Zhi Wang <zhiw@nvidia.com>
> > > Sent: Sunday, September 22, 2024 8:49 PM
> > >
> > [...]
> > >
> > > The NVIDIA vGPU VFIO module together with VFIO sits on VFs, provides
> > > extended management and features, e.g. selecting the vGPU types,
> support
> > > live migration and driver warm update.
> > >
> > > Like other devices that VFIO supports, VFIO provides the standard
> > > userspace APIs for device lifecycle management and advance feature
> > > support.
> > >
> > > The NVIDIA vGPU manager provides necessary support to the NVIDIA
> vGPU VFIO
> > > variant driver to create/destroy vGPUs, query available vGPU types, s=
elect
> > > the vGPU type, etc.
> > >
> > > On the other side, NVIDIA vGPU manager talks to the NVIDIA GPU core
> driver,
> > > which provide necessary support to reach the HW functions.
> > >
> >
> > I'm not sure VFIO is the right place to host the NVIDIA vGPU manager.
> > It's very NVIDIA specific and naturally fit in the PF driver.
>=20
> drm isn't a particularly logical place for that either :|
>=20

This RFC doesn't expose any new uAPI in the vGPU manager, e.g. with
the vGPU type hard-coded to L40-24Q. In this way the boundary between
code in VFIO and code in PF driver is probably more a vendor specific
choice.

However according to the cover letter it's reasonable for future extension
to implement new uAPI  for admin to select the vGPU type and potentially
do more manual configurations before the target VF can be used:

Then there comes an open whether VFIO is a right place to host such
vendor specific provisioning interface. The existing mdev type based
provisioning mechanism was considered a bad fit already.

IIRC the previous discussion came to suggest putting the provisioning
interface in the PF driver. There may be chance to generalize and
move to VFIO but no idea what it will be until multiple drivers already
demonstrate their own implementations as the base for discussion.

But now seems you prefer to vendors putting their own provisioning
interface in VFIO directly?

Thanks
Kevin

