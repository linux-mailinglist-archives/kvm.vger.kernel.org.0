Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72547B182A
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 12:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjI1KTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 06:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjI1KTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 06:19:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A299C;
        Thu, 28 Sep 2023 03:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695896362; x=1727432362;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hCbXv8i0vokR03BZaRoWxBzl6Mh4kyQqortukLA7VCY=;
  b=Szg/SLOoGH7BIKUxNSaDBgPRNs49SXR+4/Bvzgxrb8Ecx6Mrp4Bho96i
   RB4s/mJdrv3Ya1VvgMbk04nzo010LsU/kJdI7jne7ZuDUXkO6Jw19QL1a
   nlmqNhJu4Tt2XkNQ6F9zBoLtb4ZfFdDsqED+JYUgoBM6Lec4UZ0bVqDuA
   B5oRPN6MXOPn3+GZAHZMuaTFlL00Iv1HuHZAldgxhuuHk0cysJg4o7PDl
   ygTh8y3lvCqHWKuVPGAdl+DlEeu9SDcDy82u3iSkJhgrK3lWR5jS2Ch5G
   4yIAffzDCy5OrJH7FYVBhzngTVvlOZkEsIRl6b/NuROFLdtzdGvfQoBsh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="412939687"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="412939687"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 03:19:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="699214391"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="699214391"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Sep 2023 03:19:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 28 Sep 2023 03:19:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 28 Sep 2023 03:19:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 28 Sep 2023 03:19:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 28 Sep 2023 03:19:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wd4dYdfJEXKqLxyMMHPXO0Zmk7REAFyuveX2PMLKFyAI0Z/LO4H9OmWzr5tE5uCLWRfojSsAAhdn3BfZSRCK6xYB1qhUl44zLMSPINpWkHvx2mg+wUH0EJDOvJTEbIKukbxC1mxJi53ythIFClbzbtWZ0DwQSOGp/GpNOvqGETGhgQzAgvY7EK4D7/SRFV9ssHtHARRQvqp3LAKIIJkZkDjr8WyP64emmgRAzMBMJOJwHN89k8kbo+qoVKfgrGEp8SL7RJkp87JGb8QOPdWPSOB9OKxqqUQ0BpPDZo81D84GdNgUnMR2N1tRtubZzg1mr1qxUVIjlfZ8nDzBjwL95g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hCbXv8i0vokR03BZaRoWxBzl6Mh4kyQqortukLA7VCY=;
 b=ZXk013JYnNqqscbN4LQxY2sVMIU/doAt4TxXpq9coA/zddxVFyIKpHT+ppjge8WO1KDmG9MJ5whKT4U3PdO42rIM8sLYVJ32SkBdCu4v5AY9FdOGf5t6Fdykl/9BU4CAq4gSibMpkkLs07XG5+n82R8EWYvwSb6fjcsDSD1kUmqiL26Y+ZFB34p2AvhJD5pHkeesq6b3oCSikccrDG5g6CLLKHwDFnMVSNqzS8Qp3uN4wukfFv1LI1idkwlvwXfjdukU42TKAtEZ5znRqwzWfldj5cBj7T8awf8Hr6Ls/U8vrKHewKw1GLhr6u1AWSov9XeaFZKiiZlz1zdITnJ0zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5270.namprd11.prod.outlook.com (2603:10b6:208:313::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.22; Thu, 28 Sep
 2023 10:19:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::31a9:b803:fe81:5236]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::31a9:b803:fe81:5236%4]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 10:19:17 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 00/22] TDX host kernel support
