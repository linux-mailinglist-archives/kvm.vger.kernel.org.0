Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844717100D6
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 00:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbjEXWVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 18:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237550AbjEXWVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 18:21:20 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6429F1985;
        Wed, 24 May 2023 15:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684966827; x=1716502827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R0XpjUyWH/rXrr7TI130MtsaAWuAja2kckR/B6IKM4w=;
  b=GbBJh/TUkIFU5YG/zvRcK157g2XTvswS/bx/qioCo/hIo5uHOB3LQPOY
   V716bkGT+bKACnB8MofYZJy+9IofD3wHp8F1DMuPO+uYSc7TQ2ls5+g9P
   zEWSpwH2QLzSjYoG+ITHfS2S4XDSDsNGKHIpVf4gqiND8CAtlxswJWwsZ
   dbqceWFXUi0MLR1aM/3uTOotljspO9QTB24NFOYN1gIPotJdV7aqsYqgC
   f3GCM2YhKReXZsnQuDBcs2iaeE9b6ZfVEYT6VHfiM7KaML0nu5UPPNgV8
   TEK4q5gQ7bbxNMgJZa3gxqthtfFlLfj1JUmUwiWN25BffdVU3WEVkKetE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="381953522"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="381953522"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 15:20:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="735351617"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="735351617"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 24 May 2023 15:20:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 15:20:23 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 15:20:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 15:20:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 15:20:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1wwXd55doA+ig+0rv0ZGDtyRyhVT7BgbeGlPmbmb0pXAOC5w9ZfFnphANzbIr9a1yx62PJXwq9ZBmazuJ1hmvtnOre4A2mOy6aHQTbr/l/EMUIN3QIc8hBYRwRLBsw0QNRzPzLhLXkYpmlEDQkyYiLWDDKxprA/v3e9gAEc4xPKRaBAXhTurK8yEioyTZcEo09wwXK6IqatF0xRun0LZZuMQHthlsfwrO6Sx6h7ldArnu6+kfitqtmygk1GQciLLDvxxqjfaIdcd4tKveRnKvB9sfdfmc0DOipq0/cP7m4zqNPbctoQ4oYgRNGuKljHQNRW4orKTpFeA35x+u+Jzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0XpjUyWH/rXrr7TI130MtsaAWuAja2kckR/B6IKM4w=;
 b=dNKoh2LcJNH4xtkVdyQ9rAlYOqeIo7oIpWo+5Xwd60pXQFXVbOsCThbGO0phkRIlAIq2bzv6J3RS62jR8l+iJAoug+Er9lEcmDCjvFKG2rZV7t4GZlVd/xz2YLCwwwgZ+wclRxAjmVGIIfcKcJxGDKDJM4m1c7AImIsH5kQ06Y+zr9iqTCw239L9ji9OVXAtAJWxsfRCDO73DiojMbDzbpLcgLyppmdXOGECc+LtlH8tF+sudgQ9tWmmWdw3TzNnD8T20vlWNh1RJSLkHIcUg1HW77KVKpdG9xfA4y1qKK9A9rK7Nh+5DD1mDznoLrnHSR5jVL0vSmgH0xGa88EpAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5455.namprd11.prod.outlook.com (2603:10b6:5:39b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 22:20:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%6]) with mapi id 15.20.6433.016; Wed, 24 May 2023
 22:20:16 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "mic@digikod.net" <mic@digikod.net>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yuanyu@google.com" <yuanyu@google.com>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "marian.c.rotariu@gmail.com" <marian.c.rotariu@gmail.com>,
        "Graf, Alexander" <graf@amazon.com>,
        "Andersen, John S" <john.s.andersen@intel.com>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "ssicleru@bitdefender.com" <ssicleru@bitdefender.com>,
        "tgopinath@microsoft.com" <tgopinath@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "dev@lists.cloudhypervisor.org" <dev@lists.cloudhypervisor.org>,
        "mdontu@bitdefender.com" <mdontu@bitdefender.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "nicu.citu@icloud.com" <nicu.citu@icloud.com>,
        "ztarkhani@microsoft.com" <ztarkhani@microsoft.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
