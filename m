Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFB44D1491
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345789AbiCHKS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 05:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344149AbiCHKSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 05:18:54 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9531B7B3;
        Tue,  8 Mar 2022 02:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646734678; x=1678270678;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cSMnVrYlvpxkrYCwgs32Ul+P9AHD5a8urlUIl910pXk=;
  b=Czf0uZj6cgVazTh8gG7QH+2gj2BilODQQ4YOIH/arkKBQ235UgOOIk6W
   Fpgd/YjUUH1EcA6lExc2+p/9nXS5xywDCQwYeq0U4jW/Cp7Syk3EFfV1l
   U5NpKz6JvjAhFt0FteinPK5dbqTCsPPWfYdgB6DNrVRff3qJdbSbyTSYi
   QcPEd7G/Kk79/A8LCFV84uJIPBgRWAQhL68CHZGeX/Hcyl+8ZBnW0Ckli
   MkSaagC7rJDrmDDghxMmdlnYCPcMWRk51spDgo15AKzeTYcNVo/V5UwUH
   i1jUG/YBvYV4PgFU0lvbcaFLHoVuKg2nc2A/lYJp1G/IbxoMwVwvogb7e
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="235257474"
X-IronPort-AV: E=Sophos;i="5.90,164,1643702400"; 
   d="scan'208";a="235257474"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 02:17:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,164,1643702400"; 
   d="scan'208";a="495404723"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga003.jf.intel.com with ESMTP; 08 Mar 2022 02:17:57 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 02:17:57 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 02:17:57 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 8 Mar 2022 02:17:57 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 8 Mar 2022 02:17:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLbqoyV5qo41+45aBPqxhpojPOA3huIKMhHWonEhQp08kJ5FkfFaCO40pOzvzwUlTQ+zYjZAfK54pAaTb3wnKqpNeTQKr2jpOBR/eDuIfzqAg3jmrIqT3/cZ8HZIh0OZnx+RsF8CpLNiyGh4sSoeTfas040OetKK4q+XAam+FTEIAD9vx3j+ciB8vZ5YVQ3WtyH95HKHphNxcF5ZShASsx5GZ0hBmn8CCOOx6UP7Asdi6rKx3lZjty63Pe93yoi5fa6F665NERR6tqzvhSROotX99B1qPsKMxEGEGbk4t4uCddHxF4ZNY+vYpRS9QWHBjTFX4yQGRf8AQdd/FW7Aug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSMnVrYlvpxkrYCwgs32Ul+P9AHD5a8urlUIl910pXk=;
 b=ms+7tFkauBdURiuoi17no8K5LZYZp2640dBAdHyWjdKfdmz/D4CwmcRP9Ym+bIOJ7Ry+NSOEF4xBES3T4PG6ArM8MtQDmblFvWUU6IIRnmGKcVaEABLxD6J1Ac8yx19/ZEOE8HxdttuOz7gIp+D+hP6mcBHYOlvfOxluhzWLCfTP+C7KY6ZP0Z23jXl2YPKhI/nSeXMBc42v4x6Zrmue1OZB0XclA73XdAYo4WxoOKSu3hG78Zpz+DCysuqToYalfj/QUdB3zjGaE/HO9JofzcPwz67dVp6/nlmD2iOtygO/tzYPRPz9DpU9rLjVxdsP5n/f9sf2r0FsdBr1Z/Cdig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4695.namprd11.prod.outlook.com (2603:10b6:208:260::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 10:17:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 10:17:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYL1L4gR02rU84FUWBTBG9yRMgBqy1GrEQgAAaWACAABXr4A==
Date:   Tue, 8 Mar 2022 10:17:55 +0000
Message-ID: <BN9PR11MB5276DAD9B3C8B03F8B4921D88C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB527661103A2CFE13E4F3EC528C099@BN9PR11MB5276.namprd11.prod.outlook.com>
 <50b0d11d57d3488da809f318576466cd@huawei.com>
In-Reply-To: <50b0d11d57d3488da809f318576466cd@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b0a5399-7735-432a-c7a6-08da00ece953
x-ms-traffictypediagnostic: MN2PR11MB4695:EE_
x-microsoft-antispam-prvs: <MN2PR11MB4695980EC83A12AA07EDB1A68C099@MN2PR11MB4695.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YdMRko3HN8uFMuuRiZFXLcfySGySuZzI0I6jkETB34NeH3/+YZzSBk3rlAqurm1CSKtQE+iGvXQYkM9wiX3Hd1l3D1moW1yNl33HrSnndOSu/0DBg8ljZFKeLSFTijHceIrRNeTBUDywdtliIwi4CRyQpyJ9pdmIGvlqQzJEYhaj2dpy90A8AHPxEVsX4EKaSlwpuBKrsqEu38dUXDJqbySLR7VdiLkf9AKQ2Nl5NY1PnXeFwNg/mFbf2EZSCJ5lswdG17s7IKdz6ld6FTtz8lDFnm6lSTKBBvExAHumZwSBl75lVlsUW+tFaABE5z9lTkqVp0hq5YiVdm7uzoO0xFoCujwfuBRv7eJniXOyzp8SU+s6kcqhBO9+yniUst4oYel4vALa66xgfb9IfOvvQTWYtdP9Vm769UFdcb9Aj5XMr82JXTovxjfYGW6iZIWjPaMQ5Bsa7gURtVvci1uXrJZQOVh495ojw5iufGBMeG7EQL3K9oYYeA/25eJ+AH4/eB6RXuAuFe+4sp8yYod5xmyxtcRUzmMp0pa8nWpjB0IhL9I5ukP4nH1II4HcRcDTbo/je5+M68KFL043TmKbJUNVjASbNw24e2HShMgACPZ4Brx08yDdmxzT84LS90u8DhKnWtRTfgad8KPZbL4L68y2Ft+u2ol/3j555Mf4Mn3uvx+ceQrTUIKd2hWXaaAn9A3r7/q5zevN26fV41I97g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(55016003)(38100700002)(2906002)(110136005)(33656002)(54906003)(83380400001)(316002)(7416002)(38070700005)(5660300002)(82960400001)(71200400001)(9686003)(8936002)(508600001)(52536014)(122000001)(76116006)(86362001)(6506007)(66476007)(66946007)(7696005)(4326008)(8676002)(64756008)(66446008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEFDMGthRGVrSlJUZlVzamNvVGxpcmw2MEVOcHMrVjFtdm8xeHFYSHBENTdY?=
 =?utf-8?B?SjdtUGlqNGlEMjNGMTZhc3NYTWloNlI2Z2pDYUczUUk3NUpNdytnZW4yTUFx?=
 =?utf-8?B?VnQwelZsTjlzUnBzbURQOXYzcHJIK2xmRUJ2N3BpVUYvZktSWEg1QjAyL0tE?=
 =?utf-8?B?S09valJKUUUyYUFTTkxSZ1krN3c4ay9jYUliWGg3Y1NNRU10dlNpRTB1YUR6?=
 =?utf-8?B?TUVhL1NBRU9kL0dxL28xOGdUa3JqdkM5MHh4Z1BKV0svdndnSlM1QWxrTTU4?=
 =?utf-8?B?ZjFQQlI0eklXTzNsR041NjNHZjZkNVlZekVEYkwxd1JtV0FFK2VUTXd6cWRz?=
 =?utf-8?B?Nm5GM0VNSTBPa3ZvdUxpSlhhMFBKNVNXZDh3b2E5UmVvWE5pMVViQzVKMU9Z?=
 =?utf-8?B?eTNXYUtwc25PcVBwSkVuTVI2ZytjRXJHd0Z5SDhPQ2tmZ3JQZWdDblI2ci9O?=
 =?utf-8?B?U3JZckNjTDAvZkR6L3ZqK2hTRVlzaGVDRUNWMmNuak5vWEpVNUo4eUdwdDE2?=
 =?utf-8?B?Tk1VekV5bnZJZXRQT0dJekRVM0Z1Ni8rRXg4MmhkL3RNOWtOY3d3UDg4aFQ1?=
 =?utf-8?B?ektUQzhucklsc09TQmJ1YXRpU05zc0U2NVFjTGJsOGpYL1FON25wbWwvNEFn?=
 =?utf-8?B?Qi8yZ0hYbTdZUkl1ajhxbVVOTDl6QjZna1ZUajhQdHkvSEZnV0RBcnlFSjVx?=
 =?utf-8?B?YUV5blNRekFkN0hjOERSVHVYVmRDZTNzMGR1a1ZnSERPbG56RVFFVkxHMUJh?=
 =?utf-8?B?YkRsamR5UmRuamwwWnI3Q3lEZ094YUdQdVRVcjlqWm0rcmQ0WkxKYVZvWUsr?=
 =?utf-8?B?dDZLNUNwZDlrNjI4ekVBWU9ia3V0M3pKMSt6WHVTY1pOY1FSQm00ZXg1TFNm?=
 =?utf-8?B?akh4ZTF4RkI1NjlQN2pOWTAvOFpHSUY0a1M4Y3duTmoyTlg0alA3cWtBdFUy?=
 =?utf-8?B?MjNpZGU3c0RjVmsyKytMU3g4M0g5U1hpRDRoTEdHcm1iSDlhdnQ2TG9jVEph?=
 =?utf-8?B?L3BSOHpHUitLalJ4RERHbWYwelc5K3p1dUo2eWEvWFIrZFdjQkNHZXhYOCtI?=
 =?utf-8?B?cmMyMWxGQVExQzVwd21NbUg2elRRcjZHaGhKcitLcGI0Ym1CUjNYYmw5Qk9L?=
 =?utf-8?B?TDg4V1BjaTc5MGtMUWY2VFgzTnB5NVNPSk15anB3NHFDbEZiTGxtTC9oTE9v?=
 =?utf-8?B?b0JOTGpiU3krRkFhcUo1cnhia2Z3RCt4SGJIWG1VRXo0ZFRUclNqV3FRTmhZ?=
 =?utf-8?B?b2dTR3M5VGhCN1Rrai80eG55WThxODVaMjlGbUtSRnhEZzZuSytGc2xqZHNF?=
 =?utf-8?B?aVM1OVFsNTZ0MVdVUjVaUTVvcU9leUluaTFGTzIwVHJSL3JtRFdKVWZVclht?=
 =?utf-8?B?Y1hXS3VxMWg2NWdxWTR3b3FUa21UNk5TaUZkRFFya1lBcHVkcC9RRmNYVlpE?=
 =?utf-8?B?bVZFRElZbHo2Y292MTJubEx3eWYzSWxuRDkxd3duZnRsTzRyWFY3SmRSdjFn?=
 =?utf-8?B?OGZiTGV0THgrMjBaWjIvamJCODJDRWNDaG5CMGRHR2k1NnNXVkdaTnVwNHRo?=
 =?utf-8?B?SDA2TFV4ZGZwWTZQUzJSU21xb3VTSFZPQUVlQ3VrMVkzbGY1bFhYa0podlZC?=
 =?utf-8?B?eDM4bjF0dld1RTBtc0NGZ0VWa2todkdhOXhKM2ZDUm8rdlpjcmgyd1h6WkUz?=
 =?utf-8?B?Q2YzdlN5ZFB0cWkyMXlWS202dTVsN21QOUNhWTNRZ0V0UHBPcWU0VVJjOHdD?=
 =?utf-8?B?aWpYZllzZ25WaUJoTXZpb3NQTzYxeFd1MUJNRkZwT2tZVDM2YlFIenkvRTRv?=
 =?utf-8?B?ZU5BRy9hcCtURFphTTdCUTBGSCtnNkRIaUFQUzFCM3FBeFZHbk9ETjdsZDBH?=
 =?utf-8?B?emJ2czdHd1NMTHVPakZFS21zMDRWMGExZjhWQUdVMTdRNmhyMWRSbkZoNENB?=
 =?utf-8?B?QWhJV05OaUZVUG1vT2JEdDQwcTMxc05VYjhzeFJKT0JoU2JudXdJOGR3ODV3?=
 =?utf-8?B?NzE0anFnRHhJc080eVNIVU5mZUVKWGZBQnVaRFFjdEQ0cStBcmxIZ1pLT3JJ?=
 =?utf-8?B?cFVEaTJyR1ZRR3pLZXllWmlhbDh6VUJRajlVazZJNWx4cWRUdFVFT2RKV3o3?=
 =?utf-8?B?RWJqSkptc1lGbUp4d1lSMFdHZUVuUUY1VmN4SEZhMkFJSWh0N1prVG1KaG1R?=
 =?utf-8?B?WEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0a5399-7735-432a-c7a6-08da00ece953
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 10:17:55.2585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nwE9c5G+42yXFyMA1+5asdlet9zayto3BOdMVEG1Uj+mNt8OjBHUwiJh7PHHSbADytcw/CT1enK15WNKDqLlhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4695
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpDQo+IDxzaGFtZWVyYWxpLmtvbG90aHVt
LnRob2RpQGh1YXdlaS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDgsIDIwMjIgNDo1MyBQ
TQ0KPiA+ID4gKwkJfSBlbHNlIHsNCj4gPiA+ICsJCQlwY2lfd2FybihwZGV2LCAibWlncmF0aW9u
IHN1cHBvcnQgZmFpbGVkLCBjb250aW51ZQ0KPiA+ID4gd2l0aCBnZW5lcmljIGludGVyZmFjZVxu
Iik7DQo+ID4gPiArCQkJdmZpb19wY2lfY29yZV9pbml0X2RldmljZSgmaGlzaV9hY2NfdmRldi0N
Cj4gPiA+ID5jb3JlX2RldmljZSwgcGRldiwNCj4gPiA+ICsJCQkJCQkgICZoaXNpX2FjY192Zmlv
X3BjaV9vcHMpOw0KPiA+ID4gKwkJfQ0KPiA+DQo+ID4gVGhpcyBsb2dpYyBsb29rcyB3ZWlyZC4g
RWFybGllciB5b3Ugc3RhdGUgdGhhdCB0aGUgbWlncmF0aW9uIGNvbnRyb2wgcmVnaW9uDQo+IG11
c3QNCj4gPiBiZSBoaWRkZW4gZnJvbSB0aGUgdXNlcnNwYWNlIGFzIGEgc2VjdXJpdHkgcmVxdWly
ZW1lbnQsIGJ1dCBhYm92ZSBsb2dpYw0KPiByZWFkcw0KPiA+IGxpa2UgaWYgdGhlIGRyaXZlciBm
YWlscyB0byBpbml0aWFsaXplIG1pZ3JhdGlvbiBzdXBwb3J0IHRoZW4gd2UganVzdCBmYWxsIGJh
Y2sgdG8NCj4gdGhlDQo+ID4gZGVmYXVsdCBvcHMgd2hpY2ggZ3JhbnRzIHRoZSB1c2VyIHRoZSBm
dWxsIGFjY2VzcyB0byB0aGUgZW50aXJlIE1NSU8gYmFyLg0KPiANCj4gQXMgSSBleHBsYWluZWQg
cHJldmlvdXNseSB0aGUgcmlzayBvZiBleHBvc2luZyBtaWdyYXRpb24gQkFSIGlzIG9ubHkgbGlt
aXRlZCB0bw0KPiBtaWdyYXRpb24NCj4gdXNlIGNhc2UuIFNvIGlmIGZvciBzb21lIHJlYXNvbiB3
ZSBjYW4ndCBnZXQgdGhlIG1pZ3JhdGlvbiB3b3JraW5nLCB3ZQ0KPiBkZWZhdWx0IHRvIHRoZQ0K
PiBnZW5lcmljIHZmaW8tcGNpIGxpa2UgYmVoYXZpb3IuDQoNClllcywgYXMgbG9uZyBhcyB0aGVy
ZSBpcyBndWFyYW50ZWUgdGhhdCBleHBvc2luZyBzdWNoIHJlZ2lvbiBkb2Vzbid0IGFsbG93IA0K
dGhlIGd1ZXN0IHRvIGVzY2FwZSBhbnkgY29uZmlndXJhdGlvbiBlbmZvcmNlZCBieSB0aGUgUEYg
ZHJpdmVyLg0KDQo+IA0KPiA+DQo+ID4gPiArCX0gZWxzZSB7DQo+ID4gPiArCQl2ZmlvX3BjaV9j
b3JlX2luaXRfZGV2aWNlKCZoaXNpX2FjY192ZGV2LT5jb3JlX2RldmljZSwgcGRldiwNCj4gPiA+
ICsJCQkJCSAgJmhpc2lfYWNjX3ZmaW9fcGNpX29wcyk7DQo+ID4gPiArCX0NCj4gPg0KPiA+IElm
IHRoZSBoYXJkd2FyZSBpdHNlbGYgZG9lc24ndCBzdXBwb3J0IHRoZSBtaWdyYXRpb24gY2FwYWJp
bGl0eSwgY2FuIHdlIGp1c3QNCj4gPiBtb3ZlIGl0IG91dCBvZiB0aGUgaWQgdGFibGUgYW5kIGxl
dCB2ZmlvLXBjaSB0byBkcml2ZSBpdD8NCj4gPg0KPiAgQnV0IHRoZSBhYm92ZSBpcyBqdXN0IGxp
a2UgdmZpby1wY2kgZHJpdmluZyBpdCwgcmlnaHQ/DQo+IA0KDQpZZXMsIGVhcmxpZXIgSSB0aG91
Z2h0IHRoaXMgZHJpdmVyIG1heSBvbmx5IHdhbnQgdG8gZHJpdmUgZGV2aWNlcyB3aGljaA0Kc3Vw
cG9ydCBtaWdyYXRpb24gY2FwYWJpbGl0eS4gQnV0IG15IG9waW5pb24gb24gdGhpcyBpcyBub3Qg
c3Ryb25nDQphbmQgaGF2aW5nIGl0IGRyaXZlIGFsbCBhY2MgZGV2aWNlcyBpcyBub3QgaGFybWZ1
bCBhbnl3YXkuLi4NCg0KVGhhbmtzDQpLZXZpbg0K
