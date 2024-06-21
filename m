Return-Path: <kvm+bounces-20195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEC79117CD
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 02:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F9D8B223E8
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 00:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA0A04411;
	Fri, 21 Jun 2024 00:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mwtpDLmF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4199FEA4;
	Fri, 21 Jun 2024 00:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718931220; cv=fail; b=tcPKsdppzW+qDvYKVE12xWSb05DvHHLa+svQD1xrzB9l4EVAzwwVz4LdGMtPgU9jwMQ+k2FH3anEv5bTa0TsXmhRvhItdeot9lmezNBPKwu3BqlN1riN+sLbXwJ6Z05MGJQFMh6eObM+yFcuWTomR/lw4GYEBttpgPV91afddCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718931220; c=relaxed/simple;
	bh=aw01KqgeTGuYl00oxduHa+Ev4pvHgFN8aKKh4LKdyKM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SoWk5OULB+dgtUBNwwrS6Skb9Bh6s1cKxfOFFPwY/2TnE4sgCTMgNw385meH+j7C65SO95z4sIeUn9LE16AUbZL/TJCjfhKGxDsEET5lSCKFc3hU8KKLfCeYD/KdxtkY0vCRImozmh+Ct007a9nb3c6ZEvlpRBxNoP4LGiKA9UA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mwtpDLmF; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718931219; x=1750467219;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=aw01KqgeTGuYl00oxduHa+Ev4pvHgFN8aKKh4LKdyKM=;
  b=mwtpDLmFHbig/WlbVCW6sofK3lau/yEieBNSJnf1ykfOf8/8+LcEq507
   UMZ9Jyvj/0x/QkeQ7PRgYQ9ov+30RNC4HoK7fzCZLCLNktAWovEmHZIml
   sveVlg5TYOjARZG3Y+QfmEX48Nai4Cgkp4z1m2bbOgogpa8yJ+9yjUq2v
   QFvnJ4j+e/LJcWP1dyckz1l0gOJglLTkFTuJS+Lj6KC+68zQMIgijml++
   Azn7E/WJ4OBWZApefarYN6AD8BjWOczAUOecaWzH8VHhISt0o5luBz3ue
   n9tnYAK4iYJhG6IB5AMm7iYSxoQLhKO8Dk63exGNuSAuNNkf+v0NZcW6Q
   w==;
