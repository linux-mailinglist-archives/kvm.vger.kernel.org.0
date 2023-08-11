Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B68D7785FB
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 05:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjHKDZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 23:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjHKDZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 23:25:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B114F2D6D;
        Thu, 10 Aug 2023 20:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691724326; x=1723260326;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O62uh7Rm2FVVJ2FvNBpjOTFLtT0Q0RlzThrIlmOtENI=;
  b=fTya1R3qswmt6L00y7H49AMsB4Z5KfvwSYSurwS8guWERQIj3L7dS6j6
   /0HjcSZqkkp6Qz2oavCCgVxa/9sHqi6v+Ds9omC1ZPm7ogZEcB0zQb2rP
   U0kCivGYTxgJWIVtu1s5dAmVxi2Z7LJar1ZCIrVxjRd8EAICRj2DA2vfc
   CrPuljQg8zi1x2IOggufqlVTdRyBlZpp0uC08KMxQxGzfTbhBo7OJ7FJV
   Roja0zmeDs0yfwaZGZ/xalVVEEVctDbyaiTy3FyMyjU4KVbid6oFa+xH5
   TWbSxQEhtF+o6dvLiI6rtZ5B6ee9GNlh5xGTBXZiraPzZk+cYuDldpDUe
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="370483569"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="370483569"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 20:25:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="822507369"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="822507369"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Aug 2023 20:25:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 20:25:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 20:25:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 20:25:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 20:25:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsAANF7jvo4EUMy3yTEtuFKoUOEungdnHJaRp6whqDL1L4KeXICMJZ8+HreRA2NhQ08vVpA6rA64WxS7KEI/OlWXBjjZBtV1IfSMBMbNUBNlrm7WL5G5vqqcqUYCpPk7z95uxPVOfAKHd0YJBroiovBLRHO9tHAF5YaJRw1Pv0HB7Z3mSbJLdzRK34PBlFB6OT5DFOH+9ErejyjuKnLGRGA6BxRB3wNFohbZD0eHJYB34D/cTUaWD2QlX+Kkc5sStRcw4rDoAkjaKFe7m4QF1nCy7y3rAyfjcaWYIkCQfEWPBGPeiPM3ibO9wlfmX8VG3RRqw6D2NbMbWoYrok2fIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O62uh7Rm2FVVJ2FvNBpjOTFLtT0Q0RlzThrIlmOtENI=;
 b=euKsJ9iuibj00xjT53a2grHzukCdHQTnK6CB5gPNYMHystJSjEjnH4AYs71Q+b8EP8zvBvCh0MehgU6drsQJIAbtcKZrx+ZNy7krmHKutSgcMvwOkHmXxk3FYP6EHbY5It8FJLB2e1NHd5zOMMs+VCawSESdXRm002hWJCwMfFc+kZCgIBWH8bEZJ7q3GhPq3UfyNH9hRclFS8ple+ktwA8nlQG59LRlW/4zZJ2vFfqo0q5SA16wJGlAr4Agsf1dN5OLAaQhSSij5OjUnFw3Vi5YW20+MfkSnvbriqMaEvYVUxedA4P11svJQRY+jrAOolTd8sGt22adMwEtjPd5pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.19; Fri, 11 Aug
 2023 03:25:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 03:25:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Christoph Hellwig <hch@lst.de>, Brett Creeley <bcreeley@amd.com>,
        "Brett Creeley" <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Thread-Topic: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Thread-Index: AQHZyXH315oZeaJfAkWWY6/5iKI7jq/g/BYAgAEh2wCAAB5AAIAACU2AgACQSWCAAOwNAIAACPgAgAAFuACAAADSAIAAA0MAgAAEvoCAAJjmoA==
Date:   Fri, 11 Aug 2023 03:25:21 +0000
Message-ID: <BN9PR11MB5276884693015FE95A0939AF8C10A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230808162718.2151e175.alex.williamson@redhat.com>
 <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
 <20230809113300.2c4b0888.alex.williamson@redhat.com>
 <ZNPVmaolrI0XJG7Q@nvidia.com>
 <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230810104734.74fbe148.alex.williamson@redhat.com>
 <ZNUcLM/oRaCd7Ig2@nvidia.com>
 <20230810114008.6b038d2a.alex.williamson@redhat.com>
 <ZNUhqEYeT7us5SV/@nvidia.com>
 <20230810115444.21364456.alex.williamson@redhat.com>
 <ZNUoX77mXBTHJHVJ@nvidia.com>
