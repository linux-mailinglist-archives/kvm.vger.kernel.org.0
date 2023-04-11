Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4836DE78D
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 00:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDKWuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 18:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDKWuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 18:50:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD0E2697;
        Tue, 11 Apr 2023 15:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681253407; x=1712789407;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C+EvIrNe+rIVJ06buXQMHEl2eEY34vLXhc9r8IdJe6s=;
  b=EQrxY2ZiSp0BBQ6Xgzbs9SS8fSzqjdlC3rf+WlJdHCBsniqFQ9fWbb/t
   WBQv8io+Jy2jByrxHjGSeD/QGNV+P60+1STABm/MoXlChxNeVmDsigSZ3
   Pnbwuy1UHxfn7lkhpFjs3Da1QVB/6LDZuDfswak3EX92cngxegWqF8ysp
   RLDdireOLj7lFIiuedu3EZ54+D5ejYiVKtydqzAIOv7cqX0Rg8AZWfjOb
   /YO/VXNlJkJR1maQDCOQXBuMucTXrlLvlT+gAY/ipcKtLhk1juwfT83Ox
   s3j8d2LsLodPMupkT+VEPr5KT2cUA+fCIeVSggAIkJhI94pNSD0hF4VoL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="408891487"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="408891487"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 15:50:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="753305153"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="753305153"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 11 Apr 2023 15:50:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 15:50:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 15:50:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 15:50:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 15:50:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2Es/5l/A7K1SAcxy1qIN0GvnGqdqNThMjVWYkMFlSiDXzQLbjDUSGohhcHjC0626U53w6mjbHXcpS/yEA2R6uYhBzL109ltXRPWXNU71dsAwGrlEFFlbeV/0m4E8pcVQSedlLgCVpHrJlURLZ5OxqdbQVYr6Gyn7x8LYc41/fwN1wo02phQ+EliIuG41HOUIBMv0khwfMKxd0yl4e9RQws85Lk7co5AEm1xFW0qK9vB2D56k6lMj4jJxsB5AJh++XS/DAP2b/VhoEwN/+XhBeuOtZ5A8FtUuKxW5K8+V+FLPUfgAA9UC+dAvaMFFAx7f4xLZigW+PsgOtjekAWo3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JX1VJBXYmdEyjzAUKrW2xkCDMtNShTFMz+/gnu383U4=;
 b=QRikDztoEtJ0N/+2V9nqdTZ+tT55MjS3vNgMC3G3rmWAoaqpmQnGRvX8ZSf5mc5c0eeQttU0EionBqvrrYX2eo/c6N4dVU6v/MlAcuiaOCE4oLt8HCPVDy57KqlGqga3yoCpRf69ZsH8kpjYK8BY5QJTIa58GAn/l43uHBc4koqZkmVRJB6anR3XZi+q5peHbK8V24xyRyzT+K+6LA862OOETujSW4/HcjznsyFsZ/H/Vn9/3LnPGde0ytgOQ+u5S3gxQVehY07FhZxm5CeFDUeMzFdkWjdSoiA1uH2cKLNj94Y+rRQiYz3RpI2W5YQr1idgG9yrDZS0YPDrL1wa6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6737.namprd11.prod.outlook.com (2603:10b6:303:20d::15)
 by SA2PR11MB5020.namprd11.prod.outlook.com (2603:10b6:806:11f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 22:50:02 +0000
Received: from MW4PR11MB6737.namprd11.prod.outlook.com
 ([fe80::957c:6b5c:807d:c8e3]) by MW4PR11MB6737.namprd11.prod.outlook.com
 ([fe80::957c:6b5c:807d:c8e3%6]) with mapi id 15.20.6277.034; Tue, 11 Apr 2023
 22:50:01 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 33/33] KVM: x86/vmx: refactor VMX_DO_EVENT_IRQOFF to
 generate FRED stack frames
Thread-Topic: [PATCH v8 33/33] KVM: x86/vmx: refactor VMX_DO_EVENT_IRQOFF to
 generate FRED stack frames
