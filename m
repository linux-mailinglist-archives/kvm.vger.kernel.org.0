Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D7377C5E9
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 04:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbjHOCeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 22:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbjHOCe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 22:34:26 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27771705;
        Mon, 14 Aug 2023 19:34:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1D0bv55kgkw9cFJ/PdoAPvNsx44xK4GOmmQoJq/C/Igr8cIbpQt7j0jKDO72kMAM1VWouMLiEryh2HRQO27lCQW+bs3NqvrEYJWaomQMj7jutfjVTTZIpnWGhZDFShll/QSNvpjrAQKJgEsgC9JrHFGTvLsifvh0onLMD1Vor2WmWyZtO5/sGnsEpLKCAZ9IKzx+YeRo3VkA3jLKHiyLYLuzplD19Se/3o9n8vQxMRbDc4F6i5unbgg+8cWPeHVROKm4NZsZKmc3vO+1eBnNNV3qd3qggB/Jq+x2l6/9v+XsdrZcLjJtt9IEHsoH6VqSaDHyMdg0UQvkiGH4rXb4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNE9cOXeO1+RiH5+zFqxl+QYOhO06CjbqB3aqJiEdew=;
 b=UrAjZQVWly2l+eK2GWk8zRfudzVrAb8Y0d4Bc/TlH5TwD6+0JEL9xE47XHf/aq7T5pc40JXeULiKbqSRNYquQnDWILqe1Kd8YYokq+X0lwI+SaAT5Yjw2MxSZZnop40VSUP8XjlNaw1CIXZvOvAbpN5Pbz7thqHsQVGpjDF81K9YmK+L/8YZqDoNIuTPvWHZUXULSQO98BMvuiQIHW3hHu7bTcNCnlyBfQZIvHQnwAfJX10x2+Bkbnwoba49NRFW7M9Gr1Wm683rd1sDfa7TSb59gR7GPoVtr+97D0rdTYzf2NpEbGFgInQvGV6dgoE3rIywgUTw/9g2ZtT/XYCl5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNE9cOXeO1+RiH5+zFqxl+QYOhO06CjbqB3aqJiEdew=;
 b=fBkBmkmVgk6lmrKk7//rEI7KglallZZ4H33DdYGw9ICNYYmNAbhU39AllFtALOy2XQ0RwkTV5/4n5tLSr/HzRIFlmFk7lPvjyYHpERbeagxSDm/v4QM7iefTjjAX2987yBUV7Z47DWxBG3nX+Yp2JCouFVtq4SMdllNA9sqKon7rbATVWj+ijTLSbq8hJFmLzpXS6d5i7c3QchOhOhjVDuJuFC1HDFOWEIu+2APk+Lujz2Yj4e8ZPFTxAERKD5E6TleyIk2y//VRB4ZSBG+5vOz7UFr2AGvE/0+BxXL2Z/aDjqq3u0p9IiBQVecvSJA0EtjLyhMf0GebFaFUCfso/g==
Received: from PH8PR07CA0022.namprd07.prod.outlook.com (2603:10b6:510:2cd::21)
 by IA1PR12MB8287.namprd12.prod.outlook.com (2603:10b6:208:3f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Tue, 15 Aug
 2023 02:34:23 +0000
Received: from SA2PEPF000015C6.namprd03.prod.outlook.com
 (2603:10b6:510:2cd:cafe::e8) by PH8PR07CA0022.outlook.office365.com
 (2603:10b6:510:2cd::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.33 via Frontend
 Transport; Tue, 15 Aug 2023 02:34:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.12 via Frontend Transport; Tue, 15 Aug 2023 02:34:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 14 Aug 2023
 19:34:11 -0700
Received: from [10.110.48.28] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 14 Aug
 2023 19:34:10 -0700
Message-ID: <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
Date:   Mon, 14 Aug 2023 19:34:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in a
 VM
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     David Hildenbrand <david@redhat.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, Mel Gorman <mgorman@techsingularity.net>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
 <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C6:EE_|IA1PR12MB8287:EE_
X-MS-Office365-Filtering-Correlation-Id: b80839a0-0071-4697-f1c0-08db9d382297
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bzj2Oh84xokzCzhKSzxOCh1ftvtFtMDFAb0I8QDftPmz2zntZ9AJoBESwy5O4nuhD4P2y/O6POPkBw6x78U4cV5UZsV3N1b1ocn7QAoEaQJ5K61J/tdrHRQnW7aLrPMOkMEJYRECPsAEAnDCH5pNSRMoD8ONPunPjCJyi1NAN7vwDzxYguqTSERhYX4l6d16/By4fBouopNew9mIzwRlJaHyzuIKn0bFA/CIB69MkMfOJM3PYflhSk49bcmDeqnjPem+fZdNG9Q1VVPSFC9Nb0jQyxDZnYf27VKKkszxBQUGrPmHC3CYruKyrCTXyqE4Gx6ICEf/Bq6vpATmEE++Mx/UqxrDL+AkmA89Wm07aJ9aMnm5Skq5ipUX8MsSyXxCO82NNkFxOLKHZK5GbQwki352dC0fdTH4Nik0J2GBT5MTVRh1uy7JyadQF0LB/DVYZPOLMf2/UhoxHPgKTCjfShOXbdKE0k2f7p2TB1LKxzV+UIEdr5alPkPcrCGB+1854S0xtKJ6imvWgG5l81d7p8Z0AQTbjr4PDJ7sagkwt17Lj2so54Dv/OfV7qJBEWYoCRLLA98Ik44mXNh3Nfj47Mw6vj/32NHggWK7v3etfZeZ93e5AMKd4ESm8GoUoHFGTQMRN3lZ8T4X8zhMrO3VLgflS8+Xsofk6Py9LvNOPrsZ3ohumlOiFK+ocPvst+ipKPOQM5bCj7TfJB51dhX8RUnijcdKrzwSlXoKHUDRrejOsSoyM4cpvrln7FSQZWmYUed4OhGA+gBjVs21FVgI9A==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(136003)(39860400002)(82310400008)(451199021)(186006)(1800799006)(40470700004)(46966006)(36840700001)(36756003)(5660300002)(7416002)(2906002)(31696002)(86362001)(4744005)(31686004)(40460700003)(40480700001)(83380400001)(36860700001)(6916009)(70206006)(4326008)(54906003)(70586007)(41300700001)(16576012)(316002)(426003)(16526019)(26005)(2616005)(336012)(47076005)(53546011)(8936002)(8676002)(478600001)(356005)(82740400003)(7636003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2023 02:34:22.5763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b80839a0-0071-4697-f1c0-08db9d382297
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF000015C6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8287
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/14/23 02:09, Yan Zhao wrote:
...
>> hmm_range_fault()-based memory management in particular might benefit
>> from having NUMA balancing disabled entirely for the memremap_pages()
>> region, come to think of it. That seems relatively easy and clean at
>> first glance anyway.
>>
>> For other regions (allocated by the device driver), a per-VMA flag
>> seems about right: VM_NO_NUMA_BALANCING ?
>>
> Thanks a lot for those good suggestions!
> For VMs, when could a per-VMA flag be set?
> Might be hard in mmap() in QEMU because a VMA may not be used for DMA until
> after it's mapped into VFIO.
> Then, should VFIO set this flag on after it maps a range?
> Could this flag be unset after device hot-unplug?
> 

I'm hoping someone who thinks about VMs and VFIO often can chime in.


thanks,
-- 
John Hubbard
NVIDIA

