Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C77B3FEF19
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 16:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345388AbhIBOFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 10:05:47 -0400
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:13081
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345351AbhIBOFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 10:05:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8u+xT9b5A/9SfXqjlT9TH/a6ZiD9OdW7Ok3e0ox/3uJf4Lu+wywYLPbEW3yMF4xu87wRh4AjKi99cvjjrOPwGSg5jkgXQcMjSC4n1CJaH1ODnDZbn9JdiMGL0KBKxef8f+n6bLuYwjEh5m052Oa+b8w9lO4Ja2WodC8j4V/BVg7h8knZobwQIIiUitBSq7MY7ZzoGs0gdDzk0ggKCOkDR5jm/HCpYTfFTand87G9y7sixb101X/kRSJGaNHkDZo5NRmmbkZ9ZcpXnGoqPulWCGX0DCJZ8huFrcEQGis7eQd8UmoCpcUl7rKcyjDdFGpauIrhAQ9MzBwJQvaFNVeRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=w8KtbaSSvNWEMwYCDfmLUUAcfEoZZL4NLerwKaQjiFc=;
 b=EE3srKge3whKqtsYaq9ToPFuvXWBhlQW6LbORZPgs5/BF6ZJ2EgGZ3aYmFNGFvN/ZH3Oz8HdLT7VkX3hO+E8jB4V3bJqu8q+jlz6d6NSWKaS+a1ddsrBVdr6bbPWxQ0VK1zSTog+MWVLXnl4txKdPVle/+UNpLLdIR3aKPqCA68XQ4nomO3lFi9v9+uKh0guq+2pxJ41V9a0XHQOQ6v0Sq+MB2mze1H+vfZVkJqGY/QyxaF9OX79MFUYaCEgNDu8ya1gG2ZVcBQU0gXZ953c2PGb4P/UtmJIAVgCCTIhg10++Pac3dVwG0nm8o2SmhJ3SuvA05gjh4NROrxmdcg9jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8KtbaSSvNWEMwYCDfmLUUAcfEoZZL4NLerwKaQjiFc=;
 b=wvX6W/RyI6C9i3KiBun19idlOizZGi3dqtxzsvTyhLr9Jvh/cC6OP7f0OemdyeAnL6+rbiz9JjZwsnbNk7005a+2txRRa/2uAiDLO56sXLf5pp+67WxwkoXT+SOxvHDLj5ThJsolTT0dLIZSmzFXCicG0yQfFuF1CltZDpeOk2Y=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Thu, 2 Sep
 2021 14:04:46 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4457.024; Thu, 2 Sep 2021
 14:04:46 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     yuan.yao@linux.intel.com
Cc:     Thomas.Lendacky@amd.com, armbru@redhat.com, ashish.kalra@amd.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, ehabkost@redhat.com,
        isaku.yamahata@intel.com, kvm@vger.kernel.org, mst@redhat.com,
        mtosatti@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        yuan.yao@intel.com
