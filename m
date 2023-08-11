Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9177797D8
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 21:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbjHKTft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 15:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbjHKTfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 15:35:47 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B671FE3;
        Fri, 11 Aug 2023 12:35:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcHtqcY49zNnajQ23xPVNXbdc/GeQkdmq+UKfNvhf6A8mrRKE7s5vd4jkx5LmMduOgfaGa2/E2p9X6bwXIaYHAzPl2+0InI4K7+Z2Ij14+FfToegVrWhS/g+fTCzF2Gm865psp4odK0avRgBBpkeEyfT/sna65pB6q3Cj5eJ4g92IJPRfPzDljzC5vDO6nQgQZ+ol8MiOFYL1L3kfBnTDAS7L1IbYXk1zcUpdwsw501LvZgIscNb9mO1oaEQR0CEK7IiMEoIOmO+CJ5ejGy2Er2Et6UGS7YtLhNl7spsI7ZxgBXAQmoah4yQM4PgjG/Rwrn1nFTcIEFnVuFlnfiLDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfoGldP2OSn5G4HX5cWOwJh4PtSzWl/xwqtAHlnKEa0=;
 b=HmCu5aI+gBp3J0h62pKYH/tC37kTmjSUVn8KCCkWlIe0RnD6wTCPqyYk/n5018Q6AstzFa+JvOdecKwusXrk8gCAm9s72drC3W0k/5YHjeFQQIFVU7sXBtAEb0Afh6UGmtErKjJysuTZ8knOlKm8LVjiYrj+6fzCfQfH/tF9GVcv9q7JhMdcL453LQifGmKzAfbMk7DtIsDwNCKQrXHFoU3pLB5xHEtUGP+qoICScoEEbDi7xFYK8CDYAV7+PnrVsY0MazqwPZ9x+2Ixd0IZmehua82pj3W6ZqDXSxaPFTrSAnvP4IXQjs0RrVOVVC0EBMOytM9v6wQfhhn6qDjjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfoGldP2OSn5G4HX5cWOwJh4PtSzWl/xwqtAHlnKEa0=;
 b=E5Al9twyOCHM4wTIPW95tb1QHUJZE+yiagSVnYGQOd2VmW7vIUvJm6SRt6mkFmpxENaUE+5JzXXaicM7XjfKuOzZLLd03tKr+8V3pXg6LCmbpudXNzYRw/8v928VBhXfQ+qM6uUuPa9qDRuXufkr43lssctzFLLNDOPwuTBqGmQWkwGe26Nmi4fKyne36hpVvxtxToR4q7i4fX73ypJIoZNqgmxyfhlQlwQ3BAfHzKrSjtwg/3zfKMbO5esWTaSxjZJTtPKgLtKmxXufeDMkx9ESWBBh65E8RRVDU6NzH0/r85MobwMlYdey6NcOXkQRpYVaed54oBhEfT8djYKn5w==
