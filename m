Return-Path: <kvm+bounces-23431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3EDC9497FC
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 21:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DF5F1F218E7
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E383B82876;
	Tue,  6 Aug 2024 19:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jwdSZ/mN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D28F18D62B;
	Tue,  6 Aug 2024 19:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722971224; cv=fail; b=JAVBk6wfMpl8VpeTazf1Q4BWV/S80eMFdP+vAemWF4fNkyEcN6SjuHatGyWdPIz2SjBT8k0PUp/Dzu2FJUta7qYmLgfF/1wbENApWJuNkSB89vVqqghzFbpLGufjla9n74qIPBXOPptxtMHoZJ4vCDa4Q5LSuynGytx/RftE0Yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722971224; c=relaxed/simple;
	bh=or+5iSAnsVtlZKLVzRgjyow78tN+Nx4rTqnl6Eu96i4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XfpMHwYxWVnp8X2GfnGb5pNBNvxpw9m0l/u28mbRljUIScX7NvAge5izfn1eWmT8YRKF8lUZuXqHh3Y7wggzteEto5V8bBX25dkKosjlufX1C1zESur86Icuf95s6gYLUaoW2ndFLWNTwxhJ0llukvyEmwfAczWClFHLuYK7TtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jwdSZ/mN; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722971222; x=1754507222;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=or+5iSAnsVtlZKLVzRgjyow78tN+Nx4rTqnl6Eu96i4=;
  b=jwdSZ/mNao5U06kkDiaZ7B5fRF49POCZTNslvY6brabMuEPwiytCeCw5
   fJurClZnjX4HtdKqPC8SW5lz93YcN7jpKx1Jq/SllDGxaNlFa9y2nMosN
   s7HqyBkca6CjGrvTSHWSAvNj9PZN7fbQe3mSMKT0vzmnIbM6ePv6x/ubq
   OAKvMsHMP+xIByMDe3pkCIuNHOtKrc9geG7808pH21aaaTY/Gp4zgdCZ1
   l7cXfEl/lDaeG5YFSyTDy/ExK7cCpBqzN+sJ+2IqGNdimzD9Sv7OIPuKl
   NpyqV4JwefIBNHMsoIf4YxDzC5NRx2k+6O6TfvWNRIJA0LM0rujljHt2K
   A==;
X-CSE-ConnectionGUID: n1f7nGgvTVCzanPzaQsR3g==
X-CSE-MsgGUID: OKCVhWdbS02gB32jaXWieQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11156"; a="38465599"
X-IronPort-AV: E=Sophos;i="6.09,268,1716274800"; 
   d="scan'208";a="38465599"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 12:07:00 -0700
X-CSE-ConnectionGUID: c5JqlAG8QE6jxmbursce6A==
X-CSE-MsgGUID: 8ywkCc1ZSxONqZgElYNAAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,268,1716274800"; 
   d="scan'208";a="56310222"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 12:06:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 12:06:57 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 12:06:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 12:06:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 12:06:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L5OHyxd/4+60C3mv+BuLdZNqfsawj/Ayb1fqrcdkWXHdEkNtCKYUvWlTp9m7qgStaX2IT59Fy4Iy4RjxsZSRdCoS5CmTmOqVvpFHW7kBUbtZnfter1R/9osXXRy/JIRGomwnlGW9h5qpZuHUhsWTxNduNM8LQ2BDKoSxkk9ukA/A/WUh6reACOABgGsURMnkt9rr36/Di0WWS00wrksfVQFoyM7lMNdx61Sx2eRD20uChPnkkA7yNbKUv1n2raSwwtw5FkB5FGzWdgOsNSWRRVYlOZwo9XTZf0+aYiYbay5cyhbBMu2es1nP7jZWc6JdX+oPasEE6BYOYjgO4xKKXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xl5rMw5tYoFu6TyQPX0PNMS8Ecn7yvBYI/3fxaCObso=;
 b=UHOmQwKyLA9tOwwwyzyUGIoWxo5IxjhK81aDRzEq6N2uZf92Z6soM3ft6DU1Y5Y3oe7goVYO0fLd1qn4pj2P+j/o6sO2KNf9T+doP+T3sDtm3TlhS58Ej0LDkfKlNGVzDmW2YkJsiSH9fgbqIII8S/ZZBqXpGeuZF7QKOQAnGIF+RwNGKI3oLG0Vz68v6Dt17hePZHevXRvGMlzeZG1wTDiaVUIY9I6YYGX10kaQ5sgs6KawurzNq2fzDET8ol/bNJcyjGNjaQEYbTafZn4ivhRZWvdt4gQPVYhOr0XFSsQ/LtoHwBm91jggESSt4HZfvaQ4Ov5JZr/JipcoPDUBTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by LV3PR11MB8696.namprd11.prod.outlook.com (2603:10b6:408:216::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 19:06:54 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Tue, 6 Aug 2024
 19:06:54 +0000
Date: Tue, 6 Aug 2024 12:06:50 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 06/10] x86/virt/tdx: Refine a comment to reflect the
 latest TDX spec
