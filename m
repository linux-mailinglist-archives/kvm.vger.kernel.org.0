Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C636BDDEE
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCQBGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCQBGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:06:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D743D082;
        Thu, 16 Mar 2023 18:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679015200; x=1710551200;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yWPKVa2mQq393BzcEYX18jVj4/bsIcx+DQKPL9dnC14=;
  b=ScCmdbb7TzvBdVsWfUAxiA41RYxUunAZySPVt7uFZxsbBAlC8g90mfO2
   SvaHsaNEQnhO7XjBWd9LYXjsMySx1hIvjAwh6o7Www4k6HHvzfF4qbzNq
   0dNKs+FGoFvERTh6IIrFrIOcVWx89eYu2vi1ONbtxW6pJ8jwR7gTfAzhD
   qPzqukMfm9EMck/42XMmNf5YTaU2Mq3/1iwvTFUXj4YPbNKQScrj3W8Ck
   3YtIGl3dH6jbPfc1W0mgeXO69euwIJgcfq5IYXhWCoXq6K21E6WQh5aEQ
   x/US7RA165oegnUBx3SzsdjBCqOSwrkOK+vcY3Zuy2CeJifjSfjBas51x
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="338167285"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="338167285"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:05:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="790544477"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="790544477"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2023 18:05:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:05:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:05:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:05:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:05:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QM9gIjzUQ0X9WfXF6PA8bBM7Ze8083B6eqbrV4sE1Gub+EVJ2NvW3BieOPy6gsEX3UFf1VUytatTW37hKr1++3EuVC4bNHFq6HS9A4v4httw8CuZRZAP3bVC2lHrfzd3wJFt4S22nVBJYcx4krMucpm6jW7pXeloS5uQZG1Ut/6qFP1+r0GRecHSggKtXA3qlXi9zP6ZCaPff/3b6jCLhNmfKCd0wr6sSCQEzFI6gXlewfMNNOAAdSLSyi3L4jwxU/BO8hoCcKhG2f3gnvUI7S6ALJw/5wFRNbgKhJpz6UAnnWv53A4tNaed0Pdcwu81thstVW27YMZxKs/ceAvcOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWPKVa2mQq393BzcEYX18jVj4/bsIcx+DQKPL9dnC14=;
 b=ZVONs+MIAZVC1GmXMdsK/zbxorsNjqud/jh2xg0vLCIA7+ilrd1mOBcoTQVnKULciG5wMZw7kgxNDwEDq57J+QpL4wcfEx0qL6zGcpufiWaXh959xjFf4iN2dTVUrVAuaX6kv89TpL6IwqZGLJfOPXEhsEcJG/iTOJvC5bARTweyOXgNWcU7/KK0AgEx9nhdJYuBwi5MFHL8u4CybhI9S92eamAMfoPnAVGeIL/gX29eT8xx8Ws2skkesN1ebpK2QT+bDdwvH0FNjYtTb1t1sxxGRrnh2wZhlDiyR/gSyDg8I1NRUUhrBsfzw5/tjtcSHsj0Fib75GcTgEDR7B0axw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6981.namprd11.prod.outlook.com (2603:10b6:303:229::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 01:05:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:05:55 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v2 4/5] vfio/mdev: Uses the vfio emulated iommufd ops set
 in the mdev sample drivers
Thread-Topic: [PATCH v2 4/5] vfio/mdev: Uses the vfio emulated iommufd ops set
 in the mdev sample drivers
Thread-Index: AQHZWAEK+Y1lHM/oqEGUWYXqsDaat67+KSkQ
Date:   Fri, 17 Mar 2023 01:05:55 +0000
Message-ID: <BN9PR11MB527629EA4ED13FDB54D488158CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316121526.5644-1-yi.l.liu@intel.com>
 <20230316121526.5644-5-yi.l.liu@intel.com>
