Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE3E75203F
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 13:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbjGMLlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 07:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbjGMLke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 07:40:34 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1EC30F1;
        Thu, 13 Jul 2023 04:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689248415; x=1720784415;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kfMbFNOp17T5lhxt+5v9bZEHUnkCYP9XxQ4nVQ2PJO4=;
  b=I8XJD0jTLwAvQ+LswOmTTVnx/XnSQ0zxR6qyIeTrwH3yE8VdELS0eBd6
   qCDM+u7Z/c+wh2DedH/HW40GL1ekBat3PriGVuz7m/79RzNYRsnRzuTqg
   aH5iVEFIN/Bww/UDFXdkIlOeAUR46dOVwy3Yu0Ebnx0HwbO6vK+MDN2B0
   Ur/n8ylXABH5aPGCmNJ38YKg8jP6k0wgpX0heAKVUtPfHNrDv55uVocLx
   ymI2lFi/WdGQACx/SW6Dibb/AeY628LJvJyBZbUS8+POlwaju8fZg2647
   ZqqNfydkrxxvBTBIbg7GO6UuNDAxnzY89fY0zOoS+k3isGmYOv9dGHG+l
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="365195071"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="365195071"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 04:40:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="866518424"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="866518424"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jul 2023 04:40:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 04:40:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 04:40:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 04:40:13 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 04:40:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9WlR7yJl5dgiIH1Pi/5lqCS/0OjmreGQW7BL0BA3hx1jhd19ropY98O+4OjWuU3ES3sx78YDrtu44IbVh/SBQCUIAQSDzGj+vbPxPii+NZhZ40u1hrm+IDfSwn45uxCKLFXYrFEK0DqHCsl9WSWSK9KdkUIQTsT5DLiUgNoj3GizHrLIy8syxQz1ITtxrKkkZXRwXS7DEHAz4703OuyAJuIzgpYDaN936C+R1Gc8hVIB51Qr8j+iFwIVaepzNe8A20YkJV1NvCfBKdIJPaDjEJ3JK3F1ZvdrrasoYeFiPTxKUTS0fL86/xpNXnoGp5PIeAiRedNMx7GU7IYwciRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfMbFNOp17T5lhxt+5v9bZEHUnkCYP9XxQ4nVQ2PJO4=;
 b=dMXwnjOdUaiZL65eaFwwRZ/SxJnoCX8DA+t9gX+d3abgOQzTbJKGx6sN9gfbvaj/+P6gLBNSEdwFH4IYPKU6Ea4JGvZQ/6zMOu3lncd9ty421AWEBto9H/mbKYhde1qlUg7HY6fRW9Zq2oyPi/q7j7tI+K21pcD2X3osneyfl29rbQfCzOH0zXYXUFpNr/p3WYLjWkn13eNIm9pPGGqJz3AXZeCJk0iQvjnamsemfT6/jn/3Yd96kLl5UuyA75xnre/S8UeMxFQPbwe+2lSJncLjxEjAXlQDCWdhEdg+wJTLMjqOvRY70R0qF1EfLBy4d2TH/crqNO/i+xSGQGBN3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7343.namprd11.prod.outlook.com (2603:10b6:208:424::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Thu, 13 Jul
 2023 11:40:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 11:40:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Topic: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Thread-Index: AQHZtJ1x0ZB1GuCRuUKTpeSsU9Y3jq+2WZEAgAABkQCAAPx6gIAAC1QAgAAa7QCAAAT4gIAAAtYAgAAJp4CAAAT/AA==
Date:   Thu, 13 Jul 2023 11:40:10 +0000
Message-ID: <21f09dbe5fbda1969b6bccae58144bb28bec535e.camel@intel.com>
References: <edf3b6757c7e40abb574f2363e34c8d3722d8846.camel@intel.com>
         <20230713112215.2577442-1-andrew.cooper3@citrix.com>
In-Reply-To: <20230713112215.2577442-1-andrew.cooper3@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7343:EE_
x-ms-office365-filtering-correlation-id: 23617d33-8e4b-48da-2888-08db8395ea4d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ewGKTWZgg0hGzZ5wAZ0W6n6Jsd6K/9qWQ7FCXDsRzSLpLZ6124ImPZzagzABBdoKpVpx9rOvQaXCwhAr2AmRDm5Fd2BJXuY6r2sY+hiAas8nKPCKfKbXurwaoKcq/xuamBoU+kMd9nu7U/N3OkUdekCQhN2YqhahVn+YUUYmLqDxaUAx32uqP5L7Ai0oKiEv6Y4ekz3JLp/9ix/2nDntMop2inXPe8PHiYVJFmPP9zuWiJoMbOVqYf/QUzBZtgo8dRsh+QJcvJziHMsDg+Lr6ktAV23skFJnB/091117/j736swn0Y5vgIM8lQwDjT2JuRTOgOHICPCQ4HlmtIq3EaW4ixjdClSD6heLveufeTKLvdB+5z2SA5N7G6/VSuPxqrpco2MR21Zobt3KkspvpMDu/37BHM2aBRDNlI/QF7u5BK9EWVIgjxbNMv7rN2Hynm/2u1lVKINOEvnQMkjydUc0eGdBboam0PA2sjf2nDsDg/XtToN5dsO2fvnQwKZZqlgFbr3a+ip/dh6PO8MpOVaXtbiD4/+zbTVSM65jH7OTKKL0vuVsBH4V0xc2CYZW0oLKk0ykEQfY4+grsmWgHnIcFNDM6Xs3qEe7amXnOPlOPtqsAVKqGD6OYy7HU/MD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199021)(7416002)(4326008)(76116006)(66446008)(6916009)(64756008)(66476007)(66556008)(66946007)(316002)(91956017)(2906002)(478600001)(8936002)(41300700001)(5660300002)(54906003)(8676002)(71200400001)(6486002)(6512007)(186003)(36756003)(6506007)(82960400001)(38100700002)(26005)(122000001)(2616005)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aENQY0JQeTR1cTV4OWk1L2hhREVrbTJYTDhvYXlKMlN1cTVpUitTK2ZKUk15?=
 =?utf-8?B?RFR4RnIvc1g2aUxic2pFUUpUUmJ2ZEZsbm5vYTZkdHFTZ1MxT0o5RFlMU3kv?=
 =?utf-8?B?ZDNWQ0dDU0JPUVpPSlZpRWgwQ2NaSGVvL3hWbk9Ed1JxTlVwazNEMEVuY2ZM?=
 =?utf-8?B?dkVKOWlzMlAyQUNQWEw3UnZwZ1ZFMWFPMFA5QUxsSk9lZVZGU3FIblhncWlL?=
 =?utf-8?B?T1ZVWmRoWUFuOXMxc0Y0cWFicEpHZ0k2ZzdHQSt0SjUraGJsZFRUNzJnYXRk?=
 =?utf-8?B?NGYra0VMYUsvRHdFaWJKUVhLNlh2SC9wajUyV3VtTFdqbUhGZVJaZEhPQk9a?=
 =?utf-8?B?SFJwZlJRajA1U01VcEJNNjF3R0lsL3JFSCtlR1JTWGMvWWtJMWZTWjIrdm9x?=
 =?utf-8?B?QkVXeWZaN1l3SXdOcTdqdVNUNHl4SktJckpMeWs2cEhxWGp5MzVlSEpSdllX?=
 =?utf-8?B?ektSOXl4YVVHcGJHMUtKcVhpMFBtV0oyK25OUERaV205bnJxM2xtbmd5bjlV?=
 =?utf-8?B?QlJWVmxHeVFLTnFaVTVKZkFJYk9mQzFMUEVpRW1lejhuZzNEYzBsVG54NTI4?=
 =?utf-8?B?d2pyUkkyVjg3MndQQm11VDFqcFVjS0h1c1dObzFxMmNYRzRVcHJsbXoxc0Zu?=
 =?utf-8?B?ODNtdVgwLzJyS2ZsbGhjbjRRNGc3NUtlUFVCNnpZUDhncWs1aTdjUEVLQ0ZF?=
 =?utf-8?B?YzRHeVNudm9NS0FjMmxQb0orSnYveHJRaVdVYmJSR2xFTHlWWVhESDl3dG5P?=
 =?utf-8?B?Z0RoWTMvTzVqeWgvc0o0WGI3ZHBEZG91ZFVuRXNtTW5TUTJsdVNxQ1BUdCs0?=
 =?utf-8?B?QnRsQ2t1cWNwVGtXSGhUdFczcEs5QVFtaDlIVDdnekdaT0Z4VkI5QWJmT041?=
 =?utf-8?B?YUFmalZCYVRZNFFUUnZObDBDam93OTF1cEJDWW0vZVpteXdUSW40Z0RrWUhR?=
 =?utf-8?B?MUZMa0w0ZGRFeVdWODNUK2RJb0Q0SHpBbzVwN2tVQnl1RWRKRy9HTUt3SnUz?=
 =?utf-8?B?OUxXbFZyc1p6TnJxR1RGMjgxdDlpNWhIRitlZmdZOUo4cGFwYUV5TEJGaEJX?=
 =?utf-8?B?aHd0aXE0dWdROG96dENkOU1UUE9vQXRwb1ZiSXdoSW9ESERTcmgxVktRN3Fz?=
 =?utf-8?B?R1FSWHpkS1VvNGF0UEYvLzBoZmx3OXFibFc0djBuMHNZOGl2Y3cxa1l3Ri9J?=
 =?utf-8?B?RUNma3ZycUNoMlNFVHJUa0xXakZqVnpkMnEvZFljYVhNQys3NUs1cElJWkoz?=
 =?utf-8?B?RTdaZUQvVWN2bFdPRFlFQ0duL3JnZmxzZ25KWlBnQU5rcmtuMUJ4TEI2V3JG?=
 =?utf-8?B?THRIRndXZ3JCV1lGWVhnWXJ2SllmdkNEMERXcDl3WWY0bVBzd1lTNTg5dUhM?=
 =?utf-8?B?WGZCVVJCT3NpTWZ3aGc5WmlsdzVNUStLeEk3dTVEbCtLTkJDMXJaVWJzY0Uv?=
 =?utf-8?B?SkcwTytuNzcwMmZ5eUwrL3l2M3JCeWhwazF1OU15S01jTEp3eU1HdFhTWnpU?=
 =?utf-8?B?aWFKSW5nektKdEtqME1kdHB1d3VGT1JUaitFKzBwenpvaFJRMmxIYmxja2pz?=
 =?utf-8?B?REZIa2FEOVlWY0gwT1VQV3BqWUZ1dzVBSURnNXRIOXNXUTVLQlU2bWFKendu?=
 =?utf-8?B?QkMxbkRnYzFDR2tRcUNLUU5EWkZIM2VYNjVMRWsrRVRWVUpXRit2V1J2NFkw?=
 =?utf-8?B?SU1mYkM3c20wblU1M0g2RTJrc2gxMFNlV3lvWkdRbzZIRExmbzdlU1kwTUZv?=
 =?utf-8?B?THVCT0pqckNDbEsyc0tWdlBrMGpDaXgwZnR3NWxCa0hYUm11aWp2Vk5LcG5L?=
 =?utf-8?B?MjViRVB1V0tvT0hBTUdMWkVBQkhYcW9tbGF1V2dHRUorbkp3eUpZYnplaGpk?=
 =?utf-8?B?YnZSNzd3ODA3WEtBcjFmbWh6VkppRVFzemkxOUJEWmhXcVVmZEpSbkdyN2h6?=
 =?utf-8?B?cjhRcEZkTjhmbHZuWlFqVGh2ZHhacE9GOGRIWFN6MkFmN0trRGJ0NzluVUlw?=
 =?utf-8?B?VlJvUEZyTGl4TmdtSHVUU2FpZkdBQTRiZjFCWDlxREFXdlFjcGRYREozK0NE?=
 =?utf-8?B?bUNQYktTZTZibk5rL3Z3UC9wbWhzckdNUXpTckc1R0ZTdVkxdGFoemNTNDRQ?=
 =?utf-8?Q?GDDShpsu/AQkjEja+d1nBbDRB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23268E39AC723341B2C98DF0D2533C73@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23617d33-8e4b-48da-2888-08db8395ea4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 11:40:10.6786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ySkMshzIJq1EjJnzhEMNWY77JiTgMH9rNt3KW5yJvIUtB6/nCRHtFBtTv7I5sfG/ROTaRCjZ7Ja0mQLhsb6a/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7343
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDEyOjIyICswMTAwLCBBbmRyZXcgQ29vcGVyIHdyb3RlOg0K
PiBPbiBUaHUsIDEzIEp1bCAyMDIzIDEwOjQ3OjQ0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0K
PiA+IE9uIFRodSwgMjAyMy0wNy0xMyBhdCAxMjozNyArMDIwMCwgUGV0ZXIgWmlqbHN0cmEgd3Jv
dGU6DQo+ID4gPiBPbiBUaHUsIEp1bCAxMywgMjAyMyBhdCAxMDoxOTo0OUFNICswMDAwLCBIdWFu
ZywgS2FpIHdyb3RlOg0KPiA+ID4gPiBPbiBUaHUsIDIwMjMtMDctMTMgYXQgMTA6NDMgKzAyMDAs
IFBldGVyIFppamxzdHJhIHdyb3RlOg0KPiA+ID4gPiA+IE9uIFRodSwgSnVsIDEzLCAyMDIzIGF0
IDA4OjAyOjU0QU0gKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gPiBTb3JyeSBJIGFtIGlnbm9yYW50IGhlcmUuICBXb24ndCAiY2xlYXJpbmcgRUNYIG9ubHki
IGxlYXZlIGhpZ2ggYml0cyBvZg0KPiA+ID4gPiA+ID4gcmVnaXN0ZXJzIHN0aWxsIGNvbnRhaW5p
bmcgZ3Vlc3QncyB2YWx1ZT8NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBhcmNoaXRlY3R1cmUgemVy
by1leHRlbmRzIDMyYml0IHN0b3Jlcw0KPiA+ID4gPiANCj4gPiA+ID4gU29ycnksIHdoZXJlIGNh
biBJIGZpbmQgdGhpcyBpbmZvcm1hdGlvbj8gTG9va2luZyBhdCBTRE0gSSBjb3VsZG4ndCBmaW5k
IDotKA0KPiA+ID4gDQo+ID4gPiBZZWFoLCBJIGNvdWxkbid0IGZpbmQgaXQgaW4gYSBodXJyeSBl
aXRoZXIsIGJ1dCBicGV0a292IHBhc3RlZCBtZSB0aGlzDQo+ID4gPiBmcm9tIHRoZSBBTUQgZG9j
dW1lbnQ6DQo+ID4gPiANCj4gPiA+ICAiSW4gNjQtYml0IG1vZGUsIHRoZSBmb2xsb3dpbmcgZ2Vu
ZXJhbCBydWxlcyBhcHBseSB0byBpbnN0cnVjdGlvbnMgYW5kIHRoZWlyIG9wZXJhbmRzOg0KPiA+
ID4gIOKAnFByb21vdGVkIHRvIDY0IEJpdOKAnTogSWYgYW4gaW5zdHJ1Y3Rpb27igJlzIG9wZXJh
bmQgc2l6ZSAoMTYtYml0IG9yIDMyLWJpdCkgaW4gbGVnYWN5IGFuZA0KPiA+ID4gIGNvbXBhdGli
aWxpdHkgbW9kZXMgZGVwZW5kcyBvbiB0aGUgQ1MuRCBiaXQgYW5kIHRoZSBvcGVyYW5kLXNpemUg
b3ZlcnJpZGUgcHJlZml4LCB0aGVuIHRoZQ0KPiA+ID4gIG9wZXJhbmQtc2l6ZSBjaG9pY2VzIGlu
IDY0LWJpdCBtb2RlIGFyZSBleHRlbmRlZCBmcm9tIDE2LWJpdCBhbmQgMzItYml0IHRvIGluY2x1
ZGUgNjQgYml0cyAod2l0aCBhDQo+ID4gPiAgUkVYIHByZWZpeCksIG9yIHRoZSBvcGVyYW5kIHNp
emUgaXMgZml4ZWQgYXQgNjQgYml0cy4gU3VjaCBpbnN0cnVjdGlvbnMgYXJlIHNhaWQgdG8gYmUg
4oCcUHJvbW90ZWQgdG8NCj4gPiA+ICA2NCBiaXRz4oCdIGluIFRhYmxlIEItMS4gSG93ZXZlciwg
Ynl0ZS1vcGVyYW5kIG9wY29kZXMgb2Ygc3VjaCBpbnN0cnVjdGlvbnMgYXJlIG5vdCBwcm9tb3Rl
ZC4iDQo+ID4gPiANCj4gPiA+ID4gSSBfdGhpbmtfIEkgdW5kZXJzdGFuZCBub3c/IEluIDY0LWJp
dCBtb2RlDQo+ID4gPiA+IA0KPiA+ID4gPiAJeG9yICVlYXgsICVlYXgNCj4gPiA+ID4gDQo+ID4g
PiA+IGVxdWFscyB0bw0KPiA+ID4gPiANCj4gPiA+ID4gCXhvciAlcmF4LCAlcmF4DQo+ID4gPiA+
IA0KPiA+ID4gPiAoZHVlIHRvICJhcmNoaXRlY3R1cmUgemVyby1leHRlbmRzIDMyYml0IHN0b3Jl
cyIpDQo+ID4gPiA+IA0KPiA+ID4gPiBUaHVzIHVzaW5nIHRoZSBmb3JtZXIgKHBsdXMgdXNpbmcg
ImQiIGZvciAlciopIGNhbiBzYXZlIHNvbWUgbWVtb3J5Pw0KPiA+ID4gDQo+ID4gPiBZZXMsIDY0
Yml0IHdpZGUgaW5zdHJ1Y3Rpb24gZ2V0IGEgUkVYIHByZWZpeCAweDRYIChzb21laG93IEkga2Vl
cCB0eXBpbmcNCj4gPiA+IFJBWCkgYnl0ZSBpbiBmcm9udCB0byB0ZWxsIGl0J3MgYSA2NGJpdCB3
aWRlIG9wLg0KPiA+ID4gDQo+ID4gPiAgICAzMSBjMCAgICAgICAgICAgICAgICAgICB4b3IgICAg
JWVheCwlZWF4DQo+ID4gPiAgICA0OCAzMSBjMCAgICAgICAgICAgICAgICB4b3IgICAgJXJheCwl
cmF4DQo+ID4gPiANCj4gPiA+IFRoZSBSRVggYnl0ZSB3aWxsIHNob3cgdXAgZm9yIHJOIHVzYWdl
LCBiZWNhdXNlIHRoZW4gd2UgbmVlZCB0aGUgYWN0dWFsDQo+ID4gPiBSZWdpc3RlciBFeHRlbnRp
b24gcGFydCBvZiB0aGF0IHByZWZpeCBpcnJlc3BlY3RpdmUgb2YgdGhlIHdpZHRoLg0KPiA+ID4g
DQo+ID4gPiAgICA0NSAzMSBkMiAgICAgICAgICAgICAgICB4b3IgICAgJXIxMGQsJXIxMGQNCj4g
PiA+ICAgIDRkIDMxIGQyICAgICAgICAgICAgICAgIHhvciAgICAlcjEwLCVyMTANCj4gPiA+IA0K
PiA+ID4geDg2IGluc3RydWN0aW9uIGVuY29kaW5nIGlzICdmdW4nIDotKQ0KPiA+ID4gDQo+ID4g
PiBTZWUgU0RNIFZvbCAyIDIuMi4xLjIgaWYgeW91IHdhbnQgdG8ga25vdyBtb3JlIGFib3V0IHRo
ZSBSRVggcHJlZml4Lg0KPiA+IA0KPiA+IExlYXJuZWQgc29tZXRoaW5nIG5ldy4gIEFwcHJlY2lh
dGUgeW91ciB0aW1lISA6LSkNCj4gDQo+IEFuZCBub3cgZm9yIHRoZSBleHRyYSBmdW4uLi4NCj4g
DQo+IFRoZSBTaWx2ZXJtb250IHVhcmNoIGlzIDY0Yml0LCBidXQgb25seSByZWNvZ25pc2VzIDMy
Yml0IFhPUnMgYXMgemVyb2luZw0KPiBpZGlvbXMuDQo+IA0KPiBTbyBmb3IgYmVzdCBwZXJmb3Jt
YW5jZSBvbiBhcyBtYW55IHVhcmNoZXMgYXMgcG9zc2libGUsIHlvdSBzaG91bGQgKmFsd2F5cyoN
Cj4gdXNlIHRoZSAzMmJpdCBmb3JtcywgZXZlbiBmb3IgJXI4LTE1Lg0KPiANCj4gDQoNCkFoIHRo
YW5rcyBBbmRyZXcgZm9yIHRoZSB0aXAgOikNCg0K
