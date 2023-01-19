Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04C1672E86
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 02:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjASB4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 20:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjASB4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 20:56:32 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504686D352;
        Wed, 18 Jan 2023 17:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674093264; x=1705629264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hdQEOPG7a7GdOyqras6g9RCh1eXmV/EwdtOcY25mVYs=;
  b=UTOzNtkl+bhXHe9ufi6yJnQwJqllVwuX/DUWE4f97kJCyfkU7OUedzb4
   9WSIs2VrSlRgTaA7PeQogIbF6mbagVy3cJXDIXm84D/uNmNPCpz7bHbpB
   cUumXd0idLO58LM/gm7xmXCy/RDDbDCi0Jax/dt8wWhwVlRvRr8s+ueU0
   RhVDsyDeZOTk7797D2SOxlAxoOl/1U5HUYOwz28VaDLbAxgatrHiBoyQR
   +zyQYQf5MlxF3SiHZPdZdJSW0zqoyBdXtk/ePJD+QFsIt4bOJXIYk+VT7
   PYLPe9eX3dMbWtqshPh88rzOMRxyfcJc+wbm/xXbU8ho2J6GN0dwhdB6N
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="411403840"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="411403840"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 17:54:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="728473121"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="728473121"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 18 Jan 2023 17:54:23 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 17:54:23 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 17:54:23 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 17:54:23 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 17:54:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBDWfRmAMfQfuHSArC1osT1UKdGmV+JPK6bjWCAe6a5aH0NwtVzX9PZreRPFABQgJPw44qZKc3FgQMcuYTCzMyjqNG8uhXUvHQMd6n9q2ZaBNNIWMaRbHj95x4s813dsA2gHqL6fYUMd4Wf/DWmhM02M369HaHPUKvo6UgfKC0JdXs1N2X1lqOKA0BD/5YQ0ssLyEesXQVe0fyIYHg/qNm7fNl9eu1uKte/boOsPxDykv3f2DYtFmrw8bYei0eqI4p0BPpx8UFPJJWRJejWxIvPpOl9whh800uZwj2yucVlQBITmBdJZ/IuaizLXw8/N960XqoWXm/TED1RnionkUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdQEOPG7a7GdOyqras6g9RCh1eXmV/EwdtOcY25mVYs=;
 b=IaXgWFCWJ9wjAQs2/su6zWXAnLK04yo+lh1q5QvETO29aIb0vMnFGpoDXKBd4ViOWLq3C0pFuebgAJb2m44Dq3Q9Es1bauEzNYsqJmmtDIF0l3Zl/pLKw+/MHe1W87WtBxwkHkn/V8t/EmuDKc1wp45VbtgfXGbztGcklaP8OQ4ovcJ+UbKjzdjK0UQmhkkDBSghaQ469/drvamqYCIOGejZ1qvwh/rIovd8zhJTrkGNRpQHS3SVcsCiZBLS/LwNtIvu6aQLjgAqpUb2EKQ7iivimPfdG+bYVuWqyeGiM1zPYxAkuvuzqyVsssXUqzz+WnODS4QvoWxQtlD8Lf6SXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DM4PR11MB6456.namprd11.prod.outlook.com (2603:10b6:8:bc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 01:54:16 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::52ef:33cf:9be9:fcb0]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::52ef:33cf:9be9:fcb0%5]) with mapi id 15.20.5986.023; Thu, 19 Jan 2023
 01:54:16 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH 0/7] KVM: VMX: Handle NMI VM-Exits in noinstr section
Thread-Topic: [PATCH 0/7] KVM: VMX: Handle NMI VM-Exits in noinstr section
Thread-Index: AQHZDrl/1BljPxmiqUeeDW9Xymc1LK6kxHxAgAAXmYCAAFfXsA==
Date:   Thu, 19 Jan 2023 01:54:16 +0000
Message-ID: <SA1PR11MB67340ACD9E33ED6AE97056A6A8C49@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20221213060912.654668-1-seanjc@google.com>
 <SA1PR11MB67342CAA9AE9A7E766AF54E9A8C79@SA1PR11MB6734.namprd11.prod.outlook.com>
 <Y8hYrU3JDMVBSeZo@google.com>
