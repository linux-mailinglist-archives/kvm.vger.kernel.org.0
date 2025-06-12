Return-Path: <kvm+bounces-49230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74ADBAD686A
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 09:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F158B3A9497
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 07:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6A61FBCB0;
	Thu, 12 Jun 2025 07:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X71zy2o6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0B9142E73;
	Thu, 12 Jun 2025 07:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749711701; cv=fail; b=mX5q/ZOSc61KQmuZlq1SwukFWPLONpPKrjose3eEoQ/ePcrDSIDOsdsFBSffNZO2lyLktol3vIg3mtNMGBdOoyuJrNQqOrMHJey2FyU7CjrTfjwc28V+KiG7O9SlHUvL2gfcNtMVIPxdvEtiBnuaGv5xSgJJrjtU28NHuqH/gRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749711701; c=relaxed/simple;
	bh=78B++eMGfYefxl7gQbYWX20F8pL/+ez2IH6lTGucaIU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IFw1AioAFfxb5xQU8tcveTlVZ4ghFoCeIX+FuulBDXJa6VCPYMpqyAx7oh7GWwSy0gN2o2xpsAEMHQrjnkt1MuAuOi+yGd5YvLwocbkmMGuqP5H5uFTVfzctWfz79N6Q4pOY9dxQpn50E9ODtZ6OxrKoV72VEkoPgwLFiv+gUN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X71zy2o6; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749711700; x=1781247700;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=78B++eMGfYefxl7gQbYWX20F8pL/+ez2IH6lTGucaIU=;
  b=X71zy2o6DRaghAI49ug8ukKox9sd4Fp8HL9dF3MTnkjb90qUCn1hqed6
   oYmu/C4K2XPa8S96hIoP0tM3R4O0kl3mM6xrqcROUmb5vYXns3urBwN2j
   +QlRlddMk52GD92qTtblxQhLApfpGm8DmFWWjZctUSVa3lNOiEUsShFSq
   tORmwmgEB5riSNicvDn/tPAD7k8FvhKxfmyAn3Gsicw6N2sXrUsLfXtRZ
   QrxVuhw4uHq3HwHD/a9aUxrwecAZ5AmWBwYnNllQ6GS+ubZB8EWZt6Jlo
   zOrXgIcZiiJJz2Zc8Ma7VSA8w1/fxN55wSk8+6urCSsidiaWSd7Bf2uO7
   A==;
