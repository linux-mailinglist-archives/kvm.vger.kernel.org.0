Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8129C618B21
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 23:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiKCWIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 18:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiKCWIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 18:08:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0345E21E36;
        Thu,  3 Nov 2022 15:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667513290; x=1699049290;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RWaLlH5avmWT/fpceuy+lSbTUfim1HsLfoS/an8vFLs=;
  b=GtPHeOS7g6pxVP5Xm9FzVxzXDONUzIsP47HxIGbRxzlDyZvPZzKNwY8u
   Q5p27bt4Kd27fZfJCxNXqrOgdufuK7FcRzW1IbBRJQTD/NqmOctP/HTf6
   ipFMsB0aAOM4gTT3v30kA2aidR5Rlz8n1ZpcGchwkyUhjaXrcT0jZHYme
   znpTcCH+li6weI5ULjt8YKMQGSx1pmepAJzm/XQRRyr5/PXWI878u77N4
   9mIHnwFQMQjFf7/ApyCOJsBOumzPDGzVnuP8tMVG2NAXgDMpmZenndWOv
   JmS9jtnYWksNCUzsRHhUhNBiOZTwd17wd+nVTSSHsHfjbBwke+pmQ8W5j
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="309810743"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="309810743"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 15:08:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="724110507"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="724110507"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Nov 2022 15:08:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 15:07:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 15:07:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 15:07:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 15:07:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUAACLKhSUA3j2Or3MumlbQJILlXH6CQWlYzA44ZUnOH4zVK1DAAw8J209dXv3hrz++T/fXMetVfcxvf0GG1/j9pgrmyAg0u0tZIbvr0clI4t7qbnqv2+yiJxA6hgJy6AzdrwtZ7depqXVwGLRnrGKqtVLc8jyAMCymaKUF6w3t2FpQdI210e4ReYbbYtPL3KMHgcB8YO+5hCp0nRSXLgRv/KpP65tT7qBJGce4locgqZi9lS4kp9vrV5R9SpcOam5RJsaxl0siRkR9zvVrv3YKxDKqxWWn3XjJxCT49NzuTV5M3e19UEe1221gGVroN8yoIB5A7GFqHv+cWqoJ4PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWaLlH5avmWT/fpceuy+lSbTUfim1HsLfoS/an8vFLs=;
 b=NJZujUibupRW/6E1lTruHy54MlOOom59razzlcWgONsuN1cc2z7w1J+Ek2jkzmcd5+bek/ihhOWyiMQpSQHrCZ15cdFGmbiMxlfskqUZnXuk4Y/tNjBIRDEYlID2J4aem/bS13aqeeT96l97y3AJX5oS34bxRNWQKUV98JFpWNb2k3XNfDlPbliiNLpNtMutrLI8W1ltrFsembw0D1yndkKh3stYGdwVmLpY0woz2hgcPWk9ZhxAukiwJRcYDt5FrQ5TVrUfs74PHguMSQTXTRY4NHR14ZCSOwi6jm6SNJQEDd+mY2VJh9XqDGdOdDigNzuy22Z1H/kNbfSlFu4XyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6199.namprd11.prod.outlook.com (2603:10b6:8:99::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.19; Thu, 3 Nov 2022 22:07:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 22:07:48 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
CC:     "Luck, Tony" <tony.luck@intel.com>,
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
Subject: Re: [PATCH v6 12/21] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v6 12/21] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHY6Y2jpLGj6H1IZ0qLOAaWltkKyK4iXzmAgAr5BQCAAHYOAA==
Date:   Thu, 3 Nov 2022 22:07:48 +0000
Message-ID: <38f7e6d1c56c75dff286cf80acdd15b4869be2fd.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <fe0e1a1133166ca4008840cd1a5959fa70632f07.1666824663.git.kai.huang@intel.com>
         <f6d0b10a-94be-ff33-9742-058469078380@linux.intel.com>
         <ded3e60e-035f-1feb-bb7d-43af0064c544@intel.com>
