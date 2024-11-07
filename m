Return-Path: <kvm+bounces-31075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B031B9C0144
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F6F71F22FCA
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625B31E103C;
	Thu,  7 Nov 2024 09:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bivk+7AC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947F1E0DA7
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972192; cv=fail; b=R7Mu7c5QExoi1gA5x/C56cjZ7xkMThLuhhfAMhCr2Vgoq4wz9bXN+VhFYM1PxX8xYQxqTLr8ZewPGAWKffutORYMI/o0tZkR1eqCMnXpuC7XQ5fmNWvS8SckqObwcvGkmYHWH8ty5SywNe7MXp2XyPqWh2iCsCPpn0s5+H+e4Y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972192; c=relaxed/simple;
	bh=/TRu/dQwRVSBziyyyYfZmHXff5artzzGF80WpbeNAHY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hDVPQKeUwSpLV5NNtnKxqR7IQxDszWZgkSIQQImN5cqG/KYzxjmIu8XyZYikv2/WFCl4zxjwUpkEjy/WezmT8h1ATZk71rS6CjOThnGNnxmdq03LrL/68r2uK8neeoETDzzEJvECeRKRlz+5YFDfq03ud6Z2Pi2yKav1+fAnsbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bivk+7AC; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730972191; x=1762508191;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/TRu/dQwRVSBziyyyYfZmHXff5artzzGF80WpbeNAHY=;
  b=bivk+7ACZTeP27/gCi9Mdl1DEOvs9328oR+IHH9Bk91Ercz5qE+R7GQS
   bups02rCy1lDniKW/Ei/58F7UN1Vm6VO36GKW8U9ulV1ePGGHO1/2xz0G
   8tLzGdYjDqsoXrvVxSOWrsIXi959sVi5AFNi0fRWis7JL5dO+K2ToOzif
   QGYouMV+XM9P+qxWwilKKO5o/IZhmx/zMLfP5dDp1Ljpz/de93hOGoE8O
   GutxBk+FAZGGNaIzaoA2hPIzOQfehmrnAu8c95XVplXEO/OChhJE+nQcC
   97ElQMJqX/yZ7FgTEZGqRGIIe+d3ozHu7YljUWO4SEGgN3tDW0jQAPVpn
   A==;
X-CSE-ConnectionGUID: XwplOssTStyp7GQRhvjfFQ==
X-CSE-MsgGUID: vqRg2DjOSeCUPwEvjnu/8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="34502180"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="34502180"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 01:36:31 -0800
X-CSE-ConnectionGUID: g+0CyMGLR3SqXrwHalpWMQ==
X-CSE-MsgGUID: w3K+QCsOQkilhu05Gcn5gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="85129160"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 01:36:30 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 01:36:30 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 01:36:30 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 01:36:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TL2KCAGsB8CA0ZtHmHqZmTEGnHZ70bUhnILDPjlb8HLm2sQkFn6goxLOnegLys+wC7/IUuxgY8ufX8g/gOpm6HxCs4oFKXe35jYdLtqSRcm1h/Tz6u7fI7tytl8LY0mTXypBhQpj8mbF+cn5YlJAq1PMg6RII8xHu+HiAYNCSTB6IVRmNv4Fc0pvL2bV2Fm5zNErwReuwzrp88KOoNDKpEjhtJn4EJA9xpd973yGFfmQNeIR/l/7oBqxuZHwXtx0vtlZa9WdbLYhN1C1EwZ8DnYuERfDOfH8rupJG/tokraV+EupYDxf6m0LjjtKS/6pcRDtRqVZaDQMb35B+ai6Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/TRu/dQwRVSBziyyyYfZmHXff5artzzGF80WpbeNAHY=;
 b=cILCjie9GQgZThH/QyKKVIsME9VAlcCRR8XtAHi7gCiKOX4lV19dWgrxZOh+lSypCCUM/Q1mlsZ+pZxqOdThOrEVeVNR5ZFiVFga3IB0Edfufmikt/b145KP7cAZWAjcKluHjl3DWMSpFd3CkDKy8LWen9haSPxJv0nF/lfrN+JUmC9JGvqZYdMn75MSHAV2M+W/QZDpEPfzwdd5e4PAon2BI+TjbZGWiFKS76i+XtsW9wOZFNrh9pIE/TWgLy4dMwU8/L+cx7OVjiiNuYBURqJV/KcOLG1MfTY+OR6MpoO++3HtCtw2ArEQbu7XyY2V+dbhcYtuigKgKj2NBAmM2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4846.namprd11.prod.outlook.com (2603:10b6:a03:2d8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 09:36:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 09:36:27 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v3 6/7] iommu/amd: Make the blocked domain support PASID
