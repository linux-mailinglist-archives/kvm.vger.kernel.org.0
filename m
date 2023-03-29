Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DB56CD090
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 05:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjC2DOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 23:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjC2DNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 23:13:54 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A9F30F5;
        Tue, 28 Mar 2023 20:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680059632; x=1711595632;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NHwEATeW8DwLskj4UZjxj9kKOtWwDRNSRgdZOr/TLkE=;
  b=Y/Wkyxjx7Xde3Zmaj1eVwKpr+7/nfXyjhz/IDiIjJlwOtoDJiCHk9bzi
   JpFPp3r9QrKE3p0C54s+sFJLUWri4GWTNgP5MMXv7xOhZY71JAXZpzAvx
   SPySa62iJ2bUW4/w6eAyrzvfDrjSN20H8xj0Psw06t5BL7CRIBXmLbSaT
   w0qF3Noq13UA9LuZtPM5bq7o9kG63dG59mpswLnUEcmbTOoBeLjFoBcz5
   Q3+sG2evGaD3dnlWOpP6PnDwB1J30hzEkoyeR0WTY2lA3LfUb+YXq9UVD
   v7rUEmvTQ3zW74kOMq/XbtwOIVOjS7AYvXM1lGMWetTmu9wvYnk8nW8Ol
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="320414531"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="320414531"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 20:13:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="795055796"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="795055796"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 28 Mar 2023 20:13:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 20:13:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 20:13:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 20:13:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 20:13:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3EVJrtw8UTBxDbk9WRThOySd+lYzpN+WuWRifByWKndr424Y/ZGfSUyDSbIRdnp04Mw+pg2QEf5ZjgRjoqpp+fEXAnPy3FK0PxBlBs5PA5qTidSZRa0XoV2Pp16YBZeR0weQyjEbKpsiuQ8TT8Ml+ZidY9lY6KjGfrxQe9uzQBG+ye90qdKPjOJy6QJKs/Q+WY1rHXQrhFMAMWXsrCE5O+Vc81fte5RfcL68uy12QfEIYVh2hRcOuowLjX1EqL3bZ40TyGqlhC2AWBWSrLh2OCBNeikohZNv+Ne3nBberj+SddPzgmeyJsg3bIT1DVVJHOErgEIQb/79NKjbobHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHwEATeW8DwLskj4UZjxj9kKOtWwDRNSRgdZOr/TLkE=;
 b=aUNBHcZnd2CyHqTOhQu3zK5Q9IltPegbB2s+6PM/omB9s8Vas+jg3TLaY5DFFEydcnH4iYBDAvD38e1F73/T0jvSFZ2JwbL7xuP/9J3JV/5lHCaRobRdtRK5AP6ELUQqKKyiAtCONiXfrLO261qnWc1q2rZBHZ7JJQ7SP6KPs/bZOjq1A7PBq+oBKNSYBt50NhVxBNQFg5Uj3m96zn1tUuTBqg7f8cUUpyXx9j8lHwkQ+gPnOcBegfTMlAwbwclZ01+2puyG0k/24jNkx5w7Py8swBNUIU/JWe9dH1+zQ/nZCkxcYBc2H7qIZOHFyBzjGKsHj6Iw9Gwh1+NqM5GhSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW3PR11MB4553.namprd11.prod.outlook.com (2603:10b6:303:2c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 03:13:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.041; Wed, 29 Mar 2023
 03:13:46 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Topic: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Index: AQHZYI92Dc+A7iEOnEaMeK3O2ipWfK8PAuSAgACBxlCAADScAIAAh+4AgAABaZCAAARdAIAAAahggAAHN4CAAAKPcIAACUyAgAC3rPA=
Date:   Wed, 29 Mar 2023 03:13:45 +0000
Message-ID: <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
        <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
        <20230328082536.5400da67.alex.williamson@redhat.com>
        <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328084616.3361a293.alex.williamson@redhat.com>
        <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328091801.13de042a.alex.williamson@redhat.com>
        <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328100027.3b843b91.alex.williamson@redhat.com>
In-Reply-To: <20230328100027.3b843b91.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW3PR11MB4553:EE_
x-ms-office365-filtering-correlation-id: c7b8dfed-b928-45bd-d69e-08db30039b64
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5e84Ui0ScmQNeTeqXbIGKJTJup0gZnwBlapmBV1vpkOIcuF3WoJkc1jb1bndROrfUKo9fgbpmYY/vHUf1kpF50K7va2VCWl+oJog0YMyr42P5EjQgQGWDEXRPkBZOFo0YXz390qVznpYaG2aiHDtfv9ryaWrzDMaGy/ZT2eW8Jt/UDD0xTcUXmdZOsfVIU1YgnCnGArPC87iP58pJDKKvGReXLiu9GKMdym8oOMSJt/IEtmQRbetTIOFAf74ohrQnCKlEnOj4B7qzzmYGpRkixRDfdLT3f08uPjJ/ZZa2NjX/TFen8sbPBuGxVxucU32gPr51KZmog/j8lmT0+7onzo0618OJYj0F3QNMy2Mx7tiLQvtWCxZBn2u28fNmNRL3MN/xisgy5GXuuCpblZubF6qQIzklpO/mYUuGo3YwhuwWEoXHO8NP5dgHqLdGwFY3XhicvSHoZkdJ4CVQ/YOMdJ/FoR1TQszFwuDTbDpLToc06gOgrtHyeYMV4jyznnqoqe6nWVGBw1pGn+HcfHY1PFWxjtVly11y07Abi/MJRN6g/Y3KFfuU2N+MKTNExNDbLl7WvlNzMdfrx8+W+NftWApEjvZB6LcMx3+l0A1A2T+HilodOh/++mo3cC1hbT5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(39860400002)(136003)(346002)(451199021)(82960400001)(122000001)(26005)(9686003)(966005)(38100700002)(186003)(33656002)(2906002)(8936002)(5660300002)(6506007)(7416002)(52536014)(54906003)(478600001)(316002)(38070700005)(7696005)(71200400001)(55016003)(41300700001)(4326008)(6916009)(86362001)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXFYTHA1LzZJVW9QVlcyTzZQZ2tYQ2hhUjJZdHJWeGFRWGlrRVdQYU5EQ25p?=
 =?utf-8?B?ZWxTVUVUT1BLTVhRbStXSi9UU1lMUHA5RjhmOGVNWHFTUWpabHlyeVVMa281?=
 =?utf-8?B?OENNU2xGUkdNOUE2SmgrYlVyOWFNU1h2U0E1YnprTzV1THd3dkdrL21HSkxt?=
 =?utf-8?B?QTJxN3BTTGdzVTNBY2xtTHNwWC9SNDVWL1AyUXQ3a09jNjBpdENqWVphc3dU?=
 =?utf-8?B?eVpkVFBWL3lkUkozMkhFT2lGcVpPaVlIOFU3eVlSaWVTTlUvL2p5a253TVlN?=
 =?utf-8?B?NE1zRHNZdkV0SnZxMkMxenhqZUtwNjc2VXk4ZXFsdFdBR1dKUE0zRlJHOEJR?=
 =?utf-8?B?bXVFRWhMMXo3UjBmeHNLRnljVmlmTTRyMXZVKzVaN05wam9mbzJSaEhLWFIy?=
 =?utf-8?B?LzQyVkw3Z2FDVDJ2WmRzTkdUT003dENXTUFsa1puYkRTQmJrK1c3cVdacE5o?=
 =?utf-8?B?b1RJN21Mdkdjd0NFdzN3dXdTYU9KWVFqeit6Q25UR0E1eTBSTm5WQTRjcTlI?=
 =?utf-8?B?bmJKMXUyQ2ppRC9wajJIVmlDMmpEMEtHdlkwQWVTOGtnekx5NVBPekRzTlpF?=
 =?utf-8?B?cHJ0ZDhnT0UwOGY5Mm9PdGRNc2ZSWDI2MW43U2dKbjdmZzM2K0tFTlNTbENP?=
 =?utf-8?B?bnYwZXNPY1pGU0dZNzFFVlk0bmdwSFpZbktNVDZIUFVuRnM4ZUEwRVRVQkFp?=
 =?utf-8?B?TFZVY2Jqd1VEemJOSFZLT0VjRmhiMHMwbkw4cGt2THRKNlNlQVBjUm9NMkVO?=
 =?utf-8?B?SzdJaWdwQU10TU5qelV4M2NpaEJYbStrbDlPdUFEeFMxRHNVTWo2VldpMWtJ?=
 =?utf-8?B?ZURLQlpwQ2NLR3BIZHJ4R1o1MS9JMUw1UmdlMXJvVjB1WGRSVmxoMmt0aVh4?=
 =?utf-8?B?WW82NjM3cnlVUTI3VXo3andKY0gvay9ZMUg0K21vTUNHcW1hdmlFMG0vdGd0?=
 =?utf-8?B?MmNhV0dvNjliSjBpVmhOTnVoenhzTno4QzZGbHkyUjRHQkdvYXM2b0xiNmhL?=
 =?utf-8?B?N3ljMU9rbThQZHVnTkdyVDR6OTQyR2hEQ2NTZ1hsZjJScVhwbkt2OEJyMU5a?=
 =?utf-8?B?Mk53ZWtHWURWd1VmV0NOa2NiakorYVZYb01LcWF1TkE5U2l2MUY1dzJkckZY?=
 =?utf-8?B?ZDBzLzNNYy9jLzZZdlhRSU95THQ3MFZHekprV0tYNGJnN1B4QWwxcUJ2TDdF?=
 =?utf-8?B?K3hST253WEhWN3YrL3RWVUE3L29Fc1lVcmY5NjhNM3pmSDlVRUlrcnJEZnZ4?=
 =?utf-8?B?QmZNaUN1dzkzYndJQ1VaZlZrcnIwbHJ5c3luRDQyc25KcitqQnhnSytHY1hy?=
 =?utf-8?B?eFJNK1JSQk5vWjZmQVh6NEg2ekdOckIwYWszcWFBTkhaaUZlNEZkN2h5a1hi?=
 =?utf-8?B?ZGlNOVlHZzdkeWl2aW5IRUlkMGJzNmJuckMzMnc2Y1EvQXplYUduNzdHcE1M?=
 =?utf-8?B?VXY5bGJ3SkhWNGp0SHhuaGtBeERLK3pWaG5CUDlKeHhjRWRVUVJ0TUIyaUNl?=
 =?utf-8?B?NzliTW1YRmFpMDJLNDdjdnl0ZEdTOEpsbmprcHZlNGV5d3c3UTVaNE5QY2sr?=
 =?utf-8?B?SU9YaTdhTVFodk80OVJ5OTJXNDB1MEtKMG5vaFVKR1BVaThTZlNUeXlrayty?=
 =?utf-8?B?SDJUTnYrREQ3Sk5rNXRvOGJhajdJejFidGttK0M5L3JybFB3b2YybHNKempy?=
 =?utf-8?B?M2JuLzh4NkRxU1hNYzl1RE51ZG1mNktpUi9YenZsUXNUWnJIRkQ1T05QaXA0?=
 =?utf-8?B?TkdXY0JkcTM1OWhYVENHQnVrdUV4a0JIbm5XaTNVcm9RR3QzbGpyeU1NaWsr?=
 =?utf-8?B?SlR1dFVZak1tTnRpdStWZStGRnZRYjhsdEloTW9KZ1JWSnU5TGE0OXYzcXFY?=
 =?utf-8?B?Vm4zU21qVStpS1luNkN0QjVhK3BRMlkvWnVDQ29pRFNMc0lpZVFmWmJab3ZE?=
 =?utf-8?B?QXFQMDFyN3BjNHlSNmtJby9GSC92NSsrRGtkaDU5cHdoNXQ1a3A1TnVKN3FE?=
 =?utf-8?B?UVptNWs3d1lRK2gxVVBNSU5Zby9JREM0M0tlS3VMbzJRSGd0RnB5bHAxRFE5?=
 =?utf-8?B?NUEzUVlzMk5FaTV3YU5zOEJtdjhHQ0F4Qk1Ebzl0bUtCZDN4RFZSVWNsSlVr?=
 =?utf-8?Q?9pdU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b8dfed-b928-45bd-d69e-08db30039b64
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 03:13:45.3008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ODDgyBQEjq9VT+hGkHEBygNtMZHjQev2O+2s2Ng0ev/oYa7ACgkaTAmZ3hZFaRBrKtF5uK/WHGpoDz6xOa1viw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4553
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIE1hcmNoIDI5LCAyMDIzIDEyOjAwIEFNDQo+IA0KWy4uLl0NCj4gPiA+
ID4gQSBjaGVjay4gSWYgdGhlIGRldmljZSB0aGF0IHRoZSBfSU5GSU8gaXMgaW52b2tlZCBpcyBv
cGVuZWQgdmlhIGNkZXYsDQo+IGJ1dA0KPiA+ID4gdGhlcmUNCj4gPiA+ID4gYXJlIGRldmljZXMg
aW4gdGhlIGRldl9zZXQgdGhhdCBhcmUgZ290IHZpYQ0KPiBWRklPX0dST1VQX0dFVF9ERVZJQ0Vf
RkQsDQo+ID4gPiBzaG91bGQNCj4gPiA+ID4gSSBmYWlsIGl0IG9yIGFsbG93IGl0Pw0KPiA+ID4N
Cj4gPiA+IEl0J3MgYSBuaWNoZSBjYXNlLCBidXQgSSB0aGluayBpdCBuZWVkcyB0byBiZSBhbGxv
d2VkLg0KPiA+DQo+ID4gSSdtIGFsc28gd29uZGVyaW5nIGlmIGl0IGlzIGNvbW1vbiBpbiB0aGUg
ZnV0dXJlLiBBY3R1YWxseSwgYSB1c2VyIHNob3VsZCBiZQ0KPiA+IHByZWZlcnJlZCB0byBlaXRo
ZXIgdXNlIHRoZSBncm91cCBvciBjZGV2LCBidXQgbm90IGJvdGguIE90aGVyd2lzZSwgaXQNCj4g
bG9va3MNCj4gPiB0byBiZSBiYWQgcHJvZ3JhbW1pbmcuOi0pDQo+ID4NCj4gPiBBbHNvLCBhcyBh
biBlYXJsaWVyIHJlbWFyayBmcm9tIEphc29uLiBJZiB0aGVyZSBhcmUgYWZmZWN0ZWQgZGV2aWNl
cyB0aGF0DQo+IGFyZQ0KPiA+IG9wZW5lZCBieSBvdGhlciB1c2VycywgdGhlIG5ldyBfSU5GTyBz
aG91bGQgZmFpbCB3aXRoIC1FUEVSTS4gSSBrbm93DQo+IHRoaXMNCj4gPiByZW1hcmsgd2FzIGZv
ciB0aGUgbmV3IF9JTkZPIGlvY3RsLiBCdXQgbm93LCB3ZSBhcmUgZ29pbmcgdG8gcmV1c2UgdGhl
DQo+ID4gZXhpc3RpbmcgX0lORk8sIHNvIEknZCBhbHNvIHdhbnQgdG8gY2hlY2sgaWYgd2Ugc3Rp
bGwgbmVlZCB0aGlzIHBvbGljeT8gSWYgeWVzLA0KPiA+IHRoZW4gaXQgaXMgYSBwcm9ibGVtIHRv
IGNoZWNrIHRoZSBvd25lciBvZiB0aGUgZGV2aWNlcyB0aGF0IGFyZSBvcGVuZWQgYnkNCj4gPiB0
aGUgZ3JvdXAgcGF0aC4NCj4gPg0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9aQnNG
OTUwbGFNczJsZEZjQG52aWRpYS5jb20vDQo+IA0KPiBQZXJzb25hbGx5IEkgZG9uJ3QgbGlrZSB0
aGUgc3VnZ2VzdGlvbiB0byBmYWlsIHdpdGggLUVQRVJNIGlmIHRoZSB1c2VyDQo+IGRvZXNuJ3Qg
b3duIGFsbCB0aGUgYWZmZWN0ZWQgZGV2aWNlcy4gIFRoaXMgaXNuJ3QgYSAicHJvYmUgaWYgSSBj
YW4gZG8NCj4gYSByZXNldCIgaW9jdGwsIGl0J3MgYSAicHJvdmlkZSBpbmZvcm1hdGlvbiBhYm91
dCB0aGUgZGV2aWNlcyBhZmZlY3RlZA0KPiBieSBhIHJlc2V0IHRvIGtub3cgaG93IHRvIGNhbGwg
dGhlIGhvdC1yZXNldCBpb2N0bCIuICBXZSdyZSByZXR1cm5pbmcNCj4gdGhlIGJkZiB0byB0aGUg
Y2RldiB2ZXJzaW9uIG9mIHRoaXMgaW9jdGwgZm9yIGV4YWN0bHkgdGhpcyBkZWJ1Z2dpbmcNCj4g
cHVycG9zZSB3aGVuIHRoZSBkZXZpY2VzIGFyZSBub3Qgb3duZWQsIHRoYXQgYmVjb21lcyB1c2Vs
ZXNzIGlmIHdlIGdpdmUNCj4gdXAgYW4gcmV0dXJuIC1FUEVSTSBpZiBvd25lcnNoaXAgZG9lc24n
dCBhbGlnbi4NCg0KSmFzb24ncyBzdWdnZXN0aW9uIG1ha2VzIHNlbnNlIGZvciByZXR1cm5pbmcg
dGhlIGNhc2Ugb2YgcmV0dXJuaW5nIGRldl9pZA0KYXMgZGV2X2lkIGlzIGxvY2FsIHRvIGlvbW11
ZmQuIElmIHRoZXJlIGFyZSBkZXZpY2VzIGluIHRoZSBzYW1lIGRldl9zZXQgYXJlDQpvcGVuZWQg
YnkgbXVsdGlwbGUgdXNlcnMsIG11bHRpcGxlIGlvbW11ZmQgd291bGQgYmUgdXNlZC4gVGhlbiB0
aGUNCmRldl9pZCB3b3VsZCBoYXZlIG92ZXJsYXAuIGUuZy4gYSBkZXZfc2V0IGhhcyB0aHJlZSBk
ZXZpY2VzLiBEZXZpY2UgQSBhbmQNCkIgYXJlIG9wZW5lZCBieSB0aGUgY3VycmVudCB1c2VyIGFz
IGNkZXYsIGRldl9pZCAjMSBhbmQgIzIgYXJlIGdlbmVyYXRlZC4NCldoaWxlIGRldmljZSBDIG9w
ZW5lZCBieSBhbm90aGVyIHVzZXIgYXMgY2RldiwgZGV2X2lkICNuIGlzIGdlbmVyYXRlZCBmb3IN
Cml0LiBJZiBkZXZfaWQgI24gaGFwcGVucyB0byBiZSAjMSwgdGhlbiB1c2VyIGdldHMgdHdvIGlu
Zm8gZW50cmllcyB0aGF0IGhhdmUNCnRoZSBzYW1lIGRldl9pZC4NCg0KSSBrbm93IHRoZSBleGlz
dGluZyBfSU5GTyBkb2VzIG5vdCBoYXZlIHN1Y2ggcG9saWN5IHNpbmNlIHRoZSBncm91cC9iZGYN
CmluZm8gYXJlIHVuaXF1ZSBpbiB0aGUgc3lzdGVtLiBCdXQgZm9yIHRoZSBkZXZfaWQgY2FzZSwg
c2VlbXMgcmVhbGx5IG5lY2Vzc2FyeQ0KdG8gZmFpbCBpZiB0aGUgZGV2X3NldCBpcyBub3Qgb25s
eSBvcGVuZWQgYnkgb25lIHVzZXIuIEZyb20gdGhpcyBhbmdsZSwgd2lsbCBpdCBiZQ0KZ29vZCB0
byBoYXZlIHR3byBpb2N0bHMuIFNvcnJ5IGZvciB0aGUgYmFjay1mb3J0aCBoZXJlLiDimLkNCg0K
PiA+ID4gV2UnZCBzdGlsbA0KPiA+ID4gcmVwb3J0IHRoZSBiZGYgZm9yIHRob3NlIGRldmljZXMs
IGJ1dCBtYWtlIHVzZSBvZiB0aGUgaW52YWxpZC9udWxsDQo+ID4gPiBkZXYtaWQuICBJIHRoaW5r
IHRoaXMgZW1wb3dlcnMgdXNlcnNwYWNlIHRoYXQgdGhleSBjb3VsZCBtYWtlIHRoZSBzYW1lDQo+
ID4gPiBjYWxsIG9uIGEgZ3JvdXAgb3BlbmVkIGZkIGlmIG5lY2Vzc2FyeS4NCj4gPg0KPiA+IEZv
ciB0aGUgZGV2aWNlcyBvcGVuZWQgdmlhIGdyb3VwIHBhdGgsIGl0IHNob3VsZCBoYXZlIGFuIGVu
dHJ5IHRoYXQNCj4gPiBpbmNsdWRlcyBpbnZhbGlkX2Rldl9pZCtiZGYuIFNvIHVzZXIgY2FuIG1h
cCBpdCB0byB0aGUgZGV2aWNlLiBCdXQNCj4gPiB0aGVyZSBpcyBubyBncm91cF9pZCwgdGhpcyBt
YXkgYmUgZmluZSBzaW5jZSBncm91cCBpcyBqdXN0IGEgc2hvcnRjdXQNCj4gPiB0byBmaW5kIHRo
ZSBkZXZpY2UuIElzIGl0Pw0KPiANCj4gWWVzLCBpdCBjb3VsZCBiZSBhcmd1ZWQgdGhhdCB0aGUg
Z3JvdXAtaWQgaXRzZWxmIGlzIHN1cGVyZmx1b3VzLCB0aGUNCj4gdXNlciBjYW4gZGV0ZXJtaW5l
IHRoZSBncm91cCB2aWEgdGhlIGJkZiwgYnV0IGl0IGFsc28gYWxpZ25zIHdpdGggdGhlDQo+IGhv
dC1yZXNldCBpb2N0bCwgd2hpY2ggY3VycmVudGx5IHJlcXVpcmVzIHRoZSBncm91cCBmZC4gIFRo
YW5rcywNCg0KSSBzZWUuIEZvciB0aGUgZXhpc3RpbmcgX0lORk8gYW5kIEhPVF9SRVNFVCBpb2N0
bCwgSSBoYXZlIG5vIGRvdWJ0Lg0KQm90aCBvZiB0aGVtIHVzZSB0aGUgZ3JvdXAgYXMgYSBzaG9y
dC1jdXQuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
