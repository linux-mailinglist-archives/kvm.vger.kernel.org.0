Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6BF740734
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjF1A2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjF1A2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:28:18 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E96126BF;
        Tue, 27 Jun 2023 17:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687912097; x=1719448097;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tDmx0xCY3Wo5tZAVcH89PMPS0RYnWBNoWCn8ic9+anw=;
  b=LypeTAy+IvkeLnzQ7Wd3hi8FQQYY0d9JwIJRpXopXShhe05YvCGXNyGz
   OYBmIZrln6e2Z4lQiGv3lUJGELD0U1AScp3AE5XqRaB7x+IPnI2J8oTKw
   I9Exd5MUkJmq1B7ok0IlYKib+0215B+1AhvxzyzQ87W0T1esOtn/nt5h2
   SnI++qQRaJyNi/Z5V+pWaU1CfMoYmVgx7K3hWeP5ILXhPAyduOvh5EL7H
   7jFBjmu5MFkF4fwMKAPsRXTo11lfmsHyjW8neu5YF/ybVx4JQfg6OYSM/
   TqcJjVikUT3OQmNX5Af4JaVIi/dR8tWxet4NIbQhK2FrHrBupSSmRc6Zw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="365170071"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="365170071"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 17:28:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="666900704"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="666900704"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 27 Jun 2023 17:28:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 17:28:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 17:28:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 17:28:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 17:28:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIDjR88CoTRZ3GDTyr/bx843Pd5Kn0K1AykJ8NNCKuQXQwW/JlLBVsPcX9G4cxzNXG5S3zrgLqMN5B+RqqUUdx3j39RuHXUBCcrrpSYkLrIOIWKL/iFoSwM6ZfgDrK0wIH22+Bv7IfOXbh1qIDqVGS9H7dONG4E3uNFbRqWlJah984j4cJYMurOeO5nZ7fTknOaNzCwl8BaToCmZ6TLluTONlHrtkTmQ8jm4Z+rj5L1Zx4XHgMZYfoX9DooHsYGb5ncW8MCbxEq8JnVZzgGSAwZS/6+RaFV0zEqqcrvqsZvH4n3HJxca67t0XVAjGBKbvYsp9XYJyRKhXd+z+70bkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDmx0xCY3Wo5tZAVcH89PMPS0RYnWBNoWCn8ic9+anw=;
 b=W7RJ99G+gpOeSF/WLkTWW4nPk/5q+UFsAfhJAx+2KkJkVom66AC8p4qx9FOAwr54sU4HTq8QNAtip8nacD/TEPvlE2JA7cWriOg+3H3WEI7n25p6CvMFcg4PwRxVRFYgmKJMK/H63WO29vsjuQJHKYiYAnyVfBtWhIGTt5J6T8+Qlx6a5K75oy/yKjirxnal2wmkPWnu0NOdVJfnMhUY//z8jCZfW/1bNCEip0CcC2YsczMIm+RNOQ+/7VEifjB5AXKFuDga6+E7ipT2uG8H2o6ALBOhh1B+3Fde/CqRaqx7PrI90dQdjh1aS1OPHpXqS56ehSI6GW9oX75tLMBuqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB6868.namprd11.prod.outlook.com (2603:10b6:930:5c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.47; Wed, 28 Jun
 2023 00:28:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 00:28:12 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
        "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+eaRwAgAAMPoCAAB1NgIAArPYAgAAey4A=
Date:   Wed, 28 Jun 2023 00:28:12 +0000
Message-ID: <7b61715ad35d7b9916f55df72378e02e62c5cc4e.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
         <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
         <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
         <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
