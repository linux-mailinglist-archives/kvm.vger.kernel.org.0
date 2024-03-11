Return-Path: <kvm+bounces-11487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BD48779AE
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 02:56:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD46C1F21586
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 01:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 480E810FA;
	Mon, 11 Mar 2024 01:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NLXH+gfu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A991F3C0C;
	Mon, 11 Mar 2024 01:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710122155; cv=fail; b=oGZu4WlQbUAb2R1IgTE83+fVdPrjminLw1TBwAAdlL59fhWlaVLa4gO1kutrzDiwcR6snKUPxLe+Ch5VWp7CPLRVNAvSYv+CqG6GImx6amqMOchbzI/SY0S5nnlsanQKBYtaRB9Sg+6MAaK4Zb2O+6+GpZG9J1vmgPyA9bCkAEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710122155; c=relaxed/simple;
	bh=7tbrXyRYw/gq0i0cE7zHQ95R0wyOigc6Jg/EbcrzUqk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zu8hdeY5lXiB5qOHp1+6lT/ZoY+HtKlpG66qwP3q2nxcqhnq+ADJnuQnqKN5bapBZndK0YGw2ArgzAOryW91eTH5gKqy7VNWXOUuodKGaay+FbCLyWO60KTo1kYpewSDgZg3DijbWYq2DKCwVGsbj52PCtB1WwJWZxxodGpotWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NLXH+gfu; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710122154; x=1741658154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7tbrXyRYw/gq0i0cE7zHQ95R0wyOigc6Jg/EbcrzUqk=;
  b=NLXH+gfu31tJh0gVuYlQ9BCloePkAxG2B+UpEj6gYD/r6FQB+Z+oJeMI
   dKbIO2pd/FssQPiSwlNP9K9kI8RjiFSWpE2x1uLLn1sAXV1WbloulyfPg
   kHvy/yEca7PCBK+odpbt3iDq8cQVVXDOErgfMmlFghWxhPzEDk5HT4Sdx
   ns2kKEdPK2txawip8jpJecM/D1sest9uQKwJkJtLYyKHMkmpj5pUrhZiR
   B6z5Lc7rCsFyoUqRzEOBOYv4J2Z0/By4G7fBBD6o9GmHoqsqbKR642XZH
   atz9vikl0w+0lqcA04RGhtEnlqzwhsfMkMPmF+ZXqxYVRGDqCDaWb1bJf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="8522841"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="8522841"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:55:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="11075490"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Mar 2024 18:55:53 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Mar 2024 18:55:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 10 Mar 2024 18:55:51 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 10 Mar 2024 18:55:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiZi7q/BAK/UdQvDCBo2eW7QYGH5U9dFcYEs4c1HJK/fxCJ5j+Ej2916QttnVMxASL5vnB7hpRIxrUD2LyLOTJ1La75MLH2IczIxTQnsFP9jy/pdEo7zFFm/yb1iq7cp9eKdy7a0abGFpXanF4WJFKsI16XzQycsTAHiRo4zmg0gGgBgctVCn2PBRpA3THyiv+GGcGQsmf6B/TxnIp5hPC34c2+xX4dJYDUyE1+NjoGw7HQgz3zJGI2aJtz+kV1XAgpIFjaT/voOv3nCzifu64O+NUEirMx/1DpkIqCC0CrNKc5nMKV3WiVjwnXq7T2jNcdGz4PKuUuaOkL8HelYvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylEMl/UtRjumiA1IuJ1BdrO4RK86WSagZi9JZtIiZMQ=;
 b=FwiPfpt54Wf87MRAY3YJdOha2pXewp0GFrv5n5SexVQIxyjMMrFKONfK9NHF1icEqgObTVvpY2P6LD/EuPTP6E1lOrngbbYIaP9pA/KX6j4ZNJ1cxTdjFXn5bhFuXoJitMavCaOHx1CDP+XjyZthxWOuXl8nCqk/sqgPt4Ly4DTdHZT9bAR09wyXFXI6NFsbjfUolYj/3PFUiGqRoGC0r2LD38DPGFCKzTvF6ScrhC8k1YSmze2D1vcGpj9Klyb8xmSIOKm3LP80IsCpi6CpGlQY4zQPCx4sweodK+mAZmfaLV8vGTy2vgAP1k6rLAlsQdpVEv8G2YyTl+UYVAqhVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4719.namprd11.prod.outlook.com (2603:10b6:806:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.16; Mon, 11 Mar
 2024 01:55:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.016; Mon, 11 Mar 2024
 01:55:48 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [PATCH v2 6/7] vfio/platform: Create persistent IRQ handlers
Thread-Topic: [PATCH v2 6/7] vfio/platform: Create persistent IRQ handlers
Thread-Index: AQHaca1GPcQiX/X4gkacyzowtf1WV7ExywVw
Date: Mon, 11 Mar 2024 01:55:48 +0000
Message-ID: <BN9PR11MB527674AA4544E1FB82949FF68C242@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240308230557.805580-1-alex.williamson@redhat.com>
 <20240308230557.805580-7-alex.williamson@redhat.com>
In-Reply-To: <20240308230557.805580-7-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA0PR11MB4719:EE_
x-ms-office365-filtering-correlation-id: 9a1a1e9c-eb20-487c-db84-08dc416e5f9d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lJut0ByDcnQoZMu1aHYrANLYILBp064UfPkFImFolUExq8hhYVZCPtWJxG6mfoncPZLvrqpoI8Ced2pYcUGTWUgQstMgq4CHXvnEnPocrCPc35DJMwp4JmxV5FVKrwR9tTF01GGCF+QobUgGkpMN/FAXYNtrmALWeUTqtlBZlQE810eGzGd1j7JDKO5pwpFuqHnIibo4cZKVtql8fDRSVF+MjtmG8M0fEIYxh7wY3002nJQvHFPqvVn+EYU08sAjeK4yAYO89FJMTc9f1GeD2qT8rviPnqb87u+mCYHVcE3RzXXNSPF1S8mGx8Po/AHjSaUT1rCUyLCrziai82FsKGRp69nsyy+FVk8w2+WfAGpP5uHCbj+aDmqTZBQpP56dMwhgXGXKj7a4U8VL+Ci8935Zo2JJSbRiHUbcGAwhrJEAiSKgl63cnVbCXQjunFrk46OXvzINxZKy1PwHmjN1gE/bOiVEyBoucdpeRZ+T19IUbyjw0b07iKcrUPtjVxIC76uwrgritLy4+58T1Eftpu2yNg15MimXiwafbduZ8XViAPLgzj4IEWni6BYAAMYVNVKcaxTtqWmd7duiwYi3ruW8Wj1O66ruZaQF1WNSqPMIClo3CsFKviwtFBkZ6xjNpsIEZZEICHNfdDw3PMii5NymC+odHtu4JqFspB1hRxwy+L9IevW3fXjNfXG6H7kAFJsas4SthDgZKGJPxYY8ptpEoLQ7VT/rUpsMvhstNVo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3q9tIlVE7wQ0r74vEFisPHsldvd0hVN9aYIlyqrmS4aqKWU3CvORYBGFxe1c?=
 =?us-ascii?Q?CCYl0y11HWI+6V/fSp0OfDVzANOlmzp9K1YViWbazdwidUTj+QbVMqZ9K0cK?=
 =?us-ascii?Q?ijk2+OIdalD8RvCa604uf/H511AJ0CK4i581NGusrHzAT6ylW5J1FGv46S/6?=
 =?us-ascii?Q?mKt2hVAX8pdGinT0Vgc9eKCB9rUA10pp2m5kPjbphx/NWZa6v7elisr9N5yV?=
 =?us-ascii?Q?XRyU/z6h+bXDvl4RIvHPMnTpVm8lg02HIUpwzG3PDNkTJw8rPGquPVBZCH6K?=
 =?us-ascii?Q?qt2+EgYM/09Xq7X72D7H5Lla0fcjAX0xcDwaZNmnppNYk44ILyJKmFbDZzgE?=
 =?us-ascii?Q?6dM6i+wEexQKJQETwXnpXR4gDMxRvxd5MeQVArkqm5ZnYcjx2xvRBaHSw4wO?=
 =?us-ascii?Q?tdLyp75lmZ+bFKoZaM/+FA3xfbOt5n181DlqGPkzaTqS7BwcGel+rrVuipg5?=
 =?us-ascii?Q?0tzBOLig2uzlMSHhlivdWKHPEJAQ3xh4/caGWSzhoGBnBziehxKs6gQTJelz?=
 =?us-ascii?Q?Knvk14QB64AfE8Ti6opMmcbqvlG2b0aDQKZTyEZS9U8Cm0z54y78uZLeWxJH?=
 =?us-ascii?Q?izJqZQTk4kSEXWVaj8vQY5cBvA3uBSi83u4ZYhijwoi/g9kCebMghnStX1KJ?=
 =?us-ascii?Q?LluZH1roXVpAkUUWwtS4T2178YNU6+8ciyTHfGUAW4La6zbWhsTI5pOjvyn5?=
 =?us-ascii?Q?M/QqoLkG4bvRSxFpWS4wfKBpJx74NbcPkpdeZkpp/GhggzZIfk8j+kHPE+eK?=
 =?us-ascii?Q?q5Pp46R7I9mWKLjcac76+HG3wA7pm9Tw/zBB5KSbHTzg9ev7G/tv+8gkZYRo?=
 =?us-ascii?Q?FCC8JqvNxMRn74wuOkeuU8wH6mM4m/N3U6YzRYyFaTIPYTlSZfzETv/W8Da8?=
 =?us-ascii?Q?Ka2LwSGjT3+akV1L4dqC2YfDwy7ldWT7EEP8NYN/9uI1IF4CEmlyjAZPnxvf?=
 =?us-ascii?Q?8imL9Kd/fqqqg9t3F4kLAJ7V7dZjuBwOYOd8hm4Rl6fgjlbwpqebsbH7Ncy8?=
 =?us-ascii?Q?ygKqfIUz9k0r7uIcJOgvF56RHxfaajTIslc1aF5Ixff9+n4ZkEc8ry2avofJ?=
 =?us-ascii?Q?tlgJbyBaVAK69/Dotv+VRJARSPHGomOqZ9Y1pAC4+KcogERV3Rh4aFaJbTRn?=
 =?us-ascii?Q?zf3wzmTtVwJPiYJahmPWG8T6uiuqFTtDMk+w8puT3znJJwaHyskNGAopzxon?=
 =?us-ascii?Q?VjEeG0e2mXUlz2XKe5r9AUkO3rxqtpo8sL8RkBFF4JrF4M3XgCxsjBL97FKU?=
 =?us-ascii?Q?lE8LrHOKVQi7MEXBymPUcEHGM0c9VE1p+hVNX0AH4ViVvaxoih44a/jfZyzF?=
 =?us-ascii?Q?cBYc4n9ug+9dj+QzQXLnJS8553o50zTvpRZtUpkkvYGlnoDNtB0m+rFKKuHK?=
 =?us-ascii?Q?MkOnyMaIjVd+ThWl8K8gGTlMTlt/b2/vEZEGIVXsEIn7gXqPCS5PIIBsP4YJ?=
 =?us-ascii?Q?zwMIDMy51kUeTzaltrqtZbQH68S/3PaStCFwlUcAJZ0cRqW19gjXVnMiPQfH?=
 =?us-ascii?Q?T+rOq2wETm2EwwE6ttL+FqlY+hkjUB3wcpGN1hubffXSTMv3hdAVSv91eB+m?=
 =?us-ascii?Q?5B4yhWcIej1N8QUIV4LmyR53kkp4+2MtikY8TFN+?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1a1e9c-eb20-487c-db84-08dc416e5f9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2024 01:55:48.5831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oACKfTzF2zqD1JakUzw0z7/yHsgKrVEr9YLLMu190kALwy7uIrY9JJbXr6+OrtR6nmw7W8q14yx3BxAYPJdnZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4719
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, March 9, 2024 7:05 AM
>=20
> The vfio-platform SET_IRQS ioctl currently allows loopback triggering of
> an interrupt before a signaling eventfd has been configured by the user,
> which thereby allows a NULL pointer dereference.
>=20
> Rather than register the IRQ relative to a valid trigger, register all
> IRQs in a disabled state in the device open path.  This allows mask
> operations on the IRQ to nest within the overall enable state governed
> by a valid eventfd signal.  This decouples @masked, protected by the
> @locked spinlock from @trigger, protected via the @igate mutex.
>=20
> In doing so, it's guaranteed that changes to @trigger cannot race the
> IRQ handlers because the IRQ handler is synchronously disabled before
> modifying the trigger, and loopback triggering of the IRQ via ioctl is
> safe due to serialization with trigger changes via igate.
>=20
> For compatibility, request_irq() failures are maintained to be local to
> the SET_IRQS ioctl rather than a fatal error in the open device path.
> This allows, for example, a userspace driver with polling mode support
> to continue to work regardless of moving the request_irq() call site.
> This necessarily blocks all SET_IRQS access to the failed index.
>=20
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 57f972e2b341 ("vfio/platform: trigger an interrupt via eventfd")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

