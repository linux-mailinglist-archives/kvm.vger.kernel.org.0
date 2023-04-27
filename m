Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39FC6F00EF
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 08:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243046AbjD0Gk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 02:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbjD0GkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 02:40:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF70046BA;
        Wed, 26 Apr 2023 23:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682577622; x=1714113622;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YaQC6CLURNhIONFDqXF6+hOtJoBKqh9tqiINSb8KT9Y=;
  b=DkhaK2p7h7tW7ZCb4QSodJnZ2LMGFBvHbJ0nY3IlEeIKed+3r9dF30HF
   cZ/hoTsRmcQ4IcfopIa01+cQJFKuhf0fBwLOBYqwLtms4jfqUif/g67z/
   Esvh0Qm4VsHCm3sIJcJwjtmQhdP5WaYMMY1bxVqrUiOl57lBSxN1psZsn
   tYYUmdZZcDtApdFGaL87QCw8QuYfvfrE38DYLrGYa8NjKEPcg1R3jXafK
   ojjASwqlIcWQ0brcWnD2TcpaoMJUwjPNHrqIjbegq5EB4MfGQL7iTbRSn
   GF+M4u/hzZg/xkrzy45/sHaRIFTP4C1AXHEaPGlzw17gvGT2S2NeHF/6t
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="331595405"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="331595405"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 23:40:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="868582526"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="868582526"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 26 Apr 2023 23:40:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 23:40:20 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 23:40:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 23:40:20 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 23:40:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vm15G1GT+yVdyJURmDP7lwa25WfeoZHG+h7gfRCQz7U2XimF+ms0Ix3XttjuRkJEoJEVFiWJt++4vlr3ncH254xGO6F+eBAEzN3+qksWfOval6Qn2S9TQbLsbix7Fa6Z6VRN6n9X5VIWacfYROQXWLkw79DOjA4Gzla7ufrFOqGXOGVTptFO3ozGFpw5ZvlbjQGiSMHhxXFaamHCxBHFZeCbBTXLGuG93+fY2D/MBFMDMEc6lQQl7eUdMPqBtTwaQYbYyqyOnPlywDbiO4dk6t72o16uqANtpZL/t0wPDNDGdG6Qv9lmYSlO0XgbDvZnuXyRYUSkiqSMhlYLgmHFQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaQC6CLURNhIONFDqXF6+hOtJoBKqh9tqiINSb8KT9Y=;
 b=XhqCAr8iP9sjCp4zeurEHUKLztVJa3fWD/wIMd2f3dQBXtx7VEYiDBzgzenuFvRNRUdEYm+7RKXyhLQ96I6r9+Yj1vX+WWyKLiavrozjZyQEPCZ81HtFf5OxrAZjPtQKUETNL+JVMjRyi+fv19phhdqEUE3c01w197+XU47MQ7qjJ0SVEQZJENHz45ZVVUhumpeLR2f3evnLmQY5SFp0XKU3af3H9sNsT1MpQkxig6gJI3ycqudkpndsUkAD9k6k7pAdF0re9bc7TdTyVdfdSHhKh5GaM5VcJZe3QHx/gs0W6OXUg3BRojTzUpW6Nqal33whvvtXESXxbACAWV9mSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5615.namprd11.prod.outlook.com (2603:10b6:a03:305::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 06:40:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Thu, 27 Apr 2023
 06:40:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 5/9] vfio: Mark cdev usage in vfio_device
