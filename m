Return-Path: <kvm+bounces-26944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50FD0979639
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 11:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 688F9B22130
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 09:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A8E1C3F36;
	Sun, 15 Sep 2024 09:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HytSJJSj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6344A17579;
	Sun, 15 Sep 2024 09:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726394155; cv=fail; b=bzPQfdlScD6PIpBgYaNp1IKco1FFBC92ekqVBIYafotXHSCrmVrM1aK/2ysDni5jBqJXGRluKxCV0pRBMQTpHJ7RoA3JhxonfKOrR1OoEtvBgkUS93fV5pod4DkSOWMOnrk7lYJ4T9Vo7YhRmBJGh5sNIFeGqUE04xl+8IVvam8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726394155; c=relaxed/simple;
	bh=1OzUl33zPsek2S972AV6zZ3htvx9zzQUCdcRIz9Fls8=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r4NOH3Nj2Le9tZWoBc8ImhEnn/viisovwu0lLBSvGEpsMLFPZMae/tM2eG0+TZmgF6+Lbid3wUY2/k6ibmqAFCFKwbZw+G/fBu2okRCG+zsOZISOfVHVB2M7lx4NkQhWyzFpJlP4/jbj3gXOXpgqQtuDYm2RBK5h5LBdEpNEIIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HytSJJSj; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726394154; x=1757930154;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=1OzUl33zPsek2S972AV6zZ3htvx9zzQUCdcRIz9Fls8=;
  b=HytSJJSjTRR6/JJth15IBki68WRgsLxlINAd5qlwBHUrbDXfYFoqJJEc
   3mbC5JguKENvBAQ0CPIpJSUfLy3dHRYrBhA8zrsWXnMrBK97KBvnOhLKk
   /ykeD9Lp6io14z2KyoIn8dwtchIDcjyr5NV3N/B/tRbsiE7mJTiSn7woS
   KOtX5y/nUNF9L8ayVwiQDy9w/YKLiv6Cm/pj/1hxO1yZN0xjldqYhsVt+
   SEwbRY3vIzFbsSKwbvJVstpcL1aEFfOu8HjWtaHB5HOIabs1vasWac6a4
   Tdd4zGNuwACR2SYF5UQDMgEZn9Ccn5LJf++ydCF6HVlDsSXpRyioMxMw6
   w==;
X-CSE-ConnectionGUID: QRqIdqCLSUqM9p/E7DwQMA==
X-CSE-MsgGUID: 4ia2r28CSF6aNvUo0hJKVA==
X-IronPort-AV: E=McAfee;i="6700,10204,11195"; a="25403696"
X-IronPort-AV: E=Sophos;i="6.10,230,1719903600"; 
   d="scan'208";a="25403696"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2024 02:55:53 -0700
