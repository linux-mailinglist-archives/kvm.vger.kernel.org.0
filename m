Return-Path: <kvm+bounces-40820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57494A5D7A1
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 08:53:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 200FD1746CF
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 07:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714DF22DF91;
	Wed, 12 Mar 2025 07:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jZ3IC7wZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCD822CBCC;
	Wed, 12 Mar 2025 07:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741766004; cv=fail; b=RuKsi2bEXDj8HjDLKPS7suhDpd03IkhP92SW/4wY0VFJXHAQFbY2xjO0U/RMsygPI0ZD17ZBHOzEjAMnPjnmwZvZsKUbibX3yqg0LS7JM6vts4bCi64x0pCHQ/IkBlbNfpez+9NUxOTUcmpKyMaKxSp/qbUbHvNaw62UnLMjk80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741766004; c=relaxed/simple;
	bh=pTPxPilC2uwOnN7QnhffmVa39n5CrzHDLSukTgB9Qzo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iEXjiP8xyV3wl1cas5A8VspWAeYIVZJbzjYobsnxm7e0OunY3s2Dx6BcvHNYo8O15dOV4hREOoNhZP3Cf1MhIyp8B5sGtZSJxZPWRoB5eLytuluFOlENHFM8itE3JDfGcZFiWuE3vUb6asVxR1qzBOvSupH5SogGD9J9exohJ6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jZ3IC7wZ; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741766002; x=1773302002;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pTPxPilC2uwOnN7QnhffmVa39n5CrzHDLSukTgB9Qzo=;
  b=jZ3IC7wZPdabyjCg7+vFyaFzi4NW6hJ8W+H/QaWOVKmgg1fjQcxb2TuN
   5VCg6RGl7kY3CGyZAHteqmZWz3tcQx1c+tXqA71YhFIZdN8NmnnXZq3oY
   Mj+d53avLqvbIvKWJ3OOQbMMPW6e9qJrmSUgbhodY10YRDNYn8mcR5mJF
   okCfns3lV/BYSLlLwgf7lyQ9PtG+e1bbe0lwFcBx/FL895FM9f6u5he2w
   x4ah3I1sgsthOK398Hsuj/zhBOnWivpwEZcII0+Ffs9x8deQNKaqzDyGk
   M9bHlSS5ekQ/IeUl/wVv3eHS3wlahyPqMj0TTARojt7Th7eRi3sk0XaOu
   w==;
X-CSE-ConnectionGUID: 4pgL9OmTQTi3D39SZtVmxA==
X-CSE-MsgGUID: SQBhaQFOTeaOTq6L0IhgjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11370"; a="42869609"
X-IronPort-AV: E=Sophos;i="6.14,241,1736841600"; 
   d="scan'208";a="42869609"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2025 00:53:22 -0700
