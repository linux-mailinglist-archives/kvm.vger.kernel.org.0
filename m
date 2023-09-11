Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478DC79BC25
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbjIKUst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236928AbjIKLmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:42:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE47CDD;
        Mon, 11 Sep 2023 04:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694432530; x=1725968530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1hksIPFcfvsurVCZOQDe9vqmt8yCAnOcf1QowBDXogo=;
  b=RbNVaQecXtoSE9rJuPgAc01PAxQkh08awdSb5Td2xV8rrf6M6CdZzI86
   YTZvMnvMNgFa476uupQP3YZVxXxOfkFFzfALrORrQCXCG7hWgBsbxGTIi
   y9jOVnlRIPNI3iOShssmFHAUHVkj9gvjpwuVlO54RD1CfVyku6MP2IhEe
   +vbHz7TSIizzHOY5fzcoa5A44Ko39Fr/tCq7RauUEoEHLympw3A0uWbdx
   Pf59qbqGx/lvjL3gxhDQ4iekVoyINQu6BkV1Rc6/X1+Iqt5D5D6Vn9BAj
   nKrmTzBbEeP0ZAcDP9BY0N4xHjV5doG2N5FaQS4RD/kr2a2IKifTJ6MmA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="358362651"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="358362651"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 04:41:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="1074110092"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="1074110092"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 04:41:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 04:41:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 04:41:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 04:41:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 04:41:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nlcj2NAH1ot4ik//gjBiooAnhAvAkXstfy7shppYdIR1Yvm+3Cw/3JSn+2x7zorxOa21mtkyc4LGH/WgJKiiV9x4TOS43wG6WLgPmXYFMK3HYULOM2bEmYKxU9hiMnH9TV5hJwf9BXPB1A/Jqnh+z+yOZ8CTx5j86b6HUwxIRP/golyx4ehNgg7zuewPnTw0/4WhA93NUMbnKNT5PSJTK48pzZK6GMEV6w4+EVy5WF+/1CCg16a9hm5XA9staf+9VgFyzY0tyqDJ1O1i0ZeiS5yo5nu8+H8ytyGxK8wInAOfOI0jF1gjT57eT/jwyJh9qRnlgzzpcPxsKlBhxF/rXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hksIPFcfvsurVCZOQDe9vqmt8yCAnOcf1QowBDXogo=;
 b=oXMJaMya7VShBntoAbYZfP/irxSMZioLUaL4BrStSLJBPkcr7eGRzLow8kQizo/LlOal2nB1uQF3oFtZvfnV9umUp+Ib5ISSAOqqNMJKn+/QZDMDwmIR3xYGViDB16OpQxgHWmkkvq+u6gU8scOZE0wZpyXQ22DbBYfz0dzBfEvU5B9lrv2P/n41FWTTvG8uKMdS7qF8dgeLz+EjVkNqdE4rvMyDrOjVACGUhEMMGy8P2gsnE9VDPW7s/bMZHFzEDEtMzJiKxWIAiohBFHO2GCyRfCNt1eoEt0VUVVX1lcAKaoI1IKcXz6cqAZoPtekArZizrW/BEkh/sdYDbJ2biw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4687.namprd11.prod.outlook.com (2603:10b6:806:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Mon, 11 Sep
 2023 11:41:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 11:41:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 05/22] x86/virt/tdx: Handle SEAMCALL no entropy error
 in common code
Thread-Topic: [PATCH v13 05/22] x86/virt/tdx: Handle SEAMCALL no entropy error
 in common code
Thread-Index: AQHZ101FhnZRwPhg0EWj68AddtBoNbARMmSAgARo14A=
Date:   Mon, 11 Sep 2023 11:41:37 +0000
Message-ID: <14e8f19b93f3e0eb381061320b47a8c4a048c9cd.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <c945c9a8db98b7a304c404a7ef18aa2f7770ffaf.1692962263.git.kai.huang@intel.com>
         <0676101a-e781-81e0-2e0f-7f5e72595e5c@intel.com>