X-CSE-ConnectionGUID: gTTOAi1KQfKnmGqyNlassw==
X-CSE-MsgGUID: rjQaLbngRHair8QVl/RYig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,230,1719903600"; 
   d="scan'208";a="91869894"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Sep 2024 02:55:53 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 15 Sep 2024 02:55:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 15 Sep 2024 02:55:52 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 15 Sep 2024 02:55:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qUeaayTIksGNlmLmZI63WO1vc5v0ygR6S3YjLeHgkA81lp76W03PwjqrCHYLauzrXp5/wfNwkT6Yre9chIR4TGML7QvYjfhnD+NGIgVf1X4sD6ZicgA7rqWy30VruGq+tW1xLf+ODNjgbGt9CQsZESN+ZVV9JGHa9Ig47HU2wHix8JTVCtuDOBV8tEnwILhGdgf8FmBVWg3fkjR8KudwbXxxdM9CzJKsA7K8zKTAPOVhh7mZnj290KBF1uO9Wr1+92lxczoNY3bqv4YE9R4BjZ90Va6L/tsY8j0UqWyOjCAs+tnRl2Mtt48KySX5DVOoVuSePP7g50tg+IA1befzlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v82pXIDFfkXEdpAmrddlIhB63jCQp0LhAaw9Su86uKo=;
 b=sg2ILg+0i6GtPFNy5Hfo0KApkUrSPW9Avz2EFe5IP5s4Q1A495kwz30XCDCE3cXuNaWwQw35w+p7kmIXq8Doe7AxFgqr8FKYr65lX8+OBVWmmsNrUOtTmTs1u7yz/EdNZDk7FwcKDA7j45VSLRK2wc4BNTVE6pCFcgqrU4TYj8ftXy2/Je/I4pJjsEk62By2gGiWxZDFXsAR8bNo/JK/lLFBeNrVONMWlkDqdXiiio/VM7irSkOWAYese/tzELkAxKxR8PTF2CJPRpGVA9c6iu8SG+eEDLC+fB9YFj+pjdP1EHs/lpmaU/oLrxiWz9JpFAbRvnBx2jJkZelF0Rvptw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7050.namprd11.prod.outlook.com (2603:10b6:510:20d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Sun, 15 Sep
 2024 09:55:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7962.021; Sun, 15 Sep 2024
 09:55:49 +0000
Date: Sun, 15 Sep 2024 17:53:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	Yuan Yao <yuan.yao@intel.com>, Kai Huang <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Message-ID: <ZuaurXwXUyEjP9WJ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <Zt9kmVe1nkjVjoEg@google.com>
 <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com>
 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com>
 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com>
 <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com>
 <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:194::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7050:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c7f03ec-9a9a-4aeb-c566-08dcd56c93c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cLj48Rr6LQF8dNr6F/o0F4qdv53ldv6YS0//jP9TgitGjnktbE6XavrewPk5?=
 =?us-ascii?Q?ZPTFuD1UGrjXeyBy09Z8En+N+yitFLUpkPohFvailXYy88z55bmo+FRyYiuG?=
 =?us-ascii?Q?CC7bKuyPtzg3zddsrrl50WeBKWYBo2fjoyXEew9pXgy43XdcZPYWtKkuQmOq?=
 =?us-ascii?Q?8e45UE1QhR9jlKuOqrGrQDSqrPlR4youdBXOX58vL24ha1ye0rTN6o7/Wt0L?=
 =?us-ascii?Q?yr9crh04dTiqKg+hGAmnWJzbHy3P2B421L6nHulxsep3hvabOwxXFaiwesiz?=
 =?us-ascii?Q?n53+nMsvhrnZl1+qvmXsFNnmFjPsS2LFEjlK07CiQCbXDi5N1+99haXc+jxB?=
 =?us-ascii?Q?a4LBMwiQlScdgm6Sf/rwEbe76JgcmCaG73JdGkCUA60Fm+NqiKm7V1r3xo5I?=
 =?us-ascii?Q?EqhSUcFdp2dn7Ul3F7rATTzM7Aj3cqC/thl34LB1aA/xljm4dNpN8j1SUwwW?=
 =?us-ascii?Q?OUsgZAAVew0rejegOFwoXv5c892IqzidTZ7G64qUs8CBNaS1Y8B/2o2BOfU1?=
 =?us-ascii?Q?w6dYHDBzcWzAbq/yOioPE/BB0RXPocsAI7fEgVR/Vdptm6yAXXMd1ti6+cs9?=
 =?us-ascii?Q?5KibH0YwxF4nWwymMBoCwQaLQ1eYSK0nJtWK/va5YAZah5yDIl+r6Brqfh+J?=
 =?us-ascii?Q?sOPc1m98XA9xW/+veBT9jZR0LA/YTd3K2eWqSTYa6eZxN0DW4VO765I1CKL4?=
 =?us-ascii?Q?l6ft6fY5DpQlgSEefM69MNDoRYgjPPIN4LONnDfW2bv16rhgLQjM2yVbJVws?=
 =?us-ascii?Q?aH8f54RJppL4upeEVQHtS2uMb7Av5SM+yON0/TDV7tIJ0bVfMETE8XoWPr0I?=
 =?us-ascii?Q?NVvpVw3XmAGJHnAWWqZ0uacCu7o6fpUNbI6swzsodlkMjrUWe53GODyANJZg?=
 =?us-ascii?Q?O7npntwo+Bm9YoyoJDVqTNOhgCACgELwveCl0Ruu9La464iEy0tQkkwGI7Hp?=
 =?us-ascii?Q?W97i70kJuOQfZEla44xApAIiRglDVK2XGb4nC49K/RqmNMZ5+k9kYK3p5AT+?=
 =?us-ascii?Q?IiinBdquY4jFYrWWB8GWerYh7CbJlC6wi36mL/tfMvK/j4dTydVZKN9bhkRD?=
 =?us-ascii?Q?cxM8b00UwjkP+IP067Ebt/80jdDwcwJLGf3SaHn9r1y6J74ad580a2a3spi9?=
 =?us-ascii?Q?z0FXLBW2PTph3uCZWa/PhJuEs51BQSsTcrsg9/QuBIcVgP1EvIZsmNiAgbhn?=
 =?us-ascii?Q?vlqIfwSgZdpswIqqu6Lu8Ns0ih1RGZmsNOxw2odb7pvoL9IydX1gJrdnjYkq?=
 =?us-ascii?Q?zQuB3GeHpOybu0hR7KfdrerVF0fxo0WmTwXnePik9u9+oGymmPagBn4hSHDS?=
 =?us-ascii?Q?+p6VYb7d0EXPvz84fvd+aH7TBFEYRivFwbYX3XCso7QjG7imLRFP9tlLs4Lh?=
 =?us-ascii?Q?L4YE0EeqMIOsMkM9Rc9xAecP1ZsX?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E7XtFCyC3CHijqM6rd4N4wyVJ7od0oba2PslRLKRXTB1Ejqh66/BOTz1p27C?=
 =?us-ascii?Q?gWP1SJVlawKtrEDm7C6eMlerGZNNzz0zncntJ5BJrdGchIgQ5JHkhngt74I8?=
 =?us-ascii?Q?JD/vGimEs/mA3wOLORM3uzPUFpRB5h8hAAHkgrtDgDN+azjf3upOnO9vg51x?=
 =?us-ascii?Q?hFowemLyvFBtoIgaGOsoy1ByomHM2ZB55hxXbTXOZ/lxa/u8k0B/UR5zeslI?=
 =?us-ascii?Q?R2BSH89Ko2/wIdVPF2+7dGbUmt12YkvXZCTTWCH5WCCS+4CNzNQmCb13k4eY?=
 =?us-ascii?Q?q5CkQ3wWHu2n+17jyuRRreIY9dAa/141doC/q/DArwVK1E+PiU6t9BD3EFFI?=
 =?us-ascii?Q?qXftyVEfsifpCCXb/Mqw67H2kQCfxiqGHN3JY8BoJ85bAlfDljO7OwKNnFJc?=
 =?us-ascii?Q?kNMWIZ2Qm0ChaDnyVyahO8pTVlQwrKz2e3gibe7Lxpt7jslqnYbleVgOCNh+?=
 =?us-ascii?Q?70+HmuOdhGOlEXcKSAebr5uLaHUa+TVKZ482vcELPf9xhs1UOyyQS7dpN2TL?=
 =?us-ascii?Q?Cephq64MCmZT0f/kgcmQO8Hm7/EhXWSgtvgdHmDCvuk1Ai69cg8po0+A1m4h?=
 =?us-ascii?Q?RuREdQzqkY+qkqIOBJbmY80hMqpoTNP+7PZ5rpKABMp/diuElshvQd97V4im?=
 =?us-ascii?Q?8Ve+CjyB51tiSa5XC2m/AREMpgiGZ3Ch4rplpYk6+KpUNc7by82hiKrm/xMj?=
 =?us-ascii?Q?92c5uMW55ouZzbwcV82SngWAzz7me0N8kgDGfy5KwNuDJfaolq2uTUmMi4dc?=
 =?us-ascii?Q?iWCCsyUvIeCz7skEzZCjLzaxlAF0PjkkWkZSDm6WSAfjH4WKVbEDAGO6JUwY?=
 =?us-ascii?Q?+MdBJYOKppaiJDhbL7l2/Mm2XhiLh7+dyK25TEdJQpQms48Yte8/RSni7/V1?=
 =?us-ascii?Q?BvBcwTrX32ZUxmHH2gS0Z47xYs0GA7UjWeVuI3NK+F6bHZEqlnyXF2LXikOW?=
 =?us-ascii?Q?HHsKVjlk/5K6qry6A4avVgG4DntR7Oh5zfrIUeA/T/kIPB1/oD5Ii3fI+I7q?=
 =?us-ascii?Q?JBN9G9ri0Tj5cRzZ3m1jTogsVRXYwtq/Q8178tmrJ8c63WEY5Dc9L+49u8Dp?=
 =?us-ascii?Q?hkapWNpf6201eKLRB6m0GSYITcIfnLZT7irMIQX+jixw+/BDBSQtSH9ipW5Y?=
 =?us-ascii?Q?h25fgZGSLarfNZP16xTOQCEYCzifneYi75Dc3l1/pmJEDpO5ngx6JiXQuJcm?=
 =?us-ascii?Q?6elkg7MWo4hpZd0n6+djaOjY5XBUYU7Szyqj/KlLFR8W1jCmbLvT1YzNjpf6?=
 =?us-ascii?Q?/X6kjVFHGmStTjvOqzFjr5SDtKF0uE39zqPFX/R0pVLeA5v9LZP3iUTcolP5?=
 =?us-ascii?Q?OWt5p5/BwHSagoksGPlFFrslwIbTrPQMsmgLlv8EYz+T/+iGRwC5LZXuFSO7?=
 =?us-ascii?Q?QZc9poxhFEq6R0PqLftw7t+4es6y+n/gBlnmm6czJzk+HaXSmFBGx6ZP1ynL?=
 =?us-ascii?Q?6G0QJJIfjOWqvP9xAnGwK7s57uJE7uNxmsLvHR/KpErv5tWLeukwc+WwMSJv?=
 =?us-ascii?Q?yrTzkj0KGRUJixfRMyE7VzyZNlTNyWpL33x0wtpNZk7RgnJJn3E3ZEqE36cp?=
 =?us-ascii?Q?kvOiz7TEoM2yEjTTFZkwne+0Yj0sDYaqFeF7dnLP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c7f03ec-9a9a-4aeb-c566-08dcd56c93c6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2024 09:55:49.3692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ra+xTbaWFDpJCc/zd7k/kyYGF7/vRXILVsoBcIrr6rir+WENam//ANniV17bzYRXAnr5O8qDG/mdHtOuZS0HhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7050
X-OriginatorOrg: intel.com

On Sat, Sep 14, 2024 at 05:27:32PM +0800, Yan Zhao wrote:
> > Similarly, can tdh_mem_page_aug() actually contend with tdg_mem_page_accept()?
> > The page isn't yet mapped, so why would the guest be allowed to take a lock on
> > the S-EPT entry?
> Before tdg_mem_page_accept() accepts a gpa and set rwx bits in a SPTE, if second
> tdh_mem_page_aug() is called on the same gpa, the second one may contend with
> tdg_mem_page_accept().
> 
> But given KVM does not allow the second tdh_mem_page_aug(), looks the contention
> between tdh_mem_page_aug() and tdg_mem_page_accept() will not happen.
I withdraw the reply above.

tdh_mem_page_aug() and tdg_mem_page_accept() both attempt to modify the same
SEPT entry, leading to contention.
- tdg_mem_page_accept() first walks the SEPT tree with no lock to get the SEPT
  entry. It then acquire the guest side lock of the found SEPT entry before
  checking entry state.
- tdh_mem_page_aug() first walks the SEPT tree with shared lock to locate the
  SEPT entry to modify, it then aquires host side lock of the SEPT entry before
  checking entry state.

