Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A2C73C497
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 00:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjFWW7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 18:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbjFWW72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 18:59:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554983C26;
        Fri, 23 Jun 2023 15:57:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Endvw1k6aBCrnecLudF89dTty+py0eQMxsRJDJ1X2yxoIDg24jKtLx3YCEQmLtiBrz7lg8euGNrqFVVnE8HGHqxaPYCuOGWhMefFPwLqSA8xwiGTAGrKcq0xuImXPatF/bc+WGEoLN2H1puT8PR/mPgGln3roatdbxrbmMBOEXBEZSsqNMiZf4afN9OUuopNqJmrnRb1WziZ5b/IsTjC03shPf0zKkCTeHjFYyx3mGwZARohvQJDBYw7SLAsSzYiAU0XbAjG9j7hkzRJFiBmcwqKCq3M3L0U5dHFh2wAwAlz/6M8XOXs0HXMUWhmg8tUm4ImoKtMPdIg5OpACTKCdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMCQIMYc45wTDRgK2tNsiaaQx3WP4WxKiouyv6cq7vI=;
 b=DPSnTM+tcYiQ9XZ3mJZ2gA80+NF8hehyPmYLrUCL4538sr52MviDbI6/gdJM1xACrxsxtxrknpk+wNKbM/ZJ1upE1A+kOmgCsUnUWJYoipaJTfAq0Z35rq70HUX9BclO9m/yNIcTf1WTIqfWRS+aDL9rjLyEMMoOskgUkggu1wShRoJPodvqGZBYpA9acSGfTRMyjw/PQ4eBKpcjsPyDpZzWTM9gG1Vzb39H7MY7D55c62SLmTvKQjV0VscHH+3Slj0NbNYYUZPYyfMxTfFehvcWrv2BZBYz9J4q5WCK+m2GVErMA/K3godav9VvwySHymnTH9DwZVnEAla0f88I6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMCQIMYc45wTDRgK2tNsiaaQx3WP4WxKiouyv6cq7vI=;
 b=M8eDmLB8D4dD//0jsh7gMWppze27yTUJk7x6ebay3+cn89WJfgsImYqTMlWNDwna5mcahtLSY7QiSvRgLFL5+tXv8+kyG3kbX7k2qff/TOor8bwBgBOZzBBd8NZs5pAAo4P47BYJSR8mU8cMJr22J9idHRTTUVGEZ0ocbUiuEywm/qxHlWwrBwX9CFlvnAbvMXe7ea0xYBUU9LaMEBrsEKLaetl/621HkcVQ9RZ26ieF1BxSJuYItESCu5/RhX+EVHgQOQIZYyQ8LTgnugIR9Bg5YGpkrFYfcgapUfBu6j0egOhZ5EzxFhFZcdJSB+SeUDsjOAvMuIKQXnrtzb6i2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6230.namprd12.prod.outlook.com (2603:10b6:8:a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 22:57:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 22:57:01 +0000
Date:   Fri, 23 Jun 2023 19:56:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, joro@8bytes.org, robin.murphy@arm.com,
        yi.l.liu@intel.com, alex.williamson@redhat.com,
        nicolinc@nvidia.com, baolu.lu@linux.intel.com,
        eric.auger@redhat.com, pandoh@google.com, kumaranand@google.com,
        jon.grimm@amd.com, santosh.shukla@amd.com, vasant.hegde@amd.com,
        jay.chen@amd.com, joseph.chung@amd.com
Subject: Re: [RFC PATCH 00/21] iommu/amd: Introduce support for HW
 accelerated vIOMMU w/ nested page table
Message-ID: <ZJYjOor3TKSeIo7F@nvidia.com>
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
 <ZJRQseaYkTJGHNsk@nvidia.com>
 <7364628b-54b6-b7e3-b272-8f91198679f9@amd.com>
 <ZJWF3oVvdj4OQmTf@nvidia.com>
 <b3c85550-a7f6-a0d9-74a4-f98c8251b80e@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3c85550-a7f6-a0d9-74a4-f98c8251b80e@amd.com>
