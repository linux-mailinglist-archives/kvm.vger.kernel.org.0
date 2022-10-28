Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B146107CE
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 04:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbiJ1CRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 22:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbiJ1CRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 22:17:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841A7B87A8;
        Thu, 27 Oct 2022 19:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666923429; x=1698459429;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gvEOdouXd7wv3nZiu60vdanG9EO3r+LUThqGQuTWIuM=;
  b=dl6h0rWgkNElDx+27CMzpZD2dhnp8MZcYM+SR1fWmTyDV4qVypGmxXiM
   523XOdSoXKoQUcIhQO3R7CPfQydlHAbn5CvypBJvEsLwse2BCTj64nh0T
   HXHXhGYl8Xe33sRqqExUtIOY+JN30gaG84x+JMqIZdZ0WyGiv26AbKDd1
   yjWH4sQbP0oRh0fnMI4HUz6ubTix6VxWg9BXfHjIhdnCl+rUrv8gr2DjQ
   zkVIe3e+c8f3UXF1isyRxyCYbvPXmgZYue3ZYDVcQb+8kjHhiiIySZmtY
   YBrjfKz7iFYWWeONilWrVLhL3R8JdjVwyPNzImYvyQAH0lIxEBEdabJcC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291691486"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="291691486"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 19:17:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="737929284"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="737929284"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2022 19:17:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 19:17:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 19:17:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 19:17:04 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 19:17:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyBqkWutjFKiGNgoxdiT6OP305h4tdBIV1qiIErTGRcvEvf1u1Q1eM5bDAO4+Oc9pbqXQo6D5gwwxhYRx7tggBpGH74YEu/y0irXRBMIBlmdv9r+UrJ1iSIlY1JWdHNwRqep5rXRQRsy+XhpmAvrQFEeKUAGuR6j1RbeQWUme1RfErmqeOZ78+jaIm0OtUWma4Z+QxpAw8SWGfeqZgX7zHncJCSQ95yQcGJc92s6cz9HIe7WB8pMvsUUhNt2zKlBoB5ngmEOoC3TWM+LdHIpSk62AxwfmhuT9tbDxJOeAiF/0RjCdu4tXEwSxZrkn1g+5On/8dFKupPQ/PUVTEWrhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+oatDu2qgcrjwZCmSXrkfOnzloY25ZHw4vexm2pA4AQ=;
 b=G3sHnvW8+x041BnzlIE6faEifFnLYNnd4NnH7Y04Lq0lCRG6DED0iA60/VbZp7eTGF7GXMHmwGJKZTZqq7M+jJYJRE4SKbbejsd2QO3RvmlH6Lb6ICnoApHqu9ogPkEGD7I5F+n524AEEVlPRBPJcgzvf9d1Z+7tUA+BNX5lyRcpt1vgbJe1GhnXEwlOGIMZxpMa4/xPTdQX2xrm5Q1/qmMrsyEsFE+lYl2h0iDOS7TNtqhPZvkiqXUBCqnRhURDo49HHlWfMS7zGYp8YfjHMSh0SJMnMHuJESNuZFeVCzFQqEzJG5ukIMLbJq2gI7EkBVIVnFEAAK1lK+lk+5/30Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 02:16:55 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 02:16:55 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ikalvarado@google.com" <ikalvarado@google.com>
Subject: RE: [PATCH v1 05/18] KVM: selftests/hardware_disable_test: code
 consolidation and cleanup
Thread-Topic: [PATCH v1 05/18] KVM: selftests/hardware_disable_test: code
 consolidation and cleanup
Thread-Index: AQHY55yuIXKRns508k+BGhcyAkdsga4hY2oAgADNh4CAAFyPAIAAfM3w
Date:   Fri, 28 Oct 2022 02:16:55 +0000
Message-ID: <DS0PR11MB63739599621057805F4AB391DC329@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-6-wei.w.wang@intel.com> <Y1nNzO2tC+DCyKWI@google.com>
 <DS0PR11MB6373F09A7A51FBF417876449DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1rH2uSEa3tMNhCG@google.com>
