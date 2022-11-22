Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88605634B03
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 00:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbiKVXVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 18:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiKVXVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 18:21:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49FEC67D3;
        Tue, 22 Nov 2022 15:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669159306; x=1700695306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9f7eh1+Ahd6zcpt/zbir0AiJDK43uYaLDt1Q4RRSsz8=;
  b=k2PsdbEg+vt3V/SuNh212BHUJAKBg/IEFJXwaPpLCucSmNPUdVicmXcZ
   IqrUnqc2SwKLxIw0Fa5/p6TCQf9FlJbNkPz9z9Y1aW64EtjwgLSn0zB4M
   RPf8fe4jBzbdhtCSYUpkhSf4aVo0okIkL1Ofm+mnrwCJMEqSzC7UVPF68
   Vz9z+75GbxNKamf7U2fzsiN8+PejqL/QSOQGjYUzxRDMjOJ20n9upOu1D
   eUCno49nVUMTdSuiAywC5mvApIvMg68GZOvoXcVYhzqosWJinr5rI+63k
   gywg7vGXGcPNyZ+FYTHxTELA8bQ9bMnz71sVrJUPGM94nigpHsGFaDnnk
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="301492193"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="301492193"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 15:21:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="674512465"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="674512465"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 22 Nov 2022 15:21:45 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 15:21:45 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 15:21:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 15:21:44 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 15:21:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8HcewuUKIOvZiwyKoSYimjTLT34fYijm+ilZR91x8cSR0dHKWny2vpuV1clSL/17DUpTgktBEefFxcOaCVSuye2DAOmJNY1IQli9cmKoGOYE8xSyOzm67vYuoupuiMSq4pF4gtVhMAST0Ykzrck1JG8hxplUVN6i6UdO9qSb8chHvitiUkYsiZtDX6Vj0xqTE439oNZjE0KxS1yiFKE1NuGcHDlUg5KkNKhYouiv4XFWgO7Ka8RrkrAYZeJmqyWqks7ci8AaggUEjVOMMF8Y92Gyf8H9jbydu4yjXSVSOfM2XJzYz7fAjPcgJdosCeZMw57BBvu975oEArBVoWaww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9f7eh1+Ahd6zcpt/zbir0AiJDK43uYaLDt1Q4RRSsz8=;
 b=Mfr7Z/FZiL3LVMAn1ga07h+4dOPc1GmtShVBjNQwEm3/Zla5RNA7j0tXsGIgYe9li4zJVN78JO/GAkWUKd+ZgHMQ7Jbjz7S5PEV0w8bmCeaIff2x59CeYQ0oHRKEEs8TV5Oq5FVCOuNp7LpYmUzRdfe8ekCw233Cm3RyVuYJ7Y1eTYJsJBG0RKUZaJCmO2DiU93M6Itbs0i37AfobREEtFZbDxA8P53Be28qynPdxfWk8AJae/hHzeXJo5/FBarQd1hPUi3me3qF5/YrIc3lyDMpZ9yBuxwRaVCZzzwbiQNFy801dwkzNHdo763x5pLcdjNszU5s8uoQ5L3WPj41/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5631.namprd11.prod.outlook.com (2603:10b6:a03:3ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Tue, 22 Nov
 2022 23:21:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 23:21:41 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 02/20] x86/virt/tdx: Detect TDX during kernel boot
Thread-Topic: [PATCH v7 02/20] x86/virt/tdx: Detect TDX during kernel boot
Thread-Index: AQHY/T294K8swb3sVUCgXbqBp7bt565KEzkAgAC9g4CAAFnPgIAAbVGA
Date:   Tue, 22 Nov 2022 23:21:41 +0000
Message-ID: <b6f505bec9984febab84964c6422b4195938ff62.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <aaee2d5332a97c840ad401ba935842a998a877ec.1668988357.git.kai.huang@intel.com>
         <e758572a-5bb1-092a-10f6-591fb4526997@intel.com>
         <9db9599fba11490cebbe59cbb7c145e9c119ab0f.camel@intel.com>
         <f743a4df-f285-3f07-02ef-b908020e0c93@intel.com>