X-CSE-ConnectionGUID: rVv2RogLQKiN4yfjzxinZQ==
X-CSE-MsgGUID: P2k5Qz/GSGeV0BNETYLcww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,241,1736841600"; 
   d="scan'208";a="121463143"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2025 00:53:22 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 12 Mar 2025 00:53:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 12 Mar 2025 00:53:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Mar 2025 00:53:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N2LrPh2hUkTelH2TNLZwNTApjQqOfePgaTCSMQFm2bbzO4veTC7lAsBbiAkX9VyuN8tbI2R9oj74whiQbEbEvTAnCsKRtoBwS8nOIq3nfErPUxV2df5au0cRqvdnAXZs9W6bYHESlLk4a0V7iKjeP60XBppkrCDiE+PIkkfjKyQoYINizPKFjcc0hv/OcnLfnBg9eQU/zqXLhwf4MMDkqzGeyzN4WTLEK+wx/zg+Ifu3AEwKIeE70fpbPQpA3+Iaj1wqSW/ZjZ9tU/JlPp4IZksOJKza3bLosBdpJKQLbiwpaD715irHE4mvNy84LdEXa5TWs6j6i4LrX/lwEHlmeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBvSc0wzJNoICudSrPekZD18ENSfaBLYkig0PJPrxVE=;
 b=vwtFYP3lY3C7o+zvPQZZDuzFWQ1AC0eefvrYf9iXhoiTpzAnmTf4xOyO3WhBJdRwroPNmcGW6Ka6p49/5PUa6n0R0bYFLCfxH6EQ2gZTRBbz7nMZ+2gBOQnPYng3uJdSsjWkSnwO2Kvzrr57jwtI+sZplJaDpAFqr7XN1onhBqCovvbpjtmg3wA06ZJ35KVY8qVSlYk4sgHF0mkkFLmEE7anAAFF5Y05expCsjDgmunz8MA1zpcTLqJRxwdwO47tALlyPQBS1tkugfJjVrRRbTDCZ4gCURpEu6LgdE6L3c6jOPPAKa12S3WHq3DSAxw2qZa62GISBprOn46b8DWcTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7539.namprd11.prod.outlook.com (2603:10b6:806:343::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Wed, 12 Mar
 2025 07:53:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 07:53:17 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, nd <nd@arm.com>, Philipp Stanner
	<pstanner@redhat.com>, Yunxiang Li <Yunxiang.Li@amd.com>, "Dr. David Alan
 Gilbert" <linux@treblig.org>, Ankit Agrawal <ankita@nvidia.com>, "open
 list:VFIO DRIVER" <kvm@vger.kernel.org>, Dhruv Tripathi
	<Dhruv.Tripathi@arm.com>, "Nagarahalli, Honnappa"
	<Honnappa.Nagarahalli@arm.com>, Jeremy Linton <Jeremy.Linton@arm.com>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index: AQHbhLKIOMwFCrbJIEmx0MTBFQvwabNjFiyAgACMrACAAC5ngIAAUDEAgAsZQcA=
Date: Wed, 12 Mar 2025 07:53:17 +0000
Message-ID: <BN9PR11MB5276468F5963137D5E734CB78CD02@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
	<20250304141447.GY5011@ziepe.ca>
	<PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
In-Reply-To: <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7539:EE_
x-ms-office365-filtering-correlation-id: 901bfaba-4f67-43a4-78cd-08dd613af340
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?CFbDeUQ9iHtrGQyfbjmMc08KXcD84jJUGv+wpBmxsjqfWPwpvUy9shnRSjOX?=
 =?us-ascii?Q?uBKe9lcq0wezkJ5agsA/skG8B2VDWNHC/shAGZhE6znyBTESmSkbJBNYcGEB?=
 =?us-ascii?Q?nw17+1IOb+G7/8GNkIdTeLK0yMBLQ2aSAZzZgWMWAYxa8Zo/kbY1Sj8NZt/O?=
 =?us-ascii?Q?/EvwVc5fSJmwRfcM8vASDucJ6B0feDdWyh/tYdRVlx/OcXuyyy/agxPDLX64?=
 =?us-ascii?Q?MdwIZziRDlO6hFb3rhfQBZq8ilsFU9J+3N/SVyGCiH8cLItpy0sl5mXKRMey?=
 =?us-ascii?Q?A3nWKOznpNrmlQcwTybPvZ8ng+tn6/U0R6/w6Qyh/22QjaHBt8Hgc7n0ZoQ9?=
 =?us-ascii?Q?iQ1GlbghCQOdzBn1qwfTE9EK3056eqIjZwiTAz5jV5/KVDLnvkkGuCh+znVK?=
 =?us-ascii?Q?j7qtO4D/j1awR8shbidikl4Zf0Y7ZmWImfvzhdSrR0YV7Jts29UMhknmxEpu?=
 =?us-ascii?Q?YFzIna9QQ5kUN/Tpkc0BT5cawqoj1cuVYkGi6RoZvjcurEwhzExnAbVJcECr?=
 =?us-ascii?Q?CgvlrmzzPD+bh5ci43Z8qePZ8n+k/9mBSLIoVQzmIJwTGT9a2Cb4GMjfTgAq?=
 =?us-ascii?Q?Omt3PW0MHpEhXT7/JtPlMMC/jyuyKYyAzz6Rv+/7OL+9sv1j4B9yfwiUYbPa?=
 =?us-ascii?Q?EHTbkcM18zQHEMgGwk9bMIiH3vkVrHOryywwdDDWf+tVstuXS58D1KJiMRLb?=
 =?us-ascii?Q?hLnk+ZuqbyI5/+G+0VshLgNzWrhIhRf+8D5hnKE6AZChMomdUFFAgFctlMjC?=
 =?us-ascii?Q?Mx5PpsvRB9LZ0XRa4flv/W9p7EzuCGWw9tM3RUCejSbS7bcYReKYU4L306YS?=
 =?us-ascii?Q?Jj+0KQveIfPtfv/nH0hXoI9Bx/qEATLs3J0JRq2JQijIbOYx/X/oIDAvIQd+?=
 =?us-ascii?Q?pNI5Gtn1GR0bBMMbDDjzHLd7uraN/rlD2571nmE0klhc8FEI1KQpz1HgqClD?=
 =?us-ascii?Q?E3QkBMutR7CiCpyGu6zqiCsOK+PONNNoFbmkqs21P9oQmC37h+GTpMfqjBhi?=
 =?us-ascii?Q?CgFo8TuS9hOwtYPi4J9uwMXq9f3AGYEIvQAwUJggAbkH70pEUzum6g3TcJtK?=
 =?us-ascii?Q?7MVymdKSe/laHPNIFJqoZCWJp8vOw82gnqY5xb7lo3+dE61HFAoXBNr/oBTU?=
 =?us-ascii?Q?8vl9jfUU1P/x0RKp6OFChFIEzjRNGGao4K7PnLEOEOuxKJvjuHr4EzLMiXxz?=
 =?us-ascii?Q?BjLifaocpy0zZ7PHHwRD2zIia2fX8ADDt1LGhVzCJVfjBeo54lfKL2A7rRDY?=
 =?us-ascii?Q?EyMyYsxUI3mlNQjnBByHUpm7cQm9vfc9HISpcB6s6e/3f8yl8Srq7BT/bnvx?=
 =?us-ascii?Q?sCBnbyILAc/mUVOOJHhYIaY/5yOMl2QMW/awzwOx1ocOXdXpMAXySxZYOr/n?=
 =?us-ascii?Q?txpmW2FQT/PyUasRcOF+ROUVB+646muGHIr2bg1S0QJZ+5sxpJuC4Eih7Dq9?=
 =?us-ascii?Q?h7s94gHD6mHaw6hDvibWNkbQxmIQgm/x?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dIXhUniQ/3u+brHOAGa7o4o63JwlCYRiXXhMI/PsoamU9KjXRghKSQW5qnMz?=
 =?us-ascii?Q?OLk2JAMQ/jVrTRUvJu+43aOwpgJlmUl5isUvKr/bPHdsYI4Do65gKYFckwmH?=
 =?us-ascii?Q?9VVluMdWeV/ZsDZFejwW/+AJdCT76YjLb178Dm0LXLfPAJjuxQ8p364GXFcV?=
 =?us-ascii?Q?AgdOzO5geCfH0ap/fdq4Bx9OP+r/76RvS8lDuh7HEbyo2SBGw1Ajpo+DSME9?=
 =?us-ascii?Q?MSGOP1GqfnBSVuw8eSzENRyUpIXlvbtBMScssziZKY3WAkI5WhofN1ErBJBU?=
 =?us-ascii?Q?e8nkzLl3oTrU3YNkGpOu8Z+WNeIHF4g4lJKptF7SuaA7w4oSW6g7/w7c5F7D?=
 =?us-ascii?Q?oRD6tE0jAr6yVtb5Q1ZERzI/PhBk2h83Ue1yQq11cP1Plfg35FXrorqOyOZv?=
 =?us-ascii?Q?CiLDnio8BNnhDSxfJPWpn3Bq9b3IznVrNcmyp7JdflWMVZya+HBXML4wxTBU?=
 =?us-ascii?Q?D9fzamZelHHMVh4srr1oTNFPKLNeoWu8e7C8shV+50qhhbiDqwHuTwpFZmBR?=
 =?us-ascii?Q?srevBr7MwGhwBbPqCRnSNq90VsMh7R1ZCpr2v7Sw1+jq3yKXkMEJqmyyhsiO?=
 =?us-ascii?Q?acLVBBB4adzFGPVr0kTG6P8Y4KEDWI9Ww/S42ajJ/Fa3tZ9FKR+au0A4CUNg?=
 =?us-ascii?Q?vhm+z1V5rko5IMStXvhwfRWDBKxvWMbSJjgnOkmALJPfbMxPYGU25xaH6573?=
 =?us-ascii?Q?iIZ55gFyRvvgbDfWmDIVdUAv5T7mxrgOlvHPsRbz+qsKbQYwSrxIedKHx9dw?=
 =?us-ascii?Q?Q8rV6tMMYJj4XdIT0MLL62E8A1vyKDfUy6802DTwyFlyWpqLrUN1+nkux4XD?=
 =?us-ascii?Q?WOd43vhHuOkSi9XI0Hrkv2RJTV3TFRT1b7hfy/ylV1xLmVkVpYtClMRczXdj?=
 =?us-ascii?Q?ybCrHpl8iwPVG8g7BiAFTghbI4bcRDLsSXhMJgvTggtReVaFlRZlrpBG2Vi4?=
 =?us-ascii?Q?aDSsNNrMx/BgL41Vk32Fm5cOHeZUKPwNwsFHAPOWU8GPzYC7QNFz/SyCnK7F?=
 =?us-ascii?Q?3q6urg0zJ9/00d6vGIvg+jZeP8LDv03rwLqQE23amrkqlGgVzQTwzVEuWWLl?=
 =?us-ascii?Q?dPJ03S06K6Vb4CH/8DQtEu7rpDWtyuV8axzG02zjVVnN9ZIKx2NI5F2BEgSX?=
 =?us-ascii?Q?O1BjSaPBRcHK3hwg0sltvDvn/BEywlaTBYoFx6+gCrhJ0q6kW399pcdRVvKr?=
 =?us-ascii?Q?FeRnMM4G4OTH4mr5gTCmVR1Y1MBCHQcPHbXkl1Kb5FYjKK5s0YgPY09ZqAed?=
 =?us-ascii?Q?54Co4R7U49xUSxX3qGZrLufcsqPVnV9+7Dq2kdM4Wt1mOAsKNj4cmkgrTGBS?=
 =?us-ascii?Q?FRs+IMtJFp/8qHlNsttrUZT+b12Gd3zL7xMrcFaXGfhuB7sJnrc4soMD8/0A?=
 =?us-ascii?Q?z45AyAL0hLhjgrXnDzCFDCX/JE+8/3fF2JXpQZyNiaBhuAYpdkuKWp7wBApm?=
 =?us-ascii?Q?zmH3901neL9mD0j8RAP8U5z2usEFNGgwkCIgnp6G6ecOasVaRe2/nyTVLsEF?=
 =?us-ascii?Q?Ku+O0TYzRa8i3z5QqqZOmxxfzxEAl3af/IYgSp2mAerOLlD09ve2j+8cFGqS?=
 =?us-ascii?Q?j9dgsJpOZtk/ERmflUc8dnhjZNPbD5LbuafPIK0u?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 901bfaba-4f67-43a4-78cd-08dd613af340
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2025 07:53:17.2995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VFVeEB0F5By76din9czoePwL0SbWEfepc0pev77sUz8DLIPT1ojHxNt82vNBSTgA4KQvNGLIoA+7Tv6GkWNOzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7539
X-OriginatorOrg: intel.com

> From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
> Sent: Wednesday, March 5, 2025 2:11 PM
>
> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, March 4, 2025 7:24 PM
> > To: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>; linux-kernel@vger.kernel.org; nd
> > <nd@arm.com>; Kevin Tian <kevin.tian@intel.com>; Philipp Stanner
> > <pstanner@redhat.com>; Yunxiang Li <Yunxiang.Li@amd.com>; Dr. David
> Alan
> > Gilbert <linux@treblig.org>; Ankit Agrawal <ankita@nvidia.com>; open
> list:VFIO
> > DRIVER <kvm@vger.kernel.org>
> > Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
> >
> > On Tue, 4 Mar 2025 22:38:16 +0000
> > Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com> wrote:
> >
> > > > > Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) featur=
e for
> > > > > direct cache injection. As described in the relevant patch set [1=
],
> > > > > direct cache injection in supported hardware allows optimal platf=
orm
> > > > > resource utilization for specific requests on the PCIe bus. This =
feature
> > > > > is currently available only for kernel device drivers. However,
> > > > > user space applications, especially those whose performance is
> sensitive
> > > > > to the latency of inbound writes as seen by a CPU core, may benef=
it
> from
> > > > > using this information (E.g., DPDK cache stashing RFC [2] or an H=
PC
> > > > > application running in a VM).
> > > > >
> > > > > This patch enables configuring of TPH from the user space via
> > > > > VFIO_DEVICE_FEATURE IOCLT. It provides an interface to user space
> > > > > drivers and VMMs to enable/disable the TPH feature on PCIe device=
s
> and
> > > > > set steering tags in MSI-X or steering-tag table entries using
> > > > > VFIO_DEVICE_FEATURE_SET flag or read steering tags from the kerne=
l
> using
> > > > > VFIO_DEVICE_FEATURE_GET to operate in device-specific mode.
> > > >
> > > > What level of protection do we expect to have here? Is it OK for
> > > > userspace to make up any old tag value or is there some security
> > > > concern with that?
> > > >
> > > Shouldn't be allowed from within a container.
> > > A hypervisor should have its own STs and map them to platform STs for
> > > the cores the VM is pinned to and verify any old ST is not written to=
 the
