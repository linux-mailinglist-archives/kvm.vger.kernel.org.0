Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1B26CB710
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 08:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjC1GXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 02:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbjC1GWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 02:22:17 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E645B40CD;
        Mon, 27 Mar 2023 23:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679984466; x=1711520466;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZoEU8qPzw7jovaX3tK1wksx9Gu7VpP+a0RZnaEe9MCE=;
  b=gVTXR/o+PPRnHYsw7SezQ6G6if0eLF/B46Xhs+XdaQ+bYGDIk9E2rA6F
   +WqiKgyXrz9uVMMeuXRIGGQ/w/r5dAshFhnXYg6m31KUjQclHaVJUQGp6
   NfB7zIu7w/1SPRdNYtZxihSPNJjltdcLWci6bD8lcCm71li28IDZvqxes
   txKgdW/EUGam5Xfe9MpQI85qV7nMIAuLQsotX11bI9cSOCgMckSLZAeJf
   UBvJZQqevSjamef5cJ9qG262BF2HJdiBe/FrI2EOaUR+J9tptuDVW6/sd
   1uYPpgrIex8iCfQAjkMkrmQ8Is4XScwogVYopT2EHtN0B64Esol4XocRp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="324377901"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="324377901"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 23:19:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="773017587"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="773017587"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Mar 2023 23:19:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 23:19:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 23:19:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 23:19:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 23:19:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqVo0GYU0oQdj2mOyIH33pLK5SeJYHBWhlS0YK9iykV2d2Gjo9fttK9KtCtJ166UQwR8icNaFpS/lGG0zcSLwKQjjQdbE3imjEBE7HQ3Z5vaglHxaLPR0FHw4NkAiaFYHzN4g8YWukIAao4UR3RsJIQdksQ16wcVY2veaP7Phpoj3bM7XzddyJPsHM4cbU5NnIjejCcRfzwJdVsyVzLCNrdZ11HH6HfhZNXYXPR+n/N8ZhUPpVWF8CQF1YFPeLeIUTfruzc2Ku9DJzqjZkVATl+rvMBoxl0Mivjsj9B4jPOiITXj5vf4Dq52ZPRl6RdO19BsBsfSvgeJt0+Q95EMjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZoEU8qPzw7jovaX3tK1wksx9Gu7VpP+a0RZnaEe9MCE=;
 b=Fws96c85WoWX4JmQSIiuIijhU1JOfUY2/klOumqaYNvyRhAr9+PymGxMgf6MKih7DF3my+9SoWYTBdAURisyRJB/Mdj3qr/uO7SpB55Fp6D2osiok0D13hLroVgX6XSF/fzjU0ppS9tBy/UK2rfaNl8zK2UV7HRsFbwqP4BfrjU+hgJku+wT5fMItDQK2xMHx2NgamPCVw+0rlgvTpfl+qi0wxVFCfsWlf8ua5/u61Hwf1P4dkFa9DQ69lPE3GlUTq01eeTAm9P6f3L2E4z56wSLaCMu4FT4gfbkgqlLt9nkCiM64phsuquAt4tvmGeBmo4c8RVRKtG2xawl2dVt3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by MW5PR11MB5788.namprd11.prod.outlook.com (2603:10b6:303:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 06:19:06 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::410d:f336:9014:8675]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::410d:f336:9014:8675%9]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 06:19:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
Thread-Index: AQHZYI92YoejP8gsuUepwiqB47+8d68PAuSAgACHvgCAAC35QA==
Date:   Tue, 28 Mar 2023 06:19:06 +0000
Message-ID: <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
 <20230327132619.5ab15440.alex.williamson@redhat.com>
 <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|MW5PR11MB5788:EE_