X-ClientProxiedBy: BY3PR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6230:EE_
X-MS-Office365-Filtering-Correlation-Id: c900d044-ee4c-4a6f-ed71-08db743d27b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0OwxPxePUvJCRo492JNx+mX6GPEBIfgAIQaO2qzxaUr2B7Q3FD5wguXsNDbFE2JMI/Uz7aIo0yTc3k4tMdSbCoF5IcHctYW6+vJ0lTcVDkJfSnKLZP2+44HeSSFVRd5LCezFxtnd1vMYbMmyHjvgNo3Og/ua6EmdOmH1Vly/ZFJDGpJXuPrF0fuP0pZm869ZPyZaf3tT7s/+PVWltr2Cvmp6hlCfyfwdCiwtuQttz2ZLBGuXgDdUUooZ/losFhAj13Yj58/bZGEzy2kXUW+JZrSYenRkHyoJIJQ9RoPeL3k0mZZzmMFdb7ek/3DVFS8LKcphUx8d1HZro3M0Kq+YYSVQ8i2P+T2Al3lq+vWMzZEl5/OZEakBYzBOXZrvMDv2s6dReaA698Vxt/KCq17M7oRNSVenk6xwg5iGMQkdlQZNJa8JOr/b7ptVbfT2LTH/E7XpKdo98c6wWpS6c5DIMjZBbpDlE64XmPWO6MsfYEEQFli07L3zF3Wm5aXe2nKfbZ48mn5W80b+TzPnz1KiXdTIp1cYcxbqwSivpc816HbCMZKhqzApabU741W9SKN1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(86362001)(2906002)(4744005)(38100700002)(36756003)(8936002)(6486002)(6916009)(66946007)(4326008)(66476007)(66556008)(6512007)(478600001)(26005)(316002)(6506007)(186003)(2616005)(6666004)(7416002)(41300700001)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iDCj+cOS278xjDOdKRc9+jwOLAHEA9XJqymgnQ/iXrr8o6DrHdHDx+y49FlB?=
 =?us-ascii?Q?qIPpmf4o+aW5fOu5YExSzBr8pT6ot0cgMJoQhpSD4b7NOeLQKIazrrfBO6IL?=
 =?us-ascii?Q?9NLexKhj3wNik0ThPNnMpzUL1SjKlmgtFdg9NQK4/HHHxEsrERt9LY7I1nbE?=
 =?us-ascii?Q?DHMJkKbN2E6XJU9rShjUqfrnesKfG1FCXNgCNrfTMOayTyNVgqxanAoRcHQK?=
 =?us-ascii?Q?CiFo+WUa0YmPtAGgAWn4sKZ5M8lgO5A+Qvzv4aWUPG6bwOvPqilmnHmqihyu?=
 =?us-ascii?Q?jbPZKGcZtcsMb3EBzB5272abDX/5WB+xQtHaiUVPU9t+wPZAHJBMIHDFLL9B?=
 =?us-ascii?Q?pZ4wX9aKytWjg2V+ZQVwBDyTRVz/Ty7oglfCz0ZKsY4UtRJanhd6ZPI8XHi4?=
 =?us-ascii?Q?Hdh+bBG+8X3Ll4IbPeKS/pR85BeyddrDxgwtazvWaA2tfXcv1p3FN/uWO+oV?=
 =?us-ascii?Q?GpKJcs5CClXP+pO45KlM3Q3yMtSLnJ0CVS4Ex4EAwfEjhHon83f+/Ouqc3wT?=
 =?us-ascii?Q?/yVcYm59icNXCWVjwP3qQmL3YC1BCZiekU7UaGbKhAqXiy5UN6megyyCPmmT?=
 =?us-ascii?Q?779XiVvjGik2gp5f22jzYaru1ctpynRlib237T91FYiDqiXu8T29TaqgQgKV?=
 =?us-ascii?Q?PYSrFVrqmM8TF4mqjFlbqJ1gJsJUAVcabKOKVmldelFkPKwDpzVC/jqii21Y?=
 =?us-ascii?Q?wIs5M4zK9TCKQMa759Gc6TqMs5XHH9sd6wlNkIhIPa0H047IUA9SGk6CVcku?=
 =?us-ascii?Q?9UoJ3Rdw98hQdgXwBpBgjX6xJklQuXsVHLBe/erwvEBWkEEfIfzD5eWIOC2C?=
 =?us-ascii?Q?JGYiyoE3H6D4Ale+jATm9/TnawT77F9+bBz7kzlHyKRHe92oSEgHDEfymO7x?=
 =?us-ascii?Q?mCRmu8QLt8tQHAvqwmTWuwE3A931sXu6jJTWlSl2/BuXu7W2bc7mR6UBUxFd?=
 =?us-ascii?Q?rxLO2fShmt7X6ZS7ejTLaLJcyhyMVjiBagpfqquNpfhcgclbjIAkUOI5Ba/p?=
 =?us-ascii?Q?9oTIPV5yP1RcSQuYnjHcSk2Q94VjSOrqm93uFioEPqDEOIeWA3FZT9BoEs8p?=
 =?us-ascii?Q?17n6DK9/ytq5ejxySzzzFg2FdgTnqShj/y7zfSGN3tFJVf3NKDek75DcqHG4?=
 =?us-ascii?Q?pmPNDp737d7XSzzwHXvt4a1Za+4JohqM3Yz+rQ87/zHyPA8iCzRmidNjyRpQ?=
 =?us-ascii?Q?ng5mC7Mwv8PR/UWtNdCL4zFBvmvOTxCdaypsUEZFvnhr1Ss/FBgnZsqHXWT+?=
 =?us-ascii?Q?tBp2SZ6HHApEazEeABjzjEt8sy2cxuxpuzx2hYIzQ6EupvU5cQmMjv1UGd6H?=
 =?us-ascii?Q?8gLj9s6ju8rNTQoTIjK8Fz7yX/zyuWV5NCnxO2Bi9mmeA0C1u7gqTbesjBjk?=
 =?us-ascii?Q?eDgFLF+o2TQrVVZbXauej/XZbrQS9AlEDJKt5v3Y3va8sT4ZcpvciDpjG43b?=
 =?us-ascii?Q?KrQaauUjGYvxqT1MBktHWhLhTYChS+pSf4gqikrXq8yBR8uibtaUY9hKceXV?=
 =?us-ascii?Q?Im3FtN4kQyNDoHOlb43PJIjkWRMANvNofPNjzz0EAFvcS1bKhXnQCsjLT6Od?=
 =?us-ascii?Q?xBSk8+yx8dz8TScSyF4BjEaFp7OySZlXIZSc0t06?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c900d044-ee4c-4a6f-ed71-08db743d27b9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 22:57:01.2461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LK1eCYWLb3dDCpjbIt5JLZXNUQZ49UQ5wU15/SKmhOyEgtvPyUd1EHpt6TxFJF28
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6230
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023 at 03:05:06PM -0700, Suthikulpanit, Suravee wrote:

> For example, an AMD IOMMU hardware is normally listed as a PCI device (e.g.
> PCI ID 00:00.2). To setup IOMMU PAS for this IOMMU instance, the IOMMU
> driver allocate an IOMMU v1 page table for this device, which contains PAS
> mapping.

So it is just system dram?
 
> The IOMMU hardware use the PAS for storing Guest IOMMU information such as
> Guest MMIOs, DevID Mapping Table, DomID Mapping Table, and Guest
> Command/Event/PPR logs.

Why does it have to be in kernel memory?

Why not store the whole thing in user mapped memory and have the VMM
manipulate it directly?

Jason
