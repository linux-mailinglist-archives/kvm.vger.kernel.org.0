Return-Path: <kvm+bounces-20452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE84915EBD
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 08:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04C71283B99
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 06:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787FC145FE5;
	Tue, 25 Jun 2024 06:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bVEGbFqs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAD8487A9;
	Tue, 25 Jun 2024 06:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719296162; cv=fail; b=a83zgI1AUm7r3QX2EdezdZ8Qj4woKQkyISq6cNGrMwJ/AURlEJrnLsMpTY5orN8XtpiUUIW1FriCXyMheYXuByrlFr8gcpWds5pUJ79FVkL+CQv31ArFZhQUmA8I+A05kSelsXm6B0xBic0MBj2VEiQecNSC34mXHnzXt/LKWZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719296162; c=relaxed/simple;
	bh=KWV3R+gup4IT4oisWPGLtVfvoSFGP/evEHzVVGame+o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BlK5h4kouBkkDggWcFkdeo4IWYN86U26zkO/IIrUZRyvc8IW9uxcaBTMh5LW0h9Fe77oa97Yy9t8XeF1dO16XjFpuwNGztyq6NQSqRgMbiGJToGZEaGnh6mDQQmDV6Q5LS+wOv/3Xkx7u1ObgMVXLNKk4F5oVM7yX1tfOh753yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bVEGbFqs; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719296161; x=1750832161;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=KWV3R+gup4IT4oisWPGLtVfvoSFGP/evEHzVVGame+o=;
  b=bVEGbFqsxgT2NKndNQ/CEG1KOXTksre01yvU2+CMMQrUtRlkcIWMWHZg
   koj1kNUNmo3XWDAbDg2UpuGwNGGdyp+YPZwz25BvD7VOBysZ1urfWoKLv
   02nxXWKosZykmDB6t1yW9zkp3+iyF1+24Mj48ITH4cw8plyN1HKp5IRcw
   saMbX5wKRRe8yAFzbdnS3Sis9vXiQ7XZzVx5j+jI7D/u6JaDDef8EaOHu
   EJ8UftnFl1MV1SRPJz5pMJwemWWB+Wv0WUTt7ospdQTBE8SRui38gjkVJ
   fYoTEtC9tLSQlxbvC6cbTcL4dKLlGJsyQCnRKOj98ps1tFsu9wx8Xa2qs
   Q==;