x-ms-office365-filtering-correlation-id: 3187e4cc-4e58-4697-d7b3-08db2f5455c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2fxr51pL5RZHiNT3/zGUYq+/cvESmJvoJpbeCbw10Nsqk/tH2mtHNGBi6himh59z2A6oT9CBAmBY+SYEmTJSCfXsgp4FDU21U0uQOqKnOqI+Kc9UTzcTwLrE/5LTpwjIVMyCXrmaI8t1eJKstAShGxHkHwOQSBsfw4W6XT7rdFzJ+W4UC2Kl7cMzuNV3NbEpJy9njWBFWopZ0ETDHiY49Xltf/WHEojsLEu+gYlf1LMsSoQALyIiVwV9o0OWedAXi2BA1NTpdzQpD9ezYbVTRrm5LyTJoEKw0Z/AJJvXsEmak8k7+XO/E3kpeSRMMU1UaMfQbTLEXDfdWMky609gOPFMJxuULv7IEMhwMNNBnsJJ2+mQILMktVpk/wh5HkOsWHWtPr2wO5Dyw8Jed3MdLUeW1gpmSBTLMVM3kmfao7rPokjjWyNeyBP0EmbQfrrLPghDz+P3/PMw/FUXOlYOQI22XbkCoqS+ulxj76kOX6y4LER7TYsNKECQlNLiTvkVWCFXyxvI44N2nBc4J1ZKkUl2jT07kP5e4i82XKJQA1hKXWzrdkOJ5N3yvWfwZwaQsJ/uRa1otc4KGRBLHhuhgdxuFY22NVh2nCnPVUMueD+BSUQ646zwavkvkHlbfF+Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199021)(9686003)(186003)(55016003)(41300700001)(82960400001)(4326008)(7696005)(26005)(6506007)(71200400001)(478600001)(64756008)(110136005)(316002)(54906003)(66446008)(76116006)(2906002)(7416002)(38100700002)(8676002)(4744005)(66556008)(66946007)(66476007)(33656002)(122000001)(38070700005)(52536014)(86362001)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0RMK1FneFRFRG1mRW5ZOFZIaHFZMlpSckV4YjI0Y2ZXKzJQNmxaOGMyV1N2?=
 =?utf-8?B?TGoyR0E5dGVKd3hkc2lRRHdpOTlubjArWUkvOG1nQXhsRi9uQ2NGTXcyaFpJ?=
 =?utf-8?B?N2Vodm43YmFVWWRmK1puWTlOSSt2U3FHcGxzSWpVaGxVbFN2aGhyM2VMOHhY?=
 =?utf-8?B?WGt6ckNkdE8wbXFtR1NnYzk0NHdWalY1c3pReXFaQm4wUWdlMGVyT3RzcHdm?=
 =?utf-8?B?d2NUc09zcUtjNXVCWXJFRVZiWkVoREg0Mis2QTNPb1BYVmJsN1F2UmVkZ3g4?=
 =?utf-8?B?dmpvUm0wRFNCSzluaE4zVWlKL3NKWTJjemQ1aEJ3MDRKVllFRndyMGR4cXBy?=
 =?utf-8?B?Z3pjVUFzK3BkQS9xSk9yVWtSSjhqbkxWbmluaDJBQks5WXJZdXlZWTI0Vkow?=
 =?utf-8?B?d0szNi9LYnZqUDFJL1p5d2pzd0lKZjBXVGhTTFNqLzljVHZYeW9mbjkyS3FF?=
 =?utf-8?B?NDJyVXNRcFFKUnVpVXJObTVXaVQvZ2xFZUM3VTJLZVZ4Y0VEUm95KzlRQkZr?=
 =?utf-8?B?S09LRzU1RmQ3eEt4UklyVHlKNUhTRUJXUWxIbG15bm5neGVIcjUweTlYamNm?=
 =?utf-8?B?dGpNcVZuRXdzcEJ5RE9HUk9aaCtxQVlVSGp1WWNhZ0dOVkZmeldJYytTWFlM?=
 =?utf-8?B?RnNVazV0a1kxMDZUZlpBOTZLekVTSlVERzlUazcySHVDUzc3ZUtSSnNUbHZi?=
 =?utf-8?B?VDk1MHJXY1ZWWWUvdWFXUlRkWmZXOFZRbk5MY3A0d0lIWmduajV5cHZJbnJ3?=
 =?utf-8?B?TFpmYjlpUm1iOGZoQjB2UEN1V0JZRFpUbXlWdmI2RS85c1NVU25aMTB4NWlZ?=
 =?utf-8?B?aUFjenJSWU9IV3pFRnNNOWFIMmNVZTB4OE96UiszUFpHa1AzbnlGeTgxVFhY?=
 =?utf-8?B?S0pEaDFIOHlDZ1cwK3hwZllIdjNmMnJYSk9mV085VDY5ZHgzWjE1ejN0b3ho?=
 =?utf-8?B?b1BJZXIzRXk4VVNsVFlFZzdOTmxPSXZjdndrWDFDZlY0L3haMGhsYk9ySGRK?=
 =?utf-8?B?a3NCZ25WejZGc1NUSUEyNGZVazhFekZPT2tuR0pXdWdCWWx4TUpnTHRQUW90?=
 =?utf-8?B?RVFYOXk2Y2tab1o1bG9pSEV1a3h5K0wvRnk3ak5UaXJlbVpuSmRYZE9tMkNi?=
 =?utf-8?B?U1NSbmx4S0dWUEhVcTZsekVqM2M0Njc4QWRQamlEWnJmbWlQeDBWV1Y1RVB1?=
 =?utf-8?B?VUxNWU8vOHhUcTh5V3pVNDJVZHVualhoSS9URHdwUlh6Y0RSeVg3SXdvZEdi?=
 =?utf-8?B?eGo4VE0vWTVjU29KMkxWWjBNZFRyWVYzTlFjTEJrMXpYSVN6S0Q3VWVaR0tP?=
 =?utf-8?B?bSs1ZTV2cFp3OHpBMUFpK1ZrdXZ4TUVMYTFYbnRzSzM0dklMWGFhS3RxKzhp?=
 =?utf-8?B?SHplSWRFZWQ4RGlOQ01XcGR5UUo4M3dVSFZ2cTFmdS9GWElYMkRKUnluN2tv?=
 =?utf-8?B?d3paSXJVYm5TbEtiTFRQVWFiclh2Yko5dENKUWhEbGF5TXJzVWxBWGw4dEtL?=
 =?utf-8?B?S3RFdnpQNVVWQ1pyc0lnSHQ0K2FZMVF1bkRjY0JrdnhWd0M3YlFvRUMyeUNr?=
 =?utf-8?B?Z3NnSnlSUXZhU3dZTUk4Sit2bmo3clVnRHZtL3QwRUtCV3o3Vkd4alplLzQ1?=
 =?utf-8?B?V3RCbDFqQUU3NmlrbEdBSTg5REorakVwUkIzbngvZk43Rk4wMHFta1NJRTY4?=
 =?utf-8?B?NFlIYzRHcGRhZ3NyQjVTM3BubVNMYzFNbmhXR1hGVURIZkR6TFVwa3U0c1Y2?=
 =?utf-8?B?OG1qS0ZkRHJtdHlQZmpEbmJoSHpsTFQwZ2FvM2V6MWNOYUk3NkNiQ29nUGxC?=
 =?utf-8?B?ckJ5MUx5MjlCamRLb0dkTFBQYW9yRFNkRWhaNXlIYnZoL3Bid2xKc2RsMWhP?=
 =?utf-8?B?cENvM3BaWmlmS3VWVy94b0hvd0h3NmtvcEpSOHJWTTRIR0o1M0V6QjYxTWVq?=
 =?utf-8?B?KzViV2Z0blE4QU5PelpCdVZBaS9rcU9ldmJlbVZnMU9lUUprYXZaNGRvWEtR?=
 =?utf-8?B?N3JrbVpRemtnNi9PbTNlcUlOWTFJeFhmSG03TXlrbFRmSmJzcGh4aTNBY0pq?=
 =?utf-8?B?V0tUSEg4eTdPcTUyODlXdHRHcWwyUEdCTVlZRE9kZXhONjJyWE9NekdoTGtu?=
 =?utf-8?Q?yKE74TWfzPx2yuNmvpry+6ccE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3187e4cc-4e58-4697-d7b3-08db2f5455c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 06:19:06.5493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7D/ZxueYfvysFQuyIhd9wPyXfmfqEW1tKRZjpHFuj7PaigfYpSFWdTB/iYbug0W1BPfunH9KLdQUDmrwQ8W4tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5788
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
TWFyY2ggMjgsIDIwMjMgMTE6MzIgQU0NCj4gDQo+ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxh
bGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPiBTZW50OiBUdWVzZGF5LCBNYXJjaCAyOCwg
MjAyMyAzOjI2IEFNDQo+ID4NCj4gPiBBZGRpdGlvbmFsbHksIFZGSU9fREVWSUNFX0dFVF9QQ0lf
SE9UX1JFU0VUX0lORk8gaGFzIGEgZmxhZ3MgYXJnIHRoYXQNCj4gPiBpc24ndCB1c2VkLCB3aHkg
ZG8gd2UgbmVlZCBhIG5ldyBpb2N0bCB2cyBkZWZpbmluZw0KPiA+IFZGSU9fUENJX0hPVF9SRVNF
VF9GTEFHX0lPTU1VRkRfREVWX0lELg0KPiANCj4gU3VyZS4gSSBjYW4gZm9sbG93IHRoaXMgc3Vn
Z2VzdGlvbi4gQlRXLiBJIGhhdmUgYSBkb3VidCBoZXJlLiBUaGlzIG5ldyBmbGFnDQo+IGlzIHNl
dCBieSB1c2VyLiBXaGF0IGlmIGluIHRoZSBmdXR1cmUga2VybmVsIGhhcyBuZXcgZXh0ZW5zaW9u
cyBhbmQgbmVlZHMNCj4gdG8gcmVwb3J0IHNvbWV0aGluZyBuZXcgdG8gdGhlIHVzZXIgYW5kIGFk
ZCBuZXcgZmxhZ3MgdG8gdGVsbCB1c2VyPyBTdWNoDQo+IGZsYWcgaXMgc2V0IGJ5IGtlcm5lbC4g
VGhlbiB0aGUgZmxhZ3MgZmllbGQgbWF5IGhhdmUgdHdvIGtpbmRzIG9mIGZsYWdzIChzb21lDQo+
IHNldCBieSB1c2VyIHdoaWxlIHNvbWUgc2V0IGJ5IGtlcm5lbCkuIFdpbGwgaXQgbWVzcyB1cCB0
aGUgZmxhZ3Mgc3BhY2U/DQo+IA0KDQpmbGFncyBpbiBhIEdFVF9JTkZPIGlvY3RsIGlzIGZvciBv
dXRwdXQuDQoNCmlmIHVzZXIgbmVlZHMgdG8gdXNlIGZsYWdzIGFzIGlucHV0IHRvIHNlbGVjdCBk
aWZmZXJlbnQgdHlwZSBvZiBpbmZvIHRoZW4gaXQgc2hvdWxkDQpiZSBzcGxpdCBpbnRvIG11bHRp
cGxlIEdFVF9JTkZPIGNtZHMuDQo=
