Return-Path: <kvm+bounces-63629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 62380C6C14E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:04:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 48721363927
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502012264BA;
	Wed, 19 Nov 2025 00:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DUjB6QmF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC20738DD3;
	Wed, 19 Nov 2025 00:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763510529; cv=fail; b=FaOTP3E4GpcEUalRdx3NF4IKXT96g6/yYz4WLbb4BDuTkmck88UPXQqizIo8uNBTng4bWQQoe9BWpOnWNH7eA5kXTVWst5WHuZoaYSYVyefGf5SEJdI6nPHXt45daSgZe0a1GapWD0mknv7IXcsWFfb+n0MV8fS4013UTUDtb6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763510529; c=relaxed/simple;
	bh=ip170kNN9ZrWGT522gwS+mpQ9sknuDvUDUnQsxpbSxY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H8ToFGf3mtEx74jRBQVau/A/CAmh/0bN6mtG1rUKVDMhpeFfUjfaHVrhybcgt43YxbAT6o24uHEreKrzntUERRpjATsbQ4vbdpGvvZ924lqopPpmgb3deMgJpdV9rOYLr+4/0yqrfC1XW+zxLD118QgL7mn4wiOgZx+jbqEkvow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DUjB6QmF; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763510528; x=1795046528;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ip170kNN9ZrWGT522gwS+mpQ9sknuDvUDUnQsxpbSxY=;
  b=DUjB6QmFf/A91E/tk98Mlj1SiLsr4Ky36I+F6Ilf+/mg8jHFZXkqTO/3
   aqRBqlw+ud5kTpsdv9ZMZDWVMRbKqXfBpoGeLFiyNBgezb2+A2Sw6YcYE
   y+6fiMp/sKyIKtv2hObrFZ5gBSON38DcyJd1zeS1uwLBplTtuqpgt5cyF
   aojooLaTPx+fLY6XRyOJJdgOtRRf61au9L5x4hqp1P89U+fpr87HBiUAG
   oNoAgTqDY4NtBy/2X4Zee6bjGN7ZGyr4MyiOavAM/412Mt++EftRf1hb5
   TiFb09I5/iSXx1Qxb2qyTg/IFmzmhiDWDGfhVvDFf3/vS1GFyDlSJuUC/
   Q==;
