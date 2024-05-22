Return-Path: <kvm+bounces-17921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 823FA8CBAFF
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:10:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 187A2B21633
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9832678B4E;
	Wed, 22 May 2024 06:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FEpEzEu+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F9B770EF;
	Wed, 22 May 2024 06:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716358227; cv=fail; b=gj0fkno62+F1JIDR9T/UjR9FPzzDP9XALL17qR4vBNKJcnK6B1imvhphSxE2pjFBrlBVhiLCkVMea95So9C4z8fv7mcttWLUptmSg0PcIJNP00zzNzy9DFhXqrV87dXI9kjhQgtH6NajFDAtcxOGDte/WoNGeQE9bOftqM/gDHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716358227; c=relaxed/simple;
	bh=wH5Q9ci7fa/B+1AOUm6dMm7ApY5ghwz+sBUMwID0pKc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XIBxFszwfKaN6wirOLGjXzJnR7kqr1tNR9ff+K71ee462s9iTcgasRfl7Wqgt37Xy0Q1Ridcok3hkBSu0liNYC+mwx4F8/1skIfNIoRMeIKLFkHf/Wu5UVm9lVZPBfYWz0ky+oMaj7EcVIMADroyjAyYyWBn3kYmmV48pvw75X8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FEpEzEu+; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716358225; x=1747894225;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wH5Q9ci7fa/B+1AOUm6dMm7ApY5ghwz+sBUMwID0pKc=;
  b=FEpEzEu+YcIGT5egplaVjyK/px6oaqiR46Rl4DZymzqOOyjmaLwtEF2M
   N5SGELOe/maCiflfndU5x5L22gHdtt60rKr5Yxe162Xe7+QW0gHG+vIwY
   p/U+6uuAGi8udL0cStO8sUb033G1P8vc4JiYsZHxtRFezzSzQ2/r49hrH
   4OlSpVPyzh7iYtdH1M5ml/rkc2oX0FcDqk29bEzHYs9JD4jYd0vg5ySjn
   oQKyclZhTD9WMOHTnq51yLi/JnbYlrCgNYVBZG7/Og3VQT1ctvooVhW40
   LSeJolLvBmQyPfEQNfOjhGf6eClvnRu6+LQiLQWPPZ8M7nmij3CYgCjb8
   Q==;