Thread-Index: AQHZa4iiYR92PWeRCEi6WbUcy97+Bq8lFcEAgAB3RxCAAORfgIAAR0nA
Date:   Tue, 11 Apr 2023 22:50:01 +0000
Message-ID: <MW4PR11MB6737F5CD4B75A77D8A231AF5A89A9@MW4PR11MB6737.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-34-xin3.li@intel.com> <ZDSEjhGV9D90J6Bx@google.com>
 <SA1PR11MB673493A64E2BEAFA1A18ADE6A89A9@SA1PR11MB6734.namprd11.prod.outlook.com>
 <ZDWoL6o5LYgWP14y@google.com>
In-Reply-To: <ZDWoL6o5LYgWP14y@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6737:EE_|SA2PR11MB5020:EE_
x-ms-office365-filtering-correlation-id: 1162ec9f-cd49-4028-84a1-08db3adf1549
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n7+NDNSLIfV/UcuIE9mfcZSEdAP1kk5Xnt7DIA+LaFGm5qxsOy1kDx3QuxDQvqH0g3QW8/UudcdK7NpPeFKXOo4nZBb1ehGyrwTUblXEwWcNe11I1KFrHyRC6CiiygUQ95FwEpcqK0AjsaZGF93G1QhyEWCEhr7SUxr4JJ80kEF+xlfcW4vnnx0kPH32TwttajPCIDz8rvkQc8jix9wultZIf1fe6rVeEJVfMhO/E2zvwFIdiEKJB8L/2cA0swMVtSy1Wsinqwn5MleA2Gvdi6ZszhEEobNF2V5EHgKcYMzLYo3ERWKFlKQs0y/QS7UnOMhQ7/dBUe7gHeMdWOXkVpdYTGQC7t5eiEqnf4pzBJhqiEo8nW+n6+mV3Wo/CuKwWNyVAoqY7xKmXWt5jVoKWhkh1ersbZ0CYJvzg66woZKEr6Ay8RZX5e1d5fx22Qf7W9e2Uvo+tqbqC4cRq3j628rKnPBD0VWwSiXoUBDYQFuvyBZeChxDuVjllbwjbVmlyV+Ck0qVVDR1p7KnWIjHFzH6fF6F5gvrUtDPxxwJ7/RqRkm7hPn/PeKAgmAhg6F92XlH7u/8RCx0LxuWNK1IeZG0qMP3SlBKflVhRRQjalA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6737.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199021)(33656002)(86362001)(41300700001)(76116006)(316002)(478600001)(64756008)(71200400001)(7696005)(66446008)(66556008)(66946007)(4326008)(8676002)(6916009)(54906003)(66476007)(82960400001)(55016003)(5660300002)(2906002)(8936002)(4744005)(7416002)(38070700005)(52536014)(38100700002)(122000001)(186003)(6506007)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ep0Xzc2DEjaq/sPacgbaXLLHcMzwdHCtSTehztRStwMMYiENxSUIVVLUo6xu?=
 =?us-ascii?Q?DYQGk8q2ZrOE66G8L4IKAiNXyxMR6JESGFjap9zcSDKWBJwNUlVWSKhBrsss?=
 =?us-ascii?Q?f88bjTG3UznPe7jPGPIiZFGpp2UFUuNm2OVw8xyhJZAc2qkFaMZCn58yhzhm?=
 =?us-ascii?Q?1bc5zDQuhvhJvsxc4wtUGoxeJ/NJcZLlUKnC5GZL4DTIWhz93i+XzFiVQgsV?=
 =?us-ascii?Q?YYbPp8Di2v5aNBEyiO6eiRZnHb/DTskDw33DM7FNaswJSuPK/e57CFqdwuWG?=
 =?us-ascii?Q?y3e4yGzXrYi7S+6rfqJDUBDpfGVY/eErqE5e2nldJN6MDvtGvkXG1JJDOgEB?=
 =?us-ascii?Q?nCivvi1Y9/ppsYU+Xf0WYQohOH6EtxfGedzbQO9Sgp99pzOCKiGHrDyHU8fl?=
 =?us-ascii?Q?hqMMvFvb12VUb87vD7cBwlQBayVIeaAZXqgG84BG7N9o3I8IgxT7QDNEmnoe?=
 =?us-ascii?Q?bQ5HU5VK7NrHn/OYZjf7CNZGVe0VprBtBMTPRCDVflauehjzfiCDrilI6SR+?=
 =?us-ascii?Q?NJnkdpdZqjWEehF3hDpIuvSJC1rCC8LBkuNimWiChn9+XWHeIdWr6N2BtmY9?=
 =?us-ascii?Q?Nbr5y4Kwfz0kfKY/aVyomVt9kXYqg5CYICtyZ9owIIDfBY58yMeugoyZ/5T9?=
 =?us-ascii?Q?7gqyhK/9xhSAaQizSlTGbgovo8m8vD9yyi9nnsrQi9n/v3TQZ0gEwxzfht6h?=
 =?us-ascii?Q?MT9coJDSmqx4XqGSZOiK/Ku5KF6YsqOfj6ZkFcXvrqxTizbBt+yTKDxPql35?=
 =?us-ascii?Q?eXPrjSbW6RrQJ6xgX3m3yWd/7NHD82ZSoToGyK8KHDi+l0L06/QKjBeRhdyx?=
 =?us-ascii?Q?qRxgWmQfBULCnvnS36NLWZ5IpgX3ADxhueINMGOvHQVVxJdlb3a25CNRz9ti?=
 =?us-ascii?Q?lUCDYdf8cVF9c/pHtKTzqCNcwDYX37W/8xqva+ltu/P9y12KguktGNvh9wQ9?=
 =?us-ascii?Q?IZlsJcRNWlKbYLsk1cj8a7xxSqT2nxM5AAf/d/RLMbBrDcypX1Hq7hVabWFd?=
 =?us-ascii?Q?qHL0te7dOE40frWs2CBJkIAvCKJszxNnT7CZXX+5VZGVkMBYrn21lTwEVvYZ?=
 =?us-ascii?Q?tqI+cjlysNdvVvVPL331b6O6IlZdHfqmMZg5NP0BuzZMM+8MUWuGQWDQychn?=
 =?us-ascii?Q?OJloKV5vgLdCFdellSzMQt69mE/acgTKFjWbKuJWeeM/WjbF5YKD2eXcpBap?=
 =?us-ascii?Q?b5FhwJc2dJyzmV1++0YhzeX3486wdjFiIlmh4AnzMYXB9sCcfOhaI3ZVbpiW?=
 =?us-ascii?Q?kW7r/atZMdm0WoWCRyLzrgVnYejJmUhBdtyVizjX69brWfWHjQaf8fUJqoyy?=
 =?us-ascii?Q?xgxt0VUWSXAny3rqwWHltQ74j0ZJJNDZ7InGY3xl/xdzVB0qwhAMGg2PDusg?=
 =?us-ascii?Q?BS9+xLEOTT2LSqS+T9JRr/0/N2xWySG1DkTX77/s76lneLA/AV6qocWGgtgy?=
 =?us-ascii?Q?GmdEhgyhV916lMwXKIYsreu6IXYTCEW11yeSdruzzyl8EmP+lGo4hZ88LVSt?=
 =?us-ascii?Q?Ffw19Bz1WLRX1FHY7mVoUAMclDwfaIC8HpoL46qfjedoavjc78y3T1EpLFT4?=
 =?us-ascii?Q?Py6moEle47HG1WiBmtQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6737.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1162ec9f-cd49-4028-84a1-08db3adf1549
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2023 22:50:01.1803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +YH+J+uJtwzbdFEwkEadjhZlCI4wy49wW4Pxwh2AaScYOzeQmWWF2q/JkJRsmCYBw/bx5FC5Gi1mGLz3qbWeRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5020
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > external_interrupt() is always available on x86_64, even when CONFIG_X8=
6_FRED
> > is not defined. I prefer to always call external_interrupt() on x86_64 =
for IRQ
> > handling, which avoids re-entering noinstr code. how do you think? Too
> > aggressive?
>=20
> I think it's completely orthogonal to FRED enabling.  If you or anyone el=
se wants
> to convert the non-FRED handling to external_interrupt(), then do so afte=
r FRED
> lands, or at the very least in a separate patch after enabling FRED in KV=
M.

That sounds a reasonable plan.
