Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3258638224
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 02:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiKYBoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 20:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiKYBoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 20:44:17 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A6131B;
        Thu, 24 Nov 2022 17:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669340657; x=1700876657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mPrIF2H4X14Uk3y0r9ce1CTn5Pio7ekW+Y/8G4afijI=;
  b=Q1Awtc5eiEbWWwzzBBsBYF13NgI6YM3lUBmoA2fRb3omHpGMJb2x78EB
   5jOlsnUxjYlb6D+zgxeIqOzHf8E9jc1ZXOU3KTKaprhBzkg5AS8DHpPlF
   zYMYsOtNiGbUxTTYQEx0yq7g7gVotyeeO6EdwEF3iH/7OZwBuJ6K6J7hG
   b6MxnUhMXen/MJQeg9emtBRXDAa6yL7AgTttW5B6cAuNOuU1nRZ8Hrj4c
   8eg1/6GWUwEoR//rFBs6OOzMrRJiYlX7+OrxOhFb+4K7QBMqIkPNOTZGX
   +g8+nYFUWkJ0wONRhV5KLk7wv0SWLXh+mASjHxLypGYgRJSRyfHQEE14/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="316212419"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="316212419"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 17:44:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="673396351"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="673396351"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 24 Nov 2022 17:44:16 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 17:44:16 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 17:44:15 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 17:44:15 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 17:44:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoADqJTZuDvV9cldnxAVduR5M2VG+d/i82D+v2xkAQ0sQXRCPBCsUjGeBaCUorCEKhFkoEZE9bR8fQV4xHJ6iim9nM586L9nCXlg6o7t2KJgUCdmXV4zcYFOYPEgSOWUwZUwYl32vp9m3zjvPAD3jR9ClBQbMDjai7G/9GorBbo9nt+JWlM+fiLaeO1FrVoGL9QbA7K7YLk3lyTQQGt/t7VaDkWxIkpSUE2+nMRSj3225Zw3fgFuLNOmhGNyFH6xGaPDCGKXUtKveMmeh2htYruZdEWLsxCIfl4suMI+bHSre15ziDeno/nEMHF6krftzgR6fvYFveWvXYUDI7j/BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPrIF2H4X14Uk3y0r9ce1CTn5Pio7ekW+Y/8G4afijI=;
 b=dGBKI2MWDj7a4+eBSWlrtR8Klnl7mFTHSqtApnS7r5INJ/HZ+Q627OW8XXY5w1V7NwDHjOwDxRaIWe9iC9ysPTQJY7qy9zWuyWCVd2cbc2vcxS/1E7O2b4gKukrv8uLu/OO+KZR/wv1P1EISKsVN/lQYxg/ln8GQMITr6iCRKAaPyTZ6ums1rurKJUqdeuhhAWZfuGq2o12Wewa64Skri/vbkNHUchcj67bOGpQUZE56a+T/WAATtTmC8zPayFlw1FWJvVjIzm4SLSQqtK7yhk4I6LKlZvyvR9FN/RSIPeNWxRrwpNgBQO+ix9Xdl7vDmAjwj78I5BKHX/0ZX4wzHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 01:44:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 01:44:12 +0000
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 16/20] x86/virt/tdx: Configure TDX module with TDMRs
 and global KeyID
Thread-Topic: [PATCH v7 16/20] x86/virt/tdx: Configure TDX module with TDMRs
 and global KeyID
Thread-Index: AQHY/T3K4h1rHLbigk+AO0UKIyHeB65NNAoAgAGjyQCAAAVCgIAAB0SA
Date:   Fri, 25 Nov 2022 01:44:12 +0000
Message-ID: <b5dde5978ffa371797dacf0f8c30e22ea5cde49a.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <344234642a5eb9dc1aa34410f641f596ec428ea5.1668988357.git.kai.huang@intel.com>
         <301184ce-05e5-871c-7a6c-4298a0cbd1ae@intel.com>
         <cb83246f93281138f0e970bfccea4b13f2a64046.camel@intel.com>
         <89a746cc-8f60-8472-0d0b-71a459e2dd64@intel.com>
