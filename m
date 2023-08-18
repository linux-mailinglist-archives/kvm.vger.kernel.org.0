Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6227803CD
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 04:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357241AbjHRC3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 22:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357240AbjHRC31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 22:29:27 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2056.outbound.protection.outlook.com [40.107.95.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327E43A8B;
        Thu, 17 Aug 2023 19:29:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFaleqMee5RWpuHOyOA28g77dZztQmCK4J0uNuDymESnR6yRu6qDeSc8oXXwq9uQaAhZVvsZSo1pYgyoGXpjE2bfpBtZQXUoQ9spbQHa6ZVt09EfR5BUkTL6n/4lZo7hOl+RLmUy7FRXI0+yy7hoJJt0IaD/sCw5tDG1j5uJx264xG+gkNbwjoWX7Ba0kmmNWfJSqFfSqTmjMERkS7PANCoZT2ZsCEVf6OS7SwVokIHjfzVIxCV6kmoOb53zFqy4964j3UPu0HrXUPJbSAXcSS+wJJV6YFNLQYNUCRXYyVQ3KT25DB5uEiORL05aeVUPDJgBQiEKFINsyYfn8i6fig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/BMvWwHFo52FTv/uJJvXh7Eh1swdBtPYZHlmZnOuM4=;
 b=coOsfM2+bimn/ILnJVE6qnVS8pE2ENvqH4tEwqmxGdOIX1ZQ9ZIhiTRsh/rz62HC6zuMIVpHT/4N/GWjgB6DO1XBF7m2gu9mVrMKmlYg8bKgXh3ono5orCAoTWl3RpSM7wPUHAIHwHWidfIsnPjgzBp3sWIULKKi17IOCDEcpxyXlnS36oOVzxo7AeW1AvJcyED6XBrK7e6XD2B45zESscrNw+Io/7i8TE9+rRZKVgv59ronw818yjWUGGSiJe+feXSGCj/gbCsGEuhfHCokdqtZFg9qN1TFbolGjgJpxRDD+xd6Lw9sBBIyCOwjDwcQ05c+gvFkkKLNgw8bleZlcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/BMvWwHFo52FTv/uJJvXh7Eh1swdBtPYZHlmZnOuM4=;
 b=AikiJu7/RCu1b9cBhbo+szUrQnGQg/WlCCmMVeZpYkLEiqqU8i5Ocupftloej09CQAfejHa3xbt/o1gwb6S/fC0sEryh/SwbmtqltLj3JSW6scVn2pg2p5Qc/DSoM48oAFPJ18qM+rU5l5QqxxpcSK0J0eI5CdpI9bVVgksw8uiq1/j1Ev+vh4d0Ge8YG8bwC/7MrB0cpf4F/wrVvFFSFSMjBJN0724EKEFYZYuzuawJ5laBqmWgNeUEwr8DZ4po1T9l8huBI8MkDtbvTt3qK22GMV2DYCifzoCFZZvBGIEXKUIkwj/y57GWYRLEFAdk8Swqh5QqifRK5ifRYspcTA==
Received: from SN4PR0501CA0072.namprd05.prod.outlook.com
 (2603:10b6:803:41::49) by DS7PR12MB6168.namprd12.prod.outlook.com
 (2603:10b6:8:97::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Fri, 18 Aug
 2023 02:29:24 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:803:41:cafe::ba) by SN4PR0501CA0072.outlook.office365.com
 (2603:10b6:803:41::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.15 via Frontend
 Transport; Fri, 18 Aug 2023 02:29:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.14 via Frontend Transport; Fri, 18 Aug 2023 02:29:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 17 Aug 2023
 19:29:13 -0700
Received: from [10.110.48.28] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 17 Aug
 2023 19:29:13 -0700
Message-ID: <4cb536f6-2609-4e3e-b996-4a613c9844ad@nvidia.com>
Date:   Thu, 17 Aug 2023 19:29:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in a
 VM
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>,
        David Hildenbrand <david@redhat.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, "Mel Gorman" <mgorman@techsingularity.net>,
        <alex.williamson@redhat.com>
References: <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
 <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
 <f523af84-59de-5b57-a3f3-f181107de197@redhat.com>
 <ZNyRnU+KynjCzwRm@yzhao56-desk.sh.intel.com>
 <ded3c4dc-2df9-2ef2-add0-c17f0cdfaf32@redhat.com>
 <37325c27-223d-400d-bd86-34bdbfb92a5f@nvidia.com>
 <ZN2qg4cPC2hEgtmY@yzhao56-desk.sh.intel.com>
 <5c9e52ab-d46a-c939-b48f-744b9875ce95@redhat.com>
 <ZN63m5Dej5MBLTqr@yzhao56-desk.sh.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <ZN63m5Dej5MBLTqr@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|DS7PR12MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d4058d0-11c6-4020-408c-08db9f92efcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K7dff5zU5xFUZl79D4iUyi7kJh840sBtEJBG1BI2Tamfl+tY+zB6QOANR/O9BKS+HoVf4HqiYtXgj04+SSNc5JhAeyyDOg4fdvRUl2VxTj07rDxGZSR2nywjZAZ0MfYcPdUzBKN8Y8U8G32s4weJvFG/elV/IAN2fX86HAvc3dsuzgenKSmr7QSBNrWsJYYxDF85vX+C75NUTTLcnj8DdjEDVcPtlNVTtvTCNwR7kiexjNKI3BofxOuTQpWgxci2DeDUnLrqbFnFXV/GoD6yNRgNBD6uZvX3ZLGN0buIFiJ15BnnrCUIQvZxw2z5vj0swPaR1h/VMVL8o/lvRNOz07TDufWiGl+XDChuo6c3NZYQ1XoG8YIC5riU1GLrBnUSF3pH/oKHhjWzp/mhz2jHCaDQVz1AeCa7q8oR76eMFwlcM93v3+618+BekJA38mrrKMtZabeBrcq5qoyiGy0T3d98yM449/Qr2vZDihW/EkPevbFMJfmDst8HJV0KY0jMJ2zKHr9+2t7Vxb7B3N8x39aW0pbKCr3AzfDgoo9mhF/JXrwkaX+E8Nzkb7ihO5h4ISnxR/vcbl1FsDWWPrX/F4JSbsyWPV0ar6Am/tgvoYdp+/9HJM0OIjrdVrXfiSCp15qgaitAy8B1Rrl1PyObF6UbDQu1Nw3mSlP0+k3TKgtWak+EXigpi/hmFx+ZI2+wUxueqWVA9G5XLWAcFemtFy0WrxbnFciDqer5Zkf7vz4v5ZVdD6Pa1Y8VtyzE/mlLeBtIz8ywFmYsmwYC4Jf8TQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199024)(82310400011)(186009)(1800799009)(46966006)(40470700004)(36840700001)(356005)(40460700003)(2616005)(426003)(336012)(26005)(16526019)(53546011)(47076005)(36860700001)(83380400001)(5660300002)(8936002)(4326008)(8676002)(2906002)(7416002)(4744005)(478600001)(41300700001)(70586007)(110136005)(16576012)(54906003)(316002)(70206006)(82740400003)(36756003)(40480700001)(31696002)(86362001)(7636003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2023 02:29:23.8898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d4058d0-11c6-4020-408c-08db9f92efcd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6168
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/17/23 17:13, Yan Zhao wrote:
...
> But consider for GPUs case as what John mentioned, since the memory is
> not even pinned, maybe they still need flag VM_NO_NUMA_BALANCING ?
> For VMs, we hint VM_NO_NUMA_BALANCING for passthrough devices supporting
> IO page fault (so no need to pin), and VM_MAYLONGTERMDMA to avoid misplace
> and migration.
> 
> Is that good?
> Or do you think just a per-mm flag like MMF_NO_NUMA is good enough for
> now?
> 

So far, a per-mm setting seems like it would suffice. However, it is
also true that new hardware is getting really creative and large, to
the point that it's not inconceivable that a process might actually
want to let NUMA balancing run in part of its mm, but turn it off
to allow fault-able device access to another part of the mm.

We aren't seeing that yet, but on the other hand, that may be
simply because there is no practical way to set that up and see
how well it works.


thanks,
-- 
John Hubbard
NVIDIA

