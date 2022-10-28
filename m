Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3DA6107A6
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 04:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbiJ1CLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 22:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiJ1CLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 22:11:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5A165275;
        Thu, 27 Oct 2022 19:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666923075; x=1698459075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UpHkAYv4EM8DrtYChxZZbYB2/oq3/v3PcPv1GDii7+M=;
  b=LV0PjGRh5TVThqKhkM4ufac0dJ5Y6+eGePrY7qLZICVW9rOuDYPJsz2M
   2NFOtx2eWH0zR9hzdgkdwoHXR3czYPTr+ulz+mmGQQPSqHeb5uoj/wB2M
   CQRx1qrvf7mGUAnWO8SwpiDihQ7SAW4Ds+TNjj3mSguWYvfmcZoHMjTjH
   s97dK/MW64K5Ruo2bc29yHsV7ML7/LAjDykTxAgxhtWJwpPKLPWcxvtf2
   8BeLduwtUO4MHTvRnnSJLwaW+9nNuOXYdL3+hr4vQ6UxOyFguWiGT3tU4
   m7MdUEefN2f3/OXuth5O0VX7fMQ9y7DM5KGrd8zpcQ6uKQ30XLTh1/dMn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="309482633"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="309482633"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 19:11:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="961854654"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="961854654"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 27 Oct 2022 19:11:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 19:11:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 19:11:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 19:11:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 19:11:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igJy6RQ1XYUtKPjp/dOdtzhdhVDS6/LcHMDSN5xeDQLxz0PJaDuGUi0M70pyvyUYhoQaG+DSmDTq2JoP0A6L/l2yfG6Y5zosFh++JvnU8/ED99wapiZMSl4dnblCXG1PFv0mtfOHBJfrDjnGP2UYEKTxXId/M5rId+evhh6kSNE0rqOlHVXWGkASQT0KNPk+5wdelVqgoXbi7+7jbS1GdElARn8Rd+4+RYea6i3jPrWFGLq09DI6/XzadgyDrjodPxrAtR/KDicB2VsSbwpwZwG2r4VOt9un0I3xkQotiMJeQMnCVJbPjMdsFSfL8R9EaIokGgm61ZIzBDCjLjhkhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UpHkAYv4EM8DrtYChxZZbYB2/oq3/v3PcPv1GDii7+M=;
 b=L1ORFPDircgR33HqZt1Tiab/i8tz8a853eQHc66KLmDnUTvHBLUhXONYmYKktvtt0I8bcdj0tMTuW8uoyi0v8vO/O8dlC1lL93I4B2zHuVjvek4GZxoSoA+VKR0KWosCRkSdCSZQ2L7cbtsytXBjDmhQDq9JlN7GtkgMGu4R9ZPZxPzHd2lpT3pWnQZYgZY5kuq5VCsrah7WnmAnkoWInIJ7+3uGqheLRz51CiLDe/a8AgCkv4pe4QIn4QgMC9frzAdAsplyTw+/1hXPYyYAX37FBCFVb2RNso2OCNf3AJ32jJHT1uxyGIyIe0vjAJhLTVgqzsBzNA3QSeZbxE4fBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 IA1PR11MB6241.namprd11.prod.outlook.com (2603:10b6:208:3e9::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Fri, 28 Oct 2022 02:11:11 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 02:11:11 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Vipin Sharma <vipinsh@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 5/5] KVM: selftests: Allowing running
 dirty_log_perf_test on specific CPUs
Thread-Topic: [PATCH v6 5/5] KVM: selftests: Allowing running
 dirty_log_perf_test on specific CPUs
Thread-Index: AQHY5ZKzsJSoXiEDzEiLKUZFIm4C+q4f88hwgADksACAAOmJcIAArCYAgABE4ICAAGBX8A==
Date:   Fri, 28 Oct 2022 02:11:11 +0000
Message-ID: <DS0PR11MB63735722DBD08190B849DD9DDC329@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221021211816.1525201-1-vipinsh@google.com>
 <20221021211816.1525201-6-vipinsh@google.com>
 <DS0PR11MB637351B52E5F8752E7DA16A4DC309@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1lV0l4uDjXdKpkL@google.com>
 <DS0PR11MB6373E6CA4DDFFD47B64CB719DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1qqIgVdZi7qSUD0@google.com>
 <CAHVum0edLWu0fGMgs7n2v2Fu-XW5mXtAsJ2dtkWD=ZadbRi+hw@mail.gmail.com>
