Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2839E671771
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 10:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjARJXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 04:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjARJVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 04:21:17 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3605D909
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 00:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674031565; x=1705567565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K684Qjew1NEyCtLMZiAvhhC6ABKagcA1Fw62Shfo8FI=;
  b=Y5tSAV37pi1D7gC0DOvtLxW72JB20AN3Ot3aZYuOJuxVrWKr06SzpsyH
   0JE4CBP5wTDUmnKWWozf3D+eTcGN4cl6pNEoVj4QP10gW+kEcgZatOj/i
   zNKhontoOU5R0Ih0+nv0sqlc5NTlsni8U+CJAtwEHQA5QBWaIsrRo9z0B
   1ae+3JpJ4+hU5jUCDM/XdsXPb7rukABfEUGonPPxPxSCRZD3QRo5wPaMM
   YitQLqv5pc5fue2dmynSOaU7J5dGajEZOUK1mDI1nPrqeBujwGSu6PYCg
   ulgP2ZLvn55PNsDkmPeBPgxz6WctUWDXY6CptEk8K9M9qsvi5eiC06qEn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="387283280"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="387283280"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 00:45:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="637192804"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="637192804"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 18 Jan 2023 00:45:47 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 00:45:46 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 00:45:46 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 00:45:46 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 00:45:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6I2GOV/UPtmcRVksSEbQbnYLYjfeObgq1pBEXOLX1qG/d5kxHeO8Z4NAkzoDpUqSCLyfR5IWdpA64hk/TGUcQ2fyxIuL+NsX/EjxCWI3AtOuT91SkDCiYAyPD1GrvdFhZ3NZ96Vsg26t+Zy+1N9viNarxCqBtAI5AdofWRL7O/Q8MlZ8hHkjQHmEUrZqsZm+mt9MWkA/t2wg7As76OGpHrPIeTHdGe/IxBMWUXX2ZaZPKv76N68YN7imYvHyoIW2Zq+w9WkhyhqQVgF7BCgjgrctd32KKz20+V4NPCzgdtv/DEa1hAZ4PubXd9qOXCYycycsd1G3boUonD6MIXBhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K684Qjew1NEyCtLMZiAvhhC6ABKagcA1Fw62Shfo8FI=;
 b=XvmHoigFryKFX1KgMb7UaQKClOmKUtJD9WQ2SmhzZs55dycMgmuBzwSeTYTMMCorEaxCUyKUOxlO1jOCUB0YIo/qIBw/NfDa+VmNsU0GIS/flrbJAvy8vlzAJspCr9W60wu0V3Ajr+2QWq2cgmCT1MK58WtJHQeeGVscHu323xhQ8z2yY9rKUHCKDGmeSokZ+ptOqZwe3W1wujcD47+zc9WDSdB1f7S94p1MNA9BZQiQWZG1s8dqh454MNu0xsl1L6hxpfTEt3BYQ3MOPeBuH5fi8oQldpX3zm/D12qIdQfO7X0yTh9Lu9obMnoUJePENXIkGfZX9GhCcbMiPq96UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5582.namprd11.prod.outlook.com (2603:10b6:a03:3aa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 08:45:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 08:45:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 03/13] vfio: Accept vfio device file in the driver facing
 kAPI
Thread-Topic: [PATCH 03/13] vfio: Accept vfio device file in the driver facing
 kAPI
