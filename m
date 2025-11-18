Return-Path: <kvm+bounces-63512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E5067C68188
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:01:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B8AD0352288
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3CFB303A34;
	Tue, 18 Nov 2025 07:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KRBwERj2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A854A2FBE00;
	Tue, 18 Nov 2025 07:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763452415; cv=fail; b=cbr6uImDCkSXCzn7LFKxS4RZeGbTWBv2u8pAujhla5SXIEAs0NNPVEC5FWFUT312D7FpycJ6ZMkxzQb+4LukXcQ6W5QOfrdalslOv7htxpDKG9EVCTwyoW0fTdHXBrroH6d6rW0eSQSgJAJvIGD5bZd5goIbl7g7xqHfjuARtjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763452415; c=relaxed/simple;
	bh=zuhtNGGI1Ya3amaZ3hvnUkmu5Iu4VYI2WIf/PvDO0aE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qFAHHXtlcjM5kcyMvrGRgaUTiGAS3Bbrqc65NBuKw/DreFxRGITLTTphmpz9Pkw/+vaF2aev619Z+lFAsgOLkmT0KTL8K4WRxVvS88XFcdX5ZzR7ABviwRc8LkuRN8GKsI+RuBbrpdc7o3Y1Ws0d1MedhxCpCbkXWjdx3s4rKPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KRBwERj2; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763452414; x=1794988414;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zuhtNGGI1Ya3amaZ3hvnUkmu5Iu4VYI2WIf/PvDO0aE=;
  b=KRBwERj2JB/FO4uNbfYD17fJE+tl6/8PnUlEgKA2u26ELN6u7RxChPmK
   QkVwfNHNCxVjOojRp6w5PwT1z61g5+Wg+CT/KnNBiR4shuOU8+YNTvJ2A
   5MqjG74AMoNhNt4oZpxZnQ3D4mTBAWzM9N/VVGW+fTqolOh3XvxHpj9B2
   cgRBtFweB0glU9sm0W5B1pnlpvw3dswk8pmTbNRi/9AbWwxexrhGWyzuY
   lpFVFNmPb3A+sqEDwMEg4y3ZG6IVhNWgbFYnLhIn9eRCpjlRQZTbew6UD
   IFOLeWHLAAvD+kB+ESIeoUl9ZnJlMYBkAfQn3BjrcbQDyMj/2Ho94pXcE
   A==;
