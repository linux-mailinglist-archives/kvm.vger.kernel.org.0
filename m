Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAFF66D486
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 03:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbjAQCs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 21:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbjAQCsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 21:48:03 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB6C30E9D;
        Mon, 16 Jan 2023 18:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673923297; x=1705459297;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VHwU5hIB2s9LP9shpqUNASGjZLEYktn8JEpL/+u/MH4=;
  b=S1gOC82oR3GX2Eq5BwYgK01iPKa7/0bqsPCiJ929kh+5JcgMWxQh+7Bp
   jwMGlel60BVqcbAIHxyxRihsukH+phIGjTQQwn2zDGBIqKGJDftcj42kj
   OggNttBZMApewUpMjt0lqZKv/drlyqaEFK6VvT0LDliwIcfQHAeCY3PAm
   Z6LHHNX7qfGt4x4VWmoj/wQoImmoiQZk8iX8xtRa7UuPL+9VqSF705ROV
   QjaYgnOASaobF4eifNOHF0JUHOyKWckRLCONbp1DMXu1+bSmcT8LaghCC
   5UvNA8PUmurXx8U6wE8scXw9FL87lVOtGTys8F4you8/w1pLUjm1MsPhX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="389096252"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="389096252"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 18:40:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="801568578"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="801568578"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jan 2023 18:40:51 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 18:40:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 18:40:49 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 18:40:49 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 18:40:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJKsstDlEfGOU4ZtdnHjbncBFq5qhUt85ROKhqUOky9Oa+NgJg/RoCdlZBnh0rWmkYyk40pjEKhRqjcJ0Nq28hOLVi5d2GHUHa/haIsIzXaLyTj06ukD2/7M+MrUsdsfT74KdpR1Z44zVxygJRn+OqxiQRdHthJg20arJa8ndcFxZSU7hafY826yoZTaEHMFqIp9vLylxuj2FugbX8JUXtjTCtNTftB5dCkfTUFsGoNmian/tnriHUM4HRfoWO0WpJfOMbvd5lVfqcSMX8WebR2m+Hy5AfM23TsksGXwIOIC9wA6i+/N9Q6pQfcZcvIld4S+HW5osrNf66zYI2K85Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VHwU5hIB2s9LP9shpqUNASGjZLEYktn8JEpL/+u/MH4=;
 b=EmVUrWrz8fThpa9Qx1HdbTdBjWnWhS5id1NE86U4UgYqxTSlSAJkPJZxiIyYXymM6qJQJVHj7l3MXi0t0u3MIuRhOrki04OYsDAiukeuo14h/yE0SqZhkGMb7+d+REECExMmwevj3gsKPgY6U+FVCPe8NtK9yB46v3zM4mPV8dUqhlBqRpGCqgL0Hf4JOVcCPBInA7fOe/aDvz8ygPqf1VIKOdreqvdKkARnHCsGbbUqWZD1OVe/0/1zUi7XEJbJL0Z8IOh9pUVwgV/GjYCuu0Y7pGsPwSzwo4MDEsfuxmyF2T7FoK5Ax9YwBpQ4oYaChAhjNiIxtw7t4vW9C+m0Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6104.namprd11.prod.outlook.com (2603:10b6:8:9f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Tue, 17 Jan 2023 02:40:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Tue, 17 Jan 2023
 02:40:46 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 050/113] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Thread-Topic: [PATCH v11 050/113] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Thread-Index: AQHZJqWCjHh45046J0uLRGmChK4aUa6h7OYA
