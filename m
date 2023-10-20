Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F7E7D091B
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376393AbjJTHBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376379AbjJTHBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:01:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F7998
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697785296; x=1729321296;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jqec4uRbDD+w7HMvq46v9B9QSVayMmUYKktdzl01gPk=;
  b=m53bG0h+UnDlPviM9/i6AAc3n9jKShsNA3jRLt79I4o2SNERpHI32LY2
   QgtSVn07UbGXkNyTsO4WsoMFOfxXvvVWHn9jUQKRMLJ8Y9TApivBx90q5
   iTroe84hiqvYX02Wfj9JDUcntN/H0wvtviEpK2L14atfO85AORCrlOqm9
   NoPFf+AjIrLEF5F/VRv9JYD883XOEKPc8zmtdeAyl23vrw0Xv92t6Ot6j
   V81QHdaXLGtE7kQUZCPzzPUvxys4OoG9t1zpMrPEHmxVfpTc4/F7RUUwo
   rG5+uKNJWMiEbNyCp5meTl4TzZZjsMSIlYJoVOKeGou29zgk04dOmuduX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="365782159"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="365782159"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 00:01:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="5018333"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 00:00:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 00:01:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 00:01:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 00:01:34 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 00:01:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7Ul37VN5fuNnqshqva7TH5NvAfSJ7iQGO+kjZGUh0VLolwXhB7H6wG1mKabLkhTFwvzcSJp1T1EXabo86xhOgYpSx4yTGjTPEcsWLCAaoWCEeRXKF077HcS67u3jgL4Q9fcNJClS2513evynq45QeDXJTqTKZXIBUS5ksAIgIj6Gb0+0DKqPetYCbg0HaaZQZdQDfyukDRrMIzPvHfwAkFx8FKmZi1oQU7Sc3+kUkZsTo7Lix/wDS+tGsBYBne91TdZlItaDM8KBqjuyGDyzKNlYQYhpVGMqHrz6SvAo0W8EARvMPK+9ujdcM5aFjyHT+hAoeeSA0Gdi6IjXtfvhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jqec4uRbDD+w7HMvq46v9B9QSVayMmUYKktdzl01gPk=;
 b=QEyEbCqeJOapyPNu/To+sFQDZq47UJwWQ8LKNejYaKpAXIrAZ1ri6M+t5v/AwEF45FeHnrYgXQ9PFPpJ1vpVOHPDUKjkL/5tSsOmSZd7FyoOFrF1TpvuIi9VJdKl7ckLUmydqBd89ypX4uyAjOVBF8yngYIKz0o7/9YUWuJHVa1ry1V22YZlnFWk0y6cphFJHB118uE1IvmLmyyvJULG4F6SVmg512z60blVbUxPqT8qvc7yGKgg4vyCJc3W8wTZ2nk/MJ+ovytGqPKA1QYanmH01p0kls5CSHnYXx99bo05LeJG3Lx+P06wc92cn6uCyWhSSFmsVWKrOiJv4Wt8Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7294.namprd11.prod.outlook.com (2603:10b6:208:429::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Fri, 20 Oct
 2023 07:01:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 07:01:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Thread-Topic: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Thread-Index: AQHaAgG2taJpKTjRzUO2OAVmEMRBxLBQLMCAgAASigCAAMPYgIAA8ScAgABOHhA=
Date:   Fri, 20 Oct 2023 07:01:31 +0000
Message-ID: <BN9PR11MB5276140F0D9816FD958618BB8CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
 <20231018231111.GP3952@nvidia.com>
 <2a8b0362-7185-4bca-ba06-e6a4f8de940b@oracle.com>
 <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
 <31612252-e6e1-4bfc-8b82-620e79422cbc@linux.intel.com>
In-Reply-To: <31612252-e6e1-4bfc-8b82-620e79422cbc@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7294:EE_
x-ms-office365-filtering-correlation-id: 947417b0-6838-4e00-7286-08dbd13a63da
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: paOhqwkUUSFHKq3i6LCASMnNVpWSwz46XzAwP1eO9OP8jdTE5flMiKlXuduz8JKW7LZeGM5CLwhq2JAvvbj321sARwPVlgNrhCsFwB+Bdnb76/UrcN30W4wzgYcF4J2tW/tG14mLTf8ovSNLdJ/m7jihpyoaHPRww2PI5NarCGN0jseS2ZQq57IC3aCpwt2wCV+MqHOEi6V0zlLIITgW1El0p207V3uWpNC4/MbYjNcF7/pzOie8WASQLr/WLxX6ZfShzLg1cHsES11oB0a+cWMxvWb/fCLM6gZ86UxyOnEPbGM/ZeL3Jmu6Cz5UXBZ25xx+InrknGoZXl05GL5jqWbXt9V5edOXVi76Adk1Rfu59ZborLnnjRbYT93peR/Q2TXKwXFhD7xSzh/KlXzntjuoc8doN+bFkiSojlDB6RQ9JitWL4a7PrpsPKnM8jnK0V/69VwtJjP8xcl0iiwUJC9AQon4eyWHXY8T0S7RnFflpZ/kAFh7LzNJnSKVWabUhRGRlPrKzSRh1My+fQ/kbi3XONjwKzg6Bxynd1Q5Gp2eIfnV3M2aRYPF49SxfdUJm7Wze6hFty7RgE26qmWoL0J9dIWi9YTTbagwigsjnTkpKm7KWS4/EeNV5NMpZVXkWXNe9jMEh1xEpSC17pCE9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(136003)(376002)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(38070700009)(55016003)(7696005)(6506007)(52536014)(53546011)(2906002)(71200400001)(83380400001)(5660300002)(26005)(33656002)(122000001)(82960400001)(38100700002)(9686003)(86362001)(7416002)(66446008)(8936002)(110136005)(66476007)(41300700001)(64756008)(4326008)(54906003)(76116006)(8676002)(66946007)(66556008)(316002)(478600001)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZC9HaEhsSGxkTExUc3JwWnB2cWFKbm1TdXVXZ3VYdTZleGFkOVdFZC93cVZP?=
 =?utf-8?B?eU9PWWN0MDJXR01zMDNBOEdzYzk4RFRGeTBMVDNDbmxiM09vSEo0eDZqWE04?=
 =?utf-8?B?VFBRdnBjR0N0bDdQaGc5aWpQbnJ3cFlXQlR0K0Rxb0RmenhMcE5CZTBHQWhG?=
 =?utf-8?B?Uk1WbUJWWjF0TGxXYVRvWEV1TWgvSy93RytvaENUSlM2Z0RUSW5FSnpaaWVL?=
 =?utf-8?B?M2hNL1I4MmlVOFoxdjk0YTBVRmdjOWkzNG9WMVZ0ODYzSjdKc2F1UGNVMnI2?=
 =?utf-8?B?bGx6eGIzeWVJZXphOWt0VjI0ZW82aFNOUzZmSDljWkpVYmdkS1JhQytSeGs3?=
 =?utf-8?B?VUh5Y0IyTXlWU3JaYmQ2K0hrc05DZDNNeUYrYjNHRi8xWXp2UFBPQWRhRXEw?=
 =?utf-8?B?MStDRDFxWUVtdXh6VzZhdjRVLzdaVUwvOXl1TjNta0hMYU55L09nSXVuRWR5?=
 =?utf-8?B?b3dXUitKeU1sTUNBZUtsSkYzLzZ6d3ZmSjNwbHh0SCtCV0xNTjl2emExOUJE?=
 =?utf-8?B?TUlWbUkveWJWamZDcWVZcmI1Uk02b1pGTTd3UGhraDBnbnJsZFNYZ0NlQVJR?=
 =?utf-8?B?VTdaSzYwT1JzeHdHL0FvNWNJTkh5eFZnUFRFdjhTU3NtZnJPYS9YTTQ5QmJU?=
 =?utf-8?B?bG5ZMTN5WjBzVlRwcUJjMmMxcE9heS9hR0N1cTBLYnROYWRlcnhaWjhybmRp?=
 =?utf-8?B?bm05aXp2MGY5YkJISkI2UUpkaGl2cDQ5bjFGdElCcXE4QThIZnkrRU53b2xl?=
 =?utf-8?B?NWlNTmhaVEtFVTF3ZERzeHhycDBtdCtiQjdSTHVQd05pOUdlVDBpUmlhWmRM?=
 =?utf-8?B?aUhXdDBVUW9ZNjJuVUJjaWo2UmxoWmUwL3BnQnhLQitrZDhsUlJ3OEVaOUQ1?=
 =?utf-8?B?czQ1SVppZjRrc2RhbFJvOWRTSWJNTk1RckIwTUhqWFhGTHhpTTQ4VEhGMEYz?=
 =?utf-8?B?UHRFVEFUK1dFUGVjREFqcUVMRDZYZFRCQVlUcXNjMytmS2lhbDVRWGRaUHAv?=
 =?utf-8?B?NmtjcGlPK3pDSDc5dVVQVkxDTVZJOVcrRXVybHpFLzdtb04yR3lYRGxpbkt3?=
 =?utf-8?B?VEdmc3ZUTnZ1VUM2cU13QXhTcElYSnpPMm1tMnQ5dFJZazErVExPVENrTHhR?=
 =?utf-8?B?T0l4OERuaG5ML3dKQnhENDdhbU1zZ2VGMmtZOU5RN0lhZmlXWTltVmh2dUZt?=
 =?utf-8?B?aGpqYURXdTNubkxkYlo3V0xQY3lxUEl2R3h2LzR5WFVSc2w5TlY1L3RxT3dS?=
 =?utf-8?B?ZDhDVENLK01GRU4yN0Nzb1M3dE1IY3BYckhwbFRoUlozRGhUWFZjZ0tDRUJT?=
 =?utf-8?B?bmVqTzJ6QWtBN0w4M24rMXJWM0kveWdyalIrR1BkenJpSmhzbXZieDNUMXAv?=
 =?utf-8?B?ZzY3NGJFN0RSaUZINk94bC95TTFOVHdHVHQ4QjBpK1k5R0I2QU4wOUJ6b0JS?=
 =?utf-8?B?VUV4bVJaUkFJWG4rSVZRTUFMTjMzMTRVZ1dGRE9qbmFGREcyL2hNTVJMdUla?=
 =?utf-8?B?aXBqOWdHOEhpMW9NMjBuSkJHb09CdStnRHZPM1FEVlhGcW12T3Axb3BtVTV1?=
 =?utf-8?B?ZmhVYkpaWHRGaVJiUXNDR2JlV2VpN1BrZEdOQ2ZPMlF4Z3B6OGdLRW1RNzNG?=
 =?utf-8?B?TzBwWHlDR1l3SGY3THBhY216RUNnMFRQb2dBTGU5OUdqd0JuZHU5ZFhNam9z?=
 =?utf-8?B?VVZvdjNLMk1vQ3QzK3ZsUHR2Tit2UElhVUJDR0hvcXEzU2xwQTdCeUdWZVND?=
 =?utf-8?B?RDNkaEZrZU96c3g0cDFvMjd2RUZSVGFTcDFrL1lNOSszODRadVlwQ1BCZkM2?=
 =?utf-8?B?V2ZHQ0x5T0gvbGxlZUtRQlhKMjhwbTFaYXB4WDNvQ3JRMkxnbC9OM0lZRlNP?=
 =?utf-8?B?WFRWSlh1ZjZ5SWRCa2NCQ1Z0ellGNFRPN0JUdmNSNGM0bFJiUDVibTZyQ09G?=
 =?utf-8?B?aGVRYzdWa0RUL0pUVTMvVjhmclBVWU9FNng3Tm9ZZTFUakNwdU1ZVTJ4eXNW?=
 =?utf-8?B?WDN3OTh2Ukx1R3BLZG9McHgySzZhUWhyWFdndGI4VlFleEo5YzZnRUJaZU1G?=
 =?utf-8?B?aVlGRXVTMlg0SUZUNzloZ0pZWEdoUVU3MStvaTR6WWlEZFBRMGhpMWZ1VzJH?=
 =?utf-8?Q?Ux1ovVk9KwEuUlMSfQN4HM4lr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 947417b0-6838-4e00-7286-08dbd13a63da
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 07:01:31.6072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qy5guBPYhVz6wlod7M4uHEx3Z7JrNPeRtQmoxg2fu+UOJDXSQUWahqWvJTryrB/03WdRWSA/d1wm70zQdOpuEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7294
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBGcmlk
YXksIE9jdG9iZXIgMjAsIDIwMjMgMTA6MjIgQU0NCj4gDQo+IE9uIDEwLzE5LzIzIDc6NTggUE0s
IEpvYW8gTWFydGlucyB3cm90ZToNCj4gPiBPbiAxOS8xMC8yMDIzIDAxOjE3LCBKb2FvIE1hcnRp
bnMgd3JvdGU6DQo+ID4+IE9uIDE5LzEwLzIwMjMgMDA6MTEsIEphc29uIEd1bnRob3JwZSB3cm90
ZToNCj4gPj4+IE9uIFdlZCwgT2N0IDE4LCAyMDIzIGF0IDA5OjI3OjA4UE0gKzAxMDAsIEpvYW8g
TWFydGlucyB3cm90ZToNCj4gPj4+PiArc3RhdGljIGludCBpb21tdV92MV9yZWFkX2FuZF9jbGVh
cl9kaXJ0eShzdHJ1Y3QgaW9fcGd0YWJsZV9vcHMgKm9wcywNCj4gPj4+PiArCQkJCQkgdW5zaWdu
ZWQgbG9uZyBpb3ZhLCBzaXplX3Qgc2l6ZSwNCj4gPj4+PiArCQkJCQkgdW5zaWduZWQgbG9uZyBm
bGFncywNCj4gPj4+PiArCQkJCQkgc3RydWN0IGlvbW11X2RpcnR5X2JpdG1hcCAqZGlydHkpDQo+
ID4+Pj4gK3sNCj4gPj4+PiArCXN0cnVjdCBhbWRfaW9fcGd0YWJsZSAqcGd0YWJsZSA9IGlvX3Bn
dGFibGVfb3BzX3RvX2RhdGEob3BzKTsNCj4gPj4+PiArCXVuc2lnbmVkIGxvbmcgZW5kID0gaW92
YSArIHNpemUgLSAxOw0KPiA+Pj4+ICsNCj4gPj4+PiArCWRvIHsNCj4gPj4+PiArCQl1bnNpZ25l
ZCBsb25nIHBnc2l6ZSA9IDA7DQo+ID4+Pj4gKwkJdTY0ICpwdGVwLCBwdGU7DQo+ID4+Pj4gKw0K
PiA+Pj4+ICsJCXB0ZXAgPSBmZXRjaF9wdGUocGd0YWJsZSwgaW92YSwgJnBnc2l6ZSk7DQo+ID4+
Pj4gKwkJaWYgKHB0ZXApDQo+ID4+Pj4gKwkJCXB0ZSA9IFJFQURfT05DRSgqcHRlcCk7DQo+ID4+
PiBJdCBpcyBmaW5lIGZvciBub3csIGJ1dCB0aGlzIGlzIHNvIHNsb3cgZm9yIHNvbWV0aGluZyB0
aGF0IGlzIHN1Y2ggYQ0KPiA+Pj4gZmFzdCBwYXRoLiBXZSBhcmUgb3B0aW1pemluZyBhd2F5IGEg
VExCIGludmFsaWRhdGlvbiBidXQgbGVhdmluZw0KPiA+Pj4gdGhpcz8/Pw0KPiA+Pj4NCj4gPj4g
TW9yZSBvYnZpb3VzIHJlYXNvbiBpcyB0aGF0IEknbSBzdGlsbCB3b3JraW5nIHRvd2FyZHMgdGhl
ICdmYXN0ZXInIHBhZ2UNCj4gdGFibGUNCj4gPj4gd2Fsa2VyLiBUaGVuIG1hcC91bm1hcCBjb2Rl
IG5lZWRzIHRvIGRvIHNpbWlsYXIgbG9va3VwcyBzbyB0aG91Z2h0IG9mDQo+IHJldXNpbmcNCj4g
Pj4gdGhlIHNhbWUgZnVuY3Rpb25zIGFzIG1hcC91bm1hcCBpbml0aWFsbHkuIEFuZCBpbXByb3Zl
IGl0IGFmdGVyd2FyZHMgb3INCj4gd2hlbg0KPiA+PiBpbnRyb2R1Y2luZyB0aGUgc3BsaXR0aW5n
Lg0KPiA+Pg0KPiA+Pj4gSXQgaXMgYSByYWRpeCB0cmVlLCB5b3Ugd2FsayB0cmVlcyBieSByZXRh
aW5pbmcgeW91ciBwb3NpdGlvbiBhdCBlYWNoDQo+ID4+PiBsZXZlbCBhcyB5b3UgZ28gKGVnIGlu
IGEgZnVuY3Rpb24gcGVyLWxldmVsIGNhbGwgY2hhaW4gb3Igc29tZXRoaW5nKQ0KPiA+Pj4gdGhl
biArKyBpcyBjaGVhcC4gUmUtc2VhcmNoaW5nIHRoZSBlbnRpcmUgdHJlZSBldmVyeSB0aW1lIGlz
IG1hZG5lc3MuDQo+ID4+IEknbSBhd2FyZSAtLSBJIGhhdmUgYW4gaW1wcm92ZWQgcGFnZS10YWJs
ZSB3YWxrZXIgZm9yIEFNRFswXSAobm90IHlldCBmb3INCj4gSW50ZWw7DQo+ID4+IHN0aWxsIGlu
IHRoZSB3b3JrcyksDQo+ID4gU2lnaCwgSSByZWFsaXplZCB0aGF0IEludGVsJ3MgcGZuX3RvX2Rt
YV9wdGUoKSAobWFpbiBsb29rdXAgZnVuY3Rpb24gZm9yDQo+ID4gbWFwL3VubWFwL2lvdmFfdG9f
cGh5cykgZG9lcyBzb21ldGhpbmcgYSBsaXR0bGUgb2ZmIHdoZW4gaXQgZmluZHMgYSBub24tDQo+
IHByZXNlbnQNCj4gPiBQVEUuIEl0IGFsbG9jYXRlcyBhIHBhZ2UgdGFibGUgdG8gaXQ7IHdoaWNo
IGlzIG5vdCBPSyBpbiB0aGlzIHNwZWNpZmljIGNhc2UgKEkNCj4gPiB3b3VsZCBhcmd1ZSBpdCdz
IG5laXRoZXIgZm9yIGlvdmFfdG9fcGh5cyBidXQgd2VsbCBtYXliZSBJIG1pc3VuZGVyc3RhbmQN
Cj4gdGhlDQo+ID4gZXhwZWN0YXRpb24gb2YgdGhhdCBBUEkpLg0KPiANCj4gcGZuX3RvX2RtYV9w
dGUoKSBkb2Vzbid0IGFsbG9jYXRlIHBhZ2UgZm9yIGEgbm9uLXByZXNlbnQgUFRFIGlmIHRoZQ0K
PiB0YXJnZXRfbGV2ZWwgcGFyYW1ldGVyIGlzIHNldCB0byAwLiBTZWUgYmVsb3cgbGluZSA5MzIu
DQo+IA0KPiAgIDkxMyBzdGF0aWMgc3RydWN0IGRtYV9wdGUgKnBmbl90b19kbWFfcHRlKHN0cnVj
dCBkbWFyX2RvbWFpbiAqZG9tYWluLA0KPiAgIDkxNCAgICAgICAgICAgICAgICAgICAgICAgICAg
IHVuc2lnbmVkIGxvbmcgcGZuLCBpbnQgKnRhcmdldF9sZXZlbCwNCj4gICA5MTUgICAgICAgICAg
ICAgICAgICAgICAgICAgICBnZnBfdCBnZnApDQo+ICAgOTE2IHsNCj4gDQo+IFsuLi5dDQo+IA0K
PiAgIDkyNyAgICAgICAgIHdoaWxlICgxKSB7DQo+ICAgOTI4ICAgICAgICAgICAgICAgICB2b2lk
ICp0bXBfcGFnZTsNCj4gICA5MjkNCj4gICA5MzAgICAgICAgICAgICAgICAgIG9mZnNldCA9IHBm
bl9sZXZlbF9vZmZzZXQocGZuLCBsZXZlbCk7DQo+ICAgOTMxICAgICAgICAgICAgICAgICBwdGUg
PSAmcGFyZW50W29mZnNldF07DQo+ICAgOTMyICAgICAgICAgICAgICAgICBpZiAoISp0YXJnZXRf
bGV2ZWwgJiYgKGRtYV9wdGVfc3VwZXJwYWdlKHB0ZSkgfHwNCj4gIWRtYV9wdGVfcHJlc2VudChw
dGUpKSkNCj4gICA5MzMgICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+IA0KPiBTbyBi
b3RoIGlvdmFfdG9fcGh5cygpIGFuZCByZWFkX2FuZF9jbGVhcl9kaXJ0eSgpIGFyZSBkb2luZyB0
aGluZ3MNCj4gcmlnaHQ6DQo+IA0KPiAJc3RydWN0IGRtYV9wdGUgKnB0ZTsNCj4gCWludCBsZXZl
bCA9IDA7DQo+IA0KPiAJcHRlID0gcGZuX3RvX2RtYV9wdGUoZG1hcl9kb21haW4sIGlvdmEgPj4g
VlREX1BBR0VfU0hJRlQsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZsZXZlbCwg
R0ZQX0tFUk5FTCk7DQo+IAlpZiAocHRlICYmIGRtYV9wdGVfcHJlc2VudChwdGUpKSB7DQo+IAkJ
LyogVGhlIFBURSBpcyB2YWxpZCwgY2hlY2sgYW55dGhpbmcgeW91IHdhbnQhICovDQo+IAkJLi4u
IC4uLg0KPiAJfQ0KPiANCj4gT3IsIEkgYW0gb3Zlcmxvb2tpbmcgc29tZXRoaW5nIGVsc2U/DQo+
IA0KDQpUaGlzIGlzIGNvcnJlY3QuDQo=
