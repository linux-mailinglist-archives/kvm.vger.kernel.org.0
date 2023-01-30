Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C15680825
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 10:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbjA3JFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 04:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbjA3JFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 04:05:43 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA57829429;
        Mon, 30 Jan 2023 01:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675069542; x=1706605542;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OBNJbBVd/Imt8W/uVwT1cIU4SRTgC/hC/EgWw++FpL8=;
  b=YHYKccUbub3LfVb4CA1bgtWN1ztD4XzsRo+f/AHYWzj14GGEXCY2vJWK
   2gbaUG4uHDOQP6VhYaHkXE4QLWzJIaHjwqDKztRgnS4JrtWXjHQnycFhz
   RiAbeIfDyQI/KvQO2Nno728W0w41JG+z3T7XhS0OrBynIYydEAtjTgji/
   SRxarKOM7B0v8TpZl7issLn4AUyWwnj2UbvAVmeRDCWLKvHuWsP6Wn6bX
   HA39P7GXeqWmul0mx7Cj1bAKznAfB/0rm9J/cch1HudLdbu09ZGQEGX+o
   iTviuW7KbPd9AjJAreRdqCgFtl9Y4KVHbv7PSdLNFRsDuTG1WKbN2glgx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="326176891"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="326176891"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 01:05:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="665999942"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="665999942"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jan 2023 01:05:38 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 01:05:37 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 01:05:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 01:05:37 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 01:05:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4/njP3xQb7WZ1TICeHRaZe5OsmK1WZjLrLCmo/nnuqhDV/XYb0/9FXrdeIEcpDfWX3W6fOjpXMMKjvtu7xLay8ZnXLbycvmQ74nTA0zBtgK3QmtJz9nFQg56zX53PsVWjpYxYfFwnbOyzZFyoMeZCUXDfpjAETGHVOWN26uyB7Ca70Az76qLLk7xneQulfcKSqDO0q/NRFfF7RgyHlqvERqKMADS8VM+hQF3s5CF+T/yDasd3RNRkFQMThMqnMtt0kjs+jF4nuUM8TXodXfO2mB1Oq421INmE9UfMIiOtmv8yWHe2hChLGpWdLU3p8DF+0CZkZRGyXFc5aWOA4S7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ginebk/E+Uz4nS6LOExtvyZjhhJZCesZ0xah70KUXcc=;
 b=ULlOLHfh62R8tD4EXbr+hP+Vgg2dpFCPGwpQz4L+44fJn2GwBzryK96Wnja6ufXk3wMDcCn4mt/XzpjyuK62QctsZFpOZHKxE+w/YjRkJzBAORi05FFVRhYTEid61DAkAumJx0qqgpaI2I1oK6SlHK1mdObsF++eWCIgQpZCttf1Qr1sQF0aZjRHmDuY4L0LfZpJfquhwoA4SkeIZqrXF1VHuV0fe61437Py7IwsLdiLqD9Zj2ROMmqNQGnDXGb0SFbNBMoos9w7P/uQyXwqzT4M9CVt79DB5LGAEP35pr2U3KhZXH6s4/MT4AeTi5Ph6lu3hYlcectI//k07lgtHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 09:05:34 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 09:05:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Tomasz Duszynski <tduszynski@marvell.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     "jerinj@marvell.com" <jerinj@marvell.com>
Subject: RE: [PATCH] vfio: platform: ignore missing reset if disabled at
 module init
Thread-Topic: [PATCH] vfio: platform: ignore missing reset if disabled at
 module init
