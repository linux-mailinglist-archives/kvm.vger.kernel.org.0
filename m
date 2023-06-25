Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27EB73D54A
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 01:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjFYX0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 19:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjFYX0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 19:26:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7D1E44;
        Sun, 25 Jun 2023 16:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687735576; x=1719271576;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DUUsBped1eajr0FCRxoXMkxgRzGaDZNtJL4siMtqrwY=;
  b=PqmzmJibuVe3WsjpLQCDtrxVmFNSWihLnDw8oJAQMe0fBCzcR7lGU62Q
   vTbapw78kwBA9mG9gKGCc1q5KkqpHWLW4zeTkQy1bZr2hBYpfNtIqb5Qc
   NGPExtC1FOl60LQTUMnkkvPgDpVzgqkFUHf4skXt+85E/O6zndb3GD41c
   CgLPw5iypH9LIGwQvGuwDc6fdy50UJPUhbyoVtjj1MIesxIuvLM7PVv9C
   AHepSkCCZeaSiKF5H9xGhxxIRHR/DqVpxTUnVujWZ3YXoOpC8uoWjuyO6
   +NkiybaDUgmoObY5obtcaNkbrfN7e6UQIbecu7Vj9IOgJFZ14O6DhjWPe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="361166697"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="361166697"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2023 16:26:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="840074265"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="840074265"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 25 Jun 2023 16:26:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 25 Jun 2023 16:26:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 25 Jun 2023 16:26:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 25 Jun 2023 16:26:14 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 25 Jun 2023 16:26:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0UMC7KzhCuuBxJqt3wSBUFzBMvgQEyiVc8IDtd0YnLX51l87VUJy3jXMZ8RAS/gziLqvuCVMmraSdsFhBMatOYXjrpqE53ZHedx3xsb7lBB1Vma+ENUfHGBoY5fagtOkATzNWNks2oB9w7CeV1Frdde6Pg0OANjTHs32USz0xAf3Mn4WGy0LWyWoZqGKYE68aCx2F38863WhFwA65ZOeMic/W5BzM9D/RRkBI4/ErUYH9DOecp0KllLZe0dsZhDDmKIWDrtJyh2LvOZYurmvaAJEPuSIhROcybm4krj970UnZRRvUlVDVGOJECNmPEiDqCstxGvBypBP/oS4QypMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUUsBped1eajr0FCRxoXMkxgRzGaDZNtJL4siMtqrwY=;
 b=S3zJrQzWMJzIulOEIqMGHSv7Imed7uVhQfpLQ7CJUWA4EmONykVIsXOAo9faqyz9tkIgjSbHAZd5pcbP1GITZUyEakxh5KKwBTjxf59T4Rrp59n0gJXvKPyzrDermpLSlHJgrN1ASTHVtAc3ps/b/IiCZ7z370NMAtvBkP5jc/Uve3c0ok/D70vnL9AurbE+PyFqB3DYtBsOb8tsG62mKRT/ONAEz5yaDYSQUurg3IjcIs6fcmSuskQ3fXu79hu/WGssesU0YxiQiJwTjJ/EWT2N2MnMZ76q3/k7D2LjHwuf0mai/MgnCj2EeUhF/FiOkCEMMkgOLxtfATWet+w5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV2PR11MB6070.namprd11.prod.outlook.com (2603:10b6:408:179::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Sun, 25 Jun
 2023 23:26:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Sun, 25 Jun 2023
 23:26:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAAgAA3uQCACt3UgIAALtiAgAAEVYCAAJVNgIAAFRQAgAACvwCACM0fAIAAhMuA
Date:   Sun, 25 Jun 2023 23:26:04 +0000
Message-ID: <21c50c6eaa0475b6ef22feccb0168690b01fceb5.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
         <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
         <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
         <5782c8c2bb3e76a802e4a81c553a21edbaee7c47.camel@intel.com>
         <be258af9-a329-6f03-fcf9-9dafad42c97f@intel.com>
         <20230619144651.kvmscndienyfr3my@box.shutemov.name>
         <63477d22-26ef-dd08-a3b0-93931b7d1d16@intel.com>
         <0be5634f390015ee6badb3f2b2154ad90eb70434.camel@intel.com>
         <4069285d-1653-4cbf-a3b3-24727697754b@intel.com>
         <d624fc2c3c75e30f8ed8f52dc42826e10b9c9c63.camel@intel.com>
In-Reply-To: <d624fc2c3c75e30f8ed8f52dc42826e10b9c9c63.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|LV2PR11MB6070:EE_
x-ms-office365-filtering-correlation-id: 820e360d-f960-4d24-d3c6-08db75d38bc3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xhb4x6THj0VSVgO22Y4QAmAB+WLrDiSzwk95/SOMq+dEnFu0qWOZ3AHxNeXZK/fczYIppaC6Okmrb92C8JhCxFaOnhVFlmX4L0cYbAh+WDpOOaVGe5B7g/Kc3RVwjCNbKFM4cAbU85iPMtYlHFAjcKTu+8cVhz3/v5PAzi5sQ7rXRa3TDBnuMskHbFwpm07u7oEjzOIuo3EEN3kPmQRAm4pd8B2d86sVuOr/VYjJjYVmfPQb19ux+UOsb/hUspGZzm0Y+8Lj9tZs5vGUGf/KiJtUlkw7dVRcJXXBv8RtE3iMqrvrrt4LxUILKK/lf3g0+qSXwgvPFP5F8KJIfAq/F/ks+FWc2yhD9FbA3t/9Nn12Tf2V4BnD3ILgCst+tu38C6vdYJtHvbDx3vCnS4ETpVoJmhA277Ddcomo6ZUhHwrfd0E6QwqRmi+RWYYxIRG9YNwgYfVK0NIILvrL258VslPIezTQPbRm4wt1FicERi3zJWRBYAerYjbwqGQhiaWyqufaKNSe1HEExl0ow/O2+SHu/sUyAK9Z2ebXW/mWrYCnx6uLE66M1+ggxibJ/yThmwNVMgUhsQKItfBt3AHWade7KBIvJ1WCewoSvom+TIT7DFC7PhwvS8uYunudiU7I
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199021)(6512007)(36756003)(5660300002)(7416002)(86362001)(8936002)(8676002)(41300700001)(38070700005)(66556008)(64756008)(66476007)(76116006)(91956017)(4326008)(6636002)(38100700002)(122000001)(316002)(66946007)(82960400001)(6506007)(53546011)(26005)(2906002)(186003)(66446008)(71200400001)(54906003)(6486002)(478600001)(110136005)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXhkZjI5dHF4Z2FpTUd0dytQeU94R0R1bGlqWEdob0pJKytoRldWSUJoTkQ3?=
 =?utf-8?B?Mm9xNkJKc2d0NzNUQW9CK3FnZEkvSWJEUlU4LzJBdG8rTGQ4VFVUT2lzaEpn?=
 =?utf-8?B?ZkVHbVVrL1dZWEhVeGpMOXFVSW9iTTQ1cWNadjlDL04reC9WVjRCcXJGYk1Q?=
 =?utf-8?B?eFBxWWR0RG8vZ0gvRGFKRFZDOGk1alRaS0xIek11eTZRMURLYU9jZXFzeGFi?=
 =?utf-8?B?Q3l5WEZWNW5sZk92ZHd6U0V0emVsTXJzUHIzWk82Q1dFRys3cUFEVy9QN3kr?=
 =?utf-8?B?NEdvTUZxTVNQUzZMdGRVbXY4TTMwdW84eVd4blVyQjRBQTdCMjA2akh2WCtU?=
 =?utf-8?B?Tkw5RThHSUVFT25EeG0rS3NGRWpmQUVydU91bWpRZnRhd0x5SmJoQTJRalBJ?=
 =?utf-8?B?bVVLZU85czV2a3B5bVVjTmhTNmluWU5WOGFaU0I1SG9zS2lQaEFXWkpiRFBQ?=
 =?utf-8?B?ZG0rVmJYV0liQi9MWS9WbFcwa20zTDd0NjNTMXNkT0V2cVloQ0hVZU1sb0xa?=
 =?utf-8?B?Z1NWeVdTS0JzdGZGSy9XbnVmYXlUSEdSYWNtZE1ySS8vZlZTYmRqTWJOWjZu?=
 =?utf-8?B?VDNqenJJOG5Bc1dFRGFvQmd6T0ZjaXZyYzk2b3FTMXVPeTJXK1RqTVNaTzdZ?=
 =?utf-8?B?dnZaV25qR052c1JqRHRDMWpzR3RBNmk0OGFwWmZ6dVFKcWh4cDV0cVlZWFV2?=
 =?utf-8?B?RXF5Ym9MbkxjeE9PaWZTem1Udk9iQmdTNUZnZlh2U01nOWlhbURzWjVuYVR6?=
 =?utf-8?B?UEQyYmxjV3hPQ3V2ckp5c1Bkd2VGVjF3SmZIMXkwbFBJeVJzZmg1UGJvVDM4?=
 =?utf-8?B?SXA3c2dqWCtGaXgwVTF0RUk1ZVZkL0xnVzZlajFoWlJ4a1h3T2htNnlDWVVo?=
 =?utf-8?B?Z2c4eVFvNThaV3hVdlB3VUh4QTV6alg0NUYvV0NCLzMyR0hHWmE5dExDaXhE?=
 =?utf-8?B?MUNCWFRwTmhtV0lTQmgrVVJzUXBpQ0FoNko1U2VGaU5oUStCR2hHNktabm9V?=
 =?utf-8?B?c0lIcmJyRGZKSXYydnViaDZCT1VsT3JMbjBGYW53eDhWRmhhaEVIVXlTU1dT?=
 =?utf-8?B?NlVaVmU1OGpZSWRXdlhsZU9YMnJsSTVXbkNPbjk2ZlhSd2NuZE9yc0pXVXN4?=
 =?utf-8?B?dGVCczNId0tmQ0ZFb25DVjFUTHVpbW1UZkw0MkNYNlVxZWd0R0NuR0FvbVR3?=
 =?utf-8?B?MzBCeGsveTQ1Nk9KczdzL0ZjRkVDc0VudGtJWjRpNnNtSDdGTDdidDFCWjVP?=
 =?utf-8?B?dXdGR3ppVFAxSWUwR1BBbm1KYW9xd1VPekJhQjdkLzd1VTcyU3VtS2FnbVov?=
 =?utf-8?B?N3paSk11aUJ5eG00V1FTaTBERitTTktTZ1QvT3RLc3ZGUURxY0dMOGozWTNY?=
 =?utf-8?B?N1V2Tmo4dmdUSkc4cVZ0UDlGM0hzWTYyaktmVjhXMitNV1Rhc1JlcjVsd1FV?=
 =?utf-8?B?UGJiNW1kTnBJYmFCTWlWY3VHck1GK1pNL2QyeTlMdEtrekIwaEQ4ZFByeEJF?=
 =?utf-8?B?ZTlMUGFYTlZCVVphZ3BYZXhKTFpUSWdsZ1R1YVVEWlJmeGFyMkJaL2p3cklh?=
 =?utf-8?B?QTNQN2dVOVdjV3ZrL2JTVmVZTWJsQzZqanlheDRDQXhDV1YrSnJGbnNQbWlp?=
 =?utf-8?B?OUpXTG01bWJxOEFPMVNBQk56TS9vNVdrMFJSNzRmR0s0allRUjhrV1dvVVMy?=
 =?utf-8?B?WGR0RkxWeFJrTTVnWlpZTlpoU0pXNUhVWVhlZ3ZUSVdlN04xcG9hTjFFaWUv?=
 =?utf-8?B?VnJoMG0zYWdWc3dsK3hndS82bmxmQmUyQ2V5bEhrM2NJdFhIV2RGR3pGVVVK?=
 =?utf-8?B?WE1DTmEvV0h4WjZ4QjF2dW1BVFJNSHV1aUl2cm9BT3JQb045WVU1ejdiQ0cz?=
 =?utf-8?B?anFmQWk4dmYwSSs1OHBkT3hubkxwbDlaRmtaYUlRdlN3amUvQ003Vm5GUFpv?=
 =?utf-8?B?VEtkMy9qRCtEeENzeC9oVzB0UXVFWmNpWUpVV3p3Y1h0NW9kbkZlenNwbHlO?=
 =?utf-8?B?SkJJb1hqTnFVSEwrOU9acEgwZjVhYkp5UU5zZHhaSFVRUlpYYjVQK2t0V3Q4?=
 =?utf-8?B?cWY3ZHlWQnVHWDFvUHoxNHZTSFlNQlZIRmxuY0xFRXBkdk42aUVVb2Z3QW9z?=
 =?utf-8?Q?eQ9oh7Zy5sOtLShbjUFE9xzxv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A7B6A47F6AA704B8621FF879AA39499@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 820e360d-f960-4d24-d3c6-08db75d38bc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2023 23:26:04.6197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TYvkqwH+8UD1neZe1MqW8wFpO4XbvY+HUv0M/1WQXwC70ijF99Dl5Eln1DMKgeF02J2IXy9kapBHFUC9wWie2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6070
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTA2LTI1IGF0IDE1OjMwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBNb24sIDIwMjMtMDYtMTkgYXQgMTg6MDYgLTA3MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+
IE9uIDYvMTkvMjMgMTc6NTYsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBBbnkgY29tbWVudHMg
dG8gYmVsb3c/DQo+ID4gDQo+ID4gTm90aGluZyB0aGF0IEkgaGF2ZW4ndCBhbHJlYWR5IHNhaWQg
aW4gdGhpcyB0aHJlYWQ6DQo+ID4gDQo+ID4gPiBKdXN0IHVzZSBhIG5vcm1hbCBvbGQgYXRvbWlj
X3Qgb3Igc2V0X2JpdCgpL3Rlc3RfYml0KCkuICBUaGV5IGhhdmUNCj4gPiA+IGJ1aWx0LWluIG1l
bW9yeSBiYXJyaWVycyBhcmUgYXJlIGxlc3MgbGlrZWx5IHRvIGdldCBib3RjaGVkLg0KPiA+IA0K
PiA+IEkga2luZGEgbWFkZSBhIHBvaW50IG9mIGxpdGVyYWxseSBzdWdnZXN0aW5nICJhdG9taWNf
dCBvcg0KPiA+IHNldF9iaXQoKS90ZXN0X2JpdCgpIi4gIEkgZXZlbiB0b2xkIHlvdSB3aHk6ICJi
dWlsdC1pbiBtZW1vcnkgYmFycmllcnMiLg0KPiA+IA0KPiA+IEd1ZXNzIHdoYXQgUkVBRC9XUklU
RV9PTkNFKCkgKmRvbid0KiBoYXZlLiAgTWVtb3J5IGJhcnJpZXJzLg0KPiA+IA0KPiANCj4gSGkg
RGF2ZSwNCj4gDQo+IFNvcnJ5IHRvIGJyaW5nIHRoaXMgdXAgYWdhaW4uICBJIHRob3VnaHQgbW9y
ZSBvbiB0aGlzIHRvcGljLCBhbmQgSSB0aGluayB1c2luZw0KPiBhdG90bWljX3QgaXMgb25seSBu
ZWNlc3NhcnkgaWYgd2UgYWRkIGl0IHJpZ2h0IGFmdGVyIHNldHRpbmcgdXAgdGRtci0+cGFtdF8q
IGluDQo+IHRkbXJfc2V0X3VwX3BhbXQoKSwgYmVjYXVzZSB0aGVyZSB3ZSBuZWVkIGJvdGggY29t
cGlsZXIgYmFycmllciBhbmQgQ1BVIG1lbW9yeQ0KPiBiYXJyaWVyIHRvIG1ha2Ugc3VyZSBtZW1v
cnkgb3JkZXIgKGFzIEtpcmlsbCBjb21tZW50ZWQgaW4gdGhlIGZpcnN0IHJlcGx5KS4NCj4gDQo+
IEhvd2V2ZXIsIGlmIHdlIGFkZCBhIG5ldyB2YXJpYWJsZSBsaWtlIGJlbG93IC4uLg0KPiANCj4g
K3N0YXRpYyBib29sIHRkeF9wcml2YXRlX21lbV9iZWdpbjsNCj4gKw0KPiAgLyoNCj4gICAqIFdy
YXBwZXIgb2YgX19zZWFtY2FsbCgpIHRvIGNvbnZlcnQgU0VBTUNBTEwgbGVhZiBmdW5jdGlvbiBl
cnJvciBjb2RlDQo+ICAgKiB0byBrZXJuZWwgZXJyb3IgY29kZS4gIEBzZWFtY2FsbF9yZXQgYW5k
IEBvdXQgY29udGFpbiB0aGUgU0VBTUNBTEwNCj4gQEAgLTExMjMsNiArMTEyNSw4IEBAIHN0YXRp
YyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ICAgICAgICAgICovDQo+ICAgICAgICAgd2Jp
bnZkX29uX2FsbF9jcHVzKCk7DQo+ICANCj4gKyAgICAgICB0ZHhfcHJpdmF0ZV9tZW1fYmVnaW4g
PSB0cnVlOw0KPiANCj4gDQo+IC4uLiB0aGVuIHdlIGRvbid0IG5lZWQgYW55IG1vcmUgZXhwbGlj
aXQgYmFycmllciwgYmVjYXVzZTogMSkgaXQncyBub3QgcG9zc2libGUNCj4gZm9yIGNvbXBpbGVy
IHRvIG9wdGltaXplIHRoZSBvcmRlciBiZXR3ZWVuIHNldHRpbmcgdGRtci0+cGFtdF8qIGFuZA0K
PiB0ZHhfcHJpdmF0ZV9tZW1fYmVnaW47IDIpIG5vIENQVSBtZW1vcnkgYmFycmllciBpcyBuZWVk
ZWQgYXMgV0JJTlZEIGlzIGENCj4gc2VyaWFsaXppbmcgaW5zdHJ1Y3Rpb24gc28gdGhlIHdiaW52
ZF9vbl9hbGxfY3B1cygpIGFib3ZlIGhhcyBhbHJlYWR5IGltcGxpZWQNCj4gbWVtb3J5IGJhcnJp
ZXIuDQo+IA0KPiBEb2VzIHRoaXMgbWFrZSBzZW5zZT8NCg0KU29ycnkgcGxlYXNlIGlnbm9yZSB0
aGlzLiAgSSBtaXNzZWQgYSBjb3JuZXIgY2FzZSB0aGF0IHRoZSBrZXhlYygpIGNhbiBoYXBwZW4N
CndoZW4gc29tZXRoaW5nIGdvZXMgd3JvbmcgZHVyaW5nIG1vZHVsZSBpbml0aWFsaXphdGlvbiBh
bmQgd2hlbiBQQU1Ucy9URE1ScyBhcmUNCmJlaW5nIGZyZWVkLiAgV2Ugc3RpbGwgbmVlZCBleHBs
aWNpdCBtZW1vcnkgYmFycmllciBmb3IgdGhpcyBjYXNlLiAgSSB3aWxsIHVzZQ0KYXRvbWljX3Qg
YXMgc3VnZ2VzdGVkLiAgVGhhbmtzIQ0K
