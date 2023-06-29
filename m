Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E007430D1
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 00:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjF2W6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 18:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF2W6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 18:58:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31462D69;
        Thu, 29 Jun 2023 15:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688079500; x=1719615500;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=49P6jPl9XCUJGeOeu6B8+aIUE0RjO3Wq8ybMI6xcWA4=;
  b=F8312cdC2PgDbaQnaWIwe5ZpAlPjOI/2nq98qSL+YRuvWPst0qmmrOz3
   5vb5lb5SnKciQYpS5QLS4YjbeOlR40w77xTP+HPfzycKCnO12v4pFIH58
   Na+ZrzFRb9o8CiBWe4CSxDa9AEQkxZd1AjvIvfmM7tQ4CBWvcsTQK3DX7
   as504xGb1fb8IW25Rvu3p0V8KmHpscFtGmplZMBXJzt/3NohlXdBS8PY/
   bQprYJmB74Im/AGQtjRwttJSQpm2GOlbNfukJjqQr2Gr2qW+eIDb7f2eR
   mKq7EfsytTEvyowhiixjW+RvTdnIObL88r7i9FkMSAxiHKh6CBwe0MkR8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="341837904"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="341837904"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 15:58:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="694835968"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="694835968"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 29 Jun 2023 15:58:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 15:58:18 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 15:58:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 29 Jun 2023 15:58:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 29 Jun 2023 15:58:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ly+ZB+M1+lLxnKZjC0oDKvOfT5vuBF1HZ6UUSUTcnqltmPe+qPy13I9XwlAU5Qzta8ceoSw/3ZIDClsPCKMZmgEs76pa7mS+/WT3Ej7WfgbyYhmNo0fPgRSm1y0cFfInPbWt3fKQLHf01O+DTbcn/UP0O1z3ZKRzATiRVB2gg0LujYXyrUzTo9Wzn0XBLmF6e1Oj6wr4szAtYimsIsPxEcrXI5ftEMg4ZkAkQZlLAelpj+WCK3g1OsU1vP+KaoGvAVSWXUvDvNE1ycoCv3rlVUn8bOCSbN6W2xU00/4KlF66mktEVSx2XXw+RynLfpTHMcIq3wS1PLjW2ByXMrzF1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49P6jPl9XCUJGeOeu6B8+aIUE0RjO3Wq8ybMI6xcWA4=;
 b=WZ3GQheE9AloPCsgMeIpiM45rtluhlNeyDPLyZrz6y/iQeXbzrte66f9raRlv0olljJqgPmYESk48r+GE0NAyVrJcWuGS3XU04Y8QM1EPGKSv9C5RhsEF9CZUDQqOi2iqCA/H2F3wR18WHyIWfluezzKtzFVAlx+6cAaaigA6FWLOjeQsyHkq/nGjpTAu+DT+/lrTrCw5Q3q0BcrdsznSn+zAx+g+fjs4Ge2Jkb2QAVD2iCV/PB/zvXXQ6ENAa9uMMASsXdiDObjhbbTJQKWqFjk7RPHi0fs5Ny3pJ6oiBiOpPFfFzcx27QqaOGl1aoOZblzifuDScLOP6E6yY066g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4854.namprd11.prod.outlook.com (2603:10b6:510:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Thu, 29 Jun
 2023 22:58:08 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 22:58:08 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
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
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+hqiOAgAC/xYA=
Date:   Thu, 29 Jun 2023 22:58:08 +0000
Message-ID: <6e3770b282ba4dab1ae8418840d3b6f265a41aa3.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <bd9ce008-528b-2009-b157-6d69f1cf5530@redhat.com>
In-Reply-To: <bd9ce008-528b-2009-b157-6d69f1cf5530@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4854:EE_
x-ms-office365-filtering-correlation-id: 50b1ed19-5676-4080-ca37-08db78f44e24
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PCis7yQkK1uPYRwDRDGjKUhVLV8Pt4fQgxHylS/AcBIAG707wJ3X4jX+oUv0OwlGDU+v3IqFVw5F3s6ZZK/8+htBuMfljE23iyW2UJwZJ6AC4CtBW221dKQyJLyjxgxDNaDKjlvFmDqshUcZ05S8NljzTX1BEBsnH15vftIDamnA95Bl2o+h+go+Xvm/8GG5iCkpZ+ENmnWZt3uoSl2n+/5RBi1lkrqfZqCbmQoczt2m9HbMLWn5kALVXLBoC9N9DQT5dP+6AQ83wsfPpQ7JHeoNUo4mFhOZTgH42M/4yOvuS0BYGPQp9Wb9UZfyLjbFQ4GjcfKL38Neku/5ZQjX+ym/i9RUkejRKAf/2D6WbB8pG9IjgTRp70Vwsj631viAXBMdJMjpneOWjnnd7+pqguXliY49/HozVaAf096WGiIXKO0WRVZ1CjV58nB8Apo6rfNcm5VOBJZYU9lcWfemO8sVEM1D4bWp/yGfoncP/pPBcMe1fEIHdcP2NgY0rf5z/V/jNEtKienP4H6XNUzWeElEebjqXfVhPL/MR/3Cn8ueoJUQMv7d/WGM9NBGP2Zx1s09/jkQIakNjoDjPkYb+FRG+Pn3pTXdtNGv3geN3w0JBBeOjJTqy0g3bM0pzDsX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199021)(71200400001)(4744005)(2906002)(6486002)(122000001)(82960400001)(83380400001)(38100700002)(6512007)(6506007)(2616005)(86362001)(41300700001)(110136005)(186003)(54906003)(478600001)(38070700005)(66446008)(66476007)(36756003)(66946007)(76116006)(4326008)(316002)(91956017)(64756008)(66556008)(26005)(5660300002)(7416002)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUoxOGNGVlZjcWFOb0NxakJad1FjTjFKekhvNzM5ek1ReGFWZDB4WWdFK2py?=
 =?utf-8?B?dGI2U0JabjJ1RDV3Mkl6OGJEd2FDZ1dxcEZURW9TN3p2aDJjb21iNTV2dmYz?=
 =?utf-8?B?L2NnQjFhWUJ5aEVuQkV5Q013NXFZQUM4RW9MRklPQjBPM1g5eDdMR08rd1Qr?=
 =?utf-8?B?QjR4MmVEeFk2Ry9ka21GMW5TMEZBR3dnUGlXNHloV2ZnRUhaOWdmbnhMWnlX?=
 =?utf-8?B?V0JDcFJDS0JLMXdYeC9yejdqZXJyYng5TGRIK0x1K0U4Y2ZvcFFwWmdQQWJo?=
 =?utf-8?B?d0NMNDZCVFF6cnhZdzVHNHMwMS80RnFZbGYyUUNiUUhodnFaU2lUUUdDNWVx?=
 =?utf-8?B?TmJ4alVuRWZPaEdhamtUUVArOVQwOWIrTTVROFh1dFhlM1NuZ1h1WnlUSVZH?=
 =?utf-8?B?eUlCb2hocStwTE5UWGg3dlN2Vm9JWkhXQXFBZGhHNU0rdVdVK3dTMXRUVXlZ?=
 =?utf-8?B?NHRtOUdMaEVSYkdXM3I4MnJDa3I5TkYvd2pOMlUxSHl6TUhrZHlHZFBKbEZ2?=
 =?utf-8?B?QmR2ZjM2U1dJcUR2SlNuZGw0LzZWNEs2YnowUVcrbXlFa0YzOWd3RFhDOEEz?=
 =?utf-8?B?UzBhaWZvMklldkJkRlN6SGpYd1dtSFYwaitZL1IvZGtlZ1owVC9yc3hRYzVn?=
 =?utf-8?B?L1liUzFTcFVWdjNncDB4OGsvWDJIRmFRbjdYVXBMMHhqc0dCUjFuSnE4WWx6?=
 =?utf-8?B?SHRVR2FBYmVRMmpvZnNuYnNzMmp0eDh6NXh2dE93K0JETE5KalhXYjN6ZEtr?=
 =?utf-8?B?NE9vZkxOU0JlaWQ3MVdocGtUMVBUc1pQZEE4cS9Db3g4TDRFVnV4WDJFeTJx?=
 =?utf-8?B?ZlVIVmVTd3ZWZTUwRk1nbWxPSkVOV1VYY1RST1dvTXo1aVJqd1VkT0ttNUxT?=
 =?utf-8?B?ZW1PUXdQdDhWVTFMRTl3QVFvWVRQcW1Da2pEN1k0WWtjRTIxbHZuWUZLcyt1?=
 =?utf-8?B?RS9uM3JTQkVyY2pyMzFZMmk0a0NHSkQ3MDdVWlZWZ3BSSlJMQzlqR2NGREFq?=
 =?utf-8?B?WjBOR0lCSTVETmxDQXAyYmFCdzhxUDh5UVJWYUJIVVlVTjBmdUdFaWFGMXlF?=
 =?utf-8?B?VjRKWXhNbzg1TWwwMkZKZEFjQUlTU3FQbVpUa1E0RStUb3IrZlBENnFYVXY0?=
 =?utf-8?B?NmdleUtEaGVqb2w4clN6UDFRTW1TbUc2SnhWd3hHSWhaYXowcXNUOUZNTVFU?=
 =?utf-8?B?THhlM2REYWlyL1RIcWcyVWJZbUtlM3ZmeDJBbmxidzdhRmo5UG9XWWlBWjBU?=
 =?utf-8?B?ZXo0MFVBN3RiM2hpRVRUeXpIRkRXa0pnN05JRDRsWUtnWld2aFV1Y2VFUE84?=
 =?utf-8?B?ZnRQck9BdFNHNUw5WXhLaVRyWFBzN25SU3M2UzVyWnVmL3FuUHdmaGFESXRu?=
 =?utf-8?B?T21IYkJxZ0FZelRHMFkrN0xIWmFSZHRhMGh0NFVhZmNteG9zdVRzWXJmN2dT?=
 =?utf-8?B?dEhoV2dqVFZqeWJKL3pLSTdFR2duZ0RyNWt6SnFJMTN1ZXVmZGsyZndvMGdU?=
 =?utf-8?B?THh6aVpxSHlvQk1pbHV1MzdnTlV4VHowdXlob1VndDg1WWRBTGZpcDFQOTVy?=
 =?utf-8?B?cms2eWhrN0JjdDAxb2szTkRYVlNFb3NlNmEyS2wyVWYzd0ZSMlZvczQ0cTFS?=
 =?utf-8?B?Ykk5SWtWKzJHL1RROE9teElZYnpObjlaeEJKaHZaLzFiY2pqMWZVaG5XT2x5?=
 =?utf-8?B?WnNraEhhcms2OElCZS9VeWZjQUtqZmlyL1FQTkFjL05jbFhWN0Zoa2ZQclJV?=
 =?utf-8?B?UUJ1YnFQVGlOdXUwUDhXRXpUTGt5TnVCYmpIWjU2RUk0NmZBUzlGc3pVais0?=
 =?utf-8?B?MTFReTRVZGRsZENsa2toWXlnWTJrMExlV3dXWHNPZ2FTUDQ0ejlQRHZWeHc1?=
 =?utf-8?B?MGlzcE4yYk9nQjdqL3gwWW54TEVxQ2tRdzVyNmJRMjl2Mmk1bldRWGNGdHhm?=
 =?utf-8?B?Z0tOVFNadGhoeExGSE5KQTNDZXgxSUxwOFhiS1ZTdStaL0xVdThZUWpEbDY0?=
 =?utf-8?B?M3JuYUFzMUpmZEE5Z3N5UXJ5djZPMllKRDhZcmUvenc1UTAwTHFEeFpveWFx?=
 =?utf-8?B?Tnl3L21uWXBVTXJseURjVHhFQ2VIRUdMUFNVYzl4SFJOZjl4elN6MHJEM2VD?=
 =?utf-8?B?NGtsQU5IdzBsWHNlbUhCclhlTitOL3lHMkhPT2pTdzdCbllaT0w4eXRyak11?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <069E7E85A8E8ED438D6429031FA97ABF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b1ed19-5676-4080-ca37-08db78f44e24
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 22:58:08.0954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BQCPsHUdwgyw1gh8IF4YrpG4AEAKHGNHD8wxfcb5K5WNG3ZVK+t47aa41HJyO+FCtmFxkKqYkR1Ew/HcPSrKbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4854
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gK3N0YXRpYyBlbnVtIHRkeF9tb2R1bGVfc3RhdHVzX3QgdGR4X21vZHVsZV9zdGF0dXM7
DQo+IA0KPiBXaHkgY2FuJ3QgeW91IHN3aXRjaCB0byBhIHNpbXBsZSBib29sIGhlcmUgYXMgd2Vs
bD8NCj4gDQo+IEl0J3MgZWl0aGVyIGluaXRpYWxpemVkIG9yIHVuaW5pdGlhbGl6ZWQuIElmIHVu
aW5pdGlhbGl6ZWQgYW5kIHlvdSBnZXQgDQo+IGFuIGVycm9yLCBsZWF2ZSBpdCB1bmluaXRpYWxp
emVkLiBUaGUgbmV4dCBjYWxsZXIgd2lsbCB0cnkgYWdhaW4gYW5kIA0KPiBmYWlsIGFnYWluLg0K
PiANCg0KV2UgY2FuLCBidXQgaW4gdGhpcyBjYXNlIHRoZXJlIG1pZ2h0IGJlIG1lc3NhZ2UgcHJp
bnRlZCBpbiBlYWNoIG1vZHVsZQ0KaW5pdGlhbGl6YXRpb24gY2FsbC4gIExldCdzIHNheSBUREgu
U1lTLklORk8gaXMgc3VjY2Vzc2Z1bCBidXQgdGhlIGxhdGVyDQpUREguU1lTLkNPTkZJRyBmYWls
cy4gIEluIHRoaXMgY2FzZSwgZWFjaCBpbml0aWFsaXphdGlvbiBjYWxsIHdpbGwgcHJpbnQgb3V0
IFREWA0KbW9kdWxlIGluZm8gYW5kIENNUiBpbmZvLg0KDQpJIHRoaW5rIG9ubHkgYWxsb3cgaW5p
dGlhbGl6YXRpb24gdG8gYmUgZG9uZSBvbmNlIHdvdWxkIGJlIGJldHRlciBpbiB0aGlzIGNhc2Uu
DQpBcGFydCBmcm9tIHRoZSBtZXNzYWdlIHByaW50aW5nLCBpdCdzIE9LIHRvIGp1c3QgdXNlIGEg
c2ltcGxlIGJvb2wuDQo=