In-Reply-To: <Y8hYrU3JDMVBSeZo@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DM4PR11MB6456:EE_
x-ms-office365-filtering-correlation-id: 413e779f-0073-4c01-ed36-08daf9c01263
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mt3vMO4ayCNwNdaFFPfxzRCRg/ah+FRhFnPvmtLQ+M66KjCaVJCVOe3kdIopJ+8jySF9RPpxv1taqS5GXgJ3IUJbfDVtx4iH2Db3XlCzn+lU2XcTYcHE7Q/mlN3eT9Bbt/lrDO/MoDin+nSCxw7xQuI0teAPjNDq5PelZL0TT0qqBMYWSclbqE+d2N1LsmgoC9RPF6G1EDqmYnGQ5PCXFgOBOzn9aMNa/OovE9G1ibDrGyuhHLzghWPtSaNZ7CwkhQe6PstgWuEE6iLERJ5LoINoHM6VzFXtgcDVxW/UDsWhUMNhxhsCipYSKMMJNCVJ0/Tg3Q5+7uROzwjIIuJzPKmXvFlvkJCrf9zakmegSw43FlQ/p/gHh71LAOFmxNAwy5jYoYuUQri9nD0zOeaTm+bZ51Or3rwemwAmuCmytIcOK1f4UUC7fOQNx+zluTBEwHs8hD0dWEnuznrE/um+cUfYRWgNAp2kdpL0N5ZequmMkZ+rvUgz416tThKzOEB+Ro8p5IOCDDy+Ut3U2jCFLOrAM/w8pNTBB9+RTFP7HDgsXlvleKTkKafKi1BBADIrQ3/ijqoxgCJDu1AzUNhpb7uCoih+T2PwNXJw2VCBPBhRU7kVVdJMPHeNiEr3ob4DNF4fzPW4CgZusPHL76xEoVTfPLhJ08RQobcmMyTJmjK8G4qtfZq1/BXn6rrV6P03HffU5SNvyW8cy3LRvWJ/Zw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199015)(38100700002)(558084003)(122000001)(33656002)(55016003)(38070700005)(82960400001)(186003)(26005)(9686003)(86362001)(478600001)(2906002)(316002)(71200400001)(54906003)(7696005)(76116006)(5660300002)(66946007)(66556008)(6506007)(66446008)(41300700001)(66476007)(52536014)(64756008)(6916009)(8676002)(4326008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nvj0ZuuQGrogxWA7gp4J3AfOk8dxz5vv8tu6aSMD8m41oUq6W98UxXC01hZ0?=
 =?us-ascii?Q?NeYLtXTXNSVH2tjYIez+aQBNa7wrU4tBEMHaZgGD7aHml1sB/zQpJc9VwJ7Z?=
 =?us-ascii?Q?DsnjnzKLj4o7JLLJWmVZw3x2HC6lsQy3iwa57iV1fPvewtNAXv/ux9nTBklh?=
 =?us-ascii?Q?XchsX95hChPBTIDnOoyyptm1P6YZodhXLNLK+YP6+LEnCiwuNPt7SW9fog04?=
 =?us-ascii?Q?KVMhTm9/rfG074ZQqj5wSuHDvvMEL5rYY2TKK5kQSmtsw0BuSgspFrV5Dw7e?=
 =?us-ascii?Q?0WuvZ3ZLUjXI31OY/MpjbVlp80FPAH8pg0TfonREbWNjBB57jcL2Lj2IVc4+?=
 =?us-ascii?Q?DdLVT/s0LvKTSXIdqo2bLw7C+OFGO1gW9OdrS25c/aP7mcf8HVNofL4ke4TT?=
 =?us-ascii?Q?y4P1pKlAY/cDcOmOaTCzeQYdPzKg3ToBvf99UlCp0MgoXmg4AE1b3dqR6nTw?=
 =?us-ascii?Q?Tzj4RLMXwObrT/bgdRneUXsYZcGe7Up+y8sMW2Z9mr0EYuisTIGhiZMSV1BT?=
 =?us-ascii?Q?4jQhSrQ4jMITR8UfK/Z/3Qn69TWlPE+2WELorNrWlRLYARht2PIaORxmf+7n?=
 =?us-ascii?Q?E6vzQmROGTD1OcmJvzt6gFzLrPt2rpIl2o/XHcGJ5KYBJyd9ZhQ8uCd7dHNd?=
 =?us-ascii?Q?3lrGHGwoCFBIL3IYg8/mydhF/KhSL/VK1Quy15kHenzPq63UZV1VcCjWjhlp?=
 =?us-ascii?Q?T/p1YahTaibwLGHpLyVmQFCKhp+DNsuGhM92w1H4+pbVVihOsxblfAFe+/lA?=
 =?us-ascii?Q?tHs75M+VKQL6kd5PqKtPjQ8AloLyDyGYw07zvjW5DQP3J/0b8nSgEveYEhri?=
 =?us-ascii?Q?OjAOAVsAuWZjJdlBRMZwHTttZaICAYAtCucri3rDUGR9uYRsuzf2gDT+H0PF?=
 =?us-ascii?Q?QlmQLUPtvsO9H4OXkYKEq4F597afn/JZR45ZVqCfMTfZF8vJrVRnZR/Aex9x?=
 =?us-ascii?Q?mApzo/M5CdvaspUjHakz7BqH2crYv9XwFBQRkm8ea6r/a3JDu5wwsBkGrEEL?=
 =?us-ascii?Q?bgoned3gHluBcPYUe1XUaK0D9pJJd2H8KQLJBUYgNk/mKCY4lLHYDkWwZ9k8?=
 =?us-ascii?Q?RIP11HqbYRX3LINnsXMIwlTKEaeic1CWH/Kkk193eP9BXMS7h2qZZjaJkyWc?=
 =?us-ascii?Q?eDh3RN+QelQnD6r/YuLE3Q/fElfpgSKsoiJfVbRulIbj8x3ANMBH/Ti+GXiC?=
 =?us-ascii?Q?orjjVKzWiftHShuSlF6mcmqGDP2SXv2tAnfKZLKQn24FIxAWSe2gzX42N+L5?=
 =?us-ascii?Q?IKcjNy25m8s8cXnEKUJseo/ZPnOUSYR10iPF2t47Ig90584E2WDv1/sWuM7q?=
 =?us-ascii?Q?kuCcFzQy+cEEV0ezWxuQYLvquhiKUHfGEyXmJmuhUeVM9MD6zz1/LVi6Yj15?=
 =?us-ascii?Q?UHnXKb0YSeznTbYQZKknwXIFzLrlyc5Gf619jL7LK4lyEHNZf/Zi2Xh0pR1H?=
 =?us-ascii?Q?Us/hoyQV8KVIjpNWi4FZWrXptA8OMwv9WlPjFp/LaGtg1Qt69jbDa+2XCkkq?=
 =?us-ascii?Q?dU7sQ0dftL4fR5E+Tzm/SvCiCexKha3fP4Ne9ng5wg24e3vYkpmlx3GBfaMn?=
 =?us-ascii?Q?NhwZY/f6AkO06yie8F7/9id7sniEm6Ci40T1l9PT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 413e779f-0073-4c01-ed36-08daf9c01263
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 01:54:16.3297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HlhaF7yrntG3fhHCqGIpjlNk93Z7B+VEEE4xnp9Y7rInnDWU7eAzSCWaJVXzicQ+vUFM4QX8Qkab1vKq/Pvkxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6456
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > Is this merged into x86 KVM tree?
>=20
> No, I want reviews for the KVM patches before merging, and need acks for =
the
> non-KVM changes.

I guess you want Peter Zijlstra, or some other x86 maintainers, to ack it.