In-Reply-To: <f743a4df-f285-3f07-02ef-b908020e0c93@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5631:EE_
x-ms-office365-filtering-correlation-id: 142f665f-10da-4ad7-8cf5-08dacce04ff8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nwMpQQALSu5txtm3EHkTfkpKhVRxFYuGd6ulYMgELIjRChtBKnitOpuNCc14KiQn5kFtLhK3I8uYB0jlZvwBHCFd9kWJkJ2hwdTdVnUwnaiKufcjg4Zx5rCnD01liicupnXj8RMZa09N3RRuGhiPK1HXdijNSjOrX2nYxqaEW7m5DJMsSkDnrcTOv1Zr81InPUvWdIiYcHJnl67l5z08/iiw9rHXaNPE3ma2oauDQeAhxRu8GAZ93vT3yrJIgzNf3zr4xLiQ4MBp2FB0ENuBpnN8QwIs4Eej/RN0dUI2sTppN1u0LqS4Cfss/gPZj9YsoKiDa8Y7zmdwSnDqn/ZUpanaJ7rViIQQZ8Z1Q4z5uxyDCJMi2Tbqku4Zr/ST9pWnZ30vcqVRJMGsGKzj9Tpy0VTj4iSsmVlCR62JTAZGUWD+beYqvrrxXdN9TWe+eR0PFPZIpNSw80+Ec9g73nAxw5zCrcm11BSXY6Qs0YhFVVfWt1NvPbti1JE6uZ6w7wR/vtvuY/r7E9C4umm6A9XKaMWBL+XvRuCEqRcyXZGwetHh6waHrgbawDj6N/y69yXRNusVq/nhwXpk5iTk2cUG2WQgsdIu33CkeCpC9E+cRqJMyWEP7QL7+K47zhOMAP4mXUwGVipo6+r+fhOIeoH2xVbaMTpXRS5rGrU06Zma1dlDZXfT81CywIP62cqTy6iNfP5edBglQ904yzJ31nfJyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199015)(53546011)(316002)(54906003)(26005)(83380400001)(91956017)(6512007)(8936002)(82960400001)(86362001)(66946007)(76116006)(186003)(2616005)(8676002)(36756003)(7416002)(5660300002)(64756008)(66446008)(38100700002)(66556008)(41300700001)(4326008)(122000001)(4001150100001)(2906002)(66476007)(6486002)(66899015)(478600001)(38070700005)(110136005)(6506007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWNuV1ViVmJOSVJkQm9JQWgzckNnSGtoUWtMdVpIcDZZM0gvUzY1d2dTWlVy?=
 =?utf-8?B?UFF0NEVEK2FaWnRCZjJrOVBEUzM3ZHRsWnQzL1FoM1o1R1B3ZUkrb1RleVVS?=
 =?utf-8?B?TnJPOThONzEyT1d1KzYzY3N5VEZYS3JBQ1VidW9lRGN2eHZzYlRhRExDZ1FP?=
 =?utf-8?B?MmhUSUxNK1UzeWVLaVBGOTMxYmJQa2d3OVBCT2RaZzZBRDVRVmgveHdwaEk2?=
 =?utf-8?B?U1BKSGVuOGpROXJnbTVWMy9yZFdNNUU5T0ZlMjZMaVdsb3ExVEN0WStKUjdy?=
 =?utf-8?B?MnhHY2xUNTR2eGwrRDc1RklNVkVoRUk1RWdpcVJZL0tvbjVqTitNTVlIajBr?=
 =?utf-8?B?azNmQ1M4R2RJRFhOdGdMQ2Q3L1lLNlBkM3NtaGc3YmFVc0o1djc2aXlaM092?=
 =?utf-8?B?dExzZ09WbUJJNEFzNStRUmdMOEplb0RNS3U3NWJuM0pteElKQmhYaXgrTlpU?=
 =?utf-8?B?V3R3ZjcrS1ZaWWR2Q0RkcFlzSDlBVzlTcE9wRlNUeWg3NEZSUG5OS1dZZWxw?=
 =?utf-8?B?Z0xMOElqQmxaYTFFUmhVenRMVHd6LzVvN01BVE9EMnNVSEVOZ0w0SUdFZUdR?=
 =?utf-8?B?dExpOUFha2JJeWlVdThXd3JBalp1Qng2S1cwd3NXZlRBb25qSHFpNmZEUWw4?=
 =?utf-8?B?SkN5TVRYY3Fxb3dpUlpJd3ZBSGo0ZzJDWGJySitkZDBOUGVuWVljVFZXcldE?=
 =?utf-8?B?WVdWdlZTd2dzLzVSdjB6ZkIyemRzZmljYjBBMUY3TXpUTVlQSWtBYS9JVmdB?=
 =?utf-8?B?SEJQeUo2STUvNTQ5eUpqWU96emJPUFBiTWpVQkp6VS8yYjNDVUlDR205ZE53?=
 =?utf-8?B?RlhLSGZEVnBBQk5sUjNwL1VOU0gwbXpOT0owcVdMdEVRVnRXeUpMWS8wZ2tB?=
 =?utf-8?B?dlJCN000OHRNRlZtaDJsb0lGN1lhZWc1NUdqQndhTVBPakg5bHh5bUtGZWdU?=
 =?utf-8?B?alNyR2o5bTVtOEhMemVxcThkakVHN1phQ1I3MlRXMk5mdHYzdFNNMTJQSWhw?=
 =?utf-8?B?MEJtbFNTVTVwK1lXN0ZBYWgwQzA5ODAxTStyR2plK2FiS3NQRzljNmlpNzIr?=
 =?utf-8?B?a1FhSEZFRzkxNlpYNUhhOWxMcDExVmJZeERLcnFyUFNjRTNqOVQyaWZ1QUNl?=
 =?utf-8?B?aFptekRDUnB0Y0NobldZV093TTdCUForMGZOdTlRK05ydHFuT0d5OG1RV21X?=
 =?utf-8?B?UGNqZE1rWm9SZlNUbHo5ZUJFcGVLZUlNTzZzdTQ5NGRqOEs1WURVTUpwZXQx?=
 =?utf-8?B?WkhYZHRsU0RnOXVFQXRING9rRHZ2d0FkSnEvNEk0UmVsVGdnR05lZWdIZFBv?=
 =?utf-8?B?NXQ2N2FlUlZGSk5pVGpLeHVIWE5ycjhPclZGOSt3NkZnUE0xVE4ycXhSYVhq?=
 =?utf-8?B?VjlZS0lGTkNSVGNRSWZaVHk2eTV4Z2ZCc1JTc1JPck1mRlQ2NUZYVU4vWTlh?=
 =?utf-8?B?eFR5ZEp5eU5oODRzcE5XaGdBWWxCOXYxZWlJcXN4VTF4UjEva0pzeHJGb3FB?=
 =?utf-8?B?dUlEODRiZkxnbG5NTVA4dUQ5STRQbk9nNlZoWjBGaERUY09TRjF3ZUpRRjRY?=
 =?utf-8?B?bU1KNTlsT1I5bmJxZTV5eENBWlUzSjJYa0d1ODJReHVMTVloZHVVZlIxYklv?=
 =?utf-8?B?MWVNbVViKzZMOC9DenVkSGY4NUJNTGROdEhjdWtzSG1JUW1pY2d5K2dtV0U4?=
 =?utf-8?B?bkV0M21taEZxUDlWWXY5aDF2dDhuTnYwTDM1VWdHcVJFVWZaMHZmdzBwSW4x?=
 =?utf-8?B?U2wvYzc0MjFsRWNhR2RBc1V4V2RWTUxoc0lRdVpXM25MSmZBdWkzZEJ2b1B6?=
 =?utf-8?B?NGR6MjZHVmwydFFpLzhnWnhuYXdIS1ZmWEN4ZVhaQlJZVnFRWGRRY1RjanNk?=
 =?utf-8?B?aUlXelR3NG9PMFc1dUczdG8rM2c4S3Bra1VYN1cxWXJaaHlDQVRGNFFIem5P?=
 =?utf-8?B?bFM0ZlIzcXZWNS9zK015d3NobnV3aEdoMUxscjZuS3J0K0UzTk9SNHU2MjFB?=
 =?utf-8?B?MUtSdi9XUngvZVFoem5iQkxUbUJUa2pWd1VkWTZHOUJxNmFzYWJkL3AyUUho?=
 =?utf-8?B?QzBWSFR0UDIvNXVpZlc2Wm9vNlQ2aXZTOTdSMmZhSit2K3FmZjJyd2xwb1c5?=
 =?utf-8?B?QVFLMHR1WVlaSFVLMlBUcytpeUFIK2xxZVR0c3lHaDJWYWFWWkZsSFVQNDRF?=
 =?utf-8?B?dXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6FA863C40F2614590F35B8E9B10F9A8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142f665f-10da-4ad7-8cf5-08dacce04ff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 23:21:41.2619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JtV0Yyvq8JZSAGfb0drQ/j5DttCnrXxDFSRgZqgJidZgjBU1L9100uo891qLbHExVLlkgpubonKjpKsulua7tw==
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

T24gVHVlLCAyMDIyLTExLTIyIGF0IDA4OjUwIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjIvMjIgMDM6MjgsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiA+ICsJLyoNCj4gPiA+
ID4gKwkgKiBLZXlJRCAwIGlzIGZvciBUTUUuICBNS1RNRSBLZXlJRHMgc3RhcnQgZnJvbSAxLiAg
VERYIHByaXZhdGUNCj4gPiA+ID4gKwkgKiBLZXlJRHMgc3RhcnQgYWZ0ZXIgdGhlIGxhc3QgTUtU
TUUgS2V5SUQuDQo+ID4gPiA+ICsJICovDQo+ID4gPiANCj4gPiA+IElzIHRoZSBUTUUga2V5IGEg
Ik1LVE1FIEtleUlEIj8NCj4gPiANCj4gPiBJIGRvbid0IHRoaW5rIHNvLiAgSGFyZHdhcmUgaGFu
ZGxlcyBUTUUgS2V5SUQgMCBkaWZmZXJlbnRseSBmcm9tIG5vbi0wIE1LVE1FDQo+ID4gS2V5SURz
LiAgQW5kIFBDT05GSUcgb25seSBhY2NlcHQgbm9uLTAgS2V5SURzLg0KPiANCj4gTGV0J3Mgc2F5
IHdlIGhhdmUgNCBNS1RNRSBoYXJkd2FyZSBiaXRzLCB3ZSdkIGhhdmU6DQo+IA0KPiAgICAwOiBU
TUUgS2V5DQo+IDEtPjM6IE1LVE1FIEtleXMNCj4gNC0+NzogVERYIFByaXZhdGUgS2V5cw0KPiAN
Cj4gRmlyc3QsIHRoZSBNU1IgdmFsdWVzOg0KPiANCj4gPiArICAgICAgICAqIElBMzJfTUtUTUVf
S0VZSURfUEFSVElPTklORzoNCj4gPiArICAgICAgICAqICAgQml0IFszMTowXTogICAgICAgIE51
bWJlciBvZiBNS1RNRSBLZXlJRHMuDQo+ID4gKyAgICAgICAgKiAgIEJpdCBbNjM6MzJdOiAgICAg
ICBOdW1iZXIgb2YgVERYIHByaXZhdGUgS2V5SURzLg0KPiANCj4gVGhlc2Ugd291bGQgYmU6DQo+
IA0KPiAJQml0IFsgMzE6MF0gPSAzDQo+IAlCaXQgWzYzOjIyXSA9IDQNCj4gDQo+IEFuZCBpbiB0
aGUgZW5kIHRoZSB2YXJpYWJsZXM6DQo+IA0KPiAJdGR4X2tleWlkX3N0YXJ0IHdvdWxkIGJlIDQg
YW5kIHRkeF9rZXlpZF9udW0gd291bGQgYmUgNC4NCj4gDQo+IFJpZ2h0Pw0KDQpZZXMuDQoNCj4g
DQo+IFRoYXQncyBhIGJpdCB3b25reSBmb3IgbXkgYnJhaW4gYmVjYXVzZSBJIGd1ZXNzIEkga25v
dyB0b28gbXVjaCBhYm91dA0KPiB0aGUgaW50ZXJuYWwgaW1wbGVtZW50YXRpb24gYW5kIGhvdyB0
aGUga2V5IHNwYWNlIGlzIHNwbGl0IHVwLiAgSSBndWVzcw0KPiBJICh3cm9uZ2x5KSBleHBlY3Rl
ZCBCaXRbMzE6MF09PUJpdFs2MzoyMl0uDQoNClRoZSBzcGVjIHNheXMgdGhlIFRoZSBCaXRbMzE6
MF0gb25seSByZXBvcnRzIHRoZSBudW1iZXIgb2YgTUtUTUUgS2V5SURzLCBhbmQgaXQNCmRvZXMg
ZXhjbHVkZSBLZXlJRCAwLg0KDQpNeSBtYWNoaW5lIGhhcyA2IGhhcmR3YXJlIGJpdHMgaW4gdG90
YWwgKHRoYXQgaXMgS2V5SUQgMCB+IDYzKSwgYW5kIHRoZSB1cHBlciA0OA0KS2V5SURzIGFyZSBy
ZXNlcnZlZCB0byBURFguICBJbiBteSBjYXNlOg0KDQoJW0JpdCAzMTowXSA9IDE1DQoJW0JpdCA2
MzozMl0gPSA0OA0KDQpBbmQgdGR4X2tleWlkX3N0YXJ0IGFuZCBucl90ZHhfa2V5aWRzIGFyZSAx
NiBhbmQgNDguDQoNClRoZSBURFggS2V5SUQgcmFuZ2U6IFsxNiwgNjNdLCBvciBbMTYsIDY0KS4N
Cg0KU28gW0JpdCAzMTowXSByZXBvcnRzIG9ubHkgIk5VTV9NS1RNRV9LSURTIiwgd2hpY2ggZXhj
bHVkZXMgS2V5SUQgMC4NCg0KPiANCj4gDQo+IA0KPiA+ID4gPiArc3RhdGljIHZvaWQgX19pbml0
IGNsZWFyX3RkeCh2b2lkKQ0KPiA+ID4gPiArew0KPiA+ID4gPiArCXRkeF9rZXlpZF9zdGFydCA9
IHRkeF9rZXlpZF9udW0gPSAwOw0KPiA+ID4gPiArfQ0KPiA+ID4gDQo+ID4gPiBUaGlzIGlzIHdo
ZXJlIGEgY29tbWVudCBpcyBuZWVkZWQgYW5kIGNhbiBhY3R1YWxseSBoZWxwLg0KPiA+ID4gDQo+
ID4gPiAvKg0KPiA+ID4gICogdGR4X2tleWlkX3N0YXJ0L251bSBpbmRpY2F0ZSB0aGF0IFREWCBp
cyB1bmluaXRpYWxpemVkLiAgVGhpcw0KPiA+ID4gICogaXMgdXNlZCBpbiBURFggaW5pdGlhbGl6
YXRpb24gZXJyb3IgcGF0aHMgdG8gdGFrZSBpdCBmcm9tDQo+ID4gPiAgKiBpbml0aWFsaXplZCAt
PiB1bmluaXRpYWxpemVkLg0KPiA+ID4gICovDQo+ID4gDQo+ID4gSnVzdCB3YW50IHRvIHBvaW50
IG91dCBhZnRlciByZW1vdmluZyB0aGUgIXgyYXBpY19lbmFibGVkKCkgY2hlY2ssIHRoZSBvbmx5
DQo+ID4gdGhpbmcgbmVlZCB0byBkbyBoZXJlIGlzIHRvIGRldGVjdC9yZWNvcmQgdGhlIFREWCBL
ZXlJRHMuDQo+ID4gDQo+ID4gQW5kIHRoZSBwdXJwb3NlIG9mIHRoaXMgVERYIGJvb3QtdGltZSBp
bml0aWFsaXphdGlvbiBjb2RlIGlzIHRvIHByb3ZpZGUNCj4gPiBwbGF0Zm9ybV90ZHhfZW5hYmxl
ZCgpIGZ1bmN0aW9uIHNvIHRoYXQga2V4ZWMoKSBjYW4gdXNlLg0KPiA+IA0KPiA+IFRvIGRpc3Rp
bmd1aXNoIGJvb3QtdGltZSBURFggaW5pdGlhbGl6YXRpb24gZnJvbSBydW50aW1lIFREWCBtb2R1
bGUNCj4gPiBpbml0aWFsaXphdGlvbiwgaG93IGFib3V0IGNoYW5nZSB0aGUgY29tbWVudCB0byBi
ZWxvdz8NCj4gPiANCj4gPiBzdGF0aWMgdm9pZCBfX2luaXQgY2xlYXJfdGR4KHZvaWQpDQo+ID4g
ew0KPiA+ICAgICAgICAgLyoNCj4gPiAgICAgICAgICAqIHRkeF9rZXlpZF9zdGFydCBhbmQgbnJf
dGR4X2tleWlkcyBpbmRpY2F0ZSB0aGF0IFREWCBpcyBub3QNCj4gPiAgICAgICAgICAqIGVuYWJs
ZWQgYnkgdGhlIEJJT1MuICBUaGlzIGlzIHVzZWQgaW4gVERYIGJvb3QtdGltZQ0KPiA+ICAgICAg
ICAgICogaW5pdGlhbGl6YXRpdG9uIGVycm9yIHBhdGhzIHRvIHRha2UgaXQgZnJvbSBlbmFibGVk
IHRvIG5vdA0KPiA+ICAgICAgICAgICogZW5hYmxlZC4NCj4gPiAgICAgICAgICAqLw0KPiA+ICAg
ICAgICAgdGR4X2tleWlkX3N0YXJ0ID0gbnJfdGR4X2tleWlkcyA9IDA7DQo+ID4gfQ0KPiA+IA0K
PiA+IFsuLi5dDQo+IA0KPiBJIGhvbmVzdGx5IGhhdmUgbm8gaWRlYSB3aGF0ICJib290LXRpbWUg
VERYIGluaXRpYWxpemF0aW9uIiBpcyB2ZXJzdXMNCj4gInJ1bnRpbWUgVERYIG1vZHVsZSBpbml0
aWFsaXphdGlvbiIuICBUaGlzIGRvZXNuJ3QgaGVsLg0KDQpJJ2xsIHVzZSB5b3VyIG9yaWdpbmFs
IGNvbW1lbnQuDQoNCj4gDQo+ID4gQW5kIGJlbG93IGlzIHRoZSB1cGRhdGVkIHBhdGNoLiAgSG93
IGRvZXMgaXQgbG9vayB0byB5b3U/DQo+IA0KPiBMZXQncyBzZWUuLi4NCj4gDQo+IC4uLg0KPiA+
ICtzdGF0aWMgdTMyIHRkeF9rZXlpZF9zdGFydCBfX3JvX2FmdGVyX2luaXQ7DQo+ID4gK3N0YXRp
YyB1MzIgbnJfdGR4X2tleWlkcyBfX3JvX2FmdGVyX2luaXQ7DQo+ID4gKw0KPiA+ICtzdGF0aWMg
aW50IF9faW5pdCByZWNvcmRfa2V5aWRfcGFydGl0aW9uaW5nKHZvaWQpDQo+ID4gK3sNCj4gPiAr
ICAgICAgIHUzMiBucl9ta3RtZV9rZXlpZHM7DQo+ID4gKyAgICAgICBpbnQgcmV0Ow0KPiA+ICsN
Cj4gPiArICAgICAgIC8qDQo+ID4gKyAgICAgICAgKiBJQTMyX01LVE1FX0tFWUlEX1BBUlRJT05J
Tkc6DQo+ID4gKyAgICAgICAgKiAgIEJpdCBbMzE6MF06ICAgICAgICBOdW1iZXIgb2YgTUtUTUUg
S2V5SURzLg0KPiA+ICsgICAgICAgICogICBCaXQgWzYzOjMyXTogICAgICAgTnVtYmVyIG9mIFRE
WCBwcml2YXRlIEtleUlEcy4NCj4gPiArICAgICAgICAqLw0KPiA+ICsgICAgICAgcmV0ID0gcmRt
c3Jfc2FmZShNU1JfSUEzMl9NS1RNRV9LRVlJRF9QQVJUSVRJT05JTkcsICZucl9ta3RtZV9rZXlp
ZHMsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgJm5yX3RkeF9rZXlpZHMpOw0KPiA+ICsg
ICAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+ID4g
Kw0KPiA+ICsgICAgICAgaWYgKCFucl90ZHhfa2V5aWRzKQ0KPiA+ICsgICAgICAgICAgICAgICBy
ZXR1cm4gLUVOT0RFVjsNCj4gPiArDQo+ID4gKyAgICAgICAvKiBURFggS2V5SURzIHN0YXJ0IGFm
dGVyIHRoZSBsYXN0IE1LVE1FIEtleUlELiAqLw0KPiA+ICsgICAgICAgdGR4X2tleWlkX3N0YXJ0
Kys7DQo+IA0KPiB0ZHhfa2V5aWRfc3RhcnQgaXMgdW5pbmlpdGFsaXplZCBoZXJlLiAgU28sIGl0
J2QgYmUgMCwgdGhlbiArKydkLg0KPiANCj4gS2FpLCBwbGVhc2UgdGFrZSBhIG1vbWVudCBhbmQg
c2xvdyBkb3duLiAgVGhpcyBpc24ndCBhIHJhY2UuICBJIG9mZmVyZWQNCj4gc29tZSByZXBsYWNl
bWVudCBjb2RlIGhlcmUsIHdoaWNoIHlvdSd2ZSBkaXNjYXJkZWQsIG1pc3NlZCBvciBpZ25vcmVk
DQo+IGFuZCBpbiB0aGUgcHJvY2VzcyBicm9rZW4gdGhpcyBjb2RlLg0KPiANCj4gVGhpcyBhcHBy
b2FjaCBqdXN0IHdhc3RlcyByZXZpZXdlciB0aW1lLiAgSXQncyBub3Qgd29ya2luZyBmb3IgbWUu
DQoNCkFwb2xvZ3kuICBJIG1pc3NlZCBpdCB0aGlzIHRpbWUuDQoNCj4gDQo+IEknbSBnb2luZyB0
byBtYWtlIGEgc3VnZ2VzdGlvbiAoYWthLiBhIGRlbWFuZCk6IFlvdSBjYW4gcG9zdCB0aGVzZQ0K
PiBwYXRjaGVzIGF0IG1vc3Qgb25jZSBhIHdlZWsuICBZb3UgZ2V0IGEgd2hvbGUgd2VlayB0byAo
Y2FyZWZ1bGx5KQ0KPiBpbmNvcnBvcmF0ZSByZXZpZXdlciBmZWVkYmFjaywgbWFrZSB0aGUgcGF0
Y2ggYmV0dGVyLCBhbmQgcG9zdCBhIG5ldw0KPiB2ZXJzaW9uLiAgTmVlZCBtb3JlIHRpbWU/ICBH
byBhaGVhZCBhbmQgdGFrZSBpdC4gIFRha2UgYXMgbXVjaCB0aW1lIGFzDQo+IHlvdSB3YW50Lg0K
PiANCg0KWWVzIHdpbGwgZm9sbG93Lg0KDQo=
