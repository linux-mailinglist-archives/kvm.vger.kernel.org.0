Return-Path: <kvm+bounces-50624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BC91AE7893
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71780179A81
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829B620B812;
	Wed, 25 Jun 2025 07:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PJIi+DNI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B913202C30;
	Wed, 25 Jun 2025 07:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836717; cv=fail; b=tx0/GfDLmqyDhnvg6C9BFjs6aNFpTxq7m4bD8qEHlXgkzhyzXhR9Zpt42qa/MLywSem0DBKjK2iV8sBUz46FjwIIRzpnRB8jAh8XPfmK5vaxBst++5NBG4J7p921gcAnN54zkm0057yy/H4is1TCPuSjw241Cxj6st5ZHSRbxNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836717; c=relaxed/simple;
	bh=WJ4iybtZILSnfse7H3S/aztz2TC8O//w/M8r3RdcR5g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aaA4PPC+zQFw+fmZsYJRPfKSy4usIOfTRI9zvxUYVTCItKNUEzbsJGpbfTLz4h5S5U3ltBBfZklH3nlR3eowV2h1+U3QxLfZs9JQeDsUZXSRVDDT2HKb0HtwxqRPVTdecpnHF2CWE4boTFPV9epAgb3gh8hi1SQ6VobTqnNYlEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PJIi+DNI; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750836715; x=1782372715;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=WJ4iybtZILSnfse7H3S/aztz2TC8O//w/M8r3RdcR5g=;
  b=PJIi+DNIfh4jicPWB1BY/DGkAqqpEQRfD6R0koDTgH7Vt42Ns7nYKhIJ
   ZT04e/OFxlXlr9Q8ZqVQ4ieFHFPUQJO8R+6gtCF7UX8OAyI26XX/w53x/
   BVec5Ef5jFpX0He9xL+uSToe8ba7BlgvD4NtwV1PWR2pyGJHPy9f1VTAD
   n73yjjcZYkpKe+2Xih7HBJticTjuMObVOXkUin8P8i4pRJQ+ZDkRQm8Aj
   H1ocFQMA9nDCZz+hNSalHrW8fa2WHrhyc4SUWk3lAHrONGjrWdiwQk2Qv
   tPzgLa99xs0EtxgVuwuPVpqj5uUGgmeigyMK3EQax2Bph5JUyVaVAKzFH
   g==;
