Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B89F785BC6
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 17:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbjHWPRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 11:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236971AbjHWPRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 11:17:40 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2084.outbound.protection.outlook.com [40.107.101.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496271720;
        Wed, 23 Aug 2023 08:17:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+XDGLuDkHJXXB5PvwJ/V4/GV5kRb7q+IHDYAF/kTA40h1BAHgSLASwDPaBD7r03RueIEWsyqQ06jlOnbOSdLJL/rRh3i4nUi3M1zbWj3DQ257VqIJ/JxUoJrNkgHAhSEAN7YXV8kZ+SEwhtgLH457ZuRwUBSbCHIlzU/HAdjKSBWWweYYXdllD6tkVmj/CDNdMq4CNwuAzE7VCNuxlNbxjI7JRbX0lwAUScOOUT2LQ69xOM0LP4hZC7TC3k1AjwbGtdywVKdMjB1pA6Dbt4BMjAcTB37DBXv0GVcmwOyn5s9++3EmAQB58azeZibygCnkfTXTONdnnWaWfRXWQuNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xI53rR0+ZLyjrhX9Yc6hycAFgLv8nVgOiXliDlWbUXk=;
 b=GsXviY0yJ/1QADFmEJSpgqwUjIZq7DEAOmoTF/tYKc5XAPdzr7Qlq6hb5rxRgund38LcVyqgwAMQZbkXL/9wwtlEUQUF4oW8vepPWYDqBI93dxEn5h+xA7lWiUPnGXdH1JZ8OpBo1JVeL/hr1coLMyhcWsMq2aRgnDNX8DBnF0rOQ0paruu1fzickE5gtG2/e8LPsErfWBpMfl3k92LtHKWRylLE2HyDslSfumzIqGyxBX7q6JbLraQU4p0vIUGbEy37HNP5dJyJ1NELnvIwY9VBw7lCSw5OM7YKJ62b7/QrI5n/ZS/3r233u84k8p85OBD2TqY7gtxhj4zMEPq2iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xI53rR0+ZLyjrhX9Yc6hycAFgLv8nVgOiXliDlWbUXk=;
 b=r9dHIqkUILPPo5ex+OjKhK9wnbpMA6hJkUxINEJ4eXRVMxZ1fjj6ko5hxE6heu2ML44kxMP5t5mwtBQ6WDOrTDVVgRwd53voD1mkFyT0Zvi2V+DH07lLdSh8ZQfWUTTsxM/7RP65UB+3b2kRVDNKkXUO5BoIWNqbsCBiIjzscUisb67AgC7y5zhFIHRP0kFE+rX5pvEpQIaeGUfEVVBobFFGcRSwl+uqGf1+FYBvDF44DHx92MAa28JuU1P0NZ0nrzSGDShGtn7vqnGf3NkFQAw6QZzM3H3nVYoiEr9QY+lRLBzlrjXkaJ9vw06HUiz77E2odF+cqTCSDHZf/OH0lA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6154.namprd12.prod.outlook.com (2603:10b6:930:26::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.26; Wed, 23 Aug
 2023 15:16:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6699.020; Wed, 23 Aug 2023
 15:16:25 +0000
Date:   Wed, 23 Aug 2023 12:16:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Ankit Agrawal <ankita@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZOYix7kFDYcvZ/gp@nvidia.com>
References: <20230822202303.19661-1-ankita@nvidia.com>
 <ZOYP92q1mDQgwnc9@nvidia.com>
 <BY5PR12MB37639528FCF1CDB7D595B6FFB01CA@BY5PR12MB3763.namprd12.prod.outlook.com>
 <20230823091407.0964bd3b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823091407.0964bd3b.alex.williamson@redhat.com>
X-ClientProxiedBy: BYAPR11CA0107.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::48) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6154:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dfd1614-a131-49ee-c84f-08dba3ebeaca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cT3jKg4wfcj2jrlhEu8l3nERJakW0qYRcgvi1XHPicm+VUL4TSizlbcwTZOOYa6S297M3ogP8U2RaqjgzEBtWIxnplJC2Ph760WOM9Z+V5tN7tRNjhYPbcQ8btY+GjuiYBmzAn5YNxmvo3korj47Zdxwjl4PX1SJn1jEvQD5CocGe2yWNMkdmi41wWeKw3gseBYOeMafOuiYsFYqcQjLKgOMSuzNdT9cIt8ynJtUI0xvdqdfIerRlSm0S4aRijsa28KBp/kCldIm3m3CDdo25Ic/1mpFGTJfgRGAJH4FELMDjmFYpIWpjVc2M1mt2R4DpIZjw/JKLs7EjLGnWVwqV2nl08XM1Re/BHKpZfLdMpxmfmNvK0OetsxXdgrBs+Cd+PA5yQBXW3Tc8XSynNveRb0zN3QgpB2dsu0kNBBZj84JD6apN3lBf9kyVoXyeo79IsWsTLlfpzjAdLPhJyfuFENe0x2/OKPGlVnlloTa+vOVlIs3HCCHd6/jDjs3TkbS+u4CVqTx7S8KMZ4Vp8Gr9bWzDC/y1dUBPq4fOy5WjIzsGFRuk0FgBSaMqN9EtOCi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199024)(186009)(1800799009)(41300700001)(5660300002)(2616005)(26005)(4744005)(316002)(2906002)(54906003)(6916009)(66946007)(66476007)(66556008)(478600001)(4326008)(8676002)(8936002)(6506007)(6486002)(6512007)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GRSKrnSEiiUQ3x2PJFfnupIKe9CLiJtgoGRtccjMNJ0vfnKgCfXuaCvUMFwg?=
 =?us-ascii?Q?rHVmg3rTwwhHPdG32k89VoNAOcVfUSic6U0Zs04XxIPO4cyr9WS/k4Ypzvm5?=
 =?us-ascii?Q?lWpfccmnDgFQ68CAD7HGmSHC42KlcoUO42AI+WN54jTaiBTU0vXFHZwfPRiJ?=
 =?us-ascii?Q?e0S+Hzoid2xp12cC4oTK97IcpNAXQXV+PUBktQbRk2kvn8E53aqItGKEI8AY?=
 =?us-ascii?Q?KJgozeKitCOSDjuVzRd/7aJrk8585i5S8ylCSMiJ0SBGhMXRKiB3SbOV/fB2?=
 =?us-ascii?Q?z3MLuJ1drDVLK2MKrzia1hUB3OdTwAKdl9irCGKNzr3NyJf7L6aoKcKLQYSb?=
 =?us-ascii?Q?+goHqaVbTbYiD6j5xIZMyEXuYlTQRtaFP+kG9jdr1+60oO6bXucpsrXZ3vu/?=
 =?us-ascii?Q?G9HpcSnB+gRTy6Ki6YMe3uScyTRJPc6X7/Un18xuhnQG2El/6eTo+V1oDZ2U?=
 =?us-ascii?Q?dSzanlIDgIt3+2urz35zGU2sR9zhUHNxtOq41CwgctWb5RbhFJQvL/c6x6VL?=
 =?us-ascii?Q?dnTJaa4YGv8/L3P0pVH5y77KKTg/1sfsi4MXhjcfNtrO5MiUfP8GyV6mrqw4?=
 =?us-ascii?Q?6LxNiHdo/zLpsbQUVAYcK1nr2+JjrGAFG0clTXczhlgUbCekWlYFRTElu2ZT?=
 =?us-ascii?Q?kaZ5EPKtOXjM8dKhh3IOw0DfZ2TN8Ca6g1eE9LA2AcRQSQ92s0b4jVKTCYTA?=
 =?us-ascii?Q?APBWGhPaRtsZrnmuvlSAHFghavF7R6N+0jbfbZXuELzKQDfSB7LDh5Y8ZPLc?=
 =?us-ascii?Q?KY3aUk4POd1LMlsWVpKPXFDwAPMX60hc3MYPMvm9FgO4KHhThB0ojT58Jnug?=
 =?us-ascii?Q?p4XXYVkU+Z7saODqWOGLaS1z7Yj4l3I90UzdcohRhIiTVLKOzflDq7xhVz17?=
 =?us-ascii?Q?ffFsuUBQNozj0svPMQW3haaHxwyg6r9hHaL0BtKS0scjyLvUw4PzdDfgW7Pj?=
 =?us-ascii?Q?x4Dsup7iT6aCwtz7sqEBshEAh+g6XqHAucR2bylquISWJ9n1V503rp0QaCD+?=
 =?us-ascii?Q?WzPOUhrrW0+JKkYoNs2AXywgXRaLk9Ne82FRphXp07J7H3ShcYy8uEp6SwOU?=
 =?us-ascii?Q?xHB0ZOnYNlSBUKxdTyrA2weqe5ufdhWUaVrkc1yQBOeXOL+/lQvG7xZgBLGV?=
 =?us-ascii?Q?qLf6OoyWpML5XHYSv29VMUneKHb2TEy7mdCPeIde0AvfZKTPjZSJckdyOrcn?=
 =?us-ascii?Q?8CWj2sZ/yLReEhEY8q/GZMODarw1tj8p/CMqMmmHgc/dviAWMcZWWGyhvy0e?=
 =?us-ascii?Q?rC/MKnmhVU8qjhK2vCgyx64bAybcBs2EakkAtFfjOjKgQ5y4qvkz8g0P5+o7?=
 =?us-ascii?Q?O7f1asbAHSVr+uCFK9nbUgmvuFgmbLhzJ8hn0xKxR6xu1EcMvZfD5IXVhA1+?=
 =?us-ascii?Q?j0fPhE/5bCStaqszvCD+yafRFU5A/KuUoCzTXdv4DEbNalgof171j56CPCdc?=
 =?us-ascii?Q?FaX7dAQw4PQawFafhXLuly72+wDHaiBxRbvDBN99sikJyAv6tAtd4PVlLBZV?=
 =?us-ascii?Q?4GExlXOjP/V8XG3EN4ITwKc5g2M1FFSi+4QndEm9qK9DAhyPRlo7grTJe+wb?=
 =?us-ascii?Q?mDEg2uusP69i6W3dBv34/tQtP42UnznbOPDlqRdb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dfd1614-a131-49ee-c84f-08dba3ebeaca
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2023 15:16:25.6454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRMU49nuCuhPCYBxmsywv9Mqa6rHCCmJ6VqYvLt45TVattcddMq47ko0cjz4Bas5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6154
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023 at 09:14:07AM -0600, Alex Williamson wrote:
> On Wed, 23 Aug 2023 14:50:31 +0000
> Ankit Agrawal <ankita@nvidia.com> wrote:
> 
> > >> +     if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> > >> +             if (!nvdev->opregion) {
> > >> +                     nvdev->opregion = memremap(nvdev->hpa, nvdev->mem_length, MEMREMAP_WB);
> > >> +                     if (!nvdev->opregion)
> > >> +                             return -ENOMEM;
> > >> +             }  
> > >
> > > [AW] Seems like this would be susceptible to concurrent accesses causing
> > > duplicate mappings.
> > >
> > > [JG] Needs some kind of locking on opregion  
> > 
> > Right, will add a new lock item in nvdev to control the access to opregion/memmap.
> > Please let me know if it is preferable to do memremap in open_device instead of
> > read/write.
> 
> That's a valid option also, certainly avoids the locking and
> serialization per access.  Thanks,

open_device is no good, that would waste large amounts of kernel
memory for page tables to support something we don't expect to be
used.

Jason
