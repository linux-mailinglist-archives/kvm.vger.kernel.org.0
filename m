Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1BC787E40
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 05:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbjHYDGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 23:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbjHYDGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 23:06:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68854198E;
        Thu, 24 Aug 2023 20:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692932764; x=1724468764;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N/b5+GHofggcDFl/fb8myxTFGboJ1F6H3xNVzVrTQNw=;
  b=MJstc+kxA7lQB/huJw1Xv9i80j4+9GLjFWzHlKmAvlE03AvxRbRnd7oW
   1C9dgdeiFpQPIIDLwmiH6kYgxyp0ieXghlsNOx9vVQXOfC0z4+9s1aYNU
   R0wctxKoWlo6oe8Q7gkEXVYW6TBuX+Atv/2zLK7g8+TrA2s7p0LEHBlMV
   WO+aqb40daI3wUEXPaj1TM7qae2Q6pJCHeZ1TuvtfluyJQ/wGEyeQv7iM
   B37LXuGsAEJwNETgH3hDN+HLdz9+YDl/tM2V6jNdmpWELBATvc8LFQhqX
   77RdUA2MnAbp2bICjlcmSvwygseWhU4XdK+yOi70mJILhwotwPqBVIlh9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="372014643"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="372014643"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 20:06:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="911138390"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="911138390"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 24 Aug 2023 20:06:02 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 20:06:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 20:06:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 24 Aug 2023 20:06:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 24 Aug 2023 20:05:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cW9U7yzST/iTSyPmMY+00oZvLofF2TxA//Dmv0lxWQ+U8+UGpyu/hfd5g09W2dl99rVVkkdZ6ypl6vLaJk+bbNRPnLVZHvbjLhevd/OvyjCJbmvBS4lKg6YsraJqy8fnNIU0bm5z7LbGe8mHPFK58UrPUbh/H5Z8dDi72DkzRHcNDtZYdKri0IpuM7PxMHC5RCuvyxMyhF9WXp7d/YfF05mYQ58qoledn7UhnZoAaJ1f/qDaTGVyLFxqs3pKiSg+1vaq+tFuTZ2y0C0SgxM+bVkJzVOlfasTmLvkAtyDwK8z+Sb/AHq3+RQ7icuO2gBnC/KxCuWeesV0K2567D1oiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/b5+GHofggcDFl/fb8myxTFGboJ1F6H3xNVzVrTQNw=;
 b=duzEpKUqVQE00ackFSV3sMNibsv0tAv9kDo8sNaRVVXKfEoZ2qjqN5Nb2T8GQj3+EiNjQsBK/SGJbwFjBA7QWGAgGzAR9hAiI0+h0dEb9BHSKz+XXN8tNojZWAPz/gL/FQTZSkc5xTLN+GQ6RASOwJQRPykPiVPTp4wNX0SI3UQAlSpx26v2HfRUzWgwPdysoalY9LGrAl+3AAXx/rd1Z1aYlOhDqmhsk8BxmC3LU8lFc1v1wv/TMsl2uHJm4Q+jqV1BeHrdGtKmQZ9ilY9OXTdljdg0KnOYIRrMKtgVi4VmtRUnoTC84wvZl4g9YHU/pwld5mLANC6KDPyJs6ftMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY1PR11MB8054.namprd11.prod.outlook.com (2603:10b6:a03:52f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.29; Fri, 25 Aug
 2023 03:05:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.027; Fri, 25 Aug 2023
 03:05:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 2/3] vfio/ims: Support emulated interrupts
Thread-Topic: [RFC PATCH 2/3] vfio/ims: Support emulated interrupts
Thread-Index: AQHZ1qZCw07lj8k3WkK0UGDEHD+jla/5pAUAgAAM1QCAAJ0fQA==
Date:   Fri, 25 Aug 2023 03:05:52 +0000
Message-ID: <BN9PR11MB5276D9778C48BD2FD73CE9658CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1692892275.git.reinette.chatre@intel.com>
 <7a08c41e1825095814f8c35854d3938c084b2368.1692892275.git.reinette.chatre@intel.com>
 <ZOeGQrRCqf87Joec@nvidia.com>
 <84629316-dafa-9f4e-89e9-40ccaee016de@intel.com>
