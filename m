Return-Path: <kvm+bounces-57521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F32A4B572C7
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 10:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DCF37ACD14
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E7462ECD1A;
	Mon, 15 Sep 2025 08:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jv60jXVk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEF82EB5CF;
	Mon, 15 Sep 2025 08:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757924566; cv=fail; b=sJQG/m20rkHi0Z9zG8Ic5f4YYOcum3V/oS14vyG5SrdtUrSSENWNySMQ9WVDaTYOgy8hBd74NcizGAC362mytjvoDFajk0wDTVjz/VjJ9WnRuYzf63GJJt2yKkXFA+JQtCVZY8+CSTSOQFQQmw9N42dQXozKhbhaIwkC4Mt2Ix0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757924566; c=relaxed/simple;
	bh=UA2+2Y9rGBjVKjhtWu+s3CvOR2X1ZmPOr/wVnxPq8Ag=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fsQ/EnijMgHX4G+6yaJSYVI7Oo4UpfoqgxgRByrf31jmhhRiVKxNyAwNVR/L/Nc2kgBxYF0fnUtwN+b2SKFwnMO1DyQLhlQUTRLNJnWmGZgR8+pUG1LNchbITRRZSaeC9XKGU7sa9qnAbGf+k+q0YXHac1jxn0IKPj9BUdKKMPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jv60jXVk; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757924564; x=1789460564;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=UA2+2Y9rGBjVKjhtWu+s3CvOR2X1ZmPOr/wVnxPq8Ag=;
  b=Jv60jXVkH5SixOdTLcGYRFxgIfp1OFq3kOBcZJFbi1fqWpFrHS/drJmQ
   Ku8noolxHynHXSj7nTj3+ZRa0hH80moiH4taC5foynhVPmsSoMvAdtDeK
   XEJCp25Xi/f9Y+sKBhKXBhDeRLJ5HPCNz+f4ibiYWPL6eQ1bhQ8LDBlsJ
   qiD5m1T77OYRhA3VHDGkX+fHZ3RVqE8HUvu+Y1Gj42W1n3ikulZbj6/oV
   XPkAXhm4M7Tg4CPqE0b4bOGuO+xjEZu4oGz3l7o2FFCROjXP60HzDwiME
   +yJx2jHxDRJ4nmKF4tH+r0WieMgdypJurbmj8YJA2MDzVsZcdY4j3cH5e
   Q==;