X-CSE-ConnectionGUID: LGopir/lSAqiQIRX6g7Udg==
X-CSE-MsgGUID: eaAIsjK0RtqQvXIouTvbCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="27369010"
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="27369010"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 17:53:38 -0700
X-CSE-ConnectionGUID: EgaUBaOLSyqanqTUp2c/PA==
X-CSE-MsgGUID: uzHPnrs4TyOB+FPiUxCYGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="42333693"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 17:53:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 17:53:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 17:53:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 17:53:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jv/Hbo6rLJf3Wg8E4HrmFazeXBY8og57Kt2L9Fc6FtCfHJkep+NL5023Cft5hTT5xtNM9zZzT7RnxQd2kic0vz0bcEMVDdwK7u218h6HPXJRTMZ7p565yxUW7SelVAu6QkaHvGkG5Urz1Uhqb1KxtI9DmFsQVCc66f+IbZ5aqAIrN17vEY+kXuJaWCUaGMz55+IQFpc1rL7deZficHPuKFMJKwbCyEJGhcu+SCZcxEktwA4kJhXYazvLT6gKOuWGrla2OmzHmChuni/XYFdT+/FnpDUPWwR1cnnaP3gPExcJQNq1dEuFd29ptZ3frgDMiNqplnq0EkUEf/4NtjkmlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWlYe8StAhOp/72BmT9dSUNyraz4cFT986ihcSfAUlA=;
 b=gMdZPHvMrhYNg72c1BsjFx41MaJ5luR4BxeqIUfD5dMEx52Rb0f/ku/bv364+eKKYpGyDaHLB9H5OrBGqE2zmGbMFCVVJymX6WambOf59ljLgk9xZWDHi4abnfnnLZiA5d9h4WFJCXxIOC8dOHeTEx7k40z3qr9nVNB7dUKlFdX/pvHxfkcIRjQWXurB6A+a98jsqLdHgPo0WptuQnMU05I/ETN2SpiKFeBEPZ2+s3XLWuXtYj9hJRRxXnKA+k+vi/P1toCUBF6jbbpHNrhSmU7K77xlAja9dJ4CFC8lFie/Sqg83D0wPPQ8Jwre1SthpPrGy3d0HsXWZlHzZ6k4NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6262.namprd11.prod.outlook.com (2603:10b6:8:a7::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.33; Fri, 21 Jun 2024 00:53:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7677.030; Fri, 21 Jun 2024
 00:53:36 +0000
Date: Fri, 21 Jun 2024 08:52:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>, <kvm@vger.kernel.org>,
	<rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kevin Tian
	<kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>
Subject: Re: [PATCH 4/5] KVM: x86: Ensure a full memory barrier is emitted in
 the VM-Exit path
Message-ID: <ZnTOyyl6dfzFV+yS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-5-seanjc@google.com>
 <45dade46-c45f-47f0-bfae-ae526d02651a@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <45dade46-c45f-47f0-bfae-ae526d02651a@redhat.com>
X-ClientProxiedBy: SI2PR06CA0015.apcprd06.prod.outlook.com
 (2603:1096:4:186::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: 21b910d3-5b7d-43bb-8074-08dc918c9508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4R12DSi/4aAPM5P6barK9/XVaYglVnZIMokE5TtEEpURF6AF493CLOhcECZh?=
 =?us-ascii?Q?xHlE5CZzWU5vrhd4dPPcT/Io31ebTlK+vejHJfVVY8FZ/aVV9zB9sK8QFrpl?=
 =?us-ascii?Q?GjIAtHZuX9T3lBYkVlh0JWCO58xyPMtfD1uFz50aEmfk553pZnhiuIs0Lb0r?=
 =?us-ascii?Q?AjmDDDr0CdrJokVt8NIbo36oqx4aDEKY+4X4yEp7isnV6/NQxCijjSE95sQz?=
 =?us-ascii?Q?SF5aFATLy/WOhzxVblvm8zImyzz1EvZua3zIAe35xWotovN6RNqZrUqTLn0D?=
 =?us-ascii?Q?oJ1IkQ5QDIp4ouY5+dzmRpGSTjO+shpe4E6goEFNICmYl1u7+weezRwRUTxD?=
 =?us-ascii?Q?FO4bf7NDD1SjREpond/nn1nnBze/u/2I+dK+pQEZGo7o5Vv2VVNkoPiVTUY+?=
 =?us-ascii?Q?LRO0G+af8aKw8aIEN/7ch0Oal3zp1mnubat9FxkR55/uvdwVXlWTo0AZr4Tm?=
 =?us-ascii?Q?YJxwNdWIPDkjEI1MUYtW0zJph9cqHJbk2v4Tyzpb5DeTakZZ3y2K/Qr2F7I1?=
 =?us-ascii?Q?V9ikmxef+/lsp2tgMqB5/fGyUV+ULqjEFEV6VnkvLJVtKXrIWluAvsej59Tl?=
 =?us-ascii?Q?67VmPPo8pquAZiI5WP0Ey3f2N7VKCRy0OGZHFKMfRUOx6wcAM8AQIT7Bffse?=
 =?us-ascii?Q?mNNSu+K9emHFh6Hj6SpOX+riuojExnVXykB+AaWbEEK4dqWpUC1UyBSPqhWF?=
 =?us-ascii?Q?Ae7xBiQrriKDFDXAqMCJgG/ZCQiidz/qgBCyRLi2u8yXr2NIj3K7jU9R9q6+?=
 =?us-ascii?Q?ruXD7zpTRNiwVQcyBNEDCdgzVjKY9tuzF2MX2ohk1IC7MES2SxFTFRxdPMCY?=
 =?us-ascii?Q?8o38DB+9EDtU+XfVoQBO0H7iPHjCe7mmA1i2vE7KaK0KxMzdXVlKS0JF/JQP?=
 =?us-ascii?Q?V9zeRte7wVT906Pm55Yws+VjJFscNbxBae5cB47/bN9ekuSx2u7izJOl9ucB?=
 =?us-ascii?Q?142NM01RaDSJgoJ2yfNaJuHPs1aGNoYQHj5gU/h10nvvBPRUPS58U0pZOfqT?=
 =?us-ascii?Q?UPgi2sCIuzlnJBck/nXozj47+h/LeFGu/xtKfJfAi+YbRzlbY1mBgc6ws76d?=
 =?us-ascii?Q?vlLoiEcUocC/jegCHMt1PMxW1tbu0MGU0OCXs6yfe8mFCNZ4Z/grOqD9zp80?=
 =?us-ascii?Q?76SHfWAXJyp5UmWk8ANDgnJpJTFPhrYRzosGdMX6PYJ4bMXgJF5wt0TfTHHi?=
 =?us-ascii?Q?b0w/VygU0Z7frY8+aQeMft+6mkc7NvEwf9uIspxwDIF2JZxFlj5G3ZBVHAQF?=
 =?us-ascii?Q?TH3LDkttSya0p+tLp+Vo3pIwy3cg4jCNZlZOS2G65twbRH0ldrYAeRMfyno7?=
 =?us-ascii?Q?LyIulN84Q0IVZMkJZw4aM20V?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OZsmRAGdFqLzfQgKgAaZcTuxKrtPX/uNk4SUYwHp4hyLU2YP6R21+XmzLfaJ?=
 =?us-ascii?Q?Tjcgk42kCS8lakmylRrvpJt9skD26Ab5bDzM7RFVyQIN+bYidNWwNSA9oDSg?=
 =?us-ascii?Q?1MnIrfCyxlEzu53GI6XlNNIZ9IQCVrABDDlcHN/X7gWtFdFfyx88rfbhtjY6?=
 =?us-ascii?Q?rHYHECWqtOTMMKeM483vFxg3H1oadXcEkfTGLiu4vg6wjBaAHXPQ3PysXHbK?=
 =?us-ascii?Q?fF1zYGuhflTuObaqv9j78cHecRvhJd26Vp8VkhWQ/wk0zQ0gzGqmFVDCEPNy?=
 =?us-ascii?Q?f/R+WLF7EyXqZYQxZAaOEHEYRMwbURKGNcGfEAOoS5s5xQI+KNSnR7C4Mlha?=
 =?us-ascii?Q?G5Y7w59cud4oT6PHACs47/UBzrDsAINJXKJzlgBkcWCpXbuMFAL53VI2gQFW?=
 =?us-ascii?Q?qanrzsbJrhC1Hsw3JoDgmHLX70CUKPuAZnZHdWK0lZI5s6EqhnvtNNI7n0Iu?=
 =?us-ascii?Q?PuNU0Rixma+8zMy5j08ivwClZ1DQdxWD1qpa1QHuT/6CsEh0XQUScPobL+7i?=
 =?us-ascii?Q?FDoHgOmnVOfm0Cz2V+3g+rOFG9AfkqtxiUILuloFkIAUIvR7a2IOo+xZQaqy?=
 =?us-ascii?Q?NlNZYbhhC3HO/JTNK/2os90zF4L32M/oWPHuHXiddYNc8cDjJfuRNUDQcvf6?=
 =?us-ascii?Q?K944yZa/50ZD9YZvX9wOJNqovoMPq3l64v6VG/GnWe2FFJ+lBTFuYt/fOHTM?=
 =?us-ascii?Q?yYONk1kKwglIWoj6wv7iVc31yYY2xNTmwg6dU2zvd/GjxVlP02LgUkPsRCrA?=
 =?us-ascii?Q?CHodeDTMXIsJYVtJtgeU9cPOX94UhTKugk9GsTalb8ypo0W5BTv8K0BPIIjh?=
 =?us-ascii?Q?mhdWkPkJUULT06mLhg72zCwlAzmJUaMXn5IsESo0rQhrcwEk7e7676VsenyN?=
 =?us-ascii?Q?JDQQm75svfT3G7C++D3rbX6wxIMK2MfjKHNEdv4RSek/7IMg0Whk4qTNJ2c8?=
 =?us-ascii?Q?wFD7WJsjnw+MRgZQdI0j7XhWQR5MCz/qZzdCz4VQ0SzTUiSkqrlFZbqEkBnT?=
 =?us-ascii?Q?WzQaryFJAGFvzRQrXKFqin2ZeRzx4Udjat+njho6vwP22Js/vD7wbcFuBzHz?=
 =?us-ascii?Q?BhFvX/S2Da0fjgcbcz4ZfDrYkO298XUyY6M3AeF/azD/cN6jIXFycvRQIaWk?=
 =?us-ascii?Q?BYSbvRNCs779cT20p5CGMnSGvQEIX832DRN0KyisYrsQu+BJlV+OqouwEMmn?=
 =?us-ascii?Q?prb+AVIpQPWd6PwQiuoMESvznxkMzzylf7g0iGnsAv5HcBxAwwmuUGXreeJe?=
 =?us-ascii?Q?+azjQTLyzudj34RBLReXl/BYTivYW6IiBy3z7N+b6x9QOhGhJbzmwTDCEBlz?=
 =?us-ascii?Q?EZ3WpbUT2GopcDNkpa9qoTewddaxkCPypLfXU1p2eTdnYb0Isa5U7wwEev7b?=
 =?us-ascii?Q?bndZLktWWMQ9Z1T3KU0n4Kgr2zw9SjvhK88ULD4/6P3+qe8JnG1RevH+lGAM?=
 =?us-ascii?Q?cRewGTBVAOdkBUFNMlegfpOAYTSWa6F79We9pzDizvoZF0uD3NUFFAk8NzMo?=
 =?us-ascii?Q?lgRNILhaQKZUAhymezkbGSqklb24vUd/96zwysPJF4MtTQ3gUj7sPPVgVfyK?=
 =?us-ascii?Q?ZuOvpVCQWdsJwetdoroIBRHRMLjcfKhbP7XpVuie?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b910d3-5b7d-43bb-8074-08dc918c9508
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 00:53:36.2617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+cxJ6dhrDsYBwwmEnjpAxoLVK3OsFSEmqU1O+8O+EYw3tPRkTo1NWSxfFgnkWGmRwamVpOF+JVy6G/zoAB44g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6262
X-OriginatorOrg: intel.com

On Fri, Jun 21, 2024 at 12:38:21AM +0200, Paolo Bonzini wrote:
> On 3/9/24 02:09, Sean Christopherson wrote:
> > From: Yan Zhao <yan.y.zhao@intel.com>
> > 
> > Ensure a full memory barrier is emitted in the VM-Exit path, as a full
> > barrier is required on Intel CPUs to evict WC buffers.  This will allow
> > unconditionally honoring guest PAT on Intel CPUs that support self-snoop.
> > 
> > As srcu_read_lock() is always called in the VM-Exit path and it internally
> > has a smp_mb(), call smp_mb__after_srcu_read_lock() to avoid adding a
> > second fence and make sure smp_mb() is called without dependency on
> > implementation details of srcu_read_lock().
> 
> Do you really need mfence or is a locked operation enough?  mfence is mb(),
> not smp_mb().
> 
A locked operation should be enough, since the barrier here is to evict
partially filled WC buffers.

"
If the WC buffer is partially filled, the writes may be delayed until the next
occurrence of a serializing event; such as an SFENCE or MFENCE instruction,
CPUID or other serializing instruction, a read or write to uncached memory, an
interrupt occurrence, or an execution of a LOCK instruction (including one with
an XACQUIRE or XRELEASE prefix).
"

> 
> > +	/*
> > +	 * Call this to ensure WC buffers in guest are evicted after each VM
> > +	 * Exit, so that the evicted WC writes can be snooped across all cpus
> > +	 */
> > +	smp_mb__after_srcu_read_lock();
> 

