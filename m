Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B3C7082CF
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 15:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbjERNcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 09:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjERNc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 09:32:27 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF09EE;
        Thu, 18 May 2023 06:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684416732; x=1715952732;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B85OQKwcmh4lohMRyEDIos/pu/7p1eVyiAsnUEj90Jw=;
  b=WOhRzRBNioOVLgwiZTy2ptJqslqaUcVOn1A/MJJGb5mdkIxYP3tcuiBu
   uKzYsHh9wIP6ZAuuc4X6mGmYGYBhzg5XODeEbbgIq5BAJkjtaVvs2en/O
   kn1DceicY+1gGcffW9QJj9UQjX2t6CxsCDnscgrrvSV7vFLb9V747d/jK
   x1DbYGPBRLTg0S179OH/E0ORebm3YsKjf+d98tUwxP9sq0/8hB/TnATlp
   8ABXuMyC7qkmuGsMzzh6hTPfakOozqHAbI8PserHXppPUUz+6nAZYw+bx
   NvAanTtQ7G/mNIH5Ah07sneo2y9XkwzJrbSQJhObqvfb6jjuOpXDF+M7h
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="352080934"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="352080934"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 06:31:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="876425066"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="876425066"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 18 May 2023 06:31:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 06:31:51 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 06:31:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 06:31:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 06:31:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFGdXLoT98zBunCtU99w9R3XCPdw55VlFV2/l01sGcxUr8yzwKbQ2qzbxbP+PHnjkHBQ2zrlwC9Dsm2jEPYJAuY4CVIJ/IIdO7Ftex7jnl6hZb0heWrnGaPvYxjdwRciECA3M/N7QUPuMvg954KTc+YBWmXV3EROZg0r2SYV1TSOFcWUn1Ae1NyXtdpC6jTdeaWs71R+3kbBTGt6PuQM/X4CPxHo4NTlt8sKeGWv5B4anA7TeTkWw9r58vH9z/gd6HKcFw4Vb6IDuPIyokTZE9MUf7epzN2Xqfqz+3mjwfldL6USNuCkd0xOrBy/ugK9nkHAlGsjvI02O0sCU/6xLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B85OQKwcmh4lohMRyEDIos/pu/7p1eVyiAsnUEj90Jw=;
 b=Oy0Caiac1vHX4c+TSyFDY1ZPxQ4REPSgJc9ldak6f0Kdu4lbyKsnTCmqgCe2sm9+YUlbG4C25BBMyzo80OdOvOeiMQeQ6U6W4wZ6Tn16U0OLfUq3Uvd0sd0Y4mUmLIV9/7tO8xrj6+6+ehW3UrvR0glMLF2ZhTRM02rlbO5rLiNuDp8nZoNs4QceQKW0Aa5Qkqm1/BymmbURp2fsvbGPeictDfn+dWAzCpDz/ZCZaacbtXj0RuWkK4xRiKusQk+m1cFhD2CvTEjvzvGB+RE6TU2sDx+uwf38/JtjrQJSF0QOfcFsVvTYmVZbTNBhlI2jqqHxLkJjkMUbUEDzSsJB2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB6710.namprd11.prod.outlook.com (2603:10b6:806:25a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Thu, 18 May
 2023 13:31:48 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.017; Thu, 18 May 2023
 13:31:48 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v5 09/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Topic: [PATCH v5 09/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Index: AQHZhZ3jyYhqTyCeBkWxtZfhjn83dK9fCwqAgADzycCAAA7fwA==
Date:   Thu, 18 May 2023 13:31:47 +0000
Message-ID: <DS0PR11MB752951FE3826428345A6CF6DC37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-10-yi.l.liu@intel.com>
 <20230517160131.254be76b.alex.williamson@redhat.com>
 <DS0PR11MB75291457BBD647819B855DA0C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75291457BBD647819B855DA0C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB6710:EE_
x-ms-office365-filtering-correlation-id: 16127fd1-2222-4158-b96f-08db57a43b00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3rACqx+accsKIb9gGwJg00lUqwquIaEWH1YAODAosZSOP7ei9g9I2RvZg9U/inIBWLse04ocnhaBIFu8hijZ9UHuo+cZTBh/LQ1rYgu//1XWSxVDYwGGucBo0+mw3MCPLCo924SMcplXeGZj1Fw44TxgHNQLtEmG7XPybwadcojCj3mwxAa+3eR1MY1JfXgWwzFE3TsAfEpy33YrC1ls2hDy8yvM+abONjesvQCnqpvgh+r1tBv/a4k4E02wioVacv8aog+1fzfK4FI2hPDJxAOuOdihDsoFxUv795Dke3bhBMgc3ssiJsPzcaD1XUE9VMx2zbUba5Ye/bBMWPKVqaAJEIfI+1Cc/xBnVkPeui6IX/aQNKsuwRnqa7TKvAfeJV0mcOUM+neUAEyGOAK5PMyc+4YJrQTdMBAW/sa3gFma505mODodatgQN8WzpQ2L7J1xFgre831j+j3u/njlKq0pvkyIq65dp4SVxWjQ5HP38uwywXroMmkys71mcXqyPSUMZB11GVWfXLxn7WRrkLqbhvxILZceiDWI2V7PI8EHK80L3OXqMjOUPsiVfRt30aJGS9CEI2/KRpUmw+0xlk0H7gO5tU+WU1HZ5+EidZy12LvdUbdr01unLSBNG5G1BJhF1VAkPlokC3zSX16qFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199021)(6506007)(9686003)(7696005)(478600001)(54906003)(71200400001)(186003)(66946007)(316002)(4326008)(4744005)(26005)(6916009)(66556008)(66446008)(5660300002)(8676002)(76116006)(66476007)(7416002)(52536014)(41300700001)(38100700002)(122000001)(64756008)(55016003)(82960400001)(8936002)(2940100002)(86362001)(38070700005)(33656002)(83380400001)(2906002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckVyeWNZZm1CejlNbW16Q1RqQ1ozUlRiM1MxYXBieHNzSXg3VURHaWNWbjJW?=
 =?utf-8?B?NWlQVW9na0tLN01DdDEzK09ULzFxVEZLMDBFbGVnblZMaW11WlRrM2RMa2ZY?=
 =?utf-8?B?OEh6ZVJReHYzY1pwY0xuSzBWM2NNZzB1RFF2bEh3WDJNcmFPSjA2MTgvakZP?=
 =?utf-8?B?bTk5UGg4NVFFZGxzM0pmL3ZUVmZoWnJ6KzJKaDkvOHBqMHBiQ0NLSHpzbXk0?=
 =?utf-8?B?Q09wdlc1NFRxZmhpUVk2Tkd1aFVOTFdRQzN5cUcwZmh2MnZldTd1K0JrVGFv?=
 =?utf-8?B?Mi9WWEM4OEQ3Nk1kUGxPbWp2OHR6RGVXa3V5WFhkQklZNXVLaHdVdEZCNnV0?=
 =?utf-8?B?SDdkQWt4T3NLcFBIVlFtSTRRUHhETlhiSzNQWkcya3BQOU1ER0FXUTFNTC9F?=
 =?utf-8?B?YzF6ZHRlVXo0bDhOTDRyd0R6QUZKUEVYVTBQWnd0OXllTG8yNmZDMC9Ya04w?=
 =?utf-8?B?SDl0OWk5QmE1VDE5aUd1YjFMNk9rb2xaM3g5dXdYcXllTmNDUks0SzVRYWZn?=
 =?utf-8?B?LzI5clNmTVhKZVVqeFZUSC9rWFBNNDlmUU9xOWVuUGJhb0RiQWxVc01CN2U2?=
 =?utf-8?B?YmNHV251eDlvWHZSVXJZNGt3b3k0TzN3VHgrSHF4ZnRUc0wyZTRHN2RHUGtH?=
 =?utf-8?B?eHVhc3JkYm9lSDNJUmVHZUhBeXBsNXRrU3pVYVVFMXRQYncwcjNQUVNZVnlN?=
 =?utf-8?B?ekhLK0d2YmZUVmp0R2YvKzNzckM5VGY1T3hlOGd6ai9BMGYxUVlscEF6QXJW?=
 =?utf-8?B?WDhoa2NiNXB3RUFJMEdwYXdIRU0vQjdrc2ZzaUE5MzVvajNQcUlGSU5QMVpU?=
 =?utf-8?B?Z2RnY0g2bUY2R0NhKzU2aHV2a1J0eXdnRmhVOWdKSzNCY2V1S2I5c29JVC9p?=
 =?utf-8?B?OWthN0E5bGluM3BzWWk5bjhyRFdXd3RMdEw2dUtwU1hlUUg3R0ovUFcvYzNy?=
 =?utf-8?B?WmFwWHp3RjNjazgvR3lWaXJZazd2QWY0dVlUdlBsSkhIdE45STFteFI4M2tF?=
 =?utf-8?B?YXYzWGZGK1dmU3gwVWZ2OG95TmliYVMvT2VzcUMyb2cvQkNyZFpFYnV3NnBa?=
 =?utf-8?B?WjhqVFNxYlQ4aHlqZXJyaXN0cllaSTNLT0Y4Z1dsQjQzQWtWNW1ic1YxVUYr?=
 =?utf-8?B?OWNVbm1HUG9lSVI5czVOZ1hKUkkwWjg0NER6aERSdmY0eDdJcTJxWUNUMUZL?=
 =?utf-8?B?YjhUSmE1a2FQSGhJU2thMTBxaktKVE4zOVhPUmxrWFVTUHhwdFEzb1dOZFNF?=
 =?utf-8?B?QTIrbGFGSnhoa3BybEx2RENWKzVFRklZU3dUeitLMTNKaVlkZDV3Tzc3R0pZ?=
 =?utf-8?B?SkFBREhPWnA5cnR1Rm1TeFVWUldGWUVkMkVrTUNYRGUvcXJCdkgxdTBXOTRH?=
 =?utf-8?B?MVc3NjYwbnR0N082dmV4bzlXbkp3OVl0MmVZeExhdCsvdXpsTEQxUG95U2gy?=
 =?utf-8?B?WmNBZTR4OFJ3UC80T0Z0Ym9jL1pJL2UvcUR0QTcrUHdlVm1jTzBqaUFJaHc4?=
 =?utf-8?B?K3YyeXRueDRDVnJnZXdUSVFCaEVBVzVhMDRsd1hzRk9GRVFkdHFsdjFkclBo?=
 =?utf-8?B?TzYxMlNKeVNXSlAvZzVHWjJ2d0ltRklrZ3lkaVlsbGF0bE9qSm5WSEJhTFdU?=
 =?utf-8?B?Y3phS3k4RE94QmJsSTdnVk1JVWo5UDlwNzRicDhwdytuRzhJK3ZNUE84a3k4?=
 =?utf-8?B?aW40MGRlUUs5UlFNTGw1Y0cwcEFjT1dKZGxEY1FJUUxUY3JDVEc0MFVxdmN4?=
 =?utf-8?B?MS9uV0ZtdTBuL2ZlV2g4aFZEL3JQN0F2cWhpenlNaDVNZy94UEZrbEJTRTRU?=
 =?utf-8?B?ZVZDdklPZUo3UlY2eHlNekRaOFdoOXhYUXVYSUVjUE9uUmVvWlNKb0VrMy8x?=
 =?utf-8?B?L2d0WFNmL0pZTmVkMnNpSkxXNzVPaEdpL0o5SXhsMU9pMzRpNndEVG9KT0JY?=
 =?utf-8?B?dGtmYldZN0RVQlcwNTgvSXpiV1JuNXlVNzlGenR6Skd5dFFiQm9QcmR1b3By?=
 =?utf-8?B?UWNaUnJ1R29WMU1OK0krZi91S2M1Z2cxanRMdXBiVkZOWVNSK094alVlcmFo?=
 =?utf-8?B?dzVacjZCNlA2OThwYldsZnFWQzNVUHdWRzRGYWRMenQ5blhqZlBUTUV5Qmdj?=
 =?utf-8?Q?RWAyGnv8gICVM3ZEYTYiNFJgj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16127fd1-2222-4158-b96f-08db57a43b00
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 13:31:47.8942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PLJpYGidwKsyHPYOeHNu43M9xlgtRV7bfAyP6Q9Du6ERH1uvCnL0/jW+4pFJA0vo1sri4G8RCUaJ9eIAdL2bDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6710
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

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXks
IE1heSAxOCwgMjAyMyA5OjIyIFBNDQo+IA0KPiA+IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxl
eC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gU2VudDogVGh1cnNkYXksIE1heSAxOCwgMjAy
MyA2OjAyIEFNDQo+ID4NCj4gPiBPbiBTYXQsIDEzIE1heSAyMDIzIDA2OjIxOjM1IC0wNzAwDQo+
ID4gWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+IHdyb3RlOg0KDQo+ID4NCj4gPiBzdGF0aWMg
aW50IHZmaW9faG90X3Jlc2V0X2RldmlkKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldiwNCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBpb21tdWZkX2N0eCAqaW9tbXVm
ZF9jdHgpDQo+ID4gew0KPiA+ICAgICAgICAgc3RydWN0IGlvbW11X2dyb3VwICpncm91cDsNCj4g
PiAgICAgICAgIGludCBkZXZpZDsNCj4gPg0KPiA+ICAgICAgICAgaWYgKCF2ZGV2KQ0KPiA+ICAg
ICAgICAgICAgICAgICByZXR1cm4gVkZJT19QQ0lfREVWSURfTk9UX09XTkVEOw0KPiA+DQo+ID4g
ICAgICAgICBpZiAodmZpb19pb21tdWZkX3BoeXNpY2FsX2ljdHgodmRldikgPT0gaW9tbXVmZF9j
dHgpDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiB2ZmlvX2lvbW11ZmRfcGh5c2ljYWxfZGV2
aWQodmRldik7DQoNCkRvIHdlIG5lZWQgdG8gY2hlY2sgdGhlIHJldHVybiBvZiB0aGlzIGhlbHBl
cj8gSXQgcmV0dXJucyAtRUlOVkFMDQp3aGVuIGlvbW11ZmRfYWNjZXNzIGFuZCBpb21tdWZkX2Rl
dmljZSBhcmUgYm90aCBudWxsLiBUaG91Z2gNCm5vdCBwb3NzaWJsZSBpbiB0aGlzIHBhdGguIElz
IGEgV0FSTl9PTiBuZWVkZWQgb3Igbm90Pw0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gPg0KPiA+
ICAgICAgICAgZ3JvdXAgPSBpb21tdV9ncm91cF9nZXQodmRldi0+ZGV2KTsNCj4gPiAgICAgICAg
IGlmICghZ3JvdXApDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiBWRklPX1BDSV9ERVZJRF9O
T1RfT1dORUQ7DQo+ID4NCj4gPiAgICAgICAgIGlmIChpb21tdWZkX2N0eF9oYXNfZ3JvdXAoaW9t
bXVmZF9jdHgsIGdyb3VwKSkNCj4gPiAgICAgICAgICAgICAgICAgZGV2aWQgPSBWRklPX1BDSV9E
RVZJRF9PV05FRDsNCj4gPg0KPiA+ICAgICAgICAgaW9tbXVfZ3JvdXBfcHV0KGdyb3VwKTsNCj4g
Pg0KPiA+ICAgICAgICAgcmV0dXJuIGRldmlkOw0KPiA+IH0NCg==
