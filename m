Return-Path: <kvm+bounces-70687-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0fKgAkiNimmZLwAAu9opvQ
	(envelope-from <kvm+bounces-70687-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 02:43:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9495F11607F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 02:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 533F0300DED5
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B432278161;
	Tue, 10 Feb 2026 01:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gDLOyqS8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5BB17B418;
	Tue, 10 Feb 2026 01:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770687807; cv=fail; b=dzaAWg8KTvRBaH76uxR1PLGDuEPDnIYja/7GWXFyVGT3DNbZdRHbdIwZQZFEBzzMmYHsAEHf4/IbKc93YcZE+u8RIvho0AfKJafvurE9w1WvgaQaJHUAGQ6yLYRcnfj6v1ulTdzRa3bikH8wjrAD5+Yz/LqsUW5T3C5X2XDkGZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770687807; c=relaxed/simple;
	bh=gofJ53/eDmvn8mMpVwQvNfqFlYVe8difXRmY2G8dyYs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eDZXsCehw6sSaYugAgojQdG71a+AP2eAAG2ny16RE8BxUGnDV5wqSBbrbrTjPol1fhM/HD/+hm8GCITXPvI71JCS9va7MLnc4UtsV9XaW806H0fO2dEwJb8Zz4DSZWoctlUkHbzYnFrP1PLJnD/okYDf34o6ywKELhEhnE8sB54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gDLOyqS8; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770687807; x=1802223807;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=gofJ53/eDmvn8mMpVwQvNfqFlYVe8difXRmY2G8dyYs=;
  b=gDLOyqS8O73zKzMIHTOOoZG6icdcdc6wMLrvQqI5wpD6VNhYXeS7vQkE
   YXJIaiM8IDwZDiuOKdtYAFbMbB2tHKoMYapoLf8rDKfsAZOf8Pa0CvhNP
   +9m20ZBUeR9PEYa9eIqwcFLOoXQmsfMi8eo5sV5rmI1MUEGd0T3ZywfRx
   ODC905PLHw/nyeVRTXpAO4M/OIh4cQy+EM3PngoJwVZjdex+vc7mdgjac
   Hc8BW7ira64Cc/kNxw8w+08LEoo8/1dz/O10MrmxrvFP4G4fHF4mNShT5
   xgWe3IYaTXEPFluCnFoAIW/kniSpJ/1Mg71mSsOBVqH4qE9/yVNdrCrS5
   g==;
X-CSE-ConnectionGUID: LKj6nI8sTL6rtD2wsugeRQ==
X-CSE-MsgGUID: n6W85eESRbStr19oVPWyZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="75433953"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="75433953"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 17:43:26 -0800
X-CSE-ConnectionGUID: 0TcN+uKxSUaC7PzehJ/2Cg==
X-CSE-MsgGUID: 8xkZH8QORgaB7dkWium3QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="241814854"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 17:43:25 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 17:43:25 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 17:43:25 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 17:43:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dbh1pVUpnLKHp7ilDXD0CFh+gEMwAF+Wz7k+2+5Yz5tGh9YZZKyhuUgklcbBXkb5LwcbViz77xW63v9zfCaW38suCPB3HIyS0LWnLZVPaW2QMTTSY92rl83hsX0J6ji4B6NrBTju9wz+7v3wJf8EP35yhUCGhBA0MuX5AA7HdlX6WcXJoVzakE+rkVMOIOqcTEtImOm7z9bk7sSK966DAqZrKmuveVJ42gQ/S7fNGoilITqEvdEjbWAClQBM3QKQHQs4F31Nby7hdEgwAX/jRrWetVVKZm+rXKmwDaetMhz5oBHIL6Kuc19Ps/Uj+xlWKoyIxCsYVD7wKmeg7AMQgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Aq8aivxCYMb7GAPOMk9/PSkMTalIMnkLjXmIOuolO4=;
 b=IDX1xrxKzwvBV+R4AAvb0omVL2ak6VITL1w9awCINKwrWqpPm6yJ5dCfYFK14OjTA0/E4Uncztlagwc9sIh5QiFIyU/4gC/K3SCirt4gf7pNiOZ/jtDrq/pXr/y+VgnvgcOQSijMCi6l+0+vWIH0QRoUsPiWb7ESA3UhCXTvKK9VDXoPYTZBOBkpnGMYArqH4CLNP+auLeDj5+DYLxLPAPEYJx0KkR7s1WLEpNoKM47Xiq4l524gE7nVSIb6Nl22wmbMGJYj2TYDDI3l4jmrU4WPIg5Ixb6i6vntvdm7GZNxPOTq+geid+bUvdQXN/3ilR+wyUCNnH7+Bvrybfai6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN6PR11MB8169.namprd11.prod.outlook.com (2603:10b6:208:47d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.17; Tue, 10 Feb
 2026 01:43:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Tue, 10 Feb 2026
 01:43:22 +0000
Date: Tue, 10 Feb 2026 09:40:57 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>, Sagi Shahar <sagis@google.com>,
	"Binbin Wu" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	"Isaku Yamahata" <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Message-ID: <aYqMqRwsNSn3Slvn@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-21-seanjc@google.com>
 <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com>
 <aYYCOiMvWfSJR1AL@google.com>
 <aYmoIaFwgR6+hnGp@yzhao56-desk.sh.intel.com>
 <6a5e3e9f-69b2-4416-9465-92a859034391@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6a5e3e9f-69b2-4416-9465-92a859034391@intel.com>
X-ClientProxiedBy: SI2PR04CA0017.apcprd04.prod.outlook.com
 (2603:1096:4:197::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN6PR11MB8169:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e2b1d67-4aa5-4a26-3b87-08de6845c671
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SAfRPU/cDipyUm0wFW9i27N1sPci+a59fHxiYk2iwl9B8m2eOgm/mrJamkWq?=
 =?us-ascii?Q?9Y4nSslu7ROkBQF9CRsm5xuclmhWILt6F0zpB/QNziDR/tOJhIWJEsFGptL1?=
 =?us-ascii?Q?Dcy526hnE3NHOe0EgdvqOQXECrsJJ7Wj/rxpCY4mvx42oumsoj2sVvdv8SrK?=
 =?us-ascii?Q?gUwmeiYwnqoyKMoagrNUiv1Gh2go1I74eHOik1xdkhX23CT2G3+h/VonHLdc?=
 =?us-ascii?Q?snCpcwwayAQ/TRrfW/v2zaCX3cjsN+D1vPCZNbb5BqJrgXTf32ZzH/dW3+gC?=
 =?us-ascii?Q?eVOUEdSYQ/J2idasmt39rtFG2NEbJrUcw4ilVFUpR3BM98Xvcre9D6+/lTW0?=
 =?us-ascii?Q?mcXy//vLBVKqaz784lzjwTFY96kgRTd9P3FtoFQ1XO3mpgPo17S026Fx0Ydq?=
 =?us-ascii?Q?hyPofY+bZJWMzEK0aErojU3qpBaAHnImRK+QEnoY6WsceQIngvdzxBeb7XQf?=
 =?us-ascii?Q?kLo0KA7DkNIg+VuYim+/s617GxJZQzb6Hta3QIobTZn8+lQWZq8oBOR4hz8G?=
 =?us-ascii?Q?G1P0lK/Zxg8QakJGDKxI8cI8pkptOBRBbMsBnmEOFRe+xHIIK3710HlXVg1i?=
 =?us-ascii?Q?uGcui2YIy3fVDgogWrufL+qgWSyOyYRkTcYAYS9BsoqMLTv4r0oW/E+pLbXd?=
 =?us-ascii?Q?tMs1AeS290KbWaaxxfvSi//THSqmb6gAobD9JnRmif8ROdeSUMKpCFh7MhUF?=
 =?us-ascii?Q?5X2gDl9teL6WASY5K6bQarzKUqizJiD/8FeWdXSDtyDNcw1yFToQoUAaVD5A?=
 =?us-ascii?Q?0h6EDjc2gXThW6/l0yz67ry9n6bZpOyLZHuregwgMf159A+JYpEJjKGre5sX?=
 =?us-ascii?Q?dU7vtrWnVunqrZHqTuPYzkMOpU9oOosBQn6vEOR+GMjbXtYwYc4DCwnB7V7I?=
 =?us-ascii?Q?nND27aBzLrtHuIi8BAy5iTknRFf9p4/c6elbW+gCUpyBRhhVjbkaN2NRbizE?=
 =?us-ascii?Q?LErA6kKbGfcm+W0NasVKWf2uzNukixqo32LHCMK4P7IG4bHzAM7DVFAwFlQO?=
 =?us-ascii?Q?IE2tVgYwW74Rk6bkP+VTUXOlftLJAPGY7Rhcr79SZDqMaAHO6kSBvnydaViO?=
 =?us-ascii?Q?rJR378PVx/f3mDv0ywpXvz1DFHW6+JSiKuqcX4/pIVhVpFeW1BguJoBjSnVl?=
 =?us-ascii?Q?DpmZz+IVbe1O4Wy9+XXRgxWvA0OZwisKL6PZiAh7fMqVmIf7Tuf6RGv6Dufm?=
 =?us-ascii?Q?nd7DcJ/WdKwc3DHuprcTREKj4Q1qOTOvwM4ZQkYOfDstME0s/yROzFqXEAGA?=
 =?us-ascii?Q?blBn2EqXs7gF4As5aPfFhoiIiGYPvnSdnj2KPXZHc1Do+cUlHx7VGc8ykSZR?=
 =?us-ascii?Q?Dd4vt1G0Xq1MAifaoW10W6oT70O+3atRw1WfbDUuxBTZDCLt3YWlJ47UC0c/?=
 =?us-ascii?Q?Zqm39/KhZjPh/jElrUETOvbfRAsXEw4IiACJboSamNS7yOU2CCkmgRYIgBDh?=
 =?us-ascii?Q?Obpu9s/27l83mbHw1aSLA7VTV0ps4Nwl4nfoAO0OnMIEh089ieWJXkXC7o+8?=
 =?us-ascii?Q?e11wz7AAOTzh+OZ8iUGMeF5lxQptHe0AKyrRMDHHjX3iKGipxWExI72erquC?=
 =?us-ascii?Q?FoUdV7dHIIEJeyzZnkdt5+nahQVEdwDVGrpfoKMr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YvjDpaXUpqUr8OGzc9h87XFQPS/wMk6SQJ+O309GA0O1kMcNHaYsjvwTOBbS?=
 =?us-ascii?Q?hQByvcgRr026ykIJI7YOc3OOXbzyP3Z6tshm5YycsQHv5zFtkc+0dCZuWTxX?=
 =?us-ascii?Q?aDagMS4J6OlWoWzBsvfF78o9n05uumBlTWUGdJWVg4GMLVcOjHchvd9uGhxk?=
 =?us-ascii?Q?2YFJO90MJkJ4q11HF/E5eHulMxH9i+Jhc6T0+I+TgNs+ApywUOiT1mENvqgD?=
 =?us-ascii?Q?CiXk0XAFHZgFrifqXa4SzLQ6PIfeCLHnX2UYJEIV5oEcs/J7eJoNms80W8S8?=
 =?us-ascii?Q?4h4hMk59cQQLytBFt98jDNf+d9Uhg5B8xmp4JWIADHaCua99XkMn0WZiOZyc?=
 =?us-ascii?Q?lNUsGjgqaDyBmz2jApci4aXaiKes+OHI0ko2zvw7aiGeBoFkEC/T0ciBTi7g?=
 =?us-ascii?Q?gmMPukvL4HO2pckF+TNs49BL5lcy/aVUH2MEWK0iT8X0wPTHgKHrc8ZKEYoG?=
 =?us-ascii?Q?IkDJnTjZcaoBo+b8lGO+iTbWsO/zjgaxdDvoKRjXxMiyTmCDArb8OMNihNff?=
 =?us-ascii?Q?uU3h36eXnX3kzBOnYLI1j+3F/RHB1w8scwy3EP203ty3HiAtznkDR+YWnu4E?=
 =?us-ascii?Q?b7waIXb3OBZfSr2ErodFwHhyKpcdzmNxx3wPhhxjhZVi3r9tnwqI+CtOikKu?=
 =?us-ascii?Q?+EHQsRYYq3xY7XEsFikcCy0spFH8VhELN9yZakpFbkiYEvXTVC+4jFhpEOEi?=
 =?us-ascii?Q?ST3dG2sjk8COAlGH/+/YxEh4xkhNzwucFfa6gp9ZBd9+c6Ib35tGqOA1x4T0?=
 =?us-ascii?Q?027Gv/hJbAdiSRKj2MemyXUctL63B1hwrJ1H3V/5x+Dp5wM89+qOAdYkB6qG?=
 =?us-ascii?Q?Ianf2xg7FlC2r29PQhCOQaDbbZlyQhBEBk7EaHUGgeTgIfTs3xPAMSFMa9wa?=
 =?us-ascii?Q?GSN97LYVYUSL7YHBU2yVxL683sdO4O+eXUSiUCAVoBskOIeE+5YTXT/aIcoS?=
 =?us-ascii?Q?u5lj0fjMXhk5NBGMUz4IFskOKG1hHqTC0C5jJXiI1QHZ+1r9jgdpUfM4BCch?=
 =?us-ascii?Q?dy677/q1i/emmZG3su3nqvaiiZgW7+Z7dZtTuedb/iGZaRXn7QtxvKBkhKOB?=
 =?us-ascii?Q?C32X+tSCg3DJS/wNNy7Q9ROc4YdEtCZJAIa2MAVJqvggn8cUu5IYOy4py/iQ?=
 =?us-ascii?Q?7TkvMXIZ3S6M0qSK9S50lYZ4R/vkNLFXcW0a1cHE6/hj+WoLRq+e9EcTY9X7?=
 =?us-ascii?Q?efCfYKWpXTYF93AgsOqJADUUrOA6QqnSka9eSCYKQAZqX6P1n42HT14jLGVu?=
 =?us-ascii?Q?msXbiCR5fLipwQye8fkz5ugeHGEHkqsVCw3PIi5az3VMOABTMzykfCgqZkJP?=
 =?us-ascii?Q?kq1TeKMCaUZkFriHGSo3eWEVC4+Pb+g47zOoVWJteojQRdEQvTnu9TFBravQ?=
 =?us-ascii?Q?Dy8Ygg50Hd6EQ8KYQtmSEbjfth1ajzJ3kKuY0Q7bRht1AdBo0TrU7oIbepIc?=
 =?us-ascii?Q?3pA6Cu4x/k//1Vqqt9BnKyyZ03s513V5gvZKXbvZlhFpFlQJfwksPjADY+oV?=
 =?us-ascii?Q?0CI/wXXuuj7GqqfOwyZ96tZb22uSq2OLPcR4F1h2zfr3OEslSoz9rcS1Ou+K?=
 =?us-ascii?Q?yaDMaupsHZsWz6Xbr6GC8Eh4UW22SVU2adzmwHvrhpZy28t5GSTSXpaoj5EM?=
 =?us-ascii?Q?eK8ZLmoDhsy649dnmqxB9mMtgMMkYbzXN8qmgiR20RyJi/rtYtkGEu1yx3OC?=
 =?us-ascii?Q?ryISn+HDFHdHsWS/HbdhwSYfJWqsWhArfSx2G93LBip4CbvasqVg2de1XuDI?=
 =?us-ascii?Q?uKdY1iw3+Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2b1d67-4aa5-4a26-3b87-08de6845c671
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 01:43:22.6716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWTYsaPXbDQhAiKqrxQlsKkXXDe08UTJ2apVY0tqMHjLN9MY4T7bPu+GhVYnGNQj1StnXlCvG3lruw+qtTmslw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8169
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70687-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_SEVEN(0.00)[10];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 9495F11607F
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 04:07:08PM -0800, Dave Hansen wrote:
> On 2/9/26 01:25, Yan Zhao wrote:
> > However, given the pamt_lock is a global lock, which may be acquired
> > even in the softirq context, not sure if this irq disabled version
> > is good.
> 
> Generally, we try to avoid crap that's not scalable because it's hard to
> retrofit. But in this case, I'm just not sure how much of a bottleneck
> this lock is going to be in the real world.
> 
> Let's be honest: starting and shutting down VMs in a loop doesn't mint
> money for cloud providers like running VMs does, so it's not exactly a
> real-world thing.
> 
> That said, if this global lock _actually_ ever starts to bite anyone for
> real, it's not going to be rocket science to turn the single lock into 5
> or 10 or NR_CPUs, or whatever. So I think we can just keep it as-is and
> avert our eyes for the time being.
Hmm. One clarification: I'm not concerned about the global spinlock. My
concern is the attempt in the #1 solution [1] to turn off irq before acquiring
spinlock (spin_lock_irqsave()) to address the deadlock issue reported in [2].

[1] https://lore.kernel.org/all/aYYCOiMvWfSJR1AL@google.com/
[2] https://lore.kernel.org/all/aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com/

