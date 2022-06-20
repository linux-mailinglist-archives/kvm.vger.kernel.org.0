Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B75C550F26
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 06:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbiFTEDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 00:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbiFTED2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 00:03:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D7E63B4;
        Sun, 19 Jun 2022 21:03:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcUG2y8RZUYoSJtn7EFnVv6ogPh6f9dgHPlAJmJ3ue7k3x7DTUhnFTkchoy9uxhkj9y0xY0JSoi+rh/lk6kktU1eMJ5DjlPCh1FX05pXEAPg9Pfy/dWIP0M568uDxBEcZvL4aX/uDjszL9oJJfuxbGGzkM16nt5/d2BlSJlfPDjuernf2RRd2V0obLyBrJZMvz7WCao58y/EJKvfx4lJNjGrbiCHAsOG6pYY6EXA17cU13ZV+3xhpI+mdJpAv2lEXr8xaN5nXMjmrWhBQD+sATWNylTc77lz9J4bZiI/L30vsw+wZKc+f4+YMP8I7YS/mjhpnfNMzeo0pb7O2GKMVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThP5EeQ+ZDBCUXmcDbpoKwZw2UMTcvHh72ohLmzMXLk=;
 b=C8rgNEcx8M751S1FKgmVLi9b9dBb3JXt+VBQpNDKEAwQVCJ2neehCfC8Cf45a0EPFbWFupzlNAw6zWjSKlLzRhMJoZP7BpmKU/Zdmi4lZvNQGu6eYgIiegwSdmiMhV2dGrdZaxrWRnevys6CDSAcvp+LEhpOaeTHngpUDUArvVm0gAPJSPD4x9zg4Rl4jfmk9u/0e1lbyyH9mPJy+66h3iy3OtS64zgLlNSyUNe79VpYOKxWBExx4C0JyQIlfEZLo0xaVctyzg3wSBC6xNZ5c6LIozMxnrgMAKp68SvwrobOileNZ2xux/Ev2xKd/cPA1+FeZpo5vuHvptjpVhE/EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThP5EeQ+ZDBCUXmcDbpoKwZw2UMTcvHh72ohLmzMXLk=;
 b=Io2bu4a1GWJWiXgpz/3pFq0JSIAKkvKuXXWKO9guT7zf4pcD0zNccYFZjstkEka9rlTxhbPBJoUJ7if6TjqqL5ceXkP/ZDP+GfoBBuH9O8QGmH3jBU8kOOQ0no8zIJ4QdlKkWGHunzFOwWuigg492aCv3zjHmYM2bBsT99RXPta2CQlXP0LnBz0RcQW4d6l3V0c/0oBgeqeAGHU+lxj2VABiGPPUo2hp5Ss63EgLKDGO2inA9h7Bnj/HIfkjuBaceEtho26ML05mg+lexaNMpV48IXv9JUoE7/E4BxEtrZFIAIfK9gAXyHBr1Ud5ut5bKI8T+52j6niIPs4p+Fnhpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS7PR12MB5743.namprd12.prod.outlook.com (2603:10b6:8:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 04:03:20 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5353.022; Mon, 20 Jun 2022
 04:03:20 +0000
Date:   Mon, 20 Jun 2022 01:03:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH v2 5/5] vfio/iommu_type1: Simplify group attachment
Message-ID: <20220620040317.GD5219@nvidia.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-6-nicolinc@nvidia.com>
 <BL1PR11MB52710E360B50DDA99C9A65D18CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <YquxcH2S1fM+llOf@Asurada-Nvidia>
 <BN9PR11MB5276C7BFA77C2C176491B56A8CAF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Yq0JKBiQfTkWh4nq@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yq0JKBiQfTkWh4nq@Asurada-Nvidia>
