Return-Path: <kvm+bounces-16122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC99D8B4A35
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 08:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD1B9281B3D
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 06:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57BA4F889;
	Sun, 28 Apr 2024 06:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bJ+fJsCs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA2028F0;
	Sun, 28 Apr 2024 06:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714287556; cv=fail; b=lTcdX9vi6HrfyFhenpweZy6jh2VuEmOm2t0kRn+/03cFRfMY+aeBTHZfLKiZg0knIo3DhnByqNwoT+YwUtyaSUN8+37xYQS1PW8b5/uSUZqYFg2+izc59BdYLeYdX0Tyi0tIlYoc4qNXbDzlIMrbwE0hcQ/QkQsI1kvh7S/+3JU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714287556; c=relaxed/simple;
	bh=cXtJY8hFD33kVnVF0kPACXhftpJuPuedXzkHE2X1XeY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oz3EzZDvnKHa/GiyxiAY/VNq/VIucpr50A5PQD1X0TunveWzTBp7nrvLuQKFK2C9R1Y1R9BnADgdezpvrMxncn4nvOmam9u+xWPdrLcYXJSPGojzX7LlZiL/nSU2xuFEOHd+APiP9prOhbP/I77qWLp6upTIaJB5hDVbFHcRQ0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bJ+fJsCs; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714287554; x=1745823554;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cXtJY8hFD33kVnVF0kPACXhftpJuPuedXzkHE2X1XeY=;
  b=bJ+fJsCsUgzyzzSbfcsAdnUtt69/qk7iO1yv6csTbePtMyDzLnESF1ZQ
   exirejEEukFXxCDInhXW0ZitjdvFBvCN7UiXS/vho5mFE2Wohnm4qvNCr
   5sSS/JNG6OFuXBl3zHkR6uF/dTAPxsdorNCjEz+zXwkS2jYhIL/+Hb+bs
   mC3St9YX1RcOzlK3DZTMixs76Qqee15qDIi2idQBCbZ7Cgeb9h0rTOzaJ
   WsM9VSsdDf+fDAPA7i44aIjGrHeq7Cp9aqWmjSBCzxkppt/3ZdsR/nNoO
   hVuFLIAN3lLkMbPbNjbu5YjXnZHOsTNVJbUSzwBKKY8y1TBOU6VQHvUq9
   A==;
X-CSE-ConnectionGUID: 15CvriHrSbmxU8bfPN8Jmg==
X-CSE-MsgGUID: mtstQ7L2Rh6oERmKAINmBg==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="21388051"
X-IronPort-AV: E=Sophos;i="6.07,236,1708416000"; 
   d="scan'208";a="21388051"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2024 23:59:13 -0700
