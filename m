Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBA777D93A
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 05:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241654AbjHPDre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 23:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241649AbjHPDrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 23:47:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2332F211E;
        Tue, 15 Aug 2023 20:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692157624; x=1723693624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Mkv+CJJwS92axv81CJ02VNnAQ+z2nY64KR/+NjyyRqU=;
  b=fVl0BUsqauNurq/rJCMSHhJJWyF5OS25CZtPyWwWweG9rQRp2iJlYGGH
   Nl9JoRXzZVULXnhfj9HA7HUu8hqnZwNdGltyX5lqhvra59winqqOqPgXf
   MzYcm59YEdX2f3Q6w0XDL5qgwF9q+PflT3Bfgm1gDNNFTayPpJBJYCU1Q
   fIjHpGgFEFwYvApc+FYN1RlrrtpExOMwA1Q4FqFNScC+gcZBza7iUGIDq
   mP+yxzyg4Jf+tH8uynbOxvyZOnPlonF0urwGBEeZ4UPDVLlFd8mF1j+J9
   IfGN8njws+Gy8fTJZOyPUnfXdRU7xxw1qc3v7DauMhx946ZjRidNiQsYL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="357409151"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="357409151"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 20:47:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="683892530"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="683892530"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 15 Aug 2023 20:47:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 20:47:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 20:47:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 15 Aug 2023 20:47:02 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 15 Aug 2023 20:47:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtH6vnzztO2Yob2e6CNDS9z8mLKghBPgd+OJqtul2syIS6Pjw0yQQuvKLBnjj8BZu2Ys6hlwwozpJZtawHy84nKfr9GtE2Qj8HeY5hEWx+iyOi1E7J15d0OI9M6iwqP6eBzDp5UzM7UDYoGjbuUim7A1zrlnkOOykAZaUvODn62yznzchZgMy9i0d3Arb04ldR3BPJaLcbBbAOjpVLObTd4o5ZFRclg8j/uWOV0MA7CuBxWIG5hwJ7F4xJzNlPyZRTUaKS0UHzl17SQX4U2Q7xafT6vhJ5CcL5sasiLV6J8nZrF/jk+Z7DqILSAln2/KRCEZOUCh4meQokTTqu3Xtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mkv+CJJwS92axv81CJ02VNnAQ+z2nY64KR/+NjyyRqU=;
 b=YK4zFGbbJek5BEuvXKgveh7HIPZ23t8BdFcJ6+WMZuIrMYiZgdiTXVz+hdTTxky/S5z6TIu6GxJ2nNjM5xqYZW6Ajwzx9kYsrNsWv+RT1dyPGOgXoHrfphund4QOYI+bjRW3ebq97zAzBhmAhUUR7aQDg0NEWB2xIstkOSfDatP7NZDFkddAKpQQitijTik0S6qkBzGjfSqgC//flmruIUU1ZI73NqKGBo3pXFIso726fiJf01ZU07h2fDwsXaDLHRhloINlCJW0aq8MPBhsZj3qM2Z4XwDJPHx13KK51sj/prSwoY45cZNVfGefEmRptYiecalyxpIaJM1EnqBLoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW6PR11MB8390.namprd11.prod.outlook.com (2603:10b6:303:240::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Wed, 16 Aug
 2023 03:46:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 03:46:59 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v10 3/9] KVM: x86: Use KVM-governed feature framework to
 track "LAM enabled"
Thread-Topic: [PATCH v10 3/9] KVM: x86: Use KVM-governed feature framework to
 track "LAM enabled"
Thread-Index: AQHZuk8pOpXGo6/5yUqsQMQAFLsPwq/sc/uA
Date:   Wed, 16 Aug 2023 03:46:59 +0000
Message-ID: <c4faf38ea79e0f4eb3d35d26c018cd2bfe9fe384.camel@intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
         <20230719144131.29052-4-binbin.wu@linux.intel.com>