Thread-Topic: [PATCH v13 00/22] TDX host kernel support
Thread-Index: AQHZ101CXLqgimVufE63dNCEYW7uB7AwEbqAgAAqIQA=
Date:   Thu, 28 Sep 2023 10:19:17 +0000
Message-ID: <6d71cb084b03f2bc3fc195fa76eb60c2d2bfc917.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <01c42d09-c24c-2611-ff2e-e1079b6df157@suse.com>
In-Reply-To: <01c42d09-c24c-2611-ff2e-e1079b6df157@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5270:EE_
x-ms-office365-filtering-correlation-id: ded43885-b689-47ce-d714-08dbc00c5f54
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AeabUDCjtYn4lsywHM1FHOIDKFO4MEeaLd1azco6gVqmScnar6HMadcB81CUbdcVfg7v5l2Wa4UTbHmoTl0zxVYYwL1uiSeOdZiQnDpWl5/1J13VuJYW8o0UKPIMYvaQkFbzJQTADOc0WSIvSVzjfGYqXgJs7b3Ws/XY0BeJZm9Zg0ByoVIVxEdzaEBqBnNWcVIVmrGiHaxEDcmp2PudcklGWLgWxZT9R4S4VAj+Hpje1JXUKL4wWAgMaY86jAKGRSb1QTCod7MgLwUVvY7laVFvVymdWEasdDWCKRZ2QFgac4rVrlwNSOTFm06vcC+BH65h/0oGDaBkQWnCxMWDHyq1QRpDhrPr9lXCWJzXTcCokzP5Gr5xDG36ULjFVwCVneH7gKP4ldbs1nLTlRVpQh42UH6INcdkULSWhmmAIFUm5Z3u9F0jiusbnghtZ6z/IXkqAtzWdgKN1t5xaoqgZAonR4sGlQR2LAo31WIQhvpfGiSa3qCMN+50fVncSn9m7G5rsRI6w/i2hPg2gsyme9by4dFlRrfj/y8WRjaC8OMLM4EPvpy7/4lGeGqTCvRBpfFAzNr+VE3si/Nd8Nf5z1za+kJeNpnis2j5f86qof4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(39860400002)(366004)(346002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(6512007)(6506007)(71200400001)(83380400001)(82960400001)(122000001)(86362001)(38100700002)(38070700005)(36756003)(2616005)(26005)(2906002)(41300700001)(7416002)(8676002)(8936002)(91956017)(110136005)(4326008)(316002)(66476007)(66556008)(64756008)(54906003)(66446008)(66946007)(478600001)(76116006)(6486002)(966005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnQ5WHVHaXdjc0hLckxkektTNEZsZ1lkQUlXdjJ1REJMNHhxUWYvN21Ob1hE?=
 =?utf-8?B?WDBOM2lhNEZrRXFNYWZhMzBkL3Q4ZWE2dnpmbjRBK09DNi83ZllpRGRyZ29V?=
 =?utf-8?B?MlpMWUh2THlibDZQYnBKd2JvS25aMWR3U0I5MXZEMU96Z2R1Ym1DUVJjMlRG?=
 =?utf-8?B?cVRUUGIxRkRpZEd4d0U4NXA4NllCTDE3SzhpSnV4VzRuajRRRTZ4a1dQdFI4?=
 =?utf-8?B?aitwQVduTlpwTE9NVjVnMmRRRk5HVXpBMGk3OFJUTVEwMWF6ZjljTURuQUxC?=
 =?utf-8?B?UmtOaURPcGZDNGFvQVc5Nml4Yk04SHFlYmw4K0xEazUxOXp1SkxvU0dPSUZm?=
 =?utf-8?B?RnVQNSs3YWp4K2x0d01ycUt3MTBScUc5NkNqbFhTeFNDY1dsNC8zU3ZybmtM?=
 =?utf-8?B?WG55VjFzZW9VbGZQM1NuRTlRcTFMRC91NDN6RmhCS0ZKUFZtRmRxalJ1SlVn?=
 =?utf-8?B?ZFpMbWtpeTlSZXFjTVgvbFNQNmtHdGtRQm1kYmRyZWN4M3JzRVBMdUduUzQz?=
 =?utf-8?B?NGJxdERiaktZYklaK0RhK0dSUXNKNUlIV1RFVVlkZkdueVIwM1ljYlIrTzBE?=
 =?utf-8?B?R2IwMmxKNTlEb2pHSDNDdzJSK2FlVGdtNUlxQXFKNXNkLzk0cGJlOXVYWGNj?=
 =?utf-8?B?ZnQyUmhZaFh1N01jUGVoNlMxbGFTa0ZKMThNSXNRZVhqQXlXdEwxdlRsbkxi?=
 =?utf-8?B?REQ2ZklBWXlKNG00R0h6bDFUR1ZVenZLQktDY1ZWcnhWR0xhWnFPWEU0SDJM?=
 =?utf-8?B?K3RTYW9XaVRGemc1STBsK3E1NzhRUHFESVloZFUxc2dGYkRCcTBhMEVNY3A3?=
 =?utf-8?B?Uld3bk9zQjRXTC9jbVF0VXRqSDU5NnQxV3R0K1Bkb3ROTURQaHB3TUhGTGhq?=
 =?utf-8?B?UUtCUVI5QTl3S1FlVUZaSHdGQmFXTHZReHc4eFFhZVovVFQ4MUs4bTVYbmhY?=
 =?utf-8?B?L0p5ZldFTWFKT2huTlQ2Vms3dUNKZ2xENU9rNHZLbTBRbENsdFlhZWp4WkF2?=
 =?utf-8?B?YzJCWnZhemZrQmJjem5ac1NqNWl6b21HWW1sa0ZMV1dYUjZoRGl4WTZSR0hh?=
 =?utf-8?B?aS9kZjBCQm9ETjJZMUtwVGJ0Z1hGR1dOVTNnV1Y2V3JyRUN6YkwvNmNPdTl4?=
 =?utf-8?B?cFIzdy80VUoyZG5GUkw3V05pRzU3aVQwMyt1YzJyQ202dU5vWnhJdHdBM3U3?=
 =?utf-8?B?ai9ZQ0thTFFWd2ZpbFJnWDhYcnZGR0RGY25NQ3NVeWFCNy9VUkZIa1AzSytk?=
 =?utf-8?B?Tk1Ec05aSitneERaTEpMSmQrMTNxRVVKVjB0VDZkOWxtaUh5UHNJdzc3emUx?=
 =?utf-8?B?Zk9GQlBZV1FCeDN3Z29tWWZ3bDR4d2F6Mm9EYVN0YzVTemFJcUM5TXBLNldH?=
 =?utf-8?B?QkdBb3QwY013eUhEZmlOR1dXTmpueVgzSWJXL3dIV2hSRDcyM3dTYStyZCtt?=
 =?utf-8?B?cFhVd1kraXFBbEVaM1NiV2Y4aWxtM1poaUlGUDMwQzcvYXpZc2ZvMkM3QXJL?=
 =?utf-8?B?NjdNTW1yL3dwdVYrU1JLc21SempNa1VrWk1lUm92WXJTWlpVcHg4djd0Q2tm?=
 =?utf-8?B?MkgvRk16Q2ZYU2QyVVdYaU9oNHR6bkpnUUNiYkhpK2UxVnRnRWU0ZjZnSXhk?=
 =?utf-8?B?SERZVERBTmtBSFR6WWVjTXk4UzVBNm96a2lVVTZXQTFoRDYvVjhlVTNiTWRQ?=
 =?utf-8?B?SXgxVlZqK2dIelZFSDVEcktuSUJCaGxxMUZDb0V4SC9ZSkNwOGxoR1JKM29N?=
 =?utf-8?B?ZnllV2w5N2xpTHJ1VmtqdlIwMGJBZDBCRnlzRGRyZWNxMU1WOWNMUTBOMmJn?=
 =?utf-8?B?M1hZaW5JNXBzakRQZ0xTakpBd0wvaWlaN0RBZ2pqUEtMaDJ6WGF5TGdEOHF2?=
 =?utf-8?B?M29ESFlSQnVtM1RFdUJmM1NpWkRpZDNvejFvOXdueGVsYUlXNjBnSWQwcFlh?=
 =?utf-8?B?UnpDcHRMdFViVXRwY29aUW11YTgxMzEwaWdiY0hLZkRHcU54SlluNTI0Q1E5?=
 =?utf-8?B?RFBKdUQreTJZRFo1OGl6dmFGQXhBbkZnV3AvRlZoTFJJN2NGbHRNMjlkTkFE?=
 =?utf-8?B?TWhRUWRIYTVJaTMvRk5SY3VtNUdrYitxaFU1UlVaSGNqNmhxRUl5ejEzK0pG?=
 =?utf-8?B?RXBSTEtOdFVUUjB5M0NucHk0bWU0KzBsZjBMNGxCUUlIcmpVcnAxbTlwQmpF?=
 =?utf-8?B?enc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BCFB1343CDF6449B8F95F092C7C0B47@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ded43885-b689-47ce-d714-08dbc00c5f54
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2023 10:19:17.4481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ywzcsYVwNjqoheMjx8hk0KrL/s+pzqi6gSFWZ3ZLypAOrupBEZELpwKPry8d4v2/rGlws21PiDfb/6kg5N0NzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5270
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA5LTI4IGF0IDEwOjQ4ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAyNS4wOC4yMyDQsy4gMTU6MTQg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
SW50ZWwgVHJ1c3RlZCBEb21haW4gRXh0ZW5zaW9ucyAoVERYKSBwcm90ZWN0cyBndWVzdCBWTXMg
ZnJvbSBtYWxpY2lvdXMNCj4gPiBob3N0IGFuZCBjZXJ0YWluIHBoeXNpY2FsIGF0dGFja3MuICBU
RFggc3BlY3MgYXJlIGF2YWlsYWJsZSBpbiBbMV0uDQo+ID4gDQo+ID4gVGhpcyBzZXJpZXMgaXMg
dGhlIGluaXRpYWwgc3VwcG9ydCB0byBlbmFibGUgVERYIHdpdGggbWluaW1hbCBjb2RlIHRvDQo+
ID4gYWxsb3cgS1ZNIHRvIGNyZWF0ZSBhbmQgcnVuIFREWCBndWVzdHMuICBLVk0gc3VwcG9ydCBm
b3IgVERYIGlzIGJlaW5nDQo+ID4gZGV2ZWxvcGVkIHNlcGFyYXRlbHlbMl0uICBBIG5ldyBLVk0g
Imd1ZXN0X21lbWZkKCkiIHRvIHN1cHBvcnQgcHJpdmF0ZQ0KPiA+IG1lbW9yeSBpcyBhbHNvIGJl
aW5nIGRldmVsb3BlZFszXS4gIEtWTSB3aWxsIG9ubHkgc3VwcG9ydCB0aGUgbmV3DQo+ID4gImd1
ZXN0X21lbWZkKCkiIGluZnJhc3RydWN0dXJlIGZvciBURFguDQo+ID4gDQo+ID4gQWxzbywgYSBm
ZXcgZmlyc3QgZ2VuZXJhdGlvbnMgb2YgVERYIGhhcmR3YXJlIGhhdmUgYW4gZXJyYXR1bVs0XSwg
YW5kDQo+ID4gcmVxdWlyZSBhZGRpdGlvbmFsIGhhbmRpbmcuDQo+ID4gDQo+ID4gVGhpcyBzZXJp
ZXMgZG9lc24ndCBhaW0gdG8gc3VwcG9ydCBhbGwgZnVuY3Rpb25hbGl0aWVzLCBhbmQgZG9lc24n
dCBhaW0NCj4gPiB0byByZXNvbHZlIGFsbCB0aGluZ3MgcGVyZmVjdGx5LiAgQWxsIG90aGVyIG9w
dGltaXphdGlvbnMgd2lsbCBiZSBwb3N0ZWQNCj4gPiBhcyBmb2xsb3ctdXAgb25jZSB0aGlzIGlu
aXRpYWwgVERYIHN1cHBvcnQgaXMgdXBzdHJlYW1lZC4NCj4gPiANCj4gPiBIaSBEYXZlL0tpcmls
bC9QZXRlci9Ub255L0RhdmlkIGFuZCBhbGwsDQo+ID4gDQo+ID4gVGhhbmtzIGZvciB5b3VyIHJl
dmlldyBvbiB0aGUgcHJldmlvdXMgdmVyc2lvbnMuICBBcHByZWNpYXRlIHlvdXIgcmV2aWV3DQo+
ID4gb24gdGhpcyB2ZXJzaW9uIGFuZCBhbnkgdGFnIGlmIHBhdGNoZXMgbG9vayBnb29kIHRvIHlv
dS4gIFRoYW5rcyENCj4gPiANCj4gPiBUaGlzIHZlcnNpb24gd2FzIGJhc2VkIG9uICJVbmlmeSBU
RENBTEwvU0VBTUNBTEwgYW5kIFREVk1DQUxMIGFzc2VtYmx5Ig0KPiA+IHNlcmllcywgd2hpY2gg
d2FzIGJhc2VkIG9uIGxhdGVzdCB0aXAveDg2L3RkeCwgcmVxdWVzdGVkIGJ5IFBldGVyOg0KPiA+
IA0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvY292ZXIuMTY5MjA5Njc1My5naXQu
a2FpLmh1YW5nQGludGVsLmNvbS8NCj4gPiANCj4gPiBQbGVhc2UgYWxzbyBoZWxwIHRvIHJldmll
dyB0aGF0IHNlcmllcy4gIFRoYW5rcyENCj4gPiANCj4gDQo+IA0KPiBBcmUgdGhlcmUgYW55IG1h
am9yIG91dHN0YW5kaW5nIGlzc3VlcyBwcmV2ZW50aW5nIHRoaXMgdG8gYmUgbWVyZ2VkPyBUaGUg
DQo+IHJldmlldyBoYXMgYmVlbiBzb21ld2hhdCBxdWlldCBhbmQgbW9zdCBvZiB0aGUgb3V0c3Rh
bmRpbmcgaXNzdWVzIHNlZW1zIA0KPiB0byBiZSBuaXRwaWNrcz8NCg0KSGkgTmlrb2xheSwNCg0K
SSBhbSBhZGRyZXNzaW5nIGNvbW1lbnRzIGZyb20gUmljaywgZS5nLiwgc29tZSBhZGRpdGlvbmFs
IGhhbmRsaW5nIHRvDQpTMy9oaWJlcm5hdGlvbiBpcyBuZWVkZWQuICBJJ2xsIHBvc3QgdGhlIG5l
eHQgdmVyc2lvbiBzb29uLCB3aGljaCBJIGhvcGUgY2FuIGJlDQp0aGUgY2FuZGlkYXRlIHRvIGJl
IG1lcmdlZC4gIFRoYW5rcyENCg==