In-Reply-To: <20230316121526.5644-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6981:EE_
x-ms-office365-filtering-correlation-id: 3c2aa9a7-e2a2-4d07-e919-08db2683c2b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZMcLXITySrP+enw4Rg7/lDCDdU3cRREzDEPlyxN8RgaWvkFd4098g4mYLNpBLCjrBkuxjGPxETt7IOFu1OCjUr3UhDbRU5we4Kv7mfaJH2RT99PYcKOncT1AGfuTUT06WH/A+1Qoe10xP8+jV4js302YcXJJVkFVf1CTTMvcaOQ7gMqH0QZZllSpHuRNnDeufxboGL3RRbnjXmxoCoIO+fbHdZL0atUiLlrwdq+hx4Ym0OJTPeThjo60BlquC8Um1FVGQVaYjpW9MXBTtDYpdZ9gY0+gQi3tRldCt6rEbX6SAXyxHMFNrcoeQQ+nrXaEGOsw/vmBRvX7DGTD0R8DkUcaq2L0HllObmBpqLGavf8pXXkLyrQS8a31A3hPylDNaiw0oq0pJsAQgxGQFFoMGSXhsoFMKFMkuqLhBt+7huSoCtF7MqUv87iKeF4+6NLj0a3KSnh6/mk5PqbyVeACSFydmCGcYNTn6p6b1UGLE5Jl5OsgSZgzbJlsBFcJlVMY5OqEKU9i1XgU6YR7UFHOiu7STKttw128D8hxZNu9vx10FEtEiawsJ3UWq7Td5nXDDBCAgpxiB3DTBzGEEVtOX0WSNIF5avEK/PpHDmP7n7gZ08pEPTOjdg7GqZ0rUCnqWxHpuEQewxzXpBgbsAyHuWyviLNDamXQNmVGzGUOIVVibghvDtR4Qfsx/PK7nwE+p9yhlljwhdXEvoQoGFI9OQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199018)(82960400001)(38070700005)(4326008)(41300700001)(478600001)(71200400001)(76116006)(38100700002)(64756008)(66476007)(33656002)(7696005)(66556008)(122000001)(55016003)(316002)(86362001)(110136005)(54906003)(66946007)(2906002)(5660300002)(8676002)(66446008)(4744005)(6506007)(26005)(186003)(9686003)(7416002)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ar3KgS9YOhIQS71BmiHA2eRts3ijg7aNAnfgbQnGRSvzPJpQaMHEZ9U/RCRN?=
 =?us-ascii?Q?NbdJ82EuQfkzrYW6c1ZJS70KlfwXRKNl66bAxAwvXnKp+Bi6amdfdB2z1/MD?=
 =?us-ascii?Q?cfjz/VYGNIy/NCzLiwOIpGwl6evZ0S003mOj9ZtlVssoGQo7LPECQQrqRWNY?=
 =?us-ascii?Q?z5D9BD/PG+cQUyBhpY00OdA23xbXuZ8d7u++/1vJXYRkfsnHZs+j494B84Ua?=
 =?us-ascii?Q?0ZE05XOYCnVv0mHZG/5vHVUDxnNC30KWvy8JnaIniD/aJWbbux7BJWqNk1d4?=
 =?us-ascii?Q?nA5bxrtWCeeTua1AIlADoUUit8cCzXdcZc7hsMQsL4rB28bH+FT90KKdLDPT?=
 =?us-ascii?Q?gRj9GFpe7k8/e9F4JRuGZ28L2z1zq0xoAL5PhtomM2Hp41Z0Xgdakaf1GRhQ?=
 =?us-ascii?Q?6Lo9pFNiL6hnQj9pptKK7VCIaYxfpVS5Uhh0CvWl3/yI40lg6Of0vOHBumio?=
 =?us-ascii?Q?Nvkvo60n47BISV/q0/vUG9jNT2XwgRW0EHwCqiJ/c7+IB3Btv4cLZKjbQpNL?=
 =?us-ascii?Q?sx2yfSsj9pOtUKpCPAfDByfWRuvl2hGFmUcA3S7P9D1a2Mmo0TONpHxqIN8D?=
 =?us-ascii?Q?vJKT5EyLBg7FsP8d/2N9E2ndm68RYOEHRJuwgXqAtsRAVBVc7CzulTMXy2ef?=
 =?us-ascii?Q?+Y3lr3A6IrLPUM0kRAKEF3dgKqRkd1hLiJONCygLwIf4g+4Y29Bd2eeHy+xS?=
 =?us-ascii?Q?gzKG/NXXL3fRlcJS1mfWyRmnnv5Nr3RlnTCJOELVeO96FjUSdgpCFPqxLz8d?=
 =?us-ascii?Q?RmcmxurojkVejpJ7+Vmp4Ei794pQyaYtNPW6FI/sMs8n8r6XEFGm3nlDXCVz?=
 =?us-ascii?Q?8lZ5yQz20EIyPjLOcvmV6hfrRrv5J+DBj/T1JMsa6OXVBka1f+tHjWJZjUvg?=
 =?us-ascii?Q?q4PoD25L16lfbBF1wm5m5j1YTRAa3Y7BrUHg0Wemeg4oWiYQzcDc8/lyVM9t?=
 =?us-ascii?Q?Dz/rg4kgUsCCnxTtGQmU4UtyLcH8KPnmp40rxPHHKiZrBFoI+1vaLVHxnhUv?=
 =?us-ascii?Q?D1HN1HxurdtH+A2Bd1Kry/pMgCjrCKnphM6ntShQnsLCmLmBGk3MEByOy/f/?=
 =?us-ascii?Q?6xTYuQGi3eqBnJq4o5TZi5CDTqS/LCZuXYsj1Yg10sQeoT9Nw/PIQgnHq8f8?=
 =?us-ascii?Q?UMPsDPp0u4xA8YssfP0Jot+Rs6WDpDnzlloIs2FF6FMrftie8+fdRPVFX7EV?=
 =?us-ascii?Q?+jA2TJOr4CEyEA3GKx23gK46EDyccJGCQzhSAfMbqPnGVNSDaD08dqlYo4Uj?=
 =?us-ascii?Q?dGVKdbEmDVxMdob1SRSrRQvOuqBxK8BqxrROLaozaeAzIA+iySi5eLO2YsiH?=
 =?us-ascii?Q?k34mRG9PqMmtpax9TaeaCQ9PvV+zfQL+D3UGYcIGgX3436Z3d45LrnARwwqB?=
 =?us-ascii?Q?AlZs4mV1kj82LFyjt/+qwdcxyrphbGdn/uCE+WBkLS2xMdPiS+tUN8JJv653?=
 =?us-ascii?Q?g7KHKGf6pzULNrkAtQ28/GpiZfmWHWh00upKsc5KQ1gFiadJnaFVtb5Ez5HI?=
 =?us-ascii?Q?or+z1YsFqsx6D4qBtsolLUhaVN8LOIyjTtXYfd08TIZLf5US5dwi5ZBU3TB2?=
 =?us-ascii?Q?Q86BT0yRzJ1NOh1Nfg5KLhjDdSQ1nesEcYSDQuQ0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c2aa9a7-e2a2-4d07-e919-08db2683c2b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:05:55.1911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6sexeugR+Ss4YsexhHD3xp3wdmg9h7B19uulWOQMkwN6Sw6EbXOkbdC+PZX87T3ysgFFtqjCPdvVoWt+bkSS0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6981
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:15 PM
>=20
> This harmonizes the no-DMA devices (the vfio-mdev sample drivers) with
> the emulated devices (gvt-g, vfio-ap etc.). It makes it easier to add
> BIND_IOMMUFD user interface which requires to return an iommufd ID to
> represent the device/iommufd bond.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
