Return-Path: <kvm+bounces-25310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B265996368B
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 02:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AD2B285C9D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 00:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 352082E83F;
	Thu, 29 Aug 2024 00:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CpAvNOUn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FBE1C6B4;
	Thu, 29 Aug 2024 00:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724889666; cv=fail; b=YXjelmQUtUut5pP5aeE3iZtCFrh0sdSeuU15xiSQpTv88K49cbtCk4MYXq78WiO1cMow1jn3TX9GkNrHQWozRgMu986exYazXFhFDINzSQkDVWrGzpn1B05qoLa5Zi0kM5B7Ymc+R263V7d87RCFRT3Fdn+bzv0OVXoZjyGiE0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724889666; c=relaxed/simple;
	bh=jOvZEFpsvKNpvCjdWHD14PThoxjw6bieyXK489m5+RY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CVsuLdTJFopxeHymB2sAEtz4zJJaJJGuHf1IGmih7pPKHur6TYs3eTWpaikpWqz9kPURCF4m4igx/haxoPKiT9AkBO76Nz0eS/IfcwD6gtlfBZrb7Y/CJjrb7naFcheom3y/LIEcb/g2MBRelVKkQXK6wJWQ5jt5dX51isG7ZWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CpAvNOUn; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724889664; x=1756425664;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jOvZEFpsvKNpvCjdWHD14PThoxjw6bieyXK489m5+RY=;
  b=CpAvNOUnjj0hljLdQJbU4ecQLqY/OJ+Jq3BxkVWEKb/d/XrXs2+ZY6Pt
   j17pRUHOpSeOAhhUhMqneRikSm6eV8BpjhE77wmaMGJSODmyDe38BsBRa
   gxq9KMGsRapZtU3K85Yb0u7UlpxdhW30pMXwcOqPzpnMSORilgS87VoM7
   lL/shzviKuamWDRGIrig4y7pCDKRXWGel/UqOnruj8tQ3RIU2zRiAEH52
   7GP4ZlIm/CtJqGCNe1E3Vw0i/ozEntfJnxq72mVTNxbGNNws3au1Gx779
   +iblUVFQJy5+YMcA082yjW28QulGsGKWX5Y9XlTBR4VUCAEDGFwn3YGiW
   w==;
