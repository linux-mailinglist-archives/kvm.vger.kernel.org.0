Return-Path: <kvm+bounces-52084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E355B01192
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 05:16:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA9F31741A9
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 03:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48B619C556;
	Fri, 11 Jul 2025 03:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TSXDZOdw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683322AD04
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 03:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752203782; cv=fail; b=BnGTF39YnPx4gwNiS3T5rt9EjF1sDyaGQ31/Q3MUfusWUjLn00657p9HGLLdh/U8xRKKzb1/9t0Rwbrqt0XvZvvHJCKhlWfYQUTOZI6PG+N9tfqb8sPFzSeZQ5jTnbA+zJk3SJVPq3zxsySYczJrzJNfIFFR/VFI2TlVjWCNJ4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752203782; c=relaxed/simple;
	bh=dEq43tsJvaIgQgG+23C59AnTjsF52YSylu/XhNod+3Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=REzGY/0cd1gUt1hsoP95H3oXZ+xKzQo8HvIhuqw/xCDNM/IJD9ocJGyy8vWj8SQx7mNTYLEE05PDFyF/yvgG5zl8VoVCWIUW5ormTvGeKhqeU+kr+9mIFQ1Kd/Lu4QVcQ2nZxjrmxV1meUjSwWe72IM16qoOvXdtd2vwwzrtOgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TSXDZOdw; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752203781; x=1783739781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dEq43tsJvaIgQgG+23C59AnTjsF52YSylu/XhNod+3Q=;
  b=TSXDZOdwXEDgP7zQyTcPd8wat5N3iFWflkogYpJeiBTNfQcq//yEr3TE
   dL2wJoREHEZuZpBv976z6jYcGFf3UoDKNu/VA3Qtl8jZuCKuHF1CRpkpS
   mVyFe5V7An4ZI5KGrrWxvjCcllXvnu2a4fcO2XHVveTpZz6JmV6CLkGxs
   +Fv7sl+rIZmb09sqmsFUtOhSF+Qj+tfwOf/g6LYv5WwOPCjxtFEgasgbo
   A1ay2CjL28l0bZqLE1beRP5sHpXN/TB7KOjrzPRE9DR4/ZDvTbbX4zH2W
   9oS6j2Pt3FlNKuKPw4Ggg5XMajwl9DYzp8B4XXhWGTqNnR5hq15n386Ou
   g==;