> > > device MSI-X, ST table or device specific locations.
> >
> > And how exactly are we mediating device specific steering tags when we
> > don't know where/how they're written to the device.  An API that
> > returns a valid ST to userspace doesn't provide any guarantees relative
> > to what userspace later writes.  MSI-X tables are also writable by
>=20
> By not enabling TPH in device-specific mode, hypervisors can ensure that
> setting an ST in a device-specific location (like queue contexts) will ha=
ve no
> effect. VMs should also not be allowed to enable TPH. I believe this coul=
d
> be enforced by trapping (causing VM exits) on MSI-X/ST table writes.

Probably we should not allow device-specific mode unless the user is
capable of CAP_SYS_RAWIO? It allows an user to pollute caches on
CPUs which its processes are not affined to, hence could easily break
SLAs which CSPs try to achieve...

Interrupt vector mode sounds safer as it only needs to provide an
enable/disable cmd to the user and it's the kernel VFIO driver
managing the steering table, e.g. also in irq affinity handler.

>=20
> Having said that, regardless of this proposal or the availability of kern=
el
> TPH support, a VFIO driver could enable TPH and set an arbitrary ST on th=
e
> MSI-X/ST table or a device-specific location on supported platforms. If t=
he
> driver doesn't have a list of valid STs, it can enumerate 8- or 16-bit ST=
s and
> measure access latencies to determine valid ones.
>=20

PCI capabilities are managed by the kernel VFIO driver. So w/o this
patch no userspace driver can enable TPH to try that trick?

