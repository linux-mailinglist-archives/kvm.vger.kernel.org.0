Return-Path: <kvm+bounces-21632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB97C930F6C
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD5AAB2126B
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D2D184131;
	Mon, 15 Jul 2024 08:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OgVSmllJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4884A18
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 08:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721031414; cv=fail; b=e6Ytt6uWJP+ivlnpE0PS6enCchArnifc3Y5QOWRr9RKW+3pn0v+8SvZQfNIxI4TOtTbS7HHEcFI2wA6/IJZfW/nWhfRxj17x1uZvz8MvXgUFftMWHrruNjCJpJGHsQ4sooJ9bECNPjGDRfosILjZZC5pk0UeSj5XG4AcbUebUkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721031414; c=relaxed/simple;
	bh=iYLcCo/Lzv9xFkl5BqkpQDucnVSnKAz2zjPAJoIOMZY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LjHeousOojhYW5fOKm5vbD05GnCNcpVRYEiI8MMyyXTfYMY/k7yP6UE5QVrm5ZqMaC/pcw3HH4WIzISXoYL2BHy32nr6m0rJGBN7oE+nDvfeS0Ro4d/KSzdqfqEiUig1J87xuI9H0YoPrDOfgskMFr/yWKfI7R2yhGdNh/FF0ew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OgVSmllJ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721031413; x=1752567413;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iYLcCo/Lzv9xFkl5BqkpQDucnVSnKAz2zjPAJoIOMZY=;
  b=OgVSmllJ/guavUYdM1Wl9Vb3eVJkEa7w1RU8qn6Arqm5flYysL3kE0tj
   lV7AKaUenfiNLXFkrjOM4ruTRwoOK2i0bjHdgcYFGjn0F7sxZqaUBlXcq
   I7d77xSQwUPwEKPIQuQ/HI6WiAf6+191R01zjRR1CHfC72zP4UDGRQqzN
   qjav/L17p3OdvU79TvwkREXXIgpH7d9I6Xyk7DUFBpqvlpdVH3owv3I66
   x+FLAZYFRdpkVIU/g+sDnT6J+qYOToS0f9C4cuEnLHFbmPKOXgS8NN1Ai
   vmL4gOEIku+8qvWQj+gpU9TOIdRqshjw1bQF1yiTFFGG0Dsla9H24HaQq
   A==;
