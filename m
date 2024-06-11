Return-Path: <kvm+bounces-19310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4A2903A0D
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 13:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95A7D28304F
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 11:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BEA217B42F;
	Tue, 11 Jun 2024 11:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="atjIHQ50"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205273F8C7;
	Tue, 11 Jun 2024 11:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718105292; cv=fail; b=fARYBdOV+PxvZCKpn4HN3us/VQOxhXNtlA3hM7TaXuObsB7r0GNo8s2epltMnNFkSnUSJTtlZzi2RaxXmfvbxzEDgteNglTMSOKNeD8xsCe8DJlXw8oeb8NVyySsJUKJk4f1WNhqpULFA6iMMUpsmxM5NzPOus4wYWFev1GaKIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718105292; c=relaxed/simple;
	bh=4IZe9HAZq04Ps0ki9gR0ZnA3bJ0ymxKIJG23Sw2F54w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dxiCVVLCR/LV0zCHQ+xuls+1Yti8MHxATA4p7LvXDeh/oDlJ2GCKoDOBp0XnDUTNw+Laf3u0VDKkG6SAyawS7K12GzilmqLib2vWPrRZgkKGf5U53HsfVtHDSI6gYMGyWp+udmwNnlxWKiI0C8NyEr9wUYdKsGnseP+ZlQPJoTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=atjIHQ50; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718105291; x=1749641291;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4IZe9HAZq04Ps0ki9gR0ZnA3bJ0ymxKIJG23Sw2F54w=;
  b=atjIHQ50G1//3HXmL/l2bpXc7EWwBTKeT2Ndpc3A7AsTS5fACD7ploIf
   nveqjloezMj1ZwU/eTP3DemFARmdx2SOmTHENGpM2kyUI1zf4PHjJ2qn0
   MMc+tpCVl9dndgAMYXpw/CEy5bq0VlLEvLgkG1KcJWaTd8cOPx5ecNZjX
   vM7QM2w2CW2x9wot2Y1KcKH1Y6hvpAXJUEtzhwxbZJHg1fRvypR2ayUkS
   RerGZXVjR0HBdCvdiGhCPz/d7v+wvuZ5wm+VQyYK2skfcJ20j+6/Pr98T
   DlN5yHfVVZS9ZBmGd638k3lzTIrMmadp/Za5imIBS88zSukJ9SLcdJiom
   Q==;
X-CSE-ConnectionGUID: WM6EW3gUSoel4/jl22nM3Q==
X-CSE-MsgGUID: deDw4P2UTGOCz5A6s7ZhtQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="14687731"
X-IronPort-AV: E=Sophos;i="6.08,229,1712646000"; 
   d="scan'208";a="14687731"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 04:27:32 -0700
X-CSE-ConnectionGUID: kAgTcmPKQn+IeG+dz0w+6Q==
X-CSE-MsgGUID: JtACllDbRPiQaHwmkpiq1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,229,1712646000"; 
   d="scan'208";a="44535832"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 04:27:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 04:27:31 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 04:27:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 04:27:30 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 04:27:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7hEUvZKbo1JJhZAD2s9L7Rx2lg+pjXwY6IIJEOd4qt0cWTah1jbxLOA0u1UwUKqDSG0tzQMpEBpgW4onI0Fn3wv345tLSDlPVsXIGhHdkMoAJ8QACbAYmu1KD6+gelf0lbRfBCyA0+I2kie6nztlQneDCEwAwIOSz47GtHb9J2F6Vr+6aMwPjQBQTRaBCn18qvFDfylrooAPDpKaVfCEark5PyrZSqoOU2q/LBZXAEaeCccIAtjQL7LcoE7OMK9/dmx/h6Ht52zC+NNQJmI1aJN8hyxmazLmXQCT/5zdyIETSt4GMLqxy9W7CtzhVpekOPaANfz4J8YF53zjqq66w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUdzL8fzg2tORoyh46uKgbpNYOpC2Sl4+3IXO66SdBk=;
 b=Y02TFJhBjIgoAGK7b5/DLedrnO5i1hxzKqGg2jOsmkWhtsW/uGiW+IViwLHA6oFbPtpX/f02iJCCVOpzxWSKh+T925Uu2x8FEVsbNATJ4PVwjq4NWqZ62/EJcAPE24huj1N4/KHaJNKyFAIbX594HSB02gM76TTwiLUFbpOT8I87UH/uU1qBRxf4Aq/2lifpBOBxU+B89CdQec7e6NCwe1/rSucVS8ZCdr8EpOZ7FgDWoY53uRstgvhg5ReMn/ZzLePEpI6HfqMvTVaye8zUR5Aov88JkI2p2rn6fW4QBJs4TNTfGpcsOTftYYe7fHY5bOWaJPSVssQhqZRffur/cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH7PR11MB6608.namprd11.prod.outlook.com (2603:10b6:510:1b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Tue, 11 Jun
 2024 11:27:28 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%7]) with mapi id 15.20.7633.037; Tue, 11 Jun 2024
 11:27:27 +0000