Thread-Index: AQHZMNe4jRMwBM/EwUqhr5u7XKzShK62sPAQ
Date:   Mon, 30 Jan 2023 09:05:34 +0000
Message-ID: <BN9PR11MB527630B903EC14BC61351C668CD39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230125161115.1356233-1-tduszynski@marvell.com>
In-Reply-To: <20230125161115.1356233-1-tduszynski@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7573:EE_
x-ms-office365-filtering-correlation-id: 9e11a048-4911-4788-f0e5-08db02a1256d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dibk/WoPqdLk4ZgxlYg3Oewdh99DwTrsC65lFOQmKRIZm6jG+6tKcJa4prxl0VLQ789DuyKg+4xXNm17iE1d9NGslykn68IonMsyX1UxfAqj4BDEw9YDnFC/mftPz7rloghJAZDpKHaZVqRJNzYWGv+bBbn1Nor98VXvEQv0MUohu6lpO5yi8ZD26Iara9c2UTscdJqYLx3/s5uOtrivFRsndznAXoMjLYMZsHQMO0nzpPZ7U8FA+D9SQ44KFPoOHg5FfxjlpNcAsJV36ov3P4a8ooTcYMjcU6+GVkA8rvOfOrXe6HEUKF/KgZ5k96Dzm//rKf7LgzY++KWP11emk0AoQ4eIBrX2w/4+3AyG/WClCq8Na772HJCONGptc7j3n+iCTKq1edCsoG2ysb5MqPQr7cRSei/ojkxnnX0v3mf7m+OZrx4mPkgj1pBRpwhflE/plvELcsDUwgdKOpTSzry1VyJYFArkOyyASrVkl7VZiXpdUmj4sNBmrMq2qpCflNfL584UHY61glCfDATapAM6WyjSf7XP0tF2V+5bWyxNSmcPR+4Lj2VZMfnCqr4aqCH8GVakQqvpYMQaTvGVtHxChdhWY11FHMDBGQFUU9kFrEqjEXA6tuL9U+AwTxjhe24sN4PVJV7Y88S8ykvU2d+uS6iSbYJ6+cBGrbQEzNL3LTmgRD4hAG+gR9Si5Qm6TuUoV9unKJ3Te9c4QyuukA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199018)(2906002)(33656002)(86362001)(26005)(186003)(9686003)(64756008)(66556008)(66476007)(66946007)(76116006)(4326008)(66446008)(71200400001)(7696005)(8676002)(316002)(38100700002)(110136005)(6506007)(478600001)(122000001)(4744005)(38070700005)(5660300002)(82960400001)(55016003)(41300700001)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AtgnvmaNq46ZENP+gWq4m0tTZkBXVXKEYH+ZqgVTxPmblar8nhsugv3fZdqf?=
 =?us-ascii?Q?A2znNkF8VG3yU0ZqaU8xOfhAyoa3/GN2jSBx+QAWrjWoyiFIQ06nfKUp36Gx?=
 =?us-ascii?Q?Fyhe2QvsAzAkzxp7VCQFmwStKbYEOiXizSZuYIQuaIcPMV9eiePwZ3cHQeKU?=
 =?us-ascii?Q?c0LB9xQUYrzVETKEt7uD2+EzUxg3KaJuaRr1gNX59UWgGxobbzqMOgCB2ASP?=
 =?us-ascii?Q?GbKRH9dPmfctjcvrElXTtYzEbGRx13I2+YyiklT/4cO3ED6DDsOT/szi5Ng8?=
 =?us-ascii?Q?vJ3YUuE1qKhOIGNF01ugDpKunj6kGVrGlFU3FD1cNx+4F/fXotU8eUZ0psWh?=
 =?us-ascii?Q?3y0nW5x9h6hGg6iPghed+F9bA7vNy2r5dCYtDR3b7jGnvVKvtcDwWHHs690B?=
 =?us-ascii?Q?bQPmtuoxZuV8B6YuZ0uvXchjeWA/OEf81BGtsE9w6SGQ75g+7GO1gnLTPgWz?=
 =?us-ascii?Q?jJwwToQ5BINxdPYSsSsAlnFkOCNIR7LZDUij61UU7GYhSh8UyYGf5L21xKyH?=
 =?us-ascii?Q?8ZmuD1MHLESgzXfkC1UFgTvMpaM+ozXYua6CdWsaQvQ83fpgUzssKnsl95sr?=
 =?us-ascii?Q?w5Z8IR61w8nz5d3U3cSvPveHOU+BcD8gtR5S0saPGtzpuULaXQ+zXuMr+W/w?=
 =?us-ascii?Q?6okHos8PCCvu9vaes6sveR8WlMjLjqC69LLJ+mCwVBfiZdYJGKbnc2ve7+P2?=
 =?us-ascii?Q?qKvAG/cWSFatNaR3IYGJC5t5UWCrNUZzsT17TQ2d1pXgw55L+FY+MCQkb4dr?=
 =?us-ascii?Q?Sv08hDgZLy+8oQiImKA+IK8Cfc8kfTtFM8R9IcXnvjWVx4C3Eo3lLTSdlShU?=
 =?us-ascii?Q?5S9D2ptV9syhF6VAqG5QCdp2L+eQxu4EA9k9SsBFINhJhM4KV2E5tGG1eL8t?=
 =?us-ascii?Q?j/72lIJfKAblvZIIR+gw2L6xRRxpbKt8Qqy0y3p8reyMLHtyj5iVnlvd1cqY?=
 =?us-ascii?Q?bvtut3OTMqnqn2EmkFtaDa0uuuvv8uxbs+kyq4AA0x8fOsZOuYaCDb5UuNwC?=
 =?us-ascii?Q?aHXF3tiGWOb1QnV3Wc3gDl9Go8MDrl+d6+k4S5tCyrJ5807ZQr+imIHKayGz?=
 =?us-ascii?Q?JzG/Bvh7jku2e3sTYCDk0LMWx5ZGGxpTQiMPww3VvoJA8sZY07dbZUHspX1F?=
 =?us-ascii?Q?He+Pir9KMYsMQZzWr3TzDvPbZBubhUM7QufqQuKp/kGFz760Vl1gG7C3vyhl?=
 =?us-ascii?Q?p7Mfqg/SfLrzp8XZAEi9ZjRowe4oL9BlZF8d0QafkomgtPxPE6WuMNta/g8W?=
 =?us-ascii?Q?e2QDSV2gY8KzLVrbX/Je/KUN31TRTvMvmKOiPWlrl3A0ALNbgc9Wsek8lqsQ?=
 =?us-ascii?Q?fI2U9LhcSJkT8D/xbSGaPxRCVV8Ljc4k7pPdoeaDc3ZvJsPd7oZ3Do1o6ROj?=
 =?us-ascii?Q?4yybOKRIYuRa0oB0exSNlN2MGw1J/1Yv/uhP9mWEK21HTGMEOjHSdJHsoA2M?=
 =?us-ascii?Q?E98iGRYFG7gcBYuL6tXBQqWJTVuG7MeEfeesgrJtO+K6N3vrDDbNDFHPie+x?=
 =?us-ascii?Q?t/eUYJ8BWvhXm4iW4XXtwvlhqCoOUf5xWvRB2CMLzak/KGKOZs3iMj+4tQ6B?=
 =?us-ascii?Q?6EEtQjFiZTKmaui5LvbyUshKB4hlTljCgAqZZRYX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e11a048-4911-4788-f0e5-08db02a1256d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 09:05:34.3540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 204MUcsZsWNRBQ+lT9fJSrXK+ftwZzqslllE6okv6jrxjMt60O8Es7+5PooSh1geUDwN8l+QU//+72exNzBbQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7573
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tomasz Duszynski <tduszynski@marvell.com>
> Sent: Thursday, January 26, 2023 12:11 AM
> @@ -653,7 +653,8 @@ int vfio_platform_init_common(struct
> vfio_platform_device *vdev)
>  	if (ret && vdev->reset_required)
>  		dev_err(dev, "No reset function found for device %s\n",
>  			vdev->name);
> -	return ret;
> +
> +	return vdev->reset_required ? ret : 0;
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_init_common);

It reads slightly better to me as below:

	if (ret & vdev->reset_required) {
		dev_err(...);
		return ret;
	}

	return 0;
