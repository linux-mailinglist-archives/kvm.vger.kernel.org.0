Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595C45A4062
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiH2Agx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2Agv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:36:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D30130F4F
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 17:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733411; x=1693269411;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=DJYTaFxiEgebhx3IQDJm7jRdS2+rNbXmSoCqsaawiEU=;
  b=fix4nq1cq/lSphUD6ZdHBjHyO0iKAWWNM54JQgnRPG8nYXocEveiqBQN
   UCJ91ADRCaFnmbHiQI7avlPX7GD480jR24ARGnqGMD9jkHRcMrCpWLoGg
   1Jk/loVzQj6oTo7zSlH4hf3s9H3b2RJXAkFNBWHPZVqTPHdtO7QJL8Lep
   IU57/tsaJtL/E5/VbT7X3NO6fbOD+QXv0KEVDc/T3wq3W8Hb6jfjKrKK8
   kKiOaTwLBl9FcrW3/27P62c0rTstOSoLLj+bgscIMZt5zs2ZdUH5GE6t2
   eJMaDOdAw5asbzbMFnGr67zn7aibjlrgLMH8eg5WI8adqHOfMPa73P+Pp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="358746291"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="358746291"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:36:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="714669399"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2022 17:36:47 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:36:46 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:36:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:36:46 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:36:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZO63R55+vg0k+sfzS+UgH4y6+qVfCoU0RgfK14eBCQeew4rQj+vp22+de6/WcUlTVjlRziAAlPOPgRVcRfgnUMH+UtEWK3LHY/1vKcbOg9OGXcp70hmlhF1Wx2JYzrEsksELfhgxnUEPNuAxCd1TE4j3wnZK1JQCYxusRJgMZ4cSG8UVJRtfFcIWvbEF4SnTQ7Mqrg0F5kvgWNl48c5DI4SxTK8XP2ZV4Bak7zmt7qC1DyfTyPiynJL5+Hte2ptuV7Ezhz2XmNTEZ4jPkOlJ+DEtCd1z2igmdnoNwcOCOvFYSj6sJGPNryT4oa1KiKud9dfDCKyolKVdWMrrOeCXAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJYTaFxiEgebhx3IQDJm7jRdS2+rNbXmSoCqsaawiEU=;
 b=gqhmCXr6+yGyIWFMkDHvPDVzbn2+z4x5AQEB/qgRbOW59UdIWNcjiRX9F1r43BftSq+59OzY+A77q5SYRZ5JRwbWV2Me205Rk6NxlkSF6yJ9f2azfksLqN+43nhDrizyBGFQn4KE0ZHfGyl1OwmhPT3+WS7efZY+QOxJNRM++IwNxJGKduQ2aHuYVXyYPXvp9fts2Exco6vhv3uHsrAtTzf3JnFnC21jeqa2/0oKXtznm5xT2Z5y+bRNEFuej8L1Lt8oEirAOa4qnCM7P4DRzB+cVLC5ksW5KheLJLAUUrTI705an0Nqu7TjG81x5aOt+iuxOYIEViwqDU03sUy7Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB3968.namprd11.prod.outlook.com (2603:10b6:208:151::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 00:36:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:36:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH 5/8] vfio: Fold VFIO_GROUP_GET_DEVICE_FD into
 vfio_group_get_device_fd()
Thread-Topic: [PATCH 5/8] vfio: Fold VFIO_GROUP_GET_DEVICE_FD into
 vfio_group_get_device_fd()