Thread-Topic: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
Thread-Index: AQHZf2Ve5xw6RDm4tUGLnlOpizAoCa9qHQcA
Date:   Wed, 24 May 2023 22:20:15 +0000
Message-ID: <93726a7b9498ec66db21c5792079996d5fed5453.camel@intel.com>
References: <20230505152046.6575-1-mic@digikod.net>
In-Reply-To: <20230505152046.6575-1-mic@digikod.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5455:EE_
x-ms-office365-filtering-correlation-id: 4d6de98d-376a-4f9e-607c-08db5ca50cdc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B+hCW7IktQfMtTDFz2aveZKvtvuBIm9Ulh1wh8aPwgbA2O53Vsqp0Xs/tzkPncl7tUMjYFItEM8R+xtmpUS7YHcPUuGmfm0w4OFFDcDwKHbcmUHJ/6qvNZrejgyE0iQ2l2p7u1mEqhV8CzNXTFBe3isQ1BhH35rNcKeER5P11EDxOXGdveCtJ0LT3KcJTDzw5srMIBUxZfJH5XS7Rx0PypfF1NX592YzfLNxEPZlvzzxyhrU0vFEfT0WntbPC1EJIxnFirXV/mQub9u1ORVBSrn6/VRuGN/bYX0GUvCK6Wi7RB4FnigXDRQOItVQyqMq3TZF/8nnAF2sNmqF3eSHF3RgNz1QpZCJEisfZS50V2GO5O0CZLU1gNEnToTuZFOdvzvYcXfA1LRT02rK9iq+/ciU+tbOcNuxKuCzg/HRJMwMz2MQcCo6eZcIlPN8llJs042em5OobPrJU8maW32itOTmdwqoaSyW6xFqK4eYsyhsaOFli+a0eMsTjW6Ukrgq3eWp464Gg+6K/ctUsaPzJ9oQfYqnzTUdgtAyZMTzLAso+XRU1MiOkv96NYn1Yc6QHHYV05lLJy2CedR+oG+OfCqxyuQzy6DDz8W+IEbIEM1n5yakzqNTrdhqtPSr7QZxJREHE+ln0sqdiDSh8n/rWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199021)(66556008)(64756008)(66946007)(66446008)(76116006)(66476007)(4326008)(7406005)(36756003)(7416002)(8676002)(8936002)(5660300002)(91956017)(316002)(71200400001)(110136005)(54906003)(478600001)(6486002)(41300700001)(38100700002)(122000001)(921005)(82960400001)(2906002)(6512007)(186003)(83380400001)(6506007)(38070700005)(66574015)(86362001)(2616005)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXNaK1hWMHRPZHgxVXhkRGpvNDA3UDhuVlQ4WXFPUU5mWHRTWVBiVjBvenlM?=
 =?utf-8?B?L0FTS3h4UFlTaGtzUkZwbUNXVklBNE82WXpUTUhBbFhPaTJnUCt2WEFaaXVV?=
 =?utf-8?B?YUJrb1gxMnVhOXRFVGQvKzJiWUJUYUJmTjl4OWJ5RnZhUEpySjZBVm1LRzk0?=
 =?utf-8?B?TVZVTUlpMU5GdkNyN3JRVmhPb0NkalMxZTBXYmdGZnIvZmdPaXY0SXpjOUNz?=
 =?utf-8?B?V1RQdC8vMk9xNVFDSW1VUVBvN0dVM1kwVFZXbzROR0R1Y0Fva3QxWEUyYk1t?=
 =?utf-8?B?dkx6c1JXemQ5UTkrY05hdHpwZzRFdnNKeGFBMUtEMDhQQmFhNFl4Sis0OVRI?=
 =?utf-8?B?ckRpVlZHWEM1WWVNYllnTlB6ZHo3cGFDcG50T2tLM3V1aFlSL2pkeVNEZ1RS?=
 =?utf-8?B?cEZJOGh3QkpKZ2tnQS9ZTUdUNW5iV0hFVGNIaTMySzBJSjAzaEVhQUQxVEhJ?=
 =?utf-8?B?bmltZzdtRXRnaERNZis3MnVBbkVPc3VYOEhJTGdzR2FuZTFvSGU5VVJFODJi?=
 =?utf-8?B?WVk0UHJ3MmdZQkd1K1F2U29MUjRMMUQ5VTdQM2FuWlVLeWw2SzJwMzNINEFp?=
 =?utf-8?B?MzMzVzRIYjlDRko4dUwrYnQrYnhiRTB2dWczU0w0eHJ2dWVyMkZ2S0Q2cGZF?=
 =?utf-8?B?aVhEMjIxMHZLaU9hUHEreHl5WmJXVENNczJZQ3ZjKyt1M0YvK3RQQ2lpekY0?=
 =?utf-8?B?U21iVTRlUFRQL1ZFc1NLRmlxRHFGRGlhN2tTWklqT1lqYzh5eWh2UEswTXVk?=
 =?utf-8?B?U3czNGs3eDJIVUxrU3V0QUZpbktwbk9FcEtjOURXWnQ3bE8wWkNGSWNlYWoy?=
 =?utf-8?B?N2t4enBDck5hWnRZakh2aVpuclBRb0FPMytXL2tRYjlISVFLZG5NZFRlRXp2?=
 =?utf-8?B?ZUpFOGt4dEo5dUs2c2tpdDZrM25PSXlYMEhEWDg3dVpTMGxCTFhub1huVWp6?=
 =?utf-8?B?UXhHWDVnNWJKaGZmbEJQRE9jWFNCcHg4SVNJVVpzTzZuWG9GQTZqZkN3d2xq?=
 =?utf-8?B?UW4yZHFrazYzSnlJUkpkRC9YV28xcGRhVGlZZEZiZFV4NmlGdE9zWUY5aW9U?=
 =?utf-8?B?R21UanVKUjdsNkc2dmJNNUNnclZ0Q1Nqb0pDdHgrODZRNlBmYU1Ocm1NK3Z4?=
 =?utf-8?B?NTRGc2dXVmpDQ1cwQ2x4b21yMVdQZDhueEQyMTV0NUFVZ1A2WHBuWGpjY2h3?=
 =?utf-8?B?VEFCYVd6TFBkRFRpZ2o4N1lsMWROQWpDUmpIQXhqdzRLc2t2YTJaczBGQWxD?=
 =?utf-8?B?Qyt3ODhyUXI0dUMzeFBXRlJxMUxSWWRQV0xKdWROenNPUFpQL0RUdmhKdEdL?=
 =?utf-8?B?ZFdZMzhHOFF3YXA5Qjd5NEJnSXE5UnZhWldYOU9SZVdTSGNGbmZsM05ER2Zl?=
 =?utf-8?B?RjIrdWJXRjBrQ2h1QXFVOW1xS2VjaDA5bWh6cVFjRTM4L2cvd29WV05pMjYv?=
 =?utf-8?B?cXQ3NjBtekNrM0xhbXFobEhIRGJnTkxFcWlHZnZMZ2F6SU9yd2toMGo2WGk2?=
 =?utf-8?B?bHhsaGxzcmNSQ1h1cmVEKzNrTTVHR1J0emFvUXVmdjdHMDJaS3FiclA2SDBG?=
 =?utf-8?B?eVAxbStGeUVyc09oWGE4aTFoczlKa1V2aHVqNjl3bWdoQ3ZlYVRCYkJSb05Y?=
 =?utf-8?B?SDJqWlFLKzA0WVltcklKZG1pTFhaTzh5dVozVUgzRy9lam9WWklEZTJyK1Jm?=
 =?utf-8?B?S1VPT25Vb2YwWTBZYWFhZXBGK2xHTEFKcEk1L2puU2loYjJGMTF0YnVtZ3kw?=
 =?utf-8?B?QlVxZ3Z2SjZSVlRPQVN5SG9LanBuQlhYU3lnYXlHNFlZc0FvU0YzSjdDTVcy?=
 =?utf-8?B?NEhWU2JDSUhSb2JmZXRXRFN6bkFjTmR0V2Ryamw0bGx6Y0dCMEdLYXZOUktM?=
 =?utf-8?B?ckdMTUlSYmZhRjBaN0h3azVuVVNZYzhKbVY0blNqblc0QnQvdEphbTJkcHVR?=
 =?utf-8?B?d0pPTE9iQkhSWVJyVEV4cnBrbnJCRFplRncyY3dxR29LQmxTZjFwMzllR0hF?=
 =?utf-8?B?djV1RURzeCtWS2VCZHRYY29BRGV2UUNhQmdMSGQ0ZXE0RWNsYjV0bUl3Q2s3?=
 =?utf-8?B?Nm9GWE9yNXlpbUg2UGtzNVk1NUtiNnpOaGpEc3BwczdiTHRrWll0UDdZR2xB?=
 =?utf-8?B?d0w5QjRqOFFqeGYwWFUzNElKZVRMQmU5cU9pYk9jdGRQeEdhNmV1WFcxbE1r?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0058187AD508C14A816AB1B9AA8BFE1D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6de98d-376a-4f9e-607c-08db5ca50cdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 22:20:15.7775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2wsf3UOKJr2UaKwGumskXSPj5m7xmbhO708YN3Vqg3JHfDQ+MQv//CVZTCMF/CN2YpolXKhuYyIskKrbrzIIsCxIswV4W3867yr8QFf4VHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5455
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTA1IGF0IDE3OjIwICswMjAwLCBNaWNrYcOrbCBTYWxhw7xuIHdyb3Rl
Og0KPiAjIEhvdyBkb2VzIGl0IHdvcms/DQo+IA0KPiBUaGlzIGltcGxlbWVudGF0aW9uIG1haW5s
eSBsZXZlcmFnZXMgS1ZNIGNhcGFiaWxpdGllcyB0byBjb250cm9sIHRoZQ0KPiBTZWNvbmQNCj4g
TGF5ZXIgQWRkcmVzcyBUcmFuc2xhdGlvbiAob3IgdGhlIFR3byBEaW1lbnNpb25hbCBQYWdpbmcg
ZS5nLiwNCj4gSW50ZWwncyBFUFQgb3INCj4gQU1EJ3MgUlZJL05QVCkgYW5kIE1vZGUgQmFzZWQg
RXhlY3V0aW9uIENvbnRyb2wgKEludGVsJ3MgTUJFQykNCj4gaW50cm9kdWNlZCB3aXRoDQo+IHRo
ZSBLYWJ5IExha2UgKDd0aCBnZW5lcmF0aW9uKSBhcmNoaXRlY3R1cmUuIFRoaXMgYWxsb3dzIHRv
IHNldA0KPiBwZXJtaXNzaW9ucyBvbg0KPiBtZW1vcnkgcGFnZXMgaW4gYSBjb21wbGVtZW50YXJ5
IHdheSB0byB0aGUgZ3Vlc3Qga2VybmVsJ3MgbWFuYWdlZA0KPiBtZW1vcnkNCj4gcGVybWlzc2lv
bnMuIE9uY2UgdGhlc2UgcGVybWlzc2lvbnMgYXJlIHNldCwgdGhleSBhcmUgbG9ja2VkIGFuZA0K
PiB0aGVyZSBpcyBubw0KPiB3YXkgYmFjay4NCj4gDQo+IEEgZmlyc3QgS1ZNX0hDX0xPQ0tfTUVN
X1BBR0VfUkFOR0VTIGh5cGVyY2FsbCBlbmFibGVzIHRoZSBndWVzdA0KPiBrZXJuZWwgdG8gbG9j
aw0KPiBhIHNldCBvZiBpdHMgbWVtb3J5IHBhZ2UgcmFuZ2VzIHdpdGggZWl0aGVyIHRoZSBIRUtJ
X0FUVFJfTUVNX05PV1JJVEUNCj4gb3IgdGhlDQo+IEhFS0lfQVRUUl9NRU1fRVhFQyBhdHRyaWJ1
dGUuIFRoZSBmaXJzdCBvbmUgZGVuaWVzIHdyaXRlIGFjY2VzcyB0byBhDQo+IHNwZWNpZmljDQo+
IHNldCBvZiBwYWdlcyAoYWxsb3ctbGlzdCBhcHByb2FjaCksIGFuZCB0aGUgc2Vjb25kIG9ubHkg
YWxsb3dzIGtlcm5lbA0KPiBleGVjdXRpb24NCj4gZm9yIGEgc2V0IG9mIHBhZ2VzIChkZW55LWxp
c3QgYXBwcm9hY2gpLg0KPiANCj4gVGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24gc2V0cyB0aGUg
d2hvbGUga2VybmVsJ3MgLnJvZGF0YSAoaS5lLiwgYW55DQo+IGNvbnN0IG9yDQo+IF9fcm9fYWZ0
ZXJfaW5pdCB2YXJpYWJsZXMsIHdoaWNoIGluY2x1ZGVzIGNyaXRpY2FsIHNlY3VyaXR5IGRhdGEg
c3VjaA0KPiBhcyBMU00NCj4gcGFyYW1ldGVycykgYW5kIC50ZXh0IHNlY3Rpb25zIGFzIG5vbi13
cml0YWJsZSwgYW5kIHRoZSAudGV4dCBzZWN0aW9uDQo+IGlzIHRoZQ0KPiBvbmx5IG9uZSB3aGVy
ZSBrZXJuZWwgZXhlY3V0aW9uIGlzIGFsbG93ZWQuIFRoaXMgaXMgcG9zc2libGUgdGhhbmtzDQo+
IHRvIHRoZSBuZXcNCj4gTUJFQyBzdXBwb3J0IGFsc28gYnJvdWdoIGJ5IHRoaXMgc2VyaWVzIChv
dGhlcndpc2UgdGhlIHZEU08gd291bGQNCj4gaGF2ZSB0byBiZQ0KPiBleGVjdXRhYmxlKS4gVGhh
bmtzIHRvIHRoaXMgaGFyZHdhcmUgc3VwcG9ydCAoVlQteCwgRVBUIGFuZCBNQkVDKSwNCj4gdGhl
DQo+IHBlcmZvcm1hbmNlIGltcGFjdCBvZiBzdWNoIGd1ZXN0IHByb3RlY3Rpb24gaXMgbmVnbGln
aWJsZS4NCj4gDQo+IFRoZSBzZWNvbmQgS1ZNX0hDX0xPQ0tfQ1JfVVBEQVRFIGh5cGVyY2FsbCBl
bmFibGVzIGd1ZXN0cyB0byBwaW4gc29tZQ0KPiBvZiBpdHMNCj4gQ1BVIGNvbnRyb2wgcmVnaXN0
ZXIgZmxhZ3MgKGUuZy4sIFg4Nl9DUjBfV1AsIFg4Nl9DUjRfU01FUCwNCj4gWDg2X0NSNF9TTUFQ
KSwNCj4gd2hpY2ggaXMgYW5vdGhlciBjb21wbGVtZW50YXJ5IGhhcmRlbmluZyBtZWNoYW5pc20u
DQo+IA0KPiBIZWtpIGNhbiBiZSBlbmFibGVkIHdpdGggdGhlIGhla2k9MSBib290IGNvbW1hbmQg
YXJndW1lbnQuDQo+IA0KPiANCg0KQ2FuIHRoZSBndWVzdCBrZXJuZWwgYXNrIHRoZSBob3N0IFZN
TSdzIGVtdWxhdGVkIGRldmljZXMgdG8gRE1BIGludG8NCnRoZSBwcm90ZWN0ZWQgZGF0YT8gSXQg
c2hvdWxkIGdvIHRocm91Z2ggdGhlIGhvc3QgdXNlcnNwYWNlIG1hcHBpbmdzIEkNCnRoaW5rLCB3
aGljaCBkb24ndCBjYXJlIGFib3V0IEVQVCBwZXJtaXNzaW9ucy4gT3IgZGlkIEkgbWlzcyB3aGVy
ZSB5b3UNCmFyZSBwcm90ZWN0aW5nIHRoYXQgYW5vdGhlciB3YXk/IFRoZXJlIGFyZSBhIGxvdCBv
ZiBlYXN5IHdheXMgdG8gYXNrDQp0aGUgaG9zdCB0byB3cml0ZSB0byBndWVzdCBtZW1vcnkgdGhh
dCBkb24ndCBpbnZvbHZlIHRoZSBFUFQuIFlvdQ0KcHJvYmFibHkgbmVlZCB0byBwcm90ZWN0IHRo
ZSBob3N0IHVzZXJzcGFjZSBtYXBwaW5ncywgYW5kIGFsc28gdGhlDQpwbGFjZXMgaW4gS1ZNIHRo
YXQga21hcCBhIEdQQSBwcm92aWRlZCBieSB0aGUgZ3Vlc3QuDQoNClsgc25pcCBdDQoNCj4gDQo+
ICMgQ3VycmVudCBsaW1pdGF0aW9ucw0KPiANCj4gVGhlIG1haW4gbGltaXRhdGlvbiBvZiB0aGlz
IHBhdGNoIHNlcmllcyBpcyB0aGUgc3RhdGljYWxseSBlbmZvcmNlZA0KPiBwZXJtaXNzaW9ucy4g
VGhpcyBpcyBub3QgYW4gaXNzdWUgZm9yIGtlcm5lbHMgd2l0aG91dCBtb2R1bGUgYnV0IHRoaXMN
Cj4gbmVlZHMgdG8NCj4gYmUgYWRkcmVzc2VkLsKgIE1lY2hhbmlzbXMgdGhhdCBkeW5hbWljYWxs
eSBpbXBhY3Qga2VybmVsIGV4ZWN1dGFibGUNCj4gbWVtb3J5IGFyZQ0KPiBub3QgaGFuZGxlZCBm
b3Igbm93IChlLmcuLCBrZXJuZWwgbW9kdWxlcywgdHJhY2Vwb2ludHMsIGVCUEYgSklUKSwNCj4g
YW5kIHN1Y2gNCj4gY29kZSB3aWxsIG5lZWQgdG8gYmUgYXV0aGVudGljYXRlZC7CoCBCZWNhdXNl
IHRoZSBoeXBlcnZpc29yIGlzIGhpZ2hseQ0KPiBwcml2aWxlZ2VkIGFuZCBjcml0aWNhbCB0byB0
aGUgc2VjdXJpdHkgb2YgYWxsIHRoZSBWTXMsIHdlIGRvbid0IHdhbnQNCj4gdG8NCj4gaW1wbGVt
ZW50IGEgY29kZSBhdXRoZW50aWNhdGlvbiBtZWNoYW5pc20gaW4gdGhlIGh5cGVydmlzb3IgaXRz
ZWxmDQo+IGJ1dCBkZWxlZ2F0ZQ0KPiB0aGlzIHZlcmlmaWNhdGlvbiB0byBzb21ldGhpbmcgbXVj
aCBsZXNzIHByaXZpbGVnZWQuIFdlIGFyZSB0aGlua2luZw0KPiBvZiB0d28NCj4gd2F5cyB0byBz
b2x2ZSB0aGlzOiBpbXBsZW1lbnQgdGhpcyB2ZXJpZmljYXRpb24gaW4gdGhlIFZNTSBvciBzcGF3
biBhDQo+IGRlZGljYXRlZA0KPiBzcGVjaWFsIFZNIChzaW1pbGFyIHRvIFdpbmRvd3MncyBWQlMp
LiBUaGVyZSBhcmUgcHJvcyBvbiBjb25zIHRvIGVhY2gNCj4gYXBwcm9hY2g6DQo+IGNvbXBsZXhp
dHksIHZlcmlmaWNhdGlvbiBjb2RlIG93bmVyc2hpcCAoZ3Vlc3QncyBvciBWTU0ncyksIGFjY2Vz
cyB0bw0KPiBndWVzdA0KPiBtZW1vcnkgKGkuZS4sIGNvbmZpZGVudGlhbCBjb21wdXRpbmcpLg0K
DQpUaGUga2VybmVsIG9mdGVuIGNyZWF0ZXMgd3JpdGFibGUgYWxpYXNlcyBpbiBvcmRlciB0byB3
cml0ZSB0bw0KcHJvdGVjdGVkIGRhdGEgKGtlcm5lbCB0ZXh0LCBldGMpLiBTb21lIG9mIHRoaXMg
aXMgZG9uZSByaWdodCBhcyB0ZXh0DQppcyBiZWluZyBmaXJzdCB3cml0dGVuIG91dCAoYWx0ZXJu
YXRpdmVzIGZvciBleGFtcGxlKSwgYW5kIHNvbWUgaGFwcGVucw0Kd2F5IGxhdGVyIChqdW1wIGxh
YmVscywgZXRjKS4gU28gZm9yIHZlcmlmaWNhdGlvbiwgSSB3b25kZXIgd2hhdCBzdGFnZQ0KeW91
IHdvdWxkIGJlIHZlcmlmeWluZz8gSWYgeW91IHdhbnQgdG8gdmVyaWZ5IHRoZSBlbmQgc3RhdGUs
IHlvdSB3b3VsZA0KaGF2ZSB0byBtYWludGFpbiBrbm93bGVkZ2UgaW4gdGhlIHZlcmlmaWVyIG9m
IGFsbCB0aGUgdG91Y2gtdXBzIHRoZQ0Ka2VybmVsIGRvZXMuIEkgdGhpbmsgaXQgd291bGQgZ2V0
IHZlcnkgdHJpY2t5Lg0KDQpJdCBhbHNvIHNlZW1zIGl0IHdpbGwgYmUgYSBkZWNlbnQgYXNrIGZv
ciB0aGUgZ3Vlc3Qga2VybmVsIHRvIGtlZXANCnRyYWNrIG9mIEdQQSBwZXJtaXNzaW9ucyBhcyB3
ZWxsIGFzIG5vcm1hbCB2aXJ0dWFsIG1lbW9yeSBwZW1pcnNzaW9ucywNCmlmIHRoaXMgdGhpbmcg
aXMgbm90IHdpZGVseSB1c2VkLg0KDQpTbyBJIHdvbmRlcmluZyBpZiB5b3UgY291bGQgZ28gaW4g
dHdvIGRpcmVjdGlvbnMgd2l0aCB0aGlzOg0KMS4gTWFrZSB0aGlzIGEgZmVhdHVyZSBvbmx5IGZv
ciBzdXBlciBsb2NrZWQgZG93biBrZXJuZWxzIChubyBtb2R1bGVzLA0KZXRjKS4gRm9yYmlkIGFu
eSBjb25maWd1cmF0aW9ucyB0aGF0IG1pZ2h0IG1vZGlmeSB0ZXh0LiBCdXQgZUJQRiBpcw0KdXNl
ZCBmb3Igc2VjY29tcCwgc28geW91IG1pZ2h0IGJlIHR1cm5pbmcgb2ZmIHNvbWUgc2VjdXJpdHkg
cHJvdGVjdGlvbnMNCnRvIGdldCB0aGlzLg0KMi4gTG9vc2VuIHRoZSBydWxlcyB0byBhbGxvdyB0
aGUgcHJvdGVjdGlvbnMgdG8gbm90IGJlIHNvIG9uZS13YXkNCmVuYWJsZS4gR2V0IGxlc3Mgc2Vj
dXJpdHksIGJ1dCB1c2VkIG1vcmUgd2lkZWx5Lg0KDQpUaGVyZSB3ZXJlIHNpbWlsYXIgZGlsZW1t
YXMgd2l0aCB0aGUgUFYgQ1IgcGlubmluZyBzdHVmZi4NCg==