In-Reply-To: <ded3e60e-035f-1feb-bb7d-43af0064c544@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6199:EE_
x-ms-office365-filtering-correlation-id: 7ee0a848-6494-4781-9d89-08dabde7d7d1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: keWu1a02eA/6JfrkQ58bJaKoynxYrudvjmWws/1CUcWKP5v3+HwcDj55gFuf8+Q8xsScMOZM6de0j8WAVoJ8doc+JqmmbpLUGFgIiItRGqIgz9P+LmoTFSbBNQchiCDbM0VjPZ4wwbFGMVYWKBzW4FMCU4/nvf1o2h8sn8WbMlcILROPArmNASJNujkrVG5HzFht3zQ/tksH/OsE5QApOMTuGEst/DhRd73DaErSkbBS5GpvyInFV2hqhZCrYnrvBmeHOS2IkHYIPwrEjW0PPNGMmOG21s28uvhCtyhDZn61TJisHLSQQl30cKml4kyJaAG5HIx/Yzp4pR6EUGf2PnFwrS9lYeGCKoQX0odWMEtutj3YQdOnFsKf5MwcfwCxF/ZsdZuf2VPcjmh84elJGK1oUOCCBSQMWo/p2rKiherlmJ6mc4J35YMLc4U1RciP07Xtyuz/cftJ1glN9UwL83Ok65BUuKHpI1hOztWetKEv0Upiyt2olQ3oGBV62AWoRa9/DX0Mt9d45a+bcPTA3VHsDExIeScLv9fQPeHcf1P9934NYzbrlK5S48F3HOGQQpB5CAU/FV0jkxOIYfbkQfMo/Tt2HK+eWjwU+25Ohzf7NOGvO2LXVq/MPTiRmetimvt4jQxTm4WWfUvzC4XG9jFP7vuk502dpnMf/NK1HYPoa8jUiEAoW+uAL6ABusMYpKg43tW+TZPMZBDx2Q6xPqjcA0Mh7b4gt8h4KqCaBynAczRZzloCibPjd9515FOV2hXfwH16T93SifRxdWoutQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199015)(83380400001)(6506007)(6486002)(2906002)(71200400001)(4744005)(36756003)(122000001)(38070700005)(86362001)(7416002)(5660300002)(82960400001)(91956017)(6512007)(186003)(38100700002)(316002)(26005)(2616005)(8676002)(66446008)(64756008)(110136005)(76116006)(66556008)(54906003)(41300700001)(478600001)(8936002)(66946007)(66476007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REEwb2FEOSt1NDVDUHkzT0dkeWt2Yjh0UTJSN25BbjJ6azRwT2l3TzNTVFJ3?=
 =?utf-8?B?SDR2QndjcVhBandHczMvdEgyZEtCdGVhL1l3LzJFOW1FYUJLWGhIVExybUpU?=
 =?utf-8?B?V09iVlh5SlprZGoyeGtzWlZNYmcvOTRWSWYrbmpPQmUzMlYxZVdxSVhJcHVN?=
 =?utf-8?B?TUtJVm40cExQd0ZkcGc4T21DTXQwUXhzY0lRaGkzWmtRZlRmd2ZmcjBScU0w?=
 =?utf-8?B?VS9hR0JPdEs0VENWMmYwMTVEc1JveEVlZmoyZS9IT1ord0w4dFdFcmtYNTQ2?=
 =?utf-8?B?SHpFR3kvVjRVaEVTWllwVUpzckpMYTZKamgwVXJVSVlCbEdaR1VBaVZLRzhp?=
 =?utf-8?B?eW9MYjdza1laMXRxR1FFRnNVaDQvUDhnYkV3ditUc3Z1cnExQjhjZDIrdzJR?=
 =?utf-8?B?aVpRZlQvUDNlM2JJQjM5RnNSUlpHTGlnYW1sYzJrdmN1OHRVSFk0cThhcnA5?=
 =?utf-8?B?cUZHT1pHVGFRVnBRK2JxUzA2UUlPenh1M2dmSkRsazZsN2ozMXUyTXdoSDZv?=
 =?utf-8?B?WGFOTnN6ZzhOYjd5TlR6VkxkV0k1WFE0dkI2VjFQRE9DTktPc3BXNXZyM0E4?=
 =?utf-8?B?eVhod0RyaUhkbzJGTEwrTThDeE9ld1FYSjlSeXhMbktRQWJaVEpoc0FaeTlZ?=
 =?utf-8?B?RFRqeFhRbWhub1ZpcVZxcEhlNmtwcE80K1AzL2dQa0Y0QXJlTEZqeis4S1Zv?=
 =?utf-8?B?ODkxUUUrNStpS042YzBxY0Y0em1lWjVaeWxVWnI0K1pKNlAycUhodjBFR1lU?=
 =?utf-8?B?ZXRjRXhJeXg1eU00OGZocitGeWFzZEx2cERuQ0hXL1pHODlmRkVsbXJoWEMw?=
 =?utf-8?B?VkFpdzJJaHNHMW00TStINXBHUG1PZ0xxSCs5b1VaRWcreStZUkVnOVF3Y1dG?=
 =?utf-8?B?UkNuRmw1S21wK2dxT2lQT3V2M0NIclU3WmhrVVNtQXZYUzFHbXpXeEJjMy8y?=
 =?utf-8?B?RHhPRzJadTNSd1B5QWxoaC9zOGE5SjQwN2c0bmRaT1hmOVVLV0sxNC9DRjhm?=
 =?utf-8?B?Ry9lVWhMZmsyc29xVmJ1WkVRdW9mTW9QS2tYQWlJL01YKzQvKy9Oa1lWL0RL?=
 =?utf-8?B?R3U2VWNVRW4wUlpCZWdvT0tRWGI1a2k3Wkp1ekpxdEFSc3g4Qk4zKzJJRFJD?=
 =?utf-8?B?cGk1dGI2NTZJdlQzbUFoQU9TU3EzSWZySFYvQk1OMjBKbWVVYlBYTVR5NjVS?=
 =?utf-8?B?eWk1b1htUk5nMkUybUtUa2lETW5kckt0OUdOOTNJOUF4YjJJVUFCdXg3REFr?=
 =?utf-8?B?dnNXTEJDSzhwSlZzNTFiMmpkRWFTL3N0N3F0bXlpSjFaZmhGbjJIazFteTFW?=
 =?utf-8?B?Y2tkSitmaUhxdUxYeTQxc2grbmttVGhmdWFKcEtiVitjMk5IYVdRZ2NTaU1l?=
 =?utf-8?B?OXQ2L2NOMWh1REpHYlNqUGpGQzZLTFpJdjh6VnpsVHl2VCtuMmhCbW9WdVFG?=
 =?utf-8?B?SHZqRmZQT1oxWVZ4aWhzU0tKY3lwR05NWW81c2Y5RUxjZWlLUWxjTGk1V2Rt?=
 =?utf-8?B?c2NZYi9udnhPU3p3WERialRmeFNhaVM4akl1SmpUczUzL2c2dmJTMzdJaDNE?=
 =?utf-8?B?U1VHYUw5Z0VRNHI3SHJLKzFvOWxuL0syK20rVVMvQWtlT3RPTFpzRnNsRXYr?=
 =?utf-8?B?aUc3a1AvRnJ3bnAvL04wSHdUVjZ1dm8xVXNEQWlGbzZQSVhGM3hjMTlHQUpB?=
 =?utf-8?B?NHZ6VzE3OXlTeHUvM0pGWU9MdzBDL0xWTm5YeEh2dmMxeDlSWENwc1UwcUpE?=
 =?utf-8?B?MTlRY3MwKzN1cWNnTFNRN1hncFh2dU5RWUtqbzQvTmJuL2pyU0h0YXZqa0dR?=
 =?utf-8?B?OTlObUNwWEU3S1VyaHRweUJSSlN5eS9lUkI2NjVKZTEwb2JhdVZxRC8xUEsy?=
 =?utf-8?B?RzFwMlVnOUo0N0xhOUZnNlBjUUFsTGhBc3lqOWhLclVQb1htYytoTlJtN3A0?=
 =?utf-8?B?MWo3ZmxUUHZzbmhpb1lPYTNDeXVDMzZmTEJqSE1SWDBGV2xEMkVZTWlkYlFJ?=
 =?utf-8?B?NjFaUUpGVU1wOXkrZnVwWWFYZW94b3AxeE03SC9KVk1pVlFZS1VyUkV5K3pr?=
 =?utf-8?B?alo3VHpiZlZ5VlFLaUNSRFpLUlRQbFc0SWtYQVNQVVkxYUJiUlJHNjBtWjd1?=
 =?utf-8?B?eksvME5RTEV4YyttSWtJbWhHT2FVaU9nM3pKSWlqdGxQbzdZbGU5ZzFPTUEw?=
 =?utf-8?B?ckE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95F945526360CD4C8B335B217757D6F4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee0a848-6494-4781-9d89-08dabde7d7d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 22:07:48.1967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bW51MZps2uOjN7j66okGSI64GYS1vZZD5HD9hc3lsX1uIG+jlnYKfxLhQLaHv9/DvXSjdo6ddJ1Z48OrSqUs1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6199
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTAzIGF0IDA4OjA1IC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IFBsdXMsIG1heF9yZXNlcnZlZF9wZXJfdGRtciBpcyBiYXJlbHkgaW4gZG91YmxlIGRpZ2l0cyB0
b2RheS7CoCBJdCdzIGENCj4gKkxPT09PT09PT09ORyogd2F5IGZyb20gZWl0aGVyIG9mIHRob3Nl
IGxpbWl0cy7CoCBJZiB5b3Ugd2FudCB0byBhZGQgYQ0KPiB3YXJuaW5nIGhlcmUsIHRoZW4gZ28g
Zm9yIGl0IGFuZCBlbmZvcmNlIGEgc2FuZSB2YWx1ZSBvbg0KPiBtYXhfcmVzZXJ2ZWRfcGVyX3Rk
bXIuDQoNCkhpIERhdmUsDQoNClRoYW5rcy4gQnkgImVuZm9yY2UgYSBzYW5lIHZhbHVlIG9uIG1h
eF9yZXNlcnZlZF9wZXJfdGRtcicgY291bGQgeW91IGJlIG1vcmUNCnNwZWNpZmljPyBEaWQgeW91
IG1lYW4gaWYgd2UgZmluZCBpdHMgdmFsdWUgaXMgaW5zYW5lbHkgYmlnLCB3ZSBjYW4gY2hhbmdl
IGl0IHRvDQphIHJlYXNvbmFibGUgc21hbGxlciB2YWx1ZT8NCg0KQnV0IEkgZG9uJ3QgdGhpbmsg
d2UgY2FuIGFzIHRoZSBURE1SX0lORk8gaXMgdXNlZCBieSB0aGUgVERYIG1vZHVsZSwgc28gcmVk
dWNpbmcNCm1heF9yZXNlcnZlZF9wZXJfdGRtciBieSB0aGUga2VybmVsIGRvZXNuJ3QgYWN0dWFs
bHkgd29yaz8NCg0KUGVyaGFwcyBmb3Igbm93IHdlIGNhbiBtYWtlIHRoZSBrZXJuZWwgdG8gYXNz
dW1lIFRETVJfSU5GTyB3b24ndCBleGNlZWQgYQ0KcmVhc29uYWJsZSB2YWx1ZSAoaS5lLiA0Sy84
Sy8xNks/KSBhbmQgbWF4X3RkbXJzICh3aGljaCBpcyA2NCBjdXJyZW50bHkpIHdvbid0DQpleGNl
ZWQgYSByZWFzb25hYmxlIHZhbHVlIGVpdGhlciAoaS5lLiAxSy81MTIvMjU2PyksIHNvIHRoYXQg
d2UgY2FuIGp1c3QgdXNlDQphbGxvY19wYWdlc19leGFjdCgpIHRvIGFsbG9jYXRlICB0aGUgZW50
aXJlIFRETVIgYXJyYXk/IElmIGtlcm5lbCBmb3VuZCBlaXRoZXINCmlzIHRvbyBiaWcsIHRoZW4g
a2VybmVsIGNvdWxkIGp1c3QgZmFpbCB0byBpbml0aWFsaXplIHRoZSBURFggbW9kdWxlLg0K