X-CSE-ConnectionGUID: FwYh6o5QRKqgNbzltqIEWw==
X-CSE-MsgGUID: N8NB47Q1SEOxNuho7n2XCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11553"; a="47739188"
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="47739188"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 01:22:43 -0700
X-CSE-ConnectionGUID: xhm3pqzMQMmxHMelYdfZTg==
X-CSE-MsgGUID: 4g11Py8RSzWJvxVyso6ijg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="173697110"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 01:22:43 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 01:22:41 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 15 Sep 2025 01:22:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.84) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 01:22:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SvxY22m1lvGL/fhtWhpiMLxIIy0BJ29S+u3Ywv3AdcsXydlU5EO5FYvAKJLialIQLtNblQZF6Stiete46kN2Rnf34CBIKXkqLHzrke/qQxT4P/dG7jTjKMRcO2cJUuHLJB9OwyHxEdqc2eZnDRs2noI02p80HOOsKQ3J7tALUQnMbuDrSgoAzCZ65Oj4gIgUDvVeK1g6MYas12S3HEnViZ88ka/CYKWi4/rTeWA56mEmdk1fBWgyUv9J1cOK1BAi3qlJOLxFdHf0k4XHVGP6bDZN+OLjiBft3qw4P2o3qrciOhrDEIpTtdTUANYwY2Y3cIdT6+pcv+HS6r1rkFlVXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBHjhhet7vhN5Gys7To4t8CdO3i4ECCbtBVCpcQ2bDI=;
 b=h5ihVezotxlrrMqaMDy/fERymcSa/mangNwLf+Neez9gbwJN5BN6CWcGSrzuQufR6YOjyDhhhA6p9M0p6SgRTNT2q0dHxGJjsuml6Ikr59ZZYKXj90inbojY2gH8ABbEe6Es+X9QwfZU2fMVem9SkIP+Dlqk5RNy3zPH6Uf3z5/EijA7V4AoUGEeuIL5tk4w0Z3fWc4YANGV6TjQ/Ws+6K47EbgVgazzVdCUT7nAd54PkO7naDsdftlvDnQwe8Mf2gypyjkvV9nl1jOymWufZUf8hka4/CsHa4j469fqLJDdcMJW1rB0JpHaUcaTRYgZQJtvgW774k0wU5iOlh/jpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7815.namprd11.prod.outlook.com (2603:10b6:208:404::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 08:22:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 08:22:39 +0000
Date: Mon, 15 Sep 2025 16:21:39 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <reinette.chatre@intel.com>,
	<rick.p.edgecombe@intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Test prefault memory during
 concurrent memslot removal
Message-ID: <aMfMk/x5XJ1bfvzv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250822070305.26427-1-yan.y.zhao@intel.com>
 <20250822070554.26523-1-yan.y.zhao@intel.com>
 <aL9rCwZGQofDh7C3@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aL9rCwZGQofDh7C3@google.com>
X-ClientProxiedBy: SI2PR02CA0031.apcprd02.prod.outlook.com
 (2603:1096:4:195::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ec7ed26-f23c-40b0-6542-08ddf4310806
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?l31/aVheOmttXNE5EQC6FXl/TEAS/hjWj4BcP6MF7DLkZ7B/NbCWDk7lDfe3?=
 =?us-ascii?Q?dcFpfeJC/1jVLVIwQfWGgOUnzZXUv9P3WjvrQ1lHzz1bPN/b6P4iikQHawIo?=
 =?us-ascii?Q?0M01ySD9JQp3g7xisLSERaY0ZEmR7/TSvv4ZKLmaJ74z02T2iUjPc/QAbo6w?=
 =?us-ascii?Q?Wwje1NFbCeFsn/l6YGbDaiF6cv7rMPltBcjTw2iohpiMnFw95KAKA+WY0s7X?=
 =?us-ascii?Q?6c+eyUzF0URW+1nikAh7UbIBvsdr2AudUoX1i7ieDelWAI0q+yG+RMPaCi75?=
 =?us-ascii?Q?JWwUUhxTi1NE5f7BbnUedFztN/8tWGuW0Ihzr15zvewZvc+8VLpxX263O7mo?=
 =?us-ascii?Q?iYmj67Xvf+N94UQ60fjalHklX+CLnwibBBn3yEqjI4QKHaeM3Pd7KX2W5oCj?=
 =?us-ascii?Q?pbDKAptzvGE8mgPrWNvwCdLWIADAVpYZ/0QyurWVpEjPk9wTBJRoikePPsvS?=
 =?us-ascii?Q?dA2b/xc2WRn2q5CS11F12t8MTzaVLS3/tYm5G98++iiMfdkOBlTjcBZYAA/1?=
 =?us-ascii?Q?ASRwxPkbfR0Kud/lLzA/r4bznubcB9PxG8fwkxA1SmphuQiFQHEmCTs1ehcW?=
 =?us-ascii?Q?vK647qwcSnT0slG6F7QCTZr5TxE4ow7O7KAKrcvM5TeF+7r6YCXDemhQkWDQ?=
 =?us-ascii?Q?uo5yvLnogLRPZLxnurwrde0Xo3DqjFtMDJQ8iiumryckvG8mGZwkngOROLf3?=
 =?us-ascii?Q?5E3MwqxNc02Aczv0CrpYT+iSvOFDvs7uzcD98dcst8wxlZoVVniL2FRku2V1?=
 =?us-ascii?Q?XRQXjuN459RJK6Dm2lsnlTrwCyAasir2dmVKZkI+Pmuxaj+DBknTHa3j7DQu?=
 =?us-ascii?Q?p7gTtsx35CQ0ncjEKupE6zvxzsFnN6LEJ+GSQdQLoFOEou1Vzz5c9tNKyLV3?=
 =?us-ascii?Q?RkKz6Bey/r6vEqbdgw7XyQustvik9Ra15XHVuM2rpR9oaZVZEG0x2YYa2Bdn?=
 =?us-ascii?Q?VNfFkVDnVWrnCDcdbdt103PsEikolRVkQHyeTGQBZvSgnTOH0EO6qq/Cu6rK?=
 =?us-ascii?Q?/plGvn4RCMopxxcqMil4OlvSxNuZKCzr4J3D1sA56iEPEDwB3Izj14R3yl/t?=
 =?us-ascii?Q?UfazDq5cbJCE+Lz9khSPNkKH0EKUQ0sKGU/d3TiIeMULfaKpobzNCoTFw3An?=
 =?us-ascii?Q?mxuAymhS9/Re0vzzEZ778W9aUp+OXIztgrdQehZ1immRSpwwGUcLlwxtBMBB?=
 =?us-ascii?Q?Ak3fIeLqYjeSHWHv3boJvbF6FanhZeAQLWsArrkivoMJKb0QfycL1SLdLooN?=
 =?us-ascii?Q?HAaFd4Q8Ijc2Af5IzLC+yc7RUu3kOLCixOhCtfA7HnpNh43javA1gmVQNbSu?=
 =?us-ascii?Q?/6Rzf/J4zh1DFF/S8EjAlcFLm0hm/a79eLTsifusiA9kLUtS5u5EJFlAv7Eh?=
 =?us-ascii?Q?FLux2PfWrbH0WjpLA5y7iMgVv4fQrKsNDeERBxBb3f/m3SmhgQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9p4FPYaT/vJyjgaW+5pe28G4bQ22ZFXomh/ZGwxsIOBI7f9AhGtSX/83hQ3y?=
 =?us-ascii?Q?roO7njiwzSOLO3xiAGJ7P1IxNs+zFHj8bUhk57SNeyJbBX1vQidYxr5DH6fd?=
 =?us-ascii?Q?tBCOaiGUct76zL+cL4engRBoKb/cvDDmUgzYiFziM1O4h2iXLFReZ5tDPWz+?=
 =?us-ascii?Q?pI85yonr52SEUrLRZIeU07Z/JvML1wdpE/0w8H1JYBp0hsq5/6hjv/KecqqR?=
 =?us-ascii?Q?s9nLaFNmrNWtL4u/obfr28lr0orPLOoDJA8b1m0cQZlZdpr5pLuP82u7g5/q?=
 =?us-ascii?Q?zBdh5vLqfIfTzwT8OL3elWsXHfu5wWZWImrU8g+VfxhC4eXWZiTth33Am4mT?=
 =?us-ascii?Q?mZ185hkuHbO/WOS7Y8H/3Xhb++w3l7DW/xdVqVeh427TLkhSQkMQXAKNHU3H?=
 =?us-ascii?Q?eIMCSyoXYOCMVwJ4iY9GxpzZ87ViMDB5vTLl2MlCoHilIb/7QvJLwJTvk4X7?=
 =?us-ascii?Q?KWJIn06GmeU3vLGkUv6xfHyVp3dXvXFF2/CM/vWSLc2SrY2wjdEEWOeyXx+J?=
 =?us-ascii?Q?+K5y81UJpy1aR4oAA/Bqjq09O+MuiPek727S17DLs0wrCEsj/ZQHOhF2qQmd?=
 =?us-ascii?Q?U8SWpCCgwXcWeNPkDbHPEb1bCtQVwFuJKFJfZwg0D5D/evlAXHKDQQmhia/m?=
 =?us-ascii?Q?0hdZe7ddAxb6YiChcHkIATu8hPiDVNYINzOdA7ZsU3mIMDRzP0EK3dPszPEK?=
 =?us-ascii?Q?4bryjWaSPO+K9l5eBmSL+v14TnEcKOC1phhEMOdhHzpxRAgLLOzUpgnKgPeK?=
 =?us-ascii?Q?cCiLacR1W0hXzAS1B+kLf0Yjc0IVuxLe1bT4KArBXtivh1v5nPIdOq+KDI6N?=
 =?us-ascii?Q?igfcv6AZ8lJMtimb0OpeVRfGQwuImC1guIi90y3kDSKbuK6ZM/sgfEGAxZcf?=
 =?us-ascii?Q?i1hm0fLP0XFpMhPKSBB1WIUPJYtjXyaEAarFotrrvPDfaPNFX7+EeiZhM95/?=
 =?us-ascii?Q?SVikfVYC9QQa1DjNQ+ywzCT5CdQmS0P5gN51MT2MGMYyu6szRHvT6NWogWSE?=
 =?us-ascii?Q?Mr3pAnG9V1wRzUun8Ob+fsQxK1YwIIuHHhjspJynFcHYw2MIu2Nq97BSNXeR?=
 =?us-ascii?Q?2adgrvm9c20gH7b/K8zr2Ojmyg6LpuOAJx0cq4KEbSkabnhhJLG/DgxWkT2I?=
 =?us-ascii?Q?RwX1qkWjqSVgHDWXz1CMrxXe/nWqvEDmVf8HIDGFaQ9jwbRIOpET9tOVzl8t?=
 =?us-ascii?Q?XPnCBTsI6xYna5wEV3ToxmGW2E/khVaS/KfRHJ83PuuwyKdo7llLzJclqh1m?=
 =?us-ascii?Q?FHYp+dvPolZopbrmck9Zbh/ybZTW8DvHg/tolYh7Q/EiseLUWBx0B41jgtSv?=
 =?us-ascii?Q?W0U0GN5/91khLwMaLsf4mkz3jahd9I+3GutwPWdbSF9vMa7tS/G4tc8S+2la?=
 =?us-ascii?Q?sxKnD8ZrPKhgVDTfvwuCgJSbnsFdrcr5L7dPxnCuRdv0Gnj0c1plDYcp/F6r?=
 =?us-ascii?Q?nVaVA5bPVtLuS0/+mZsu9D3RwSU2KO8Pm+wtgM46XDIqeJlg/GZMEz7vCiF0?=
 =?us-ascii?Q?MI4VBsZueJvKq5QHd/r0wVj0sHgMXDivHqyioxChTW3StpFsazTHeiVDNdnh?=
 =?us-ascii?Q?sDGImJO3yFY6LUORH995/f+wrRjpuNX1GSa4AQ31?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec7ed26-f23c-40b0-6542-08ddf4310806
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 08:22:39.3836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9Yf+nqZ4qDNggUbgDItXe199xlfHP1zo3d54sAO2/U9u5uRcyNosngouXQNKLd/HlcaZHet3PbA+yobzPpFUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7815
X-OriginatorOrg: intel.com

On Mon, Sep 08, 2025 at 04:47:23PM -0700, Sean Christopherson wrote:
> On Fri, Aug 22, 2025, Yan Zhao wrote:
> >  .../selftests/kvm/pre_fault_memory_test.c     | 94 +++++++++++++++----
> >  1 file changed, 78 insertions(+), 16 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> > index 0350a8896a2f..56e65feb4c8c 100644
> > --- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
> > +++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> > @@ -10,12 +10,16 @@
> >  #include <test_util.h>
> >  #include <kvm_util.h>
> >  #include <processor.h>
> > +#include <pthread.h>
> >  
> >  /* Arbitrarily chosen values */
> >  #define TEST_SIZE		(SZ_2M + PAGE_SIZE)
> >  #define TEST_NPAGES		(TEST_SIZE / PAGE_SIZE)
> >  #define TEST_SLOT		10
> >  
> > +static bool prefault_ready;
> > +static bool delete_thread_ready;
> > +
> >  static void guest_code(uint64_t base_gpa)
> >  {
> >  	volatile uint64_t val __used;
> > @@ -30,17 +34,47 @@ static void guest_code(uint64_t base_gpa)
> >  	GUEST_DONE();
> >  }
> >  
> > -static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
> > -			     u64 left)
> > +static void *remove_slot_worker(void *data)
> > +{
> > +	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
> > +
> > +	WRITE_ONCE(delete_thread_ready, true);
> > +
> > +	while (!READ_ONCE(prefault_ready))
> > +		cpu_relax();
> > +
> > +	vm_mem_region_delete(vcpu->vm, TEST_SLOT);
> > +
> > +	WRITE_ONCE(delete_thread_ready, false);
> 
> Rather than use global variables, which necessitates these "dances" to get things
> back to the initial state, use an on-stack structure to communicate (and obviously
> make sure the structure is initialized :-D).
Sorry for the late reply.

Indeed, this makes the code more elegant!

> > +	return NULL;
> > +}
> > +
> > +static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
> > +			     u64 size, u64 left, bool private, bool remove_slot)
> >  {
> >  	struct kvm_pre_fault_memory range = {
> > -		.gpa = gpa,
> > +		.gpa = base_gpa + offset,
> >  		.size = size,
> >  		.flags = 0,
> >  	};
> > -	u64 prev;
> > +	pthread_t remove_thread;
> > +	bool remove_hit = false;
> >  	int ret, save_errno;
> > +	u64 prev;
> >  
> > +	if (remove_slot) {
> 
> I don't see any reason to make the slot removal conditional.  There are three
> things we're interested in testing (so far):
> 
>  1. Success
>  2. ENOENT due to no memslot
>  3. EAGAIN due to INVALID memslot
> 
> #1 and #2 are mutually exclusive, or rather easier to test via separate testcases
> (because writing to non-existent memory is trivial).  But for #3, I don't see a
> reason to make it mutually exclusive with #1 _or_ #2.
> 
> As written, it's always mutually exclusive with #2 because otherwise it would be
> difficult (impossible?) to determine if KVM exited on the "right" address.  But
> the only reason that's true is because the test recreates the slot *after*
> prefaulting, and _that_ makes #3 _conditionally_ mutually exclusive with #1,
> i.e. the test doesn't validate success if the INVALID memslot race is hit.
> 
> Rather than make everything mutually exclusive, just restore the memslot and
> retry prefaulting.  That also gives us easy bonus coverage that doing
> KVM_PRE_FAULT_MEMORY on memory that has already been faulted in is idempotent,
> i.e. that KVM_PRE_FAULT_MEMORY succeeds if it already succeeded (and nothing
> nuked the mappings in the interim).
That's a good idea.

> If the memslot is restored and the loop retries, then #3 becomes a complimentary
> and orthogonal testcase to #1 and #2.
> 
> This?  (with an opportunistic s/left/expected_left that confused me; I thought
> "left" meant how many bytes were left to prefault, but it actually means how many
> bytes are expected to be left when failure occurs).
Looks good to me, except for a minor bug.

> +		if (!slot_recreated) {
> +			WRITE_ONCE(data.recreate_slot, true);
> +			pthread_join(slot_worker, NULL);
> +			slot_recreated = true;
> +			continue;
If delete_slot_worker() invokes vm_mem_region_delete() slowly enough due to
scheduling delays, the return value from __vcpu_ioctl() could be 0 with
range.size being 0 at this point.

What about checking range.size before continuing?

@@ -120,7 +126,8 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
                        WRITE_ONCE(data.recreate_slot, true);
                        pthread_join(slot_worker, NULL);
                        slot_recreated = true;
-                       continue;
+                       if (range.size)
+                               continue;
                }


Otherwise, the next __vcpu_ioctl() would return -1 with errno == EINVAL, which
will break the assertion below.
	
> +	/*
> +	 * Assert success if prefaulting the entire range should succeed, i.e.
> +	 * complete with no bytes remaining.  Otherwise prefaulting should have
> +	 * failed due to ENOENT (due to RET_PF_EMULATE for emulated MMIO when
> +	 * no memslot exists).
> +	 */
> +	if (!expected_left)
> +		TEST_ASSERT_VM_VCPU_IOCTL(!ret, KVM_PRE_FAULT_MEMORY, ret, vcpu->vm);