Thread-Topic: [PATCH v4 5/9] vfio: Mark cdev usage in vfio_device
Thread-Index: AQHZeE8HRxnCahityku4CGwUwe3P9K8+tX+g
Date:   Thu, 27 Apr 2023 06:40:18 +0000
Message-ID: <BN9PR11MB5276A384E0A0877F9E895F358C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-6-yi.l.liu@intel.com>
In-Reply-To: <20230426145419.450922-6-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5615:EE_
x-ms-office365-filtering-correlation-id: be1b8731-2be8-47c3-0668-08db46ea4462
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: inkGlab0e/lfku9F0I6BcR20jAJf7BrUlvEZefVJwE8aDUJHQn5/Nrys8txLPtDPaSUqDhM8AqMLw+eN6ZxjAcSxkl/3w5ZLhq/80ipUA9ImkWpNebGZck870M6RoECnRJbIoO3PDzXyW3yAg0unQdDBUkkKs+9qsIz5ZmbSt6LQD3Qa3n2F5PkbbmmRT2VlYuSGdD64P96Uy2/E9jGT4MjwO6y2eeSxa5gkEVPPmZ8mYmpgjl8MMzcOKhgRbRpP6e7/yHwc1nJk8uMPRP5ZiWwUAYSMECjhu6XmZ6MzcdIWPydhqsLguFDWxUJq21PN9tPLFuuZry6qQ4kZBlT+tC99Xsl8dNmdPnRxz39MRE4JRy9nLsRSg/aQSGZH7RrXpK4D/xUTgwkIjVSOjYplKbtVqs3qvtWdO6WQzib8GZhDNuTmJ5LhD3xbPIrvri9MKc58pJPF6nMQVk4jHrmLcimN9Wri2TjIQq6fXeJX1VAfLRw62zP+T7crZxSi6UQKKqspk8//5zPjTCsORZo4L13EcVFf6oz4NyO7q3uX+G5kddDQuDBInIES8L5UrmWx0trRoIFxZR0wmD1C1eYBQPqtmZr3r1NvsUV7LbqVNS21+ogIZdirRfcAvnb/40EV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(82960400001)(71200400001)(478600001)(54906003)(7696005)(110136005)(186003)(38100700002)(66946007)(76116006)(66556008)(66476007)(316002)(4326008)(66446008)(64756008)(41300700001)(6506007)(26005)(9686003)(86362001)(8676002)(8936002)(33656002)(122000001)(7416002)(38070700005)(55016003)(2906002)(4744005)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bZVBvevLdzMztO5ANFVsr2GYJ3qTBftes3HQjP/lTTFNNc0KTT0RA64KyezY?=
 =?us-ascii?Q?YC8Ii0mXA+IeQFvxSSkIumtmZiR2eH0GuT2ERupAOrD9x6HQjmIx+MGI4IJo?=
 =?us-ascii?Q?M5ZsidZhNdDET4k4o1X26YRKuoLJ5MBN7yiywoYQrnOx9tSW1UlA95wizhRN?=
 =?us-ascii?Q?7YwM33HnIyvZJ7yMq3LiFhQyOaHoYjs31dyoVoBEC330sdaCCtR/jRBYUBF8?=
 =?us-ascii?Q?p/Myq8SRTxvk30OH8XzrL5gGaR7O6Qw8rmAzVnxogxDgJm6JQKRBwVvuIKsl?=
 =?us-ascii?Q?X2d8perPMqdWTT8bYTCb8RyWr1LQN/dWBlupTFC9apO25AUXJGi/CO3eGRXS?=
 =?us-ascii?Q?rTh51XXhjKUqILMTMIrY2g+8UNV87QfHDKaNFO5azec2F64TyyhI8ohG1otK?=
 =?us-ascii?Q?wrq1+Hm96wCSsPTBc0zgGZrkZrBhXQ1KoK1RRs02y6X4fl8GjD9FSGZYh7zC?=
 =?us-ascii?Q?+5rgCt7jnEXAAGPTIDnnhFmjqoWt0nzoItrneUP5mIByhBC6OQjTlL0Zzy96?=
 =?us-ascii?Q?jwBPKFKH/T1XQkIVN/ZJvfmleo7KZHB4ZgyUipKewYRj6flFseNIO31xVVb/?=
 =?us-ascii?Q?MHuSdYP6b7Wg+K+VA3mU29MFjvaANVAErKpHIiy1rZV+DTcnAoEGEYMcXlMb?=
 =?us-ascii?Q?sR84DwfuJkAADf9mBRvYyH6feMZ55V2JKjtneu3R4MZFz0HsOrICOI1jlAxS?=
 =?us-ascii?Q?oDdUL28VjWB7GKvb9tuTf7SWL/N76IB38XG/dra9NyZ3umQNyYCTRH8euUqd?=
 =?us-ascii?Q?kxZ7vG0D80/Aaf4r19ALwbfVN0XOuIfVDFUkoI5unDUWYpi211PV4Lbo8Jvk?=
 =?us-ascii?Q?MCHWRG31ISWXAY96j0fYTVjARxRYU9u8vmnJR7vVDYF0jFMWM89XuxBbaWM6?=
 =?us-ascii?Q?7MIPgYNCzKfcZyJrHiaTIFb6BGHpXoz7k6njua/Z4gMh+6BTeF680WOX4pxV?=
 =?us-ascii?Q?3IglHC8P8PEcZvKrDVWNmQ30jDfxn27yPFzb+6fKQYsBpame69DkuHnsqMw+?=
 =?us-ascii?Q?m5IAAo91AgGrq/V35ztWECKB68Ho4BFrCcqmDM6jtVosf4XFNZUb+ZPW72US?=
 =?us-ascii?Q?0OzvOmPrO3SR0oZhRpJ1z7YGWoHfGYWP1dur8uHfkQJeVntvNctMFy8W9muL?=
 =?us-ascii?Q?pzjmu7RXCW1dQfr99rYaRCtwUEoAoRZqrf79CJYoBr8+p27fVd4S4a9LysOj?=
 =?us-ascii?Q?6ZKfnrsF4h66l6I38Qvsu9ERkM8kIFQU6mGFdYPcAXr954z1cJJb2BPv9btJ?=
 =?us-ascii?Q?/7mSM0I33ebKDZTVooXq/ODDZ1ikDBk50+t+C+oge1gVgiWHQfrodwRZE/q5?=
 =?us-ascii?Q?5lEULH9XLVPcfRBRFMWnMnm4W60/7BRolryfsKi3ZcT9vgcLsR3pfjMJ9VKN?=
 =?us-ascii?Q?mX/Rf+0Kwg2Joj2kVYzAIdra6xdip7+nSXRwXeIECZj33FHu9PVHV0jN4q3D?=
 =?us-ascii?Q?xMbzvKmOT4my3rRxlowrObbQd8EYKjXQUR9U7laTgFHsd6RbZw0taaZGFsdp?=
 =?us-ascii?Q?ZAAE+JZcMqZbXFTRbw4sfTMj20C0m7V3mc20pFlUtlxJS2dD6S7Z2fJ6y7Ko?=
 =?us-ascii?Q?J1MNOpZ1+za5u5Cq3Utb0RhWTVtC4Kauic39E2jh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be1b8731-2be8-47c3-0668-08db46ea4462
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 06:40:18.6465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xCxoW2IKxLs/J+0LAPpTMLLZdI8Uxd7KaXSB3NYesnw/eClD9P2ghaUNOwPmiTZPqwnCRsYEn/Dn2Ip4BZWWVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5615
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, April 26, 2023 10:54 PM
>=20
> Use it to differentiate whether to report group_id or dev_id in revised
> VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. Though it is not set at this
> moment introducing it now allows us to get hot reset ready for cdev.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
