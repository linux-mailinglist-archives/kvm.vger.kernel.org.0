Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0827A6BACD6
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 10:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjCOJ70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 05:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjCOJ7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 05:59:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3313487349;
        Wed, 15 Mar 2023 02:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678874260; x=1710410260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=d4UEnfVlofC1uiWj2LR79TcuBAoXekziH6VP4Z7jP2s=;
  b=FD1NfUyotvj5YNkdleMjBDA9rZkX7CNMDR5G3n5K+IkSofPLGYZ+XYqf
   2mVO69FIbFF1nyHTZnk0qwevqsEWR/Q1FuTKcHsBTRt8hUjY8mR4eR2AS
   ELuPn0t9LDPWhjbV6vscQG8h3ahJulo0GEFqkIj/2qs2rjvl3MzvAkYHh
   SU8AUADVJMOfWKuGMKUcMA771xoZMMJ2OYO0xJQOQZNANRc/btaV4unhq
   PD2xswEo/YfP7jaGp6ioikPE+zYK7oNMPdRTTDg1r9FBX6Hg4+t/aVYeL
   HCywNmGq4naY4R3Bj5TuL45bvKJk+hzrOyov90i3vkyDEWfgUPRVwBPBN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="340023550"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="340023550"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:57:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="743628542"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="743628542"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 15 Mar 2023 02:57:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:57:37 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:57:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 02:57:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 02:57:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixJdeC9/vf4C8qAtUu7Zm1qHaiLx3bEC54qJX6/hB4s2H0Vowse5FeV6jQSvGJItpi3ZKQk0bbw9ZBbFLfv3qP9RalywMJfLgteZ3JQXSAQIHNE+5xrAK6nZW1TNhyZYPcOKbrSZDN8Z6VQtlmN+LSslzdL9UtPwtJ4Eu2mx1wWwiEP84nY1NuBNFoVYKNi6LSNSoTZngiRY+NwHQ1Ko8qjGxyjA2WFkjUZuI5E2Z9oF1kIUR+DOuPKZhKJ4MtJbX10GRY3Dvbd4ifT4dBhzsrqIdp1fdAyYyRjpoCrq6lFu4czaQgqIi9pA/eKhIWgsoNS2HyRyU5NJISb+7HiNww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4UEnfVlofC1uiWj2LR79TcuBAoXekziH6VP4Z7jP2s=;
 b=hxhr3A7fAMROcsGXu4wqfGHG0KJ1CKP0az3xN/P4tXiLhv0G2FyCgG9MR1c5C5JeHZL+N0qvVsXVVu3+WNGW4aNKKTMk95A59KuvAwKZmzOp/DTrx4NwEPsHY/gs+/P2KDMl4ijR9eItFHs9qxtK4y/bDQN/9erth1cWvvgzf1+/zkzCxOYHzWGo5n3emRU5Pu0wn0wdL+t5fxq1oRb7wkbpDiOLYaoyS5pwMGtFCgMLCJxk4Cbz56d/BHipe4rT98GqrmvtUhkKKL0nja15f0kdPSKtAbzEnid21y/4jIgJrIhHRho8ObripmfvnWk6yKlWWXMpPkVO/7wuZNkPIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5293.namprd11.prod.outlook.com (2603:10b6:5:390::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:57:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 09:57:35 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v13 004/113] KVM: TDX: Initialize logical processor when
 onlined
Thread-Topic: [PATCH v13 004/113] KVM: TDX: Initialize logical processor when
 onlined
