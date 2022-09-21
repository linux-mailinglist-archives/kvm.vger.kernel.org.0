Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFA05BF876
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 10:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiIUIAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 04:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiIUIAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 04:00:14 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB8D5FADD
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 01:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663747213; x=1695283213;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=yPxuzmZtsRZpaMkx9ypgwWyVXkJ8qNXTN90i9pBzIlQ=;
  b=T5MMUhtbb0B/qQrUCgudFcpwcC90vvwPMb0YsYstcJ5fSbwsJra2Tf/1
   9jfNJPlsFVqUIdDDkHjHnRmlYxy5XNpPWgMeKvGLOK7B8D+aFDdh7jloL
   LPwr8S9bi2T7cep0rVbAeIsn3L8JQCUTUpoQphx019kPoSfZc4FprIpVv
   jp3e/LvJNlFl939nw27m/vTSpNBb8Iti75CvXAudxZzi1rN3zLCVw/xDF
   z5EJ1bGrGtTmZHf8Nf9Dq9QEuMtPKEMeLYfPDkDt4q9orC6sFVil/9aP1
   gw0DSNlOB/d6clRWIXQEdttQ87SbZR5aGWPe/iPATWvdf5JpKE5Dpcqzd
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="280307669"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="280307669"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 01:00:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="794581116"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 21 Sep 2022 01:00:11 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 01:00:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 01:00:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 21 Sep 2022 01:00:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 21 Sep 2022 01:00:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/h4d7AdJXhhNED7OiwoH3WHsQOuWHr1jneOu+CGpd5An5dt0czn9dQvCQ1n+0eIecEAYLQPK0xp6lZKZXxL3tIez5iidtKDY6Uuh+TNWzk8ZJDQdI89FnPtZXQGL3YGDjJ0ryiJSgAab8oHnBEAf99eUqP4+NaChBNUnUE8ngSsCMZWhS1ouv/U7Rq5VlG3bhDmKvrtFMJLO9d+rh1E7tRLE87GMtYkV/QnejsH5azzB/IkK6KuP5j7c+1ZR86aekQFow3zQw1bvF8wM5iaqO8I/1ev9D8texVqHOb/PqK8fdth/Za0l3KNsp/HYxvWkjRd+02xSWWFDfx0F4Qz2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPxuzmZtsRZpaMkx9ypgwWyVXkJ8qNXTN90i9pBzIlQ=;
 b=G+H1yDvmYA3/nk+4ZOlecFMB0GofPGR9T/ZVOIR+THwt8HF+K62VyafTpabuIgAKVCqBcNLQKOuO60kWG2hZJ4faHsCKnpBvmz6TQPf+Xvbu33jU00hoay63BOprrSZ5/2sPiFlXuj3tsXaafOr04LL+i+ps5lMiSA7/4X7OaxaL1yv81aC2+8J/rqZaH9PgbGU81XTvnJRzeJtKk2k85AF4k5AfBrEqJYPtud81vv/Qkamip0qkDkMRL9TpXYD1/zvmpP3UwpcYw/aDRwFEpRtLkYmiX2GEsK73VT+I64cgZofs8/BziC43OGnuVAblOcfj0JIazUk0VuV1Q1GawQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6760.namprd11.prod.outlook.com (2603:10b6:806:25f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Wed, 21 Sep
 2022 08:00:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%6]) with mapi id 15.20.5654.016; Wed, 21 Sep 2022
 08:00:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 1/8] vfio: Add header guards and includes to
 drivers/vfio/vfio.h
Thread-Topic: [PATCH v2 1/8] vfio: Add header guards and includes to
 drivers/vfio/vfio.h
Thread-Index: AQHYzVMToTT1GAXzq0WP7wdk/8EgUa3phZDA
Date:   Wed, 21 Sep 2022 08:00:08 +0000
Message-ID: <BN9PR11MB5276D454C2E5C07F299800768C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
 <1-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <1-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6760:EE_
