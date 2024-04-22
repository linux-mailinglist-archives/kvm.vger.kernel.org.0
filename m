Return-Path: <kvm+bounces-15476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3FA48AC87C
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 11:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42F8E1F238CD
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 09:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F91353E22;
	Mon, 22 Apr 2024 09:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b9iY7g4D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA4B4C602;
	Mon, 22 Apr 2024 09:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713776946; cv=fail; b=PUM5vAhCZIuaok/H95Zn+VjIKXNqrKgUVrIffXc5pQEjD3A74YqLEpJb7yBqHnKs4S4bEiaoRvqV2FcUDKSC15vHNg9VCnzub9+my3t3fVJ2yntA+0z+DiC6/kCXzZ1gyrEiTCRtPmQ9v9WPxmZQ8Dk0anUy3KWo1QakKoKIWWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713776946; c=relaxed/simple;
	bh=j+ay19Csb4XfGcVnBgT5chdbldPi91+rLn1w6PuP4Sg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eh3DQhD3FbSjnvmmPN8BAnFrlb4i8DWlCSqIycSuy4LlAr661monrjY0C15GJ7lES8a4K8jiLvg/68h0TRH20eHnFBsn//enqLz89Dv0/pkPK3oNCM8gMWPcq9qka9bR9SwFHQI4NDEs8rxfR+1XP+YskTsQ54vGRidIuUAEprA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b9iY7g4D; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713776944; x=1745312944;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=j+ay19Csb4XfGcVnBgT5chdbldPi91+rLn1w6PuP4Sg=;
  b=b9iY7g4DJhGeEg2VIW2ueJi6lIJmRXL9dRvjyBCCbbJ9x7DWuoPPj/uB
   CHgwEFhHKuyyY6JNaAeJHsAp7sUi9UfZKr7FASBhLz2RcePPD50+EdY7/
   1Zj6d7MSvW1/uFt1HEOVhhEcp6eSqxZS19N8R8RNzb2dKJJHkMkV03DP8
   9+1hQB5SZhTB9kst5995LX560/iiTrwWjnmJ6xLtd8+Bf8IGNGmaalsY1
   0V60c8HwdjCPtKXLr8FAyalbQ0gT7ypa72P3jQJaIuGkflGv/HmtM/ZFj
   79nML09XGEnwhCNTKbs3FdU+uz7gjkJ28z9aaKCvyCu6RyTPLh5wksCzC
   g==;
X-CSE-ConnectionGUID: n7oldEE+TGmdmcXffMG1uA==
X-CSE-MsgGUID: XYY3TxHdS6Wjudc1Dwcm6A==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="20706362"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="20706362"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 02:08:51 -0700
X-CSE-ConnectionGUID: zvdw5uPnQtaTIl8iGeXRSQ==
X-CSE-MsgGUID: //P2jaN0Q6WN6Q7EtUPB3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="28463418"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 02:08:51 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 02:08:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 02:08:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 02:08:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 02:08:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMCAR+NBOGYZDfygbHzNu8cO8AMi4AnToQ1JiHi4gHEkdmWtfUojEdZdvU2goyLY5nig6+UT23c3TDbbPrF8lxXhd3fHydUtJrkeJUF7XxhJzDUd4Jlks3W5QhI99Q+VyPKkRCYDji6LVRiztmh/TDYEs9wd2lrhbcxGj+mMyXyy8lxCTDSALLfVQRj5C/xq3o3ouZqNe6x5BrLe8DUgRPZ25JK0Z3+4n7kpvCpmMglEB6qk5MSxaedu9SBUC2adMfTdtw3SuGlbh83dBpBBruf92GGRza/Z5mSTXDKHxc/qoYha+1DygGs2xHkSA06VeiVpxAN6db3LPdNGVPdI8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4SukwFLw6Z09vzxqhl2NLCi2N+6eKYuEGOeZumxCYyE=;
 b=Xz8LezflcEEkRZyi+Cc9jgQ+1w/y3Dpc5R6KUdGY4uJk6MfBAK93bxZD46GjbNmOI86ZTTYS7hIcHVriag2kxsZKnELg8z7XRehm8dOxvlDIy8o8nmL6hNVPrt91SWLFqAQCP0OMPadbH52o6UlCjRdqWI+/ZRamPEBGsSyB10pB3ud+dTB6XbYuEcO2p4JXxZEdzmde++yOzUAapPSRYRf8rNrKA1LtfiuOP/HjZOrW/TepmTz1MvQD2eItm1heeuK2JsyI3xWL4NxpVdF3RySQuT/5ykwQWZ6sX9LECV2Nr8RMiCG8QY3gP5Ph6w3CzcDZKjIMokwMvc2l/1kdQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7214.namprd11.prod.outlook.com (2603:10b6:8:139::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7519.12; Mon, 22 Apr 2024 09:08:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::f62c:98e2:37af:8073]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::f62c:98e2:37af:8073%7]) with mapi id 15.20.7519.018; Mon, 22 Apr 2024
 09:08:46 +0000
