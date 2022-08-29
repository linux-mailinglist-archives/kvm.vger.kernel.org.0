Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04265A406E
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiH2An2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2An1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:43:27 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F3D101E2
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 17:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733806; x=1693269806;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=/3HTtv2TE2vFT4cUU+41GF5O+10h2Nqf8UhViuRwxRw=;
  b=iuASDYZDs3YqpfzUBBO2XLZXRPPWGXaUV9rve6EvbWgoiMmNwnzSgXVb
   xriIjXJ6ZYIX9/9FUFJb8WWkKJRmkSAgN0AXRShchbTcuHElF0e3bJuj8
   FT9o49BlbT6XWkcw8PigKKBqkSmPAkImOaSCvd6Mk+yEWQ31hzENealD9
   gZyXcFcwmneEcR0C6g35XuMBuy9lDZaAA8/7kY5BMztvoFPBrnUQDKJYt
   TFUB7GG+SywAvio8Rv6rK5QLNGF5FkEMt3iharueblTdV9HqzIphbMmx+
   cFrjbEk528IdHEFWep6oBvSlljtv14y9EuryCmIBu59SJfuHk5w1h5fk+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="274531433"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="274531433"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:43:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="611114755"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 28 Aug 2022 17:43:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:43:26 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:43:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:43:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:43:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWdTuycfzYKWsopXR7ZcOa//fHR6TAV5j0sDZj21W3UuOXJCCT6+At+/AgL0dEqVPbDA7OIelarcvgrvq70lZG/XN9FelrTlJN6wN+6jPBqRipp0NH4vaxjIJa9I9B0TsfnoTvp9K7eSO7E8fEUT6i1zC473NXkROO83TSgoJlr1d0rsTmXNYyht1lY6wCB7xEUw0t2ZHVL78KkhwxfWcLbqUX27d4GfDuJuB6gaNjPPauONH3I3n+3zolA4VyB+Yk2XsnyYSFoNaDuXMYmGSL3Edqh5ciCEaJMQ6xxytR1m/vS2uTpiqq3dBiDYiBucOO1hZy5rNgzx8FtRHjg/Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3HTtv2TE2vFT4cUU+41GF5O+10h2Nqf8UhViuRwxRw=;
 b=M+E1jVTOwsVcVT+4D0g+QxQXsn1TvEvNatRe0dNFoJceJJGkv0Hj9yj6gpSwMXsMNweP3NnytiRpxbSPBY8Qbe9lFFYPDV/1JgUMPyCOIYTQd/BxC0PpQXxCsRAD6wJrAbV1MBVGqAtWIYZ2SpOY4z5LWI9GzlhbOV2njRAKugRNiL8z5OuowRn3jZ/n18rl4hEDdmaKEKXSYGPmH6wW7umAxrBldCG1mZU31XdQ/drVEJaHVk0AYbRTqTaRji/hFdQM2s3YPXx4/UiZGFK1/SFaL9y3/RbwMeC1xVx2dvZ/tzyXn1rxdHNXl2o3FVxw1d7DPKz6hVDmPivmRwnI+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB0053.namprd11.prod.outlook.com (2603:10b6:910:77::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 00:43:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:43:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH 8/8] vfio: Split VFIO_GROUP_GET_STATUS into a function
