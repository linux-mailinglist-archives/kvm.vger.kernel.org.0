Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41936B6104
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 22:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjCKV3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Mar 2023 16:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCKV3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Mar 2023 16:29:38 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A869E3C7B9;
        Sat, 11 Mar 2023 13:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678570177; x=1710106177;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lYccMTi4riqdGB9EDqSrIEw4B83PyNKGp7P5bZcbV6w=;
  b=SR33prRT6hw1IiCJ0bQUW1R4ITNv66d16H97f9h84LJe7L9h4YFmuTiT
   x4/K/LQ4LeCHcV+uGEAxNlYhbn+oWI/GoRxWBfVUdbI4ayVKT8GmJ2lDq
   +MM4S+vPBUeQIzjXsHzw2TZKV0b3Z0YiZvQzuxEXlRTbEHDHm52Q5VMzO
   dOWdstsWK6on7YdyFljOF+dKeNc4WEGWbDtzhfAacyYEnSXwUiEHbF8DT
   8IAjTcPhAT/9FTnNvNzRIyhTz3wGgQxxuNvyZLjgRSGKAE+1qQR6/BGSg
   RBBL08Mg2locSoj6lyJIAmQNbClVIKeAgIdDtVLSKycj+HwOIQvbeupwI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="317330354"
X-IronPort-AV: E=Sophos;i="5.98,253,1673942400"; 
   d="scan'208";a="317330354"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2023 13:29:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="710676021"