Date:   Tue, 17 Jan 2023 02:40:46 +0000
Message-ID: <945d4ad2b415776a642f4f1f934d1a780a7423f2.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <7a0fb2a0dddc87fb8d34d5af8fc73b288dbcc63c.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <7a0fb2a0dddc87fb8d34d5af8fc73b288dbcc63c.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6104:EE_
x-ms-office365-filtering-correlation-id: b82424fc-b098-47fb-06f4-08daf8343c78
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t49FnSgT9kbL4qkqImZW64P3Qf3Sjd/xnQB+IhzkpTCHccTCN4rvUqUyI8Tvq83D7DraT+Ynm7AeqU3gK6L7JX93xFlGdpF6TkBl7OvRQSFWrZ6Um92HdJ4800V9i7Uf4sbdgl+hMI1q8cHPtyeKSzIF4kR3IgLuDmQUv+ACVCKlvIwRR5x5aYtsmxfs4vED58X8mpq5mWCSWg9FGGV2T1aaYkosHFAgDTNttoGTqkDZhihPSdofXU3qBD/ED7r7eaqYd1nE0spB68C8LaujGYtzL5I3yN9KEUmlZYPQQL/Vl5JxbMdmUv3wx1TYIfmVlqS0Al3wAsNH1Yte1HjE8uKMp3taNcdhslKeLAxKXW6PlzlRKVFoHgN8ppE0qw6vbb31Fej8ekmdPl9fgA3v3LfjpKdDTFnQjYe1Cxq7PpxrdGoGXSf8Cy4uNMzB8lgvlVSRvQWg+2yoIKD4ghZS2tUrpPTe3G1goSYxO+fpF0WVaUPkTMVBF+Bwl2CxI/w/VnyqTW89fq6IalCxcsibF7srQy/MZJqvU3wbKFVIhwWGQ/xuoryhOgQC9KlpSdRtPBFL6fdc19JHmaWHJB6lYBuFapxYGo6Gu5YNhpwLz9AeDkuHFFdfD95+GQiPHIVCP5l0UMt80qgqsvzBHOYJa/Z2f3lEROfzWs23bQFqFInhLScl1xPqelG7tlYPz5rdhs4seit5lS0OrHJEVjcBJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(36756003)(2906002)(38070700005)(86362001)(76116006)(8676002)(4326008)(66556008)(66946007)(66476007)(66446008)(64756008)(8936002)(5660300002)(83380400001)(38100700002)(122000001)(478600001)(6486002)(316002)(71200400001)(110136005)(54906003)(6636002)(82960400001)(91956017)(41300700001)(2616005)(6512007)(186003)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlZEclg1eEJ1Nkdrd2NqK05BMUZXb3ZqV1hDZ1p6QlpMa2EwZlFvVjRGc0RR?=
 =?utf-8?B?THB2azFONlFpa1Zabkd5QUpCaDh0dVJneld2V2ErbVBpeG9HMytTVm43dXFw?=
 =?utf-8?B?U1hsdVVTY2JHUDFwSmFOZktTVC91cUx4U056TTlmd3lHeHljcmlkQllTNitS?=
 =?utf-8?B?RjBiV1NkRU9wRS8vRk5OZnA3LzVud3EvUUFJTElyRkFoVm1sZnd0NnpnSlVz?=
 =?utf-8?B?ejNIQk5CMXZCS1hoVElIM2RCblpuWkw5VDhtVWpTTkZubUlyYlhPajB6OE83?=
 =?utf-8?B?dE5hNDBBY091QUw5eTU0RHMxL3pKSDdVSTZ0N0FyNnNOcmk4amlFMzFaM3ZM?=
 =?utf-8?B?Q0pyek0vc0I5c2FxcHNUSzI4NUpYNVRaZDFQc1pzdm1UN3pleGcwQkY2YVhF?=
 =?utf-8?B?cm5OeU1KN2dicUFJbVF2UWlHcXV5VDJubkdadFNJQ2EvRERhSDJETXJ2ZXg4?=
 =?utf-8?B?WjgrWjBNRzZpN1U4UFI0VkszcWhQa3FscWkyZmM3cnl1SXV2eC93MmxENDBG?=
 =?utf-8?B?WkR6TmRFbFJtVStILzNMSGgyMHpJb1c5dmErb29CUnhEeDJmdGcwTFlLbGd5?=
 =?utf-8?B?bDNwWldtMlU5RzEzZXNPUWNyZzFSU3lzT216YWVLZXFXdVBCWU41Y0t3cEFI?=
 =?utf-8?B?NEFQaWJ1L29zQjdDMlh0ZTlaTzdYWVpHdXNISHVDTisxVFBjc2Y5TjlzQnkz?=
 =?utf-8?B?b1l5enAyQllMRCtISFZTbGRwVUxIQVlQcnBteEh5bVhseDVEMHpCZ0hlZ0ps?=
 =?utf-8?B?U2JEb2pBWlpGNDZVcGx1UkdjcHU0WExMSS96NW9sQThjY2NEZ2xWaGQ1Y0dB?=
 =?utf-8?B?RjIwY2VZZGVPZG5qMTFXWkJXd0VaQTNXczRYbFBkaG1pbXVycThsRWtrN3ky?=
 =?utf-8?B?RVVSUDFnOThqWUNsd3o5ZFUxZy9ZeldGellvdUFQc3VHZmxHL1U1VHRCUCtn?=
 =?utf-8?B?enpvZnZ3dlR3aUFKUWJkRVFaQ0FvKzBlVHM5Tkl0WWJlamtMZVllUHZHMEhX?=
 =?utf-8?B?emYvQ0JTK2llcWw3WER4YWl6NnZzbWhjZlltWC9aUG9mT09JbkJGS0dldkpC?=
 =?utf-8?B?NFFSRHd4cGM2TEZQSjI5QzZBbm5icFlMemNXaWlmdjduUG1MNnRUN2lpM0hS?=
 =?utf-8?B?Uk9hVm0vSkpSRDdUMytaQXhzQ2dkRUFwZHd6R2tZTFdiSXVxeHc0a0dJZkFI?=
 =?utf-8?B?OUFsR2NmdklHcy9QNWVpTDVET013VHBGVThkNDJVUjM1OWRLVWhqRDd1Y1FU?=
 =?utf-8?B?cENxYk5wUGRLdFBZK2RXTkpCTnhIR2xrVXdoV0xwUFpFWk1JcUVrMC9QbmFQ?=
 =?utf-8?B?eEF4TFNqdi9XQ0s4bHVOSXhVcHdUY3RuNzB2c2d4RUpKeEpQREgzMXArR0tu?=
 =?utf-8?B?RXU4RDg2KzhuVytiK1V6eTMyY05wN1hFVkdwejlXbWxkNUFNaUtwS0d6MTNZ?=
 =?utf-8?B?YTdtSUo5WkhrVkxlRlpUMzkrQjlnSFlHbzdFSWFvR2RpMjZ6MnZRd1FkbFZ6?=
 =?utf-8?B?czdFSit3YXVQejEyemVlUFEyTitpZk12bER1UFgrZU1ydGtPMjBsTFVzVGd2?=
 =?utf-8?B?ai94RS9FK3daK29aU3NkbExMWFFYUW0xWFJuYlR0VVQ5NW1YWmZRaFIwaFdX?=
 =?utf-8?B?MFEzemNBOGkxTjkvRzBVaFFHL1d4c2t1ZjQxc1Q3RklRWmNxOXV1ZXFzOWdl?=
 =?utf-8?B?ODVGWEtKZlhqb2RiVk1xL3BPbWM0U1NnMzdycEVsbU1NZnhaRWJadWZWKzA1?=
 =?utf-8?B?SU9MREJha0g3azlSWmV0T0U0cTRBVzFwQ0llV1NLa090RjVOZ3ZqTFRJSTVW?=
 =?utf-8?B?elNrdnZSOU1FTThoY1htNnNJVTJkNXBuRE0vNFAxemhOc0Rrem9PY2lhRGRv?=
 =?utf-8?B?bXhuR2xHMEtkNGc1NTVvaUxHaGMwWFdiS3p0TU93eVY3S3haMU5Kckl0cVV1?=
 =?utf-8?B?VzBYODVscTU5d1krRVZQMG94dEJBR1FGQzd3NlAxTUZyb0o5SUh0aUw3WlBG?=
 =?utf-8?B?QTJJS0pabVM1eHVXaSswTFdIeG05QUtubDh5Tis5aFZubzlTcVpLK0VTRTBL?=
 =?utf-8?B?U3dVbDlRZFU2VEk0NitQMnJHUllJeGJJYjlDckt4c1NldElHVVRBNmFsZFdG?=
 =?utf-8?B?Z0dGbXk5R1VwVngyQzhycWVhZi8ydlFIZStMNExYUmFBSkg2SStnK2xBcU9r?=
 =?utf-8?B?YXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B3F803BAC635A42ADBBA43A03F03A90@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b82424fc-b098-47fb-06f4-08daf8343c78
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 02:40:46.2364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JRExR1t/AQ57/A0YgrysFWzMwMVdASjj5zmccCFTLi/qUeYGzdKKACgziPikGzb3ZSuexFeqa+hH2LqUGLWnow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6104
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBTb21lIEtWTSBNTVUgb3BlcmF0aW9ucyAoZGlydHkgcGFnZSBsb2dnaW5nLCBw
YWdlIG1pZ3JhdGlvbiwgYWdpbmcgcGFnZSkNCj4gYXJlbid0IHN1cHBvcnRlZCBmb3IgcHJpdmF0
ZSBHRk5zICh5ZXQpIHdpdGggdGhlIGZpcnN0IGdlbmVyYXRpb24gb2YgVERYLg0KPiBTaWxlbnRs
eSByZXR1cm4gb24gdW5zdXBwb3J0ZWQgVERYIEtWTSBNTVUgb3BlcmF0aW9ucy4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQoN
Cg0KWW91IGFscmVhZHkgaGF2ZSBwcmV2aW91cyBwYXRjaGVzIHRvIGRvIHNpbWlsYXIgdGhpbmdz
Og0KDQpbUEFUQ0ggdjExIDAzNC8xMTNdIEtWTTogeDg2L21tdTogRGlzYWxsb3cgZmFzdCBwYWdl
IGZhdWx0IG9uIHByaXZhdGUgR1BBDQpbUEFUQ0ggdjExIDA0My8xMTNdIEtWTTogeDg2L3RkcF9t
bXU6IERvbid0IHphcCBwcml2YXRlIHBhZ2VzIGZvciB1bnN1cHBvcnRlZA0KY2FzZXMNCltQQVRD
SCB2MTEgMDQ4LzExM10gS1ZNOiB4ODYvbW11OiBEaXNhbGxvdyBkaXJ0eSBsb2dnaW5nIGZvciB4
ODYgVERYDQpbUEFUQ0ggdjExIDA0OS8xMTNdIEtWTTogeDg2L21tdTogVERYOiBEbyBub3QgZW5h
YmxlIHBhZ2UgdHJhY2sgZm9yIFREIGd1ZXN0DQoNCk5vdyB5b3UgaGF2ZSB0aGlzIHBhdGNoOg0K
DQpbUEFUQ0ggdjExIDA1MC8xMTNdIEtWTTogeDg2L3RkcF9tbXU6IElnbm9yZSB1bnN1cHBvcnRl
ZCBtbXUgb3BlcmF0aW9uIG9uDQpwcml2YXRlIEdGTnMNCg0KVGhleSBhcmUgdmVyeSBjb25mdXNp
bmcgdG8gbWUuICBUaG9zZSBwcmV2aW91cyBwYXRjaGVzIGFyZSBhbGwgInVuc3VwcG9ydGVkDQpv
cGVyYXRpb25zIiwgY29ycmVjdD8gDQoNCkZvciBpbnN0YW5jZSwgdGhpcyBwYXRjaCBzYXlzICJk
aXJ0eSBwYWdlIGxvZ2dpbmcgaXNuJ3Qgc3VwcG9ydGVkIGZvciBwcml2YXRlDQpHRk5zIiAoYW5k
IHdoeSB0aGVyZSdzIGEgJ3lldCcgYWZ0ZXIgaXQ/KSwgc28gYmFzZWQgb24gdGhlIHBhdGNoIHRp
dGxlIG15DQp1bmRlcnN0YW5kaW5nIGlzIHlvdSBhcmUgZ29pbmcgdG8gX2lnbm9yZV8gImRpcnR5
IHBhZ2UgbG9nZ2luZyIuICBCdXQgeW91DQphbHJlYWR5IGhhdmUgYSBwcmV2aW91cyBwYXRjaCB0
byAiRGlzYWxsb3cgZGlydHkgbG9nZ2luZyBmb3IgeDg2IFREWCIuIMKgDQoNClNob3VsZG4ndCB0
aGUgdHdvIGJlIGluIHRoZSBzYW1lIHBhdGNoPyAgT3IgeW91IHdlcmUgdHJ5aW5nIHRvIGhpZ2hs
aWdodCB0aGUNCmRpZmZlcmVudCBiZXR3ZWVuICJ4ODYvbW11IiBhbmQgIng4Ni90ZHBfbW11Ij8N
Cg0KUGxlYXNlIHRyeSB0byBtYWtlIHRoZSB3aG9sZSB0aGluZyBtb3JlIGNsZWFyLiAgTXkgZmly
c3QgZ2xhbmNlIGlzLCBpZiBpdCB3YXMNCm1lLCBJIHdvdWxkIHByb2JhYmx5IGhhdmUgX09ORV8g
ZGVkaWNhdGVkIHBhdGNoIGZvciBfRUFDSF8gdW5zdXBwb3J0ZWQNCm9wZXJhdGlvbiwgYW5kIG1h
a2UgaXQgdmVyeSBjbGVhciBpbiB0aGUgcGF0Y2ggdGl0bGUuICBCdXQgeW91IG1heSBoYXZlIHlv
dXIgb3duDQp3YXkgdG8gbWFrZSB0aGluZ3MgbW9yZSBjbGVhcmVyLg0KDQpbc25pcF0NCg==
