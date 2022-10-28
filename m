Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCB5610717
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 03:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiJ1BIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 21:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiJ1BIj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 21:08:39 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8B3A23D6;
        Thu, 27 Oct 2022 18:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666919319; x=1698455319;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U8lY10aWH1CppO0K0EliG47o2514jrY/yqJlGJSXYvA=;
  b=NItCLwCDGtp2QoimToalYdkCxja4bhQ6NK/SPRyO70lUEsrU7i8VuMEc
   uYvUS6pMBQoO9zkScrtrpWsX1RyBaDGvGGd5/eE6hNchV4QUh+Ato4Bk7
   fICCbH+w/Myd44jBBfMy4py8WOFCaBlUEe3E1B2i2Ie8+dnrzMgHt/xb7
   YAFPseitMdMBbf2DQDXueOPyWmkKD2fwRKMDXdRCTElsPA75isSNccSLS
   GPjxq8fpW3s7jpKuVQafZl5BXgfas+LFweC3JFVq+vZLhTXWs/UMJCrNV
   /WwL1eJDbjO3Y9nsanBpL2jr7xvMMKIRMrzQdH9yGItu1Kic+1EMABYZK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="309473220"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="309473220"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 18:08:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="665891560"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="665891560"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2022 18:08:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 18:08:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 18:08:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 18:08:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 18:08:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cb4p7lrX36ua5i2wpk24bK33zg0UVqz83rAMYh8/GqTXmXBwpc6pNZzLi6BOvLPNPDlnaM+0z6is4UY+4335CbmGEgaaRlrLauyLgHV4uKNaOXrECCk3mCx5hkWWR8lX2ZdgR2bwWQOREFyAulRcNKqPhQeokAhRTJCnjk1/lkHcOc+A6vamINLkzHzyiAr8mDJnqndriWQwUS98sgYK4taZ7IocKJaoymVebeicPQq2VGeb5i/U3iC/2D6athsm8oyZgWo/MF0r2nYr+q1D7RAhOqhPwHjVtCvKbvA7RGgC/e/K5J75SjPy8Bqklswsvtv+8ibdAj8Hwtlaoukmjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8lY10aWH1CppO0K0EliG47o2514jrY/yqJlGJSXYvA=;
 b=BwFmph5Y8tcq3U51A3I/jEkW9Gsg5hpMT5O9IJ0utTp27UkEdUktRbfPbBCtPQ3yg+e/HxhVzl8JUhG1zfusi+HR4TDYnHuh2ZwYpHil+bWzCn7pZLYsJmDJ7yAe5R0Rb9nWlhxRoGmbAkn5TPfxSLai/zG4S4tVZG+H2ZE6efYH7s0fXbv3LPWd9sRew0777gT8U7yMn3c60QLJyApsuSUtDjleiNiXM+b39N+56R8ueNn/rlPidjoYJleaC0d5pRwuiz0RfRrc5TiSrF7c90Xs98U0KmYzbsiUujxzd0cWTSnugO81hCrVW+x2OgeyDJyPnJdfoVDKmbiqAuS3Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6850.namprd11.prod.outlook.com (2603:10b6:806:2a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Fri, 28 Oct
 2022 01:08:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 01:08:34 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 19/21] x86/virt/tdx: Initialize all TDMRs
Thread-Topic: [PATCH v6 19/21] x86/virt/tdx: Initialize all TDMRs
Thread-Index: AQHY6Y2lEID+Mxvc/UeB4tSysBnuLa4iLMqAgADTs4A=
Date:   Fri, 28 Oct 2022 01:08:34 +0000
Message-ID: <143c501bb9c36ddacc2883778ef692dbb0d04ff9.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <c78e41604f5c5274da3d5a9a01632abfad0926a5.1666824663.git.kai.huang@intel.com>
         <d114ae48-8ba5-a639-f220-b60f2cac67d2@linux.intel.com>
