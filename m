Return-Path: <kvm+bounces-70306-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNJCCNVBhGng1wMAu9opvQ
	(envelope-from <kvm+bounces-70306-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 08:08:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C24EF47E
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 08:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 93F503017241
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 07:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CADB35B636;
	Thu,  5 Feb 2026 07:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hzo/pzdF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1682B3570C4;
	Thu,  5 Feb 2026 07:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770275271; cv=fail; b=KN3yb+g26jTq2givlcLYqj+xqSyqE64MbaBgtIWe5x8oEqjXpdPbJnuBIE7gC1hL+C+mt3nkgHpP+LIdNmjEvEj72R6qmguIsqDuTMOAZqfk8xP9WjRu+bm2Ero+ozQRNXbenmfvqRhHxNdpUxDKfaZAtcCpSIvRwS5doF0ytIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770275271; c=relaxed/simple;
	bh=SZa/5xIhL3NB05p+RBBZt4FdTSw/kKdg3Ka2LNGbLRE=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dFofPbjf2pIIWVxyA+uDNNPGWx4lkKddcL6KMpzUHsRLzLmFD1RrAD5QhIV1sIXWosy/X18CJCM9FM1LlD3oE7oJ3iJqcLV3FHPYAO9Vkrx+1+UHK1anwnfi0GXSPwDsgJ+OGC7TOOyskehgIeD7xthM+cXECVA/hpJiFkePDQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hzo/pzdF; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770275271; x=1801811271;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=SZa/5xIhL3NB05p+RBBZt4FdTSw/kKdg3Ka2LNGbLRE=;
  b=Hzo/pzdFXsiWo74cc2bJMqHcZ82i5KCnZS8IgQPAwnkL54UvpxBwKpPq
   XfV2wbP2fX36YbGl2UVotKkHVLh7WUZ0LMjEa51wYoU5WXuRDct1K6L8V
   KLN3cHSVgwTfMUUYoi0LAgb0nD2498qp6M5RYVbBJosR1brVqAFJxpbkJ
   zKwH/Mee1FPnAMkFXDreUN2bPbVbGghrdnjFxIJQzapzjp/F73Ajo0ofW
   g0MbTpj8gOAG1cN5cuszYDOmnr6CQO+eIvx6jP/YM3jrmT8x/Y1gnZy8+
   Rmq0qyi+fJ6kpkA2MYTUg4Vdj8ikCPFdowSk4HpqlgVAc2EezwyxHnRi7
   Q==;
X-CSE-ConnectionGUID: pGfYJ3CvQ9CdtdyUwkjwew==
X-CSE-MsgGUID: c32jcpU7ROmotM7bo2lrrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71565281"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="71565281"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 23:07:50 -0800
X-CSE-ConnectionGUID: i0y5ahUIRPKYE0fm6TkMhA==
X-CSE-MsgGUID: G8bvKwVHTIyQFyydhq8hyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="210449729"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 23:07:50 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 23:07:49 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 4 Feb 2026 23:07:49 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.2) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 23:07:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qgm4L+9tAAjbL/fGHJN9w7z7N7gFzrW0fTlf3IcrVWfVQ8x4arSghSZIowIrC6Ppcmcw7Q2LDbGvpoRBW+4BaskV2yQz+2Xq90OanL6HFGAe8JzcNH4HX1s+TQ9plwY914IJfydTsDJsZ4ztVGMFCBVpsDLYHprUB6wCH68HJoU92QG37+qOKBXuw8D5xcVPtId9lLu4/iWjem2BeSVrSsW8pkTSIaIjtnIyDpM1SYxdexSNlSOux5CroaAUs2+1qj+U4cV3S6ybs6v8UPJbZaVS7FDhxNkMj1BTcFajtNNEcljGAU07v0t4upIgdQwKsEL7cwgcpYYHkl5ulDxAjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRoThvwNVhIJEAH3WLFq3eYl0Vx/aeOyI3+R1tGAfgs=;
 b=NJwLb/N3aOftdWv85KKZaGTrY2d3A1932gQhStN2Gw6cldpZR2VCqRDK5zM6skNu/WFYFc5Sib9gfhz+i0H0CPRe8fN7N7Q1wWKsehW3pRSPnsedk6bkf8/2c7MRCMa6gd0tzBdYPKJgKce9MH2vG1Uaw1riiua2YhndgVVYXTLhc3omjGPLpnvZ23psSD8m/iFnqZQKrjcc5SPdxa306+LIKOTtv1mJEQNV8kc+/0QLBC+HCfOSLuku/9TQtON0n2Mdl2i2P5L16sOnIni141iySA1PRz8U1np9ycA5l0trdku1mOgMTZYuvwxrXedlnQKekP3/8SQjNAVSFEOKXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6877.namprd11.prod.outlook.com (2603:10b6:510:22b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 07:07:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Thu, 5 Feb 2026
 07:07:46 +0000
Date: Thu, 5 Feb 2026 15:04:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>, Sagi Shahar <sagis@google.com>,
	"Binbin Wu" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	"Isaku Yamahata" <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 09/45] KVM: x86: Rework .free_external_spt() into
 .reclaim_external_sp()
