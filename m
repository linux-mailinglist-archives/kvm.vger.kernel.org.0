Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DBF7A9DD7
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjIUTth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjIUTt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:49:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC97D64590;
        Thu, 21 Sep 2023 10:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318615; x=1726854615;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iya22aIXqo9qxoYt/F43jMnOU1MX3WL2D2CN7UrXIq8=;
  b=bcvLndrKt3r42gXiSli2mo6FBIv6mNb813jEFlUGUD0XF2f4wGig80ao
   eR+0I6cvZMXIxZ5wsqWWQQbF2LdFFn8vWQDK19c2jZ8Xo6/JT4DNck7ut
   dZ2vwqCUNVun+TM18jDEdHxaA9h4cJsUeVUs83OHRN12kl6y0nqJ4gSVi
   ftVkVNwFbaCguG3/ZruvHsVHR+TKwbhNPjdteYBN/VTcWCWlSWR7TUgrt
   xiuUhe8oDSUIh5xmQWmqwOWc2ZIwFoYBRMcNRU9K+6yZRqMVlNbMk2gy6
   Ry9zt25FMB/MzVBPKKFqikDue6ghivgjJCigo1VdFKbCV7TbPAwb6gUzH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="384274172"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="384274172"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 23:24:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="920605779"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="920605779"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Sep 2023 23:24:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 23:24:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 23:24:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 20 Sep 2023 23:24:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 20 Sep 2023 23:24:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+ADQZvj06NmFt7nxcpFMejj02AEPumvM3eKz4qKe/HPSJkPyWiFrvml4+3J2zdLo30lv/3Q/xQVdk+PTwo4b3xkXOg8vvCMPiJJMwYzIVCwEJpEFKhtASQVKnEAQpysiOvh4ldYWmC4MuxFqVgO08Hcwugf5tOgIhIMqvrSQfbuG66jPHIUqpNkh5pX5TqdTZFd8AjM/MzGShYJBNDd822E8Loa4IZCEXJviBGN11o61n7wLWdpSDVobA+QNF8bHlPcTr2hWYlVUghB2r3epH+78zWqigM7q/7aY9JTTMkmS5fX7dzAKVJInBSIpOAiczROp/54v7WAK75FDyOlpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iya22aIXqo9qxoYt/F43jMnOU1MX3WL2D2CN7UrXIq8=;
 b=i8fB2Czyl5aCgEUQFVvLg28lDFzPJKFDzkaMSJAAFPFg27bU8GT8IXwXM4TwQJjhC+H+3PkKhmdTAsK940hy1xek4t+krOBkKN5YzH3QsvVVUjeEIkJLd76QT9l+XdQBhBmR2uun8/zlPp35vAgXY79OiGaETGesCdOQvN1IMEWz4Zj0N7bSPvhbzKSu6+P6hG95hQ62qNticpsvNczTdPYe1qWVPtGhsPl64rT8sT6ScnIlbE0SJ7GeSBnU6LNTK5Upf8D6vxi3Z7xhaXzWk0ydPbQ5dQB0ljkDzLcIv+9bU51t1tAyzlk6xHUHcAcSpS8Rywk8IjOt7kYOES3Rdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH0PR11MB5252.namprd11.prod.outlook.com (2603:10b6:610:e3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 06:24:04 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%5]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 06:24:03 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Nikolay Borisov <nik.borisov@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 16/38] x86/ptrace: Add FRED additional information to
 the pt_regs structure
Thread-Topic: [PATCH v10 16/38] x86/ptrace: Add FRED additional information to
 the pt_regs structure
Thread-Index: AQHZ5ss6vttMEsm+OUmXJJK/yPurx7AjtmQAgABJenCAANZqAIAABEEw
Date:   Thu, 21 Sep 2023 06:24:03 +0000
Message-ID: <SA1PR11MB67340B4A2473585039129129A8F8A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-17-xin3.li@intel.com>
 <336f77d6-1d94-d2b7-f429-855bfbc3f271@suse.com>
 <SA1PR11MB6734182B172E9204CD11688CA8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
 <587bcb4e-dc09-4c89-3c8d-ab2b7b75e40e@suse.com>
