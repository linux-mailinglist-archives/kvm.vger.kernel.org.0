Return-Path: <kvm+bounces-26611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74692976030
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 06:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 940301C22DE4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 04:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A32491885AD;
	Thu, 12 Sep 2024 04:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iB3zPdIU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E575BAF0;
	Thu, 12 Sep 2024 04:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726117007; cv=fail; b=V/AiN8jOdYrbmC9IJpBocUEDdhj2FVvHx2BkDx3SL+IWMF2xAJ/GOenpXSNok15Xz+apGlRzXFmKt11LIDLe/MjlXMLhDK+EFe1CfLrpLzYCqKwtq4ikKB6ufTKmFetTMMl7c2J4YcgHlwy5ECPnZf5HUYU+xnBjYVD1LCu42ak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726117007; c=relaxed/simple;
	bh=KE0SyzoB8YxU/wQZPmCP4W7uuVLCSOJjvgqEBkMrW2A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jvBqoHWCgZHhHR7KD6hpVMzjkkfmtY9rVa6GFn7Qt1dTGDL4dMyIHzeh0t5zS7SY2/mLu72SrcX2ltt/H9BWJEM4sPlYvnSGUQ48duicf2xnC5cWZowzT0yqdHTkHbC7vpDxXwYCvDm35ci/NWx5nOSvwplyI+6L1z9tTAnEQcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iB3zPdIU; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726117006; x=1757653006;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=KE0SyzoB8YxU/wQZPmCP4W7uuVLCSOJjvgqEBkMrW2A=;
  b=iB3zPdIUkyFXVtELSYAj2lA1Rz64NuOLNZbWb+1A9Ks8oQlVP+iPZt5x
   FxJ3zVaZ1gn7WxZ2p0r2wV4jD5Vxa1cHsN5GDImNe3xGRY7BvCfd2kjIH
   NjfHo/3KWf2kFuggZ0BooWI3PO5poFhXN5XvzWiw4kYOwf9iMRdKwx7fc
   R4jZg761IjdlqPFqCOL+P0ODq2wWfr9kkvo1tEMdPBYwy8xL6P7Jr7vFy
   TyIb+YthAMfCyBQ81mzSgdGvts8Xplb1kDRwvNOcgo/nakQcprLssAER+
   L6NUIEi4krNaw0wtGTwaTap/Jn43mIikmbPo50VQXj2I06zgCGtBjB/1P
   g==;
