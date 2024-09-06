Return-Path: <kvm+bounces-25975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51ACD96E7DB
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEDA91F24680
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 02:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8103F3B1A4;
	Fri,  6 Sep 2024 02:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HVSAFd0A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7583A1BC59;
	Fri,  6 Sep 2024 02:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725590791; cv=fail; b=SeYXD9Kprdnz+wSrAdtDA4UnQm1hGOnyw+D4gOwCj5FiheT1Dqq3SnMgJLU94WBIUxr8l6EKTxGKJq5Pjc5VeG7v5lZ0Lals1/5YaVgQgHhvEqYTgntTBwGKgGwTj5reOacFG23BdC/+G0B1X9c5SRgNxvI7gsK1mueoNhTC+w4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725590791; c=relaxed/simple;
	bh=na4cv31V1WrcuTf+77+WSWQpH3va2SNe65nnXwBbAz8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V3tsi+v9SDglv7ZB6qSPb1Zp2pJcNSeq46eh1xCRe6qS0esSg6r5PzuZ7WJcil2cEfICbLC5SWWRUkV3qUGeccuovHDTJ4w0q1vcTj3PZa4X1k7wS9VElQeRRishdOsj0bff/7gYKtSGBBqZ9meFvwrLiT+Kjxlnpo0CChcqvY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HVSAFd0A; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725590790; x=1757126790;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=na4cv31V1WrcuTf+77+WSWQpH3va2SNe65nnXwBbAz8=;
  b=HVSAFd0Agzf9AQVMjbd+U+eSWzRGzIMFvcZ5/aijXPxGLVx5TtIRg9VC
   /PauGbzrfZIcWMKL9pTJXf0Yp/+VjCaU+guC4iL+j8Ent59juVY0ysXpK
   q4vo0xOp7+LdJmGyLgTKkt6RiYHFMi6to5uOkxNSOBdESAXNE3vdr17KE
   5lyYfu37QIXSTogQ2ctDvSQoy75e1FQm1c3JFLKXw5Dz1GjpdNlLNitTX
   J7FNTl+1Pn+48BZ0Uth/7yGdWR7618ni4TbSrU3rMFSMRgyqM5/p0zanM
   p7ceI52f82b/phXwKgCKSAqSuGXMamA236+r8i4b6vxt+QgvdDPcjH5q3
   A==;