X-CSE-ConnectionGUID: CIArf7w1R1C9IGycjXEKSg==
X-CSE-MsgGUID: U59S82DtTaaC7MjqfyzDLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="69162088"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="69162088"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 16:02:06 -0800
X-CSE-ConnectionGUID: nOEIotLsSw2n9aYKviX51w==
X-CSE-MsgGUID: UTubz14iSZKWqLXHFShD/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190173647"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 16:02:05 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 16:02:05 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 16:02:05 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.71)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 16:02:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ur6xjk/1XmkrArbNa1bAMbM5xQfnZRJJdPcF1AhbURSOiVSKVzP1K61JQNf/7304PxcSIWGd8bVWpkfEGb4fVSUIflXheM4xaK5OAcPWX9GA815UYwgglYkM5QO/RwD3dFOoI7lie90niQ0BuE8kZXTxOMHWuEdtIShhiHS3oC9VZ8VvXIPXlzXYkmXYbooON9fOIadnHfA078AUZp6PcS1UvBCIMyN/pOYloKS8eLjNRDupAkakWFXr1RtktOjqQ3tI5FBSKLtd+Ojv7MchXKskpHjfYsKGDg4IKVn8THdM3tXpnc3KoSs09Vl86MIkzeFq0aKMXUZM8kQCJYwBLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ip170kNN9ZrWGT522gwS+mpQ9sknuDvUDUnQsxpbSxY=;
 b=YIGekOwbtkqCCfykb6p0Qo93Pyn8HpwZg+oyW3X2zuTUzZT1tLoDkHAAHRo53l4gjC8YWwqUSODHgB4gb/XtO5zKj9eiDJTia/y6HCdsG7CVso0vrhd57ZcTFrooOlYe0mhPjfuRdWMd9yOGJ/apjVxWfni6/EsMr85X7UfI1TW/z6ZQWZRzuHRUVxz6qL7d7Jc30bomUumBaDJe51FePtqfscbFY14CfzcYLxUenUSqLGixKFrKqPwHq9ECwJSf0XarO1IUZgR6ySZVaiole+ds1SlkShOLYWmrv82BVyiOJ7FK2IcAitWcZWtpez9xEevhXnV4doJDCuzkCYIsbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB5959.namprd11.prod.outlook.com (2603:10b6:510:1e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 00:02:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 00:02:02 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Keith Busch <kbusch@kernel.org>
CC: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, "Robin
 Murphy" <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
	=?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, Kees Cook
	<kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, "Ankit
 Agrawal" <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "Shameer
 Kolothum" <skolothumtho@nvidia.com>, Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, Alex Mastro <amastro@fb.com>, Nicolin Chen
	<nicolinc@nvidia.com>
Subject: RE: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Thread-Topic: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Thread-Index: AQHcUvHIktoMrvUl+keVP/eL057qqrT4D0PwgADb7wCAAD5E0A==
Date: Wed, 19 Nov 2025 00:02:02 +0000
Message-ID: <BN9PR11MB52768D54FF42AB11C49202C98CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-9-fd9aa5df478f@nvidia.com>
 <BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRzUpmUkDy-qN5c1@kbusch-mbp>
In-Reply-To: <aRzUpmUkDy-qN5c1@kbusch-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB5959:EE_
x-ms-office365-filtering-correlation-id: 6fd54202-3187-45c2-3838-08de26fede61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?r5w7DSRc5AJzs+j+siLw/hFD3oikHPcMUvtoLp6ZKH44Gh5cQEArQZRR6L?=
 =?iso-8859-1?Q?Et1EL1Hj23fpMaN9Puv12BOECxatn4gw9G2lNX4fQ7PfZAkx23E3yMkgJE?=
 =?iso-8859-1?Q?tle0A7gJ9IQt398Bpf2tFkqCUbjTT6QLG7XKP0JWGAvYG0QA53ENWOXoNi?=
 =?iso-8859-1?Q?db/+FO2DOD7PC0qYOhQtSfS0AnLTiRPY0yRFX/NsKbse8aEqnycsDnU9Tx?=
 =?iso-8859-1?Q?ditViUk1piHU4e3w77wG4EzyfggG631w0/n10RajDWPgqRChRkF81f1OdF?=
 =?iso-8859-1?Q?MF7c8eDNkN3z6XbbnhKfMASAAIGctgSQBHZ+b8qtlrfuhhTh4aIgDNPzaV?=
 =?iso-8859-1?Q?Xkq4ODlo0e2YxBmCZdVRQuaqVPqMWtphYnef3QeknbclZ/BvbuBXzoxKqe?=
 =?iso-8859-1?Q?QJ7F18R6fsGEf2geu/ftxA8iMg/YS4mxmaw9ZjhPRtxyq0T2YkHT52kl/D?=
 =?iso-8859-1?Q?kvHSsoQtLEbIspUqD0U4F4png8GTeQ5SnLBjfWSL1GTrEfaJO09r969k9c?=
 =?iso-8859-1?Q?qxP1HjHPGgg3GgbtHVp1Up3dtUONzwmPOqWGJ8asT87hGU0VdByd/23C7S?=
 =?iso-8859-1?Q?THVj5miqCBpcoc+Z5JpflUCRDjASSU2cdqwERksEvPnYxbcL3V2Rbe46Yz?=
 =?iso-8859-1?Q?QbFIfuX2noCivJyl4OS3EA41pS5zvjQsZtWaYW41U8HVUEtiGbhpUXZpSN?=
 =?iso-8859-1?Q?Vo1/jL0YlHRbbc5kStG1Ix50Lh6afBakLG2dTzMHvcz6sxQPMHiSf90N2I?=
 =?iso-8859-1?Q?KOL90SwLmJC2ZnzdvoCmxwU0nmBPI7uSMKopj2cy9dYRrxg8EiFQcgEyPH?=
 =?iso-8859-1?Q?wjEtoFjgsy2C+OhkKheZMGRNDKjWsYNuyFrF1VWockQoZW1tSkLzy/XCsE?=
 =?iso-8859-1?Q?35iH1pAdEy8gtD+OQFKTWk+VOOjXJfiYTRTyBoKwlacZrtvPszEfwJPZx8?=
 =?iso-8859-1?Q?uHSfbRpW0fMBgW/uy+LlmT0xA67jqAZwM6qHDFXHqRR349+8yYnllWQstG?=
 =?iso-8859-1?Q?0RuB3C4cQPBuKKv7Ha12MNpAm/3VYd80fbJKUtw+VRtnOIJVpht9MN2XBq?=
 =?iso-8859-1?Q?8z+MDbfbQ9w7hpS1fphp2Mpil+m0x/JM01LRaYzPvZ80NEHQ//ntKvtz8V?=
 =?iso-8859-1?Q?0+OfqM0CoxJFL/jx3Kj2er9jr5oYyguQzwGmxfPI70mBamJV8IRkhdyxu9?=
 =?iso-8859-1?Q?xhLBbz2p5wqRSlXDqawUXdfrzgz+KRnf7VZPf2rB/XTF+S+dL05uGPbDVL?=
 =?iso-8859-1?Q?ibClpywMF2iRO++gs9YJtp/Wti35CoBFVwIKoLwHdVQmys2+E+/ckhFx0l?=
 =?iso-8859-1?Q?opKqR40MdggG9/VO7Yx6YhCS8lKyVQQ0EoCscMyq40fOSrcDNLtKLqKJob?=
 =?iso-8859-1?Q?wvE8eSRBYyO8pWZZ/mEayOOmi5Z3AbIwyKNBLIdXGl1lYJOshGIZJr2fqU?=
 =?iso-8859-1?Q?HJx3XnNyF10katgDE7QLGVCapunmKzOo5J39ZwtzfbDpTWfT6/fCzrA/Fq?=
 =?iso-8859-1?Q?Ds99anpEStwGKUU1NXJM0x5z+VZeRgU9kZiAwRPOUdbogZ3P+bb0McJfzV?=
 =?iso-8859-1?Q?OBhAliFDkSOMJqozhXVDV2t/HCyW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?oY+B1aiukEWZ+s3u9kpAkIXJ+8RE+7LX803t2nNjWwNoTDKoAw4Yf2AChN?=
 =?iso-8859-1?Q?cRc1QXhH7zBqp4ePv1Prc/j9BsAjSfGQYfsQCK+R8tdDbKeEPGnaTtEHh6?=
 =?iso-8859-1?Q?FeD45dUPgyA806KWI5kTMtOlVPaJmrb310BYssce7irIj7x7BpkIDb/tcM?=
 =?iso-8859-1?Q?z4ZP6cVu9ml4kjUJo93mIi4nx6yEyiA2RjgRJIqp21FY89PATzCwa71dOy?=
 =?iso-8859-1?Q?c1z0miGOjrxmAFYVbzgZ5MMUn+MBFkhP/ocuN1s45wlizM/sS0/pFGA6j5?=
 =?iso-8859-1?Q?0nnoJHfltRqgStEAunKN6dcQRlH/CLWOdl+T04XXS6vNSxep7gsk6BZGe5?=
 =?iso-8859-1?Q?7YGO0xHI07uDO0An2kqTZBMf7kduw2Mnbi1C3qPSY7m5q3w1lcOKiacZEo?=
 =?iso-8859-1?Q?uoW3gI9ZpHwk+DUg+AjMALewtYpdllv52qgUpO489gxTHUb3Se9sfufznQ?=
 =?iso-8859-1?Q?5tArXPXt0ge7gcNQEKRhSA0zIpiKiDX3X9r2wR5ryDzzITexkKdBjS2ow0?=
 =?iso-8859-1?Q?7TCDaEshyKFR1dI9zF/PlU9r4WneGAYlXvwbKq60CBAUSdAaMonbTP4A8e?=
 =?iso-8859-1?Q?xzltoSHbjJBRYvbeSCpWOS980WeqUh7iPuT/ZpnglMZVXYTKRu8sT8azjN?=
 =?iso-8859-1?Q?3bfpTAccdN4SHM7xQYyE5RU4wzE9xQ057Jpe7iWrcKX/B8J0g97jGHo3yk?=
 =?iso-8859-1?Q?UdmwseCqJzGqtWsmcv6jI7m8L9hW29E+6mSZS3kfeSegaWCCrjKJ4A8iri?=
 =?iso-8859-1?Q?jAjjsp6xoCruTMsXqdv4KbWvj/RzGajeoetwODGTHToaaK1/5NSOhocl61?=
 =?iso-8859-1?Q?IQaGB9AxKJlBLYTfNnlO0B3O4/ZJy1hWiRX/vI7w6plBlPnedYWg2J+2hZ?=
 =?iso-8859-1?Q?p8xo7zyVkxcOK7jPFbLvjDZQfGEpOd2XxcleBQ0J+jtOIN5YU9mz4CZ+qP?=
 =?iso-8859-1?Q?+3NfYcd445K8Mc791WfDRCcg/MXZSt5jb3NQxazHdJ30fL1pxdGfCaZFiA?=
 =?iso-8859-1?Q?aPNOTTOaWVe1exvDNgDrJgP12YhIAVTiW0zvRtU+IyOXNMakEzkqut2z8T?=
 =?iso-8859-1?Q?296dJjU/t2hGm8BDNjuWyVcr+cALH+U5tGEAsbahcRLH9Sga0UlMGVAJuc?=
 =?iso-8859-1?Q?7/bk08SJllWvJM/mCcwPobBJOyHp3GvMxY0meUa1aHYmr3jDPXKF+864td?=
 =?iso-8859-1?Q?AnppevSpMX0ThBS7Z2kCvUklDnC4xSqJW8YlMJliJCsp2m1HemIPQeiK1k?=
 =?iso-8859-1?Q?N12R3yrH2Q/isR0P/wGOE5Eut7ioM6b8veJx83bR2gxtaKBN5qhPqhnjZL?=
 =?iso-8859-1?Q?ww5aG0XsQeLtRgzm3dorwuty4n74GrAFuyryE8QgsD+2ZAC1iwgQyBi9ff?=
 =?iso-8859-1?Q?Z7EKQo4ec6iXgW8KsJgFJ9p9vv5cp6QkPFCteI/+XRW18HAUrY0NLdDNsn?=
 =?iso-8859-1?Q?HUEBXmgMrZckgF3+qYuNvrj/Xy9pL6khiWS4ujTyPpsyR8NevJIWSlZPzC?=
 =?iso-8859-1?Q?f5md+dRTkGB38hyr9nOquP+eCLJrFLip7ql9DAQFPh/ujayxzq22/lksNp?=
 =?iso-8859-1?Q?8t1EmpO9J9twtvTKZAVKQ1VPcuU1Fm+UI6//ouO79Qg2C2AJCB+b9fUxmc?=
 =?iso-8859-1?Q?RG98R4lBXtViGnT+PmQJl/yUihdEachZnc?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd54202-3187-45c2-3838-08de26fede61
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2025 00:02:02.7482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ar66e2sG9qLA0rnELQFzW5BypWG18lVCDMZERV1UV9p+HYv4XhWoYd1n6EvcQy6+P14uHL1hka62ctQm5a4lgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5959
X-OriginatorOrg: intel.com

> From: Keith Busch <kbusch@kernel.org>
> Sent: Wednesday, November 19, 2025 4:19 AM
>=20
> On Tue, Nov 18, 2025 at 07:18:36AM +0000, Tian, Kevin wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Tuesday, November 11, 2025 5:58 PM
> > >
> > > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > not required with only your own s-o-b
>=20
> That's automatically appended when the sender and signer don't match.
> It's not uncommon for developers to send from a kernel.org email but
> sign off with a corporate account, or the other way around.

Good to know.

