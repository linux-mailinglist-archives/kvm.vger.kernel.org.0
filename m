Return-Path: <kvm+bounces-30856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5366C9BDFAB
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 835AE1C2111D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154C11CF2A8;
	Wed,  6 Nov 2024 07:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z+kz8tqz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF8D2D7BF
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730879231; cv=fail; b=Tp39f8j59yH5L1bce1NDeXHUncZXlJonhWHvh7TdUGXQ/UWegH39Gc5L4iCWsf/0wbVBJNaG93tr1pXocW50CPteh3oNiPC5zKMCSFjfUFFAw1gtBAzu0jpj+ucxhrMD+VFihJ0jP/uwXKITQlsQ9fuTmxkiVHkptEZU8ETNYdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730879231; c=relaxed/simple;
	bh=oQMSY+MZksomnLnd0/3XmFkG+W6ffc63pFArSc7694w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ESdlQZ5po4Q9OZNxtNZJosXjsjRu3S6whFo6cgRPOKexGtNuY3wgb5bR4ruzaauAvq6xym1v+T6bvl7ZtS5UKm0Y21mAvrmSL9tIFNk3gkpOuKO15xxjzwaCTNwD1v3QN5BCA10i12a8LGuRiws32A/XzKn2SitzI1u0aO/WbrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z+kz8tqz; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730879226; x=1762415226;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oQMSY+MZksomnLnd0/3XmFkG+W6ffc63pFArSc7694w=;
  b=Z+kz8tqze/h23uKtzigXeXBTxRHhiUQuf1G+qBIHwauSsutBUW9nuHSn
   F/4PNDVMihNyQ8tXujCzCGj17B7wiFEuCACP1HJ444VcstviST5YkCgY4
   OioFtO27k9p+GFnpra3Yfg3Vuo9JkPKOthqJhjOogKbsXS2rs2IuNQF6x
   iQ55Si6au37wRRo0nZZv7oTL4qV/lJJN1K5K3YPX/Yb0FTenZCpBdgTdk
   2y/E1YpA0Eflvgtp41FE6YE4CZSTUc+dDZzZ+eNXmkLBWHmgKziFL1L1D
   92rS8eAhNbQGfxl+Vn28W18QmNwVH0ABfGOXWvQvLp+/a/QKKWb9v1dNP
   g==;