X-CSE-ConnectionGUID: 4ERFIxJMS7aSiCzDxniA6A==
X-CSE-MsgGUID: xg6Ng1IPRzqXQ01JJslRoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="24435929"
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="24435929"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 21:56:45 -0700
X-CSE-ConnectionGUID: opyxqz9SRLObSUOCEOldGg==
X-CSE-MsgGUID: w+3EOKirTiq9aHvrrvveMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="72368367"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2024 21:56:45 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 21:56:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 21:56:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Sep 2024 21:56:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Sep 2024 21:56:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k6uuylzQv8EsE+tn0RDl4xmX7M72BihIyhftR3KOXzr28vNFWCRVxCpU+jbSfBOxNxPDSQKZN/zvLrcp9fIrhELB/wGJcoFzgev2hDuqEibtan+vRKQgIIN0Eu0ZeeKrBLuytP4ctRWjVnGeFBVlB8igsf5JD2US4x+HjlKOU+aacEE+SpLTgEAkVFYD16FZgLyGYHQUVYYW+oyhfoa5oADmk4QsEiqRpjWoeMh0e27bl8QG5ATrIFrn8pZG1ZDipxEjnu+hUKiGpLgClSMQR2ivZXGPyFIwWHmAnK/+eIoYuodzVsVju8hpnwEmrqnqo1nL1ntM4tBzOI/b7dmxkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYQvmyaHNMhOYyk2kZCGrFmh0208NjKLJJhMVi6AJRc=;
 b=UB9St/mKY7WMWK1XnBOjVQGgfhihmrwhp2DxK6IRtCvz2Ab0vVqH/z30JDLP/3Yi3tldFgVYx+sgfgmZs4mISfn4PYI8DFwWA/vuQhNGSej6l8WUJ94hms5vwb23KfxZCF9umxf/8zLXgX5AhdVV5HR3e/ai/EgnKSo36pTbc5gSqSo1uIpl+HOmDnt088pOJkn3MHHZL3KNQqakqTwEakN2U8v/Br641ZnBbOXWeIEzAKszykUSM8bHSn6+W7su+bFp62w2JeULPvcPJ2FY/MDuFZ7voOK/TnsYeIENgGEpkpzzzKfnwd41Y+c+pkfPliwbAseS2OR3ypDz4PVySQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8139.namprd11.prod.outlook.com (2603:10b6:610:157::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Thu, 12 Sep
 2024 04:56:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.7939.017; Thu, 12 Sep 2024
 04:56:41 +0000
Date: Thu, 12 Sep 2024 12:54:43 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "dmatlack@google.com"
	<dmatlack@google.com>
Subject: Re: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Message-ID: <ZuJ0E1JeRQrIboBp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-14-rick.p.edgecombe@intel.com>
 <ZuE38n/yhI24vS20@yilunxu-OptiPlex-7050>
 <6b9671bfdc7f1e8dab0ede65fa7c7e76f0358a06.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b9671bfdc7f1e8dab0ede65fa7c7e76f0358a06.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: eeeead03-f28f-4766-0239-08dcd2e74a84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?zkxSK/aQdjfVBzNvvO/nIk5NdAIUPzO3W/B1bncU/5H16209D9yCM8C6KL?=
 =?iso-8859-1?Q?Vkwk8wfYAF+IGfORW2BIZKy8kLsCK606RBtA4YIMCRJL8YBiIzLWqk11FX?=
 =?iso-8859-1?Q?ocb6UtTOSRvwaUpS8AdnbMp3qgIBwKURecZLjBX30D2kuNNHgjCjX0ZRD5?=
 =?iso-8859-1?Q?SBESgFB9pZolIVt9UZ5bDrnsMYUIR4sJwjQ11uoizW9VbMdh28HhEN3mYG?=
 =?iso-8859-1?Q?uXRW+bx4y+ExghRnNMvH3ZZpuj/jRvxflCMEHwFsWUTyZ0886t0Lfepkng?=
 =?iso-8859-1?Q?cmvwD7vRJynhr4sOQVb7HOJPTPgvBxdXGv9Jm3jjT56iivCaSQIt9ya2nC?=
 =?iso-8859-1?Q?tr6/MbgyURBgfZ8karr/ZNOMJq/r1LhiW0ZQ8xRydo8avvAthmYWoH1Y0A?=
 =?iso-8859-1?Q?MLLnkhmexLvg6c07VC7pjsqTyAz0mCbi21v7lwmmlbZdxVBZo4pICXR7XA?=
 =?iso-8859-1?Q?pij4yyOFjVVMUPhwCOR2r73Dz7dfZZ93sfh/OA3osQ+/0ymMKqLZT2sCMu?=
 =?iso-8859-1?Q?eejHE8lb106jMitfXdMnXn8iLkGNkDHuGI8DDBz9zrO+6NB+QcTv3Vj8mV?=
 =?iso-8859-1?Q?Pjx/S6Ico032PosCGT+bKJ6JGmgNYsruYuzbTvwHqjEJb4djZKBnOT51W4?=
 =?iso-8859-1?Q?+5RvWJDxFrmCssrWGo+e7mYryTIfDsvHNyRtvbOWLmg0VXKZQhKGxvf9VO?=
 =?iso-8859-1?Q?G+wOvTITSTnhiWAx3GL/dbiRYini/7Slralh23vUT8NJd1peRzlUJSvEDa?=
 =?iso-8859-1?Q?IaHrgQemwHTnWU/to74aCqfWK+K09AU7L04DinACnPebV4GHVEAs5Dv4KY?=
 =?iso-8859-1?Q?9Yq+a78BfvpnA0ixyp3K6pt41Qp3p5EN2R1s+SFNFsc1FPLZdJtcRB/L0M?=
 =?iso-8859-1?Q?H5KSXcdisLqJqTcqplq6PX5USlgVm4+ziLhl+IXhQqaBCtjz2skgOgi8Hv?=
 =?iso-8859-1?Q?RfkB2M6XbV48BBTVLXcaEaPv5r0r0sgmuq28dT8kc7kTmGQm+u1YlisfyW?=
 =?iso-8859-1?Q?4omK01K5suR7Q6aWNyHZgQUtxrepHL/BI4J6EgrJkXZTKTsT+tB8Fjtbqo?=
 =?iso-8859-1?Q?ei+BRpk86S57QNl7ORNxyfZEGNrbK7oEnPeH2xWKhYT0fxdQGuc53Q9Evf?=
 =?iso-8859-1?Q?en/CLKNCIvl35zCaaGMkaynAAxJq1RSwHSMVuloOIi5Bz05wpRVADKMkzZ?=
 =?iso-8859-1?Q?WLHztXLmI1Fo46XrPkwL+Xa9A7I4CjXAloTapshRMdxPmEy8Ie2sY8PJmN?=
 =?iso-8859-1?Q?dWdVRrM50jl39N5S/98JGr2u+7LnoTG4O+Y5L6BnLhEYkzci/Glx3ZvFDa?=
 =?iso-8859-1?Q?xi4NCdF8Wv/BSPe/kYjWp8VULoBL/Lehw3liijEvZiX7RxPp+oh6DsQxI2?=
 =?iso-8859-1?Q?3ilnoCKzRiuwi7KAKyHohf1VhKkzXQbQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?5u9rBrnyf4HIw1l3oFV/AGI3QHpZFOt6bwqpeojowyLz9v7rVxyG7v38zJ?=
 =?iso-8859-1?Q?ls4i0viE9hXyYI5boja7bryQXXB/aQDm/vHEnNPQIonlN9bEdIkiBIZIic?=
 =?iso-8859-1?Q?kGWDEuLKPTbICjrEALqtUam+soiGtvk3gEsUKlEbd/2qQSYvxMIqVwZs9X?=
 =?iso-8859-1?Q?leRF3NHR0utszfsIcW028qaYUmQU3PXW8NKhzXqisDgqoWfm5HcY1GSVOL?=
 =?iso-8859-1?Q?o395yH/vYu9sqDRjlGLwrkMUW7lVvaEynZsF0WOr/V6a1+8i4U4PMfFGv7?=
 =?iso-8859-1?Q?7Cx6LKLsiUfCg+L3QDUzLyAmJNW2g478/pgCdYkH4X1Q5P3PacGyDi2IJF?=
 =?iso-8859-1?Q?0jRAgzVpxIGfBCh8q88vLLA2MKIdm/cfa/yX8/EBqyoITQwFHAVb17lREu?=
 =?iso-8859-1?Q?Yu0ri8s/F1CbqpPiQk9q9W4ILKI6zyo10wB9EYHVntOcz8wU10qeKDpHZa?=
 =?iso-8859-1?Q?rSJNQRd4aVTU+VC4xbr21fZLX/yyJEcijGuQx5JmVuwvkv6e7jd9NRspYV?=
 =?iso-8859-1?Q?pI7rGgnARMevme72TLKDrfdNeNgFCpgw9SKAallTiAejFtp4KuZpObDLky?=
 =?iso-8859-1?Q?Yu2PI//ZgnmJAioKqo2OZH0rW7xbNL52INcVqnaHEDbxgm5rg1FiqDn3iX?=
 =?iso-8859-1?Q?WhtVJPKNQmGWGLxLt5kOg0ole+WIQHRIX3PYX3ymz3A327+tfV/ENvxvag?=
 =?iso-8859-1?Q?hGYsZ+lfgDrZ17PmZbL2Pq0goc3JV28b7ypNmssDSOiozu1x/XuJY/Wrp5?=
 =?iso-8859-1?Q?4MqfbMYwjSyew7lzz2lexVJGAFz07eThKTxhG7W6ov7tdfC9yl2ka4C1Bd?=
 =?iso-8859-1?Q?peHVw7kD7xYeoXnkhMXm2HY9HbbuTS4iPbvim4zZY6/kooMv80C5NTRL+n?=
 =?iso-8859-1?Q?ZTLh2CSaA1KKR9kRpt8JbwPheuz00KI7jMMAiTqceQkHd2eotYEFFy9S4O?=
 =?iso-8859-1?Q?1O97FvSD9Bw//Ye85JlBO95gBAkgGIjS45GdRIynhlj5VKG51Az2jnM7wh?=
 =?iso-8859-1?Q?BEw0pBJm0s+uQPAIPD2iYFcsAqBzUSKPBeC6iw+JN7vOq5lcgsG2a6Qe7I?=
 =?iso-8859-1?Q?osBk3wsfxOY0HgBeEnL9sq94lcJ0FoBMWZnjl8zTwpdBKYOTwJ44C2GdIS?=
 =?iso-8859-1?Q?opzSC2K4AJz1u56cvrztCKwlmKu+tEEJizGxVq+OoTRuWXgRM5DeavpSK3?=
 =?iso-8859-1?Q?9Iif1/d3lLVRxmY/N62uzVrYqGU/gyzeylent26xJvGJmQXWyTM1ddENP9?=
 =?iso-8859-1?Q?u5H7vPtTIm2CrXC6uZ+5NyyPZzdvD73NSSEF8x9CzLBvgyQkWAKbYiAIn1?=
 =?iso-8859-1?Q?X8Z78QKWXQuf/KppASOyYaRGmD6NpUolZ0d9l53EtFeimsKbBNfKWDC/9h?=
 =?iso-8859-1?Q?tPqYfUasi+7pq/2V8dCn4wOaOWv53N3OBPhpt3D9+s9P3opNO7X3cqFZQE?=
 =?iso-8859-1?Q?q3vo6ide5mUav5jMxvvSvT9x8TcKi4EtoDGGPiMcOgOCHJQaUr0co5RkVY?=
 =?iso-8859-1?Q?8ttKPAnbMdPItimxnPBOiNHpT+34FOXHdgDudDoPnKiUk+poA9PmKmdWXp?=
 =?iso-8859-1?Q?bnozVM/tFau2tMt6soTSzzDuWydu8/0ZCVfvEXLU1iCL0k2hylUUD166aM?=
 =?iso-8859-1?Q?zqsvvxZu0zTT3G0dEJN9FEmWiirpQ7fc9e?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eeeead03-f28f-4766-0239-08dcd2e74a84
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 04:56:41.0422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkHY7d+VvtgBZVCQYDMVIMO4vt5iUwgKiHuK6dw6ay0co24hu7kGI2dtH30B1JQk1vUFvVaF0ws8AU8AWMb8RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8139
X-OriginatorOrg: intel.com

On Thu, Sep 12, 2024 at 01:28:18AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2024-09-11 at 14:25 +0800, Xu Yilun wrote:
> > > +static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
> > > +{
> > > +       /*
> > > +        * TDX calls tdx_track() in tdx_sept_remove_private_spte() to ensure
> > > +        * private EPT will be flushed on the next TD enter.
> > > +        * No need to call tdx_track() here again even when this callback is
> > > as
> > > +        * a result of zapping private EPT.
> > > +        * Just invoke invept() directly here to work for both shared EPT
> > > and
> > > +        * private EPT.
> > 
> > IIUC, private EPT is already flushed in .remove_private_spte(), so in
> > theory we don't have to invept() for private EPT?
> 
> I think you are talking about the comment, and not an optimization. So changing:
> "Just invoke invept() directly here to work for both shared EPT and private EPT"
> to just "Just invoke invept() directly here to work for shared EPT".
> 
> Seems good to me.
Hmm, what about just adding
"Due to the lack of context within this callback function, it cannot
  determine which EPT has been affected by zapping."?

as blow:

"TDX calls tdx_track() in tdx_sept_remove_private_spte() to ensure
private EPT will be flushed on the next TD enter.
No need to call tdx_track() here again even when this callback is
as a result of zapping private EPT.

Due to the lack of context within this callback function, it cannot
determine which EPT has been affected by zapping.
Just invoke invept() directly here to work for both shared EPT and
private EPT for simplicity."

