Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA6E6BDB40
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCPWGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCPWGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:06:17 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0F467833;
        Thu, 16 Mar 2023 15:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679004373; x=1710540373;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jwtCNHxbAG2hdPHAF8rmTS4SZNEkGmRVdhPXGiDF8GU=;
  b=bE9dPuwbzQFqRJtJ1KWmM297fqSsmC7BT9lb/zFPqNh7HP+rLcwvcuzQ
   PXa9iBr50N5E7cHwvmkcEaADuw22Pv3Bmwclfi43TqlnlbcUuYGzKxVqM
   /KOAzafEU3JrN4/Zj0xkM+9xenWEMjaQXTDn+T8a9fHhw1JdM1djvUoaT
   Ic74qo89wx6u0eD3+mue4XuIgQDMwcwEBo4UsK2Uv7XJVAqFMWUeruXWX
   mTaevTxpVDjcty0yoklikcDfJW+TkATVTeQQgBLZN1wEP7ygR1cQdcY+A
   bumw19DEG5YLQRnAARjcGqwj4IUANJhr0fimctxGTtDUTQwzoNmdtjk5t
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="326490263"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="326490263"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 15:06:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="712515045"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="712515045"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 16 Mar 2023 15:06:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 15:06:12 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 15:06:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 15:06:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 15:06:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFQpTGQrPsvUWtOYYL8f04h+dIxKj+IQM7K4Tc0JPpXVBhV4XFPM/Q1dfoKid9PsTSqvjz+TrQ+usCMRydGZslCxJZ21LZDhkgVw0ufiDGv83ULNySpmmGVbTptjPWH37gvH2Lcwqb9C78nsYt6IXlj3IiK0E4ddN39rGMe0OzSQxCX2aePZv5RBSK6X2GS9zPKd3Ak5DUc+HNB7KXAvIhy86lnM1UpoEETQEZbwuo2FOb1AywtZFrauNP4AeNF4QvWZx6BHYGrkacJFhyqgUu/n6gpVFkK4eI6JtMd/Q3jN6MAv9z1l5DUL+kccMgHvODOkpVHybjtyQpS09P7O5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwtCNHxbAG2hdPHAF8rmTS4SZNEkGmRVdhPXGiDF8GU=;
 b=Bf+gweuepswttt9LXckIRB7kX1An8pEWqHEND0WJrFHt4u5+2x8Ve/S70/hbKD8HwEKa7eFIwx60+qpBkWrdnIILPyNGBU+PSrOR+k1b2wA1x0aNNPNBzhChmtwv6wJF0GmBhY8dVom1ZwpTaBTXYYPd4jqhhyAJvavGEX213ZXzYcW/wvlszVBlb3dCUeFPfya2p5rPjobYSw1/t5eXBWc9FUua2xWASLolU1tRPKOkAGF5HeI3Vf6I+2XJMHtuV1Q3GeHdzEJNpB8TnhXpJKmVof9notI9ZHbCySEhLt/Qc556OctNwgeKD2GUAWDkT6wqcENQ3jsOK/bI0JvdoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7409.namprd11.prod.outlook.com (2603:10b6:8:153::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 22:06:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 22:06:03 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 00/16] TDX host kernel support
