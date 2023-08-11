Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B2C779701
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 20:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbjHKSVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 14:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjHKSVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 14:21:12 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E21130DD;
        Fri, 11 Aug 2023 11:21:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJ4Agpa+SldoYXX9cMUGu6Z4P31ZouGLmuqRrvDQSR1HHh3NtDiYU9XjJcQnIBZ2AtQv+aJvQxY+VHHZAftYUR+6riAKPh57UhFOE7Zflu9hHHTjDOE3sVQnIGrR2Il3CUjkrya33gRFIflCmVSWgkDzPKoREl7B7Ll3cxivjYyYVYRPa2z2xxgX0muEozGs+8vN34pAkpKk9Bz0w9mKvpNWzsimam1F6O7QBToXwLSjHMVJwPREAVrQdbIrpxH7xGiP/7Yvem83b/hFMYBa1a6qgG2tmAYP0Q6Vh/8mLOVHg+qytWwB6TWTalTcelKMZ96bBP9fhDSK9FAkF7dszg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmyCYJ8CQneTA/yCjp8OBFNwDWMJnlaBLg1MC5C0uno=;
 b=kfzVHunq8aqc8F/1MeDomb+mIBnjZbezYpI+hVWYPzzEi4RBxSQZ69K+H894eCRCfPEdi6DxbFUB2nQV5QK5PEdgRhPp5j6XYuOZZSZfb9/zUIOHWQwhrQ7xX9Xm+aikawabCKXLhfb5e6SLkK9zx9OmXSeu35Ay9dEKeuJayZOPSoK2b3kY0CEplxO/9ojfE3dsD8njytXRIBFy6YXikw3M6OLySYz82o9W4pBuy8TR7sgMXuTodOG1VZHBAwkQAPtJOcrPNJJLl1YMLdcLFFB66XvCEs/G6snSeKKbR5LDHLj0RrqseTFHuI0VtiIhqMogEGJNiYXeDXOU0XbIkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmyCYJ8CQneTA/yCjp8OBFNwDWMJnlaBLg1MC5C0uno=;
 b=rRpqJo8H5A6oE7SEflZE3bhJnckLKpG8L4bNn5GV8DV+WmVvv2j2JPiAP4uULRPbu+IIJnechenwAr8Q0a+lOT248hZBdswNKRKq6aXlHKTlpDc03b7DNqPPFKnqXdH22Pa5lwNZdbKfrYLVw2ZC29y8oS8WC9FXPqHFQml2hJQxJimYIAPUCzi8+3iGd0dL95WEQMEr1TQ8BlwOtTGWiAzLR65MALq6q+4zAt8EolC05FXJdD40I/h8AT7dodajzK1thOh4/vV9TMARdwEwDOUukkd7ItYSfLJcz9nVbaZfKZLR287UtRK2Y90euikn/TJeLdoe1HR31qICDwJHkA==