Date: Mon, 22 Apr 2024 17:08:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <ZiYo/giv0/sNhjX1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:196::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7214:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a5ea0c6-0fc8-4bce-2e23-08dc62abd0f7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pAC2ACtKKLg0EaNGb/RnSrYCjj09fg8duhx2e3yb6/fhTzizVxdxVW7UGeyP?=
 =?us-ascii?Q?vFrtvCEZklO9bQgisSG6WuTdvgvntratnlFPXBp/oBsqNR1LN+m4uUZH49HF?=
 =?us-ascii?Q?UxgkOPOKiNjjwqZJQXE3xsN6C5OvLZNgmnEZ9s3OZDNlw9ETZ0lFfJOt2MeE?=
 =?us-ascii?Q?wQ8va8nBvIdr2uZOGdx8WMkMmv+R21Ceq9p0Mq8TkqGPjgEtflnAAtoNJWSK?=
 =?us-ascii?Q?O7A2U6i5kCrPA5vgaIAVs7HFMwzuW2l3fIMSWbeW3aThmeQx5gRQ3hoVJ0JR?=
 =?us-ascii?Q?mpbt17WsTtgmY7FY6XufJDvIdFWHk5TAkp2tFwC4uvQfzjRodRU8VDMtqGL0?=
 =?us-ascii?Q?2hnl0ZdAveHMxcIkcct6kqOuBq3+ayO47iJUCHh3CP9U5zaqVuvWldKIcVqp?=
 =?us-ascii?Q?vv7mdbp/H16rDSkZF4ZGy1G8KFChMJIJW7jq3FPJFF+b+rS2L/nLxh6iFqFQ?=
 =?us-ascii?Q?JeHxGHn3Gei2jjKFR0uJ1v4fpk+fX+slxUJoe45j4eu+fS6OsMpCe0b0zsX0?=
 =?us-ascii?Q?9dw4PREcdrVYzCWsB86XBZ7VdyZ3QapR53zHEkFnXbmX/Gti2jR0lBKk7CLd?=
 =?us-ascii?Q?ru6MTU4Stssc1sDcMUhcuwgFHyCWWQ+gPSSBmXjrm+20GMpk1QBp0nuTKOYh?=
 =?us-ascii?Q?F0v971+xsY8gn2VzEo+tEWCTON4ZnoeKlgyhafN7PUhe9JFB5ZeF9EucN5SN?=
 =?us-ascii?Q?O8Q04VPwKq17qitzqwkmsWV6E52e1r2jwnfxAoSwFst0KIoJtaoyAkofLL68?=
 =?us-ascii?Q?7tv8+eqYKCWObGwgu9J9i+3bSvUxEbHbxdGRVVQ+CNbI8qtjziPmojLe/dEM?=
 =?us-ascii?Q?rGqhiVb6nbTdCsDDTiDTFaJRgndfDQqzDqsYKbMoa7ueE0LJVZkpV2hHhrGL?=
 =?us-ascii?Q?uCepaZfS9Z0AR6Nh1YV/jBev/p+AFXu8QY7odydlo4kkY2ms1pGp2IqKv89i?=
 =?us-ascii?Q?T4tIj8dhj8mTxWxb7vIr6odWxysdAQPfyLsBnCuM863rjtlQtDtKJ+CdSxcW?=
 =?us-ascii?Q?DSXMqT1Tp2iBJErTjhXtNT1mKf2syz/+bbJ+eB3bP4bNeeBHhSlbW6NKjXD0?=
 =?us-ascii?Q?tMCBvV8HB7peTysHE65y8GVsI1SfUjlUZukovf+knuyz5Fj/oOvxow1EEyH4?=
 =?us-ascii?Q?9HB99ze31ZVPKDnunsHo8qmT1N3TI9ycAst78Vepo45Amsdqkk/FqwAt2FYK?=
 =?us-ascii?Q?Kzg+iNf+uBQ2r0DJNwY4BwJnPzkINenh2eRN2Oobk7IsK3/iyBtqO0eTWqcM?=
 =?us-ascii?Q?5D+qw2cM8iXFiXIOajkzycDH0K1uk4tx5PcJ2M2TfQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WWnlkxAcEDzl0kWtsP2mgGxj5oUoaZ+3daqPsai8wN3CNf/7Ii/EUTwOL/2/?=
 =?us-ascii?Q?tqCKpj8MUwSpoY7zwCdWWqVjv859AMYaMyGRM07rE4SNMP+/iHimlMBxviy9?=
 =?us-ascii?Q?Jw9dLcrA9cLmkynYe383g9+df15BsRXl0EaJrVRHqffUtTaqEOQwlTwi+YR+?=
 =?us-ascii?Q?83y57kwe5cwV9A2tTIQovavqRumByp+1mmQviEn7AsNSSsyu6gJjldn5zWHM?=
 =?us-ascii?Q?CeT0cUlhK1igxzct4YPX9B3VgJDZm/PV0SdkvgMnLznF1QxPEMqgTC9cw6TB?=
 =?us-ascii?Q?hZAHqgy7ybFif0mZ8419i/UHnaDFTLl1tRzvVIN7HXnopZfa7m0A1d85WVTj?=
 =?us-ascii?Q?PveUeGgTbLxEv9zJFd+5+wedM1RZK2QDzXm3UyAvCzBh81Q8grZVMK6IyF40?=
 =?us-ascii?Q?XNHm/Ij1efayciUYkJO0W/AhUjbTkg+LfNt7purnDxWXlI4xHuT2iLgttfo9?=
 =?us-ascii?Q?Z9y3/JZrRaNVUUV6WZaqKJAtkr8gZh1LSK7BwL7FD75YKAVXoBBfF0E07+LX?=
 =?us-ascii?Q?Tg/3ts34KSxaRaSAMjSFeuMn7k1lCHk10smD8vB+eA7QAeLD4lvPjq7qLEU0?=
 =?us-ascii?Q?qetHDdXjRbnDRvNfEYUyaOB1dVG34K77vhbPNPFRQrnjwvrsR63cpa0Ckc4i?=
 =?us-ascii?Q?GGOFGuxv+LmzTaR0rZYdEdL23ySuqDiWiMmLQZq2Yh4+jcxZgO336ykrnTKu?=
 =?us-ascii?Q?9Syx1fpUCgXVTkDeBzF5QrEyCjNJNp9Q1mfMjJc0nuTUW/xKilLp8+MoEwdP?=
 =?us-ascii?Q?6d7z192Jo+sJIPGkEiaqzU1H8HQcOwb8tHMZ1VyQ+im7HuqcdTpgk5P734wl?=
 =?us-ascii?Q?cv9vXxYylmAyxQmzrdB5L0Te+QauX8Slpc+bMDV7PYGRQAPchiulSwssfiSK?=
 =?us-ascii?Q?MfyZPu1ZZeJUvUmNomNI800eK4hgyxCjtH+5NUcJq/RzI/ZcPLjC3gmwh1L9?=
 =?us-ascii?Q?13fcIqg7W5BmJ3Jv26R6wz044+KI5XAD/JCVtXT47p1FpE6WJPyyzy/CXvEG?=
 =?us-ascii?Q?7j8YCKYBDfNVJtep6RydnY3qP2EMzKcMBkSeFpKfqD6E2jVHt2iol4Ada3vP?=
 =?us-ascii?Q?qx8UgawhCv1mcVvSP7hjAO++/ht7U17K+4K9ZNAt58kbFBKTNq/McNI8q6GQ?=
 =?us-ascii?Q?8CB7ZVLPKTAGmRkaeKlMWAYVTMkB4B3urTba07dotAqwyfhaUcsiezA1WIT5?=
 =?us-ascii?Q?lALnzGGuH/fZ2498FLWCvs+k++gjPj6CcwjKhN+BAz9wDUAm2rn1S6TI+t6Q?=
 =?us-ascii?Q?xxkb+Z0fmsiAcnVPXASQUv/dMpPR6Gz65pQmkXwYTu2vhAm5a1jpWe095zdB?=
 =?us-ascii?Q?PQqSBf6hWLeneN8X930urRcUbADUQwo36O85UuS7b6vzxf3fs7dF7/O4dP+l?=
 =?us-ascii?Q?lAsZjaMM5PepsqfK6xI+g1ao3I4aaWN/A2ZfziYmUQcdoLmND6mefUvB4nKO?=
 =?us-ascii?Q?y+mzxeD9zdBBV3274IfNFPyYdvXqUNa8sRz9p/Tvw/7k73A4pT6elEb8FKaR?=
 =?us-ascii?Q?z+q7r09ISXYoTWYjytnQ0k7/wleEzD6RyKLoZL4FDLOc2cAO/07er/hRXr7H?=
 =?us-ascii?Q?vMq34H4YrYic/8eohcT/m3eN03l5YK0YarF7XWDX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5ea0c6-0fc8-4bce-2e23-08dc62abd0f7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 09:08:46.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A27/+k1QrBfHe85gzZWdRPEXyWBudYffW8sZkEm8Ownno0/q+wrEEGVW7gMyxXgLJ7ybMX403Fc9S9nwQbHBVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7214
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:04AM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> @@ -1041,6 +1255,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	struct kvm *kvm = vcpu->kvm;
>  	struct tdp_iter iter;
>  	struct kvm_mmu_page *sp;
> +	gfn_t raw_gfn;
> +	bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);
Why not put the checking of kvm_gfn_shared_mask() earlier before determining
fault->is_private?
e.g. in kvm_mmu_page_fault().