X-CSE-ConnectionGUID: JLDE6/FMT0+B5ZG+HzI2kg==
X-CSE-MsgGUID: CTFFJijZQCGMcIoDi2VtAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41211353"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41211353"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:47:06 -0800
X-CSE-ConnectionGUID: /0Saqs1CQKWp8gYiykYayQ==
X-CSE-MsgGUID: otJRHfO6QEahxswpQe7Dbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84306810"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:46:02 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:46:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:46:01 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:46:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jwPt0C2z1QrLEmG1Fpsd4YUWbeiIyWrofCC1wOpKFiQMP9EtHPNsTOIQMdDTeDGbPNnS1xdgDAmHxkrlT1Vy1zL/XLIdw1OjrRl8jo0AtJn9CRHzMfMLaN7ZF/efLdDs9j94ORgjlOAMCDaX0iTm0VsxBrE2Kiwr02F5fqH0QhyKi8cOS+emKrnl26+ZwJnAKiD04dLM/xng/x0v/aGe8gEZ00begFhnW6XxSuXWur4/rbbTDpPmsp6Detr7Ev4YpozsKJ5YdjqDNRQQWnZbuxSo5QmxXIg1CVTApsnYtvZ5hQPvagDki2BLhBlV4/IcJtM6rKPnYJZHWd7k8EBKFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQMSY+MZksomnLnd0/3XmFkG+W6ffc63pFArSc7694w=;
 b=WoTazwIHaqnjtHRZqE793EjJ1AqtlhiONR7lnqinmp1yYETDCOEW+/IFDXJF2z4dZ8O+etw1HQQ2TpnveQIZxy3M6EkRjxhC9wpYHQP/fCm7lTWAYLQUr/nQ+EW4iOgCk71wsGxMdlvrYMcRjPxW1tCYQ+JJk2Dc+MWRlgjJ7EnyyNsTOzKt7hLylX0HYWBhM+2nPfOJ8x7MelV87ChyqjIK8SS3L1Q38rtbsL6jSq7Ffhnv+YxRe/aITOgBHG1LIwZ+fBz82bczgKgY4Lgd3DQsWP23Ei5clswYH14ttzQTtVrl7KKXhRxEVoQmnKvuf5E8/ECMe57FbdT7ubUz6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4998.namprd11.prod.outlook.com (2603:10b6:510:32::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Wed, 6 Nov
 2024 07:45:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:45:54 +0000
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
Subject: RE: [PATCH v4 08/13] iommu/vt-d: Make identity_domain_set_dev_pasid()
 to handle domain replacement
Thread-Topic: [PATCH v4 08/13] iommu/vt-d: Make
 identity_domain_set_dev_pasid() to handle domain replacement
Thread-Index: AQHbLrwfL+LIPsta9k6ulMlBEed8MrKp4j+g
Date: Wed, 6 Nov 2024 07:45:54 +0000
Message-ID: <BN9PR11MB5276C0B4288C579DA52FE6D38C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-9-yi.l.liu@intel.com>
In-Reply-To: <20241104131842.13303-9-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4998:EE_
x-ms-office365-filtering-correlation-id: 5476c002-c1ad-4f09-4690-08dcfe370b5b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?LgYUsqD8BHN75R+GRjHevSOWP4S03iIpOv2OOnDUgBXuUZPx2Z32/VCfkZsd?=
 =?us-ascii?Q?QJ/H9m49wIEmzMmd2viBbF5hUMmWyyi5vqRphnjqpgL19wM9LucrCgLUKcSn?=
 =?us-ascii?Q?lsm/pP25OZ9JM/DlVFzLGghOE8lX77m/yaIVVofbPv2l+L3mMs3cOk3NIkvP?=
 =?us-ascii?Q?QMK9mF/ffcqAgURQXwsTN0urV1Lr6fToCkojUD4sBW4/TTQ66ostPQ02MMD7?=
 =?us-ascii?Q?5JwteEsaqyqfr9MDbbWTF1bqQCVAA934baEFaip8NohpcFknM5Lyi4wY6wSJ?=
 =?us-ascii?Q?Gg6ARxjeGTOV1xKu0RPY/BALyEBGajr37u5hUphlP3OyUbyQ5GLkjMhq3NnY?=
 =?us-ascii?Q?K+RI6SAIIhmf5Rm98W5VjrRffFdJN+K/v8UwChwtoMwQzbgxUOKl7glYb1VB?=
 =?us-ascii?Q?qAhQJjFkDrIVsubE64dvZi5BMytbVJA0b0PoZZ94oONRSAFSkwiFM+B3XN5g?=
 =?us-ascii?Q?P118OSX4SVEwdI9vTX3Ba/hPEelNUbOrgflXBRKPeDqatHlmrv7Oa66ubrfE?=
 =?us-ascii?Q?2iRJ4kA/8jsMEl7+Ec3O8JHhy/oVkrDqdODsk1fs6ia+nd4I5X4nNJ6MWLZ6?=
 =?us-ascii?Q?UNTkYoSy1wHyE24CoGBUAPoCthsUy3pDTuUpXIlo0GUY5yC5DaDuqx2Wj5YL?=
 =?us-ascii?Q?8L/AZpEA5TZX7BocASIGBIX+8ewmpWokDt40lleAZdGiC33rqyYlPh844JaD?=
 =?us-ascii?Q?l58G3RZEEXDl5vBnJP6ezsGRmZwA5Tr5WkLLqhvVBQbWfGRaK/PpaXk/uzQo?=
 =?us-ascii?Q?AJMgMrbrOHUnc4FEaUA3oVTNBVtKBvCIKopP5j1ffxvbpKCoL4w3cRRTmvpf?=
 =?us-ascii?Q?Qp2bXMnCwC/hX/+QyCZG1z3ucCycACi2BePsmQQmwvYzRKcJVrIVzRZRsQsQ?=
 =?us-ascii?Q?AniieJswrrJmakM0ekmHJLpCDryAPCt2b9CRw1rG7P8j2BeGAdgwFhxlrY64?=
 =?us-ascii?Q?bMcLLYDPke24irTvUyemzaxTw/2HjlzyhypD4fTb/k2zBK0qsxIUpzafUFil?=
 =?us-ascii?Q?7Tr1IzforN0DF7u+I94QMEziIEjCoIQtZx6d3BtOWryLt0JZxs/DKp7Wwm/u?=
 =?us-ascii?Q?W+g2HvtM6KZbloLzanmHNHnnfXU7aQ1urLCLenyXhNjQ5K7mpZlquwnFhXvk?=
 =?us-ascii?Q?nj5yk4RO1aC11/c0OxrErGnTeuZYJ4jxlHvi5gQENVIIj/0KvikOvGDbLKSD?=
 =?us-ascii?Q?7v8y928jrRHDI2R45Z/+2xJf9YtNCBBCYq8kuOiMbsSJaVidrVSfWOFJbfP9?=
 =?us-ascii?Q?Osd7+gxZnOduh3MEoTBD1Rt9DGmgR/Z2SY4yPcIZSHwuc5GM/JjPLU48Z3p+?=
 =?us-ascii?Q?QUvxXK3Jt9dxfT4G4BIERxQNZB/gRba/zQW7E5L+R/mVckRWjjuoJOwrhfHC?=
 =?us-ascii?Q?PnSlF08=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rsNU9zsELS744r+a4Yl41Cef603b7hUn9wRs+voLwSNwPN6jKOlILMTxJyHw?=
 =?us-ascii?Q?AuYb8xPDid0DOgqd8Ge2dml5SFId1AGRnssX2Twuqem5fd5fVfUD9/r0dQj2?=
 =?us-ascii?Q?9VG73pK//FdGVdZiD7BfUi6cryLpS2CklvAnBf2L/gg1g81TPqiwS0xoN5Wi?=
 =?us-ascii?Q?cpcgHB3OlFnbeLQG0XC/PTIlUanqonGTiwnyHFCRTLRWiv4xY62LBnEvu0kz?=
 =?us-ascii?Q?EcLV7OSF9mHZj92mah9NdoFxB8QqEawEaTCxvuaI2x8p/8y1GsKLdArg/4PU?=
 =?us-ascii?Q?H2uZ+sZGzOhhLPF3fSYbVad9XrrQ3KmpFkFAWo5TDFE1PFhOgD0DMIFSCa0c?=
 =?us-ascii?Q?EsbUV7GGnmqjxSsipEopevwAcCeButBkvOOXGMi5PeTP2T/E7kjFabF2zuKD?=
 =?us-ascii?Q?ckDP86LUQvvuEvSgrHdZjAP7byp7Cz3ecBjqi9LKCcmQMv4BTjjN+p775j8E?=
 =?us-ascii?Q?HwuqtpWDzdZFlI/1OYNcwzkfFOKTIO+GuKvV3jHlTU6geKwDCY5ICqFNT3Dw?=
 =?us-ascii?Q?uMAVcfJkagI5GV1EEqfuo4czs+JvbdizT5ioH5KbzNYCVuBK2nlMajPGOueB?=
 =?us-ascii?Q?2F998W/N0kFnXD/TbjcqdvwpDSzjikCLmJRE1zZ1w+IPXfjB1CUjj1RI+4p2?=
 =?us-ascii?Q?G61fg8LMMxYmz3oEsZPeLmsYNByCnvlwAbL4x4KuiL3t/CstOVRGS9mpDWTQ?=
 =?us-ascii?Q?DJB3rC71X1tqG5BN+NrJL8Y5dGSJGmlaU07b5MD1VGuYArHM5c+WHdm2p69B?=
 =?us-ascii?Q?YWCPvaw9yUFyEJwVHXjAjbFLLCCvmaHDY1MQJIZPyf2KY35WhAQNBpq6zwtj?=
 =?us-ascii?Q?4x7z92LoXK+I4RtwxxW7boSdqCXH0L+8owXgiA5yP84MMMCkNzLGD0khkJJ0?=
 =?us-ascii?Q?KF7T3L5MBpUP19zE7x2sirajIlwYT3n0NL+cMWoAs4MXr7tjtnxTBLBPZpbG?=
 =?us-ascii?Q?znjiafzaywJEQ8xehmoK/BcHfLjK5VKxvQ6qvDKs8gjrN1jyyJXUgCqsfGTP?=
 =?us-ascii?Q?Dg/GOLgURKh+pLc0acqlDxzT1o+xO3b4JE9sAQ7mWlk/PLfEKqTbzPTMvrDm?=
 =?us-ascii?Q?6UXK0WwSUKOf6jSKjgcCvftYF1Q8vxlGOuuCsEjajDfe8JrGNlSIwgeig5SQ?=
 =?us-ascii?Q?jdaMPmAO8puI5dveJdJC7W2VvPlUoKhvYUquftiwWlwHUAo9QIiVtZyRrvif?=
 =?us-ascii?Q?/Of4hoeL/Z0ZrQpGhDhCLC9whUASHSf7+PmIPZVVjFpqLxs+hDQNF2Z27BC3?=
 =?us-ascii?Q?+G8WG6czndy3PuPJxPUdZ04MXM0lBlSRfjXLw0p6IJjPEO9jqhL55cYkbK1O?=
 =?us-ascii?Q?BtzzR/LKd6GmbVN8+9EHs252ppYi4MGHug1SIRUb4lxhTfH9w9I1msK1RXWm?=
 =?us-ascii?Q?+N1sWxY1mGHgTYLO1/ZS8jCKTVCNIoxUVpta2rTTZgUe3Edo5w6AZbCbLber?=
 =?us-ascii?Q?JGCiuMYPAe/JCiI24Y+oxPHC+VYyz/Qw8frG+WdrBYxENQwrTfNY3iyIemGv?=
 =?us-ascii?Q?LPR/t+oY7PmissCisUujMRIU8YOhBC/arpLodELSahqJU042WrKdvY6o/U1M?=
 =?us-ascii?Q?Nt/l5d1XSQtph1h9gF3ydQpY/7mnqcZpZzC45frG?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5476c002-c1ad-4f09-4690-08dcfe370b5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:45:54.6916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bad18ESEKU7RpycxfseR5UUj9G4K+HSwthyZ1pq8QpTxQ6Ue6mSwESPV70KTbj8VbW5HfRNU1Y7ORsg3dTIqBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4998
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:19 PM
>=20
> Let identity_domain_set_dev_pasid() call the pasid replace helpers hence
> be able to do domain replacement.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

