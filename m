Return-Path: <kvm+bounces-7973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4392B84951C
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 09:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADDEE1F24F4E
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 08:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6E911C89;
	Mon,  5 Feb 2024 08:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ievj7Yqr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57C411715
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 08:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707120617; cv=fail; b=WKLeuxLu6kUJ46fFSV0kxfCBfTB1ViMQShOH7ZR7w5J4r35ckhSGtSnIsqeLNcGwFAxrigwFW4P8yaUxpfyesaAG3znnjPRey0KjSoB2J++A73XvRMZZpuG9yRtCyKfXKTzvZfOU9HDGftyXfk58bVDy40L0svhRoMj9YnSmBh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707120617; c=relaxed/simple;
	bh=GsJslXMaLbKwWq9YhO/LY6yrpyue3EfxTO7fl9ISOCo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fzv0NcWtpCg11YpBMBzolPS5j3nq5Om/Dyeq2LlgJnjYJ5LtZec+T6Rjib/d4Jox2xghMB5BaHwbbtziLUcrZAq4WosxUUM37cDypGD4xBG/W12a/znU6LI84kJL4CbmsKz3NG/dJvBlqr/w78p6jgcqgj8OftS5y/spCD3y5Gg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ievj7Yqr; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707120615; x=1738656615;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GsJslXMaLbKwWq9YhO/LY6yrpyue3EfxTO7fl9ISOCo=;
  b=Ievj7YqrRXk8/N9sj4w/LG7wpgWSo7aooljYgrriHpyOkPVQESPIiBqd
   ZYgX2F2C75rlF9cjIqEFu3yhp0nW91nyEZZEGG8Tu57k93Mi62Qb2cdOf
   qM5agxrq3xAU2G9MV+9qKJeTBNF4Z16bf3u+BRcYnQaOrMUci89lI85/K
   04bIK1YO5M4oyH8lkxZSslEUQ2z0MpynTpctqBqaisr6GQGnKvRU/1E6p
   LfOtvLX9u+iouoENsv3rjLW/ps54cBiTP+wTrzrwPdIrLjLForpWzYXBf
   V8qVP/XX10d5Jl8s6EYewy7UKt/C9PYu397evvW2yqwQ9wmfUa1JTHG1k
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="725897"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="725897"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 00:10:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="5281170"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Feb 2024 00:10:13 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 00:10:13 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 00:10:12 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 5 Feb 2024 00:10:12 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 5 Feb 2024 00:10:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWevk1WaDg1REDXdBGfVsloRqwDABvak6vbP4uhtWMUtch+42JonIbfzIvj2OmqeCMdgUVgJ/jO8LopH7aaDgPl5SEDmfKFrkbzdGmjYatWPQksN44XtP/wsix+S4JuruRBC0BgSvfDrnlHC+6knXzoEbRU8J1RTka4vz3tb2LjvZZt3PZcVQ25ScD17B4xwDywhQx+w7MZrZ8htZKo2cx5xxU/USwEZ83VGftIkopmnzkZzgQPzO0MxokxjIZ31/4IEvM4n5gDifb6Xkuh+4OX43wMWAIu7ZFT0Dp962kayORXcrkNYhbYOCtKuC8YcahOo6Kf6Rs6Fb7W7aNTgTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y1hxwSuGbqNa7eN9YCjFpJ7sdPP3YwAOHjO4Mn2FzqI=;
 b=IkIrloCWSYYjM47a6ua41FMW/cvzLSk2id0yIuK1PaIU/qhoLOwyLCNP57bf0Ck0AITtWr/DY9N0A+BbGvrw7LxWCiv5rRjdLUUKrTQHV7aDYTjeyoqPt2SkOnB+Ro0+f/qI14+V1D+vrPaRckG52Ti/fTnq3YbhGHh+2aEOAqgYvdBJWFMVSdjc9rxAwaKEDExQ+1himmtHPzFKAryTO0OV0ULsTZNI3FuwDx0a+OgbKgEMrWfL0TPgXGDxORPHaiE8/RQPBQb5JzNSK6/8uqAtPIUBBZZBy3CHuwRv1rzG6OLb0D60RYGXrC0Ztp/ozZ9121csW+JEuUbi6XLltQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5461.namprd11.prod.outlook.com (2603:10b6:208:30b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 08:10:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 08:10:10 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>
Subject: RE: [PATCH vfio 2/5] vfio/mlx5: Add support for tracker object events
Thread-Topic: [PATCH vfio 2/5] vfio/mlx5: Add support for tracker object
 events
Thread-Index: AQHaU55VErLgbW2DsEuQXOOLlNC0xrD7a26A
Date: Mon, 5 Feb 2024 08:10:10 +0000
Message-ID: <BN9PR11MB5276D9B9CA3E4F69D183D94A8C472@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240130170227.153464-1-yishaih@nvidia.com>
 <20240130170227.153464-3-yishaih@nvidia.com>
In-Reply-To: <20240130170227.153464-3-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5461:EE_
x-ms-office365-filtering-correlation-id: a0e468b1-3efc-46f3-1c57-08dc2621dfa9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eVzIzYUi4RchDTxrfpdayqDlvOlEppVngB0yOjdGg5eR2ijgUSA+qc2H8WZ/mwkFENkxpuOWserFhgTVfOquDyfQ+do0+v/l/x8MmmPLsJAC4kBYcVc24/jTo0LxXbKX3GXWhfIMsYXGo18pmHAzTRy8yAMhqv9O9ovS/lxoKgu7f+qwBqRfFcS2rksdUxMvJ06XuMa8Uv5ulfP1KDk/nVsa3Km+p4H+ZbHfxdu+1tVtnN/oCBoc61tEYiUF+VReQ+2hFlZpFY+1PXY5TNb9BZDsMhWDEVFg2oh1LhiOue9VJFitW9YIgt6UM9Q/4GjGf94HVguP5yJ37BapQsUqyX81w+DNv66AoxL2Tp/1atOAvaU866eGQo+tTWS0ZNhq2OD48hACYJcuD9vB5wFBRzALPFGSWkx2n8gKH/aLXQrsQx19MwE3xEa8/nMZj9Sb3OIh+JhgPL3NnS/x605hCAbd1ZJ5eR59mi6TGyiKUd0dMcFHpgi8J+HigYMQhLJQzw7TPNctF6BZwYAJYfpghyzo+ba8+a1P/+leDp8Y8sq3j0IpVnzF9eFMdhWA4t+v90pg0S0Hfcrg1vkri6XZGkt0vF7DYiAnxVJJDxyUfZ7JaAFFFV5yu6HyHKFagVyM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(376002)(136003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(86362001)(55016003)(33656002)(82960400001)(122000001)(38100700002)(41300700001)(26005)(66946007)(76116006)(4326008)(8676002)(8936002)(38070700009)(478600001)(2906002)(5660300002)(52536014)(66446008)(64756008)(66556008)(66476007)(316002)(54906003)(110136005)(7696005)(9686003)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?69A4SGEqwNJk2RzhbvcgEDICAEJNsyDJc4MCBIXYG9/xjsTDYRC6xZandNf2?=
 =?us-ascii?Q?do1sYX9YeVeM1guP4qO4vt02VxS/Xh2LI7hv6qO1eMBI3mmlmiQ9buJXHnG+?=
 =?us-ascii?Q?K/j1wqTFUO/7JEPA6WkAYQVizyWLdHqraOZ/WPcRDRA77fnJxiTqukoJl7jn?=
 =?us-ascii?Q?HgYG0jfQxmArEBUu0w3zhwsyADh9RgQ3SIVELwQtOWB5Wv6yp0ol/Y7IFSqL?=
 =?us-ascii?Q?bqMv/+tO00ZuyvkansK0HIWC6fBAW4zglhcuVLFBs2p+hC/F5hH7k3InXJGg?=
 =?us-ascii?Q?Ol+Iz1wZLibTVKisGs7rMRybyX0zRHeIJSmOSstOMD4jllbBzX2ox4ORWz5W?=
 =?us-ascii?Q?d5FGI2RsgmbDC+SBGKWzx1aWT7duQ9jzbcc3aXuskwCaje6iPxQka7xFOVzP?=
 =?us-ascii?Q?2qyCQYk5zEMUSP9fGI9Tfs0amaezcr2uMixP7A/nJTK9vNi/kbPnzJDBq8gb?=
 =?us-ascii?Q?yzus2cZnN5nnnZMqQ70KL8n47TYiSr4YR1CG+BtY3wZCDSfQ3GTq4/TGqAD2?=
 =?us-ascii?Q?UnM3qTZ5MB93L+MIGPgh3vjxrHwb7I40CN97pFeKegSaxqwr4sAM1dK8RMGi?=
 =?us-ascii?Q?f/E1bXM5/sse3+cy6NPsJiKQvnkua/Sp4w0gxhQGp1w9xNqCDN7PVMT72fZ4?=
 =?us-ascii?Q?y48WqVxC1MVXeSOmzeHa+Oo346HCA/tpCrI+Ofi8daykSEE9qZpCdj//7AFG?=
 =?us-ascii?Q?XE74fdgQZd4PW4/bpjRX98Y8SiJA1GFTkN6KKEK1802zpjdBxAa/K0tMz7JE?=
 =?us-ascii?Q?TJJgfdHIt7DzQilc7Khdq4CyX5b8f2zWMuzyVlfZYLkevmrU4tO6aWksQgQ6?=
 =?us-ascii?Q?PVTn+T2rZWNIdt5lMxnA/75xDdJFwSJosDAckZcAMBBz0yYYULiL5iLJSUWM?=
 =?us-ascii?Q?cX8OEE9WV5A+zVP/L9q+IIHkDH6hONsRLh/+4UK/YmB98pwhgzfAlrQsXrqQ?=
 =?us-ascii?Q?3ASNmS3IBodq7V4/Kw5IHszT0dyNSubEljoj4YjDlrMJliE+ShA9NOcuyEi0?=
 =?us-ascii?Q?ECm2uXwrwFHhG1Fa2UEoD35dFLfgCH1LJcmsEg0nO25WY2eQwNcorGKlpsjr?=
 =?us-ascii?Q?CnjUhjCJrp80Uv7qY5pKOhESpDKDaeCOfgGKL0k6vmtyIRiM4wmU3BaKKCXh?=
 =?us-ascii?Q?7t7Qs+l8QcBw2hLcILbxt2oQYMdr5SY4Z8ZirGDCReVKI9EziCjALal4Ysk8?=
 =?us-ascii?Q?ommEoLdRQl5QfRtrO36ulHda+6sdvryLC1ngeOhmIRd/ln4C6DCjnBeqFlCg?=
 =?us-ascii?Q?URJTpuH7XOI404BM5KxFVTW/FclOIWI7Nuf9S+hPg7Qdfwo9j8iYYzRFYRgs?=
 =?us-ascii?Q?IGWQdwwukhJq5dvTYjRgFaGD6+mYe15wDyQtVGaKZszep4v6cViVqp+b6hJ6?=
 =?us-ascii?Q?q6mVpCSAv9RVYS94HUKEdQVf7WmeHHZoh83WEP0W9r3u6tJL9WpKyrvbcX1j?=
 =?us-ascii?Q?FIfYUWmZgh90tt9YFHSFQ6ziks/yFrcTyev42XHHhJOoC6Be7Z6SMvPXOvJk?=
 =?us-ascii?Q?ORcA5jjJokrsOzLmBDHk7Btt/Y05J5sT9LnDywNIkcGHCYvTlDEpuydVS95A?=
 =?us-ascii?Q?KCcCuSRT1XH2CBRgmLKd65vEWXUCyFQf9r2j89Gm?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e468b1-3efc-46f3-1c57-08dc2621dfa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2024 08:10:10.7635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YXkIjET5Fr3kuIsQCpkMIyL9FvwiitGa7bYRcNajViyx9VH2PD1sxPrxlXiW8PzTGPBkFAdCIP2+bU042rhJQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5461
X-OriginatorOrg: intel.com

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Wednesday, January 31, 2024 1:02 AM
>=20
> +static void set_tracker_event(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	mvdev->tracker.event_occur =3D true;
> +	complete(&mvdev->tracker_comp);

it's slightly clearer to call it 'object_changed'.

> @@ -1634,6 +1671,11 @@ int mlx5vf_tracker_read_and_clear(struct
> vfio_device *vdev, unsigned long iova,
>  		goto end;
>  	}
>=20
> +	if (tracker->is_err) {
> +		err =3D -EIO;
> +		goto end;
> +	}
> +

this sounds like a separate improvement? i.e. if the tracker is already
in an error state then exit early. if yes better put it in a separate patch=
.

> @@ -1652,6 +1694,12 @@ int mlx5vf_tracker_read_and_clear(struct
> vfio_device *vdev, unsigned long iova,
>  						      dirty, &tracker->status);
>  			if (poll_err =3D=3D CQ_EMPTY) {
>  				wait_for_completion(&mvdev-
> >tracker_comp);
> +				if (tracker->event_occur) {
> +					tracker->event_occur =3D false;
> +					err =3D
> mlx5vf_cmd_query_tracker(mdev, tracker);
> +					if (err)
> +						goto end;
> +				}

this implies that the error notified by tracker event cannot be queried
by mlx5vf_cq_poll_one() otherwise the next iteration will get the error
state anyway. possibly add a comment to clarify.

and why not setting state->is_err too?

