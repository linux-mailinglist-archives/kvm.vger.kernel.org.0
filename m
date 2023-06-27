Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023EF73FB50
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 13:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbjF0LqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 07:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjF0LqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 07:46:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED46F4;
        Tue, 27 Jun 2023 04:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687866378; x=1719402378;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DfBwGJmkxudvKfmOrMQkcQ5+Z7dAAreMDkAsZ0z+tqQ=;
  b=hp+RToZYWNtH+zx0Q15qEMXgMVMn+O/G78hEGLO0dkEWR5Zix0Q+9scu
   AIXFbkOMoghHqbxmODN+Lyk7q0rHGVVVt+18n69XLnB81+OdZjg80hPAE
   n9ME19X1O5kuAkOIUiWc+Bgostl57KF4UNrEoFfhnm20MmtsjS4pb5duj
   D5DLG06FUBfoXYEnKLLrzWWa6esar36zkZ7Q2JUFgU6ow/Lg7yjPtiDy6
   ZO817O+0ymz9fnD2nmghZl68kLisCFs0Hu7KmVFyfrx0lELDItysNkhmb
   bMtt7tZXN7P/8iCitif3gGFEMARS0xqEpHHl0dw17Y48En4OpeFxQcodw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="425217995"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="425217995"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 04:46:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="746169943"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="746169943"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 27 Jun 2023 04:46:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 04:46:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 04:46:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 04:46:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 04:46:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWEv17b9zkyhr+6+hGCq9iR2f9GBf4Em7hmnVXM0fgT9XTSgrk3MLSg8O5Bai6+ZC8RTJ2ak872gMGC19wO5orHCip68r27JoPWp5+NMgMagiKCOUZ1tvOnWkzJv6KcKotc4pQR63uggOxXFkTDYfkVzdoLy5TxdKyqoq6SErAddDz6XwBuM9pt24LVu+aFQhBaUC2UxLyQyU3D+XxbRIaqhPrVZIbWHTpNAgAoagEnirXRIE9y6+NUCI7cIU0elXc+NXdPao+MbrhL6c7Pz/92JQU5qXXnu6to12eqW3PJ4V407h2K0WsJYqj4rQtoiscu/x9TsAweao9onnRSohg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DfBwGJmkxudvKfmOrMQkcQ5+Z7dAAreMDkAsZ0z+tqQ=;
 b=d+VOrpgp3pHPJWBb431heV5T/uD9TdPR5JQv3QpEh64Ip+sQpi6SAl73mG7HswuZaPMoDlEIWsvOMHoE/EL4hlpsUNNW9G8CAZtGnhuTa56bN1810wIHZPxeEDB1PCYv1itPyyELsqEqx8TV3Tc5mp1eeWoI5e0YDWEImtly1vxHIntRwQTlF2/9FiS1Y41H1rtMWcXjAMdeuPoxzDN6J+SKiI7+CZcE2qNv3jXGB5jKrgP2uwuPl+zc3eawut1EEkOCEoutBwVIZ5QdLq78pQggi2rIapCDKWa+w/MzWerIZMBELH1kgFPpMg3hK5rthaLhWckz1wzC4ewx8sv95w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7994.namprd11.prod.outlook.com (2603:10b6:806:2e6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 11:46:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 11:46:11 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
        "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHZqDWtVIac1znuLUmerNJjHJZ1la+eaXIAgAAPH4CAAA6gAIAAAlGA
Date:   Tue, 27 Jun 2023 11:46:11 +0000
Message-ID: <fbebd02d5ee0121811903ed1dd669d3c6ec84689.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
         <20230627095124.nhiypr6ivi4kdfrw@box.shutemov.name>
         <49f197f7756ac05b99717a9f63d56cfb860ab88b.camel@intel.com>
         <20230627113752.djyxgt4io6aiixwy@box.shutemov.name>
In-Reply-To: <20230627113752.djyxgt4io6aiixwy@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7994:EE_
x-ms-office365-filtering-correlation-id: 608790c0-e68f-47fa-3dd5-08db77041af9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bvOy5yVjV3vA/HdrdsjYsrpU0ZsiXHjV7BztrJNOmNQbhebESRPhVcCJrSnZC22mywof9YRa4F7LVu6Nb+O+HXlZGUgTa6tl08sAXDePRJL+aL9MbaLsJ8F5pGq+slVoU1OXsintRcFJZHqp5U9T6qeKwvjuSPOl5SQ2qS3ahtqwUgywG6jcQ9tHkB7f+cboCCG0oA+qp6Gjfhpnk2u7wPWG82HylYyi6sdeo7NKIBInCOEyLXhOReclWx1aEFWEPyAJ559AGSoWZqlZod6dDuQXKaxhfsRS9I/rulsEWaZsgG5Hu7FOwW9da99+oRUEf6787mZWZa69t1jFIgVcoNOusm/QSO1k9BwxQlIAL+HVhpmG6Xpfj1yz+q1wFLxFeQu5j7Kl2SKQGZOvCKgiuRHklpYJGOie13ZhujtoauNAM4a6jW4Kv16W8TaMyl0fO1jlju/PVibUWkoczEsyXZrioJVyvpF6zGb+dFgPBiXqzmXn6PspxlNBEFdRnWjbNfU8oATF0dgO8c9RmmQOtpyGU3n8F66RBznHQPSl5F6OXSFAVm30Weq8k3hZO5sKvgKgw+ju7IMDI6Izc9SgubQXeJpGIqtkWWgA8AJq887Dl5FKfrm3tjdEGCKb8NX4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199021)(6506007)(2906002)(26005)(71200400001)(6486002)(122000001)(82960400001)(38100700002)(2616005)(83380400001)(186003)(6512007)(41300700001)(86362001)(54906003)(478600001)(38070700005)(4326008)(76116006)(6916009)(66946007)(66476007)(316002)(66446008)(64756008)(66556008)(36756003)(8676002)(91956017)(5660300002)(8936002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFJ2UDJyMy9wdWlEeFoyRmJQSS9ZQjc0SWZmNE1Gbjh0TmV1M3V6S3VrNEFk?=
 =?utf-8?B?U05BZHgyZEx4TEQrM3c1RUJaNEtZck4xa084djFBaTUwQ0N2Wkk0OU9TYVdV?=
 =?utf-8?B?alJxK21hYmtBSmRIR2JCNzJHang4dnh4emhrNDNWbTNZazByS3ByRnFXR3Zw?=
 =?utf-8?B?eThLZHA1NjhDN1A0RDRsaXFabThvVnlUUVVQRVc2YTJza1NqNXJCUlczdlNn?=
 =?utf-8?B?ZnJLOG9Sb1UyOVFmUzMzYys0eStkTWpaTkpVY1htRjJOcjNiNHQ0Vmg1a2Nx?=
 =?utf-8?B?bVJvSWlReGZucTBMVXBkSm51bHB6cWtlemRla2JybUpjVTIwWGRHNVdwVmlV?=
 =?utf-8?B?VXFCR1I0TVN2SVRGRVRCWk5oZjljQnFjbEtIRW1xNTZXdGJMcmFCM2VNQ2ZG?=
 =?utf-8?B?MTFGNTVVODZNY3J5ZTFLb3NPOGs2N0xNU2dXL2FCNUhBYXVSdnZhbnpRRGd3?=
 =?utf-8?B?MzJBQTIxd2VONUtmRFdnZ3dxQ3JSYnhhaVg0am9iNEJLS0xCNXZsdDR3TWpm?=
 =?utf-8?B?TUYrOVNuMGFtTVdBWjhTSmVDSTBhdlRWQkJhQWVXVktFZys5T1l4OVZmdzRT?=
 =?utf-8?B?SHlRKytUVzc4a3V5RHB0cmxncmo0U0d4cXZqT1JrSWtWOTZDQjBEY2xKQ3lH?=
 =?utf-8?B?ZHozMFRjZHMyNVRFeWl1RjcxVlJtcmp4cVNaMHRINkpRUCtqU0NyeUxoOHpk?=
 =?utf-8?B?Umx6Z0NZcWpSWnREdVY3Y3dwZmtMVm1TMmM4LzhqSEJuRWVHVElSclJNcWho?=
 =?utf-8?B?ZEorTnBoQWFWSldmdkVSTjBYeThGRkxxSWZqbFh5STVJTTBzVWpmcDR3bzU2?=
 =?utf-8?B?aDlEc3F3N1d2c1h0Ym5jTHp6YXdJYzR2THdWaWc1bDRUMzdSM0tDZ1ZMNXhY?=
 =?utf-8?B?OGFBbTJ1Z3RQTUVtTkpNRkNYSzdxdTNoZHRSVTh5dHN4VHNyd29iWnYzTDBT?=
 =?utf-8?B?WjYxNnFkdW5HaGxVTGZTNzM4bDRiaUNIN01tNXRyRmFqWloyazE3OFIyUkFt?=
 =?utf-8?B?YzBoUEZWS2R2Q1RhSU9rNlI1MnRCYmVYejM4dW1pTkhOajhEeld0NGpFOGc0?=
 =?utf-8?B?Rk9DQ0RKakg2RXZ2NWZtU1RBVmlmdUkyRVAvQWViRitING56ZU5rcnpZQlNk?=
 =?utf-8?B?cVduby9tcWwwcWxMck1pZmJ5TU01SnErTnhiU1l5TjZVbXpqNEM1NzgySXN6?=
 =?utf-8?B?S3RSdS9zWWdqN1dnb2w1Z2NLak43RzFreTBVV0Fuam9MdjM4bEx4b2ZCcHJp?=
 =?utf-8?B?ZXhkMEZtN0hVeWtNd1lyMWtnT05WeVk2RU1tRUVibXROVURIay9zSlhuMldz?=
 =?utf-8?B?RU5IejZlTGFrOXdvMm85WHFuMTZHU0NXTXdXZm9FNTQrM2ZiWm44OUhjbUt4?=
 =?utf-8?B?bXpIUUMvRzlteWNWazdONTQ4R1FBNFVDRnBHZUE3ZjIwWit6Zy9LK2R5WHg3?=
 =?utf-8?B?bW9IUTAxWWc4Z1hmd1d3VlJvRnNRS0RWOThFclE3VkJhbXJ2OWVybDNZbUk0?=
 =?utf-8?B?TXhCM2tSQ3hiby9VRVFrUTlHNHI2bk1mK2grbEwwc2dyVmdFUnEvb3BkT0o1?=
 =?utf-8?B?RXpQWWlvemg2Wm5ia3htOHJEZGZydWFGZ0lRMUo3b3c0ZFJpbGlhN3FMaDZB?=
 =?utf-8?B?SDRRbHByMGJyZXd3RFQwQ2FDeDFDeVMvOCtKek5SL2tzK2d6R2I3ZnFPS2sr?=
 =?utf-8?B?VHBJVk8vcDliSzRmZjFUSzVSRlYydlIyY0FXL3R3eERLUnZPajVWZU9NY3Nz?=
 =?utf-8?B?Nzh0Y20wQXNQTUdwVmZ6WTkyU0lyYnk0c3pscEZ1MWtUNnlwNUVZenk5Skt4?=
 =?utf-8?B?UjN2eTFrb3k1QTBwQzVaWFhFemc2TUp4UEtDVDJweUZnQktLQlIwbm95VjlP?=
 =?utf-8?B?OUZlcER5TytIUWgxUDBsTTlTc0dOK0hKNFFNVEpVQXNxZ0VVSjhqd081Wm93?=
 =?utf-8?B?Sjc1dGExSnBmcitSSndTSGkwTHhRc3grTzZLMDcrdnN1c2FiQWJ4cGtNUHE0?=
 =?utf-8?B?cTlKeFFySHhXdW13MnZpY2o0NUxJcTdYNjR4WG9TMy94YmRkcmEvRHp1VlMw?=
 =?utf-8?B?UGFFRkNvT1hiMkdTT3FoTk9iSXA3SHNvc1JWQVNYeEUvUkJLTmo1cXVud0Ix?=
 =?utf-8?B?YUlqZlFoc3hQa2VkVUNEUk5pZHMyMC96VlI3WXRwQmUrb1RFNTFrZlZYN21n?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1D93182BF5F384BA6422B57EC068454@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608790c0-e68f-47fa-3dd5-08db77041af9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 11:46:11.8850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ew0na8iSr7FD2q8wrHZbSmpXVeg1zkYiCiYcyjK0tqVIq5eCgpKZC34F+iu7wOpeZREdrKpaIq/a4EmBcbjhcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7994
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

T24gVHVlLCAyMDIzLTA2LTI3IGF0IDE0OjM3ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBUdWUsIEp1biAyNywgMjAyMyBhdCAxMDo0NTozM0FNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMy0wNi0yNyBhdCAxMjo1MSAr
MDMwMCwga2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNvbSB3cm90ZToNCj4gPiA+IE9uIFR1
ZSwgSnVuIDI3LCAyMDIzIGF0IDAyOjEyOjM4QU0gKzEyMDAsIEthaSBIdWFuZyB3cm90ZToNCj4g
PiA+ID4gIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ID4gPiA+ICB7DQo+ID4g
PiA+ICsJc3RydWN0IHRkc3lzaW5mb19zdHJ1Y3QgKnN5c2luZm87DQo+ID4gPiA+ICsJc3RydWN0
IGNtcl9pbmZvICpjbXJfYXJyYXk7DQo+ID4gPiA+ICsJaW50IHJldDsNCj4gPiA+ID4gKw0KPiA+
ID4gPiArCS8qDQo+ID4gPiA+ICsJICogR2V0IHRoZSBURFNZU0lORk9fU1RSVUNUIGFuZCBDTVJz
IGZyb20gdGhlIFREWCBtb2R1bGUuDQo+ID4gPiA+ICsJICoNCj4gPiA+ID4gKwkgKiBUaGUgYnVm
ZmVycyBvZiB0aGUgVERTWVNJTkZPX1NUUlVDVCBhbmQgdGhlIENNUiBhcnJheSBwYXNzZWQNCj4g
PiA+ID4gKwkgKiB0byB0aGUgVERYIG1vZHVsZSBtdXN0IGJlIDEwMjQtYnl0ZXMgYW5kIDUxMi1i
eXRlcyBhbGlnbmVkDQo+ID4gPiA+ICsJICogcmVzcGVjdGl2ZWx5LiAgQWxsb2NhdGUgb25lIHBh
Z2UgdG8gYWNjb21tb2RhdGUgdGhlbSBib3RoIGFuZA0KPiA+ID4gPiArCSAqIGFsc28gbWVldCB0
aG9zZSBhbGlnbm1lbnQgcmVxdWlyZW1lbnRzLg0KPiA+ID4gPiArCSAqLw0KPiA+ID4gPiArCXN5
c2luZm8gPSAoc3RydWN0IHRkc3lzaW5mb19zdHJ1Y3QgKilfX2dldF9mcmVlX3BhZ2UoR0ZQX0tF
Uk5FTCk7DQo+ID4gPiA+ICsJaWYgKCFzeXNpbmZvKQ0KPiA+ID4gPiArCQlyZXR1cm4gLUVOT01F
TTsNCj4gPiA+ID4gKwljbXJfYXJyYXkgPSAoc3RydWN0IGNtcl9pbmZvICopKCh1bnNpZ25lZCBs
b25nKXN5c2luZm8gKyBQQUdFX1NJWkUgLyAyKTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCUJVSUxE
X0JVR19PTihQQUdFX1NJWkUgLyAyIDwgVERTWVNJTkZPX1NUUlVDVF9TSVpFKTsNCj4gPiA+ID4g
KwlCVUlMRF9CVUdfT04oUEFHRV9TSVpFIC8gMiA8IHNpemVvZihzdHJ1Y3QgY21yX2luZm8pICog
TUFYX0NNUlMpOw0KPiA+ID4gDQo+ID4gPiBUaGlzIHdvcmtzLCBidXQgd2h5IG5vdCBqdXN0IHVz
ZSBzbGFiIGZvciB0aGlzPyBrbWFsbG9jIGhhcyA1MTIgYW5kIDEwMjQNCj4gPiA+IHBvb2xzIGFs
cmVhZHkgYW5kIHlvdSB3b24ndCB3YXN0ZSBtZW1vcnkgZm9yIHJvdW5kaW5nIHVwLg0KPiA+ID4g
DQo+ID4gPiBTb21ldGhpbmcgbGlrZSB0aGlzOg0KPiA+ID4gDQo+ID4gPiAgICAgICAgIHN5c2lu
Zm8gPSBrbWFsbG9jKFREU1lTSU5GT19TVFJVQ1RfU0laRSwgR0ZQX0tFUk5FTCk7DQo+ID4gPiAg
ICAgICAgIGlmICghc3lzaW5mbykNCj4gPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gLUVOT01F
TTsNCj4gPiA+IA0KPiA+ID4gICAgICAgICBjbXJfYXJyYXlfc2l6ZSA9IHNpemVvZihzdHJ1Y3Qg
Y21yX2luZm8pICogTUFYX0NNUlM7DQo+ID4gPiANCj4gPiA+ICAgICAgICAgLyogQ01SIGFycmF5
IGhhcyB0byBiZSA1MTItYWxpZ25lZCAqLw0KPiA+ID4gICAgICAgICBjbXJfYXJyYXlfc2l6ZSA9
IHJvdW5kX3VwKGNtcl9hcnJheV9zaXplLCA1MTIpOw0KPiA+IA0KPiA+IFNob3VsZCB3ZSBkZWZp
bmUgYSBtYWNybyBmb3IgNTEyDQo+ID4gDQo+ID4gCSsjZGVmaW5lIENNUl9JTkZPX0FSUkFZX0FM
SUdOTUVOVAk1MTINCj4gPiANCj4gPiBBbmQgZ2V0IHJpZCBvZiB0aGlzIGNvbW1lbnQ/ICBBRkFJ
Q1QgRGF2ZSBkaWRuJ3QgbGlrZSBzdWNoIGNvbW1lbnQgbWVudGlvbmluZw0KPiA+IDUxMi1ieXRl
cyBhbGlnbmVkIGlmIHdlIGhhdmUgYSBtYWNybyBmb3IgdGhhdC4NCj4gDQo+IEdvb2QgaWRlYS4N
Cj4gDQo+ID4gPiAgICAgICAgIGNtcl9hcnJheSA9IGttYWxsb2MoY21yX2FycmF5X3NpemUsIEdG
UF9LRVJORUwpOw0KPiA+ID4gICAgICAgICBpZiAoIWNtcl9hcnJheSkgew0KPiA+ID4gICAgICAg
ICAgICAgICAgIGtmcmVlKHN5c2luZm8pOw0KPiA+ID4gICAgICAgICAgICAgICAgIHJldHVybiAt
RU5PTUVNOw0KPiA+ID4gICAgICAgICB9DQo+ID4gPiANCj4gPiA+ID8NCj4gPiA+IA0KPiA+IA0K
PiA+IEkgY29uZmVzcyB0aGUgcmVhc29uIEkgdXNlZCBfX2dldF9mcmVlX3BhZ2UoKSB3YXMgdG8g
YXZvaWQgaGF2aW5nIHRvIGFsbG9jYXRlDQo+ID4gdHdpY2UsIGFuZCBpbiBjYXNlIG9mIGZhaWx1
cmUsIEkgbmVlZCB0byBoYW5kbGUgYWRkaXRpb25hbCBtZW1vcnkgZnJlZS4gIEJ1dCBJDQo+ID4g
Y2FuIGRvIGlmIHlvdSB0aGluayBpdCdzIGNsZWFyZXI/DQo+IA0KPiBMZXNzIHRyaWNrZXJ5IGlz
IGFsd2F5cyBjbGVhbmVyLiBFc3BlY2lhbGx5IGlmIHRoZSB0cmljayBpcyBub3QganVzdGlmaWVk
Lg0KPiANCj4gDQoNCkFscmlnaHQuICBJJ2xsIGNoYW5nZSB0byBhbGxvY2F0aW5nIHRoZW0gc2Vw
YXJhdGVseSBpZiBubyBvcGluaW9uIGZyb20gb3RoZXJzLg0K