Thread-Topic: [PATCH v10 00/16] TDX host kernel support
Thread-Index: AQHZUDU4yjGg6zotWUGcKkdhU8wVmq79ZzGAgACfYAA=
Date:   Thu, 16 Mar 2023 22:06:03 +0000
Message-ID: <73d837716d0ecd00b9db42f6fac9b4df55086c88.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <12597014-f920-df75-d516-db871aedbc8c@redhat.com>
In-Reply-To: <12597014-f920-df75-d516-db871aedbc8c@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7409:EE_
x-ms-office365-filtering-correlation-id: 4acf719b-a6e6-45fb-94ff-08db266aa264
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7zuwoWKKxW1rVfcR5NliiVUke1dy51RP1n6gYAsOe29ny3IJ/X8kR4+d4bnWtK226go+jwMz47Xg3VTR9scs5ceQTVmY5JTJeDVFzlejDuKAwYOaXyWRglVcGRxrWGXAcelNPxHcx18XAgF/qElcLB9vaHbV8YeF8770HC+mrISS4Joj9QMe2A9AHJ/JioIpcsOvGRq8D6flmQhDVqGu9VwhLwrokdfQ2aERNUYStxz5S/0uF0Wo3MXXyntjMqMmj6xJ6rDdv40NFGMpIcBjDf44a/OwHXi2K7Hmmb6STOk3MBnFNPT0chcc8rJTDLw7wRrs7Pc1BdM4+0RXwz3NLErjniyiqdG6Qx29q+fLaO1EXdsHMieEAEEFuMhWcD/WggnRq2PfydORF+P6xg6ItdchLHQtAmd/nl577lmnbJ885yIw/rmpT83ecjO4Wf0x0AY3unYnQ0kj6WvEv3NZ4fDg9JhxC55l389DgJl17Olg/lK43QNtf206pqhlzfPwineHr6Jq9UzW7WjBWBbhpounHOkCbM9bAkoWECQdF0YxA/4EbBvJ9yfuhzrb79a2d2U20QlcHJQVCa90ZPjmnBn3mWmU5zVlbS8eJRX51Y/a62+cAYxhIZDwGrsoCdq44vJIQz865ZTOW90Yff5oWQ69HIxo+8BRsYcFZ9tRz9sRM/8M59bQk1tIbUUtL2RB04aMOcA6JhJ0U9Xf7L/6sYrxphVYlVgHAO30xVw0fLs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199018)(38070700005)(86362001)(36756003)(82960400001)(38100700002)(122000001)(8936002)(2906002)(5660300002)(41300700001)(53546011)(6512007)(83380400001)(4326008)(26005)(186003)(6506007)(2616005)(316002)(76116006)(66476007)(66446008)(966005)(110136005)(64756008)(71200400001)(8676002)(66556008)(7416002)(66946007)(478600001)(54906003)(91956017)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b09TZUlReHBaaUlRM2dQNjVyMmNkUWhHRCswTi9wbWV4Y081Yzl0ZDZSTDZ2?=
 =?utf-8?B?aHhGbFd6ZitMaDR5SDBrUkpEWm5pTk9PaWVMZ3kzRTdpUDlPVjZhMW03MFNS?=
 =?utf-8?B?cC9QVEFmcVk0S2RhV1RqT2F1aGZ0TG5JaFBUenBVbCtyRmt4VXJsaUp0allN?=
 =?utf-8?B?MjlHb29jQlpwRmR4UjBUdzkyQjZsMXkwUFljNm80ZTNOOERwZ1grdXNjTnpN?=
 =?utf-8?B?ZlJlSzh5UmdPbXAyZ0lYK3A4OHlmdGZqRmw3a1BENmtPWjhuM2IrWllMb1Bo?=
 =?utf-8?B?WmZFek5VVUYybDVGc014R29hWU5tRWg1R0Q1MHJkU0NvSGtSVlQrR0R2WmpR?=
 =?utf-8?B?TU03Y0VQQUZBbXlLbC9zSDFGSHpWZWpoL09HYzMyRG90WVVKMFlZUmJRQ3A2?=
 =?utf-8?B?U1d6SnJndC9BTDlxNE5qeTVQTzR3NEFseVlPVVZhMmI0RG4ycFYwUG9nZjN5?=
 =?utf-8?B?TmVPVWJWeXhISGpkanowaW9maU5Za290UWJWWnF0dkJzajVIVEh6WSt4WDhL?=
 =?utf-8?B?aENKeE5obUZ2QnF3bVczdmF1cTVKd1Y1MXRSWlNLK29LQXE4K1pIa3ZhMlda?=
 =?utf-8?B?NjdZUS9mZkMwQUtzak1BdHY0WGVZRkdzZWJTQ041amRCYTJIWkRzUUdMaHJs?=
 =?utf-8?B?dk9KaTJvbWlvbUh2Zy9ML3ZOb1NzM1ZzWVQ1VGJ5V29XMHpDWW04aGdHYUFO?=
 =?utf-8?B?bUNBYUxnZlVFVFkvNi9IOFcwWGMzWVdwSUYvbzhTYTgzc3hGUFRxLy82ZjdD?=
 =?utf-8?B?UDBqcEdwY0lmSTREaDZMS1VYWlZuYSt1dnZwbzJjMXBrbTFLdmNkZjV0ak5H?=
 =?utf-8?B?R2JVU3BQTkhmWnFLRU5jOWdQcFlvR0FkTkRpSjNUeEQzbHlLbFNINjNQQWdC?=
 =?utf-8?B?V3o1TkdIVWpydTBKQmZyTWVzZ0h0YmdrMWZEenc5M3JwU0Y0V2wyY3FWcGZO?=
 =?utf-8?B?SU1rT2trbU5yUE94SEM1YlRNangrckozODhVK3JNY3htUm5aY2tERkJsMGll?=
 =?utf-8?B?NXl2cnRsUkx4Z3NRZWgwd3FwYVkzenZKZENyWDlIZzhIV2k4Y2Fqd25EQUFU?=
 =?utf-8?B?TUFSd0JpeDNqM2VQODlXZktTZkRoaW1qd24xbmRCQ1d1M3BrRnNVVytadWJX?=
 =?utf-8?B?aUFXMW9RUk4wb0ZvOWNHRC9laWVRMU9HNDBEcDUxNDJtZVFpQVplQk5OMDM1?=
 =?utf-8?B?cURMRDB4aHNiQmhsRFVaMHBHZWxPY2J6a2RUN3o4d3pVdmpIUVpwdFhNVC9w?=
 =?utf-8?B?QjQ5M2FVeHpIU2hIZ0tiMVpmRlNnaFNrazBEWVQrYW5mODdJUUxheEhrQWdJ?=
 =?utf-8?B?djhKUHFOOEhxZk55TWt5VXYzNDJNZmJTTWQ3Y1dFaUNmZDkwQTRQQ29VUDBo?=
 =?utf-8?B?Vm1QVVRVVzB0WjdxWklydFRZQXp5Ty90NlVxRml6dzRBZGVTbkpZeVpQMk82?=
 =?utf-8?B?MlZTZXU4cGNIZ2hTV3hDUmdQcHNsUGpHTUYvTFpCNlJ4NCtYYjZ0YUNoZjg1?=
 =?utf-8?B?dzcrYVB4ZjQ3M1QvOXBWMEpCLy9sMHlMQS82cEsxYVBCaFAvQkRVOExTRGtO?=
 =?utf-8?B?dnNkaHAyV0lLR3doZTc2L2k5VU82RTMzTGw2VHZxUDkrSjRTWFFqbCt2dmlp?=
 =?utf-8?B?b3MzZVF6Y2VoUU80V2xQekhuNnBRd2JwMjNISjBlOU92MVg3ZFo5Z0UrME9W?=
 =?utf-8?B?ODQyMEJEVFQ1SnpTY2hVNTBOS0dscHNIY1BzdStMaEZCY3dTcDQwMkNvMERI?=
 =?utf-8?B?ZEQ0SFBqaXp1RDNncWozV25FNnlOTGNwdW1UQnRRVUttTkpwVWJXYU12OWRD?=
 =?utf-8?B?Um9zVk1lcjJvUjVhMTdkMjhCbS9TZXp4Mnc1NmhNNkpETk9RbHhUM2kzUEJK?=
 =?utf-8?B?aXZ0ZHpabE1tRzE2Qk9Vd1VrY2Nvb1psYmhLbm9raEhlVlUzelZ3NVYrMG5L?=
 =?utf-8?B?dUQ0Wm9oRkRJTmNUK0pWYTVWQ2JFN3pKMTlCalpMRTR2R01Bb3BjQStuT1h0?=
 =?utf-8?B?T1h3RVczUGZ0a1c3OTZORTEyTUVGKzJNK20zSzhodkx3MTJkT2JONURYRWFr?=
 =?utf-8?B?YU5aejdwSFJ2MXhheUFhZ09zS2NNRFNZcnh1cGpMcEsybHpFR2VVMGQxN0Rh?=
 =?utf-8?B?Q0Z0aGY0bWhQTnozREYvZldBK0ptK1RKNUJ2UzBaekNEWlZFVmFiWHhjOE5j?=
 =?utf-8?B?YlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF42CE0B8402A843A7FF8B1CB57FF1B4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4acf719b-a6e6-45fb-94ff-08db266aa264
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 22:06:03.5321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3aT4YBh+tkSM72Lbs3zEp6nJQHu/JDu8A4Xu3BkgoeQj9g8zW0oq0AoX/nvMNX5ZgzBhb79Hk937IWH0cEYqQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7409
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

