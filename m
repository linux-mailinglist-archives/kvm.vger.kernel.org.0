Return-Path: <kvm+bounces-17283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4A08C39E5
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 03:44:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CD951C20BBB
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 01:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07ABB125DE;
	Mon, 13 May 2024 01:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gYcNx6iZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22464111AD
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 01:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715564687; cv=fail; b=f3h1IyIhwtcNZ86UQ7EdTAkwuvWV9UX2Jk7rTTSaaz/FZP1L1c+FLClOPhPSkrCrvb3nNiafjRIq8HWkTtVa/nblO+fIYmB6w1os6loB6uuNnsWFm4fBjTfKuDBIpYREW6rgqZsa2BJhZP79tqr9oBLZx83dRi9sGf8YYWGsJ0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715564687; c=relaxed/simple;
	bh=4oSlyEATl6KmjxqWtENLgEuavRjgKA7/p/0NFuPG4ho=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I746MnIDmJn+VVIG4bBI+yWn8G5CNNUfdZC8GjWRb+mWsjuEQdnBhlLD/F/KZLa3NZ68LP6QoyMiPtnsDbzR+IDMsJudR3cMCvUQa8vGmLOnRLjv4gftf3FGtkQZYk3REhRtQ77lf9xl3yFDtVYwqFpj5LWoI+FNLwIIvqH0/PE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gYcNx6iZ; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715564686; x=1747100686;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4oSlyEATl6KmjxqWtENLgEuavRjgKA7/p/0NFuPG4ho=;
  b=gYcNx6iZlHRVldv3rniaNf4g7gkCNd8wZZF8LU5+xCe73l3wR13tRZYK
   Kf7xU+rWWtU6GLy5wVYEethg+GfTj3+saTetj8VEBUiVC09ocmwcWzHkl
   QgvgkCH0iGDn95J7LI4MgmJDrWftE37cCawIhKCuyqdov0hVKtexCyFVa
   kxky0eKSU8YSyBgsAtqfIs19WzvADUycWYJnO7tfiyIyVE2tNMyKM1qkQ
   wFJ+4HwqHzWMLiC+SN1UjtewzzkxAIvd+JWKXdhYafv/tc4XJiie7i2H/
   KuCMf0jWjFEfoJe6tJIMCLIb6py4PoSee5Dgzp1H6j4ipvs0KYz6yPaYp
   A==;