In-Reply-To: <587bcb4e-dc09-4c89-3c8d-ab2b7b75e40e@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH0PR11MB5252:EE_
x-ms-office365-filtering-correlation-id: bd939e1d-4276-473a-f1d8-08dbba6b5a0e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gA3yuQ/5UHJSG7BcZ9lzzSFQFriiP9/i6duWo76sKvK77XongWP27EVIAjJw/iSKpF1K2RCebVQULFJIUmKXZom7LtkdeGoTgU/NQJCFndrIBBGDOKIDtv3vM88qm5qTNkKxh4qZQgDPv04J1ApbcolIabEzJbnLJXadLSV+IITg774V1dFHl1iX8a/4ax8fOLvLQ7EfW1uhEPQYeIyxIcsuB9ocV/z7D1Ou0swoZuxDkXnctZ+WmxUHw0/1BTJJ2o+wj9nJ41m0Ym7zMhiIbWuEHGx/V2GpQ49gtkafsooHn0aqaCGtYFnhzOMvZ/TUEvUIXc9oZcRSC0F/pYQXEFTjYd1rAxcvfU82FBEaR6L+yJl7N/obKrm9yXrgn93EtTXiNQ2aBUFTwm/D3gRGWzoHsk/NeLTsTdEKaPCGn7klqWtFzc4ddZjIYRCfaZb/Pzrsd8z7iLsmKpIKSX4nIJ+RrKpqXxdl5syrmOofvAfhFqnQq+3lCnVz6OoI4wg1KY45p7wVKZun8aPQ8iLWzPg1vzez2Oicg9kQqWmIZXsFH6Zce8z+uQCCvhtRKpjwi74PPF4nMoKjVz+OlvkdPI6Z5cgWXAwfclkE61tAo8jNia6v1BeloZcqXoaU6gye
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199024)(186009)(1800799009)(2906002)(5660300002)(52536014)(55016003)(26005)(54906003)(66476007)(66446008)(64756008)(7416002)(41300700001)(316002)(66556008)(66946007)(76116006)(110136005)(8936002)(8676002)(4326008)(478600001)(71200400001)(6506007)(7696005)(9686003)(38100700002)(122000001)(33656002)(86362001)(558084003)(38070700005)(83380400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEY1MGYrT0lxYjVlRXdZTUV2TUJTelBlblZUZFo1RERzMzBsYWxEdllXOXNV?=
 =?utf-8?B?L09ZcGo0S0YwM2x6RWF0aGJLWGVmaXVYN0lSNW1QSEFvZDRKNi9YUlVadDNE?=
 =?utf-8?B?d1ZXNHIvSmp1a3VOdnF3cDYxeGwySFh5OWkyWnNJNk5DOHZKQ1dCTC9YZDEr?=
 =?utf-8?B?aWE4WmsxTDhESGpicHVpRCtKRVBFMHBYVXBnc3hqUFlkelVmSTR5UVo2b1Fo?=
 =?utf-8?B?V2NCRXJqMGZiZzZyd1pGemMwcFA5YWhBL2E5STZsVERMcjRkZW45K2tsNXpj?=
 =?utf-8?B?WUYrK0o1b3N4cldSRVdUaU10UXpueDM4RGQ1R0JWdEZteDBWTmZhU2xGSm10?=
 =?utf-8?B?UkdQTVpDQ0pPbVBMMUhDWWJnQzV4SjhMZzdMK3REWHlRYndYNFJwL0owMCtu?=
 =?utf-8?B?NkNiMmRqeHpNaTFsa0VOWUZaSE1kRWl2Tml3N2ZUWTB5OEpUOU9tRVRVNXdw?=
 =?utf-8?B?MVdiM3BlZC9TVkN0dm1Rc0JKeXBzMXVUL29Kb0p6c1JQVFRINWgwZ0RpSGl5?=
 =?utf-8?B?anZlTmFsUVE3Q3hGZExObzlJWWxJYmhLb09NM1NpUHBZMG5VbnZSSytkWFVl?=
 =?utf-8?B?eHdhRXRkSDNZbEpxTU1wd1FxUTZVeFF3Wm1rN0tjTXhIOUpnNlNXUmRMbnJH?=
 =?utf-8?B?KzNEZ21CeUdmODh5NUFtaUpnZGhvVFk5N2g3OHBrME0waGZ6ZGxSTlpKSWY2?=
 =?utf-8?B?d1ZrT2c5WmxQRFBiWTl4djVRRlZnMmN2NHRQbkpZaXhRREhFQlJxRlhEQXdn?=
 =?utf-8?B?ajFrenp1SngydXNpdFhvdVcwQXJ3bVZsM29ES0ZEeGlFYnlFRTAzMGl3bDFu?=
 =?utf-8?B?Tmp6cGI5eDdHQWJHV1kzL2I3R2FkUFo0cHhISENwajVjMUdiUUl2S2h4TjN0?=
 =?utf-8?B?N1dydzg0RVRPZzJqdWh6ZU5vR0hYMlFSSVR5NnM4T003TFcvM09jMkIvczhi?=
 =?utf-8?B?andpdkZnNUJTOS9DY01FZVR5MFR4a01CcWhjOFRmT2o2UjhMWnhsWlF5R1hN?=
 =?utf-8?B?QkUrMDNmQ2FKbE9iTGdPOExUVXo4MVBIcXBYK2REZ0hnU3F6bFE3ZVl5N3ov?=
 =?utf-8?B?NE9aYUZlVXZBSjUvR0RvNmpqTmU2RjRvb2xYRCtRYXpOYmd6K0hRaUVyTEdm?=
 =?utf-8?B?MzZkd29mSTlhWWpZeUx5TGQzNm9hc0RpSkZxL3hUY0pIUUdRVlNCZnhwNzNa?=
 =?utf-8?B?VVNoZWhRMzJrQ0c4ZGcwK1FEeUh2T1V6YWxkek5rMlNlcmZBbTJzcEdRTWtI?=
 =?utf-8?B?dklxOGlMUTRIbWRUekVSOWt6MzROblRQWFZnTk4yaS9aYmJuVWpCV2UwNzBs?=
 =?utf-8?B?anhpMjRkTG1SbVNHbkZjTEZCcjdqOGg2cEMzRE1yUUpOcDFHVW9yZCtqRG8y?=
 =?utf-8?B?cmxmWXBCL3YxSitBcjNwUHhVTDJmeVduaU5EOHJLWmYxTk9obTBucmdVblhs?=
 =?utf-8?B?NnIxS011VWFoRG03UjRwZ25kYU5hYUJrR1BWZm9Pc1hPRXhHSjFpa1NRYkd4?=
 =?utf-8?B?VDFEN2poTUJqelVOTHNoSGs2T2tQZEY3dzhjNWlrbU9SZlczUW1zQmdGNjVZ?=
 =?utf-8?B?S0JtdFExU0tNbXVabDd0S0p2QkZDYTJJSjN2eUxabVNKNlBVNjI2MURQakdI?=
 =?utf-8?B?aWwxZW1lc0dTcTdMeXhmOGlmZWNMd0RqMHpEUWd1cG5ITS9UYmRkSnBKN0RS?=
 =?utf-8?B?aEo5UVEvaTNnUWk4YXBrVnhxTGw5WTdvTlpXblF2TS91RmpKVmpsUUlycXZZ?=
 =?utf-8?B?RW9Cak55OVZTelZRQnBPYmYvQ3QvR2VnT0VOSUhOK1NtNlZHSDJsQ1lwK2Zs?=
 =?utf-8?B?Vk0vK20rc0xLWWwyU2oyQmQvSTJ0dlBVL3FWQTBiZjd0SEcwNXUxNW9uUFQ4?=
 =?utf-8?B?MWNodE5KUVhTMW1SM29mc3R4RWM3dTRxQWE2TG8xU2xReW1GN0ptVTBDMkhD?=
 =?utf-8?B?T0lKaFhaVVFCcjBlU01RYUpUUnU1OHVTYXdHL1pUNEx0S2UxTW9sT0hkd2lj?=
 =?utf-8?B?ZTZHeVpCa2ppc0Y2a0xCNit1Z1hBQ05la1loc2R3Vm1SUldkVjg3MS9vcTlO?=
 =?utf-8?B?MzcvU0Z2MS9OektNbmhNQnBTZ0lwRE9aTlNOZkp5ZmREZ3I2bktwMHErUkNW?=
 =?utf-8?Q?hC7I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd939e1d-4276-473a-f1d8-08dbba6b5a0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2023 06:24:03.7682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vRttKikSvq5+c0cI7K4SKwVdekcLXiLauau2DaAmsaeYxTQGCov5HSxbmBGBHpvq/Lqt0Ndox+tmGKXyPihXRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5252
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IEkgZ3Vlc3MgeW91IGhhdmUgRlJFRCAzLjAgc3BlYywgbm8/DQo+IERvaCB5b3UgYXJlIHJp
Z2h0LCBJIHdhcyBsb29raW5nIGF0IHRoZSB3cm9uZyB2ZXJzaW9uIG9mIHRoZSBkb2N1bWVudCAu
Li4uIHNvcnJ5IGZvcg0KPiB0aGUgbm9pc2UuDQoNCkFjdHVhbGx5IEkgYXBwcmVjaWF0ZSB5b3Vy
IHJldmlldyBzbyBtdWNoIQ0K