Subject: [RFC][PATCH v1 00/10] Enable encrypted guest memory access in QEMU
Date:   Thu,  2 Sep 2021 14:04:33 +0000
Message-Id: <20210902140433.12994-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506014037.11982-1-yuan.yao@linux.intel.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0021.namprd06.prod.outlook.com
 (2603:10b6:803:2f::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0601CA0021.namprd06.prod.outlook.com (2603:10b6:803:2f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Thu, 2 Sep 2021 14:04:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74e5426b-fef3-4afa-69f4-08d96e1a9e7b
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368425C251EF6EB845088FA8ECE9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fl7ic724O72Iv1GS866DvlkeFIAbqDTQfIw1XhB/evxyGm6IClAF3Ua4IBLFKPQX1GwsdluwmALNCeDDBGKAZCCaBFNXSaRZVjyRmjiYYL4G+xWy+UETcTOTyKL/kokR/BJ5KQk2Rmx6e9Zo5azm0795TuBEWtdlvqOrTG5nb3VLMyYc80mh0ze/k1PlB/BXd3408rPZf41wOslLVXA2tlUJ5367HouAySOChL6+IDhAMoBNOGCnsjNuPhjcoC/HWd2MaiL9sdSBwQzuS89q89cS8fZ+6tGkqGKCt3cfegCO8oXYCNHagLtGlZCibvSHpAO9gLo8RvdF1f1W+ahj7QoVw1bVedP+5fotp6FbXbbxUi1+TNN+dQLczFmon36cm5vJFxiv8JGlPEOrPXI57QbV8mIAMYWh5R137KvqvGLGW99GyhVuB9doxxXEV7hE6OM6S+VWe+8fTMveenCbjYkOPjxNF+vds+Xdx3764uBgOxBvlmOYi8LXBfx1doME8XUk7T4ntuM816Wio1d+FeZ0OGbx4js36IgCsfmxoO1oKZAqUKV2bLd3NypqCPv2qFDv8T10eZcECBjK2JsmoYEUOcf4IMT8SuMNVS0j2YHbqWpumJ+qkxcSNQf/kjX2YNOLHkxPufip6KGOIGX3mWPB8VKs2H3e0n2bT8uEUuHwoQ4FGrPnSHhxDRWxtq61yoVvVBSS8Z08wfdw9aC2dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(38100700002)(38350700002)(86362001)(1076003)(6666004)(956004)(83380400001)(2616005)(66556008)(186003)(26005)(5660300002)(316002)(478600001)(8676002)(6916009)(8936002)(7416002)(7696005)(52116002)(2906002)(6486002)(36756003)(66946007)(4326008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cgFxWjclR17GhDQ9Czpt6gIEwq+Y7uvwEIaLiS0xz1+7SXIvS/G/WCz1zoPy?=
 =?us-ascii?Q?7m5+POGFbaXBJMDwypzsE4G+BNUtPaHZgiDZ0aQEk50GNaECEGlyGjGmvnoT?=
 =?us-ascii?Q?EZnHIVAbDjhIDEOzAaIFhJCNCguj8R8u220HXJHfiEzX35D1E6u+g0O9J87d?=
 =?us-ascii?Q?VNU5fibyOcjdCQoHV6Ot5+dlmIazURKGSSebhFd9xEEXp/VGGgWqDgLHAAl5?=
 =?us-ascii?Q?saEeUUmelz4opmDAMttSY+iiw1q9846T75Hyj1kiXIGcYxEtP9omjJEgGl9y?=
 =?us-ascii?Q?Zww0M/cXa5ASOXws+fLNtQQqlYPlnHA5+cOb4ZlDLF6g+SviEWUQz9js8UGL?=
 =?us-ascii?Q?pA4Z6cIXKr1QUSGej733Axjbm5m3VnPOCFXatluy2pGyEFNhYCSkmY5uUuU6?=
 =?us-ascii?Q?y7IN00QtFvvrntdwj081hzxojRdWX+qNHqFLHfC4+Y3Ykzc88IQ+5xMPzJDK?=
 =?us-ascii?Q?BOSMpS1z6yzGzEhBpSYGkTKVwDQ2YPidli1GVP4U4rMVro3kmSZBHODlU6gT?=
 =?us-ascii?Q?RRKk7nOZzA8G5MkaUvbzXcLMojdGDNa1wqfQc39wkmNvCnVSW6G7CoeSGwey?=
 =?us-ascii?Q?l73NVNSB/EJMfq1SebZ9ZglUpICfmq0uxJZk1lbt8h6fnI3YM2OBt6qGd1ws?=
 =?us-ascii?Q?zdtCFjHCJmo1kj5vfaxfiNuGx3DR1aWD/u/DFt+uDGkcC2sKFBuiEDVMt3O8?=
 =?us-ascii?Q?eBktfNmFPJzoyZ5NoBKs+J01mGxh/KNlKrYgs49Hf2GbY5gJBiOgg56McHTj?=
 =?us-ascii?Q?iC5ZRyTVaVi7ogRo6J1LAWquKHE7HctYM+RKq/oTDQW1702ZCTf1mvblQPWs?=
 =?us-ascii?Q?z/hVhaY6P2F2aqaq+A/HVUU6ylwMN3Plga/P4zcyHlPsvWAordNxYBrC8ESH?=
 =?us-ascii?Q?oHj+RIHIqgXdqn09TZOgGk9z32bIKO5GfItJtIMwoFn3+biWjKgRxvblyjwY?=
 =?us-ascii?Q?t7JHbRxKohDxOMeKqc8HMCqd1BOvkJboVoi9Ph88PYqCoiN1MsnD67zO1QK1?=
 =?us-ascii?Q?fGplr3rVAuyjiFWUolWYZBF4rT0M8bkbVKOvyK6JiSpLjDUxzJb3VO2PvCEm?=
 =?us-ascii?Q?GElLnFAHaKB+XLBwlGYxC9PS5nnPF9ri2Y2EqEhzFxsWiLd0aPGNpuFbGAdj?=
 =?us-ascii?Q?plhDfrl4CCWjIdt+l3PsEKHSQoslTNK1QnAx8b28dNNgmkuOCrh7kQWZSzaQ?=
 =?us-ascii?Q?j3+OslkPR7oo6swYLsv2RP4WMC3khKAimeHNsE7yK74qLH852kd57ExoS3EM?=
 =?us-ascii?Q?zC5Ea6jM9+W0+GUo4UOnuK4PvLsKbHoYplys8YtnuuLcnLmT12JSDYKnM97z?=
 =?us-ascii?Q?UH5/wxLV1CHf2VdrIFPrz++V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74e5426b-fef3-4afa-69f4-08d96e1a9e7b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 14:04:46.3375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQOVUMqA52QDEkcgjaBkdOS3ApyBFlY+5nXyMTpflW5DqLEABAXAxwsUtsPod/y5drbi26IrNKYE5CpDBDHncQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> - We introduce another new vm level ioctl focus on the encrypted
>     guest memory accessing:
>
>     KVM_MEMORY_ENCRYPT_{READ,WRITE}_MEMORY
>
>     struct kvm_rw_memory rw;
>     rw.addr = gpa_OR_hva;
>     rw.buf = (__u64)src;
>     rw.len = len;
>     kvm_vm_ioctl(kvm_state,
>                  KVM_MEMORY_ENCRYPT_{READ,WRITE}_MEMORY,
>                  &rw);
>
>     This new ioctl has more neutral and general name for its
>     purpose, the debugging support of AMD SEV and INTEL TDX
>     can be covered by a unify QEMU implementation on x86 with this
>     ioctl. Although only INTEL TD guest is supported in this series,
>     AMD SEV could be also supported with implementation of this
>     ioctl in KVM, plus small modifications in QEMU to enable the
>     unify part.

A general comment, we have sev_ioctl() interface for SEV guests and
probably this new vm level ioctl will not work for us.

It probably makes more sense to do this TDX/SEV level abstraction 
using the Memory Region's ram_debug_ops, which can point these to 
TDX specific vm level ioctl and SEV specific ioctl at the lowest
level of this interface.

Thanks,
Ashish