X-CSE-ConnectionGUID: 8QwZEmiqQJq/plfVxpdk0A==
X-CSE-MsgGUID: tnQnDjyRSDKyEyQaBTxWlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="18547854"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="18547854"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 01:16:43 -0700
X-CSE-ConnectionGUID: fgFvF71TSIKeINeoXWdMGg==
X-CSE-MsgGUID: wek2pJhHTIGtR9E5CQx6Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="50305591"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 01:16:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 01:16:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 01:16:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 01:16:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/MttBjUNs++drVT37jdLd92grRRgA1POhpP1VvHdv+a9Qan1xJiVpqI0AESZYMBQl2+vEqZ4YraglDrcHHF95NHlVMseYLgeNNLagUyU2J17nTcbLy3FfkaY6IJBYPRinE2VZD9YwdsBFygAikFH8LtUTK1iFTgWrVkP7eCzBf02Y9SeYYnJ6sySz60yITUo5bcWo42k5qctVvOxJEvJZbdGe8sXW6D9/k7ouVYfkeWeq2LJhGybjE6scRIFOw9c6Wh+OVXn5bd2RywjCQVnTsPf+OFZ0kjZkHoE7hOZorCcWVUj+Fax0wj1h99EWdbp0lDNcBVPMgtFctmujwMWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYLcCo/Lzv9xFkl5BqkpQDucnVSnKAz2zjPAJoIOMZY=;
 b=bYEd5tZYPG6WkLsSs1sO2r0KPRhWEKcCuwuGGnCmQCAEKfmkMjwLRSCwQU23FzBfhejfoY5dgmJGgNvBnz9/7addE+x56tEMTckwYnXKyjlTX8I+O3JqYRds64mr3jpn6kmEaQWTkssftoG6Z1wm/o6ppUcqutefeOAsq8zcAFbG0sh6cwK5E8VG8avxGnWK8WDghib9DrIyHOyg+TMMzqm7uyzxlklgxdqmNCQlEEP34wOQ3Ka6KbgAmpqDnasqBGoAPFgucRwhX7yYG7iD0QB65U3YhmuDkcxV8P7GKq6Mw+GH9PSKAL1VmTs4ErUXPcWOoIi6CYJxtm4D5IPtBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7953.namprd11.prod.outlook.com (2603:10b6:208:40d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 08:16:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 08:16:40 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
Subject: RE: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
Thread-Topic: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
Thread-Index: AQHayTj2wpmFdPKSj0OJ4Op2lJVMhLHvsdBggAI/lICABZgWAA==
Date: Mon, 15 Jul 2024 08:16:40 +0000
Message-ID: <BN9PR11MB52760966CBFA7DB116ADCA338CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <BN9PR11MB5276F74566E3CBE666FCD3BB8CA42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240711184119.GL1482543@nvidia.com>
In-Reply-To: <20240711184119.GL1482543@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7953:EE_
x-ms-office365-filtering-correlation-id: c13d79e5-fc64-45bd-a573-08dca4a67483
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?KiibhpH54a7g3QcyHN/8bEkMiekxSu8UJkqtbO8forpwZ+sMr5bgmLmtgIfC?=
 =?us-ascii?Q?0/xLQW0iwvl0R9KAtsRvjlGq05TmRCUebWPoOyCr0MuWlP/T5+k5eMkTcTo0?=
 =?us-ascii?Q?+nXqCCuQ3z98xYbuD66a9jtv7qn7RESO0DN+7f9p73mfPL936837BdOQLIAc?=
 =?us-ascii?Q?ZV1kdBONDvjTFp/8Py/JgHf5f3apAOUJE35+QI7n5ulzRsPPvDPZ2Vrykbay?=
 =?us-ascii?Q?w/wqGS35gUJ9hNL6XKy3lExL+zv0xn/1C5tzGRiqbRZCl0mCQx9C9BG7sWs4?=
 =?us-ascii?Q?VMoOswLRqwsxz+oEnz+XmAsii57jrhhJ1ZD8XHSuSf5uRwTU8xBztHjDBWYI?=
 =?us-ascii?Q?y0Ma7d83qZdnOGFbLWkbzqxtcVXsCZtiu/0jYS1HoD+sBU+ghsC0fSZsSWwN?=
 =?us-ascii?Q?zn/AmV5e00ETNe2N23CX8m216iiIlKgfkqJg3jIq2LiGZ5DZGVLJTpqQ44bV?=
 =?us-ascii?Q?PBplA7jexBBebU+Vau3xbxoU5lgQy+Qx/4Ryp2y94rbra1GrVvSyrJCmZQvA?=
 =?us-ascii?Q?XqDkFF2YjO05PD1iE6QvizE9wWIC9G8cIe0gepcNTzkVA3JCyTwWRFJKqwrv?=
 =?us-ascii?Q?GgOL3caoHKFdGWQozulMW5jH0J7/5ouujHyBLY6/KqFubS1SlYF/kPgKFedS?=
 =?us-ascii?Q?VXA7gYp5zDxD5htE48etPZw0vT9owYhU7NYnBLwnKXt8XOV7QsA5SHk2Zqxc?=
 =?us-ascii?Q?CX8sdXS6lDO0tJNackKYPs9uDCY7F4PYB9A7ayVEYm2FbcxRYdfrjefZPsHp?=
 =?us-ascii?Q?mxUk7s914mxJB31wdi0DLRcwL/moQ/+IHQwr4RrzuFXgSdHcQBXRaDbRf0+z?=
 =?us-ascii?Q?2mpthygLSvTdCTT8KHgchREOaLKMaxd9y5AUnx+zMWzYl3CBEHGntRyk0A6x?=
 =?us-ascii?Q?1HwnR4VuThUvMrmU4/+Y3ZonoQ+xP99zGF12lbsJAa4yNVnZ7pK0XyyGT9dW?=
 =?us-ascii?Q?jobpaMqV5myKU8eQRFBQWxZaXpYLpel7LQXy2JmvnF146LLqK2Og16FvfJgO?=
 =?us-ascii?Q?xW4NjWBJPEgOGsEPpvefzUgkRTMRlTT/kSnTKhp7V0Ux7X8euC9ZHfkNOCaU?=
 =?us-ascii?Q?AZze2h6TRMrYohELn+TAO+wxEDUtQvx0d+gNrMN5zZcvBcs08iBr8/p2L2MS?=
 =?us-ascii?Q?awb4RH7plvUf6JXWPQDqkfmqqlLRnE+DxTmB7zkaVBSmKqCvXvzqUAsjA2II?=
 =?us-ascii?Q?CTuLDmNoXlkHBAGwvgE0R72+dB+yFJ7heWWA/I6+rKdAne9u1I3YYSn9K9H6?=
 =?us-ascii?Q?JqX3VUQsyUqpl2XxRa1ERfH6eEYvzbSgwFH8ppm03RUe6vSWUJ7jsdhUM0H/?=
 =?us-ascii?Q?OI1a1tbcIhd2EbUcrtdwcfgvHRabxl2mzxBZXsl8yHo9T7mnX0KNt+DG01Gy?=
 =?us-ascii?Q?KLiJVjgR8GsAmIxM2p+Dt+a9Oo5+hvUag4sO+vKUaYhkRsHEog=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u4zmJT//Ccjns8RqMnZVlvI0EGg/J1XUgXvkQr7BMxLdJeUndgWzPjaJe2CX?=
 =?us-ascii?Q?qz1nKtXw0IoQPJAoyhKQs7KkF375hxlN/vyL3YZWWEvcF5ShzfPQL8CgpB0o?=
 =?us-ascii?Q?OEeC8+/RRqQWrS1kudsQ76Y1tqQRqUA1VwPlsymQZGmq8z+5BokmczXSijVP?=
 =?us-ascii?Q?/Q9csvxgm/G9KFQVOjf/dcEr23mxQnyFh/PA8vm9xhqcjedFpsBhP4p2nu7p?=
 =?us-ascii?Q?SvFdAyc7hYl/N86YzdOmDDAFxMlCAcag1NTGv1r3eVhC3BIZnOr0P5jx6nE5?=
 =?us-ascii?Q?MaeGMVgebPWOwuJDfKopdS8Jchj1Pj6PZquEl4HW87AB7BzVoM8tXprcZqaP?=
 =?us-ascii?Q?e5Wb8euHKiwTI5NVKakWH01vCsHhm4JN6ptftiI0ksnn0gLTB1pl5VpDVkWB?=
 =?us-ascii?Q?g8232q405cYQiJJgUh/pjJKAmXsHlOP9j+2/IeE8OekFrU9VoZ8zYAj+kOmR?=
 =?us-ascii?Q?2aKNTxBOh98hn1doO3lbvp1sRWQ6fxT+n5d509V9LLcGX+sq3QVX0/CQvSxX?=
 =?us-ascii?Q?OXk7cypLZzRiyyfsFVD8bn+MbteDueko1YDn8ETAdK/2zrMTM3rzXZKYy+u1?=
 =?us-ascii?Q?Gjz1G+GGm6FzhGkY2EaIre66WmbKZWBpXclo1X2++FDFz2yGS06XHfkpR2Ft?=
 =?us-ascii?Q?ny+o1uJM3Fg/YziIfg0Ov7h6tsB926s+V9qeAHc4vefRuURfzIjd/hWJfzTd?=
 =?us-ascii?Q?nGAngmqCOvAunXek6q9hu1iUvjSXWmH6uCk0PYZccEO9sY/pf/DJ+YOBhIAb?=
 =?us-ascii?Q?1uyXmlS2eahJp8YuX6AmHugLq15Ep5WDcSBbS8PjYjKPjqc0aFtRiaUzd0n+?=
 =?us-ascii?Q?zL02RRgP6t0mASjgXdQJsJ/g0CygOIkJsS8D2HlGejLENm+3gvfohk5MGVsI?=
 =?us-ascii?Q?I0vGP5e0fzAU6qV06tJiGtgCuRyOh2fRnHwEqFTvwng3aBn1t5LNIRpXDSLm?=
 =?us-ascii?Q?UuA3NoT6y9cpB/yOf4/3Cmh3F84CK3D0PJXtizWdX2HOFIY7lXGoZn9ovJAD?=
 =?us-ascii?Q?ak/IrqX0tZJY1Wi8rjyEpS/ZRcvFvNET13LfmQqK1eL87mdtEk9a0kCiOkOy?=
 =?us-ascii?Q?/eEixBeBVa6ZMbOK5Qs1kDYNp1kaj4XMD2XB0iPOooNuv/2kRrtxzhMUsOrz?=
 =?us-ascii?Q?sij6Ex9F0d/qF+nWA9njfs+XaaitZ3YcWrqRgkt0HUUeVLONDspn9c6xgUzv?=
 =?us-ascii?Q?vSKVgJ4Fsh/ik+ghLfG81+coAsYS0heKX83MdvvX0+YRlYvoAtcaF7Qosywm?=
 =?us-ascii?Q?gmQvFPGCxwioBpozqqtcthnnwvpkowU5t1pPFkkBhchXSTQPsX9o/8EWpsre?=
 =?us-ascii?Q?sKkbB/7ar1iQNUAOHjC07N0g+0Stf5Dst5JkT+jKOhi/vRNm6RtOT28F0B2D?=
 =?us-ascii?Q?7Vk3UsboxG400d8wX/n/zmkvH+Oe67ZGjWznrfr8ekWZwfZfemccgTQkR5L7?=
 =?us-ascii?Q?7KqfreZRjjGq67AdVGRX6m4WBqrdvH25Gq0hyNmhsfs0Xw8gq+Dm3VjSIEaX?=
 =?us-ascii?Q?qP4nFQYdTdkHICQD6lK5UqI1XBhSUfSesmmqx/Bptv/hlx7ryNv3OWuhpIwX?=
 =?us-ascii?Q?HdJ/62ua7s6o34PkrA+9rdaxXBTK8pK5YQZ2OQx0?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c13d79e5-fc64-45bd-a573-08dca4a67483
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 08:16:40.5942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ap1IxansTwHLrtY03OphoTTJw7yET+JUp1Ozd+1W+i0hQbVbOSZ89t09egN4/6kx2j4/yacjrjbc53Xz/cKstA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7953
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, July 12, 2024 2:41 AM
>=20
> On Wed, Jul 10, 2024 at 08:24:16AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Friday, June 28, 2024 4:56 PM
> > >
> > > This splits the preparation works of the iommu and the Intel iommu
> driver
> > > out from the iommufd pasid attach/replace series. [1]
> > >
> > > To support domain replacement, the definition of the set_dev_pasid op
> > > needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
> > > should be extended as well to suit the new definition.
> > >
> > > pasid attach/replace is mandatory on Intel VT-d given the PASID table
> > > locates in the physical address space hence must be managed by the
> kernel,
> > > both for supporting vSVA and coming SIOV. But it's optional on
> ARM/AMD
> > > which allow configuring the PASID/CD table either in host physical
> address
> > > space or nested on top of an GPA address space. This series only exte=
nds
> > > the Intel iommu driver as the minimal requirement.
> >
> > Looks above is only within VFIO/IOMMUFD context (copied from the old
> > series). But this series is all in IOMMU and pasid attach is certainly =
not
> > optional for SVA on all platforms. this needs to be revised.
>=20
> I feel like we should explicitly block replace on AMD by checking if
> old_domain is !NULL and failing.

this is what patch06 does.

>=20
> Then the description is sort of like
>=20
> Replace is useful for iommufd/VFIO to provide perfect HW emulation in
> case the VM is expecting to be able to change a PASID on the fly. As
> AMD will only support PASID in VM's using nested translation where we
> don't use the set_dev_pasid API leave it disabled for now.
>=20

yes that's clearer.

btw I don't remember whether we have discussed the rationale behind
the different driver semantics between RID and PASID. Currently RID
replace is same as RID attach, with the driver simply blocking the old
translation from the start and then no rollback upon failure when
switching to the new domain (expecting the iommu core to recover),
while for PASID replace we expect the driver to implement the hitless
switch.

Is it because there is no need of perfect HW emulation for RID or just
to be cleaned up later?

This difference at least starts bringing some puzzle to me when
reading the related code in the intel-iommu driver.