X-CSE-ConnectionGUID: bVJNilRHQYWgKs1Lgw2Wxw==
X-CSE-MsgGUID: WXxbLFGQRxGPmgFxtG+iIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,237,1708416000"; 
   d="scan'208";a="25901514"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Apr 2024 23:59:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 27 Apr 2024 23:59:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sat, 27 Apr 2024 23:59:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 27 Apr 2024 23:59:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUyC9o2ufijWlXiMcG3EPsXOcw3naggXD3KwbD6Keycf6IOaUCPwK9vOmchPMm/N9Zsig045evAOEV4wSh9lflGTZK3AjxHm3YQ76ZS9i3esdHRTZz8ypBqoWFzK/j8e1TTP695DoVfVwTi7Xu9kZ33Y61ghzwUnVlDxDlWh2zG40ryN/JPzq5OuJouw08pgrke0cTEA/lJ/jnncFEaK6A8JyllPPWAIGk5c1tPn9UClDWgTrT1JJginwobyh+DuuUoERBuLUIA8dOtt4w7Tz9AX8GrHyps9LspZLuyIDchXdXdF07+HTigE/pGTjH8sbOh6HWMwi5u3TJmmB2NG9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7s3qB8UVHKSr0zGN1YV4l2miQP7s9nC47wFO4/H7W0U=;
 b=DBy467S+qX68ULkdNrgFB/PHXrvmAeez35Ezwa3Ke/AEJeJWxrkrQcqzMibewYSIe7NMqErjOqDYuizpE6ixEg1fnaaAg8Yh1SSfT6FMmYnxnI9+rcm8d/qMXZD6mku7f34WgPUFZhrO7JpvDXwno7Z9StZuKoLyFlmeNFlRC2+k0a3zJqZgGIKnZL0VIOlRaTcKKDM9YkOcyzu7aYU0N9zKK6364FaBYWpmB8ViFVZGqbsX7YAfCPq5Ef1MusEHtgBNFoGNITGQ2nXaW4usFcSK5zCoQN+IdadFzjye5W/8DEL72j2fm9YEbHUX2EeZK202FsdistCpOYKcH5hFqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4673.namprd11.prod.outlook.com (2603:10b6:5:2a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.32; Sun, 28 Apr
 2024 06:59:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.7519.031; Sun, 28 Apr 2024
 06:59:10 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Gerd Bayer <gbayer@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
	<schnelle@linux.ibm.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas
	<yishaih@nvidia.com>, Halil Pasic <pasic@linux.ibm.com>, Julian Ruess
	<julianr@linux.ibm.com>
Subject: RE: [PATCH v3 3/3] vfio/pci: Continue to refactor
 vfio_pci_core_do_io_rw
Thread-Topic: [PATCH v3 3/3] vfio/pci: Continue to refactor
 vfio_pci_core_do_io_rw
Thread-Index: AQHalzGYZBj7tl5r/U26nLrq0RTMrrF9Qn3A
Date: Sun, 28 Apr 2024 06:59:10 +0000
Message-ID: <BN9PR11MB52768226A8AA551DC26516598C142@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-4-gbayer@linux.ibm.com>
In-Reply-To: <20240425165604.899447-4-gbayer@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM6PR11MB4673:EE_
x-ms-office365-filtering-correlation-id: 0fb05c39-7bba-4a5d-cf00-08dc6750b4c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?wCtkcsIFy8xHJFTXQkhK+vWTCkmWHMh+4Qka8XIduirk5lvfhUlpfh8HMHEa?=
 =?us-ascii?Q?SVvlJbMuJwAt6a3I7UcDTxzfPls34R6104HKVd/O02cylkU5TVeCfVuZRipb?=
 =?us-ascii?Q?R0kxoGYARyJONxyyzPDGX/SgMy4khqPJ3gyyUBNxnD4RdzcCT26re0xrsvqd?=
 =?us-ascii?Q?UJDyiwvhRmjTnLL86leQMxaInuug95K60OI3Hgl+lK2SqszGFPxmkFxLyjsJ?=
 =?us-ascii?Q?AFiK//3Kz+nYn5mO6UwyPQFElcOMyD7f1FwWHRT2SznrakcnBdIGI2pBWghA?=
 =?us-ascii?Q?8ybldGT2OcRIpkDhCtyQ5hel2kSpKwiRzCsEjy+OKd3+fNSymBsjaiGkCeq1?=
 =?us-ascii?Q?CBgrJ3mCyqvm5R/E/CK5h0GTIbssjKwbb2+LNyyESF7ZFM+X4dyQHgRR2UwX?=
 =?us-ascii?Q?HC581azln/Ih8mxfhmLua39pn9XPwoFRckSwsnz6RMi9xUUipIK3rLoXxKuH?=
 =?us-ascii?Q?fGABi81BwsErHPcX12NffE7M+6M83e3hv/zre6QfXpQ3JGpxPhdAsjce+WKT?=
 =?us-ascii?Q?RIAqnVBUFHCKtbSeFgvqok+A7OBRBWJSi/WuQVrjPaUdEM5mFL9FyuHSddO8?=
 =?us-ascii?Q?wjqURHjzv9QvK0PLPKAmtKXTKRVb+EgJxjbvXoFrWAa01/oh0QfDwHTtF3s6?=
 =?us-ascii?Q?jvCBdMzFq0HtVafnSrZAEddH63HfAFoOFHI+YmE6CuOG9hf7zKD1UZUn5hV7?=
 =?us-ascii?Q?yIKgry8gJVf914QgKz+0uQm1L9+gTl/Yp4/MDhsXM65xRjraeCcTlrTeUBLB?=
 =?us-ascii?Q?rBLLXWdF9pViDQnXDjaKaVOEo13Iao+k0cujdEqjmeYx6B8rHa9CPZwWazOg?=
 =?us-ascii?Q?Wq0mst73ZFgG9Dv+69msD+yboB/R9raOd/tiRoS+hMZwZ3hbmRFJIckaQMD2?=
 =?us-ascii?Q?ltbmpSgJdolL27JkVn+/gDUoOFt53TaWoWYArX4Era2Zx6GSFkxUGzOpGLfe?=
 =?us-ascii?Q?c1IyERhYe1JJzCeJnjLsKLO8qBdi3/JDMgqhP78rkJJIjpkPLVFePrRxqTgl?=
 =?us-ascii?Q?uBNGxbwm2vMbnrtoVDJ1jWkeZfj3gZiTbjl/EYZuMEiwS+2r2HFBJ9/VutCl?=
 =?us-ascii?Q?2YeoLVRLNdnHS8cBouDjR648UucwpBIQ5wDkvd0YY85iq7Yy+DfZu+3Lyysc?=
 =?us-ascii?Q?hTwNugSij3ZPZmy4Ii629vGL6Qeb4BVUiHkSAI6lkeRgdLmZhcAgZiz75s48?=
 =?us-ascii?Q?OqQynkw5hr5kCQHSLSivl4C20NlKngvfhojWzRoDuZKzbm2g6kI7zyalK5JI?=
 =?us-ascii?Q?/bA4ORupi/d/4utUCOx+XOtXo9oc8gmosU5rQbU2cTh2HlXL4WkZRSoE8T4A?=
 =?us-ascii?Q?J4biJCqOmm91bUrkOW0c013T+r0tJF8eix0ZtLMEmFUTZA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5x00+f3MUoWsavLhaoGdi5AFw42+M3sfsjYpsf4s3mWgoVETFvF3vgXTnqxn?=
 =?us-ascii?Q?5mVMiAMk6GfArq8lUrsFdIhB9quwntD121RekRrGTvrNImtcqNQev5yb8PMQ?=
 =?us-ascii?Q?9KTQte+GKpBTWorbn9tTb1ub23UJxEt0nitsumXwvTkqwLAFMoIylskv6ECL?=
 =?us-ascii?Q?Ysu3r0B/t00adsB8HsKWRBjPFisIuO7mnlJ3KYAiocRkiXQMbdx0EdoMdx5X?=
 =?us-ascii?Q?sy/qvMpbD2Ws8LDz0O/PdNovq0Bg5F/NHyi8qfA/dxe4ZnohnI9m72rJSivJ?=
 =?us-ascii?Q?pRg+mhG8nnQ2ZUAeKA9/2V5tWnqKkJJmRZL0Qqa/zB0CL4jZRFpm0i4Cjbcw?=
 =?us-ascii?Q?i5wnbzYJ3sZcG5wkwPo5dEuNIVrl5XVJ0keQAjvZGZWIcbHLbUG+1CpC46K6?=
 =?us-ascii?Q?tcgpyzuMebPC2rm6u18rBZTn004+kCDGF22XwUS+LizQ0B+U1G4eYzKWV+gK?=
 =?us-ascii?Q?VoxLL08NeEKrV6pScfgsQt1OHtl8/3YCfJPCJsyt/IYe7HCcswzSjUbVdE3+?=
 =?us-ascii?Q?+g5wIuBPvm3lOlHffUU8a0nNHkX6Q9RWDlode1ugyfoNCEg0nhad5tHRrnkN?=
 =?us-ascii?Q?pBGfsznCpgVvffTrDWa+GTBgoK703TqDRSyarG7Tg2nF+2jiLpzBuWy+oGZd?=
 =?us-ascii?Q?4GJMouysNXINWoS6SeKM4Za0gdTLzuxosmTcGK2y6wSmSDZDMoxniEyNMcsG?=
 =?us-ascii?Q?xXFcz/yM2eU6DKG4Y+o2UnMD255FB9khpUvZJ1oVFbQP3rdzg0Shf3aevyXq?=
 =?us-ascii?Q?buUgMu19+v1l7uTg9auM5Z10X1g9z2VGEyCszO+BZ3DvSwz+oCFnXqMVhva0?=
 =?us-ascii?Q?/Ij0CJbm76BvN1XYOwW7CtUcVvRXZIoUkI6HpZ21+HtY0CEA9Jm0t58j2GqX?=
 =?us-ascii?Q?bRYZbRrCm4zCmx9dqDhOK76vA1yVtLIBswLPkomAPZDN1GyDagwfHYp0RRl9?=
 =?us-ascii?Q?vJ+n9zi+3P4VR1CQCZDHjE7V3EzBEnp/TdwHju+UVqGPGJiGIdFMZKzxfK/q?=
 =?us-ascii?Q?6qLvDQjzpIQ+9ynUXBZtbbEezTIejoqdRYxK6U0WpdY6NJHo9ekfRp1XQQyQ?=
 =?us-ascii?Q?+1GqqOeidytr47raDklcQVQaRwdwrIGGUngrZinF/MenqXdZqKgChXCS9K8b?=
 =?us-ascii?Q?hbAAhgmOLUbEV/dG7uIwLzrtyYeKHRSHb9FJ6cz8B8dyLbsXIRbKzmZC3Mfx?=
 =?us-ascii?Q?KpUeBdoxqVnaCKB5SziXZpliTT171pwM3vLBgGvjV9yj9QtIQrbpWnJFgsA2?=
 =?us-ascii?Q?2e+aVXhzoYkBmyC8CL+bNb69eklZkk/u++UiNo4FpHy4XG4tyE5h04sgK4kv?=
 =?us-ascii?Q?FlBSUhnKcrmReXVDk8fqQp24P/+rrIC+myBWNUcYjntnLTQsvZfCTlBdkNTk?=
 =?us-ascii?Q?GJMgYtpitxBSBFFWb3Wn1Rz6Qek2JRhuxweX+LCtFN+ie15a5Sybb9bYFEjN?=
 =?us-ascii?Q?GwYSkgbdNNA67OoNmicZgzVuGvDgOh5Zg/NxZvcQsWhNh5iBDOY12FPpVvWj?=
 =?us-ascii?Q?7yNEix2RQ4AaDeq+6fq/vpm52p8a2WG7vE0epT+tjTJZ7rsmV7ZeWOy6hb0N?=
 =?us-ascii?Q?ixMQFEN2+/qd36Ns4QzOFKcLyRRTeaBtaGCcOZSx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb05c39-7bba-4a5d-cf00-08dc6750b4c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2024 06:59:10.7092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OTO/YS3J8HocR+e6SKFYEsG6NFnilxADepiiqbirQ/EzIoUyXSjMF3toHKDihvQFqJ1o+paB0yNqi1kfUxlmgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4673
X-OriginatorOrg: intel.com

> From: Gerd Bayer <gbayer@linux.ibm.com>
> Sent: Friday, April 26, 2024 12:56 AM
>=20
> @@ -131,6 +131,20 @@ VFIO_IORDWR(32)
>  VFIO_IORDWR(64)
>  #endif
>=20
> +static int fill_size(size_t fillable, loff_t off)
> +{
> +	unsigned int fill_size;
> +#if defined(ioread64) && defined(iowrite64)
> +	for (fill_size =3D 8; fill_size >=3D 0; fill_size /=3D 2) {
> +#else
> +	for (fill_size =3D 4; fill_size >=3D 0; fill_size /=3D 2) {
> +#endif /* defined(ioread64) && defined(iowrite64) */
> +		if (fillable >=3D fill_size && !(off % fill_size))
> +			return fill_size;
> +	}
> +	return -1;

this is unreachable with "fill_size >=3D 0" in the loop.

shouldn't it be:

#if defined(ioread64) && defined(iowrite64)
	for (fill_size =3D 8; fill_size > 0; fill_size /=3D 2) {
#else
	for (fill_size =3D 4; fill_size > 0; fill_size /=3D 2) {
#endif /* defined(ioread64) && defined(iowrite64) */
		if (fillable >=3D fill_size && !(off % fill_size))
			break;
	}
	return fill_size;


>=20
> +		switch (fill_size(fillable, off)) {
>  #if defined(ioread64) && defined(iowrite64)
> -		if (fillable >=3D 8 && !(off % 8)) {
> +		case 8:
>  			ret =3D vfio_pci_core_iordwr64(vdev, iswrite, test_mem,
>  						     io, buf, off, &filled);
>  			if (ret)
>  				return ret;
> +			break;

the check on 'ret' can be moved out of the switch to be generic.

