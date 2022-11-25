Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78C76381DB
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 01:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiKYAIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 19:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKYAIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 19:08:34 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5076D4AC;
        Thu, 24 Nov 2022 16:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669334914; x=1700870914;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iehyhrF259tkvYl2ZpG2kJlcZ+0onoAjZQwOind4Gpw=;
  b=L2yzgguluY+SPDQ3KCK3d/g2g6SvwjmCTcRYzirXknMUyG0DoZwCDm9p
   vBblg2NcFIf1vvddoovpZ4oi5dHQtWdawx947nEXkYNhyjnlekc8iZDo9
   4lRDH6uM5l72hAJY4ZOVYSMKog0CP+Nm3HmkgONlpLotmuWvQpGdSoD+L
   EK72NU+jdQD+CxnG6mXNoTaWZ+gT+T2niU1d/oT+8k0yFG5Mo/ktzvwA3
   I+p0czHEwcCoaw2PnBrM/D5iLj/Jc0D20MYjauSQfkWu14A/A0UEJbT4y
   Htf2eUSJPLmzsxbESrKUYSzbdZNqGh/qGZOsg0WjmvHa3X7Qg+5DU2qZU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="400672059"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="400672059"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 16:08:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="816982324"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="816982324"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2022 16:08:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 16:08:25 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 16:08:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 16:08:24 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 16:08:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsWd9B2uFzP03itpum61v6a+u4hFMo/hi9LQrwqrYAjdYD49Pk1tf2BxZrr51CgSbUnLqBZPaFib8vFgR2QRaWnr41tE8tPOf0XTCUeZZELwNHvI6A96of0JYRKXZ9nDGJfy1kmWj22hxWENE3aKsCdKm5lFOUO9ortfWRAv/Dr7hpDWwCIcdnfwXg9+Y3aYXL9qJioAIPLK0/kHWsP5Xt6EJc3YzuxQeWk4oFJJEmDU01i2ObZ04SEEgk3EJxRK3SMy0kDUySvqNc48+yH30EFULS4C6RoecACxWYB9x/aqno3N1CcKDa2FEcokVyPaCNSFFp8jhfcU9Ad/GQZrpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iehyhrF259tkvYl2ZpG2kJlcZ+0onoAjZQwOind4Gpw=;
 b=N9p5iCmxDuGBtOjeUmODTagGhXh01DQY/LEuvxNz4a69TnFIZRmMowv2p3HYgdeepMEMxQDk6rp1zaoBhQxvaG0lC4BRRecSAS3SmPjoGMCQ/wPr4OpdyceyMHzIVsjtwj5LrnSuL2AZdl+m5iVZxD+nfIKEYhxt5+HEGeF1H487qZL0ERaCKFAUTEufqgfH6gMR1fZWcgftlEMd3rYJB2/WZUdkbdw6/GzKs6/B0mwR4km4HzF1pP0mJ/8SxPxE5aOMGxD67M3009jE2xfkl08ZAa/O+YZrGvW/ezgPk4Rw1fYeOdotdG3B5rGQt7N52GFTOIxIrMXcQqnAQBrOVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6102.namprd11.prod.outlook.com (2603:10b6:8:85::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 25 Nov
 2022 00:08:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 00:08:18 +0000
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
Subject: Re: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Topic: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Index: AQHY/T3LiMVg2HYmLEKsa3j9uYLXLa5NPPqAgAFwwoCAABvQAA==
Date:   Fri, 25 Nov 2022 00:08:18 +0000
Message-ID: <5ed6985e6104021ed1391c4f1d54c51d82b6fe98.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
         <001d826d-a644-37ef-6b6d-729be14fe5ca@intel.com>
         <43aa0e78e15acc491ea3ac0db36dedfb6bd38515.camel@intel.com>
In-Reply-To: <43aa0e78e15acc491ea3ac0db36dedfb6bd38515.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6102:EE_
x-ms-office365-filtering-correlation-id: 980c3569-2e8b-4a90-70ab-08dace79284d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6dFWOmH5chsyR9gISNcF0SmV8fkwLBR6dtQOiDe4832veNQEP+8mLXVk+6tro3i5TyYFQVAVKSUdGq2XCSL4oA1iLv+GI4Ryv6SaOJo8tAbr3/dBubyX9tNQRoXp5H59ExUNg4mZgAMJrzeESOM6NWtrKLnZvHkb32+PPrC7lPdsw8xATuGU3aOtcFiyku9qNff9WbMs5hFo32erz9GGGCRTz3zqbGeOlwWeWDUXd0PZjyQhJdmZRckSGppFaBTpp0d0IHtx/DZ1Pg/rNumP7fyFro1EU2jnLmholTEsTgJJAEkQFhGQ8I1+n3GpcCpjCVl82JU3RiPgmxEx1Sw4o593xvjg5AorzWUWNjrMiQwRyRj2gtpo2mIvw1/1JJ2JU94uDXL4SDGSJilJDAg3tt0zJ7TcoSEUDcljZQ8SjRVEx+mxFq3Go1BOFW3YO8FDtzT3b/bOL5TG7eUHgl0WlCVB9hfxnZBK9uhtNAjrJJbk19lYbPS7k7hFTD2y6GR0TXIdham5b6m4p5Hwk+KaO3L7fkz9ncJXIPyAhZyWMWYBWyVNXbLP0vTJu+WTow6Le93YtB34qicJi5CdR+00OFUYVSknEDNvPGpSyBz1mmdSkTAwRV27cfr7JyCcqOiUGtEAEyJNJ8HPmU69AMcdGvjrr3pYt/QsMS5/SqVRiHyaxurjCI/3AiGrgXCSnlxpOi0k4zJ1VHTBFkr2/lzLPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(186003)(38070700005)(36756003)(2616005)(82960400001)(6512007)(86362001)(4001150100001)(38100700002)(26005)(6506007)(83380400001)(122000001)(7416002)(8936002)(41300700001)(478600001)(8676002)(4326008)(2906002)(71200400001)(66476007)(66446008)(64756008)(91956017)(66556008)(5660300002)(110136005)(316002)(6486002)(76116006)(54906003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VU14Mm5kSElyek5OWnMrZFNoNCtUeVRkTnJ0SWkrZ0t3c3VYU1lrUWlTbFpW?=
 =?utf-8?B?bjErb3NTblJQSGRtbmNkYm5yMW1YeHRYeEFRYXJDZTdZak56djZtK3JVdm9S?=
 =?utf-8?B?Y1cyWVE2ZUR5L3dhR3d6NnorU085bGZxc3ZBTmVmYWljSWhaQnAxbWN2anFo?=
 =?utf-8?B?blhRN04xQnFwSnFCenRwb2c4MkgvY3Z5TUZEZEVkTWc5UmxNK1JqTytSSG9n?=
 =?utf-8?B?dnZzQTVhYVBVUG9samU2NXNleFgxSFlmdVJZdGxaVnE4UURHd25EcVdIMFRV?=
 =?utf-8?B?NzN2RVo0ZXpDYlpLR0dtN3pWekxpNXZUQmk1SmNxNDJhL2VZZ1ZpOVhOczAw?=
 =?utf-8?B?alNKT1RhV1V6ald4TXAyMmcvbjBsbDlmNFpzOW9xYUt6d0h3RkVDalFjNjVx?=
 =?utf-8?B?Z0JQOWpPMnZvcStHTmc0WWVRbTNnUDJtSEduZEU2cWF2azAwTmRQYVlYOHIv?=
 =?utf-8?B?SkppVngxVTJyYmVDZmhLZUxOZHpGK25kN25IZE05d0JhbU5uL1B6VW9Obnla?=
 =?utf-8?B?VkMxMnIzSkE4a3NkbUZTS0I5aE5vNmoxTVB1TEJVRXRpTHBlWmEyQ3psZEM5?=
 =?utf-8?B?SER1R0JQc3ZGZGRpUXZ5cUkyQVRZMUc2Tk4wOXZXejF1RTdIc2FYajFXWGQx?=
 =?utf-8?B?ZVRWdFNxbWlhM001b2dHc1dmQWhjZ2l5NU5NcXBRcFBJREc0QWUxL1BOWHo3?=
 =?utf-8?B?NGR2N2hWMk9rVDRhaFM0NXh4ZGlTb2hPME9zSlIzU1JJaWdjZm9uVDhTZ1Zm?=
 =?utf-8?B?dVdIK1ZVemhvQjJtZ3o0NlVnZXBiWENLZXZscmhkRGJlc2VTU0JPREFvVEtq?=
 =?utf-8?B?eHZCOE55alBBbUY5TFI3T1l0VFp1N3ZDT2FaVlhnWTdaazgyVVZncGJSN2VV?=
 =?utf-8?B?Wm5TQWxSNXcxdFpqb095QUNrWVRaQ1FUYThnbGhJWmhrc3lCRVBtak02dmU2?=
 =?utf-8?B?c1FDalRrUW1VRHZ5dDZpZFB4alRGdStKUVlvVUZoNlYzY01ReFdSdzYyWkh1?=
 =?utf-8?B?Vms1K2M5bTdpeW9Gcm5ub0MvOG9hRUF6SVM5bXBmWmdaMzNwREFZVkdPSGRM?=
 =?utf-8?B?aUZObS9iNEdNWU9OK0N2VHRxK1dNTFZMYmppK3M4bVpaMDR2MTY2T20rckxs?=
 =?utf-8?B?L1h1RnhvUEtWdFI4ZC84SEVielhsbWlEVG1zSUVoTkttL2l1bVRrOGVDY0F2?=
 =?utf-8?B?YWFNN29BbHdDUzVjbEhreWtpbHlsUUFZcUhpb0ZFR0xpdnlHbEhkenBDakNH?=
 =?utf-8?B?NjBFV21acDZYK2tEdHl4Tk9tS2s4N2FDQ3U5dC81Yzh0akJFMSt6OVJZSnFB?=
 =?utf-8?B?MG02dDcwa1J5THg3NExLZWxwSGNRODdMRXZXYmo4WHUrMUZzL3pCMWtlZG9n?=
 =?utf-8?B?b1l0YU8yWEZ3OGQzcVVRTVdwZ0FBcG5GZlA3bkM1T1pwZzYwblFWZEpVVFk4?=
 =?utf-8?B?Y05VZEpEVnhQU3NadkFtVlJQUGFRVDhCSnVZRXQzZnhtajFXTmNKNjBJZDl0?=
 =?utf-8?B?QzBsb05TQlpXRzY5anJvcDZVb29oOFFreS95ZGtHV3RFeTdrNjhGUEl4TlBM?=
 =?utf-8?B?dlJPa0Y0NkpUM1p0SWp6Z0lNRWsrOTZRSHIrZ0JRV2tJaW5mM2NFanpGQUw3?=
 =?utf-8?B?VC9rbXJJVjh0T3krazVBTGpSNnAvYnlNMjdjQ0ZSajR1RjBoZU9mTFZzWUZI?=
 =?utf-8?B?SVVyc00wVHZEaFRQcC8xaElLandmUXpKeWI4SDBmR0F6R3NpZ28zekM2L256?=
 =?utf-8?B?MWpheHhGcERuaTV4RlRieGlMYU91L3dNa2J0aXhOVW92UWtlT3ArOE1iU2FH?=
 =?utf-8?B?TTNvMElNeVA1RHo2L2RicklQbUtDRkpqTnRoZmVkTUJqdVdXM1RJMm9hbWdY?=
 =?utf-8?B?VjdNOTBZdE1SeGFEdnpOaU9hL1V1VEJpa1B5REVTODVHUXlxek4wVmlyd2lL?=
 =?utf-8?B?MG5BUnhHbHpVSXp3UmZpV1plMTg1c3licmNhaVpBVENCNk9qQ0tuK0ptdkhx?=
 =?utf-8?B?TVpwaWU0QXVJTjg1RjhpY0NEd3ppZGdvK1NsTExOSnRuWE9GeVpNRm04L09F?=
 =?utf-8?B?VVg0eDZuVDVhbUJCVXViQ05WeUEwNnFaZm5XdkYrUkNMU0NSbnNaWnpVaVdl?=
 =?utf-8?B?SG4zRkVFQWhOMnJrNzI4eS9hVGdXbVpUWDdYUFMzRFFocVRRZjV4UkVJVUxC?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9846B15140DD254EBE9B147F24C19AAB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 980c3569-2e8b-4a90-70ab-08dace79284d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 00:08:18.8562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OlXZBN38TH5OXIunDjUP2HS8D+Ib0C04kKofCTdEHHQfPUpu4LSzqi/md2SSzAMUHqKcls3a+C0lqMfMs5q1bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6102
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTI0IGF0IDIyOjI4ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ID4gPiA+IEludGVsIGhhcmR3YXJlIGRvZXNuJ3QgZ3VhcmFudGVlIGNhY2hlIGNvaGVyZW5jeSBh
Y3Jvc3MgZGlmZmVyZW50DQo+ID4gPiA+ID4gS2V5SURzLsKgIFRoZSBrZXJuZWwgbmVlZHMgdG8g
Zmx1c2ggUEFNVCdzIGRpcnR5IGNhY2hlbGluZXMgKGFzc29jaWF0ZWQNCj4gPiA+ID4gPiB3aXRo
IEtleUlEIDApIGJlZm9yZSB0aGUgVERYIG1vZHVsZSB1c2VzIHRoZSBnbG9iYWwgS2V5SUQgdG8g
YWNjZXNzDQo+ID4gPiA+ID4gdGhlDQo+ID4gPiA+ID4gUEFNVC7CoCBGb2xsb3dpbmcgdGhlIFRE
WCBtb2R1bGUgc3BlY2lmaWNhdGlvbiwgZmx1c2ggY2FjaGUgYmVmb3JlDQo+ID4gPiA+ID4gY29u
ZmlndXJpbmcgdGhlIGdsb2JhbCBLZXlJRCBvbiBhbGwgcGFja2FnZXMuDQo+ID4gPiANCj4gPiA+
IEkgdGhpbmsgaXQncyBwcm9iYWJseSB3b3J0aCBhbiBhc2lkZSBoZXJlIGFib3V0IHdoeSBURFgg
c2VjdXJpdHkgaXNuJ3QNCj4gPiA+IGRlcGVuZGVudCBvbiB0aGlzIHN0ZXAuwqAgSSAqdGhpbmsq
IGl0IGJvaWxzIGRvd24gdG8gdGhlIG1lbW9yeSBpbnRlZ3JpdHkNCj4gPiA+IHByb3RlY3Rpb25z
LsKgIElmIHRoZSBjYWNoZXMgYXJlbid0IGZsdXNoZWQsIGEgZGlydHkgS2V5SUQtMCBjYWNoZWxp
bmUNCj4gPiA+IGNvdWxkIGJlIHdyaXR0ZW4gYmFjayB0byBSQU0uwqAgVGhlIFREWCBtb2R1bGUg
d291bGQgY29tZSBhbG9uZyBsYXRlciBhbmQNCj4gPiA+IHJlYWQgdGhlIGNhY2hlbGluZSB1c2lu
ZyBLZXlJRC13aGF0ZXZlciwgZ2V0IGFuIGludGVncml0eSBtaXNtYXRjaCwNCj4gPiA+IG1hY2hp
bmUgY2hlY2ssIGFuZCB0aGVuIGV2ZXJ5b25lIHdvdWxkIGJlIHNhZC4NCj4gPiA+IA0KPiA+ID4g
RXZlcnlvbmUgaXMgc2FkLCBidXQgVERYIHNlY3VyaXR5IHJlbWFpbnMgaW50YWN0IGJlY2F1c2Ug
bWVtb3J5DQo+ID4gPiBpbnRlZ3JpdHkgc2F2ZWQgdXMuDQo+ID4gPiANCj4gPiA+IElzIGl0IG1l
bW9yeSBpbnRlZ3JpdHkgb3IgdGhlIFREIGJpdCwgYWN0dWFsbHk/DQo+IA0KPiBGb3IgdGhpcyBj
YXNlLCBJIHRoaW5rIG1lbW9yeSBpbnRlZ3JpdHkuDQoNClNvcnJ5IHRoaW5raW5nIGFnYWluLCBJ
IHdhcyB3cm9uZy4gIEl0IHNob3VsZCBiZSB0aGUgVEQgYml0LCBzaW5jZSBURCBiaXQgY2hlY2sN
CmhhcHBlbnMgYmVmb3JlIGludGVncml0eSBjaGVjay4NCg0KU28gdGhlIGZvbGxvdyBpczoNCg0K
MSkgRGlydHkgS2V5SUQtMCBjYWNoZWxpbmUgd3JpdHRlbiBiYWNrIHRvIFJBTSwgd2hpY2ggY2xl
YXJzIHRoZSBURCBiaXQuDQoyKSBURFggbW9kdWxlIHJlYWRzIFBBTVQgdXNpbmcgVERYIHByaXZh
dGUgS2V5SWQgY2F1c2VzIFREIG1pc21hdGNoLCB3aGljaCBpbg0KdGhpcyBjYXNlLCByZXN1bHRz
IGluIHBvaXNvbi4NCjMpIEZ1cnRoZXIgY29uc3VtZSBvZiBwb2lzb25lZCBkYXRhIHJlc3VsdHMg
aW4gI01DLg0KDQo+IA0KPiBUaGUgVEQgYml0IGlzIG1haW5seSB1c2VkIHRvIHByZXZlbnQgaG9z
dCBrZXJuZWwgZnJvbSBiZWluZyBhYmxlIHRvIHJlYWQgdGhlDQo+IGludGVncml0eSBjaGVja3N1
bSAoTUFDKSBvZiBURCBtZW1vcnksIHdoaWNoIGNvdWxkIHJlc3VsdCBpbiBwb3RlbnRpYWwgYmx1
dGUtDQo+IGZvcmNlIGF0dGFjayBvbiB0aGUgTUFDLg0KPiANCj4gU3BlY2lmaWNhbGx5LCB0aGVy
ZSdzIHN1Y2ggYXR0YWNrIHRoYXQ6IHRoZSBob3N0IGtlcm5lbCBjYW4gZXN0YWJsaXNoIGEgc2hh
cmVkDQo+IChub24tVERYIHByaXZhdGUpIEtleUlEIG1hcHBpbmcsIGFuZCByZXBlYXRlZGx5IHVz
ZSBkaWZmZXJlbnQga2V5cyB2aWEgdGhhdA0KPiBtYXBwaW5nIHRvIHNwZWN1bGF0aXZlbHkgcmVh
ZCBURFggZ3Vlc3QgbWVtb3J5LiBXL28gdGhlIFREIGJpdCwgdGhlIGhhcmR3YXJlDQo+IGFsd2F5
cyBwZXJmb3JtcyB0aGUgaW50ZWdyaXR5IGNoZWNrIGFuZCB0aHVzIHRoZXJlJ3MgcG9zc2liaWxp
dHkgdGhhdCB0aGUgaG9zdA0KPiBldmVudHVhbGx5IGNhbiBmaW5kIGEga2V5IHdoaWNoIG1hdGNo
ZXMgdGhlIGludGVncml0eSBjaGVjay4NCj4gDQo+IFRvIHByZXZlbnQgc3VjaCBjYXNlLCB0aGUg
VEQgYml0IGlzIGFkZGVkLiBIYXJkd2FyZSB3aWxsIGNoZWNrIHRoZSBURCBiaXQNCj4gbWF0Y2gN
Cj4gZmlyc3QsIGFuZCBvbmx5IHBlcmZvcm0gaW50ZWdyaXR5IGNoZWNrIF9hZnRlcl8gVEQgYml0
IG1hdGNoLiBTbyBpbiBhYm92ZQ0KPiBjYXNlLA0KPiBob3N0IGtlcm5lbCBzcGVjdWxhdGl2ZWx5
IHJlYWQgVERYIG1lbW9yeSB2aWEgc2hhcmVkIEtleUlEIG1hcHBpbmcgd2lsbCBhbHdheXMNCj4g
Z2V0IGEgVEQgYml0IG1pc21hdGNoLCB0aHVzIHdvbid0IGJlIGFibGUgdG8gYWNoaWV2ZSBhYm92
ZSBhdHRhY2suDQoNCg==
