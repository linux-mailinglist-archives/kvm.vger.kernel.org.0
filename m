Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E84A6EF786
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 17:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241200AbjDZPIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 11:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240717AbjDZPIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 11:08:47 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C56ED;
        Wed, 26 Apr 2023 08:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682521725; x=1714057725;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DmEvg76vUdcKKBRi5Sm6XEPzG/JNctVpIB+ydqAcV48=;
  b=KBNevS2Bdl0/rTPKHz6HNmDLoVyJSWVTmUTkY4Bo8G/JzyfNY1k5T0X3
   zb1AYWTynCDfp37scwmT3Nwn7sUERPvlbHll7SjiJ51E8ayB86CN7EDIm
   9NItXXNy4gAVFzn+AcrCqtI65ojSO2yPNA7DA7lewAfyp5J0SaDwLKRlP
   6Vf/GGwSssUUilnGdg44py/+SLqIUZbiAIUF2fhIvPS82jV/Jm8DZEylo
   z5pMlRYMksXCICqYOg9mBQrHCQM8Tf5VqEHFYIQRyJBxuN9NhnRxDilTv
   DQVmhWjcG9WHRPkfGqHpMgOwOsF1IMzTMDXV2LyI5iLdEwsQrMAsuxzMV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="347156615"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="347156615"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 08:08:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="818147300"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="818147300"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 26 Apr 2023 08:08:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 08:08:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 08:08:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 08:08:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 08:08:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I38tKyN5R1Zusy3eaWJMceOZgEvZXlU3S9Oyy8XVe53ezPA9nXxCu2JJOvP3KprZEIg1lP5tHz4XrR5H5BrIuMjR4+AE2Mt32PiYj2xEmujoBPI12UD3zwcDmjJHP+Ga8ESJM+jVGVlqg5mEjRWOhW/N4xVpAx33zn6dR2v5R+LZX+T9dzOXWzKwEja5pPXdo4L0/cjxdSBLVeSI0a2Q2f/pn3FhcQuEoRs2J1z1f/7wkmpNJftynqHkZ9SzJg6jzw0w8yfwYa74N7hIed5zFrWTgY+eB1vCt15pgg92MpoqsarqdjUq8uvuz0cXZsRuBRBv0jjlzutxlqx3bt5kNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmEvg76vUdcKKBRi5Sm6XEPzG/JNctVpIB+ydqAcV48=;
 b=gAQVXIt4uLzarKcw5Fgj4atI0oTkIMUVqZ5eIyvO8/F32qNgn/7CU11d3+ZT4C1o1eHILz3vkRoRaN+yMQ9oC6omDHw9Rnu0R9C2Va/tPm6YDeI5acheuxCwl+NhldLf3mnuLfG1nv/qNMObO98+Ayz5tfp1aDSfLip6nNSCf1OX2ZFFSpWAVzrU7c3liy3BaxIof5bV09bcODL19cGFqE/8/Cj7KjU9Iw2vn6vuJBanybsIfu1jUkXkrghmeE8suRI2l9saiezOSffGjLH7n8uT9asAClBybcSdxKMG2XXQWFZ/6WzskIZyKv9BG5rQ7Zq7P9YePhlMWVjrzxcQUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Wed, 26 Apr
 2023 15:08:42 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::c421:2c78:b19b:f054]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::c421:2c78:b19b:f054%7]) with mapi id 15.20.6319.034; Wed, 26 Apr 2023
 15:08:42 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAM6MAIAAOT6AgABpLgCAAPyoAIAAA7kQgACCLICAA9TGQIABATgAgAAIdQCAAAm2AIABGm0AgABffwCAArUGYIAAJAOAgAj7bjCAAGUPAIAAHeIA