X-CSE-ConnectionGUID: /rMsv6g7RWCigQxDMYhKGg==
X-CSE-MsgGUID: JVLjeWCaT+6RmsgEezbl/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="38806308"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="38806308"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 23:15:53 -0700
X-CSE-ConnectionGUID: BHamHYBrST6Aj2Rru5GtbQ==
X-CSE-MsgGUID: OcdEZRqiTV6p58BXLohudQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="44234454"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jun 2024 23:15:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 23:15:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 23:15:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 24 Jun 2024 23:15:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 23:15:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bk0/wyPOtu64hcNDpK44dNzRsCVvDc8AC8dExLJU3YNLbvnIjWLfV4xFQyuvHFkQQY/cwsmmWpwKmMX/OvMo5JP/SQ2lDq+d5BGzx50v13Pr0T6ye4DQIMIm65i/xRiLw3xXWVVd5rgOX3rCbPfjFZAR+jtKJY93GCEcgeKFmLXedBU8GOkdMW/ThyPilU3T0ElGkHo0E7PBQ/ooCpAR/s2yfAi/HjGHdrlfT5orzlLVkuC37DI0f5NVQrRsH2ybHb1sT5tdq5koq4uwzMQ1ntSbb26zK9zmf+xuMbBKYgkW4mQ2eqC59DobiDLC95OB0y9FMIqp1yqj5tPotB/jzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mP+QZwhNJpRyGvEU5XnKNtm09g/MD6vntzFWZmeXA3E=;
 b=NbUDJsPgiFpRhpnxdXyJ3GTL9UCs/psbeeZMVgYQKf7pIXrexTGyDLaPH1NWyFnMfT8WJqXI3jlbL3NiZ4I9Et5r9afpIEdhGaNiP/dSbsWMq11Gr8nZzUZgO19buXdsghtiYqtzO4/ysuTs4wecFZGz6G9d2EPToF+wGxFGzX6q4qicv+uWhOIO9VwRFG5/cjO7rjAXjVFXja7Y9hV3VG+ftDTvDTyuZMVvSbjmAzua8AlZzw61ri/yv2MBz8TOatY3Z4TB4/HbKd/2ODzjmGsNOael7mU3uCTY6NOtyyxiYVfetJ35Edjm8BRtuA8O0tFDmdwOi05RdUYTspXKlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8084.namprd11.prod.outlook.com (2603:10b6:8:158::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.22; Tue, 25 Jun 2024 06:15:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 06:15:42 +0000
Date: Tue, 25 Jun 2024 14:14:30 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Message-ID: <ZnpgRsyh8wyswbHm@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
 <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
 <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
 <Znkuh/+oeDeIY68f@yzhao56-desk.sh.intel.com>
 <d12ce92535710e633ed095286bb8218f624d53bb.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d12ce92535710e633ed095286bb8218f624d53bb.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8084:EE_
X-MS-Office365-Filtering-Correlation-Id: eb6cde0d-6e5f-4cea-9cf8-08dc94de3daa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?8UcxGq7CBxTNpERmRN9gztH4XRMxRjb1DZdRDqQxpdxhsQ6D0vZbBSqC2z?=
 =?iso-8859-1?Q?3oj06tdmaQPQrEud+54y3TDmVCujNBre2CULrsJmaWiBI2gF+NrJMxiU7Z?=
 =?iso-8859-1?Q?wsYN0RqeYCpdS9ve15D54UNXzfoGXSSdTYXG/E8ujk+A2g0Uekw8W0AqJk?=
 =?iso-8859-1?Q?bNCtFG8QhNt38YHHp4qTcUBpOuqvau1B8Su+s+hx2GKqCkDzoS3UwcFkFt?=
 =?iso-8859-1?Q?GOQ0Vk4cwoneXOammVzdDUY6/8iLPvPTqdhHu/f6EJKJ4Uh9GrLZ1fbDi2?=
 =?iso-8859-1?Q?KWf5VXDE/bfgCzGa6ilWZmbjjxkv4VARdRIxt8InFuiDPviC4mGecM5oew?=
 =?iso-8859-1?Q?EvlD1CCFBR7fzdQadGeblrT6dU8l3JUYoS8zaBTvKspin74lPJjqkTLSR5?=
 =?iso-8859-1?Q?FmCGGtwW3XIt2q6Kj3qfyTgLTm5hg7q7iuFuqq24+IV/r/7NPfdvEmBhYN?=
 =?iso-8859-1?Q?68RQt4U4GykSQLLPnaG+sj8JNhwweXV+7ihrz3MghQAdyOnk3eBpOnvcQ+?=
 =?iso-8859-1?Q?8+ICql1gNYVQ1UGOR53CTSfuQZfjzHnxBwWHfinIF+6FTUCzp0uBYv78Od?=
 =?iso-8859-1?Q?L/tCWxvwPS+y9pXBG4A/sGfCfHM8cEuVczkB24CnbjaOC9wfJb5OIYGJHp?=
 =?iso-8859-1?Q?rs6XzQFogcOzZD+9QsKRUKFtoP5zshlJuGsvzhSxD6T7EnESwCP+1sGiRf?=
 =?iso-8859-1?Q?9ybfuCUg45EHmGlHK3PrN6miPYQN/e9cG5qp5z8qAqv+rW0+7W7sW73LgZ?=
 =?iso-8859-1?Q?JdwlciZqUefAajJ8obMNRakQeLneYNGZQtEqfV3C3/Y8U7ohyNh42wSKb5?=
 =?iso-8859-1?Q?vc8ccdnYfl7/evhMZ+MLhGobRGJnrEsJq0xwJpp/96DL/v8hurf9j2xy/N?=
 =?iso-8859-1?Q?7LaqtdomoSkQ2a9zE6qcvWSOBExMLQ+QYDGicki1JosBKB/qTh2GVTcg0+?=
 =?iso-8859-1?Q?vgHKTKLGPF1Nfte3xjhXSCltYBHICWI1LcD+uhbQoOf1GZ31kJI7GrJGo/?=
 =?iso-8859-1?Q?hxQ3XBratrRPo4Gt7Oavd2LoX3o1WLxyPUKmKYIWOsXoRJMKLP6T8RwcwJ?=
 =?iso-8859-1?Q?V+jJqSD3Xs6fS/XP4+KKCNxtCyMj779Au6cPYajWWlfp1K7keqNYn1MJxL?=
 =?iso-8859-1?Q?lr7KPEAYhicPBvvfmd7ZZYb7UHyqlMjmD3rC3kXBihcaMVvoh30CAkkgLE?=
 =?iso-8859-1?Q?3Cr92bGXvv6Mem0XoBuKJyIQqnlNuqlO/IOjSUBtDTDwpem5wKCLIQ0ZB/?=
 =?iso-8859-1?Q?sdgtr4nd9EpgUSjQUYxiilkZXOVaFsCBbmxP7Af/3QrFV3kA2UffpP/3rz?=
 =?iso-8859-1?Q?Z1b2PTMUGHInwkl5vPiY5BXnau6aMN696UtlXMRjtA9F7W2k3tr5HIFNKH?=
 =?iso-8859-1?Q?KnXga3U7J2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?OI0+8c+asuN9VBxcAoenJmo+Va10yYG5PbFXr6jhYmJgXK9caOi7/Tg6Dd?=
 =?iso-8859-1?Q?PmMw88/TMiPk0Nrq+w6qAdv5jQHQX6MyznKsmEqVbu5jIkaQqHx13OjyMS?=
 =?iso-8859-1?Q?VrW3TGoahAwbr4laws3P7Ljlv57OIybPrNFFv5ZenZRhIIdv4vodDz218C?=
 =?iso-8859-1?Q?inXTSz4xgwzT42AvuitOdRcyB3CHFkRUkOQZ246Vq/MN5JpY+iR4S0ZGWP?=
 =?iso-8859-1?Q?IFVxpfqaRpWKfQAlODG+e85nHEPzxlr9ai6C9F6hl6m3z2Kmt3rKHJztPc?=
 =?iso-8859-1?Q?Jtl+GwKD3YjGh8Rk97ckPfYMuA+ZtOsNs/f5ddjMH4XCGwdDdWjF8Tk3RE?=
 =?iso-8859-1?Q?gzqm8SnaKurhc3hFytuGyGQcmCF9MoHjw4Jl4v94U1UgRNUKBNSR4AC43h?=
 =?iso-8859-1?Q?Cfya+gr+xw0CQlZyDhLvfJdCkWadCgSbVybZOajkpkGYOa7XVPdItJIRt5?=
 =?iso-8859-1?Q?v0jByGmjN4Axj+eOQvm57hIM/zrQ+8xBqhP6sr2vcKZdHUSDFKkgHlmufT?=
 =?iso-8859-1?Q?/waPt/9aBp/HaBcDT/Qhsddz3rxLzh6IPTzscYYaiXAvc27Hib307+pfhZ?=
 =?iso-8859-1?Q?hmdZ/MoZKNIrqOardazUAtUe5ZJsCfDKRs1T4G6Qu6namVt9Og+GwOVAcr?=
 =?iso-8859-1?Q?meTJgcp6S3LXzT6J0Lgf/a7vny/50F+61WEo/gYd8tC2on5RFivDUgzbju?=
 =?iso-8859-1?Q?W4ZrV8cKz/HsE5N633q0GKxaW69bc5R8TSA2GipzzvP0pQHBtorG1GaQff?=
 =?iso-8859-1?Q?fYQoICiHjBidN0f8nrtrw4RUCGe4quxam8P5q7HRjhDbvXdhdD741mwXai?=
 =?iso-8859-1?Q?/AJw7B+ErLsJegBAfJ50kR5pym+emVFeBPA3L9i3SnE4VjsvzWG1iQMKaj?=
 =?iso-8859-1?Q?y4wDoAFoy/tT6VojIk6ABwRn/H2LymEDipU7aRtRTJ+bgXzrB3RbfFown5?=
 =?iso-8859-1?Q?BgijTXSII1I+5Q3Du8gRCLSsN0aHdTrndmrbsL7g7tC7h2xBVLnr5q+uMk?=
 =?iso-8859-1?Q?lEe88dCOFqQiuMbeS1MNhDtbwHG7I4yIkzvxRbjfhZiYAv+COUghla9LvB?=
 =?iso-8859-1?Q?uLVsjxKPOoINVjBqw5qVRPZhBO0IyQ2xrUG8HxFD0L4/pglExoGRAH4ypr?=
 =?iso-8859-1?Q?J2FMqzNGLCp8e3w4CCeN+Aax4EdIcEOnSlNhf0MqHWoDAJ3JqqdY3VUAjv?=
 =?iso-8859-1?Q?jjIZO8THe4K4YWyucjtQOIZlUerhDgLliWm7Bqz0VfExq6gDH589MEQU8j?=
 =?iso-8859-1?Q?Dbd2jATnebN0Ln2UlD94VA4bTO2i81FzEV0eeZLFLjIkmZfLCu2lO6B7ct?=
 =?iso-8859-1?Q?X5WwrNaSeFDxhb3MsmA5HcPcTDyZ8zCFD9yPlQ/y4a3EjxM0oJZhEEFyBJ?=
 =?iso-8859-1?Q?qFlwNht5u5Zb1LnBK24w9Zoq5U8u6YqNtF4xrmW8t5rpxPvLoRD4hPn07/?=
 =?iso-8859-1?Q?qMAXeqvUxvTVXvMMmPjMSKy3qeqIe/+iAR5A+lJB4UAb5C6RoIhJnFaWfM?=
 =?iso-8859-1?Q?6Pzz7z5fQpDGda0pWmxmrif7NxE2MPl4BNvGgJUQ/zf2HczS4Sf/l2StNJ?=
 =?iso-8859-1?Q?rtvVsC0C6NJHsuRyKW66Eu/mQO/zu/Zn5PLJ7SqrQTcsysBVvpECcj6R9r?=
 =?iso-8859-1?Q?QIwJFpzPHNuig3c25LzhRHYv96fXP9liiT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6cde0d-6e5f-4cea-9cf8-08dc94de3daa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 06:15:41.9160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9w9H3/I8qiUTv7CzLbGCmTRONm9VUREttReiODYbTn9ilIGCOeaSzXwBBTWi7WSffriLARGylQAVyhdQaY3CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8084
X-OriginatorOrg: intel.com

On Tue, Jun 25, 2024 at 07:15:09AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2024-06-24 at 16:29 +0800, Yan Zhao wrote:
> > > @@ -1057,7 +1057,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
> > >           * KVM_RUN is unreachable, i.e. no vCPUs will ever service the
> > > request.
> > >           */
> > >          lockdep_assert_held_write(&kvm->mmu_lock);
> > > -       for_each_tdp_mmu_root_yield_safe(kvm, root)
> > > +       __for_each_tdp_mmu_root_yield_safe(kvm, root, -1, KVM_DIRECT_ROOTS)
> > nit: update the comment of kvm_tdp_mmu_zap_all() 
> 
> Yea, good idea. It's definitely needs some explanation, considering the function
> is called "zap_all". A bit unfortunate actually.
> 
> > and explain why it's
> > KVM_DIRECT_ROOTS, not KVM_DIRECT_ROOTS | KVM_INVALID_ROOTS.
> 
> Explain why not to zap invalid mirrored roots?
No. Explain why not to zap invalid direct roots.
Just passing KVM_DIRECT_ROOTS will zap only valid direct roots, right?
The original kvm_tdp_mmu_zap_all() "Zap all roots, including invalid roots".
It might be better to explain why not to zap invalid direct roots here.

