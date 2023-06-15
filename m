Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8212B7322B0
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 00:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239241AbjFOWYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 18:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbjFOWYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 18:24:36 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928F62D49;
        Thu, 15 Jun 2023 15:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686867868; x=1718403868;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XbCfJ1eYS6TbK3O3477msIKr4pYr3EHyXWo9HV4ajlk=;
  b=O2+ECaiEbu80e5QihC58S53O+JR85yY+GBuWueJDoAOU1ms8wFif3nLb
   lyrPesqw30yhm2+wnd1H11wraPIHaE2piqTEcwR8dIQavwB1+WezeRdTg
   V1CAxFHYXBbnrSZNnMbEVj765GLSoJNyYG7bVx+s5Y5qi47o0wAzZjpq8
   eBUSA/XKp0T4zeTo+Sn+i1BhaSaU23h+nWTDrIllGiyVeUwOry/U7qWaM
   giw9sUf7eFBXFUd6SS8kh/z8B3hp58X+PC6eFbwJ/v4Y+JH2BFRzq/Jjr
   otUEczdLUOGIZrEh5FqsGzHyiWGyPCgcflum41CbwIuF5ucHqv5FWHh4N
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="422698531"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="422698531"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 15:24:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="742410993"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="742410993"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 15 Jun 2023 15:24:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 15:24:27 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 15:24:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 15:24:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 15:24:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z65KccszMrLf77EqKK0DFBJFT90qHbHM5QUn012wYSxp6f6Am+0a+WV+cWNCjzukSlQPJnqhhz/3jySQ+mG4ecem3GFCXgotkLAyt5DM+iQQHn4e2fhmh4jF4O2VPynlgMhvwOuYwcXgf42F1G7xta2vLlYy8V3MXNJLQ3wuBa8LAxfKbot2X6cC0hxLQQAbe9GJSSw8PXpBWpHmylRbFH/hCh9Vq7NgE1xevLW0vnrR6RC2HxyyB5zFL3YInTuubUEy3Xi6Auk+yA6gZUSsXJapkr9mPP6nU1Jd5MN4ngiesm3M4n79cOfCng2nn7UzFh7CUhh0dgGc24kwDRf4zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XbCfJ1eYS6TbK3O3477msIKr4pYr3EHyXWo9HV4ajlk=;
 b=OYiQ8HL3xVlMxjjQbsP/XPNrNuhJwTBiUNIyB7pwJ5rnlnzA31Drl6cAuVKj9CE6K8/ioU21qL6KaSD3XJjlKdrCrM7S8/7X+oCWbxpVzXIi0qOU9w4ip93CNSwqTRB1hFmtkIV8z5RZ9xcVWMRARLMM/R/QlXYn3YiHBmEpxKLhpEQHrGKvWNPrqm9nfr/OmvvewdJAyQQBwqcFqpi+GyJpF1maeyiiQhjJJ/fmkmLh+4a7nxDDm8SSab7vTG4RMEs4kRCw5d2DdTKR3jmcWiEy7RP4ruCoeE85r4e6EMCdcDjBu8yEYQ4GImklDTbeGkVhCwJRZpBpLuNoSB3NEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7439.namprd11.prod.outlook.com (2603:10b6:806:343::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 15 Jun
 2023 22:24:18 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 22:24:18 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 15/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Topic: [PATCH v11 15/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Index: AQHZlu+0KAMcPEG9HEOo/5AeWmgUfq+LlEeAgADuFAA=
Date:   Thu, 15 Jun 2023 22:24:17 +0000
Message-ID: <a60acb9be5bd5b0eb9b32ff11932fc019262dfe0.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <30358db4eff961c69783bbd4d9f3e50932a9a759.1685887183.git.kai.huang@intel.com>
         <49bd9f7f-9a2b-8b8c-f408-49b9b5982eb7@suse.com>
In-Reply-To: <49bd9f7f-9a2b-8b8c-f408-49b9b5982eb7@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7439:EE_
x-ms-office365-filtering-correlation-id: 65479e42-aedb-4adb-3159-08db6def4257
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXZu52I0RuVzO1u/2z2+UcmtwNhacYwFVNk1LBnr934pG2FMG5KPhJi2a40n38WMMgnMYyjJznkyRwin/HH9ZdQ3RUHIaYPZoYtOPyJ5l7QlT+8W4hfoKmPk7ZWfEFa4r0ckD7LZXbUhmQkPSE3OE96e3Jb+YWTlypa/yHA9tq0sbRKIApaqRqYbfySA4afh+as6ZRxc7f0AbgS0z0zWGg1KAJOBN+zmUeTl9wpvxN2kwg1Fvl0A33C4cIwpoSqTe/1ElscLuupvHWM3yyJ3rSNN+rD5jnd1QSJ52rbiYdB/LEvyVEHsXK5yIE60pag8VI2CKqgsKQm+zPFZYEe2Z6MGwYKSHrwUpZHl7ybyzvFUr1VJg7j2hce8uBgl3m6WBi/klbItk5DulHINIi/ScdIIleAza/oWGvy+PfIVjdx2IWdyuK9zUEToX0MDMHakgkydhH6LeJ3WO5LrBqiV/fFehMXsfxZUiBcOybUkhimWIW/6zU2Mf2t3tjErt8VwuwZ6LyK+T7YkgQJ6AhaHFDlTe9OZySPih29LIBec7AzIn1hyWBi1Z8y9OtWLNigDMhT7HsWdK81V0Mdyquk3UyIrcc/eHYDYEeFN5wCUYy+YKIB3qOIc1RAIMeIoUrZ/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199021)(8936002)(6486002)(41300700001)(316002)(2616005)(83380400001)(26005)(7416002)(38070700005)(2906002)(6512007)(6506007)(86362001)(186003)(122000001)(82960400001)(38100700002)(36756003)(8676002)(66946007)(66556008)(76116006)(54906003)(71200400001)(5660300002)(110136005)(478600001)(66476007)(66446008)(64756008)(91956017)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0hJSVlZL1ZjVTV2MHRPQ29aeUtPR293T2Q1MWUwU3RLbzc1RnY3Ukg4cjhZ?=
 =?utf-8?B?bXc1QmdrRUpYbk1qZTNzVFFKdWVUVCtseE5aK3EzMzVqTzhkcjJab1ZaSDls?=
 =?utf-8?B?VzFrWnlDb3hVNmlmSnVTVmdjT0JtbUp4LzBWMCtZcGtFZ3p0akxYaUtYdUFt?=
 =?utf-8?B?eXZ1Y1BsUldMMHlHU3ZpZUtYd3ZvNGJ0VURLaGtWalUrSlp1TGNuOEFyeTIr?=
 =?utf-8?B?TjB2K2RkN3hxVUJmOVdoNmpzamI0S0NwV0JkLzJIdVBzbkJsZGNhWTFIaDRq?=
 =?utf-8?B?bHAzUmtnN3dJTDlVZkpGS3dRUlJpNHl0SkVUS3R4eWZhMU1qY2VPWmgwR2da?=
 =?utf-8?B?RW4vUTMwa1I0ejhYSUE3UkZDVUVUREpXSkl0VU5rQllJVCtWdHYvdW82Rm55?=
 =?utf-8?B?bmdBeFRVdlAvT25CSis4emg0MU1PcW1aV0FXb0NHR1dYMHVyZGkrVmdhVjZH?=
 =?utf-8?B?RVpHSVpuSFU5T25vL3B6L0VkcFBIM0MvUS9KWk9neWtWVi82MUdkSjlZRER5?=
 =?utf-8?B?Tk1ieEQxOFRZR3dTQjgxa2todnZlWE10VXFIL0dCdVpHQTVwZm1vaDY5b3Zi?=
 =?utf-8?B?UlBEQjBrUG9mMUlQOUZ0VGVMN21HVmlMQ3JQQkpKVUhxdGhNa2FCUi9abGgz?=
 =?utf-8?B?MHM1VW84dWpxZ1BzQXhDSmlYWXFuQXBONjg1RjI5Y3RYSENxakpOZ3B0M3Ji?=
 =?utf-8?B?ckpUOG8wcUYwNTZleTlHU0hxb3VmemNTSDMxM0U2YWxMYm5FN1RmTXk4bmJi?=
 =?utf-8?B?TkkvN1FqVEI5VVhJdjIwMjNRclNLNnVmUmZKS0J4cjduL0Y5REo3N0RvRnc0?=
 =?utf-8?B?cFlrd09UQ1h4cVNqUlJFNUZYQjExc0xyczRwcDNDM09EK05SRE9IbW4rMHJ5?=
 =?utf-8?B?SEN1bkVRZEFXUnpCRWkwLzFJenJDMERCNCtOcDhLVGVDY1BTckNVZjNhRVdu?=
 =?utf-8?B?bXg2clF1NHUzc0xLTmtkdDc3cXhmcTBFcXVTQW1neXY1NDRMbXR6K3lvRmFx?=
 =?utf-8?B?TXJObHI3NHQxMGhZWEZ5WHRtbURWSzdSa08zM2JqYXg1NUhHMzY1aVFBc2JV?=
 =?utf-8?B?M3VEVlh0RysrN3RjaVhaa3pZcDlqdEpFNjJybVBibEZoOXRCb0E5c1FaMjhF?=
 =?utf-8?B?bFd3NVg0SDh3S2l2TVcwMFpua3R0dFgzdldZbUR5MWZWR3NnWklUQjlHL3hU?=
 =?utf-8?B?Y053NmMzNXBKUWl1ZVhCalZJOERPWXJySFhPUDlZaEFXMVEvQ1A5VDVFRHFR?=
 =?utf-8?B?L0prY1Bia2p3bU50ZkY0bkl4NkxqSk1WRWJuZmZ6V3lHcG9OMFppWDVVMndG?=
 =?utf-8?B?RGVWRnZvUllVTjBnaWFHakZaSCtPS3VLa3NsV1JlY0RVOGNXUTRnQjl1WFh5?=
 =?utf-8?B?RVFlSGRZVnU5bDJpRnA3cnBGVWkrdzhvYytaZFdTQUxJTnZ3YlNVZ2diaW5w?=
 =?utf-8?B?QW1FbGdlY1U1YUhhNzlLS2UwMk96bFZxZ3VVS2RYaEE2MDNYbmtEWTlsRkUv?=
 =?utf-8?B?eGd2NUI4bERmWHpPVXFaQ1IvdU5hRWMvMUl1YlBFSEdDTjRpQ3U3MlpZVjgx?=
 =?utf-8?B?Mm9nN0MwUDhGZFdJeDZ4Yk9NNVZtNFpIcVZHYWJLOGF3VlpGWWthY2s0elhM?=
 =?utf-8?B?NmNkZ2lJU1pLSzI3Rjd1Z0NPemg0OCtGUlpJMnhCUmx3S0RjSENrZWhweHFT?=
 =?utf-8?B?b1dBNDh6b053UVNiM1gvbFI2OE9xb3hManUxSElRSEphSFZXdG5xSk40YUg2?=
 =?utf-8?B?Y1I3TW5CUkNqOU1TOVRDQVdhK3REREwwSG1BbXlRem5pQzNYeXlPU3IxTkdJ?=
 =?utf-8?B?U2ZtRmJNTFF4QzB3RkY0akV5VkU5ci9jdWZmTlJiL2NmUWZzaTJ2WFpKb1RV?=
 =?utf-8?B?dEJFQmhIZEdlSnlVa3RFUHEzT1U3RGpybDBQKys4VFVxV1p4dHZZQmNtbk5O?=
 =?utf-8?B?bGdYN0pxZXdsZklrOUViMm9uTjROb2p3QTRWSVVLck1PQVhDUWFwcXkxZlpF?=
 =?utf-8?B?dS91STZNanlTRmYzUzJlVUMyem9xYXRaL3FHK0hRbEpMRUJEbjZpblIvTE5r?=
 =?utf-8?B?SmoraG5QbkpYSkhxVlBXMDJGMnZFbEVaK3ZCS3QwVk4xYVRRMHErTXVWeVBK?=
 =?utf-8?Q?z6LZ5yA4gDvPx6cLFkp3CH2gn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5408A0E957CB3E41978BE16CF98F33D6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65479e42-aedb-4adb-3159-08db6def4257
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 22:24:18.0078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XScgFt2wtUVRrbTXy0i0oLlq5HS2RK7ehBieXjLzaqsOI80PhXU7ehXDDc7yu6OVCa7ibTtJa7caUblR/NhjAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7439
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

T24gVGh1LCAyMDIzLTA2LTE1IGF0IDExOjEyICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiA0LjA2LjIzINCzLiAxNzoyNyDRhy4sIEthaSBIdWFuZyB3cm90ZToNCj4gPiBB
ZnRlciB0aGUgbGlzdCBvZiBURE1ScyBhbmQgdGhlIGdsb2JhbCBLZXlJRCBhcmUgY29uZmlndXJl
ZCB0byB0aGUgVERYDQo+ID4gbW9kdWxlLCB0aGUga2VybmVsIG5lZWRzIHRvIGNvbmZpZ3VyZSB0
aGUga2V5IG9mIHRoZSBnbG9iYWwgS2V5SUQgb24gYWxsDQo+ID4gcGFja2FnZXMgdXNpbmcgVERI
LlNZUy5LRVkuQ09ORklHLg0KPiA+IA0KPiA+IFRoaXMgU0VBTUNBTEwgY2Fubm90IHJ1biBwYXJh
bGxlbCBvbiBkaWZmZXJlbnQgY3B1cy4gIExvb3AgYWxsIG9ubGluZQ0KPiA+IGNwdXMgYW5kIHVz
ZSBzbXBfY2FsbF9vbl9jcHUoKSB0byBjYWxsIHRoaXMgU0VBTUNBTEwgb24gdGhlIGZpcnN0IGNw
dSBvZg0KPiA+IGVhY2ggcGFja2FnZS4NCj4gPiANCj4gPiBUbyBrZWVwIHRoaW5ncyBzaW1wbGUs
IHRoaXMgaW1wbGVtZW50YXRpb24gdGFrZXMgbm8gYWZmaXJtYXRpdmUgc3RlcHMgdG8NCj4gPiBv
bmxpbmUgY3B1cyB0byBtYWtlIHN1cmUgdGhlcmUncyBhdCBsZWFzdCBvbmUgY3B1IGZvciBlYWNo
IHBhY2thZ2UuICBUaGUNCj4gPiBjYWxsZXJzIChha2EuIEtWTSkgY2FuIGVuc3VyZSBzdWNjZXNz
IGJ5IGVuc3VyaW5nIHRoYXQuDQo+IA0KPiBUaGUgbGFzdCBzZW50ZW5jZSBpcyBhIGJpdCBoYXJk
IHRvIHJlYWQgZHVlIHRvIHRoZSBtdWx0aXBsZSB1c2Ugb2YgDQo+IGVuc3VyZS9lbnN1cmluZy4g
T1RPSCBJIGZpbmQgdGhlIGNvbW1lbnQgaW4gdGhlIGNvZGUgc29tZXdoYXQgbW9yZSANCj4gY29o
ZXJlbnQ6DQo+IA0KPiAgPiArICogVGhpcyBjb2RlIHRha2VzIG5vIGFmZmlybWF0aXZlIHN0ZXBz
IHRvIG9ubGluZSBDUFVzLiAgQ2FsbGVycyAoYWthLg0KPiAgPiArICogS1ZNKSBjYW4gZW5zdXJl
IHN1Y2Nlc3MgYnkgZW5zdXJpbmcgc3VmZmljaWVudCBDUFVzIGFyZSBvbmxpbmUgZm9yDQo+ICA+
ICsgKiB0aGlzIHRvIHN1Y2NlZWQuDQo+ICA+ICsgKi8NCj4gDQo+IEknZCBzdWdnZXN0IHlvdSBq
dXN0IHVzZSB0aG9zZSB3b3Jkcy4gT3IganVzdCBzYXlpbmcgIkNhbGxlcnMgKHN1Y2ggYXMgDQo+
IEtWTSkgY2FuIGVuc3VyZSBzdWNjZXNzIGJ5IG9ubGluaW5nIGF0IGxlYXN0IDEgQ1BVIHBlciBw
YWNrYWdlLiINCj4gDQoNCk9LIHdpbGwgZG8uICBUaGFua3MuDQoNCj4gDQo+IA0KPiA+ICAgc3Rh
dGljIGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkNCj4gPiAgIHsNCj4gPiAgIAlzdGF0aWMgREVD
TEFSRV9QQURERURfU1RSVUNUKHRkc3lzaW5mb19zdHJ1Y3QsIHRkc3lzaW5mbywNCj4gPiBAQCAt
OTgwLDE1ICsxMDczLDQ3IEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ID4g
ICAJaWYgKHJldCkNCj4gPiAgIAkJZ290byBvdXRfZnJlZV9wYW10czsNCj4gPiAgIA0KPiA+ICsJ
LyoNCj4gPiArCSAqIEhhcmR3YXJlIGRvZXNuJ3QgZ3VhcmFudGVlIGNhY2hlIGNvaGVyZW5jeSBh
Y3Jvc3MgZGlmZmVyZW50DQo+ID4gKwkgKiBLZXlJRHMuICBUaGUga2VybmVsIG5lZWRzIHRvIGZs
dXNoIFBBTVQncyBkaXJ0eSBjYWNoZWxpbmVzDQo+ID4gKwkgKiAoYXNzb2NpYXRlZCB3aXRoIEtl
eUlEIDApIGJlZm9yZSB0aGUgVERYIG1vZHVsZSBjYW4gdXNlIHRoZQ0KPiA+ICsJICogZ2xvYmFs
IEtleUlEIHRvIGFjY2VzcyB0aGUgUEFNVC4gIEdpdmVuIFBBTVRzIGFyZSBwb3RlbnRpYWxseQ0K
PiA+ICsJICogbGFyZ2UgKH4xLzI1NnRoIG9mIHN5c3RlbSBSQU0pLCBqdXN0IHVzZSBXQklOVkQg
b24gYWxsIGNwdXMNCj4gPiArCSAqIHRvIGZsdXNoIHRoZSBjYWNoZS4NCj4gPiArCSAqLw0KPiA+
ICsJd2JpbnZkX29uX2FsbF9jcHVzKCk7DQo+ID4gKw0KPiA+ICsJLyogQ29uZmlnIHRoZSBrZXkg
b2YgZ2xvYmFsIEtleUlEIG9uIGFsbCBwYWNrYWdlcyAqLw0KPiA+ICsJcmV0ID0gY29uZmlnX2ds
b2JhbF9rZXlpZCgpOw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlnb3RvIG91dF9yZXNldF9wYW10
czsNCj4gPiArDQo+ID4gICAJLyoNCj4gPiAgIAkgKiBUT0RPOg0KPiA+ICAgCSAqDQo+ID4gLQkg
KiAgLSBDb25maWd1cmUgdGhlIGdsb2JhbCBLZXlJRCBvbiBhbGwgcGFja2FnZXMuDQo+ID4gICAJ
ICogIC0gSW5pdGlhbGl6ZSBhbGwgVERNUnMuDQo+ID4gICAJICoNCj4gPiAgIAkgKiAgUmV0dXJu
IGVycm9yIGJlZm9yZSBhbGwgc3RlcHMgYXJlIGRvbmUuDQo+ID4gICAJICovDQo+ID4gICAJcmV0
ID0gLUVJTlZBTDsNCj4gPiArb3V0X3Jlc2V0X3BhbXRzOg0KPiA+ICsJaWYgKHJldCkgew0KPiAN
Cj4gQWdhaW4gd2l0aCB0aG9zZSBjb25kaXRpb25hbHMgaW4gdGhlIGVycm9yIHBhdGhzLiBKdXN0
IGNvcHkgdGhlIA0KPiBwdXRfbWVtX29ubGluZSgpOyByZXQgMC4gYW5kIHRoaXMgd2lsbCBkZWNy
ZWFzZSB0aGUgaW5kZW50YXRpb24gbGV2ZWwgDQo+IGFuZCBtYWtlIHRoZSBjb2RlIGxpbmVhci4g
SGVyZTtzIHdoYXQgdGhlIGRpZmYgbG9va3MgbGlrZToNCg0KKHRvIHlvdXIgYW5vdGhlciByZXBs
eSB0b28pDQoNCkkgbm90aWNlZCB0aGlzIHRvbyB3aGVuIHByZXBhcmluZyB0aGlzIHNlcmllcy4g
IEluIG9sZCB2ZXJzaW9ucyB0aGUgVERNUnMgd2VyZQ0KYWx3YXlzIGZyZWVkIG5vIG1hdHRlciBt
b2R1bGUgaW5pdGlhbGl6YXRpb24gcmVzdWx0LCB0aHVzIGl0J3Mgbm90IGdvb2QgdG8gZG8NCndo
YXQgeW91IHN1Z2dlc3RlZC4gIE5vdyB3ZSBjYW4gZG8gd2hhdCB5b3Ugc3VnZ2VzdGVkIChhc3N1
bWluZyB3ZSBkb24ndCBjaGFuZ2UNCmJhY2sgdG8gYWx3YXlzIGZyZWVpbmcgVERNUnMpLCBJIGp1
c3Qgd2Fzbid0IHNvIHN1cmUgd2hlbiBJIHdhcyBwcmVwYXJpbmcgdGhpcw0Kc2VyaWVzLg0KDQpJ
J2xsIHRha2UgYSBsb29rIGF0IHRoZSB5aWVsZGluZyBwYXRjaGVzIHdpdGggeW91ciBzdWdnZXN0
aW9uLiAgVGhhbmtzLg0KDQpIaSBLaXJpbGwvRGF2ZSwNCg0KU2luY2UgSSBoYXZlIHJlY2VpdmVk
IGNvdXBsZSBvZiB0YWdzIGZyb20geW91LCBtYXkgSSBrbm93IHdoaWNoIHdheSBkbyB5b3UNCnBy
ZWZlcj8NCg0KPiANCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gaW5kZXggNGFhNDEzNTJlZGZjLi40
OWZkYTJhMjhmMjQgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0K
PiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gQEAgLTExMzEsNiArMTEzMSw4
IEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ICAgICAgICAgIGlmIChyZXQp
DQo+ICAgICAgICAgICAgICAgICAgZ290byBvdXRfZnJlZV9wYW10czsNCj4gDQo+ICsgICAgICAg
cHJfaW5mbygiJWx1IEtCcyBhbGxvY2F0ZWQgZm9yIFBBTVQuXG4iLA0KPiArICAgICAgICAgICAg
ICAgdGRtcnNfY291bnRfcGFtdF9wYWdlcygmdGR4X3RkbXJfbGlzdCkgKiA0KTsNCj4gICAgICAg
ICAgLyoNCj4gICAgICAgICAgICogSGFyZHdhcmUgZG9lc24ndCBndWFyYW50ZWUgY2FjaGUgY29o
ZXJlbmN5IGFjcm9zcyBkaWZmZXJlbnQNCj4gICAgICAgICAgICogS2V5SURzLiAgVGhlIGtlcm5l
bCBuZWVkcyB0byBmbHVzaCBQQU1UJ3MgZGlydHkgY2FjaGVsaW5lcw0KPiBAQCAtMTE0OCwzNiAr
MTE1MCwzMiBAQCBzdGF0aWMgaW50IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KPiANCj4gICAgICAg
ICAgLyogSW5pdGlhbGl6ZSBURE1ScyB0byBjb21wbGV0ZSB0aGUgVERYIG1vZHVsZSBpbml0aWFs
aXphdGlvbiAqLw0KPiAgICAgICAgICByZXQgPSBpbml0X3RkbXJzKCZ0ZHhfdGRtcl9saXN0KTsN
Cj4gKw0KPiArICAgICAgIHB1dF9vbmxpbmVfbWVtcygpOw0KPiArDQo+ICsgICAgICAgcmV0dXJu
IDA7DQo+ICAgb3V0X3Jlc2V0X3BhbXRzOg0KPiAtICAgICAgIGlmIChyZXQpIHsNCj4gLSAgICAg
ICAgICAgICAgIC8qDQo+IC0gICAgICAgICAgICAgICAgKiBQYXJ0IG9mIFBBTVRzIG1heSBhbHJl
YWR5IGhhdmUgYmVlbiBpbml0aWFsaXplZCBieSB0aGUNCj4gLSAgICAgICAgICAgICAgICAqIFRE
WCBtb2R1bGUuICBGbHVzaCBjYWNoZSBiZWZvcmUgcmV0dXJuaW5nIFBBTVRzIGJhY2sNCj4gLSAg
ICAgICAgICAgICAgICAqIHRvIHRoZSBrZXJuZWwuDQo+IC0gICAgICAgICAgICAgICAgKi8NCj4g
LSAgICAgICAgICAgICAgIHdiaW52ZF9vbl9hbGxfY3B1cygpOw0KPiAtICAgICAgICAgICAgICAg
LyoNCj4gLSAgICAgICAgICAgICAgICAqIEFjY29yZGluZyB0byB0aGUgVERYIGhhcmR3YXJlIHNw
ZWMsIGlmIHRoZSBwbGF0Zm9ybQ0KPiAtICAgICAgICAgICAgICAgICogZG9lc24ndCBoYXZlIHRo
ZSAicGFydGlhbCB3cml0ZSBtYWNoaW5lIGNoZWNrIg0KPiAtICAgICAgICAgICAgICAgICogZXJy
YXR1bSwgYW55IGtlcm5lbCByZWFkL3dyaXRlIHdpbGwgbmV2ZXIgY2F1c2UgI01DDQo+IC0gICAg
ICAgICAgICAgICAgKiBpbiBrZXJuZWwgc3BhY2UsIHRodXMgaXQncyBPSyB0byBub3QgY29udmVy
dCBQQU1Ucw0KPiAtICAgICAgICAgICAgICAgICogYmFjayB0byBub3JtYWwuICBCdXQgZG8gdGhl
IGNvbnZlcnNpb24gYW55d2F5IGhlcmUNCj4gLSAgICAgICAgICAgICAgICAqIGFzIHN1Z2dlc3Rl
ZCBieSB0aGUgVERYIHNwZWMuDQo+IC0gICAgICAgICAgICAgICAgKi8NCj4gLSAgICAgICAgICAg
ICAgIHRkbXJzX3Jlc2V0X3BhbXRfYWxsKCZ0ZHhfdGRtcl9saXN0KTsNCj4gLSAgICAgICB9DQo+
ICsgICAgICAgLyoNCj4gKyAgICAgICAgKiBQYXJ0IG9mIFBBTVRzIG1heSBhbHJlYWR5IGhhdmUg
YmVlbiBpbml0aWFsaXplZCBieSB0aGUNCj4gKyAgICAgICAgKiBURFggbW9kdWxlLiAgRmx1c2gg
Y2FjaGUgYmVmb3JlIHJldHVybmluZyBQQU1UcyBiYWNrDQo+ICsgICAgICAgICogdG8gdGhlIGtl
cm5lbC4NCj4gKyAgICAgICAgKi8NCj4gKyAgICAgICB3YmludmRfb25fYWxsX2NwdXMoKTsNCj4g
KyAgICAgICAvKg0KPiArICAgICAgICAqIEFjY29yZGluZyB0byB0aGUgVERYIGhhcmR3YXJlIHNw
ZWMsIGlmIHRoZSBwbGF0Zm9ybQ0KPiArICAgICAgICAqIGRvZXNuJ3QgaGF2ZSB0aGUgInBhcnRp
YWwgd3JpdGUgbWFjaGluZSBjaGVjayINCj4gKyAgICAgICAgKiBlcnJhdHVtLCBhbnkga2VybmVs
IHJlYWQvd3JpdGUgd2lsbCBuZXZlciBjYXVzZSAjTUMNCj4gKyAgICAgICAgKiBpbiBrZXJuZWwg
c3BhY2UsIHRodXMgaXQncyBPSyB0byBub3QgY29udmVydCBQQU1Ucw0KPiArICAgICAgICAqIGJh
Y2sgdG8gbm9ybWFsLiAgQnV0IGRvIHRoZSBjb252ZXJzaW9uIGFueXdheSBoZXJlDQo+ICsgICAg
ICAgICogYXMgc3VnZ2VzdGVkIGJ5IHRoZSBURFggc3BlYy4NCj4gKyAgICAgICAgKi8NCj4gKyAg
ICAgICB0ZG1yc19yZXNldF9wYW10X2FsbCgmdGR4X3RkbXJfbGlzdCk7DQo+ICAgb3V0X2ZyZWVf
cGFtdHM6DQo+IC0gICAgICAgaWYgKHJldCkNCj4gLSAgICAgICAgICAgICAgIHRkbXJzX2ZyZWVf
cGFtdF9hbGwoJnRkeF90ZG1yX2xpc3QpOw0KPiAtICAgICAgIGVsc2UNCj4gLSAgICAgICAgICAg
ICAgIHByX2luZm8oIiVsdSBLQnMgYWxsb2NhdGVkIGZvciBQQU1ULlxuIiwNCj4gLSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB0ZG1yc19jb3VudF9wYW10X3BhZ2VzKCZ0ZHhfdGRtcl9s
aXN0KSAqIDQpOw0KPiArICAgICAgIHRkbXJzX2ZyZWVfcGFtdF9hbGwoJnRkeF90ZG1yX2xpc3Qp
Ow0KPiAgIG91dF9mcmVlX3RkbXJzOg0KPiAtICAgICAgIGlmIChyZXQpDQo+IC0gICAgICAgICAg
ICAgICBmcmVlX3RkbXJfbGlzdCgmdGR4X3RkbXJfbGlzdCk7DQo+ICsgICAgICAgZnJlZV90ZG1y
X2xpc3QoJnRkeF90ZG1yX2xpc3QpOw0KPiAgIG91dF9mcmVlX3RkeF9tZW06DQo+IC0gICAgICAg
aWYgKHJldCkNCj4gLSAgICAgICAgICAgICAgIGZyZWVfdGR4X21lbWxpc3QoJnRkeF9tZW1saXN0
KTsNCj4gKyAgICAgICBmcmVlX3RkeF9tZW1saXN0KCZ0ZHhfbWVtbGlzdCk7DQo+ICAgb3V0Og0K
PiAgICAgICAgICAvKg0KPiAgICAgICAgICAgKiBAdGR4X21lbWxpc3QgaXMgd3JpdHRlbiBoZXJl
IGFuZCByZWFkIGF0IG1lbW9yeSBob3RwbHVnIHRpbWUuDQo+IA0KPiANCj4gPHNuaXA+DQoNCg==
