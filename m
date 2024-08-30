Return-Path: <kvm+bounces-25467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F6FD96591F
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53DE51C20C4F
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5171531D7;
	Fri, 30 Aug 2024 07:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WfIMITjL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D8414EC7C;
	Fri, 30 Aug 2024 07:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725004377; cv=fail; b=phaAm4sq5+x60fk9pftqJ9UYWb/0dGAl6xbAQJaFlR32QhjwoxpoyuIe393GgPOQYtsLxwX2WEi4bIPDOTFBfLAj/z/bk9pR08Ebi+XbzIKXCcKQZ0RsyzvHS0KsCuiNySWQKf+7sOiGv+L8LbM0PZ3DXg2pMHJQQeEtoEj3K1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725004377; c=relaxed/simple;
	bh=DD6a+Ffg4Xz1JaQKNsRok8kUNM6maCElnc3MCG86XkI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pVNbdYeQVvHMXy2rpf+ctApowGlPJrk1RWeNgPdZg8rF2EHzoqKq9GhhaCCk/bWcVaFSnHzsY14G4UyVmRsS+VJH2AEGCs91YkvhIajr2WKu9xn1rcqopDzqo4ybLa5dIQeb3XOIzMYCVKuFKzjqIou76v26yqT2hldRqFL/XaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WfIMITjL; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725004376; x=1756540376;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DD6a+Ffg4Xz1JaQKNsRok8kUNM6maCElnc3MCG86XkI=;
  b=WfIMITjLGfMKGntL2MT8DBj1xMj/B1v0uEM5gkKcDfTqNq3k6POcl8rJ
   oFDde9MR+cCLinkobLHixy3Jtybj/a4Gnokuu+LhKigrmWfi2p83dHpe2
   9i1eo6Umti4qx9HrQWPM0P3iq8R4g3cPpm7xUcNlAqlhAXWqhgRghCPhq
   pcVCY5XTR8Gj2tJs0YMFersMPJoCSdhZqsbG/xK8On/5rjQ0gUqzUjROH
   GOQoUMiKxLD6hKZ4TwTmKw8Km/jf0AOALWREWsxSk8Nh5Wd3tAZHzgYnv
   Emj/sAUTg/mnG0bBYuoR9BeDb5rX4hDvIjkYRz1+rRLooM5mL9gk1hn41
   Q==;