Thread-Topic: [PATCH 8/8] vfio: Split VFIO_GROUP_GET_STATUS into a function
Thread-Index: AQHYslOIYf1+w2Jra0mchVFKxYCai63FG/YQ
Date:   Mon, 29 Aug 2022 00:43:23 +0000
Message-ID: <BN9PR11MB5276F6806763952D3DB427EF8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <8-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <8-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb200c57-f6ed-49ad-08fc-08da89577a47
x-ms-traffictypediagnostic: CY4PR11MB0053:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8g7PnNXe92YXmm1669EJMA4Uh4AEJPQM28+7fW+nL1ytS5u6ZGvdwXJmZxYAy1IHOXyrO3oB2aSHS8cmpiqcBL6/IHMUQ/CHQJGHrpafGhwXOemRHqDaU0nZhSksd/el2BK/qhlzAKYyhLtpzxYYWuZwlxOX1tikbCrsXzWYpiBgS9iLhqvjb9pGdQL9WkJ9feaYiaU7cYLRXWL+3Z0dZDuu8xz3Tm+j4g6p4UVyJSAZJfzvc0cYEMRoUg5RoLALh254btqLktytgoUOhRVBhS/MkhwCOceqPxVC5XcTJGn6Wkq49uxraxC+M2fn619eB6nN/VbEMhrVKUZfUMDwIYms0DIKUMLAjhcGT7BAmvMC5Rq52lF/8wCgpNlT/EY16P1vm3LPlbW7TFkW0/vOgFhobgakLxBuZdmLz6o/QngGLmEZl4Z5+4cF2xKycl04eQi+Pw4cCmSToUvAJiw9scFzhRonCWwZF5Z/XsUcoyHYiPU/1BcoPcGhZ8qmmM4IOdsu2aIKNnB0qCJ+s+dNaCFCoX06NwDkExbaMFgliUYBtpG4LK1HO+SdFqZvHYkIFs9HwzgzPmcm7+tW/81mE7LSC8l7a6MKQjagdNO+zZgbvmgYJjDfTTlgGAv7H4sSJ06RQheESEfzoIWytLvyZ72xKQ1XbwjItyRb9fyxKB+hz1jYiGwyPJpNDLmz/hYSPCrtG79wcIPXOICZjx2EZJR7s5hfpwDGGprMS1yn4e9Lf4diyj6VoIbS845X5uE4fnD3n3uyjqbhOxIeF61kbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(396003)(39860400002)(346002)(41300700001)(8936002)(5660300002)(122000001)(52536014)(110136005)(66446008)(316002)(38100700002)(478600001)(71200400001)(64756008)(66946007)(66476007)(66556008)(8676002)(76116006)(6506007)(186003)(33656002)(7696005)(9686003)(26005)(2906002)(38070700005)(55016003)(82960400001)(558084003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9yRid/ulxY6wjHBv6jT7/QcT9xkkkayBMH8LLYkkKDkAlN/wVICu3A5/+Vuc?=
 =?us-ascii?Q?SEGSrbh8vpu0cCpXQNB+8LxEGjfyYYeShAX8bJ7I5DWPcFhlsHABZP86HHQF?=
 =?us-ascii?Q?uNkXfVTYKqMNuGs3ZqIj8UIU8jwfwjji4o5a0MPJ+Nqs8g/o7SB//sl5a+qN?=
 =?us-ascii?Q?s/sb61aIqTNTycj+DLNfmIAytJJMLbgkuKTmswiJJ/Ni1WIqVabqaku0imbn?=
 =?us-ascii?Q?u0MIq0kV0s1vF633p8LZYKqMMs6wMxbuddqsTlpAvwISlkm6vBgyoK2RyKFP?=
 =?us-ascii?Q?ZuTQ+UQsWptim5KBY13om7ztTSpxh5WXk7s0d2IIzBXMcXznG+tXeIr4JUuq?=
 =?us-ascii?Q?d3zkCvthhJF38Afek4AyUKEg+1LFxxI2BhgKQD5ddHZEfcSOQCfPR7yJrbxP?=
 =?us-ascii?Q?8IzBaaKUU2Rz4FWfpM4Q7Q60Sbip2ogS8rVqsv7bGt5ANFFvLD3ukrg+U8ZL?=
 =?us-ascii?Q?eZRAKlVkMMvHsIcLTQgLam5MvDU6QQjUZQl+IYGFhfp+WK19geVyw6vUjjE+?=
 =?us-ascii?Q?wyeaIPUALTw5I3tE7G53mOFGyebb2d92n11gy57v6qht2cjOcYsY8b4axvfD?=
 =?us-ascii?Q?HeWLJhVHBHZ+9/sEVJmv4BXCcqjhjkCWA/KbzmW6Y/MupNdEP3S703zp6n9w?=
 =?us-ascii?Q?COR2MgKC9jR3dgDcJilyuxkS09aXyOZPUGdDVmN1/CHNEZJpdXIu3IPVVRbm?=
 =?us-ascii?Q?z0k/tq42o/d7u/3QSukydU13ga22u5SZQMak5UT/GlUh+y6S668CC/j4ynPw?=
 =?us-ascii?Q?ir/NbC5IKmx88nBskdScF/KCcM4UNMCcyoOwSvlEMj0YFHGa676MiiTbAsz6?=
 =?us-ascii?Q?N988gEv/O/mPShltGfTERgX9zjBQXY98uooXFsaUVauKrWeeSjl6Y/+V5+QH?=
 =?us-ascii?Q?kHkK2BpurfYtSog5fit6I2BXCk00wZBx4+f2F+o4KGpx3MY8a6y9x8pCYYaj?=
 =?us-ascii?Q?DhBZ1CxDhmBTzZqN2npkHKFzeUYasmsBR7J0KfERPSS1O9jBUm1/RilA57zx?=
 =?us-ascii?Q?x52VYzxZzxwzOrwj3c2T2pYLQdZHO9RM/sbHekucP/7yNzHVtNJ44aG4FWkX?=
 =?us-ascii?Q?4Cwg1j4qZRTREVlsoVzZwn926xP0mE4Rh4c2NBWmYoEOVsymhW3LEVKbVNk9?=
 =?us-ascii?Q?c6Y5GmCKPV0nbQSY0IqK497PD68NDjI/SASc74kekwwJ4nyvPQwlVJdGi7sQ?=
 =?us-ascii?Q?PAs4WXpORLOEbenmuTMtuNqtr/gAMM1SU5SzaE73cmYUP7qoYJA/gPPQAc1g?=
 =?us-ascii?Q?O0IZI0nzpL0LsARUN2kUup4JSnDj1+ZgqvrocqfP8/oDFwaOD595C3ijjmnN?=
 =?us-ascii?Q?h8OeLJEdfReGgKrS/zuweeihm0YodswlMyQxCDOLYXdST4RY+gUC6YF1+7Wq?=
 =?us-ascii?Q?80xrYLfk8QGiglNHPclnRYA0ZDGQryJalvdfNzE6THI2wvLbgadpGHK92NFk?=
 =?us-ascii?Q?wFcuzcdWlqFIFDEXNmKtCpB2cESIKclD6wx7d6xnYTjhi/BnvN+AL6Mp/PAa?=
 =?us-ascii?Q?micT5FDUkrAOKapYKViVsfaSEeMAHe7Viepwmq5UWhrjUxzssYAQYE85pk3h?=
 =?us-ascii?Q?GxCzq6Vwx+Hlc9tIfxA8K5FnW6hX63LbJULjbaI7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb200c57-f6ed-49ad-08fc-08da89577a47
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:43:23.2514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l7ubeNOM3z4+94Ssa8nmHEbTlbzgwLw7kt1uCstAByJ3o60IyIuZt72gHvcqZ0iVNaBwQ4Fn7kvSbwRhfsrxYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0053
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 18, 2022 12:07 AM
>=20
> This is the last sizable implementation in vfio_group_fops_unl_ioctl(),
> move it to a function so vfio_group_fops_unl_ioctl() is emptied out.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