X-CSE-ConnectionGUID: VbhL2PwCSwinFzTdkqJhXQ==
X-CSE-MsgGUID: dd43Or81Q2ihXboFBE1wJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="90940911"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="90940911"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 23:53:33 -0800
X-CSE-ConnectionGUID: 8y/4rAvtRrqU9byx0Sdshw==
X-CSE-MsgGUID: QYPRGYhoQ0C4N9tUURYGOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="189979419"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 23:53:33 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 23:53:31 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 23:53:31 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.40) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 23:53:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZIgyMQoSGsBLT49V1aNRgOWJdCqQxJWXENDSjaOVvNU1CWt/0r3Koe1u3HRpFgOajyoddb1Uv+XDhKLmcEzJJkoYIHLJBwJ4ySFsg6ygAi9slATv9Nuql2xoIiNKzKyJRnJ6SvZoSazM4axptjbbX8d8xVNCjkI6+3nQOorqLzn2US3b5eDFOeD2v1YJaW6WqD8j5oOlSYlW08CibSGbxGjvAC7xI+GoN6tzC6on2d59hoZyCDzXCrPgbPB642LcZFSBGbCtmfvyuY9rpPwEDL1TlpNH6GZ1Q5JewIAuAqzIIPWycCvCBxVAqS3JW/fGVXde/7pKrwqKk7lGgMWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15feSCoUh8ENcHVx0tZFD4v7sNFqGFUbdtGMd2h+UUE=;
 b=UqSngZvOZ1H4jbN/mr9gefRTINmviI/Z6oQjx07vYXkv9KtlvrLcFJOd15EGUhMkXhgeuweiW+yTWwvg2mC7KIAQ0Wquk+go7febKTQYPaSazZRPIKh6323f1IDAbicusStRNDojj9zoBbhO0C59KGyA1TVgvHyz3KPdrq5+8kMBc24rkbjlbTETtBP4R9ZCp/Dhfc9ndUfMWh2vq/tLzYc7gTsfmMbU5rtjZpKOFEmbtsHBDIqUCsYg8vaH95bLlwB+eolUPQ2pcY/Mr/Zsr3/hjguO0dn44sfnHT8MFd25ilT5K5I/Za21D0whcxyofrjMLVbxheyteAMeSx4k2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7374.namprd11.prod.outlook.com (2603:10b6:8:102::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 07:53:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 07:53:27 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "afael@kernel.org"
	<afael@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: RE: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Thread-Topic: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Thread-Index: AQHcUsnzy6x4f36ohkm++SV8i6qV3LTx7zWggACMYQCAA9kXgIAA9gOAgABTBDCAABXWAIAAZp9g
Date: Tue, 18 Nov 2025 07:53:27 +0000
Message-ID: <BN9PR11MB527640AE172858646199B1888CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRduRi8zBHdUe4KO@Asurada-Nvidia>
 <BN9PR11MB52761B6B1751BF64AEAA3F948CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRt2/0rcdjcGk1Z1@Asurada-Nvidia>
 <BN9PR11MB527649AD7D251EAAFDFB753A8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRvO9KWjWC5rk/Vx@Asurada-Nvidia>
In-Reply-To: <aRvO9KWjWC5rk/Vx@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7374:EE_
x-ms-office365-filtering-correlation-id: de5be147-e142-4ac9-bdb3-08de26778ebf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?bHRpAEtskIfb1J+NATAHzgeiq1kvGCWprFl96xBFVwmmiOhXhGJA/oXgxVDL?=
 =?us-ascii?Q?zOY8zbPuBr5F3FX4s9OqgduLu6MYxnAUr42E4RLfNu1hOabFTCfGyUd+2WO5?=
 =?us-ascii?Q?gcSz8OVsOJ3wXBuX8CHITEPWD0sYB+CVFSE6a/JSKJnWVi5OvSO6MUwtkiSS?=
 =?us-ascii?Q?7vb8tI9nsJQclmH/KFt/iG+cR53C/4bG8ibIwScnVp2obhLhGMYHuM3/hIPx?=
 =?us-ascii?Q?Ejy7ShKcv5SON1KQwePBFBkELj/Ihla2a7fz7vhth+yrE3Sdfvgqg6XUy0gl?=
 =?us-ascii?Q?cDUphV8zK67ZmQAI38oFkMgZK+Ur0ymxG7R8M/WxGEBy6gUKv70Vp36QHlO3?=
 =?us-ascii?Q?7GacBSMAlArObt81pFi6Aqh0nJdIho2focblB1CH6QOqNQX+gfYi8cYmupmF?=
 =?us-ascii?Q?yBZb2nItNgJ7/EBj3TMfCZVO2InTveM+byMhE0MN1neQQNYYxG0RPbAfASfv?=
 =?us-ascii?Q?wbCqCE89Klo/KP+Ewp8YiWNOQO1a/WL83GR0wRtzA2qvTVIv2k0GiZ9jKjru?=
 =?us-ascii?Q?IiGvzAVh1ByLDa47KtMAJm1pYiJfhC1dTNyD89kBwc13HnSX5xC/HcnbShRS?=
 =?us-ascii?Q?D5nWxNoWgvv1hXnL+Ca9V+rESK2KdKI8gFBVFPF75HlXm+JrFhRgMFMqkB/j?=
 =?us-ascii?Q?wUmcddwwGB66O7c8UK9X2XKfpaIlc5W3IiciR0bFaUFOftXmLUvfxqe1qU1v?=
 =?us-ascii?Q?uIpjhwcQqLghjat1r8qYh6hmopV/YMPSVjegFqGGOz6gcB/Jxuy0UNAYQxOD?=
 =?us-ascii?Q?OErNPr0h1esv0Z0R0NGzYqNJ2244xkkB97HkiWRs8T4Rz7K3quoWVPqjryvk?=
 =?us-ascii?Q?SHk4KjP/FIw8hQp63jvtCFcxCcEbsI2ounF3xyi7hvvPlq3HvXZVbP4EJiWD?=
 =?us-ascii?Q?pGZHvmB+UjjjFz2L8bxXYSoLQSNWSQ7DvMoK//qUYoytHGTJeE/G4iC+ZVXZ?=
 =?us-ascii?Q?eyZndrdW0TpxmnGINU4MBXV1rke+o4uTITt4Q2BkZz27Hxio3BY2M7NJPj6p?=
 =?us-ascii?Q?H5/X8IieRWHkUO8QGVvKu/tg2MpkVim106PC8ubR7I+UNDXl7oU8le21bsTa?=
 =?us-ascii?Q?07arm8djRShl/2qLvlW5iydcRyJLL7yZ8DOlszhDKuNi44dfVqUR9sxAzp/W?=
 =?us-ascii?Q?IUZvz50ky8tOuUKaA5Eeg/05cgkxPrHSGDQCHdp+iYv6YjppxzgF3ixijWBR?=
 =?us-ascii?Q?ld6fOgoDBLtDY8y1669JvFG8GDE3lc6cfFoNLU2CMWFBRgG7WnI+l7OL1xKS?=
 =?us-ascii?Q?jrNfykjZ+6JslpwBLSBuGaFKNOARVBGESTiyeNo+bUCnX2aciSufIW9QBoSW?=
 =?us-ascii?Q?j0qwBIM6WkcTRsEOTQ21gtxwZBEef65caZRBIbu+zh6lShJhMJEajjXgyGnT?=
 =?us-ascii?Q?FbcBuF/utml5U6jbYtgAGKXZxzhTyAXOtB+g+zb1dhxpDnKEgRjRKBKiFAt0?=
 =?us-ascii?Q?N7dTo8dqzm4yyT5OFfbZIrSc+IHduaLQ03BIgPo1v5QwLdn60q6lwTqCfBx8?=
 =?us-ascii?Q?hAQqENb+PV1Nhts8eR2EQoHnYUENNJeTuH4X?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y2sSO9DSnxCWMvY4HZZKBZPsqYKblmiwLE9pCv18bGnMqVsQ/MP3GocUo/T/?=
 =?us-ascii?Q?9p7oQvkwVNIUH819XqldGs+inaFkRmRALatZMOhrBzCE+a1voIfBqFWtCuIV?=
 =?us-ascii?Q?9GxnUvmnbDSRGGvNFd1Uytu7KZtzOH6o1Z6CrHo7gKJHWzUMvpJu08oXrKXA?=
 =?us-ascii?Q?uc/xAhiuvKyolJHPm7Z7vsYYk8cujUS+3heHfNF+OziF/r4JF7DqmghKo+gW?=
 =?us-ascii?Q?950ZSI8cH+8ztShDPXhT53w5BPFRo7qs69HkLa6WsDEM3nZR4EoRgDOE3G9k?=
 =?us-ascii?Q?C4QDlHI35Js3c2WuVxBYtj/KcmrxipqeaoETZ6OTiDCd6cU+WxXYrvVdFRO8?=
 =?us-ascii?Q?jtYPFveJeIKnW4DLSCNGRFqJG5W0BjsxNL4Rdbo8276GUAX+547Kdvynx/ls?=
 =?us-ascii?Q?UlJZy4cmoPs1w7elKQr9IeStN9gK0lhgXgLhdVAazjXMqPXQCcmPwZ8HMZJg?=
 =?us-ascii?Q?EUfhqbzcH9D00PfPph5TfTPhapd+Y18Kig9k0j0hGx24fuiVYtNOx05W8+4B?=
 =?us-ascii?Q?Dwr/b89u3sQ20PWTNueLaixKLa2s3Nr8sCoIVzM8K3jO+5qIiH8bhUcASQqN?=
 =?us-ascii?Q?N7NOEne1TyAmUZ2HSyK3w+s6zAYiQJ8zuJQRVWhoSlhm2+ZrX9k77ysZCatU?=
 =?us-ascii?Q?MMyuJ3ek1pu20MwJbLqEtdJD8h8SIBm25qpAHfum0huApqWhuh/n9Qj5qeR1?=
 =?us-ascii?Q?Y6YGlK2H3X8JnEJTjA8Qw477bZdf+wGjkmjM50ZrUDBmWwNG5ACj3aT4NZHY?=
 =?us-ascii?Q?AJt7A6l7dBIJe+yOmUuozuSU1gDKAHWqL1a5xQHq0RuXfGfFL7v17AbXjLgX?=
 =?us-ascii?Q?UUOjg1DwGV9LQ2piS8SBuwdbTRPEIJCpqEH1I53my/qSCbH2udri5qLGN+bW?=
 =?us-ascii?Q?USVqnI6ceQHhVK/9IDSQOYMf9/QrBJNmsSqQ7cAAt0F/aOU+6IMasSx6binh?=
 =?us-ascii?Q?ugNsamaXG6ne6N+hC+GP0gHe1GV5jvN1UtwvaCvkHYJSQE3+P8y1VSORl6rM?=
 =?us-ascii?Q?wRn27oz6mMLnzlqDoB2VVxj8Nx5wCWBiLlhQg5ff/5k23rYCUkuuF5p+TEZp?=
 =?us-ascii?Q?fFoHVYY570Qw7Y4oG+W5XwwN2C1Xl+XbX4/5FRSqt3dU58DZSvvimIZXVN5r?=
 =?us-ascii?Q?IMX2FCwImDjTHA8yYiXpuZj5cZb4DgDcTfG1zht9XrXfRsiZ4dugraKJ/sXm?=
 =?us-ascii?Q?2LWGFbG6e1ffyLFJ9Y6l5RI6CVtfziHZBNnfk2JB4KmH97R+qlLm6KBki1hZ?=
 =?us-ascii?Q?NHGmmu8rSjNHdDWOPBV/6AMJWRFOskx4Meej3A1aGxP8JsJZ0DqBbx1pa+cu?=
 =?us-ascii?Q?F4GKV+TF8RQIYUbhruHp8XsOo+faqTbgubFhyhVCY2ZqE0w9B/b8Mjbxugb0?=
 =?us-ascii?Q?SCT2KHEeHM2i9gcmEeohizMrS1zU2qf/HY9Ot9cJeO8L466/8xbduwUIjMJf?=
 =?us-ascii?Q?ZesKhP/myiWnyd5rmZrlXijCekNthr8FCocVXtmfaO9rv1ykOyilCb7jO/tQ?=
 =?us-ascii?Q?Z4CRZ60cv/igh1dH3ODyNGOm54d7aVGZYhlCF0vt9jzO5LPjeQ7E2l+kd/8b?=
 =?us-ascii?Q?35XMY4mYHal4W5VPoFeAzkyzfPqCXPu9wgWZUoql?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: de5be147-e142-4ac9-bdb3-08de26778ebf
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 07:53:27.0713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e7bje4PHNhcDt1/lNKgnWrZzpNRlYSkfYeiUoLY40/uaST66/T89FVeidzAcf79uO3piy6nSnGr776Bht5StXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7374
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, November 18, 2025 9:42 AM
>=20
> On Tue, Nov 18, 2025 at 12:29:43AM +0000, Tian, Kevin wrote:
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > Sent: Tuesday, November 18, 2025 3:27 AM
> > >
> > > On Mon, Nov 17, 2025 at 04:52:05AM +0000, Tian, Kevin wrote:
> > > > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > > > Sent: Saturday, November 15, 2025 2:01 AM
> > > > >
> > > > > On Fri, Nov 14, 2025 at 09:45:31AM +0000, Tian, Kevin wrote:
> > > > > > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > > > > > Sent: Tuesday, November 11, 2025 1:13 PM
> > > > > > >
> > > > > > > +/*
> > > > > > > + * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software
> > > disables
> > > > > ATS
> > > > > > > before
> > > > > > > + * initiating a reset. Notify the iommu driver that enabled =
ATS.
> > > > > > > + */
> > > > > > > +int pci_reset_iommu_prepare(struct pci_dev *dev)
> > > > > > > +{
> > > > > > > +	if (pci_ats_supported(dev))
> > > > > > > +		return iommu_dev_reset_prepare(&dev->dev);
> > > > > > > +	return 0;
> > > > > > > +}
> > > > > >
> > > > > > the comment says "driver that enabled ATS", but the code checks
> > > > > > whether ATS is supported.
> > > > > >
> > > > > > which one is desired?
> > > > >
> > > > > The comments says "the iommu driver that enabled ATS". It doesn't
> > > > > conflict with what the PCI core checks here?
> > > >
> > > > actually this is sent to all IOMMU drivers. there is no check on wh=
ether
> > > > a specific driver has enabled ATS in this path.
> > >
> > > But the comment doesn't say "check"..
> > >
> > > How about "Notify the iommu driver that enables/disables ATS"?
> > >
> > > The point is that pci_enable_ats() is called in iommu drivers.
> > >
> >
> > but in current way even an iommu driver which doesn't call
> > pci_enable_ats() will also be notified then I didn't see the
> > point of adding an attribute to "the iommu driver".
>=20
> Hmm, that's a fair point.
>=20
> Having looked closely, I see only AMD and ARM call that to enable
> ATs. How others (e.g. Intel) enable it?
>=20
> And how do you think of the followings?
>=20
> /*
>  * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software disables ATS
> before
>  * initiating a reset. Though not all IOMMU drivers calls pci_enable_ats(=
), it
>  * only gets invoked in IOMMU driver. And it is racy to check dev-
> >ats_enabled
>  * here, as a concurrent IOMMU attachment can enable ATS right after this
> line.
>  *
>  * Notify the IOMMU driver to stop IOMMU translations until the reset is
> done,
>  * to ensure that the ATS function and its related invalidations are disa=
bled.
>  */
>=20

I'd remove the words between "Though not ..." and "after this line", which
could be explained in iommu side following Bjorn's suggestion to not check
pci_ats_supported() in pci core.