X-CSE-ConnectionGUID: pDTPdqdnQWSGGsJj8cMLNg==
X-CSE-MsgGUID: YZ4KNeF3SHGX+U/r/a4MdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="27263161"
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="27263161"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 19:46:29 -0700
X-CSE-ConnectionGUID: EjvWG/ybQdiHvEcP2D4lKQ==
X-CSE-MsgGUID: Vp15/swrS4KzBeMvgzrv+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="66558187"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 19:46:29 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 19:46:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 19:46:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 19:46:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 19:46:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lebw9youAKhpZYjS4azJIREUQiPM9NlHbeXvxZVec0Nyb8swuEsw4TmS6K/bshhSm9ta91AfQbsCCXf4KvZCNnw4X3+YZfh1cyyF0mAio4xZqWhQM9CNM/tQ3RmFLKlrQW5lnMQkIYZzcim3FAVuA2lvKu4TQwy1AfbCBduXxsv6gBzZTcfcg06CAUalHxOaoqqoe5t8t+w5ntqzSR8WKuMY/B/ji/9EJPNyf46rGDMpTxIVkxWo9c8snoSw1icH3gO05Odqh/t+hroKQHH5FI1SQeTdySRfQ/HKMP6QyY4qyc/j6M4vJe1+o3tSWkryO2U7KgdsNm14CjwRGRC2mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=na4cv31V1WrcuTf+77+WSWQpH3va2SNe65nnXwBbAz8=;
 b=tIn6ylXrpkXuktxBKpqjOBNEiXNDcwF9NQQyIwakolM+EWgt+nHg9EiCtVRHEUIcEif/1S6T7pzabfN3l0q0tOUiAWU2GxoCSHfM/VAAFGy/D0rRiwmJiblnwrl86pF7/4b+QmQ1qpjR4u0gGwaPEeDI+1Z68ybQKZguFdSpdY9ExcgLwkDWK+4CyOk0rGYwWVlxFuZFX00zUxSnSYzM7L4fW++9ALGUUZ6DSWS8NbNDG3n8chzgqh04W+2GWgVVe86mZWxMfXV+zACdtECRuOBlj0uYTK4HmqMCg9wFofCa0N0eqiaPGAZmEkUW9YWhCO0bafpwqT9AwQMaBQHKDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB8277.namprd11.prod.outlook.com (2603:10b6:806:25a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 02:46:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 02:46:24 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: Xu Yilun <yilun.xu@linux.intel.com>, Mostafa Saleh <smostafa@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "pratikrajesh.sampat@amd.com"
	<pratikrajesh.sampat@amd.com>, "michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>, "dhaval.giani@amd.com"
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, "david@redhat.com"
	<david@redhat.com>
Subject: RE: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Topic: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bI5OEgwgABEaACABIX0AIAALPiAgAEeNQCAAHoIAIAGzr6AgAA6GYCAAA/8AIACSweAgAADRwCAAAMgAIAAjnSAgAAlTICAADxFEA==
Date: Fri, 6 Sep 2024 02:46:24 +0000
Message-ID: <BN9PR11MB52769C4CDF39D76D320FB3938C9E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
 <20240905120041.GB1358970@nvidia.com>
 <BN9PR11MB527612F4EF22B4B564E1DEDA8C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240905122336.GG1358970@nvidia.com>
 <66da1a47724e8_22a2294ef@dwillia2-xfh.jf.intel.com.notmuch>
 <20240905230657.GB1358970@nvidia.com>
In-Reply-To: <20240905230657.GB1358970@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB8277:EE_
x-ms-office365-filtering-correlation-id: 8240ee56-71ce-40ca-a53f-08dcce1e1943
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?bxZvRPcF2z1zuNVk9dchZstn964D8BmWiocALxQvI8awpHpopUY/ULeDKJE5?=
 =?us-ascii?Q?GJbAkDQmOyb86EuXPPhgZgv5QEk7b0pdP0T4wwBpol/EiKLfzjtaOnvTw69w?=
 =?us-ascii?Q?ek0+HU7uJzmdNuV4DmZdWwhIxInAGcE863IzIYTfBoScRN2GVebsIM8F0T1X?=
 =?us-ascii?Q?V3k6KsDLWN2fEA3Rl3wBdoAZ4kKI0ppW9YYYM1p+KXhRNNwwPQDzSkvIixyb?=
 =?us-ascii?Q?wCONv9GhNRet4dp6OV4+vSvNAXC8RxGrBo4Bxs+stNmn6EhtcBbeMZ5ZZ84l?=
 =?us-ascii?Q?p3ZTJXYrRJzEA1WmW+F6GKmCaf353wydNn+28WNADMPN/GsKNoYpRwPbxVW7?=
 =?us-ascii?Q?0Gd+PkV1HwrhACueNsnMuHaWb6VRdLc/OknBNXMD/QMYFQrqZ7UxaauAwBR6?=
 =?us-ascii?Q?g13ThA9EgHb8HCsGA3+yzUe0BcFRf7rGu8h0rYlbi2MaoUs7ORq+TXOpzdes?=
 =?us-ascii?Q?w0xwHZCuoDVDR7oyuBwQR0YIjTrfViRchu3RvWtQGz5r2QDtynXe/LReDA6c?=
 =?us-ascii?Q?199gai+UmSm3YZoh7oxtyjXYkpD19l9MMIXQZ+dhzVYaJ4s9JBc/iQ+Ez6Ld?=
 =?us-ascii?Q?aZC3hfuobTlwZn2HsREp4ryLfVALDrd7T8biN2H7ouB8r4JH3Mh1+MvXukGW?=
 =?us-ascii?Q?GG8KWFJIMzeK4FiTbvWqO0BZKn5LncXEg+NIUtDsowGOp84OVs1UgxAPynC5?=
 =?us-ascii?Q?HhVt5qkRUXnNlz0FempzrzpY3rit1/LdnSwuu8eoR+YhBeCPvURAqrAQJTdL?=
 =?us-ascii?Q?dZ35YJqBkB0RRi2wGlnYsVRk/ZK9Zg2Felc03QMORFv142ISGj4z/+KDSoC+?=
 =?us-ascii?Q?CToVw7OA2MZDz8zYmv7OQ54ZdgUYA5OPUAyY72vZog2+P7bf+spoloFrZ/cA?=
 =?us-ascii?Q?ygSL/ipgZ3wpxL3YUke5iqfp9WJbJDgIINqLIvhn7agTq46ATMf59NZbwHqy?=
 =?us-ascii?Q?ZVHuztJkomi3HXetCvNBhLZSEDwtmCrmhpT1brHlkdRVjMjwE/cWcYEi5Es2?=
 =?us-ascii?Q?4QGs/J+qTgtlCQoNVbsV9ahLUWtWQilRGJX0pk0hGedxKIx5Y0a3N6p8OzFN?=
 =?us-ascii?Q?0pKa9opJGdOMjEYRET7Yt1HJCUc2gyzxYzE3r8/KidlZfzInNJoR0TVC85zT?=
 =?us-ascii?Q?Axyv3YyqpE3mGhbh/J+lyRiu02cbulmtpG19R11dflajeVoi51r7TZeBVOCY?=
 =?us-ascii?Q?3pys0k72IHvJYkiLYWelWbvIZjsmkKmm4k5RwJqivoezCEZO0sQAUdUTnmE/?=
 =?us-ascii?Q?K4jwPmUrvm4bMRqaJ0s4YO8DNpDhzseD3a4vXjBvrWd9hzY4cMXseycSdEpD?=
 =?us-ascii?Q?LGycTeLCDH/cz//JrmVszkYrswa5w2ZhrTsAYOrTWAmnLZe9f7y3a7sQa+lh?=
 =?us-ascii?Q?/DNm59jdOnHTXHfuj8tZHYN17EMJWB4Y5dOF3ZLNPMZVswQb2A=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kdyr28y9Vd8anA3EFrBsj75BULi8v8nkSHnofYtmkoU63OrXMGeJ0ZnTQFpJ?=
 =?us-ascii?Q?oUObQ+UVwDBHb+h/Fj/ze6ugegIJtzhWH+iKGHnnCjW2+aDcgOHNTHv7yTVF?=
 =?us-ascii?Q?mIeiGWRLHUMIbU8NCunjPgiJ9m+4HeF3/t51AKrwJCsCZDS7IGVrT7FSoHrn?=
 =?us-ascii?Q?5sjMNMQp6LaLKI8Gt3mdoeOiiNMAT4inkORx/BW7TtXMtgOST1qGDB2AQB07?=
 =?us-ascii?Q?8tkPxV6/Rb5EDF0UUZYova9uyfgKmQMayPOkWgHb803VJlvMiLg/K4vMCYOf?=
 =?us-ascii?Q?g49A3OrRcloHfjFsAyGFRX8X7to41qTdVwFdCjjqP+EW95wU1SZmp2+qGBcu?=
 =?us-ascii?Q?ku7FKG+qIg/CMsXjmtuxa8n+1MQqT/1/4NF3bAMFCmft7WEERgmVvb1z0EFw?=
 =?us-ascii?Q?voNzwCo/qkh4l966niQv40k5hUmm0L4r0riFCZm6wJ4+8+HtQ5eywz07PbFa?=
 =?us-ascii?Q?IkO8Re+pI35dkTf+9JxeNTqXYQkkQVrxuzVJGhR/JauLNLc3s370zJyUHgIR?=
 =?us-ascii?Q?ifxncki2LeHxYFSMK4SQBQIxE5MmiJBBFgvZlDF+WTf/hHl/qxTCXyRsbNkE?=
 =?us-ascii?Q?ouMNd+YeBfTYFORoEuJXmpUheLrGGwgQD9kk2xV5UV4wYm1NQyJKKMEP4A5m?=
 =?us-ascii?Q?xtyf3qDhwH++TwXSEackn794VtHXsdjjkgwfeYWJVGw59gMWu54C488H74pB?=
 =?us-ascii?Q?RpmldxFZsVz13DtKZlUGPZyy2KdSu5EgOeKtaN9SnrrpzbZcUiew8j8h/rL6?=
 =?us-ascii?Q?JeMb/84lI357OE8tVqKrG1yKokZoET+5ke3kcXq+A9/3hDTZ1geqsRD9TgHZ?=
 =?us-ascii?Q?Za0/nsBB0lafTNfYTORpDoRNa9j/k1Hz5AR/t8owBPHiEnNTrM1IyH7JxMR+?=
 =?us-ascii?Q?eT2qFDFVaGDnbCS9AmSiG5jc90NGTSShfPzOomsNLPqd3ZwSrotC/mJ5UOIm?=
 =?us-ascii?Q?tqV9rdUzuKKQs2TKXbMnMUdfJNJ0Fzt6LzSaXYDXWnXTPNud7KSv3ZxOPJIc?=
 =?us-ascii?Q?t8/V0D6T3nk0AZ3SO7gO0xPSGR4uHk/hmEwhHnN1C6cmMAI7muzs/mHZKnTL?=
 =?us-ascii?Q?XyURz73v1/hk9CJP7CHmSsdVslGi+TuR68zZKByaIdMAGeQ1mcxZtXGvEyRX?=
 =?us-ascii?Q?X4KtkAY3PPYlFn1Iq6znrKuxxE4Yp0XQNp1FAzLn5F9u7kqt6aZn5pz6Z/4D?=
 =?us-ascii?Q?uxCkkXyNd/kC9+wVQSoGgPEn0UvvjbUfRoAQNpUZx47E8RDUiD6J85Cw/w/J?=
 =?us-ascii?Q?5c7Geeos75Nku3nKrlzTz6jKX34IZpS/idFkGpzSKLyIasRJZIRLwcab/ofh?=
 =?us-ascii?Q?pVbE5MIw7wSplPC3KNhT/m9dEALVTXP9JVeaMCLQXIBon/bM8MMVNfxqRV8v?=
 =?us-ascii?Q?P28HN+2bGQzmOqupYRLh99lgzZCpSS12hqoDrd92P1s1T7dNP668EYiiH788?=
 =?us-ascii?Q?1L+7+Jo5JfgQ9MK+xSuygz0zBO64ym8ceZPHVdpSiIYch+u7/EoAQ3UupDaz?=
 =?us-ascii?Q?oFjaufrf6Pv3yo8uGm1EDJ0HZxhvqMtuGhlw6NkzkLu5Pk106aPqO7l+axEs?=
 =?us-ascii?Q?n36mOGFmy6+0xXnEwFVS54yzk3CW+Y93TfgMcGxC?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8240ee56-71ce-40ca-a53f-08dcce1e1943
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2024 02:46:24.7819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ReEJpj7TwH3Rp9REgGpe0ui6p7/hWsGHuK15vK0GEvzA6gGaiZSMpg2TCMzQeFdQ7ATxpm+DaTgdPp76ZGNshg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8277
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, September 6, 2024 7:07 AM
>=20
> On Thu, Sep 05, 2024 at 01:53:27PM -0700, Dan Williams wrote:
>=20
> > As mentioned in another thread this entry into the LOCKED state is
> > likely nearly as violent as hotplug event since the DMA layer currently
> > has no concept of a device having a foot in the secure world and the
> > shared world at the same time.
>=20
> There is also something of a complicated situation where the VM also
> must validate that it has received the complete and correct device
> before it can lock it. Ie that the MMIO ranges belong to the device,
> the DMA goes to the right place (the vRID:pRID is trusted), and so on.
>=20
> Further, the vIOMMU, and it's parameters, in the VM must also be
> validated and trusted before the VM can lock the device. The VM and
> the trusted world must verify they have the exclusive control over the
> translation.

Looking at the TDISP spec it's the host to lock the device (as Dan
described the entry into the LOCKED state) while the VM is allowed
to put the device into the RUN state after validation.

I guess you actually meant the entry into RUN here? otherwise=20
there might be some disconnect here.

>=20
> This is where AMDs model of having the hypervisor control things get a
> little bit confusing for me. I suppose there will be some way that the
> confidential VM asks the trusted world to control the secure DTE such
> that it can select between GCR3, BLOCKED and IDENTITY.

this matches what I read from the SEV-TIO spec.

>=20
> Regardless, I think everyone will need some metadata from the vIOMMU
> world into the trusted world to do all of this.

Agree.