X-CSE-ConnectionGUID: 1BUMhkviR+qeUvjXNQALUw==
X-CSE-MsgGUID: zdsUjjFRTJuJjL+qkZyZCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="48836039"
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="48836039"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 17:01:03 -0700
X-CSE-ConnectionGUID: LJx2oGbWSMqFAYMQRQ7DgQ==
X-CSE-MsgGUID: ooVrt4KCT9CpHNu1InmgPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="86589088"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Aug 2024 17:01:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 17:01:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 17:01:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 28 Aug 2024 17:01:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 28 Aug 2024 17:01:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aNA6JenusXcOhWQEZ+v45RRI0OO1UnvnLiDBFzzQne2GWJn5xrnYMdiv4MHO5TF6A/AkeLEP6bHIgi2N/p4inCH2/YDK31cWkbcE+gjIEdTxMRmFtsu00OVO3tRJFEmK1MjY3TxTgNazT7WVE3g7GCapfOI0RF1I/CHEKYZARtXpor9mbH8nORAGPgl8tWXkRyn/dHvqHX/jybx7J1MhVQj3ffDuERXH9jPLYtGwu5vedNmhiM2KCwjMoU11r05GN3P26Y3uzxKSY0tDliP2lMXR2SisBrhBUPhGIyiT5Qha9+sB0MvbqnqOtkbdWgz24H5USEWqM5HB7nmQmlya5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X79aTA0qmNnK1rs127YQPiPk2JTF0NIuq8vvvRdtvLg=;
 b=jl39+KKaS9PADldCQzn5REmAOrJaZhBoa1wzm201bxqN6SIk+iy1uCu74DFXQgKYUQVg49yeF4ysgKxrUpEBMPrE/9o1JFDEerbXYKg0E6okC/blzN/itEXa7PGDQX4B4Zcv5f2J0pvVMEWGv5z0J4hFp3Zu7tqgygLcc0OAv0Fmc3HKyIjBfqpUz4G0nyhzD8bcDZNLhxOlPAi5Vx3ggpxEvGhVgUMm5D/tVjVfHxEhS85Qh8tSIBBJNQ6CHrgu8759OsI85efatEO+TZZ6+9juaEqJway6Q29rRAziHiIbJlLhK+GVry97qwQw9pzrP8QtZ/oanwehPt4zoSeFQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB6014.namprd11.prod.outlook.com (2603:10b6:8:73::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Thu, 29 Aug
 2024 00:01:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 00:01:00 +0000
Date: Wed, 28 Aug 2024 17:00:57 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alexey Kardashevskiy <aik@amd.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Message-ID: <66cfba391a779_31daf294a5@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
 <20240827123242.GM3468552@ziepe.ca>
 <6e9e4945-8508-4f48-874e-9150fd2e38f3@amd.com>
 <20240828234240.GR3468552@ziepe.ca>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240828234240.GR3468552@ziepe.ca>
X-ClientProxiedBy: MW4PR04CA0263.namprd04.prod.outlook.com
 (2603:10b6:303:88::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 78556d78-6b6a-4b00-29c6-08dcc7bdaa7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?msDggINtAahbJv/dcvqdsGP3X9TobpyJunEDWHTGeVU/ecu/K9QSctIy2VO3?=
 =?us-ascii?Q?IH8kz2G9zrMo2AwnK6kr5ZoqXxa/0Xp4KVA4J4rbiI+fGCSl5+sEkO9Qbw8r?=
 =?us-ascii?Q?y7FHgYeNkGi3Y/lN3DSUNRR/IbbwpwgzbiP4/pXs1xsPZ+NvGaWRCdKc1I2k?=
 =?us-ascii?Q?UKeZMvl/XRg2jKWrpoQmYmS+V9r5o1ECb0Xe8IlJC9QwjTiyJOwCMZ6m+NgL?=
 =?us-ascii?Q?Sr9vDzrcg2T5wVSUnVVhvPxpGyinJnMtxLCWiNSjz//rxx3hDoU0Ora8mkXo?=
 =?us-ascii?Q?nuGp6jLML275li4qqR5M12bWSgraydxD5IzFDck+lva7s0vyVNaGQzeVi+kE?=
 =?us-ascii?Q?QXBlkSD+tLYDRHoj0eWID3YBws3OyEisHK7x/2cv4d1KvRlEKT1xAKcejjQt?=
 =?us-ascii?Q?zbMlSrmuv2fQl4MsDdCgij+qZkj3n+G/fowV0mz5q59lqUcMR+8iZs3jTq9w?=
 =?us-ascii?Q?P83HcUDErPfFMY09BhCBIpLsNXCljCtjdkfMzzVwaQhOEVKO2i8wwVy3nU1V?=
 =?us-ascii?Q?qqPjG4v/gBPKBWHFA4mSgIF+KBUb6pgkcmlrIGk421TiYfLYvm6jxD7joITb?=
 =?us-ascii?Q?P4Tc1LWaYEU/QVr6Vm+/K1yvQe/n0T32NH/BgaYt174STuhOysoHzc6a3qH9?=
 =?us-ascii?Q?4mlc1xkSK1wtmUhWUL+S6uL8Hs//BIpFg10//LcrEXHbNpUg5bW6FJ09hfNJ?=
 =?us-ascii?Q?Kut+EeXXwbLKE/VCvYaZbcIbapRxhvMBQ6wLtdiq7fKilS9i0jtwYgMP5Bwb?=
 =?us-ascii?Q?Z4uzXH6DcuPQX4CQNB7t79G0kJ6eKf4wceFbogmjtj9tLtfD41qYtMN1C56h?=
 =?us-ascii?Q?kF46O4N8ujbdO4y4A9e7EbdghN2xkItyNjXjPcueOckygCTmdnrPd/tNfAv4?=
 =?us-ascii?Q?JNOKY8OngJ6PG0lKO0OL9bEiyQIP4GuSNHglIUbkIZUFNHM/FyS6mFlw5/BX?=
 =?us-ascii?Q?IxXDQ/BUu9YVfz5NLY1gAm4B/8o4itEA9dXiQ4pcR8vQ6VvuLM8ltdTvepqb?=
 =?us-ascii?Q?hONAfcSkYgDoW4HGaabLpw7w/fsrdU1q0fDJ6ZiHSP46twl/d/z+9BuzRG7i?=
 =?us-ascii?Q?Dn4/G2bYxg4om8wVRPC80BS78riwaQLtJuB+EnNXdxko9KMQMRR+ohLMMr0a?=
 =?us-ascii?Q?4WXx66yL2wPVF6nbBAq4TqgDT/TeMb9Tolt1Si/eU6Q/kt5r1Y0rGRvhex4k?=
 =?us-ascii?Q?/d4qLCwfReXti64UbxQJNLJaJv1sogqTjS4knYMXjW7/kV4h1/eBiyf6oRoo?=
 =?us-ascii?Q?0Y8/LFnyuESn423XJduTXln9WF7Ykk3I7CAKB4Mdjb3qHd77DuUquHPzYIuS?=
 =?us-ascii?Q?k2KUz+zya17TTdlKTyJlb+eX2OlgwHVt+ex/Nt2OyMeRtA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nGj3fwfYYw3/y/SesdjtM1toIdNf59IEsGe9HZqGfv+akcFClQYuj9Lmdx5t?=
 =?us-ascii?Q?uxeZk2cS1VyN2mwMr73JBsUpWHt+p0jqfDA7fwAKgJfj9GNoyGW9sHoHcPK8?=
 =?us-ascii?Q?3/0GUjq9ixTSTdqhGiWURhztchdy1ZAszfB+S64PDxvNTmGDfa9tYuIGs2bq?=
 =?us-ascii?Q?+yia68cR6GfAfsOy8ndZu/GIe3ZCFTkBTRa/c81/uNQ2zgKEYRlX2eobXe9s?=
 =?us-ascii?Q?h5V6Nux3uViuqZpNrVM7OhhQwCTGameFmlhLmpNiE/7DbOLhhV5kNOPO8mbu?=
 =?us-ascii?Q?tiJw78HNl3v3cSXweWO/+DLmceeXTKAfCWQX30BDRs2KsbNeaDyP+ti2QhR5?=
 =?us-ascii?Q?DubjmGouduriQHk2hfy55uriXRdnMkD0IXHxc5o5DGPvWDSfJb71zArA1zGE?=
 =?us-ascii?Q?oWkHmZ1ENst0whwhlC1rITj8YtnsR6xTrMuBWXkdqhUDA7IIN6+Dy5lp5inm?=
 =?us-ascii?Q?sQl/xxDzZP2ZKClLz/ycsvYqgifdFRJAXKvLPWW9RiKEu4KSfipT42TdMS/L?=
 =?us-ascii?Q?SKanzHhMJDKp+H+TODj8Bxrgyxmf2zN/rAwWQydcCnDqqNLtsVd6+WZ/Duow?=
 =?us-ascii?Q?KNjyKliT1lTmUr8AmOWsXD08PbP6gb/9PSrn8u3jRNn6OJ8P/M/MYXRR+3ZM?=
 =?us-ascii?Q?WtP/aGkkFcvLrP+SDKQGOkXtcEBfZdRLqqGwjbTLLwTcS0LjH4TSDLQRF+U5?=
 =?us-ascii?Q?5GKVv3l9AbyaXZZEae13WjlgowyI08FyHtqLw+tDFCHyWxbrMjO0K2WcBDEK?=
 =?us-ascii?Q?JbYYpT8FWBEIJtD1caCxzkEV2/fTQl/B0usX6rXi2RcZwXRWH41k9lou5650?=
 =?us-ascii?Q?ozJFz277vauHMJDAYbun+fhziJOn6ogv/pKYSWTPcFhZv1D8zis7dmmxtCGB?=
 =?us-ascii?Q?VhPkud5AvKz1ObiKzkYIwi41OEzfg33Z5j7gFw6S7DcnWrom9SFxJCuN0l3b?=
 =?us-ascii?Q?IeJ1+RBH7saPsrVF97eNx+IrB5W8hIFham9zwUIZhsGBP9HXpF9LtypmJEcx?=
 =?us-ascii?Q?Eu9Wlkc6+gvEhaMSv9yK3r5I6y2YJSMZXu/YqLT8DK4m8OwYqpzNS8wgvhpt?=
 =?us-ascii?Q?Knbe+byQHmEqWJNihJuUGhxYbpLtfVem8QDMWxoyU+3OJQQMDaTV7zvKo0r/?=
 =?us-ascii?Q?/b4irhlnNeLUiRlRbMVWQUiw6aumRgzO+/rh05zkdjRxUwaG7qKu1QbIUrQJ?=
 =?us-ascii?Q?A2HWe8HUYSkE2tGr7Q29j9ZbgSLf19lVIl9BQgw9OxkR0+bP0Hj4ZTe3AXmQ?=
 =?us-ascii?Q?qpBmJKdjwXYvYjvJUr8mcYJTBm9E4H5M6rv3NkTBoEj5d0olICCsrc1c1JKK?=
 =?us-ascii?Q?1kV9QD6ZN/Z6gjjHlOhl+BM5hrd7FGUlFJBLpqBL1l2MHyEezEvqe7pr7xBn?=
 =?us-ascii?Q?JpVExSAjt/pg8+FoQY1zbccReWpdTG8EXLZ+5pNZQ3cm4YHiOyOfOPVYGn5X?=
 =?us-ascii?Q?gfssV7a5eRVA36c3PGBmMHYtMfqUF/DU4FdvHzH45laYsJJ5cvQvNC0i75TN?=
 =?us-ascii?Q?uArCIA4baq85lh8Zv2LtAZ/IBI3gt79RVgtBkZUI1hdezxPcPw59M2CnnfrJ?=
 =?us-ascii?Q?2gFjK53ZF0JAk5tRHALDGFccgZGuWh+WF45efNz1V1f5GhLQImOnp00s/oLu?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78556d78-6b6a-4b00-29c6-08dcc7bdaa7b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 00:01:00.3919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8mCzOReOOow7hyjCug53iWetA2XUzdJo1DCtbV9S1JdTy6ahpeH5GItjsZKMThElYWiZpfQZOiIxJKfrcYmEAcMz6KAwGGIUnfnzp35BFck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6014
X-OriginatorOrg: intel.com

Jason Gunthorpe wrote:
[..]
> So when I look at the spec I think that probably TIO_DEV_* should be
> connected to VFIO, somewhere as vfio/kvm/iommufd ioctls. This needs to
> be coordinated with everyone else because everyone has *some kind* of
> "trusted world create for me a vPCI device in the secure VM" set of
> verbs.
> 
> TIO_TDI is presumably the device authentication stuff?

I would expect no, because device authentication is purely a
physical-device concept, and a TDI is some subset of that device (up to
and including full physical-function passthrough) that becomes VM
private-world assignable.

> This is why I picked on tsm_dev_connect_store()..
> 
> > Besides sysfs, the module provides common "verbs" to be defined by the
> > platform (which is right now a reduced set of the AMD PSP operations but the
> > hope is it can be generalized); and the module also does PCIe DOE bouncing
> > (which is also not uncommon). Part of this exercise is trying to find some
> > common ground (if it is possible), hence routing everything via this module.
> 
> I think there is a seperation between how the internal stuff in the
> kernel works and how/what the uAPIs are.
> 
> General stuff like authenticate/accept/authorize a PCI device needs
> to be pretty cross platform.
> 
> Stuff like creating vPCIs needs to be ioctls linked to KVM/VFIO
> somehow and can have more platform specific components.
> 
> I would try to split your topics up more along those lines..

I agree with this. There is a definite PCI only / VFIO-independent
portion of this that is before any consideration of TDISP LOCKED and RUN
states. It only deals with PCI device-authentication, link encryption
management, and is independent of any confidential VM. Then there is the
whole "assignable device" piece that is squarely KVM/VFIO territory.

Theoretically one could stop at link encryption setup and never proceed
with the rest. That is, assuming the platform allows for IDE protected
traffic to flow in the "T=0" (shared world device) case.