X-CSE-ConnectionGUID: sdv+cBi4QHas3nbRI9WKgg==
X-CSE-MsgGUID: IXHIG35ZTtmjMF8L4CFQpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="69314158"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="69314158"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 00:01:38 -0700
X-CSE-ConnectionGUID: MH9qd2C1Q4OcPT6UYU7Obw==
X-CSE-MsgGUID: mYZ6GpHGTo+FeQXXGqMxug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147337628"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 00:01:37 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 00:01:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 00:01:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.50)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 00:01:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZOFhuK6I6Vxtk9EzPcMfccTOAmO/+yNNg5cc/6m7ioQLVMW2ZuYZGN2IAH8ymged18P5mftUdgiSQYZuKaGNjOg2bUOBuuB6jAflWiLeFw8Bq1rsp0fN0M4VEvBsAJ27XNYEbs/M1BCE5gaQbhI6Fw66HIku9soGXy62G60aLGE1R+2Iz74BPB5Lfm062eAJVS2pC1mrne8IzFibTs6GrZxDGDOlOg/ekMHZHpD9NfBUeCE/qMCyeLS4Zkglx3kfMIOS2DRB5/bNQ5e5mL/jFawh7h9dr71bcd2pLvtEhguRht3DZO6F5R+FHiQptxKHtkU2tPdh4dtZ1L7VNh/+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMxGHnDX9WwiTOmdB4rhgPuWOkzP/gjhxmMlRCJ7s9A=;
 b=S1WIoMwI3gRTd9qcozEX3dSVD9w13UrVoDdOUdm/iF0JnjYxZ0QPtJNkKXTHIV8zpGSWx/hbnp+olNd17rbO/s/hlx7njgUav06S/HJ8I2acDNoeOFX0n6EZARUSBggFE/3no5EdKn+1wU81XQfb5C0J1gcKAacsUtVfqeArj3FcCju34xTRc4pQhaYUt/KDHcbZ2TKZWJREkvbeYrVOdfCXpvLCfnMtKqT/v6ZeL89H7hZiJHlBb9Zp/pYe519XhUbCAdvXx7ncTygEoDE7Xr1HC2QYqonLpJzbo62ihj/o0S45m5/MKKu1nkcEwDQwurkf48TkkRBwx99MpHpYwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4995.namprd11.prod.outlook.com (2603:10b6:303:9f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.19; Thu, 12 Jun 2025 07:01:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 07:01:06 +0000
Date: Thu, 12 Jun 2025 14:58:44 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, "Adrian
 Hunter" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Message-ID: <aEp6pDQgbjsfrg2h@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
 <aEnGjQE3AmPB3wxk@google.com>
 <5fee2f3b-03de-442b-acaf-4591638c8bb5@redhat.com>
 <aEnbDya7OOXdO85q@google.com>
 <7de83a03f0071c79a63d5e143f1ab032fff1d867.camel@intel.com>
 <aEnqbfih0gE4CDM-@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aEnqbfih0gE4CDM-@google.com>
X-ClientProxiedBy: SI1PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: c4417d99-10df-4e31-3408-08dda97ee6d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?ehNrINIpMZxcWZEFsORv3Eh97Vi+UitwITu54F0h4DEK/rm5KhhBU/og2F?=
 =?iso-8859-1?Q?Lw018MbWSZPWrYHUv7w1dOXLjWTUljMbSRbIGV+2PYfxI0rugZHsUw7+Ip?=
 =?iso-8859-1?Q?BL/PArzsREX5In1mONNdyAb2mWh8ZBgjWp3nWWOx4LDzWq+GS1j29RBEEK?=
 =?iso-8859-1?Q?+zlRa/ZoN5+9kS8jPoysTSc6f0djkZptj7FewKCObU/Xsyw8KfiBSg1480?=
 =?iso-8859-1?Q?CkD87FBGkK7hyC3sXJezkJwrX/hqP+CjDNSkZdzTFDUGXY/33nSywMLYq4?=
 =?iso-8859-1?Q?DqI9HhNkoH6WVTeleTPAo4/RhfXXhEH5++Wvh1LlWbeOXGYLE2DRVsQiYp?=
 =?iso-8859-1?Q?EznSibyB3IvJ9J+pPPZzX9nn56kAR09l1JA+NP4ZyboaHPEjRNrZ0DzTFX?=
 =?iso-8859-1?Q?bJT2LIkyPftqTKL/ISTZTcmrtLxiJGqjYP20dk7Ig4Qr4rQBD355m7Qk2E?=
 =?iso-8859-1?Q?q7en1U3MH69CE6ZEgY5Ea99zfLQdgbzUP5rUE7plmndp+k1EZei3hhUoHB?=
 =?iso-8859-1?Q?2tFPixj0tQHdR2/zqqEmx1tvrYObRKvLYtykjSqNQxSsy16pP2Q8OOM2w4?=
 =?iso-8859-1?Q?D1GqjM3u8Eyq73VCfWGBGThzV5/EwckjBmw/mQnLpsS53PSku/Js4pjwbB?=
 =?iso-8859-1?Q?PnJ7dXmSdU9Kqd6CABDV8Zo/h7A0IxkrU4uGkBila/Lun8ci7jpY0YAJtS?=
 =?iso-8859-1?Q?rG2DHOJnAhyZtU+iTw/NQzBKaXmwLFlgzD1r7w91sSaZUfq2gb08OPgpPW?=
 =?iso-8859-1?Q?bqCT4wsSbjOxGGrgW5dkF2SmdZVO5KyBOBubyfgk/R4HeyUnsOi1APOQAp?=
 =?iso-8859-1?Q?ou3MTZ7m0OtZuIRJBZL9rBaehoQ+dJ+uGgU4Ri4lS3QB+U71WPp+JOUjN7?=
 =?iso-8859-1?Q?+GL/8jjg/Sylq74oMphdYbUkQXE+NTvoR+Agvg3VlONgWwVicw+kn+TynN?=
 =?iso-8859-1?Q?QmkERim/lbDrpRVqz/MAqqC0ed29gsyzxA0J430tqHaO9URs6qXKvORUmH?=
 =?iso-8859-1?Q?Nr+8EUgoJ8ocbzoLuCrYhdGD9oA+FPw2TUDNLU/OjkatvRISqqqkjx6dOm?=
 =?iso-8859-1?Q?g2FCIMB3vbRQ6yhvjSYALe3zN4E2oDxbCDIb36OOzo6Lvl9jhHz0jtmWYS?=
 =?iso-8859-1?Q?57FMpV8yUVwrduTlcPZb8Ju/cfGCCIXmPPyuapDq0VN4dA5yW4kMLgMCTf?=
 =?iso-8859-1?Q?mWfMDk3qKKOdrkL6+5xMTgTbyerEpTzbpFShkclc5XgljLw4OUnvE1qDlg?=
 =?iso-8859-1?Q?UZvcpID4uzH2w6yFXbsUV/4NgnRBjNJ0IWTGR8fnxUUI90cs4E1q0/ECUX?=
 =?iso-8859-1?Q?xR2M8BL63DKB/+BiUGHVpioh45K2tXW1cirzBdwpth+Woi25ClqvhfAJtK?=
 =?iso-8859-1?Q?Qv/1vDQ85luwZUyelUuz3HKiiyLrCCC7K1nqmCUdnre4fq3KGLeqg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?VTTx2QZq4o5LptRSzcdIWr3YobPHmEwO4a2DM4kfWLlmVY94KzaVAjXLWq?=
 =?iso-8859-1?Q?Emm3pvfNg+YyntZPlPUG+Ct0f2gkPOr6oE4j8lLI2GRPzet4z4Yj8Yc9WQ?=
 =?iso-8859-1?Q?K2qNXLjGo6nVRgyP9ulHbUCOkAb6Cy04jjnzM5UH0NXXXUkaKzCf/YZlf+?=
 =?iso-8859-1?Q?oIgnPVjigyuP3FkONKQLJzHQZKX55DoI8/bOa4XQYrnrMovpt7RDlG7ERt?=
 =?iso-8859-1?Q?enKP/2OWi5JXlXLvnQPzKkPJV1XYE5OoceRb/mYhz/TWXbUt6Qyjpv84Ls?=
 =?iso-8859-1?Q?SCbR7mD6TpSWNlDbEnlZ1cen1Eo2BvCrR77dSJ2ZW4CYcRcWYod5RZzr2U?=
 =?iso-8859-1?Q?xqBWONCb+3rzwmhPD6OXGElQH4sTQ7mTAHQWDG26TrqWZf1+2/wn4S08dg?=
 =?iso-8859-1?Q?0IupNUp9NHMiO3vwAwYcA0B7vX/dJRKLUNW8UwdWXbnYdjEVc9MgCRRMmL?=
 =?iso-8859-1?Q?zvZQiZG11hIFJ9Q9BO+8i1SbJhLNA9u6ZXQZr0oI+uAWPAgllL7GZdufEQ?=
 =?iso-8859-1?Q?dU7inRwoWF41bbTyZhCL5tB3qZHVDuA3gMl8UJltmO7rsipDgzKLtzSARn?=
 =?iso-8859-1?Q?P/GmEPlEOR/bi4sDdiF93T3tSZ2HdTv3Tjmy9vSz2w+jkkaW71SaOOn1vr?=
 =?iso-8859-1?Q?t9X7gvZGk7szPPnt5cXg2WdqlQ6FxBUpq4Ilm3rAUuCq5ofr6QpBc9OquW?=
 =?iso-8859-1?Q?D67zU7Uxl/Q45uf/bvyODeFTACN4STcC2MOdYu9Px2l6VzxU0mikmocBBy?=
 =?iso-8859-1?Q?w82jPGdBMiBB+r3SdCL24z+e4P5jRHt1NzO8tIu1jkzVEnMDSPEyR2K2L4?=
 =?iso-8859-1?Q?jOMQpZHCugedxtCrsNmm0+HcbPvvObIb+NJg1fdhHuHXh3oZfG7pgc7I04?=
 =?iso-8859-1?Q?iiXOcsvQ3Kl6ZmbGZIncs5QxgL9OdKXvleM08KMp6w9U2uCM3XtrVDE0v5?=
 =?iso-8859-1?Q?4yLbNZ30MVekCi5YwAbJkuyZGHPkzubCzjtCCQSO8/xXsz7LZPLUa8x/QF?=
 =?iso-8859-1?Q?G+2eNJd/PYAQLZKMt6Qf506oSws9dP25YDu5EMGMx9MPHGMJf7K9T/lLNy?=
 =?iso-8859-1?Q?t3h2Chwdn1PtPAB0CAFB4chilbM79NGsD+pK/FhcMJgUYTvI7gko6LvsZI?=
 =?iso-8859-1?Q?tSgMN3w6CaC4dftOhCoysgLJuPiz+KktuaZoX8oJy0DXJ5932ycLIT4HYn?=
 =?iso-8859-1?Q?frOznFm9GwD0RksTAJPtZUVrMYDvSjIjRtYocIgU4hVfftZpUB60o58rJL?=
 =?iso-8859-1?Q?Atn6vwbwgJqoK/qsNh3+kwBigO/U1/VH/Jq+V3Lk/u7vn/PubH2DIep65y?=
 =?iso-8859-1?Q?wxete0DS9CywJp5YvBy/nZmH8V2ASL4s6LmEL+N9w7swPtshzRuTlRycd5?=
 =?iso-8859-1?Q?MwZvamuF+lGBZtvQdc2bAxzgSucEwnY8EzG8kBc3OMVGikfRQ6Nh0/MN/A?=
 =?iso-8859-1?Q?/OS+p8lbqthC/+eJC3c6vsd/joMRE9t6AvqcxDwmUUQUpPAI98UNjQrEvL?=
 =?iso-8859-1?Q?dZzLBVgLUmWh1Q8y64v/sUK3EgySJpEJcwF/7+k9kCZk0NBet5i5992a6q?=
 =?iso-8859-1?Q?6B7XIRzoxJv1E4mBkuZzlNoZ8wPbd8I+QRTHdi9PyNCDDykzmSYNqhWGZQ?=
 =?iso-8859-1?Q?jUdzukpev85b8poK+9yJnXTLMvRViUZWOS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4417d99-10df-4e31-3408-08dda97ee6d6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 07:01:06.1793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XBqkGDaVNVsEIsj2Vx1wZn4eNCSZKy0GpEQG0q0fNgXLm8UxlsLsRt7PEu5QeDRsNAuizZKE8CsPu42bU9Rl6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4995
X-OriginatorOrg: intel.com

On Wed, Jun 11, 2025 at 01:43:25PM -0700, Sean Christopherson wrote:
> On Wed, Jun 11, 2025, Rick P Edgecombe wrote:
> > On Wed, 2025-06-11 at 12:37 -0700, Sean Christopherson wrote:
> > > Ugh, and the whole tdp_mmu_get_root_for_fault() handling is broken.
> > > is_page_fault_stale() only looks at mmu->root.hpa, i.e. could theoretically blow
> > > up if the shared root is somehow valid but the mirror root is not.  Probably can't
> > > happen in practice, but it's ugly.
> > 
> > We had some discussion on this root valid/invalid pattern:
> > https://lore.kernel.org/kvm/d33d00b88707961126a24b19f940de43ba6e6c56.camel@intel.com/
> > 
> > It's brittle though.
> 
> Hmm, yeah, the is_page_fault_stale() thing is definitely benign, just odd.
Agreed.

> > > Oof, and I've no idea what kvm_tdp_mmu_fast_pf_get_last_sptep() is doing.  It
> > > says:
> > > 
> > > 	/* Fast pf is not supported for mirrored roots  */
> > > 
> > > but I don't see anything that actually enforces that.
> > 
> > Functionally, page_fault_can_be_fast() should prevented this with the check of
> > kvm->arch.has_private_mem.
> 
> No?  I see this:
> 
> 	if (kvm->arch.has_private_mem &&
> 	    fault->is_private != kvm_mem_is_private(kvm, fault->gfn))
> 		return false;
> 
> I.e. a private fault can be fast, so long as the page is already in the correct
> shared vs. private state.  I can imagine that it's impossible for TDX to generate
> protection violations, but I think kvm_tdp_mmu_fast_pf_get_last_sptep() could be
> reached with a mirror root if kvm_ad_enabled=false.
> 
> 	if (!fault->present)
> 		return !kvm_ad_enabled;
For TDX private fault,
-fault->present is always false if !fault->prefetch as its error_code is
 PFERR_PRIVATE_ACCESS | PFERR_WRITE_MASK due to exit quilification being
 hardcoded to EPT_VIOLATION_ACC_WRITE.
-fault->present is false if fault->prefetch is true as its erro_code is
 PFERR_PRIVATE_ACCESS | PFERR_GUEST_FINAL_MASK.

In tdx_bringup(), enable_ept_ad_bits is checked as a prerequisit of TDX, so
kvm_ad_enabled should be true.

So, page_fault_can_be_fast() should always return false for mirror root.


> 	/*
> 	 * Note, instruction fetches and writes are mutually exclusive, ignore
> 	 * the "exec" flag.
> 	 */
> 	return fault->write;
> 
> > But, yea it's not correct for being readable. The mirror/external concepts
> > only work if they make sense as independent concepts.  Otherwise it's just
> > naming obfuscation.