Thread-Topic: [PATCH v3 6/7] iommu/amd: Make the blocked domain support PASID
Thread-Index: AQHbLrxkNHcykgfRXUiNqDAbJmno6bKrk3pQ
Date: Thu, 7 Nov 2024 09:36:27 +0000
Message-ID: <BN9PR11MB527617BF8F4DC634B14D2DFB8C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-7-yi.l.liu@intel.com>
In-Reply-To: <20241104132033.14027-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4846:EE_
x-ms-office365-filtering-correlation-id: e76109a2-a777-437d-5aa2-08dcff0fa758
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?vcR4MoylAJFFi+5pFyt0XQTYq9KyCxS+xfzpdX3cWnThP7n2u7NpTrNr8vM1?=
 =?us-ascii?Q?u7W+c8QPYgACfQuSIxQpW1omt9nGi1lHdpMpyHQ78oO7+vZxVy0IMLXV/Mjr?=
 =?us-ascii?Q?zdAeah/aGiymMusGLPSTgom6+ua1iXrQh70ARZSfPM2EijrF/REI4lo1kfbK?=
 =?us-ascii?Q?5onQaordJDPfKtsIoyaSPrBdUQ+ogm8oDWoH9lrd4sGI0FwNGBabipCjdveH?=
 =?us-ascii?Q?q9ufVNt8s9Je8MOtxwdgV9BTLT6ecIPxqPkx1J+aAqpm/jZvuHnvFUWI5Hj8?=
 =?us-ascii?Q?asqFN4mVMmpOZ7/B5LLaTz8+0RV38tGam8lYakPTxXDVC6tJnAuuYOMsD3Jt?=
 =?us-ascii?Q?CoywoN3tpW1bj5sfJp334GfD5EQ0MLuolNTtJUyBQ1U8AGSnEr7eOr7UuFnw?=
 =?us-ascii?Q?7R80smQZPnsJcSIeIuShGfoVdH/rysUNvLRSRwJcq3sWxLpFmq4PDZcseY8E?=
 =?us-ascii?Q?zYk3fN7vHkWdejwphYK9uiZoxkSP+74SrYpTEpmJfX8q6L6SdFefRoU/R171?=
 =?us-ascii?Q?vSwUbNOc7kKFxkKbAWhrm2ulXcDmuS0Q0qxZY8UiNbJJzJSX/nZnaOqVwgD/?=
 =?us-ascii?Q?c+PAU6QeuxMkX904Z/ukql0DPD8OImUP+fB0gNC1EP+6dN2+48GBu1Du255d?=
 =?us-ascii?Q?NHIDQ6RwEB1Q4vrt5zZR/wQlPpLx9bekcKVuJINGNGDR1+kjFFXS0cHKXkOO?=
 =?us-ascii?Q?0vO0Goe2gpNpR+Y4aa98KJeGbRHlnUeYQAeoIogMtp9hBDh7aBJVik5nsxbg?=
 =?us-ascii?Q?zgYJxPD5iho+Dd4sbVdozeWyBQLCl2K6VRXRUMMywaWjVDPxMyoJ+duKFU8O?=
 =?us-ascii?Q?ssLKSVRtfBExPRqEcsC8ZSA4OXEIc1vyVc757q5f0jAn5KNnnldtyPj7pwjT?=
 =?us-ascii?Q?yAUZFrshqaPAPFCLNJxW8xzupg2brp1G4WlP0tBePAtxithLkozES272E6Sx?=
 =?us-ascii?Q?a0gPs9xiK1KAL5JF4fOS2GU9ZKYd+KJf7opPNpEkFCZwJkhaCFbA17M0atsX?=
 =?us-ascii?Q?B/7fmo727wXmPCFakUj8LCTjqFLuS/i2KBAchlKSDmtveFwyIxZYNS0Pc4BY?=
 =?us-ascii?Q?TbDRHm8J8GplF6HH1dlD90Id6e4sAwMXYo/uOtEzajQO/7NGe9GYOJEyEvbg?=
 =?us-ascii?Q?zXL/PG/36sjmnO2+KjxjpqWbEb5m1IIGKC5J9bVyAh89Y7mYpYCbnMWfAV/l?=
 =?us-ascii?Q?My+EaPl+R8Ek8z1Piss47/7bNx4DSL5dtAD+pNBzpll26lwqscTliMl8zb2R?=
 =?us-ascii?Q?mLYi9FlbxYZNqXPyhQ5XdDvcgbst1kqUh8lXUztqRudBAnB9TNaRTMAN8SET?=
 =?us-ascii?Q?/xAwnTpsYFtFYfjooB1rXfUV7Ym8213QLfCIsSNluiXTsaxGPpc27W/1oPD3?=
 =?us-ascii?Q?2L1f4Fw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hEK+z0SISsqguuEy+I3QMJ6y+ipcY+lXIHQmy4dgX8oyNZC/kByP4Lns5zpl?=
 =?us-ascii?Q?u99SaRZsBkvEeOkCWiRM2F+KMbO+ONFm4mKY6VZctt31UUq9FEU4BOIJYE35?=
 =?us-ascii?Q?QZaZljUe7vrOTGZCSpPa7pHU4jdI0zY2yEpbeg7Ku29WTRRmLwfc/0H7/ZaN?=
 =?us-ascii?Q?ysCsPH0E9COhu17aOBP4Vu2I5/YYzO6jhVS9KVh+zjftHo/yffviBd0cyRTY?=
 =?us-ascii?Q?/18VSVzlAWEkttxaDlK2DGrlznU7xVAgD0oAl1afz9VU2KFiSyg2Zf6pkSaj?=
 =?us-ascii?Q?HV6b6QWjvq65SvbRLO+icEAyO/24l+9G4NOoY4sRHiBJrk/oY3gTVca0+wFy?=
 =?us-ascii?Q?lxY+PoOScwa2gp6R0Qo+MqrfT84IyEPjfSrWi5PQQDme1VXsriJGtY4fWj/T?=
 =?us-ascii?Q?mEjRK5zRyeqAWPOKzIXkIJb4pZjGS2PC8iVF+P/qpsJENmgB6F+ezLHgw8y5?=
 =?us-ascii?Q?+9zTXp5K0Ex1IKVQHtG5QrA2GQ2oTlDnHQuMpZmKIM2YnW4ZXnHgzw2N1lbo?=
 =?us-ascii?Q?OJf0PBfvO7Ib/KsSBpIhzBSQegmNpNnSf5Ot1Ub8LglDzVmCpR7Um20a9Sn3?=
 =?us-ascii?Q?YWIwawWsqqs52GACplws5uDbcFYGqfMhEQ0yQegH7u2lFYwxUOggIudU6ZPn?=
 =?us-ascii?Q?gWVzuDZgz7vMTsmMdaW9vvt/Ir1VjdKtkXcR8jGMiLgPNA8Yrt0sbIr77fcO?=
 =?us-ascii?Q?87wz9vrz9Mf2hjmiN0wSpQsneuWKs1Lag/QML/m0Gp8fZa6bvEn3zuTFSeFZ?=
 =?us-ascii?Q?GxLDBgVF+V2Tz2FMAF9INWlO0j6afrbN3gN9/KeoZTy32ok0IMUlD8q8g3Xg?=
 =?us-ascii?Q?l6/MSdaj0cykEs25icxf2AsVStrknNK7KOqRgU8CHxeKweYVjvXV5Qd23AZZ?=
 =?us-ascii?Q?pFVKgSh4HhWniH9WTt4ETILxEYzLI8sJ+8iaCn9DQ4iW53t4ZXDycPGOtifz?=
 =?us-ascii?Q?pFaS4EwaS2ESOslhMaUkPBglDEqTVH8TPYJUg0aJ4FcGZClAo8KF1zahZelS?=
 =?us-ascii?Q?9iNPc9O/xi3FvQHwDbR9/FLiIKfzhN0MSUQ34/i79iHnf40TdkCaNqB16Kfm?=
 =?us-ascii?Q?62YNk8pFJlIDYZy7V5Qp1R+nTxHNA8GEV2Kd3A/AWwYfqptN3xbKx3NWUovO?=
 =?us-ascii?Q?0bG1N9htJ3GmtXHc4Bev0u1PzVLshLxkPO8l6ADmhgXQscoi5NCx1WpEyUW/?=
 =?us-ascii?Q?2A7dszFOYrNv1GqwR8l5amokh6EH0sEWFnqZruZYoElgUAnaQfzle7o7HmMR?=
 =?us-ascii?Q?7VufrBpuBsSZVipG1tgs/hGcJwS5tBWsdN09L/6Aoj5jnqBIyAPxBRKj43X1?=
 =?us-ascii?Q?WdVoG//ugJ9GQeqbBnQT1EREveELJGYMSsj+Z97QmMRBqS2Q41itvXJlfxBe?=
 =?us-ascii?Q?VZc+vAilYg58KKWk7k8f+XKYCtuqDMQMMe0yv0dqdXBF8+L/J/AIXW67fEMp?=
 =?us-ascii?Q?bz561ZG+rwYttKUuA/Ol03qGeSdk7R5fk+N7b80prknRBLC8txOgG9NSRFGl?=
 =?us-ascii?Q?v+wGDp3hOHvmBxxMqXV8p833Y09rZ6V2mbVVmHSTBNL6EoDG5d8T+L1JRGBv?=
 =?us-ascii?Q?YwcIwHdAsUVCjPFiFx7dvl6qNTckfRj6tcQQznRw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e76109a2-a777-437d-5aa2-08dcff0fa758
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 09:36:27.6477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hq2eg7AATAa7jWD1g8riiVXuBU+7C0ATmcz2tHxV6j6i36sPUHO9BbucBHpvgX4JmShvoQ6CMEZduCzYYlYCqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4846
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:21 PM
>=20
> The blocked domain can be extended to park PASID of a device to be the
> DMA blocking state. By this the remove_dev_pasid() op is dropped.
>=20
> Remove PASID from old domain and device GCR3 table. No need to attach
> PASID to the blocked domain as clearing PASID from GCR3 table will make
> sure all DMAs for that PASID are blocked.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