Received: from PH7PR13CA0005.namprd13.prod.outlook.com (2603:10b6:510:174::8)
 by PH7PR12MB6934.namprd12.prod.outlook.com (2603:10b6:510:1b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Fri, 11 Aug
 2023 18:21:07 +0000
Received: from SA2PEPF000015C6.namprd03.prod.outlook.com
 (2603:10b6:510:174:cafe::2d) by PH7PR13CA0005.outlook.office365.com
 (2603:10b6:510:174::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.9 via Frontend
 Transport; Fri, 11 Aug 2023 18:21:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.19 via Frontend Transport; Fri, 11 Aug 2023 18:21:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 11 Aug 2023
 11:20:47 -0700
Received: from [10.110.48.28] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 11 Aug
 2023 11:20:47 -0700
Message-ID: <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
Date:   Fri, 11 Aug 2023 11:20:46 -0700
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
        <kevin.tian@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
 <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C6:EE_|PH7PR12MB6934:EE_
X-MS-Office365-Filtering-Correlation-Id: a1870338-a6de-48f1-f2ba-08db9a97bafc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: raPla8IGi3rfJs0Um70A2BlPXSXj3dx7JAI5nT7Tgo/ptQcyu6k+L6vL/WyqbX6WdzCrTqpfV6vR8W0kJ4rzTyww2yMYy8nw4xpajfmdmAbx/cnCp/1/AYCXxCsIULNPJNlrv/p7I0NLSc+0CH/yOjD1rTKmmBnh+Jc1cF19hOJysU4IYWsyoFxzNQHJ0aTAJ6EaAKRiJ2Efz4hZEj9ZiCx+ZcN2c6mt776lss2bwTqfqiIfVDwQpgd5sUdKm2dDcupywxu/DXbDxGOZ+pPaTHH7g8jaBZpGMPC7QDmqGQuEt1bNhj4ENG6K1ZceZuqTAK22RoPFSFH2u7WRvyz0ohOc7Gr1kccN+QJOvmepajhOuDQhExIsmElqZ9anGryIGSWoVuA/9KHbDaiyepPRE8avA3qbHNZT7DrxkPXXtWae1DYk7EefCmj57ZCep9qUxcCUO+htUdUeNGz2NWKxVq4Tw6EMgK4N1nGmgD30DFzKaRpHJwX/igm6Sbgy7IyJX/hkaS6QdMs21V9kkopcQmOlQlnpXnR3XYLyjionWu6DwR/9tpO4yaigdZkuMTZ6CcDztnwdQhLM2i621Cv91iDdRMqlxRuPIEe4gIjftikakAqtHcfwx28FMfPYCKALY40AWt8hlcm56lFx/xrmIJRXtCsQgbZrsNfNijB7EtjWHP338l4uP7wVzmKrYBlZU3LVDYK0qmaM0S5ekED+O5sKB+QYvk5LanQsFjRDBKf/tVsVUi+pPRU1/bBSkfr9B1Ss2QZgq9hOdBxUc6hUJA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(39860400002)(376002)(1800799006)(186006)(451199021)(82310400008)(36840700001)(40470700004)(46966006)(2616005)(478600001)(16526019)(426003)(86362001)(31696002)(83380400001)(40480700001)(336012)(36756003)(2906002)(26005)(7416002)(40460700003)(53546011)(41300700001)(4326008)(7636003)(356005)(16576012)(316002)(82740400003)(31686004)(70586007)(70206006)(47076005)(36860700001)(5660300002)(8936002)(54906003)(8676002)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 18:21:06.8904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1870338-a6de-48f1-f2ba-08db9a97bafc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF000015C6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6934
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/11/23 10:25, David Hildenbrand wrote:
...
> One issue is that folio_maybe_pinned...() ... is unreliable as soon as your page is mapped more than 1024 times.
> 
> One might argue that we also want to exclude pages that are mapped that often. That might possibly work.

Yes.
  
>>
>>> Staring at page #2, are we still missing something similar for THPs?
>> Yes.
>>
>>> Why is that MMU notifier thingy and touching KVM code required?
>> Because NUMA balancing code will firstly send .invalidate_range_start() with
>> event type MMU_NOTIFY_PROTECTION_VMA to KVM in change_pmd_range()
>> unconditionally, before it goes down into change_pte_range() and
>> change_huge_pmd() to check each page count and apply PROT_NONE.
> 
> Ah, okay I see, thanks. That's indeed unfortunate.

Sigh. All this difficulty reminds me that this mechanism was created in
the early days of NUMA. I wonder sometimes lately whether the cost, in
complexity and CPU time, is still worth it on today's hardware.

But of course I am deeply biased, so don't take that too seriously.
See below. :)

> 
>>
>> Then current KVM will unmap all notified pages from secondary MMU
>> in .invalidate_range_start(), which could include pages that finally not
>> set to PROT_NONE in primary MMU.
>>
>> For VMs with pass-through devices, though all guest pages are pinned,
>> KVM still periodically unmap pages in response to the
>> .invalidate_range_start() notification from auto NUMA balancing, which
>> is a waste.
> 
> Should we want to disable NUMA hinting for such VMAs instead (for example, by QEMU/hypervisor) that knows that any NUMA hinting activity on these ranges would be a complete waste of time? I recall that John H. once mentioned that there are 
similar issues with GPU memory:  NUMA hinting is actually counter-productive and they end up disabling it.
> 

Yes, NUMA balancing is incredibly harmful to performance, for GPU and
accelerators that map memory...and VMs as well, it seems. Basically,
anything that has its own processors and page tables needs to be left
strictly alone by NUMA balancing. Because the kernel is (still, even
today) unaware of what those processors are doing, and so it has no way
to do productive NUMA balancing.


thanks,
-- 
John Hubbard
NVIDIA