In-Reply-To: <89a746cc-8f60-8472-0d0b-71a459e2dd64@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB6695:EE_
x-ms-office365-filtering-correlation-id: 7ef13353-e0b3-4169-5ab2-08dace868d88
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zMj9EWtabqUEaY8x4xfm4UntGfgxjLXo7LZnYBZn3Xpmhb5PcIj4YfKEj3lxWEYSRFHsDrVZK3XTZKVJtehHbs6NxU454o9x1PmstWNuzwIQzZriwHnJoZ1Nb/DlZdXzQI5x37w62usRbYZtZ+Il9Iastt2pk1ioc2end2tEUEGrQJXKtFGsoKhKfoh4M+CFxKl9BgsnvSUX5fJrT/KBY+qzxE2JLakht0KyVC0DpYQBlFIJgckzAhj+FXdUu6Axq0ddVoKt314RH/R0zzaVD4a+jmqtRUMUhB/bYDulAbBTesPxC5uN0tG/4Nwqe1Ns6RSJ0Vr2idIkPxhOONszeXkUJNolp8tw0ipo9ehlAFuTdhXErGXc7l6id1Hj1l4xbdrheQ7BqPJESR2i3/8aND1M/Flm99LgFzEUrGe/twaU7Jkx4fIUH3VCDJvZuUcSd41JApswV3GNhbkGMgiqQF7ZEwKH15ffCPv7RBxSDRkCYGgo2PZeug08GlkjxoYNBXEca3Y3oHu6XPrw+IU6ujdMgiXHu9zNwLg3CuJ8qhQMy+Pd6lCE6T2wvM23F7+/yFv3L3XGdg94J5eRZSDxlIm8j0bf5pz4NWJ6ZiVMj0r3daxrjpUO6zPz5uL8XP4xNeH1mMF2owwrEwGNRrv3FWkRM/JVEhgAZ0GX4mhjvxUqPxZJqz2XdmY4R64swr8ojEVONbqpodHeLol08/NfnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(83380400001)(38070700005)(86362001)(110136005)(6506007)(6486002)(71200400001)(54906003)(36756003)(82960400001)(122000001)(2616005)(186003)(66476007)(5660300002)(64756008)(76116006)(66446008)(53546011)(478600001)(6512007)(26005)(8676002)(66556008)(316002)(91956017)(7416002)(2906002)(41300700001)(4326008)(8936002)(66946007)(4001150100001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1U1U2lxdlhISTZpTWM3am9lamxWakRDdmgzeFJsYW5QbTBkcTMxb3BwNjEw?=
 =?utf-8?B?ejl3Z0VPdm5tYVFvYi9YNjY2VWdqV3BtaVpaeTJ2c0s1MVliWDE4UTd1VHBX?=
 =?utf-8?B?OUZNNVJiWUlzNGQ2elEvanRPNUM1R1p5b2JjWTVaN0RoaStkWW5pOVdLWU82?=
 =?utf-8?B?MHV6N1MzbC9ManFrYnc5TjVpMXpXUmJ5NkpidEdQU3IxZHpyYzNncEtvd3hv?=
 =?utf-8?B?L3E4QUVtakdHbFBkRnpqSVdhYjZNekZzbFIwUVdpK1Zab0c3cHBxYUNpTml0?=
 =?utf-8?B?cGdYSHg2MXRKakwxOS83NjdYQUsweU9Ld2k3TlhtbVBBNUJMRTJFM2s4ckMr?=
 =?utf-8?B?SVhHU1hGVldWeXJqaXZBVmRwam5ZbTFDeU1QeHljZWlMZEFpaWphNk8rbU9X?=
 =?utf-8?B?ZUUwcThZd1dIR3NzK0d5NWZDS01ONTJlcXBlUG41dXNabktOU05KTDlzM3VB?=
 =?utf-8?B?MTJTVDh6SEFOdlZrRzk0LzY2dGdOT1lDT3h5bWYzS2d0dHF6dGxHT3d4S3hn?=
 =?utf-8?B?VUErWXpOdVlXYWNDeVFPK25aWnpLVWR2OTN6Y1BaNC9Kc0kydU5ZaTBvb1la?=
 =?utf-8?B?SlMrL3RiVkdWWmpvRTd3RXhRdHM2a24rY2JoeEk1OE9jMVEwbzJnUTN6bEdK?=
 =?utf-8?B?RmZGOTM2OHgwWHVZS0ZKWTZldWwwZFZnOWtIZXIwcFFiVTJVKzhmYW82dFFh?=
 =?utf-8?B?a3pkOEEvc3NhdmE3ZUE3Ynd0RlRQRXlMcGI0eExVNUpPb3V6aStObU41MjV1?=
 =?utf-8?B?TUM0ZVVzTXBVSGEzTmlPOThYemRsYlZGZnhDN2J2SE9SQ2xPUEVhZlJPRVpK?=
 =?utf-8?B?QUhVRjVOVFNuOHhFY3JmeTJvSmxoTGN0OUROeDdSaFl6aDlvQnp2dDFmMG5C?=
 =?utf-8?B?dWdRL3NsTEd2cXI4UWhvOU56R1Mxc3dtWkYrQ1JIRVJveXBZYXZjSDk0NjJo?=
 =?utf-8?B?eEJjNTNaTWl3amE0dFJaNVVNTi9OejkwSFQ1NnRxSFl3MWZzeEJaRGRHbnkx?=
 =?utf-8?B?Q25TU2g1bVdXbjZzRDEvQk9abjBHVlMxN0x2dUh5WUJPVUZYVWhzcTR1UmpK?=
 =?utf-8?B?SVBWM09Tcm5Xdk42ejBJRVZHanE1Skp5RU90SHdFbWlsd2x6SXBJSFZvR3B1?=
 =?utf-8?B?RjVSSTZ4MkVpeVBaUmN3UjBUR1dSV3ZybjMzN2MrbnJ6Y0w5bExGa29ud3Jx?=
 =?utf-8?B?SDJLSjdESDdOaGpVNXZhdzhldmNzQWRyQXdGYXFrZEk0dTZqcVF6SzFDeWk2?=
 =?utf-8?B?elhuVWIzcE83UnhadXJPQnZ3bGFlOUZ4OVRzVlA2Nkd6Vm84TUJCRjdxdC9X?=
 =?utf-8?B?clFMZXJvTlRxK2RWVGRCNzRqTi9VaGQzYzhaMjZxY3lZNnFwTnhIZXQvNElG?=
 =?utf-8?B?Zm5xamVzaVczdnhML3lhdlRmOXpCcFd3eVFxREFidzJSRUszYjFXZnZ6a2Rn?=
 =?utf-8?B?c05yS3Rqb3RXejdZU3dJTGlWMFNuVmUrNFBHK2tjQU9qYW9rYTdSNkhhS0Fu?=
 =?utf-8?B?cmE4ZXdWNFcyS3ZBUkRxQmkrcDN3Rk9JaXAvR2lKRzg0VFVHa1htVTRDZUM5?=
 =?utf-8?B?VHUxeStNeS93ZjdnMTlMbDhRNm1nYVg1QzZlRnplczREWTVRR0hXL3hDZkhK?=
 =?utf-8?B?L2o0RE1MN2NPQjBpUDdQTnlVa3laM3FnSmxmanIzYjVFcWlITGh4S0FjZWdP?=
 =?utf-8?B?bXB4TzFPTjlaUGFPcXNxWmd1MEpEc0NqUTM4ZGJPUHVQdmxzckZjL3k1ODky?=
 =?utf-8?B?dmJ1NnczcHNSUE5rNWxyWVg4Ti80NitFc1JJZ1dZN0VUaXdIRmdaME1KeGxr?=
 =?utf-8?B?eS9NdzV6NVFpc3gzRVNVczJBNmMrMG12b0h0SzNka0Y1QkFSOTIxd3hacDJz?=
 =?utf-8?B?Zlo2a043SDQwOVlGNG4xQ1lVWVRrVFBLQ3FGOUY0WEdxZTdBQU1OTGZsSWtF?=
 =?utf-8?B?TFFMalNMdEpaVWREYW9JMHYwZDRvZEpySnNack5DQXdjS0d0TlZVeWt5c3Rp?=
 =?utf-8?B?WUQweE1TdU1XS1AveExaQm1BOUJrYzNVS0ZjekkzWHJTUnlFMkhCaC9PdmxZ?=
 =?utf-8?B?cmc4bFB2Z2FLK01CNzloUGhYdklYckdKcWwzajJSVW1vWHhGOHFDdTRLNVhs?=
 =?utf-8?B?U2pqUUx2YU5vOWY4VThWR29CbTllenYrakI5WWYxN3FLVkdMM2xxbmJ1dnoz?=
 =?utf-8?B?MEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FED5F04081CF2B489ABC326E38A3520B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef13353-e0b3-4169-5ab2-08dace868d88
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 01:44:12.1653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VATwNc6E+li9TwXlKSkFRlSzRfnPVweRrunEu6IEfFQ18EmmS2yRMDRjIl/hs0rZEk5hutlYBIJN1WXjVLnt2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6695
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTI0IGF0IDE3OjE4IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjQvMjIgMTY6NTksIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gV2VkLCAyMDIyLTEx
LTIzIGF0IDE1OjU2IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gPiA+IE9uIDExLzIwLzIy
IDE2OjI2LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+ICsgICBhcnJheV9zeiA9IEFMSUdOKHRk
bXJfbnVtICogc2l6ZW9mKHU2NCksIFRETVJfSU5GT19QQV9BUlJBWV9BTElHTk1FTlQpOw0KPiA+
ID4gPiArICAgdGRtcl9wYV9hcnJheSA9IGt6YWxsb2MoYXJyYXlfc3osIEdGUF9LRVJORUwpOw0K
PiA+ID4gDQo+ID4gPiBKdXN0IHRvIGJlIGNsZWFyLCBhbGwgdGhhdCBjaGF0dGVyIGFib3V0IGFs
aWdubWVudCBpcyBiZWNhdXNlIHRoZQ0KPiA+ID4gKlNUQVJUKiBvZiB0aGUgYXJyYXkgaGFzIHRv
IGJlIGFsaWduZWQuICBSaWdodD8NCj4gPiANCj4gPiBDb3JyZWN0Lg0KPiA+IA0KPiA+ID4gSSBz
ZWUgYWxpZ25tZW50IGZvcg0KPiA+ID4gJ2FycmF5X3N6JywgYnV0IHRoYXQncyBub3QgdGhlIHN0
YXJ0IG9mIHRoZSBhcnJheS4NCj4gPiA+IA0KPiA+ID4gdGRtcl9wYV9hcnJheSBpcyB0aGUgc3Rh
cnQgb2YgdGhlIGFycmF5LiAgV2hlcmUgaXMgKlRIQVQqIGFsaWduZWQ/DQo+ID4gDQo+ID4gVGhl
IGFsaWdubWVudCBpcyBhc3N1bWVkIHRvIGJlIGd1YXJhbnRlZWQgYmFzZWQgb24gdGhlIERvY3Vt
ZW50YXRpb24geW91IHF1b3RlZA0KPiA+IGJlbG93Lg0KPiANCj4gSSdtIGZlZWxpbmcga2luZGEg
ZGVuc2UgdG9kYXksIGJlaW5nIFRoYW5rc2dpdmluZyBhbmQgYWxsLiAgQ291bGQgeW91DQo+IHBs
ZWFzZSB3YWxrIG1lIHRocm91Z2gsIHN0ZXAtYnktc3RlcCBob3cgeW91IGdldCBremFsbG9jKCkg
dG8gZ2l2ZSB5b3UNCj4gYW4gYWxsb2NhdGlvbiB3aGVyZSB0aGUgc3RhcnQgYWRkcmVzcyBpcyA1
MTItYnl0ZSBhbGlnbmVkPw0KDQpTb3JyeSBJIGFtIG5vdCBnb29kIGF0IG1hdGguICBJIGZvcmdv
dCBhbHRob3VnaCA1MTIgaXMgcG93ZXIgb2YgdHdvLCBuIHggNTEyIG1heQ0Kbm90IGJlIHBvd2Vy
IG9mIHR3by4NCg0KVGhlIGNvZGUgd29ya3MgYmVjYXVzZSBpbiBwcmFjdGljZSB0ZG1yX251bSBp
cyBuZXZlciBsYXJnZXIgdGhhbiA2NCBzbyB0ZG1yX251bQ0KKiBzaXplb2YoNjQpIGNhbm5vdCBi
ZSBsYXJnZXIgdGhhbiA1MTIuDQoNClNvIGlmIHdhbnQgdG8gY29uc2lkZXIgYXJyYXkgc2l6ZSBi
ZWluZyBsYXJnZXIgdGhhbiA0Sywgd2Ugc2hvdWxkIHVzZQ0KYWxsb2NfcGFnZXNfZXhhY3QoKSB0
byBhbGxvY2F0ZT8NCg0KPiANCj4gLi4uDQo+ID4gUGVyaGFwcyBJIHNob3VsZCBqdXN0IGFsbG9j
YXRlIG9uZSBwYWdlIHNvIGl0IG11c3QgYmUgNTEyLWJ5dGUgYWxpZ25lZD8NCj4gPiANCj4gPiAg
ICAgICAgIC8qDQo+ID4gICAgICAgICAgKiBURE1SX0lORk8gZW50cmllcyBhcmUgY29uZmlndXJl
ZCB0byB0aGUgVERYIG1vZHVsZSAgdmlhIGFuIGFycmF5DQo+ID4gICAgICAgICAgKiBvZiBwaHlz
aWNhbCBhZGRyZXNzIG9mIGVhY2ggVERNUl9JTkZPLiAgVGhlIFREWCBtb2R1bGUgcmVxdWlyZXMN
Cj4gPiAgICAgICAgICAqIHRoZSBhcnJheSBpdHNlbGYgdG8gYmUgNTEyLWJ5dGUgYWxpZ25lZC4g
IEp1c3QgYWxsb2NhdGUgYSBwYWdlDQo+ID4gICAgICAgICAgKiB0byB1c2UgaXQgYXMgdGhlIGFy
cmF5IHNvIHRoZSBhbGlnbm1lbnQgY2FuIGJlIGd1YXJhbnRlZWQuICBUaGUNCj4gPiAgICAgICAg
ICAqIHBhZ2Ugd2lsbCBiZSBmcmVlZCBhZnRlciBUREguU1lTLkNPTkZJRyBhbnl3YXkuDQo+ID4g
ICAgICAgICAgKi8NCj4gDQo+IEthaSwgSSBqdXN0IHBsYWluIGNhbid0IGJlbGlldmUgYXQgdGhp
cyBwb2ludCB0aGF0IGNvbW1lbnRzIGxpa2UgdGhpcw0KPiBhcmUgc3RpbGwgYmVpbmcgd3JpdHRl
bi4gIEkgX3Rob3VnaHRfIEkgd2FzIHZlcnkgY2xlYXIgYmVmb3JlIHRoYXQgaWYNCj4geW91IGhh
dmUgYSBjb25zdGFudCwgc2F5Og0KPiANCj4gI2RlZmluZSBGT09fQUxJR04gNTEyDQo+IA0KPiBh
bmQgeW91IHdhbnQgdG8gYWxpZ24gZm9vLCB5b3UgY2FuIGp1c3QgZG86DQo+IA0KPiAJZm9vID0g
QUxJR04oZm9vLCBGT09fQUxJR04pOw0KPiANCj4gWW91IGRvbid0IG5lZWQgdG8gbWVudGlvbiB0
aGUgNTEyLWJ5dGUgYWxpZ25tZW50IGFnYWluLiAgVGhlICNkZWZpbmUgaXMNCj4gZ29vZCBlbm91
Z2guDQo+IA0KPiANCg0KTXkgZmF1bHQuICBJIHRob3VnaHQgYnkgY2hhbmdpbmcgdG8gYWxsb2Nh
dGUgYSBwYWdlIHdlIGRvbid0IG5lZWQgdG8gZG8gJ2ZvbyA9DQpBTElHTihmb28sIEZPT19BTElH
TiknIHNvIEkgdGhvdWdodCB0aGUgY29tbWVudCBjb3VsZCBiZSB1c2VmdWwuDQoNClRoYW5rcyBm
b3IgcmVzcG9uZGluZyBhdCBUaGFua3NnaXZpbmcgZGF5Lg0KDQo=
