Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF2B711012
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 17:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241825AbjEYPwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 11:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241842AbjEYPwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 11:52:32 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65B61BD;
        Thu, 25 May 2023 08:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685029947; x=1716565947;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=as1KtnbbP95GMhC+Isj4LyQXmPIr9UTa8ZaoLXqtC1I=;
  b=NDvyeQHdhZan69pQhmSX+BEoirMDTzs0zffRR06DqPKo9qMdBRyaoE+5
   Y3CH8ubm7wy8qQ8w+iWvTcHQo7GC4zjGvpWMJVyRBGBUosh2+AdcISmHl
   yWgkR9A4DYy5wfkr3JRQqeAyATGfrx1znT+JU87y60rjY3lHfKNstU3GW
   D+JLK8OM1zIx8qCLy+t+JqDT3AX5OUTzqB6RshUdBC9MTJT7NTrp+jpZg
   2MUugBZ+hBoYnAjJ+lZfrzsXXBxYPMpHUfeH99g5v6ZxSg33F0Cl3ecxq
   b3L8TPYvrCzHVvTLyWJ3d1tGo6+dhiyLFxrswn+L0ZaePM3T7DwfF4lIm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="351439798"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="351439798"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 08:52:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="951498958"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="951498958"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 25 May 2023 08:52:25 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 08:52:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 08:52:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 08:52:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 08:52:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5wIxVIqBYcRBUzgUEPVY+c+nmr8Ek7Q1MDubKS8gNDKkXHmis5Z2OZUaXcWdAXDD7ga+j/gNjdKOgkLe0Mz6QLrB0dXzNzPDx9sAgwWXw7njjlVSNCszw+114Ro2q6RR3NA3DefG7EQ1DhgB7dBpPVJg7vRD3pfwDjvqh55Hxw+1wy2xcC5vLKzQdwwZOCSyXWABdD00vBF7133PrD7GkXXc8uw/8evEL2emV6MjII3qx0wuDc6p6gudAPSrMGCoMnfXvuuSLzhPJHXyohL41mY/wSPavcisD44J6XttKFKGOFVpV+RHHhxz411PRe0YJyha6sJXvXVBbr/zVf4lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=as1KtnbbP95GMhC+Isj4LyQXmPIr9UTa8ZaoLXqtC1I=;
 b=E1HSIIWuEjGVylzzB1ce7EH5+ytQ0N1+ajpNCtHsowyo/ik7aSZWpJQdPvFAfJH23gLpTiahEjqr+2dkKRYWx2GjhR3Le5V7NnixItYmiS2J/Y6WYPmcqFdWW7iFRZlTyttrSjIqgmNDKxEA1tpKbIMwns25fTudxCDHYJYG9wHI3S4RwSr1J8VWJqwTrAamR5SDUnWcSXXnEQrrZZBoQ0dS4ouyCAL25N+7HsjKhiTO+X3m3x9ebqzviur+PZVYn3js2rQaeCWIVdHzG9th7h7P/1a7mZATVWDKKIVxN/QDL5DwFAuDC9gBOIbJ2Nr4S4SA+rTf9WOk6oKsr5Ob6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6618.namprd11.prod.outlook.com (2603:10b6:303:1ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Thu, 25 May
 2023 15:52:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%6]) with mapi id 15.20.6433.016; Thu, 25 May 2023
 15:52:20 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "mic@digikod.net" <mic@digikod.net>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "marian.c.rotariu@gmail.com" <marian.c.rotariu@gmail.com>,
        "Graf, Alexander" <graf@amazon.com>,
        "Andersen, John S" <john.s.andersen@intel.com>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "ssicleru@bitdefender.com" <ssicleru@bitdefender.com>,
        "yuanyu@google.com" <yuanyu@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tgopinath@microsoft.com" <tgopinath@microsoft.com>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "will@kernel.org" <will@kernel.org>,
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
Thread-Index: AQHZf2Ve5xw6RDm4tUGLnlOpizAoCa9qHQcAgAEGdICAAB9/gA==
Date:   Thu, 25 May 2023 15:52:20 +0000
Message-ID: <7cb6c4c28c077bb9f866c2d795e918610e77d49f.camel@intel.com>
References: <20230505152046.6575-1-mic@digikod.net>
         <93726a7b9498ec66db21c5792079996d5fed5453.camel@intel.com>
         <facfd178-3157-80b4-243b-a5c8dabadbfb@digikod.net>
