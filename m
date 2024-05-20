Return-Path: <kvm+bounces-17741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 214778C97F4
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 04:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C390A28105F
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 02:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6D1C2FD;
	Mon, 20 May 2024 02:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mQcv6ZRu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3898F5E;
	Mon, 20 May 2024 02:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716172586; cv=fail; b=Wf2fOElpcYCNaFOuGXIpSnvMECV+KHrtfVeCAqh3M6MAVQBvQKyKTJ31dec3CcW+fg9YmpkMfQNrAUt398qbbene0pJ7jqCtKGKj3nCmpvhLtwdy9MUMhHVPhZaTtJxeWc825HRR2GZPLqEOILbdWJXWKmi0OHxkE66wQYb7DWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716172586; c=relaxed/simple;
	bh=QR5W79jM6D4hBbCcw+yZxsXa8wcmy9og7ZOLKLMKJpI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j6sKlvFmNLD0TmLRtso1see06YtDzmwwriFchooLnD6ka9mNa+mRPGt8LmSb76z4ZWaY+9o+GXrfAZh9Z6+Ck8xPl7asuQWWGz9IvNbcWZ1lIq7EtZGdzAJH6GEDywoaFtxc+kgfdhOnLM2gV/wAp30/WHiFWgQ+HDyV3OLK9Pc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mQcv6ZRu; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716172584; x=1747708584;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QR5W79jM6D4hBbCcw+yZxsXa8wcmy9og7ZOLKLMKJpI=;
  b=mQcv6ZRuwTVsnbSF1MxtJeJV6orUPhN66Pp4l9emS3I8ksEgfSg7tqWV
   X1eWsnsRy3/Xi80uUL0ZZpWDPciUo93tubbrlrpQI5Amqsg63VwwgP3bQ
   P1a9LxiWghStCz06vxbj7ByU9pAPhJv5yLnvZyEVKRg0N5asv2S5tdjdX
   Ip1lQuIg3LXWxteUfDgdCmB6yq8ZlcbLX+NqyHFWeQtHa5zygCSmHW2NN
   euRE9u8cggjf83aQbXM1wgDfjp/P6RvJhw+TponuygT+7XapC1Iq3LE9S
   V+zsfGG2tUBZU7J/c5Yf+Cm54UR2SzeiFzUpuHuZjh8sLnCtRX+U+QUnF
   w==;