In-Reply-To: <d114ae48-8ba5-a639-f220-b60f2cac67d2@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6850:EE_
x-ms-office365-filtering-correlation-id: 2453c67d-8071-4830-2248-08dab880efe1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VB9bxS/O3Yh8pjj7kw50KDIFWDCUpncmgsg2plY1lu662t3cdVaMIGf5Qm/yNVqX34pdk4OHxj2mCqm9CGzprnxE08wGgym+aH7Vee7WQ8ezeFPkVru3crKS17MgSc+1YEFQYaynoG8LNMMjZdPJZeQkBT9YLTcEd3wWpqjXnJ8WkHKTXojpWbvLGIzseLB54GCRlcFde6HiOb66nry3jVMMKim0ABugc/Vr1vfy8KQpg2aP7e6c9Mp1KVlfS96Z4SGo7PSznSiQFNXTXdOcf98CLHDZZp6ZBUZPbhOROI/3djz5/sPUV3sgtaJiFx71XTvI+SI/xg30EeCQ8jxNNBMSHwYXNJY6YLD3ZldrejhuQxk+yCU/iRjOEru5myGkKwdH0ypIqOnk6EXGQO+R7CTz3TwrSH8ZDHMyoOQSqN26wsNdY1P+rZl6BWcoVmnHckfTZUC8tFbADptF4PG5Z0LFG1VpVJLMzRQ79DFRFSFbgCvp0/QsJ9NG8MvhV9LmYxU0EqsyhqIr3Fn4OZFxWdbbysBBcc6aPTZ7piXbe4o1N9DWmBlGsYQVT3JbFNTpI4X51UvaR02rwFuzHStV0dBWM2xiTBAMmTZDXkij0Xu8GwFPYRAb0LpYiCzOrLRD1IhNRIskXktH6xzK+w9yhgcmgbeU3PLrFRUteBCtbttQLD2qUp0DVncj2ER2aBt2IaUnS5S7zi2Y7JwE2dsZpjWmSe6j5fDEmq2jbw+jZScJQTE0ompjAKrytkbiaoft4iuo691YOlZwGFddmQ9ucQi0kgHPr1YJw3L1QGN1FfY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199015)(6486002)(64756008)(66946007)(66446008)(66476007)(8676002)(76116006)(4326008)(66556008)(91956017)(186003)(6512007)(5660300002)(41300700001)(82960400001)(122000001)(54906003)(110136005)(86362001)(38100700002)(6506007)(71200400001)(38070700005)(478600001)(7416002)(36756003)(558084003)(8936002)(26005)(2906002)(4001150100001)(2616005)(316002)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkI1WXhFa2xQT1M5N2lyT294VnBKMERvNCtHMHdrMlV4Sjk2SVpQQkV2alg3?=
 =?utf-8?B?QjNMNkkzNXR4amFmNlVwTGZGSHd3blZVVWIxWG5ScjNiUEtpRUJyaHNhbUx5?=
 =?utf-8?B?TGhNN1g5SzJTNmQwRVVneEVjWmNsSzhWRG94WmxFYTNXKzUyQlYvTlBCV2I5?=
 =?utf-8?B?RUM3dzBRZDd6YXdoRjBDeWVoa3pIaVpLWW0zZGNWZmVaNGw1RHZqeWRKK3Vh?=
 =?utf-8?B?d2N3bXR6UUlPZjV4akd3Tnl3RmJHNzdkVmxqOWlvanBCVWhQSzVyZEpnQTUz?=
 =?utf-8?B?bGVtMnFTdDN6ODMwTmxPOTZLSUZyN1E2U3l6UDhVclY0bGt0Z2tNTEJmNW1C?=
 =?utf-8?B?STZ2MXJSbVdNK09xTlRHMTlkcGpzaUFkaHJwUVpOV1ZnSWhOSXpBT1FoeGs0?=
 =?utf-8?B?YittTXBoQ3J1UXpkbHQxNWlpdjRpMkZOZXMzMEF3aHlFaE5WdWxzekVJM2Vu?=
 =?utf-8?B?eHc4NXB4Y25aQngzTm00bzV2QStRVExqR1MxNk8vVmUyL3ZnczJlcVBhNDJC?=
 =?utf-8?B?enZ5MzdHRkM2NHliZm4zakgzL0I5eFdGL3E2aHYxVzFqQXRhcDczaFJsVmRV?=
 =?utf-8?B?Y3k3T3V0TW5GYlV5MVBkSlpGS2QxSGhKTVc3Y3VNRnlYNHMyVG81TXlaMUdE?=
 =?utf-8?B?dkc5Q2xCKzgyZTFmd2RTeFl1L21QT2RsK2R4c0ZNOGZDNnBVY0IrdXp4UmJz?=
 =?utf-8?B?RDAyV3V6VElWR1g0RW84V0hoTVhXaUE2ZU8wTGJkV2VlN0c5NUlIR0RER1Rp?=
 =?utf-8?B?ZlByeldXT1lRY2U0SWVzOUZhU2w3MTRsWGNad0QzYlJsYUthenhWSEtIL2d3?=
 =?utf-8?B?OHpuUzhuL0Zkdk9JS3QraU9BVUx0NlZWZWNzYk9XYkYvb3NOWVF3YlhiL1h0?=
 =?utf-8?B?NTV2dzVOOERtbmlRcXQ0eEg4T2ZrS3hpdXM0emFucWxVSytCOHJ1MC9WajN0?=
 =?utf-8?B?aHhDVGJzTGFuZmxOenFlOERJQ3R1dTlWenQ5OE9Cb0tmNnNJR2w2aytPK2tW?=
 =?utf-8?B?TVp6dzJCUFJhemM2bDVPZ1lmditzNVRRQ1drUlVPay9RUzlybjUzNlJCWk5I?=
 =?utf-8?B?NEUrRS9UY2Z5MUR2d0xHNDZWT1VKeDUrQS92M3BBM3VHQjlLUndJYXBLdUk3?=
 =?utf-8?B?M0JNbWhpSjMybTBYcXFWcEFGU0M0KzVDdFozYWh4S01KT1c5cVRBSGZ2VjhJ?=
 =?utf-8?B?T0Rna3JhMUZSZ0pWbXU1SWZuR3ZYZ2FWb3BhRkVpQTdGb2dKRmZTL053NWZm?=
 =?utf-8?B?MUdURmZzeFZrblVET2Z3WE9WejA4T29VUUxTWHBjamtjQXFQaHpGOHlOenlZ?=
 =?utf-8?B?cTZ1MFRXa29xZFJjS2VsNWhQS0NBenJuNWkrMnlmcW41TWxwbTdiQTJJTnF5?=
 =?utf-8?B?VkNsVjZ3enc3SkQwaU5QT2phS3ZrMzcvM1lJL1pjVEFwenFhUFRtcGY5U21z?=
 =?utf-8?B?SVNTcXlPSUYraDZERkVzeGVEOHd2OEM4bE9Uc1Noc1N3MTJwUWJuMHRwVHNm?=
 =?utf-8?B?dldZMmhlUTZVdERnZ011MlMwaHp6b1JZdi9NT21COXc5dlhBbThrUWdRV2tR?=
 =?utf-8?B?TkNsbDlrQms2WkEzWTRRSDZBc3BQKzNScmhLcjV6SGUreVRZSzM1SUpjZHhK?=
 =?utf-8?B?UjZRRlIzMHRLNSs2M2k2MjlLcWJORTN0OUJZby83cmZBSFRHbFFqVi8rbjAw?=
 =?utf-8?B?VGZkZ0Q0a0pFR3lwMnhyenRSM041R0J1N1liQWlHWjlLdUFPM3I4MEgwd3ZF?=
 =?utf-8?B?cGZzK0lBYXg1K1FTdCtpc2psbWNqUWdNVmJVSW1sMTJ3dXRGL1R3b1ROZkZE?=
 =?utf-8?B?eDIvOW01SUxDL28wQXdSdjFSWW1oTVBOdmloWHBnVVhhczc5Wnl1NVlySFVV?=
 =?utf-8?B?RWtzNGFsNmUxWXZ0QmtyakQ2YWJsa0l4WWtMTm9HNmM3c0c4dlRlRlBKWHlx?=
 =?utf-8?B?Ui8xdC9CcUxFbHZXRmFlS0JIQ1lwOEh3TmdEV0tuUDM5OXBwZWhJVmQwVW0r?=
 =?utf-8?B?OXc0K2l6TmNSNUNQcUx0QmJFRXh6cEEwdUlBYnd3N1pKbTZ1VFo0R2xuZFo3?=
 =?utf-8?B?aWFTTWNGZEhjZFVyMC9lNURBYjFKYnNKdzEydG9Ga3ZtVjhxZzRBOGpCMXAv?=
 =?utf-8?B?MHUzaCtPUlRaOEhYKytnSHUzRGQ2aGdmVjNUclQxaEMzKzFkbkR2bjZLelB6?=
 =?utf-8?B?VVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <597B389841480144BE9576C3FD0DD7F3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2453c67d-8071-4830-2248-08dab880efe1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 01:08:34.6024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Asz1EgzDegy3fmp+EFBwRVf+O2McJEhkWkrGb+409KHVCUD0GU20w3RHtugCizsuNM6CBOAJt6dE2/Kqtk8CXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6850
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTI3IGF0IDA1OjMwIC0wNzAwLCBBbmRpIEtsZWVuIHdyb3RlOg0KPiA+
ICsJCW5leHQgPSBvdXQucmR4Ow0KPiA+ICsJCS8qIEFsbG93IHNjaGVkdWxpbmcgd2hlbiBuZWVk
ZWQgKi8NCj4gPiArCQlpZiAobmVlZF9yZXNjaGVkKCkpDQo+ID4gKwkJCWNvbmRfcmVzY2hlZCgp
Ow0KPiANCj4gY29uZF9yZXNjaGVkIGFscmVhZHkgaW5jbHVkZXMgdGhlIG5lZWRfcmVzY2hlZCBj
aGVjay4gVGhhdCBpcyB3aHkgaXQgaXMgDQo+IGNhbGxlZCBjb25kXw0KPiANCg0KV2lsbCBqdXN0
IHVzZSBjb25kX3Jlc2NoZWQoKS4gIFRoYW5rcyENCg==