X-ClientProxiedBy: MW2PR2101CA0018.namprd21.prod.outlook.com
 (2603:10b6:302:1::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ffc12fa-3882-4ffd-dd09-08da5271cfd2
X-MS-TrafficTypeDiagnostic: DS7PR12MB5743:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5743D38F2F8B191654273127C2B09@DS7PR12MB5743.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1OlNCIDP/VA0Nw3FuQSHjfU89hetjcCk0gBu20znr05wprqCEoHNmLiFn6qgpf5oTIsxMqqt34UwzQnJ8zE1Jvt9EMYZxYIlIvQSgUWe2oYY6Mv7+M3c+pqKmSnkjFCcaRUOG5E35pEr14QyFszwOejjVpn0Q5B2PpI23wjL7A7eEh4YvKChJhBSFA8a0OY1kCRAWoUIQwT/vss0cah9axJXsc8wPxt3fCYIG4A7mB7Aza7iukgJSfoGBdUcSnF72QdDEQQUMVBU8PS8PuxT9XhxC5XQ2jNh/D12BVy0udDCHv694dl4eXEEeLkEXz68DBp5CSJZ0sgx/lSxODcw+T4lz66wurT3JtMXMXjyW+cBxCFz9sd5V87X7xSjnsp7utgvX2P68lgvo7dG4oAtN9yVARPYjWNp2K9bYwMenulLfDLppMZ/DJZ6yAA53T6EcrL3fCE0xLc2SEUer4eAdcA4KXF9IQ8fbVKJwrPd5eWgFucnE3xODwnjoId/azk/vQKwM1a38D1wZwPNULNuT/gemURbRRyENssVdodbHegn7dWcfD2Y+9Kadc76k/PqeftivgBhMrtLJAQL8+6ky0iFWLJjfMEoG/Y2rHhOvoErDUjte7iQuRpSSJXaJVqB+TezMjtfU42jbqSEGsv5rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(6862004)(6506007)(2906002)(66476007)(66556008)(4326008)(8676002)(478600001)(8936002)(7406005)(36756003)(26005)(4744005)(316002)(6666004)(6486002)(83380400001)(37006003)(66946007)(54906003)(6636002)(38100700002)(86362001)(7416002)(5660300002)(6512007)(2616005)(1076003)(186003)(33656002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TLROKD5CyEvZwCEnYD+GwakM1HU80UbqCmUp6VciYy3HN6tADoFspt2LtA8b?=
 =?us-ascii?Q?LGjtqYvQOzlY/Xxsyl2hfIqPkVMhKBe1bTCoNNg1UZnMoMZO4edeaeFJ8/do?=
 =?us-ascii?Q?2IJLxdl04coMCUqRr7rxELADb0qzaaqgKQjR+X6B9pSu4VVDlar1mUaluOyh?=
 =?us-ascii?Q?TsUvXx2L87KVKihrV2JOHbM+b6xuw9rrO3hoSAf0qui0OVDBNrWAq4KMyVUl?=
 =?us-ascii?Q?BgCtbtAuTCLrco8g8ObiaPaEsgcyFxoFjW+FLE3jFaDgUXoPdHjz5yduNsdf?=
 =?us-ascii?Q?8MrA/NIwvJQffK6tUZ7+4CpAW5Ruf8sMgpCqj0YpRqT/1sTpUkVTNMAuFzBU?=
 =?us-ascii?Q?Nr56fInXKRXFykXH740ac1prA1N9IpOi45Hq2qycrENH0eqwiB4ndibeO8Zc?=
 =?us-ascii?Q?9Ylhy71E0Uq/fJLUhec6/QK3FeJJFguDnC06wQWvXJIZEQHHi5YssE3lGr88?=
 =?us-ascii?Q?Bs12EhkeU9KTqKnX/owBPd1vhrD4Pd7egL/8FLcJg80kHoksx6tVq6bORjYO?=
 =?us-ascii?Q?u+p63AHJrG9HFoDy1fT5x29ax7R+2+gvpseRrqBofSKStlG5JtLe9pwHcUfk?=
 =?us-ascii?Q?jByM7I+UMr1KH+8b9BExQqdrmZ1kpnTClTqIBbDpQJ9Yu3Risimd2uOyqOtX?=
 =?us-ascii?Q?/kAdvEPsIO7GFf47AQv1jOrrxx7Df2MER2wvJx0uaOrsWUX9TjPHBBVBnucb?=
 =?us-ascii?Q?T2z7CYXfpKpGb7VnUga/7H0arAx/AB/1ys+F8spl8m9kk9S1tK3rIoKb0dC7?=
 =?us-ascii?Q?X6rmrRfvmCZmoEgfOe/ktuxfP5ATQbBqYljfSffD2qhFJruNaf17zsh7jMle?=
 =?us-ascii?Q?8Q2+ekV6YOngLVk88pvKB4AwnVYSWT/1sMUZepXrzzHrIAS6KZnquUTVbL99?=
 =?us-ascii?Q?Oo1JYJ2xTeYIzIUc+1Kluje/r14M4x5Ic16jyPmUsxqBMLWhYVXwcSIb17vX?=
 =?us-ascii?Q?zRt33TPmhGcmDEiTFihjA4wMYHu5Ncw72gq7IYp8wFSoIOoVo3myGbFwDo8F?=
 =?us-ascii?Q?cH3UjKtHIF/XRpzcqG8xctytB8xa7UIb+AmMBr+Mtv8HYide59+RNYkNTDP4?=
 =?us-ascii?Q?dNtxUbub+1//9HjFmZXuzJDj1DTllWPBPIrBeJLqOAkJZQRBc6HEuozqvD0H?=
 =?us-ascii?Q?qw9PHAoaW6oVKSvup3Um3hvPGSswEE/y0FZdqagwDx88kVyhOeUg6fKTb4Hb?=
 =?us-ascii?Q?rZkSHy0glyHPESeseDHUDI2VBdhCTg0oC5PhtEbvjXWEeXhkC+tw6g9YeyBd?=
 =?us-ascii?Q?CpkkE7Q16rLxBmuE+NGQQaF8de9ZBYN+pRtgjsyQ7E28Y1QT4zEkLF5BexGU?=
 =?us-ascii?Q?icTvlfgytvVLBjcCYrQn0j2GMK3BXcrPmNQio1+xKUFa7Mok0e8+a4Rxei6d?=
 =?us-ascii?Q?gSiSI6kzcsnVtXEZ3bHUjIWnAh/AJreRJxy4PU/UmBaf74Kxxs9M/OC1FJV9?=
 =?us-ascii?Q?ox5W9vVA/c0aCey4/DeD6cgX+xLfgizZI5sHQIprmKeTIVxekt7vcZlUU5jh?=
 =?us-ascii?Q?3j1u8zOM8lSu5KmNBLEYcZMi/delh2fW6WbVT5XzyOK//RrEfdEkdNfGLEkJ?=
 =?us-ascii?Q?MojxSFQ3Bw2xSbCVRf4NYyzFnvxI+Fa7QKzPONfXgpsYZCqPZBCRHq5+h/BE?=
 =?us-ascii?Q?W22YqjCnzNQaMhMksaXArA1l7elvpzL+XcS5whxq9jnP/Gy67yH6ZydsZiXV?=
 =?us-ascii?Q?eGQFGLzFCa9o0hSbtdSssMg/nQSKWuk30D3E1Kz4CXbikUbDtDeix3BEqMkd?=
 =?us-ascii?Q?FVtfifxlFQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ffc12fa-3882-4ffd-dd09-08da5271cfd2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 04:03:20.0967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRZunGZtKJI1pF4+CC1DhZ8W9+HBQAB2476EZ0NtLO8aMbrpDgLnqm3qQb2EGifz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5743
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 17, 2022 at 04:07:20PM -0700, Nicolin Chen wrote:

> > > > > +     vfio_iommu_aper_expand(iommu, &iova_copy);
> > > >
> > > > but now it's done for every group detach. The aperture is decided
> > > > by domain geometry which is not affected by attached groups.
> > >
> > > Yea, I've noticed this part. Actually Jason did this change for
> > > simplicity, and I think it'd be safe to do so?
> > 
> > Perhaps detach_destroy() can return a Boolean to indicate whether
> > a domain is destroyed.
> 
> It could be a solution but doesn't feel that common for a clean
> function to have a return value indicating a special case. Maybe
> passing in "&domain" so that we can check if it's NULL after?

It is harmless to do every time, it just burns a few CPU cycles on a
slow path. We don't need complexity to optmize it.

Jason