X-CSE-ConnectionGUID: aNvYUBZXTIWff6HUghXsiQ==
X-CSE-MsgGUID: dOWhk4GrQVeafKmOkmObMQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="15317205"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="15317205"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 18:44:44 -0700
X-CSE-ConnectionGUID: 3KF3kUtbTCqDj9SDiSzyHw==
X-CSE-MsgGUID: hdOCuJ8WTHK9VKBCbGHNkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30217655"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 May 2024 18:44:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 12 May 2024 18:44:42 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 12 May 2024 18:44:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 12 May 2024 18:44:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 12 May 2024 18:44:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2dUaJNPqhMBLJxRL7hX2rtvyavNjjbh7V6op/T9LVH/tLPfZ/GrQr85L3EF7Fzxk+21hjANSHNkl/NIvF4t+lhM2xpqYafFOKSDX07Kh4YltJuiMlXPZPSuGnH+NxUxoxAeW4aUoYkDoLgLb1CDGFq8C6uGqA/ZAM1wGxd4HY+QmfSyDs7IWKVKjglzHnU8zbBoNWoRzXjNnjO6bpaurA13XHeXlcLSQihMeTpd806QbZ7G+kKFjF0dYymp7MfVpnDrVC2xMl32MeYIXgprHk5YsJqMPvNw6xtzdeGjjwxfhMop9xAnovGNHWazCRRE0ho2eSSeng1jLW4amrDdqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkKFg3wSZiVJFxIFTA/80pwK7Qv7gYtGauAZEtKWsdQ=;
 b=TDfNTerCZI1HN2AuvWFFXxt2upEgPC00vFhf6Rh9qFnJeMgK10eBSQQZzyU1gNC13utPLFo0JOVJagXpTcKrjD+NiplpxLvZeRWqFJ/++EWWo38JakyWbyTZZ0NipFRCjGMLqtFXlkNS/Bv2WgyUAicqvzvEnxexTWGres6jdw6/Rd41gahlAp6YbcVm+munman2DDvjiB7UHFPPaT/CmOlZK5Percpus1hpBSjcadQ9WlE9tR9dboLn0kWSEYucnCIig+AqE131B6DKmBsY62+8m4Dl5VLYf6ZKNgGOrQlKKyLYHEdZlnWCO62/OwRbIMyilhCa8SAtrXNyxMheNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7510.namprd11.prod.outlook.com (2603:10b6:806:349::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 01:44:40 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 01:44:40 +0000
Date: Mon, 13 May 2024 09:44:32 +0800
From: Chao Gao <chao.gao@intel.com>
To: Tao Su <tao1.su@linux.intel.com>
CC: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<xiaoyao.li@intel.com>, <yi1.lai@intel.com>
Subject: Re: [PATCH v2] KVM: selftests: x86: Prioritize getting max_gfn from
 GuestPhysBits
Message-ID: <ZkFwgGYV84TztUxD@chao-email>
References: <20240510020346.12528-1-tao1.su@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240510020346.12528-1-tao1.su@linux.intel.com>
X-ClientProxiedBy: SI2PR01CA0024.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7510:EE_
X-MS-Office365-Filtering-Correlation-Id: 38297428-334d-40d7-2620-08dc72ee4115
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EVS/IxnQ3GRuAnl42nqosRhcNUwbNLgKfrv94EdzkIFjQViPZbiTtXN+qafy?=
 =?us-ascii?Q?HQTN9TiPqkbmlOKiw+/bcp0N4ZsuVHrVgOVQFKWQ/8+l8t03QmXDtOoClPud?=
 =?us-ascii?Q?gS1R8cUrKwx8I64G4/Zd0FjRmO55IPcv6ezOKGCq/VHdEE2t2f9i++6MAtLv?=
 =?us-ascii?Q?3+0BlVVh0P9IHXyu3THlNQ5PrvFVbJXQZWFSVavVA9JkGnwKHdJhu+LuTIz2?=
 =?us-ascii?Q?gYnc7p0Jz7Ui/LVKPBDmLZGLFVwEhIYt4B033SM68GbNaRPO4V54TwUGSfiQ?=
 =?us-ascii?Q?F2sL1Oc2KVRr+L9K67h1ci/5OCdP6n6LwBrk4auagl/zbJbYyRE447psTHf/?=
 =?us-ascii?Q?eZG38NCpCEAtzCzMbH082yhe1+9zmTDBf3GZQu9U5/VOqxwty/s3S01Lt2DQ?=
 =?us-ascii?Q?gmlnFZjM8L2FnNZAE1fBATaat59MKg11avS4ZAuEu5JMl+wtWlhUbPbk4jk6?=
 =?us-ascii?Q?W+a0H8rdJP1kP7/YSSdPqNFoyTZwKtNYjv6uCFstEaU7eqHPfCipAFRfvPRk?=
 =?us-ascii?Q?q60vyQxrVAvANNMnhf9hMn1A9D8xZNwlhzg0Ey/8Q5HOstHtCD8JnHLIpWYm?=
 =?us-ascii?Q?uYKbvcowT59NGULi4RttniUM3JEHiOXuTPlPNtQ9D9rkP4C0ITA/Kw6VEWHf?=
 =?us-ascii?Q?xXwBbMHiiTSyySBWS9P5MLhz3t5+/IQ55mcmX/kQAAoCAFhKPDMeo5WpPd5O?=
 =?us-ascii?Q?XhUJoWMHdu3ZckLvBn5bMv2ACQ93Uhsv/Dw6tTsbTRisUZHEObKMJ6jl9ZMl?=
 =?us-ascii?Q?pXSIjb42ZsXQdUtdt44+wLio4og8Aa9nhvzkknj4vQckqdj61lZtDXGfwJ+H?=
 =?us-ascii?Q?wuEskkCU0EasKy0gSoH5YQI/oFn7PE/h6VfMcUZb95PT0o2eaIXhOwcz7FEi?=
 =?us-ascii?Q?wOT5RU3yl1f3KyoEN4uD8olI+vaj8GRSOcV1UYZqDqF8Iv49Kqy3frGmpzpy?=
 =?us-ascii?Q?8qGPZ/JJePx2fmoPytTgNdfHhqTP7uhKVA4XqenjYdeEAc5WWpURvgDLYdrK?=
 =?us-ascii?Q?YxHV8UANGobR/LgeseRU6TJdjP2bzJ4nS+yshVl/onmsuGI+5+CpDTEUe04n?=
 =?us-ascii?Q?MyR0ITJaa0M7IkSkTejDz3URAxTK/VzevRgRvddO3X+oYhoHyqYbAP8pipwJ?=
 =?us-ascii?Q?FtcC/N3i9gPlz+5opx9JUJWeaZpglRfjy5Gg5jy/RdDlALHsU4IH5MPuY9KZ?=
 =?us-ascii?Q?KRT8E0Pxg3ys9Dq/6PV3iqGaLbHer4+enpyI8QI+iB/MCa+O1Tt5T26r45E?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SH/kL+S+WVlydM7Nq4qPtYs0G5FvpQs3sRJFab42UgvlPqvAriNfZbPds1x1?=
 =?us-ascii?Q?Jv3A01e8uFOrvtGAgBD4OOC0YhptxthKCnuKyOohW2WdXrDdsQ1FuZODZWLI?=
 =?us-ascii?Q?pn/m+T3sAyFi1dH2zo5+sdIpTINbCknZ1xYB8VJICJs6l5I/WEl/KLTizVkN?=
 =?us-ascii?Q?Wfv2FLKSyNMizW24OLvlMQRWXZHWKYSt99jNAi+cdXGx60EEShZ2m431UzmY?=
 =?us-ascii?Q?EEWXzEEz3wz5EscknazlDPYGueuBaDXBWXFWzXRfT30MK4B9Ht1HOd8bLB17?=
 =?us-ascii?Q?JnfgLOen3i1iGeqCyV172DfLXh6f8XjwE/jaMCQQCiNze+xCN5eNTp3fIN4X?=
 =?us-ascii?Q?UObMkY3KksaEqVlrK9fcetPtqCmrLtNuOeEhx74iTrQ2u+2b3kGH3uJXxMCw?=
 =?us-ascii?Q?U7tbPRmWqpDl7yYucQ5BQsUflLZQf7PAgx1ixbzgdAOwmKXTHjemKsYJdh3K?=
 =?us-ascii?Q?ckbktty5kSr7nHsOXhlVqs1z8zrOKCVWvaPkon4IDIJ+IoZQM9t+HjWv1jdm?=
 =?us-ascii?Q?kYUd9/Rm1f7yLm8HI1ewbmtboBVzARF6QHJXvuNx+COJ9xMy75KnJy2XU3Dt?=
 =?us-ascii?Q?xfr+fVwTybfTl9kdJ7dDksnxD8eGPFWsoqrYnqXMKMuk2/NgyhUEmorcG4z1?=
 =?us-ascii?Q?c9ATqz1A8PpjTW6oCT1ijdSBU/KEP0W5H+yIaQ/SjIScfGJ08ZIlUj3GpV2q?=
 =?us-ascii?Q?3kuxaKiXByJWFuG6bciTMfKkXSaxcspOHf1ikIQ3XhyJzyvz6FF6BFBMhdZE?=
 =?us-ascii?Q?AsilbzjuECCVIPwHh4YV5pDnrt+Ou6vv9tldgVE36IljNeDwu3ZAFWcElKMu?=
 =?us-ascii?Q?r4iDFEYftidQgr1OVlFVb4d6UkLSWzMyHvSRlBezuTyrqbpcwez5zha5/6Zl?=
 =?us-ascii?Q?WD6Qhq8cZiSIZtLueFb22UbCXTB+Z7r2sFEmcWv5MwoVNsQdVg/6ddu4h1YY?=
 =?us-ascii?Q?guU7Cx6I/ncPOHaDKuSV7ea3F/j5SviaDBDPBCJ6kVAD5+5esqjqaKrw09KL?=
 =?us-ascii?Q?NPnehIdHE+ghv4+6nXeVV5e8KjojbWW0SFzQ0nwN9rqlaEYobQn7aBl1ONw1?=
 =?us-ascii?Q?TuCXixvIMuO6onCvfWDXue3Obx93aHnAF2gz398D89Fmy+2RESMZ5acN9kPp?=
 =?us-ascii?Q?Q++w6C6aLUwpISigXbBeUBjwOM5SzQDJpkvSwlQzyWVfPqNbKHgeVyJgQQ0c?=
 =?us-ascii?Q?fDYprldsEgw/U4PdLly4IAKb7LMKiEHGq94zNNo0qjV9zTcb0MQMubK7Vb8d?=
 =?us-ascii?Q?iiETfVeBtf2V6xLu6Ssknoa3i/0b5EedvPl7J4n0CGaq1yT28L/A4w9wfdKg?=
 =?us-ascii?Q?WOv9sGFgs0t89cwlxxu33XKlnbrC0TVGndH3waRobiJudZxI9BUOPwtHm0iW?=
 =?us-ascii?Q?KAWB02J6QbFftgUANlwLVuzThkCNqHKMqokZVJkv1RhwppCJjolW44V+OXZT?=
 =?us-ascii?Q?nQtLAEY2/4oBIdDHoyk3FYA1v6BYgSJ54ONRC8Hcyju9I8VFA/y0xbUV6q1v?=
 =?us-ascii?Q?gRT/s2SFEiisSGea2JZvZtUgjs2/MBdyau5uhsOuZWqQFnnKsEp8+ySaerfu?=
 =?us-ascii?Q?As9rCl3V86hZysWfq8Rt9X/ukAGcM95BEsCL/vwD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38297428-334d-40d7-2620-08dc72ee4115
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 01:44:40.0479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1afbGjGJo18ixLtl1Fp2a3HW1fXjqq3ai39NPB1WBKpGeG9cg6U2gVYTUQ8MzdQDmnQES8JUCx/89oLHWNHJHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7510
X-OriginatorOrg: intel.com

On Fri, May 10, 2024 at 10:03:46AM +0800, Tao Su wrote:
>Use the max mappable GPA via GuestPhysBits advertised by KVM to calculate
>max_gfn. Currently some selftests (e.g. access_tracking_perf_test,
>dirty_log_test...) add RAM regions close to max_gfn, so guest may access
>GPA beyond its mappable range and cause infinite loop.
>
>Adjust max_gfn in vm_compute_max_gfn() since x86 selftests already
>overrides vm_compute_max_gfn() specifically to deal with goofy edge cases.
>
>Signed-off-by: Tao Su <tao1.su@linux.intel.com>
>Tested-by: Yi Lai <yi1.lai@intel.com>
>---
>This patch is based on https://github.com/kvm-x86/linux/commit/b628cb523c65
>
>Changelog:
>v1 -> v2:
> - Only adjust vm->max_gfn in vm_compute_max_gfn()
> - Add Yi Lai's Tested-by
>
>v1: https://lore.kernel.org/all/20240508064205.15301-1-tao1.su@linux.intel.com/
>---
> tools/testing/selftests/kvm/include/x86_64/processor.h |  1 +
> tools/testing/selftests/kvm/lib/x86_64/processor.c     | 10 ++++++++--
> 2 files changed, 9 insertions(+), 2 deletions(-)
>
>diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
>index 81ce37ec407d..ff99f66d81a0 100644
>--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
>+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
>@@ -282,6 +282,7 @@ struct kvm_x86_cpu_property {
> #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
> #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
> #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
>+#define X86_PROPERTY_MAX_GUEST_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
> #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
> #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
> 
>diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>index 74a4c736c9ae..aa9966ead543 100644
>--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
>+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>@@ -1293,10 +1293,16 @@ const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
> unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
> {
> 	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
>-	unsigned long ht_gfn, max_gfn, max_pfn;
>+	unsigned long ht_gfn, max_gfn, max_pfn, max_bits = 0;

nit: max_bits has only 8 bits. so max_bits should be uint8_t.

> 	uint8_t maxphyaddr;
> 
>-	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
>+	if (kvm_cpu_has_p(X86_PROPERTY_MAX_GUEST_PHY_ADDR))
>+		max_bits = kvm_cpu_property(X86_PROPERTY_MAX_GUEST_PHY_ADDR);
>+
>+	if (!max_bits)
>+		max_bits = vm->pa_bits;
>+
>+	max_gfn = (1ULL << (max_bits - vm->page_shift)) - 1;
> 
> 	/* Avoid reserved HyperTransport region on AMD processors.  */
> 	if (!host_cpu_is_amd)
>
>base-commit: 448b3fe5a0eab5b625a7e15c67c7972169e47ff8
>-- 
>2.34.1
>

