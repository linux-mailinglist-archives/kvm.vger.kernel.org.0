Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1756A5141
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 03:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjB1Cfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 21:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjB1Cfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 21:35:40 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783DD2798C;
        Mon, 27 Feb 2023 18:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677551736; x=1709087736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VQMAjzWKlVKcZxNL1Jhzz5b8u/70ywnMyyN3nK9dlP4=;
  b=OJ1SaFp5HPOcxJ8MAzrC2l84sg+BVa/jKYyBNem8wM2XTfeSFtff0DZf
   ED2goi9RcRcWHYYyDHe9rNPsgB2md4AFsR8S7yQWTRbZknbqR865R+pW0
   BWejaTvf27RIAisBHpoxM8bTlmUMTPu6GF46CLBp2rlOemTwYfpXqVeGG
   /tyEhINGB0FGaenNnGgcBMQpvSsSkAqPyOvYQ3OlyudWIpZoBx+H/jJYn
   riiCotlb3b+NJ9OBaL9mjTuDFPtfsZreAIJTQhErkneExLIB5CBuQNMov
   UkivLlXDZfvklM4iUxXmr5ylbrOyTNrh53eddiIt5L0a7t1vhNVrWX9pS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="332753861"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="332753861"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 18:35:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="783647150"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="783647150"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 27 Feb 2023 18:35:28 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 18:35:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 18:35:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 18:35:27 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 18:35:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adHM5A31y7MPLdpzDvWymtHmEMLWlQ5HIkgKe0ABeODpoy7V69IgtaF/lgH2ZX37NOrWRKHJRQVf4ocZgiDNptS/j10KHlwgbE34hmLg183T2jIcxX6NCkK21/p8UoamOV9o/x2+vXlY63fHvE5Qj365A7s71VkShBjZvwEMxiIMvwP2wzxoztL2Ihh0r83Wmd/qew6IcB8J+YfaW8RjR36UHfuMs1nZkEM/VVYUARZ8dwzEuM7RRAEkx55QDFgc/Ip+UWqhygsE77a60Jdv4ynVUEl7/YmhsBN05vEdUcTV9B6OHkxsv19gSf8JlyO3Spf+fF3RVJKuRnqNZzGKYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQMAjzWKlVKcZxNL1Jhzz5b8u/70ywnMyyN3nK9dlP4=;
 b=gB6cLIAzgnY6QbOahkjo0YwEvX4Xq4DdAKws71l/PdjZoI9dIBe4GbKGjmkQnUUXNKvapZnzG9/RJUktaG38u7j9XcBOzBspPotY35r3F6837LY/7ZbefMV0OQBsFY587qTbXAbJdeXRraJYSOER/XJHqGY5dKXxvNKpYHM+ew2clRDbbLjUvEm9n9o/TnXSnzflSLCz0tSW97UmTaEk4mIDSnKSqPcxflbtOrg+V3qJx4FFlSTvlKMGyvsW3YEX9wYOBMangHQzn+8g8BzgU4oFe9t17X+tRqhKnqYyu2CuV03rPdQBUc/sl/7SP+pcgS5WNPZ72N7rrVcJ2RYDcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5445.namprd11.prod.outlook.com (2603:10b6:208:30b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Tue, 28 Feb
 2023 02:35:25 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 02:35:25 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Thread-Topic: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Thread-Index: AQHZSpxK4wL3BAz2vkuMw78Q2DEYMa7jHbWAgACHOBA=
Date:   Tue, 28 Feb 2023 02:35:25 +0000
Message-ID: <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com> <Y/z2mY97uPsCs6Ix@nvidia.com>
In-Reply-To: <Y/z2mY97uPsCs6Ix@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL1PR11MB5445:EE_
x-ms-office365-filtering-correlation-id: f7cfc9b2-40b8-407a-5dab-08db193472aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bbBpnsEtrFKoE0YC2dm4ucCiUeXLgDbS60UZKDzMRRmG3yxQiGN8klmhIc/m3U1TgVLi5cqbJ9HzihWqokQYGCTy9b59j6SUt3zMUoei5ztQ/I2pq99Y7B9KVIZoy+DxJAav9Eo/x0En35SbLBIXsWsbzcNkI5hFCRm2/NZdP3O1ffD4bai4FumCy//xzsKSCMz3Vm3fxCJStv+xlZPRpyHBsi7h5x9k43/+GwllyNn3bO7P9Nil96Ps9EbBa9zIH3ycWZtG4YduioBI6JYFQf4AAV1XhZK0KYFMAPZhzc9KRk8XG130Ql+89E/+6TWE8pQYPT1Ptiwr4mfZ2bByUEM6N/PLw2rYGN3FdgCtY75d6I7ftp+hetQ4L0CKHKuWscda9Oyszy6rJCiLd7IyRWF/meXmIWIrDZLJxHeWIIdrkVkc8vAnF1RYZKPPlOEHIr2IfEz4OPmbZC+9lBUP2Qrl+VV17tW39PmeBn5EQNo+6h0ReNU4TjnUV3VOMSUgWObqGHc+ZOAI9RW6YLfh1T+d83aCmkNYpcTUV/3o/iFIFwAs9Iy8S20Tt95znIvC1Qe8bTT5VuMeCLRF37UF/ph3wJjHHfa7QFZIXnGGgxWgcbCNKOHTTbFAIIqzsnjIYIKynCXicWhy+ylwfgEoLe4FtCsGMgJrCpSEvQek8+IfGlXjZ/SQqHz4msKmrc8xkpxieBwFulDrQOhPoqRmHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199018)(186003)(2906002)(9686003)(38100700002)(66556008)(82960400001)(38070700005)(83380400001)(316002)(52536014)(122000001)(8936002)(66476007)(66446008)(6916009)(76116006)(8676002)(41300700001)(4326008)(7416002)(5660300002)(66946007)(6506007)(71200400001)(26005)(7696005)(55016003)(478600001)(64756008)(33656002)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXJCZlRTbE51OWl2bzA4ZUxibXlNdFhjRFh4WDRKeGtTRWJnNDVVb2NOb2Nm?=
 =?utf-8?B?TE95Uy9ZSGlocHRRUEVuNlNvOXlYQjVRZEpBRmpjTUJEQkFySXMwOEE0RUtt?=
 =?utf-8?B?bTlaSlA1UmoyRDF5R2RDdzFuOGhxaHFFQzhub0MwbWd6OEVYUWNCZG1GZi84?=
 =?utf-8?B?ODM2eHpscTlCL3d6bVp3ZjZmQU9Uc04zNFdyd09xR2daT3BQRVpGSmtRdXd1?=
 =?utf-8?B?eFJtalBRTW1UZ3hqWHZ5cnkrMFdvSWR5V1JKcWZSSHAyRktZNzcybmVpZ0lx?=
 =?utf-8?B?Qmd4M2RnSUZCVDY0WHVkV0dTRVJkMDcrUnpzWmEzNGIyUm81MUhHUFdWMFAy?=
 =?utf-8?B?SEp2anpTSHA1ZG5kM1l5RVRJeEJqdXVXOFJCMm5CQklGTHU5Z0Vra3ZqVzdy?=
 =?utf-8?B?WC9MYmliTFFzYXRmRVlxdU1Lam00QVh1QjdkZjdXbWl5K2JQTGRwMkpKUi9J?=
 =?utf-8?B?VlZRQmNSc3BpQ0g0Q242QzhEVHZUY29LTlhJVy85cnpvU3I2ai9XdzM3UThj?=
 =?utf-8?B?djRicGlydVJnUStXaGRYd1IyZC9FcCs5b3NIVGM0S0lYZTYxZFpNSHVpbGZS?=
 =?utf-8?B?ZTBaT0lrSzVHWXZYS1ZIZzRWSjNnTUN4K2hCV1NtS2x0cFhWcitSN3FmMjZU?=
 =?utf-8?B?YlV3aFM0YjNtSVJWcHlDMVMvM2dvSllaZEc4cFVHVWlTOUpFVWQ0eEgrdXJS?=
 =?utf-8?B?RFF2RmtCZFBpcWVlK0t2NFdqUTRZUWF0R1BpS2x4cVVVSWxWQ2dsWE1HMGlU?=
 =?utf-8?B?T25EUy9OOFpsMW1lb2NndG96MUdsTU1jVFlJV2xaZVJaQlc0bEdGWUlSTVpp?=
 =?utf-8?B?aEI2emw0UjJmQmNGajZvbFliQ2Npb0xIdkJ0U1Btb3YyMUMzUXdpMUdKSTRn?=
 =?utf-8?B?SldXMmdpWXMzOXh1aUtJenpUOEhlaktaNWkrOW9sWFBOaStFYmZJWGprQ3Ft?=
 =?utf-8?B?R3RsN3BOaTR0d0t2TGNvTktNcm40b1hyWitFMUR5b1pyeTN4Q0Rsc3lCTlBh?=
 =?utf-8?B?RU1HWEhjYW1BQ1BPWmlvTzNJR2hoWFJlMlRSLzFMU2p0ZzRlUWc4ZjUzQ2ZC?=
 =?utf-8?B?WTVIbnVaQU1UV0xBR1V1L0ZYeFJZZUhUSzZDQk5OVFBpM3RqZkxMMGRMZ0RO?=
 =?utf-8?B?bHp5dGNZSFpCOW1WdTJTSGdXSG11ZUlTNzdReWNaYlYxbDlxQXVRS1VZcTJW?=
 =?utf-8?B?SWJpbCtoZEJScWlVNTZsQzNCZFlKbXl0R1hidXBpTXpzeGJiKzR1UmNVNVBV?=
 =?utf-8?B?OEhDVTUvdkQrU2N1VzF5VldGYnVnQ2dGNkJpcHdlZHZ1YmpZbkczdytPRkIx?=
 =?utf-8?B?ckVWSnlPLzB3REVNc2ZuK0JXTlRIRVI2eVFiL3Vnb0FubmJ3RlZ6SmtITjdR?=
 =?utf-8?B?cmJxMTIwdE9HUFhlT2xwOVZEK3EwSDVNbXc3T2VOdzA5RDUvK01XWStsNlZl?=
 =?utf-8?B?SklWS3R3MzNaYjdmS1o4YUU0L09uT3N3MmwzaEJPeU9mU2tKT2FsTGdCWGdK?=
 =?utf-8?B?RmdDUG8zR0cvYkRORGZZTnpWQS94eVFvdGpxVm5NVHQzM3pUMjl3Q2sycUlh?=
 =?utf-8?B?WEFpY29sQUF1SktpRzd6bjY5RTFMQ0pWQVlGanZZdVJXc1pGV21GakZ0TGt2?=
 =?utf-8?B?M2pPdFliZ2RPV0hsT0xGYWxZMkpBanc0SkRIS2RBb3kzRTJFN1ZVckRrRzQ1?=
 =?utf-8?B?M0E2dGVHOEp2eVpSVnNDNXJkSC8zZ3YwYTlrQ0FmSWhCQVZFWktIRlF0NWlX?=
 =?utf-8?B?Q0lRTmM3TkVYWnRQQm0zdEFBc2JJenZqczdUT0Z6eHdwR0RzNXFXN2srM2Iv?=
 =?utf-8?B?RGczRkJ2K0lXTU9wYVV6Q3dHemlRR0RNaXdzV1RhYnYxZjNYUmJqVkpUTkdB?=
 =?utf-8?B?NTlTeUtSZE5yR0xlYTFWYjhiZVFOUkVSRC9QSTk4K1FDMlloQ25WWkRRaW00?=
 =?utf-8?B?aUpDZXNWRnl4Qlcxb01nZlNna0dvaElvYitTSzYvV053cVhrQ0hTYWdacnRJ?=
 =?utf-8?B?Rm8vb0dKd0poWWgxSGpOb1FBaHJybGM5NHkrVlpHVHBKanl4REZxQThOTUtL?=
 =?utf-8?B?aG52SlFiaS9FUFp2ak56UXVsR2tVY2orNzNoKytORUtPQ3ROVmxidjRVMXZC?=
 =?utf-8?Q?DxnKXx88V09QVSYMV4e3YC5dI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7cfc9b2-40b8-407a-5dab-08db193472aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 02:35:25.5349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N/6ExNqZrLgGWUPori/Jn1FPkO1RLiTcOvYhk7vQ6pXyV53eZBljwQJVz2wrH5GNAirK2440hIPgRTlV0V9hYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5445
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUdWVzZGF5
LCBGZWJydWFyeSAyOCwgMjAyMyAyOjMwIEFNDQo+DQo+IE9uIE1vbiwgRmViIDI3LCAyMDIzIGF0
IDAzOjExOjI2QU0gLTA4MDAsIFlpIExpdSB3cm90ZToNCj4gPiBGb3IgdGhlIGRldmljZSBmZCBv
cGVuZWQgZnJvbSBjZGV2LCB1c2Vyc3BhY2UgbmVlZHMgdG8gYmluZCBpdCB0byBhbg0KPiA+IGlv
bW11ZmQgYW5kIGF0dGFjaCBpdCB0byBJT0FTIG1hbmFnZWQgYnkgaW9tbXVmZC4gV2l0aCBzdWNo
DQo+IG9wZXJhdGlvbnMsDQo+ID4gdXNlcnNwYWNlIGNhbiBzZXQgdXAgYSBzZWN1cmUgRE1BIGNv
bnRleHQgYW5kIGhlbmNlIGFjY2VzcyBkZXZpY2UuDQo+ID4NCj4gPiBUaGlzIGNoYW5nZXMgdGhl
IGV4aXN0aW5nIHZmaW9faW9tbXVmZF9iaW5kKCkgdG8gYWNjZXB0IGEgcHRfaWQgcG9pbnRlcg0K
PiA+IGFzIGFuIG9wdGlvbmFsIGlucHV0LCBhbmQgYWxzbyBhbiBkZXZfaWQgcG9pbnRlciB0byBz
ZWxlY3RpdmVseSByZXR1cm4NCj4gPiB0aGUgZGV2X2lkIHRvIHByZXBhcmUgZm9yIGFkZGluZyBi
aW5kX2lvbW11ZmQgaW9jdGwsIHdoaWNoIGRvZXMgdGhlIGJpbmQNCj4gPiBmaXJzdCBhbmQgdGhl
biBhdHRhY2ggSU9BUy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlpIExpdSA8eWkubC5saXVA
aW50ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVs
LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy92ZmlvL2dyb3VwLmMgICAgIHwgMTcgKysrKysr
KysrKysrKystLS0NCj4gPiAgZHJpdmVycy92ZmlvL2lvbW11ZmQuYyAgIHwgMjEgKysrKysrKysr
LS0tLS0tLS0tLS0tDQo+ID4gIGRyaXZlcnMvdmZpby92ZmlvLmggICAgICB8ICA5ICsrKysrKy0t
LQ0KPiA+ICBkcml2ZXJzL3ZmaW8vdmZpb19tYWluLmMgfCAxMCArKysrKystLS0tDQo+ID4gIDQg
ZmlsZXMgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRpb25zKC0pDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL2dyb3VwLmMgYi9kcml2ZXJzL3ZmaW8vZ3JvdXAu
Yw0KPiA+IGluZGV4IGQ4NzcxZDU4NWNiMS4uZTQ0MjMyNTUxNDQ4IDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvdmZpby9ncm91cC5jDQo+ID4gKysrIGIvZHJpdmVycy92ZmlvL2dyb3VwLmMNCj4g
PiBAQCAtMTY5LDYgKzE2OSw3IEBAIHN0YXRpYyB2b2lkDQo+IHZmaW9fZGV2aWNlX2dyb3VwX2dl
dF9rdm1fc2FmZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSkNCj4gPiAgc3RhdGljIGludCB2
ZmlvX2RldmljZV9ncm91cF9vcGVuKHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICpkZikNCj4gPiAg
ew0KPiA+ICAJc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UgPSBkZi0+ZGV2aWNlOw0KPiA+ICsJ
dTMyIGlvYXNfaWQ7DQo+ID4gIAlpbnQgcmV0Ow0KPiA+DQo+ID4gIAltdXRleF9sb2NrKCZkZXZp
Y2UtPmdyb3VwLT5ncm91cF9sb2NrKTsNCj4gPiBAQCAtMTc3LDYgKzE3OCwxMyBAQCBzdGF0aWMg
aW50IHZmaW9fZGV2aWNlX2dyb3VwX29wZW4oc3RydWN0DQo+IHZmaW9fZGV2aWNlX2ZpbGUgKmRm
KQ0KPiA+ICAJCWdvdG8gb3V0X3VubG9jazsNCj4gPiAgCX0NCj4gPg0KPiA+ICsJaWYgKGRldmlj
ZS0+Z3JvdXAtPmlvbW11ZmQpIHsNCj4gPiArCQlyZXQgPSBpb21tdWZkX3ZmaW9fY29tcGF0X2lv
YXNfaWQoZGV2aWNlLT5ncm91cC0NCj4gPmlvbW11ZmQsDQo+ID4gKwkJCQkJCSAgJmlvYXNfaWQp
Ow0KPiA+ICsJCWlmIChyZXQpDQo+ID4gKwkJCWdvdG8gb3V0X3VubG9jazsNCj4gPiArCX0NCj4g
DQo+IEkgZG9uJ3QgcmVhbGx5IGxpa2UgdGhpcyBiZWluZyBtb3ZlZCBvdXQgb2YgaW9tbXVmZC5j
DQo+IA0KPiBQYXNzIGluIGEgTlVMTCBwdF9pZCBhbmQgdGhlIGRvIHNvbWUNCj4gDQo+ID4gLWlu
dCB2ZmlvX2lvbW11ZmRfYmluZChzdHJ1Y3QgdmZpb19kZXZpY2UgKnZkZXYsIHN0cnVjdCBpb21t
dWZkX2N0eA0KPiAqaWN0eCkNCj4gPiAraW50IHZmaW9faW9tbXVmZF9iaW5kKHN0cnVjdCB2Zmlv
X2RldmljZSAqdmRldiwgc3RydWN0IGlvbW11ZmRfY3R4DQo+ICppY3R4LA0KPiA+ICsJCSAgICAg
IHUzMiAqZGV2X2lkLCB1MzIgKnB0X2lkKQ0KPiA+ICB7DQo+ID4gLQl1MzIgaW9hc19pZDsNCj4g
PiAgCXUzMiBkZXZpY2VfaWQ7DQo+ID4gIAlpbnQgcmV0Ow0KPiA+DQo+ID4gQEAgLTI5LDE3ICsy
OSwxNCBAQCBpbnQgdmZpb19pb21tdWZkX2JpbmQoc3RydWN0IHZmaW9fZGV2aWNlICp2ZGV2LA0K
PiBzdHJ1Y3QgaW9tbXVmZF9jdHggKmljdHgpDQo+ID4gIAlpZiAocmV0KQ0KPiA+ICAJCXJldHVy
biByZXQ7DQo+ID4NCj4gPiAtCXJldCA9IGlvbW11ZmRfdmZpb19jb21wYXRfaW9hc19pZChpY3R4
LCAmaW9hc19pZCk7DQo+ID4gLQlpZiAocmV0KQ0KPiA+IC0JCWdvdG8gZXJyX3VuYmluZDsNCj4g
DQo+ICAgaW9faW9tbXVmZF9iaW5kKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldiwgc3RydWN0IGlv
bW11ZmRfY3R4ICppY3R4LA0KPiAJCSAgICAgIHUzMiAqZGV2X2lkLCB1MzIgKnB0X2lkKQ0KPiB7
DQo+ICAgIHUzMiB0bXBfcHRfaWQ7DQo+ICAgIGlmICghcHRfaWQpIHsNCj4gICAgICAgIHB0X2lk
ID0gJnRtcF9wdF9pZDsNCj4gICAgICAgIHJldCA9IGlvbW11ZmRfdmZpb19jb21wYXRfaW9hc19p
ZChpY3R4LCBwdF9pZCk7DQo+ICAgICAgICBpZiAocmV0KQ0KPiAJCWdvdG8gZXJyX3VuYmluZDsN
Cj4gDQo+ICAgIH0NCj4gDQo+IFRvIGhhbmRsZSBpdA0KPiANCj4gQW5kIHRoZSBjb21taXQgbWVz
c2FnZSBpcyBzb3J0IG9mIG91dCBvZiBzeW5jIHdpdGggdGhlIHBhdGNoLCBtb3JlIGxpa2U6DQo+
IA0KPiB2ZmlvOiBQYXNzIHRoZSBwdF9pZCBhcyBhbiBhcmd1bWVudCB0byB2ZmlvX2lvbW11ZmRf
YmluZCgpDQo+IA0KPiBUbyBzdXBwb3J0IGJpbmRpbmcgdGhlIGNkZXYgdGhlIHB0X2lkIG11c3Qg
Y29tZSBmcm9tIHVzZXJzcGFjZSBpbnN0ZWFkDQo+IG9mIGJlaW5nIGZvcmNlZCB0byB0aGUgY29t
cGF0X2lvYXNfaWQuDQo+IA0KDQpHb3QgaXQuIG5vdCBvbmx5IHB0X2lkLCBhbHNvIGRldl9pZC4g
8J+Yig0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
