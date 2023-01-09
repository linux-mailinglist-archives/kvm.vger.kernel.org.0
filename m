Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F61066232B
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 11:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbjAIK0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 05:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbjAIK0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 05:26:13 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE48B6C;
        Mon,  9 Jan 2023 02:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673259970; x=1704795970;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GYxK1iEhyj0JGYKgVhD0rNTGLG2OEWl24MwLydFE4eM=;
  b=EBIsq29u2Syo/vBCLKYhAlUc9lELDU127v2Y4BkqTnjKCTmSwjOquRN+
   uLWl2ABCTs/QLRF6IYB+HH5uWpI6WRZPlYDebxruhXzToCGfD7macveMk
   nwwRa0SyJvdDzO1tFhedu+wRwbVS5/9SveTBA2Un2MXFdyQ95Z/8k3K9Z
   CMQAqoGtIUnayqa896fy3pyjf6mGYh1icgSib627ln76LcmLINxwTNCcd
   f3SYgU+2xkxddSs7W5xsHIV8IznFKpMbIA2usQNaMgy9UQCjQXPdbdLgG
   5ZWKvxbdcTgGt1AfLJpnPYgXENQyTOgFoIu6LKGPXkbj6FvoKFCkZxub/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="324089207"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="324089207"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 02:26:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="745331701"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="745331701"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Jan 2023 02:25:59 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 02:25:59 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 02:25:59 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 02:25:59 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 02:25:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8jIUvsvZKydH0rVPsDnwMYPq8BYhSoANCM+z0Q4EkdtwYvS4k2qPAfjIirVhVoHgTFMZnp/hUDEY4xLjJTTMrypTDtzQn3t3eNgy2ANyaPn287a2Wqa5MHhTnpxQBVdUp3l5Lpd/v39fkjVpqqY0XZc07idNTwYT0MdFbYIoevVCmcFenKtw2Sjt42kvjskljOffBEZhn+sqRLtiEU0ldHvwwg4BIBadVlfxeGmYSd4zdBZeUBXrEOpgWzSTa+8qNco8qNZbHeJPL7dV2AMy91bG2lbWwcnsCSycHdCz/+jRQ1Cams1plflzYXbw5o2haO2dFfoEXpPy/ta0PAL7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYxK1iEhyj0JGYKgVhD0rNTGLG2OEWl24MwLydFE4eM=;
 b=Uu6SkUrybwiRujL33pIfqQ9E6rBqpEfT0rN4o+LWRxgBehp3RFpSQnSBI97GBmT+Pvc81AJQEbQPRN/8X3d9xd847/1lNgTZ+v68I3+8fJ1pVqVRBGxir7iPOZ7QPXza2KLCoo9zRge8vnQWIwZ33kwL4VUIJogN88YOJ3ageJ4cKPzrThXxj2a+V+gt2avuCNImGLvilQU+4QuKbwBvF3K78xbMk49A+Lc2mVQt9gCcQI/A1b0uDqpqmvk0AwWA7WAE3yiVqnTPrwEBbmbqta7p+fQKCKo3MV8288psfc8lin7aTnSn0RBs3r9lU5dvrfwP1Yvrkk+uDtg5UIBW0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6740.namprd11.prod.outlook.com (2603:10b6:303:209::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 9 Jan
 2023 10:25:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 10:25:55 +0000
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
Subject: Re: [PATCH v8 06/16] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v8 06/16] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHZC5gFuAba9tjOq0ycIRHt8DkLjK6R1lgAgAQ7+IA=
Date:   Mon, 9 Jan 2023 10:25:55 +0000
Message-ID: <e605ce95f1b92fae630bf6abb801774bc28d8072.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <7c21a3de810397901bade0b1021912bbbf2d18bd.1670566861.git.kai.huang@intel.com>
         <d1093b3e-cdab-b138-d488-19b9456be978@intel.com>
