Return-Path: <kvm+bounces-3820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2977980821A
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 08:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C90C1C217EE
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8D91DA34;
	Thu,  7 Dec 2023 07:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YIpE5lfv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D13E10C6;
	Wed,  6 Dec 2023 23:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701934970; x=1733470970;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e28p+qTelnA8MxRY4W5MF+BWq3+QG6tQEvndgrFwFwI=;
  b=YIpE5lfvf/lEI2S/LdIsRRQjmcRLlwArmFRWUkoqoYbYpQjkQIqDvJwZ
   n56EH/OFD/WnVR6803rVl+U6211xQcEY024w60Qww9YNFXN6wktNN0uYD
   o5/IFC9Ra9gpHqHirlVfCcm7CCHrfw/zCsDDgCtJ5qPOveaSngoZHIbwT
   1jS+DXNLU+7QElTFkY6mq3df6MOCMNg6LxvjoasA0fYJFN+nHnmUn6fh6
   ccrzazKhpaJKybxmg1WZ8vWEVqKrAWmPrZCG5+zNfQx7Q8mvXny4uXj0+
   OJwGXSwfi/LpvGY6OtqL3vLuTMVHTs5bQIA/Bd163HezZxw3Y8JrRRgl3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="396981338"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="396981338"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:42:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1103116854"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1103116854"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 23:42:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 23:42:31 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 23:42:31 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 23:42:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nairz/5necYHhZXbXqlYQYkEt7pF3nqiqYWeU3z15eenrwgkSOqPXonayVg4/D3HvldGN70wholGsya7HeaMLPTO4R52fPUZdTIAj5b+H6ttwuAfyf5ArR/LIR2tHdX2GuuhCtlAxlOsOzHtk+z8lI11vdNA15aJxSolVCHPlK4Bq3gGn17hxEgoFjVOqtUO7ucp8Sak1TkgS21Fa04P7PrKuG/gKRS9ncf9P6aYkujBjKqx1LATBpmBFSbYoLBOQ9pNNfAkg0EZyZjHC82M7GKcHdpuK//8Djk30+ef6uLLaTo+WAgeWs3XXfgp7LbYWcNjP25hJopDaslXwJbxNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GG+frBSaBcWIwZCFYFIknBUnolI/USkz6F1eduTlYi0=;
 b=exk5vneuS7saIpTpPaA5/Q/jn4dqDs33ZGO+JvL2naCFayFAbyb3j+Q+ZAL5WCg1XxAN7s7RgNkBe03c74yXBn4WOJMOckzXzsZJJt8/re83F1qApZlJMi0TkREUnDug5d78HSzjQQ4edNLTmoIr6pjczlJkZsVW9pC1pRhZCPmn5oAP8LNfJN3ZihXVfGnWYfXSTQtUkdIiRNtrPRv0sGnG0dis9L1WidejAPuDDYKHCqRbPBx60h+foJS+8kiLxgwciKJUcVncgfrmr9RgpfM4xw4v5m7guzo9zKqpm28HuQhgTfMNu5JSVaLV4K2Pa9ehX5gl53H39t9luGCZ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB8261.namprd11.prod.outlook.com (2603:10b6:806:26f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 07:42:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7068.025; Thu, 7 Dec 2023
 07:42:29 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Cao, Yahui" <yahui.cao@intel.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Liu, Lingyu" <lingyu.liu@intel.com>, "Chittim,
 Madhu" <madhu.chittim@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH iwl-next v4 07/12] ice: Fix VSI id in virtual channel
 message for migration
Thread-Topic: [PATCH iwl-next v4 07/12] ice: Fix VSI id in virtual channel
 message for migration
Thread-Index: AQHaHCV6Cks/Ywuac0CVQm/ldkdBQLCdiQCw
Date: Thu, 7 Dec 2023 07:42:29 +0000
Message-ID: <BN9PR11MB527690BEA042226F61259FEE8C8BA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-8-yahui.cao@intel.com>
In-Reply-To: <20231121025111.257597-8-yahui.cao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB8261:EE_
x-ms-office365-filtering-correlation-id: e0d2eecc-a645-4fc1-fbc7-08dbf6f81080
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bPOBeKIwJYzLE6itQh971EfTs//1x5jfnF4o4zcSI7DWlokHIL1exPEF/ng68pU7N3XYEzwtoRbK/bI1TBqTEmFNvjUbxOausmdI2spX0vPPcVSXzOg7msp2iL/8ZxtsQPlAElrJPMEwWL638OTBNIP3qrgUYevA9aQynjCEw/dYgX+CsevpwJkUc9jSBa5wOb6qyJkQartSDu0G4eoTCIEuGSpRXmw0bq3SPLOHz+kcirhfswr2psJgGH+8Mwm/2DzEn7i4zyC27fZmyisu+Z9jkmhp3y0fGXoP0Zd8PODKs7np+IIuTQyUuXw7Le+gh2VY+Mnzm4YO6Q9g3MN0pIiVMsdhFigko04/H8LZKnybmdCVw7t5s8hH5cNSotQabsujH6r9vsJ96cUH8635UtM+MPa+BCmIdrcGG1Yvo/Kn6OW83REqX2Z8mBE8IpmmTLaaxSlTxLtFZnRdlraRe7CjoRNFhnkpzCTczhqbyDYWloXmvvk6lfwCNMkJ1M6KPuKu3NXCL8ybqUxRY1s5pBVxqoBlU2pSJUXrOs42hUoxbgc9cft0Ej3SD0Gd9D3FxQypZzgZbTqa7+Yt8jVb2zG0uejI8tWfNg7Puhy3m3cDjJYdWKQ9oDPm0kAn7mc/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(136003)(366004)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(15650500001)(7416002)(33656002)(2906002)(64756008)(316002)(110136005)(66556008)(54906003)(66476007)(66446008)(76116006)(66946007)(38070700009)(4326008)(8676002)(86362001)(55016003)(52536014)(8936002)(41300700001)(5660300002)(122000001)(38100700002)(82960400001)(83380400001)(478600001)(26005)(71200400001)(7696005)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6vVobZvkedmQdwiQxNtSTqo5+c2meb4mC7MSK3kp678kOfzEHjvwttBmCzNq?=
 =?us-ascii?Q?rj+hNB2YqNvQWTbzufq6hvbkjVMQk04dHfkS+Yc++MYLyeZcIRihKKVFYNGE?=
 =?us-ascii?Q?xBdGIRooYqRNM2P/iK4R6is4TCullPmXKlleUymPs7uVvqSmRFERUW/IIxir?=
 =?us-ascii?Q?pq/5R++jQ9bQwjE991JJ/FqJlvUYlXZIzxYglQMjspHlQFWtPTGYIrAYXGSz?=
 =?us-ascii?Q?t/tjiTu28M0e66mvVBxqj9ArtckPIklpjGv/Pm5nK+lkpGdG2OqeH1xuzYXF?=
 =?us-ascii?Q?OmjbfYKQsjcR+pwg+sOWJIfVMPHTBMZ0v6exQhEuj3EibjnQihn4NU5VeDBg?=
 =?us-ascii?Q?rrPsqqf8nAS+ymvVdxhZq/sXzKu5qYH3VOZUMw0ol+QDVd+05R8CNBBfelOM?=
 =?us-ascii?Q?JTpgxbYevQhJ87/ZobVnFqx+/sH7y/K3EoXFbUL/BuS03k6LFMNyHwhtgK8i?=
 =?us-ascii?Q?A1x7qwgtUPoau7mTeNpIwr3xkveA2uxVa/9BZ2ajHDhbUlWv81UYXXZ8fHfe?=
 =?us-ascii?Q?8oo2DcnQgaL9G8lSpexPm7vuZYlmD1si1whAVM0IKLCSFtIWlT5vPicFIdp/?=
 =?us-ascii?Q?HqfLr0rUUygZYz9r7ZD9xhIajmEoeME2jY9Ll7AKYJseAUkUxd3Dh8J4YizW?=
 =?us-ascii?Q?t19Zd00eHm2SBKdNN2fP4e1FID/gdc9JX23lTA2gs15W1od0RrR+qpR0gP7p?=
 =?us-ascii?Q?xL44mpSyfX/q/y/lQw7yKEJ/bY7myxPrPEMSMLxly2iVbPZnWuOz6/C8cc9h?=
 =?us-ascii?Q?D4KjzCFy/Y5WtWwu3AJ6zxIFfRFs+Ht/moM5tX9t9U1j6lYhAbLblBOG91kL?=
 =?us-ascii?Q?86de4n6S5eNE0NPkxRc3WFl3swmvGmZ+zoRJw6nsGuby08cIYkXeTahmK/f0?=
 =?us-ascii?Q?bNbY7IQpfSjTETvLdMAhgahJhowqwD/sh/3cS5R8XdR71bYViZAqkjUaTs3Q?=
 =?us-ascii?Q?et9cxOM9jmj5ThW+5hnr8ZC9geg51sIDcmQ1vZbBevO4xQ8TmctYMBKh32Az?=
 =?us-ascii?Q?42XYdiZpz338Yy/FFqIF2SyEckEGmOQFl4tWxqWaDiAXv4V6xpP/4QAMbzJ6?=
 =?us-ascii?Q?hx3kma++1s7LgdiRHZ30wOLcAfEgJJO7A163KIGbugvWyyMtgbXDKD0/eY/A?=
 =?us-ascii?Q?CcGzr08KF1Mlkip4DLvs090/rLHSzHXSGB/L8li8gn02Z7OIN9JHzUn7Elv+?=
 =?us-ascii?Q?xyhsVImMThZmRTF61HpfKmpIgMDjMVZBI1ZvQuh7M0rFpCJjS4qYsT4E7BYR?=
 =?us-ascii?Q?umTpeZAUH4vDm4NdnW/stbdLrykK4sX/prNIOLzD5RI4HaZs4WkJcu11YX9F?=
 =?us-ascii?Q?JlEShiEduV0znxnxsAUJ7URGUQmS4Scii1M2bMeEJid5OHIccAovfJwb1PKC?=
 =?us-ascii?Q?UH+Y5EPNX3qZawqWfGiWBVeLmz11KT3i71fI8/BxcNhOZweMevur3sp13mxR?=
 =?us-ascii?Q?y1L4PPzxGl28RPaBEHbnVxoi91Ku63/gaE+1MKsL/iZF2lGDlpa6gFGuKVyq?=
 =?us-ascii?Q?S5dSHc6m8dZpct1P8VMOSEgzZ2npV4kc/9hcCQ5l1hWIpV5FLk0Zp2qkzp1t?=
 =?us-ascii?Q?3aSqeOJgmjwX/EORtx5l5vgk0UEeZGaVDykzZjSf?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e0d2eecc-a645-4fc1-fbc7-08dbf6f81080
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 07:42:29.1764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JsUFgbKKe1lh9xrnb1USY4cCuMYG61WZrdN+f/W4DkTghxKxRrbVaUoQXgN9onhswFJUUoqcUtYCFIPCjkuq2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8261
X-OriginatorOrg: intel.com

> From: Cao, Yahui <yahui.cao@intel.com>
> Sent: Tuesday, November 21, 2023 10:51 AM
>
> +		/* Read the beginning two bytes of message for VSI id */
> +		u16 *vsi_id =3D (u16 *)msg;
> +
> +		/* For VM runtime stage, vsi_id in the virtual channel
> message
> +		 * should be equal to the PF logged vsi_id and vsi_id is
> +		 * replaced by VF's VSI id to guarantee that messages are
> +		 * processed successfully. If vsi_id is not equal to the PF
> +		 * logged vsi_id, then this message must be sent by malicious
> +		 * VF and no replacement is needed. Just let virtual channel
> +		 * handler to fail this message.
> +		 *
> +		 * For virtual channel replaying stage, all of the PF logged
> +		 * virtual channel messages are trusted and vsi_id is replaced
> +		 * anyway to guarantee the messages are processed
> successfully.
> +		 */
> +		if (*vsi_id =3D=3D vf->vm_vsi_num ||
> +		    test_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states))
> +			*vsi_id =3D vf->lan_vsi_num;

The second check is redundant. As long as vf->vm_vsi_num is restored
before replaying vc messages, there shouldn't be mismatch in the replay
phase.

