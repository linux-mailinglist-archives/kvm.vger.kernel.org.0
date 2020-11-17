Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4EF2B6B45
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgKQRKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:10:22 -0500
Received: from mail-dm6nam11on2062.outbound.protection.outlook.com ([40.107.223.62]:45280
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729163AbgKQRKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:10:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWz19W6+mIJJ1S9pgGlqfiTzjcnHrjitvYodwu9gBBPjC8HXmHAzDeFlfRoSQOd4DfEqZHNy2LzHDEvEvCHLCqJa/+BpAjDSWzSxPm8KjBIl06Cx9H+PHe5jT//YIwBRCEcXCjH9/GtPAMTyjfaYxksUfOl/SInzNlX+Udg4ZOY9groPinUKnscabe1h+eVF/XjUJI5+JjQJ4bS7Fkc8U3l8fPB+gb5iH284IGYFiR7CtIeEjWO2e6/cnEYuIpkHUnJKnkm7ka/cStB8Imw3VteQplpzWYbzkboP7GYQuLUgpneYGLC3AVCFwnNdNodyADlWuk5Z6EXEpWBcuoQIPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdWuBzL53Hglqtsx7B762tWfdj2SyfamwHMgvNKpSKo=;
 b=MBp+NxZDqIcv/PhDgF93b7eR9ic3EoQ3dRVo9/ESTVVwrOgeQTmryDNhO1679ypRyAr7wnL3dERrbxLu2Lh83kODN7RMlnU7qY8x9l6OICMhp13hFR4KGbG/ELmFQE08Czou+O9CrlAzjHJyRR8wABSPe25n1xwITo0FZMOyzuDAxhV/FXWnBT+LTyJ8VNA4bmWlRTz8mJ6UslKD+GbGWoECjsCXdNttupW+l6/Mkdo0U0pUUnpD/0IkozqGA5yai9e5GeGa5TYi64colxHCm0LzvzFJPYbcaBLEKtWtryxSJ4O50jdXxEYiP9rCTXGM3eN3H0QZX3BHf1xDmITsnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdWuBzL53Hglqtsx7B762tWfdj2SyfamwHMgvNKpSKo=;
 b=THQbVb8NrM4JqzYAXaGuSMvScIYceaGS/bDDGkyrieQelPxW0KqXUWnYAGcwvVytw0ZUbK8mpsgLeQwtJRax4a632jMH0GmDP1NyGfhfxBFAQMjYRb8F1G9fqZM0odVXQ1+sNjfqRMzw9kV2zLZ2chbCyjSmMRbprYBp5Bm0UiY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:10:19 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:10:19 +0000
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1> <20201116155341.GL917484@nvidia.com>
 <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
 <20201116232033.GR917484@nvidia.com>
 <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com>
 <20201117085443.2c183078@w520.home>
 <b6bd90c5-69e0-4e73-4f1a-8bc000aab941@amd.com>
 <20201117170741.GU917484@nvidia.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b6a7ce40-e509-6219-d5b2-e0c6e453dfcc@amd.com>
Date:   Tue, 17 Nov 2020 11:10:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201117170741.GU917484@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR2101CA0018.namprd21.prod.outlook.com
 (2603:10b6:805:106::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN6PR2101CA0018.namprd21.prod.outlook.com (2603:10b6:805:106::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4 via Frontend Transport; Tue, 17 Nov 2020 17:10:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2dffd3c6-3ac8-4158-f271-08d88b1ba96b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-Microsoft-Antispam-PRVS: <DM5PR12MB17724DBD87D7E72C6F8929CFECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EP85rqxkbkjaORFKNIt8FZ4XbHZugM5pB18AAk/w7n7kQ+7Z6f/K6pt7EUZ7baFtGh2u4ER3gdzBz0u0ojylCZs2GNELXHKSNPzNs26tuTi1sU0Cw1+bz1L2/NHwHjXJH3qkEKeQnZorHh9EaQeU5UbNy7rp9NAeMXCmDTIT1xwEEwCXOSPgMLEzoOBo6nokZJ+nugfTmKxj3D5vItGpzKeuuBHSgGRczRqWdoMxnmAps2E0oG3I0zMx3r1iqQIFYPcKqpAQvy2IxBQ5BlVUWZ7W8ehA715y2IP9Z08/i22hh2kuwZOJGK0h8Bk/1cY/6cM1TRTrrkq1ORF30NSrs0FgNpnOak3l8edCxwaCkOtlPKsm7L6Jtq0fIlBnC7Ao
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(31686004)(53546011)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(186003)(36756003)(86362001)(8676002)(16576012)(316002)(6916009)(956004)(52116002)(4326008)(54906003)(31696002)(2616005)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1GgnPPgkFgl6F24028gzWm/Wd2NwVHpUEwnFcHiG/Pgvo7QeJr/3JNha00vFaRoTVGddRuH06nJbHG4TnWZ2A/7oLf+jwnL3W1mN9FHxmbTikfuGfpGL7CHnxjmMvy6BHj5k2FJ+2gFUlufUDkew00Qi+Bqf3rZ3E5xu2d58R5ysY8peD3hK192C7vXDaQLzEeSU8RjyDdPj1M1QJ/q3KKKADq7OunuaapN00JwZ17zf/HMhWuy572ip6H081KEoqRC54d6JVuYQITrqUBJcQy/MouNUQz+L+EKxHDgWR6KdvfDa7FKEmF45tutdYIoo38hlqD2jjIIGknHqd/YWf5IEUz/0K2VZtLR9oZSO3957b9ZPLJnjD0LDoyTtEcOHkKPD3mBQYv1TbqkNVb/6UHBconi4w9fUI5X5HihQ+F66jZkHMCkHWyUsRLzm+YebsbtnDqd3Dnd4/KOA12QaajJuwKfBB7TWifuN7wZrE7casYov1V3wX/W8z6DZ9PbXweHEM/wKdcJNQMB8jFAVO45b8c4yHaMrHHfEdbYPmiSCFYbnSxvARHFZJmeEJHkZU3/tUKa4iD/nBsM08MpgTdIrlsHb+HUwfEunutyQWjXdiHvE08F2ETSTswWmtVNmpQVW+7Igr0mgKqGZAvh0vA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dffd3c6-3ac8-4158-f271-08d88b1ba96b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:10:19.7895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oslNV1AZ/WphLnwHTP/q1LQnnANxHyqEOQTaIF1LtHNuUYevqCiMS+hUDKwJsBDTPzqUa4X+MC2krYxUtoslIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/20 11:07 AM, Jason Gunthorpe wrote:
> On Tue, Nov 17, 2020 at 10:37:18AM -0600, Tom Lendacky wrote:
> 
>>> Ideally it won't, but trapping through QEMU is a common debugging
>>> technique and required if we implement virtualization quirks for a
>>> device in QEMU.  So I believe what you're saying is that device
>>> assignment on SEV probably works only when we're using direct mapping
>>> of the mmap into the VM and tracing or quirks would currently see
>>> encrypted data.  Has anyone had the opportunity to check that we don't
>>> break device assignment to VMs with this patch?  Thanks,
>>
>> I have not been able to test device assignment with this patch, yet. Jason?
> 
> I don't have SME systems, we have a customer that reported RDMA didn't
> work and confirmed the similar RDMA patch worked.

Right, I think Alex was asking about device assignment to a guest in
general, regardless of SME.

Thanks,
Tom

> 
> I know VFIO is basically identical, so it should be applicable here
> too.
> 
> Jasnon
> 