In-Reply-To: <Y1rH2uSEa3tMNhCG@google.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MW4PR11MB5911:EE_
x-ms-office365-filtering-correlation-id: 9a0711a0-af2d-43b9-fd65-08dab88a7c5e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0KYfkci8asc6ofGQaH5r9yaCRoaLOc22RDQXqtPUDHzamiKX4qz893x9BQXhJ7uNyPs9aOWmxv5xolwxtVjWaxUO9t7m1V+jvX529kehS/p3SFrUJe4LbWD+CX9RPf+F6ddAGt6y3GTI8NKcK//H4hfV4S/eTIWgV4f6fy+vrHGPgwOmY5mOW6lMGNK2o2dySWUubmaSlU68QtMHhwhcuu8oMmcFJguGJuAuGlGwLTPI4TVzV0ml3C6DZ8il5iQ5QmyFP7SfcfTnLgPzwrhkH/kY0m/5hVLWqDmg2crBYy29+JuBvZlJUm900skDgTa3n063+T/b39coJv5nFnTmxmwWtNmwKucNswMY2mcJbXec7YSNByLQmChwZOmADCRbPo8/o2M2fptQlz+MXtMWt/Jotcvuvpsr7TnKe0lRMx0tzCF/o2p8J2G2F+8eSGpIKQVgANvuerij0LyV1leIyiEJ7CbWa5afVDKupXZmoy2CG/R/DtjdwMKxATVj2KNxd6FkhCSFF2A+HKcoB4HAb8vgN30MeTDF4Wn+jxQ1DOeFPG90MrYEnetgrjKCRVJlURpW+lUQ3BavfvijJZxAXz3G7cxM/GDSaM8zup8E7iSK+nLv9suQLO2F8H54qhI6rxeYDLsmLX/JlrZdUWf37p1JXpoI8OOClNvPHb9xm5/ozvlWh0hVKusjrApk0zJCr0yOlubFQpVTVW5lDasm06S+DeFFnpW2mVtZZRZFWuZe28WYrm8enwPo72AI5QClwEGIIfvMVRdgh2WaVyN2Wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(136003)(376002)(366004)(451199015)(6506007)(4326008)(316002)(6916009)(54906003)(2906002)(8676002)(186003)(53546011)(64756008)(33656002)(7696005)(52536014)(9686003)(26005)(4744005)(41300700001)(8936002)(66556008)(86362001)(66446008)(5660300002)(66476007)(76116006)(55016003)(66946007)(38070700005)(122000001)(82960400001)(71200400001)(38100700002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IDuWSZLUwTV0mvEpgsB6I2H/ajCO8Y835kDjvWRYYQId/25PTa8RVQPxhQR2?=
 =?us-ascii?Q?6FVKLnX028npiHpCu6jSC17O+UTL0Mib97ZQH4/WSx0aVtPiMbcqt/A/zL4w?=
 =?us-ascii?Q?F6/Uri2Ozux6koJshMxFWcLo2hHJ5s/cNuIEVwmaUqEQ+VplnMOGTXn73kHf?=
 =?us-ascii?Q?nR6up4URDkjiG34sH+kiNxGJDV19ph4Aox/6g+uenmUR3Fm6O2PZ2XMN0AOq?=
 =?us-ascii?Q?EdFx1bozUJ7xlycx+whg60rlfMEVFwLgnjFugfX2MLjWN6GzwrDBKa0rcGLO?=
 =?us-ascii?Q?+HCiUhaBnDhMb0+J0UlHQEGMTOmIo4MiIfIh1aFLSYnhwbB9RRP05wwH2mzs?=
 =?us-ascii?Q?AbWUNYsWZUVfd6+gldOGUWbszxonST2i5Yn0qGZrSYJpIZdBLn1EOecBK/VE?=
 =?us-ascii?Q?OF/mVlDebOVYSs+Aqp0rJ3HPaoy/5qFVa84TfMX/NcdhhZ6kkQcMnFeZhQFA?=
 =?us-ascii?Q?DQtQeQwft/bB6Dsr69a/ul0DoOp6ryz6aAY6lbh2cqGTDo6ZQJvwguPFbSIR?=
 =?us-ascii?Q?YE2a6Rx87d2Ikfovax94zgpibwQywb3OxG7jap8DAr3N3EGerdT+CxUD5XLB?=
 =?us-ascii?Q?6B9QNje23mcJPpMRUHnjIp5sAnOOZxb9ItveYUCTVfdLmMLJ6pGgzNBmky6u?=
 =?us-ascii?Q?Eil3XtkP2MsPu+MOGwR2iA5g5ZmxfLHmVm3x5SuU1u9ol+A2f99Qv6hBgnzV?=
 =?us-ascii?Q?r/h9M/eY1BQ3diQyjZv2YK6aFq1L7RKcZpwUfkgSo4AFl2Ps7tIA0f1m+yUM?=
 =?us-ascii?Q?TUG5GMMyv86pEaig5ZWQ4BkjKCgT+x3t+UVlgQkM+XEl5k6ylXmcxQm861Vx?=
 =?us-ascii?Q?cGKHxReUqByVpeFMdc+G/h8qZlERTXUvtFiS+BkZKy3sd//I64gL4eHYnhGP?=
 =?us-ascii?Q?xxHwteg9r8KVQNGHwSWU3es2P5YeVIp/9RfohWfJJttC4tEUPO9TsjTlvjzB?=
 =?us-ascii?Q?Uy76ni9zWDI9GwVMqV6QtgZkvMw+gxh2gv1vi/X5ZPUeWRrghZ3T4XgcQaYD?=
 =?us-ascii?Q?XLLgrMGVJEMyxe8sTd9oyXgTytDJSDsMUsXl2uXamr9niL9biqedC0IgBaGb?=
 =?us-ascii?Q?OTmxbj9dluCafKWEbvdZXmR1q6PGOPqndib2ARBvup+izQ0Pc5m4As594a3o?=
 =?us-ascii?Q?8vRsn9T0DnaOrwdNMrQ+jwDl1f/NhflhIVCNxdngdRvuuVrGPUInP2zn/hAQ?=
 =?us-ascii?Q?l/2NIt00Z+8WNGkR+AVDAXpcQy8w8pCT8MPmxWukP48ZXeOcHzugyqOCphkr?=
 =?us-ascii?Q?48uyk27Mxy5jUHYtQciqus5fEhW2spZe9k+K/0EenlyLr+31f4Nbva6BrjeX?=
 =?us-ascii?Q?CfROAXuTU3Vn1CgGRJgz1Twz/3ecZ7ENHB5DwGsPWiqFvxwf0atfoLJuv4Zc?=
 =?us-ascii?Q?gTQ5A7NNIInsviLve9mibbDAKrPtmjzMBcRFfPHFNwvQu+L8HwOIq5pgpwBM?=
 =?us-ascii?Q?sT63SHUSxTkCmbw4kcKzJusRvlkyMnR60zawiEC1xDESToXhL3JruQ5z6Cj8?=
 =?us-ascii?Q?+T1jqScVtfphg3/Arns9AYfHxCwwferh5p4UcSyPtU5FWUrzNv6Q8XvS6Yx0?=
 =?us-ascii?Q?3qU8rfdnzv8834Rii4Hmj7XV8PYKHjt4SE+yhKna?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0711a0-af2d-43b9-fd65-08dab88a7c5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 02:16:55.7788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PyQeP/oPjqQCpVqxEZ7pLRIQZfDOKmNfPcgN6nMZiA29WAvDtlcfhDdp5iVx6xz3Vwce5pnn5bfohiYPQpdWVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5911
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, October 28, 2022 2:03 AM, Sean Christopherson wrote:
> But why does it matter what pCPU a vCPU is running on?  Wouldn't the
> probability of triggering a race between kvm_on_user_return() and
> hardware_disable() be _higher_ if there are more pCPUs returning to users=
pace?

I think the point there is that the vcpus and those syscall threads need to=
 be on the
same pCPUs. Linux by default has its own load balancing for threads to run =
on. If the
vcpus and syscall threads are scattered on different pCPUs, kvm_on_user_ret=
urn
would less likely to be triggered when the syscall threads return to usersp=
ace.
