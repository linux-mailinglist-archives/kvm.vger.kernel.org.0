Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CA8741FF6
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 07:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjF2Fiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 01:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjF2Fis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 01:38:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DDE1FCC;
        Wed, 28 Jun 2023 22:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688017127; x=1719553127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DuGv5Jq/hB7bX7ovV7PiGA51o03NuaPNoz3a4ekdI7A=;
  b=LLx4AhLqjiY0oyLrcEQ2h4DtpFTp4oepF8QuDWIdFDRKGn9D167FtqPu
   pvB0MolP9ytdiMTSU+sRN+rhCaAPAxbMa1N7lyuQSY8hfucKZ4yXUuD/S
   ELOaXdtHA6XQLSZAIYAF6xBxflr1h6fHF+biPE72mPKD/pZbh7qqLbfx+
   mxSR2YD+g0siNtwszMjAWOB/oG0SntpCiZMZCHYssTlp7BccdSUX7tuDe
   plQLx07FwPVvawk/4ahbpnvu2h/IFz2w2K/0oI4VO5C/GwhykUvZp9tkm
   OaZvjw1dq8SXVQbceMmbrqFe8pE0010f0vPmEHaDsVhQ0o3G/B/ogKKX1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="346796367"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="346796367"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 22:38:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="720440944"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="720440944"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jun 2023 22:38:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 22:38:45 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 22:38:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 22:38:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 22:38:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXuxGtLL9DPL3BkxTGUGid3RmOAxAzrfJH6Z7cLPLqyBoCZNxGhOoQu4KT3d/1rlV8fpxOqaAf+aD8aLcVwdCVIJhy2BMGC1gRMs1C3xLqzzPvb1cw48DbWEcnf9yiOS1DfncJMyClMQTtcwNAD71T2553wYQDNmbNlKVQanhel1cVaUBpbBmHJoquPTvWwcxYaIOw9d67FnjelwDvyVPUMbKtTQkjZZk1Nr7M/VNCujIuSuWNSoO0A+DNnEghq3cIvGN3ItYSGNureTU4fQmnmc5LvM7BkPhceHj2MuJqCuM0npAxc3Na4PNhHTT54qmi0rFiLq7KiOTy1obJp4ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DuGv5Jq/hB7bX7ovV7PiGA51o03NuaPNoz3a4ekdI7A=;
 b=Ny8oC/RiqOagff3AHU8Uy/hPuTrXDqeJECzByLOqlRBoJA728OUenJUr5WodbcvsZNBIC6VHC1ZZbqdwAE6teQhUvvDQCRMnhU/+OsJmKC2vXGfwaDOfPimwTKe2DyP6kOHHenQxNYk6nBPCol4EuoKgQGwPxnr6dkXDc/Ihm+S5uiLwOLkToizMeQKZRqvf96iz3coLVrKK9oJeVhHLXYkmwZN37WhQNOpIr/LZVcy0Gj/r4ZNRwz7xyI5DotKD3A509jCPu/8txqr/RULkniMevYEy8oO5Aux2EKaMMkzo99hgrom5jB4qFTe4lFi428JvOT/yHiXsXmLHhl59fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6699.namprd11.prod.outlook.com (2603:10b6:510:1ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Thu, 29 Jun
 2023 05:38:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 05:38:41 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Topic: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Index: AQHZqDW1qzOe/uWSAkmVYoaVetZlS6+f8x4AgAEtegCAACbjgA==
Date:   Thu, 29 Jun 2023 05:38:40 +0000
Message-ID: <3afbb049ba3a848bb0befd7056ced519c7aa8991.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
         <1662a5ef-c333-d6d6-7605-060f4bcca6fd@suse.com>
         <8a1d39c7641b0ba2be3191599a114bebfa3ffca5.camel@intel.com>
In-Reply-To: <8a1d39c7641b0ba2be3191599a114bebfa3ffca5.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6699:EE_
x-ms-office365-filtering-correlation-id: 482a3351-ffb3-43a3-be8e-08db78631828
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7okY3WnJKTb9RqIvPdF7tCDDodKeTY0PP/wYOiZjD3I8FD2p5pBDVbkqunWlYpXT6WLuIfg34t2/54WvwyVH6jXrFnsMalM/sURa2oLJC2iQBh2PeYlv6/u4Ma2AUYETaPIEAmPLfFDUeI4OZGRR804FsuF53B/9v4w54c9O29OzKohU4KVSEAn1M7gnehCwsCnFqDAGXBp5GyhR0tcXx1QsuO/6wmQ2BoacuLu551DzvTIrrudni5oImcbk3iCLC4yd8Qu0bW7ifozuTwDFs6z2dnNUKOlrxa68LRQxR8vUYbuPohMy5G+n/Jz0P/gBXUEcbTcLEHb/Jg2oMFp2fqD+UJWNlVXMHKB+RRGz4EnLvGxwK/xrrhnRJT2SF7mokRm1LgBpSMsyPLS7SRYbSCFi+vMQIEc0jIZEUU5zEU3KMPpAPlyAW+9mSBxQUz0glZTZvJizrMwPGtR8vqYWlZVxN+6eLldQyHPM/HCI/JwwW94X/BOXYxyN1yfkZbNPsdwqKJoKhjdVTBhr/KWEelGTKKEhtOE8PW4wtACIFqznJ+jCy09fCjPm7dkRwsq5XNTlwynBiMZYl+of+5F5OYsaCPU7NAUc727hurzVd7FjkfXJLXGo9BbjvT7Uhjc7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199021)(7416002)(66446008)(76116006)(66946007)(64756008)(316002)(66476007)(66556008)(38070700005)(478600001)(4326008)(36756003)(8936002)(91956017)(8676002)(5660300002)(86362001)(2906002)(54906003)(41300700001)(110136005)(6486002)(6506007)(6512007)(186003)(71200400001)(83380400001)(38100700002)(82960400001)(122000001)(26005)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0lCcTZoaGZXOVlkbVN5NGUrTEJTS09JU3JRaVl5amFGbzR2VDRiT2pTMDBZ?=
 =?utf-8?B?V1Zxb2hMZWdsRVF3Y2owV1hWUTJJejcrQk53a09LNytxdlcvN0ZId0RXYXkv?=
 =?utf-8?B?U0dMQmsvekZmb2RLMnlRNlNOWkE2VFE1OSs3M1oxZEkzSXlGSDJHSW53dThq?=
 =?utf-8?B?a1Q3RytWYmR4ZlRyRzNXNDZVT1Z4STBSWGN6eU1zcExjd1JSUWNjSmk3U2Zu?=
 =?utf-8?B?VlhZbk1RSXdiYndNeGJRN2FNUVM2U1JQcVp6U0ltVnFxZEhmWEpGa2E4Rk03?=
 =?utf-8?B?TytEK2pLUUdmYnBSY0luTzI4SEM5clBnencwNkU4VmRhQUFwOG42ZGEvWHp4?=
 =?utf-8?B?TUgrV0w3UloxRVlzWGk1aFRlYTE3QWhNODk3SGZoTFNiRUdsQmpYbEZBTjI3?=
 =?utf-8?B?dHZTcmszZERtbDJqcm9YYS92Z3VLUGNtc05CQm9QQkRCUlI0Z2Z2TTFNcStJ?=
 =?utf-8?B?MjNsaHR1US9vWkdLRkVZanV0UXVyek8vMHJYZ04zSU5ZTys3TEtJRDkyZE04?=
 =?utf-8?B?cGt6dzdsd0djUVNkUm94cHI5eXA5enJoVVFWNXBKTURzTFdyeENxcXpsdGtD?=
 =?utf-8?B?cmQ5bVEyaVlrdWtaTlAvTVc0V0wzWEZuOEVWa2tlTmh6MUFjN2V4T3BQMEgz?=
 =?utf-8?B?K2t1WVBzNFlocEdyc0hFbGxXVll0TzZVVDZVRFBCalZWT2lXa1FRV2h5bTV3?=
 =?utf-8?B?QzJzWEFaODc2MHJ2aHVoV25uNlZ6T3dUMU54anEyZlpNOC8vWFNXRjZlUUVY?=
 =?utf-8?B?TUdqTndVSGxJTnNiVjN2VXdXU01od2p0UmEyQTAycVNlcnJDV2Zwc0t1dWlO?=
 =?utf-8?B?Z2tmZ0Y5QXFSR2RxSCtGaTdsOTk2dFpCTGVPVzNNRjN5VmRoV1hucVRic3pG?=
 =?utf-8?B?SjVUQVRBbVZtY3RRVVRIV2VCSFhObEpOQjk0QTA3OFJvaHhjSjRsbHRkSGZM?=
 =?utf-8?B?S0hCY2FHZkFtRjVSMEZHTUhXM2luLzNSN3NkdHFFUXBlbmdaVFFhVXg0WUtQ?=
 =?utf-8?B?My85enJYSnNIYytQSVpGdDI1RzRLNUJOU21PYlRySVlCMjM4RTJ2dXVCMlU4?=
 =?utf-8?B?YkZTdjVyb1RtcHFvL3IyZGtkKy80S01DeWpzK0tkaG5WenplK1MxY2d5T0FP?=
 =?utf-8?B?cEhmNHlJTjZiYlRwb2lKcnNRUHQvVGZTRHBGU2JmdVdOYlJXYnlVNEJXc0pE?=
 =?utf-8?B?WDJHZXJSZlN0N3hVTUsxdmZZRi9uV3NXcHBoVGxHNHloRmNJMFpGcktxSDNT?=
 =?utf-8?B?Sk5pc2t1bW4vNy81WC9CRTFYK0lsWWozNkJMT3V3Q0l6ZGhxRVIwUzJUTlFj?=
 =?utf-8?B?bDN1WVFITjVlTkc5REdURmw5c2xOUTQ4NHE3VCtlVnl2dW56aDIvbk5FZVZ1?=
 =?utf-8?B?MEFWeGg3OTE1aTU1RkhLVGtqMGRBNzg4L0dJZ0owUUFoREN0RmJmSllkTGVU?=
 =?utf-8?B?M2FjcjAyd1N1N085bmdNQTgwa2pFS1ZNY2xmcmJwWFU0SXorVmIxSyt6dWVD?=
 =?utf-8?B?N1NWaVdZS0tLTWpZOTZzQk5DZzRoUTg3MUtzcm51cjF5SUlPcEVIMFUxVHlM?=
 =?utf-8?B?TldidkdnZHNSVzRFY2xwQnRITzR0TGQ4dHI2M0JIZERyek5yOGJpZ2ZMVDFl?=
 =?utf-8?B?T1ZCVUZmeHZrZVEvOHdGQzk4cXNITTh6S1kvcGF4Q2N4eGtaVDFXeFRERklw?=
 =?utf-8?B?MTZNRkJJYXpjakZuQWtmZ1c2SEpoT3A4dWpGQ202d3EzMXV4K2swd3ZaVmlx?=
 =?utf-8?B?ajJ0NSs1cU80ZXUzTktxK2ErUW16TlR6eTVYQVU5cnFRUXI5RWpUYWJOaDF3?=
 =?utf-8?B?aFVmQXpZQUpmU1RtMEkrb2R6ckxGQ1ZrbThmUFlPeVFmQU53MXA2Sjc2MWs1?=
 =?utf-8?B?NER5YUt5b3lCdUhEeFB3SHR4T2FHMFBuWVJkdE1Jd1AwbFhYa3haWmZheTZ4?=
 =?utf-8?B?UDVmcHFRMDNPODMrWUVvQXdYN3NVQnJoa1VyUC9BV29XV3Qzenh2MUttL2xj?=
 =?utf-8?B?SGMrTGw5cjR0TGZuNW05cWJ3WFNiNHNsdXQwblJ6M2twM0hZWDNTOHRsNmFV?=
 =?utf-8?B?UktlajlOMXBXKzNJRTRHVGpObW5jRlVET3QwZSs4SVp1OGNNSHA2RHJab3pR?=
 =?utf-8?B?cVVtVXh3c0psMXYrZ2haVjFwMjBWdWtlVTgxVDFNWlZWOW00dGg0cTJyNXRG?=
 =?utf-8?B?QlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4DF789A49AFDF64E8A3FC40D15DC4898@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 482a3351-ffb3-43a3-be8e-08db78631828
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 05:38:40.5332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XImqQcbFTH4kU+QeHpjGutBl1eeAa3Wkbf3un8BgQ6mDfvoYXTCgMfaua3JZmjX1NWM1rp5d+cNWLcNcnv8I9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6699
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA2LTI5IGF0IDAzOjE5ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBXZWQsIDIwMjMtMDYtMjggYXQgMTI6MjAgKzAzMDAsIE5pa29sYXkgQm9yaXNvdiB3cm90ZToN
Cj4gPiA+ICsJYXRvbWljX2luY19yZXR1cm4oJnRkeF9tYXlfaGFzX3ByaXZhdGVfbWVtKTsNCj4g
PiA+ICsNCj4gPiA+IMKgwqDCoAkvKiBDb25maWcgdGhlIGtleSBvZiBnbG9iYWwgS2V5SUQgb24g
YWxsIHBhY2thZ2VzICovDQo+ID4gPiDCoMKgwqAJcmV0ID0gY29uZmlnX2dsb2JhbF9rZXlpZCgp
Ow0KPiA+ID4gwqDCoMKgCWlmIChyZXQpDQo+ID4gPiBAQCAtMTE1NCw2ICsxMTY3LDE1IEBAIHN0
YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ID4gPiDCoMKgwqAJICogYXMgc3VnZ2Vz
dGVkIGJ5IHRoZSBURFggc3BlYy4NCj4gPiA+IMKgwqDCoAkgKi8NCj4gPiA+IMKgwqDCoAl0ZG1y
c19yZXNldF9wYW10X2FsbCgmdGR4X3RkbXJfbGlzdCk7DQo+ID4gPiArCS8qDQo+ID4gPiArCSAq
IE5vIG1vcmUgVERYIHByaXZhdGUgcGFnZXMgbm93LCBhbmQgUEFNVHMvVERNUnMgYXJlDQo+ID4g
PiArCSAqIGdvaW5nIHRvIGJlIGZyZWVkLsKgIE1ha2UgdGhpcyBnbG9iYWxseSB2aXNpYmxlIHNv
DQo+ID4gPiArCSAqIHRkeF9yZXNldF9tZW1vcnkoKSBjYW4gcmVhZCBzdGFibGUgVERNUnMvUEFN
VHMuDQo+ID4gPiArCSAqDQo+ID4gPiArCSAqIE5vdGUgYXRvbWljX2RlY19yZXR1cm4oKSwgd2hp
Y2ggaXMgYW4gYXRvbWljIFJNVyB3aXRoDQo+ID4gPiArCSAqIHJldHVybiB2YWx1ZSwgYWx3YXlz
IGVuZm9yY2VzIHRoZSBtZW1vcnkgYmFycmllci4NCj4gPiA+ICsJICovDQo+ID4gPiArCWF0b21p
Y19kZWNfcmV0dXJuKCZ0ZHhfbWF5X2hhc19wcml2YXRlX21lbSk7DQo+ID4gDQo+ID4gTWFrZSBh
IGNvbW1lbnQgaGVyZSB3aGljaCBlaXRoZXIgcmVmZXJzIHRvIHRoZSBjb21tZW50IGF0IHRoZSBp
bmNyZW1lbnQgDQo+ID4gc2l0ZS4NCj4gDQo+IEkgZ3Vlc3MgSSBnb3QgeW91ciBwb2ludC4gIFdp
bGwgdHJ5IHRvIG1ha2UgYmV0dGVyIGNvbW1lbnRzLg0KPiANCj4gPiANCj4gPiA+IMKgwqAgb3V0
X2ZyZWVfcGFtdHM6DQo+ID4gPiDCoMKgwqAJdGRtcnNfZnJlZV9wYW10X2FsbCgmdGR4X3RkbXJf
bGlzdCk7DQo+ID4gPiDCoMKgIG91dF9mcmVlX3RkbXJzOg0KPiA+ID4gQEAgLTEyMjksNiArMTI1
MSw2MyBAQCBpbnQgdGR4X2VuYWJsZSh2b2lkKQ0KPiA+ID4gwqDCoCB9DQo+ID4gPiDCoMKgIEVY
UE9SVF9TWU1CT0xfR1BMKHRkeF9lbmFibGUpOw0KPiA+ID4gwqDCoCANCj4gPiA+ICsvKg0KPiA+
ID4gKyAqIENvbnZlcnQgVERYIHByaXZhdGUgcGFnZXMgYmFjayB0byBub3JtYWwgb24gcGxhdGZv
cm1zIHdpdGgNCj4gPiA+ICsgKiAicGFydGlhbCB3cml0ZSBtYWNoaW5lIGNoZWNrIiBlcnJhdHVt
Lg0KPiA+ID4gKyAqDQo+ID4gPiArICogQ2FsbGVkIGZyb20gbWFjaGluZV9rZXhlYygpIGJlZm9y
ZSBib290aW5nIHRvIHRoZSBuZXcga2VybmVsLg0KPiA+ID4gKyAqLw0KPiA+ID4gK3ZvaWQgdGR4
X3Jlc2V0X21lbW9yeSh2b2lkKQ0KPiA+ID4gK3sNCj4gPiA+ICsJaWYgKCFwbGF0Zm9ybV90ZHhf
ZW5hYmxlZCgpKQ0KPiA+ID4gKwkJcmV0dXJuOw0KPiA+ID4gKw0KPiA+ID4gKwkvKg0KPiA+ID4g
KwkgKiBLZXJuZWwgcmVhZC93cml0ZSB0byBURFggcHJpdmF0ZSBtZW1vcnkgZG9lc24ndA0KPiA+
ID4gKwkgKiBjYXVzZSBtYWNoaW5lIGNoZWNrIG9uIGhhcmR3YXJlIHcvbyB0aGlzIGVycmF0dW0u
DQo+ID4gPiArCSAqLw0KPiA+ID4gKwlpZiAoIWJvb3RfY3B1X2hhc19idWcoWDg2X0JVR19URFhf
UFdfTUNFKSkNCj4gPiA+ICsJCXJldHVybjsNCj4gPiA+ICsNCj4gPiA+ICsJLyogQ2FsbGVkIGZy
b20ga2V4ZWMoKSB3aGVuIG9ubHkgcmVib290aW5nIGNwdSBpcyBhbGl2ZSAqLw0KPiA+ID4gKwlX
QVJOX09OX09OQ0UobnVtX29ubGluZV9jcHVzKCkgIT0gMSk7DQo+ID4gPiArDQo+ID4gPiArCWlm
ICghYXRvbWljX3JlYWQoJnRkeF9tYXlfaGFzX3ByaXZhdGVfbWVtKSkNCj4gPiA+ICsJCXJldHVy
bjsNCj4gPiANCj4gPiBJIHRoaW5rIGEgY29tbWVudCBpcyB3YXJyYW50ZWQgaGVyZSBleHBsaWNp
dGx5IGNhbGxpbmcgb3VyIHRoZSBvcmRlcmluZyANCj4gPiByZXF1aXJlbWVudC9ndWFyYW50ZWVz
LiBBY3R1YWxseSB0aGlzIGlzIGEgbm9uLXJtdyBvcGVyYXRpb24gc28gaXQgDQo+ID4gZG9lc24n
dCBoYXZlIGFueSBiZWFyaW5nIG9uIHRoZSBvcmRlcmluZy9pbXBsaWNpdCBtYidzIGFjaGlldmVk
IGF0IHRoZSANCj4gPiAiaW5jcmVtZW50IiBzaXRlLg0KPiANCj4gV2UgZG9uJ3QgbmVlZCBleHBs
aWNpdCBvcmRlcmluZy9iYXJyaWVyIGhlcmUsIGlmIEkgYW0gbm90IG1pc3Npbmcgc29tZXRoaW5n
LiANCj4gVGhlIGF0b21pY197aW5jL2RlY31fcmV0dXJuKCkgYWxyZWFkeSBtYWRlIHN1cmUgdGhl
IG1lbW9yeSBvcmRlcmluZyAtLSB3aGljaA0KPiBndWFyYW50ZWVzIHdoZW4gQHRkeF9tYXlfaGFz
X3ByaXZhdGVfbWVtIHJlYWRzIHRydWUgX2hlcmVfLCB0aGUgVERNUnMvUEFNVHMgbXVzdA0KPiBi
ZSBzdGFibGUuDQo+IA0KPiBRdW90ZWQgZnJvbSBEb2N1bWVudGF0aW9uL2F0b21pY190LnR4dDoN
Cj4gDQo+ICINCj4gIC0gUk1XIG9wZXJhdGlvbnMgdGhhdCBoYXZlIGEgcmV0dXJuIHZhbHVlIGFy
ZSBmdWxseSBvcmRlcmVkOyAgwqANCj4gDQo+ICAuLi4NCj4gDQo+IEZ1bGx5IG9yZGVyZWQgcHJp
bWl0aXZlcyBhcmUgb3JkZXJlZCBhZ2FpbnN0IGV2ZXJ5dGhpbmcgcHJpb3IgYW5kIGV2ZXJ5dGhp
bmcgICANCj4gc3Vic2VxdWVudC4gVGhlcmVmb3JlIGEgZnVsbHkgb3JkZXJlZCBwcmltaXRpdmUg
aXMgbGlrZSBoYXZpbmcgYW4gc21wX21iKCkgICAgIA0KPiBiZWZvcmUgYW5kIGFuIHNtcF9tYigp
IGFmdGVyIHRoZSBwcmltaXRpdmUuDQo+ICINCj4gDQo+IA0KPiBBbSBJIG1pc3NpbmcgYW55dGhp
bmc/IA0KDQpPSyBJIGd1ZXNzIEkgZmlndXJlZCBvdXQgYnkgbXlzZWxmIGFmdGVyIG1vcmUgdGhp
bmtpbmcuICBBbHRob3VnaCB0aGUNCmF0b21pY197aW5jfGRlY31fcmV0dXJuKCkgY29kZSBwYXRo
IGhhcyBndWFyYW50ZWVkIHdoZW4gQHRkeF9tYXlfaGFzX3ByaXZhdGVfbWVtDQppcyB0cnVlLCBU
RE1Scy9QQU1UcyBhcmUgc3RhYmxlLCBidXQgaGVyZSBpbiB0aGUgcmVhZGluZyBwYXRoLCB0aGUg
Y29kZSBiZWxvdw0KDQoJdGRtcnNfcmVzZXRfcGFtdF9hbGwoJnRkeF90ZG1yX2xpc3QpOw0KDQpt
YXkgc3RpbGwgYmUgZXhlY3V0ZWQgc3BlY3VsYXRpdmVseSBiZWZvcmUgdGhlIGlmICgpIHN0YXRl
bWVudCBjb21wbGV0ZXMNCg0KCWlmICghYXRvbWljX3JlYWQoJnRkeF9tYXlfaGFzX3ByaXZhdGVf
bWVtKSkNCgkJcmV0dXJuOw0KDQpTbyB3ZSBuZWVkIENQVSBtZW1vcnkgYmFycmllciBpbnN0ZWFk
IG9mIGNvbXBpbGVyIGJhcnJpZXIuDQoNCkknbGwgY2hhbmdlIHRvIHVzZSAiUk1XIHdpdGggcmV0
dXJuIHZhbHVlIiB0byBwcm92aWRlIHRoZSBDUFUgYmFycmllci4NCg0KVGhhbmtzIGZvciB0aGUg
ZmVlZGJhY2shDQo=
