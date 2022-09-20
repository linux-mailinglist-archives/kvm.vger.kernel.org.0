Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0065BEEE2
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 23:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiITVBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 17:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiITVBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 17:01:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789EC31ECD
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663707707; x=1695243707;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RMMI3CFgLip1Jcc4hbCom/0y43TSd5tSyti0yUOjEQM=;
  b=DqOEoVDK8W6nZ4OMFxkDO3WXYsfdTJP7bOvVSXPuPtwD+nX9eikQWR3Y
   urn8ta8hnObWwV4Y72oMllcD7AckcwsP0opN6h4kw+Vp/MY18R6LQC8YT
   POF4jsMUnXaiNRZmPoKiwSKyRmO8JAHlM4M32B1T2Plh4rlVspJOI0Qj2
   Q7h1jzQn4FY9i9B8x4L4YDZs0Ev195d0OnaSXajxBd2GR7G9/3d38vsHS
   SzeSu+wrK/glB3f99rAMEcB6VFWV6bzbNxyRJx6VTyWvPDlxuOVs82kxk
   S0+EEEuwZASwKZD/tULw+cVFZXkpclkDxM8rcyMqwZkz6AVu/R3dZMnAK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="300655351"
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="300655351"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 14:01:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="947847900"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 20 Sep 2022 14:01:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 14:01:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 14:01:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 20 Sep 2022 14:01:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 20 Sep 2022 14:01:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQzUOjhlMzQWbVP16mpm08k8TduHLoytC73bDSrl6wzd1PBUAQza+7SbY2n6IVxYFEiNe590if4xjWexQkGzIfVmhuwjt6ViD9SdYjKHJCFf9E7KsfT6jXme4gOSrtuukmsK1RyFdNS6wfB2/c/1CkTBW7Kku+PYNnUnEN8F0E0huft7/g4C/FkakqKmdU/kQsum9OrMW1ytXg+stWF6/CkbLi8N9QxGzxGgWaGoMI9jaQUq+7x10MqK0A2yKdkjaeBsuypCn+b3BHXshJV6ruFSqESBZtDiZjz80jFJm7Ou3Lv+HsEInLkdkxYnRuBwabjdyBgsOiuVQupMcnxBbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMMI3CFgLip1Jcc4hbCom/0y43TSd5tSyti0yUOjEQM=;
 b=Mt8ueMjOWddxYhYCIVLhvvnKRyAeTgCQqHQ+TYWA2cz8XOr5a9K2U+PwR18VXRkZqXAUg2tc5VXIc73Xqy22jM16XYhRHA+m3vbOYTqrPQnO4g/L9Lybo1cXktl2xFONdfMEaEURl+rdi/f2QPYPnwAJcYDAtaitH2ZRR6BljI/Lg01KirPxxa/qyImKlgdITvqNrWytvA01Idl6HYb3kr6PsAky4ZNKUCiYJO67yGcez0rPe01fg6HIF+6GRzMgeUtjZEmjsyl+xxP0zkM6O2tn7SVPC75YNbksMWMwXManNaxaD5F08aCvWh0h8pZaoPbNWVdj3bgkeLcbzC9tlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4579.namprd11.prod.outlook.com (2603:10b6:5:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 21:01:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::e5ee:2a16:3baa:d199]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::e5ee:2a16:3baa:d199%7]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 21:01:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "dmatlack@google.com" <dmatlack@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v2 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Topic: [PATCH v2 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Index: AQHYuaFVUKotwXOBH0if+KDdPORKha3HPtWAgAOTCACAHd7mgIAARFEA
Date:   Tue, 20 Sep 2022 21:01:37 +0000
Message-ID: <d39458f94d13e6498272bbad609b577fbb67a861.camel@intel.com>
References: <20220826231227.4096391-1-dmatlack@google.com>
         <20220826231227.4096391-2-dmatlack@google.com>
         <2433d3dba221ade6f3f42941692f9439429e0b6b.camel@intel.com>
         <CALzav=cgqJV+k5wAymUXFaTK5Q1h6UFSVSKjZZ30akq-q0FNOg@mail.gmail.com>
         <CALzav=cuwyFTn6zz+fJqjKNs6XYx2-N61sgMQ9K5C-Z=a4STZg@mail.gmail.com>
In-Reply-To: <CALzav=cuwyFTn6zz+fJqjKNs6XYx2-N61sgMQ9K5C-Z=a4STZg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM6PR11MB4579:EE_
x-ms-office365-filtering-correlation-id: 0ddae439-9812-4fcd-2cec-08da9b4b4ead
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +u0DASR0NVFlAsrc8JDXxhO9uj/5IfGB2yYAGk8xCHhasmKJY+pyt8Y5kxu+4biLbndsXa6oAymg5I7bY7FWVBvodIwo/bgtwONfoqG6p2sNV1aD/2K+sv5+loIUWqzStLbwwNuB3VnmHB27pE09RqT5Ll1TTVXeJV2Jyk5jYbr/HNfeueRTfKQadTTy+JA57Kcu/Vn0j4QdRM6ohyxTT+x/1xLC/cfayt41zbhVw6aqu3piUDO5JBQb5NN2QRHzI318HbMi8P6kJZ25UCJ7tGrrSZ1G862rfAmsRhf0jlY6qZururaxdF8TjhkBFRgZxs1VW3L2vSv5g1L+95WvOl0LikQQoIF8oy7BNcmauYCC3Y1fbeZLswVjSSKnxx3bgdzboGh/FPFJufFLBrnnLEwsGT5Ln0kfpvNDpqI0+kiR9D+0bDGYAPTTt7Ad2xvrpj0CZL6F8xmPZNTfpU0MPMsWa9vIWgoBTIUMFhn6TPGt/dXpmxFvpNa/tqnDR/yXciDWQW922SPYLiygW4Srg2MKlujb6scDuk9K4+e4TqWvuEVHtLXBF8k3Z80hwV6oc3ChhoADoPS/fMcb3X8czKFqzKX30nmhmv2fw5aZP6Yg7HzEOCSz78EGrKaBmlIXPfu4az/NF5qrkPLXWfOi3lZrnIgDc6vHHLuprkboHl1G8K5mWvg4NyAEi01gGOQhW5+aOmiLFqAi0mLFXkugoCuAEdcZ3M1mYb+M2QU8WULP2pMRAf5p6gvTcFMf6SaFtoRHTS4T5A5KPZ7ZzdDWjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(2616005)(66446008)(66476007)(66556008)(66946007)(26005)(8676002)(4326008)(64756008)(76116006)(91956017)(6512007)(6506007)(36756003)(71200400001)(38070700005)(5660300002)(82960400001)(8936002)(41300700001)(38100700002)(6486002)(478600001)(53546011)(86362001)(186003)(122000001)(316002)(54906003)(6916009)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFMxVjlUaUF3QU1PK2JSUkpPMDB3Z0NHTEIzR2ZtUXlEYjNiL3Z2VUdDTjJV?=
 =?utf-8?B?MjJMYWZDTzBTNDZYZzIwSW5xWkR1aUE0U2VHMXpsaXUzVnl5L3dtYTBYZHpG?=
 =?utf-8?B?MmZsSlA3bWNSbnpqb0VOaExGb1VHZG9wNmZpUWdvclN4OEs1Ykl4MCtEZDJ3?=
 =?utf-8?B?NHRjcER0Yk42Wk43R3ZoWkxWUkpwNmFJV0FlcldCM0x2ejVPYTBHRldGaHdp?=
 =?utf-8?B?RkhnM1FJZDVvT080Unk2KzdtWktsbkVFK21KRFdwRzdHa0Q4eGJBSmVMeGk1?=
 =?utf-8?B?L1RYWmJ6bHFubUQ1S3JYNUJWQUgxQmpNUGxSWG56YzFBWFR0YjdCQ0dVc0E3?=
 =?utf-8?B?c1A3UTg3eFpNdjROK1Y4OFNnbHRXQndROThCNVBTanFJbEpxUFJpTy9ER2pT?=
 =?utf-8?B?R2h4YWJ4djhGdXFsZXY5cW43M0h3U2RNaTU5b1pzbnpzdHMxMmthNWZFRjdN?=
 =?utf-8?B?dDVqQ0o4T1AxalgxZVNYM1pqWjQxT056L00vbU9MZ2JnVUtMOWNXZkg0YVow?=
 =?utf-8?B?Z0pRM1kxWEd2clMrWElZMHNiTXBMVXVtTmxvWVJpajlCUlMwMGJ3Y1NqMi8w?=
 =?utf-8?B?RytDQ3M0cW5jNjRSZXQ1QjkreGNOSk0ranI0bnVxWGdYVnBXczJ5M0tobzNL?=
 =?utf-8?B?b3lVT2dORFZSdHBySXBYZ3ZUY0dsNExObmszUXBBbzlEWEhUWTFzSytHYVJ4?=
 =?utf-8?B?WGlQOFppYWdIUjkxZU5Dc2hGK0xpOUY0Rkwxdm05aWpObUVlQU8rUWRDaGZQ?=
 =?utf-8?B?SjF4bzRiZU1YY3Erb1kvL1JZcDE4bUdTSTVzNmkxdGlmeG83Z01nRVcrcE5P?=
 =?utf-8?B?VmhlZnFPRHRkRDBDK1BNZ3MzNlEzdmlSNUNLVUNqaEp2U3pxdWd6eS9GL05u?=
 =?utf-8?B?NE9lTVh4Y0VoL3hsV3BtbURHSFcxSEtjME1UQm9EcnA3OGxZUlRIR09oK2J2?=
 =?utf-8?B?TEcvdzlaQ2Z1R0Y3S3BacXJPTm5DTEI2ckNJUGZadEQvNy92eUMrZWE1KzB5?=
 =?utf-8?B?NEFVdXpMQnhaT0k0L0J3ekpmb2hZbTdrTU9CbFhvUlBwbEJTS3BtaUUvSis1?=
 =?utf-8?B?cnlnSVd3M1hTQ2tIZllvSzV5KzJJdDROTElJbE5xdGZZVThkL1JUdGVJWjhw?=
 =?utf-8?B?bDJKUHF0SkNxN3UrV1BJZzNhUlphNW52aEFnZC85QnBDWVhneC9SdSsvSkZF?=
 =?utf-8?B?bXpzbkFadzNqTGE4cTNhME8zc2pkV1ZlSUZ6Z3VtNUpqL2s0SWFjMVlLbjB5?=
 =?utf-8?B?cnI0MEZEaVFJaWdwbUNVdFlRM3U5Q0QxSUhBekhLeXV3ZGpaWXlEYU9zekRP?=
 =?utf-8?B?cEdEaUNVVUJzOUZkOXlEdWdyMjlZR1I5d3NaWkVrWW15WUdhMWszNDJ2NWp2?=
 =?utf-8?B?Y01HU3lHMGdRSVgxQkZ5SFRMditOMjIxNXE0d1dpOS9YbHB3UnA5QStrUGg3?=
 =?utf-8?B?dGpxemM4clVPYXZiZ0RPWjFaZDBtdVJrYWhOMmRXN0NsTk13RUM3c3pTSVRR?=
 =?utf-8?B?TmU2Q0w4V3c0SjZlcHM1MWRLc1IzRktXOG5GbTMra2YweFpXVEhlUW80YU9t?=
 =?utf-8?B?bENZU2I0UlM4ek1BWUd2RENucE45N3VDVHk1QzU4Q3NyNkFtK05MeFV6eHJw?=
 =?utf-8?B?WUltd0VlVGlEWUVreHJibEY0TzAwK3lsWWRtcnNiYTV3NU42Umo0R2VjYTVZ?=
 =?utf-8?B?ZmpETTIxdEp3VjlpdHZ6dHAvZlMyS2xJYUVRN0JVRnFEbzJONmJ2Q2dwSGZr?=
 =?utf-8?B?ZjNVZ1BTMDE1VytrTG9PUnJkODdnTzM1ZlUyTkRhYjh0ZXpVZExGMHFPZGdm?=
 =?utf-8?B?akxERXdkRDFiWVBEN1pEMlEwN3lVUkF0U3NSNTZJS0dzY3VYak5ReTJXQ040?=
 =?utf-8?B?ZzZIWG9ERURIcWdOODIrRmM4cVF6NE42dTExZmpTeGF2cWg2WEtkeWR6ZU1K?=
 =?utf-8?B?NnVzeHlFUkMwNk9kSk5rQlRabEFIQlhOU2tBVUVQbkhCT2NpemNCYWNxVVFt?=
 =?utf-8?B?b3RYZTJBdkZoYWEvdEd6NmtXZ3VQUy8wQUdWb2Z5MkY1SFhDN2YxQlZYMmlu?=
 =?utf-8?B?dWxsck1VRWRJVTJVNUhmRE51RzlINlpFalFiWkFMNDlXTHdMa3Q2VHE2V3dj?=
 =?utf-8?B?TUZRNE1oZ1BlWktoMkloMGRtUFFST0xyKyt5ODlUS1ZlL2RRaWxackE4U0xI?=
 =?utf-8?B?eGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA640B15A0962546815D633A0DB07B7D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ddae439-9812-4fcd-2cec-08da9b4b4ead
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 21:01:37.0858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ik6+tQwCcV5GjIsLwseAFI/Gl1zYMviYAmSYnGtHz0tRnTcIW8RepOnqd/jl2OD/yJUir54UBn3s3pP9GMUKtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4579
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

T24gVHVlLCAyMDIyLTA5LTIwIGF0IDA5OjU3IC0wNzAwLCBEYXZpZCBNYXRsYWNrIHdyb3RlOg0K
PiBPbiBUaHUsIFNlcCAxLCAyMDIyIGF0IDk6NDcgQU0gRGF2aWQgTWF0bGFjayA8ZG1hdGxhY2tA
Z29vZ2xlLmNvbT4gd3JvdGU6DQo+ID4gT24gVHVlLCBBdWcgMzAsIDIwMjIgYXQgMzoxMiBBTSBI
dWFuZywgS2FpIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+IE9uIEZyaSwgMjAy
Mi0wOC0yNiBhdCAxNjoxMiAtMDcwMCwgRGF2aWQgTWF0bGFjayB3cm90ZToNCj4gWy4uLl0NCj4g
PiA+ID4gKyNlbHNlDQo+ID4gPiA+ICsvKiBURFAgTU1VIGlzIG5vdCBzdXBwb3J0ZWQgb24gMzIt
Yml0IEtWTS4gKi8NCj4gPiA+ID4gK2NvbnN0IGJvb2wgdGRwX21tdV9lbmFibGVkOw0KPiA+ID4g
PiArI2VuZGlmDQo+ID4gPiA+ICsNCj4gPiA+IA0KPiA+ID4gSSBhbSBub3Qgc3VyZSBieSB1c2lu
ZyAnY29uc3QgYm9vbCcgdGhlIGNvbXBpbGUgd2lsbCBhbHdheXMgb21pdCB0aGUgZnVuY3Rpb24N
Cj4gPiA+IGNhbGw/ICBJIGRpZCBzb21lIGV4cGVyaW1lbnQgb24gbXkgNjQtYml0IHN5c3RlbSBh
bmQgaXQgc2VlbXMgaWYgd2UgZG9uJ3QgdXNlDQo+ID4gPiBhbnkgLU8gb3B0aW9uIHRoZW4gdGhl
IGdlbmVyYXRlZCBjb2RlIHN0aWxsIGRvZXMgZnVuY3Rpb24gY2FsbC4NCj4gPiA+IA0KPiA+ID4g
SG93IGFib3V0IGp1c3QgKGlmIGl0IHdvcmtzKToNCj4gPiA+IA0KPiA+ID4gICAgICAgICAjZGVm
aW5lIHRkcF9tbXVfZW5hYmxlZCBmYWxzZQ0KPiA+IA0KPiA+IEkgY2FuIGdpdmUgaXQgYSB0cnku
IEJ5IHRoZSB3YXksIEkgd29uZGVyIGlmIHRoZSBleGlzdGluZyBjb2RlDQo+ID4gY29tcGlsZXMg
d2l0aG91dCAtTy4gVGhlIGV4aXN0aW5nIGNvZGUgcmVsaWVzIG9uIGEgc3RhdGljIGlubGluZQ0K
PiA+IGZ1bmN0aW9uIHJldHVybmluZyBmYWxzZSBvbiAzMi1iaXQgS1ZNLCB3aGljaCBkb2Vzbid0
IHNlZW0gbGlrZSBpdA0KPiA+IHdvdWxkIGJlIGFueSBlYXNpZXIgZm9yIHRoZSBjb21waWxlciB0
byBvcHRpbWl6ZSBvdXQgdGhhbiBhIGNvbnN0DQo+ID4gYm9vbC4gQnV0IHdobyBrbm93cy4NCj4g
DQo+IEFjdHVhbGx5LCBob3cgZGlkIHlvdSBjb21waWxlIHdpdGhvdXQgLU8gYW5kIGlzIHRoYXQg
YSBzdXBwb3J0ZWQgdXNlLWNhc2U/DQoNCkkganVzdCB3cm90ZSBhIHZlcnkgc2ltcGxlIHVzZXJz
cGFjZSBhcHBsaWNhdGlvbiBhbmQgYnVpbHQgaXQgdy9vIHVzaW5nIHRoZSAtTw0KKG1vc3RseSBv
dXQgb2YgY3VyaW9zaXR5KSAuDQoNClNvcnJ5IEkgZGlkbid0IGNoZWNrIHdoZXRoZXIgY3VycmVu
dGx5IEtWTSB1c2VzIC1PIHRvIGJ1aWxkIG9yIG5vdC4NCg0KSWYgbmVlZGVkLCBJIGNhbiB0cnkg
dG8gdGVzdCBpbiByZWFsIEtWTSBidWlsZCBhbmQgcmVwb3J0IGJhY2ssIGJ1dCBJIG5lZWQgdG8g
ZG8NCnRoYXQgbGF0ZXIgOikNCg0KPiANCj4gSSB0cmllZCBib3RoIENPTkZJR19DQ19PUFRJTUla
RV9GT1JfUEVSRk9STUFOQ0UgKC1PMikgYW5kDQo+IENPTkZJR19DQ19PUFRJTUlaRV9GT1JfU0la
RSAoLU9zKSBhbmQgZGlkIG5vdCBlbmNvdW50ZXIgYW55IGlzc3Vlcw0KPiBidWlsZGluZyAzMi1i
aXQgS1ZNIHdpdGggdGhpcyBzZXJpZXMuDQoNClllcyBib3RoIC1PMiBhbmQgLU9zIHdpbGwgb3B0
aW1pemUgdGhlICdjb25zdCBib29sJyBvdXQgdG8gb21pdCB0aGUgZnVuY3Rpb24NCmNhbGwsIGlm
IEkgcmVjYWxsIGNvcnJlY3RseS4gIEluIGZhY3QgaW4gbXkgZXhwZXJpZW5jZSAtTzEgY2FuIGFs
c28gb21pdCB0aGUNCmZ1bmN0aW9uIGNhbGwsIGlmIEkgcmVjYWxsIGNvcnJlY3RseS4NCg0KLS0g
DQpUaGFua3MsDQotS2FpDQoNCg0K