In-Reply-To: <0676101a-e781-81e0-2e0f-7f5e72595e5c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4687:EE_
x-ms-office365-filtering-correlation-id: b23bd876-c06c-4349-c3a7-08dbb2bc0eb3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5rFYXZ2unnhh638Mp1nOK54qaB9nFXO4hrvXzTzaUFI8XqcvxmtauoWsWFu22/ZJXRvYXMSlqNRGlT7XkgM94rA/jByfCwPd0IBYlhmApiDKnZIrv+7qdoYAu2iqqA35sswbF3kcu9VPCdjuZVZLO49jW8VNQB56hbpEu5ljAqt5heebMq+djE9GINM8PHox3diQz+b8YqzwNzMQcS/fQQQAN6XaUS6nnX8ty49EkffW8VhI9Tp9ka7ipmJHUu7nHSZH9btjdRN+nklF8PDJqvxVhxNovkklNqEfXNz3D1jbZPtCRIj4LTUAIoP8oXNf0hEuyaj3ygenhcOFKFZQbkFNWe0Zjhth9kTf03WGoQCuMa0nHxo3yiOLO5pnv+0UiAT2fGkG5Brkm5OsfjkeSOfM1Rb5HhrZqTtXjOqTp/4Oy29gidW+KXIGhcec9uj+1bB/V7sD/2mOZAuJWKvojrG+OPHy1oe6XbW1Z5cjbfTs9b94roRETp2b6hYfyPjMrNKfYkYOJ3VG+8mWBTSJXDwt1kQDEGBPtSgAffMw8fHYzs6e7OgSsj3hqGW9o2HO3kV6OKq4SmPo1g9CdAOEK81GckTUZvpT9zVDJ35wyMPm3K7X3Zb0M842KkXDwdre
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(366004)(396003)(186009)(451199024)(1800799009)(6506007)(53546011)(6486002)(6512007)(71200400001)(83380400001)(122000001)(86362001)(82960400001)(38100700002)(38070700005)(36756003)(2616005)(26005)(316002)(7416002)(41300700001)(8936002)(4326008)(2906002)(76116006)(8676002)(66556008)(66946007)(54906003)(66446008)(64756008)(66476007)(91956017)(110136005)(478600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2VFanh2TXhTQWxaSzVwakI0ZHloMWtQWFNmQkJtTFRFVVMyRmV0TUZjb0tW?=
 =?utf-8?B?MmVuMnd0S3kvbzBRd2NyS2kxQ1J4Nk4xN01HMksrR1lHdi92Vm1IWUtOQlhE?=
 =?utf-8?B?dTVxVlIzUC8xSlhmV0NqR3ozVTBnRWVlSVJ4VUtDaFV3bjc3eGVZcWJTR2M4?=
 =?utf-8?B?dkdSdXVydDU3SEVqZ1JyU0VaSHhVWkNnZ2kydk5qNnJudmRLVTl1MzZxVHp5?=
 =?utf-8?B?b2xlb3d4VTNuQ1ZLRW1LVjRFZVp5RklpVzBnV0g3ditDazRZSmlxRmM0c1V3?=
 =?utf-8?B?MmFqZ3ZlN1E1Ulovc1JpYjRwWEkwNlFHS0k0VG9sTk5QbFBOTTZ5UlRSc0tJ?=
 =?utf-8?B?aGxqazMzM016b1VSblVIQy9PcFVyQ3NXZHRINmY5aFJvdXlJemtkYjhwS05p?=
 =?utf-8?B?QmZtQzQ2TjBoWUI3L0pVSTZLVWJuaFlwTzVIczhDNll1aVYzQ1I4d3RMRXRW?=
 =?utf-8?B?ZVRtc09RMWxVaTd2OERCTXpKYlkwYnF6aDlESkpyOGt6NDRVYVk2TCtiaEt2?=
 =?utf-8?B?Y01mR0ErNk1LdFhMeUpNV2lDM0o3L2JYbEpmYmNXQWJxenRZNFlOVkxFK21T?=
 =?utf-8?B?RjlyM3dqZ1JBVXFDNmFSdDFJallidHhpRlNhUTZiTEZra1pEUGZJdzVJOGMz?=
 =?utf-8?B?OWd5b2NwRUlITUNYWDZiZzk3UHlHVUlGNitmSU9tajVUUGFhOUtGL3lFZTR5?=
 =?utf-8?B?cTFnd3pFYzBNb2tPank2NDlDZzRCMDRtR3pOblk2a1k0VjRCTUtKU3h4VUQw?=
 =?utf-8?B?bHJQMzJxbXZLdng2N2xvamliRmhlVmlRK2hMWUxjQ1YvbjlBT2REc0I4RzVu?=
 =?utf-8?B?ekREMUJzUkUySjJVeTZKZCtEK1htRitDU2V4Nzg4aFJTMGpHdnFpdUNpWHpF?=
 =?utf-8?B?WE5LWVUxSW90djBtWCtSUzFDMU5iUGdRS2JJT1JoTDFDVHpueVdFdG1yYmx2?=
 =?utf-8?B?MTQrOFJUNTVFR3pVcVpSaTVhenJoY29uQXF0aWpwZkpkRjVoWktYUU9vU3Zj?=
 =?utf-8?B?a2g2NW5tNFlHbkUxZWxLU3ptcHBybjFYK2d0Vm5BS1NJdGFLQXRaTWxMbGNq?=
 =?utf-8?B?WFFyN0RSbE1MdlBVamVBeDZ6b3pHZmpBZWVHU3VEaUd4eUNVNWxpVjhoeGZ4?=
 =?utf-8?B?bVNpU1JBZC9FS2hra2ovNndzU2ZHc29id2oyZWNtbFpPRkRxUGlFVE1lN1Zv?=
 =?utf-8?B?eUdteUZZaHoxcno4bHZlVTBaVFhwbXQrajRsVHNOUk00M2grUFBaWnpqS2RS?=
 =?utf-8?B?aTcxMDRHdkZUVFkwdHBUQThrWldsd0lxMWdRWkt5Uis4ejRxZTl1cmtuYkZH?=
 =?utf-8?B?TVh1dmJXeFZYa1RHQ28rNjlOMWUxb1B4OGdUc3VVQ1ptdVJJWWcyL2VjQW9S?=
 =?utf-8?B?QTA4T1JYSE5RM01qZFNTeXdWNkxOUkZkODN0RzZXaExNMmZDVUh3KzJrR2ZM?=
 =?utf-8?B?Qm4xMlhoTU03U3F3ellLM01kZFBndkl0dk9rckUzbXFJa2xwcWNSdEozcGFZ?=
 =?utf-8?B?MXE3VGhYNjl0QURjSndSWlROTExIK2hlcWtFTGY2MEpnOUF6aUVQT2NrLzhT?=
 =?utf-8?B?SXByYjhWNW9JUW5yWjhqWVR2N1kwdEtGM0NCdW9xbDZCUzlpb0pueXlvV1JX?=
 =?utf-8?B?eW9rS0tlSHJueUpMb2xHMittUGlRc09veFJrVzJ6NjZOU2xjSjVBMVg1cUo1?=
 =?utf-8?B?aDlYbWpSZTA5OXJlRzdrL3g4a1llc2cwRVV5TmpSY0JuVUs0OW1PeGZUY3Rm?=
 =?utf-8?B?eWdOb1lNR0Q4RWZqY0RNV2d3Sml4eVZpWlBHdHRjMVN1dmQ3TUlzdnVxbmdJ?=
 =?utf-8?B?TWFRMDVUR1AzbVVoS1VXV0E5UitMNFlab1lXZDVXSEdIblRYT3BCUEF4RUVv?=
 =?utf-8?B?MU5wQk1HaE5lMnJKU0xjSk5OdU9KMkkySkJMOVNtbTBRclJob015UEVTOUpy?=
 =?utf-8?B?djQxRkNKVkZFcml6VVc5d1FESlRnczhmSHVneWpyWWV2OWUrbkpqNW9DT0I5?=
 =?utf-8?B?ZXNCbkxtWlcyV3p6ZnV4ZVh6YnNVNWpULzhXSnZnTTFDYjZ2N3hkT0lpdFFY?=
 =?utf-8?B?WmdjMTA0Ymx0NE8wY2xGalJxNytSMVQyOWxWcTZIY3I2VmwzSjQyd3oveFlK?=
 =?utf-8?Q?aPuX3ieMK+Iz4URyILlzjxWb0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA76BF1C8B5FF34FBDBB8CA150B35B32@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b23bd876-c06c-4349-c3a7-08dbb2bc0eb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 11:41:37.2928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zFm6NfjiJUoqg2oSEKW3b+BIsUAZd8SJIfhlXE3P7HswE291IoPeQiYNwSGr6pRTdN1eM1ZtUTpHvwO76s3A6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4687
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA5LTA4IGF0IDA5OjIxIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOC8yNS8yMyAwNToxNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IFNvbWUgU0VBTUNBTExzIHVz
ZSB0aGUgUkRSQU5EIGhhcmR3YXJlIGFuZCBjYW4gZmFpbCBmb3IgdGhlIHNhbWUgcmVhc29ucw0K
PiA+IGFzIFJEUkFORC4gIFVzZSB0aGUga2VybmVsIFJEUkFORCByZXRyeSBsb2dpYyBmb3IgdGhl
bS4NCj4gPiANCj4gPiBUaGVyZSBhcmUgdGhyZWUgX19zZWFtY2FsbCooKSB2YXJpYW50cy4gIEFk
ZCBhIG1hY3JvIHRvIGRvIHRoZSBTRUFNQ0FMTA0KPiA+IHJldHJ5IGluIHRoZSBjb21tb24gY29k
ZSBhbmQgZGVmaW5lIGEgd3JhcHBlciBmb3IgZWFjaCBfX3NlYW1jYWxsKigpDQo+ID4gdmFyaWFu
dC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5j
b20+DQo+ID4gLS0tDQo+ID4gDQo+ID4gdjEyIC0+IHYxMzoNCj4gPiAgLSBOZXcgaW1wbGVtZW50
YXRpb24gZHVlIHRvIFREQ0FMTCBhc3NlbWJseSBzZXJpZXMuDQo+ID4gDQo+ID4gLS0tDQo+ID4g
IGFyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oIHwgMjcgKysrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vdGR4LmgNCj4gPiBpbmRleCBhMjUyMzI4NzM0YzcuLmNmYWU4YjMxYTJlOSAxMDA2NDQNCj4g
PiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiA+ICsrKyBiL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL3RkeC5oDQo+ID4gQEAgLTI0LDYgKzI0LDExIEBADQo+ID4gICNkZWZpbmUgVERY
X1NFQU1DQUxMX0dQCQkJKFREWF9TV19FUlJPUiB8IFg4Nl9UUkFQX0dQKQ0KPiA+ICAjZGVmaW5l
IFREWF9TRUFNQ0FMTF9VRAkJCShURFhfU1dfRVJST1IgfCBYODZfVFJBUF9VRCkNCj4gPiAgDQo+
ID4gKy8qDQo+ID4gKyAqIFREWCBtb2R1bGUgU0VBTUNBTEwgbGVhZiBmdW5jdGlvbiBlcnJvciBj
b2Rlcw0KPiA+ICsgKi8NCj4gPiArI2RlZmluZSBURFhfUk5EX05PX0VOVFJPUFkJMHg4MDAwMDIw
MzAwMDAwMDAwVUxMDQo+ID4gKw0KPiA+ICAjaWZuZGVmIF9fQVNTRU1CTFlfXw0KPiA+ICANCj4g
PiAgLyoNCj4gPiBAQCAtODIsNiArODcsMjggQEAgdTY0IF9fc2VhbWNhbGwodTY0IGZuLCBzdHJ1
Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKTsNCj4gPiAgdTY0IF9fc2VhbWNhbGxfcmV0KHU2NCBm
biwgc3RydWN0IHRkeF9tb2R1bGVfYXJncyAqYXJncyk7DQo+ID4gIHU2NCBfX3NlYW1jYWxsX3Nh
dmVkX3JldCh1NjQgZm4sIHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmFyZ3MpOw0KPiA+ICANCj4g
PiArI2luY2x1ZGUgPGFzbS9hcmNocmFuZG9tLmg+DQo+ID4gKw0KPiA+ICsjZGVmaW5lIFNFQU1D
QUxMX05PX0VOVFJPUFlfUkVUUlkoX19zZWFtY2FsbF9mdW5jLCBfX2ZuLCBfX2FyZ3MpCVwNCj4g
PiArKHsJCQkJCQkJCQlcDQo+ID4gKwlpbnQgX19fcmV0cnkgPSBSRFJBTkRfUkVUUllfTE9PUFM7
CQkJCVwNCj4gPiArCXU2NCBfX19zcmV0OwkJCQkJCQlcDQo+ID4gKwkJCQkJCQkJCVwNCj4gPiAr
CWRvIHsJCQkJCQkJCVwNCj4gPiArCQlfX19zcmV0ID0gX19zZWFtY2FsbF9mdW5jKChfX2ZuKSwg
KF9fYXJncykpOwkJXA0KPiA+ICsJfSB3aGlsZSAoX19fc3JldCA9PSBURFhfUk5EX05PX0VOVFJP
UFkgJiYgLS1fX19yZXRyeSk7CQlcDQo+ID4gKwlfX19zcmV0OwkJCQkJCQlcDQo+ID4gK30pDQo+
IA0KPiBUaGlzIGlzIGEgKkxPVCogbGVzcyBleWUtYmxlZWR5IGlmIHlvdSBkbyBpdCB3aXRob3V0
IG1hY3JvczoNCj4gDQo+IA0KPiB0eXBlZGVmIHU2NCAoKnNjX2Z1bmNfdCkodTY0IGZuLCBzdHJ1
Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKTsNCj4gDQo+IHN0YXRpYyBpbmxpbmUNCj4gdTY0IHNj
X3JldHJ5KHNjX2Z1bmNfdCBmdW5jLCB1NjQgZm4sIHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmFy
Z3MpDQo+IHsNCj4gICAgICAgICBpbnQgcmV0cnkgPSBSRFJBTkRfUkVUUllfTE9PUFM7DQo+ICAg
ICAgICAgdTY0IHJldDsNCj4gDQo+ICAgICAgICAgZG8gew0KPiAgICAgICAgICAgICAgICAgcmV0
ID0gZnVuYyhmbiwgYXJncyk7DQo+ICAgICAgICAgfSB3aGlsZSAocmV0ID09IFREWF9STkRfTk9f
RU5UUk9QWSAmJiAtLXJldHJ5KTsNCj4gDQo+ICAgICAgICAgcmV0dXJuIHJldDsNCj4gfQ0KPiAN
Cj4gI2RlZmluZSBzZWFtY2FsbChfZm4sIF9hcmdzKSAgICAgICAgICAgc2NfcmV0cnkoX3NlYW1j
YWxsLA0KPiAoX2ZuKSwgKF9hcmdzKSkNCj4gI2RlZmluZSBzZWFtY2FsbF9yZXQoX2ZuLCBfYXJn
cykgICAgICAgc2NfcmV0cnkoX3NlYW1jYWxsX3JldCwNCj4gKF9mbiksIChfYXJncykpDQo+ICNk
ZWZpbmUgc2VhbWNhbGxfc2F2ZWRfcmV0KF9mbiwgX2FyZ3MpIHNjX3JldHJ5KF9zZWFtY2FsbF9z
YXZlZF9yZXQsDQo+IChfZm4pLCAoX2FyZ3MpKQ0KPiANCj4gVGhlIGNvbXBpbGVyIGNhbiBmaWd1
cmUgaXQgb3V0IGFuZCBhdm9pZCBtYWtpbmcgZnVuYygpIGFuIGluZGlyZWN0IGNhbGwNCj4gc2lu
Y2UgaXQga25vd3MgdGhlIGNhbGwgbG9jYXRpb24gYXQgY29tcGlsZSB0aW1lLg0KDQpJbmRpcmVj
dCBjYWxsIHdhcyBhIGNvbmNlcm4gd2hlbiBJIHdhcyBpbXBsZW1lbnRpbmcgdGhvc2UuICBJIGRp
ZG4ndCBrbm93IGZvciANCnN1cmUgdGhhdCB0aGUgY29tcGlsZXIgY2FuIGF2b2lkIGl0LiAgSSds
bCBjaGFuZ2UgdG8gdXNlIGFib3ZlLiAgVGhhbmtzIQ0KDQo+IA0KPiBZb3UgY2FuIGFsc28gZG8g
dGhlIHNlYW1jYWxsKCkgI2RlZmluZSBhcyBhIHN0YXRpYyBpbmxpbmUsIGJ1dCBpdCBkb2VzDQo+
IHRha2UgdXAgbW9yZSBzY3JlZW4gcmVhbCBlc3RhdGUuICBPaCwgYW5kIGdvaW5nIGEgd2VlIGJp
dCBvdmVyIDgwDQo+IGNvbHVtbnMgaXMgT0sgZm9yIHRob3NlICNkZWZpbmVzLg0KDQpZZXMgSSB2
ZXJpZmllZCB0aGUgY2hlY2twYXRjaC5wbCB3b3VsZG4ndCBjb21wbGFpbiBpZiB0aGUgI2RlZmlu
ZSBleGNlZWRlZCA4MA0KY2hhcmFjdGVycyBpbiBvbmUgbGluZS4gIEknbGwgdXNlICNkZWZpbmUu
ICBUaGFua3MhDQo=
