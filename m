Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084A4663F3E
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 12:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbjAJLaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 06:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjAJL36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 06:29:58 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83782482B9;
        Tue, 10 Jan 2023 03:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673350195; x=1704886195;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tXwrGbx2pGcwuA5UcjPmqLlYRdlvGu9Q0F7Kv4pbqHg=;
  b=iNyWerF0zIgmXYp0Mx3eur60I7IsKtR8i99xqgGq2HcxJdxCRYqn1DKA
   2EhzsII4ftzFUfrqOZ5yasiIaFrxSsH2ZbmkNKuj/R2qtazHpgVAv7nqz
   Hn8GMb1+1Nb25DpooIt83dRwt9QTYbE8yeurJoFVrqgzZdSwVKjHVPLj4
   J5fmUU4JosPjFqmsKs56GIEMH3ACcHSMWkIwy8qz8XfiTS2qufBViWwRt
   Elrq1ZtuMllKNulbV1iIOPYyccgnrU4/gF6Fv3Kd5edoDRNAkt/lIAeFK
   7IquvIaYKcyB32kEYrNOl/ANWwr2GWJ6z6NFyOoCGNyiF1YMarg1AbWq3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="320814277"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="320814277"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 03:29:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="606932069"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="606932069"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 10 Jan 2023 03:29:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 03:29:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 03:29:54 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 03:29:54 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 03:29:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUBk8baSUYaRm8aQ2FzL4U8LKFXPaUt5YUDtpwvg3RR/uKWncstyjO3PCEYOBnc/fyFyYtoLwGmWImgoYNga/0ehBGOZ3xkpymyTNvj+UPSifI+vwggoqEd7ZPuQdmI7yPUehWd+DV0lEXdynEm+DJYVyvjee3YSA8VKQftTDfSEe0hKs456JRe/poUvPrEh4MpIAAjnyrWSnbzBRy35YMo2P4SgMkCqdOb4jRJicN+SPGI3FmreoyECIfkJMfNKvAgCz2GCeZEh8HRGlH0aQS6unjwquRCJzHmkbpH0yYkOtHGMPB34QAADObEfw26poTFTEJ1Uc/U0uWv6nb/Lig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXwrGbx2pGcwuA5UcjPmqLlYRdlvGu9Q0F7Kv4pbqHg=;
 b=TBrP6ZTHaqiuZFX+xJVfXTj3flKMIZ7KbhbRxYllpJEszfbKauVkFLlN7LeLjdOZSmEmroLoJLfV0oTHjtqMzOvDsR1SEsHsICii75RbQLPRYIfa5m2QHyVTJpaG2fQhs6SPlKnYwlE/1RuDF4knTvGWMEQzMZtVLSRapQXhVTsyWdB33gV8nu/nwxjih/H3ehHuUq+zYH6llDXPvD6Dg03QXO9QTYTERWu2XB8W+7KerIEaf8gjSDjwIaChkDIFSBrVndGeXGYOs8Rblz63aESubfYZNRhzci1em07Qi9i160DzzgepHvw6Zl/eMx204/cMfIUv/0wcuRDFrxZFPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM8PR11MB5688.namprd11.prod.outlook.com (2603:10b6:8:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 11:29:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 11:29:49 +0000
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
        "tglx@linutronix.de" <tglx@linutronix.de>,
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
Subject: Re: [PATCH v8 15/16] x86/virt/tdx: Flush cache in kexec() when TDX is
 enabled
Thread-Topic: [PATCH v8 15/16] x86/virt/tdx: Flush cache in kexec() when TDX
 is enabled
Thread-Index: AQHZC5gL930dln/hIEKzIGHp1lCBha6SSMqAgAVttoA=
Date:   Tue, 10 Jan 2023 11:29:49 +0000
Message-ID: <6f959f494f0fb3dedfa963c3d6a0ce7f395b745d.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <ee5185e1727c3cd8bd51dbf9fcec95d432100d12.1670566861.git.kai.huang@intel.com>
         <ba0fdee9-148b-b0b9-ecde-2610eff02ba1@intel.com>
In-Reply-To: <ba0fdee9-148b-b0b9-ecde-2610eff02ba1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM8PR11MB5688:EE_
x-ms-office365-filtering-correlation-id: a2fc504e-54b5-485a-a9b5-08daf2fdfbd4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O+iTe1GrquP6opftedKmvZDjJoxbQiH9iHAZPFEh3F8zjAUi6at8c7mNoudhNwyvwzktOaHO139E2mqXwPcmpRTiin6cKbAscmcUQCScGRfth97f408qSE2iCKctUQb6EwpHOJHZaypHbkX+4Rarebpq6dGm4yD8o4O1obKnjIwJlhNDH/mYFhqzvUzhRfFaGaDwnyGYjfyn8viZahQBanHmTDFEeIA/Lm74VPXlNor4yhEhtjWgKgAopqe+SKsYNx1bLKhkk1PXVaX6dcaz1++IThVQ/2/OxRnLTq05Qea+nJVgf74NtjU+SR2qE+a+eiUmMsCj9xbd0AalbRMLQ3utPzsSuwJgzQEZY8yrXQnZL4k/EhupVwb8X4mFCfxFL0KdKpqAFm76nNyqRv25AM/YsweGNvqPcZpCPOOwYWBuzsheokVDuLi0KyeRDJ+ZqgTuHlwTKEQRnwV2RbNyrci/35EiSlCVITiaP5OjJxK3HIgHQzqUg8v+WysOzChgYdTmrFcccdAgEItn6oASfg7OvFF6HUse4UJ3Sv+XnJnOUzkqSQ+SeJnliwL3KAgevLhkiplDT3LL2GEZRNKMv7ZH9PVSHSmbCbJrMeVmWer9PKIzFTKOprnDLtvngYUBKrUTAO/+2jNJAcXHUzTKPqRk8hcNzkrfIIdx5/bHDrxF8il+bWCuKLlRMxXDg8GIX4xcSr09mMYMrC8A/3+d2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(41300700001)(4326008)(2616005)(110136005)(316002)(76116006)(8676002)(66946007)(66446008)(66556008)(36756003)(64756008)(54906003)(66476007)(91956017)(86362001)(38070700005)(8936002)(82960400001)(122000001)(38100700002)(5660300002)(83380400001)(7416002)(2906002)(66899015)(6506007)(71200400001)(53546011)(6486002)(26005)(6512007)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0FzQXV4V2NHRXdGbmltZWdKL3EwTGkyNHhPbXZIdS9uQkdOQnFqRlByYVdT?=
 =?utf-8?B?Nkk2ZTQ2WE10VCswMEdYTGdMVmp6NG0vbkMzL0NuelA1R2U4LzN2SHhURk0x?=
 =?utf-8?B?bldreWVBK1ZIVmtkUGJMYVFjKzJwQmFkSFFYamlaVnNFNlNObWJtN3FlYy90?=
 =?utf-8?B?UldnZTZDbUF2S2Q1OWlDamxGRzNlV2xCSWNJSWpsMnZNeHgzZlVjalNBYkR6?=
 =?utf-8?B?S20reDVCVkpRMUxuU0JoZ0hHU0cyRjIwTG5HYXZMOGdoUmM2QitzVXp0SDFi?=
 =?utf-8?B?d1JaeWhsRFZsdGdmZTVrcjRyZzgrZ3F0VDd0dmdTYmJYTXhJUCtZcXRZUXlX?=
 =?utf-8?B?TW9BYmkwVmFKYUprYitkYVVhbS9LZWtBVithaWc5V2Y0V2FNRTN6dFl0SU1L?=
 =?utf-8?B?cXJnTTdnYmQwWUV3dXhIZmtNbENDc2ZhaGFPVUJ5a1Z6cXhnMDFhQ3VuRFRp?=
 =?utf-8?B?NmZTS1krRGh3N1dKQXJqY21oNWQ4c2loVWFYWjVqZGdxbjhxcHRjUWVYVWVO?=
 =?utf-8?B?SytQemxNWERPMm51VlUzSEViWERWVVo2QUg3WDgvSnBCZU8zaHpNZktBcis4?=
 =?utf-8?B?NjhSK0tkR1hBa1hmYlRVNkJEZUtaL3NIbXRVMDJGZ0IrNW5YektNbDVCMVU2?=
 =?utf-8?B?akQ3VGdtTE84cVd2L0lrRk16ejNsT0k3VEFpclBoSmQveVhDbWdxU3M4dDVo?=
 =?utf-8?B?UGl0ZG8zalNTK0M0blFsRis5VTIxOUhOdUFiVWhyTkJXUm4xNFdsaXhWc09N?=
 =?utf-8?B?NFJpTFd4NlZ1U1dlVDhpNFU3cTBabVVvckFPT1Q5R1ByTzdWV3JDbHNnNlhw?=
 =?utf-8?B?N1ZzK1lmL2p1N2xHdnhjUENDMGw5NGJyUUd3bG9JWFlSTEFuVXFnVlFwOC9T?=
 =?utf-8?B?UHlwc0t6T1E3d3dGYmdVUlJXWnlyWmp6MmtHR0RJMVMrTzExbEx6SE9PelY1?=
 =?utf-8?B?NkV4ZSsyREQwa21UVXNpMXJRU3VZWjYyTGQ3b1VRendCQmt1TmtNS1c4WUp1?=
 =?utf-8?B?T3MzVG9kMkRBblh5M1ZzSXZmc2I3ckVmTVRMS2o2VG5kTE11TTgvZHFPR1RD?=
 =?utf-8?B?RVErdXE2enFLKzFDTG5YNklkOEV5MFk2MkFvTnJyeDI0UlQxRnRzd2xmZTdT?=
 =?utf-8?B?cFMyam5WOU5ERGYzaEwvUS9JMFJodG9PbkFCSXdNZEU1eEdnYk15eUhaaFM4?=
 =?utf-8?B?SzdzdFU1dGJ5NDRPV2RDRDg2VXl4T3N5SkhHQTM2UWFTWERIU3NUQXBzSHNX?=
 =?utf-8?B?cTRmdXk3ZzQzdmt3R2NqWVhBUWZVNmRpNlZqSHJlaU8yZXlPNUVSYVBSNkVx?=
 =?utf-8?B?bDQ1VlZLdm8zZHRSa2k0SUIxYzMwcitMNWl6ZGVhVHorby9pRmpZMTQ5MHFW?=
 =?utf-8?B?bEw3QnRTYkl4cHAzRTdZYkdLWk12TzFBa1cvK3Z2VlpRbzdobS9zcHYrb0M2?=
 =?utf-8?B?NWRCbDU0L1V2SWJjR3VjRFVKeUVrU2ltZjJtaVFRNWl6SkxNa0xySENDTm5y?=
 =?utf-8?B?YWFJd3dMUWF2UXgrOEdXTVNGRWFTaG5NalpGbFBSSHorVDF4WDdFbjRHVEo1?=
 =?utf-8?B?RSsxMnhNQUljUytiZWN6bFptdXBXelN4TGQxbFBkdzFxV0RpSmZVTVo3bklR?=
 =?utf-8?B?UjAzQ3VGYVBMc1JGK01tcGxqQjFZYUx3ajM3UzhSYlNLNCtMU1BxM2ZGcUND?=
 =?utf-8?B?dWdvNElMVzZUMEI5N2FRSS96WW1zclNTL2RBN2Z5VlBLbFB6cmFwODl3Y3g5?=
 =?utf-8?B?QVdhR3FkajNZNnR6VmxUYmVWcDBwcUtkSnUzYlpNazVLN3RQUEUzRUVpNmsr?=
 =?utf-8?B?a0Y1bXRITTNDbHRUUTQ0c3FVNTkwTzBrTzdsdHc2ZTNwWDNwZmtTZnZxS1Rl?=
 =?utf-8?B?QU5mS1JnREdKTDVWVUR4Z3ErN2h0M3dmcVF5cnNDYnVwVFM0a3ZSZHRCZXVI?=
 =?utf-8?B?T0p3K1B0WWZvVmZlenRncG9pK2RDaWs2aW5sd1NHT0tqL2dnNENYNEF2enk2?=
 =?utf-8?B?MGdwN2prUjJhWlFKd3UzNHZ4UVJHbktXNldDTzZNUDNpclZPV1RXeTVOdHl2?=
 =?utf-8?B?U0RSM2d4NTdvbHlLTW9zNGtwTzdGUjJJK0JFV0JvUy9STTNodUVGODN2Tytm?=
 =?utf-8?B?VUZXcjdFTFkxcmRFMnRyckM1NEhVOUxkU3YvaVplWUhrWHJoQTZuVGJUVzRi?=
 =?utf-8?B?V1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <617F4FF3A7309A489B862D5458B18E6B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2fc504e-54b5-485a-a9b5-08daf2fdfbd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 11:29:49.1387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VEqjBIkw9dgsKXkKh+otnKVGxtpisPGXCL8ap66dufjZqgLNa69TtZW4ei+trpVIoPfPthNx7VEuIrFLQuKLkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5688
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDE2OjM1IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAyMjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IFRoZXJlIGFyZSB0d28gcHJv
YmxlbXMgaW4gdGVybXMgb2YgdXNpbmcga2V4ZWMoKSB0byBib290IHRvIGEgbmV3IGtlcm5lbA0K
PiA+IHdoZW4gdGhlIG9sZCBrZXJuZWwgaGFzIGVuYWJsZWQgVERYOiAxKSBQYXJ0IG9mIHRoZSBt
ZW1vcnkgcGFnZXMgYXJlDQo+ID4gc3RpbGwgVERYIHByaXZhdGUgcGFnZXMgKGkuZS4gbWV0YWRh
dGEgdXNlZCBieSB0aGUgVERYIG1vZHVsZSwgYW5kIGFueQ0KPiA+IFREWCBndWVzdCBtZW1vcnkg
aWYga2V4ZWMoKSBoYXBwZW5zIHdoZW4gdGhlcmUncyBhbnkgVERYIGd1ZXN0IGFsaXZlKS4NCj4g
PiAyKSBUaGVyZSBtaWdodCBiZSBkaXJ0eSBjYWNoZWxpbmVzIGFzc29jaWF0ZWQgd2l0aCBURFgg
cHJpdmF0ZSBwYWdlcy4NCj4gPiANCj4gPiBCZWNhdXNlIHRoZSBoYXJkd2FyZSBkb2Vzbid0IGd1
YXJhbnRlZSBjYWNoZSBjb2hlcmVuY3kgYW1vbmcgZGlmZmVyZW50DQo+ID4gS2V5SURzLCB0aGUg
b2xkIGtlcm5lbCBuZWVkcyB0byBmbHVzaCBjYWNoZSAob2YgdGhvc2UgVERYIHByaXZhdGUgcGFn
ZXMpDQo+ID4gYmVmb3JlIGJvb3RpbmcgdG8gdGhlIG5ldyBrZXJuZWwuICBBbHNvLCByZWFkaW5n
IFREWCBwcml2YXRlIHBhZ2UgdXNpbmcNCj4gPiBhbnkgc2hhcmVkIG5vbi1URFggS2V5SUQgd2l0
aCBpbnRlZ3JpdHktY2hlY2sgZW5hYmxlZCBjYW4gdHJpZ2dlciAjTUMuDQo+ID4gVGhlcmVmb3Jl
IGlkZWFsbHksIHRoZSBrZXJuZWwgc2hvdWxkIGNvbnZlcnQgYWxsIFREWCBwcml2YXRlIHBhZ2Vz
IGJhY2sNCj4gPiB0byBub3JtYWwgYmVmb3JlIGJvb3RpbmcgdG8gdGhlIG5ldyBrZXJuZWwuDQo+
IA0KPiBUaGlzIGlzIGp1c3QgdGFsa2luZyBhYm91dCB3YXkgdG9vIG1hbnkgdGhpbmdzIHRoYXQg
anVzdCBkb24ndCBhcHBseS4NCj4gDQo+IExldCdzIGZvY3VzIG9uIHRoZSAqQUNUVUFMKiBwcm9i
bGVtIHRoYXQncyBiZWluZyBhZGRyZXNzZWQgaW5zdGVhZCBvZg0KPiB0aGUgMTUgcHJvYmxlbXMg
dGhhdCBhcmVuJ3QgYWN0dWFsIHByYWN0aWNhbCBwcm9ibGVtcy4NCg0KV2lsbCBnZXQgcmlkIG9m
IHRob3NlLg0KDQo+IA0KPiA+IEhvd2V2ZXIsIHRoaXMgaW1wbGVtZW50YXRpb24gZG9lc24ndCBj
b252ZXJ0IFREWCBwcml2YXRlIHBhZ2VzIGJhY2sgdG8NCj4gPiBub3JtYWwgaW4ga2V4ZWMoKSBi
ZWNhdXNlIG9mIGJlbG93IGNvbnNpZGVyYXRpb25zOg0KPiA+IA0KPiA+IDEpIE5laXRoZXIgdGhl
IGtlcm5lbCBub3IgdGhlIFREWCBtb2R1bGUgaGFzIGV4aXN0aW5nIGluZnJhc3RydWN0dXJlIHRv
DQo+ID4gICAgdHJhY2sgd2hpY2ggcGFnZXMgYXJlIFREWCBwcml2YXRlIHBhZ2VzLg0KPiA+IDIp
IFRoZSBudW1iZXIgb2YgVERYIHByaXZhdGUgcGFnZXMgY2FuIGJlIGxhcmdlLCBhbmQgY29udmVy
dGluZyBhbGwgb2YNCj4gPiAgICB0aGVtIChjYWNoZSBmbHVzaCArIHVzaW5nIE1PVkRJUjY0QiB0
byBjbGVhciB0aGUgcGFnZSkgaW4ga2V4ZWMoKSBjYW4NCj4gPiAgICBiZSB0aW1lIGNvbnN1bWlu
Zy4NCj4gPiAzKSBUaGUgbmV3IGtlcm5lbCB3aWxsIGFsbW9zdCBvbmx5IHVzZSBLZXlJRCAwIHRv
IGFjY2VzcyBtZW1vcnkuICBLZXlJRA0KPiA+ICAgIDAgZG9lc24ndCBzdXBwb3J0IGludGVncml0
eS1jaGVjaywgc28gaXQncyBPSy4NCj4gPiA0KSBUaGUga2VybmVsIGRvZXNuJ3QgKGFuZCBtYXkg
bmV2ZXIpIHN1cHBvcnQgTUtUTUUuICBJZiBhbnkgM3JkIHBhcnR5DQo+ID4gICAga2VybmVsIGV2
ZXIgc3VwcG9ydHMgTUtUTUUsIGl0IGNhbi9zaG91bGQgZG8gTU9WRElSNjRCIHRvIGNsZWFyIHRo
ZQ0KPiA+ICAgIHBhZ2Ugd2l0aCB0aGUgbmV3IE1LVE1FIEtleUlEIChqdXN0IGxpa2UgVERYIGRv
ZXMpIGJlZm9yZSB1c2luZyBpdC4NCj4gDQo+IFllYWgsIHdoeSBhcmUgd2UgZ2V0dGluZyBhbGwg
d29ya2VkIHVwIGFib3V0IE1LVE1FIHdoZW4gdGhlcmUgaXMgbm90DQo+IHN1cHBvcnQ/DQoNCkkg
YW0gbm90IHN1cmUgd2hldGhlciB3ZSBuZWVkIHRvIGNvbnNpZGVyIDNyZCBwYXJ0eSBrZXJuZWwg
Y2FzZT8NCg0KPiANCj4gVGhlIG9ubHkgdGhpbmcgdGhhdCBtYXR0ZXJzIGhlcmUgaXMgZGlydHkg
Y2FjaGVsaW5lIHdyaXRlYmFjay4gIFRoZXJlDQo+IGFyZSB0d28gdGhpbmdzIHRoZSBrZXJuZWwg
bmVlZHMgdG8gZG8gdG8gbWl0aWdhdGUgdGhhdDoNCj4gDQo+ICAxLiBTdG9wIGFjY2Vzc2luZyBU
RFggcHJpdmF0ZSBtZW1vcnkgbWFwcGluZ3MNCj4gICAxYS4gU3RvcCBtYWtpbmcgVERYIG1vZHVs
ZSBjYWxscyAodXNlcyBnbG9iYWwgcHJpdmF0ZSBLZXlJRCkNCj4gICAxYi4gU3RvcCBURFggZ3Vl
c3RzIGZyb20gcnVubmluZyAodXNlcyBwZXItZ3Vlc3QgS2V5SUQpDQo+ICAyLiBGbHVzaCBhbnkg
Y2FjaGVsaW5lcyBmcm9tIHByZXZpb3VzIHByaXZhdGUgS2V5SUQgd3JpdGVzDQo+IA0KPiBUaGVy
ZSBhcmUgYSBjb3VwbGUgb2Ygd2F5cyB3ZSBjYW4gZG8gIzIuICBXZSBkbyAqTk9UKiBuZWVkIHRv
IGNvbnZlcnQNCj4gKkFOWVRISU5HKiBiYWNrIHRvIEtleUlEIDAuICBQYWdlIGNvbnZlcnNpb24g
ZG9lc24ndCBldmVuIGNvbWUgaW50byBwbGF5DQo+IGluIGFueSB3YXkgYXMgZmFyIGFzIEkgY2Fu
IHRlbGwuDQoNCk1heSBJIGFzayB3aHk/ICBXaGVuIEkgd2FzIHdyaXRpbmcgdGhpcyBwYXRjaCBJ
IHdhcyBub3Qgc3VyZSB3aGV0aGVyIGtleGVjKCkNCnNob3VsZCBnaXZlIHRoZSBuZXcga2VybmVs
IGEgY2xlYW4gc2xhdGUuICBTR1ggZHJpdmVyIGRvZXNuJ3QgRVJFTU9WRSBhbGwgRVBDDQpkdXJp
bmcga2V4ZWMoKSBidXQgZGVwZW5kcyBvbiB0aGUgbmV3IGtlcm5lbCB0byBkbyB0aGF0IHRvbywg
YnV0IEkgZG9uJ3Qga25vdw0Kd2hhdCdzIHRoZSBnZW5lcmFsIGd1aWRlIG9mIHN1cHBvcnRpbmcg
a2V4ZWMoKS4NCg0KPiANCj4gSSB0aGluayB5b3UncmUgYWxzbyBzYXlpbmcgdGhhdCBzaW5jZSBh
bGwgQ1BVcyBnbyB0aHJvdWdoIHRoaXMgcGF0aCBhbmQNCj4gdGhlcmUgaXMgbm8gVERYIGFjdGl2
aXR5IGJldHdlZW4gdGhlIFdCSU5WRCBhbmQgdGhlIG5hdGl2ZV9oYWx0KCkgdGhhdA0KPiAxYSBh
bmQgMWIgYmFzaWNhbGx5IGhhcHBlbiBmb3IgImZyZWUiIHdpdGhvdXQgbmVlZGluZyB0byBkbyB0
aGVtZQ0KPiBleHBsaWNpdGx5Lg0KDQpZZXMuICBTaG91bGQgd2UgbWVudGlvbiB0aGlzIHBhcnQg
aW4gY2hhbmdlbG9nPw0KDQpBTUQgU01FIGtleGVjKCkgc3VwcG9ydCBwYXRjaCBiYmE0ZWQwMTFh
NTJkICgieDg2L21tLCBrZXhlYzogQWxsb3cga2V4ZWMgdG8gYmUNCnVzZWQgd2l0aCBTTUUiKSBz
ZWVtcyBkb2Vzbid0IG1lbnRpb24gYW55dGhpbmcgc2ltaWxhciAoU01FIGFuZCBURFggbWF5IGJl
DQpkaWZmZXJlbnQsIHRob3VnaCkuDQoNCj4gDQo+ID4gVGhlcmVmb3JlLCB0aGlzIGltcGxlbWVu
dGF0aW9uIGp1c3QgZmx1c2hlcyBjYWNoZSB0byBtYWtlIHN1cmUgdGhlcmUgYXJlDQo+ID4gbm8g
c3RhbGUgZGlydHkgY2FjaGVsaW5lcyBhc3NvY2lhdGVkIHdpdGggYW55IFREWCBwcml2YXRlIEtl
eUlEcyBiZWZvcmUNCj4gPiBib290aW5nIHRvIHRoZSBuZXcga2VybmVsLCBvdGhlcndpc2UgdGhl
eSBtYXkgc2lsZW50bHkgY29ycnVwdCB0aGUgbmV3DQo+ID4ga2VybmVsLg0KPiANCj4gVGhhdCdz
IGZpbmUuICBTbywgdGhpcyBwYXRjaCBraW5kYSBoYXBwZW5zIHRvIGxhbmQgaW4gdGhlIHJpZ2h0
IHNwb3QNCj4gZXZlbiBhZnRlciB0aHJhc2hpbmcgYWJvdXQgYWJvdXQgYSB3aGlsZS4NCj4gDQo+
ID4gRm9sbG93aW5nIFNNRSBzdXBwb3J0LCB1c2Ugd2JpbnZkKCkgdG8gZmx1c2ggY2FjaGUgaW4g
c3RvcF90aGlzX2NwdSgpLg0KPiA+IFRoZW9yZXRpY2FsbHksIGNhY2hlIGZsdXNoIGlzIG9ubHkg
bmVlZGVkIHdoZW4gdGhlIFREWCBtb2R1bGUgaGFzIGJlZW4NCj4gPiBpbml0aWFsaXplZC4gIEhv
d2V2ZXIgaW5pdGlhbGl6aW5nIHRoZSBURFggbW9kdWxlIGlzIGRvbmUgb24gZGVtYW5kIGF0DQo+
ID4gcnVudGltZSwgYW5kIGl0IHRha2VzIGEgbXV0ZXggdG8gcmVhZCB0aGUgbW9kdWxlIHN0YXR1
cy4gIEp1c3QgY2hlY2sNCj4gPiB3aGV0aGVyIFREWCBpcyBlbmFibGVkIGJ5IEJJT1MgaW5zdGVh
ZCB0byBmbHVzaCBjYWNoZS4NCj4gDQo+IFllYWgsIGNsb3NlIGVub3VnaC4NCj4gDQo+ID4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9wcm9jZXNzLmMgYi9hcmNoL3g4Ni9rZXJuZWwvcHJv
Y2Vzcy5jDQo+ID4gaW5kZXggYzIxYjczNDdhMjZkLi4wY2M4NDk3N2RjNjIgMTAwNjQ0DQo+ID4g
LS0tIGEvYXJjaC94ODYva2VybmVsL3Byb2Nlc3MuYw0KPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5l
bC9wcm9jZXNzLmMNCj4gPiBAQCAtNzY1LDggKzc2NSwxNCBAQCB2b2lkIF9fbm9yZXR1cm4gc3Rv
cF90aGlzX2NwdSh2b2lkICpkdW1teSkNCj4gPiAgCSAqDQo+ID4gIAkgKiBUZXN0IHRoZSBDUFVJ
RCBiaXQgZGlyZWN0bHkgYmVjYXVzZSB0aGUgbWFjaGluZSBtaWdodCd2ZSBjbGVhcmVkDQo+ID4g
IAkgKiBYODZfRkVBVFVSRV9TTUUgZHVlIHRvIGNtZGxpbmUgb3B0aW9ucy4NCj4gPiArCSAqDQo+
ID4gKwkgKiBTaW1pbGFyIHRvIFNNRSwgaWYgdGhlIFREWCBtb2R1bGUgaXMgZXZlciBpbml0aWFs
aXplZCwgdGhlDQo+ID4gKwkgKiBjYWNoZWxpbmVzIGFzc29jaWF0ZWQgd2l0aCBhbnkgVERYIHBy
aXZhdGUgS2V5SUQgbXVzdCBiZSBmbHVzaGVkDQo+ID4gKwkgKiBiZWZvcmUgdHJhbnNpdGluZyB0
byB0aGUgbmV3IGtlcm5lbC4gIFRoZSBURFggbW9kdWxlIGlzIGluaXRpYWxpemVkDQo+ID4gKwkg
KiBvbiBkZW1hbmQsIGFuZCBpdCB0YWtlcyB0aGUgbXV0ZXggdG8gcmVhZCBpdHMgc3RhdHVzLiAg
SnVzdCBjaGVjaw0KPiA+ICsJICogd2hldGhlciBURFggaXMgZW5hYmxlZCBieSBCSU9TIGluc3Rl
YWQgdG8gZmx1c2ggY2FjaGUuDQo+ID4gIAkgKi8NCj4gDQo+IFRoZXJlJ3MgdG9vIG11Y2ggZGV0
YWlsIGhlcmUuICBMZXQncyB1cC1sZXZlbCBpdCBhIGJpdC4gIFdlIGRvbid0IG5lZWQNCj4gdG8g
YmUgdGFsa2luZyBhYm91dCBURFggbG9ja2luZyBoZXJlLg0KDQpTdXJlIHdpbGwgZG8uICBUaGFu
a3MhDQo+IA0KPiAJLyoNCj4gCSAqIFRoZSBURFggbW9kdWxlIG9yIGd1ZXN0cyBtaWdodCBoYXZl
IGxlZnQgZGlydHkgY2FjaGVsaW5lcw0KPiAJICogYmVoaW5kLiAgRmx1c2ggdGhlbSB0byBhdm9p
ZCBjb3JydXB0aW9uIGZyb20gbGF0ZXIgd3JpdGViYWNrLg0KPiAJICogTm90ZSB0aGF0IHRoaXMg
Zmx1c2hlcyBvbiBhbGwgc3lzdGVtcyB3aGVyZSBURFggaXMgcG9zc2libGUsDQo+IAkgKiBidXQg
ZG9lcyBub3QgYWN0dWFsbHkgY2hlY2sgdGhhdCBURFggd2FzIGluIHVzZS4NCj4gCSAqLw0KPiAN
Cj4gPiAtCWlmIChjcHVpZF9lYXgoMHg4MDAwMDAxZikgJiBCSVQoMCkpDQo+ID4gKwlpZiAoY3B1
aWRfZWF4KDB4ODAwMDAwMWYpICYgQklUKDApIHx8IHBsYXRmb3JtX3RkeF9lbmFibGVkKCkpDQo+
ID4gIAkJbmF0aXZlX3diaW52ZCgpOw0KPiA+ICAJZm9yICg7Oykgew0KPiA+ICAJCS8qDQo+IA0K
PiANCg0K
