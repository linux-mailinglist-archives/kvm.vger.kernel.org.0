Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6155C635AB8
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 11:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbiKWKz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 05:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237038AbiKWKy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 05:54:59 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9C012522F;
        Wed, 23 Nov 2022 02:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669200228; x=1700736228;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HQBklD+VXE7TlWCsRGPWGxSkY3gLNTQ2WfcK+6p/tTY=;
  b=hmIcZH7dkWw+42zJKF4Dh8rhstyvLncRkjSt0UZkK2azGZQ+m8bxiuGE
   nhONb3Kr7sERd/slliOm5nhQXdhBF21oWtL+DTH0h310xCPcpyuWM8vi3
   hWa1sFqSkzV1H1A/3lKRwLMF3VSMXmISQ4/K5a4V3N7jwbVwShfWS6+oG
   TTc/XzGL8c941LGZM5MsH9GoCVCHprHU51rPDnn7q/fdAAwayneuAa8YC
   o3WOlIx9QwHQlA2DagjyW0Fzzvugz75VyIF4c3FvuAiu0x2pVTCZKjHMx
   caqlzBTo3ExLaZ+5axDvMnxT1Puc1qlpbLIUsTc3KmPM+v5YPCw49DprY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="312738170"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="312738170"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 02:43:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="619572840"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619572840"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 23 Nov 2022 02:43:48 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 02:43:47 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 02:43:47 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 02:43:47 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 02:43:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDOozksPI2xKYBxHdeDIn9gJJqNf8MBEdoRkILYhGBgcjoccLcxTumZ1PaajoZmpC5uttQBKV3wrX6ekL/3cE4hOBq5QogSem5HMy+fjgE9bFqKOUt5Zs/FVyj/n2k5j5wFeRq1cyIEiH5I12dflxQjamkqjRJ7ASqDFNshs35nsASVeoXfGioa11LMx3pC+nWV9c/1J8XzeJENGpKsqUpJRTC7GV6Ok0IIyELF3SoSfQr5/FojxqMBuZuVSFG1wHmrWHLUeGQBU9daWUmgoKKvNv6fToNmsdGbui/pKQWeWUQX9UW7i50uOsvnWWhg0D9sQTHVQVB67egALhxyAEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQBklD+VXE7TlWCsRGPWGxSkY3gLNTQ2WfcK+6p/tTY=;
 b=EcuSHbSY93hK8TeCm/7Zdk4nfpuwxlWb6GWjcRDjNX74wXHQRMNRmQxRrAMq+UHeIgxCwBaq4GR62hsVMBL99D1Zm6/2LUXDWPuDvARNQFFleviaj35vuhwckchYHoT5Z019uXMa9H0ozO6DQm35rsy3Vd0jmwwhMiaHnIE57b8PW/W5hV3JZfFmUx7Uxo4pQ+UCeUAx6PCUc4grwj7JIRdK6E7XmFrGDtEfymJb/AQAfkogO7j2TgIY9kbnOPPOBUGTeVM5EttJrS9AqgIsjjKKhXCreRPf5tanPaFFUj+rXOcd3lWuavMGpZm8YmttCZK0AlrCYT6OXFxJfVIIRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6293.namprd11.prod.outlook.com (2603:10b6:8:97::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Wed, 23 Nov
 2022 10:43:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 10:43:39 +0000
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 05/20] x86/virt/tdx: Implement functions to make
 SEAMCALL
Thread-Topic: [PATCH v7 05/20] x86/virt/tdx: Implement functions to make
 SEAMCALL
Thread-Index: AQHY/T3A+/0sXXuTQkqld4kSQb8mzK5LQ7sAgAESqgA=
Date:   Wed, 23 Nov 2022 10:43:39 +0000
Message-ID: <0bbeb95691cbda6ac9fef0ec0f3dd0b4f7b00d2b.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <5977ec3c2e682e6927ce1c33e7fcac7fcfe2d346.1668988357.git.kai.huang@intel.com>
         <c551c360-4924-c42e-d4d9-b56ad6d6e2fd@intel.com>