In-Reply-To: <20230719144131.29052-4-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW6PR11MB8390:EE_
x-ms-office365-filtering-correlation-id: 262b0048-1a38-46d3-17d1-08db9e0b71cb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LyvwC1kRvygVUrOpi1QgaKtpQX0AeXRmPST7/3R7aJeH5ha0b0wsp6CBLfYxNAjjC3yztS7BKbzzmG7lzcLk1fi3cdH6a+0wz2NAeRsPybxAp+4FWLPQjP5I+re4F5mRgQP5jI5YqMNa2O+99I99mF2mnhqiI4C4biUYlpiVWc3mhnDIMPinb9wsInhE19TRaChRWImZO5LRZFDh/6PqLaCLakPFkuS2lJKSpdwgzbq15Y6+lvz5J33jSIV+KzRK3CsTMaPglE5CT2VY32pqeVXZKM9slGycip0gx2Nq1GbYfMLCtmhKuorrPYI2rq2ThRonTmm1tRJObNhSYOKkN1K5kmZfMgPKBEYGUAeRxWWhX8r37WC+km1ZzBi+6c4B/5Dp3VHdwnAwImOQAGxkwI71EpjiYFBUoXJ9Rczw9gnzIuM/CR3Bn2l9vihAP5BiwcB/4jtkoY+bNQ8U2l/pbHKIlr8yPsSXu8xf12Az64ueHlX/E9dD1cgrCrlSSM+/ymiVMVZQz/U6hHzvi20965vWAMDsVKj0y6HEizuARPHBTJcY3iZw+JaxfUc+Xmbw5mL3brl/+u6Cu1tpzEjgCnyTJeKOcbFBh2C9MLs9pEuYKKah1TOBQw6jVwP6N8EU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(396003)(346002)(136003)(1800799009)(451199024)(186009)(71200400001)(64756008)(54906003)(66446008)(76116006)(66476007)(66556008)(66946007)(6512007)(6486002)(6506007)(2906002)(478600001)(26005)(110136005)(91956017)(5660300002)(2616005)(83380400001)(41300700001)(316002)(8936002)(4326008)(8676002)(122000001)(38100700002)(38070700005)(82960400001)(36756003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eERYSFlKQk1kbFBkaTFoVU1IU21CcUhNa0ZlN3RGMjN1Ykw3bGJ3UFRITkVz?=
 =?utf-8?B?dFhtYWdjY3Npci9FYmxJZGxhMDJMNEkzQ0IyZUgvK0x3dTFxUStGblNwTVNh?=
 =?utf-8?B?SytXTTFRd2k5TnNGUXVxMm5FQ2tNY1N5VEwwN3V3T0ZDWkM0cFNpZmhGbm9X?=
 =?utf-8?B?R3dPMW9EM0Z1Ykt6cFcwME82cmdZQnlCQjdtR3AzU1ZId2w0Nis4Q3pPN3BP?=
 =?utf-8?B?VTB4RTBJUE1ZYXlrUC9YNkNmbDMyQ3ZPVklMa1VsWHpoUHVoVjZIazg5WWdV?=
 =?utf-8?B?NFpYK2RJcjN1Yk9LeHlJdGVqYlBWczRFdWk2bDNMRTMwbW5ucHB2b0ZpZ2xQ?=
 =?utf-8?B?U0NiWU85cEc1OFJodTB3b1QxZzh6Vm4wN1BFTkRLY1YyMEF3VVp2YXU0M2x4?=
 =?utf-8?B?ZGNJUUM2eFRGVVBZSWZXdlBQcXZvL0MxUVdRLytaaysyNWd2dEhGRmp5aVFi?=
 =?utf-8?B?WE1IbURPYVhtanZMMjROUlpBREl3cU95WDlTc0JQd08yZVJQMWcwVStqejNL?=
 =?utf-8?B?Z2JZZktuT1ZzbTFYeklyaUIvUW1JeTYwRm5sMWdFUGJhSi9Ebks0WkNHQStn?=
 =?utf-8?B?UWZTMnNiWHBBTnhyYVZzSkNyVjVoQS9XV0V0U2JxV2Rlbkd1bnkxVkZVLzJV?=
 =?utf-8?B?bkxwendCcWFLN0xGcW50cjh2MG5oYTRqbXlNVzYvSlB5QlQ2UWJ3VnBpWThy?=
 =?utf-8?B?Rjh4ZldOa2lOSGw5YUUyOHJkSHBZZG10MS8vZCtzSlB2bEdlR293VndqQU8y?=
 =?utf-8?B?dnByY1huRkhYWWl4cUZGUXd0Wm4wZFhUeVJCZ2ZuVHdZTkdsQ210TElURFVB?=
 =?utf-8?B?WVJMeHFKdXBCU0FDeGRtMUVOMENHZ2YvbjNwaklvU0tZVTFmRm1oc0EyandF?=
 =?utf-8?B?WGJYNzFHdE9mOFZXVk53SE5pbG0rR2xzR2w4b0o1UXJqVWpzT2FFaDRSVHJU?=
 =?utf-8?B?MnI0UnZuN1FtekVJOWxsQ2oxQWpBejd2aFFDMXBCRGtZTXY5RkJVNkxwZkha?=
 =?utf-8?B?cGtBZ0Q1MEJSRGF2ajJWbmM1cXExTkU5WmNRUy9jYXV0Z1FmTThSSEkva0RV?=
 =?utf-8?B?MUZtL1V2bmRsdDRjNmN4NDBkcnhKVzZmb2ZVbHVodXFyZW1jaktRdDN3RUhK?=
 =?utf-8?B?ckdaREU4elcrLzdZNGE3ZE91M21SK0dhYlJjb0pzUjB5WlA3VlBYZVRlelJX?=
 =?utf-8?B?OFZjU1ZQUjZSL0t1WFk1dnF6bmVoQno2ZStRVFdVYlJOUloxYVl4U1hxdGdm?=
 =?utf-8?B?cEZ3VE03am42OTkxUkVkYTVtcUZKMWhkMVRJWHZMU000K0RVd0dINURWUHJO?=
 =?utf-8?B?YlNPU1N4Z096Z1RxVHFJb3BBNmxmUUdsQ2s2ekVtYUZMZVVFRWJzZ3FBTGN3?=
 =?utf-8?B?SG5OTnlrVy9WN0h1SzNiMlVRQnBJbTFlQmtGOXJJTGtIYjIvRGs5TlVlS28y?=
 =?utf-8?B?VGhpK09pZnJjenhOdENOeVpSc0JWOEZlLzh3VStLUTN3NE45VVJrQUJuMitO?=
 =?utf-8?B?bW5ZZS9yQUd6ZEprQXl6S2hLMHhIaGVZSGR4NWpwQUxHWUZDczlndWo0L0pr?=
 =?utf-8?B?WFY2OEVrdmIxcCthMGNNTDRRcVlJcHpjUlJEUmpiMkZkcm14WWU5TEdWV3NK?=
 =?utf-8?B?czhHZDFFU0JtVGpGMEF6aVh5Y0NkSEFDZ0V1ekE5VEVHSE95UmxWd3V3bG5B?=
 =?utf-8?B?NUVmZ3ZjblF5VFh3NWh2T0orYUpYcjlycjBvS1pJNDgwLzJyT1pvcFFsazlt?=
 =?utf-8?B?WiszQzdKc0gzMGFXRmdQR2JTZmtBbjY2U1ltNFZWT0dXTm5XbXVWYk9aOUNZ?=
 =?utf-8?B?L2FBdE5kNGlPc1F6VkhFOFhyRG9mMjVPWlUwOHI0aXJqRjlqOWNKT0NaV0xo?=
 =?utf-8?B?UmhJTDJRWTBoZmhGRjRzc1pkNHMvK01DRzhSQnRIZWg5Y296a2g0cGNncEVU?=
 =?utf-8?B?eVR4YWl2RG56b1ZuWGhzMWZJZENxUGtjRy9aN3JVN2Y0MnJDL2JCSHFYaEhu?=
 =?utf-8?B?SWJ5T1NYWm5MckN1V3cwdGdqWXFOWEsrUThNZ0ZOMmhHR2ZTZ2hUb0l5c3Fn?=
 =?utf-8?B?M2JCTzBHbTlaOEFBcndna2M0UCs3eWI5QWJJMXRkamptazBHT2E0Vmg1Mzdi?=
 =?utf-8?Q?tLbAs77z+fd5qQjQ7kJ2AQ6OX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C78E27C3F4153D438AFD226AAF0C7681@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262b0048-1a38-46d3-17d1-08db9e0b71cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2023 03:46:59.3498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /NHACdnjSX037/CM29UyEkiSMOuhrk6cio40m8XUEEbLSFz7UcE3xKqaR5fY9BWMfst1x1HGtydLmlKdk3mxeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8390
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA3LTE5IGF0IDIyOjQxICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IFVz
ZSB0aGUgZ292ZXJuZWQgZmVhdHVyZSBmcmFtZXdvcmsgdG8gdHJhY2sgaWYgTGluZWFyIEFkZHJl
c3MgTWFza2luZyAoTEFNKQ0KPiBpcyAiZW5hYmxlZCIsIGkuZS4gaWYgTEFNIGNhbiBiZSB1c2Vk
IGJ5IHRoZSBndWVzdC4gU28gdGhhdCBndWVzdF9jYW5fdXNlKCkNCj4gY2FuIGJlIHVzZWQgdG8g
c3VwcG9ydCBMQU0gdmlydHVhbGl6YXRpb24uDQoNCkJldHRlciB0byBleHBsYWluIHdoeSB0byB1
c2UgZ292ZXJuZWQgZmVhdHVyZSBmb3IgTEFNPyAgSXMgaXQgYmVjYXVzZSB0aGVyZSdzDQpob3Qg
cGF0aChzKSBjYWxsaW5nIGd1ZXN0X2NwdWlkX2hhcygpPyAgQW55d2F5IHNvbWUgY29udGV4dCBv
ZiB3aHkgY2FuIGhlbHANCmhlcmUuDQoNCj4gDQo+IExBTSBtb2RpZmllcyB0aGUgY2hlY2tpbmcg
dGhhdCBpcyBhcHBsaWVkIHRvIDY0LWJpdCBsaW5lYXIgYWRkcmVzc2VzLCBhbGxvd2luZw0KPiBz
b2Z0d2FyZSB0byB1c2Ugb2YgdGhlIHVudHJhbnNsYXRlZCBhZGRyZXNzIGJpdHMgZm9yIG1ldGFk
YXRhIGFuZCBtYXNrcyB0aGUNCj4gbWV0YWRhdGEgYml0cyBiZWZvcmUgdXNpbmcgdGhlbSBhcyBs
aW5lYXIgYWRkcmVzc2VzIHRvIGFjY2VzcyBtZW1vcnkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBC
aW5iaW4gV3UgPGJpbmJpbi53dUBsaW51eC5pbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYv
a3ZtL2dvdmVybmVkX2ZlYXR1cmVzLmggfCAyICsrDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5j
ICAgICAgICAgICB8IDMgKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9nb3Zlcm5lZF9mZWF0dXJlcy5oIGIvYXJj
aC94ODYva3ZtL2dvdmVybmVkX2ZlYXR1cmVzLmgNCj4gaW5kZXggNDBjZThlNjYwOGNkLi43MDg1
NzhkNjBlNmYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9nb3Zlcm5lZF9mZWF0dXJlcy5o
DQo+ICsrKyBiL2FyY2gveDg2L2t2bS9nb3Zlcm5lZF9mZWF0dXJlcy5oDQo+IEBAIC01LDUgKzUs
NyBAQCBCVUlMRF9CVUcoKQ0KPiAgDQo+ICAjZGVmaW5lIEtWTV9HT1ZFUk5FRF9YODZfRkVBVFVS
RSh4KSBLVk1fR09WRVJORURfRkVBVFVSRShYODZfRkVBVFVSRV8jI3gpDQo+ICANCj4gK0tWTV9H
T1ZFUk5FRF9YODZfRkVBVFVSRShMQU0pDQo+ICsNCj4gICN1bmRlZiBLVk1fR09WRVJORURfWDg2
X0ZFQVRVUkUNCj4gICN1bmRlZiBLVk1fR09WRVJORURfRkVBVFVSRQ0KPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gaW5kZXgg
MGVjZjRiZTJjNmFmLi5hZTQ3MzAzYzg4ZDcgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92
bXgvdm14LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiBAQCAtNzc4Myw2ICs3
NzgzLDkgQEAgc3RhdGljIHZvaWQgdm14X3ZjcHVfYWZ0ZXJfc2V0X2NwdWlkKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkNCj4gIAkJdm14LT5tc3JfaWEzMl9mZWF0dXJlX2NvbnRyb2xfdmFsaWRfYml0
cyAmPQ0KPiAgCQkJfkZFQVRfQ1RMX1NHWF9MQ19FTkFCTEVEOw0KPiAgDQo+ICsJaWYgKGJvb3Rf
Y3B1X2hhcyhYODZfRkVBVFVSRV9MQU0pKQ0KPiArCQlrdm1fZ292ZXJuZWRfZmVhdHVyZV9jaGVj
a19hbmRfc2V0KHZjcHUsIFg4Nl9GRUFUVVJFX0xBTSk7DQo+ICsNCg0KSWYgeW91IHdhbnQgdG8g
dXNlIGJvb3RfY3B1X2hhcygpLCBpdCdzIGJldHRlciB0byBiZSBkb25lIGF0IHlvdXIgbGFzdCBw
YXRjaCB0bw0Kb25seSBzZXQgdGhlIGNhcCBiaXQgd2hlbiBib290X2NwdV9oYXMoKSBpcyB0cnVl
LCBJIHN1cHBvc2UuDQoNCj4gIAkvKiBSZWZyZXNoICNQRiBpbnRlcmNlcHRpb24gdG8gYWNjb3Vu
dCBmb3IgTUFYUEhZQUREUiBjaGFuZ2VzLiAqLw0KPiAgCXZteF91cGRhdGVfZXhjZXB0aW9uX2Jp
dG1hcCh2Y3B1KTsNCj4gIH0NCg0K