Message-ID: <aYRBE1tICOiQ/RL0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-10-seanjc@google.com>
 <aYMVEX5OO22/Y72/@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYMVEX5OO22/Y72/@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI1PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6877:EE_
X-MS-Office365-Filtering-Correlation-Id: 461b9abf-3220-4157-452a-08de648543b4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4fYCwgRQO1NJdzoE22z/Tz/sXgNAmXS9YfNwyvc/p5i6TRcJW4Ed2NTMEgi7?=
 =?us-ascii?Q?PFlGgEzfaBmG5OVlfZl6AsAdc0I88GyJWWdKreLBKog7xke6RRqyDWq9SMmK?=
 =?us-ascii?Q?064eEGjQDPxuuNDsPovw0POMxrkg/qY7aLTWu/oluKVgR1/kfIMqPoQ1ZYFr?=
 =?us-ascii?Q?cNJAiQWdQRCTakvfQArHS75nj6Ye7Pk9HpsGCxftOV7ucaieDDielmireG9n?=
 =?us-ascii?Q?FKSoCNjYNV5aG7g/f4jmvKQjCLtUDGIwnompIYEzTo4jY3OrPRqzs56elSN1?=
 =?us-ascii?Q?jQ4mV5rT34KKUjic3r+CqhDyvuIHRERoXkXlBksRDeuavBK7iqcZXNpddVdj?=
 =?us-ascii?Q?CNebuYCJ8qt7ngTw3A3RiQrK6MGvTU7htEj56jVh506vPWqdvcVxaKFXgfCE?=
 =?us-ascii?Q?/0oHff2gLu9c+M3ln90a+CiuPrUnFe7kHodgbJDzKOyrqmqbdwAtkdHd8jp6?=
 =?us-ascii?Q?mgxEKDdwtijn1bvol0CspTSENHI41VGhqoFphBar/UPFT++XKHPA5I1+2wYk?=
 =?us-ascii?Q?HSqB6IOL6rgU3HTtS6ZhOSor878acWqLm2ar1vClnarSN4WyE6PSg6B+slz7?=
 =?us-ascii?Q?IyTvGYOFNbyI0pV7NIGdk2ruXouBAnsJSNURFctVvBIp1kviC9PT0f0GD/lp?=
 =?us-ascii?Q?+n8yl+BONPVfZqx0OiFChNa+0iola38piwxLrQCahsKXhlZJRUFB9kO991aG?=
 =?us-ascii?Q?cHG5mNSrg5lbCMAGLrBRZZP+ifkLzj/w3y/QfMt7Rxx+XJVAhXCWI0Q7Ja1A?=
 =?us-ascii?Q?TdCZaDLkUHitwJp+59eULxOkRtkrbi2RX+g3+VO7LD+r5gPNJVKr0L2mVNIr?=
 =?us-ascii?Q?C5l7EMz2I35x1d66i300uAG1K3PcT0bJ/GAEXuoi+aob+bbQlZM5+dguebbA?=
 =?us-ascii?Q?oHfAP1YoZBKTt1+PQlQNcFJ1KmH4sOtdBZX/2sXP+V/cPESjQwP+llqxg+tF?=
 =?us-ascii?Q?ezF+jSJy8qKQwXuXtrqbhD1P/vxRJY+Y4BjY4e9ztTHgLFW5s0hRHqIgbWB6?=
 =?us-ascii?Q?/dOA1vOBuoi/umszur6jDzit+NpZKIckfSYezknfoDrLkGTzTXKq2LSjw0L0?=
 =?us-ascii?Q?k2oTzbISzoBECWOYt8JD/rYzVXNreDJOM9ZV1oh30jOH3UGpUzMRxdK/v8+e?=
 =?us-ascii?Q?ApYXt2pUuBsNDMYiCA0IqOW2oAwlA9YByUqNZl2SbLHbVftqplBAfn61Np8o?=
 =?us-ascii?Q?XIqbPD59yLdNqebkhL/BIMNec4mVfz/SNPNpU1PkETLraekJZ5TO91CKUqBR?=
 =?us-ascii?Q?xZ7qTTnhlmgbMdVSqbxGLtBjZu/+EIN2pAB/y983WlG7fK8U6u5Nh+CrgGQ6?=
 =?us-ascii?Q?dGE7TmCCIv32tmVxFwBPXeihBRQUCJoWGlRcxv9+v9hSXcm8XOR+UOE5ddWB?=
 =?us-ascii?Q?ZfJ5v/rL8ABRCx8Qh6TgdHVtfH81xUshqyzH7Qr9bg8uSi7taystw1OrujlV?=
 =?us-ascii?Q?JipF/Ew+IxLIHfcfpP9nONWmEzRpA2fPEPFcXCrMHorJu+cXAGxnzRA5CN+B?=
 =?us-ascii?Q?cBhz7NL7Oi4LWe2RDBvXJI3qzpUgpCoE0+rsh8N2QJTagO98UL+ixk54KsDb?=
 =?us-ascii?Q?lgmCnPaNWFZPHpl8gQwzl2CfDMw9HokX3vpQH0865CYGtEWhujvsbri9wSgo?=
 =?us-ascii?Q?dg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4/Xk6VN8TpLXK4eeA5nOoEYrh0y57ihXnxlQ/mC4jp2aaKG7HNi/eq8vh3WC?=
 =?us-ascii?Q?UHGnMNHL+654t7ANwPp/RUubAt65m8eMkuzlGW5l+AdTuEExjUPJFg1hy+Mm?=
 =?us-ascii?Q?EQhK87bFtUy7Zuq4elNE0LK9qc0/VG77QmxXpSGRBNOYHnxOw4BlVRWGZAIH?=
 =?us-ascii?Q?jQVc7CAs8Zd6dc8rlq0cM15nE0/SwShjlvnrSX2NrEpjkvwICnAxaQ0U12aP?=
 =?us-ascii?Q?mm1M1iYI5nmPJOs0L1gP91H06ZnIiB0ZSP/hBjWT+3cYU2C3FawitzqS7PtH?=
 =?us-ascii?Q?uEFEzXtVMDi9pggSDtsxqCisOu7pljqHtEVavn5/7Sv+yuIEITxp63ryQGDV?=
 =?us-ascii?Q?i2IhPj9AsIj6RQSwVgzndP/w865kNXxjme2EeU8eukFr2MlcrCm0xjhtaTOW?=
 =?us-ascii?Q?cfXY5sRhQ+YLski25Mu+AOMDC0kwW16E7ftUF88IgU3mKRcnBOai6F9erOCe?=
 =?us-ascii?Q?ftvs9eywAFC2Scur9wRwRJ9bSTAZ798PG1NWT7WFkrzfR/loZh2P4llUH0QG?=
 =?us-ascii?Q?4H/syZOhJanzZcFG2C0CxZqIGHFp4NvpfrtRHcmQSmBSp3M3yIRnwVPK28Dc?=
 =?us-ascii?Q?yzUkIVd4ABwrtC4eZakYKJNWwc6oXWK8Zs4E2alqIKgcrfE02+QYgCT8lfrF?=
 =?us-ascii?Q?MWwsCCLskAjSI0AumRCpzh2Y/4fyRhTmkPtAaCl04bs253m9PqbROlJhp+dY?=
 =?us-ascii?Q?lAH9c9USCN7td+v6sQTPZP5rHjOiedoh8CJ7cJ7Y0ZHpdIbMyjTzLYObDk3I?=
 =?us-ascii?Q?yIfbiEgCXWwhjciF917Vr8jl43S+swrt9cIFN183PCLglAU30yAclLqJA0N+?=
 =?us-ascii?Q?WTjsy1emQ8JwL3rBeRN66vH2ObW6jEtCz7AnivZj8J4c8dNMnzM5g6Zgyerk?=
 =?us-ascii?Q?/h2L9dZF+WnlpxRQv5gEHP6FmX/X4o7DOzVjp8AZuEqJ9+RYGszPw+sOZxKw?=
 =?us-ascii?Q?OBld03DZa7+NNob8g6PgcGwqvykVoNpDY5m4pB0k/un12Nn9Vk1R9njX4bGr?=
 =?us-ascii?Q?i0i8sDLlG5+Drt1nOUcqroLlM6mgAEuGIyLBUzoQVhKAf7Sa5fwfjZhEbGmX?=
 =?us-ascii?Q?Q9fm+9eNMJdQCPcDUJ0hs9YDz5fFRWwF90QCHntRi12YlO1Ls44QH/L80JUQ?=
 =?us-ascii?Q?f2Q9aHWplaXJrAXtp+oQ07NZZY4+JuKYGD1mvZnblG2xm6izMTlMn29RO3CP?=
 =?us-ascii?Q?zCR5g9M8041wTk+YpMNeOkHoiECWH20w57CN6qIDoobjHztzN1jY9TdvJsyl?=
 =?us-ascii?Q?zeJGJKac1S3/kKoHZMIO3lt515u8m5GG3UeAIK4Ff7RxiET8fyh3ldkatjsw?=
 =?us-ascii?Q?kktQQyvI7gtcD1hybx+X2BZJjD3BDpY4+SqbK4k4aGkcjPYdGlutf1iNdZhn?=
 =?us-ascii?Q?WzwBJhHKRxpeG7kC3zdSre7XySkNoU/GOafyohvNXeKFgSOW6XKSKuj6t6SB?=
 =?us-ascii?Q?Gz2U8PfWbxZTMOzyTQrh+HjHaYh5Rj1iZ8hQYqFMfQwePdZkbzb1rgexUnU3?=
 =?us-ascii?Q?V5ugJTFPwz6nhJd3AGFDPGl4EAVBiXaZuol6uk+JBnpc5C3qyZC1iAio6uCB?=
 =?us-ascii?Q?2p81nYlCTidtNOiIssT7CPCkvpzBJ06FCoZcbdEkv0+65e3GMx1mpZAPaiZF?=
 =?us-ascii?Q?aNpBa6LZjLWj63mHQ68O6FDUOCKjBcN5YhIxHd0SQMqaG+CAOXuqr2LTvFwC?=
 =?us-ascii?Q?VVgzP42cvp9U1VlQoyK9vNcxJvjzySvVP1baMS6AU0/HG2xY9amI+BJlicCa?=
 =?us-ascii?Q?PUTj3n7T9g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 461b9abf-3220-4157-452a-08de648543b4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 07:07:46.4738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISFhuZmQpWovryQFRbLNc/TLnf1O6jb5j2iOknq/3H0m0H2UAAAh1XfkD9oilmFM1RlS9KhMB6DbsCx3d3qqaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6877
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70306-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:replyto,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,yzhao56-desk.sh.intel.com:mid];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 76C24EF47E
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 05:45:39PM +0800, Yan Zhao wrote:
> On Wed, Jan 28, 2026 at 05:14:41PM -0800, Sean Christopherson wrote:
> > Massage .free_external_spt() into .reclaim_external_sp() to free up (pun
> > intended) "free" for actually freeing memory, and to allow TDX to do more
> > than just "free" the S-EPT entry.  Specifically, nullify external_spt to
> > leak the S-EPT page if reclaiming the page fails, as that detail and
> > implementation choice has no business living in the TDP MMU.
> > 
> > Use "sp" instead of "spt" even though "spt" is arguably more accurate, as
> > "spte" and "spt" are dangerously close in name, and because the key
> > parameter is a kvm_mmu_page, not a pointer to an S-EPT page table.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h |  2 +-
> >  arch/x86/include/asm/kvm_host.h    |  4 ++--
> >  arch/x86/kvm/mmu/tdp_mmu.c         | 13 ++-----------
> >  arch/x86/kvm/vmx/tdx.c             | 27 ++++++++++++---------------
> >  4 files changed, 17 insertions(+), 29 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 57eb1f4832ae..c17cedc485c9 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -95,8 +95,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> >  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> >  KVM_X86_OP(load_mmu_pgd)
> >  KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
> > -KVM_X86_OP_OPTIONAL_RET0(free_external_spt)
> >  KVM_X86_OP_OPTIONAL(remove_external_spte)
> > +KVM_X86_OP_OPTIONAL(reclaim_external_sp)
> >  KVM_X86_OP(has_wbinvd_exit)
> >  KVM_X86_OP(get_l2_tsc_offset)
> >  KVM_X86_OP(get_l2_tsc_multiplier)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index d12ca0f8a348..b35a07ed11fb 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1858,8 +1858,8 @@ struct kvm_x86_ops {
> >  				 u64 mirror_spte);
> >  
> >  	/* Update external page tables for page table about to be freed. */
> > -	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > -				 void *external_spt);
> > +	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
> > +				    struct kvm_mmu_page *sp);
> Do you think "free" is still better than "reclaim" though TDX actually
> invokes tdx_reclaim_page() to reclaim it on the TDX side?
> 
> Naming it free_external_sp can be interpreted as freeing the sp->external_spt
> externally (vs freeing it in tdp_mmu_free_sp_rcu_callback(). This naming also
> allows for the future possibility of freeing sp->external_spt before the HKID is
> freed (though this is unlikely).
Oh. I found there's a free_external_sp() in patch 20.

So, maybe reclaim_external_sp() --> remove_external_spt() ?

Still think "sp" is not good :)

