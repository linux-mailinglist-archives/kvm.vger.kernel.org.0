Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCA6776EB2
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 05:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjHJDqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 23:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjHJDq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 23:46:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061E92103;
        Wed,  9 Aug 2023 20:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691639187; x=1723175187;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sylj8QX8JoLnUaipPOdrpfUqNOuijvxkRVk7+VsNB0M=;
  b=Fs8UsssBQfleqNY0PUjjXmJiZpYuCJmB7aWSJgaNHHuSsQlggzRz3Luy
   bAYWinH5nvoo37vLmrB1cpUC6CE1VBmco62UFqzmSbbyv8RGGpUUKZ89S
   g3kC1wu9ExXQpkheN756JSdLcWiRo1U91pa7MXT5mUypwdurm0J60hzv+
   Q6SWw/QDSwdYPvwIbalJssQPihZlvLCQ1M2gVHiqcuDsqNKURD5v9YPTq
   4nNY/x+PeVFax3YRu9BpyXKyclJ/T13UuCrxhCN6N4vvkFbLjJ0bqcF/J
   NByEroiYVW1NrQCYqWHeOckCQBW6QASVM7oJSknpaf8Mb3rpeJB+CI3jH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="374067721"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="374067721"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 20:46:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="978631709"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="978631709"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 09 Aug 2023 20:46:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 20:46:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 20:46:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 20:46:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 20:46:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGim6xNTtLa10Xkxcr+Zl6luSehPABRpagXh4nDO6OJIpIdGq5cU6FK3LjcOqeHzEzeKLTvPZ5KTnpnxq+yEYGJ6veRABxOdZlKZPqAmPXc0lMTZcjbPA83C/ufvGh1Ux02YXdfz5NCBPjXNT42QXxpX4yjEaEsvjWG8wqcFIjjxIydNO6M9eN1jp+zxuFBiV+csrCwkKUeFwUZHjcBljrnlesILzr7WxGL3mFHmJYV/PBYLvEfk8MZTNwg7wlidoDS57OMVbtV6Z0QeNUU44ovrsZ0h+Y4LY1zWhU1/gkkjUjt7bKe5zMYLbmpEsWoeeesH2GQpEbrRwwiksjl+SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sylj8QX8JoLnUaipPOdrpfUqNOuijvxkRVk7+VsNB0M=;
 b=lwOW3JirgFCGA3AiSS+iwO8JvTMP1Mbt+pqOBnoBiBqMKF3AFX9ETRTMxqj8fFHOFKwmQQi9u2xkvShcu1rjLSJGgzzWIE44NbNQI7FM1yudnEzWRNdJCnL9+shtd2tIQ4Rgc9cxwv9/it042T3XHTpy2r8IqekARzb5hOoTINxlWmL5X5nZHr+g1zxUcA/t0PZoXflLEFi3UL0OIfj4QKli2Bq4Xvxwd4Zq7EmDrKGzVl2rouWZjNp9nN1z2K/4cInkbTyIwnAyAURRRTDn0SpFV9P1rijTWM0YrHTYus0wpOYkvumpkmayHJ/eqp+DWggZCaHXba78P/6UtfVCrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5631.namprd11.prod.outlook.com (2603:10b6:a03:3ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.28; Thu, 10 Aug
 2023 03:46:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 03:46:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Brett Creeley <bcreeley@amd.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v13 vfio 6/7] vfio/pds: Add support for firmware recovery
Thread-Topic: [PATCH v13 vfio 6/7] vfio/pds: Add support for firmware recovery
Thread-Index: AQHZv0DJiKwEjj+SREi3671DP8pR9K/acO8AgAAEWQCAAAgqgIAADUAAgAhwdGA=
Date:   Thu, 10 Aug 2023 03:46:22 +0000
Message-ID: <BN9PR11MB527634BA82AD978D4053F0E08C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-7-brett.creeley@amd.com> <ZM0y9H0UbHHW8qJV@nvidia.com>
 <73aa389d-7ef6-5563-0109-a4d6750756df@amd.com> <ZM09c8IG+ba+fdts@nvidia.com>
 <73c3aabd-1859-573c-c878-e4fc73186576@amd.com>