In-Reply-To: <c551c360-4924-c42e-d4d9-b56ad6d6e2fd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6293:EE_
x-ms-office365-filtering-correlation-id: 17ea9a0f-2f34-4531-d0fa-08dacd3f94ec
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kJHwzYQfMlHoe0ItENATGP5TDL5mH56SQ4oIAXYxsSeRvSQfCIBqxd3tw95Xd9y8aDjIDEIJgTai5WDfZdqDdgFOus/WR1aMmGLV0X3m4f9M01L0xMz10MkrqY6yAcW1C8gi62EfjeZ7yjSdMURHCLNLrSzrwO4MNWbPXE8vhfSKzVKj/gVo0Y40vuw8OcYtFVW7cL0WrV2fwTPkukCAHjzPRcCGQi07EqRxteoxNgCQLsB1mKP7yl4Vhp1ZdQtzfjOPfpHnzhWyKlcO0Vcfu4EbVj8IovxWaBhx/w6H5wf00OaVKI1pVQH7fO3WjZyJQa8otSTKgswIeBveo7fTK7OWqErnsT2AE7JbTnpR86N+1B5bPsykh7fMvHK/grbTuMBFbQAmbsDGk4GudUIBTG2O9iabnwjEdsjInxPREFYy34LKXSWbtLjbDJuuMkrY+eE7YhFlpB6l2ZWFkJyqMwxPMaFty+gs1GbQHIgSBsRSGs607qsbP4+Hgn3u5Ayft/UBXMenqFTTN5EWahtmylBpGyh6XweyezoQMKPbfUbppxJc4ir9evEitDXt1P5hBYYI0JjhbnTpwNIZ3BYAAC30M2H3dkdyOaJJ/aGndcdWu2n9UQRr9Vaa2tOlbgqHh+5rI6gperuzPQ19lIu3kGkI5XlrEeGal1hNRHgC4E/uQWsc4vPcVIpUokOUmvJCilqJxZ4mXLteZijDxeg/rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199015)(4001150100001)(6486002)(38070700005)(41300700001)(478600001)(83380400001)(2906002)(186003)(71200400001)(53546011)(8936002)(36756003)(66946007)(5660300002)(82960400001)(110136005)(54906003)(2616005)(6506007)(86362001)(38100700002)(316002)(7416002)(8676002)(26005)(4326008)(76116006)(66476007)(66556008)(64756008)(122000001)(91956017)(6512007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zjd0Y09yNEtQbzV3OHNZVVZlWTVoUThXdm5EUjlGaGQwQnZBWHZtcEtXTHZM?=
 =?utf-8?B?SW5SSFlvUkd1SFJOMDM2TkxUUys2M2p1SVh0NXlRNGJmV1RsNXJRdEtDNHkz?=
 =?utf-8?B?a1ViZWVFc1dMVk9aUGlpNVcrQlVyYm5DbnFLN0lBY2xqZmprS2N4QXNZTTIy?=
 =?utf-8?B?OFd2ck9WWW9uSjc4WUdGVC9VdTdneTRxRk12ZHVYelNrVU9qc1htVDVxajc1?=
 =?utf-8?B?b2F5aUpEeHgvdUJ3R1M4UHM5MXcrNkxEOXF6bGJmR2MzTGVHWDB5VGJWME5S?=
 =?utf-8?B?TDlORHNrY3N6R1lWcllzYVNrdG5Makl6eVUrbmo5OVRPSjd6d3Q4MS81ZC9N?=
 =?utf-8?B?ODdndU1hYUUvT1Z6eFUxY3ZCWWx2OHdtN0ZYL2d4QVE1Q2JWNy9TTmRZRkRq?=
 =?utf-8?B?c01XS3Y4ZnRyM20xODRlRVJlOTFSMUlGbUVoTUFiaFo4MGQ3eWljWmo5YmlE?=
 =?utf-8?B?SElZdU4yckN5NVhEZjZ1ZmN3L1VKMGs5OFBsYlFUby9iYUNhUjZ0enp0dkx6?=
 =?utf-8?B?cEpHTnMwYURScnlLS21MeS83Y1Z5cVNtS3VuelJNTHBiSHYrdDYxV0greGZz?=
 =?utf-8?B?Q0ZlN2VVdU92enhqb3lsaWxaN09HeFRnRTdDUTk2SjBwSS9YZ3lBc0ZMTWZX?=
 =?utf-8?B?ZGpBSU1NeXJwZ2MxNE5yaGliQklwdUF4SEFzZENGemQ2OSsvNFZpZ2lDZ3VX?=
 =?utf-8?B?ZUdUVmdXTkhqT2pNMCt5cU50SUVpQWhkMnIwSmFhdFA4L1BqMFI4TGVSNHpJ?=
 =?utf-8?B?ZDJFNWIySTlxY2xCREZsR2J3WEZYLzJJTjVvQmRwcjlZaVpnRklpR2c1ZzZ4?=
 =?utf-8?B?WHc2TTdOc1l1NTY1VzZTbkZPUEtSeXpDRG1nS1gvMENKbjJuT3Z3a05CcDVj?=
 =?utf-8?B?Ynh5MGl1cEVMeWlObnROcW9SVU1Sa3R5ajBFLytkNWVVMCtHQmQ4L09GUndt?=
 =?utf-8?B?VVYxcndFNGhaWUwxYUpZcUZTbTIzWFltMFl6dFhIc2NqR2xlZllJSFJJR016?=
 =?utf-8?B?TGMySjYrbWxrQk5MelV4Ry84UEhFK20xd1hwL29vZGFXSHJOcS8rS0x5WFQ2?=
 =?utf-8?B?N1huWFdnTUovUWp5bHB4elRNbTdwMUFvdmQ1dnY4dS9XMzJ5TWFrcG01R1Fj?=
 =?utf-8?B?bDYwNjFodVhFNFpxZmdPeTN6dGFpNUdUenYvb0ZPeGg2c1puTTRiSmIwTjVI?=
 =?utf-8?B?czBtakorQ0RhNFVZSldlRElvcDJvZWNUS1A1ejFkMUlCM0VyTWIwcFd4SVVm?=
 =?utf-8?B?THZNL2JDYndlelNJYzl3TjFraEY3K1RPL0NrbXEvYlF0aTdCL3JTek5LazZ4?=
 =?utf-8?B?OUJrd1UrMmNQVnZ4d09QTmpxb0dHSC8zZTV3MUJyTHArYkNxcnYyYlExYVdW?=
 =?utf-8?B?NzR5d01nK2JpckpyeWFuYWIybThaYWVlbmxxOEkzYW5uQnZHZnBhS055N2Fu?=
 =?utf-8?B?ZFQvWFIzVHcrQWJHakZxVGFNa2x6UzlnTWdUcFdFdDE2eDFWR2ZCVkt2QVYy?=
 =?utf-8?B?VDkrckpkMW84bktOV2tHdmpmYUdUSHlZdmFjKy9VaHJOWFkrWVluWDhDd1Bs?=
 =?utf-8?B?NG5Rcmh3Sllva3ppN2kvZzQxcElsVTdXWEVSQXFQZDNqVHBJNHRydzJFOGFH?=
 =?utf-8?B?bU9GcXNsdVJJTThwVjBVekhqN3RpUGVMcWhXdmNLL2p3ZWJvZ3dvUFRoc1Ur?=
 =?utf-8?B?bG83OXZtK0paemdiVlU2K0R5bGQ3OFpzdmt0dkV0eUhBTDVKcFZtRFJJbmRQ?=
 =?utf-8?B?ejBPdUY4TkRDSWFISVhUOHdzNGtnNzRucG55eGZZa2xrd21MNy9PczA4Tmtw?=
 =?utf-8?B?SW9XWkJ0R0wwSVpJbnVBblY3WGJ6SHA4YXd5b0QxTTdzejJUZWkvZnhtQ2Yz?=
 =?utf-8?B?TUt1RTBCdGlrcjJrWCtpUXpjUEhhSFZNdms0NzFKM25naG5ETk8rUmgzMFQ5?=
 =?utf-8?B?K3Z0NUMrWXRyU25aM0NubVVJQjk4Ryt3RTNRbWVkaGhyZTFRa3liYkhPYXcr?=
 =?utf-8?B?dlVEZ3FRMWg0dmpRMEsyNjA1eFRGc0VSMlBJNlQ3MUUyM2w5THlMUFd1SXl3?=
 =?utf-8?B?NndwYW5jaUJsMTZoYi9oVjVIb2QyRXZrMG5PdHl5RFhnVEsydlRab0gwVzMr?=
 =?utf-8?B?NGt6eGdDdjRuMUtkZmhZKzEvMERYcVU3TC9NSFNHMmo0dTFjd01TTFdaZENw?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A93ECF876A8A741A0ADC19CCEB8B34A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ea9a0f-2f34-4531-d0fa-08dacd3f94ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 10:43:39.0902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x50c7tNc23DlMd5ep9DsTcK33uVtJwb6ERvyV0vPDboZWJpKNF7NNDCau5Zj1zijzUgVKnrrItYZeDF81ZmxVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6293
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDEwOjIwIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjAvMjIgMTY6MjYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBURFggaW50cm9kdWNlcyBh
IG5ldyBDUFUgbW9kZTogU2VjdXJlIEFyYml0cmF0aW9uIE1vZGUgKFNFQU0pLiAgVGhpcw0KPiA+
IG1vZGUgcnVucyBvbmx5IHRoZSBURFggbW9kdWxlIGl0c2VsZiBvciBvdGhlciBjb2RlIHRvIGxv
YWQgdGhlIFREWA0KPiA+IG1vZHVsZS4NCj4gPiANCj4gPiBUaGUgaG9zdCBrZXJuZWwgY29tbXVu
aWNhdGVzIHdpdGggU0VBTSBzb2Z0d2FyZSB2aWEgYSBuZXcgU0VBTUNBTEwNCj4gPiBpbnN0cnVj
dGlvbi4gIFRoaXMgaXMgY29uY2VwdHVhbGx5IHNpbWlsYXIgdG8gYSBndWVzdC0+aG9zdCBoeXBl
cmNhbGwsDQo+ID4gZXhjZXB0IGl0IGlzIG1hZGUgZnJvbSB0aGUgaG9zdCB0byBTRUFNIHNvZnR3
YXJlIGluc3RlYWQuDQo+ID4gDQo+ID4gVGhlIFREWCBtb2R1bGUgZGVmaW5lcyBhIHNldCBvZiBT
RUFNQ0FMTCBsZWFmIGZ1bmN0aW9ucyB0byBhbGxvdyB0aGUNCj4gPiBob3N0IHRvIGluaXRpYWxp
emUgaXQsIGFuZCB0byBjcmVhdGUgYW5kIHJ1biBwcm90ZWN0ZWQgVk1zLiAgU0VBTUNBTEwNCj4g
PiBsZWFmIGZ1bmN0aW9ucyB1c2UgYW4gQUJJIGRpZmZlcmVudCBmcm9tIHRoZSB4ODYtNjQgc3lz
dGVtLXYgQUJJLg0KPiA+IEluc3RlYWQsIHRoZXkgc2hhcmUgdGhlIHNhbWUgQUJJIHdpdGggdGhl
IFREQ0FMTCBsZWFmIGZ1bmN0aW9ucy4NCj4gDQo+IEkgbWF5IGhhdmUgc3VnZ2VzdGVkIHRoaXMg
YWxvbmcgdGhlIHdheSwgYnV0IHRoZSBtZW50aW9uIG9mIHRoZSBzeXN2IEFCSQ0KPiBpcyBqdXN0
IGNvbmZ1c2luZyBoZXJlLiAgVGhpcyBpcyBlbm91Z2ggZm9yIGEgY2hhbmdlbG9nOg0KPiANCj4g
CVRoZSBURFggbW9kdWxlIGVzdGFibGlzaGVzIGEgbmV3IFNFQU1DQUxMIEFCSSB3aGljaCBhbGxv
d3MgdGhlDQo+IAlob3N0IHRvIGluaXRpYWxpemUgdGhlIG1vZHVsZSBhbmQgdG8gYW5kIHRvIG1h
bmFnZSBWTXMuDQo+IA0KPiBLaWxsIHRoZSByZXN0Lg0KDQpUaGFua3Mgd2lsbCBkby4NCg0KPiAN
Cj4gPiBJbXBsZW1lbnQgYSBmdW5jdGlvbiBfX3NlYW1jYWxsKCkgdG8gYWxsb3cgdGhlIGhvc3Qg
dG8gbWFrZSBTRUFNQ0FMTA0KPiA+IHRvIFNFQU0gc29mdHdhcmUgdXNpbmcgdGhlIFREWF9NT0RV
TEVfQ0FMTCBtYWNybyB3aGljaCBpcyB0aGUgY29tbW9uDQo+ID4gYXNzZW1ibHkgZm9yIGJvdGgg
U0VBTUNBTEwgYW5kIFREQ0FMTC4NCj4gDQo+IEluIGdlbmVyYWwsIEkgZGlzbGlrZSBtZW50aW9u
aW5nIGZ1bmN0aW9uIG5hbWVzIGluIGNoYW5nZWxvZ3MuICBLZWVwDQo+IHRoaXMgaGlnaC1sZXZl
bCwgbGlrZToNCj4gDQo+IAlBZGQgaW5mcmFzdHJ1Y3R1cmUgdG8gbWFrZSBTRUFNQ0FMTHMuICBU
aGUgU0VBTUNBTEwgQUJJIGlzIHZlcnkNCj4gCXNpbWlsYXIgdG8gdGhlIFREQ0FMTCBBQkkgYW5k
IGxldmVyYWdlcyBtdWNoIFREQ0FMTA0KPiAJaW5mcmFzdHJ1Y3R1cmUuDQoNCldpbGwgZG8uDQoN
Cj4gDQo+ID4gU0VBTUNBTEwgaW5zdHJ1Y3Rpb24gY2F1c2VzICNHUCB3aGVuIFNFQU1SUiBpc24n
dCBlbmFibGVkLCBhbmQgI1VEIHdoZW4NCj4gPiBDUFUgaXMgbm90IGluIFZNWCBvcGVyYXRpb24u
ICBUaGUgY3VycmVudCBURFhfTU9EVUxFX0NBTEwgbWFjcm8gZG9lc24ndA0KPiA+IGhhbmRsZSBh
bnkgb2YgdGhlbS4gIFRoZXJlJ3Mgbm8gd2F5IHRvIGNoZWNrIHdoZXRoZXIgdGhlIENQVSBpcyBp
biBWTVgNCj4gPiBvcGVyYXRpb24gb3Igbm90Lg0KPiANCj4gV2hhdCBpcyBTRUFNUlI/DQoNClNv
cnJ5IGl0IGlzIGEgbGVmdG92ZXIuICBTaG91bGQgYmUgIndoZW4gVERYIGlzbid0IGVuYWJsZWQi
Lg0KDQo+IA0KPiBXaHkgZXZlbiBtZW50aW9uIHRoaXMgYmVoYXZpb3IgaW4gdGhlIGNoYW5nZWxv
Zy4gIElzIHRoaXMgYSBwcm9ibGVtPw0KPiBEb2VzIGl0IGhhdmUgYSBzb2x1dGlvbj8NCg0KTXkg
aW50ZW50aW9uIHdhcyB0byBwcm92aWRlIHNvbWUgYmFja2dyb3VuZCBpbmZvcm1hdGlvbiB3aHkg
dG8gZXh0ZW5kDQpURFhfTU9EVUxFX0NBTEwgbWFjcm8gdG8gaGFuZGxlICNVRCBhbmQgI0dQIGFz
IG1lbnRpb25lZCBiZWxvdy4NCg0KPiANCj4gPiBJbml0aWFsaXppbmcgdGhlIFREWCBtb2R1bGUg
aXMgZG9uZSBhdCBydW50aW1lIG9uIGRlbWFuZCwgYW5kIGl0IGRlcGVuZHMNCj4gPiBvbiB0aGUg
Y2FsbGVyIHRvIGVuc3VyZSBDUFUgaXMgaW4gVk1YIG9wZXJhdGlvbiBiZWZvcmUgbWFraW5nIFNF
QU1DQUxMLg0KPiA+IFRvIGF2b2lkIGdldHRpbmcgT29wcyB3aGVuIHRoZSBjYWxsZXIgbWlzdGFr
ZW5seSB0cmllcyB0byBpbml0aWFsaXplIHRoZQ0KPiA+IFREWCBtb2R1bGUgd2hlbiBDUFUgaXMg
bm90IGluIFZNWCBvcGVyYXRpb24sIGV4dGVuZCB0aGUgVERYX01PRFVMRV9DQUxMDQo+ID4gbWFj
cm8gdG8gaGFuZGxlICNVRCAoYW5kIGFsc28gI0dQLCB3aGljaCBjYW4gdGhlb3JldGljYWxseSBz
dGlsbCBoYXBwZW4NCj4gPiB3aGVuIFREWCBpc24ndCBhY3R1YWxseSBlbmFibGVkIGJ5IHRoZSBC
SU9TLCBpLmUuIGR1ZSB0byBCSU9TIGJ1ZykuDQo+IA0KPiBJJ20gbm90IGNvbXBsZXRlbHkgc3Vy
ZSB0aGlzIGlzIHdvcnRoIGl0LiAgSWYgdGhlIEJJT1MgbGllcywgd2Ugb29wcy4NCj4gVGhlcmUg
YXJlIGxvdHMgb2Ygd2F5cyB0aGF0IHRoZSBCSU9TIGx5aW5nIGNhbiBtYWtlIHRoZSBrZXJuZWwg
b29wcy4NCj4gV2hhdCdzIG9uZSBtb3JlPw0KDQpJIGFncmVlLiAgQnV0IGlmIHdlIHdhbnQgdG8g
aGFuZGxlICNVRCwgdGhlbiAjR1Agd29uJ3QgY2F1c2Ugb29wcyBhbnkgbW9yZSwgc28gSQ0KanVz
dCBhZGRlZCBlcnJvciBjb2RlIGZvciAjR1AgdG9vLg0KDQpPciBwZXJoYXBzIHdlIGNhbiBjaGFu
Z2UgdG8gYmVsb3c6ID8NCg0KIi4uLiBleHRlbmQgdGhlIFREWF9NT0RVTEVfQ0FMTCB0byBoYW5k
bGUgI1VEIChhbmQgb3Bwb3J0dW5pc3RpY2FsbHkgI0dQIHNpbmNlDQp0aGV5IHNoYXJlIHRoZSBz
YW1lIGFzc2VtYmx5KS4iDQoNCk9yIG90aGVyIHN1Z2dlc3Rpb25zPw0KDQo+IA0KPiA+IEludHJv
ZHVjZSB0d28gbmV3IFREWCBlcnJvciBjb2RlcyBmb3IgI1VEIGFuZCAjR1AgcmVzcGVjdGl2ZWx5
IHNvIHRoZQ0KPiA+IGNhbGxlciBjYW4gZGlzdGluZ3Vpc2guICBBbHNvLCBPcHBvcnR1bmlzdGlj
YWxseSBwdXQgdGhlIG5ldyBURFggZXJyb3INCj4gPiBjb2RlcyBhbmQgdGhlIGV4aXN0aW5nIFRE
WF9TRUFNQ0FMTF9WTUZBSUxJTlZBTElEIGludG8gSU5URUxfVERYX0hPU1QNCj4gPiBLY29uZmln
IG9wdGlvbiBhcyB0aGV5IGFyZSBvbmx5IHVzZWQgd2hlbiBpdCBpcyBvbi4NCj4gPiANCj4gPiBB
cyBfX3NlYW1jYWxsKCkgY2FuIHBvdGVudGlhbGx5IHJldHVybiBtdWx0aXBsZSBlcnJvciBjb2Rl
cywgYmVzaWRlcyB0aGUNCj4gPiBhY3R1YWwgU0VBTUNBTEwgbGVhZiBmdW5jdGlvbiByZXR1cm4g
Y29kZSwgYWxzbyBpbnRyb2R1Y2UgYSB3cmFwcGVyDQo+ID4gZnVuY3Rpb24gc2VhbWNhbGwoKSB0
byBjb252ZXJ0IHRoZSBfX3NlYW1jYWxsKCkgZXJyb3IgY29kZSB0byB0aGUga2VybmVsDQo+ID4g
ZXJyb3IgY29kZSwgc28gdGhlIGNhbGxlciBkb2Vzbid0IG5lZWQgdG8gZHVwbGljYXRlIHRoZSBj
b2RlIHRvIGNoZWNrDQo+ID4gcmV0dXJuIHZhbHVlIG9mIF9fc2VhbWNhbGwoKSBhbmQgcmV0dXJu
IGtlcm5lbCBlcnJvciBjb2RlIGFjY29yZGluZ2x5Lg0KPiANCj4gDQoNClsuLi5dDQoNCj4gPiAr
LyoNCj4gPiArICogV3JhcHBlciBvZiBfX3NlYW1jYWxsKCkgdG8gY29udmVydCBTRUFNQ0FMTCBs
ZWFmIGZ1bmN0aW9uIGVycm9yIGNvZGUNCj4gPiArICogdG8ga2VybmVsIGVycm9yIGNvZGUuICBA
c2VhbWNhbGxfcmV0IGFuZCBAb3V0IGNvbnRhaW4gdGhlIFNFQU1DQUxMDQo+ID4gKyAqIGxlYWYg
ZnVuY3Rpb24gcmV0dXJuIGNvZGUgYW5kIHRoZSBhZGRpdGlvbmFsIG91dHB1dCByZXNwZWN0aXZl
bHkgaWYNCj4gPiArICogbm90IE5VTEwuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW50IF9fYWx3
YXlzX3VudXNlZCBzZWFtY2FsbCh1NjQgZm4sIHU2NCByY3gsIHU2NCByZHgsIHU2NCByOCwgdTY0
IHI5LA0KPiA+ICsJCQkJICAgIHU2NCAqc2VhbWNhbGxfcmV0LA0KPiA+ICsJCQkJICAgIHN0cnVj
dCB0ZHhfbW9kdWxlX291dHB1dCAqb3V0KQ0KPiA+ICt7DQo+ID4gKwl1NjQgc3JldDsNCj4gPiAr
DQo+ID4gKwlzcmV0ID0gX19zZWFtY2FsbChmbiwgcmN4LCByZHgsIHI4LCByOSwgb3V0KTsNCj4g
PiArDQo+ID4gKwkvKiBTYXZlIFNFQU1DQUxMIHJldHVybiBjb2RlIGlmIGNhbGxlciB3YW50cyBp
dCAqLw0KPiA+ICsJaWYgKHNlYW1jYWxsX3JldCkNCj4gPiArCQkqc2VhbWNhbGxfcmV0ID0gc3Jl
dDsNCj4gPiArDQo+ID4gKwkvKiBTRUFNQ0FMTCB3YXMgc3VjY2Vzc2Z1bCAqLw0KPiA+ICsJaWYg
KCFzcmV0KQ0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsNCj4gPiArCXN3aXRjaCAoc3JldCkgew0K
PiA+ICsJY2FzZSBURFhfU0VBTUNBTExfR1A6DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBwbGF0Zm9y
bV90ZHhfZW5hYmxlZCgpIGlzIGNoZWNrZWQgdG8gYmUgdHJ1ZQ0KPiA+ICsJCSAqIGJlZm9yZSBt
YWtpbmcgYW55IFNFQU1DQUxMLg0KPiA+ICsJCSAqLw0KPiANCj4gVGhpcyBkb2Vzbid0IG1ha2Ug
YW55IHNlbnNlLiAgInBsYXRmb3JtX3RkeF9lbmFibGVkKCkgaXMgY2hlY2tlZCI/Pz8NCj4gDQo+
IERvIHlvdSBtZWFuIHRoYXQgaXQgKnNob3VsZCogYmUgY2hlY2tlZCBhbmQgcHJvYmFibHkgd2Fz
bid0IHdoaWNoIGlzDQo+IHdoYXQgY2F1c2VkIHRoZSBlcnJvcj8NCg0KSSBtZWFudCB0ZHhfZW5h
YmxlKCkgYWxyZWFkeSBjYWxscyBwbGF0Zm9ybV90ZHhfZW5hYmxlZCgpIHRvIGNoZWNrIHdoZXRo
ZXIgQklPUw0KaGFzIGVuYWJsZWQgVERYIGF0IHRoZSB2ZXJ5IGJlZ2lubmluZyBiZWZvcmUgbWFr
aW5nIGFueSBTRUFNQ0FMTCwgc28NCnRoZW9yZXRpY2FsbHkgI0dQIHNob3VsZCBub3QgaGFwcGVu
IHVubGVzcyB0aGVyZSdzIEJJT1MgYnVnLiAgSSB0aG91Z2h0IGEgV0FSTigpDQpjYW4gaGVscCB0
byBjYXRjaC4NCg0KPiANCj4gPiArCQlXQVJOX09OX09OQ0UoMSk7DQo+ID4gKwkJZmFsbHRocm91
Z2g7DQo+ID4gKwljYXNlIFREWF9TRUFNQ0FMTF9WTUZBSUxJTlZBTElEOg0KPiA+ICsJCS8qIFJl
dHVybiAtRU5PREVWIGlmIHRoZSBURFggbW9kdWxlIGlzIG5vdCBsb2FkZWQuICovDQo+ID4gKwkJ
cmV0dXJuIC1FTk9ERVY7DQo+IA0KPiBQcm8gdGlwOiB5b3UgZG9uJ3QgbmVlZCB0byByZXdyaXRl
IGNvZGUgaW4gY29tbWVudHMuICBJZiB0aGUgY29kZQ0KPiBsaXRlcmFsbHkgc2F5cywgInJldHVy
biAtRU5PREVWIiwgdGhlcmUgaXMgdmVyeSBsaXR0bGUgdmFsdWUgaW4gd3JpdGluZw0KPiB2aXJ0
dWFsbHkgaWRlbnRpY2FsIGJ5dGVzICJSZXR1cm4gLUVOT0RFViIgaW4gdGhlIGNvbW1lbnQuDQo+
IA0KDQpJbmRlZWQuICBUaGFua3MgZm9yIHRoZSB0aXAhICBJJ2xsIHVwZGF0ZSB0aG9zZSBjb21t
ZW50cy4NCg0K
