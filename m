Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CEF7784C5
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 03:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjHKBKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 21:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjHKBKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 21:10:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4792D40
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 18:10:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ti222+kWHGUvgAzNiVn0AtJ/YkpjheFGsH7As4rqRja7XkcheS8MkD8Yv02+d8bBBIHhsq+KWUWOTufhFfJ+p5ELErypI/PrDwiazOInCAunIIX8N4Fjq7yovyh2c867ruyD1ot8eBu9ma3iPtfZCqu+ePNydn5O8xKuRfnJb9tEgpR3gcJWC3xbgiYccb3ATSblA3T74STR67sJ7Ttb3+Hio6QiAcgrR1Gq/NupVuBSde+v0E/V7r3qYyH+il4eTjX4w9YPj3AWIuGCqXndxdoTGdAwvkpewp/W8fVm82xYlr0GGFGvJ226dQJ3UpqbjWiMarzsdcuwXreF1xKYdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aFHFZzSNLK3NaaAdFHFo0qav/BGDLCkPexxlphmnI4=;
 b=BmzpubfQsTAd0M3qVaIA5cT+/lYiPxUgvITFG7TyfdZNM4+Pcxy/2MDyxQUFwClZgTlPdCSlP3EQoB8BMuizqP+QBMx8AtD6IQ/CcXov8BWuidCZolmkbeXKZeVttZGrWMDg7Mf9OrbwabAs9wJRRw/o4SFap0AbZAOwzETcRhJ40m+2rnjwUcW8TEnzQ+XVLnuh/Dtynii9r+hYb8SJB9rPIRxUZ3+oXjxXmI8gGALgMBsXvtK/4R2+9ooIvREAi3Qaty6mFD93BU5c65+sg0Itbn7NC+tSesb+a1vlW7MI+P+/t2isk5P6sZtEfLGUSL5gQ6H9HYEf6Mo8l5ZyBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aFHFZzSNLK3NaaAdFHFo0qav/BGDLCkPexxlphmnI4=;
 b=MT0ZJ5fgOLVbDR9viY6kkTCYV9nNTP4JGmwKk04SnvHCD/K40kghV5N4RfBXbGNV8572c4ySRO1n0t7fmZsTks98U5m6rwm/92GSsslJ1JS0QqfIk9f3VeqJvLDPjzxMmb0ONbrct5VN+rJ624bu6PuMULCQRqur6h9oXXHWaOrWcv55xQxPLAhuSQiP2VGQKzwrmad3bm7o/HHKMNB/+8dyloXAIHCNFFk60NmIBQ/qna33PVLIiZSX5Bqwhqn1CX9uyAGuE872RVQk7w38rlXBGx6/bRVBP0TiqM7CSJHEqaSzEFNQGYCHzAoHz9V/mTuCAJg8KebJnsAwcQiAzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6659.namprd12.prod.outlook.com (2603:10b6:510:210::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Fri, 11 Aug
 2023 01:09:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 01:09:59 +0000
Date:   Thu, 10 Aug 2023 22:09:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Message-ID: <ZNWKZLJUMnVOEjef@nvidia.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
 <ZGdgNblpO4rE+IF4@nvidia.com>
 <424d37fc-d1a4-f56c-e034-20fb96b69c86@oracle.com>
 <ZGdipWrnZNI/C7mF@nvidia.com>
 <29dc2b4c-691f-fe34-f198-f1fde229fdb0@oracle.com>
 <ZGd5uvINBChBll31@nvidia.com>
 <69511eee-69b5-2a83-b7b9-f4a2664e15e8@oracle.com>
 <ZNUymqfxICNh0pUO@nvidia.com>
 <113513fa-ac9c-31c4-6d97-ca2055ceafed@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <113513fa-ac9c-31c4-6d97-ca2055ceafed@oracle.com>
X-ClientProxiedBy: SJ0PR05CA0192.namprd05.prod.outlook.com
 (2603:10b6:a03:330::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6659:EE_
X-MS-Office365-Filtering-Correlation-Id: 75cd3b15-f8dd-4f61-70ec-08db9a07aecb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dAmLPnQmHSSSj84eUHqNBYsMQ2ayx9B4lqRKLqidKxQN7r98p6BrcEhJH60m6HDb+2QOtflPVYyOrWTz4fXpqQzVWTagzDb5qZwVxicIFaMcPXMDt6OOB3KtwaqPMMwX593XFNmDlFsDATn2/XWRgMyzZB8oReO/3z4I6+7T4F5uuK4Cq0KXFweio7nKhtyUSpOq43XYvalxcGgSVidxOyIJKAcfuc4xrxAq9s8/6xUKAJKJTwcPx6rmAqN76/8D9ODOq97wHFNXd7wP2pn74BZ5tiNixiZYyB8EpQogWrj7TCVEK0Wd0IBnbYZF76KdfpWa1moj/OGdPKuCSAbNB5GOo+QYACVHk9JQbDzHEvahlBCUqtzgC6t1X3VF+A34VrrQ6jWORlDpk/c49z6tOpl0lZaZ+w/OAAy6ZroWyewjm2wgxYOUrgQOK/ob0aEb7QgwSjs6ZTAt3S6Z2qErl5PLecRKXm3IMRUAzam46XsSHmHBX6RMV14BgQa5UghvuyjfpeOJFExDG1HpY53ZSvgmbao6Ytl1y7FLSMPZb05eBfma2X+y2NFs+8LieZt4jJwdEuhh2yJwE5P1zi17C5UJHXTqCiPpxGuUMydiTqWwl79f4K7uFkZ+XtH/svptSsHPJCK+IOoFbRQG0yqj8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(346002)(376002)(396003)(1800799006)(186006)(451199021)(6512007)(966005)(6486002)(6666004)(54906003)(36756003)(86362001)(38100700002)(26005)(6506007)(2906002)(7416002)(478600001)(41300700001)(5660300002)(2616005)(8936002)(66946007)(8676002)(66556008)(83380400001)(66476007)(316002)(6916009)(4326008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SYvJmw7pkkKBqB+RIf0cR7BvCi+mV6Lqj+hc2TK18J60ii/HmdvK+dueC15B?=
 =?us-ascii?Q?yx//QHhysLUGnkrCjEFT7seO6qO4AeZuL9l5at9pvtdToDiJ/WJ8t1Pk+yY0?=
 =?us-ascii?Q?mOgULb9CX5Jeg5JlnYt3cZIMwxbdWSdgPYTjH9lRPRyxYjTN1u6kH7zmR/Sr?=
 =?us-ascii?Q?yIJhQyJslffZZmHuHdJMERNvwE8bI9k0oKsqcgRq5rtthToM6GWIDHaWxI6L?=
 =?us-ascii?Q?CCS03q9W1gSVkHxVhDKkJK+KfzZ/8RwmVpJjRPNztMiK92+ClJgzjf+MWVCO?=
 =?us-ascii?Q?TO5mjt0aPksYnOvAei2UckipeYtfWu9/3rgu3Ob73D4JZuVsl8/jS3TFsvKg?=
 =?us-ascii?Q?+ODk2ru6f7AjBvpR+ke/i758qKx92j8hE5DOsJ34fT84QBbCAhMjZ258J1BP?=
 =?us-ascii?Q?PSNGFHjmx11xJgy4h0N/TK0qYt0nqSlOMi+B9Aes97YbKJ6rqGx3Of6opaos?=
 =?us-ascii?Q?ifz9C+yUgwE5r+wN1U6oaKtWT2rTxn/Jj1cb7dGEtXQEMYiSvn6ORp8TB4lq?=
 =?us-ascii?Q?FrC+ZZU489kPWO8UUlTM+CwsCYcyusE7KXdWEGO8ysVhak9cwC+nBYAOnDuJ?=
 =?us-ascii?Q?E74w1eBcyndRLeTiNpZ3wjH+pxxUPEiExxsSa0U9vmdZj4qLUUKo8WrJtj3Q?=
 =?us-ascii?Q?gEYtrRa5ribub/owYP7vgPmZywhJz4DMrQAevbOYJFU3IkeDVbpXfWAta5YR?=
 =?us-ascii?Q?faeuTCAr3Hu1K5LMcUk44ZliWsSM8k/f7UynubKLg/rOHruGIBL2yXiIHMS8?=
 =?us-ascii?Q?DeP6hHQMkRSvF3SRiVlltkc7+iKd7xAn2aLJ/S2lBf+AH9ExjESOR0Olncah?=
 =?us-ascii?Q?7dJsAoHcb+oICNOkJzpRSt8qhC5ZASNAd1JtcJ/PbfPSxT8rsU80EXRSJZbi?=
 =?us-ascii?Q?ybWV6+TSXMoBOR0rr8JVzkoXsFvNbkHZA1AxFwJmClV9iw4L8PYAk2dy3aNj?=
 =?us-ascii?Q?xYZsLfhkaGXrq22sEuCJocwywNsIWgmaf0ood7LKB4+wE1qVMhRE7/aoJJjb?=
 =?us-ascii?Q?iEjul8XnZchRkPPg9VoY9DAP9wcqhIPS6kLt2FU4jVK46f9C11p8mpxpHv4U?=
 =?us-ascii?Q?m5Aqnd/KO6O7FNXo4jqKFidhJhkmaPMNJm9dajBIQFsqAjvA1+lt1BwE31MI?=
 =?us-ascii?Q?rbHfmRifkb6sbZeJq3nsbVboYsW6OiG3LJw7OGN4GiKu1lJyPWqqTL2Xl+ji?=
 =?us-ascii?Q?mju07i4p3PfpRv27RwdbkfI4R6anVNhyI6SeJFkN5h898etu3Qerbt+Ja61l?=
 =?us-ascii?Q?YArl8k6KhfmlapgXen3Giz/tLe7uy+PZU04fkaeB9GJPlnb9RZrRNZyG50dL?=
 =?us-ascii?Q?FsYcVOXuk9XtcG4lY2poRfJTIY12xcbH1PklgyzimcQD/fM8HnGwBoNiG53B?=
 =?us-ascii?Q?1RjA9NMb0AIXe3odixPSUvFlzMJMcvn/8N0Hx9sXp9VUDxHkIugHnHco4khU?=
 =?us-ascii?Q?iL/MshDTMqsi6xVa13l64MWI5tnejri6jY4z/OWmP/d0OQwvTIrnm/XkXGnz?=
 =?us-ascii?Q?NG3PRT3uAjR3Nk7nWssoDk4lBMEgAM1sSo8+iRVg291r9N2utrrVap0A0BUL?=
 =?us-ascii?Q?6VAxD35hNMm1waUJ6HLzLyqnSiEBfK1x7G3A55Jp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75cd3b15-f8dd-4f61-70ec-08db9a07aecb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 01:09:59.3742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: welUu3d68sjawtlz1KuN6HdNDHjKkTHOOtv2Zw4Ys39yBSAcwEwgrrGOdRa7gStS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6659
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 09:36:37PM +0100, Joao Martins wrote:

> > Yes, the "domain_default_ops" is basically a transitional hack to
> > help migrate to narrowly defined per-usage domain ops.
> > 
> > eg things like blocking and identity should not have mapping ops.
> > 
> My earlier point was more about not what 'domain_default_ops' represents
> but that it's a pointer. Shared by everyone (devices and domains alike). But you
> sort of made it clear that it's OK to duplicate it to not have dirty tracking.
> The duplication is what I felt a little odd.

Well, it is one path, we could also add a dirty_ops to the
domain. Hard to say which is better.

> (...) I wasn't quite bodging, just trying to parallelize what was bus cleanup
> could be tackling domain/device-independent ops without them being global. Maybe
> I read too much into it hence my previous question.

domain_alloc_user bypasses the bus cleanup

> > Return the IOMMU_CAP_DIRTY as generic data in the new GET_INFO
> 
> I have this one here:
> 
> https://lore.kernel.org/linux-iommu/20230518204650.14541-14-joao.m.martins@oracle.com/
> 
> I can rework to GET_HW_INFO but it really needs to be generic bits of data and
> not iommu hw specific e.g. that translates into device_iommu_capable() cap
> checking. 

Yes, HW_INFO seems the right way. Just add a

   __aligned_u64 out_capabilities;

To that struct iommu_hw_info and fill it with generic code.

> > Accept some generic flag in the alloc_hwpt requesting dirty
> > Pass generic flags down to the driver.
> > Reject set flags and drivers that don't implement alloc_domain_user.
> > Driver refuses to attach the dirty enabled domain to places that do
> > dirty tracking.
> 
> This is already done, and so far I have an unsigned long flags to
> domain_alloc_user() and probably be kept defining it as
> iommu-domain-feature bit

Yes a flag in some way is the best choice

> (unless it's better to follow similar direction as hwpt_type like in
> domain_alloc_user). And gets stored as iommu_domain::flags, like this series
> had. Though if majority of driver rejection flows via alloc_domain_user only
> (which has a struct device), perhaps it's not even needed to store as a new
> iommu_domain::flags

Right, we don't need to reflect it back if the dirty ops are NULL.

Jason