> >  	/* Update external page table from spte getting removed, and flush TLB. */
> >  	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 27ac520f2a89..18764dbc97ea 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -456,17 +456,8 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
> >  				    old_spte, FROZEN_SPTE, level, shared);
> >  	}
> >  
> > -	if (is_mirror_sp(sp) &&
> > -	    WARN_ON(kvm_x86_call(free_external_spt)(kvm, base_gfn, sp->role.level,
> > -						    sp->external_spt))) {
> > -		/*
> > -		 * Failed to free page table page in mirror page table and
> > -		 * there is nothing to do further.
> > -		 * Intentionally leak the page to prevent the kernel from
> > -		 * accessing the encrypted page.
> > -		 */
> > -		sp->external_spt = NULL;
> > -	}
> > +	if (is_mirror_sp(sp))
> > +		kvm_x86_call(reclaim_external_sp)(kvm, base_gfn, sp);
> >
> >  	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> >  }
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 30494f9ceb31..66bc3ceb5e17 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1783,27 +1783,24 @@ static void tdx_track(struct kvm *kvm)
> >  	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
> >  }
> >  
> > -static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
> > -				     enum pg_level level, void *private_spt)
> > +static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
> > +					struct kvm_mmu_page *sp)
> Passing in "sp" and having "reclaim_private_sp" in the function name is bit
> confusing.
> Strictly speaking, only sp->external_spt is private, while the sp and sp->spt
> are just mirroring the external spt.
> 
> But I understand it's for setting sp->external_spt to NULL on error.
> 
> >  {
> > -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > -
> >  	/*
> > -	 * free_external_spt() is only called after hkid is freed when TD is
> > -	 * tearing down.
> >  	 * KVM doesn't (yet) zap page table pages in mirror page table while
> >  	 * TD is active, though guest pages mapped in mirror page table could be
> >  	 * zapped during TD is active, e.g. for shared <-> private conversion
> >  	 * and slot move/deletion.
> > +	 *
> > +	 * In other words, KVM should only free mirror page tables after the
> > +	 * TD's hkid is freed, when the TD is being torn down.
> > +	 *
> > +	 * If the S-EPT PTE can't be removed for any reason, intentionally leak
> > +	 * the page to prevent the kernel from accessing the encrypted page.
> >  	 */
> > -	if (KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm))
> > -		return -EIO;
> > -
> > -	/*
> > -	 * The HKID assigned to this TD was already freed and cache was
> > -	 * already flushed. We don't have to flush again.
> > -	 */
> > -	return tdx_reclaim_page(virt_to_page(private_spt));
> > +	if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
> > +	    tdx_reclaim_page(virt_to_page(sp->external_spt)))
> > +		sp->external_spt = NULL;
> >  }
> >  
> >  static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> > @@ -3617,7 +3614,7 @@ void __init tdx_hardware_setup(void)
> >  	vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size, sizeof(struct kvm_tdx));
> >  
> >  	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
> > -	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
> > +	vt_x86_ops.reclaim_external_sp = tdx_sept_reclaim_private_sp;
> >  	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
> >  	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
> >  }
> > -- 
> > 2.53.0.rc1.217.geba53bf80e-goog
> > 