>  	int ret = RET_PF_RETRY;
>  
>  	kvm_mmu_hugepage_adjust(vcpu, fault);
> @@ -1049,7 +1265,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  
>  	rcu_read_lock();
>  
> -	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
> +	raw_gfn = gpa_to_gfn(fault->addr);
> +
> +	if (is_error_noslot_pfn(fault->pfn) ||
The checking for noslot pfn is not required after this cleanup series [1] from
Sean, right?

> +	    !kvm_pfn_to_refcounted_page(fault->pfn)) {
What's the purpose of rejecting non-refcounted page (which is useful for trusted
IO)?

Besides, looks pages are allocated via kvm_faultin_pfn_private() if
fault->is_private, so where is the non-refcounted page from?


> +		if (is_private) {
> +			rcu_read_unlock();
> +			return -EFAULT;
> +		}
> +	}

[1] https://lore.kernel.org/all/20240228024147.41573-1-seanjc@google.com/

> +	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
>  		int r;
>  
>  		if (fault->nx_huge_page_workaround_enabled)
...

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d399009ef1d7..e27c22449d85 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -201,6 +201,7 @@ struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn)
>  
>  	return NULL;
>  }
> +EXPORT_SYMBOL_GPL(kvm_pfn_to_refcounted_page);
>  
>  /*
>   * Switches to specified vcpu, until a matching vcpu_put()
> -- 
> 2.25.1
> 
> 

