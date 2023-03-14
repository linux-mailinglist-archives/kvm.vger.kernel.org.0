Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC9C6B87DB
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 02:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjCNBuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 21:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCNBuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 21:50:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9928A64279;
        Mon, 13 Mar 2023 18:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678758651; x=1710294651;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t0R4/nEkZpOMudut8RlEf0P9QOP0bqZB6nqPXhd78ZQ=;
  b=kbd+IlcPSrgt5DsKvxYOfcubGTDY/iEsrzJmpzx/KH66ASOO2Xk+799q
   RGWNG7x8mYOmhhJ3m6zO2O0Z7udA0qhpQFjvpIJECL6R6QMWPQ9zihKM6
   B269HnoUx4qxgf1dH/80kPxSx/1as/psvPmkZ7QqHsGK74B3vzfmbW4li
   pugjOe9bT25rt160pUFXDdSJ4LlQzS+0WfFHYzVqFVLKBbhXU8GD7CeEG
   gbP7wuV9KAkYiWPoxj0VOxq/Pg49h0LmNc/V1JUPWZBTU6gznJhJGbQzE
   iHGxYdHJZu2+drD/pV9bHZYUyuxg25O6wgzBO+QfAPctR/0nL8rHg460j
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="321156835"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="321156835"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 18:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="681246375"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="681246375"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 13 Mar 2023 18:50:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 18:50:50 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 18:50:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 18:50:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 18:50:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPm/iUviJenVD8lTfX7366b14AqNMdeesNxGGtQpOhh+5fN60OzAljW4tMwGnfH2RXkBRW8Z1DhaNjTF1PQXepep1VB9UQopayWxPwwgllTJkssja6AAoa6GKjRLsVadbOwkHveWwvjN4Vt80v7Iiirkwozz3IjkCzLhHnZfJ+VVnaX2sZYiHZiY9tt/uQrXaFUs9vjaPP4hhXPaV/ZroQ7RgEtBmFD20J/gfiQEKsXo5i0MzKsgx0y0CnGVb9TJP5fuSyZmSK0A76hTPUnvunOfj8bAXlzVSUFTbIGNFF37GWgUrr7HFrujo53m+bxKcNE6v4z8yUri304HHk1HnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0R4/nEkZpOMudut8RlEf0P9QOP0bqZB6nqPXhd78ZQ=;
 b=N42suWvLFspp29vvGMDhkNGGXlHQhkTJ65l8YWuUTORHbVz9xgxkAgu3lc1O39mWeydkPKj1tx+wtmPO3OVZ5x/oPIWGoFbNGaoaOvV+R3x6uV1jGNN0K7EqmcUxN0Fww1iq0Id4/cR8CGaQAsoQrje5wmh9Tr+IZZnIcUZmKyIjCcoM0b2lFFBzgfXoETFLSr+oyKynWVSe2pdQuv27LrZs2KMQhJJsv1E1KWkHyb/Zn4ZuD6FIYBqKERcB9DwlUHt4YNEypN2+OGCL95jXnv/nP0HKdwBxdH3rwtH2CqaF+BYICAt0XY3H6mzuXrR+kvjvjcLDhTLGauRN5eCoDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7439.namprd11.prod.outlook.com (2603:10b6:806:343::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 01:50:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 01:50:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
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
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZUDU50M/RwoyayES+lzw7MeI2g67xefUAgAZUzQCAAZ2qAIAAIeiA
Date:   Tue, 14 Mar 2023 01:50:40 +0000
Message-ID: <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
         <20230308222738.GA3419702@ls.amr.corp.intel.com>
         <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
         <20230313234916.GC3922605@ls.amr.corp.intel.com>
In-Reply-To: <20230313234916.GC3922605@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7439:EE_
x-ms-office365-filtering-correlation-id: 522a792a-8a66-4532-e431-08db242e83f9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Iy3EyOWjuRWgA9qxvTLXwEK6yAq1msXZX/8wPSnfG2e6SWYxuKFeqPw4OvHTOUPqzkWPcR5YfURNR6ssj2I+N2/RBrNetiRA5GIDFXFszYR/ZZcAzJMbGv18snG/Aix++PNQgeZzDtvqrux3KyKN7VnqHNtoO2S7On8iLXzRKL7zBx84bspga7oAlkjjP7MO97HC5zp1gKK8psldXJiowi3Cr7nYsAxavTJ+L8OY3CB5KZpNkj4o2lFsbJvsr6JFQvJGwP2z/kV2or305jHS1FWdVi5bdxn1bvEBmfFisKJlOlS2ZIsw4VvllQAArsiwIEIw5bjI775i2DgGBJdtspagsyiJiTYu/T6jQKxIo7zlxVCFozKfpAq9ftS02pc3E3w3+F6/SiFKyL87Rek2G92aqVRINBHqIhnsng8jKrenPtao03fsxsP/WFn2cqzqmkBUTO/SNn1Q8NlWJVAVsgSepdj3XviNLzqcfxGCgnvuermobHFI3Cmf8WuHk4k1NAJoPakEIAIFdRXa0J/3BuVzoy1Xd4SOXu+uR4nIqy2+yKad3tIp66LN+xq3Wcb3/5tXoonPDWfWo3l/w/ASE6am44fra6I15nwdRSa6JbK9HCXsuHH/EhHZ6WonSfXA+Op0EoVFtKbyJmWD3dPGA9mLvecRORqsVkRPPXqzV4RY7fPt5EOcdrb+uRecwpV0LBNRGcDL8a+lDJneghaIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199018)(6486002)(2906002)(83380400001)(82960400001)(36756003)(26005)(6506007)(66556008)(5660300002)(4326008)(8936002)(186003)(71200400001)(8676002)(86362001)(91956017)(41300700001)(38070700005)(2616005)(6916009)(7416002)(76116006)(66946007)(66476007)(64756008)(66446008)(6512007)(478600001)(316002)(38100700002)(54906003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmxiajlTOWlFbVMvQ1BLcmF1T3RhcFZucWlRNHQraS9zV0NCRVoxdWdoTjRT?=
 =?utf-8?B?SWJBaGxtcDdOMlZTZC92a00zRFNNWTdWemtIMXdsdjVIRUtxWGd6Yzlwc0t2?=
 =?utf-8?B?a1BhMU9id1oxelo4ZmpkejJnT2NQaWJtZjkxZUcydzhnRkorWXFWb2FZV0xM?=
 =?utf-8?B?emRYQmpHVzRUUzgrQUx0Vk4rY2xYVmcyaTRwY2tMRWZVZyt1aUUvbklGTDFI?=
 =?utf-8?B?cldSR09FQktrZDZvajVzZURISFN1UXZzbWxPVThoRzdCOVgwcEVEVWE2Ynho?=
 =?utf-8?B?TVhXNEZsVEJaTVlZdEhRMU5KWnNpZ05sQUNXeGgxRnZiQ1pIQWdrcTlFSVNN?=
 =?utf-8?B?K0wvUyt6S2dBNFRrejc3bFhKNUg4bkgwTVRaUTlUZmNYbHR4cERHSFJNeXF6?=
 =?utf-8?B?TnlncE5mbEM5TTYycjBieURWK3BuNDJDSmhDWndHT2dRaU9XY3JZTnAzYm5r?=
 =?utf-8?B?dTlKd2szeE1yUWpvUENEdzIyZW9zMlF2bDVEOHFGaE8xY0UyN3N3cHB5Z3Yy?=
 =?utf-8?B?L0tGTTRoNzVDbkpFV0dhZ0diWXROTnRLc0lRaWZLSFNaVmhCTWV3VzA5KzlF?=
 =?utf-8?B?OUhNV2tZaVVjcWVXV1h5cS9TWml3aFlVQWQ0KzJXYnFGaHYrNkJyMFVwUWhl?=
 =?utf-8?B?SkNPdHR4dzJUckU5YmxNd0FkTXFhNWcrS3RNZGRzcVFEWElNZHc1UFY1Qm5M?=
 =?utf-8?B?UDR2K0JMUWlZRitvZUphOTJpTWpINXQyY1M1TGJMYXh3dkUyYUtiR0tpUVlu?=
 =?utf-8?B?QWdWOUozeXIvWXdTZTF2VHdwVXVETG9VNzVIWDNpZk9FcSt6TTZlSDNzb1d4?=
 =?utf-8?B?VmtoWFFLTDdqMXpMQlJFWW92dzhGVGR0SDN6Uy9pQkVXaVNwalpGeXdVRWdp?=
 =?utf-8?B?N3pkcDhRSEdtcDZ0RzQyazNldGk0WDVLcmc5amF5czdWbENCdVNyVk5FOG1S?=
 =?utf-8?B?NWEwdTFBSnhpcmJ1T0F3UVBVNURXRFFNT29PVFo1Zzk3VDhFUmJkOS9zU2dh?=
 =?utf-8?B?eXpZcjdSR0t6TU1jTDhoWDFRS0Q5S2tyclBESkM3bWFWL00rMG9kbzFDZUYw?=
 =?utf-8?B?TFZYMGdHbXhuZnlZcmFxMDhja0dmdDl0KzJ5eDRwUUVlUjE3R2dFVjdHSml3?=
 =?utf-8?B?U256MGVKN3E0cDVvMEpwTmw5YnY0MHhpbTlUZFBFMTlNMUpnRHdIZ1hCOC8r?=
 =?utf-8?B?QUZVNkEwdkRia2VrRTRtblB0d1R4NEkrZnpCVHQ1L3MvS3pBZ3lrdFllWFp5?=
 =?utf-8?B?eCtLZlF4MmNFN0QwVDhBY2YwdUs2VFg4c2NJcyt3SjI3eDVmNnZxamlMNCtp?=
 =?utf-8?B?ZlNvTXUzTTFPN0psbHdhallEaWw5NXVkcUEzUmRLSVRuWVhMNzNHM3U3OGtZ?=
 =?utf-8?B?NDU3QXAzZ3ZsZEhWRmpsQWZOZ0VyZ0loVHExRGdMV3Y0ek0ra1lmRDFUbklB?=
 =?utf-8?B?UWk5RmhxUnNteGY3ZjJoUTNQMnhSZzB6WlNMbkJWSURBbDd4U09QUzc0TXNi?=
 =?utf-8?B?ek9XRkJoaTJROUhMdnZ0cGF0aGs3L0tLTlg2b1dJOUxOeFk0SHFvZzdiWEZk?=
 =?utf-8?B?akRNN1dHeDhTc2FGemRCaUlvMUlicnQ4UE53emtxc1JZQ0svU1UrVjE0SVpW?=
 =?utf-8?B?bHRmY09yeTN5WWxzekdEZ291bjJ1ZEkrckVKbjFvNnVoUHo1TmREc2tCOGsw?=
 =?utf-8?B?cWFnQ3creEtDOGUyVCtUQmxHWitDdStWVmRtR2V1U3Y3bTFhajF3bUQvdGpX?=
 =?utf-8?B?S0x3NGdCZzkzOHVGK3BBS2FBR1NLeHdWTU9PRHlZWEc3U3dVbGVGZ2Ixbk55?=
 =?utf-8?B?bkFtUVZrQ0ltMk1YK05lSlNyNkNPN3JPS1FPZ2diM2hjZ3p1dTlXeExLTVhF?=
 =?utf-8?B?S0lLYWVSUHQzUm82TFlKYVF6YUdmMStnOTdDTzBCTXFjaEhSeDloK3dhaE9s?=
 =?utf-8?B?WlExZENydjBkK3BaTXUxckpFRnc2NmM5bUM0THRwWXBTRHF5V25XVE1SQ3Yr?=
 =?utf-8?B?RWU1Nk9aLzlJc0N0YTBQdnh4eHBqaVJVZE5JaEcwdGh4b0lHNGQvSFdnZ3Mw?=
 =?utf-8?B?MW03dTA2K2wyZkNpbWpHS2lMcWUxQ3hqRnpodk1FM2tlTWZIMXRLNXZmNjZv?=
 =?utf-8?B?a0dWaU1uZnhRRjhVL3Bpam1FQ3NYcE0wUzlCV0R4UmU0RGIwWS9JbjN2emFT?=
 =?utf-8?B?RlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BF013606ADFD44EA81A547AFCDC1D64@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 522a792a-8a66-4532-e431-08db242e83f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 01:50:40.3719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yARzVn9d0qrMnfsqjYZFscx85RnpyUwxThMBT572tIIg4hPA475fNbcyiWf9qg1fMSAnC0U+WhDMVPtU2JwnVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7439
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAzLTEzIGF0IDE2OjQ5IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gU3VuLCBNYXIgMTIsIDIwMjMgYXQgMTE6MDg6NDRQTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gV2VkLCAyMDIzLTAz
LTA4IGF0IDE0OjI3IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToNCj4gPiA+ID4gKw0KPiA+
ID4gPiArc3RhdGljIGludCB0cnlfaW5pdF9tb2R1bGVfZ2xvYmFsKHZvaWQpDQo+ID4gPiA+ICt7
DQo+ID4gPiA+ICsJaW50IHJldDsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCS8qDQo+ID4gPiA+ICsJ
ICogVGhlIFREWCBtb2R1bGUgZ2xvYmFsIGluaXRpYWxpemF0aW9uIG9ubHkgbmVlZHMgdG8gYmUg
ZG9uZQ0KPiA+ID4gPiArCSAqIG9uY2Ugb24gYW55IGNwdS4NCj4gPiA+ID4gKwkgKi8NCj4gPiA+
ID4gKwlzcGluX2xvY2soJnRkeF9nbG9iYWxfaW5pdF9sb2NrKTsNCj4gPiA+ID4gKw0KPiA+ID4g
PiArCWlmICh0ZHhfZ2xvYmFsX2luaXRfc3RhdHVzICYgVERYX0dMT0JBTF9JTklUX0RPTkUpIHsN
Cj4gPiA+ID4gKwkJcmV0ID0gdGR4X2dsb2JhbF9pbml0X3N0YXR1cyAmIFREWF9HTE9CQUxfSU5J
VF9GQUlMRUQgPw0KPiA+ID4gPiArCQkJLUVJTlZBTCA6IDA7DQo+ID4gPiA+ICsJCWdvdG8gb3V0
Ow0KPiA+ID4gPiArCX0NCj4gPiA+ID4gKw0KPiA+ID4gPiArCS8qIEFsbCAnMCdzIGFyZSBqdXN0
IHVudXNlZCBwYXJhbWV0ZXJzLiAqLw0KPiA+ID4gPiArCXJldCA9IHNlYW1jYWxsKFRESF9TWVNf
SU5JVCwgMCwgMCwgMCwgMCwgTlVMTCwgTlVMTCk7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwl0ZHhf
Z2xvYmFsX2luaXRfc3RhdHVzID0gVERYX0dMT0JBTF9JTklUX0RPTkU7DQo+ID4gPiA+ICsJaWYg
KHJldCkNCj4gPiA+ID4gKwkJdGR4X2dsb2JhbF9pbml0X3N0YXR1cyB8PSBURFhfR0xPQkFMX0lO
SVRfRkFJTEVEOw0KPiA+ID4gDQo+ID4gPiBJZiBlbnRyb3B5IGlzIGxhY2tpbmcgKHJkcmFuZCBm
YWlsdXJlKSwgVERIX1NZU19JTklUIGNhbiByZXR1cm4gVERYX1NZU19CVVNZLg0KPiA+ID4gSW4g
c3VjaCBjYXNlLCB3ZSBzaG91bGQgYWxsb3cgdGhlIGNhbGxlciB0byByZXRyeSBvciBtYWtlIHRo
aXMgZnVuY3Rpb24gcmV0cnkNCj4gPiA+IGluc3RlYWQgb2YgbWFya2luZyBlcnJvciBzdGlja2ls
eS4NCj4gPiANCj4gPiBUaGUgc3BlYyBzYXlzOg0KPiA+IA0KPiA+IFREWF9TWVNfQlVTWQlUaGUg
b3BlcmF0aW9uIHdhcyBpbnZva2VkIHdoZW4gYW5vdGhlciBURFggbW9kdWxlDQo+ID4gCQlvcGVy
YXRpb24gd2FzIGluIHByb2dyZXNzLiBUaGUgb3BlcmF0aW9uIG1heSBiZSByZXRyaWVkLg0KPiA+
IA0KPiA+IFNvIEkgZG9uJ3Qgc2VlIGhvdyBlbnRyb3B5IGlzIGxhY2tpbmcgaXMgcmVsYXRlZCB0
byB0aGlzIGVycm9yLiAgUGVyaGFwcyB5b3UNCj4gPiB3ZXJlIG1peGluZyB1cCB3aXRoIEtFWS5D
T05GSUc/DQo+IA0KPiBUREguU1lTLklOSVQoKSBpbml0aWFsaXplcyBnbG9iYWwgY2FuYXJ5IHZh
bHVlLiAgVERYIG1vZHVsZSBpcyBjb21waWxlZCB3aXRoDQo+IHN0cm9uZyBzdGFjayBwcm90ZWN0
b3IgZW5hYmxlZCBieSBjbGFuZyBhbmQgY2FuYXJ5IHZhbHVlIG5lZWRzIHRvIGJlDQo+IGluaXRp
YWxpemVkLiAgQnkgZGVmYXVsdCwgdGhlIGNhbmFyeSB2YWx1ZSBpcyBzdG9yZWQgYXQNCj4gJWZz
YmFzZTo8U1RBQ0tfQ0FOQVJZX09GRlNFVCAweDI4Pg0KPiANCj4gQWx0aG91Z2ggdGhpcyBpcyBh
IGpvYiBmb3IgbGliYyBvciBsYW5ndWFnZSBydW50aW1lLCBURFggbW9kdWxlcyBoYXMgdG8gZG8g
aXQNCj4gaXRzZWxmIGJlY2F1c2UgaXQncyBzdGFuZCBhbG9uZS4NCj4gDQo+IEZyb20gdGRoX3N5
c19pbml0LmMNCj4gX1NUQVRJQ19JTkxJTkVfIGFwaV9lcnJvcl90eXBlIHRkeF9pbml0X3N0YWNr
X2NhbmFyeSh2b2lkKQ0KPiB7DQo+ICAgICBpYTMyX3JmbGFnc190IHJmbGFncyA9IHsucmF3ID0g
MH07DQo+ICAgICB1aW50NjRfdCBjYW5hcnk7DQo+ICAgICBpZiAoIWlhMzJfcmRyYW5kKCZyZmxh
Z3MsICZjYW5hcnkpKQ0KPiAgICAgew0KPiAgICAgICAgIHJldHVybiBURFhfU1lTX0JVU1k7DQo+
ICAgICB9DQo+IC4uLg0KPiAgICAgbGFzdF9wYWdlX3B0ci0+c3RhY2tfY2FuYXJ5LmNhbmFyeSA9
IGNhbmFyeTsNCj4gDQo+IA0KDQpUaGVuIGl0IGlzIGEgaGlkZGVuIGJlaGF2aW91ciBvZiB0aGUg
VERYIG1vZHVsZSB0aGF0IGlzIG5vdCByZWZsZWN0ZWQgaW4gdGhlDQpzcGVjLiAgSSBhbSBub3Qg
c3VyZSB3aGV0aGVyIHdlIHNob3VsZCBoYW5kbGUgYmVjYXVzZTrCoA0KDQoxKSBUaGlzIGlzIGFu
IGV4dHJlbWVseSByYXJlIGNhc2UuICBLZXJuZWwgd291bGQgYmUgYmFzaWNhbGx5IHVuZGVyIGF0
dGFjayBpZg0Kc3VjaCBlcnJvciBoYXBwZW5lZC4gIEluIHRoZSBjdXJyZW50IHNlcmllcyB3ZSBk
b24ndCBoYW5kbGUgc3VjaCBjYXNlIGluDQpLRVkuQ09ORklHIGVpdGhlciBidXQganVzdCBsZWF2
ZSBhIGNvbW1lbnQgKHNlZSBwYXRjaCAxMykuDQoNCjIpIE5vdCBzdXJlIHdoZXRoZXIgdGhpcyB3
aWxsIGJlIGNoYW5nZWQgaW4gdGhlIGZ1dHVyZS4NCg0KU28gSSB0aGluayB3ZSBzaG91bGQga2Vl
cCBhcyBpcy4NCg==