Thread-Index: AQHZKnqWGXn8Av12RkuGPIHRTAbvma6j3Kxw
Date:   Wed, 18 Jan 2023 08:45:44 +0000
Message-ID: <BN9PR11MB527682EB316BD8DA04D1E7DA8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-4-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5582:EE_
x-ms-office365-filtering-correlation-id: e0122000-b577-4279-ecb5-08daf9306331
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t9U5eDmmMCtEQfOoUHVB+00QxCQxW6I6ccV3xEooIjP9RWu+CSS4V7Qnd0S43dzJkG0FFDZtcGLTgeJ3DRsj/FR9xd0dNjW0+4NC9k802ReiIYsnETtBpBG5t7n1Bs3ijgR9Sp882yPAu+njk7SBd+n9IjsXlAUpYsrfCE99aOqbydzSkgcjqrMzGRvTfsTixMtUQpvKPj1UhCxZwgNbA+rk3gqxBJ5XIXI4fRO2QYT3clnOnw54R3+nDHEdBwUzOxYpHnMy9ig3sNjJvWKv1Z0+968PcNp3KmWknqjAK/uKheZD2YzFAewRCuSTIpwj4h7echLg9++ofCs9Fo8Z9TlWMW+sKmEfKzf7cYZPcPb5if2PB7JbxETUaDfimW0N53SMs0tosJjBg3mFa7sNWtnbdhofE2ZAYiGHlRh8WobXnPgXKuoSmdyKniCKc3cJQm5o/KFE8vh9V+Q4Rnfis81SF2h3q+ZqBCiBwpiASGbZCETnF11FcCVYxS3RjOaj+fAdNiqwLzpMOz9rhBxMEk5tNh7gflJqNKkqZxEz50/XyR06HShQWtJkcK5GXbN1EznTmEZ4jVAZP4nFchL31TfdHsAgyaPmTiZNiuepNQZ7+NQ5u5uO9dBvLuc3VzvtjA+ym9jaOx9vMOmHrGF/A0G39XF51DM+YnyhEhTOVrxjhE8XoPvWTCOtmo8wEM+mKTgz53J9YEnpUb32irsH1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199015)(86362001)(9686003)(66946007)(41300700001)(186003)(64756008)(8676002)(4326008)(66476007)(66446008)(66556008)(26005)(33656002)(76116006)(55016003)(71200400001)(316002)(7696005)(2906002)(110136005)(54906003)(478600001)(122000001)(6506007)(38100700002)(38070700005)(7416002)(558084003)(82960400001)(5660300002)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hBOYsAbB74+u9XxgjfJSCOSGUgQe0mXR6/eNJtFhhle0EPbUCrFKYb8qwY8m?=
 =?us-ascii?Q?TByZoZfOdIYsD00fEsxgRFdwDf61PCad1O6RQ+aijtCpyG9nm14WWXhSE0WI?=
 =?us-ascii?Q?763Tx0362IoVsXpak8Aw8Go8+c5WFNXx3th6P5cnKyP5pGFeX0rTS1/3nUhv?=
 =?us-ascii?Q?FrFxdBnK2pPDrbrs7pCuvQ3TaR+JKwk50IShg17WIBEQFCkX2czX/au4zZZP?=
 =?us-ascii?Q?5ma4w1VzxNq5Ib5CwyhJK0QL1KNQXFew1CPWYjmzeLBGoHTGYqedlSCvslpm?=
 =?us-ascii?Q?/DsKqeqa/q1CO+O6VgwJJhtQ4RbHUDx0yocFucZTjGAvLRCaDmJLZZmbeVFG?=
 =?us-ascii?Q?0wl8iyVGEdyyj1L5V82o1YyEz2EOCMkkL7gBScOC5gEJ+kDM9S71WtpG9z+D?=
 =?us-ascii?Q?j9zHhpXiY19PsClzDtef5KnXoMT9TIgZaLpgNmy4ut4ErDgIz3U0viGF8/m0?=
 =?us-ascii?Q?UhQapkT56N20huqttn1jqmQvjY2EwOfcP2nhVrRzUtfzqIDzAvbm48tUGu4W?=
 =?us-ascii?Q?FOwW7eTaMowQ0aMLdNfvnPF5c46yMGFORR29RVciQBi/hRlXm/NmbOA0fX69?=
 =?us-ascii?Q?J++hcFGUPq0S1ZnzoIcQbkt4OGU7IQ/08Jd1ISbvlo3Q0tiazI4Cnq6C0tY0?=
 =?us-ascii?Q?cH9kIXOVHn41zLQ3u2Yz5Z70ecZxSqZsx34z+3Cxla/eZMVhQ1kteV0U04N9?=
 =?us-ascii?Q?xsh03njnNVv/eMQFlj5cZN3CDRser/GFpXlDVarFIUm0aABlRwPy5NmsDpCv?=
 =?us-ascii?Q?aFl8+lBLHp6a50sZ22IYXEsw2oA3nbaJGXDR3mQms5z3yQ5cAiKhzs4Q/D6G?=
 =?us-ascii?Q?stY3atXUcqd6LHBHfhcsyvf5Ql3qJ+7iaMAvp7KZBkEW/LPyh6Fb+nwG9syw?=
 =?us-ascii?Q?czTn8KPaRXQerQPZfuXtnFgzUZpK1blJ8btqyJ/sCvgiRWB0i03zlikSxkwI?=
 =?us-ascii?Q?e5+3lwnvfJBGytmH9O5EKdA3cv85sELrKPaHNjZIqYgVbIVjYSIapP/5GIUI?=
 =?us-ascii?Q?Op5gQvXLX3hp3asoWhFVBuQRtrFd0L15/Bp95u86vpYc0NKqGxbSuZTBysXo?=
 =?us-ascii?Q?Kau0vHyG+2Euvqtwqe3mKZfn74QjK6sQhMgM1LCGT+Pzxon4XjK66MaptJGU?=
 =?us-ascii?Q?QN71qva6TOc3/UuCBhPJLuHLD6V1YaGic8HdePxoNrJ62Y6AXBLAxkhRIFfk?=
 =?us-ascii?Q?O88HQ7FwUO2omAnRR3RviwqBsMwQIvWOaeCNWGwfbtZ8o6jasB16jK45Nju5?=
 =?us-ascii?Q?MuA7ZmUjBeZ520sArkzzg+WRoXcTqsmRXTWYXqaT5/s3XtT03Nl0Qh6ndk8/?=
 =?us-ascii?Q?yQIC9SFivPGpGDTZ2RtHicCNyfA5BEEJFqV/cnCWuI4St+QEOrmgowkOMUjF?=
 =?us-ascii?Q?xjTu9G4t2MILMv5rfqTw8nLrZFi9Tbrt+RvYcwKW+XozovSxTpvRUDpN4MK2?=
 =?us-ascii?Q?CQrBpJfUC5kubxQf6axQcB4SqJccDrXBIAphiEFJmYN0vgIYmmEFvUI+odQD?=
 =?us-ascii?Q?BkRKVK+aVCbRtfIHA0Dehxj6jDQfC9xkHCYtywJdnGDLm8bc4wEV5k6JC9Ru?=
 =?us-ascii?Q?HU8eJcj9sNU1LNsvKhyP62tNlrXEr/BYcfhLIQia?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0122000-b577-4279-ecb5-08daf9306331
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 08:45:44.3840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q9bdSyNLVyl5AD+bqeFJozrHPcB3CC+HrZgm540QBINQFkAGKEDbO9jDlmiVUmao/SvhuFIi1NEY2iEZKpulvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5582
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, January 17, 2023 9:50 PM
>=20
> This makes the vfio file kAPIs to accepte vfio device files, also a
> preparation for vfio device cdev support.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
