Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD00B775E4D
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 13:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjHIL7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 07:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjHIL7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 07:59:20 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D08110FE;
        Wed,  9 Aug 2023 04:59:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOQhNeOaTM7RW+Z0KNB9HtMEYxKssKWftw3CYPqO4G+rbSUz7BXq6G117qWEtRVPH/lFCvsRcmUVMQX6HxxKAEPL7vTjspgJVe560vFEJABIz18waX8obbN58nwYxXxZUNvIsjbzdDPBKICa2v9fgNJdXTZic05S9q1qZJWHNH08Hh8FgllP7SIaJae8/2/oNiRPAfO4J/Agws7B0ISFtm3EWe1ev1p5GndUgZlthcHcnrbSCxLtjNTed4yaOXNwWGZfIKCZzxrXKOLDe3QoCEXxO9bG8eV+z0uc87yhW1UbEhoxdOCIkdfH8P6VMKWK8HU5SuoY8j8eTjwgqRRJDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rNlzZpoavH6QLkcYr+cJAtpvBpfparXa6WOvYYOyxs=;
 b=J4bhnijrY8We5BFPR6xelSS+SaI+T5ZYyZYF7tSy6/UUlR1DDICoEJA1yqTPauO1v71cZMGk4LGDXfM50nyfF2TEY7yUm+w/WHVFS+2VmKioh77cT3aLEUDUlge+Vs8jln5VtvNA/RU4+5DJjp41FFC9ZSPlFAIqny8PWoNHvw29+lYYfqYR8UHuNvpGVYAWX9+6wqBKv3QJMHpnsrgm8fSm+RJOoQVen7SKeNnoa8jJ5kdopiGNg/FBzXOmUSlVUvNcXQR4vMBod0fXZJQRrzRENC+j1bGyWcQ++FnEJ8rzZD86x5HoEcCkjLs+oUdIWg0+kK7eBSaiw3v55vU49A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rNlzZpoavH6QLkcYr+cJAtpvBpfparXa6WOvYYOyxs=;
 b=cSEAXqxfZqw+9dv+1Jpsk/4yAg7ZyjPk0fc9nkp21suTrfCcZq5ziBpUohE7ZaxWYuGLo4TX5EUiRVeybaJeOQ0YOV4CpSAenSVuGx1j67MXUVhP3gpTlIE/AS2AyRq5tRj34AvX5AX+KpovWPr1fXrg2M2cJ6hObZb0ySiE74Tn10+EqgEsKJjMt3xCIEug07rvbAchDUrW7t2IxQY8fBchPudSE6Qe3MTqk8Hr4yBxy2ILBvy+8zZCwmvYHgCg6TnfMs/6uySHx79hZjWppqNwq2JG6u5KTqesikoxzPWruF7yfbFGnFX4znm2i+RVYhJQwcfUV3yOZJ2Maw/dMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB8715.namprd12.prod.outlook.com (2603:10b6:208:487::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.28; Wed, 9 Aug
 2023 11:59:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 11:59:17 +0000
Date:   Wed, 9 Aug 2023 08:59:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mike.kravetz@oracle.com, apopple@nvidia.com,
        rppt@kernel.org, akpm@linux-foundation.org, kevin.tian@intel.com
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages
 for NUMA migration
Message-ID: <ZNN/lNIct0eufg7N@nvidia.com>
References: <20230808071329.19995-1-yan.y.zhao@intel.com>
 <20230808071702.20269-1-yan.y.zhao@intel.com>
 <ZNI14eN4bFV5eO4W@nvidia.com>
 <ZNJQf1/jzEeyKaIi@google.com>
 <ZNJSBS9w+6cS5eRM@nvidia.com>
 <ZNLWG++qK1mZcEOq@google.com>
 <ZNLZpWbnSmNRc/Lw@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNLZpWbnSmNRc/Lw@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: BL1PR13CA0187.namprd13.prod.outlook.com
 (2603:10b6:208:2be::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB8715:EE_
X-MS-Office365-Filtering-Correlation-Id: 48597aa7-d757-41a1-84b8-08db98d00eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RPRzAA9izQ37zCxh2Am/YVeyx97/xyQyP2QYi201KO75rkKY9G/S36vMXXoM68OhiWMUegqlYy8GIHvKvDucViGoWDDHvcQezotxviGmnrTSt8kKKW4MfVfBLKQOHlg8k+MrVJFU+Ac7q9XolIkDuO/B0o0lYc6tp716RCTVr6UD8ypbkDNaGfzek2HwHANpPCVOWSOE4pkQmFXKudtb2t88OBdNT2yWOk8ba5iRIlWUFEfoW+smxZGXZ1JZPuGbsLBHmIDSQczpOjQl14cWgthpoftapOWU+H5gJmKikGyAQGc2nA5C0vNj0BGLLh4TLU+Wicg0LfkXCuMfMpt6LyiB67KVMvlRuydjoBmjUgqrThqG3r4fvOLGtaRUSLhwOAmtm7Db8mIiWtss4HNr0oHJIyaJbhkUv510AeZk+Qe0F0yNNURJB/DfW4UShD5DZmY4qIi+HUFExMwZTcocV+uJkd72OmEtYikBt/NMePaap3r6zQpyu4h4UjEFwYK/3DQpg81Exgf9ee/ErBwMjBtN+VsezuafmwaxLa4q/TP83MQGuxCphcc5ZwxSn7jT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(451199021)(186006)(1800799006)(41300700001)(26005)(6506007)(6512007)(6486002)(478600001)(36756003)(2616005)(4744005)(2906002)(66556008)(66946007)(66476007)(6916009)(38100700002)(316002)(4326008)(7416002)(86362001)(8936002)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BJt9dBDeEkHAJQWLHr5uiEWEKt7JwnG0N0S438BWzKmR4n/oepU0hbccrbiP?=
 =?us-ascii?Q?zn+REEENdsRN42dhXMn/3uN1fIOEoleljXoW3DzDk3uHo2b7JQTuAcnHjbt5?=
 =?us-ascii?Q?VNgb3UqTYG4OztCrJRfNa/ofD5jkooPMkZU1IawLED4IiLvOjtovLe4fyxn0?=
 =?us-ascii?Q?u6oE7jwQP6savl328646BRP0JAh/+qSWykErJFFr8CkZViZm7bPhkEi1ft0+?=
 =?us-ascii?Q?dXb9XtfL/96THjfERkSVvjJX2p3enLgyM4h6WCCc7jzbkD9QxW0IcNg8UgkT?=
 =?us-ascii?Q?catjPzoIQrkrvjp8Qi9LOaFDRD3ybPUhar80Ootf/GeP1Z/M5XMRZHMMHU6u?=
 =?us-ascii?Q?+kRw8ERR7yGahzs4IvXoh4eKPt0V9+k2Y1FFxlOq60XKIF7oHtysKwisk7cx?=
 =?us-ascii?Q?h+nMp0l+nezH8cgF8DfbUneNiTRCl495UyRtLLUXt/oQ8PnMA1GciNCuZPXh?=
 =?us-ascii?Q?etz2XF+njRrH8l2JRFzWkk+T5pSPvRpLqTqRkyl0Vpcci2ocSvSpSPKVVvVu?=
 =?us-ascii?Q?BlvoptRO6PNEw+1UqK0ox8I0XFKliZt8Bra0bUFmOxAAnD0ib5iL5AEmlsxV?=
 =?us-ascii?Q?umGwe92cMBOQnyp/jjp9G2RwwJv4yvRw/10C5EeV7ajYClfNpNhR1BlLA0yp?=
 =?us-ascii?Q?ENwAy6OPo2yLe1vpGMc370LGuIqEVnAhjKFb8sH40Cf35mdyFG8CITbuHPHU?=
 =?us-ascii?Q?RrtNnYNfk17jpx19gsOT+CLmk1FuNvzSNdaQSoIF9kKjaHKPoOt+qbf/eT8f?=
 =?us-ascii?Q?xkP952F0NfpWEm3V9/MaEinMhsChSp3fco7hbrQxcegbSTaBuvCaLHIk1X+m?=
 =?us-ascii?Q?vOrWzGeH1AiECOGewn5Dy/KZxdk7DGkAECPBc9nuHDCkTYjrvb50ORgNWlHR?=
 =?us-ascii?Q?wUeMYBqD/yWT7ptUeD7eN7XMMwiD8zy4FXcy3lwI6pjRJIy2kNRz4TC/vY8u?=
 =?us-ascii?Q?PveobaQ7yFfLy9T95v4fQT10tfebSgoK6W789IDIkq+FbPjnkM44O+v6wBA9?=
 =?us-ascii?Q?SOCQ6gBCW/4zxRIFd7jhCmCWSMuCVe3VZidGWwCSp3pwGgFus8DHsvirpYku?=
 =?us-ascii?Q?/JZr8mug2vbsrzROVtS0xHQDE6zaS9PvsiKNnZ8X7sRVjHfZKqSHIsSAp3aj?=
 =?us-ascii?Q?EufqLjXM2IykUOvCNHSxJFj08lNApLNb+NpoR/cm92VgVTRAlDlHU7e7lI0O?=
 =?us-ascii?Q?jcA4s1MEqjjqN/uMYRX0wN3u2EawD+gsUmk6HHSQRhIJXCROppXq9A5ky9Nl?=
 =?us-ascii?Q?eOc3D6g/Xm+sGkUxgBGWZOsbz/8kE7jeLjYCdG66JY80zt14hxkyHm/ni/dJ?=
 =?us-ascii?Q?cvpZjC43Hog2Up4J/UCx9UlKEQTt6S/PGJwH/G6I/H8LbuyAYb+bbq7ehsyQ?=
 =?us-ascii?Q?Uxkt4emresf259jv+S6FFMhpDpWM2XxWehoIALsXRo06KRx+/7iCBhz3iygI?=
 =?us-ascii?Q?YBHbNUy6FXMoCrUDEJ8cPHy4y5Q0J8Wj5KALEZKBEV5md82xPiUk+x/66acX?=
 =?us-ascii?Q?7w+WmX4P7KLV4oauPms02sLFny4vmAy7H9C2np6dKtjOOV96CuP4Lb/C4X8q?=
 =?us-ascii?Q?nfS9zHwFot6r9EL54JElRudKA73ghVOcG7FWMjMS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48597aa7-d757-41a1-84b8-08db98d00eff
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 11:59:17.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhulJhHN5aG+jCebjKHZ4d7UbeXKa3JsPIxkvngiQgJVluwe2Iohx/tchdezFrRF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8715
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 08:11:17AM +0800, Yan Zhao wrote:

> > Can we just tell userspace to mbind() the pinned region to explicitly exclude the
> > VMA(s) from NUMA balancing?

> For VMs with VFIO mdev mediated devices, the VMAs to be pinned are
> dynamic, I think it's hard to mbind() in advance.

It is hard to view the mediated devices path as a performance path
that deserves this kind of intervention :\

Jason