In-Reply-To: <73c3aabd-1859-573c-c878-e4fc73186576@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5631:EE_
x-ms-office365-filtering-correlation-id: 146ed32f-83ef-4249-f4d7-08db99545d62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ypcwbr/OIYOAkkqxG6QXhaLlQYczxq0t/pb2WcNIf265SlRNs8iH4n6VJb+bQgjsNr54r2PIJQJX/B1osrEk62M2CyNnXm0sturK67BABh2zXlqlYyE0Q4MArz0/A/2SbKBrqGdb5j1uQUQiW0oSK9yBAH8RR8Dt7axOl1hkd36byqdPZ52XHeY0c1Tiyvdi6FUXvw7+K9V4S2Nf/1R9SM1U5EuDDldRh8eTmftpEj7JHGXo/4k1Awqkal7DvoQzzN+iEsRIkkm8t4Ik3gwKTkltIFEJLqkCvr/S8iHJmFpL3nXi2UMd4denRX01iHOA2kQbJNUZ4tMGK8KSRMtiWTg9HfAvvRplpBdJJH82Ot2wGEkQ7ZIbN7Tjte9invhbVjAo/0by3JT8fj4aFpy7vgMTRtDHd7YtfEyyyl5ON+Z3zgvgEkJkboPHPTO6+V/MvaOkVXDrtzU3O3jfuFaUrxVX030skZVfnOydokcTJ/VoEh7GXjIX5gUFQ4hRYQx7NpeiG5GsLLZoQU8u+wUOvap+W9d6a21v2FGlIccf0lEmqDfQxIPwGw5Ar5j63DYsaXXgEEp5WaFO8SQG2mkzONdTCzBUIhPVZ1oROKFWV938WGdZHFARV+AmDO5ZK/OE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39860400002)(396003)(346002)(186006)(451199021)(1800799006)(41300700001)(7416002)(2906002)(316002)(8936002)(8676002)(52536014)(5660300002)(38070700005)(33656002)(86362001)(55016003)(122000001)(9686003)(6506007)(53546011)(26005)(82960400001)(7696005)(478600001)(66556008)(83380400001)(71200400001)(66946007)(64756008)(66446008)(66476007)(76116006)(4326008)(110136005)(54906003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnhVMWhhYjBWWjRocEV2akpVQjdyaTR3ZXRtL3N0ZzBuaW84czNZOC9lZ1Vq?=
 =?utf-8?B?dkEyUlVnQzA5UWpKMDhwT2xNNnhDSmlIZ3FJeTZlWHRwb1JVaURVakpybmph?=
 =?utf-8?B?QmdEUDBNZTlHZldkcW40YllFbnZhUm1oLzFLZnh4bDUycWJyTG4vdjJvUmwv?=
 =?utf-8?B?TEFJbVQvVlRlTjF4Smt6TGJoL0orWElDcXdNdmtwR1RvUmR6UWErTW16elRq?=
 =?utf-8?B?M0tvMFVIVHJwQ3ZVQzZTWGRnQ3pvcnMzNXlRcENJZ2hsTURBbWI1ZWFuU1Ju?=
 =?utf-8?B?QVJjZktFaHhLYkhpeTUzS0JZckZnckRMZ24xeHp0SWNKV2JPTnFkREJXbm9V?=
 =?utf-8?B?bFh3VWRBQkxBNTBSQTVzM0VjRFZhYmhxK3pNczFERUJoY1JSNUlNTlNJNFMz?=
 =?utf-8?B?S2syS3JWRFJsM3E3L3d0NkthbGVnY1EvOGRQOGsycG53ZFYrOWcrQWNXajNi?=
 =?utf-8?B?czFvejViQzNLSmlqYURBYmQ4OVEzU1k4RUNTNDdWTWF2U3BBQnF6MHhTbklv?=
 =?utf-8?B?ZnJqV0tZZURsUVlXMFBDcUluRS9Mek9KWVBXZzltNUZBVGt3V2luWnFSVktk?=
 =?utf-8?B?bThobGhiWElKVXhwbENZSjlsd0ltMHBTUFVwcGg4ajRGK2ljS2Y3SkFDeW5G?=
 =?utf-8?B?dGZXZVRHaFpDOEoyWGNsMGg1NFVmdkJSb2ZTK3dIRHFDYzA1bWZIUUt0M3NM?=
 =?utf-8?B?Q3VsZDgzMnozSjk2MUxGR1p6SkNsaDd0OFhKNEE3WGhKUTY1U1ZIMnRnVzFs?=
 =?utf-8?B?Nk05TWVJK0dPNHk1UG10T04yMWQ1RFgwYnp6TUpZMktCL3JmUW5lK0Y1bzFO?=
 =?utf-8?B?SFV5TmdnNnRCdUxMcGxkR1BIVk1Nc1djd2xCdlp3dFhEbE1XZ245OUVESSsv?=
 =?utf-8?B?NmcyZEZGeHNHbEtDcmxpU1lFb3E0ek4rQVFjVFhqZ0ZIMFp6b1QzVGVkMDQ4?=
 =?utf-8?B?ZThJcVNRd3hLbUJZZ1Fpc3AzRy92cWpqbVoyQ1Q1ZlRXYTFodnVtbGpISUFH?=
 =?utf-8?B?TnhvTE1yM3BBdHNNSTBzUEFFTkxDNlUrRGk3MHRRNzlxTWFGMmxqdFhwRGNu?=
 =?utf-8?B?WFFNK0NMVkM5UHlWRGRTTVR1OHorQTBYRS9tYzB5QzZJdGhTYndZWDNEOEpv?=
 =?utf-8?B?Q2N3M3k1NUJuaEtlNml5bmpSQVYwVkxnZHBhamFHb0M2M3BSQTZBK3RRd29t?=
 =?utf-8?B?U1VsL0lwN0NpT09aZGF3SlJ4ZUV1SVdSYzI1RWRSY2ZIeEh4OHdLcWM4NXVR?=
 =?utf-8?B?SXFKc1lXSnN2dkJzTTQ3bTQ5TS80bmxqZzJad3dMbnlnMXpGZVowazZQMTNv?=
 =?utf-8?B?VVVlMVJIcTVWWUorOXZ2QUpsbXp0Z2dZSXgvd3RtSndoVUhQeFpFMHJDOU5P?=
 =?utf-8?B?aUM3SGJmaVRmZCsxVVgrRHc1dHAzb1psejV3Zkdrd2FDRHhxckJwMDBtWGlE?=
 =?utf-8?B?RytBbzIvTXhWc29EYkZmSE9qRE90MzNwaU9FTkc3Qnp4Qk9GRm82QmVyenYv?=
 =?utf-8?B?bjNSbHRqZHFBZmdSQkttWEpyMC9TbllBS0tKWmx3OENrQVA3R1p6QThkSUJ4?=
 =?utf-8?B?ZU0yMU5SUTlIRGtycTIrVkRnUlA1VmFhVm5zeHJjV01SdjN5aTB4ZFNDMnE4?=
 =?utf-8?B?WlA0dWYrWlJVcHNqNC9ESFRFYUNzWjZlejBKc1I0WW5UVlF4WnFrSEVBSW9o?=
 =?utf-8?B?YVVWSEZ4VkFRdHJQenRyU2l2bjhoSlMvYUNXaFNmS2hWYWZ1V2dRTkpobHFV?=
 =?utf-8?B?MFFmMXRSdlNKTThXeG40M084WVI3Z3ozMERyNmprbFdlWDRTc0pyWDZ0eDgx?=
 =?utf-8?B?L21IeGFtZnZlNjIyNW8yWGd1dE80aG4wQkpwcWF6dlNsOC9tcW9tMEdDR0Vo?=
 =?utf-8?B?TCtTbXRhTW1FcHpYZUdXNWwyS2sxN3RTOWFRYVVMWmQvOS9iTVhpVCtrVVhM?=
 =?utf-8?B?blM4TlBFZjVUbGRQY0wrYXZkZ2tEZmNHL1hTQkFnSGxtcnZVd1EzSXJJelBj?=
 =?utf-8?B?SDh1cGtGUkEwTzVKMzVLNzNoQWpqNGVWZG9Nc3VTbnBzNlhDNFpSRFVCMno1?=
 =?utf-8?B?RDZQbDcwSlVUM3NQUzNwV2pVbnE4UlplYmR0R3N3RWNZR2tOemlGeFVFK3pE?=
 =?utf-8?Q?BxNw3SlUP/Sj3QK7Ygk9G5/+L?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 146ed32f-83ef-4249-f4d7-08db99545d62
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2023 03:46:22.5894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NWgGTHdgLauGYtJeGDQEaEXejhwJmk3EIY8AB3fGxzxG6TqD2NVwBnqWK10X8oJAs6wGaANN0NbofLayOS+i2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5631
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCcmV0dCBDcmVlbGV5IDxiY3JlZWxleUBhbWQuY29tPg0KPiBTZW50OiBTYXR1cmRh
eSwgQXVndXN0IDUsIDIwMjMgMjo1MSBBTQ0KPiANCj4gT24gOC80LzIwMjMgMTE6MDMgQU0sIEph
c29uIEd1bnRob3JwZSB3cm90ZToNCj4gPiBDYXV0aW9uOiBUaGlzIG1lc3NhZ2Ugb3JpZ2luYXRl
ZCBmcm9tIGFuIEV4dGVybmFsIFNvdXJjZS4gVXNlIHByb3Blcg0KPiBjYXV0aW9uIHdoZW4gb3Bl
bmluZyBhdHRhY2htZW50cywgY2xpY2tpbmcgbGlua3MsIG9yIHJlc3BvbmRpbmcuDQo+ID4NCj4g
Pg0KPiA+IE9uIEZyaSwgQXVnIDA0LCAyMDIzIGF0IDEwOjM0OjE4QU0gLTA3MDAsIEJyZXR0IENy
ZWVsZXkgd3JvdGU6DQo+ID4+DQo+ID4+DQo+ID4+IE9uIDgvNC8yMDIzIDEwOjE4IEFNLCBKYXNv
biBHdW50aG9ycGUgd3JvdGU6DQo+ID4+PiBDYXV0aW9uOiBUaGlzIG1lc3NhZ2Ugb3JpZ2luYXRl
ZCBmcm9tIGFuIEV4dGVybmFsIFNvdXJjZS4gVXNlIHByb3Blcg0KPiBjYXV0aW9uIHdoZW4gb3Bl
bmluZyBhdHRhY2htZW50cywgY2xpY2tpbmcgbGlua3MsIG9yIHJlc3BvbmRpbmcuDQo+ID4+Pg0K
PiA+Pj4NCj4gPj4+IE9uIFR1ZSwgSnVsIDI1LCAyMDIzIGF0IDAyOjQwOjI0UE0gLTA3MDAsIEJy
ZXR0IENyZWVsZXkgd3JvdGU6DQo+ID4+Pj4gSXQncyBwb3NzaWJsZSB0aGF0IHRoZSBkZXZpY2Ug
ZmlybXdhcmUgY3Jhc2hlcyBhbmQgaXMgYWJsZSB0byByZWNvdmVyDQo+ID4+Pj4gZHVlIHRvIHNv
bWUgY29uZmlndXJhdGlvbiBhbmQvb3Igb3RoZXIgaXNzdWUuIElmIGEgbGl2ZSBtaWdyYXRpb24N
Cj4gPj4+PiBpcyBpbiBwcm9ncmVzcyB3aGlsZSB0aGUgZmlybXdhcmUgY3Jhc2hlcywgdGhlIGxp
dmUgbWlncmF0aW9uIHdpbGwNCj4gPj4+PiBmYWlsLiBIb3dldmVyLCB0aGUgVkYgUENJIGRldmlj
ZSBzaG91bGQgc3RpbGwgYmUgZnVuY3Rpb25hbCBwb3N0DQo+ID4+Pj4gY3Jhc2ggcmVjb3Zlcnkg
YW5kIHN1YnNlcXVlbnQgbWlncmF0aW9ucyBzaG91bGQgZ28gdGhyb3VnaCBhcw0KPiA+Pj4+IGV4
cGVjdGVkLg0KPiA+Pj4+DQo+ID4+Pj4gV2hlbiB0aGUgcGRzX2NvcmUgZGV2aWNlIG5vdGljZXMg
dGhhdCBmaXJtd2FyZSBjcmFzaGVzIGl0IHNlbmRzIGFuDQo+ID4+Pj4gZXZlbnQgdG8gYWxsIGl0
cyBjbGllbnQgZHJpdmVycy4gV2hlbiB0aGUgcGRzX3ZmaW8gZHJpdmVyIHJlY2VpdmVzDQo+ID4+
Pj4gdGhpcyBldmVudCB3aGlsZSBtaWdyYXRpb24gaXMgaW4gcHJvZ3Jlc3MgaXQgd2lsbCByZXF1
ZXN0IGEgZGVmZXJyZWQNCj4gPj4+PiByZXNldCBvbiB0aGUgbmV4dCBtaWdyYXRpb24gc3RhdGUg
dHJhbnNpdGlvbi4gVGhpcyBzdGF0ZSB0cmFuc2l0aW9uDQo+ID4+Pj4gd2lsbCByZXBvcnQgZmFp
bHVyZSBhcyB3ZWxsIGFzIGFueSBzdWJzZXF1ZW50IHN0YXRlIHRyYW5zaXRpb24NCj4gPj4+PiBy
ZXF1ZXN0cyBmcm9tIHRoZSBWTU0vVkZJTy4gQmFzZWQgb24gdWFwaS92ZmlvLmggdGhlIG9ubHkg
d2F5IG91dCBvZg0KPiA+Pj4+IFZGSU9fREVWSUNFX1NUQVRFX0VSUk9SIGlzIGJ5IGlzc3Vpbmcg
VkZJT19ERVZJQ0VfUkVTRVQuIE9uY2UNCj4gdGhpcw0KPiA+Pj4+IHJlc2V0IGlzIGRvbmUsIHRo
ZSBtaWdyYXRpb24gc3RhdGUgd2lsbCBiZSByZXNldCB0bw0KPiA+Pj4+IFZGSU9fREVWSUNFX1NU
QVRFX1JVTk5JTkcgYW5kIG1pZ3JhdGlvbiBjYW4gYmUgcGVyZm9ybWVkLg0KPiA+Pj4NCj4gPj4+
IEhhdmUgeW91IGFjdHVhbGx5IHRlc3RlZCB0aGlzPyBEb2VzIHRoZSBxZW11IHNpZGUgcmVzcG9u
ZCBwcm9wZXJseSBpZg0KPiA+Pj4gdGhpcyBoYXBwZW5zIGR1cmluZyBhIG1pZ3JhdGlvbj8NCj4g
Pj4+DQo+ID4+PiBKYXNvbg0KPiA+Pg0KPiA+PiBZZXMsIHRoaXMgaGFzIGFjdHVhbGx5IGJlZW4g
dGVzdGVkLiBJdCdzIG5vdCBuZWNlc3NhcnkgY2xlYW4gYXMgZmFyIGFzIHRoZQ0KPiA+PiBsb2cg
bWVzc2FnZXMgZ28gYmVjYXVzZSB0aGUgZHJpdmVyIG1heSBzdGlsbCBiZSBnZXR0aW5nIHJlcXVl
c3RzIChpLmUuIGRpcnR5DQo+ID4+IGxvZyByZXF1ZXN0cyksIGJ1dCB0aGUgbm9pc2Ugc2hvdWxk
IGJlIG9rYXkgYmVjYXVzZSB0aGlzIGlzIGEgdmVyeSByYXJlDQo+ID4+IGV2ZW50Lg0KPiA+Pg0K
PiA+PiBRRU1VIGRvZXMgcmVzcG9uZCBwcm9wZXJseSBhbmQgaW4gdGhlIG1hbm5lciBJIG1lbnRp
b25lZCBhYm92ZS4NCj4gPg0KPiA+IEJ1dCB3aGF0IGFjdHVhbGx5IGhhcHBlbnM/DQo+ID4NCj4g
PiBRRU1VIGFib3J0cyB0aGUgbWlncmF0aW9uIGFuZCBGTFJzIHRoZSBkZXZpY2UgYW5kIHRoZW4g
dGhlIFZNIGhhcyBhDQo+ID4gdG90YWxseSB0cmFzaGVkIFBDSSBmdW5jdGlvbj8NCj4gPg0KPiA+
IENhbiB0aGUgVk0gcmVjb3ZlciBmcm9tIHRoaXM/DQo+ID4NCj4gPiBKYXNvbg0KPiANCj4gQXMg
aXQgbWVudGlvbnMgYWJvdmUsIHRoZSBWTSBhbmQgUENJIGZ1bmN0aW9uIGRvIHJlY292ZXIgZnJv
bSB0aGlzIGFuZA0KPiB0aGUgc3Vic2VxdWVudCBtaWdyYXRpb24gd29ya3MgYXMgZXhwZWN0ZWQu
DQo+IA0KDQpJZiByZXNldCBpcyByZXF1ZXN0ZWQgYnkgdGhlIGhvc3QgaG93IGlzIHRoZSBWTSBu
b3RpZmllZCB0byBoYW5kbGUgdGhpcw0KdW5kZXNpcmVkIHNpdHVhdGlvbj8gV291bGQgaXQgbGVh
ZCB0byBvYnNlcnZhYmxlIGFwcGxpY2F0aW9uIGZhaWx1cmVzDQppbnNpZGUgdGhlIGd1ZXN0IGFm
dGVyIHRoZSByZWNvdmVyeT8NCg==
