Return-Path: <kvm+bounces-10765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8878086FB50
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC10A1C21AD8
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD38171A6;
	Mon,  4 Mar 2024 08:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="egrtj5lh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085A614A93
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 08:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709539717; cv=fail; b=iHzi4m/q7Tbtpm+mr6pMN/OCSAoxo7vjKscAAokvmFBFaPWzjd1FoyGkmeZF5bZXdl7cuJQaIgsp7041mPgDpwX+oOauQsZtDZ/F+Gc4XtSbGoVKi6x8E2Dq4As+wSMtMWss02wswjCPA2a+FHdnWB2CPIRceXRoMz2QaGIhsEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709539717; c=relaxed/simple;
	bh=EmJN4m3P57GpUUU5bffqtSEsrNmEIVsb9GQpSO2gkjM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uZbeN9waPfK9aVzGv2xmEM2KuAZVVeHmxK45vKfWprGXQr4p8wpTN66CYpDrdq2P2BvmAuliq4XzD8VXR4Zy2E68vrD0iAASpD/TQ+4lwTfF5aITBClUdTukE0kAA240ZYgzZllNj+asSJKapZSVJ+bPCBgoAmg1Dpk35M5RbF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=egrtj5lh; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709539716; x=1741075716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EmJN4m3P57GpUUU5bffqtSEsrNmEIVsb9GQpSO2gkjM=;
  b=egrtj5lhU8u40XqQKOS2qtKTGgRXO8yGKdiHz7E1mAjOv1YPe2qzolWq
   i8BeB1DpOhc6dfpRozEsGiDHw+lqcB/edN5yWAd8XysqdQ9rhsOanCY11
   FpCrz5vjv48ksazFuaBnRF++J+HDHvPU9X01PcA0Df32sBoR2gIWC8PB1
   NU+h0dLT9OlRfMxciWaxrs9wn6U2rvgsY+VrDZSRFE66De7EhNni4EUmU
   thIMfsJJmZvfvxA2m2KbnXiIpRpWd2Az+SH7wvEkeDTVcDZTucvZXj7ZT
   yYUEYc88/2XQ7B3/IM4+i3X4XizRMaoAhcyQsB67AXRUfr6G0XTgGbRM2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="29440663"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="29440663"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 00:08:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="46421194"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2024 00:08:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 00:08:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Mar 2024 00:08:34 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 4 Mar 2024 00:08:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ex8qSuMRSa06xofrsHng0YgEK1K5PMtNcYXAkESt6FljdA1jfp7VDQZ5ceacgt7YH74eyExtGc8W3uE1KNZ+izeNab4/ZzSvm/X5ZgAzopmW+ONI9yuXylcTZGxWtvPM2SzJEGAyQCSlUexS1aJ10nvXfbq2okgYAg1+s33KjJzkOhEUMqojVAedmdTKQi0xEnYyZcUWcWAgx6//o2K2fTl4Aw55O2eFQbiWDC/0PshpsPMNP/g7f6w5+JBayOUKcCkKOZVmfwak2XJa4aGge4IkFJio/dg8BnqdepOr5Eu99R48lgfrr0QEbeu+a6iuBa6lPjst8mb1PRIKacc10g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmJN4m3P57GpUUU5bffqtSEsrNmEIVsb9GQpSO2gkjM=;
 b=Zx+gMMfXvb3C96JXjNU2JOr8BMu+bcZ4m2cxIo7BleAimR4fUJRgFo4gp9Y7oR3OG0X64BNO1JuKh0BEJ5vpOQ0CmGEPHGWautWSdcJ+e1Xs5/4mywVSVT+VHJ9fuMpFsHqEWt6psdceMCTBD36+FY3oVxfxy530JUwnWwAJcOyWjt9g/LPds28LoBmtDXqfz/sHroVNJiy5RjguRhaL3UowfMVKlfurhJvG58qItn5jnUn7xa5KsshoL3ZgRIOIxh+W4AvuF0QTEX0U6NQi5wIthgHXDUCIyrVaIN+vW8WT3uJlw46DpSAiWGIsRw0FXa2w2w+PSecKxm2iEHuBpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7731.namprd11.prod.outlook.com (2603:10b6:930:75::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Mon, 4 Mar
 2024 08:08:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7362.019; Mon, 4 Mar 2024
 08:08:32 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"linuxarm@huawei.com" <linuxarm@huawei.com>, "liulongfang@huawei.com"
	<liulongfang@huawei.com>, "bcreeley@amd.com" <bcreeley@amd.com>
Subject: RE: [PATCH] hisi_acc_vfio_pci: Remove the deferred_reset logic
Thread-Topic: [PATCH] hisi_acc_vfio_pci: Remove the deferred_reset logic
Thread-Index: AQHaau+Tt9fpVJ4wiEiDWQsvNp0O0LEnQFRw
Date: Mon, 4 Mar 2024 08:08:32 +0000
Message-ID: <BN9PR11MB527667CD0837A036394DF9578C232@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7731:EE_
x-ms-office365-filtering-correlation-id: 75c62cc9-ddc8-4502-b9d7-08dc3c224886
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dWcFBS6D9nZEygSYj40SkCCB/VIWpbs9HZD1ylbnrfZ9jdMNvIBgBrvwZeHC5w1gJ4urs4zObb0SdkiOzDm3kA9UWv8bw9EGD8VDbwsrYi4OMMwU3QIleuPDD07GG0ijDbfeGH2teFhXPvQBEbzMg8ugnZNGcFWa2PjBqGMMELP1ssTTno6c5xxFBc/YKRRcoP/WdnzW7HbizHmITK9ELOWy1/F7veFJjkjZUqwt0FDcXa6zBir+9Q9jk+m2bzRDfZYS8Bh+TKx5iu9YDRsPsFUj4c4uPva7Fr9zQ5JDFO3IWY9Q3Z+DM+2GWrS74IyX0+wPJgW4/Wbr29wn7IzfFzf2x1J1ZzzzUxsalO9oiqS8ITUJbGEes98rqJekO5YTElPyh5aqtGi9pP5DahLaQ7RFRs3rEB1mA0nsmnzRrsQBzign8mHcJf2R6tbSh4EiT2mcVM6Ukgu7f6rbUxviHxGo/UHo+jIIzmOVtkufpNL4QN9+3EToOMMYL0fMLAsAD0T96VrR68IGew1Ujm8enS42lh2WIlp1/Y7r5dzAj6fLaldHPX6ShwmzKRjKUCSCsR/BTtndFuVqhyV4YZ1vw8TukjeT5YuXbDAslxQ7JJVcWxw08NjmqzP6Mck45uuWuXy2q4ILDY34L0p3P+W+kSX2w6B1QFAhBIbBsTOZt2s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XDTR0wuJLIkV0fj2EJ8BHuKCJphcNQ57kzAayJ1GV9EqkNYZ4DaUhlHZ+R8W?=
 =?us-ascii?Q?vEUAi7imcJFS13ea1g3LJpYC2/BXHPeF/qzSbrU3kdivhpWQf9jchA72pOhY?=
 =?us-ascii?Q?Ohmpfe6Xt9wOPN/BIaulW/FAMIopMYHuNsHIxIbQ6jURpsEMMdFHsiqpCstW?=
 =?us-ascii?Q?zkQKGhkDjzPu9nC/GVzd7KTyDBUjmpGSr3Be4XjADoHc5OV0GHmqzKHrP90r?=
 =?us-ascii?Q?vt1/EFKpiXaGiHG1RxxHaw/kvjRRc9kc2u4NuV8V4XklChFghahLBhrt06v1?=
 =?us-ascii?Q?No4UecnLDNwk/Z/Wd9ugpfJcd1+76xasgG9UAb1wZG7QlyLPs1DwKvOpbzr/?=
 =?us-ascii?Q?fc3viEoVVYzSgeE0KCIll/WQLieyCmmlQ7M6camhcFfED5Lfv81+aOvCAoUg?=
 =?us-ascii?Q?HABcjgYQiUJQopGSkncLtQg4TGEb74U+xKnvijeRo2UDA4mCGbP5tQnX6uci?=
 =?us-ascii?Q?cjZQPqXvpZdnsWUe1cX7l7CLNuNCxIH092al/dUJ3wElhUExe6xwyaYxJ/WW?=
 =?us-ascii?Q?veKjV/Jo3W+Onp3X4hkEVROzQMuuOS39JGof0qbWCEUSAPR7DG3nb3FV6H4J?=
 =?us-ascii?Q?G4AFW/35jkUmqV3MiRBRothEKXTyaoBPeTP0mrf4ns3mz1l9bgrbMDnKlBAa?=
 =?us-ascii?Q?sekt3QO4QicpFcgh1FMPqbZUcE2jNsO7B627TOYT765NFjYmz7QlmpsrqGud?=
 =?us-ascii?Q?IKAKG0+UpWPKvoxMRR5BMUPYDSse5p7h3ES9cU+E5IWKdBR4s0cnKS7DpHXI?=
 =?us-ascii?Q?dmAPUv52m77G+9yU8RJ7y/RT7y7apfpdQXX3sUBg/wOPW4pDwUCraXqGSOfn?=
 =?us-ascii?Q?2w13PAQ3fsNVUifi9+CbLojq5ms3PGYPOzSoZQeHH5WHRElVBCogJbGjQ2bO?=
 =?us-ascii?Q?CyS8vJnbphke5aAgZ1zu3SqFdnM7Lnmh+wJv6qcbY2iLXsQQg266Ywlug4PG?=
 =?us-ascii?Q?UhjmDs9w9bQDzaYCKKeLAnzQ49zpKuC+pqbP9X7HZb8vh3I9YE4lXDwpxTqk?=
 =?us-ascii?Q?Z8sA6J7Nu3hZzyPKlcytHoSZLC4+gUZEyyZOEDQxTv035kA26RjUdZlfP3km?=
 =?us-ascii?Q?qusdPiMn6Y0p6VpxRPxlaoyWldsTQOn890Pv9KEr5bKQhqR6a+Wv0QBeMyZI?=
 =?us-ascii?Q?D3KAIU7iWCQm6xkxeCkzd5hZonEmmBTNJhr6fm1IpQAEKSLoxoV8okA5vKts?=
 =?us-ascii?Q?XeMoFIAsWfZV/oUjimp3wXIrAmrqLZIYBmMFzJuR3pxZ/2epABHLh+jw50xM?=
 =?us-ascii?Q?n3Xw+g4GW4cF14HhNmMNRjDavxcWuG6C2DcGbsNfO+VVDzY7q4DUUCMqzQ0A?=
 =?us-ascii?Q?1JwCHdXAR29NDzhoDhAvifx+Kb4wJTJUm+kdfKi4aTv3Ue6SGcSclPgv4V0n?=
 =?us-ascii?Q?4kuAMnNuo+wv0BdhSrEaKRxLlfiwtVQCH3UKm2Ej0kHhN8CYJhnEObgVcKTB?=
 =?us-ascii?Q?X244EwYlSSDLQARNfJ/vWxEU6ZJKiJKxzuehiJm65ys85BCwiItTrVpepjRz?=
 =?us-ascii?Q?Ttw843N4rJTtra4snZW9s3CPp1cY2RIOoCZoY3XFflw2wxiJxOltCku4/4ih?=
 =?us-ascii?Q?B5omUUNZQMYMPL7tfqrHgWZdGDOkEwPA0TcWqLE9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c62cc9-ddc8-4502-b9d7-08dc3c224886
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2024 08:08:32.2540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yIkVN0n8Nkw7tXHhvKmKCK5GgeylPzW69KKDtBAK0o2kEH8lJmq7tMGHR+ALI7KPAOCPlHzvPYfF61Wdoc1Jwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7731
X-OriginatorOrg: intel.com

> From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Sent: Thursday, February 29, 2024 5:12 PM
>=20
> The deferred_reset logic was added to vfio migration drivers to prevent
> a circular locking dependency with respect to mm_lock and state mutex.
> This is mainly because of the copy_to/from_user() functions(which takes
> mm_lock) invoked under state mutex. But for HiSilicon driver, the only
> place where we now hold the state mutex for copy_to_user is during the
> PRE_COPY IOCTL. So for pre_copy, release the lock as soon as we have
> updated the data and perform copy_to_user without state mutex. By this,
> we can get rid of the deferred_reset logic.
>=20
> Link: https://lore.kernel.org/kvm/20240220132459.GM13330@nvidia.com/
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

