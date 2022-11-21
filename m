Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D07631D1C
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 10:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiKUJo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 04:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiKUJov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 04:44:51 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A09614D25;
        Mon, 21 Nov 2022 01:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669023890; x=1700559890;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=84m1n638LW/BPr/nkgJLnU4RiOZlysbRhEb5DkTOxcw=;
  b=T2PLUXwFf2s/tjRRGlKEvsXRFfx1Ekhp8c+lriCQPEtI9WZmIZP2SNcP
   Ahz6mmK2A8eQtcCTJ69Rq+ENm2Gy8iDBhrXiwiaVgSLxEvhKA/CrVCKWo
   VGv1qgfMdxfFUwQX14hzdOWvWUFboAoTq4Za2osW+da3FRuv0TcJRY3E0
   3isITuEOBojeXVmnneIvFhk9yBZU5QTt19TvzLQNxy/DwFibaxxcCbnpg
   x9I+dVIJqWiEWjlYEui72L95lN9m5EnMddEz86dGtO62chfVfHwrsSVNU
   idtOvexa/ytcX7NCu5eXqDCS3kRn5swtZ48M9MW39U9KJz/vmUPcC/0OQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="399806704"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="399806704"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 01:44:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="746837708"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="746837708"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 21 Nov 2022 01:44:49 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 01:44:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 01:44:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 01:44:49 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 01:44:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fjpa4Qx/h4S/0j0lHpDIR5R2Cc8v6j9nxuSWTAy13ik5G6cGy75BzWtI5cjEUyi04lj9DLrWbP/oQqBTUuT/k3LfhFWLwIuvmGo2f9MEEywMWyu7TnSFYy71pKzqBQpztoH2K150Cv36ol4oo5gNsC2RmxKUTENmHMekbW419SKe0Sa/v2n/Lu3zD0dvRKGY/vnGoNKWi4yexRbUrxSfurVDwG+5uOf9llt1+m83vq7P6cfpHeGa8nR5nHt2vMusYGIN11PB5T0iL5ibIyDd9t6N91iY2LGeFSmSMUyhe53RPWge3IPA4MksAFQHOaBuM2mUJOChB0oD3mUl84DeEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84m1n638LW/BPr/nkgJLnU4RiOZlysbRhEb5DkTOxcw=;
 b=JQxdtlNlql4uG0nGKtRsNlopjAihhx9O1Od8sq5B0DXArT1YoPEq2daEwxenOq23XibNVQztyJ8CnHcUgFBX2pSSCfd1PDRn32oEWmgt9ygXD+xpvYfgkS3d+fOmsr2ZR5x3rFbiWgSXWtkS4fQEcfUKyCeaqjBy17U257JHvA6meBDRQNpFQKWkjUraScqs+D0LFvDSFdD/fjC7zANFedvgrGUJhsWmC80JiDCzE9+nPc5TDUjtr2+ycJwa6a5EXaZIx0DB9f3ZMZoEj92wW1IXYIRCeLtTarIPrIDNWSpyhLrZAjczfVHS4Ee699gUYzAC53QCX9xe4eWiqKNmxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5660.namprd11.prod.outlook.com (2603:10b6:510:d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Mon, 21 Nov
 2022 09:44:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 09:44:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Thread-Topic: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Thread-Index: AQHY/T2/qiNrCEbeGka7t7fkot0Cyq5IvpmAgABiqQA=
Date:   Mon, 21 Nov 2022 09:44:39 +0000
Message-ID: <31cb1df3cf21889fb33a7c675aa1bf5fa2078cad.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
         <62c67ed3-e4d1-082f-800a-b0837c9432a9@linux.intel.com>
In-Reply-To: <62c67ed3-e4d1-082f-800a-b0837c9432a9@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5660:EE_
x-ms-office365-filtering-correlation-id: c4fb7c3f-84c4-45c0-097b-08dacba50292
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bfi2+QppgfdkYCoIGwFNeN4yyxcFqRR7nMXNRKh8WvT/Ak/xgax+Ug7al0tgPmH9LjyZylbKy2eSemQyQTGljl8ScPd3qSzour9WadzfSQzmycgaeIK9dCj9WCryc2Go5XXHcnOj2zAdJ/8UyuAEr7n/Ergh1ULTuyGHdQf3KUDvif15ld8JNbHIWIaqmIcXhVDFY6Zp3LyM7dD1E6hF4nWTSqqcnKsUom0Yg3XBZ4ymZ4LRcaVcG1ig7rw1SdlZv4UUhvPnEICF1IiGz2omky06MtpO+1MOueF2a9BkgbCLC+5kcR4mKVLadb7iVAdqXN5Aa+MGJaT1vdRTozcj8JcGAtGSgjqLQl3scB+HT/XhqkjUjls6xq/CknFU7zYnMJ513rOo8OQDw3GNApq9g/mSCQyUSl1HOsF2JHi1DOl04VBBgcUgQZ0s2eyMmNPhx5QHQ2d1GNLpRsyOoSdZGWoipHV5msoppoCovacMuPJHKu4SFFK7zvv5Uy6gOzCMPeJCjaqyJXQkZHxLzcEhh52pMLp5UBM51/QICVvudu9EQDefLso6RIphi7EAXH1HzLWUGvQOjgbgMfFqrpPcQWHmA6RSfeUcvakl6dZEBjBC+Rwq9odwfbTvnGRQV3HrwgRWQ9C4R1Ih3cJy370O9h1hWaJi2a7yZg9oV2h0/Csc2vr+57NLsJPPrbv4grcfzNBasKvntArmnkxYsu7CGPGEcCbnPTgeEPfXT9nZfEKk/6I/LOoVYU/pqP1pR3qVkWRaYINPT8XcBHrNfNRSGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199015)(66556008)(86362001)(316002)(8676002)(6512007)(5660300002)(2906002)(122000001)(4001150100001)(64756008)(4326008)(66946007)(76116006)(36756003)(186003)(66446008)(7416002)(66476007)(41300700001)(2616005)(26005)(53546011)(8936002)(38100700002)(82960400001)(91956017)(6486002)(478600001)(966005)(83380400001)(38070700005)(110136005)(54906003)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUt1T0dnR3NCQUlQR3h4OStIQlBaOUdkV0hqVUF1eGVySlZEZXhpT1RETk5I?=
 =?utf-8?B?UXo0ekcwa21wT2xHa3hNSk5XM010cHZLK25DckpVdFlPNkh1UlpXZU95RVBZ?=
 =?utf-8?B?WHltUGxWMjhCUXFKemlBZ2V6RWJxL3BwNTNTOWxFYk8vRG9RSytsNEtmMkJm?=
 =?utf-8?B?RmN6R2ZzNkhrSk9ZTldDNjZTUXdOcnRFQlpvelNSWVk1clVDVlFJNGsxYWE0?=
 =?utf-8?B?dTV3OUJTSFczOGhkdkdIbG1qRVpyd295SnhWVnF1V3VLQzNKS1lreUFLS09o?=
 =?utf-8?B?dnZ2Z1VDZUpsU1M1T2FNVDUvYVhuNkdjbkJGc1Q5UE1iRlFtdVJINVVORm1k?=
 =?utf-8?B?dTBkbWVvbWRWaFlKMnplOEV2ZmNhYU9QdEsxOXJ6YUdzTEpSNGYvNEd5Zkcv?=
 =?utf-8?B?TjlEMzd4aHlPbUMvVjVNaGRDWkRON0o4ajE4elBwUFIrME56MUVYamlacVgw?=
 =?utf-8?B?N3hSQXlBRGo4L0VLZmhuOGJzcjd3cTlyOTd2ZzVQVmxXZzVhRlBnMlBoUlJE?=
 =?utf-8?B?TSttR2dibmxXWGVJSU1icHpDQzJqaEw1MU9aL3FoWkNYZTZXbS9ReVhoZTNv?=
 =?utf-8?B?SFJ1VkhRbE9WM3VRUWo0OENqSnFlZytNS0FpdFF2REpqL25aZ0RPdXJURUov?=
 =?utf-8?B?c1BSaTQyWTEzcVBEbWlTMVk1eXNBa0h6ZDU3eVFDdDdoU0w4UTJNS3F6UWxv?=
 =?utf-8?B?emVpbkVES3YyWHdLQUFHRTJlYUhTVFhwdjY0V3cwYmZOdEY1OVRCa2VnUWpI?=
 =?utf-8?B?d0FiMmE2ZjQ2c3g2Tlk5SS9ub0t6RWEwZkJqblNESUN5dG5rai91NytFMzZr?=
 =?utf-8?B?ZVMrRGY0MHNPaW9oK0JjRjdYT1pCa0ZVWm92b29keUtPVU55Q2xsbEtHTlBL?=
 =?utf-8?B?QkdCV3J3V2dTdE5xOVYvQjhiS1dwQi9iN1hPQTFpeVFJZUVadnF6ZFdkWGhk?=
 =?utf-8?B?eUVhY0ZjdmcxZjFoRjFTWnplWnRWcGJTNTNTbXBUaHdVNUwvQVMrSmtRcGE3?=
 =?utf-8?B?d254R21peWZWTUlXb3ZHcWxMVW9hMENCMGRuZkRzT3I1QkZlR0FubXltbGhX?=
 =?utf-8?B?MGp4RmhITDg0bjR5MjY2aFJMdEFqdHZiWC9Vbm00TkllYVppbVpQTEJmRFZi?=
 =?utf-8?B?V1k3Nk1sYzI0SVVVRDlYR2JpR2k1YkNWL1lhaUxjRzNxUGZNNjJUOEhVdWw3?=
 =?utf-8?B?VHA1ZHhkbEgza09WVWlZNzYyTEFoMFJjdHhLLy9DSFZ6bzRRdjhFbHFBblRv?=
 =?utf-8?B?Vlg1NXkwL0JGRnJ1amVvRDJISWlXZmlEaG96Qy8vSEdtQVJyV0NOM3llNGI3?=
 =?utf-8?B?VGE5Mml6T1RiN1A2RHFHWUtCTERyS3RVb0M3MkVsbkZhaVNCdHBXUGVJVG1P?=
 =?utf-8?B?cG9haUI0dnVlOC9aOWNRZTZtV3ltS3lucEh1cWJoL1BuM3ZReFNWSmRqNUU3?=
 =?utf-8?B?bytzMzhGUXJoc0lDMy9EL2FHa2QvVlhXbnF1YlNLV0hQSHBoVk5oVmk2QlJq?=
 =?utf-8?B?dDkwc1NuMzVaVi92U0NYRExmL0NTQWZ6ZEtPZDliNlAyWC9IV0VscDQ2UWJV?=
 =?utf-8?B?a2tzNGlTczNycnVqYmxGa1YwZXRVYndHT3owNTlVdzNqUmhua2sxUS9nd0cy?=
 =?utf-8?B?RzVJcHFpbEVHTUJjRWVQd2ZxcGxlVHBvS3o4QVhveS9PSUpCbEl1b2NvSmJv?=
 =?utf-8?B?cUVZYVcwNlJ4YlZjMDFIUEFVWFNTZDZqcXY1bGprQjBvZUp6VCt5bGJYTUh5?=
 =?utf-8?B?LzJiZ0hiNXVRQ3p0WnEzRWRNbDlkd0lWZjgydHQxZURJMHQzQzNQcTZZaytU?=
 =?utf-8?B?czk5dnUrMC9Vc3FDL3JVc1hvQ0c4di9DWm93TlpOM2d5UldUM000K01LWXdu?=
 =?utf-8?B?NHJ4N1ZjMDVORGVFb2FnUTJIdFJCdjQxcVRVdGJ0dy82cDRodVZSUjhRS3F2?=
 =?utf-8?B?czJkNVBqU2Q3SzBVQVVSTmhGbjNHSVNuZm1YOVd4a2h2aWphancydTZvcmgz?=
 =?utf-8?B?N3E3dCtCV1pScmhHSS9aZ2h4U0gzajNYZ3Z3eUdsMmllaHdoNXRyK2VoMU9Z?=
 =?utf-8?B?eDAwQ3JZTG43Nk5mcTF1RjQvSjhHQUNTQWx2T01pQUNmSk52Zk5abWI5bE0y?=
 =?utf-8?B?Zmo5MVFIQnNoaEljU1phcEh5cDhyTldpVWJRaUtQTnNXdk9QZDRRanVudEtT?=
 =?utf-8?B?WXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51242A6BEC9BC442A7D8988FB8855CDE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4fb7c3f-84c4-45c0-097b-08dacba50292
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 09:44:39.9357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4YZepq915Ags/z2bZZAtfZYg9/joCzZzQ4P2dqf0hkbT5rF3jlpPXFswuJG3Doaju50l35Pu/jK3UAafx/QVBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5660
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIyLTExLTIwIGF0IDE5OjUxIC0wODAwLCBTYXRoeWFuYXJheWFuYW4gS3VwcHVz
d2FteSB3cm90ZToNCj4gDQo+IE9uIDExLzIwLzIyIDQ6MjYgUE0sIEthaSBIdWFuZyB3cm90ZToN
Cj4gPiBUaGUgTU1JTy94QVBJQyBpbnRlcmZhY2UgaGFzIHNvbWUgcHJvYmxlbXMsIG1vc3Qgbm90
YWJseSB0aGUgQVBJQyBMRUFLDQo+IA0KPiAic29tZSBwcm9ibGVtcyIgbG9va3MgbW9yZSBnZW5l
cmljLiBNYXkgYmUgd2UgY2FuIGJlIHNwZWNpZmljIGhlcmUuIExpa2UNCj4gaXQgaGFzIHNlY3Vy
aXR5IGlzc3Vlcz8NCg0KSXQgd2FzIHF1b3RlZCBmcm9tIGJlbG93IHVwc3RyZWFtIGNvbW1pdCBp
ZCAoSSBvbmx5IGtlcHQgdGhlIG9uZSB0aGF0IEkgcXVvdGVkDQp0byBzYXZlIHNwYWNlKToNCg0K
Y29tbWl0IGI4ZDFkMTYzNjA0YmQxZTYwMGIwNjJmYjAwZGU1ZGM0MmJhYTM1NWYgKHRhZzogeDg2
X2FwaWNfZm9yX3Y2LjFfcmMxLA0KdGlwL3g4Ni9hcGljKQ0KQXV0aG9yOiBEYW5pZWwgU25lZGRv
biA8ZGFuaWVsLnNuZWRkb25AbGludXguaW50ZWwuY29tPg0KRGF0ZTogICBUdWUgQXVnIDE2IDE2
OjE5OjQyIDIwMjIgLTA3MDANCg0KICAgIHg4Ni9hcGljOiBEb24ndCBkaXNhYmxlIHgyQVBJQyBp
ZiBsb2NrZWQNCiAgICANCiAgICAuLi4uDQogICAgDQogICAgVGhlIE1NSU8veEFQSUMgaW50ZXJm
YWNlIGhhcyBzb21lIHByb2JsZW1zLCBtb3N0IG5vdGFibHkgdGhlIEFQSUMgTEVBSw0KICAgIFsx
XS4gIFRoaXMgYnVnIGFsbG93cyBhbiBhdHRhY2tlciB0byB1c2UgdGhlIEFQSUMgTU1JTyBpbnRl
cmZhY2UgdG8NCiAgICBleHRyYWN0IGRhdGEgZnJvbSB0aGUgU0dYIGVuY2xhdmUuDQogICAgDQog
ICAgLi4uLg0KICAgIA0KICAgIFsxXTogaHR0cHM6Ly9hZXBpY2xlYWsuY29tL2FlcGljbGVhay5w
ZGYNCiAgICANCiAgICBTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgU25lZGRvbiA8ZGFuaWVsLnNuZWRk
b25AbGludXguaW50ZWwuY29tPg0KICAgIFNpZ25lZC1vZmYtYnk6IERhdmUgSGFuc2VuIDxkYXZl
LmhhbnNlbkBsaW51eC5pbnRlbC5jb20+DQogICAgQWNrZWQtYnk6IERhdmUgSGFuc2VuIDxkYXZl
LmhhbnNlbkBsaW51eC5pbnRlbC5jb20+DQogICAgVGVzdGVkLWJ5OiBOZWVsaW1hIEtyaXNobmFu
IDxuZWVsaW1hLmtyaXNobmFuQGludGVsLmNvbT4NCiAgICBMaW5rOg0KaHR0cHM6Ly9sa21sLmtl
cm5lbC5vcmcvci8yMDIyMDgxNjIzMTk0My4xMTUyNTc5LTEtZGFuaWVsLnNuZWRkb25AbGludXgu
aW50ZWwuY29tDQoNCg0KPiANCj4gPiBbMV0uICBUaGlzIGJ1ZyBhbGxvd3MgYW4gYXR0YWNrZXIg
dG8gdXNlIHRoZSBBUElDIE1NSU8gaW50ZXJmYWNlIHRvDQo+ID4gZXh0cmFjdCBkYXRhIGZyb20g
dGhlIFNHWCBlbmNsYXZlLg0KPiA+IA0KPiA+IFREWCBpcyBub3QgaW1tdW5lIGZyb20gdGhpcyBl
aXRoZXIuICBFYXJseSBjaGVjayBYMkFQSUMgYW5kIGRpc2FibGUgVERYDQo+ID4gaWYgWDJBUElD
IGlzIG5vdCBlbmFibGVkLCBhbmQgbWFrZSBJTlRFTF9URFhfSE9TVCBkZXBlbmQgb24gWDg2X1gy
QVBJQy4NCj4gPiANCj4gPiBbMV06IGh0dHBzOi8vYWVwaWNsZWFrLmNvbS9hZXBpY2xlYWsucGRm
DQo+ID4gDQo+ID4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9kNmZmYjQ4OS03
MDI0LWZmNzQtYmQyZi1kMWUwNjU3M2JiODJAaW50ZWwuY29tLw0KPiA+IExpbms6IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xrbWwvYmE4MGIzMDMtMzFiZi1kNDRhLWIwNWQtNWMwZjgzMDM4Nzk4
QGludGVsLmNvbS8NCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRl
bC5jb20+DQo+ID4gLS0tDQo+ID4gDQo+ID4gdjYgLT4gdjc6DQo+ID4gIC0gQ2hhbmdlZCB0byB1
c2UgIkxpbmsiIGZvciB0aGUgdHdvIGxvcmUgbGlua3MgdG8gZ2V0IHJpZCBvZiBjaGVja3BhdGNo
DQo+ID4gICAgd2FybmluZy4NCj4gPiANCj4gPiAtLS0NCj4gPiAgYXJjaC94ODYvS2NvbmZpZyAg
ICAgICAgICAgIHwgIDEgKw0KPiA+ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCAxMSAr
KysrKysrKysrKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCj4gPiAN
Cj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvS2NvbmZpZyBiL2FyY2gveDg2L0tjb25maWcNCj4g
PiBpbmRleCBjY2VkNGVmM2JmYjIuLmRkMzMzYjQ2ZmFmYiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNo
L3g4Ni9LY29uZmlnDQo+ID4gKysrIGIvYXJjaC94ODYvS2NvbmZpZw0KPiA+IEBAIC0xOTU4LDYg
KzE5NTgsNyBAQCBjb25maWcgSU5URUxfVERYX0hPU1QNCj4gPiAgCWRlcGVuZHMgb24gQ1BVX1NV
UF9JTlRFTA0KPiA+ICAJZGVwZW5kcyBvbiBYODZfNjQNCj4gPiAgCWRlcGVuZHMgb24gS1ZNX0lO
VEVMDQo+ID4gKwlkZXBlbmRzIG9uIFg4Nl9YMkFQSUMNCj4gPiAgCWhlbHANCj4gPiAgCSAgSW50
ZWwgVHJ1c3QgRG9tYWluIEV4dGVuc2lvbnMgKFREWCkgcHJvdGVjdHMgZ3Vlc3QgVk1zIGZyb20g
bWFsaWNpb3VzDQo+ID4gIAkgIGhvc3QgYW5kIGNlcnRhaW4gcGh5c2ljYWwgYXR0YWNrcy4gIFRo
aXMgb3B0aW9uIGVuYWJsZXMgbmVjZXNzYXJ5IFREWA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni92aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBp
bmRleCA5ODJkOWM0NTNiNmIuLjhkOTQzYmRjODMzNSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4
Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmMNCj4gPiBAQCAtMTIsNiArMTIsNyBAQA0KPiA+ICAjaW5jbHVkZSA8bGludXgvcHJpbnRrLmg+
DQo+ID4gICNpbmNsdWRlIDxhc20vbXNyLWluZGV4Lmg+DQo+ID4gICNpbmNsdWRlIDxhc20vbXNy
Lmg+DQo+ID4gKyNpbmNsdWRlIDxhc20vYXBpYy5oPg0KPiA+ICAjaW5jbHVkZSA8YXNtL3RkeC5o
Pg0KPiA+ICAjaW5jbHVkZSAidGR4LmgiDQo+ID4gIA0KPiA+IEBAIC04MSw2ICs4MiwxNiBAQCBz
dGF0aWMgaW50IF9faW5pdCB0ZHhfaW5pdCh2b2lkKQ0KPiA+ICAJCWdvdG8gbm9fdGR4Ow0KPiA+
ICAJfQ0KPiA+ICANCj4gPiArCS8qDQo+ID4gKwkgKiBURFggcmVxdWlyZXMgWDJBUElDIGJlaW5n
IGVuYWJsZWQgdG8gcHJldmVudCBwb3RlbnRpYWwgZGF0YQ0KPiA+ICsJICogbGVhayB2aWEgQVBJ
QyBNTUlPIHJlZ2lzdGVycy4gIEp1c3QgZGlzYWJsZSBURFggaWYgbm90IHVzaW5nDQo+ID4gKwkg
KiBYMkFQSUMuDQo+IA0KPiBSZW1vdmUgdGhlIGRvdWJsZSBzcGFjZS4NCg0KU29ycnkgd2hpY2gg
ImRvdWJsZSBzcGFjZSI/DQoNCj4gDQo+ID4gKwkgKi8NCj4gPiArCWlmICgheDJhcGljX2VuYWJs
ZWQoKSkgew0KPiA+ICsJCXByX2luZm8oIkRpc2FibGUgVERYIGFzIFgyQVBJQyBpcyBub3QgZW5h
YmxlZC5cbiIpOw0KPiANCj4gcHJfd2FybigpPw0KDQpXaHk/DQoNCg==