X-CSE-ConnectionGUID: jaqdQ7McS4+O0KjALKtJSg==
X-CSE-MsgGUID: FL+xMDk6Twu0UrPk0HSj1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="78518517"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="78518517"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 00:31:54 -0700
X-CSE-ConnectionGUID: 7K291e9PTPOJiNx/5wuqww==
X-CSE-MsgGUID: Wl7vMCrQRA2haV7V3EeI0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="183173200"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 00:31:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 00:31:54 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 00:31:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.85)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 00:31:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqHaFeg9ZPagtMz0ebBw7j9vKgQSha/GiwWc6j6wzHIIS6RSZVx8cxJPgN2s+vQqle0rpXJaWeOJsh1me4icElThJAkSQs5EgZ+iiISlKyx980Jp6ULi5yj7AikFiVsvJFeB1FfayOOYxkYIf22HCyajOAqOCEuHy6JB2pRGxt/LSRJF0aaQdTN3k5DJX+9wrqs5aqo5vXcmN4t7r0UTDya2/I6M2mG+RNZneJFxVaxqR9D7HPHQuRBLeR8llV1jpJThDQUKztJ8u509tovqbbDDnA4wZainrqjHpPKX8BvUZzwpiajXOykVAI4XvTM9blPOgBplpN9mh/dQ2rlIJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lk4suN2Z7P3xtEb0PPUx+Ul2Hg7Gs0Q+v5x/OdQobhs=;
 b=t5MOhBJQzXfyNxB6Vlx7aLXfOLFcoS8SwYg8WoNTs8KSbB7VD8+w3rwrRvCyxle409OFVeryTlpzaRZ2MUQwSPWbj2CbS5lmyMmh7iQlaL+jOEcKQ06QmbqQwwLk2nkgsGU3BIBgBJnt2oPw1nvWs+35vzbEJVJzmTY6psk6DjCd0YVNiV5Oz0IQuDpPd87QiSlE2UhJz4TPvUfW2R/gTNflww8WDMwT2DjNroa9du1eo8+UsAcukPEJ8fuSCDAzuNT+maa2PzxT1+X3SbQVfsZFWtvYH4H+tpbx3ACWhbpk1SAQliJQLdyZYejW6aLFqtThCEOHz5M5KJCGpX4Tyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB5213.namprd11.prod.outlook.com (2603:10b6:a03:2da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 25 Jun
 2025 07:31:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 07:31:45 +0000
Date: Wed, 25 Jun 2025 15:29:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"Du, Fan" <fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFulSNMRd9kA9X+V@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
 <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a0a63e1-fc4c-48c8-8bcd-08ddb3ba56a1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?yRi10peDQSTUKF96eiT2Bkyp3KbSr8fIgxPFAwMHEZ+7TThH9a8rlHA+We?=
 =?iso-8859-1?Q?ljNRnXB3vIxznIvjUVD7pdvMM8DRRUepv7Z+MLwQw3HvSZdSLrTNuwkR3J?=
 =?iso-8859-1?Q?/ZZrnZZgrtfsm8QS3timPau+raAOIqLl7724bhnVgH7XyZEGKfVzEbh1to?=
 =?iso-8859-1?Q?dqxNJYaELNyGLuGnaMcdmn1pErvuCY76+yYBMdWjzvdde2yfMbU3KAgmyF?=
 =?iso-8859-1?Q?Jk/TpHpZ4s9q9Tt1CzqZ/+ijseOGlxTnPxGon+C1w3Vwtb3Gq5zDa9aRo9?=
 =?iso-8859-1?Q?4xoa8S/NoOPZ3c5Bb9oBCiS5y36/KLnO9rH9h4OSWiUreJCaiZRhIiHHe2?=
 =?iso-8859-1?Q?tUfPthitV94Jbh/USifL0f9AePzTcHbsLeX9wqf449TUXgSVFIXXOg14Kx?=
 =?iso-8859-1?Q?ONgNtdIbFedJgIoz4FVQBfcfqzGtreOp6Ta0bxNjZ58yRQWQ2mdbRNEiTe?=
 =?iso-8859-1?Q?WZM21PlTiS/S/kn7HJJJV4m8442H+FOc2S2My/r07FgK/6hl6DAJmqFIzI?=
 =?iso-8859-1?Q?xB3hSaRvT5rCqYZ7mX9XwhHiN+WH0sDCOOtD+eRj9U4/TGC+7Ip4UVpEfy?=
 =?iso-8859-1?Q?kKTX4s0BFBLN/EEq4qYrTBaiXSLoVOoNbdXX9IUOsUP7G4eo+xvzoj5t1Y?=
 =?iso-8859-1?Q?vHMpusvOcoybiCbNcqr2pials8OETLVGCrz2g7Tq7qTmj4+H9d0Pe0d++l?=
 =?iso-8859-1?Q?iIf5WcQUrw+aB3ht3hbZN6u2JrIB0HB+lZ1Mp75dm1VzXxiiCGDKnIetiJ?=
 =?iso-8859-1?Q?ddcsktm3NxHWBj7QORPAjVfFdfLOKohWhZPOjDdB4stbnB1onn3w0N3wE7?=
 =?iso-8859-1?Q?QlwzustKc1eXjV+OZ22uljHQLD7Rcc0uSWPWpZQWBr7hL0GR1k/XZxlQ1/?=
 =?iso-8859-1?Q?FJrja4Hj4wHtk9Ot3dxvYlUE+nVPlTt+9iUEenGP1cch0O3vLHMPRnNkJF?=
 =?iso-8859-1?Q?FKq5wvdetwhoYupuX/XVXEbGBuYbIMLBHzARyLPmy8xf/oawaCCo5KeOJF?=
 =?iso-8859-1?Q?1Z682hFKve5PEH5Xf90kct4+PtXFGxJeBQBuiHi0XzdeEIwlTnz+zdtCMN?=
 =?iso-8859-1?Q?MhLIShrncZXFpL9xoVB93dQZ7TNluEIIJk3QjQB8Vma8TIcRbJNndJmb3S?=
 =?iso-8859-1?Q?rxTb/xUMu12g9KRmf72grDWET6i4iw+djtk5RguCeV345CVDEozEZh6+yx?=
 =?iso-8859-1?Q?kZv8+/TDHu5r5guJ2gbY5jSo4or2Z2d5AHyBZlSAjSfeVpIZ4sPaYZq/W5?=
 =?iso-8859-1?Q?YT1gGXkRv7lOYWbQRLLIK3UJSuPHUbbNHoA3Oulu3HRmQVBLImeKel4fyu?=
 =?iso-8859-1?Q?/I92gsrgWl9MCgOHFpwxIZcGgT1vJ/ihCriPiOl1XZf/VeigYtZpygmcIH?=
 =?iso-8859-1?Q?U8RSKojFx0+TSF8K06fGYi1zG0a1XYnugQZ/6Q9wQcWqJaT/AA1m03rcVE?=
 =?iso-8859-1?Q?hhqMsVt0r0B7vGB1oeEFMI/npThOGjkGu9H0lFcwgqTGIKbVvVL0Rs8gX+?=
 =?iso-8859-1?Q?0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?npzegcS6huL7w6NzydvZ6Cg642dhqUdYc+YU99I2nb8uM5oCBvZpWAwlK1?=
 =?iso-8859-1?Q?sz5wwik3zxtEZd8qDb9wr5E1fOSbQHeylnbW7LJngXXQnyHhntk/0fGRzW?=
 =?iso-8859-1?Q?RD4mj+C8nP4PxsYahXpBlzhlUTcweY2K1jQC3z7+mJA4BObHFO6vKxLzdH?=
 =?iso-8859-1?Q?xboBqr73KD4G/Nklv5sQAArNFnpmQdheNz4WEHn6EY3uuxEQxQGoeMMnBS?=
 =?iso-8859-1?Q?o0P7a+tc7fjM11lkyRfmQ8NBErEEVg7hQTetKa3lHoT1DGfDzBgLXC7jKm?=
 =?iso-8859-1?Q?qZ6kG0ZCOAun9KiqPi/uA43wlDia7jLELgPOc7DC79js36AC/7vefqnhBZ?=
 =?iso-8859-1?Q?yyi50BReyEJllLDuTzJiyH8z5SoGl3Xl9UT2JWruCAcajVkq3rIDdsdb4G?=
 =?iso-8859-1?Q?aXUHkrb/lL86npDo7nSzQgNZot8MzYDB2Xc6CeEM7bfR2cTsrcb7L2G6lf?=
 =?iso-8859-1?Q?yBDAfjPvaLO13pUtlbxzXEWWel3Y20Cn7j1ue86vnRayyhh8Af8bGS+wKH?=
 =?iso-8859-1?Q?JSZDBnaiiEwGww3cx5vcp6a0yOahX/BovSfU007tCIsqonn08HQC0baEx4?=
 =?iso-8859-1?Q?uUPQL8Yx8YTvY6451zvau7100LxyuUbwU60yVHVbkYSYJ4vfvemqbiLG6Y?=
 =?iso-8859-1?Q?yvHO798LCJGQuDSRLdvZfx04KyHnlDHqm+XeWNh4h4/fZIhkoxdl0vKxBE?=
 =?iso-8859-1?Q?sai8vPRdwLQa9KJYEjN4UWtminV5qxzx2e+r91Zfyec+q1nGyISDTVTxo1?=
 =?iso-8859-1?Q?HFnJigrBCIhKeDDuwgcVy19+HUY4Nh9HNoEbsvSPQ0LCKtPH3QUi7QDETF?=
 =?iso-8859-1?Q?oNfVlGWGwASpOEECtgrQnZPds0FRu/9fh+DHeg4ngcNQg/n0EgdLUe+Lyw?=
 =?iso-8859-1?Q?ggex1gAdMAKybyl9/qcIoW/fDgDnWqOLSCdYJw8JdZ7xvMzPlF51laZg+Y?=
 =?iso-8859-1?Q?1QuY7JJQvftcXgu0WDK9TXHx8x+mtY4DK8JacQBuE9glOiCctyvsSkFHtn?=
 =?iso-8859-1?Q?kKs+/5TfX9E2EfL+TtcU7h9dxG3Pl4J+F/X6PkpOG7v5MdQqb98/RPTRdA?=
 =?iso-8859-1?Q?aQArgV22cIueRCpxBf7XD5ffDTSV8ywQp+4GlKWhjV5H+emNIWlP6zx+a0?=
 =?iso-8859-1?Q?shbZ23yNATBXtdNXXCt3In+dHTbtfxn4s93SpHuHHSoio+XcklW750jL0p?=
 =?iso-8859-1?Q?mS4VnOagEOCkW+7pYL9nV8GFaIRoCmUGpI/a/Ohcgwmxeguje0NgiIR5uw?=
 =?iso-8859-1?Q?piDPSPbMDWhW0MSefsrgehVOIAlyiPD9Wkjl9off2KOve3VoH7NIXh52cp?=
 =?iso-8859-1?Q?T1FxbTDi4bM+kzafdT+Vhk1GxCWVYEUISQIOVLtxfUmu2ML+3Srzl8BySV?=
 =?iso-8859-1?Q?dK/nr+Vp0cU/Cv6bSMXxjXNA5m+bSVCimtJluQEbPPman4qLN+N9KxE3sK?=
 =?iso-8859-1?Q?NxrJO34Dpfu1Y7oO1iljBYzV25xIvywTu6zmc4nwXBpEV5Xqh/Q/7+/QWY?=
 =?iso-8859-1?Q?fJRcimdxhnB0InvwczBJNALDMojAW4uDGqQR5rq9mInSk92zQSFKp86Bc0?=
 =?iso-8859-1?Q?9aE5FTwhfWQ44WV5k79mMt2jYt2ooobsmv4iFcUOhXTTKGalOQzQ+n4Skb?=
 =?iso-8859-1?Q?mqFt3trgIPKjI+bEAD5b+k/X46jmZ2pQfU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0a63e1-fc4c-48c8-8bcd-08ddb3ba56a1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:31:45.7403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1KUW9MtW3WOo4sMyeJTG0cMvlKaSigtxEEs5gsT0tnA2Ubt42snooHX2Ai7Tva3f124RtxibfRFAgnagjlWNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5213
X-OriginatorOrg: intel.com

On Wed, Jun 25, 2025 at 08:01:41AM +0800, Edgecombe, Rick P wrote:
> > > > So I think we're all in support of indicating unmapping/splitting issues
> > > > without returning anything from unmap(), and the discussed options are
> > > > 
> > > > a. Refcounts: won't work - mostly discussed in this (sub-)thread
> > > >    [3]. Using refcounts makes it impossible to distinguish between
> > > >    transient refcounts and refcounts due to errors.
> > > > 
> > > > b. Page flags: won't work with/can't benefit from HVO.
> > > 
> > > As above, this was for the purpose of catching bugs, not for guestmemfd to
> > > logically depend on it.
> > > 
> > > > 
> > > > Suggestions still in the running:
> > > > 
> > > > c. Folio flags are not precise enough to indicate which page actually
> > > >    had an error, but this could be sufficient if we're willing to just
> > > >    waste the rest of the huge page on unmapping error.
> > > 
> > > For a scenario of TDX module bug, it seems ok to me.
> > > 
> > > > 
> > > > d. Folio flags with folio splitting on error. This means that on
> > > >    unmapping/Secure EPT PTE splitting error, we have to split the
> > > >    (larger than 4K) folio to 4K, and then set a flag on the split folio.
> > > > 
> > > >    The issue I see with this is that splitting pages with HVO applied
> > > >    means doing allocations, and in an error scenario there may not be
> > > >    memory left to split the pages.
> > > > 
> > > > e. Some other data structure in guest_memfd, say, a linked list, and a
> > > >    function like kvm_gmem_add_error_pfn(struct page *page) that would
> > > >    look up the guest_memfd inode from the page and add the page's pfn to
> > > >    the linked list.
> > > > 
> > > >    Everywhere in guest_memfd that does unmapping/splitting would then
> > > >    check this linked list to see if the unmapping/splitting
> > > >    succeeded.
> > > > 
> > > >    Everywhere in guest_memfd that allocates pages will also check this
> > > >    linked list to make sure the pages are functional.
> > > > 
> > > >    When guest_memfd truncates, if the page being truncated is on the
> > > >    list, retain the refcount on the page and leak that page.
> > > 
> > > I think this is a fine option.
> > > 
> > > > 
> > > > f. Combination of c and e, something similar to HugeTLB's
> > > >    folio_set_hugetlb_hwpoison(), which sets a flag AND adds the pages in
> > > >    trouble to a linked list on the folio.
> > > > 
> > > > g. Like f, but basically treat an unmapping error as hardware poisoning.
> > > > 
> > > > I'm kind of inclined towards g, to just treat unmapping errors as
> > > > HWPOISON and buying into all the HWPOISON handling requirements. What do
> > > > yall think? Can a TDX unmapping error be considered as memory poisoning?
> > > 
> > > What does HWPOISON bring over refcounting the page/folio so that it never
> > > returns to the page allocator?
... 
> I do think that these threads have gone on far too long. It's probably about
> time to move forward with something even if it's just to have something to
> discuss that doesn't require footnoting so many lore links. So how about we move
> forward with option e as a next step. Does that sound good Yan?
I'm ok with e if allocation of memory for the linked list is not a problem.
Otherwise, I feel that a simpler solution would be to set a folio flag when an
unmapping error occurs.

guest_memfd needs to check this folio flag before the actual conversion and
in kvm_gmem_free_folio().