In-Reply-To: <facfd178-3157-80b4-243b-a5c8dabadbfb@digikod.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6618:EE_
x-ms-office365-filtering-correlation-id: ce685577-ebcb-4eba-34ba-08db5d3805fc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zw+G+vxJtZgVE+JD9lyX+QTOxcyrDQcg5ky6MmT9a2edwuoBvtxBn3wsJjjXWU9PhhmUOtrvQ0zScqzlawSriG2pI13yZPkzlBGpIPn/0BS5RUmQbSGbytp96RqQOzQ8jvqcr5oIa4mElKIecO2zaoAZTkQpe42WMKK5yx40ksnMG60/YNkDhTPFrI4pBtE0wNc6qnizJDLCf4b5+PKm043LmuGep/v9+yCfVMYX7/ZrpjIJU6XXUIq+D2LYkwkkrcpMRposdiefQVt/Fy7gemlf3l+8mYZebBl94TDr5ppeiNHtb3ipLc8y+KQDhq7/WVZLZL9/QgBH+hX4iwcw9zTxKOeeqDQgHfQbGIXBQDY+1tcdwC/GlTMUhSAoO2uNA/aWRbB2yVlH8L6h2CDu5GqF0XoEEHyx/h/H3cpZcsrPETE814K35MZB9y9Zs/+ODDFGK6SVxVce43nI+IcgHKBKjwyGAPzlMIM1wSpKY562PUWt1UGEHP+T1hA1lcq7JG9UxvLI4pFEJ9JIV7Hgpvb0mGc00e9X0vB1E9ai4hg0d1A2E/hpUQRiV8v+hPYX7xDJU/wQB3khEGTyfam4VEORI2PZshvblXBE2jPOV1HDbiHpYJx7o+mTcMrTWr38eXakF9HOSv6mKuz0/W1T1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199021)(54906003)(2906002)(7406005)(7416002)(5660300002)(8936002)(8676002)(110136005)(66574015)(91956017)(76116006)(41300700001)(66946007)(64756008)(316002)(66446008)(478600001)(36756003)(4326008)(66556008)(6486002)(71200400001)(66476007)(6512007)(86362001)(6506007)(2616005)(38100700002)(83380400001)(26005)(122000001)(82960400001)(186003)(38070700005)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ay9NajZoUmdOUlA0UFVMQTdHUHN2M2NVYTNSWk9mb051bHRWbzJrYm80RlQx?=
 =?utf-8?B?dDVTZk5id3ltdGdQc0lUMFpJb0YvcHJBQWRRbjhGYzREbzk2UE85TTlPYTVB?=
 =?utf-8?B?b3lIUU1aYUhUT2VsUkNmWU1xZkxFL1RMcWRROHlTZ1hZSW9qa050VGswdDE3?=
 =?utf-8?B?YUUrUzZXR3hIMWlBeTJoSFFuUGo4VzU2WDVJbXBnK2tNaENNTzBMS0VONWd3?=
 =?utf-8?B?em9CQmR6Vi93L0RiOGlrSFJBQk1adVhaZ1RVY3d3dVlKN2d0NXZESjdMYnVR?=
 =?utf-8?B?UngrYk1qOHRHa2dmZ2ViSEx3RDNhZzlOZEd0S01PUm9PSW9YZVN1TlIwOFBX?=
 =?utf-8?B?VElML3pJTURlb2R1QXh6bnRpQ1p2RHhsaDc4TzZZaGtOSHpMRWFQMER6a3FK?=
 =?utf-8?B?ckJCUmFFOWx0SlBzZkdTZ1RpMjNKbTZmMGdEWTlMUElMbjBhYkYxS2tpcVlp?=
 =?utf-8?B?bTJVWDBrSzdDZU8rVi9YV1BtSDVIVzJSOC9HRkNQdWp1UWZucnhDWXgweldv?=
 =?utf-8?B?cWtrdnFqdDc5VnA4UmFmeFNQYU1URnlYWVFjVUkwV0xLWWZRTHBUS25Hek1i?=
 =?utf-8?B?RFlwZ3R4NVZKZ1VUeSs0Mzh0N0pONUxSeXpRcVdPdmZDTVNNU25ZemliTnIr?=
 =?utf-8?B?b3ZYcXhlOFdlT2tXYWZHOGc5cmk4dDlLOVd4QndwOS9wbGlmNThNUlNHRTNI?=
 =?utf-8?B?N2lOVlBLRXhLK2hxWkJWY3Brb1VGYnFoaTBOZjlDeThCSUR5TkZtSVltUEFw?=
 =?utf-8?B?bjRmVXBPaHdpODFmc3NZZ3NMRWhhUzI0YkhTVmhMU2NWdjlwMFNGWTdaSWVY?=
 =?utf-8?B?b0w4anRRY3pZcDJwVDhNYU8vT3BRTHJORTVwcDM2VXhFTEdrSnMvQVJBZ2Yr?=
 =?utf-8?B?WTBXa1M2MnJIcXhsdHkzY2hUdTlPRUh0K1lJNnJEVEQwTDVHbFB4bDZ2WXlr?=
 =?utf-8?B?dXZkb2xKcHFHaDlJK3VTdTRhNUhpVkdlQURPS29EU3pveXZIN2N4U0J0NmdM?=
 =?utf-8?B?d3JINjNDWnNHR3o2YnB5ZThVeHhpTis2dys3USsrckliUzJhUDlrR1Q4ZlFo?=
 =?utf-8?B?dml6WjB5eGlVR2JNcEhSRDZqTWF1YjRPRVdnbDZwcS9rRkVNMmdBT00yWVAr?=
 =?utf-8?B?OTNHd3h6TnJqRXFPRkxrTTg2SStZa1E3QmpZUHFJd0gxTnN2MjBSQUoxSFVL?=
 =?utf-8?B?b2RrRXFSRU1mVVZ2M3NLMFJ5SFdySGp3OHdSVmgrRWtUWCs4OTl0ZFBqME83?=
 =?utf-8?B?VGRDdkhRM0M4dkY2RXJZSjM0M3dRRXRuMGJHZUp5Si9qS25NWVVOemY3QzJ1?=
 =?utf-8?B?NWh5NWR2OXVPRFpvYW9iNzNkam1DRzN5T3JGSENaS2ZTa3BKeEtrOW1NdExh?=
 =?utf-8?B?WTVHL05WbUp5QzN1SFB1SkR6NFdjZjA3R3gzVFAyZXlQVFBKaVU3NmhXK0RF?=
 =?utf-8?B?NjJEUGRBSVd1Vml2NjFsWG1WM2FUZlNzTkpSdGNNdG9JVHZTaHZZdzNPZjE0?=
 =?utf-8?B?YXZOV3ZFbXY0ejdsTUJVcU9zc2c1ZjArL2NETDBwV2J4Si9NV1pHbUVHKzJU?=
 =?utf-8?B?SHZTUW8zTDFEV2p4YkZDYm03R0RPbHNwOXJ4MzdYSnN3b3VQejBzMWFaSlpx?=
 =?utf-8?B?Q2NKblpFbmRVS0RMK2EycHN2S1MxRkw3ZzlDbU9lRlBoOUxLaktvUGRjVzRE?=
 =?utf-8?B?Y2pNZWxkekI2b1h6bFVQZnBnTTNBR1p4bzI4T1o0RlIyUk9ZaWVFeUZmRk1q?=
 =?utf-8?B?bDRlenBoSG5KaXpYWUZzYnJldDgzdUxFUU9CdnAvaVU1dG44VGp5aWJncCsr?=
 =?utf-8?B?RlJpZElXSnVqTVQySWltVVE1M3g2bktSa3UvOXhPcGlaRy9odlVvUzhNWFI1?=
 =?utf-8?B?Y25HMDVwRkNrVDJEUmJaQ1ZvdkJjQm1WYzQyL09wQm5KbzY5SUs2aTJGUUI5?=
 =?utf-8?B?RUxCdnJOaUFpSDVlTmE0TitSTkk3QmhickNHUjBiZzFJekNzVERETTkyN0Fk?=
 =?utf-8?B?bmJvc0NOZzhDTEtMUEdVMGV3Mm5kRUtUYlZMRnZBbkcvSUFCdm1OSmVlU3BW?=
 =?utf-8?B?UythTHFtVTJzY04wd2hFYkRGckhDbFQxbzdJcTRoWHBIWGZEb3V3SUhIT2Q3?=
 =?utf-8?B?MG5FclkvNUlTWXBQOCs3QWJDYWZtQkw5L3VXU0YyV1ZzL2wwVjM1NlorQmM2?=
 =?utf-8?Q?kYGLIR0EAFcb5EHq6zuF2rU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EF2B76737B290498C4DD414B74D2308@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce685577-ebcb-4eba-34ba-08db5d3805fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 15:52:20.2873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ML/7gl4eUsJIkM/yFhJg7UrfALPFIG4jNjwO9UKK6ZXldoDIFYLRd3LjUHMn5elkdNg9kZW2WIjFAXfGWPSJQg0BELqzIevKozO7hYwOh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6618
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA1LTI1IGF0IDE1OjU5ICswMjAwLCBNaWNrYcOrbCBTYWxhw7xuIHdyb3Rl
Og0KWyBzbmlwIF0NCg0KPiA+IFRoZSBrZXJuZWwgb2Z0ZW4gY3JlYXRlcyB3cml0YWJsZSBhbGlh
c2VzIGluIG9yZGVyIHRvIHdyaXRlIHRvDQo+ID4gcHJvdGVjdGVkIGRhdGEgKGtlcm5lbCB0ZXh0
LCBldGMpLiBTb21lIG9mIHRoaXMgaXMgZG9uZSByaWdodCBhcw0KPiA+IHRleHQNCj4gPiBpcyBi
ZWluZyBmaXJzdCB3cml0dGVuIG91dCAoYWx0ZXJuYXRpdmVzIGZvciBleGFtcGxlKSwgYW5kIHNv
bWUNCj4gPiBoYXBwZW5zDQo+ID4gd2F5IGxhdGVyIChqdW1wIGxhYmVscywgZXRjKS4gU28gZm9y
IHZlcmlmaWNhdGlvbiwgSSB3b25kZXIgd2hhdA0KPiA+IHN0YWdlDQo+ID4geW91IHdvdWxkIGJl
IHZlcmlmeWluZz8gSWYgeW91IHdhbnQgdG8gdmVyaWZ5IHRoZSBlbmQgc3RhdGUsIHlvdQ0KPiA+
IHdvdWxkDQo+ID4gaGF2ZSB0byBtYWludGFpbiBrbm93bGVkZ2UgaW4gdGhlIHZlcmlmaWVyIG9m
IGFsbCB0aGUgdG91Y2gtdXBzIHRoZQ0KPiA+IGtlcm5lbCBkb2VzLiBJIHRoaW5rIGl0IHdvdWxk
IGdldCB2ZXJ5IHRyaWNreS4NCj4gDQo+IEZvciBub3csIGluIHRoZSBzdGF0aWMga2VybmVsIGNh
c2UsIGFsbCByb2RhdGEgYW5kIHRleHQgR1BBIGlzIA0KPiByZXN0cmljdGVkLCBzbyBhbGlhc2lu
ZyBzdWNoIG1lbW9yeSBpbiBhIHdyaXRhYmxlIHdheSBiZWZvcmUgb3IgYWZ0ZXINCj4gdGhlIEtW
TSBlbmZvcmNlbWVudCB3b3VsZCBzdGlsbCByZXN0cmljdCB3cml0ZSBhY2Nlc3MgdG8gdGhpcyBt
ZW1vcnksDQo+IHdoaWNoIGNvdWxkIGJlIGFuIGlzc3VlIGJ1dCBub3QgYSBzZWN1cml0eSBvbmUu
IERvIHlvdSBoYXZlIHN1Y2ggDQo+IGV4YW1wbGVzIGluIG1pbmQ/DQo+IA0KDQpPbiB4ODYsIGxv
b2sgYXQgYWxsIHRoZSBjYWxsZXJzIG9mIHRoZSB0ZXh0X3Bva2UoKSBmYW1pbHkuIEluDQphcmNo
L3g4Ni9pbmNsdWRlL2FzbS90ZXh0LXBhdGNoaW5nLmguDQoNCj4gDQo+ID4gDQo+ID4gSXQgYWxz
byBzZWVtcyBpdCB3aWxsIGJlIGEgZGVjZW50IGFzayBmb3IgdGhlIGd1ZXN0IGtlcm5lbCB0byBr
ZWVwDQo+ID4gdHJhY2sgb2YgR1BBIHBlcm1pc3Npb25zIGFzIHdlbGwgYXMgbm9ybWFsIHZpcnR1
YWwgbWVtb3J5DQo+ID4gcGVtaXJzc2lvbnMsDQo+ID4gaWYgdGhpcyB0aGluZyBpcyBub3Qgd2lk
ZWx5IHVzZWQuDQo+IA0KPiBUaGlzIHdvdWxkIGluZGVlZCBiZSByZXF1aXJlZCB0byBwcm9wZXJs
eSBoYW5kbGUgdGhlIGR5bmFtaWMgY2FzZXMuDQo+IA0KPiANCj4gPiANCj4gPiBTbyBJIHdvbmRl
cmluZyBpZiB5b3UgY291bGQgZ28gaW4gdHdvIGRpcmVjdGlvbnMgd2l0aCB0aGlzOg0KPiA+IDEu
IE1ha2UgdGhpcyBhIGZlYXR1cmUgb25seSBmb3Igc3VwZXIgbG9ja2VkIGRvd24ga2VybmVscyAo
bm8NCj4gPiBtb2R1bGVzLA0KPiA+IGV0YykuIEZvcmJpZCBhbnkgY29uZmlndXJhdGlvbnMgdGhh
dCBtaWdodCBtb2RpZnkgdGV4dC4gQnV0IGVCUEYgaXMNCj4gPiB1c2VkIGZvciBzZWNjb21wLCBz
byB5b3UgbWlnaHQgYmUgdHVybmluZyBvZmYgc29tZSBzZWN1cml0eQ0KPiA+IHByb3RlY3Rpb25z
DQo+ID4gdG8gZ2V0IHRoaXMuDQo+IA0KPiBHb29kIGlkZWEuIEZvciAic3VwZXIgbG9ja2VkIGRv
d24ga2VybmVscyIgOikgLCB3ZSBzaG91bGQgZGlzYWJsZSBhbGwNCj4ga2VybmVsIGV4ZWN1dGFi
bGUgY2hhbmdlcyB3aXRoIHRoZSByZWxhdGVkIGtlcm5lbCBidWlsZCBjb25maWd1cmF0aW9uDQo+
IChlLmcuIGVCUEYgSklULCBrZXJuZWwgbW9kdWxlLCBrcHJvYmVz4oCmKSB0byBtYWtlIHN1cmUg
dGhlcmUgaXMgbm8NCj4gc3VjaCANCj4gbGVnaXRpbWF0ZSBhY2Nlc3MuIFRoaXMgbG9va3MgbGlr
ZSBhbiBhY2NlcHRhYmxlIGluaXRpYWwgZmVhdHVyZS4NCg0KSG93IG1hbnkgdXNlcnMgZG8geW91
IHRoaW5rIHdpbGwgd2FudCB0aGlzIHByb3RlY3Rpb24gYnV0IG5vdA0KcHJvdGVjdGlvbnMgdGhh
dCB3b3VsZCBoYXZlIHRvIGJlIGRpc2FibGVkPyBUaGUgbWFpbiBvbmUgdGhhdCBjYW1lIHRvDQpt
aW5kIGZvciBtZSBpcyBjQlBGIHNlY2NvbXAgc3R1ZmYuDQoNCkJ1dCBhbHNvLCB0aGUgYWx0ZXJu
YXRpdmUgdG8gSklUaW5nIGNCUEYgaXMgdGhlIGVCUEYgaW50ZXJwcmV0ZXIgd2hpY2gNCkFGQUlV
IGlzIGNvbnNpZGVyZWQgYSBqdWljeSBlbm91Z2ggdGFyZ2V0IGZvciBzcGVjdWxhdGl2ZSBhdHRh
Y2tzIHRoYXQNCnRoZXkgY3JlYXRlZCBhbiBvcHRpb24gdG8gY29tcGlsZSBpdCBvdXQuIEFuZCBs
ZWF2aW5nIGFuIGludGVycHJldGVyIGluDQp0aGUga2VybmVsIG1lYW5zIGFueSBkYXRhIGNvdWxk
IGJlICJleGVjdXRlZCIgaW4gdGhlIG5vcm1hbCBub24tDQpzcGVjdWxhdGl2ZSBzY2VuYXJpbywg
a2luZCBvZiB3b3JraW5nIGFyb3VuZCB0aGUgaHlwZXJ2aXNvciBleGVjdXRhYmxlDQpwcm90ZWN0
aW9ucy4gRHJvcHBpbmcgZS9jQlBGIGVudGlyZWx5IHdvdWxkIGJlIGFuIG9wdGlvbiwgYnV0IHRo
ZW4gSQ0Kd29uZGVyIGhvdyBtYW55IHVzZXJzIHlvdSBoYXZlIGxlZnQuIEhvcGVmdWxseSB0aGF0
IGlzIGFsbCBjb3JyZWN0LA0KaXQncyBoYXJkIHRvIGtlZXAgdHJhY2sgd2l0aCB0aGUgcGFjZSBv
ZiBCUEYgZGV2ZWxvcG1lbnQuDQoNCkkgd29uZGVyIGlmIGl0IG1pZ2h0IGJlIGEgZ29vZCBpZGVh
IHRvIFBPQyB0aGUgZ3Vlc3Qgc2lkZSBiZWZvcmUNCnNldHRsaW5nIG9uIHRoZSBLVk0gaW50ZXJm
YWNlLiBUaGVuIHlvdSBjYW4gYWxzbyBsb29rIGF0IHRoZSB3aG9sZQ0KdGhpbmcgYW5kIGp1ZGdl
IGhvdyBtdWNoIHVzYWdlIGl0IHdvdWxkIGdldCBmb3IgdGhlIGRpZmZlcmVudCBvcHRpb25zDQpv
ZiByZXN0cmljdGlvbnMuDQoNCj4gDQo+IA0KPiA+IDIuIExvb3NlbiB0aGUgcnVsZXMgdG8gYWxs
b3cgdGhlIHByb3RlY3Rpb25zIHRvIG5vdCBiZSBzbyBvbmUtd2F5DQo+ID4gZW5hYmxlLiBHZXQg
bGVzcyBzZWN1cml0eSwgYnV0IHVzZWQgbW9yZSB3aWRlbHkuDQo+IA0KPiBUaGlzIGlzIG91ciBn
b2FsLiBJIHRoaW5rIGJvdGggc3RhdGljIGFuZCBkeW5hbWljIGNhc2VzIGFyZQ0KPiBsZWdpdGlt
YXRlIA0KPiBhbmQgaGF2ZSB2YWx1ZSBhY2NvcmRpbmcgdG8gdGhlIGxldmVsIG9mIHNlY3VyaXR5
IHNvdWdodC4gVGhpcyBzaG91bGQNCj4gYmUgDQo+IGEgYnVpbGQtdGltZSBjb25maWd1cmF0aW9u
Lg0KDQpZZWEsIHRoZSBwcm9wZXIgd2F5IHRvIGRvIHRoaXMgaXMgcHJvYmFibHkgdG8gbW92ZSBh
bGwgdGV4dCBoYW5kbGluZw0Kc3R1ZmYgaW50byBhIHNlcGFyYXRlIGRvbWFpbiBvZiBzb21lIHNv
cnQsIGxpa2UgeW91IG1lbnRpb25lZA0KZWxzZXdoZXJlLiBJdCB3b3VsZCBiZSBxdWl0ZSBhIGpv
Yi4NCg==