X-CSE-ConnectionGUID: QAV5LdmcRhqubsoXbEFp1w==
X-CSE-MsgGUID: rK+/WN35QmqBallMiurX2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="42129897"
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="42129897"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 20:16:14 -0700
X-CSE-ConnectionGUID: GmLUNB/NTf+rZtdlRFBFyg==
X-CSE-MsgGUID: IBH1+AW4RaydFxMXgwS1Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="155676153"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 20:16:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 20:16:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 20:16:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 20:16:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iEgFXS7+1AxeHn8nJ1rs9q3ldAtcO/vg6clRiW8HuFfX4ghewRO0jOhKF33pybMMegELgZfViy6n5UEDnsDp6ukPn6B/bXgp9DoanTfhcNWpuvI4CXtttu4l2EJw8jeIrCs3GjJ8VhqPTl6LCn6Ya0PC4Uzvzysn8fbfs0OTJJO/s6ilq3OEEscLt3UgXZgm+jZ2seJh4xx/Wuh2CFQ4eiD2xhq16i/ZkXZeuoI3bE5LDay5HGReUopU+hYXPivIVO12mtsfMP9PMJraJLWv5hkFZ2MLk+XeTSiEyE0D+XkSz47H1XKjTtoc0/m4Ky5CQAtepVEthOBSK6v2aLs4hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZQ3a4wPrZlWRN0bKk9QuYPjfS2lj9/O+qUUeqTpCgc=;
 b=aoOBW2cZlqTMptUwyJWTXdsr+W7l5FyqA648msLeyANxI1RH2HiQeQZvcrJbjnxthlpTK4rXQ0mivrrat94V2uEZbpzsvh2qCbUehph/Yb9MP9glzw2+Az2zF0V0heSpA0QxCDpWNYqjaIG5SGZpKw4zMn86ADDjmWY8d6TvQ6RuOiqPHxMDLAqycG5Q3HXWi/wfcYYfh0Y/uhyj9NKJU2zkSAT3rB/2kTiCY0+lRn3cs4w+u0ONWv78k5wQlpHi2pNqoDrnBxG2tYVRtIZS7FHXLzL2g7P0whEA019vX7vslHGplBYrRcrE0cYPELtazP8yRZehf3IP5JhgLCHUGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7715.namprd11.prod.outlook.com (2603:10b6:a03:4f4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Fri, 11 Jul
 2025 03:15:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8901.024; Fri, 11 Jul 2025
 03:15:28 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>, Brett
 Creeley <brett.creeley@amd.com>, "Cabiddu, Giovanni"
	<giovanni.cabiddu@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Longfang Liu <liulongfang@huawei.com>, qat-linux <qat-linux@intel.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, "Zeng,
 Xin" <xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, Matthew Rosato
	<mjrosato@linux.ibm.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "Xu, Terrence"
	<terrence.xu@intel.com>, "Jiang, Yanting" <yanting.jiang@intel.com>, "Liu, Yi
 L" <yi.l.liu@intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v2] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v2] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHb8a+qjHF+d/C0QkaqfUj98TUuWLQsQJww
Date: Fri, 11 Jul 2025 03:15:28 +0000
Message-ID: <BN9PR11MB5276AA956A0674CD8C708CD08C4BA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
In-Reply-To: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7715:EE_
x-ms-office365-filtering-correlation-id: b7feaa23-2f36-4aae-1592-08ddc0292ff7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?jbu3oSYoKzqLXVjGvf/d6VrqiPNBNH//dUGg3j6VgCmR4U8HUv7o1Ma3+ztK?=
 =?us-ascii?Q?wdCeCk5EeJFClpVa7vh63ZDsKTowTf04IeL5+mu47sJ7xwMvLODOi3KOnHM3?=
 =?us-ascii?Q?M8eyXHi6ZIVcJ6bcRDy3iP02zPyuzS017fD16CW+X9vgT+jVsa5VJhfSIn3X?=
 =?us-ascii?Q?s8DNgMXOtHhviBPUmWkYrMKYQ7zlBWGH48tD4o2oFd/sBISdKDfh7IZOgvg0?=
 =?us-ascii?Q?g1jElpcjhfj61Z2WlNo3DMQ1z/se7LOMilR6zp6X9HrbwYGE7Us6TT8JT/fC?=
 =?us-ascii?Q?GYyCYLae/Sc5QC+McRozBTn4VfX4K1EKKTO531kEsXsZhyKB4gppEJ+uGX8y?=
 =?us-ascii?Q?Yc0AXtL1EldBCoUDFia5nGsU7vT/iTpsa98sAnln1Ul5IK03zJEHzK4ygim0?=
 =?us-ascii?Q?MvV5bzncbthbCI8s/e1YgayMWlIzXOOtYjx9qkO8nlaEqgXcp9gm7KcapI4V?=
 =?us-ascii?Q?n0hOYtjIUl9rWPI6AKcZpFCjVtBhRLPg+VwJlw6juuYNouizLBFszp9WXP2Z?=
 =?us-ascii?Q?4hkZzeH9dAsNgbch1hV6KhxPhMTFuqsRDpQdtGY0f7mbId6DKB99XviK9gRY?=
 =?us-ascii?Q?HxCwIPbr/4GBijf3gwo10jcndkr/fy6yT0TbfzlyI6nfDj7iXKnAGFAzf1k4?=
 =?us-ascii?Q?89CArZ27Qql/MCaQHQ8aNcj3FQnZU9qzDI7utAWelTcabMfwiE/k7Xmvmpab?=
 =?us-ascii?Q?KvJk6cZW6ijpoQfwocimnh1T5QWDvGCrnHIAXkKp8MXnPXIvDO4gGye04fPZ?=
 =?us-ascii?Q?8bRHOWV1r1iHJ4ILeUgUSoR4RUIdx5HTbB9ryTSQ38dE/FZ4R1j/S6SygrSP?=
 =?us-ascii?Q?I/qohuKo7sn3zYF0+AokkKU5MiQdmdqJG4y/nQI4D2HlnYe5F4n2S3XdY/7o?=
 =?us-ascii?Q?06Flbm1FAprm2O6H1cSFmlEDOiVohUOnDElcVHvuIzSLIAIPsO5d4LSKp4j5?=
 =?us-ascii?Q?QZGmUJqlSZcvXI8VFbzeyAAVdRjS8pabWfPYmvdGL4g/sZycjQgFDajfd7p3?=
 =?us-ascii?Q?zTZdiCIKKpSCwvgFq0PvCD8h87LLuVCcsP5kGfBTeEmBVdOs3tcRk1nFwx5j?=
 =?us-ascii?Q?QUXMSdgT5VaQ8ElqDz4UIXaOhgV7X8xFhWlDcq/clElOqRQgbMQM63Yi/WhY?=
 =?us-ascii?Q?2C1mDveu4+0KIbVi//7mX45bivaxcA9GLFUykc0aTXDtEJBzIm81EgJPYHky?=
 =?us-ascii?Q?QastkYxurG4YikSPlRLptHGsZh484a2F64PQC7IMzONT7W8M0NWQShpUx1v2?=
 =?us-ascii?Q?pIu0F8t6jM5kM+4fbrZ04GKoec2jMD52mTZlq8VPp6w5GagYk06a6dxp4uAV?=
 =?us-ascii?Q?vs1j1AeQGWolbKL3Try46QIQtVygr8/RUEARF7/KVYwrAV0Vxm1+xwTtFZWZ?=
 =?us-ascii?Q?dui+tEvitpXKXnV/uvVOaLEO8FK1wlBb+0aaIuHJeLb1e2chxAgXiFF1F8h4?=
 =?us-ascii?Q?OFvvT7XWT1570vDnGYykkaMzsUOdBOBDV07hJc188iYjxLKjW4vZQmznS1sU?=
 =?us-ascii?Q?sB/Z4qXQJlvUmgE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G/YPcQYqbPJjeHF81J2TGleM9ZeICqUOYC4NyOSmMKvl6Oe4npGZoz/ecSzh?=
 =?us-ascii?Q?VGyv04K8fD6QZtx0TtXVBvdi3X+2HkajF0AURhwq2Low5b6S5kXf1c0aHznh?=
 =?us-ascii?Q?PebzITJQ7F9Hk6wplVz+lsjzdT/NpyjlnFCXWK5xQT46ScmHdq1Dw0/Ch6R2?=
 =?us-ascii?Q?S2qHiXnnTdFyzYNiptzHfugS8Fpp2eQ0jwco91PxLIMwk+a9XERMuo1ZbEAX?=
 =?us-ascii?Q?qhvTRjJUxULWjrqnmKPjCJtxUimDXZrw0LmgPAXGQr3dg3qSjbbJv4PkJ1aI?=
 =?us-ascii?Q?2bkujeiY+WBEYe8aveqtUJ9YYvtQsit4HzhWfQZQkj7ZzPVZrbBEkwKjjZ9C?=
 =?us-ascii?Q?/cARfQgbzft9kCoXl+myfGRcV5Djb6/0lzcl1gdcYh+rVtNlin1+BJPrfyly?=
 =?us-ascii?Q?a34MrWMYK+DkTe3fMuXJEu0elP/Mdy66W3hCUgzIlaZFh9Ms1RLpbfFrlHSV?=
 =?us-ascii?Q?LFP9MpCGFAw0xCIqzWRRDjgsq3/URYYmO5b8HC7X6AUkdkmuZUULkb1LOg3t?=
 =?us-ascii?Q?CvCKHhtaPVs1oEoPtxdZsziZPmpJOZqeTUcl5KVGY4O8PtmDBBsqvymOhF6G?=
 =?us-ascii?Q?kjEPFoClaIjn6I8bFK7lKg1Krp7ttsnxws+eWhmHeMd8Sh21Os8DJF/rTt+u?=
 =?us-ascii?Q?2n3aWh6Z5nYjd6xOplL6c4wv6G4S11pPqjaUKd2SfxhQW/RUg6KskES7gGt8?=
 =?us-ascii?Q?Eyt081/R8H/xBGMPjYINAnOlpXN4IocD+6XfAGfvuRLtH4Z97+m2Eex3IV0o?=
 =?us-ascii?Q?Zf+e8xy8ZiFrs3/dhPKZkpKI5hpLonb+qXLEUKiMkca5dCnl0hPPL61HDA6M?=
 =?us-ascii?Q?l3MLhNcB9tr/YUgmKrZW+brLHWXR2EXlaI7RJly64f6cw41ZygPb20mLtGJl?=
 =?us-ascii?Q?shYrzRXtKusSovZwfM+AGPMzytTHtMY58ub1gXw8fS2u9m82DR9llbgy+aEb?=
 =?us-ascii?Q?hepwydEeuMP8SI4ST1Xnr7l06RFxSpFr0uFeKmcvyxJq27uMUxJ7TSxLSm/L?=
 =?us-ascii?Q?XhDyMqc1GdBNNgcK7q0V4bupZiEWA31On2ZY4V4SKng555ASBD47jgZ/dpAT?=
 =?us-ascii?Q?DUXlGbySxK0niC1c/pXYXDPN2rSOIC23tlV87Io+G7F3ws7am0zKQyS4Xx5h?=
 =?us-ascii?Q?CsfDgFg4xXDURutYhakWDzrS9gSf7eqjHWfyMMaeJXOGlWZ/bvTDyvUnLKIj?=
 =?us-ascii?Q?DFcFEu8oinSGuPbl6HPHLmTcJ/dG7V9OiJsG3mjIVdQXivT4VqpIyp2Pqjo5?=
 =?us-ascii?Q?TGi6D/N7Bsl+Fd0qBAvzu/Lqvk8fGaGTJe2fuYjn3wlW6fd/sxUbvL2ifkHG?=
 =?us-ascii?Q?7j8yCmCckeJvZ+0XA/dj5ZXEHEpOiv3d6JI6L+sJz47szZHWs3HDMjX92sD2?=
 =?us-ascii?Q?zS/Jg188cEbxnt4JtjqooeVJ4w5ZiEPkehSW9e9xDOrbiViyzji9qi4m3Vzs?=
 =?us-ascii?Q?ftl7MwFf3MCLoictfP7fzOWXKwdr/U7y0t+WldvYMBh5BDT0cmoBbh2K/vBV?=
 =?us-ascii?Q?HMVjOSEdM7gY8J7sluBptUdr7l3RR71/n5PbIGdRAqnyhCogBvO+AiG/r+rv?=
 =?us-ascii?Q?nQ/d6WHPFAi0YLcsPWEZXRSjmQm1SrZGAIrRZTWX?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b7feaa23-2f36-4aae-1592-08ddc0292ff7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 03:15:28.6796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iWik2smMliLdrZagwqDeqhKi5G9/vIkj+d3vEhIxTPDRqHARN5VLKtnqTToeq88hYEFwL8eDPfVtVgWESvGPMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7715
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 10, 2025 11:30 PM
>=20
> This was missed during the initial implementation. The VFIO PCI encodes
> the vf_token inside the device name when opening the device from the
> group
> FD, something like:
>=20
>   "0000:04:10.0 vf_token=3Dbd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
>=20
> This is used to control access to a VF unless there is co-ordination with
> the owner of the PF.
>=20
> Since we no longer have a device name, pass the token directly through
> VFIO_DEVICE_BIND_IOMMUFD using an optional field indicated by
> VFIO_DEVICE_BIND_TOKEN.
>=20
> Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