X-CSE-ConnectionGUID: 4YKGzjoTRr2kEp/MG9MuQQ==
X-CSE-MsgGUID: Bf3OHeMMRAO0YZrLwSGWmg==
X-IronPort-AV: E=McAfee;i="6600,9927,11077"; a="22857695"
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="22857695"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2024 19:36:23 -0700
X-CSE-ConnectionGUID: F9SuTHrlTsGp9U5CeGhljA==
X-CSE-MsgGUID: osReiQIDRympOFOieCJGlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="36959056"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 May 2024 19:36:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 19 May 2024 19:36:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 19 May 2024 19:36:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 19 May 2024 19:36:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBcbLQNtamMfkZiSvcK8ljMMDOhvbfEHbd9/JHB0ttjBVi2n3PX+oP5ySgweOqiCxKETkckqjpggIHvW47QqhQGThxLZUHwQVXMtrv0SATvkjblajwj2aq7QAvkcK1Q48T5j+nl9EVX312CFI6KSSGdgUa1qmv+OCx3SBOdWqfJaDtc5AZi4DHyVSfC8XyD3jTZYywuotwCb8gRjFPlb3TPr/wA1rn2cE378mYKRb0uVC4UQMKo5hYC+12ZQUbJDT1gQ0hq6J3uagrP0HhQPCIETYzs8SHYxbIsV/lZHbTM0VA3vo9QMz9uyVCLeLNkMdrzvt1QwCaeyjDVwRw/dUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3LyGxT2Ko/WWYP6oPMoZwY6EkLWjj9d3NsdyUvL3Hc=;
 b=akVeTddPzGnYmRs0Z+SJGsLva+yUXiVQ/vLR+ufiv0ZTuLq9oSKtoCENRRysXKIjbY9SwrVR2g4i/NpYhV2Cmytfi6D1pX3kDVS78mQRyDo2Sr3QtKXCtVkro0T42KxCEf1HH8qXby7x29Yy1e2pFBYFplix2wwczKQ4eQkfhkkSdaVkkasxEZ2U0mDCHcsIYCrb09S8xupKjEfFsdZnOb0PDuI2YfuzxA9gLEKB5R4yflR8aPnurK2X93UhZBYDMkrFCd7MAUFhU1dT9JwOiBOaqLS/+Cc4kOCRftFnRCYmgGOKyr79GGGUR6f5AX0MqzyzEP5zvUhtaLtxZ0npcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7671.namprd11.prod.outlook.com (2603:10b6:a03:4c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 02:36:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 02:36:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org"
	<will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>
Subject: RE: [PATCH 1/5] x86/pat: Let pat_pfn_immune_to_uc_mtrr() check MTRR
 for untracked PAT range
Thread-Topic: [PATCH 1/5] x86/pat: Let pat_pfn_immune_to_uc_mtrr() check MTRR
 for untracked PAT range
Thread-Index: AQHaoEaluFlXp2ccfkynqcQr/+5ZoLGLbskwgAAOFQCADgeZUIAAb6KAgAWIEPA=
Date: Mon, 20 May 2024 02:36:20 +0000
Message-ID: <BN9PR11MB5276FF52AD334D78F80985138CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507061924.20251-1-yan.y.zhao@intel.com>
 <BN9PR11MB5276DA8F389AAE7237C7F48E8CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZjnwiKcmdpDAjMQ5@yzhao56-desk.sh.intel.com>
 <BN9PR11MB527614E72C1DF467FF3F4C948CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZkYTByuHu_IptChR@google.com>
In-Reply-To: <ZkYTByuHu_IptChR@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7671:EE_
x-ms-office365-filtering-correlation-id: 6435b85b-cc3b-438b-084f-08dc7875a1f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?cpYwA19UeaLf6p7cwO2/IF9v7cjb2QLSdfuS/6biMxGT2bHqrVNQFkSCq4DL?=
 =?us-ascii?Q?apP3ZwjgoHO8A0ChSU6DccwqeSF13nPCt2NdrZnQW02iyQhQbOBqB0SaXD18?=
 =?us-ascii?Q?Pfz9RTmYKb0i1VQHZJ9v2mpxZ4Dpki7zzH7sgyDfK8h4FgpK8JTSGocVqDu3?=
 =?us-ascii?Q?cHpicaAJOLh3guUCer9asFItcjm/dVuDsXyWNNltgoKhgYQIvI2kJveknbyg?=
 =?us-ascii?Q?hmsqzrQ4HzA7l/JV83rYTZPxGCfn3Tti2AM5ywAezb0Hj+VrSuDxSIEododq?=
 =?us-ascii?Q?JhCNB/5+ALU3N70XefNHapXbHckYlpmeJFNQuX/a79Hqah8yjRdpw5uYIArL?=
 =?us-ascii?Q?Dudhbv6UrgtzQI52OsZ8SMH7cFg/8L1FrBUA+aZNQ47gT3u+vSVrLfuNqUEy?=
 =?us-ascii?Q?Hz/itMuQuDnypdcElTZvGVdlaiQvrbMenDh9NqzsemoAXMNI9SPS8hbRc4fw?=
 =?us-ascii?Q?dibDY86WhI1buZFDIvVZfIwn17WxiKQ4R6/5HmkFFQohoG8UvJt+qMNCUu5J?=
 =?us-ascii?Q?JbkHvTb+uxSgo4LKWj4f16QK+sZE0GpW2Kn0YwBN7O96BMmue99lh+ircNIS?=
 =?us-ascii?Q?+z96ys49MzzOy3mXiJ7Olded5n4jqBVVz83f3myJx75vtN0Jigwi3PNRb6QG?=
 =?us-ascii?Q?kk7vEyqOCQCyIV2J2b8Tx2skAY/XooVKDe4CZItDxLE59vNbxkDBvGgBr2ou?=
 =?us-ascii?Q?sm8qY4z8m1w7nrrGkoha+8953T63yRsLT6XB3J5oJYgSwLnAOIBl3f3Sh1NM?=
 =?us-ascii?Q?jwgHaNy9w4uh5MeVmVngj+B3X+FbxVgo/4S8CYeJ0DRK/944ChM1AF4Sc1wG?=
 =?us-ascii?Q?J87Yu9DlJMcN5/aZ7qq/0j3tcEKzIGi/TYGSXsIMWHZBRjhhCyHu3haO2pq8?=
 =?us-ascii?Q?ijyEMg9QKLe+hs8zcAo9mT5Qtw23KQbhVsHkmM6yjkIYkmtW/GVeX+A4VHuz?=
 =?us-ascii?Q?ezMjglazucLZLMmjcd/RtzQstZymvMRNHuE/W1oxV7Y8jydsuENLLGDlVvAP?=
 =?us-ascii?Q?lmvPxB4SZ/qx6bsdvyhb7RNnf1UE9jAMP6cbeHnBUINXNQOGZBfNv/bYStEm?=
 =?us-ascii?Q?7qscPLW4wFR6+/RA26bPpZQwyCpRR0WPPWKIrDo37OuINcnwKEaq7L35js8H?=
 =?us-ascii?Q?H6CTDllwgFpAPu79XizEP/9KCVR5yp1MQM80kZJGtclaljjpR9Mv83aIQXGU?=
 =?us-ascii?Q?IoYoeJWYJT73G7eeMKcBJ6A+aSHenzDgE53K8CNeMoJpsP2y2I58SRyqqy7W?=
 =?us-ascii?Q?EbXTQscHfbq2zjqhm04CRvjJHywpmumQDxoRRNMlm+sYL58Ls4gvgQ2i7Ajt?=
 =?us-ascii?Q?u1oKHzhp07MInXE6z6hg3UlgsAyQj2DrjNUBp0gIvlmFTA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c+ItALxrfPhmA9X7ae615UgFc4j4Bkz+1krfwNQhzkRI3/GSkFyp9a8E5fWo?=
 =?us-ascii?Q?G1z4OmARXRtAKreGPj5K92NLemlYZPhAqGPJQsSOVEupProwMBEFUt7WFntQ?=
 =?us-ascii?Q?dmO71zP05LPk/qWqXMThe/7qpP/DA4lUlFUaPktaGXhJh2gIEDJbFIDd161o?=
 =?us-ascii?Q?3YV2E0XzDxbg5HFvZVHm8bm34SCrlKOIcKgwSnVZNx+wC4JGghW8bjQcLare?=
 =?us-ascii?Q?+roEDPVz9mVgrAhPDU7u1hcs0DFIVKvL/sw8Kcv5Qz3af8pRXlB/o8ngNcxI?=
 =?us-ascii?Q?++A2OafpzNBcWs8QAv/ycqLenuaDCIYXjGHk8JOhVQ6SD5qQUbQgmG6mHcC6?=
 =?us-ascii?Q?pMexrtsbQtBOpAmlenWdmLE99SwKMuZGgLwB5zC8nOI+ef9ViBbTd4XlsKww?=
 =?us-ascii?Q?3aAdC3j6FvWGLdtkc7O4sVmiHrgbqaFkGwhiNrkMb689+leC3ubHRV+J0wND?=
 =?us-ascii?Q?77IavGdqOCNPmjrfK9KHCzQ4jZzUNwIS3qX1lAwBm1ZwELVEZtCqZmpk9uXR?=
 =?us-ascii?Q?nJqPUy6WBs9VtYvrbSppoRJmEMmfQwaHJAkrevl3wxupX0dh6e7lab+4HBjb?=
 =?us-ascii?Q?kPscexPatjCmJ6gowGgoXnErLsd+kYQNxHYZNqfWCbqoYXyWDSOh8e/lSII1?=
 =?us-ascii?Q?ly6DVxi/uL3MBHgFUlvRgtrVaZeiXrSddrxUnOlJEDKNhT6oFlsvbbfsDy4d?=
 =?us-ascii?Q?x97+1bgNCWsNMVEYXs0KAgbO0jGLALLdU0WZzqIi8BaXeq05OrZIIm3acJE8?=
 =?us-ascii?Q?YedgNJ/B6OaDTilfXkKXQu+6692YzpzvATqOPSl41kORx9BoK5CtiIFUDc4x?=
 =?us-ascii?Q?Pj8sHkCxYiPk0khx8LSEV4RyVsExQNroXABPQ4RK6YKsTYhpNPVkG+dnWn4P?=
 =?us-ascii?Q?ELqGE7pkCloNIU0wZBiDloceW5NlxEU4ufms6yBX/cgMKzC+pTPhbjv0Naiz?=
 =?us-ascii?Q?6svTXYj+3kvobkocK+QW2IBg0L6PF1EnLzSzuFlqSe85q+dhOQvChmRuIicy?=
 =?us-ascii?Q?EimpFt4lLAiEAwF8CYZusB0oEInY7NLEnCtVB2FpilDFwHNoEEXdA5VQf20g?=
 =?us-ascii?Q?g2uxYQzeqI/5r8uZ2kRakhzk1d5pGF4oKNiBJkEVWdj3VxGggL3uLrC25i7J?=
 =?us-ascii?Q?lvwZDsSUv6FOL0k5aefnYA5sKqWP8jjT6/2HO31o8iJ7/PrXHvEEckIqTVJU?=
 =?us-ascii?Q?R/rDhhXagzutjE5ud1sgI0eXc6XRJ9Q1qG5rul0mi9+slZOLNa4rYYNjT3mT?=
 =?us-ascii?Q?/NlfL7dqYLIL03HPbpylFKnqrFFw1e6bKiVJel72ZNZlYqNOnkuf9b6Uv/Lp?=
 =?us-ascii?Q?GX7/8lXCW7mYkbfN2yqMhOc2uw4OGPjuYgMXxvGOtxk6bRmFr71EPLUyNUQI?=
 =?us-ascii?Q?j++LLzXxbJNcdYmkIh59x8xCYDPiBXP3hut+oDf3dgAJOMTLRc5Es8ZNemLx?=
 =?us-ascii?Q?H6L7PSeAoexP55jbYQuQicziNyuCdsL/qjbDmiDYhLJognRCkorgrdalmklT?=
 =?us-ascii?Q?QJlzaoI9NIrXY4/R/En3UaKvEutROPzPR45790ObHLsWzrZ1PC5ZtXyoiD68?=
 =?us-ascii?Q?lD6FmjnKg9hcUc2nu7xP/J2v1ClRgDmV06gP5R9I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6435b85b-cc3b-438b-084f-08dc7875a1f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2024 02:36:20.3379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d/jSOrHxunjIG6cKZkvqcq2m9UsAX88k3NNzRZGyALAKWvAGMdHH4uKYl3AMpSP0nrFL/Ka3pBR9d4bjJs41Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7671
X-OriginatorOrg: intel.com

> From: Sean Christopherson <seanjc@google.com>
> Sent: Thursday, May 16, 2024 10:07 PM
>=20
> +Tom
>=20
> On Thu, May 16, 2024, Kevin Tian wrote:
> > > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > > Sent: Tuesday, May 7, 2024 5:13 PM
> > >
> > > On Tue, May 07, 2024 at 04:26:37PM +0800, Tian, Kevin wrote:
> > > > > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > > > > Sent: Tuesday, May 7, 2024 2:19 PM
> > > > >
> > > > > @@ -705,7 +705,17 @@ static enum page_cache_mode
> > > > > lookup_memtype(u64 paddr)
> > > > >   */
> > > > >  bool pat_pfn_immune_to_uc_mtrr(unsigned long pfn)
> > > > >  {
> > > > > -	enum page_cache_mode cm =3D
> lookup_memtype(PFN_PHYS(pfn));
> > > > > +	u64 paddr =3D PFN_PHYS(pfn);
> > > > > +	enum page_cache_mode cm;
> > > > > +
> > > > > +	/*
> > > > > +	 * Check MTRR type for untracked pat range since
> lookup_memtype()
> > > > > always
> > > > > +	 * returns WB for this range.
> > > > > +	 */
> > > > > +	if (x86_platform.is_untracked_pat_range(paddr, paddr +
> PAGE_SIZE))
> > > > > +		cm =3D pat_x_mtrr_type(paddr, paddr + PAGE_SIZE,
> > > > > _PAGE_CACHE_MODE_WB);
> > > >
> > > > doing so violates the name of this function. The PAT of the untrack=
ed
> > > > range is still WB and not immune to UC MTRR.
> > > Right.
> > > Do you think we can rename this function to something like
> > > pfn_of_uncachable_effective_memory_type() and make it work under
> > > !pat_enabled() too?
> >
> > let's hear from x86/kvm maintainers for their opinions.
> >
> > My gut-feeling is that kvm_is_mmio_pfn() might be moved into the
> > x86 core as the logic there has nothing specific to kvm itself. Also
> > naming-wise it doesn't really matter whether the pfn is mmio. The
> > real point is to find the uncacheble memtype in the primary mmu
> > and then follow it in KVM.
>=20
> Yeaaaah, we've got an existing problem there.  When AMD's SME is enabled,
> KVM
> uses kvm_is_mmio_pfn() to determine whether or not to map memory into
> the guest
> as encrypted or plain text.  I.e. KVM really does try to use this helper =
to
> detect MMIO vs. RAM.  I highly doubt that actually works in all setups.
>=20
> For SME, it seems like the best approach would be grab the C-Bit from the
> host
> page tables, similar to how KVM uses host_pfn_mapping_level().

yes that sounds clearer. Checking MMIO vs. RAM is kind of indirect hint.

>=20
> SME aside, I don't have objection to moving kvm_is_mmio_pfn() out of KVM.
>=20
> > from that point probably a pfn_memtype_uncacheable() reads clearer.
>=20
> or even just pfn_is_memtype_uc()?

yes, better.