In-Reply-To: <d1093b3e-cdab-b138-d488-19b9456be978@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6740:EE_
x-ms-office365-filtering-correlation-id: fad22a87-ae94-4281-25e5-08daf22be454
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mIKIdLTQDPk89SH1dFlIubtwY0sPga0TDvhaK4B4T8wuzCt5POEsF0vIHjo4dpvB+Ala5NTRKj3EbP778VnwLMJZuSnPJQQ8w0oHGcOl/ckVy7PAIyFAqfkrez9m0ANwnT8l1slRA50H7Zlvu/ZHdEYQk5Un5u9nTzqX+jvZ34xann+Uhy9p/KnRT1kq0fqBdG3DzeqWTQU2f6izIVlMs6PnvM25EZmHLwtEIqfRyZsRdgi8Q+dxIC8TeqmKdZJIbgdLEb4P3SUAqLN7M/CCe2r/U4cSjXl3IokIkNE3GXbIDpkwulW2zDLQzU8PMeKyoR4d8WDJVAktFzG9ovyKhE2KoTB4NvusM82duxxTtiiDd4IfvkEJxiovgRn7J/bRCS331xZ6Q+RGWTFsAxnk78Rll363gZU4b/vgvVSK/IXHVw+Ypi/RJHaJ11c9sgXekZwwMhFjVLxk1PKsi2sVWeENgYVuzaEQrD8Ad4y5MDhw5ccNOe51z2Sf+VJ3Hl64+5zY1amxlVVveA26xS+kamvnOh9snSu9mnD70dhfRM85oMQb7nUN70qAGlKq1s+ppPcKH2T//VOhkpgwA6ETNnt+LjDinZ0DpxCkiZmyein1+va1AX2I+kDn4Xf/BcMqCRjoTOHUxV9u2gkOxw4XrSH3K9ZWYn6aS3v8jn2YID28y0F/G7k9gC+B29+2uZ3pQyBmcYHCT+ujVCtLRbqf4LyNCkcrCRpAcXOa5KSQQRllmNjTJwOap1dgeNCcp3uzRvIh6Le6WCfST0nmXX7zuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(41300700001)(66946007)(8936002)(76116006)(316002)(8676002)(91956017)(110136005)(7416002)(54906003)(2906002)(64756008)(4326008)(5660300002)(53546011)(71200400001)(6506007)(966005)(66476007)(478600001)(66446008)(6486002)(66556008)(86362001)(26005)(186003)(83380400001)(2616005)(38100700002)(36756003)(38070700005)(122000001)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2JCTmNrODZiczRwR0VjTUxWZ1k3VTNHZUxranNKLy82SGk3dFM4OVBBQ3Yz?=
 =?utf-8?B?NFQyekNNN1hTRmtFRytQQlhodlpFMDN0eDFvSHdZQ3F3WUllM3dSY0E4dEN4?=
 =?utf-8?B?eEVrLzg4d0pCNjlqTGF6bWlOaFhPYUNDNVpqTldjNmJvdWg4cWxLRVVhT1BM?=
 =?utf-8?B?NkZOeWFNb3JxWi9tVmtHaWVXT3RlV09hQ2NHSVN5QjRycHoyT01EeDhqOFoz?=
 =?utf-8?B?dGkveU53NEhJeXVCcHBCUHpuVUZIeVNqWnp5UXF3U3lOVzlGOFdpY1JsVEdk?=
 =?utf-8?B?eExKL01EbjNnMjhydmpvNldTN2VCTlZ5SENNUzJkdXdZNDN5Q2Y3a2VEY3FJ?=
 =?utf-8?B?c1RGUFRrVU1JaG9yTWRTSGVhSGRXK3Z0cVdnblBZa3B0REdOblNrZmROVzV3?=
 =?utf-8?B?Mk92cE8wam5rWXQ5QW5QVmNlVDBRaHowUGIxbjJRY0dWRU9YeFlmNm55dm4w?=
 =?utf-8?B?WGlVbTNxVnh2azkwckhHMGRVdy8zaENITFRUMEdHTGsrRjFTTVYwQS9FWDJa?=
 =?utf-8?B?V1lGS0tmSTRhb2JiSnkxUmNWMC9EMGp2UzdReXFEUmVnN2NDV05yMWZtUzVr?=
 =?utf-8?B?dnFMaWwrTFNSZjIwODFyS21hRlg1WWl3bDBodWlBeVJrckIydkdnaHgvWDBE?=
 =?utf-8?B?d2FvMUN4aWx3YUFJc0t1SVJrazd1NzVDZERJNWtwY1l0SFZ3M0EwRk9VaFJI?=
 =?utf-8?B?RmFpNERhSEVvVFdaYkNHc0JlK1k4SFNYcnh5WjFYYmxWSUtSbHVXd3BJbm9G?=
 =?utf-8?B?Z3lNK2p3VzR1cnZTMHRpUG5MeE51cU5uZ3NoUDNiZE9Bam5Mb1ZnNUFFRXIz?=
 =?utf-8?B?UFlQNXRGUEw3eEFsOUcyZ2MzZVV3aHljSmhtbEYwZjl4SnNSd1Z2R2NHdGk3?=
 =?utf-8?B?VzlKQTl1d0pMRVFsbzVuZHQ5MDhPMnNrS3JIb2JybG9SK3lKQkFCc3hINW1T?=
 =?utf-8?B?bHlYZ0hFM1lQL0hmTWhENjE3RXZjVFUxT25ETGJONDJxeDFDK1hDWHBEOE1U?=
 =?utf-8?B?QW9WY2ZlZFJ4M3JCSmlSdjJ0RHVlZXpLeURCTE1rNUxRcDRmcW9IU25lR1Vj?=
 =?utf-8?B?ZVRTOGV5QzFpWTRvdERTSjJIcnZTSkRuamF0VWlIYW8zeXpLTTlMWnNjWDZh?=
 =?utf-8?B?Nm5UTm1zR0lTRzh3a012dTJXNTBiQXA0dEVHTnIwNVA3S25hUjRNV2dpVVhF?=
 =?utf-8?B?QUcrZUFCMUh6a3d4OHdiQmc2bUVEQUFhcDBLMmZoN0tPNUl4K1BkVEdJZk8r?=
 =?utf-8?B?RzBwMUVtTnV1NXkxa0dHY0g0bTFEMDJPNmY4RGVCV0xKR2xvZVRwQkw2djA5?=
 =?utf-8?B?cVdpcDMzN3M4S0xiRVJ5bURZYjFFNjdLS1pYQ3RUckRiREd3WHRLYk41T0ho?=
 =?utf-8?B?UDFyUFE5RjJSUWpvY1lBOXMyT1U4Z21rdmQxZG8zdmNhL0U3RG5jdXlGYUFT?=
 =?utf-8?B?dVRJYzlRejRKeDdrWU9rVWR3dFk1WG4xb0cwcGJ6TzhlaU0walVFVTdnbmNs?=
 =?utf-8?B?QjZXTVc2cGRCSm1uNXl3eDdmMHhvZjFuVCthSU0za2RVV2tjOVNPb3RRTmhB?=
 =?utf-8?B?YnAxd1RmZ0d5QjFoSURnQVMxZFFjbXB0UmxyemphWHcvTlJFa3UyUVNONUtS?=
 =?utf-8?B?cCs1dUIvSU5rKzJXNzRjelFVYm5kdmU4SnNoQ2xEb2tjcTd2NzIzMDBxZFRs?=
 =?utf-8?B?QjBHem44dGJSbVdWV05jSklGUVRCeXVrWnlXaTZuWWZxRGdaSTRxL0xQd1dR?=
 =?utf-8?B?MVFjTGhPemxQRVkwa0x2bTlmSjdHb1hnNTh2VitYaUZwTHYwVDI3ZVE3dEcy?=
 =?utf-8?B?ZTA2K3NCTkVYUlQxYUM3eUMrYUNhbklkR1VYM2hKU0lodjFIQjFGSmMvNDdX?=
 =?utf-8?B?OU9QTmxnelBDUjJ3c1hLV29qYUNrTTRZekVYRnloL2RPRU5UakhyWlNkWTBX?=
 =?utf-8?B?MnlCRjlOSGMrS3d2TXZpRzhlUjBRenQ4MWR5bTNHQWQrZi8xeDF5Y2t4bXV2?=
 =?utf-8?B?a283aU5wNmFYUm51MzB2cE5mSVlxTzdKeXpwdm5BbEJBaXVOc3YxL3VBNnhK?=
 =?utf-8?B?MkM5alFTcnhZdCtCYmNiUnh4N29UYzZ4V2RMbk1TeEdZZzBSbURFUWJ3bXVG?=
 =?utf-8?B?RkhUNlZ1bGVhNi9hNEpWVjlTb1M5dTh6bVZFa2VCdXhpbG1IWGx1Z2tEV1U1?=
 =?utf-8?B?TWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDA3B9D0C57B9A42B5E032E70E969719@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad22a87-ae94-4281-25e5-08daf22be454
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 10:25:55.4113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MWMsaZWKQyXhpXiUEYHbboO78DmPTOpPYiOW7vwYrgqJVjqDTW77NOZZB/TtW+2yC9ypatw4UeHi64c2iiei2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6740
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

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDA5OjQ2IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAyMjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IEZvciBub3csIGJvdGggdGhl
IFREWCBtb2R1bGUgaW5mb3JtYXRpb24gYW5kIENNUnMgYXJlIG9ubHkgdXNlZCBkdXJpbmcNCj4g
PiB0aGUgbW9kdWxlIGluaXRpYWxpemF0aW9uLCBzbyBkZWNsYXJlIHRoZW0gYXMgbG9jYWwuICBI
b3dldmVyLCB0aGV5IGFyZQ0KPiA+IDEwMjQgYnl0ZXMgYW5kIDUxMiBieXRlcyByZXNwZWN0aXZl
bHkuICBQdXR0aW5nIHRoZW0gdG8gdGhlIHN0YWNrDQo+ID4gZXhjZWVkcyB0aGUgZGVmYXVsdCAi
c3RhY2sgZnJhbWUgc2l6ZSIgdGhhdCB0aGUga2VybmVsIGFzc3VtZXMgYXMgc2FmZSwNCj4gPiBh
bmQgdGhlIGNvbXBpbGVyIHlpZWxkcyBhIHdhcm5pbmcgYWJvdXQgdGhpcy4gIEFkZCBhIGtlcm5l
bCBidWlsZCBmbGFnDQo+ID4gdG8gZXh0ZW5kIHRoZSBzYWZlIHN0YWNrIHNpemUgdG8gNEsgZm9y
IHRkeC5jIHRvIHNpbGVuY2UgdGhlIHdhcm5pbmcgLS0NCj4gPiB0aGUgaW5pdGlhbGl6YXRpb24g
ZnVuY3Rpb24gaXMgb25seSBjYWxsZWQgb25jZSBzbyBpdCdzIHNhZmUgdG8gaGF2ZSBhDQo+ID4g
NEsgc3RhY2suDQo+IA0KPiBHYWguICBUaGlzIGhhcyBnb25lIG9mZiBpbiBhIHJlYWxseSBvZGQg
ZGlyZWN0aW9uLg0KPiANCj4gVGhlIGZhY3QgdGhhdCB0aGlzIGlzIGNhbGxlZCBvbmNlIHJlYWxs
eSBoYXMgbm90aGluZyB0byBkbyB3aXRoIGhvdw0KPiB0b2xlcmFudCBvZiBhIGxhcmdlIHN0YWNr
IHdlIHNob3VsZCBiZS4gIElmIGEgZnVuY3Rpb24gaXMgY2FsbGVkIG9uY2UNCj4gZnJvbSBhIGRl
ZXAgY2FsbCBzdGFjaywgaXQgY2FuJ3QgY29uc3VtZSBhIGxvdCBvZiBzdGFjayBzcGFjZS4gIElm
IGl0J3MNCj4gY2FsbGVkIGEgYmlsbGlvbiB0aW1lcyBmcm9tIGEgc2hhbGxvdyBzdGFjayBkZXB0
aCwgaXQgY2FuIHVzZSBhbGwgdGhlDQo+IHN0YWNrIGl0IHdhbnRzLg0KDQpBZ3JlZWQuDQoNCj4g
DQo+IEFsbCBJIHJlYWxseSB3YW50ZWQgaGVyZSB3YXMgdGhpczoNCj4gDQo+IHN0YXRpYyBpbnQg
aW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+IHsNCj4gLQlzdHJ1Y3QgY21yX2luZm8gY21yX2FycmF5
W01BWF9DTVJTXSAuLi47KwlzdGF0aWMgc3RydWN0IGNtcl9pbmZvDQo+IGNtcl9hcnJheVtNQVhf
Q01SU10gLi4uOw0KPiANCj4gSnVzdCBtYWtlIHRoZSBmdW5jdGlvbiB2YXJpYWJsZSBzdGF0aWMg
aW5zdGVhZCBvZiBoYXZpbmcgaXQgYmUgYSBnbG9iYWwuDQo+ICBUaGF0J3MgKklUKi4NCg0KWWVz
IHdpbGwgZG8uDQoNCkJ0dywgSSB0aGluayBwdXR0aW5nIGhhcmR3YXJlLXVzZWQgKHBoeXNpY2Fs
bHkgY29udGlndW91cyBsYXJnZSkgZGF0YSBzdHJ1Y3R1cmUNCm9uIHRoZSBzdGFjayBpc24ndCBh
IGdvb2QgaWRlYSBhbnl3YXkuICBUaGUgcmVhc29uIGlzIGFzIHJlcGxpZWQgaW4gYmVsb3cgbGlu
azoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0vY2MxOTVlYjY0OTljZjAyMWI0
Y2UyZTkzNzIwMDU3MTkxNWJmZTY2Zi5jYW1lbEBpbnRlbC5jb20vVC8jbTQ4NTA2NDUwY2QyMmY4
NGFiNzE4ZDNiNWJmOGRkYmZmOGZjYzMzNjINCg0KS2VybmVsIHN0YWNrIGNhbiBiZSB2bWFsbG9j
KCktZWQsIHNvIGl0IGRvZXNuJ3QgZ3VhcmFudGVlIGRhdGEgc3RydWN0dXJlIGlzDQpwaHlzaWNh
bGx5IGNvbnRpZ3VvdXMgaWYgZGF0YSBzdHJ1Y3R1cmUgaXMgYWNyb3NzIHBhZ2UgYm91bmRhcnku
DQoNClRoaXMgcGFydGljdWxhciBURFggY2FzZSB3b3JrcyBiZWNhdXNlIHRoZSBzaXplIGFuZCB0
aGUgYWxpZ25tZW50IG1ha2Ugc3VyZSBib3RoDQpjbXJfYXJyYXlbXSBhbmQgdGRzeXNpbmZvIGNh
bm5vdCBjcm9zcyBwYWdlIGJvdW5kYXJ5Lg0KDQo+IA0KPiA+IE5vdGUgbm90IGFsbCBtZW1iZXJz
IGluIHRoZSAxMDI0IGJ5dGVzIFREWCBtb2R1bGUgaW5mb3JtYXRpb24gYXJlIHVzZWQNCj4gPiAo
ZXZlbiBieSB0aGUgS1ZNKS4NCj4gDQo+IEknbSBub3Qgc3VyZSB3aGF0IHRoaXMgaGFzIHRvIGRv
IHdpdGggYW55dGhpbmcuDQoNCllvdSBtZW50aW9uZWQgaW4gdjcgdGhhdDoNCg0KPj4gVGhpcyBp
cyBhbHNvIGEgZ3JlYXQgcGxhY2UgdG8gbWVudGlvbiB0aGF0IHRoZSB0ZHN5c2luZm9fc3RydWN0
IGNvbnRhaW5zDQo+PiBhICpsb3QqIG9mIGd1bmsgd2hpY2ggd2lsbCBub3QgYmUgdXNlZCBmb3Ig
YSBiaXQgb3IgdGhhdCBtYXkgbmV2ZXIgZ2V0DQo+PiB1c2VkLg0KDQpodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9saW51eC1tbS9jYzE5NWViNjQ5OWNmMDIxYjRjZTJlOTM3MjAwNTcxOTE1YmZlNjZm
LmNhbWVsQGludGVsLmNvbS9ULyNtMTY4ZTYxOWFhYzk0NWZhNDE4Y2NiMWQ2NjUyMTEzMDAzMjQz
ZDg5NQ0KDQpQZXJoYXBzIEkgbWlzdW5kZXJzdG9vZCBzb21ldGhpbmcgYnV0IEkgd2FzIHRyeWlu
ZyB0byBhZGRyZXNzIHRoaXMuDQoNClNob3VsZCBJIHJlbW92ZSB0aGlzIHNlbnRlbmNlPw0KDQo+
IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvTWFrZWZpbGUgYi9hcmNo
L3g4Ni92aXJ0L3ZteC90ZHgvTWFrZWZpbGUNCj4gPiBpbmRleCAzOGQ1MzRmMmMxMTMuLmY4YTQw
ZDE1ZmRmYyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvTWFrZWZpbGUN
Cj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvTWFrZWZpbGUNCj4gPiBAQCAtMSwyICsx
LDMgQEANCj4gPiAgIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5DQo+ID4g
K0NGTEFHU190ZHgubyArPSAtV2ZyYW1lLWxhcmdlci10aGFuPTQwOTYNCj4gPiAgb2JqLXkgKz0g
dGR4Lm8gc2VhbWNhbGwubw0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgv
dGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBpbmRleCBiN2NlZGYwNTg5
ZGIuLjZmZTUwNWMzMjU5OSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgv
dGR4LmMNCj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBAQCAtMTMs
NiArMTMsNyBAQA0KPiA+ICAjaW5jbHVkZSA8bGludXgvZXJybm8uaD4NCj4gPiAgI2luY2x1ZGUg
PGxpbnV4L3ByaW50ay5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvbXV0ZXguaD4NCj4gPiArI2lu
Y2x1ZGUgPGFzbS9wZ3RhYmxlX3R5cGVzLmg+DQo+ID4gICNpbmNsdWRlIDxhc20vbXNyLmg+DQo+
ID4gICNpbmNsdWRlIDxhc20vdGR4Lmg+DQo+ID4gICNpbmNsdWRlICJ0ZHguaCINCj4gPiBAQCAt
MTA3LDkgKzEwOCw4IEBAIGJvb2wgcGxhdGZvcm1fdGR4X2VuYWJsZWQodm9pZCkNCj4gPiAgICog
bGVhZiBmdW5jdGlvbiByZXR1cm4gY29kZSBhbmQgdGhlIGFkZGl0aW9uYWwgb3V0cHV0IHJlc3Bl
Y3RpdmVseSBpZg0KPiA+ICAgKiBub3QgTlVMTC4NCj4gPiAgICovDQo+ID4gLXN0YXRpYyBpbnQg
X19hbHdheXNfdW51c2VkIHNlYW1jYWxsKHU2NCBmbiwgdTY0IHJjeCwgdTY0IHJkeCwgdTY0IHI4
LCB1NjQgcjksDQo+ID4gLQkJCQkgICAgdTY0ICpzZWFtY2FsbF9yZXQsDQo+ID4gLQkJCQkgICAg
c3RydWN0IHRkeF9tb2R1bGVfb3V0cHV0ICpvdXQpDQo+ID4gK3N0YXRpYyBpbnQgc2VhbWNhbGwo
dTY0IGZuLCB1NjQgcmN4LCB1NjQgcmR4LCB1NjQgcjgsIHU2NCByOSwNCj4gPiArCQkgICAgdTY0
ICpzZWFtY2FsbF9yZXQsIHN0cnVjdCB0ZHhfbW9kdWxlX291dHB1dCAqb3V0KQ0KPiA+ICB7DQo+
ID4gIAl1NjQgc3JldDsNCj4gPiAgDQo+ID4gQEAgLTE1MCwxMiArMTUwLDg1IEBAIHN0YXRpYyBp
bnQgX19hbHdheXNfdW51c2VkIHNlYW1jYWxsKHU2NCBmbiwgdTY0IHJjeCwgdTY0IHJkeCwgdTY0
IHI4LCB1NjQgcjksDQo+ID4gIAl9DQo+ID4gIH0NCj4gPiAgDQo+ID4gK3N0YXRpYyBpbmxpbmUg
Ym9vbCBpc19jbXJfZW1wdHkoc3RydWN0IGNtcl9pbmZvICpjbXIpDQo+ID4gK3sNCj4gPiArCXJl
dHVybiAhY21yLT5zaXplOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBwcmludF9j
bXJzKHN0cnVjdCBjbXJfaW5mbyAqY21yX2FycmF5LCBpbnQgbnJfY21ycykNCj4gPiArew0KPiA+
ICsJaW50IGk7DQo+ID4gKw0KPiA+ICsJZm9yIChpID0gMDsgaSA8IG5yX2NtcnM7IGkrKykgew0K
PiA+ICsJCXN0cnVjdCBjbXJfaW5mbyAqY21yID0gJmNtcl9hcnJheVtpXTsNCj4gPiArDQo+ID4g
KwkJLyoNCj4gPiArCQkgKiBUaGUgYXJyYXkgb2YgQ01ScyByZXBvcnRlZCB2aWEgVERILlNZUy5J
TkZPIGNhbg0KPiA+ICsJCSAqIGNvbnRhaW4gdGFpbCBlbXB0eSBDTVJzLiAgRG9uJ3QgcHJpbnQg
dGhlbS4NCj4gPiArCQkgKi8NCj4gPiArCQlpZiAoaXNfY21yX2VtcHR5KGNtcikpDQo+ID4gKwkJ
CWJyZWFrOw0KPiA+ICsNCj4gPiArCQlwcl9pbmZvKCJDTVI6IFsweCVsbHgsIDB4JWxseClcbiIs
IGNtci0+YmFzZSwNCj4gPiArCQkJCWNtci0+YmFzZSArIGNtci0+c2l6ZSk7DQo+ID4gKwl9DQo+
ID4gK30NCj4gPiArDQo+ID4gKy8qDQo+ID4gKyAqIEdldCB0aGUgVERYIG1vZHVsZSBpbmZvcm1h
dGlvbiAoVERTWVNJTkZPX1NUUlVDVCkgYW5kIHRoZSBhcnJheSBvZg0KPiA+ICsgKiBDTVJzLCBh
bmQgc2F2ZSB0aGVtIHRvIEBzeXNpbmZvIGFuZCBAY21yX2FycmF5LCB3aGljaCBjb21lIGZyb20g
dGhlDQo+ID4gKyAqIGtlcm5lbCBzdGFjay4gIEBzeXNpbmZvIG11c3QgaGF2ZSBiZWVuIHBhZGRl
ZCB0byBoYXZlIGVub3VnaCByb29tDQo+ID4gKyAqIHRvIHNhdmUgdGhlIFREU1lTSU5GT19TVFJV
Q1QuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW50IHRkeF9nZXRfc3lzaW5mbyhzdHJ1Y3QgdGRz
eXNpbmZvX3N0cnVjdCAqc3lzaW5mbywNCj4gPiArCQkJICAgc3RydWN0IGNtcl9pbmZvICpjbXJf
YXJyYXkpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB0ZHhfbW9kdWxlX291dHB1dCBvdXQ7DQo+ID4g
Kwl1NjQgc3lzaW5mb19wYSwgY21yX2FycmF5X3BhOw0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+
ID4gKwkvKg0KPiA+ICsJICogQ2Fubm90IHVzZSBfX3BhKCkgZGlyZWN0bHkgYXMgQHN5c2luZm8g
YW5kIEBjbXJfYXJyYXkNCj4gPiArCSAqIGNvbWUgZnJvbSB0aGUga2VybmVsIHN0YWNrLg0KPiA+
ICsJICovDQo+ID4gKwlzeXNpbmZvX3BhID0gc2xvd192aXJ0X3RvX3BoeXMoc3lzaW5mbyk7DQo+
ID4gKwljbXJfYXJyYXlfcGEgPSBzbG93X3ZpcnRfdG9fcGh5cyhjbXJfYXJyYXkpOw0KPiANCj4g
Tm90ZTogdGhleSB3b24ndCBiZSBvbiB0aGUga2VybmVsIHN0YWNrIGlmIHRoZXkncmUgJ3N0YXRp
YycuDQo+IA0KPiA+ICsJcmV0ID0gc2VhbWNhbGwoVERIX1NZU19JTkZPLCBzeXNpbmZvX3BhLCBU
RFNZU0lORk9fU1RSVUNUX1NJWkUsDQo+ID4gKwkJCWNtcl9hcnJheV9wYSwgTUFYX0NNUlMsIE5V
TEwsICZvdXQpOw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsNCj4g
PiArCXByX2luZm8oIlREWCBtb2R1bGU6IGF0cmlidXRlcyAweCV4LCB2ZW5kb3JfaWQgMHgleCwg
bWFqb3JfdmVyc2lvbiAldSwgbWlub3JfdmVyc2lvbiAldSwgYnVpbGRfZGF0ZSAldSwgYnVpbGRf
bnVtICV1IiwNCj4gPiArCQlzeXNpbmZvLT5hdHRyaWJ1dGVzLAlzeXNpbmZvLT52ZW5kb3JfaWQs
DQo+ID4gKwkJc3lzaW5mby0+bWFqb3JfdmVyc2lvbiwgc3lzaW5mby0+bWlub3JfdmVyc2lvbiwN
Cj4gPiArCQlzeXNpbmZvLT5idWlsZF9kYXRlLAlzeXNpbmZvLT5idWlsZF9udW0pOw0KPiA+ICsN
Cj4gPiArCS8qIFI5IGNvbnRhaW5zIHRoZSBhY3R1YWwgZW50cmllcyB3cml0dGVuIHRvIHRoZSBD
TVIgYXJyYXkuICovDQo+ID4gKwlwcmludF9jbXJzKGNtcl9hcnJheSwgb3V0LnI5KTsNCj4gPiAr
DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIGludCBpbml0X3Rk
eF9tb2R1bGUodm9pZCkNCj4gPiAgew0KPiA+ICsJLyoNCj4gPiArCSAqIEB0ZHN5c2luZm8gYW5k
IEBjbXJfYXJyYXkgYXJlIHVzZWQgaW4gVERILlNZUy5JTkZPIFNFQU1DQUxMIEFCSS4NCj4gPiAr
CSAqIFRoZXkgYXJlIDEwMjQgYnl0ZXMgYW5kIDUxMiBieXRlcyByZXNwZWN0aXZlbHkgYnV0IGl0
J3MgZmluZSB0bw0KPiA+ICsJICoga2VlcCB0aGVtIGluIHRoZSBzdGFjayBhcyB0aGlzIGZ1bmN0
aW9uIGlzIG9ubHkgY2FsbGVkIG9uY2UuDQo+ID4gKwkgKi8NCj4gDQo+IEFnYWluLCBtb3JlIHNp
bGxpbmVzcyBhYm91dCBiZWluZyBjYWxsZWQgb25jZS4NCj4gDQo+ID4gKwlERUNMQVJFX1BBRERF
RF9TVFJVQ1QodGRzeXNpbmZvX3N0cnVjdCwgdGRzeXNpbmZvLA0KPiA+ICsJCQlURFNZU0lORk9f
U1RSVUNUX1NJWkUsIFREU1lTSU5GT19TVFJVQ1RfQUxJR05NRU5UKTsNCj4gPiArCXN0cnVjdCBj
bXJfaW5mbyBjbXJfYXJyYXlbTUFYX0NNUlNdIF9fYWxpZ25lZChDTVJfSU5GT19BUlJBWV9BTElH
Tk1FTlQpOw0KPiANCj4gT25lIG1vcmUgdGhpbmcgYWJvdXQgYmVpbmcgb24gdGhlIHN0YWNrOiBU
aGVzZSBhcmVuJ3QgaW1wbGljaXRseSB6ZXJvZWQuDQo+ICBUaGV5IG1pZ2h0IGhhdmUgc3RhY2sg
Z3VuayBmcm9tIG90aGVyIGNhbGxzIGluIHRoZW0uICBJIF90aGlua18gdGhhdCdzDQo+IE9LIGJl
Y2F1c2Ugb2YsIGZvciBpbnN0YW5jZSwgdGhlICdvdXQucjknIHRoYXQgbGltaXRzIGhvdyBtYW55
IENNUnMgZ2V0DQo+IHJlYWQuICBCdXQsIG5vdCBiZWluZyB6ZXJvZWQgaXMgYSBwb3RlbnRpYWwg
c291cmNlIG9mIGJ1Z3MgYW5kIGl0J3MgYWxzbw0KPiBzb21ldGhpbmcgdGhhdCByZXZpZXdlcnMg
KGFuZCB5b3UpIG5lZWQgdG8gdGhpbmsgYWJvdXQgdG8gbWFrZSBzdXJlIGl0DQo+IGRvZXNuJ3Qg
aGF2ZSBzaWRlLWVmZmVjdHMuDQoNCkFncmVlZC4NCg0KQXMgbWVudGlvbmVkIGFib3ZlLCB3aWxs
IGNoYW5nZSB0byB1c2UgJ3N0YXRpYycgYnV0IGtlZXAgdGhlIHZhcmlhYmxlcyBpbiB0aGUNCmZ1
bmN0aW9uLg0KDQo+IA0KPiA+ICsJc3RydWN0IHRkc3lzaW5mb19zdHJ1Y3QgKnN5c2luZm8gPSAm
UEFEREVEX1NUUlVDVCh0ZHN5c2luZm8pOw0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwly
ZXQgPSB0ZHhfZ2V0X3N5c2luZm8oc3lzaW5mbywgY21yX2FycmF5KTsNCj4gPiArCWlmIChyZXQp
DQo+ID4gKwkJZ290byBvdXQ7DQo+ID4gKw0KPiA+ICAJLyoNCj4gPiAgCSAqIFRPRE86DQo+ID4g
IAkgKg0KPiA+IC0JICogIC0gR2V0IFREWCBtb2R1bGUgaW5mb3JtYXRpb24gYW5kIFREWC1jYXBh
YmxlIG1lbW9yeSByZWdpb25zLg0KPiA+ICAJICogIC0gQnVpbGQgdGhlIGxpc3Qgb2YgVERYLXVz
YWJsZSBtZW1vcnkgcmVnaW9ucy4NCj4gPiAgCSAqICAtIENvbnN0cnVjdCBhIGxpc3Qgb2YgVERN
UnMgdG8gY292ZXIgYWxsIFREWC11c2FibGUgbWVtb3J5DQo+ID4gIAkgKiAgICByZWdpb25zLg0K
PiA+IEBAIC0xNjYsNyArMjM5LDkgQEAgc3RhdGljIGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkN
Cj4gPiAgCSAqDQo+ID4gIAkgKiAgUmV0dXJuIGVycm9yIGJlZm9yZSBhbGwgc3RlcHMgYXJlIGRv
bmUuDQo+ID4gIAkgKi8NCj4gPiAtCXJldHVybiAtRUlOVkFMOw0KPiA+ICsJcmV0ID0gLUVJTlZB
TDsNCj4gPiArb3V0Og0KPiA+ICsJcmV0dXJuIHJldDsNCj4gPiAgfQ0KPiANCj4gSSdtIGdvaW5n
IHRvIGJlIGxhenkgYW5kIG5vdCBsb29rIGludG8gdGhlIGZ1dHVyZS4gIEJ1dCwgeW91IGRvbid0
IG5lZWQNCj4gdGhlICJvdXQ6IiBsYWJlbCBoZXJlLCB5ZXQuICBJdCBkb2VzbidzZXJ2ZSBhbnkg
cHVycG9zZSBsaWtlIHRoaXMsIHNvDQo+IHdoeSBpbnRyb2R1Y2UgaXQgaGVyZT8NCg0KVGhlICdv
dXQnIGxhYmVsIGlzIGhlcmUgYmVjYXVzZSBvZiBiZWxvdyBjb2RlOg0KDQoJcmV0ID0gdGR4X2dl
dF9zeXNpbmZvKC4uLik7DQoJaWYgKHJldCkNCgkJZ290byBvdXQ7DQoNCklmIEkgZG9uJ3QgaGF2
ZSAnb3V0JyBsYWJlbCBoZXJlIGluIHRoaXMgcGF0Y2gsIGRvIHlvdSBtZWFuIHNvbWV0aGluZyBi
ZWxvdz8NCg0KCXJldCA9IHRkeF9nZXRfc3lzaW5mbyguLi4pOw0KCWlmIChyZXQpDQoJCXJldHVy
biByZXQ7DQoNCgkvKg0KCSAqIFRPRE86DQoJICogLi4uDQoJICogUmV0dXJuIGVycm9yIGJlZm9y
ZSBhbGwgc3RlcHMgYXJlIGRvbmUuDQoJICovDQoJcmV0dXJuIC1FSU5WQUw7DQoNCj4gDQo+ID4g
IHN0YXRpYyBpbnQgX190ZHhfZW5hYmxlKHZvaWQpDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L3ZpcnQvdm14L3RkeC90ZHguaCBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiA+IGlu
ZGV4IDg4NDM1N2E0MTMzYy4uNmQzMmY2MmU0MTgyIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2
L3ZpcnQvdm14L3RkeC90ZHguaA0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHgu
aA0KPiA+IEBAIC0zLDYgKzMsOCBAQA0KPiA+ICAjZGVmaW5lIF9YODZfVklSVF9URFhfSA0KPiA+
ICANCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9z
dGRkZWYuaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L2NvbXBpbGVyX2F0dHJpYnV0ZXMuaD4NCj4g
PiAgDQo+ID4gIC8qDQo+ID4gICAqIFRoaXMgZmlsZSBjb250YWlucyBib3RoIG1hY3JvcyBhbmQg
ZGF0YSBzdHJ1Y3R1cmVzIGRlZmluZWQgYnkgdGhlIFREWA0KPiA+IEBAIC0xNCw2ICsxNiw4MCBA
QA0KPiA+ICAvKiBNU1IgdG8gcmVwb3J0IEtleUlEIHBhcnRpdGlvbmluZyBiZXR3ZWVuIE1LVE1F
IGFuZCBURFggKi8NCj4gPiAgI2RlZmluZSBNU1JfSUEzMl9NS1RNRV9LRVlJRF9QQVJUSVRJT05J
TkcJMHgwMDAwMDA4Nw0KPiA+ICANCj4gPiArLyoNCj4gPiArICogVERYIG1vZHVsZSBTRUFNQ0FM
TCBsZWFmIGZ1bmN0aW9ucw0KPiA+ICsgKi8NCj4gPiArI2RlZmluZSBUREhfU1lTX0lORk8JCTMy
DQo+ID4gKw0KPiA+ICtzdHJ1Y3QgY21yX2luZm8gew0KPiA+ICsJdTY0CWJhc2U7DQo+ID4gKwl1
NjQJc2l6ZTsNCj4gPiArfSBfX3BhY2tlZDsNCj4gPiArDQo+ID4gKyNkZWZpbmUgTUFYX0NNUlMJ
CQkzMg0KPiA+ICsjZGVmaW5lIENNUl9JTkZPX0FSUkFZX0FMSUdOTUVOVAk1MTINCj4gPiArDQo+
ID4gK3N0cnVjdCBjcHVpZF9jb25maWcgew0KPiA+ICsJdTMyCWxlYWY7DQo+ID4gKwl1MzIJc3Vi
X2xlYWY7DQo+ID4gKwl1MzIJZWF4Ow0KPiA+ICsJdTMyCWVieDsNCj4gPiArCXUzMgllY3g7DQo+
ID4gKwl1MzIJZWR4Ow0KPiA+ICt9IF9fcGFja2VkOw0KPiA+ICsNCj4gPiArI2RlZmluZSBERUNM
QVJFX1BBRERFRF9TVFJVQ1QodHlwZSwgbmFtZSwgc2l6ZSwgYWxpZ25tZW50KQlcDQo+ID4gKwlz
dHJ1Y3QgdHlwZSMjX3BhZGRlZCB7CQkJCQlcDQo+ID4gKwkJdW5pb24gewkJCQkJCVwNCj4gPiAr
CQkJc3RydWN0IHR5cGUgbmFtZTsJCQlcDQo+ID4gKwkJCXU4IHBhZGRpbmdbc2l6ZV07CQkJXA0K
PiA+ICsJCX07CQkJCQkJXA0KPiA+ICsJfSBuYW1lIyNfcGFkZGVkIF9fYWxpZ25lZChhbGlnbm1l
bnQpDQo+ID4gKw0KPiA+ICsjZGVmaW5lIFBBRERFRF9TVFJVQ1QobmFtZSkJKG5hbWUjI19wYWRk
ZWQubmFtZSkNCj4gDQo+IFRoZXNlIGRvbid0IHR1cm4gb3V0IGxvb2tpbmcgX3RoYXRfIG5pY2Ug
aW4gcHJhY3RpY2UsIGJ1dCBJIGRvIHZhc3RseQ0KPiBwcmVmZXIgdGhlbSB0byBoYXJkLWNvZGVk
IHBhZGRpbmcuDQo+IA0KPiA8c25pcD4NCg0KQWdyZWVkLiAgVGhhbmtzIGZvciB5b3VyIG9yaWdp
bmFsIGNvZGUuDQoNCg==
