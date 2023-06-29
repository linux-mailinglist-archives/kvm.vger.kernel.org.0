Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD3B741CE2
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 02:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjF2A2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 20:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF2A2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 20:28:00 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744BD1FF7;
        Wed, 28 Jun 2023 17:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687998478; x=1719534478;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fiUym9w8wvyNBCQohUeoyZ5rXRiaAKVQGHV4kRpZQ9c=;
  b=BcsMSjr4CxueRrS4gT3AR+Fhm+sCa8J44oqvuDV7L2ulUFd3HifDV9xP
   QpuT0S8KCshX4rM9GiZSRSZ42hl5SEjTnHkUDVmcMZ0hCvbd4gI60YBa1
   IqI0mIoY5WNgmG+IcVdFjdhCvGjP7a1syv1+z2d3U3IQhNbBCUgFW6YUE
   pJ+feuE7VGMZ8mdEys0IIRw6EvAm2SsCPcDWgYb0xOa5VNCA6axGoCe6M
   y1ZtXLGwuPjkxajM/Z/1/y6+rUFLB+X/7MmgYmTHmKPQ+jsdXq/MrCj8Q
   i6Mc0d+eljNAOUqE+wuhquVPqbA6JpUbzIH5MvCVMdso45bGswubq89Bd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="428009400"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="428009400"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 17:27:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="1047593841"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="1047593841"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jun 2023 17:27:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:27:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:27:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 17:27:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 17:27:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqMP3GdFnV09OFVJlKYiILY/VVpR03wXNRRYebnuyzUBARmTy0PXDtpit7t5onzHoHtA9oQx5xOqEvTzu6lJ/ZdK8iAzh7TtZP1PTDXYAlMetXSa+9w3zYB8JVts1fgwyYCGlY0ccN8mJYL+Km0s5auLVULLFwhVaqFLTlHI6kxY9DVuArQDc9CGIqcNFeHHn21YVa1pg7RCqPCwKQujdPmyBz7C7rGQymrYk3+iNG29J5PM6nr4k3oNXcpPB9vZEuiDVPmoo3oZdBGSy/fr6gQaizzh5BBSW4kaFDhP8NYCVEnmB+3AmCCQdHwy07hnVrp4eqj2eMSFbB/xTfTwLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiUym9w8wvyNBCQohUeoyZ5rXRiaAKVQGHV4kRpZQ9c=;
 b=FVbpte77YJ8BfXi5btl43dbLqOerNCDzAIa1ofUj3nkUOeIRlEaKRJBt3FXUCeuo/+hTHZzZ4GUAVOv39WjbboNI1Y6mSAahfTUwno+HS0k2tvzVcq+eCp/NVPhBKro8JRDFVhjc3OmsmI/Y27sfqz74e6X5ol2MK3+/+KxOzeUHA6V1ESo5iiMiSyRFVPSNi9FJOvZqb2O+w2UYqOqicokHminSwU4ZyeWp7vNeTx6S9rkH2gU9Rt2T7mTzrqHvuIesrLsOWtWNm6gQmEPzvknBz1eynxD5yqva/9RwEDiJV+KQ7IrQxLpU9P1Hx+jzKZL50FuNVeN8Qt2Fn4bv0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5818.namprd11.prod.outlook.com (2603:10b6:510:132::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Thu, 29 Jun
 2023 00:27:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 00:27:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
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
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
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
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Topic: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Index: AQHZqDW1qzOe/uWSAkmVYoaVetZlS6+gKBOAgADIkIA=
Date:   Thu, 29 Jun 2023 00:27:50 +0000
Message-ID: <f04c7b69fe539a8065c24f766455c0bec3cdf877.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
         <20230628122957.sl7wzenjby3o2xsw@box.shutemov.name>
In-Reply-To: <20230628122957.sl7wzenjby3o2xsw@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5818:EE_
x-ms-office365-filtering-correlation-id: 4eb65aa4-f4fd-4fea-5254-08db7837aba8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZuZ6EJK0fm/o7XYXb+9K6CAHk2b27xBoYlBR93/IPEfg5pOtuauK9CQ5Z7sb2Z0zygypCx6j/IL/NNntwJYXxqglmuU+ILYjfdz5lpx9WfUC2NCM7TCb8P7dMsWmCNjCG/b/ql83xbJzsU4MaLbRXJk9+IJ0HAf1hNDpaFRDWafk6xDQtBwF771XkdoKT810tQiYEelWcleRWrDTTj7PT3t05Hu0erCq+osMLxjz/WfzUSl5NVpFyd/pd6ENP+78cf0y5CLhLyP/vNVT0yP5tIEw4ahM03Iz0wyAV4MMCDLTHxkiaJPak2zai3u6hLXDVRF2pe5rVVQF6N6uv/c4KLNxAdGdIlXnFqVR5LEIYtoCaSwieBhH7aptwfrN1a/k7c8sy0Fir2KglLgb0PG29IkpLTN49HdkblxS7kox7bUc1JhTCIdkVWyB4hWeifeAJ3RMO9bsh5yGHSFEBLqzzd9j22nLbYkoUJndHS49S3+smbIbAtKipB99hV4rbveX+nFTbViEeoUS/PVhD4LqbYhuWOgyTu4YwhEVuLCnxMLIUFLpzA7u3Og5eX8/hUALhNA90uutXCYOJ9x8IAC343pQ3dkqA3NU/VbJjHDy14vVlcY6/GwKrouXzP8XAX3u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199021)(7416002)(5660300002)(66946007)(91956017)(76116006)(66556008)(66446008)(4326008)(66476007)(64756008)(6916009)(478600001)(36756003)(316002)(8936002)(8676002)(2906002)(6512007)(54906003)(41300700001)(38070700005)(6486002)(71200400001)(186003)(86362001)(6506007)(26005)(122000001)(38100700002)(82960400001)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWVpRnhPd0VROHFpYmtmVVgyOTVhU3JSODVieGdKNGp6ekpUMFBDQldEMWJv?=
 =?utf-8?B?bnBSVXdSK1YxN1hlczE4cmgrOU1FRTAwL2xtbHpEWkFkbGpML0o2dWNZVEgw?=
 =?utf-8?B?U0VLRXRRMGIvbHgyOGdKS3RKZitSWEswRDhJZ1NkOXp1NzY2Mm1DVjJSaVoz?=
 =?utf-8?B?QjRkbGRWbzliZHozYSt3dUJmMmNGOEFhejVLN01haUg0OHY4OGxRamVoSita?=
 =?utf-8?B?bGhGTWdaaW5JU2hobm5wMHh5eDUrY1BSaWlDUUdXc3ZvM2JnQ293UGNmVjBC?=
 =?utf-8?B?eisxVmVnc2dvcFNHTW0vT21IeC9MQ09QVEhLMnRsajhqN3NyQUpycE1OTVky?=
 =?utf-8?B?NE9Bc05uWENMRHdBOWNZZUZOZkRYZ21vdnFSSGV1OUpXblNXWFNJbXVPVGpS?=
 =?utf-8?B?L3l5K0s1eGdYbEZUUTJ5TXowSHNqQmtleDVJZHUrbGFkcE5QL1NOR3pXdExE?=
 =?utf-8?B?MVNQTTh6TldUV3JsWjFPNjJ5dDl4QXdQMjVEL1o1TVJCTGdPWHpBZXR2VGJR?=
 =?utf-8?B?M0NhZDYyUXgwVHUwTG14aThkTzhsOVU0bGwyQ0JBVVIxM1J1aVZBNU9wWnNj?=
 =?utf-8?B?bndrVVJnNEUxZGlVQzV6R1E5dUQzN2JLSVRuZkRJZHhMS3pDc3dvWitDdU5r?=
 =?utf-8?B?ajZtUFFmVkVBVGVkM0l5S2hxdHVSS1FZYjVaeTRJKzRXYU0yUFA5UytWZjRG?=
 =?utf-8?B?UC9GUnhQZnBtbXUvNHNMSzhudUVGdTdJV1FQalB2MnV2WDY2ZlNFN2tEeW5K?=
 =?utf-8?B?YWh5NlZvNCttRDRyU1dqTSs0NncxaXRjYktBU2ZKUVhKUGlIZEFKM2pJbUdh?=
 =?utf-8?B?L0pzcHJpckhpdXc5YjNHL1Q2MmFIQ1JJUHhRazdlNnlZekE2WEwxbzdVVGgr?=
 =?utf-8?B?RGtwMUVpV1FOYzdEbnlrODZJdTh3K1NhZXUxV2t4K3BqR3JaYW93VWxGR3kw?=
 =?utf-8?B?Z0JCSXhRcmcwM3FyVTNTZXdQUWdUMDJRT0FMeEpvT3BBVmFyNmVYZ25CM3d0?=
 =?utf-8?B?WUZ2ZDQ0UkVzRW9yczE5cmlxOXMyMEozMElwVnB4WkpjeHFJbTZLUGs5aHJn?=
 =?utf-8?B?MzdERTFDTVEwSGk4U2V0Yys2bUQwd0tlRHhXMmtkVUEraGcyY1VLNVIwY1Rs?=
 =?utf-8?B?UDd3ejgrd2ExVGZteHhjUGZvUGpXdDR5NFF4RG1iT0VVRUp3ZmtDcVlQa3N1?=
 =?utf-8?B?eTNGVy93RWwyYkFXOUkvUzlJenA3QUFQZFFWaitscHZYejZsN3BUaW81UmIy?=
 =?utf-8?B?d2hncmp6SzErQkpZVGdOeThSTTZqbDM5QnRvSVpRNUU2V3lWWUNkQUVUdmZU?=
 =?utf-8?B?TTc1SHA5emlER3FneW9CMkdDVFFnR1NoRHAxUkVNYnRvQXJLcm9oZ0VCVngv?=
 =?utf-8?B?V25tOHowaUUrVW1Lc2kwZ3dJRmNiRWVyNDBpUjk5a1FJcGhCTTBDSFNFNVpk?=
 =?utf-8?B?dVRPWCtWNTl2RnNUdlZEQ1laVTdEd1JocGUyZXBrWW85dzhyNXFSRlp3eU1Y?=
 =?utf-8?B?ellNZnNZTXdFVDEzTGZuajlzOTJQMmVGODFGUjNINWYrWUovejVTRlg0di9J?=
 =?utf-8?B?K2VxdExuWnFVTmhWSFN6Ym9jQjgyeEJlM0dOZWZoWlFJRXE0Q2JWL1pPTlFJ?=
 =?utf-8?B?NlR4QU9obHkwaEpyc1owbVR4S2h3NmR1YzZxN3B0MVMrcTd2N24ra05EWEh6?=
 =?utf-8?B?QW85NUliVkgwVEtCdkZaaGF0R3dyeE14dzF4ell5ZTIzNzhQYjNZQVBGUm4v?=
 =?utf-8?B?L3ErTWFzWjZPN2F5Q3E1YVhwSFgrb2pxUWVNQ2RvZm9YV0YzOCt0WVhWbzU5?=
 =?utf-8?B?bVVCSWJCWWJUZENOOFhlN05RdGNYaFdmQm82V3BIb3BOTzRRMWRpUGhBdnpo?=
 =?utf-8?B?VnBnRmFnbHRUUllIVkp6cThuYmJvZ1BkZkJ6NHJjQmF0ODh2RGozUUFyZm4y?=
 =?utf-8?B?T2tGVzQ0bEVIeUVpejE1dXkxWmRaSGdJKzQxa2xLNFFGbmFwUG11a2VTb1Jr?=
 =?utf-8?B?UFh6M3Bmb1FFTkppdGI0YXExVTBWTzk3RjB0QXhNRFNld0c4djAreXk2QjRo?=
 =?utf-8?B?TWJwc0NFaVk3TlE2VFVpaGZKeG4yVGd3aWxRa3U2c05uTVBDT3J3QmdHVkR5?=
 =?utf-8?B?TjVXVzlVam1mV1ZKb0tQSUlpK09UaG1zSU5zM2cwcmNvak56bnpTYzd1aDM1?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7DE0BFE75BC9A4292F897B0E0D1ABF6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb65aa4-f4fd-4fea-5254-08db7837aba8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 00:27:50.1217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EWCcF9eGip7eSSxkSbs3vMBWI/VsE9QNnhqlaXcq/T460vxqGyuDbV/96kPSryGj6t3PZNZYbLkzwwLzl/TDYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5818
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE1OjI5ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBUdWUsIEp1biAyNywgMjAyMyBhdCAwMjoxMjo0OUFNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gQEAgLTExMTMsNiArMTExNSwxNyBAQCBzdGF0aWMg
aW50IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KPiA+ICAJICovDQo+ID4gIAl3YmludmRfb25fYWxs
X2NwdXMoKTsNCj4gPiAgDQo+ID4gKwkvKg0KPiA+ICsJICogU3RhcnRpbmcgZnJvbSB0aGlzIHBv
aW50IHRoZSBzeXN0ZW0gbWF5IGhhdmUgVERYIHByaXZhdGUNCj4gPiArCSAqIG1lbW9yeS4gIE1h
a2UgaXQgZ2xvYmFsbHkgdmlzaWJsZSBzbyB0ZHhfcmVzZXRfbWVtb3J5KCkgb25seQ0KPiA+ICsJ
ICogcmVhZHMgVERNUnMvUEFNVHMgd2hlbiB0aGV5IGFyZSBzdGFibGUuDQo+ID4gKwkgKg0KPiA+
ICsJICogTm90ZSB1c2luZyBhdG9taWNfaW5jX3JldHVybigpIHRvIHByb3ZpZGUgdGhlIGV4cGxp
Y2l0IG1lbW9yeQ0KPiA+ICsJICogb3JkZXJpbmcgaXNuJ3QgbWFuZGF0b3J5IGhlcmUgYXMgdGhl
IFdCSU5WRCBhYm92ZSBhbHJlYWR5DQo+ID4gKwkgKiBkb2VzIHRoYXQuICBDb21waWxlciBiYXJy
aWVyIGlzbid0IG5lZWRlZCBoZXJlIGVpdGhlci4NCj4gPiArCSAqLw0KPiA+ICsJYXRvbWljX2lu
Y19yZXR1cm4oJnRkeF9tYXlfaGFzX3ByaXZhdGVfbWVtKTsNCj4gDQo+IFdoeSBkbyB3ZSBuZWVk
IGF0b21pY3MgYXQgYWxsIGhlcmU/IFdyaXRlcnMgc2VlbXMgc2VyaWFsaXplZCB3aXRoDQo+IHRk
eF9tb2R1bGVfbG9jayBhbmQgcmVhZGVyIGFjY2Vzc2VzIHRoZSB2YXJpYWJsZSB3aGVuIGFsbCBD
UFVzLCBidXQgb25lIGlzDQo+IGRvd24gYW5kIGNhbm5vdCByYWNlLg0KPiANCg0KSW4ga2V4ZWMo
KSB0aGUgcmVhZGVyIHJlYWRzIHRoaXMgd2hlbiBhbGwgcmVtb3RlIGNwdXMgYXJlIGRlYWQgdy9v
IGhvbGRpbmcNCm1vZHVsZSBsb2NrLiAgQWxsIHJlbW90ZSBjcHVzIGNhbiBiZSBzdG9wcGVkIGF0
IF9BTllfIHRpbWUsIG1lYW5pbmcgdGhleSBjYW4gYmUNCnN0b3BwZWQgcmlnaHQgaW4gYW55IHBs
YWNlIGluIG1pZGRsZSBvZiBpbml0X3RkeF9tb2R1bGUoKS4gIElJVUMgdGhlIG1vZHVsZSBsb2Nr
DQpkb2Vzbid0IGhlbHAgaGVyZS4NCg==