Date:   Wed, 26 Apr 2023 15:08:41 +0000
Message-ID: <SN7PR11MB75407B73858A0B796DB948CAC3659@SN7PR11MB7540.namprd11.prod.outlook.com>
References: <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230414111043.40c15dde.alex.williamson@redhat.com>
        <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230417130140.1b68082e.alex.williamson@redhat.com>
        <ZD2erN3nKbnyqei9@nvidia.com>
        <20230417140642.650fc165.alex.williamson@redhat.com>
        <ZD6TvA+9oI0v4vC2@nvidia.com>
        <20230418123920.5d92f402.alex.williamson@redhat.com>
        <DS0PR11MB7529C11E11F187D7BD88C18AC3639@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230420080839.652732dc.alex.williamson@redhat.com>
        <DS0PR11MB75298CDC8108BA213243DBB8C3659@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230426072020.62834ac6.alex.williamson@redhat.com>
In-Reply-To: <20230426072020.62834ac6.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB7540:EE_|IA1PR11MB7773:EE_
x-ms-office365-filtering-correlation-id: 70f59c22-541e-489c-7f20-08db46681f4b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u0MaRu3rXBKpBFYpYbj1AzR5NPVX9eM2O/n6vmOwXPmpRuLGR39IvYCkfmXvhwAe9AW8w7QkrZWSK6JT3O3Q5XdpMi1RwbM6zCtpAw1pxF9brEN2B9P0CUCLoavqEwgqjuLEMvpMWSh2odKiw9WU/VelftkLcwbkwcB7vcIQtet48+51LAEHkUhYh1ynSv1nIPWvj857BmCngkaI/16lhklzTWRRWXsmTH6SziR09siKCoJFR5yPWv1VwxwhVUAKFtLleubw6A5BxIUq5ZlDybRA/wc6Vfs+f5zDpZpYl4mGse+6UO4OxNtcKrS2E+gWgi8SHPmI04htZgnXxdvrVL7LlexOFivgMiNLqsZjnBbIwY4ZX2Xy/lawBUoosmWIRWHc+i53s7ENsUW/a0Ps18hSvlHmxHTuyOoj74zp5DYkDZsDbtso3tpogBPqV2Q3UrrxPaKc3eYexaprM3gRNYniPrMqXn/HFh+WGnVDfIJ5+JVw552IGgMyDgR9FmDmLgeWz3Zf8hMyA4OzlA5jnBNoYnJ+6JkA/ovY+6r7SHrhQ1lW+qgZmAP4kLLQQOsrpSDFl/odDjjkwg6NJRfMZyscY/27/9EvvpMssuRfZHQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199021)(8936002)(38070700005)(54906003)(8676002)(478600001)(76116006)(55016003)(66476007)(66446008)(66946007)(6916009)(4326008)(66556008)(7416002)(122000001)(64756008)(82960400001)(41300700001)(316002)(38100700002)(2906002)(52536014)(86362001)(186003)(5660300002)(966005)(6506007)(26005)(33656002)(9686003)(7696005)(71200400001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGFnWnE2djJsc0kzU1RiZ3Z2OTkvYmRxdyt5bVpRRWdFR3kvOTNiMmtaRlhs?=
 =?utf-8?B?L0F2TSszdmlzejhUY29mYjlIU0dRUGFxbTM0cXZ0dHBOT01lbEd3K0VaYW9T?=
 =?utf-8?B?cW5ncWtyZVBoWkFWSnQ1QTl2ekpaQ284K3hkVmtWOUx3WHViTzhYcmsrTDB2?=
 =?utf-8?B?RmQyMUd6REswM1FDbDVodmZqK2dYd1N5c3Rrb3RuVVNtaEtrbDZJV01JRC9X?=
 =?utf-8?B?OHNtNnM1SGs3MkJmM29DYUVQajhrYWFMQXk3VG5HNjBTbFFqL3hVcG1kaGZY?=
 =?utf-8?B?NHZrU21CQlMrQTFoa3piL0ptdTJ1cVNyYXZYOTk4S25Idm5sYmluN0J6Wi9X?=
 =?utf-8?B?ajV0bWdqMVVvQkFGalY0QXFnUzlnRjhZTmNhRUx5TGh1ZHJvVDQxdm5zQmZx?=
 =?utf-8?B?bmhyckM4VWExUVFFb1I5a0xJeUdkSHg3WWF2S0ZYdFlhQUtnV2xvbEVGdmR0?=
 =?utf-8?B?Uzk2ZzllZXpjYzhSNmJ2SkE3VVRLSU1vWUVxQUttRHdJYjNWblNmSXorb2R0?=
 =?utf-8?B?RU1qUTY4MnhDQ2VUT1Nwa01wTkxQelFqc0FacW9xaUx3bGQ3OGltM1hCZHRp?=
 =?utf-8?B?Z251SHlJMW9UM0NyZEFZSCtpUm5FZWtIWVJnQkVxNUpCZS92SXF1aUZGbURS?=
 =?utf-8?B?elV0Y0Y0THhKK01tdm1xWWtzRitVTVh3RTJJQzlRN0w0YjlwYXAxMWc2eG82?=
 =?utf-8?B?Znp0U052UG5YUGZsTzZMcElLUTk2TEFDRUszdi9sbVJGYkhoaklTNGc1ZFpF?=
 =?utf-8?B?Q3FadFRKNjU0bUVSTlpqQ1JEckhReGQ4RlVHanlHQlZvSzc4WjJZREg2ZW9G?=
 =?utf-8?B?K0N4anN3TmhScU1FaUgxQzErTy9FMW1RTE5IVCtFYVJrWk5BdGFIUjR6eDhE?=
 =?utf-8?B?RkFVMEsySGxkSzM1NUkzM1BBaGlSQU9DdGVSdW5sME0xN0xDdUc0cHp4M2du?=
 =?utf-8?B?T29tOWVDaW9BNytzY3VPbk12cllYdzFoNzEwNWx5OVRWaCtSMk5QNXhBNHV0?=
 =?utf-8?B?UVVZY0VycnNmd0JyOGpybFVUMFI5eGlvUG5kMm51cER4TkR5N0pxYm9ZbGZI?=
 =?utf-8?B?YU1FaFErWk1qS2tiTCs2bVZXODZHVGhtZStTUFB0cnJ0bnpITG5hK3FCT0ND?=
 =?utf-8?B?U1Q2OEVZc3I1VVNOa2d3TlhlQU9XWVVlQ01VTGx5MEhNUWVvTVY4RGhkSENj?=
 =?utf-8?B?RmozMWJjbUNSbXRsSThNQ0s3SmhEZ0pBNXBqbk5kMGNPcGtuVk5PaFNmV3hR?=
 =?utf-8?B?a2ZjbjlKYnNQT0VwU0J4cTEyNjg4akozOWJLWmg0T2ZsS2lIaWw4NGttQUtn?=
 =?utf-8?B?TytFVGRsdkM1dXdQK0RsdEd0MEFQNy9vNjRoTW51N1hObnZ0T0lpcGlnR3o4?=
 =?utf-8?B?U3QzRzhGWS93QjZpNU5vSzgwSDJaT3EwQ1U4aEhIYzBIVURRT2xZTGk1THVw?=
 =?utf-8?B?Sy9KZVp1clBCdWhyZ0JCOThtSW1xR21EVktvbE12Y2x0SjhGR2cxOGk1Myt2?=
 =?utf-8?B?c3RzODFvVEswSFpmTDFSZ1E5REhPZkhFRlJIYzVHemcxRjZJTURhTGYzYnlt?=
 =?utf-8?B?M01KME9paUJnZDQ1Z1AzWUhlY3B5ekVxNEFrMzQrQjNYY25yd2pkV1FwckU3?=
 =?utf-8?B?VFQxRlZmODhValJUcmMyLzIyNkZEWEZIY2NScjlKTXNOQTJCSUdTbWlDM1hK?=
 =?utf-8?B?WHR3YUp3NTBJN3RqUkhDZ0ZNVU01QmlWMTVHemRYd0FRc1diN3JMS1pyaEJY?=
 =?utf-8?B?VERLSWUyRFFYL2M5UC8vMDEwU1ZzT0E4UDFxN1htc0kwUUJhL2VTYzhuRXNM?=
 =?utf-8?B?WlBRUm1CQXZKTFBLWEJGODdCM2hXdzU0LzdyNHFGL0JqNVZKb01kbUE5S2l3?=
 =?utf-8?B?bXFhcnRyZVVLVE1QcUhDNjRXQlFjK3lRY0p6bEIyYVF4M29FcjFvazU5OUVa?=
 =?utf-8?B?a0JlVUdZcEtGcSsyR3QxaHhRZmVaaGNZK21idFZ5WklFT0ZkYlFnZzIvdE9R?=
 =?utf-8?B?am81WDB0ZHhNdFBBOHZzUUxHTHhCazdocUExVURpNVE5aHhtbjR3NkVSalN2?=
 =?utf-8?B?QzIxck4yQzE4dFF1cklvMlU0djhKRG9DaFdzZmNmSUpvVkFqRi9rOGdVRTlX?=
 =?utf-8?Q?15CLfIL3FmoqZsoJ0+7hOPltS?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70f59c22-541e-489c-7f20-08db46681f4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 15:08:41.8406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OeZauv7vNJNS8f3/YN9aRwSFLQ/VcZhpT20/IQRXZOV4qgl54EexZ3bamNpN7zHZuUdfb/WOCPnEfjLlsk8PzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7773
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIEFwcmlsIDI2LCAyMDIzIDk6MjAgUE0NCj4gDQo+IE9uIFdlZCwgMjYg
QXByIDIwMjMgMDc6MjI6MTcgKzAwMDANCj4gIkxpdSwgWWkgTCIgPHlpLmwubGl1QGludGVsLmNv
bT4gd3JvdGU6DQo+IA0KPiA+ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1z
b25AcmVkaGF0LmNvbT4NCj4gPiA+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAyMCwgMjAyMyAxMDow
OSBQTQ0KPiA+IFsuLi5dDQo+ID4gPiA+ID4gV2hlcmVhcyBkZXYtaWQgPCAwDQo+ID4gPiA+ID4g
KD09IC0xKSBpcyBhbiBhZmZlY3RlZCBkZXZpY2Ugd2hpY2ggcHJldmVudHMgaG90LXJlc2V0LCBl
eC4gYW4gdW4tb3duZWQNCj4gPiA+ID4gPiBkZXZpY2UsIGRldmljZSBjb25maWd1cmVkIHdpdGhp
biBhIGRpZmZlcmVudCBpb21tdWZkX2N0eCwgb3IgZGV2aWNlDQo+ID4gPiA+ID4gb3BlbmVkIG91
dHNpZGUgb2YgdGhlIHZmaW8gY2RldiBBUEkuIiAgSXMgdGhhdCBhYm91dCByaWdodD8gIFRoYW5r
cywNCj4gPiA+ID4NCj4gPiA+ID4gRG8geW91IG1lYW4gdG8gaGF2ZSBzZXBhcmF0ZSBlcnItY29k
ZSBmb3IgdGhlIHRocmVlIHBvc3NpYmlsaXRpZXM/IEFzDQo+ID4gPiA+IHRoZSBkZXZpZCBpcyBn
ZW5lcmF0ZWQgYnkgaW9tbXVmZCBhbmQgaXQgaXMgdTMyLiBJJ20gbm90IHN1cmUgaWYgd2UgY2Fu
DQo+ID4gPiA+IGhhdmUgc3VjaCBlcnItY29kZSBkZWZpbml0aW9uIHdpdGhvdXQgcmVzZXJ2aW5n
IHNvbWUgaWRzIGluIGlvbW11ZmQuDQo+ID4gPg0KPiA+ID4gWWVzLCBpZiB3ZSdyZSBnb2luZyB0
byByZXBvcnQgdGhlIGZ1bGwgZGV2LXNldCwgSSB0aGluayB3ZSBuZWVkIGF0DQo+ID4gPiBsZWFz
dCB0d28gdW5pcXVlIGVycm9yIGNvZGVzIG9yIGVsc2UgdGhlIHVzZXIgaGFzIG5vIHdheSB0byBk
ZXRlcm1pbmUNCj4gPiA+IHRoZSBzdWJzZXQgb2YgaW52YWxpZCBkZXYtaWRzIHdoaWNoIGJsb2Nr
IHRoZSByZXNldC4gIEkgdGhpbmsgSmFzb24gaXMNCj4gPiA+IHByb3Bvc2luZyB0aGUgc2V0IG9m
IHZhbGlkIGRldi1pZHMgYXJlID4wLCBhIGRldi1pZCBvZiB6ZXJvIGluZGljYXRlcw0KPiA+ID4g
c29tZSBmb3JtIG9mIG5vbi1ibG9ja2luZywgd2hpbGUgPDAgKG9yIG1heWJlIHNwZWNpZmljYWxs
eSAtMSkNCj4gPiA+IGluZGljYXRlcyBhIGJsb2NraW5nIGRldmljZS4gIEkgd2FzIHRyeWluZyB0
byBnZXQgY29uc2Vuc3VzIG9uIGEgZm9ybWFsDQo+ID4gPiBkZWZpbml0aW9uIG9mIGVhY2ggb2Yg
dGhvc2UgZXJyb3IgY29kZXMgaW4gbXkgcHJldmlvdXMgcmVwbHkuICBUaGFua3MsDQo+ID4NCj4g
PiBTZWVtcyBsaWtlIFJFU0VUVEFCTEUgZmxhZyBpcyBub3QgbmVlZGVkIGlmIHdlIHJlcG9ydCAt
MSBmb3IgdGhlIGRldmljZXMNCj4gPiB0aGF0IGJsb2NrIGhvdHJlc2V0LiBVc2Vyc3BhY2UgY2Fu
IGRlZHVjZSBpZiB0aGUgY2FsbGluZyBkZXZpY2UgaXMgcmVzZXR0YWJsZQ0KPiA+IG9yIG5vdCBi
eSBjaGVja2luZyBpZiB0aGVyZSBpcyBhbnkgLTEgaW4gdGhlIGFmZmVjdGVkIGRldmljZSBsaXN0
Lg0KPiANCj4gVGhlcmUgaXMgc29tZSByZWR1bmRhbmN5IHRoZXJlLCB5ZXMuICBHaXZlbiB0aGUg
ZGVzaXJlIGZvciBhIG51bGwgYXJyYXkNCj4gb24gdGhlIGFjdHVhbCByZXNldCBpb2N0bCBJIGFz
c3VtZWQgdGhlcmUgd291bGQgYWxzbyBiZSBhIGRlc2lyZSB0bw0KPiBzdHJlYW1saW5lIHRoZSBp
bmZvIGlvY3RsIHN1Y2ggdGhhdCB1c2Vyc3BhY2UgaXNuJ3QgcmVxdWlyZWQgdG8gcGFyc2UNCj4g
dGhlIHJldHVybiBhcnJheSwgZm9yIGV4YW1wbGUgbWF5YmUgdXNlcnNwYWNlIGlzbid0IHJlcXVp
cmVkIHRvIHBhc3MgYQ0KPiBmdWxsIGJ1ZmZlciBhbmQgY2FuIGdldCB0aGUgcmVzZXQgYXZhaWxh
YmlsaXR5IHN0YXR1cyBmcm9tIG9ubHkgdGhlDQo+IGhlYWRlci4gIE9mIGNvdXJzZSBpdCdzIHN0
aWxsIHRoZSByZXNwb25zaWJpbGl0eSBvZiB1c2Vyc3BhY2UgdG8ga25vdw0KPiB0aGUgZXh0ZW50
IG9mIHRoZSByZXNldC4gIFRoYW5rcywNCg0KSSBrZWVwIGl0IGFuZCBoYXMgc2VudCBhIHJlZnJl
c2hlZCB2ZXJzaW9uIGZvciBob3QtcmVzZXQuIPCfmIoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcva3ZtLzIwMjMwNDI2MTQ1NDE5LjQ1MDkyMi05LXlpLmwubGl1QGludGVsLmNvbS8NCg0KUmVn
YXJkcywNCllpIExpdQ0K