X-CSE-ConnectionGUID: Kc0dJvneSNyL4J40itrcWg==
X-CSE-MsgGUID: dnut04P5SJSH1nT2BMlBSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="46145418"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="46145418"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:52:56 -0700
X-CSE-ConnectionGUID: 433UJPk0SjaYY8VL5FtjCQ==
X-CSE-MsgGUID: FefE8yyBR2C0i97ydkcS+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="87059388"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 00:52:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 00:52:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 00:52:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 00:52:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 00:52:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gxq9hDUEwrExp/m2BwjidHa7brsIKaELuyEpjqehlISIHTlV9Bf4RNh5MUoShSDqPE9e7iaDXFK49G24dFj8Faumuqd0TqIu/lohuyFWZosD2+ql5OWPKvdCsjSo9LEy8uGBHOUssc2twc4isCzS8u+C5LvDzI59DH9gROyECU7HLvtw89cfjL+KGLkF98pRvwYi3Wgv1nGlNU+TxcqgtOV+v8pA5GMWsJC6s5+qfiPn/vWscE0CrMLl8/iq7broQbpg+sbps/oYz1HUzKJm7jppgk7tG1YayMPumIboZlztWsMUoY4K7R7TKigZsPk+80HVq0cZsj7uGfsd9MDrnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CM+sQrfQuQLuLy4Hav/STndav9/A5lHhWmaaFy9rgtI=;
 b=Ub+Y+RI46+XpGpSeLStbWjltpHgiwzNBVE8ouSo5x47hR53TiTo2lxFS4ZmjpxhjZIgc7crFOAmZBJ6hbQoIAvx3Kxz0YIyFxdIU4lLquQftsxXmdrtbx4MiPDuZrEyTmrMKVgh5jepPlMFqRUUqJbicYVezMSV1MKrxJCkuqrlior+Xjojyz5zvFLR67qzvLHCq+nBN5856QlhbEyIUNb4i77myuckBkR+kdpVmMKkbeDd+WVrEV5PrMuUjyuTCYmT9ou/9ckfuZyD7z3y4l+xt1pQ2c+qsn1FtlsdO8F22/5KLS/nptD15bHk+g5n5YwKza1mKZr02YhmcxOg5dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7173.namprd11.prod.outlook.com (2603:10b6:208:41b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.29; Fri, 30 Aug
 2024 07:52:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 07:52:41 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown
	<lenb@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
	"Sudeep Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"Nicolin Chen" <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: RE: [PATCH v2 4/8] ACPI/IORT: Support CANWBS memory access flag
Thread-Topic: [PATCH v2 4/8] ACPI/IORT: Support CANWBS memory access flag
Thread-Index: AQHa+JkhqkLnJjngX0qHXNW/ip5jXLI/cGLA
Date: Fri, 30 Aug 2024 07:52:41 +0000
Message-ID: <BN9PR11MB5276313B7EE893B59FBD46F58C972@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <4-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <4-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7173:EE_
x-ms-office365-filtering-correlation-id: 72405135-b04b-4147-b64f-08dcc8c8b990
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?us-ascii?Q?l0OYDTrWzyKqeABY/sEZKVnHbJFI2+fgR4Ql0zaljk8x+5gjYy+6lgefyJHF?=
 =?us-ascii?Q?UhsEer6KRYqEJI8c7vhfmrfE5Ec65IRLCb2fLjzzdeqBLRa5hJTdFZfgVL0Y?=
 =?us-ascii?Q?01LbjoikNhnGGO2OCusIMIRFNXdSBV7Fa+PVswTuaPuyokKjTDaalT7irN8S?=
 =?us-ascii?Q?5srqCcAVX33A8nEa1RHejcRUgkGu9Ri2QMJKu6sfmZDjSFpjy0EonVe2bj6Y?=
 =?us-ascii?Q?Mauz+ZD2f0me5GR7rWZbaUBnR1dwKvpYZDiYn4V0QRCuPIVbNbd+eeZ9NWNb?=
 =?us-ascii?Q?Fe5Jrp8ctuHhSzMfQcLwqfz6TXxXibSMhhr/Zp6PlAmXfIni03b4cEzOD/zF?=
 =?us-ascii?Q?LdBYRBXB/pXhl0yks5+QGmJWVknxo20jQDIA3lHF9V8ahOL6VM/q9rngr/qa?=
 =?us-ascii?Q?Eob6ia33g8ksD+OKdie+eVR5AUjy9Cb5lELuyvjm5cp2ePnBtVutfHrrWBbo?=
 =?us-ascii?Q?qd0z+k7O2+Ms1HT+QsMlBk3KwP/JDVV0U7bw+e78Dcx/YggJ6ZUtnNFdU6vK?=
 =?us-ascii?Q?eFYC255hPG7o5hrVgniltgq8DkVJGLsvB5rNojPue93IHQU4nYDvbJJorQge?=
 =?us-ascii?Q?M2RWBKObyTBtQ204P8q1OQ6lGJppJgCgy+vKiMH3bYeaOtGfi+XwFb+e7p+U?=
 =?us-ascii?Q?JTqOdeYDfytB+hkgg3pvCsMLv/Tb6EXG1PPVepHOGS/BoLhK3t6qtffI8KOv?=
 =?us-ascii?Q?y2qIUKt5ydDbLy6h09QziXXrhtS/XDVa8/kvTwVy1kO6z6FEElHPmXW+mdtT?=
 =?us-ascii?Q?v3kp15vtSTcE/iGq7ZJ/j/FoauS9BKnrwjfZlVzxYbjnhJ6QR219nl692llQ?=
 =?us-ascii?Q?W7IliU2BIJ8VhYlDH4MAMaF3GSVnYcMZlMIwF0oRcV988YPw8R4pKkpUwheS?=
 =?us-ascii?Q?EeeOPM3varHB8LR5EmVkpRXIkZ5nuftJorUpGOJPkvFWTD5KBoz1TLqfG2nK?=
 =?us-ascii?Q?eX97q9oHjsWxIqpfBsuvgQV5FCZ+KZa61KDSdJoN76BiawKIotu4pOsmNl+g?=
 =?us-ascii?Q?5f7dh+A0KKWwISego3MnkxHmpg0b6/H36xthpEWxrsJS87LIZ4tr4ttizKMt?=
 =?us-ascii?Q?QtcvsSoDki+sGNetOB52bH5R3h7MudnryRcwY1qK7f4lNKXCUc/W+on8tqkZ?=
 =?us-ascii?Q?llqsACmdf8eHAIniggKUKb2WAlkFzlWDGzLiLYhqsvliIhQalGCd1GhGcUeW?=
 =?us-ascii?Q?W2s9onIu42ZrZq0QFi+Zpx9Y2P0usKEQMJoJtjspNA04UGHX1oTHqg3Yl+bi?=
 =?us-ascii?Q?WyQFE6EvIk99qFC8bKcuF+sKyoLNMQZmpa5U9b6exFjT9aHMNybpTtkXVe2X?=
 =?us-ascii?Q?FYrsjkNridNzTZfwSA2XxCA1QLt+8FD9FHXOwDFon+4KNhiMVEL933/SFRTM?=
 =?us-ascii?Q?kTkpmL5P9jk4aruncQM3qyTRiz/vw9QlYEqJjLq4EJHqRqYIhbPeLYPc7cHC?=
 =?us-ascii?Q?FQo36mTJG7A=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OGsfi+M9eArpk4afCmYP9fPIxh5OMue/o0+QMBaHn4n6uS5GBs81dTK0EH1S?=
 =?us-ascii?Q?RWtlCvzY7wLXO13iyrMSoJxyvq1llmSw2esK0QDhrAP6O5GtgtL8U8qJqsP7?=
 =?us-ascii?Q?saq6mS19H55+RqvTn8JQahrP6rfi5v4+qqPKFIuuIJm6oMKhfefICz3c+6Tb?=
 =?us-ascii?Q?bvmJPMD8BETFpz5reaGuqXu7pFnCWMvORJgvfC5wxYCcZGbYZc33vJvh5DxP?=
 =?us-ascii?Q?8loS6w0bCWeexoCza9g6Z6Sw+BEea+tdzPdSE+gZFoHbQPqB851ZBo28RxXh?=
 =?us-ascii?Q?5Wuk5PfOCtt8pFt/BZPNoo8kLuxqq51u0Al0OkYluudm7Vjosq6kdlVJRYqJ?=
 =?us-ascii?Q?YuCsEpTm11NNxq5AcAfrBfsBKoJFiozS2Bm/T+slnkn172VOmc3SaKJFedig?=
 =?us-ascii?Q?gz8H7qSkJ5UEIucZca9cWsZKN2OkbleS0ndQUtGPR/o290+o8RDjypNyOapJ?=
 =?us-ascii?Q?FZ8P4BiPxs+xTQ4glzzDNWITZ2iILlgiQXb5ovO6ECL+YwOwFRv67ox7r19n?=
 =?us-ascii?Q?WacIOIE3rpzTONmWOe4OTiqQQech8dOU+OKtg6TiyB+iUr4O1rzLdHSKgf7R?=
 =?us-ascii?Q?DlnZQgUliy9SWbBU5DagMxIT9VYyG3ATLnn5nNTHzlzEdmI5Oa4OBlyb9R3U?=
 =?us-ascii?Q?H5OPeGyLmOx/imJU3ql46al4TKmz2JcEeqUY0FNPz3jShIHZYIGjDjSJerc4?=
 =?us-ascii?Q?/SNhlrDuE4gxnYf0f3RLxB6pS8YyqSl1mjF0cy1iwDxJNfizZP5PK4Id50x/?=
 =?us-ascii?Q?SyRThCv9a9VuoWf0Q+U3EaULjgrI0ACww508thPD5fQQ8sxxN6BKEtIv0TPp?=
 =?us-ascii?Q?oNW25tEAWFJCyJWLjV05nOBfi8l4kFgTGQa5JIxRNMXQCcyXu3zWxzMZaAfb?=
 =?us-ascii?Q?vCnAXH6x8IDRk5mg7/epFBFmKNGiBAZqcTwxtxEWgh9r/uT654A3JLgCrtpm?=
 =?us-ascii?Q?PqJSRjbUQ2ZUMQP8K8ZMHdluRJ3v+/96cblpTLl0kVC67uWuXhO94+FLCxr4?=
 =?us-ascii?Q?veq1yuqVuGp4yKTb2dbwYC7Lnm4p5C9xTs55MR7vLa/MwESujJhOtFkKIRez?=
 =?us-ascii?Q?+p+Skw7Y6R44iZu9IeTsskwY4Kas8+E+aSQuTq8SJ43HBRTvFqzMp+stb0RB?=
 =?us-ascii?Q?VOH5yUejOTvwJTYmw+DSdp/9tKlaktKE1daDEfOfcMJmGXdjLspVWOSu32ed?=
 =?us-ascii?Q?bYXi1jbieY1ESxT92i5UkHpmmnG3oVAUMuEHWvQyXJmfqw3Lzcwxqczx8/HE?=
 =?us-ascii?Q?QMDwK8D217q2qgfdmmKBk5rrh9dNWyp+2eFdz8OAgCNhS27tSNNahotJcDTt?=
 =?us-ascii?Q?MMdKGdewGxztzGSQRMUFZUfxlqQB467FMSU8txZNPs1ZfuoYFdCcVrRPIuCI?=
 =?us-ascii?Q?xJlhGHAjVDDTV834PyVTBLeE5P88YjqjuxmZ3Qm4tV0rnt+n5Oe9ELlXne0l?=
 =?us-ascii?Q?XcRjfcIHqFz55jrGnei9tY561dsKGpg0ptEBbSlPlvrs8osXT5TBBaXHG1xF?=
 =?us-ascii?Q?YVktHKE0GHRQXMYwwIgO6t+dFfmfPnmCJBz5wXJrKSdgMo0fRatm71XjHVDD?=
 =?us-ascii?Q?cUWhjGgMRWhqvng0Dp/StdpowbFMqZUIBDgJRdGA?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 72405135-b04b-4147-b64f-08dcc8c8b990
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 07:52:41.1609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5MPezseWySPKmXr7rc6L09K1t2oTu/p7pRwyLlOeFxhbmeKuAyhvmVx3BzXwhZ87sRjIccE171Nlas5tiNqIRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7173
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, August 27, 2024 11:52 PM
>=20
> From: Nicolin Chen <nicolinc@nvidia.com>
>=20
> The IORT spec, Issue E.f (April 2024), adds a new CANWBS bit to the Memor=
y
> Access Flag field in the Memory Access Properties table, mainly for a PCI
> Root Complex.
>=20
> This CANWBS defines the coherency of memory accesses to be not marked
> IOWB
> cacheable/shareable. Its value further implies the coherency impact from =
a
> pair of mismatched memory attributes (e.g. in a nested translation case):
>   0x0: Use of mismatched memory attributes for accesses made by this
>        device may lead to a loss of coherency.
>   0x1: Coherency of accesses made by this device to locations in
>        Conventional memory are ensured as follows, even if the memory
>        attributes for the accesses presented by the device or provided by
>        the SMMU are different from Inner and Outer Write-back cacheable,
>        Shareable.
>=20
> Note that the loss of coherency on a CANWBS-unsupported HW typically coul=
d
> occur to an SMMU that doesn't implement the S2FWB feature where additiona=
l
> cache flush operations would be required to prevent that from happening.
>=20
> Add a new ACPI_IORT_MF_CANWBS flag and set
> IOMMU_FWSPEC_PCI_RC_CANWBS upon
> the presence of this new flag.
>=20
> CANWBS and S2FWB are similar features, in that they both guarantee the VM
> can not violate coherency, however S2FWB can be bypassed by PCI No Snoop
> TLPs, while CANWBS cannot. Thus CANWBS meets the requirements to set
> IOMMU_CAP_ENFORCE_CACHE_COHERENCY.
>=20

I'm confused here. It is clear that we need a mechanism via which the VM
cannot bypass the cache, before Yan's series comes to relax.

But according to above description S2FWB cannot 100% guarantee it
due to PCI No Snoop. Does it suggest that we should only allow nesting
only for CANWBS, or disable/hide PCI No Snoop cap from the guest
in case of S2FWB?

