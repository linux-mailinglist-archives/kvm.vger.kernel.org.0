Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C337E627558
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 05:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbiKNEjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 23:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbiKNEjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 23:39:51 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA68014D0A;
        Sun, 13 Nov 2022 20:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668400790; x=1699936790;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3fKifVeqXiRRPKBA8SwJHQHxgceE/wxaA4d3CApHW18=;
  b=UpPZik7J76clqiS1w+qhWw4qxp/o3M3nO6ru+CQ+y7Sm41wnzPByi8XO
   pbGTgp3BEuIzYfP4oMU+668wFFztS1wYxd6UQgNkZOwPq4AhhrpmDCEUH
   LU4lbJLTpGdD6ADTEFQyKt/30scpbjNerFQpX2byln6qgoVMNGGxe6Xem
   vOmsFVSbvqYq+gf1woVmYg4b1ZPPmpqQrqiDJ4gi5Dv9AZhTzHKc+3KX4
   +UmWfHmMCWLx78lC0Zp22yc0f6wOOJakDkQd7HiCdsOusHoBU0TbbEGih
   jS5My+IoH94+gfUiN1KBA7ScoCEqebCzMYftrixv9q6BuMN6rVCcSBIJz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="313685147"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="313685147"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 20:39:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="780777743"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="780777743"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 13 Nov 2022 20:39:50 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 13 Nov 2022 20:39:49 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 13 Nov 2022 20:39:49 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 13 Nov 2022 20:39:49 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 13 Nov 2022 20:39:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxfuX7do9awEF1BkDdg5MbmSgMYB8hVyTTdTuE3H9Qr0Gwmy3ARnrT0XQ9ySn5gVw67K/LEkYoRTnNO8Fb/6+16KXAEf6jFEG53w1/J7wsFH6x3KbbC9uGD5KHE/9mnCmrT6Knv3NlEaDfnWo3gI77g76Lv8A9DXNh854Q3YuHr4c1z/tATbHgWko/DZlVJTq9YYhu1JbIT3QWR+Mr/LRzXgaber8od/ZEYAIGRVdM7Ucu1WBojh8FwYYeeI1uMaNwWB9G3CSmJ2K00PskEHZIekvTIaVeSWUtphwbvEAEvJmkia68R0FE5U6RicRqA/xaXz9/DJKKBGppwwQhAmgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3fKifVeqXiRRPKBA8SwJHQHxgceE/wxaA4d3CApHW18=;
 b=WU5IdcCuMZejuYqAb8ygLifBySWvkxg2wJwMOrYlC4tMj+nLW7CHJo1pvI5G6SAlYBoQ+MBU/sDJK7z6p+GpDT/UWHOvHWNSIwQgRZV6ZysKk28kWvEuA0v5GtfLAQEk24H9kQelgKnFUr/teoMwBa0e5ibF0zPXMIcKqbFtXvQrVHb0jNScjXlUzYr8W82kSHJQkRXlYzS2p3ndafW4KvCl0VcemGC+4evV4Yd47EDXNzMUEQJaImShN72AWWWnrAZ2YNqpOQCFeBKYVOLN427a0kjnKy+LYz6V5k5GjYzMIqsS1t7YWe149G9lom6aNa4Dj75BPUcLTIAVdKzVxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by SA0PR11MB4656.namprd11.prod.outlook.com
 (2603:10b6:806:96::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 04:39:40 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.017; Mon, 14 Nov
 2022 04:39:40 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9M9YytlyKV7ob0GK/oJbeBhPY6433PwAgACmfxCAAO8aAIAAL0qAgAAENoCAAAgUAIAAGnuAgAA1qHCAACERAIADuBAA
Date:   Mon, 14 Nov 2022 04:39:40 +0000
Message-ID: <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
In-Reply-To: <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|SA0PR11MB4656:EE_
x-ms-office365-filtering-correlation-id: f0539792-4afd-42d8-29b3-08dac5fa3e4d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3itzW8hNBYFfY67kOL1igp4wTpfS+hGFwJzjXbX6qntEUCPDoHVL8YhqFUK3b1b6SeDau66G7oHwFy95esy5kr57OMmOV8uXgAcUTRFKOjzBO3k5/0hkEXGouPqXzJ9nPmj8NT8RMHSDpFGDcANXy3Wq6NnVaTtSpLssvriKNQhuUCrpTRM6me4Kki9cVLWbgGdCK9T/Z2t05az+FHaN30C8MTwDjILGVBHHax4XL5EVyLChpi0ny/R6KvX4c5wbP1JXW/9gFXkLj5z+ysOxZsyF2Qt6bB2u5jCR6KWgn2Q6tp8c8oQwUGs5bPhsAb3DXZ94EWbDwYH9jQlpsYmblxhjhA0iUtfLsZ0d+2ArotZ8TSYr2lxeao5f6bfcnwi0e7NidsqbX8uCOLL1s+Jb9kNh8yxcSjxwC7epxuEGa9DWrLg49Xbbd30ZT1Fhx4MtJ4CZvtgq3ZBZrKWi33gGH1m7XaBcCj8wNSYJLv/DRAevVDl6XU/A1EwidsSMG5ly0JG5iHf2BHKCjfUuhyB6NYscbBl7tWB6o2Up1170MLcbprnAvPfJtBVcJHJUpkIaRAct1/FyMyIVSW75ky5O7SKP3udcmvWOs4y2JG9TRrKqjqHxcD/qTF4I8Cet6Yditq861acrAjyFTC1h5HDBu3LlZ/ayGbwKu9DMSxOJ8Uyn56jPZjh823QmEND1F6Q8CABPXYPjYvwxTGoGu9gqnqXGkAg0+e1kQt9KutOoiPSGlnA/C3QSPDka/awVNZfLtmsplwvdlZKWF4WeJ3lM8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199015)(33656002)(38070700005)(71200400001)(54906003)(7696005)(6916009)(478600001)(6506007)(316002)(26005)(9686003)(8936002)(66946007)(66556008)(66446008)(76116006)(66476007)(64756008)(8676002)(4326008)(52536014)(41300700001)(7416002)(186003)(5660300002)(55016003)(83380400001)(2906002)(122000001)(38100700002)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czVQaUtrZlNsVXVjOG5qaXE5ZG9LYTI5N3BFSXBwd25aajU5d1FQbU51WVR6?=
 =?utf-8?B?cHA0anFQYmpRZjZZVytVc0wxbUJzTXM1OHNiODVOMDhScVZLZkcveWlpc1FQ?=
 =?utf-8?B?VW1FRlBtZEhnTlZ2eTFtdHdqSE5lSUVuLytIOTFya1VKNTd5UnRtVHFjS1Vm?=
 =?utf-8?B?dzdyZ2JxejFSTDBIcDd0aHdhTkxTNlR0Y2Y3WkNsWlF2QU8wWnJPU0RMY1dD?=
 =?utf-8?B?Z1Bqa0w4ZEo5TEpsRU9YbXZRM2xNV3l1UFhWZS9uRkM1RTFKUjVwV25qSkZW?=
 =?utf-8?B?cGFIT0pvUklaY1BmWXd3UTBqcDRnVjFCQk9ySmlRNlhCOGdaQ2VkWVljajMr?=
 =?utf-8?B?eGhjR3ZFMXljcDVMWjVzUVVYdDd2WXNwQ3dmaXY4Ympla0s4V1ZyQzNtTEc0?=
 =?utf-8?B?cFVDd2htblJnaEE5TjFwK3dPd05lbFZQcGxFcy9VbjNNSktOMFUrVGcrVnRE?=
 =?utf-8?B?cURGczU2bGNoKzN6S3lBRzdHZUVoNzE4dnp5UGdNTUV5eUt6ZHQ1eXo2Vi83?=
 =?utf-8?B?endHbDJONnFjR2poRUVZZzRXb0xiT1lzcm1qN1BhUE9lYXJIWFlweUJsL3JY?=
 =?utf-8?B?QmhETmpJb0g3c09xanJBMGZBdlNqYWJqWk9Ba2FDVlR1R2p2U3BaeDcvMnB3?=
 =?utf-8?B?cjVUTGVrS0FUK0MvYmpvTDRCemM0b1RzN2N5aFRjeUVDb0dJcWhtbWlVSjBo?=
 =?utf-8?B?Y2dlUWNHYWp1L1dwd3VobEQ5c3IwSWdCWGpaYWNYaDRyRFJ4dCtxU1lBNTlk?=
 =?utf-8?B?OWY2UGM4QnRIeUlaYTlwWFFmVHFoR3NKdkVmSkVrQzhwaXgxWTA2MUk2RXJD?=
 =?utf-8?B?NDBVL0QvZ3M0VXRHZ1ZPQ2RJSHNPU3BldTJ3bUR1aXB0d3QrNC9sL2NZMFB2?=
 =?utf-8?B?NXd6V3YyVE44WkpVZUg4ZmJWMkQ0bVd4RW8vNUtSbG9YMXpUL0g1RkVabzJI?=
 =?utf-8?B?MW55aWRKSS9RUUZTR1FlM0IzR0pVREhWR3BIZUR3ZmMrbTVJcThCWXBFNHlx?=
 =?utf-8?B?VjNZSFhrUFRmTkFNNHdVam9PSENmSENrMmpmK3hndFhrempvRmtpSk5HY0Ez?=
 =?utf-8?B?N08yZ3M4MnVJV1FJcmFRNm9LeVZ4Nis3SW0xMmZOWm5iazgwSnc3Z21hYytG?=
 =?utf-8?B?NmtUSEliWEVjNEpOeExwQ05UTTgzdy9YSmxYeDlvb2RqSldUQU5zN1hSNnky?=
 =?utf-8?B?ZHA1V2FIbnpRQ1FUakR5SEIvRzIrTnJyQUI3ZWFKQnFmNTAxN3N2djVFV09h?=
 =?utf-8?B?d1NZdEN1aDhIVlREUERyTFRHNzgzMVBqOXA5RS9nS21BWWlZTGJ2VVMrZWxy?=
 =?utf-8?B?SE1JZmpFSDZ3aEdVRTg1ZHQrUEM0dGFENU5NbVlsaXBWdnZPSXBsYzViVmE3?=
 =?utf-8?B?N29ENFByeExPV1JJV0VQb1NKMmNvSzFXUHBvMy8yVWVwNDhZMjBKbEVMeEFI?=
 =?utf-8?B?My96ZWdnVk9tbUJXaC9hOVV1M0ovcU5sVHpaTWQvRXR0YytXYnRHbFByQnhX?=
 =?utf-8?B?Y1RrU0ZFUzFzL2pkVlVNOXYzcmp6QzBkNW9FYnAwZTgrdStpOFArZkVDMXVq?=
 =?utf-8?B?dUhrSUR6QmlQZHlPdHhVUi9qTzByM050RUhOTWZqaDB0eWRELytrcElNR1Zu?=
 =?utf-8?B?bStiRnF2ajNMUWYycFZzWXFDRkxLTlVQaXMzZkxySDNmY3NPa2R3OXBpTGM2?=
 =?utf-8?B?OWJCWDYyZjNLdWNIK08xTTRkQU0xdFdTQzV2WnFUaUNTTWRnWmdidjlOTnRB?=
 =?utf-8?B?bHQrR2dRT3hLNHljNk1YQ0FUM1pjVlpQTC9QSnVENW1iTW9Lam44SXp4MlVj?=
 =?utf-8?B?UVA1blViSkJtbGxmMjQxcHY0ZDNRSStXZDhrVzkwalZFM2k3N1JEaTVmZlNH?=
 =?utf-8?B?ZHk5NE9nekNIbW9MRkpBTHl0Y0luSFJaUGEyeGE4OHRocndJWWx0d1NpRWpr?=
 =?utf-8?B?NDdEWE9Ra2NKOHVkTVdUb2xrd3FDbmlMT1Q3Z3V4STk5WkpnaXVPTWVDcnFR?=
 =?utf-8?B?aGF0b2RCWDF5WHRZWXBjUklsWFFmN21aVWJrbmZFL041MnRRS0tBazVxeTJD?=
 =?utf-8?B?M0tlT1BONWdZdjdQSkhPZjhhUjRUYTFhem5kdTVVQTBVTjFRL3g2QTVkOTVW?=
 =?utf-8?Q?EG/w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0539792-4afd-42d8-29b3-08dac5fa3e4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 04:39:40.3774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bKNqFQwLcqBl2461prCnsrOeo5aXA1S0gTdsy8egrrqDRrQUpk8X9Lp5Bbp9mf+m/z0QB82hStk/Hg88TOBBvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4656
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ID4gPiA+ID4gT24gSW50ZWwgeW91IGNhbiBvcHRpb25hbGx5IG1ha2UgaXQgaG9sZCBvbnRv
IElSUXMsIGJ1dCBOTUlzDQo+ID4gPiA+ID4gPiBhcmUgYWx3YXlzIGVhdGVuIGJ5IHRoZSBWTUVY
SVQgYW5kIGhhdmUgdG8gYmUgcmVpbmplY3RlZCBtYW51YWxseS4NCj4gPiA+ID4gPg0KPiA+ID4g
PiA+IFRoYXQgJ29wdGlvbmFsbHknIHRoaW5nIHdvcnJpZXMgbWUgLS0gYXMgaW4sIEtWTSBpcyBj
dXJyZW50bHkNCj4gPiA+ID4gPiBvcHRpbmctb3V0Pw0KPiA+ID4gPg0KPiA+ID4gPiBZZXMsIGJl
Y2F1c2UgIklmIHRoZSDigJxwcm9jZXNzIHBvc3RlZCBpbnRlcnJ1cHRz4oCdIFZNLWV4ZWN1dGlv
bg0KPiA+ID4gPiBjb250cm9sIGlzIDEsIHRoZSDigJxhY2tub3dsZWRnZSBpbnRlcnJ1cHQgb24g
ZXhpdOKAnSBWTS1leGl0IGNvbnRyb2wNCj4gPiA+ID4gaXMgMSIgKFNETSAyNi4yLjEuMSwgY2hl
Y2tzIG9uIFZNLUV4ZWN1dGlvbiBDb250cm9sIEZpZWxkcykuICBJcHNlDQo+ID4gPiA+IGRpeGl0
LiAgUG9zdGVkIGludGVycnVwdHMgYXJlIGF2YWlsYWJsZSBhbmQgdXNlZCBvbiBhbGwgcHJvY2Vz
c29ycyBzaW5jZSBJDQo+IHRoaW5rIEl2eSBCcmlkZ2UuDQo+ID4gPg0KPiA+ID4gKGltYWdpbmUg
dGhlIG5vbi1jb2MgY29tcGxpYW50IHJlYWN0aW9uIGhlcmUpDQo+ID4gPg0KPiA+ID4gU28gaW5z
dGVhZCBvZiBmaXhpbmcgaXQsIHRoZXkgbWFkZSBpdCB3b3JzZSA6LSgNCj4gPiA+DQo+ID4gPiBB
bmQgbm93IEZSRUQgaXMgYXJndWFibHkgbWFraW5nIGl0IHdvcnNlIGFnYWluLCBhbmQgcGVvcGxl
IHdvbmRlcg0KPiA+ID4gd2h5IEkgaGF0ZSB2aXJ0Li4uDQo+ID4NCj4gPiBNYXliZSBJIHRha2Ug
aXQgd3JvbmcsIGJ1dCBGUkVEIGRvZXNuJ3QgbWFrZSBhbnl0aGluZyB3b3JzZS4gRnJlZA0KPiA+
IGVudHJ5IGNvZGUgd2lsbCBjYWxsIGV4dGVybmFsX2ludGVycnVwdCgpIGltbWVkaWF0ZWx5IGZv
ciBJUlFzLg0KPiANCj4gQnV0IHdoYXQgYWJvdXQgTk1JcywgYWZhaWN0IHRoaXMgaXMgYWxsIGhv
cnJpYmx5IGJyb2tlbiBmb3IgTk1Jcy4NCj4gDQo+IFNvIHRoZSB3aG9sZSBWTVggdGhpbmcgbGF0
Y2hlcyB0aGUgTk1JICh3aGljaCBzdG9wcyBOTUkgcmVjdXJzaW9uKSwgcmlnaHQ/DQo+IA0KPiBC
dXQgdGhlbiB5b3UgZHJvcCBvdXQgb2Ygbm9pbnN0ciBjb2RlLCB3aGljaCBtZWFucyBhbnkgcmFu
ZG9tIGV4Y2VwdGlvbiBjYW4NCj4gaGFwcGVuIChrcHJvYmVzICNCUCwgaHdfYnJlYWtwb2ludCAj
REIsIG9yIGV2ZW4gI1BGIGR1ZSB0byByYW5kb20NCj4gbm9uc2Vuc2UgbGlrZSAqU0FOKS4gVGhp
cyBleGNlcHRpb24gd2lsbCBkbyBJUkVUIGFuZCBjbGVhciB0aGUgTk1JIGxhdGNoLCBhbGwNCj4g
YmVmb3JlIHlvdSBnZXQgdG8gcnVuIGFueSBvZiB0aGUgTk1JIGNvZGUuDQoNCldoYXQgeW91IHNh
aWQgaGVyZSBpbXBsaWVzIHRoYXQgd2UgaGF2ZSB0aGlzIHByb2JsZW0gaW4gdGhlIGV4aXN0aW5n
IGNvZGUuDQpCZWNhdXNlIGEgZmFrZSBpcmV0IHN0YWNrIGlzIGNyZWF0ZWQgdG8gY2FsbCB0aGUg
Tk1JIGhhbmRsZXIgaW4gdGhlIElEVCBOTUkNCmRlc2NyaXB0b3IsIHdoaWNoIGxhc3RseSBleGVj
dXRlcyB0aGUgSVJFVCBpbnN0cnVjdGlvbi4NCg0KPiANCj4gTm90ZSBob3cgdGhlIG5vcm1hbCBO
TUkgY29kZSBpcyB2ZXJ5IGNhcmVmdWwgdG8gY2xlYXIgRFI3IGFuZCBib3RoIGtwcm9iZXMNCj4g
YW5kIGh3X2JyZWFrcG9pbnQga25vdyBub3QgdG8gYWNjZXB0IG5vaW5zdHIgY29kZSBhcyB0YXJn
ZXRzLg0KPiANCj4gWW91IHRocmV3IGFsbCB0aGF0IG91dCB0aGUgd2luZG93Lg0KPiANCj4gQWxz
bywgTk1JIGlzIElTVCwgYW5kIHdpdGggRlJFRCBpdCB3aWxsIHJ1biBvbiBhIGRpZmZlcmVudCBz
dGFjayBhcyB3ZWxsLCBkaXJlY3RseQ0KPiBjYWxsaW5nIGV4dGVybmFsX2ludGVycnVwdCgpIGRv
ZXNuJ3QgaG9ub3VyIHRoYXQgZWl0aGVyLg0KPiANCj4gPiBZb3UgcmVhbGx5IHJlYWxseSBkb24n
dCBsaWtlIHRoZSBjb250ZXh0IGhvdyBWTVggZGlzcGF0Y2hlcyBOTUkvSVJRcw0KPiA+ICh3aGlj
aCBoYXMgYmVlbiB0aGVyZSBmb3IgYSBsb25nIHRpbWUpLCByaWdodD8NCj4gDQo+IEkgcmVhbGx5
IHJlYWxseSBoYXRlIHRoaXMgd2l0aCBhIHBhc3Npb24uIFRoZSBmYWN0IHRoYXQgaXQncyBiZWVu
IHRoaXMgd2F5IGlzIG5vDQo+IGp1c3RpZmljYXRpb24gZm9yIGtlZXBpbmcgaXQuIENyYXAgaXMg
Y3JhcC4NCj4gDQo+IEludGVsIHNob3VsZCBoYXZlIHRha2VuIGFuIGV4YW1wbGUgb2YgU1ZNIGlu
IHRoaXMgcmVnYXJkLCBhbmQgbm90IGRvdWJsZWQNCj4gZG93biBhbmQgZXh0ZW5kZWQgdGhpcyBO
TUkgaG9sZSB0byByZWd1bGFyIElSUXMuIFRoZXNlIGFyZSBleGFjdGx5IHRoZSBraW5kIG9mDQo+
IGV4Y2VwdGlvbiBkZWxpdmVyeSB0cmFpbndyZWNrcyBGUkVEIGlzIHN1cHBvc2VkIHRvIGZpeCwg
ZXhjZXB0IGluIHRoaXMgY2FzZSBpdA0KPiBhcHBlYXJzIGl0IGRvZXNuJ3QgOi8NCg==
