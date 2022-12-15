Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5838664D757
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 08:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiLOHjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 02:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLOHjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 02:39:31 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1FF2CC88;
        Wed, 14 Dec 2022 23:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671089970; x=1702625970;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eueUiiYFfS2mWB8yKuEYiwwbyRC4YRdc8dQfjy4HDtk=;
  b=jrmQlbhO9F7W5eUkypTqsgHkI+uAvZV5qJuGC7cYWvsntaoi04hrci8B
   LZmQXW8ybmqMW93C00wFYi+T8JKhdLxbE8LnBd7ME7mbjYj+T6EahgLxp
   SpOPS5n+Oz6ceVtQtrnFZxkIaESRPl8fpKY1MZ4SXb8YozV8TvCuMiBX3
   D2zF+lPpoTMnvntmUkdRKdy/zMgkT2WZgC26njDR1bsGA1JZR4RL5eKEO
   waZgHWJvFcyXmehhhx4ycwGYrKtiiXtfMOveY8RqMHof+sGA3LdQ2VSqy
   nhgrvYOZua0h9P11BXUdsSiKCNXvGUnolWSFj+Yft/t5aAsEQM3hUg072
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="316246434"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="316246434"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 23:39:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="978110773"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="978110773"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 14 Dec 2022 23:39:28 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 23:39:28 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 23:39:27 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 23:39:27 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 23:39:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmUiooxU5z2dxe6V4aZVZDx5nk9JFQut1b/VMMqt7AfzZh8Vsfic9nyC4vSiV2aoFVBu8Jyn4Gsg4N3kTpkJAsy/vcoFe1FqekbbTQE0BKhrMQDz0wlx63uGSIen40tzw6iMM4/3nKJvIp8Rw7LSwW5paklfLwvYB2kEa/kfKnJuUheHyKZrjPfTSXc/TkCHqBmOejPweNo5ZznquI/9ZgV/wUiWZqncAU33PFzpGD3DExpGxVOrBppOkS7K6q7ehZ1Jy52EenfgqaQInUq0pXmFyAzxiuLfJbL4ObXVL8wMHzJYVwEy2diCR1SnKjp1LjxCBLup6lihdlB2DK9Qaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRQo66ccNsK3ZF2mCNjZki/G0j5Lpq4tZtpx9zVRABo=;
 b=ScYZw486gxSZA0w+doYH0lFkulwZML+uBLruaT4OieMKF97TxXzcxTbgvyUkW0WLEGvmPVsHBwsdy2rQEsngKulGruFgRjlqSbs8Q2wXajc4RAFdKTDqOhvW0F1FF5f9Nhp/CV0P9ZmZ7996TJbdHFlr4FM4Z4X8vuNL03oHxeSxFWUz6B3hx6fSIj9L8Dvq8aKyPKHX3WPB0H0Popr3MP4PyX+s9UKRhHBWZbTF62O63GYveJxDy5WLmYFU0BJSD+CbT3R0btN0SZMV0uTIJPXjNdA41fEMNGxGWWnzg1+CKU2Z5Zy24c3vO5kpQjYT69WeLjrIFl2lMW35fWryXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5069.namprd11.prod.outlook.com (2603:10b6:a03:2ad::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 15 Dec
 2022 07:39:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 07:39:25 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
CC:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: RE: [PATCH iommufd v2 8/9] irq/s390: Add arch_is_isolated_msi() for
 s390
Thread-Topic: [PATCH iommufd v2 8/9] irq/s390: Add arch_is_isolated_msi() for
 s390
Thread-Index: AQHZDloHJZKkreHCiUakZoQiyXw8XK5uk8Mw
Date:   Thu, 15 Dec 2022 07:39:25 +0000
Message-ID: <BN9PR11MB527666D2192E2C25FF8A36AA8CE19@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
 <8-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <8-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5069:EE_
x-ms-office365-filtering-correlation-id: ee068699-4e51-40fe-3ffd-08dade6f7d5b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v40/LhsoBY2OLyH2MsXAoU0Uim09uwEJKoplUaBeJBrn7ajr9yV4/zKc1gKani3RB09WcNRheo419RZY6zbuxZdMiGpcKgsY67ZQ59pu+4078+/wNyaxxcaqxHRoLtGXBkahQyUU3uJqRKWRmOjwtF6h/jDSRhbQPKF19sv/ZFIrzXRvzUt9FsyL1i4AZbzSL3qSSR84+RkJ8UhT5lnBpdVWe8969qiOcuYlCDJ0fVsN0PYoU9feIyrXN6Vw/tgci9Beb5ts7j/IPvA8fQEsoRsuBWo7xBmHyx1e0+wnA18RyUvNZp5XpOy1eZSD+tw9+cFrUPVHEbW7rou3ExkyOVPTrTIoUtGeecWultvQP8yKgdkp75LGKvgIaVOBjhhZFTHL0kxMdRhPOan/jbnT2CRGG0iNI5hIn7zDaahd+J9+Ya1NZip1hMxuxrAcVyfS1Pg6p6v0m0H4XKs/Fc14I+ZBVfW5lHQkcAfQb2BlyBEJBo5eluPcAPU1ssyntEGdVmARWV0H1tAqEr2BBeT+7N1rBJHbQYimBtdqa7rGR+Jc+vIWe0YzdJix4emubQKel9oxvmDjP3GQiKlp195g3vzlJ9kGdxfjnLGaKc/OvEry3BzgEJJZIIrQ1i9myZZpyqcEOu0vVrDlIz5oDmHiY7m4+CE7RN4jk86xS/unHOwe/RZtwWeMp27RoyMWL9a71aeyOchiXer4EsAtaUmg9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199015)(76116006)(4326008)(66446008)(64756008)(66476007)(66556008)(7416002)(2906002)(4744005)(8676002)(66946007)(5660300002)(478600001)(52536014)(8936002)(41300700001)(86362001)(71200400001)(33656002)(9686003)(110136005)(26005)(54906003)(83380400001)(186003)(6506007)(7696005)(316002)(38100700002)(55016003)(82960400001)(122000001)(38070700005)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BnVL0Ptvjaq8RnOHfEJ99jvOSwmH/amQ74TI3P+kvkwrFFAe02YxOzNXa7yG?=
 =?us-ascii?Q?9eZkuzPiBGB1iVrIs4dOAlnfl6Nbiaj5QQ7tpLv5oBGU9cHaWC2TJ5coo32I?=
 =?us-ascii?Q?qkj04rlKtNgebRwwGCSzLQdWbuYVmQnGmG/a/JoKn3XZdNVwstvMxp6oPH2W?=
 =?us-ascii?Q?JNfbb5hiUWkJ+Ie14Oiq8Ie1EnLTKZuqruWQGM8BiFymjVmDNa6+6zltWIY/?=
 =?us-ascii?Q?FxZp8+j6ZLTZeTnvB18GH7cGzfYaGMnOO+Z1xmhoOUWM51eHQ7Eqw6/V44F6?=
 =?us-ascii?Q?VW/65HKeqom5S4g4dZRBZct9cavvT5iC4gmz36vHMWOszva5t66BKC/z6zLu?=
 =?us-ascii?Q?hHrbGGeMio2Tvwq3mq/ERDvVGE+8vr5L8oW3RCPfzylM0RtX5rOnec9GqHkQ?=
 =?us-ascii?Q?hZ+CR/i53dGnmEIuAKfop4M5Eaec8HRLLuzfHwJFqfH1aOF6L1jYmJKcK1BA?=
 =?us-ascii?Q?WIu+C2tgf4cl9OVUlDHYIBYzTbgBXLhKTxHgAKIV1SJsj00eNy1JbgsDq05f?=
 =?us-ascii?Q?0w8qZ+7V3KuEMxyl7YPL8hjBNiW9s0as7DAdMYBkv2WirHgE9e6fDkWKGCDd?=
 =?us-ascii?Q?WdHeg4/3e2OR+CSIpTmUTKBM2hlRXezfxv/gtysXV0pKl6MVO/mdvuhyPH6Q?=
 =?us-ascii?Q?qq90lqQBG2wo7DkvFIEeYBdNClV6w61QRH8JoX4Eu84W8FH0/+AnBznlEWVY?=
 =?us-ascii?Q?J6N1duk3ECMLk6rPGtQn0ay2J5fnBxfIlRjdrW4m7MxHo6w94eDMbUSMmZPd?=
 =?us-ascii?Q?p5/+Kud393tqGkigBLbCLSj+T6gwrnEv6X8LTesc2NF/OS3ov40eMPmxbidN?=
 =?us-ascii?Q?Fc17ltcgSbMT11Qqb8dsw3EYVta9XAAmKhDQe87XrSNg4K43EeKrbHww3N1l?=
 =?us-ascii?Q?EhHO9JbrVNtknvJtArnxJ7K1LCeRJj0BiqR/xF5TF1YWbhPiwBVyWdllRnpF?=
 =?us-ascii?Q?xKD9JPeoGZfN5Mdcq7bII1jAazsDqMsWNJhC0iTjqqhNS60tVEYO887DsLTr?=
 =?us-ascii?Q?7LfEM5WCG+2fzmOYGmjdVIo69oVT7sefK9CTa3SsSL6P377tS6KJ6ed25ug9?=
 =?us-ascii?Q?fyYYnxD8yaS7uaZwwipKDqjUdeV/F2N3aTBgaD6QhnciTp2xQPJpb+AmNXUt?=
 =?us-ascii?Q?CKpLfXomWE0uU005E0rPzioyQMosdLKBRUo0UpWaGLuaKKv20SP+q7E5iSbj?=
 =?us-ascii?Q?T6qGxN7TWulIQ1m5IT/p08GYPjax7k75Xe4XM07OIMXbQjPVueiXLrE25Zl+?=
 =?us-ascii?Q?4ukru1EDGfjAL8jgWVZWYBIxfeFiT8Lw4kkqmgs7NqW0yOMBP2GN86l2BihS?=
 =?us-ascii?Q?dOpvpZ6Ms5MH2X/5A3Q9kzv0Iv6o76Swu3iZR+faCJFGVKCMZDSaug7gPtrX?=
 =?us-ascii?Q?SV901xNbAfdhch+PqH/g396jdglQU4cQKaPP2+yyP94iyfewhkkGrXSpFlaT?=
 =?us-ascii?Q?2UK06tKLySM+3LXUp4JIItTlc1FXoaRIqrsbHtAXtV64/iOJSqMNuZm8FaeD?=
 =?us-ascii?Q?5aKzhqPGFbyi+h1Y/R5pOapmh9/5PIyy1noe9GPog8EtbMjidhVtqNKWi4Qv?=
 =?us-ascii?Q?fnM5uuDIYtgYkAu8bAivzJaB7jELye5HoE/PaEQY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee068699-4e51-40fe-3ffd-08dade6f7d5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 07:39:25.1589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ihztQ4X7fOBFjw00+cMZS3KpdW3Q1iwUaTp71ir6UBOmVsxlUL6rqg4Or20nh+FXowU4Oz0StgM8qvRXsiclHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5069
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, December 13, 2022 2:46 AM
> @@ -660,7 +664,7 @@ static inline bool msi_device_has_isolated_msi(struct
> device *dev)
>  	 * is inherently isolated by our definition. As nobody seems to needs
>  	 * this be conservative and return false anyhow.

Also update the comment given the returned value is arch specific now.

>  	 */
> -	return false;
> +	return arch_is_isolated_msi();
>  }