X-IronPort-AV: E=Sophos;i="5.98,253,1673942400"; 
   d="scan'208";a="710676021"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 11 Mar 2023 13:29:36 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 11 Mar 2023 13:29:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 11 Mar 2023 13:29:35 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sat, 11 Mar 2023 13:29:35 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sat, 11 Mar 2023 13:29:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G88KwzhQcOq2bC2KV/O3Jwc+LjTz3AklB72kZneq26W3mJFQchdp1faqSyrdUntxNErzVnJ3CwP9FAz+F1C+tX0Y6gE7/r72qnuRKY/1aBxgWpgOG2DT5AolsVFOZcrGqflHK9CrJQiFgiRhlPzbfJ5lZgtpmE6Jaiue8C6Nbxze2PM3LPNZYim0n4zjUqpJZYqYUOexCDQ5XIeMBaoY8/JBLt6Ze3LlNJaSCF2QzN/6vepb6NqxFqipvwZOCri6+AABj99JHx1gMH0GC4M2baQtgKwlMHwIZOfb0x10IL39+IHoc+VVzM4DFDiO1WAuEfUzHMsspMP+jsR23KIwPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYccMTi4riqdGB9EDqSrIEw4B83PyNKGp7P5bZcbV6w=;
 b=K1mQPbdxYO3T5uDqP/ELmgV2KEqMB0Ge+U03VpEqW9yjsgeQ74XDIpLXikFA7JOjmxyUHs3TMneU6IHV2xms+EW7B9k3IY5cZVFXHKCOIehqA6tmnlstGeYuy6aplCvJhf5T2w1oqmuJGCgXsiZNdVi8culsCKAMuoyoQzEYvTbu91AgN7xOWpcvgXoL9jmGlWlS0UomYFVdYpgpANtNzO2G/oNYCKwJBDBWYiZdY0B4669mTt21ybZ/Xs7nQaGFr43hVt+jn2wkjUXv1M3gQeOUjRqf5P+ORnkUAiPBkUthdEJzQoT4GVeJCIEzDxrBxVQ0cwzjN7Mx+d7uv/U5Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH0PR11MB4776.namprd11.prod.outlook.com (2603:10b6:510:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Sat, 11 Mar
 2023 21:29:34 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.019; Sat, 11 Mar 2023
 21:29:33 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Kang, Shan" <shan.kang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 00/34] x86: enable FRED for x86-64
Thread-Topic: [PATCH v5 00/34] x86: enable FRED for x86-64
Thread-Index: AQHZUKGtEiPr5jtjrECPbJnYmBRDsq71XseAgAC+rvA=
Date:   Sat, 11 Mar 2023 21:29:33 +0000
Message-ID: <SA1PR11MB6734CD5D93F411EA5D701265A8BB9@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <1df9a4abab08677e7fcb20eff1306b080044836a.camel@intel.com>
In-Reply-To: <1df9a4abab08677e7fcb20eff1306b080044836a.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH0PR11MB4776:EE_
x-ms-office365-filtering-correlation-id: 37256d1f-5386-4905-e45d-08db2277b507
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8KCJxy5yPPHBgjuQPRNN9k/3G1YatvEQYTFBFX1S2up0e2tGZrFoSMNkOEKB4u2Rd4cxHDJ8nuLNRh6xtMcxYl5hKoDeD4J4Kq3VUsi3N+cSMf9XrDLewQon0FCd/qrV2yWiaMb4chUo9XliEWtqaSrq5PMedWRv6P7MnB3Tc7rsophqzmSMJX4jLcT8+YdSLoV8iLesP/GWbo4K6liHem2SeJtrnKPNNyDlyYShF0hUqIx3H0kAo3ZaQmXAhjizbfVT8LZN7sv885C9Vh+zvFR1PZcdorYfFu61JKXPVl62SJGymjiBIf/ooBnMhPHLbKZe39N0zn7c5kuJRaH/mYRmlmHKl5+1/xpyBsG1AE0jCEcohsjTTmJ7NO9m/cHWZIksWjneGhYUzBw/aXdnRPwDs0XQYVKrVru15gyvo9rwYQfjsZmqCba6kFXR/yOPqta9ys2BG971eieAkVs4QcDDBT3qoWWf3RYNBUHSj3GxCIS6XEbTQuWq/xWpjpHSSZc5tsWE/Zk0plzgjmC1FAi955vt2Q3QBvDMPXCoSmP/5iQNY7jwfPv5x18LUh0jmg2lU2TUdQcoSYNOKP5f43GoPLrS3u9cTe+KDu+MbJqvSMp1Cpzgk5Tc05r3UttLOK6Ni8S57LPcZ6A2cd9R17nqJ5fi9ckVL6MTsXKjx5aHTQA0vX2ygu0fRfSZO3Ed
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199018)(83380400001)(41300700001)(316002)(76116006)(64756008)(66476007)(66556008)(66446008)(8676002)(4326008)(110136005)(66946007)(5660300002)(478600001)(33656002)(52536014)(54906003)(8936002)(82960400001)(7416002)(38100700002)(55016003)(186003)(966005)(7696005)(2906002)(71200400001)(122000001)(86362001)(38070700005)(9686003)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGU4VHNyMnozanlkQzAzYTdtV2dZZ2MvREhnUnlRU2FzVkhEZEREVDU5SFhJ?=
 =?utf-8?B?L3l3Yk5YazFxZ1JHeHh4VzdsdUtMbkdOSFNqT083TGU3MFBlYUdHb3dDK1Bk?=
 =?utf-8?B?RURMYlc1ZkI3cFk4UmhBYTYwZk9iSEl3cXR2TUE1S0NWUi9NL2pYMzdHTGpj?=
 =?utf-8?B?RkUrL1dOZGZOUEwvU0FjN0l1NzQxbmpkRzBCWldBSVBZem03TUJQKzhJSXFn?=
 =?utf-8?B?U2U0bUtncHNUc0ZTNzBGekRiUkVta1c4WWZBdXVUZlJ0MzFLZHpwZ0grcUNZ?=
 =?utf-8?B?K2lIVTAzYnNsSTJzdE9WVTlNeU9SbW9yR2FjVW5nU3lSblduU1U1bkZNMmto?=
 =?utf-8?B?OHAxUzRNZnpuWDRadURBNXlaa0tDWTI4VFQ3dzFia3BOaHV1VVozY3pVakp0?=
 =?utf-8?B?N0xJMDBkVVkrVjZDYTNwWElLcFNZaHVYWXMra0t3Vm9pZ1NiMGdKVk1EaGVu?=
 =?utf-8?B?SkcwR3B1ZVBZTHBYc0ZEY2daVTN5ZXM0bkRTSHhNZENzNE1vWkFpUkdMS285?=
 =?utf-8?B?UGdISkJUaFlqVFJYRzY5a1cyN2NQZnZtWFBDWS82MGk3Qko5ckdhak5GQUFn?=
 =?utf-8?B?NXM0VUFFK2FlYlBiUnQyMEtSK3gvRlo2Qk1TbXVBc1BiVGZrNWU4REZBMlh0?=
 =?utf-8?B?dkRiazl3Uk9FZDY1WTNqR2lKY3YzTDZKWStIbWwvNVc5NzVFUzZzYzJEc1ly?=
 =?utf-8?B?a0U3YlJ4WlEwTU9MeDJrbWRGcUNpN1BxR2g5U2tzQlVVempzU1QyN1hkTTNS?=
 =?utf-8?B?NnFMQ0k0aW1IbHUyODZSVmxWb2ZUelRreFM3TDVEUmdQbXowcDhwQlZER3NT?=
 =?utf-8?B?MWNHRUZVUEdsbXduZnVCVWQ5WXJvSkwvcFRWQWJobkdtdEpxeEZINjIrNTNh?=
 =?utf-8?B?UmZITG9nYXh0OW90bm90QXB0T2xBdFZ6eXlXbWpKY00wK2JVRzFSdGJkOE5M?=
 =?utf-8?B?a2lGb1dYd2x6Qlg1U0xXNWJnUXJYSk1jUFNOUHY3b3d4SFFGc3ZFSTdLb2hD?=
 =?utf-8?B?YmVEVVRKcjhmL0MxTGczdzFYaG9JUVN0SGJaeXhGN2VCL1JlNmFTMkMwMUJJ?=
 =?utf-8?B?OVlKS3ZCOUhwekR3RkpLZ1F1TE1ZaWZhRGxrWlBDNWltdFcxYU5rY21VOEpB?=
 =?utf-8?B?VXM0MjVBWGh3U090aGlpNVZ0elRpSzBLQ0FaVUJObTBXQ0VNcnhDR2NPd085?=
 =?utf-8?B?M25CZDZISGJiYWhhTiszd3A3WUcrcHpqQXRRQ3NPaWxMTmQwWld4aDRna2sw?=
 =?utf-8?B?WEwwMlhtd1RGNVlPeURBMEp2MjhLRFJHNkdDeDduaHJLUFZ3UUNwQk9Cck4r?=
 =?utf-8?B?d3BnajQ2VTV4enFGWjgveXVITE5UWVFNelpwOTkrandpa1BIUzN4b2ZXNGFP?=
 =?utf-8?B?VE1iNEdsNmhSRmc5ekNoenBndFFobTA1Q2NTNDNOYVoxU1ljQURickZIQkY2?=
 =?utf-8?B?Mjh3c0lab2NHSW1taWZCdEptRk5SbDF5MzI5OFVmcVdQc3VEQlRoRFREOUVn?=
 =?utf-8?B?SS94ZW0xNWVMNWpJNFJXNHorWXAwMmFxK0FneWRhNVZuaXA5RTNUa2xXamVQ?=
 =?utf-8?B?Zzl5ZytWWGxobXNCMzd4SFJ6OFJVdWF0QWR2elV6Y0ZtUCtYSHRqdXRNd2Vs?=
 =?utf-8?B?V2lLWUVaVnVjZytvWkxXNFlqRUJpYlo3REsvczJyQnVaQk95eEhQZVo0WUl6?=
 =?utf-8?B?eUNYRkNZQWJZZzcxVkJCVFcybVk0N004bG9rRTFYTFVpOTdlaGNPeVRpUXo2?=
 =?utf-8?B?dUtBcnNOYkRqSTVZSzJ1dmlrV1F3L0hHc1FyODlMWkpsR2NDVjRISzNyZlBy?=
 =?utf-8?B?Wk5xSG1ZSGRXT3NZQUErUjNiNU4yYnE3YjZ5ZU5GOFBueWVJWllBNGJBV200?=
 =?utf-8?B?TmNFR1B6M3dKcDhJcnA3RW94VC9paVV2Z2hoZjloMVI4ZXdzQm41TjRaYnMr?=
 =?utf-8?B?cklZcnJGY3orSGRGd0xQMWYrSnJPZGFnVWp5a3BmaFZJNUJkaE9kWVdEbjVs?=
 =?utf-8?B?OUV4WU9mMm1qeFFnd1lRbysyOVRHRk1sUTZBb1J0d1Jac0pCOXN1aVVkRkJB?=
 =?utf-8?B?YWRvcTFiME9QM2c0TjNRWmxVWlRsbkNza011MVdxd1Nqbm82SzQrRE5tUVJr?=
 =?utf-8?Q?TH6A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37256d1f-5386-4905-e45d-08db2277b507
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2023 21:29:33.6390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Je9wIhhwwvuD6a5K9wOxgnNeCuUhji7AXTvcR+3Ehfh9kFrIm+3qqQCTq0WJo9vx6yEvpcDJ/5Yj5WI+zVSyVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4776
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBUaGUgZm9sbG93aW5nIGlzc3VlcyBhcmUgc2VlbiBpbiB0aGlzIHJvdW5kIG9mIHRlc3QuDQo+
ICstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSstLS0t
LS0tLS0tLS0tLS0tKw0KPiB8ICAgICAgICAgICAgICAgIHwgeDg2OnRlc3RfICAgICAgfCBicGY6
dGVzdF9wcm9ncyB8IHg4NjpzeXNyZXQgICAgIHwNCj4gfCAgICAgICAgICAgICAgICB8IHZzeXNj
YWxsXzMyICAgIHwgICAgICAgICAgICAgICAgfCAgICBfcmlwXzY0ICAgICB8DQo+ICstLS0tLS0t
LS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0t
LS0tKw0KPiB8ICAgIHRoZSA3dGggICAgIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAg
ICB8ICAgICAgICAgICAgICAgIHwNCj4gfCAgICBJbnRlbChSKSAgICB8ICAgICAgRkFJTCAgICAg
IHwgICAgICBGQUlMICAgICAgfCAgICAgIFBBU1MgICAgICB8DQo+IHwgIENvcmUoVE0pIENQVSAg
fCAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgfA0KPiB8
ICAgNi4zLjAtcmMxKyAgIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8ICAgICAg
ICAgICAgICAgIHwNCj4gKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0t
LS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rDQo+IHwgICAgdGhlIDd0aCAgICAgfCAgICAgICAg
ICAgICAgICB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgfA0KPiB8ICAgIEludGVs
KFIpICAgIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAg
IHwNCj4gfCAgQ29yZShUTSkgQ1BVICB8ICAgICAgRkFJTCAgICAgIHwgICAgICBGQUlMICAgICAg
fCAgICAgIFBBU1MgICAgICB8DQo+IHwgNi4zLjAtcmMxKyB3LyAgfCAgICAgICAgICAgICAgICB8
ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgfA0KPiB8IEZSRUQgcGF0Y2ggc2V0IHwg
ICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgIHwNCj4gKy0t
LS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0t
LS0tLS0tLS0rDQo+IHwgSW50ZWwgU2ltaWNzwq4gIHwgICAgICAgICAgICAgICAgfCAgICAgICAg
ICAgICAgICB8ICAgICAgICAgICAgICAgIHwNCj4gfCBTaW11bGF0b3Igdy9vICB8ICAgICAgRkFJ
TCAgICAgIHwgICAgICBGQUlMICAgICAgfCAgICAgIFBBU1MgICAgICB8DQo+IHwgICBGUkVEIG1v
ZGVsICAgfCAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAg
fA0KPiB8ICAgNi4zLjAtcmMxKyAgIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8
ICAgICAgICAgICAgICAgIHwNCj4gKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSst
LS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rDQo+IHwgSW50ZWwgU2ltaWNzwq4gIHwg
ICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgIHwNCj4gfCBT
aW11bGF0b3Igdy9vICB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgfCAgICAgICAg
ICAgICAgICB8DQo+IHwgICBGUkVEIG1vZGVsICAgfCAgICAgIEZBSUwgICAgICB8ICAgICAgRkFJ
TCAgICAgIHwgICAgICBQQVNTICAgICAgfA0KPiB8IDYuMy4wLXJjMSsgdy8gIHwgICAgICAgICAg
ICAgICAgfCAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgIHwNCj4gfCBGUkVEIHBhdGNo
IHNldCB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8
DQo+ICstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSst
LS0tLS0tLS0tLS0tLS0tKw0KPiB8IEludGVsIFNpbWljc8KuICB8ICAgICAgICAgICAgICAgIHwg
ICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8DQo+IHwgIFNpbXVsYXRvciB3LyAgfCAg
ICAgIFBBU1MgICAgICB8ICAgICAgRkFJTCAgICAgIHwgICAgICBQQVNTICAgICAgfA0KPiB8ICAg
RlJFRCBtb2RlbCAgIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8ICAgICAgICAg
ICAgICAgIHwNCj4gfCAgIDYuMy4wLXJjMSsgICB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAg
ICAgICAgfCAgICAgICAgICAgICAgICB8DQo+ICstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0t
LS0tLS0rLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tKw0KPiB8IEludGVsIFNpbWlj
c8KuICB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8
DQo+IHwgIFNpbXVsYXRvciB3LyAgfCAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgIHwg
ICAgICAgICAgICAgICAgfA0KPiB8ICAgRlJFRCBtb2RlbCAgIHwgICAgICBQQVNTICAgICAgfCAg
ICAgIEZBSUwgICAgICB8ICAgICAgUEFTUyAgICAgIHwNCj4gfCA2LjMuMC1yYzErIHcvICB8ICAg
ICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8DQo+IHwgRlJF
RCBwYXRjaCBzZXQgfCAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAg
ICAgICAgfA0KPiB8IEZSRUQgZGlzYWJsZWQgIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAg
ICAgICB8ICAgICAgICAgICAgICAgIHwNCj4gKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0t
LS0tLSstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rDQo+IHwgSW50ZWwgU2ltaWNz
wq4gIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgIHwN
Cj4gfCAgU2ltdWxhdG9yIHcvICB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgfCAg
ICAgICAgICAgICAgICB8DQo+IHwgICBGUkVEIG1vZGVsICAgfCAgICAgIFBBU1MgICAgICB8ICAg
ICAgSEFORyAgICAgIHwgICAgICBGQUlMICAgICAgfA0KPiB8IDYuMy4wLXJjMSsgdy8gIHwgICAg
ICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgIHwNCj4gfCBGUkVE
IHBhdGNoIHNldCB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgfCAgICAgICAgICAg
ICAgICB8DQo+ICstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0t
LS0tLSstLS0tLS0tLS0tLS0tLS0tKw0KPiANCj4gVGhlICJ4ODY6dGVzdF92c3lzY2FsbF8zMiIg
aXMgYSByZWdyZXNzaW9uIHNpbmNlIHRoZSB2MyBGUkVEIHBhdGNoIHNldC4NCg0KVGhlICJ4ODY6
dGVzdF92c3lzY2FsbF8zMiIgdGVzdCBwYXNzZXMgb24gdGhlIFNpbWljcyBGUkVEIG1vZGVsLCBu
byBtYXR0ZXINCndoZXRoZXIgRlJFRCBpcyBlbmFibGVkIG9yIG5vdCwgYmVjYXVzZSB0aGUgU2lt
aWNzIEZSRUQgbW9kZWwgaGFzIHRoZSBSRFBJRA0KaW5zdHJ1Y3Rpb24gc3VwcG9ydC4NCg0KV2hp
bGUgb24gYSBTaW1pY3Mgbm9uLUZSRUQgbW9kZWwgb3IgdGhlIHRlc3QgYmFyZSBtZXRhbCBtYWNo
aW5lLCB3aGljaA0KZG9uJ3QgaGF2ZSB0aGUgUkRQSUQgaW5zdHJ1Y3Rpb24gc3VwcG9ydCwgdGhl
IHRlc3QgcmVhZHMgQ1BVIElEIGZyb20gdGhlDQpHRFRfRU5UUllfQ1BVTk9ERSBlbnRyeSwgdGh1
cyBpdCBmYWlscyBkdWUgdG86DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjMwMzEx
MDg0ODI0LjIzNDAtMS14aW4zLmxpQGludGVsLmNvbS8NCg0KVGhhbmtzIQ0KICBYaW4NCg==