In-Reply-To: <ZNUoX77mXBTHJHVJ@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6780:EE_
x-ms-office365-filtering-correlation-id: c95946bb-0d08-4a7b-ac6a-08db9a1a981c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HA4H6JOgRLMJJCr6EEBhd4kBnyXusKE0830Ef+he893PYeOBpgIlHpmH7Y72cPsFrva97piFb1BJVjkIZluKcR/v3G4eFefQY3w7JyFI674uET/6OOrkBx7kkHVL+ZvKa2+SqjDx4mpOdG4CIpyLw2CS3HkO0076RhQ4q070gvsJd6YzaFESB3JMHZE+chF/3objJcxGTK6RcO4dffnbpEfgnTj1V1bINL6wrOwZyvr2RyW3HS7ZFudQ3pV8aCTjaszHjYiOJ585CmdU4pAlH/o6MlsJ7JLkz9Tp7Ne8W7ftsu26WvYUD08JEts2IpgbPeOsutq5MhHazrIy6HLUW9SIYchVHqU3EoxB2FtIOTv9Mh1Kdn7T4ooeG2i1romKwApQrL/Fz6m0N7FmeOOjfBC0vFASIyM+Z9Fpu4dml8x3Uqv2fO0JkVHx0kHipjEutc7eIDaB9iuDuTxjjKGMjg54TWJ4IWPJ+P1OnnznLJlLeqLpnzfxT6X2QcryGa3HQ1vJR/QNwi6uDEe8PR+m5smMF/ywMNKh3FNSXFTgq0dhYF6NjBKQvbqwmEbGql1HoHJxZk6iDhxtfoJ4VkhwqHXw7ESfSFcI8UhzDFNUfCeruLMMAZVztIyqb9S7qi9FSRIwwcKiUx2yDsoJbe9IuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199021)(186006)(1800799006)(2906002)(7416002)(5660300002)(8936002)(8676002)(52536014)(316002)(41300700001)(4326008)(76116006)(66476007)(66556008)(66446008)(66946007)(64756008)(110136005)(71200400001)(478600001)(7696005)(9686003)(54906003)(83380400001)(55016003)(33656002)(26005)(6506007)(38100700002)(122000001)(82960400001)(86362001)(38070700005)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzhpUVZNbjhtTGFyZHhWdG01czE5VmF2cHpNdUpEaXhweDRmUWZvNW5BNE1p?=
 =?utf-8?B?R2dhN0hGTEJoZHdoMlIrVms3bGxoY0FUa3hWa1NxOHlHaWgyVmx0OUFxMXhN?=
 =?utf-8?B?UlVsODVQc21wdFNrOU9qQU4ydCs2UHdvVmt6UDEwcGtMa0NIU1RZUzVtSE1N?=
 =?utf-8?B?cnVVazlMTlVLM3czSlNaVysyRXN1Q0E2QWVQcnJGTWlkNHVVZ1hIWENhd2VL?=
 =?utf-8?B?YUpoenV6UFJoejdaUVRsK1Ayekhkd3ZlRGMrUXk4VHMxWHpDMDZVY2d4RkQ1?=
 =?utf-8?B?Q28xRVdFZE1RRzdHK21RVW04QW1VcEhxN1g0MDYwMnNNOFp1VWVUZEVQY21U?=
 =?utf-8?B?dWxNTUlDTkdmZVZZTUprN0FjTnlndnV1ZDZneDNMMElWSzltNkdDRW1QOWUv?=
 =?utf-8?B?N0lnZkJtaGNUbUxIUEcrd3MzaW1JYS83VzlXa1pJUEhzNURUZ2pyako0RFBI?=
 =?utf-8?B?dEJtT2t2L3ZqcnVhRGhhV1QwNmVuL25uMm4yU3pVV2tSZGViSlpES3hWQzZJ?=
 =?utf-8?B?bFR6c0FrZzkyS01CWUVnYitGTXdGbXQ4TVF1T21KS2VxZVJPOC9YTXlEbG56?=
 =?utf-8?B?b1FpanA0blFadmVLWWZYVkdlaDZRTnYzcXN2eDNWamlWU2tlMUpvS3FDcjVo?=
 =?utf-8?B?ZHgvTHVuTjJpOWk0WkhiWmVxbHVDcGpLbk5wK0JCZHYrYWZwbnR5K3JFRFA4?=
 =?utf-8?B?NWpvcnRYMCtxQWZFN2g2b1VsbnJjMFJ1K1k2bEN6djJ3YlNXcFJIUEVUZEFk?=
 =?utf-8?B?eStYNTUyMTRzQm8ydDR5VXhsdjI1TFFlemRUM1N3Ykt6TGRiQ25XRXVLNzkz?=
 =?utf-8?B?V1F0U2pmVy8zOHFjUS9keEJBeTVTQ2FCeUduM3hSY05EUW5HekMza2tsL2FC?=
 =?utf-8?B?M1FIdnNLamFRQzNkK1BqeDlIOEMzaUtuaTRrMlpOblZId3FjNWpVaWNGWDZu?=
 =?utf-8?B?MzFVcEI0Sjd3cWZoNExPbVZTSmgzKzhsSTRNS3hneVoyMlNvdmd0alNKK2Fx?=
 =?utf-8?B?ZnBIdUltTFpNQS9mQndSY2NyRE5kbWhDMFN0QXk4RzhrRDcvVEI3NFdZenpY?=
 =?utf-8?B?N0pjczMxbllseVpsUnRwNWNWbDlMdEpmTE1qZHU1Zy9KOEFscjVmWFBGQ2JV?=
 =?utf-8?B?czh0T2hXUlpnYks3OC9rRytneFlENDN3VlJLYmNrUjJzRWl1ekkwWjlCNjhP?=
 =?utf-8?B?V0txMzhxVWVITHkxd0FGSGJManZSMjhGWUpoMldiUXlxQ0RjTnVUVmsxcnds?=
 =?utf-8?B?ckwzQ0xQdlNKYi8wYk03K09yd1I4NU1ONithbk5tT29MNzJrRVkyZmNvQVA0?=
 =?utf-8?B?Rm9wWXJTdDA5VUxOUFBVMWxORGlMTURiTklTNlk4TllaOEJELzVzSTBZaVhv?=
 =?utf-8?B?am9iR0RJYmxPbSt1cGd5ZGgvTXdMR0czcDQyUTNqU09PcFZrdm4reS94V0Jv?=
 =?utf-8?B?WVF4VHVkTXpRZGI0RXIvckIwQ2RFMXVYS1dSclpwVnRWVkk4aHc1bjJXRHlO?=
 =?utf-8?B?TE9TYjl4WDc2UzU1Ry9Ub2ZUY0tteS9JbE1xbUlNeXBOcGFSRm5CaFd0YVNm?=
 =?utf-8?B?TjI5VWdScHFud0JJNzBPb0pXZkdkYWZ3SElNNGdHZHhFc201RC9hR1BTS1N6?=
 =?utf-8?B?dXdzQll0a0NqVmtobk01R0U3S1lLcDZ6WWljaVNhV3haekVxaXRvcC9MNkpo?=
 =?utf-8?B?SmdrTEV4OGFsSnYvWm9mOXhnM3VwcElLbkY2bTNvZ2FIL3c4dTJvZjkzZW1o?=
 =?utf-8?B?R2FETnJ3TDIzQWh1T3h2YWZuOHFFd3N3MEcvQk5RL0dKRkw5YTlZMWl3Qlh1?=
 =?utf-8?B?OUtESEVablZ4Vm5DenNxMmtmMWlkTnFVZ2twRERaSExHZGpBa3hEQVRoS1E4?=
 =?utf-8?B?cVZVeEdKU0dVS25qUklaRlBDMVptY09UekhHNlY1NHF4YXAzamN0ajNXZCtC?=
 =?utf-8?B?eWJDb1dlNndueHJoblNNSWEzeGFQajQyeGZXa3Nwc3p1cTM0dUl4b0pGSHVu?=
 =?utf-8?B?bkRyWFVua1ZCTnRmZ3dCMXZ5MmEvNHhRd1l4Q3p5cC85ZGxVQVpzSEFTQktL?=
 =?utf-8?B?OVZ6bzN3K0JLQ2hlWG9tWWZJTStqY0lGMTRRU0xVNEpCZVh0a2x4RXQwc2Zq?=
 =?utf-8?Q?cVle2d/usHcJs1TqeRmKd/RMY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95946bb-0d08-4a7b-ac6a-08db9a1a981c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2023 03:25:21.4424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MLriC0f1swpL778SLPhso9ryb+CBf2sdKAIx350HXD255mecTokZGft45yguDMq/hG3iLd2osCMEO96AsoLK1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6780
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IEF1Z3VzdCAxMSwgMjAyMyAyOjEyIEFNDQo+IA0KPiBPbiBUaHUsIEF1ZyAxMCwgMjAyMyBhdCAx
MTo1NDo0NEFNIC0wNjAwLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4gT24gVGh1LCAxMCBB
dWcgMjAyMyAxNDo0MzowNCAtMDMwMA0KPiA+IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5j
b20+IHdyb3RlOg0KPiA+DQo+ID4gPiBPbiBUaHUsIEF1ZyAxMCwgMjAyMyBhdCAxMTo0MDowOEFN
IC0wNjAwLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4gPg0KPiA+ID4gPiBQQ0kgRXhwcmVz
c8KuIEJhc2UgU3BlY2lmaWNhdGlvbiBSZXZpc2lvbiA2LjAuMSwgcGcgMTQ2MToNCj4gPiA+ID4N
Cj4gPiA+ID4gICA5LjMuMy4xMSBWRiBEZXZpY2UgSUQgKE9mZnNldCAxQWgpDQo+ID4gPiA+DQo+
ID4gPiA+ICAgVGhpcyBmaWVsZCBjb250YWlucyB0aGUgRGV2aWNlIElEIHRoYXQgc2hvdWxkIGJl
IHByZXNlbnRlZCBmb3IgZXZlcnkgVkYNCj4gdG8gdGhlIFNJLg0KPiA+ID4gPg0KPiA+ID4gPiAg
IFZGIERldmljZSBJRCBtYXkgYmUgZGlmZmVyZW50IGZyb20gdGhlIFBGIERldmljZSBJRC4uLg0K
PiA+ID4gPg0KPiA+ID4gPiBUaGF0PyAgVGhhbmtzLA0KPiA+ID4NCj4gPiA+IE5WTWUgbWF0Y2hl
cyB1c2luZyB0aGUgY2xhc3MgY29kZSwgSUlSQyB0aGVyZSBpcyBsYW5ndWFnZSByZXF1aXJpbmcN
Cj4gPiA+IHRoZSBjbGFzcyBjb2RlIHRvIGJlIHRoZSBzYW1lLg0KPiA+DQo+ID4gT2ssIHllczoN
Cj4gPg0KPiA+ICAgNy41LjEuMS42IENsYXNzIENvZGUgUmVnaXN0ZXIgKE9mZnNldCAwOWgpDQo+
ID4gICAuLi4NCj4gPiAgIFRoZSBmaWVsZCBpbiBhIFBGIGFuZCBpdHMgYXNzb2NpYXRlZCBWRnMg
bXVzdCByZXR1cm4gdGhlIHNhbWUgdmFsdWUNCj4gPiAgIHdoZW4gcmVhZC4NCj4gPg0KPiA+IFNl
ZW1zIGxpbWl0aW5nLCBidXQgaXQncyBpbmRlZWQgdGhlcmUuICBXZSd2ZSBnb3QgYSBsb3Qgb2Yg
Y2xlYW51cCB0bw0KPiA+IGRvIGlmIHdlJ3JlIGdvaW5nIHRvIHN0YXJ0IHJlamVjdGluZyBkcml2
ZXJzIGZvciBkZXZpY2VzIHdpdGggUENJDQo+ID4gc3BlYyB2aW9sYXRpb25zIHRob3VnaCA7KSAg
VGhhbmtzLA0KPiANCj4gV2VsbC4uIElmIHdlIGRlZmFjdG8gc2F5IHRoYXQgTGludXggaXMgZW5k
b3JzaW5nIGlnbm9yaW5nIHRoaXMgcGFydCBvZg0KPiB0aGUgc3BlYyB0aGVuIEkgcHJlZGljdCB3
ZSB3aWxsIHNlZSBtb3JlIHZlbmRvcnMgZm9sbG93IHRoaXMgYXBwcm9hY2guDQo+IA0KDQpMb29r
cyBQQ0kgY29yZSBhc3N1bWVzIHRoZSBjbGFzcyBjb2RlIG11c3QgYmUgc2FtZSBhY3Jvc3MgVkZz
ICh0aG91Z2gNCm5vdCBjcm9zcyBQRi9WRikuIEFuZCBpdCBldmVuIHZpb2xhdGVzIHRoZSBzcGVj
IHRvIHJlcXVpcmUgUmV2aXNpb24gSUQNCmFuZCBTdWJzeXN0ZW0gSUQgbXVzdCBiZSBzYW1lIHRv
bzoNCg0Kc3RhdGljIHZvaWQgcGNpX3JlYWRfdmZfY29uZmlnX2NvbW1vbihzdHJ1Y3QgcGNpX2Rl
diAqdmlydGZuKQ0Kew0KICAgICAgICBzdHJ1Y3QgcGNpX2RldiAqcGh5c2ZuID0gdmlydGZuLT5w
aHlzZm47DQoNCiAgICAgICAgLyoNCiAgICAgICAgICogU29tZSBjb25maWcgcmVnaXN0ZXJzIGFy
ZSB0aGUgc2FtZSBhY3Jvc3MgYWxsIGFzc29jaWF0ZWQgVkZzLg0KICAgICAgICAgKiBSZWFkIHRo
ZW0gb25jZSBmcm9tIFZGMCBzbyB3ZSBjYW4gc2tpcCByZWFkaW5nIHRoZW0gZnJvbSB0aGUNCiAg
ICAgICAgICogb3RoZXIgVkZzLg0KICAgICAgICAgKg0KICAgICAgICAgKiBQQ0llIHI0LjAsIHNl
YyA5LjMuNC4xLCB0ZWNobmljYWxseSBkb2Vzbid0IHJlcXVpcmUgYWxsIFZGcyB0bw0KICAgICAg
ICAgKiBoYXZlIHRoZSBzYW1lIFJldmlzaW9uIElEIGFuZCBTdWJzeXN0ZW0gSUQsIGJ1dCB3ZSBh
c3N1bWUgdGhleQ0KICAgICAgICAgKiBkby4NCiAgICAgICAgICovDQogICAgICAgIHBjaV9yZWFk
X2NvbmZpZ19kd29yZCh2aXJ0Zm4sIFBDSV9DTEFTU19SRVZJU0lPTiwNCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICZwaHlzZm4tPnNyaW92LT5jbGFzcyk7DQogICAgICAgIHBjaV9yZWFk
X2NvbmZpZ19ieXRlKHZpcnRmbiwgUENJX0hFQURFUl9UWVBFLA0KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAmcGh5c2ZuLT5zcmlvdi0+aGRyX3R5cGUpOw0KICAgICAgICBwY2lfcmVhZF9j
b25maWdfd29yZCh2aXJ0Zm4sIFBDSV9TVUJTWVNURU1fVkVORE9SX0lELA0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAmcGh5c2ZuLT5zcmlvdi0+c3Vic3lzdGVtX3ZlbmRvcik7DQogICAg
ICAgIHBjaV9yZWFkX2NvbmZpZ193b3JkKHZpcnRmbiwgUENJX1NVQlNZU1RFTV9JRCwNCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgJnBoeXNmbi0+c3Jpb3YtPnN1YnN5c3RlbV9kZXZpY2Up
Ow0KfQ0KDQpEb2VzIEFNRCBkaXN0cmlidXRlZCBjYXJkIHByb3ZpZGUgbXVsdGlwbGUgUEYncyBl
YWNoIGZvciBhIGNsYXNzIG9mDQpWRidzIG9yIGEgc2luZ2xlIFBGIGZvciBhbGwgVkYncz8NCg==