Received: from CY5PR15CA0048.namprd15.prod.outlook.com (2603:10b6:930:1b::10)
 by MN2PR12MB4077.namprd12.prod.outlook.com (2603:10b6:208:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Fri, 11 Aug
 2023 19:35:43 +0000
Received: from CY4PEPF0000EDD6.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::78) by CY5PR15CA0048.outlook.office365.com
 (2603:10b6:930:1b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.31 via Frontend
 Transport; Fri, 11 Aug 2023 19:35:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD6.mail.protection.outlook.com (10.167.241.210) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.19 via Frontend Transport; Fri, 11 Aug 2023 19:35:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 11 Aug 2023
 12:35:29 -0700
Received: from [10.110.48.28] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 11 Aug
 2023 12:35:28 -0700
Message-ID: <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
Date:   Fri, 11 Aug 2023 12:35:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in a
 VM
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, "Mel Gorman" <mgorman@techsingularity.net>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
 <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD6:EE_|MN2PR12MB4077:EE_
X-MS-Office365-Filtering-Correlation-Id: aec95a83-517c-47cf-7b51-08db9aa22725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cl1iYVoEiSGCqCKe9ctGfVbfiSMYLlbYOJN75g+7Gwq2oRKAte7rUshGRad1Jld4+cDIHFSl+0/Ja/QlfT1Eo5RPH847A/r2upfMgVdeXZAplM3LtDDDZNl0GOA2xtP2wBVGHetCo5Ty4arZPPI9W3T6kgOpNw2DbWIyEmAGadS2bUEHlI8SnXCU4pdZgIVYgbLXmcJsP2h8jElvuJo/ET6nBQ/OaDIp1M2XL5nuC3gVCeNSyltL9su+DZQq77rlYxe4D/0AUDExV6eD6hotvD4JxBRhC8Jx3LtYSe8iW2wJBABm+ISYVnxtWyqQp3MDpjKBgMD2OTFNsfGjF5vU9aMbZR9kgTQsSbto4bdYs9gqIVlZS3GVZIaCJt/nrX8a5ZFmbVqs06L2mE67YgjD8Zq4UIGlPdRKiSt2RUQtkRa/CK8FGvusNcnN5mwdO42NN5YQDgnt8+L5B0jF/ORP/ZaO0ihZiFChi19obzQWKfh63iT5O5duKYlBkdvgL6SE8Q6EBOBaxLsKRdsJnGT0EE/xjfwcDCqVhFuBUZTwhvjMSPycio2in6wp7d2yyPHbfIX1AJshWZlg2mgtvKNC4bP741FlotYkp5p1opT0OeglthrXceJZY+hVPbb0Q/z5xP7lWYfcGpEniENXeQtwYfdIMqKVRkrEUaeJs9tnoqrgDHXH3W7pnGlSUR2g+ry7NNGYh42FLxIMm/m06wZJrqwwhtbLkabbjQGZpfAH2tEmfuhHWqvEcx4rCghF8FWPe/3oqyiSbRJsRDA9vMDhlg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(396003)(82310400008)(1800799006)(451199021)(186006)(36840700001)(40470700004)(46966006)(31686004)(40460700003)(40480700001)(54906003)(70206006)(16526019)(110136005)(26005)(53546011)(336012)(478600001)(70586007)(86362001)(36756003)(426003)(47076005)(83380400001)(2616005)(36860700001)(16576012)(316002)(41300700001)(7416002)(4326008)(356005)(2906002)(31696002)(8676002)(7636003)(82740400003)(5660300002)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 19:35:43.3798
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aec95a83-517c-47cf-7b51-08db9aa22725
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EDD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4077
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/11/23 11:39, David Hildenbrand wrote:
...
>>> Should we want to disable NUMA hinting for such VMAs instead (for example, by QEMU/hypervisor) that knows that any NUMA hinting activity on these ranges would be a complete waste of time? I recall that John H. once mentioned that there are
>> similar issues with GPU memory:  NUMA hinting is actually counter-productive and they end up disabling it.
>>>
>>
>> Yes, NUMA balancing is incredibly harmful to performance, for GPU and
>> accelerators that map memory...and VMs as well, it seems. Basically,
>> anything that has its own processors and page tables needs to be left
>> strictly alone by NUMA balancing. Because the kernel is (still, even
>> today) unaware of what those processors are doing, and so it has no way
>> to do productive NUMA balancing.
> 
> Is there any existing way we could handle that better on a per-VMA level, or on the process level? Any magic toggles?
> 
> MMF_HAS_PINNED might be too restrictive. MMF_HAS_PINNED_LONGTERM might be better, but with things like iouring still too restrictive eventually.
> 
> I recall that setting a mempolicy could prevent auto-numa from getting active, but that might be undesired.
> 
> CCing Mel.
> 

Let's discern between page pinning situations, and HMM-style situations.
Page pinning of CPU memory is unnecessary when setting up for using that
memory by modern GPUs or accelerators, because the latter can handle
replayable page faults. So for such cases, the pages are in use by a GPU
or accelerator, but unpinned.

The performance problem occurs because for those pages, the NUMA
balancing causes unmapping, which generates callbacks to the device
driver, which dutifully unmaps the pages from the GPU or accelerator,
even if the GPU might be busy using those pages. The device promptly
causes a device page fault, and the driver then re-establishes the
device page table mapping, which is good until the next round of
unmapping from the NUMA balancer.

hmm_range_fault()-based memory management in particular might benefit
from having NUMA balancing disabled entirely for the memremap_pages()
region, come to think of it. That seems relatively easy and clean at
first glance anyway.

For other regions (allocated by the device driver), a per-VMA flag
seems about right: VM_NO_NUMA_BALANCING ?

thanks,
-- 
John Hubbard
NVIDIA