Thread-Index: AQHYslOji/tOlFhdIEmH9eguJfUqd63FGdZw
Date:   Mon, 29 Aug 2022 00:36:44 +0000
Message-ID: <BN9PR11MB5276BEFD3546A57DCE137EF28C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <5-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <5-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a616f0cb-e9e0-4613-305f-08da89568ca5
x-ms-traffictypediagnostic: MN2PR11MB3968:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vQFMui58grtBfm4zv9EJ7Nm8iwQXlcTLhDLwRlAoVjjUE0vPZ2LMHW9EfBxOnJD3YKkZyLqX6i4SGbU5t9IfaSJ0Lxbk6Cge6M8G0WaU4E13pY/hLriwUaJNOKXgw2YFRRMnIr9gHgTiTelFSzjj76XLBh4tifOWFjKZU9KJumaEc5zI5MJ7b+KvbxLOSOeg9W6KK9iQdsxVQr+c4bXRATkZQ5Yhq3+41BiD2500DY0hb0VG29tTBiMbS14ZG2DT+AcUYrg7xQBh3LRuSBQPbzFnUr/8VzMUXzoQdky1gYEkK28kgoE+/Ts9/Y9jvnsPXlukdod5UBP/DHKLwPkVkj1jWkJ0+UoPFFWs+oTlIMlOArXZNfTVKMddETW85gkGB/5G7PEXEs9g7CFvCqhyQKkF2NokyO47UHvHYqDYzy5ZcPtvLkKetzAbs1GRRNcpAknrdR1IqPARU070/uP3tvmu/r3yYl8s68sud4nc9iXcOp+SLB3+PxdONQU91HQqyXEgVwAFC4W9aOjLWrPb9nY2c7CgPR8bn2FCfFMYMaYE/pozw0gmqVXC3bms4kf5zJHvG2arPnSnp+Ts0VqGzcPQA7J0HfhWNabM8k+5aTsnd+sndm1ht/ib8xs5WHs8XLngLhqMaieEezIWcrF0ojD23nezA9iySTv/ruplVdU9CpOc3P31KQI4wmedSoGQEwSYAqZd6N4xnG7sn4ag+wm/WUPb8RNmKtaoLcFgGsS5hLkiORPyvJId+JxxDmVEtxiEKA0+CyMzCv47jMtpHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(376002)(136003)(39860400002)(7696005)(9686003)(82960400001)(86362001)(38070700005)(6506007)(26005)(33656002)(558084003)(122000001)(186003)(478600001)(41300700001)(71200400001)(55016003)(66446008)(8676002)(66476007)(64756008)(316002)(110136005)(76116006)(66556008)(52536014)(66946007)(5660300002)(8936002)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fz9tPuc08Xjek2EideGa1+61QxJfqZq/lGpJKS35QYpSL+yGlksG6jCRe7Y2?=
 =?us-ascii?Q?y8Bh8vNjw8wtvyerNMgjp7cYaDfQLeDRqi4A8CtcSaaTf9Jx/7isICcc6jiq?=
 =?us-ascii?Q?GPrIsixHdFSQ18WKaKaL+H54xK8dr0z5mNx2whZciRo6IaWu50+zyp8TjrHn?=
 =?us-ascii?Q?d9Ps2Ape01qv7QeRw129wEw3QjOy5uPm6jvkkf+KIS6YANlGzHxGKfNzr+Nq?=
 =?us-ascii?Q?IJ9LH+WZZpnh9VYLUTrKQ6dcEwbBfusAY+YaGOLoR4q5a3WIGs/ctpkUZb6b?=
 =?us-ascii?Q?srr5ZbYMG6CFG352rO5blt5pV4TU1S1XW/jSuB3LaU17QitfgDubDl+C1oPl?=
 =?us-ascii?Q?otTvRO1JltVSf52kqgGUZI6YTdxdWDY6Q0u0kcQB6uUNMOCR85Tk2t1wlTN9?=
 =?us-ascii?Q?c2QWduzgGRowrd2jhHowJ5/b2L7YfuASqRs9m3WXpoqexMd7EdZdT7DEbl89?=
 =?us-ascii?Q?e+TUF+XJlW/DGKy1VSNb+yIGQ4HZoJUZwHhw4uNdlrnTEH9Xat65Hb0JiW7r?=
 =?us-ascii?Q?9s45XqJ9nlLNelZv8rY+3/1yhnOc+ahY4GNgk7xJCp96TqdoWSbe7HJ4EI5p?=
 =?us-ascii?Q?odi/bdFC1zS0FqFiydY6g+APMrPYUbPR0FvlJItFRUBRyJkt21PqtyeDy/Z+?=
 =?us-ascii?Q?g7NDutQENR+dNhMlSZM+iZi5sSsKfIwE1W6zL1PJAx6fZF7wnHgr8exJI2Li?=
 =?us-ascii?Q?07tuk6YztZVnFdYMAi/RjeTok1Q0bjhQRHYuiSIbdeEes9rBE/wsJOuDoRkQ?=
 =?us-ascii?Q?uvINa3Q19lqzPmvfb1GYOUKlVXsAqBMS2o9cpw8L/OlTdHCCphMh9EL9xEo1?=
 =?us-ascii?Q?4qqGZZ0JglrzXK8AlXOOWAMsJpb1FY30dRbk3YQhZQXClCDPNg5zCirkb6MH?=
 =?us-ascii?Q?Z8wQzl2s67t1xXjmRWQeWwGPnnUqivUFxRVsqrEULo5Q4tabnE1lcPDztyYA?=
 =?us-ascii?Q?0/5JrEpdimaQOw228+kMRhhL2VY9gOO8lne1prA7ppOOuVv8QmIYFH/R5zGl?=
 =?us-ascii?Q?PxijZrWkCTOKSbcZFb1DnCNVxRArNHuWETcSq6S87iVlDOmzDhbAe1BRlhUC?=
 =?us-ascii?Q?iACvPd7mejc3x3cN7DTVNWIakYRXpEZPHWqSqAeEZSZOSET71BPZ/jP35G21?=
 =?us-ascii?Q?TlJjToZnqg1erjSq/hgPBDVLvvkkoeoJOd3asCA82vAzPelsVkMNThyzcBDG?=
 =?us-ascii?Q?yhD9m4aPKkaspb70i5OT0Rt0RgYawb9qWaq/xSbWItAOanRlnvMOGI/zH8rp?=
 =?us-ascii?Q?DKastK4+EPexJor0uZvlh64E1qOd8Y74B4ElMnp3OA/4lBsyaLu5e86zJFwF?=
 =?us-ascii?Q?pldnF7c9YiJfS0wZ0e8p+JolMbko2A5R1E5rmlyUNqMu7LRScCdtROjjPRVD?=
 =?us-ascii?Q?c4By7oMEbw6xwmM5A6NVaZ1SopjcIViwQnLIVhL6+O0pnHPaSSyfTDyWSyqs?=
 =?us-ascii?Q?4GmYAPAGsurQSKk6wmiBfl1rTj7piTfgv9qAGxWxTHOwNvGTSQjDKpTRz0RT?=
 =?us-ascii?Q?HRumqYFjcIlj9YxgFYrGz906q5oLdJX6TvKo+tqMdjFuDhXMkbuOcjTDbbHN?=
 =?us-ascii?Q?AGj31+/KX5elLqrUP1G87DgdmJm46jmD7xcbefYK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a616f0cb-e9e0-4613-305f-08da89568ca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:36:44.5550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 27qjTvyXKguGLz/GiFMoMhrjaCWHdGgQ6uKmJt8tCeLXjwGH+oHJ3vCweFZfSh4pPGw42GVOEgblrMJrmlOKqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3968
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 18, 2022 12:07 AM
>=20
> No reason to split it up like this, just have one function to process the
> ioctl.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