Thread-Index: AQHZVQwsoPylvipHqkGgpDMo0xja1q77nwYA
Date:   Wed, 15 Mar 2023 09:57:34 +0000
Message-ID: <c4dfef93d3df7266e2873c3115ee1886d4f7cbb4.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <82616f9c8a4fadeae48eea42c31aed270f3c25c4.1678643052.git.isaku.yamahata@intel.com>
In-Reply-To: <82616f9c8a4fadeae48eea42c31aed270f3c25c4.1678643052.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5293:EE_
x-ms-office365-filtering-correlation-id: ea3cbf7b-1613-4635-5ef9-08db253bb392
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fTSaaH/1Wbkt7xuz6ffjlWivxmysqngNlOZ11q9BuvdV1+KjCeM2UPZaWXO0AQLRFrlQm1N4Pyq6CjwbfWX+/KrkprB50IIqbyH0fyvanjIkxVQMj5yBRJ4+rlRaFdlk2tSGpzPh/lCBShXR19n4HfbkPldm7HHgSU5A0RtlUZebz206rAoRzWR7mmaP/v3GFBUam5ZSelskPSmRU9h7BwMXS7077pAq7yw0Nd6MS/YudthjuJio9ZO4gCaOnX2pHtS/pbVRqouOBCwJew8BzN5szXxH2G1MxlUQZolXq+IESrW/eMgG+5KN7rqxB+qEuY46t43NOOgS1QflDSXCc7vvZVwqyFo00vnkklLgkircLc+74PMzhdacGOEoKljPXEGMws4cU5zLKYqndbfmR804th0QIAz9+1pYX7n6j85VLoBHvfj8VIn6E1sTgGvZykXnzcnhLaWaZz8wuoPncmE/LmXS7yd16CvBn10Byy0cq8hi5FdaHICRIP3cFcJ+CgH9fvZ6YIgumkbYO21Rs6Fal5ONF2/86ExlbqKW+kRA6qkXssaOwSN2RlJWENERJK8zqXjw5QpcjtGVcTgGvpZwYtR9mPTtRXaA0+MP0zlilSsu74JsmjmBay6ocHho0SC+0faQ+TZ6PEFL4UFfGdwpuBhThUq52J1O9VPOPiBSJGUNgd+VGosWUEXnOmfWQl6nd1HZSGPSPTp4lMPhzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199018)(6486002)(478600001)(83380400001)(186003)(26005)(2616005)(110136005)(91956017)(316002)(76116006)(66556008)(66476007)(66446008)(64756008)(66946007)(54906003)(6636002)(8676002)(71200400001)(6506007)(6512007)(4326008)(41300700001)(8936002)(5660300002)(38100700002)(122000001)(2906002)(82960400001)(36756003)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjlOUktJMFk5VE9qSHhpcDExWFIrT1pxVXlkUmNYV3U4UHJjU21hZkVCSjhN?=
 =?utf-8?B?TlpLVkQrbXZUbkFEeDZHZW55c3QxczlHbzMxNUlJMjJ1cm54NCtPU3EzUnRs?=
 =?utf-8?B?ZGlnRlAyaUpXUHNRNVZEQlhjTno1dWx3blFoRHZ1RkRKOVpjSDlueFlTaVdC?=
 =?utf-8?B?UEpFcFRKU3p2eEUyekp3aUJhTnNUT3VhbHIzbHhEUDgxb1NuQUJzUzd5ajhW?=
 =?utf-8?B?MzUxOGw0cEs2emNldjZmVjJTNFFRZEtjYTFyQWFFUlA1RjZQbHVOV0xFYWxh?=
 =?utf-8?B?bjBhVlV4dDQwUEdnakNwL0hmQnhjYVZja0Q2UlZHS0Z6SDF5b3J1NVB5ekVv?=
 =?utf-8?B?QldqenVEUllORmU4Qy9Ccjd4bWExNVd3MFpLdWpxVGs1RTJVSkN5UlI1eFd5?=
 =?utf-8?B?NGlMMWtUaWVranUzUHVIN1VjdzE0NjhES0RTaVk2VUdMTVBJbE1OSjh3dDdn?=
 =?utf-8?B?L1R5VnMyTUlkbWNKVUdxSURld1V0YUpQS3RpZnZiMEllM1ZHL0FyQWdqQjlF?=
 =?utf-8?B?ZzR6VDRWWXJ1QVJnQXNxWU5leks0VnhTeTY2TUtsd0NFblc0MDRqSUdMV2VZ?=
 =?utf-8?B?OWtTbG5mZGZkcFZMaUFzV0J0ZUlaWXgvV25qdGQ4K2JYT09SZU93eUo4NU5w?=
 =?utf-8?B?WDlxbjJ4b1NaeG9QQVNVOURrYi9FQlZaQnpqWUc3Z2pSbm5FZUxRQlFEOGVQ?=
 =?utf-8?B?b1FqL1dPYlJUVTZmamgwYTM0OUtrNE9kNDJJaGZYRDZkZGk1dWhMcDFyUzVL?=
 =?utf-8?B?TnRDeEtZUi94dkhESCtkRkJSY1FwVjdpRFI5Y25nL2J1TEkzNERrU2ErNmI1?=
 =?utf-8?B?YUo1ajZzbHB2RE5zZXNVanB0VElaZXF4cWQ1ZzVMd2ZUekdwMHpWdTgvNW9B?=
 =?utf-8?B?NUNCSzlCL2VlZkNVcFhxREhkRmlIMnBlSFNpNWNyd3NUVEZ5eDV2WGo4NUwy?=
 =?utf-8?B?YnN6WXZTN1VoeFV3a04vN2ZucnhrY3k2WFV2eC9hbG5HdzFkaitoeURaUENt?=
 =?utf-8?B?UVl0WmkyblBTV1ltVCs5NlBuc1JlYjNwbkxxZFBGS1NnYmw1cW0yWGRUb1h2?=
 =?utf-8?B?Mnd0UWxpaTNodEZaWVV3OEE0QUUyQjNtZ2JXSk9oL3c0ZHJhYzlUNWl5R29J?=
 =?utf-8?B?Y3FyNUNKSnhGbWRuZEtZTVZpVE9DOVZEakhNWGVQRTJqZDlQYTRudm9aV2Mx?=
 =?utf-8?B?K0NXdkRUNmd5d1ROVytNdS9rczFKbzdQYlpwMU1ONDA3VjcrWndDd0NSZWdo?=
 =?utf-8?B?U1FyU2tjTVFSSDZNbWthZTRTUmJqZ2FZNlpnZFc2WndVL0t4S053WDl1dHZN?=
 =?utf-8?B?U0l2c3pVcVUrWURkY0MyZTgwME5GWUxXUHV0L29PZWtVZ2o5TVZqa3VSUTV4?=
 =?utf-8?B?NVJ5b3c0eGVVSi90d29neno3K1hUVFI2Wk51dkowY2dOZGdYRUVkNGc2aXo5?=
 =?utf-8?B?VlZ4aTVkTjUyb1pPdDMvZGpxaURSSHpyakdzK1oyYThnYVgrT3FzM3JRYTBn?=
 =?utf-8?B?MlhHY2xVa0ZKWFVySnUyMHZCaFZ3clprWlFiZzV3STRncGlOVWJwY1RsTzRZ?=
 =?utf-8?B?ZHltUUY0d3hQM3Z6Tzc2bWZRYW9maityeGtRTVNsUzJuclpydjFtMlZlYlZB?=
 =?utf-8?B?VWMrYVdNdTlrcnBYU2xWUENNKzRnU3VkcklvMHJBVFZzU1hHZ3FSTHdJR3Z4?=
 =?utf-8?B?ckZTT3Iyc3ZZNWxrQ2UvdWhtRFViNUxsK3VRN3lybFpGYUpGNWZPbFZ3Zlpx?=
 =?utf-8?B?V0FMTzQxMTJzcllQTDV1eVFtN2VzTUliU3dTTGlQK2dPYjN4aW1XTjZjckpC?=
 =?utf-8?B?dDdoNHpnR1RaMjMxbDBQV1lKdTdabjhpSTJmeWN4bXdPM0EwejU5eVUyNXJ3?=
 =?utf-8?B?UE0rZXZ4OUFMYnFKNytYcG5lVEtDRjhxVkdmT0s3Q3RybFB5eG5DNzZvdTdz?=
 =?utf-8?B?c29EQmthSE9YTHF4RGNRdVRnbmtQQngrdjEveDZSdmdGOFlFTmFla3h4M25Y?=
 =?utf-8?B?M2tuOU8raUIra0FDbHlpZmM4NjI4R2l5blI3ek8ySDFZNmJiaDhUYTRaVHNH?=
 =?utf-8?B?VGxFR25JQURnWG43ckdiN2xjZXZRVkxqbkxuOHlnWUtGa240OUhIMGphSkFl?=
 =?utf-8?B?V3pxeGJVZ0E5c1daRVluYUlBekxnNG1wOXFpbWRnVjB3M1dYY0lqb2NaVldq?=
 =?utf-8?B?RVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <040BC9F3B1CD3F43A8F113822D4D650E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3cbf7b-1613-4635-5ef9-08db253bb392
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 09:57:34.8757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f/NXAHTCI/mJQbse5Lh3zpYSF8rtZKwJ7dMtBPMzYCxkh04L+vmu1cnWO8u3XQsePZiyqB7mRbGzHsqzzYwssg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5293
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTAzLTEyIGF0IDEwOjU1IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBURFggcmVxdWlyZXMgdG8gY2FsbCBhIFREWCBpbml0aWFsaXphdGlvbiBmdW5j
dGlvbiBwZXIgbG9naWNhbCBwcm9jZXNzb3INCj4gKExQKSBiZWZvcmUgdGhlIExQIHVzZXMgVERY
LiAgV2hlbiBDUFUgaXMgb25saW5lZCwgY2FsbCB0aGUgVERYIExQDQo+IGluaXRpYWxpemF0aW9u
IEFQSSB3aGVuIGNwdSBpcyBvbmxpbmVkLiDCoA0KPiANCg0KRG91YmxlICJ3aGVuIENQVSBpcyBv
bmxpbmVkIi4NCg0KPiBJZiBpdCBmYWlsZWQgcmVmdXNlIG9ubGluaW5pZyBvZg0KPiB0aGUgY3B1
IGZvciBzaW1wbGljaXR5IGluc3RlYWQgb2YgVERYIGF2b2lkaW5nIHRoZSBMUC4NCg0KU29ycnkg
Y2Fubm90IHVuZGVyc3RhbmQgdGhpcyBzZW50ZW5jZSwgcGFydGljdWxhcmx5LCB0aGUgImluc3Rl
YWQgLi4uIiBwYXJ0Lg0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNh
a3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvbWFpbi5j
ICAgIHwgMTUgKysrKysrKysrKysrKystDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3RkeC5jICAgICB8
ICA1ICsrKysrDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3g4Nl9vcHMuaCB8ICAyICsrDQo+ICAzIGZp
bGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L21haW4uYyBiL2FyY2gveDg2L2t2bS92bXgvbWFpbi5j
DQo+IGluZGV4IDVjOWY1ZTAwYjNjNC4uZDFjOWM3ZjU1MDUwIDEwMDY0NA0KPiAtLS0gYS9hcmNo
L3g4Ni9rdm0vdm14L21haW4uYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L21haW4uYw0KPiBA
QCAtOSw2ICs5LDE5IEBADQo+ICBzdGF0aWMgYm9vbCBlbmFibGVfdGR4IF9fcm9fYWZ0ZXJfaW5p
dDsNCj4gIG1vZHVsZV9wYXJhbV9uYW1lZCh0ZHgsIGVuYWJsZV90ZHgsIGJvb2wsIDA0NDQpOw0K
PiAgDQo+ICtzdGF0aWMgaW50IHZ0X2hhcmR3YXJlX2VuYWJsZSh2b2lkKQ0KPiArew0KPiArCWlu
dCByZXQ7DQo+ICsNCj4gKwlyZXQgPSB2bXhfaGFyZHdhcmVfZW5hYmxlKCk7DQo+ICsJaWYgKCFy
ZXQgJiYgZW5hYmxlX3RkeCkgew0KPiArCQlyZXQgPSB0ZHhfaGFyZHdhcmVfZW5hYmxlKCk7DQo+
ICsJCWlmIChyZXQpDQo+ICsJCQl2bXhfaGFyZHdhcmVfZGlzYWJsZSgpOw0KPiArCX0NCj4gKwly
ZXR1cm4gcmV0Ow0KPiArfQ0KPiArDQo+ICBzdGF0aWMgX19pbml0IGludCB2dF9oYXJkd2FyZV9z
ZXR1cCh2b2lkKQ0KPiAgew0KPiAgCWludCByZXQ7DQo+IEBAIC00MCw3ICs1Myw3IEBAIHN0cnVj
dCBrdm1feDg2X29wcyB2dF94ODZfb3BzIF9faW5pdGRhdGEgPSB7DQo+ICANCj4gIAkuaGFyZHdh
cmVfdW5zZXR1cCA9IHZteF9oYXJkd2FyZV91bnNldHVwLA0KPiAgDQo+IC0JLmhhcmR3YXJlX2Vu
YWJsZSA9IHZteF9oYXJkd2FyZV9lbmFibGUsDQo+ICsJLmhhcmR3YXJlX2VuYWJsZSA9IHZ0X2hh
cmR3YXJlX2VuYWJsZSwNCj4gIAkuaGFyZHdhcmVfZGlzYWJsZSA9IHZteF9oYXJkd2FyZV9kaXNh
YmxlLA0KPiAgCS5oYXNfZW11bGF0ZWRfbXNyID0gdm14X2hhc19lbXVsYXRlZF9tc3IsDQo+ICAN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14
L3RkeC5jDQo+IGluZGV4IGYzZWIwMTM4YjYwYi4uZTUxMzE0YmJiNDM5IDEwMDY0NA0KPiAtLS0g
YS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMN
Cj4gQEAgLTEwLDYgKzEwLDExIEBADQo+ICAjdW5kZWYgcHJfZm10DQo+ICAjZGVmaW5lIHByX2Zt
dChmbXQpIEtCVUlMRF9NT0ROQU1FICI6ICIgZm10DQo+ICANCj4gK2ludCB0ZHhfaGFyZHdhcmVf
ZW5hYmxlKHZvaWQpDQo+ICt7DQo+ICsJcmV0dXJuIHRkeF9jcHVfZW5hYmxlKCk7DQo+ICt9DQo+
ICsNCj4gIHN0YXRpYyBpbnQgX19pbml0IHRkeF9tb2R1bGVfc2V0dXAodm9pZCkNCj4gIHsNCj4g
IAlpbnQgcmV0Ow0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC94ODZfb3BzLmggYi9h
cmNoL3g4Ni9rdm0vdm14L3g4Nl9vcHMuaA0KPiBpbmRleCAwZjIwMGFlYWQ0MTEuLjAxMGQwMmM4
NmJhNCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC94ODZfb3BzLmgNCj4gKysrIGIv
YXJjaC94ODYva3ZtL3ZteC94ODZfb3BzLmgNCj4gQEAgLTEzOSw4ICsxMzksMTAgQEAgdm9pZCB2
bXhfc2V0dXBfbWNlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ICANCj4gICNpZmRlZiBDT05G
SUdfSU5URUxfVERYX0hPU1QNCj4gIGludCBfX2luaXQgdGR4X2hhcmR3YXJlX3NldHVwKHN0cnVj
dCBrdm1feDg2X29wcyAqeDg2X29wcyk7DQo+ICtpbnQgdGR4X2hhcmR3YXJlX2VuYWJsZSh2b2lk
KTsNCj4gICNlbHNlDQo+ICBzdGF0aWMgaW5saW5lIGludCB0ZHhfaGFyZHdhcmVfc2V0dXAoc3Ry
dWN0IGt2bV94ODZfb3BzICp4ODZfb3BzKSB7IHJldHVybiAtRU5PU1lTOyB9DQo+ICtzdGF0aWMg
aW5saW5lIGludCB0ZHhfaGFyZHdhcmVfZW5hYmxlKHZvaWQpIHsgcmV0dXJuIC1FT1BOT1RTVVBQ
OyB9DQo+ICAjZW5kaWYNCj4gIA0KPiAgI2VuZGlmIC8qIF9fS1ZNX1g4Nl9WTVhfWDg2X09QU19I
ICovDQoNCg==