x-ms-office365-filtering-correlation-id: 0dfb3c45-59ad-49aa-df50-08da9ba74d8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AzRQo6JxWT21Q/L0RF1AldPrJeIhnBK3ctA4hy20RVvyPlzp2saVQP2uNAh4+M4nRJsTiKH3S8l8Oi8UYgjN7vpa9UcMsofT190XDiCpFT6H6mnjSHKdlufajwN27TAUdfWeC2R7dg0poV+9gpy4ftvIjWQlAVrUvNIfpHTeHdGoshrgdJmvEFIk5/BrBq2teC14HzssrLcArMFGthb7iZr18yY0rF6eF3yfGuHn6eGV+0fwQ/vTLYlm+shrqtayRkVbbXEK9Y/WhazPNLFOQ2eBUCUBbOCpWiFkZsUiCkr8p9azh95pjXH95h/6nwBXiP3WDZqJGH145NZALPIU3yHHaRybLKV0xv8TRk8NvzpNwmW+qEu36fYRuJvQbFLRcRuW6glQMsJOM/dIrIWJueWs6vqIMGgiSNnA/SeXFgIkz1+QV9Q8WTbNEAUEMI8kKmPsWMnruLxbSyxS354uDq8yP54Q5BqsgZ23AlHKUnoHo3cj8QDIS+m085bRxMUPazv9loHbVEcFCBX5tYMfjDFmPrnyijcJFt0v9q5tfzMK2iWwzR62+tQk/E1m1AdebcKw9wqUqPOT75/Hz2leRMmICZ/JyjKhSlAT/UAXrOB4aU8aK6lvHcVtr3hcZPQQ7a3E3ibUyyODEDej0ie7gHwywLmy57GUo3DYKjb+o+6mfLWg04p3L4zQg+H+z9fEG/J+OdsIVTVFo4BKUe5nxIQua5SGO/oXY371j0YbJbQe6NC4Bl2I2ayMbGwWfngkeKiROSSx5qaG2MJOrD2NKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199015)(8676002)(478600001)(186003)(66556008)(66946007)(71200400001)(33656002)(558084003)(76116006)(6506007)(64756008)(86362001)(7696005)(41300700001)(8936002)(26005)(66476007)(52536014)(38070700005)(66446008)(122000001)(38100700002)(110136005)(9686003)(5660300002)(82960400001)(55016003)(316002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DNDXyMPZceSUpqGP2e2gBmyWZmDCZ47hEi3+HcXkO2nKbU5m0OYnwcHTpNdM?=
 =?us-ascii?Q?uwhAb1gkXMkkpObuedirxT1/4eZkguKezDDb8op2Bc4kQiqeIaFr3LeOE0Jq?=
 =?us-ascii?Q?g1FzpNnkRUxIMt3jIJTy5MP5uNOL8szySI/sebdTM9WCQlBJegumQiPkhNaE?=
 =?us-ascii?Q?L3fWpObPWFx2r/insGN2PtdFFNhwWIu43xfw/MeVrk8BCUvvQsoXa5p48KTx?=
 =?us-ascii?Q?IqOmMWVi5DjwAGT5LlT6vqbD7u7FGGPAPY+JMkN+EPFDr8XvsuAQwvUsETVz?=
 =?us-ascii?Q?1vjW1EqltKVdSDzdX6uoS6XYSeZLNcDtA/wmoOLVNa2kOYd8lIjzH8IaG2Bs?=
 =?us-ascii?Q?BmarqsYi6e77ybBI7ak9G4+pkWu+jCiZCiB6OwXT2C0NJhhZnUylMMwQyRAE?=
 =?us-ascii?Q?Hc8irWQxEBowC/yVSSaK4KBaIoNbWYwSaoam+69sWOeMq20/fQfvizILVsUJ?=
 =?us-ascii?Q?rVDKcH0awBOGpd/g1E3hdidUWPr2rR/ez5tLwgGZ0JrO+jNrE/y8OFp3LopT?=
 =?us-ascii?Q?CSLd2BGAy45asFp8gP3hvVuoYcpCJGq6A3vRL5EvYTIhWLoQ2Si9OqIFxggD?=
 =?us-ascii?Q?P3V3+kZRFuGbhov7o6s9K7ez7zJQ0PfBLN5aqTQdK7U0DTHKqVInQLQsp1EY?=
 =?us-ascii?Q?LzAqeAl+Hw8F7Z4EIDJg5oz1xoxdagTEc879FQkszqVIm0uWq7h7G2nLIwQR?=
 =?us-ascii?Q?sjiQl2T/udjbXNrCJEKOmPLlJF6+u7v0SpoUF+EhCWUzkh8Vbf6vyrIy5WGu?=
 =?us-ascii?Q?GVt9oXglfXdbGkfLoTj/vkJGB070h96aXlIiSzu2ME5ZxBrVz/maM182uZZk?=
 =?us-ascii?Q?8UTRphZEc/7ZdrxvS0K6jFRNA2PBBGSVcr8wKRjBM9Ctxxu3f4eB5XYpMeQV?=
 =?us-ascii?Q?bq4JLNJeh1okaINPtOqojFU/OlZXqAY3pbuXr0BFkK1dB/3u8vozs4Omfu03?=
 =?us-ascii?Q?2LtD7/Psevz3ZT23uYofyTlGLQBYnePDqn6JxiyDSS25L9J0O1gVaeOpCYRX?=
 =?us-ascii?Q?pNsNCv8w3CDc9Eon7wsirg4XD5ZxQpJtnw/K3P9AeFSSYvhe4GF6SqxvwQA2?=
 =?us-ascii?Q?QZF3u8x0p9Yl0+ex4llgSE0gkGYOFWZhEdL4Hl6/5FD+SGeH+/kr3d2zsP6e?=
 =?us-ascii?Q?r25xtvgtSRwbMgPpo+BGmCfA6oRFhqwLijzEjfT9FblcGQuxOvKrks079k96?=
 =?us-ascii?Q?4HqNR20qMzmYIlecQu78BdZHIgMw9mBWTRZOMuMQXRvX1sbmGmF0Cv7+QF/l?=
 =?us-ascii?Q?UoFr+4Hv3wUWQIupfzKJrtJ3Ta/ASVwB+lhT0AaRF31eKPYcqVhnZOzjCDFf?=
 =?us-ascii?Q?heH0WwatJqkktNAC3/7jAIBy/gQ1Lac0DiJdyXoGZkjuc2sY5TX2qt+/o3fy?=
 =?us-ascii?Q?g+rE5nBk7LXD4P8EfFlooCSvWjSXfvebys1pEL5IXnGlL4fCIQBQRdKDm7Dl?=
 =?us-ascii?Q?ym/Q/6sPNNSf+FGtFDENN3jNTWXMs9f0ep0pRcQD7PlrQ5VATpgydy/cvQd0?=
 =?us-ascii?Q?p0leGKGlGw7Q7TmMFDT/iC2Fx+h6Q39YttFx6XkCUYoBsKFcsCHv+phvTovZ?=
 =?us-ascii?Q?aAYPVsBY9rrhsRSapSrliHc/uRJa5d79gvFs4gMC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dfb3c45-59ad-49aa-df50-08da9ba74d8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 08:00:08.8577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m8pUH84t5pH9f9FJ/X2vBtM14lCXw8kqRQxr4K5qWavF7ju8RRxk8ofP3S9QgB1QAsGLsiuMf3c9V8FbDenTjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6760
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 21, 2022 8:42 AM
>=20
> As is normal for headers.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