In-Reply-To: <84629316-dafa-9f4e-89e9-40ccaee016de@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BY1PR11MB8054:EE_
x-ms-office365-filtering-correlation-id: 86ddd572-593e-4285-b89e-08dba518312b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: icggwK6DH3rFeyDbbS61V0X5Y04yCijvOFb/ynW/iw2Frhd2REFFarN/xyrWi2VCFj+frmChlAWujWFVES0AWg4U6WIqLa5JKae4fnbdgMJvEsSKANwOqq2q7LUsOTU2eqMCRMbIpKtj0K+8eVZXi2IRXfg6Tyunr2D2DAwLUR8kzq9aNzU7gfuymshI0bt7LivPEg4lT4pf/ZQxJ8rYcbh0PSVfIQzt0Hc+UIR4wI3Z/LEeTXtvLk2t+K6Zg7IVoX85qoVjg1enmiGNfkQnSAE1jM/19/3qHsyHauT2yB8X+NpZvSiwEQ42NwQ2aFZ30y/zR6JNa6MXCUNSET2DfWr4KbwdzAsuKMvh2rAQZ5A03eEi8S+8UIa+C624QZeZITQAzY5KjTxg2rv7T5X8RdZDI3dfNWNjx2dhhee5dqR0OXxsSQvY6mAW6sAPS4vgjhpB03kSayGIP4f52R/X8ymeJUuV27mPnliPjxMYohpWfh3DalA8LySv3XKNQEu81IDOWGuXuFIwaGTeA3V5lISo9pXTCQpaUnbLIjCooSdLHsCiJOvuq4Jy6d7oIWC8N0gFjTMOod3YTx/e+/TqAeSOjfiZAKo+S/r6P35mIqqXQP214TiA7Q35oZM2CtAr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199024)(1800799009)(186009)(82960400001)(122000001)(38070700005)(38100700002)(4326008)(8676002)(8936002)(41300700001)(53546011)(6506007)(7696005)(316002)(33656002)(66446008)(64756008)(54906003)(71200400001)(66476007)(66556008)(110136005)(76116006)(66946007)(86362001)(9686003)(55016003)(26005)(478600001)(83380400001)(2906002)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFVxTHRuV1NtbU53S09abkIvUTNrS0d2dkRCOHVYWnV2SHNweVNpb21LUmNh?=
 =?utf-8?B?a0UrUitwVXZ0UG1FREtlSUxrNTAwVWdKbUQzSVVKSHY2WnlSWk5oNTlSeFFL?=
 =?utf-8?B?YmVCRlJnc3RaRlh4bjRYOXhLS0lkMENuUmRYeWJFZFg5Q2Y0THZaTnMySk4x?=
 =?utf-8?B?N3lDK0RQTTFvRjMzQlUwbnUraGlnekEvUzBmRHBHSVkwUlJLQVg1YnFndWtQ?=
 =?utf-8?B?dng4OWt2L2ZjVHcvWWxwZVdkM1U2ZVhsa3VERGQ2VktHMWh3Wk4rNm5LcVFS?=
 =?utf-8?B?RklKY0xVN1NNMUk5NGVSMFJFQjFuQTM3OXNUbFNsdmVPVHY5bWJCUjRKTVkr?=
 =?utf-8?B?dEV2anhIL25HVW9ILzJaY0RGVU5FUm8wOTlYMSsxVEZ1RWk1OHU5Y3RPc0s1?=
 =?utf-8?B?ZFpXbVZGVWluWjh0TDN0YmYzeDI5YWZTcHVzUUYrcG9abUpOMkN0K0oyU0ho?=
 =?utf-8?B?V0pWVDErKzFKZUFkNlJybzMyUWtKTW8xQmpvajUrVUdpaHNzRU1PYjBzV3Zt?=
 =?utf-8?B?KzRFVnlTL3EyVzFNejBockF5bndTYmJFZ0ZvMmU5dUhqT1lqTnhRQVBuUTF0?=
 =?utf-8?B?ZFpsTllGV01Va0Rwd1IwcERxSDRKUW9iQzBweFA5ZDc1aUdwR3Q1eXc0ckZz?=
 =?utf-8?B?cERoMkI2RVlhWnNzZFJLMXJiQS83amFpLzhKYURUaUxrUXgyMmY1aGk1bmVV?=
 =?utf-8?B?WDI3MS9aMmZ4M1NOOXBKd1FBWTNQUHpISWg3VVNIckNvNW5jYm9TMGNYY3BW?=
 =?utf-8?B?MU5HRkc3eDNhd3R2N0FmOG1nb2JYazJVeFF0WXBhcFN3M0RxOVprSTBsZkJV?=
 =?utf-8?B?bFZrYVhtZXVKRHhLY1E1VFFIbkJuRlEzMGJRVlRlWHpRdjlQdkFPanJ0U2hN?=
 =?utf-8?B?L2gxcXJxODBUWkN0bUlrSlRyR0J4WjRXSHR0eFgySUdpZ0MxV2dEYVFjTmpr?=
 =?utf-8?B?cTdrdmRpZXMvOGhWTzVsdVpnbnBMVUhVRmNuVFp3M2haeUVVZHM2SkxZUGJt?=
 =?utf-8?B?MG9Za1pQZTlyQitvTWw1TmZMTjFxL2pOWjR1eFVrVFlTY2tDVUdhQU9jNURB?=
 =?utf-8?B?ZHA1cFdnaFhlNW5FOXp3bHRka3gzMkRNR2Z3b2x3cC9GNzNzWjQ0TVdCYXE5?=
 =?utf-8?B?clJlTDJCdTd3czJ2Rm1UYktFcWpaNm9ZZnhGS3JHS3ZrMUhHNlBMeldva0Vz?=
 =?utf-8?B?Zitmdk0xTzRPRmFJSWpXVU5QWE1NSDVwOHoxUkU0MDdMalk1Y0RxTENxbXlX?=
 =?utf-8?B?dUJNV24yTUJ5OGlmdjVqWGNVR3ByOW9YTUtieVhQZk5FMXpJcmt4THpJUW1j?=
 =?utf-8?B?aU5rYnU5NkpFYUxoSkZteG04MUI3bXkvREVZOXRyVjRXSGZ6a2NwM2pDVnlS?=
 =?utf-8?B?Y1JCTFNsemFPWC9ZQTlMVGt2cFYrSGg3clJ4SzlWT29XTzFhZ2lzTFNWV0cw?=
 =?utf-8?B?c3JJQ1JDNlRyTHNPS3cvbUxObW84ZHlraUgyMXdhWVB1b1krTUJNTDdPY0hI?=
 =?utf-8?B?b3huY25lcWk2bWxIQlRVYkFTTkRlUVd3SVo1QnQ4RXFTVmRaZUIyZ0F4VFFx?=
 =?utf-8?B?Vmxva1VZcnBsTjVrVDNqQi9QOSs3dW41aURjcVJUQmlWRzQ1SGl4SlJXcHEx?=
 =?utf-8?B?VlhHWHFRWDk1N0owTkNtREluUEFYSUg3WDJxdmtvYTlvUG1lR3M2K2luRTEr?=
 =?utf-8?B?MUdMK3cvUVJWc3dFZTRBTjdVNk9NbTNvRGxVY3Y4NEhCeE9aamRhRzd4a3pE?=
 =?utf-8?B?RWk4dkJmZUJaLzg0b0dwZVF4aU9NNVlCWXlGTjFCeDFVVDM2UDdZL0pVR01x?=
 =?utf-8?B?blUvS01GeldsWk5hRHg0RHJOQVI5MThEc2JOYVRnYkllTE00Mm9ZaGxmeDhs?=
 =?utf-8?B?QU9ncXROdXVPbjgxK0R6alIyZ2pBMy9EZkJwRjhFdkJ1Tnl3eHFCcDRSMnU1?=
 =?utf-8?B?b2tqcWJlTkthN0x6Q01qMDV3dmpOVDNOV1MyWHdJSnBDZUhZd1I0U21SbExG?=
 =?utf-8?B?ZE9YNk9obzZmS3pGSkFOYWFQckFaRzF3QzU5WitkNGFYak9OOUlMTFlYR1Nn?=
 =?utf-8?B?TkdsTWl3dTJDSmZoSXJEMWpINHBIc0dPRzY1VFNGZnBRdGM5cThvWTBpNVRT?=
 =?utf-8?Q?dF9RusJG+YyI4V0jb+2IUfRdb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ddd572-593e-4285-b89e-08dba518312b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 03:05:52.5344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ox4pKsdeMVrWcOVlm4xcOha7DXnswnbakOSq66iETJ1E/qZjy4+BWfiwkQ/dlZ0J+0vk3dgIQg6/VRknfkXUXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8054
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBDaGF0cmUsIFJlaW5ldHRlIDxyZWluZXR0ZS5jaGF0cmVAaW50ZWwuY29tPg0KPiBT
ZW50OiBGcmlkYXksIEF1Z3VzdCAyNSwgMjAyMyAxOjE5IEFNDQo+IA0KPiBIaSBKYXNvbiwNCj4g
DQo+IE9uIDgvMjQvMjAyMyA5OjMzIEFNLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+ID4gT24g
VGh1LCBBdWcgMjQsIDIwMjMgYXQgMDk6MTU6MjFBTSAtMDcwMCwgUmVpbmV0dGUgQ2hhdHJlIHdy
b3RlOg0KPiA+PiBBY2Nlc3MgZnJvbSBhIGd1ZXN0IHRvIGEgdmlydHVhbCBkZXZpY2UgbWF5IGJl
IGVpdGhlciAnZGlyZWN0LXBhdGgnLA0KPiA+PiB3aGVyZSB0aGUgZ3Vlc3QgaW50ZXJhY3RzIGRp
cmVjdGx5IHdpdGggdGhlIHVuZGVybHlpbmcgaGFyZHdhcmUsDQo+ID4+IG9yICdpbnRlcmNlcHRl
ZCBwYXRoJyB3aGVyZSB0aGUgdmlydHVhbCBkZXZpY2UgZW11bGF0ZXMgb3BlcmF0aW9ucy4NCj4g
Pj4NCj4gPj4gU3VwcG9ydCBlbXVsYXRlZCBpbnRlcnJ1cHRzIHRoYXQgY2FuIGJlIHVzZWQgdG8g
aGFuZGxlICdpbnRlcmNlcHRlZA0KPiA+PiBwYXRoJyBvcGVyYXRpb25zLiBGb3IgZXhhbXBsZSwg
YSB2aXJ0dWFsIGRldmljZSBtYXkgdXNlICdpbnRlcmNlcHRlZA0KPiA+PiBwYXRoJyBmb3IgY29u
ZmlndXJhdGlvbi4gRG9pbmcgc28sIGNvbmZpZ3VyYXRpb24gcmVxdWVzdHMgaW50ZXJjZXB0ZWQN
Cj4gPj4gYnkgdGhlIHZpcnR1YWwgZGV2aWNlIGRyaXZlciBhcmUgaGFuZGxlZCB3aXRoaW4gdGhl
IHZpcnR1YWwgZGV2aWNlDQo+ID4+IGRyaXZlciB3aXRoIGNvbXBsZXRpb24gc2lnbmFsZWQgdG8g
dGhlIGd1ZXN0IHdpdGhvdXQgaW50ZXJhY3Rpbmcgd2l0aA0KPiA+PiB0aGUgdW5kZXJseWluZyBo
YXJkd2FyZS4NCj4gPg0KPiA+IFdoeSBkb2VzIHRoaXMgaGF2ZSBhbnl0aGluZyB0byBkbyB3aXRo
IElNUz8gSSB0aG91Z2h0IHRoZSBwb2ludCBoZXJlDQo+ID4gd2FzIHRoYXQgSU1TIHdhcyBzb21l
IGJhY2sgZW5kIHRvIHRoZSBNU0ktWCBlbXVsYXRpb24gLSBzaG91bGQgYQ0KPiA+IHB1cmVseSBl
bXVsYXRlZCBpbnRlcnJ1cHQgbG9naWNhbGx5IGJlIHBhcnQgb2YgdGhlIE1TSSBjb2RlLCBub3Qg
SU1TPw0KPiANCj4gWW91IGFyZSBjb3JyZWN0LCBhbiBlbXVsYXRlZCBpbnRlcnJ1cHQgaXMgbm90
IHVuaXF1ZSB0byBJTVMuDQo+IA0KPiBUaGUgdGFyZ2V0IHVzYWdlIG9mIHRoaXMgbGlicmFyeSBp
cyBieSBwdXJlKD8pIFZGSU8gZGV2aWNlcyAoc3RydWN0DQo+IHZmaW9fZGV2aWNlKS4gVGhlc2Ug
YXJlIHZpcnR1YWwgZGV2aWNlcyB0aGF0IGFyZSBjb21wb3NlZCBieSBzZXBhcmF0ZQ0KPiBWRklP
IGRyaXZlcnMuIEZvciBleGFtcGxlLCBhIHNpbmdsZSByZXNvdXJjZSBvZiBhbiBhY2NlbGVyYXRv
ciBkZXZpY2UNCj4gY2FuIGJlIGNvbXBvc2VkIGludG8gYSBzdGFuZC1hbG9uZSB2aXJ0dWFsIGRl
dmljZSBmb3IgdXNlIGJ5IGEgZ3Vlc3QuDQo+IA0KPiBUaHJvdWdoIGl0cyBBUEkgYW5kIGltcGxl
bWVudGF0aW9uIHRoZSBjdXJyZW50IFZGSU8gTVNJDQo+IGNvZGUgZXhwZWN0cyB0byB3b3JrIHdp
dGggYWN0dWFsIFBDSSBkZXZpY2VzIChzdHJ1Y3QNCj4gdmZpb19wY2lfY29yZV9kZXZpY2UpLiBX
aXRoIHRoZSB0YXJnZXQgdXNhZ2Ugbm90IGJlaW5nIGFuDQo+IGFjdHVhbCBQQ0kgZGV2aWNlIHRo
ZSBWRklPIE1TSSBjb2RlIHdhcyBub3QgZm91bmQgdG8gYmUgYSBnb29kDQo+IGZpdCBhbmQgdGh1
cyB0aGlzIGltcGxlbWVudGF0aW9uIGRvZXMgbm90IGJ1aWxkIG9uIGN1cnJlbnQgTVNJDQo+IHN1
cHBvcnQuDQo+IA0KDQpUaGlzIG1pZ2h0IGJlIGFjaGlldmVkIGJ5IGNyZWF0aW5nIGEgc3RydWN0
dXJlIHZmaW9fcGNpX2ludHJfY3R4DQppbmNsdWRlZCBieSB2ZmlvX3BjaV9jb3JlX2RldmljZSBh
bmQgb3RoZXIgdmZpbyBkZXZpY2UgdHlwZXMuIFRoZW4NCm1vdmUgdmZpb19wY2lfaW50ci5jIHRv
IG9wZXJhdGUgb24gdmZpb19wY2lfaW50cl9jdHggaW5zdGVhZCBvZg0KdmZpb19wY2lfY29yZV9k
ZXZpY2UgdG8gbWFrZSBNU0kgZnJvbnRlbmQgY29kZSBzaGFyYWJsZSBieSBib3RoDQpQQ0kgZGV2
aWNlcyBvciB2aXJ0dWFsIGRldmljZXMgKG1kZXYgb3IgU0lPVikuDQoNClRoZW4gdGhlcmUgaXMg
b25seSBvbmUgaXJxX2N0eC4gV2l0aGluIHRoZSBjdHggd2UgY2FuIGFic3RyYWN0DQpiYWNrZW5k
IG9wcywgZS5nLiBlbmFibGUvZGlzYmxlX21zaSgpLCBhbGxvYy9mcmVlX2N0eCgpLCBhbGxvYy9m
cmVlX2lycSgpLCBldGMuDQp0byBhY2NvbW1vZGF0ZSBwY2kgTVNJL01TSS1YLCBJTVMsIG9yIGVt
dWxhdGlvbi4NCg0KVGhlIHVua25vd24gcmlzayBpcyB3aGV0aGVyIGEgY2xlYXIgYWJzdHJhY3Rp
b24gY2FuIGJlIGRlZmluZWQuIElmDQppbiB0aGUgZW5kIHRoZSBjb21tb24gbGlicmFyeSBjb250
YWlucyBtYW55IGlmLWVsc2UgdG8gaGFuZGxlIHN1YnRsZQ0KYmFja2VuZCBkaWZmZXJlbmNlcyB0
aGVuIGl0IG1pZ2h0IG5vdCBiZSBhIGdvb2QgY2hvaWNlLi4uDQo=