In-Reply-To: <CAHVum0edLWu0fGMgs7n2v2Fu-XW5mXtAsJ2dtkWD=ZadbRi+hw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|IA1PR11MB6241:EE_
x-ms-office365-filtering-correlation-id: 551049b6-3119-4e2b-ad1b-08dab889aeeb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W7ty6fw90SHOi1rtTZTlDbvqZMpuMwRZfAP2G07d3X2kLOdnz9EO8WgpfNU4Io4+z235u1nr4bc6XljORl/qlQ/IcsI5zb1bdA1aTvrFbLShm8tn0VhQ+HRdevR9krd2JmBc22UXpsZtWD9bLjRUCjKi3eHEhcVkNklWJCUYDNxvk3EtThcmCi4zHPC2mUb1KURwlnSevKDN0ZuEHvWq9kNg2gZNT6DeJnxTuuUlKf9GnEsAD8T8mPF5CrsuvJdR0CcEaW7EK5YKo0gOxJjYz5MvBEzYjp+tz5VtdxeWmAK82m8kyqse6Y8MBZMFU3q8L/bpprrA3ubXTa1uxJFDyPSNnXnkWjHYibwdY93j5yCTZs977sw+lx/5f5IAfOsbe8mS9U2lXWO5wyWVV6mgKWkd2PlzXIqnJV6Gi+2mXZVEZNMrfcOfARvv43T70IPrJpMvSGQjU7SYyvUGLZ8zxLb1EojsNPTU+QWbC9XLrN2Sxyk2p6hYmBitqiLKXIrF1n2+DwuF5jilDpQqQKHkD+7nSkBC7uyLrKfZRp4UByXETGVkZ9n2zP/fWZlghNNoXwobjo52/xFwBzUrnm6rrF4V1hY7HQYKJBTIOx7JGoCDXXkKh6CkOsitCAxxhnna5OFZNaToCpEOlOaht+c7q9eJvf/QU3cMowd5FDEhA+5jbgVjVf8UW7xsFZUM6rvtl3AK9GVwU1aesWzUQHI5ugqaxs+b3XScJsA76p1ggGbFgPahKQ1CVG3jGEcedJqmYu1efP8SyAZP6rGKT1Nq0tXf2Ub57eZCH2MaSFgEVDM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199015)(33656002)(38070700005)(86362001)(122000001)(82960400001)(38100700002)(6506007)(53546011)(7696005)(4744005)(55016003)(2906002)(186003)(9686003)(26005)(54906003)(66556008)(8676002)(71200400001)(316002)(52536014)(110136005)(478600001)(4326008)(66946007)(66476007)(41300700001)(64756008)(66446008)(5660300002)(8936002)(76116006)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWhVZkRPS2lTM1Z2bGZicUwrbTUzdktXM1VPSFlnNkVzMmJmejNQRHh4WkxV?=
 =?utf-8?B?K2QvVW9XT3VSOUoxeVJFNHAyaHUvY3VGdTQ5WDNYYnVBVVlndlVodmRCOFhG?=
 =?utf-8?B?N3Z5amdDZWFFalpWaWhMeDg1R1RRUE91ZzBUclRRRWwxc1pENkRmY0U1Mm1E?=
 =?utf-8?B?N2JZV3JMSmVueDg5cGhRUVhFU1dYZCs3QTdOMnRoZC9ZQktMK2x5UlhaS1FN?=
 =?utf-8?B?WUZMRjhCMis5RkJMR1FVY29aY2U1S2NRZzJqYURKV0pnTTRlYkorNXgyQ0pn?=
 =?utf-8?B?ZlY1K1hKRVBybjlUNzM2L3FLdTFiR1laMjU3R0xzamtTR3M0TEpXeVVDTTlr?=
 =?utf-8?B?MjNQWDQ3MXdkeXpZSEIzRVorTmdVbEhKNnVLaWhReFQ3dVp5enVKZjBxdUZ3?=
 =?utf-8?B?NGxHVU5CMklnOTU0Mkh4YitudzBoQ2dlWUhIQ2tUSGRCU21yQ0tVMFZZa0dx?=
 =?utf-8?B?RU0vOWhuQ2NaRkFXYzh4eU51Y0xjUkp1OVhGLzdPWGliQ24xVzhQMXlLampH?=
 =?utf-8?B?UjU1cElETzZrZHFWU2QzbUhKdEdqcnlMQ05ZU0RWbDcvRkJZcGhhTlpaSkkx?=
 =?utf-8?B?UWcwRllUTEthM2dKckJRU0hsWmJWYkxzejFER1RpdklQditMUFFYU00xZnFs?=
 =?utf-8?B?UVlFQzd4ZDRZRklwR1VFUVJXZE0vNXhTWlRtaUlsQktFcFBqTjMwMXpUMjU1?=
 =?utf-8?B?V00vM2lOR29nOG1WS1JGZHBTMG5HaWtUdHdZb3NuM3prWTBhejdYTjJ6b1RZ?=
 =?utf-8?B?M3RuazZvSWFobDBOQlRUZGZXdHZMTzJ3cm5MVkU2Tk5SOW9hVFlkRmx3RVo4?=
 =?utf-8?B?Z3BHYXk1L0x6dkp6dlIrZVRFTjJoaGlSaFBtSEZMbVo4NTVpaWx3UDJJdGo2?=
 =?utf-8?B?WmhNQWQ3SjZXL0U1YUE1czFhZnNaOFBKUlE2N0xCTUo3ajdxZWNKdy90cnlF?=
 =?utf-8?B?QW5HVnJEMFVpcVBxa08xcGRQdTMxaTZkQlRQSExmcEI4bWNJbE54cEZxUmRY?=
 =?utf-8?B?aFJJNll6VWtFTFY5MHJQNUtuME9xWThpQ0JhN0xpSWswa01jY1VEWDQxOUJ4?=
 =?utf-8?B?aXpJc2Ntb1NnTnAzQVgxd0t5VWIzS1NSVG5Ec0d0c3dSNDZMNFoxeWlIYXc5?=
 =?utf-8?B?QitWOUJXUkV0T2ltYWNaS0ZwNnZhS1NuZzROV2ZVK2JHVDZIRE5SRUhZNGl2?=
 =?utf-8?B?aTUwcWJUSXRHbHZSYlVLc3hMNWEyOUswZWdqRVova3ZKV2t4OFFwVWRnSFZq?=
 =?utf-8?B?c2JDN0I3VDBwUkdXVjJmTi9ISEdSMVc5WkZ2ZEdDcm5QbXJyM1dWZFdZOUlx?=
 =?utf-8?B?RzhZZnlCQTVHRm9xS1NxK21rQytaU3htcEFNWmRmb29XamxyRTlMcE1uK1c1?=
 =?utf-8?B?cmtoeU1RaVB2dDhOaEM5VzZsK1pXYU0rcmJkU1FQTHJsV3dDbzRqdXUyVGRu?=
 =?utf-8?B?c0liQmw3NTk1M2ZqeU1wR1pJV1dNNWNDcVlFY3h3ZUhlOWNFenBLYkNlS0hl?=
 =?utf-8?B?R2tNcEk5SkxzWW05S3RYT2lRMk04N3RKVENuOE8xNk9pS3Q2N08vZzhKa1ZE?=
 =?utf-8?B?Nmp5ZUpBNVpvMVFnWDhOeDJBQ01waExjTzk1cWJYclVhbk5rWFJhU2orMW4y?=
 =?utf-8?B?dHpIVE1Zai9hSTVkODRBT1NCQm5qek9haWg1ZXg5dUlOQzJNNmkybXpPTDdO?=
 =?utf-8?B?SWVQdWxZRHg5VGFpNTdCYjBHdkJKcGpkQWI0VkdxeGZuQXdqYStiU2dJaDI5?=
 =?utf-8?B?S00zeVlXWDNyZEZKS3BjaTdsZGJBbSt4LzFJMDN3bmE4cUFYNlpNRTgyMWIv?=
 =?utf-8?B?RS9zNTFqeVdyckFxOXdXczR0Y3JUZWpNeG4yUDRIZVVwaWVEVFE1eUlQTFpt?=
 =?utf-8?B?c1V1ekUzQWpDbDdjeW9pWi83Um9IUWk1dlA0Wi95UGt4RTI2dkVVQjNmZnRs?=
 =?utf-8?B?aEwzVVlSYzFRS3VYUkV4ZWR3TGRKemdzaWNmRm10VlBtR2ZVRGRxL1RBNEd4?=
 =?utf-8?B?R1VpMkxuSnpHTUtNS1d6dG8rMGFJL25NZVFOTjMzSVZXdmk1bVBQK0RDRU9r?=
 =?utf-8?B?RTV4NlBaeWlNbGNpYS8yYS9tVVhQRzlHQTl0eWN3cWN5NTZqbzFSK0I2clhD?=
 =?utf-8?Q?uKdPNvMN8xtdDHCCPVrr/3NIl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 551049b6-3119-4e2b-ad1b-08dab889aeeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 02:11:11.0589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cfbfCRuMze43uP1AY2mEdzWw1KiU4g9/XBHHHWrvlTHkiI5Qqt0HAj1Y/aEGnrVXBgIiXOqTKBnRbQ03UDHyQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6241
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpZGF5LCBPY3RvYmVyIDI4LCAyMDIyIDQ6MDMgQU0sIFZpcGluIFNoYXJtYSB3cm90ZToN
Cj4gcHRocmVhZF9jcmVhdGUoKSB3aWxsIGludGVybmFsbHkgY2FsbCBzY2hlZF9zZXRhZmZpbml0
eSgpIHN5c2NhbGwgYWZ0ZXIgY3JlYXRpb24gb2YgYQ0KPiB0aHJlYWQgb24gYSByYW5kb20gQ1BV
LiBTbywgZnJvbSB0aGUgcGVyZm9ybWFuY2Ugc2lkZSB0aGVyZSBpcyBub3QgbXVjaA0KPiBkaWZm
ZXJlbmNlIGJldHdlZW4gdGhlIHR3byBhcHByb2FjaGVzLg0KDQpUaGUgbWFpbiBkaWZmZXJlbmNl
IEkgc2VlIGlzIHRoYXQgdGhlIHZjcHUgY291bGQgYmUgY3JlYXRlZCBvbiBvbmUgTlVNQSBub2Rl
IGJ5DQpkZWZhdWx0IGluaXRpYWxseSBhbmQgdGhlbiBnZXRzIHBpbm5lZCB0byBhbm90aGVyIE5V
TUEgbm9kZS4NCg0KPiANCj4gSG93ZXZlciwgd2Ugd2lsbCBzdGlsbCBuZWVkIHBpbl90aGlzX3Rh
c2tfdG9fcGNwdSgpL3NjaGVkX2FmZmluaXR5KCkNCj4gdG8gbW92ZSB0aGUgbWFpbiB0aHJlYWQg
dG8gYSBzcGVjaWZpYyBwQ1BVLCB0aGVyZWZvcmUsIEkgYW0gdGhpbmtpbmcgb2Yga2VlcGluZw0K
PiB0aGUgY3VycmVudCBhcHByb2FjaCB1bmxlc3MgdGhlcmUgaXMgYSBzdHJvbmcgb2JqZWN0aW9u
IHRvIGl0Lg0KDQpJIGFsc28gZG9u4oCZdCBoYXZlIHN0cm9uZyBvYmplY3Rpb25zLCBhbmQgaXQn
cyB1cCB0byB5b3UgZm9yIG5vdy4NCkkgd2lsbCByZS12aXNpdCB0aGlzIGxhdGVyIGFmdGVyIHRo
ZSBjb2RlIGNvbnNvbGlkYXRpb24gcGF0Y2hzZXQgaXMgbGFuZGVkDQphbmQgc2VlIGhvdyB0aGlz
IGNvdWxkIGJlIGJldHRlciBjb25zb2xpZGF0ZWQgZnJvbSBhbGwgdXNlcidzIHBlcnNwZWN0aXZl
Lg0K