In-Reply-To: <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB6868:EE_
x-ms-office365-filtering-correlation-id: 81d2d8ed-eb01-423b-1860-08db776e8e8d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pj7bumpNRI5ZXvlQ7oPiWeQUy8uWxLebI2Kg2tcZk9yXFwZQW3h/l0H+Q1HVdRxfFlvzjnkPy59wR/J5ZE49kDOLakhFYHbvSNkutQ/SJrPt3SGdoBgOM79BpZIcnzMOCVP8xbJWiG3FTpPxhW3EkdI0+4kxzm7/WqwAFrovl6suk1+EFA3j46l5N/jszmB5sQFoc2tvZqwSihVIe6/+kGwR/0RGrstcEP/lAzMK1hv1EBUcW5dSNi4Fpj2rDxL/wVMv241EDS5JRKOnBqV7OizZSQWEU7wHAapVAezN7iLtudu6p2a12ughBla8shwPUs6eZJohlmAadx4xlLNKvZjWVvr1T/SheN4ZgT7c7v3zb+shrjcCHFkWNB36JvX0YoBvr1QV4ZjhCwXPPAKg+rpBDTbAlpGa2tcI5wyLrxJERf7q19r19Jt2/hqUzGWRH7L0vJkKlO1sACUd8aRCl0AmWTheiWnY8G9v/+7eui/tD871CXlH43yow1W+OgfyEjeJ0Og5K/9+4Vkm03fGmlcMsfcb6dD5rQN4XsDYpczftwRCPP1BQJULaxJYpI9oBhzfIcDPJbql17di8tqHsaXw/jluGvRkyZ8FHI2z7IgF+PfHMpwrBLQq2bkXbAuI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(36756003)(66556008)(66476007)(91956017)(66446008)(64756008)(4326008)(66946007)(316002)(6916009)(38100700002)(76116006)(122000001)(82960400001)(54906003)(186003)(8676002)(41300700001)(8936002)(71200400001)(6512007)(26005)(6506007)(6486002)(478600001)(86362001)(2616005)(5660300002)(7416002)(38070700005)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlJHMGMwaTdEcW04aGZSV2FESXRzNWlMVnlJVG16bHRaMDA2YmI4UURQWEdU?=
 =?utf-8?B?M3ZnK2JWRFc3ZCtCOWZReCtEbTU5emIvQlloVDhqUzRtbG5hMmcxZGFIaW5i?=
 =?utf-8?B?c2h5UlEyTDJUSjFzMDhaVnd2MitzRFpmeS9wUXIxbmdmL080V0hjVFArclZJ?=
 =?utf-8?B?dzRHWmJVT3lnNFRUQ2lKT01vZVJGZlRpU282SGdjMVZCTG5COWF1NStFUUQv?=
 =?utf-8?B?MkZjcDYwbmdkY2QzZnhYdkJiWTZoWXY3RGdEeTZoQkx2NnUyL2dSeWsrdENL?=
 =?utf-8?B?L0szUC9CaEdPbWRLUnBCQVhDVDUrejRCSnVGNHJxcGVWSGxMdm9CWnd5VG56?=
 =?utf-8?B?alorekFoM1FqNXMvbDFSb0VWaURtN0YzQWppUVNqQllOVjdxUlkxSkJsbFhF?=
 =?utf-8?B?QzdBYnpHZkxQRWF4Q0F2eDZwT1MzeEZ3WlYyYTc3WHFlVUFSWEZhSkdPekYy?=
 =?utf-8?B?R3gyaE5OM1NWd2lNLzRkdzlwbUZmNTdrUkE4dFU1S1RMUEJ0YVBtamdUdmdj?=
 =?utf-8?B?MWw3ZGVBaHBkWGwxbnczMFpKSWgrQk53L3A1YWcyRnJIbmpsTldNMWFWazVW?=
 =?utf-8?B?aS94VHVsSFZDWjB4dlhLWGlkSldnRWc3b3pTSDlDNnYyOUlvMUU5YWVuS01O?=
 =?utf-8?B?WEhZbjZ5c3QrQmJydCt6Z2txRjV6SWpHZHI2WktxRGg0aUxkS3BUelhWNkRa?=
 =?utf-8?B?aHVDNWpwWTREV2NlbWxrNWtrYmN1OERHRGdTZUVlTEJLNWMwdWZhbEExWVhl?=
 =?utf-8?B?ZmVQcHJtQVNlWHlDUmU4dFJJZXlrZ2xUUHdLUTR0eThJOXQzU21GWkU3TlBU?=
 =?utf-8?B?TzZkYUFJWDEzQkJnNEFHaGlHVG1PMEFuMktQUjRnNFFpNjJaL2s5dCtzcUVt?=
 =?utf-8?B?WFBkcHF3NFFQN2pZYzY3UExEa1JuL212UUV6YlI1bkpZUGkzUXp5TVV4Rlcv?=
 =?utf-8?B?Zlc2VmNKUUZSWEZIZjBLVUNiaEx1QTdoK1hpcmVNT1dDK282WkhZc1dJVXoy?=
 =?utf-8?B?M1ZSRkIwcmsvUm1aM3BCOVcyUzBlTTJjSms1SFdGcjdEbkNLYlVtK3p5ZUdY?=
 =?utf-8?B?ZFNwdkYvSTRiNDNEMHBTelRNa3ZKcTF1Z3IvNlRnd29YSk1FYUs2R0ZSVVhs?=
 =?utf-8?B?aG9BaUwrRnZibVBuOXQ2b3hmakNUSUlCYVppUEtOVWIwM2FZTkNMQWhFbUJ0?=
 =?utf-8?B?MTVQT3lJS2ZoWVJOOURFcjhid2F6SEI0YUtQOHQzdFRoM3N1V0JTYThwV01X?=
 =?utf-8?B?aDRjQWFOaEY1a20zSnFqVVlGT0Z5QS9aa2RES2RPcDUzVzdJekdsUVkwQnNw?=
 =?utf-8?B?ODNkUlREWlVOK3RzYklvblNJdCszZ3owczY5UkVRejNqd0tNVlFaNkRCTjV3?=
 =?utf-8?B?NmxIR2hOaC9BWE9GMEVsZ1JBZGt6ZXhlOG1Mdzl6YTRTNG9xeUNEcVUyaG9y?=
 =?utf-8?B?a01UUFlKNFkvV0paa3FBN0hCSWR1dk5lL014djYvYytvRkU4bE5aOFBLZ0Zp?=
 =?utf-8?B?c1U1RGpWT095R1pzeVpWNG9QKzVxdENjcGh5SzBQSnJBVUxFak9hcUdZTzVi?=
 =?utf-8?B?WTNBMStLUFdCaktoaTZnenFKRjB5cHZZWGRpZ1JkaU16aUNWQ3JjdjJlR0xm?=
 =?utf-8?B?c3ZGMzVrTjJnR1cycStsYlZYUlJaWDY3QWlpK2Y1V2F2OVUwUUNQcnpTR2FP?=
 =?utf-8?B?Q2JsSVJFYy95NVdOKzBHLzA1TW42dTE4TUNYUkhDUEgwY3RNcFdBdjRMcm16?=
 =?utf-8?B?Qmh6YndKUFA1VFZWR2xUTEpWdWFWeXJtQ0JBQ3V6cFBUcFFoOHRaaEZ2VjhF?=
 =?utf-8?B?WjFDeCtyQTZoUGRTcnF1Y0tkRzdKNm9kTGxRdE9EZEZvbGdvTEgwMFcvYUtv?=
 =?utf-8?B?NC83QkpjampTTW9Mc052Ny8yWk1mc0xFYXA5WlBOdTNiQ3o5TXlEL3BUcEsx?=
 =?utf-8?B?aEhqbkNoZzNGcTV5aGtxem5LSmNKN1hYYlpBZnJ1UWMyOENBWHVON05XSnd5?=
 =?utf-8?B?NTFJNGZKbzcwM0JCak9QRFlOdjhxenNzUVAxVXU5Y1lhWWIxRHpYUVlrMENB?=
 =?utf-8?B?K3I4cUVGSEc1dllOUjNZM2xtOGtHS0pOeHBHc2RJZVN3VzlCblJkeHpGRXF4?=
 =?utf-8?Q?sBufgW9+ee5qKyyCba456F+8L?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA3D2103EB6806459085C4111AF14996@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d2d8ed-eb01-423b-1860-08db776e8e8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 00:28:12.4768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 59VehIjORcKTFsQkGW72q7HPz7BG9nMFa1IyVL5RGHKJqrddlOo6ZyEuLZgX7qsHIh8jRUHUTAYkkA4Rgbj7Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6868
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTI3IGF0IDIyOjM3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ID4gDQo+ID4gPiArLyoNCj4gPiA+ICsgKiBEbyB0aGUgbW9kdWxlIGdsb2JhbCBpbml0aWFsaXph
dGlvbiBpZiBub3QgZG9uZSB5ZXQuDQo+ID4gPiArICogSXQncyBhbHdheXMgY2FsbGVkIHdpdGgg
aW50ZXJydXB0cyBhbmQgcHJlZW1wdGlvbiBkaXNhYmxlZC4NCj4gPiA+ICsgKi8NCj4gPiANCj4g
PiBJZiBpbnRlcnJ1cHRzIGFyZSBhbHdheXMgZGlzYWJsZWQgd2h5IGRvIHlvdSBuZWVkIF9pcnFz
YXZlKCk/DQo+ID4gDQo+IA0KPiBJJ2xsIHJlbW92ZSB0aGUgX2lycXNhdmUoKS4NCj4gDQo+IEFG
QUlDVCBJc2FrdSBwcmVmZXJyZWQgdGhpcyBmb3IgYWRkaXRpb25hbCBzZWN1cml0eSwgYnV0IHRo
aXMgaXMgbm90DQo+IG5lY2Vzc2FyeS4NCj4gDQo+IA0KDQpEYW1uLiAgSSB0aGluayB3ZSBjYW4g
Y2hhbmdlIHRoZSBjb21tZW50IHRvIHNheSB0aGlzIGZ1bmN0aW9uIGlzIGNhbGxlZCB3aXRoDQpw
cmVlbXB0aW9uIGJlaW5nIGRpc2FibGVkLCBidXQgX2Nhbl8gYmUgY2FsbGVkIHdpdGggaW50ZXJy
dXB0IGRpc2FibGVkLiAgQW5kIHdlDQprZWVwIHVzaW5nIHRoZSBfaXJxc2F2ZSgpIHZlcnNpb24u
DQoNCgkvKg0KCSAqIERvIHRoZSBtb2R1bGUgZ2xvYmFsIGluaXRpYWxpemF0aW9uIGlmIG5vdCBk
b25lIHlldC4gIEl0J3MgYWx3YXlzDQoJICogY2FsbGVkIHdpdGggcHJlZW1wdGlvbiBkaXNhYmxl
ZCBhbmQgY2FuIGJlIGNhbGxlZCB3aXRoIGludGVycnVwdHMNCgkgKiBkaXNhYmxlZC4NCgkgKi8N
Cg0KVGhpcyBhbGxvd3MgYSB1c2UgY2FzZSB0aGF0IHRoZSBjYWxsZXIgc2ltcGx5IHdhbnRzIHRv
IGNhbGwgc29tZSBTRUFNQ0FMTCBvbg0KbG9jYWwgY3B1LCBlLmcuLCBJT01NVSBjb2RlIG1heSBq
dXN0IHVzZSBiZWxvdyB0byBnZXQgc29tZSBURFgtSU8gaW5mb3JtYXRpb246DQoNCglwcmVlbXB0
X2Rpc2FibGUoKTsNCgl2bXhvbigpOw0KCXRkeF9jcHVfZW5hYmxlKCk7DQoJU0VBTUNBTEw7DQoJ
dm14b2ZmKCk7DQoJcHJlZW1wdF9lbmFibGUoKTsNCg0KQXJlIHlvdSBPSyB3aXRoIHRoaXM/DQo=