T24gVGh1LCAyMDIzLTAzLTE2IGF0IDEzOjM1ICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMDYuMDMuMjMgMTU6MTMsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBJbnRlbCBUcnVz
dGVkIERvbWFpbiBFeHRlbnNpb25zIChURFgpIHByb3RlY3RzIGd1ZXN0IFZNcyBmcm9tIG1hbGlj
aW91cw0KPiA+IGhvc3QgYW5kIGNlcnRhaW4gcGh5c2ljYWwgYXR0YWNrcy4gIFREWCBzcGVjcyBh
cmUgYXZhaWxhYmxlIGluIFsxXS4NCj4gDQo+IEknbSBhZnJhaWQgdGhlcmUgaXMgbm8gWzFdLCBw
cm9iYWJseSBnb3QgbG9zdCB3aGlsZSByZXNlbmRpbmcgOikNCj4gDQo+ID4gDQo+ID4gVGhpcyBz
ZXJpZXMgaXMgdGhlIGluaXRpYWwgc3VwcG9ydCB0byBlbmFibGUgVERYIHdpdGggbWluaW1hbCBj
b2RlIHRvDQo+ID4gYWxsb3cgS1ZNIHRvIGNyZWF0ZSBhbmQgcnVuIFREWCBndWVzdHMuICBLVk0g
c3VwcG9ydCBmb3IgVERYIGlzIGJlaW5nDQo+ID4gZGV2ZWxvcGVkIHNlcGFyYXRlbHlbMl0uICBB
IG5ldyAidXNlcnNwYWNlIGluYWNjZXNzaWJsZSBtZW1mZCIgYXBwcm9hY2gNCj4gPiB0byBzdXBw
b3J0IFREWCBwcml2YXRlIG1lbW9yeSBpcyBhbHNvIGJlaW5nIGRldmVsb3BlZFszXS4gIFRoZSBL
Vk0gd2lsbA0KPiA+IG9ubHkgc3VwcG9ydCB0aGUgbmV3ICJ1c2Vyc3BhY2UgaW5hY2Nlc3NpYmxl
IG1lbWZkIiBhcyBURFggZ3Vlc3QgbWVtb3J5Lg0KPiANCj4gU2FtZSB3aXRoIFsyXS4NCg0KSGkg
RGF2aWQsDQoNClRoYW5rcyBmb3IgeW91ciBmZWVkYmFjayENCg0KT2ggc29ycnksIHllcyBpbmRl
ZWQgdGhleSB3ZXJlIHN0cmlwcGVkIHVuaW50ZW50aW9uYWxseSB3aGVuIEkgd2FzIHVwZGF0aW5n
IHRoZQ0KY292ZXIgbGV0dGVyLiAgSSBhZGRlZCBoZXJlIGZvciB5b3VyIHJlZmVyZW5jZToNCg0K
WzFdOiBURFggc3BlY3MNCmh0dHBzOi8vd3d3LmludGVsLmNvbS9jb250ZW50L3d3dy91cy9lbi9k
ZXZlbG9wZXIvYXJ0aWNsZXMvdGVjaG5pY2FsL2ludGVsLXRydXN0LWRvbWFpbi1leHRlbnNpb25z
Lmh0bWwNCg0KMl06IEtWTSBURFggc3VwcG9ydA0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGtt
bC9jb3Zlci4xNjc4NjQzMDUxLmdpdC5pc2FrdS55YW1haGF0YUBpbnRlbC5jb20vDQoNClszXTog
S1ZNOiBtbTogZmQtYmFzZWQgYXBwcm9hY2ggZm9yIHN1cHBvcnRpbmcgS1ZNDQpodHRwczovL2xv
cmUua2VybmVsLm9yZy9sa21sLzIwMjIxMjAyMDYxMzQ3LjEwNzAyNDYtMS1jaGFvLnAucGVuZ0Bs
aW51eC5pbnRlbC5jb20vVC8NCg0KPiANCj4gPiANCj4gPiBUaGlzIHNlcmllcyBkb2Vzbid0IGFp
bSB0byBzdXBwb3J0IGFsbCBmdW5jdGlvbmFsaXRpZXMsIGFuZCBkb2Vzbid0IGFpbQ0KPiA+IHRv
IHJlc29sdmUgYWxsIHRoaW5ncyBwZXJmZWN0bHkuICBGb3IgZXhhbXBsZSwgbWVtb3J5IGhvdHBs
dWcgaXMgaGFuZGxlZA0KPiA+IGluIHNpbXBsZSB3YXkgKHBsZWFzZSByZWZlciB0byAiS2VybmVs
IHBvbGljeSBvbiBURFggbWVtb3J5IiBhbmQgIk1lbW9yeQ0KPiA+IGhvdHBsdWciIHNlY3Rpb25z
IGJlbG93KS4NCj4gPiANCj4gPiAoRm9yIG1lbW9yeSBob3RwbHVnLCBzb3JyeSBmb3IgYnJvYWRj
YXN0aW5nIHdpZGVseSBidXQgSSBjYydlZCB0aGUNCj4gPiBsaW51eC1tbUBrdmFjay5vcmcgZm9s
bG93aW5nIEtpcmlsbCdzIHN1Z2dlc3Rpb24gc28gTU0gZXhwZXJ0cyBjYW4gYWxzbw0KPiA+IGhl
bHAgdG8gcHJvdmlkZSBjb21tZW50cy4pDQo+ID4gDQo+ID4gQW5kIFREWCBtb2R1bGUgbWV0YWRh
dGEgYWxsb2NhdGlvbiBqdXN0IHVzZXMgYWxsb2NfY29udGlnX3BhZ2VzKCkgdG8NCj4gPiBhbGxv
Y2F0ZSBsYXJnZSBjaHVuayBhdCBydW50aW1lLCB0aHVzIGl0IGNhbiBmYWlsLiAgSXQgaXMgaW1w
ZXJmZWN0IG5vdw0KPiA+IGJ1dCBfd2lsbF8gYmUgaW1wcm92ZWQgaW4gdGhlIGZ1dHVyZS4NCj4g
DQo+IEdvb2QgZW5vdWdoIGZvciBub3cgSSBndWVzcy4gUmVzZXJ2aW5nIGl0IHZpYSBtZW1ibG9j
ayBtaWdodCBiZSBiZXR0ZXIsIA0KPiB0aG91Z2guDQo+IA0KPiA+IA0KPiA+IEFsc28sIHRoZSBw
YXRjaCB0byBhZGQgdGhlIG5ldyBrZXJuZWwgY29tbGluZSB0ZHg9ImZvcmNlIiBpc24ndCBpbmNs
dWRlZA0KPiA+IGluIHRoaXMgaW5pdGlhbCB2ZXJzaW9uLCBhcyBEYXZlIHN1Z2dlc3RlZCBpdCBp
c24ndCBtYW5kYXRvcnkuICBCdXQgSQ0KPiA+IF93aWxsXyBhZGQgb25lIG9uY2UgdGhpcyBpbml0
aWFsIHZlcnNpb24gZ2V0cyBtZXJnZWQuDQo+IA0KPiBXaGF0IHdvdWxkIGJlIHRoZSBtYWluIHB1
cnBvc2Ugb2YgdGhhdCBvcHRpb24/DQoNCkluaXRpYWxpemluZyB0aGUgVERYIG1vZHVsZSBuZWVk
cyB0byBjb25zdW1lIG5vbi10cml2aWFsIG1lbW9yeSB0aGF0IGlzIGdpdmVuIHRvDQp0aGUgVERY
IG1vZHVsZSBhcyBtZXRhZGF0YSB0byB0cmFjayBwYWdlIHN0YXR1cywgZXRjLiAgQ3VycmVudGx5
LCBLVk0NCm1haW50YWluZXJzIHdhbnQgdG8gaW5pdGlhbGl6ZSBURFggZHVyaW5nIEtWTSBtb2R1
bGUgbG9hZGluZyB0aW1lLiAgVGhpcw0KYmFzaWNhbGx5IG1lYW5zIFREWCB3aWxsIGdldCBlbmFi
bGVkIGJ5IGRlZmF1bHQgZXZlbiBwZW9wbGUgZG9uJ3Qgd2FudCB0byB1c2UNCml0LiAgU28gUGV0
ZXIgd2FudGVkIHRvIGFkZCBhIGtlcm5lbCBib290IHBhcmFtZXRlciB0byBkaXNhYmxlIFREWCBm
b3IgYWxsLg0KDQo+IA0KPiA+IA0KPiA+IEFsbCBvdGhlciBvcHRpbWl6YXRpb25zIHdpbGwgYmUg
cG9zdGVkIGFzIGZvbGxvdy11cCBvbmNlIHRoaXMgaW5pdGlhbA0KPiA+IFREWCBzdXBwb3J0IGlz
IHVwc3RyZWFtZWQuDQo+ID4gDQo+IA0KPiANCj4gWy4uLl0NCj4gDQo+ID4gPT0gQmFja2dyb3Vu
ZCA9PQ0KPiA+IA0KPiA+IFREWCBpbnRyb2R1Y2VzIGEgbmV3IENQVSBtb2RlIGNhbGxlZCBTZWN1
cmUgQXJiaXRyYXRpb24gTW9kZSAoU0VBTSkNCj4gPiBhbmQgYSBuZXcgaXNvbGF0ZWQgcmFuZ2Ug
cG9pbnRlZCBieSB0aGUgU0VBTSBSYW5nZXIgUmVnaXN0ZXIgKFNFQU1SUikuDQo+ID4gQSBDUFUt
YXR0ZXN0ZWQgc29mdHdhcmUgbW9kdWxlIGNhbGxlZCAndGhlIFREWCBtb2R1bGUnIHJ1bnMgaW4g
dGhlIG5ldw0KPiA+IGlzb2xhdGVkIHJlZ2lvbiBhcyBhIHRydXN0ZWQgaHlwZXJ2aXNvciB0byBj
cmVhdGUvcnVuIHByb3RlY3RlZCBWTXMuDQo+ID4gDQo+ID4gVERYIGFsc28gbGV2ZXJhZ2VzIElu
dGVsIE11bHRpLUtleSBUb3RhbCBNZW1vcnkgRW5jcnlwdGlvbiAoTUtUTUUpIHRvDQo+ID4gcHJv
dmlkZSBjcnlwdG8tcHJvdGVjdGlvbiB0byB0aGUgVk1zLiAgVERYIHJlc2VydmVzIHBhcnQgb2Yg
TUtUTUUgS2V5SURzDQo+ID4gYXMgVERYIHByaXZhdGUgS2V5SURzLCB3aGljaCBhcmUgb25seSBh
Y2Nlc3NpYmxlIHdpdGhpbiB0aGUgU0VBTSBtb2RlLg0KPiA+IA0KPiA+IFREWCBpcyBkaWZmZXJl
bnQgZnJvbSBBTUQgU0VWL1NFVi1FUy9TRVYtU05QLCB3aGljaCB1c2VzIGEgZGVkaWNhdGVkDQo+
ID4gc2VjdXJlIHByb2Nlc3NvciB0byBwcm92aWRlIGNyeXB0by1wcm90ZWN0aW9uLiAgVGhlIGZp
cm13YXJlIHJ1bnMgb24gdGhlDQo+ID4gc2VjdXJlIHByb2Nlc3NvciBhY3RzIGEgc2ltaWxhciBy
b2xlIGFzIHRoZSBURFggbW9kdWxlLg0KPiA+IA0KPiA+IFRoZSBob3N0IGtlcm5lbCBjb21tdW5p
Y2F0ZXMgd2l0aCBTRUFNIHNvZnR3YXJlIHZpYSBhIG5ldyBTRUFNQ0FMTA0KPiA+IGluc3RydWN0
aW9uLiAgVGhpcyBpcyBjb25jZXB0dWFsbHkgc2ltaWxhciB0byBhIGd1ZXN0LT5ob3N0IGh5cGVy
Y2FsbCwNCj4gPiBleGNlcHQgaXQgaXMgbWFkZSBmcm9tIHRoZSBob3N0IHRvIFNFQU0gc29mdHdh
cmUgaW5zdGVhZC4NCj4gPiANCj4gPiBCZWZvcmUgYmVpbmcgYWJsZSB0byBtYW5hZ2UgVEQgZ3Vl
c3RzLCB0aGUgVERYIG1vZHVsZSBtdXN0IGJlIGxvYWRlZA0KPiA+IGFuZCBwcm9wZXJseSBpbml0
aWFsaXplZC4gIFRoaXMgc2VyaWVzIGFzc3VtZXMgdGhlIFREWCBtb2R1bGUgaXMgbG9hZGVkDQo+
ID4gYnkgQklPUyBiZWZvcmUgdGhlIGtlcm5lbCBib290cy4NCj4gPiANCj4gPiBIb3cgdG8gaW5p
dGlhbGl6ZSB0aGUgVERYIG1vZHVsZSBpcyBkZXNjcmliZWQgYXQgVERYIG1vZHVsZSAxLjANCj4g
PiBzcGVjaWZpY2F0aW9uLCBjaGFwdGVyICIxMy5JbnRlbCBURFggTW9kdWxlIExpZmVjeWNsZTog
RW51bWVyYXRpb24sDQo+ID4gSW5pdGlhbGl6YXRpb24gYW5kIFNodXRkb3duIi4NCj4gPiANCj4g
PiA9PSBEZXNpZ24gQ29uc2lkZXJhdGlvbnMgPT0NCj4gPiANCj4gPiAxLiBJbml0aWFsaXplIHRo
ZSBURFggbW9kdWxlIGF0IHJ1bnRpbWUNCj4gPiANCj4gPiBUaGVyZSBhcmUgYmFzaWNhbGx5IHR3
byB3YXlzIHRoZSBURFggbW9kdWxlIGNvdWxkIGJlIGluaXRpYWxpemVkOiBlaXRoZXINCj4gPiBp
biBlYXJseSBib290LCBvciBhdCBydW50aW1lIGJlZm9yZSB0aGUgZmlyc3QgVERYIGd1ZXN0IGlz
IHJ1bi4gIFRoaXMNCj4gPiBzZXJpZXMgaW1wbGVtZW50cyB0aGUgcnVudGltZSBpbml0aWFsaXph
dGlvbi4NCj4gPiANCj4gPiBUaGlzIHNlcmllcyBhZGRzIGEgZnVuY3Rpb24gdGR4X2VuYWJsZSgp
IHRvIGFsbG93IHRoZSBjYWxsZXIgdG8gaW5pdGlhbGl6ZQ0KPiA+IFREWCBhdCBydW50aW1lOg0K
PiA+IA0KPiA+ICAgICAgICAgIGlmICh0ZHhfZW5hYmxlKCkpDQo+ID4gICAgICAgICAgICAgICAg
ICBnb3RvIG5vX3RkeDsNCj4gPiAJLy8gVERYIGlzIHJlYWR5IHRvIGNyZWF0ZSBURCBndWVzdHMu
DQo+ID4gDQo+ID4gVGhpcyBhcHByb2FjaCBoYXMgYmVsb3cgcHJvczoNCj4gPiANCj4gPiAxKSBJ
bml0aWFsaXppbmcgdGhlIFREWCBtb2R1bGUgcmVxdWlyZXMgdG8gcmVzZXJ2ZSB+MS8yNTZ0aCBz
eXN0ZW0gUkFNIGFzDQo+ID4gbWV0YWRhdGEuICBFbmFibGluZyBURFggb24gZGVtYW5kIGFsbG93
cyBvbmx5IHRvIGNvbnN1bWUgdGhpcyBtZW1vcnkgd2hlbg0KPiA+IFREWCBpcyB0cnVseSBuZWVk
ZWQgKGkuZS4gd2hlbiBLVk0gd2FudHMgdG8gY3JlYXRlIFREIGd1ZXN0cykuDQo+IA0KPiBMZXQn
cyBiZSBjbGVhcjogbm9ib2R5IGlzIGdvaW5nIHRvIHJ1biBlbmNyeXB0ZWQgVk1zICJvdXQgb2Yg
dGhlIGJsdWUiLg0KPiANCj4gWW91IGNhbiBleHBlY3QgYSBjZXJ0YWluIGh5cGVydmlzb3Igc2V0
dXAgdG8gYmUgcmVxdWlyZWQsIGZvciBleGFtcGxlLCANCj4gZW5hYmxpbmcgaXQgb24gdGhlIGNt
ZGxpbmUgYW5kIHRoZW4gYWxsb2NhdGluZyB0aGF0IG1ldGFkYXRhIGZyb20gDQo+IG1lbWJsb2Nr
IGR1cmluZyBib290Lg0KDQpZZXMgS1ZNIHdpbGwgYWxzbyBoYXZlIGEgcGFyYW1ldGVyIHRvIHNw
ZWNpZmljYWxseSBlbmFibGUgVERYLg0KDQo+IA0KPiBJSVJDIHMzOTB4IGhhbmRsZXMgaXQgc2lt
aWxhcmx5IHdpdGggcHJvdGVjdGVkIFZNcyBhbmQgcmVxdWlyZWQgbWV0YWRhdGEuDQo+IA0KPiA+
IA0KPiA+IDIpIFNFQU1DQUxMIHJlcXVpcmVzIENQVSBiZWluZyBhbHJlYWR5IGluIFZNWCBvcGVy
YXRpb24gKFZNWE9OIGhhcyBiZWVuDQo+ID4gZG9uZSkuICBTbyBmYXIsIEtWTSBpcyB0aGUgb25s
eSB1c2VyIG9mIFREWCwgYW5kIGl0IGFscmVhZHkgaGFuZGxlcyBWTVhPTi4NCj4gPiBMZXR0aW5n
IEtWTSB0byBpbml0aWFsaXplIFREWCBhdm9pZHMgaGFuZGxpbmcgVk1YT04gaW4gdGhlIGNvcmUg
a2VybmVsLg0KPiA+IA0KPiA+IDMpIEl0IGlzIG1vcmUgZmxleGlibGUgdG8gc3VwcG9ydCAiVERY
IG1vZHVsZSBydW50aW1lIHVwZGF0ZSIgKG5vdCBpbg0KPiA+IHRoaXMgc2VyaWVzKS4gIEFmdGVy
IHVwZGF0aW5nIHRvIHRoZSBuZXcgbW9kdWxlIGF0IHJ1bnRpbWUsIGtlcm5lbCBuZWVkcw0KPiA+
IHRvIGdvIHRocm91Z2ggdGhlIGluaXRpYWxpemF0aW9uIHByb2Nlc3MgYWdhaW4uDQo+ID4gDQo+
ID4gMi4gQ1BVIGhvdHBsdWcNCj4gPiANCj4gPiBURFggbW9kdWxlIHJlcXVpcmVzIHRoZSBwZXIt
Y3B1IGluaXRpYWxpemF0aW9uIFNFQU1DQUxMIChUREguU1lTLkxQLklOSVQpDQo+ID4gbXVzdCBi
ZSBkb25lIG9uIG9uZSBjcHUgYmVmb3JlIGFueSBvdGhlciBTRUFNQ0FMTHMgY2FuIGJlIG1hZGUg
b24gdGhhdA0KPiA+IGNwdSwgaW5jbHVkaW5nIHRob3NlIGludm9sdmVkIGR1cmluZyB0aGUgbW9k
dWxlIGluaXRpYWxpemF0aW9uLg0KPiA+IA0KPiA+IFRoZSBrZXJuZWwgcHJvdmlkZXMgdGR4X2Nw
dV9lbmFibGUoKSB0byBsZXQgdGhlIHVzZXIgb2YgVERYIHRvIGRvIGl0IHdoZW4NCj4gPiB0aGUg
dXNlciB3YW50cyB0byB1c2UgYSBuZXcgY3B1IGZvciBURFggdGFzay4NCj4gPiANCj4gPiBURFgg
ZG9lc24ndCBzdXBwb3J0IHBoeXNpY2FsIChBQ1BJKSBDUFUgaG90cGx1Zy4gIEEgbm9uLWJ1Z2d5
IEJJT1Mgc2hvdWxkDQo+ID4gbmV2ZXIgc3VwcG9ydCBob3RwbHVnZ2FibGUgQ1BVIGRldmljZWUg
YW5kL29yIGRlbGl2ZXIgQUNQSSBDUFUgaG90cGx1Zw0KPiA+IGV2ZW50IHRvIHRoZSBrZXJuZWwu
ICBUaGlzIHNlcmllcyBkb2Vzbid0IGhhbmRsZSBwaHlzaWNhbCAoQUNQSSkgQ1BVDQo+ID4gaG90
cGx1ZyBhdCBhbGwgYnV0IGRlcGVuZHMgb24gdGhlIEJJT1MgdG8gYmVoYXZlIGNvcnJlY3RseS4N
Cj4gPiANCj4gPiBOb3RlIFREWCB3b3JrcyB3aXRoIENQVSBsb2dpY2FsIG9ubGluZS9vZmZsaW5l
LCB0aHVzIHRoaXMgc2VyaWVzIHN0aWxsDQo+ID4gYWxsb3dzIHRvIGRvIGxvZ2ljYWwgQ1BVIG9u
bGluZS9vZmZsaW5lLg0KPiA+IA0KPiA+IDMuIEtlcm5lbCBwb2xpY3kgb24gVERYIG1lbW9yeQ0K
PiA+IA0KPiA+IFRoZSBURFggbW9kdWxlIHJlcG9ydHMgYSBsaXN0IG9mICJDb252ZXJ0aWJsZSBN
ZW1vcnkgUmVnaW9uIiAoQ01SKSB0bw0KPiA+IGluZGljYXRlIHdoaWNoIG1lbW9yeSByZWdpb25z
IGFyZSBURFgtY2FwYWJsZS4gIFRoZSBURFggYXJjaGl0ZWN0dXJlDQo+ID4gYWxsb3dzIHRoZSBW
TU0gdG8gZGVzaWduYXRlIHNwZWNpZmljIGNvbnZlcnRpYmxlIG1lbW9yeSByZWdpb25zIGFzIHVz
YWJsZQ0KPiA+IGZvciBURFggcHJpdmF0ZSBtZW1vcnkuDQo+ID4gDQo+ID4gVGhlIGluaXRpYWwg
c3VwcG9ydCBvZiBURFggZ3Vlc3RzIHdpbGwgb25seSBhbGxvY2F0ZSBURFggcHJpdmF0ZSBtZW1v
cnkNCj4gPiBmcm9tIHRoZSBnbG9iYWwgcGFnZSBhbGxvY2F0b3IuICBUaGlzIHNlcmllcyBjaG9v
c2VzIHRvIGRlc2lnbmF0ZSBfYWxsXw0KPiA+IHN5c3RlbSBSQU0gaW4gdGhlIGNvcmUtbW0gYXQg
dGhlIHRpbWUgb2YgaW5pdGlhbGl6aW5nIFREWCBtb2R1bGUgYXMgVERYDQo+ID4gbWVtb3J5IHRv
IGd1YXJhbnRlZSBhbGwgcGFnZXMgaW4gdGhlIHBhZ2UgYWxsb2NhdG9yIGFyZSBURFggcGFnZXMu
DQo+ID4gDQo+ID4gNC4gTWVtb3J5IEhvdHBsdWcNCj4gPiANCj4gPiBBZnRlciB0aGUga2VybmVs
IHBhc3NlcyBhbGwgIlREWC11c2FibGUiIG1lbW9yeSByZWdpb25zIHRvIHRoZSBURFgNCj4gPiBt
b2R1bGUsIHRoZSBzZXQgb2YgIlREWC11c2FibGUiIG1lbW9yeSByZWdpb25zIGFyZSBmaXhlZCBk
dXJpbmcgbW9kdWxlJ3MNCj4gPiBydW50aW1lLiAgTm8gbW9yZSAiVERYLXVzYWJsZSIgbWVtb3J5
IGNhbiBiZSBhZGRlZCB0byB0aGUgVERYIG1vZHVsZQ0KPiA+IGFmdGVyIHRoYXQuDQo+ID4gDQo+
ID4gVG8gYWNoaWV2ZSBhYm92ZSAidG8gZ3VhcmFudGVlIGFsbCBwYWdlcyBpbiB0aGUgcGFnZSBh
bGxvY2F0b3IgYXJlIFREWA0KPiA+IHBhZ2VzIiwgdGhpcyBzZXJpZXMgc2ltcGx5IGNob29zZSB0
byByZWplY3QgYW55IG5vbi1URFgtdXNhYmxlIG1lbW9yeSBpbg0KPiA+IG1lbW9yeSBob3RwbHVn
Lg0KPiA+IA0KPiA+IFRoaXMgX3dpbGxfIGJlIGVuaGFuY2VkIGluIHRoZSBmdXR1cmUgYWZ0ZXIg
Zmlyc3Qgc3VibWlzc2lvbi4NCj4gDQo+IFdoYXQncyB0aGUgcHJpbWFyeSByZWFzb24gdG8gZW5o
YW5jZSB0aGF0PyBBcmUgdGhlcmUgcmVhc29uYWJsZSB1c2UgDQo+IGNhc2VzPyBXaHkgd291bGQg
YmUgZXhwZWN0IHRvIGhhdmUgb3RoZXIgKCFURFggY2FwYWJsZSkgbWVtb3J5IGluIHRoZSANCj4g
c3lzdGVtPw0KDQpCYXNpY2FsbHkgS2lyaWxsIHByZWZlcnJlZCB0aGlzLiAgUGxlYXNlIHNlZSBi
ZWxvdyBwYXJhZ3JhcGggaW4gbXkgb3JpZ2luYWwNCmNvdmVyIGxldHRlci4NCg0KQnV0IHRoZXJl
IGhhcyBiZWVuIG5vIGNvbnNlbnN1cyBvbiB3aGV0aGVyIHdlIHNob3VsZCBkbyBpdCBlc3BlY2lh
bGx5IHdpdGgNCmNvbW11bml0eS4gIEkgcHJvYmFibHkgc2hvdWxkIG5vdCB1c2UgdGhlIHdvcmQg
X3dpbGxfIGhlcmUgKGFsc28ga2luZGEgZm9yZ290IHRvDQprZWVwIHRoaXMgc2VjdGlvbiB1cCB0
byBkYXRlKS4NCg0KSSB0aGluayBJJ2xsIGp1c3QgcmVtb3ZlIHRoaXMgYW5kIGJlbG93IHBhcmFn
cmFwaCBlbnRpcmVseSwgb3IgSSB3aWxsIGFkanVzdCB0aGUNCndvcmRzIHRvIHNheSBpdCBwZXJo
YXBzIGlzIGFuIGVuaGFuY2VtZW50IHdlIGNhbiBkbyBpbiB0aGUgZnV0dXJlLg0KDQo+IA0KPiA+
IA0KPiA+IEEgYmV0dGVyIHNvbHV0aW9uLCBzdWdnZXN0ZWQgYnkgS2lyaWxsLCBpcyBzaW1pbGFy
IHRvIHRoZSBwZXItbm9kZSBtZW1vcnkNCj4gPiBlbmNyeXB0aW9uIGZsYWcgaW4gdGhpcyBzZXJp
ZXMgWzRdLiAgV2UgY2FuIGFsbG93IGFkZGluZy9vbmxpbmluZyBub24tVERYDQo+ID4gbWVtb3J5
IHRvIHNlcGFyYXRlIE5VTUEgbm9kZXMgc28gdGhhdCBib3RoICJURFgtY2FwYWJsZSIgbm9kZXMg
YW5kDQo+ID4gIlREWC1jYXBhYmxlIiBub2RlcyBjYW4gY28tZXhpc3QuICBUaGUgbmV3IFREWCBm
bGFnIGNhbiBiZSBleHBvc2VkIHRvDQo+ID4gdXNlcnNwYWNlIHZpYSAvc3lzZnMgc28gdXNlcnNw
YWNlIGNhbiBiaW5kIFREWCBndWVzdHMgdG8gIlREWC1jYXBhYmxlIg0KPiA+IG5vZGVzIHZpYSBO
VU1BIEFCSXMuDQoNCkFsc28gWzRdIHdhcyBzdHJpcHBlZDoNCg0KWzRdOiBwZXItbm9kZSBtZW1v
cnkgZW5jcnlwdGlvbiBmbGFnDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1tbS8yMDIy
MTAwNzE1NTMyMy51ZTRjZHRoa2lsZnk0bGJkQGJveC5zaHV0ZW1vdi5uYW1lL3QvDQoNCj4gPiAN
Cj4gPiA1LiBQaHlzaWNhbCBNZW1vcnkgSG90cGx1Zw0KPiA+IA0KPiA+IE5vdGUgVERYIGFzc3Vt
ZXMgY29udmVydGlibGUgbWVtb3J5IGlzIGFsd2F5cyBwaHlzaWNhbGx5IHByZXNlbnQgZHVyaW5n
DQo+ID4gbWFjaGluZSdzIHJ1bnRpbWUuICBBIG5vbi1idWdneSBCSU9TIHNob3VsZCBuZXZlciBz
dXBwb3J0IGhvdC1yZW1vdmFsIG9mDQo+ID4gYW55IGNvbnZlcnRpYmxlIG1lbW9yeS4gIFRoaXMg
aW1wbGVtZW50YXRpb24gZG9lc24ndCBoYW5kbGUgQUNQSSBtZW1vcnkNCj4gPiByZW1vdmFsIGJ1
dCBkZXBlbmRzIG9uIHRoZSBCSU9TIHRvIGJlaGF2ZSBjb3JyZWN0bHkuDQo+IA0KPiAtLSANCj4g
VGhhbmtzLA0KPiANCj4gRGF2aWQgLyBkaGlsZGVuYg0KPiANCg0K
