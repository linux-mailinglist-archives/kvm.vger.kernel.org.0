Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59E174240A
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 12:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbjF2Keo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 06:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjF2Kea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 06:34:30 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D972D3593;
        Thu, 29 Jun 2023 03:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688034841; x=1719570841;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CWAxUn759Exin+2i6l6Ff0pI3YQyzI1p5DavZJKYcJc=;
  b=TsAmXh9mF/+HHpmiazFmtrWPX/xx3aGdW3GRFe3AMP4qa/N3+aojXHuf
   opTl0USIcz/VXgh9ZXMQ2Ug7+aIwNyhy3jsi0DX68V4XyPrUTureySAF/
   dYWXThV/rckKu0zFB+wkKUkp+CytjshW03uJdFG2E6eSC/jXYPtVnubVj
   ilqQx5+FxmbeByYNb+iov3XjT653dnHPpNlWULp6dj1ZmHTfo/AXjNM5S
   dF4LDEIdGxoRilb6eaOnKgL3VfUasOu6CpBOFlz6mzpXMX5QQwRSD857V
   hEwidadFBla1tg4QOw0gDAYEfBzhwqJP1Zx6OvKIAytpWqjjYkogiZXXm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="360924924"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="360924924"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 03:34:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="711382758"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="711382758"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 29 Jun 2023 03:33:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 03:33:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 03:33:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 29 Jun 2023 03:33:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 29 Jun 2023 03:33:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkQzja+H7CfIhYJdx67K/cA/20SZGF2cCFFBBAh4MeaGFGtNiC4ustcHmo6qFHCf0tghlDUMJbgHXN9gOCMDVes6JESQ3lVqisnXxOOfLhvpnVQdg27cA5/gx053qwGv0kGfgjk06LPyvTxw3AFMwfUTqOUiODJu//grRSgbL7HmAXr+ZY8fmjUGwKkqEyT4tPsPcM9dVCEPxuyOrmhA2Ir4C1HB3eYMHor9f4ZLToIdWtnLxA9sESnUB8oHQXA8bmsto1JuayTuOipQ3OOxtUugcqdON5t3+iBLE/X9HubDyKxYrFPfPCu6sDqbPwUGgYE20/xo6RMZkmuVK/hy9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CWAxUn759Exin+2i6l6Ff0pI3YQyzI1p5DavZJKYcJc=;
 b=R3ArtlDl1rLhsJMm4mr+mn9M/ACeexZm98ymZjD4Q7yqz/3dFHJW9/WKaj9fTfrUFemoGSqqAdREbq/9t9cQsMIEiE7VbeHbdDJKgaMYwRwvzRnzNV3CYzECrsHyY2A2OjzwKb02bv3Vz11qmqmZAHxh32frY3ROK3GArIS2Eeymx5INa+F8AhNDscA9m2C9xks42hc0MsozUbBcJPpBZmoB+xuVde9VSYAo8XTX3blHPzQnX1tSKG/qZZkLeO91NmMfQB7ml5Yp0t9OQIYGmJHXbSQlstY6YqITjfG3AgAxuSgUKUvTeLhVj0zxqU6mabnpkH/BaCoeeQxOKHf3sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8070.namprd11.prod.outlook.com (2603:10b6:8:12d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Thu, 29 Jun
 2023 10:33:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 10:33:38 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Topic: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Index: AQHZqDW2iSvVOZI03kGK/IB0Vnjb6a+gWhoAgABWcYCAAOlagA==
Date:   Thu, 29 Jun 2023 10:33:38 +0000
Message-ID: <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
         <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
         <20230628203823.GR38236@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628203823.GR38236@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB8070:EE_
x-ms-office365-filtering-correlation-id: 8ce4f854-5f24-43c7-cbef-08db788c4cd6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p/y3EiwE0vEXgeVOBcm41cPCXPD7URgW4T41jJONl3dwVETyKweKV9l3B5pdAv1DXqazkILQufLq5VTsDZwHWlPIy1WmU7G10sodmiSwxZE0BIZKzXiOEtNszSNKeh7cRXzlef7bceV+2af9S75Aww8049CVyr6M0DWUuZ7frcg3i8eGPiKIADuGVdWKopNTDT1ppH27snfJNkjAy+bBQGnZtxKF0h73kRFBIwHbG/O0tQE3kypWl7BdCZbca/ye6ZsCgrgizcVEqERWgVEOOc/7qHsYF7gAcOV4Au8zpLuxdM2M22mvUdLIgWrX+AAe8QzTFUxzwxsqgrW9c4K4Sm1Om+Fh8sEEFJlyF/v5IuQNxC3DyV1UHf3ptMFZHMq2wBmuWIETYcIRQYpDl/vh21gGpreX9JGG5NW9MOZ8hPj9V9xRAMng9IYpMl95pJc5+cUakMJHivVrCgzNzz0HZqKiUU8iIW8fG2x2O3lkpouYMiSsk1IPZr8acd2gJ+2HEIGB8LUOHYsIhOuLuFFRY94sS4QwBR80KYIUdmA2bwnO6pCi7oCnL7jWl+YfCMip0Wvn+8Fpln2DvnVaEZOQ2JBHmqreM+vLi/W0ZWFZENo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(316002)(8676002)(66946007)(64756008)(66476007)(76116006)(6512007)(6506007)(66446008)(186003)(4326008)(26005)(6916009)(8936002)(6486002)(54906003)(71200400001)(41300700001)(966005)(66556008)(91956017)(5660300002)(7416002)(2906002)(2616005)(478600001)(38070700005)(82960400001)(38100700002)(122000001)(86362001)(36756003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjRJVno3UjVINFVxK2FoSzJnTXhFdEkwWnNLZEJ0K0VLUzQ3aUJDWHF4V2d0?=
 =?utf-8?B?cWs4VmRWL0ZwU2U3MWNQNm44bkxhbTdxWHFrRUdBdEc0aWtlMS91Y3cwTnkz?=
 =?utf-8?B?U3p3amJveXFIVS9xS2FVaFVDcm16d2NGWWg2SUx4dS9HcXFPMnpWVHg0VS9H?=
 =?utf-8?B?VkRmdUVwVS9sbkNaRGpCdWVsV241NE52TzRhaW9vdktDMENuNld1WVBzaVdj?=
 =?utf-8?B?ZUdZeGhwN055dFNNMGlZaXJwQXFHQlYwajZHakNHc3BwcjR1Y1BHenFlSDRX?=
 =?utf-8?B?bHFUcXIzaFJIdDVxSjR4Mkc0bmtpeFZCc1A4RFlJT2tGbkluQk9aUkxmRHBD?=
 =?utf-8?B?MWhkK05XWHdiMU9FNGNhemNJNzBhYVk3cUpqdjFmcldrRlJISUU4S3pNdUpp?=
 =?utf-8?B?YVc2MXd4M3dMNXVJMGpaRkNTUFgwN00zd3RVZVlBUHV3WHgzbmJxRmwzWGtR?=
 =?utf-8?B?MWExYlRkbnRhY3EycytMRHQwRVRSVUw0bTFzK0dvdnk5K2N0amI1Qi90V1pK?=
 =?utf-8?B?RWJEYzRxNURraFZ1MUFTSEt3M3NSWHBWOFdNV3pUT0xUNkg3R0cybG1WdTNI?=
 =?utf-8?B?SXI1RHZZN243THRlOTFBRDZnZFhVUk9lRjRwU1M2L3F3S09yeDFCTU9MT3p3?=
 =?utf-8?B?SjVsYjcyMGVrMWJlem5SS3AvNVhZR0xSYlNPc2EwczRZN2taOTRrK3dUNG5P?=
 =?utf-8?B?aVZBNm5pbXhGSjlxek4vVGZUKzYvN0kzdGtYemo3Q0hIYlNaWktucGlQdXNL?=
 =?utf-8?B?S0pwSEduOGdMWEJwQ0JGL1BEbFdvZFNNalk3NUUxa041SzR0aS9JdGxuYlZ3?=
 =?utf-8?B?Z1JFTGdxcG03MXNpc3haZG5NTUhnMjBJclN4Z0VWRlJ3S3ZHdncxQXJrYk04?=
 =?utf-8?B?aVlLamdFK3krUzA0UWVPUEpGcC9DeDhsclBsenpSVisyQ2l2UlZudkxBWHV5?=
 =?utf-8?B?eTNRRjRIR3gwU3VzVWh5eVdWUHo5aFFKSTFZWTJyV2o0WEJOVTIzQVNjVitE?=
 =?utf-8?B?a2s5eHJha0pGMk5oUzdieFZzT2Y1QTFxcE1zcHZHR0xMcFZBeG5rZUNVUThN?=
 =?utf-8?B?dWYzK3lZZS9uTVNCVmxBMTlDYmRjdkJkcXZKbHVFMUtPQllqUVkzYVVCS29Z?=
 =?utf-8?B?ZTh5UitERDZQcGlLcU1sblQybzUrZzI0V3VJMmsydVRRYlhBT3lkYlYwYVNO?=
 =?utf-8?B?c0dMT2RqQUxpSW1NVUI3b1pITEhScnNRYkVxQ2xyMkREbFFMdUlvSUE2bjRG?=
 =?utf-8?B?enlNY1VvQTRRWEk4OWlheW5SaTNlajk1cVhYVG85S0JUK2lSNldtTCtPWW1I?=
 =?utf-8?B?K0ZBNGNQemhQUEdJVEJQNlhscTlXakJ2TWo4YzZjcS9NblFrQnJWelZVclhr?=
 =?utf-8?B?KzUyKzMzZm9lN3hQM09NSUZGSklxZUZoMXpRUnc0TTU5dHhrSWdHUGhGSUow?=
 =?utf-8?B?Q3JMK1pkNmhLT3BhZnpUQy9ZeTNLdHNsV0dnQmhMZmN0RStyM3hlZ0pmbEJV?=
 =?utf-8?B?enUzdUxKTzdLYVhWOUVmOVJzaFFsL2k1TiszV3htUW50TEsxbTFsdUE2bExF?=
 =?utf-8?B?bVgzS2g2RXJQWlBMOXppYnNFNUdtY0xhelBYTSsyRmdVcTFuNzVmNklpbWZk?=
 =?utf-8?B?ek5hanpsaVRhandiYlY5S3RadjA5ajBxSHRRbTh6QjJ1YUloUkxDQngwV1hM?=
 =?utf-8?B?a2JxTTcrck1LL29OYnRqdDFpV2xrZVpNaUVBN0ZrTjlQQXQ2dWhMdDlJcndM?=
 =?utf-8?B?amRVRW1YU2pCQ0dFZ3RhNmNDa1lZcTc0UTA1c0pHU0JBNnJxdXZTbDRERzQ1?=
 =?utf-8?B?eUlKVU85RDl0cWg1VmhEcm5vSm9NMEExM0llL0JjQXo0eG9ndGxvMGFGaEtk?=
 =?utf-8?B?YllnamJNajl0cmtkQnhjZS83d1NWYVdjUWErUHZPZiszRndncll2WjZnbnhO?=
 =?utf-8?B?eTFlcTlIVmlHeG5ySjFnQ3A2N1VZdmNzWVdpWXRkOWc4RHgvYUU4TUcxbTZ1?=
 =?utf-8?B?OCtPTGZ0eHZGVlpvMUZ6c1duY09jT0k5WHVPVVVtZ3JFRVVNT1hPZjltU0ZM?=
 =?utf-8?B?Z3BWTUNzcFRpZmxlSlpaVE11enFQbU1lOVZzTzBidjBscWplT3B0bFFoa0U0?=
 =?utf-8?B?S1ZId003c0ZWTHByR3FpQW9rQ1NLNjUrQUVQcjY0QjUrYUZiVys3TjNLSVRm?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3CFAD0CE1E27E448D0CA60A5EDB5DBC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce4f854-5f24-43c7-cbef-08db788c4cd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 10:33:38.2871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ZV18B1oM5qXrZJ2ANPYdDVk8SAzMIeb8g/JY8z2JwQovoEMaWZv+bqtOgPB/WbLbgAEnndyZ2yWB17+wNXgGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8070
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDIyOjM4ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBKdW4gMjgsIDIwMjMgYXQgMDU6Mjk6MDFQTSArMDIwMCwgUGV0ZXIgWmlqbHN0
cmEgd3JvdGU6DQo+ID4gT24gVHVlLCBKdW4gMjcsIDIwMjMgYXQgMDI6MTI6NTBBTSArMTIwMCwg
S2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHhjYWxsLlMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4Y2FsbC5TDQo+ID4gPiBpbmRl
eCA0OWE1NDM1NmFlOTkuLjc1N2IwYzM0YmUxMCAxMDA2NDQNCj4gPiA+IC0tLSBhL2FyY2gveDg2
L3ZpcnQvdm14L3RkeC90ZHhjYWxsLlMNCj4gPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHhjYWxsLlMNCj4gPiA+IEBAIC0xLDYgKzEsNyBAQA0KPiA+ID4gIC8qIFNQRFgtTGljZW5z
ZS1JZGVudGlmaWVyOiBHUEwtMi4wICovDQo+ID4gPiAgI2luY2x1ZGUgPGFzbS9hc20tb2Zmc2V0
cy5oPg0KPiA+ID4gICNpbmNsdWRlIDxhc20vdGR4Lmg+DQo+ID4gPiArI2luY2x1ZGUgPGFzbS9h
c20uaD4NCj4gPiA+ICANCj4gPiA+ICAvKg0KPiA+ID4gICAqIFREQ0FMTCBhbmQgU0VBTUNBTEwg
YXJlIHN1cHBvcnRlZCBpbiBCaW51dGlscyA+PSAyLjM2Lg0KPiA+ID4gQEAgLTQ1LDYgKzQ2LDcg
QEANCj4gPiA+ICAJLyogTGVhdmUgaW5wdXQgcGFyYW0gMiBpbiBSRFggKi8NCj4gPiA+ICANCj4g
PiA+ICAJLmlmIFxob3N0DQo+ID4gPiArMToNCj4gPiA+ICAJc2VhbWNhbGwNCj4gPiANCj4gPiBT
byB3aGF0IHJlZ2lzdGVycyBhcmUgYWN0dWFsbHkgY2xvYmJlcmVkIGJ5IFNFQU1DQUxMID8gVGhl
cmUncyBhDQo+ID4gZGlzdGluY3QgbGFjayBvZiBpdCBpbiBTRE0gVm9sLjIgaW5zdHJ1Y3Rpb24g
bGlzdCA6LSgNCj4gDQo+IFdpdGggdGhlIGV4Y2VwdGlvbiBvZiB0aGUgYWJvbWluYXRpb24gdGhh
dCBpcyBUREguVlAuRU5URVIgYWxsIFNFQU1DQUxMcw0KPiBzZWVtIHRvIGJlIGxpbWl0ZWQgdG8g
dGhlIHNldCBwcmVzZW50ZWQgaGVyZSAoYyxkLDgsOSwxMCwxMSkgYW5kIGFsbA0KPiBvdGhlciBy
ZWdpc3RlcnMgc2hvdWxkIGJlIGF2YWlsYWJsZS4NCg0KUkFYIGlzIGFsc28gdXNlZCBhcyBTRUFN
Q0FMTCByZXR1cm4gY29kZS4NCg0KTG9va2luZyBhdCB0aGUgbGF0ZXIgdmVyc2lvbnMgb2YgVERY
IHNwZWMgKHdpdGggVEQgbGl2ZSBtaWdyYXRpb24sIGV0YyksIGl0DQpzZWVtcyB0aGV5IGFyZSBh
bHJlYWR5IHVzaW5nIFIxMi1SMTMgYXMgU0VBTUNBTEwgb3V0cHV0Og0KDQpodHRwczovL2NkcmR2
Mi5pbnRlbC5jb20vdjEvZGwvZ2V0Q29udGVudC83MzM1NzkNCg0KRS5nLiwgNi4zLjE1LiBORVc6
IFRESC5JTVBPUlQuTUVNIExlYWYNCg0KSXQgdXNlcyBSMTIgYW5kIFIxMyBhcyBpbnB1dC4NCg0K
PiANCj4gQ2FuIHdlIHBsZWFzZSBtYWtlIHRoYXQgYSBoYXJkIHJlcXVpcmVtZW50LCBTRUFNQ0FM
TCBtdXN0IG5vdCB1c2UNCj4gcmVnaXN0ZXJzIG91dHNpZGUgdGhpcz8gV2UgY2FuIGhhcmRseSBw
cm9ncmFtIHRvIHJhbmRvbSBmdXR1cmUNCj4gZXh0ZW50aW9uczsgd2UgbmVlZCBoYXJkIEFCSSBn
dWFyYW50ZWVzIGhlcmUuDQoNCg0KSSBiZWxpZXZlIGFsbCBvdGhlciBHUFJzIGFyZSBqdXN0IHNh
dmVkL3Jlc3RvcmVkIGluIFNFQU1DQUxML1NFQU1SRVQsIHNvIGluDQpwcmFjdGljZSBhbGwgb3Ro
ZXIgR1BScyBub3QgdXNlZCBhcyBpbnB1dC9vdXRwdXQgc2hvdWxkIG5vdCBiZSBjbG9iYmVyZWQu
ICBCdXQgSQ0Kd2lsbCBjb25maXJtIHdpdGggVERYIG1vZHVsZSBndXlzLiAgQW5kIGV2ZW4gaXQn
cyB0cnVlIGluIHByYWN0aWNlIGl0J3MgYmV0dGVyDQp0byBkb2N1bWVudCBpdC4gIA0KDQpCdXQg
SSB0aGluayB3ZSBhbHNvIHdhbnQgdG8gYXNrIHRoZW0gdG8gc3RvcCBhZGRpbmcgbW9yZSByZWdp
c3RlcnMgYXMNCmlucHV0L291dHB1dC4NCg0KSSdsbCB0YWxrIHRvIFREWCBtb2R1bGUgdGVhbSBv
biB0aGlzLg0KDQo+IA0KPiBUaGF0IGFsc28gbWVhbnMgd2Ugc2hvdWxkIGJlIGFibGUgdG8gdXNl
IHNpLGRpIGZvciB0aGUgY21vdmMgYmVsb3cuDQo+IA0KPiBLaXJpbGwsIGJhY2sgd2hlbiB3ZSBk
aWQgX190ZHhfaHlwZXJjYWxsKCkgd2UgZ290IGJwIHJlbW92ZWQgYXMgYSB2YWxpZA0KPiByZWdp
c3RlciwgdGhlIDEuMCBzcGVjIHN0aWxsIGxpc3RzIHRoYXQsIGFuZCBpdCBpcyBhbHNvIGxpc3Rl
ZCBpbg0KPiBUREguVlAuRU5URVIsIEknbSBhc3N1bWluZyBpdCB3aWxsIGJlIHJlbW92ZWQgdGhl
cmUgdG9vPw0KPiANCj4gYnAgbXVzdCBub3QgYmUgdXNlZCAtLSBpdCB2aW9sYXRlcyB0aGUgcHJl
LWV4aXN0aW5nIGNhbGxpbmcgY29udmVudGlvbi4NCj4gDQo+IA0KDQo=
