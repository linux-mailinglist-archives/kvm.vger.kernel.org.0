Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF6E6BAB32
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 09:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjCOIxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 04:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbjCOIxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 04:53:15 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A3B58C2F;
        Wed, 15 Mar 2023 01:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678870383; x=1710406383;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LMVO/ZLeHiCQHSE2ScPZQCpyPxsDDBYaJB+upOXBQuY=;
  b=G5TVhIQc4S+000ENAat1X0erekYZFkVRKhfQ5yiIGmpVefXuE08HkOwc
   jf5kuqoMVurkHeva80TauFPDwp34YgCH4+PnfcEUXyWaxGFjbi4eHstP+
   g0fR941Bzx9Sgsgh2g4+Nm5UsOshALmr/NNagoYP/jnmq7HtiFxmMeXdy
   XC9snoBSPiIgWHloRyBrOPcuXleSkRUaFi4AOVFt2HiKpFBTFnFsEwTNn
   xeSFdDoBRsRXUh4O71bbrdHrHN75Rxm52x1Oebd6uUPT2lzCsvwtB26xX
   vLLAOK3ft4QyGlADmiWX/TS53iNmvVYrWGvK7lXi4mR/+B4BppzYcsusj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="326008907"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326008907"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 01:53:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="768421794"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="768421794"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Mar 2023 01:53:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 01:53:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 01:53:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 01:53:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 01:53:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHihQL0M4CoU+5mPX6cf1bE50ZWEiZYW9StMB9xy49PymPESZ/GQPKRND0vhrbDKEW3hXUL5WE2Fz1Gw2lgm0ab1XYBuekBzyv8oisIbyeDzsM+gdJMskMvL40B8yDXxREA/2o9jBXOgTi+fLzGEQ6NqiwkQZPYfPTpMGCZRJkFtCmbqI+D2zRQS89eniR/MlzjN0kPW8OZHa4nXpcnubX7W171W8XjMCoOWF9O5RYsKQv33hVKh8fdJoIo3/JjtI8A2z6xr4SqwvA0x5G5MNbyRoXvzMUAqPQP9WCXXohFnD+Wubj09B+BwWpGi54nt7+phGWv6gsU/l0ZqI8PkDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMVO/ZLeHiCQHSE2ScPZQCpyPxsDDBYaJB+upOXBQuY=;
 b=dMkKItAlDqBm72AppgB2hNIy69eMB4PXNKozRALb/SF7EirjlD69iTW8XnVT6G6wEPP0pi7SvWhNqRezxLMlku1QmXhu9rTFLzYpnyrHePoQ3q3eilvPblaoucD2yFO6UbF1DUzenXNIGPfFeyk4cHJ+rcfpwlommtedPMlumeKkPNMtKuCo41ipj1w0Mx0PGrKddnxE/9+1jOLSbib39VKczpZ5fMQsjMpKng6e259TMwoXCLyDzBvjEzAoXm9ZjA1I3Y5houZhq1z2iitDhkV5KWDqlyPTB5XyzIu4CWqOO1cDQ9zo5ganPivJhnAQdKwqSiPhqIRXle6ShCepIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB5439.namprd11.prod.outlook.com (2603:10b6:5:39b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Wed, 15 Mar
 2023 08:52:57 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 08:52:57 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VywVS1tWF6Uet+ZnBHpWUv67zRtmAgAdhcICAAL+cgIAAAWUAgAAIiACAAB2B4A==
Date:   Wed, 15 Mar 2023 08:52:56 +0000
Message-ID: <DS0PR11MB75295B8B4352698CB165B300C3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <BN9PR11MB52766F9DA462F5C7BC23654F8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBDCCYLJn32Yk/eI@Asurada-Nvidia>
 <BN9PR11MB52766160C546FA5075B191258CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFj8AZ4gWOW1PQs@Asurada-Nvidia>
 <BN9PR11MB5276FDB32A40B521C0E351E68CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276FDB32A40B521C0E351E68CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB5439:EE_
x-ms-office365-filtering-correlation-id: 04d21c84-4f75-4290-efe0-08db2532ac1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7BXC34kqsH51ERRuFYI+MeBy2XYUNmP80310cm7mMY4vA8GLQh+WtJJcSKghP1y7fgDB4Bbh2pLl0bciOHYRUXlU+5284tiB3gpdJMfyNIkE0n4/rz1dI0Ta0Y02RorcwtF0TaO3EkZszfa2MYM6CdfhfP96nE7IB8LBtpS7sddjFvgNdhXjhfvcHizh/9fu7jQ3A0M9M0Y9g9PRj7Ez1i1mkQ9G6RYD1Px/ft+3trtnE3U9KrSEgpJ/dTcB5Anbv68dE0H58rHI32xM2LKC0cg6GzqvkftxxC8ImN2Qfl9pO39RFsYifZv7Xxt0bRRTrGX2qZbJFGBf8PGjShig6S979HS6hjZJz6CnESJ6sS65wB9zoSssH8lpLxjgK7+Yk3/PhvotEqixLkJuY6KemtLIucuc7DqD8erOk58DxeYI2hVH/+3zMDsKH0P+ArZ5sGF2U2opEDQgJ0FJ4BCrEtgG5shQWwKJo9loctTEVdfDgRTZeyzU2d6dxp2aZ/SybYzogkXLxA4L57RKRngYATsKYC/rUbGzJEj2wLUHEg9dqw19/Vk1rMUqJ73s6Izbimnvdj58rnBL0MQPeiL8A4clnBGZbufnmhRplO+62oChlU43Ie/lbqd76xyzOXRYoYvARB7OvRXu9AgbTyTFljCU5bCA1xqsu6vwD4hhomAMkveSvwe9/wCvYgiG1N+/9hrLd3MVB/4p4v1cfyqHng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199018)(41300700001)(7416002)(52536014)(8936002)(5660300002)(2906002)(38100700002)(38070700005)(33656002)(86362001)(122000001)(82960400001)(7696005)(71200400001)(478600001)(66946007)(66556008)(66476007)(64756008)(66446008)(76116006)(8676002)(55016003)(4326008)(54906003)(110136005)(316002)(6506007)(53546011)(9686003)(186003)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cjV5SWtzU21GbmdzWW84NythaVZ3Z1JJU2pDdzQwdlljZDJNT0RnYmVmOSsz?=
 =?utf-8?B?MUs1U25nTlVCOGdVQUpGRGMwWTVFcm1Ba0RVVmtXQW9vU2xIdTZPblQ1MHcy?=
 =?utf-8?B?NC9LMEFIZ1Q5K0E4RjVMRFZ4V3MvV1AzdGZDZkRRL2xWaGxzU29wbW1aZmdV?=
 =?utf-8?B?RGcvRWlTYkpmSmNpbFlTV0N4Q1lXYUY2V3FsaWpNVyt0NVFFeFgyVGFJS2Uz?=
 =?utf-8?B?bzJFQjRJM1pCT2pVL21TMk9ScCtpNkswMWhKY3JjUHRTNG1XeFlRejNqY1RY?=
 =?utf-8?B?eXI1b1R4akc0V1VUMldoeWZPaGExMEhnQksydmFFSmloQ3gyVVZ0cHFZZWNk?=
 =?utf-8?B?aDhkOFE1Tk51OWJsOHQ3WjkvbjRVdHZsYnBWVklBbGx3S1BJTmgyRU1IaE5S?=
 =?utf-8?B?YUNhNkF4TGpDellsQzlZQUY2TEF2WkN0NWZDbXE5R2ExM0tyZW5hMGRZRkNk?=
 =?utf-8?B?NGZXMG5PdWNob0U2dHBJSDQ2RXhGa0h3aVFuSGhvcitTU2JLY25JQ0QzZkZV?=
 =?utf-8?B?NjZQN25iaTkrOVZ5WUJKWU5vQmFkbExSSy9OcUNrazJ0R2JBbUNJTTAvdzRU?=
 =?utf-8?B?blFiQ3hmMmN0Y25GUGhDeGpUc2swbXBhN3BXT2xINkRkMCtvQ2d4UFNYVkNw?=
 =?utf-8?B?Z2M4ZDltSUNEdkEyMmdpcHNKRnN4MmZ3TVNnVk1WNGF5TGF6MHIydzBrVW9F?=
 =?utf-8?B?cVVSOEZhbDdCMDExV0pJQVhsNU1ybUNyemhBZWpYZVpOUTdZUm5lTmltQWxR?=
 =?utf-8?B?WlBWMWl5eFJ4clJiVTZlTHFwNTRYUGJQdGV3MWtrbEVkV05ndnJDMXdFU05T?=
 =?utf-8?B?U004eUtKMEV0VEtLNFVaNGRGM2VmaFZ1dWI0c08wd2h2TmdQOEtQeXhlUUo4?=
 =?utf-8?B?cUpqM0FxRzBnT044SkVRY3BJYlEwczI1RGJvSE1TYlR5UVZwZ3lOY3NsVTEv?=
 =?utf-8?B?U2t5YnBjSnZ0TjVBMERNUEc5M01zNmZlUWN5M21TbG44NGFiemt2MU82Z1U0?=
 =?utf-8?B?NEtCMTdxV3lqcnJKUVhXOVBGRWprckdscmNZSTNaS0Q0OWhhS2pUbXVtK3d5?=
 =?utf-8?B?TUswZVNKbXVvclNYblpKRXVoWHA3NnZ2Q2xMelU2Sk5JS2p1ZUVoeHVDYnl3?=
 =?utf-8?B?aE51Rk1udHhUaUtRdDVudkE2MThUTjR4VFF1TDlZZzZjdDE4aEczeEFBWW9R?=
 =?utf-8?B?dlRjdXlZUk5McElKZnJrZFpBQTgveFdPTGE1SWFyNU8rT2VEM0JvVFBhZ1Ro?=
 =?utf-8?B?Q1hZV1NmVDFGTWhJOHRpUjdORytvb2Q4aXJrNk5VVUU5b0UxOEtUU3drcXBT?=
 =?utf-8?B?Z1VnNWZYTlBObTZqUU03UWw1WFVLZFZyTWlJZ1lRVVFwZ0h3YkswQkhzZzNi?=
 =?utf-8?B?Y1pMa044V2xSRFJvemRWbUtnZ2NqelBRY3M1LzRpSmlGMzBpb3djVHAyUUc1?=
 =?utf-8?B?bm1GeVBKcWc2NitiN0M0bmFpV2FDVFcwMnRibFc0MEd1TFRNWkwweFgwTUtX?=
 =?utf-8?B?VUl1cklYOFVnb0tGRXNJaXNjSFVVSnlyejZNNGx2Zys2OXAyUGM2d2ZJci9n?=
 =?utf-8?B?c0d1N0R6anFlNm1uTTRqQkxlRVpkdmFVMTAyZlovRUZGZk5rc0taOFhnYXE4?=
 =?utf-8?B?RC9KVjVKWXgyNG45RlBuMTVxQVljMU5tbEtHc2drdDVTc1JQajBDSmpLTjNO?=
 =?utf-8?B?RXUvb01uUzRiQkk3bjV5b1VuRC9tckswSzd6bkw3QUZ5YjR3anRRVTRKSU8v?=
 =?utf-8?B?U201TExwVjBqMXZ2d0pjYVJlSHpMZWs3aGVZanlwSStmVnAyS3RlTThVVVZY?=
 =?utf-8?B?WEdMcENJY0dHdWJQMmVEQTA2V0dSQVowQmxnYU5RQTFtb3ZPT1FOTnhtNnhl?=
 =?utf-8?B?dTdXTWZoMlVBbnpRamFRemcvWVdaYm5WMDJIa1JIM1Brejh2Z1BOcStqbVBY?=
 =?utf-8?B?U1Zoa1A5MEZHZTZkaVFsb1I3YVJxR0hibWxUM1ZacEVvYUFraGtZWkxNdFdo?=
 =?utf-8?B?V1gxbTVQbXJNSTIwU3RLTVZlWHdTdm5ldk1HSXFMTWlLa0gvdC9oaDZFU09J?=
 =?utf-8?B?eWFIL3Iyd0dHM29mTm9aZUJIQjExdGx0dzdHUWRoMUN1dUlNaHhGYldJYWtV?=
 =?utf-8?Q?bYCq1+IWwqFFRO22iIE59flpR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04d21c84-4f75-4290-efe0-08db2532ac1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 08:52:56.8939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b6oSTDojhQ/XUnYBObtJAa/vJgzKiRCsjZrSl2R+rwY4pMlMyAI2waYQCVfV6nqSq+nYY3jYsu1DhhY4lW0zrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5439
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgTWFyY2ggMTUsIDIwMjMgMjo1MiBQTQ0KPiANCj4gPiBGcm9tOiBOaWNvbGluIENoZW4N
Cj4gPiBTZW50OiBXZWRuZXNkYXksIE1hcmNoIDE1LCAyMDIzIDI6MjIgUE0NCj4gPg0KPiA+IE9u
IFdlZCwgTWFyIDE1LCAyMDIzIGF0IDA2OjE2OjM3QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3Rl
Og0KPiA+ID4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0
YWNobWVudHMNCj4gPiA+DQo+ID4gPg0KPiA+ID4gPiBGcm9tOiBOaWNvbGluIENoZW4NCj4gPiA+
ID4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAxNSwgMjAyMyAyOjUxIEFNDQo+ID4gPiA+DQo+ID4g
PiA+IE9uIEZyaSwgTWFyIDEwLCAyMDIzIGF0IDAyOjA4OjE1QU0gKzAwMDAsIFRpYW4sIEtldmlu
IHdyb3RlOg0KPiA+ID4gPiA+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxp
bmtzIG9yIGF0dGFjaG1lbnRzDQo+ID4gPiA+ID4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gRnJv
bTogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gPiA+ID4gPiBTZW50OiBXZWRu
ZXNkYXksIE1hcmNoIDgsIDIwMjMgOToxNCBQTQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEBA
IC00NDksMzMgKzQ1MCwxOCBAQCBpb21tdWZkX2FjY2Vzc19jcmVhdGUoc3RydWN0DQo+ID4gaW9t
bXVmZF9jdHgNCj4gPiA+ID4gKmljdHgsDQo+ID4gPiA+ID4gPiB1MzIgaW9hc19pZCwNCj4gPiA+
ID4gPiA+ICAgICAgIGFjY2Vzcy0+ZGF0YSA9IGRhdGE7DQo+ID4gPiA+ID4gPiAgICAgICBhY2Nl
c3MtPm9wcyA9IG9wczsNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiAtICAgICBvYmogPSBpb21t
dWZkX2dldF9vYmplY3QoaWN0eCwgaW9hc19pZCwgSU9NTVVGRF9PQkpfSU9BUyk7DQo+ID4gPiA+
ID4gPiAtICAgICBpZiAoSVNfRVJSKG9iaikpIHsNCj4gPiA+ID4gPiA+IC0gICAgICAgICAgICAg
cmMgPSBQVFJfRVJSKG9iaik7DQo+ID4gPiA+ID4gPiAtICAgICAgICAgICAgIGdvdG8gb3V0X2Fi
b3J0Ow0KPiA+ID4gPiA+ID4gLSAgICAgfQ0KPiA+ID4gPiA+ID4gLSAgICAgYWNjZXNzLT5pb2Fz
ID0gY29udGFpbmVyX29mKG9iaiwgc3RydWN0IGlvbW11ZmRfaW9hcywgb2JqKTsNCj4gPiA+ID4g
PiA+IC0gICAgIGlvbW11ZmRfcmVmX3RvX3VzZXJzKG9iaik7DQo+ID4gPiA+ID4gPiAtDQo+ID4g
PiA+ID4gPiAgICAgICBpZiAob3BzLT5uZWVkc19waW5fcGFnZXMpDQo+ID4gPiA+ID4gPiAgICAg
ICAgICAgICAgIGFjY2Vzcy0+aW92YV9hbGlnbm1lbnQgPSBQQUdFX1NJWkU7DQo+ID4gPiA+ID4g
PiAgICAgICBlbHNlDQo+ID4gPiA+ID4gPiAgICAgICAgICAgICAgIGFjY2Vzcy0+aW92YV9hbGln
bm1lbnQgPSAxOw0KPiA+ID4gPiA+ID4gLSAgICAgcmMgPSBpb3B0X2FkZF9hY2Nlc3MoJmFjY2Vz
cy0+aW9hcy0+aW9wdCwgYWNjZXNzKTsNCj4gPiA+ID4gPiA+IC0gICAgIGlmIChyYykNCj4gPiA+
ID4gPiA+IC0gICAgICAgICAgICAgZ290byBvdXRfcHV0X2lvYXM7DQo+ID4gPiA+ID4gPg0KPiA+
ID4gPiA+ID4gICAgICAgLyogVGhlIGNhbGxpbmcgZHJpdmVyIGlzIGEgdXNlciB1bnRpbCBpb21t
dWZkX2FjY2Vzc19kZXN0cm95KCkgKi8NCj4gPiA+ID4gPiA+ICAgICAgIHJlZmNvdW50X2luYygm
YWNjZXNzLT5vYmoudXNlcnMpOw0KPiA+ID4gPiA+ID4gKyAgICAgbXV0ZXhfaW5pdCgmYWNjZXNz
LT5pb2FzX2xvY2spOw0KPiA+ID4gPiA+ID4gICAgICAgYWNjZXNzLT5pY3R4ID0gaWN0eDsNCj4g
PiA+ID4gPiA+ICAgICAgIGlvbW11ZmRfY3R4X2dldChpY3R4KTsNCj4gPiA+ID4gPg0KPiA+ID4g
PiA+IHRoaXMgcmVmY250IGdldCBzaG91bGQgYmUgbW92ZWQgdG8gdGhlIHN0YXJ0IGdpdmVuIG5l
eHQgcGF0Y2gNCj4gPiA+ID4gPiByZW1vdmVzIHRoZSByZWZlcmVuY2UgaW4gdGhlIGNhbGxlciBz
aWRlLg0KDQpUaGlzIGNoYW5nZSBpcyBvayBidXQgc2VlbXMgbm90IG5lY2Vzc2FyeS4NCg0KWWVz
LCB2ZmlvX2lvbW11ZmRfZW11bGF0ZWRfYmluZCgpIHdpbGwgbm90IGhhdmUgcmVmZXJlbmNlIG9u
IHRoZQ0KaWN0eCBhZnRlciB0aGUgbmV4dCBwYXRjaC4gSG93ZXZlciwgaXQgZ2V0cyByZWZlcmVu
Y2Ugb25seSBiZWNhdXNlIGl0DQp3YW50cyB0byBzdG9yZSBpdCBpbiB2ZmlvX2RldmljZS4gTm93
LCBpdCBkb2VzIG5vdCBzdG9yZSBpdC4gU28gbm8gZ2V0Lg0KSSB0aGluayB0aGUgY2FsbGVyIG9m
IHZmaW9faW9tbXVmZF9lbXVsYXRlZF9iaW5kKCkgc2hvdWxkIGVuc3VyZQ0KdGhlIGljdHggaXMg
dmFsaWQuIEFsc28gY2hlY2sgdGhlIHBoeXNpY2FsIGRldmljZSBiaW5kLiBTbyBtYXliZSBub3QN
Cm5lY2Vzc2FyeSB0byBnZXQgaWN0eCBiZWZvcmUgY2FsbGluZyBpb21tdWZkX2FjY2Vzc19jcmVh
dGUoKS4gVGhpcyBpcw0KdGhlIHNhbWUgd2l0aCB0aGUgdmZpb19pb21tdWZkX3BoeXNpY2FsX2Jp
bmQoKSB3aGljaCBjYWxscw0KaW9tbXVmZF9kZXZpY2VfYmluZCgpIHdpdGhvdXQgaWN0eCBnZXQs
IGFuZCBpb21tdWZkX2RldmljZV9iaW5kKCkNCmFsc28gZ2V0cyBpY3R4IGluIHRoZSBlbmQuDQog
DQpJZiBpdCdzIHJlYWxseSBuZWNlc3NhcnksIG1heWJlIGxldCB0aGUgdmZpb19pb21tdWZkX3Bo
eXNpY2FsX2JpbmQoKQ0KYW5kIHZmaW9faW9tbXVmZF9lbXVsYXRlZF9iaW5kKCkgZ2V0L3B1dCBp
Y3R4IGFyb3VuZCBjYWxsaW5nDQppb21tdWZkX2FjY2Vzc19jcmVhdGUoKS9pb21tdWZkX2Rldmlj
ZV9iaW5kKCkuDQoNCj4gPiA+ID4NCj4gPiA+ID4gSSBkb24ndCBmZWVsIHF1aXRlIGNvbnZpbmNp
bmcgdG8ganVzdGlmeSBmb3IgbW92aW5nIGl0IGluIHRoaXMNCj4gPiA+ID4gcGF0Y2guIFBlcmhh
cHMgd2Ugc2hvdWxkIGRvIHRoYXQgaW4gdGhlIGZvbGxvd2luZyBwYXRjaCwgd2hlcmUNCj4gPiA+
ID4gaXQgbmVlZHMgdGhpcz8gT3IgYW5vdGhlciBpbmRpdmlkdWFsIHBhdGNoIG1vdmluZyB0aGlz
IGFsb25lPw0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IE5leHQgcGF0Y2guIEkganVzdCB0cmllZCB0
byBwb2ludCBvdXQgdGhlIHJlcXVpcmVkIGNoYW5nZSBjYXVzZWQNCj4gPiA+IGJ5IG5leHQgcGF0
Y2guIPCfmIoNCj4NCj4gPiBPSy4gSSBtYWRlIGEgc21hbGwgaW5kaXZpZHVhbCBwYXRjaC4gUG9z
dGluZyBoZXJlIHNvIFlpIGNhbiBqdXN0DQo+ID4gc3F1YXNoIGl0IGludG8gdGhlIG5leHQgcGF0
Y2g6DQo+ID4NCj4gPiBGcm9tIGRiZmU3NDU3ZDM1ZWE5YTRkYTljOGU2ZGFhODM4YjEwMWJjOGY2
MjEgTW9uIFNlcCAxNyAwMDowMDowMA0KPiA+IDIwMDENCj4gPiBGcm9tOiBOaWNvbGluIENoZW4g
PG5pY29saW5jQG52aWRpYS5jb20+DQo+ID4gRGF0ZTogVHVlLCAxNCBNYXIgMjAyMyAxMjo1MTow
NyAtMDcwMA0KPiA+IFN1YmplY3Q6IFtQQVRDSF0gaW9tbXVmZC9kZXZpY2U6IERvIGlvbW11ZmRf
Y3R4X2dldCgpIGF0IHRoZSB0b3Agb2YNCj4gPiAgaW9tbXVmZF9hY2Nlc3NfY3JlYXRlKCkNCj4g
Pg0KPiA+IFRoZSBmb2xsb3dpbmcgcGF0Y2ggd2lsbCByZW1vdmUgdGhlIGlvbW11ZmRfY3R4X2dl
dCgpIGNhbGwgcHJpb3IgdG8gdGhlDQo+ID4gaW9tbXVmZF9hY2Nlc3NfY3JlYXRlKCkgY2FsbCBp
biB2ZmlvX2lvbW11ZmRfZW11bGF0ZWRfYmluZCgpLA0KPiBleHBlY3RpbmcNCj4gPiBpb21tdWZk
X2FjY2Vzc19jcmVhdGUoKSBjYWxsIGNvdmVycyB0aGUgaW9tbXVmZF9jdHhfZ2V0KCkuIEhvd2V2
ZXIsDQo+IHRoZQ0KPiA+IGlvbW11ZmRfYWNjZXNzX2NyZWF0ZSgpIG9ubHkgZG9lcyBpb21tdWZk
X2N0eF9nZXQoKSBhdCB0aGUgZW5kLiBUaHVzLA0KPiA+IG1vdmUgdGhlIGlvbW11ZmRfY3R4X2dl
dCgpIGNhbGwgdG8gdGhlIHRvcCBvZiBpb21tdWZkX2FjY2Vzc19jcmVhdGUoKS4NCj4gPg0KPiA+
IFN1Z2dlc3RlZC1ieTogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gU2ln
bmVkLW9mZi1ieTogTmljb2xpbiBDaGVuIDxuaWNvbGluY0BudmlkaWEuY29tPg0KPiA+IC0tLQ0K
PiA+ICBkcml2ZXJzL2lvbW11L2lvbW11ZmQvZGV2aWNlLmMgfCA2ICsrKystLQ0KPiA+ICAxIGZp
bGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW9tbXVmZC9kZXZpY2UuYw0KPiA+IGIvZHJpdmVycy9p
b21tdS9pb21tdWZkL2RldmljZS5jDQo+ID4gaW5kZXggMDEzMjgwMzQ0OWJlLi5kYzEwMTViMDJh
NTMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pb21tdS9pb21tdWZkL2RldmljZS5jDQo+ID4g
KysrIGIvZHJpdmVycy9pb21tdS9pb21tdWZkL2RldmljZS5jDQo+ID4gQEAgLTY0OSwxMyArNjQ5
LDE2IEBAIGlvbW11ZmRfYWNjZXNzX2NyZWF0ZShzdHJ1Y3QgaW9tbXVmZF9jdHgNCj4gKmljdHgs
DQo+ID4gIHsNCj4gPiAgCXN0cnVjdCBpb21tdWZkX2FjY2VzcyAqYWNjZXNzOw0KPiA+DQo+ID4g
Kwlpb21tdWZkX2N0eF9nZXQoaWN0eCk7DQo+ID4gIAkvKg0KPiA+ICAJICogVGhlcmUgaXMgbm8g
dUFQSSBmb3IgdGhlIGFjY2VzcyBvYmplY3QsIGJ1dCB0byBrZWVwIHRoaW5ncw0KPiA+IHN5bW1l
dHJpYw0KPiA+ICAJICogdXNlIHRoZSBvYmplY3QgaW5mcmFzdHJ1Y3R1cmUgYW55aG93Lg0KPiA+
ICAJICovDQo+ID4gIAlhY2Nlc3MgPSBpb21tdWZkX29iamVjdF9hbGxvYyhpY3R4LCBhY2Nlc3Ms
DQo+IElPTU1VRkRfT0JKX0FDQ0VTUyk7DQo+ID4gLQlpZiAoSVNfRVJSKGFjY2VzcykpDQo+ID4g
KwlpZiAoSVNfRVJSKGFjY2VzcykpIHsNCj4gPiArCQlpb21tdWZkX2N0eF9wdXQoaWN0eCk7DQo+
ID4gIAkJcmV0dXJuIGFjY2VzczsNCj4gPiArCX0NCj4gPg0KPiA+ICAJYWNjZXNzLT5kYXRhID0g
ZGF0YTsNCj4gPiAgCWFjY2Vzcy0+b3BzID0gb3BzOw0KPiA+IEBAIC02NjgsNyArNjcxLDYgQEAg
aW9tbXVmZF9hY2Nlc3NfY3JlYXRlKHN0cnVjdCBpb21tdWZkX2N0eCAqaWN0eCwNCj4gPiAgCS8q
IFRoZSBjYWxsaW5nIGRyaXZlciBpcyBhIHVzZXIgdW50aWwgaW9tbXVmZF9hY2Nlc3NfZGVzdHJv
eSgpICovDQo+ID4gIAlyZWZjb3VudF9pbmMoJmFjY2Vzcy0+b2JqLnVzZXJzKTsNCj4gPiAgCWFj
Y2Vzcy0+aWN0eCA9IGljdHg7DQo+ID4gLQlpb21tdWZkX2N0eF9nZXQoaWN0eCk7DQo+ID4gIAlp
b21tdWZkX29iamVjdF9maW5hbGl6ZShpY3R4LCAmYWNjZXNzLT5vYmopOw0KPiA+ICAJcmV0dXJu
IGFjY2VzczsNCj4gPiAgfQ0KPiANCj4gUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRp
YW5AaW50ZWwuY29tPg0K