Date: Tue, 11 Jun 2024 12:27:22 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Alex Williamson <alex.williamson@redhat.com>, "Zeng, Xin"
	<xin.zeng@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>, Arnd Bergmann
	<arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
	<yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "Cao, Yahui" <yahui.cao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/qat: add PCI_IOV dependency
Message-ID: <Zmg0muHFdWEp+M1x@gcabiddu-mobl.ger.corp.intel.com>
References: <20240528120501.3382554-1-arnd@kernel.org>
 <BN9PR11MB5276C0C078CF069F2BBE01018CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB55026977EA998C81870B32E688F22@DM4PR11MB5502.namprd11.prod.outlook.com>
 <BN9PR11MB5276ABB8C332CC8810CB1AD18CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB5502763ABCC526E7F277363888FC2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240607153406.60355e6c.alex.williamson@redhat.com>
 <ZmcbNa4yn+/0NnTD@gcabiddu-mobl.ger.corp.intel.com>
 <ZmfCkiuiag34_mjO@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZmfCkiuiag34_mjO@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: ZR0P278CA0147.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::21) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH7PR11MB6608:EE_
X-MS-Office365-Filtering-Correlation-Id: 673eb9bb-ff49-4e15-50ba-08dc8a097983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tZklFFdmMH1I6jbD5a54uFSILnh9spAufXdfKvmLqpe+0eiT1UsazpadRKUE?=
 =?us-ascii?Q?fGOrWFp9qtmw15GrA07Z/tQ78hsM7PDSIw7mwHn5WDyZHBvIduKpF/TG7Z0L?=
 =?us-ascii?Q?Sr8cv+7xiZQW3DtBky4Zr7GehD8iara9j7mg3wb6ykBQZRbNVpI4e2O/yRqO?=
 =?us-ascii?Q?T9CcO7EahCvNU8A3kUgL9XgQI5TORZEsZqFea8llU0lgDIaqUj1TV1r0S6K1?=
 =?us-ascii?Q?qtxmrJywm9RTm5e7sG5sdvOTOZdv6fx4/v44Ze0wWVOiBRw5TKNUTlV/w1sZ?=
 =?us-ascii?Q?IeC4cba+HoqnSOsECbU7rBju247/zbw5v6dUQJEyJpeK8r+CTRqMkIJLzEMp?=
 =?us-ascii?Q?+Tub1VGEQulf1/LFwRFlqfGiFwiOXcOIPwILhXDqFSxwZMkA6H+RsUbxUpSS?=
 =?us-ascii?Q?ARSqNqdIBZDksPDOpvCn10N5RWqGTrgQNSuUztzvVMp0yvA0bXpXindLfDw0?=
 =?us-ascii?Q?R/TSz4FeoIe09w42M9q82hFJd0qHiIp4HxYKarv0H+ASpztHZYpyjxXEGpoP?=
 =?us-ascii?Q?ZLnzrYKTAnDA4KC0cl+T3jkLdW2llmZPdtxL0UM2AlPIN9h00R7STKGF/bKT?=
 =?us-ascii?Q?6TuMJjVpVwIKxemxJH7j7KkIimiXWEcClj/z9DDtaPC1yJ56H/XnAgULKpNt?=
 =?us-ascii?Q?AgBymc/0sL5GxliwJICyGfD8EuZYm35m0imxG4D6KSXVnBlbAAQcWIi3RZsJ?=
 =?us-ascii?Q?uya3l6BOt3TWpt48GpzWrz0Dv694Mir7syJyIcCvDe1hLk1DGz5L9rXxKPR8?=
 =?us-ascii?Q?nzjT4CicocDKVDK0GOKsnKScaivGH5Xz2g9tiMiP6zlb0AoRityloqtNZD2k?=
 =?us-ascii?Q?2Qzo/Pntl0qPtuMrQwaiKbR9EmS9WTvl6juFDPRj5dFaTMUXP2cqe8Z5hBDa?=
 =?us-ascii?Q?hkdtf8Dl7okMaVBh/P0OKWzN3JMfjNP9E+7HXIIFAUhqrbGngYUF/+BD3Tas?=
 =?us-ascii?Q?cKXT05bmarD7ct0i7hY4zZk+xrOx594rmEQSqzp7IrEsAiT4IIjIDjEemioc?=
 =?us-ascii?Q?gMq8gNBOGfw6H7FOqyCf2MHTzL8/F7Vl4yhKkTRv6SU6+aLWenkctf7EAQUL?=
 =?us-ascii?Q?DMKTLKA5KDgI30sdkglaOsVSejpzDqcUZXu2N7WOZ4csDC/Un99fgslwtt3U?=
 =?us-ascii?Q?Ffk1Wb4mCisW4ebVEqPPzpyKbRaUfVJ8lgJNGAEX+9f+ix83eb3a+YLX9tfY?=
 =?us-ascii?Q?hyBEUHlPHpjcx0osELiJIp7lw8o35QIBFisdHNPpMAvd+QjzIQ1B41y65XCR?=
 =?us-ascii?Q?N3kAwRwsSaRhX1l+7gs+1fP2uVajXZGQt2FT6ENEtAvDVQNCIrW+niMrTU2d?=
 =?us-ascii?Q?/gMe74I0WZxZQxZgM4WbHywQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GhsDgWhe/IzVBDCs1Zjg9S8oxqrMiwrtAFMuG7cHHvLjJHfhi/u3J+iSxmHv?=
 =?us-ascii?Q?kA/VNCjwc7nnl2r+rmJMSXxlWtBEQngSZ6f7NnD0+wL40ntC6//st8LJ6yoU?=
 =?us-ascii?Q?ekhph1fOz8yfhncQz3x6aViB3Bf1z0KpXsgZg6su9ip4E1sJ3YyvByVYOm2x?=
 =?us-ascii?Q?gtKUEMnqAIrZroikrwGQ6LIymD0g2jdpT2X/CS2bDHSFDQJaQk5IN4Y3HvC1?=
 =?us-ascii?Q?R5AoQbsiGozzRPBOe86xOZJvUtYW2/WKQH3QKBPEgm3ReZrr19Qo/o/bmjHj?=
 =?us-ascii?Q?FCLyksJiHDbPDc4utAhGyQNINMcPxawTi5aGXmhxCckVy+uHgDXi30CR1nvU?=
 =?us-ascii?Q?KYY43l3WwUucMP4Xy/PMSs0+A2mf9bQumvQmEvKJDSqyJydGMLyeG/pi/k6W?=
 =?us-ascii?Q?to+XnJaI585o8C/yvNk7LhtL/Q8UdOrdOpi519Ryu8bzfFqnG7bkuvqq10aS?=
 =?us-ascii?Q?BGWH73i514d7lBtza2JifFZg84Dc3d+KgPnHv2IFFaxrnQfLf2J9kfOVIMij?=
 =?us-ascii?Q?kYz+Iw0SmRoxs/ja4KZkwZoeaeLF9oLR03BGzuwrtBTE77iLrzQa+y1tNByq?=
 =?us-ascii?Q?Yb0ViQ7Ky47Kkhur9tIJzx7oISKMetvg4ny8KL2JA6sze53Zmsa7KVg6fI+Y?=
 =?us-ascii?Q?h4nlpZihn41NBU8CdX20uryt00SAl7x0UsSK7Q/Y9HRldNKDLrxi+pU7a0Uj?=
 =?us-ascii?Q?4uSxN6+Gs9/hzuUIZVjD6NmzPWaAsR33qgeJVo+3qLyyPo8x13k5hKZr2hFw?=
 =?us-ascii?Q?X0kXsshlTlrgpJT5UYirZiO6oKYeeuDUs42WsvC7VBRvpdUijaaWkhdkQFqV?=
 =?us-ascii?Q?WQB5ot8b92GCSKEAbbV+9JQSq61lr6wnuTbZZ+VkxwozeK8fbL3bOg2P4pQ/?=
 =?us-ascii?Q?fPkEPEcR9FsWbyUViz3GHJYfl6Q4+q4nJUYWlrvpPJQlstbfBICREVf9q48D?=
 =?us-ascii?Q?i7eDUaFBUhmo60MtL6wR17n9hww3tJ5fEXAc311sgk3Tobc5tCtVm3nhZ9pQ?=
 =?us-ascii?Q?63kH8pmssiFYB0CpiYg6cNnhotHNxI1ODT1sL1v2QLF6RHmpH03DSGWLbcSO?=
 =?us-ascii?Q?nPtBAlX0seTHabgqZhONr5KsXiF2Hka84xGTsRm2+G28oORL9YhxJjESf+1b?=
 =?us-ascii?Q?I6W6x0HcRlgwRPsz297d25sZU2QHOGzaiY8rz0veXUqBFL34ShvuwkNU5oqY?=
 =?us-ascii?Q?LpK2vzPy8kRCF4+pJHyTJHgOcHIcpZCxsVhwY5AkzPpLR5vKnStDR7kRvXZx?=
 =?us-ascii?Q?RMTGC7cQpwU/mpU6Gf/BQI4DVuY3D3JR/59b9qhO0x6yanZvVypeAYwMP6ks?=
 =?us-ascii?Q?BOntDPX9RAbvaBKfcN81VKFklZG/z2fgQEzzWpSX0j4bTeIVYjuRYFWgUSvT?=
 =?us-ascii?Q?b49EGeREMOulgOvXzlqLIUFgYGa7O0I8NPU7yasMBlhLx5JjskM/VKg9ofoG?=
 =?us-ascii?Q?BbNI2vrf+XAozfhnEmnj1FnrVsKtNiyJaJjYaBF8v79It4qF+roWvStM8SUf?=
 =?us-ascii?Q?pzyzVyIPFlwTRqzcrxM4kB6CiVltN5SV83jQ07jmr/ggR2HU523mmpGDMqxy?=
 =?us-ascii?Q?0tF2RdawQKQkc0WeP++DU+nsKO20iAHTQy7KLyTvNIdzHa5hxu1jfwWXF/o6?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 673eb9bb-ff49-4e15-50ba-08dc8a097983
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 11:27:27.8562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yeba2X2ZWn/qD7ONaaF/go0DSeQs+2ofNmeuOAIxREbHAuebncVGHnIjEtzTB5dZSK/1QfEqZl/bGEC7YQQ3FVTRT0b1ZLyP9LH5UIQtnYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6608
X-OriginatorOrg: intel.com

Hi Herbert,

On Tue, Jun 11, 2024 at 11:20:50AM +0800, Herbert Xu wrote:
> On Mon, Jun 10, 2024 at 04:26:59PM +0100, Cabiddu, Giovanni wrote:
> > On Fri, Jun 07, 2024 at 03:34:06PM -0600, Alex Williamson wrote:
> > > Is this then being taken care of in the QAT PF driver?  Are there
> > > patches posted targeting v6.10?
> > Yes. This is being taken care in the QAT PF driver. Xin just sent a fix
> > for it [1].
> > @Herbert, can this be sent to stable after the review?
> 
> This patch wasn't sent to linux-crypto so I cannot apply it.
Was sent yesterday to linux-crypto:
https://patchwork.kernel.org/project/linux-crypto/patch/20240610143756.2031626-1-xin.zeng@intel.com/

> In any case, is there any reason why the fix can't go through the
> vfio tree?
It is a change in the QAT driver. That's why I asked.

Anyway, it should be fixed as part of v6.10 - I was wrong saying it
should be sent to stable.

Regards,

-- 
Giovanni

