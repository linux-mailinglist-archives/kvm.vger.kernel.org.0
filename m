Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5286636A2
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 02:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbjAJBTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 20:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbjAJBTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 20:19:18 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598EBE0BC;
        Mon,  9 Jan 2023 17:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673313557; x=1704849557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xh8e5q+DPEX58SXRVJkIKay5bT0Hsv4BXaxO/mrHtkw=;
  b=C5wn2Ec6IgPTrtVmcQK8YxCGwzubjMC6SzSPAuosaihzh3fA9KF+C+uH
   4QPQRLc79wKwRLwwSRFnUHsoA3GFdWsamGYKvFXR2YQh4RNweqhtU91iu
   0IpAz+RrSSn9n46bGVoKunFUcxBuS+uNtwfgaEkXtIQ1NkT3iAK04+BQP
   Gdx3Wt29IbgPPgpAJwiCrvob+gcPbfJ0F9iqZ+8XgHVLTAnskiPNppBw7
   c1VuPFI+N9fDXY/yfzOXwLQLSFAY898mkMT+wl8BuIinDWYsARE4b9juE
   jAwZn3DYJI8L1Yyn6utKsCS0PtnAQEfoHUz+JQ5WJd+ngPIxhod2vYqr2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="310827574"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="310827574"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 17:19:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="725368829"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="725368829"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jan 2023 17:19:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 17:19:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 17:19:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 17:19:15 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 17:19:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0pUCjDbvJFgB9vwWG/YAnyDf9GnJ1rwBvOqNe9JGDw4v/EQHLZ0cS3S73A9i3g0OZZMZuC0wZhe4QBieu+pen8DhoLXZsYl507EdtkTUV6gsO5RQTAkndqoNzVsfxvIOkSZl+CJ7Y06xO/gsapNO26erYIiw4lsVXcd1/KZzxj3af8dQl4rrVRw0GcmaRyD+jjTv+QXOdzZH4YzC71Dd8ELd/OhBS8X6AAPCZ90Lfr8kL7g6DH3akTC6mHiPxvRRNplY7e/PAjRy+4oshZz7ikKr8FBCfL8Nn5dyfurtWFgmKdUmt0mCqs03McBuSR1rb0Poh3tAGOxkzFxEJW2jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xh8e5q+DPEX58SXRVJkIKay5bT0Hsv4BXaxO/mrHtkw=;
 b=G3wWowdTJ7Dq5WxgulTgWHEAXlITiazoir3N8RR5ADAnbd/r06hjbUCDIVTIndHvOYlKKhohAsFW4wv2mcytKu3yiP+7lmzKqttwKUEps+lBQ+ZT8n9pzAWpwcGSa+Fr9v4i8SbDpSNeuEmtcgDctp0hlpBndwFqC8wcRDrzcjO0/rLVN7NEac9Tqbf2yDPiJuespwhVampGQs/8SvBOGwNS4BhgRZJgm/ARFbKislTOSB6i1kKxQY4Y1qDxE6NBZ0s6Qf6ANh4WuF1fOS0wxt0CI3aJA4wvWIXSHWUlylHbq1l3xA3U8j32DzUPOFn6IpNlayo1FjiMdlEIhEkBCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 01:19:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 01:19:11 +0000
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
Subject: Re: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Thread-Topic: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Thread-Index: AQHZC5gQ3FCTeDpWDE6DayveLyjo/66SH22AgATsd4A=
Date:   Tue, 10 Jan 2023 01:19:11 +0000
Message-ID: <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
         <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