X-CSE-ConnectionGUID: DNHDfgfPT4e7viZwHYU/Wg==
X-CSE-MsgGUID: PtkiYfxgQIePqQq7EcnJGQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12760528"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12760528"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:10:25 -0700
X-CSE-ConnectionGUID: SFrQrdO5Qsu8lQDcS/VrNg==
X-CSE-MsgGUID: O3qu1GpmQJmuqdSCrTpcRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33592763"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 23:10:25 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 23:10:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 23:10:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 23:10:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 23:10:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPVoVVRIm8sbngD6VQRt0eP88P2/zLc+I4GxqavvYj5t4x7ojZac+xP2Ht0jZ0ci+4hqXizh2rirec0A0iYm24eCNAWzfojF8xHP9apqrgr2ImuFgtxU9D0aWJp2OOsuHlyxALG18wzsrDej2BrCB9mlAbXdjI2aAHygsyqU3tS2ZUDqha0fFhvhe21flQ0bU9CqJbC7rfvle13TXrRBxVgOU8A9IiPMosdI2/IOhT04WWrgeINlArw23qS4aI2TOSEyGxSJv1gzq79P4oVr2VB+Nm4HuXF8kyFKl0bCUjIw6iCsqRzLk+O/nUaHaSg1WPZcPV/Hq5+W9/upOJ9JMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l68PrbGv9hk67IF93pr13FGP6bISm7BTpwx5xNRJL8Y=;
 b=gT7lGXWN7gK3TfakxXLJ2ar0TbLuDhQQn06dxHJKKWHYBaHHSimHP6rcKxTb4NrZfA/aZRuJNEaOcvAnsJLQWay4zbjYZWAEvDoR9HfFpu2hUwUFAvByFJHpShkgFmZ5BdF0YnQMk4X+rtdMOpkdZDDwm4aW/hrPr6V6LYbuGwpGRilhhg+Jy3OsXyI+8w6tsEdGOQjDWrwU3j/F/J5vGI2yC6lzXWvDnSs6O+3Ex+GgsLgpaLZEwSIJbPwtUmmPL6G/CUSd0BpBFSFsg9VEKWENAxv2tPQDv3aQNweYsrNA7GHx4DfIVrFVnOZ7nuBwGqCLGSfz0EDiQpnoYw76+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB6423.namprd11.prod.outlook.com (2603:10b6:8:c5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Wed, 22 May
 2024 06:10:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 06:10:21 +0000
Date: Wed, 22 May 2024 14:10:13 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 1/6] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
Message-ID: <Zk2MRRkS6c5cGYSV@chao-email>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240522022827.1690416-2-seanjc@google.com>
X-ClientProxiedBy: SI2PR06CA0002.apcprd06.prod.outlook.com
 (2603:1096:4:186::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB6423:EE_
X-MS-Office365-Filtering-Correlation-Id: becd2f3a-0daf-45ad-7fef-08dc7a25dcaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KXF+apMSo5Ffe313XhAQetB1tX7dPROcK9c5P0c26ccq/fnjw7IE/V5YBrQw?=
 =?us-ascii?Q?QjpY7VLb9tU+wGh6uUEgl6AjDY6yCoOt/oiZ5BJPPY9RG6y/+J9RLP3bkNh9?=
 =?us-ascii?Q?mLcLIjVzVlNm7ogWTAPV3GzC0hxlV1XJ8pKD5TCacDZZZ0hfcV1nCezJdGcG?=
 =?us-ascii?Q?Odp4zs1jv7JapW7PWi1yo+rhb7X3Zy99yEUXCg9N8VpCjUFlVisE6H15J3gp?=
 =?us-ascii?Q?RprY2Ar5lCseqWCh+TRKb7FGnNCeWH+RTAuyIZ3OdOLsOAGHltYXaTun1dlV?=
 =?us-ascii?Q?46uOu674wyS4jlE5BRqw4LyDk9qQQp98yWgj0sxuZa0qlb+aRfiSMoAELh/9?=
 =?us-ascii?Q?UHDqEJVheJ022u5i5EtMuVREQxOHGVJdJFXEtC0BuQtmTtW2t/xNEGnT5bwI?=
 =?us-ascii?Q?kjtw/J89PvwWV6hG5B5S5vifmEdbLeFY9ShYmGxh07uIaFGNYYgVsvq77kR4?=
 =?us-ascii?Q?zFhXQ7jooaNl3Rg255+DR64g5Xn4iyc8/AWs6LnFdq9sVCDq2vKGsN1k6WK1?=
 =?us-ascii?Q?yrd3SSOP/5kKxGQJALB8A7HHaKq4OR8JQAzt2RZrZiX7kK55L9oAti4alz4E?=
 =?us-ascii?Q?j5mWEANjBYm4UYnB0bLtDPTeIYcTc8SbwzPAuSw3XFBQHSICzFJWsyKySm9m?=
 =?us-ascii?Q?jK00JRko2/n5rpgpZUmM6gf1bRi0LcRGJeTD0B6xsl+cX4BKPXWs6UBhvEOD?=
 =?us-ascii?Q?JjAeOIZyhC30io3Thb7wVPv5p2cYC/xZXOKP0sNqusTaeB0BBQThz9R/1eMk?=
 =?us-ascii?Q?DWCF+/Lt+LEQCBJ+cbnbYFk7FE9hcAQMpjC+ijhO43Mcvc5M0y7kw6ujXaB5?=
 =?us-ascii?Q?e6cCgDZsRnEhRNMsF9c8MFALhCEptUj5IBlhAk8uV3c0ToEBi7yKnWswXj8h?=
 =?us-ascii?Q?42NE8OyhtCZCQRJocisBLOyS/D3iU15nAwisLjmk6JFTsQ7zBKdk8V6yjjWd?=
 =?us-ascii?Q?yldU184sVjhucSw49G3ueFv6WQhR8QgktiZKBBqnoKvyS6g/HLJnbOW9lLnd?=
 =?us-ascii?Q?Z2WbWkQsxtw+OuHJJ6P/q2LgJrqeflroZXXvFdee6e2/XEcPbZFUyB5cDMNN?=
 =?us-ascii?Q?MUPxU6ppK5yrOFC7fuBXNMZQA4934uJNp/TmRZVZ9vtaiCSh6MMJBNaNCZ/g?=
 =?us-ascii?Q?w3BKOJCTnDnOdmYQNexrmesrLKymNwedQaJVwX+ywk2zIx4EpwkJi0jU3V8T?=
 =?us-ascii?Q?i/+2dI4gu5bVRjgJrqEHXtG78RlG98kcZ6QsLTsotF9Wwog5TFUKBcxVia+e?=
 =?us-ascii?Q?0eNIM28j51fvetgVM7KDLdqhgGkudKvE2XXrBy6TBQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0WW20S/BMy0jZeVHWWflLt3nhFz7P+JOdvbMp84R+e15DWXh2UwXMcFLZbNM?=
 =?us-ascii?Q?3LUVfRSiILEa9YArPY6fcUn+wca5bpabSeBTfPrpo1pnR/94EZ1bMXjnlmOh?=
 =?us-ascii?Q?jdpKsslRptxhj94MlbqrJwpygHEYAln739RDsDr4q46SqoEol6ipNJ9Im+mP?=
 =?us-ascii?Q?vPBxeD0oTkBWqGK3z1L/5Wo4aosiBTiyK3FDFO/uvrPuA93NSF9NAS5LCMhT?=
 =?us-ascii?Q?t/LiXRQOzX3Ttkp3Hoqj0JQ+A0Rv+Boinonl/obadTC9YTq1XNDOUxfqvPxp?=
 =?us-ascii?Q?ZBcWGdyDMUR31hqjrgt7fqGFzFNyj9br4vYXfRcQZgGk85qTAZyTiwRdN5Pi?=
 =?us-ascii?Q?/RYqcqn9pBmwSwyC4tP5x7W47/CVDpNQr+2c/7vqtqGsvMEtb59yRI9EB/xw?=
 =?us-ascii?Q?dqiQ7HUbjmKfMzatiEE8C026ckAuTxbuCOqZiXdRIlXUEjblsDJn+HpBYgC+?=
 =?us-ascii?Q?jGA4iB7s6iSinyCsW/W0nOuN9KrOMrmntuYlt6EPospOPmJ53CPAQfUXByBC?=
 =?us-ascii?Q?iKEgBvoIujvPaIzOJUiE1pVLkMi9M2lKiEBVHNmi0devGTowLVF81erm8LeO?=
 =?us-ascii?Q?BkI+e4OMKTBIPB1jzw3ZBcV9LnNwBVmOo6yKj6X78pp8QAxX3d2Tlzpsex0u?=
 =?us-ascii?Q?MiDpP7epJkeyeAS6h4Ro+b7EFoPU7ZGqpWjDRiV/ulzxljdzuX7IEiwSWkgx?=
 =?us-ascii?Q?IRBqQ5vt9FvAb8XaVrfkQhYxFYGxocYyCkUQm6drBijGxHCWeWLaoqMF0tti?=
 =?us-ascii?Q?MviiFUr9DSfA0rfXjwxMYLk7BBnKJwFlawJFY6Y4WL/1cafUmSjC70lRgMh4?=
 =?us-ascii?Q?hh2Czc0BECFhpld/3AB5+M2yEbUsBLBc8DbtYQBjhfwYWzRkbLKN7mCatJF2?=
 =?us-ascii?Q?eroj+OQZUlAeSDEr9oIxNkRZRMTguZ72ZxSJnwyOrVfb2Xw//MeaOSApmG5b?=
 =?us-ascii?Q?FbmnfOWjv8yNTcZEmzdwEaoNJ7nSKlBf/4VFG/0sd/noPHkOHel5QX9QMz1D?=
 =?us-ascii?Q?9qNUznX7XWLvko027Pl99j+GK9WrwvrvSXqpwXaUXtWcVhYUiWArkJ/mQLGh?=
 =?us-ascii?Q?DFdPTM24Pi/WwUYLeixpFC05f6FHlZ/Mf54THI10rV6wcWnhYSdIPAPlw9gY?=
 =?us-ascii?Q?bH0oVN5TRrL2V1FL6kcqOiFW+XXBaOiUzAUQW8hEo5jKGTFT3x+zodykBVTG?=
 =?us-ascii?Q?zOBrx0IgXBk5FJK1ABJFR4huwkhW+eNLqhh83JJAsIMwSRvDdN/SgSD6GTVE?=
 =?us-ascii?Q?fKppnd8MbIQnMAPZ4F6Ufe3l2ddNVWJqcTgL96I8dzwU1ND3y6X+IHS1qtV2?=
 =?us-ascii?Q?IjWiq6TvCKWE0AY9J43j7n1IqyC5V1oS2pAbknZzBHbszxcbyRFEG8oUzmXc?=
 =?us-ascii?Q?V+3iEToWOLmHeXAfRbFxUzydsoa8Kk9u2Mt9fyBMG+QhiUo1yv80xYlxcq0T?=
 =?us-ascii?Q?iWhZ5v+AjtPfm4/IZZ6SqErJCrgF+xx6FoTh50q4x5mB/pvocQc13sxq6MHI?=
 =?us-ascii?Q?ZJNzUAku3vBb4vEkznSXozGSfvkMvGwoEFb4/S/9/9OZF6/++UB1rGGyncQH?=
 =?us-ascii?Q?BD4AQ0BvTAgUifmJX2b7P8qqNwN42eEZVQZeTR1Y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: becd2f3a-0daf-45ad-7fef-08dc7a25dcaa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 06:10:21.5704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/13L3ZSXRqxysvM8wBHtlqep44C30v8ceK2NJIFtn+OPQ3rPEoi1d/ohNe5rWXi51Wajg50q9Eo6MKQdwXO8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6423
X-OriginatorOrg: intel.com

On Tue, May 21, 2024 at 07:28:22PM -0700, Sean Christopherson wrote:
>Register KVM's cpuhp and syscore callback when enabling virtualization
>in hardware instead of registering the callbacks during initialization,
>and let the CPU up/down framework invoke the inner enable/disable
>functions.  Registering the callbacks during initialization makes things
>more complex than they need to be, as KVM needs to be very careful about
>handling races between enabling CPUs being onlined/offlined and hardware
>being enabled/disabled.
>
>Intel TDX support will require KVM to enable virtualization during KVM
>initialization, i.e. will add another wrinkle to things, at which point
>sorting out the potential races with kvm_usage_count would become even
>more complex.
>

>Use a dedicated mutex to guard kvm_usage_count, as taking kvm_lock outside
>cpu_hotplug_lock is disallowed.  Ideally, KVM would *always* take kvm_lock
>outside cpu_hotplug_lock, but KVM x86 takes kvm_lock in several notifiers
>that may be called under cpus_read_lock().  kvmclock_cpufreq_notifier() in
>particular has callchains that are infeasible to guarantee will never be
>called with cpu_hotplug_lock held.  And practically speaking, using a
>dedicated mutex is a non-issue as the cost is a few bytes for all of KVM.

Shouldn't this part go to a separate patch?

I think so because you post a lockdep splat which indicates the existing
locking order is problematic. So, using a dedicated mutex actually fixes
some bug and needs a "Fixes:" tag, so that it can be backported separately.

And Documentation/virt/kvm/locking.rst needs to be updated accordingly.

Actually, you are doing a partial revert to the commit:

  0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")

Perhaps you can handle this as a revert. After that, change the lock from
a raw_spinlock_t to a mutex.