Message-ID: <66b2744ad5b48_4fc7294f4@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <bafe7cfc3c78473aac78499c1eca5abf9bb3ecf5.1721186590.git.kai.huang@intel.com>
 <66b19beaadd28_4fc729410@dwillia2-xfh.jf.intel.com.notmuch>
 <e0447cc1ce172e1c845405c828cd3b6934b85917.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e0447cc1ce172e1c845405c828cd3b6934b85917.camel@intel.com>
X-ClientProxiedBy: MW4PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:303:16d::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|LV3PR11MB8696:EE_
X-MS-Office365-Filtering-Correlation-Id: f8443dd4-19da-4446-d8af-08dcb64aef66
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2itIkeYjZUIMnM5kADDhTc4KIOsBHILe72cVH2m1JOM483xR46XJOrU+OzPC?=
 =?us-ascii?Q?mKQzjIQuAPtdGdOXM6ewRDFm+qTFUnBFI9WN2G85R5nxeVpPpxmNm9Z2sRom?=
 =?us-ascii?Q?g5vm63oZ3KfyViRfgQO7lPaRLPK9bC1NkHfxIBhKrkoEEKHPyse24e9BjcfX?=
 =?us-ascii?Q?68RTKMxO84NOLUpmjh2zp6su+H58X/hwxCDeo2cjcz3iu2rH+HhoKiK7kI8q?=
 =?us-ascii?Q?GxxNqyuoigoAUvNuuHxIl05Bubl4xOTCIRfb6cVlIK7qJJ6FTZ0tVHx479rk?=
 =?us-ascii?Q?hrT3BBc+UQmtIeJIzHDj+mAUITdHho35bcZKmQjqFD8yHXhrcIkPyNDbIICt?=
 =?us-ascii?Q?K53wyV1T0htx0BRYIz+ftlMZti22XJder6nslTYZbR178NQkx/KnGXrQnLtz?=
 =?us-ascii?Q?rdOFYg1J65ccH8JL4Qv7Rb4VLZNE4QiN4JOgjCYfnIPV7JGQkIdHkndrJ36g?=
 =?us-ascii?Q?JB7RZQi2PILNeS80sd5n70xs9himPsxidkw7o/W445c4DubJrZWiB8WZXciQ?=
 =?us-ascii?Q?YdZY8ZGZ4Acyahmbr3Kt4cOXHz/vdakPbEGM9s7pro0WX1XsuhdJFtcYWtRv?=
 =?us-ascii?Q?1MsfmA24zxrNvQsYMJUidAyqFTtSEwZLKPiYt2V00xUGU1oEZ59IjdjuYpbp?=
 =?us-ascii?Q?/Azq6QFOl/GQWJhQJjG7RwcZJu2VP/UFTPtJ7WrEtQCR1WSVZeOVHPXbgE9U?=
 =?us-ascii?Q?RC5Et4q0rcsC7IunXqoT2/zlkaE7r1k6ONICcvpbHLgpohTbi6IgDQbXdhxu?=
 =?us-ascii?Q?yhf0oVtdPYkiKQALkrZ3zNgFI4+8m2eJbuMOg422lfSDHxdADt0qmrBRd/nA?=
 =?us-ascii?Q?iMZwT37u82JnIo6qE/VAG1GYksrJX2dmKa5o5nY53rGBSaiN1QjvVHb13KHF?=
 =?us-ascii?Q?k9WyM/sgM6+FN75kebJcIwYDjakzgdvny7g+VOrb6hdiy965AxLu5Plw0vQ5?=
 =?us-ascii?Q?Gpa5TnbhGXLcto1zJCcqWMFVRVtviuHTZF/E9/6qOCnDi0zAH7k8QmbK2mBq?=
 =?us-ascii?Q?3/Qrko2h7daLGPca/KIqcpSqon7H6Y6U1wx/e8wVMiut8WXp3IHNqUerELFs?=
 =?us-ascii?Q?v7nKTdX3r29RpxvVrdOVv7wiTyuPH1RVKnl0G2bJtS3jfhkOUEah3Zljb9Fb?=
 =?us-ascii?Q?mb8bqL7zAYoL1HfBiOvISwOL8a60S+TN5AT3BM06Xn3UPnIFhUm/C04GdWJK?=
 =?us-ascii?Q?wupnB5aduEJhLCukWdp1BZLz86jNHiIqeF8HYZeB51BPv2i+FgRiaQRpE7tH?=
 =?us-ascii?Q?YzBO31isDtB63mjZ4WgtBO5giE7GgX882T9EFLkHShMbUrhlgiUMQv0HdLw6?=
 =?us-ascii?Q?Q/mClazFvH/tW7L8hKDNu5aurPJB9+7+92RJJl44iahuS2dpPCgSomVd4art?=
 =?us-ascii?Q?WTPvCuDoAadfM+q4mop2SQ8elqaU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sw9ouEREcV+FpWFF/0ycgPFIeV3qQ7pvIR3B1/knRD1RT8Z5ARD9V+63VQaW?=
 =?us-ascii?Q?D5ZdHZyTiw9f4Kp1+xgR94yxVr0V6FQ+b8OkwWtJKJ0KUIpL7NaZ9eQy9yx5?=
 =?us-ascii?Q?K52INU4hJYYuQhM1bwDXXm0gKf38OwBQBAVRJtu/ju0h7T9bzCp9gmsdg4kp?=
 =?us-ascii?Q?3G+5lEuvTgah+2wEUMZPTrM4GtEOzgppTpJCNzfzY/iirmpwpxfZqONZsMdf?=
 =?us-ascii?Q?/4/wsHpRh4ld2+v2+0pnFLrtDHiTKYMXFF8dwdVhCFFl8T0Bawtt0ucUCZpZ?=
 =?us-ascii?Q?97rpKqYb1OoSZBDnXRVz4577i/ZsfSkDWhTOaAcJfjF2ykjyfhuxH9Xkg/Q7?=
 =?us-ascii?Q?7LXv9BrfsLfBX1q0KxiIY1NVC3RCQb7F6iXN4IJZCTlgNI/hx+yPEzsxzKYQ?=
 =?us-ascii?Q?yUv/SaDRyWeeUZhELOgboQe2wqGwh4fOo9lAxyvhe6JWKqG+ZuI/ktOjmInt?=
 =?us-ascii?Q?ZddfzGfHvOZDQ1gNsycxDK7OHt2J2D3d3Focftga94lpfL2CiGrNFFDr6/xS?=
 =?us-ascii?Q?MCpaAUE37Lk8kktRRLzPbUfynfY9lcjm7lseAVQxxV1XUfP7da2fG/BeL2eQ?=
 =?us-ascii?Q?IPhLGUOMpfmOAGePtduHfHGkzPmN49yAyT0KGyLbS7Lwo7H06y2szFoIihMT?=
 =?us-ascii?Q?mH+CwSYB4n31KKEe3CvvRfB5nPOiwLbrXt32x+BaNPAQ+mvTA52QifnVqoof?=
 =?us-ascii?Q?M3Wid4a46Ymhx15zbEjIZ5cNL9l66Sbe7UuwC36p/g2ySAeKUExPtmoew2+s?=
 =?us-ascii?Q?fXlmlb1H88nGD911sIM/9dnM7I9mUcK9yQIn1w8UZRzjnFEU5J9zfkHin6px?=
 =?us-ascii?Q?LRuEXohVqTt+bqfXrq7N/N6n2kCRWXvR2OqDNs8V5hogmRbx5JUCdWbXO/so?=
 =?us-ascii?Q?NGrZtSAVKzU8saY5kLYXyJAWxDsxkM+UNlmTAT1EtQXm1mtPB0i7Dz7IGIQe?=
 =?us-ascii?Q?mnuqvg3Lh2L0RzJYeWVNzopwp+7RmTtCc0XEPUdHYQiL2qGxpc4JuVJAd8TF?=
 =?us-ascii?Q?ekR2xZH7eIejxV68WY2dzJNqYUfxC+A1/zuNk5o6pMN/mtLqFXtOfiDoOavm?=
 =?us-ascii?Q?f9oKUvhfKZgN5KPLMLzOnEX43PL/S+soU9ioBztv05+PDyR8H7smlIIuInLB?=
 =?us-ascii?Q?krfPW9gUZ+DhSV6+FzYVkqqFjCHH1fiDyBUKf4SuaRZYvwbcG+Ga+V3ATe1Y?=
 =?us-ascii?Q?mKEThKT4ZHR6qYz1e6ExtTT+f4Q375liE9/WKCTQvvUOJl512SMp/+8kActX?=
 =?us-ascii?Q?2jAqKHE67q8cyRTlkbTW1aygMWLOzOKV+a4j8jA6MNSs9bpMkNIuspQmXr76?=
 =?us-ascii?Q?MJnphNPitgSlZFEDqam4kQye2MTTRyWPsNnzn2Gzbw7WHtGaODbcrQ+CBCzQ?=
 =?us-ascii?Q?6M5vaLxrV7rAmbfcO2JGWAhosacBdEDgQwKlxr2IMXl893nL6GE66vgjimqt?=
 =?us-ascii?Q?o1SD6wSCJYtByo+7WuyEOtt47CT2V8+MoPF6QVMtucN11d8rnQQawuHucG+8?=
 =?us-ascii?Q?0QkBcAhEAEFlX4WNzNp+8JXY30nk6GG0dX8/lsxfOww5XUwh2/iFP+I4gK6B?=
 =?us-ascii?Q?kTmjx+PhSiXOrxf1RV6M+5dPUfQBbqOyAFTi3Ak0+m77c9UD9w21SPzZtQA7?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8443dd4-19da-4446-d8af-08dcb64aef66
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 19:06:54.1282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X71ZOy/95o5M8zmMrdYeLc2tPmUR9fKQZoqwnGF4sKDi3doXWkb08UkKiEEsVlbHczlP8hLWNYJ1LzOC3LLj7ioKnqJ6BiHFOFPH1n4/veA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8696
X-OriginatorOrg: intel.com

Huang, Kai wrote:
[..]
> > Given this is JSON any plan to just check-in "global_metadata.json"
> > somewhere in tools/ with a script that queries for a set of fields and
> > spits them out into a Linux data structure + set of TD_SYSINFO_*_MAP()
> > calls? Then no future review bandwidth needs to be spent on manually
> > checking offsets names and values, they will just be pulled from the
> > script.
> 
> This seems a good idea.  I'll add this to my TODO list and evaluate it
> first.
> 
> One minor issue is some metadata fields may need special handling.  E.g.,
> MAX_VCPUS_PER_TD (which is u16) may not be supported by some old TDX
> modules, but this isn't an error because we can just treats it as
> U16_MAX.

TDX Module had better not be breaking us when they remove metadata
fields. So if you know of fields that get removed the module absolutely
cannot cause existing code paths. Linux could maybe grant that some
values start returning an explicit "deprecated" error code in the future
and Linux adds handling for that common case. Outside of that metadata
fields are forever and the module needs to ship placeholder values that
fail gracefully on older kernels.

OS software should not be expected to keep up with the whims of metadata
field removals without an explicit plan to make those future removals
benign to legacy kernels.