In-Reply-To: <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4522:EE_
x-ms-office365-filtering-correlation-id: 361a7680-21d9-42e9-fdc2-08daf2a8adea
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oFBPCI34TJVvDii3RKu8afpHBHDmNPzhlqWPCAdLCqTcHzJj2lL+NMDS17ZSfrenCs80ULKAyMJSjgeHXmAPbDj0Ve+bWSi4JRNZgFmmXLRjfDVdOyMBUnk/HxOYMfUP7hZX239KMR7F7XKjxjrS/k6adHYavg47YXWRdBza6msudZK4GBleJVrYcNklP/R5fovbdm01J8nur2xfxCxzcgLyZih1xnn6Vq2eulTpwOLvNjbmWf7S8xAH+ftaoVTM8kM4Cr0wQdqUbiq+pTDmugUDJDJDKYG+13oO00RxauBRCUKl5RJDuJYFYinlr0vaeFsmQzd8IDk2pJOq6jGb6qWdNDsM1RMBqukk3hWsc1Hlwgt4zHd3pX4jT25jAkIE6IUG46UPPy4MRC+JxQWnuxaWHnyEGmyoaSfG7TrGk0AsMIenMmGyQnQimbKszqc1jj2V+Hfbw42dMJohctaMapu6vyl7TW6r2lcQ+WpnUL1wI+l35wjEFsIENq9OwByWE1Q7UhACcwmlWVZu/fOXKsIz3NySc/NpHR6Ri7OTranbHeGsDX4TF84Upxu0Ls7NqMmB4hQ19UZLSY5WC2wCf+iuC3gr1170QUKQDNkD595hxdK5+XJcyZaXO9lprH5MWJ/aKcqGZb/1nS4e72eMKnhslA3TLT4c0lRAYvAFwNEhrJb1xe/bYB+A6LvB9QOUwomkRI1O/Ud8+LFfg7dSYTce5xef+C+APg3Z9UuVvH0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199015)(36756003)(38070700005)(86362001)(76116006)(66556008)(66476007)(8936002)(2906002)(8676002)(4326008)(66446008)(64756008)(66946007)(7416002)(5660300002)(122000001)(83380400001)(38100700002)(71200400001)(6486002)(478600001)(54906003)(110136005)(316002)(91956017)(82960400001)(41300700001)(53546011)(2616005)(186003)(26005)(6506007)(6512007)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkpOMERldG5mVFdyS1ZYd0VsN1ltVHowTFZLNGtKd243YWVSUzNDbWNydG5U?=
 =?utf-8?B?TEZyMmxycng5emhVS090UFVJMTJpQW9oR1FxZUlNOEJjRVZVZUNjM01CbDJO?=
 =?utf-8?B?end3bDVSb28zTW8xd21ndjZzVGlmbHdwdTJnMWRldUVOZFNZUHJFODlXZytG?=
 =?utf-8?B?OHRIdDQzVFpLQzh4VHA2M2VqMlRRNm5GYlJuZ0liU21Ga2ZaNXYxZ0wrb0ZS?=
 =?utf-8?B?cmN0ZEE3Y3A4aTBhcG1HVFZETlZReXhtME5hUE5WMkpRNTVlNFdMaTlOeG05?=
 =?utf-8?B?akRzcmFsZkVYRklhZzJYcGUwVFh6blg2K2lEOFl0bkJZcCtEMXFNNDk5L2th?=
 =?utf-8?B?TTVuZWR4L21hRiswYTdpRXdqYVBSdDV6elpEUEU4N1h6UVhsNUxKSTZ1MVN2?=
 =?utf-8?B?ZWg3YjF2dmtlbFZ0V1F4V0dTUHRLSFF0cWdBSGQrUWpGZTZlSUhEaXpJelpP?=
 =?utf-8?B?WmFjOWI5QmJUb1o2a1B2Mi9jcXJZOVNqNk9RcHg2NlFucjdYQmp2cm1YWFNV?=
 =?utf-8?B?V3pIZWU4bFczMFJ6Mk1zNm55Q3JVcmpnTldiZmc0N1IwdmpzYlZyUElxTEZy?=
 =?utf-8?B?Sk9ZazJwaHkxY2VPNDhhYXVZRFhQWHl6clFSMjc3RnJUMTNjbHR5ZlVRN0Rw?=
 =?utf-8?B?a1ZlK0FoNzl5N2EwQTNJZHhYUHJTUGRXUmU4UnpiOVZ5Y043TUlvanl5YTZO?=
 =?utf-8?B?czhRZVo3RGhVSUc1L1czTXVTWHVFeEpDK0NpU2FUUk84YmxUT0RQaDhUME02?=
 =?utf-8?B?UDRQS0E4MXM4TEtXNGV5eTMvRU5JTWZXbm5BeGZSeThOZ0YxYUZzQzAwU0hN?=
 =?utf-8?B?Nmpnd3RuQllGTHhpS1l1a0FDM2xaV1hNdk9SRVFoTlJTRTVHejFSZmdkU3g5?=
 =?utf-8?B?Z0wrUUp3TE5UaGF3bThJQWZ2VUtBQlJvU2RvVGdFM1NhY0RqazBaeWtUN0hj?=
 =?utf-8?B?cUowQjNwdXg5T1crYU1pRzdFK3BqTnB3enpKUEtPUi8rM2FjempzK3FBdlRI?=
 =?utf-8?B?cVYxak92ZVhlSjk2TFcwSDU5akd6bTAyQkRJY24vSHlSMlJvbFo4c04rMEJD?=
 =?utf-8?B?MTdmTVkyMzZJNFd5cUMvS0RDa21xMzV5UGJ4RTRJVC85UFNjeXo5YXZ0eU1S?=
 =?utf-8?B?MTJvOVJodm1ZUzJGelVNTFRDbURHTis1QlVOejVKbWd1VlU2UzNFNWFlcS9t?=
 =?utf-8?B?eTcwelZhNTBkMnltdEYraGZNS2tkM2QweTlScDJKZW9OaDErSkNPR0xUeVAr?=
 =?utf-8?B?ZE1JWUZQSnZiZDBQeVJldEw0T1JxU1loRy9EdUtMTHRPMjhXb3RVelVER2Jq?=
 =?utf-8?B?ODJ4MXBnNmU0SlZjRHdtNjQyOXk1TWI3NXErbG04L2VyQmorc2MrQUxTVGxM?=
 =?utf-8?B?YlVqd3lLREFkMWEvdGxqMGo0UDQ3SlNvd2xtOGc0eEdXWDBCa1FrNXVvbUpL?=
 =?utf-8?B?REozc2pTaHNIcFBFS1J3VkFmeGJFV1BKMmh3MHl5cGxkNzF2ZDBkeCtCYW5X?=
 =?utf-8?B?ZksrTkE0Ym1FdHJmNUNJK1FyWEhVNUllSkhkSC9NWkkvWEh1UlBWNXY2d2Fh?=
 =?utf-8?B?WnZJNUwwQ2wza0FjaC9NVXRKT25EdFNiSlhSZHRoMjRVVHFlam9ZWGUzOWFk?=
 =?utf-8?B?ck9vYU1WV240cHFPNEVtclg4RGhqU202YmhkNFZwOVErQUQ0ODJVeEszM3JN?=
 =?utf-8?B?NHlHZzFjZkRsZWJwYzYrT00wRytiMnJzQU1LTmNEQnN3cUdmZnpEeW5hVWlC?=
 =?utf-8?B?bGJqZHNsM0RidkovWDZENkdWcG1WLzFqRmZUYUV4WklQWmpoSUtXWjhLNVVh?=
 =?utf-8?B?Mll0UTBnUTF0bFUzOFVCZXkzSVFPaUpVVXNBbDZjeXNYOU1ZM0t1ZUFOS2to?=
 =?utf-8?B?L081ZnlRV3NnS2ZNRWVUZjhock9RMERBalJMOS9BeVNydFIwbVg4SVdwTC9a?=
 =?utf-8?B?SkI4SHRSeXVYT0ZhUGpVTGhSalZMRHBSUEVOM0ZZV3h4T1NybHQxMGRBSEtK?=
 =?utf-8?B?cDVBYXMvR2lRdnNaZjBMeXlJNmszZ1Y2ek9qRkZsN05ZZW5OVTdhTFpJU2F1?=
 =?utf-8?B?MlRvOTN2SnBidFQ3ZHJOL0FGRHRJRWl2MGJiSmpOaUNpTjIwa0tnQnplK25D?=
 =?utf-8?B?SG9GTTVwWnR2VHJ4NzBIYXNhMXhwRVgxSGV2aVkwQWduZEJVY1FCNzFianBD?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E4FF6C77FEB0A40B96EBAB574D681F0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361a7680-21d9-42e9-fdc2-08daf2a8adea
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 01:19:11.2320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ewUsf2E5g5WSY34qCcv8K3jp4zNs3SIZzJLkX6EDOXaOmS+4hKI1eWkdURRIHsMx9z+v4I9G0EbxudjO+CruhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4522
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDE0OjA3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAyMjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ICtzdGF0aWMgaW50IHRkbXJf
YWRkX3JzdmRfYXJlYShzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yLCBpbnQgKnBfaWR4LCB1NjQgYWRk
ciwNCj4gPiArCQkJICAgICAgdTY0IHNpemUsIHUxNiBtYXhfcmVzZXJ2ZWRfcGVyX3RkbXIpDQo+
ID4gK3sNCj4gPiArCXN0cnVjdCB0ZG1yX3Jlc2VydmVkX2FyZWEgKnJzdmRfYXJlYXMgPSB0ZG1y
LT5yZXNlcnZlZF9hcmVhczsNCj4gPiArCWludCBpZHggPSAqcF9pZHg7DQo+ID4gKw0KPiA+ICsJ
LyogUmVzZXJ2ZWQgYXJlYSBtdXN0IGJlIDRLIGFsaWduZWQgaW4gb2Zmc2V0IGFuZCBzaXplICov
DQo+ID4gKwlpZiAoV0FSTl9PTihhZGRyICYgflBBR0VfTUFTSyB8fCBzaXplICYgflBBR0VfTUFT
SykpDQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKw0KPiA+ICsJaWYgKGlkeCA+PSBtYXhf
cmVzZXJ2ZWRfcGVyX3RkbXIpDQo+ID4gKwkJcmV0dXJuIC1FMkJJRzsNCj4gPiArDQo+ID4gKwly
c3ZkX2FyZWFzW2lkeF0ub2Zmc2V0ID0gYWRkciAtIHRkbXItPmJhc2U7DQo+ID4gKwlyc3ZkX2Fy
ZWFzW2lkeF0uc2l6ZSA9IHNpemU7DQo+ID4gKw0KPiA+ICsJKnBfaWR4ID0gaWR4ICsgMTsNCj4g
PiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiANCj4gSXQncyBwcm9iYWJseSB3b3J0aCBh
dCBsZWFzdCBhIGNvbW1lbnQgaGVyZSB0byBzYXk6DQo+IA0KPiAJLyoNCj4gCSAqIENvbnN1bWUg
b25lIHJlc2VydmVkIGFyZWEgcGVyIGNhbGwuICBNYWtlIG5vIGVmZm9ydCB0bw0KPiAJICogb3B0
aW1pemUgb3IgcmVkdWNlIHRoZSBudW1iZXIgb2YgcmVzZXJ2ZWQgYXJlYXMgd2hpY2ggYXJlDQo+
IAkgKiBjb25zdW1lZCBieSBjb250aWd1b3VzIHJlc2VydmVkIGFyZWFzLCBmb3IgaW5zdGFuY2Uu
DQo+IAkgKi8NCg0KSSdsbCBhZGQgdGhpcyBjb21tZW50IGJlZm9yZSB0aGUgY29kZSB0byBzZXQg
dXAgcnN2ZF9hcmVhc1tpZHhdLg0KDQo+IA0KPiBJIHRoaW5rIHRoZSAtRTJCSUcgaXMgYWxzbyB3
cm9uZy4gIEl0IHNob3VsZCBiZSBFTk9TUEMuICBJJ2QgYWxzbyBhZGQgYQ0KPiBwcl93YXJuKCkg
dGhlcmUuICBFc3BlY2lhbGx5IHdpdGggaG93IGxhenkgdGhpcyB3aG9sZSB0aGluZyBpcywgSSBj
YW4NCj4gc3RhcnQgdG8gc2VlIGhvdyB0aGUgcmVzZXJ2ZWQgYXJlYXMgbWlnaHQgYmUgZXhoYXVz
dGVkLiAgTGV0J3MgYmUga2luZA0KPiB0byBvdXIgZnV0dXJlIHNlbHZlcyBhbmQgbWFrZSB0aGUg
ZXJyb3IgKGFuZCB0aGUgZml4KSBlYXNpZXIgdG8gZmluZC4NCg0KWWVzIGFncmVlZC4gIFdpbGwg
Y2hhbmdlIHRvIC1FTk9TUEMgYW5kIGFkZCBwcl93YXJuKCkuDQoNCj4gSXQncyBwcm9iYWJseSBh
bHNvIHdvcnRoIG5vdGluZyAqc29tZXdoZXJlKiB0aGF0IHRoZXJlJ3MgYSBiYWxhbmNlIHRvIGJl
DQo+IGhhZCBiZXR3ZWVuIFRETVJzIGFuZCByZXNlcnZlZCBhcmVhcy4gIEEgc3lzdGVtIHRoYXQg
aXMgcnVubmluZyBvdXQgb2YNCj4gcmVzZXJ2ZWQgYXJlYXMgaW4gYSBURE1SIGNvdWxkIHNwbGl0
IGEgVERNUiB0byBnZXQgbW9yZSByZXNlcnZlZCBhcmVhcy4NCj4gQSBzeXN0ZW0gdGhhdCBoYXMg
cnVuIG91dCBvZiBURE1ScyBjb3VsZCByZWxhdGl2ZWx5IGVhc2lseSBjb2FsZXNjZSB0d28NCj4g
YWRqYWNlbnQgVERNUnMgKGJlZm9yZSB0aGUgUEFNVHMgYXJlIGFsbG9jYXRlZCkgYW5kIHVzZSBh
IHJlc2VydmVkIGFyZWENCj4gaWYgdGhlcmUgd2FzIGEgZ2FwIGJldHdlZW4gdGhlbS4NCg0KV2Ug
Y2FuIGFkZCBhYm92ZSB0byB0aGUgY2hhbmdlbG9nIG9mIHRoaXMgcGF0Y2gsIG9yIHRoZSBwYXRj
aCAwOSAoIng4Ni92aXJ0L3RkeDoNCkZpbGwgb3V0IFRETVJzIHRvIGNvdmVyIGFsbCBURFggbWVt
b3J5IHJlZ2lvbnMiKS4gIFRoZSBsYXR0ZXIgcGVyaGFwcyBpcyBiZXR0ZXINCnNpbmNlIHRoYXQg
cGF0Y2ggaXMgdGhlIGZpcnN0IHBsYWNlIHdoZXJlIHRoZSBiYWxhbmNlIG9mIFRETVJzIGFuZCBy
ZXNlcnZlZA0KYXJlYXMgaXMgcmVsYXRlZC4NCg0KV2hhdCBpcyB5b3VyIHN1Z2dlc3Rpb24/DQoN
Cj4gDQo+IEknbSAqcmVhbGx5KiBjbG9zZSB0byBhY2tpbmcgdGhpcyBwYXRjaCBvbmNlIHRob3Nl
IGFyZSBmaXhlZCB1cC4NCg0K
