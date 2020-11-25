Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9812C42D4
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 16:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbgKYPZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 10:25:13 -0500
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:1665
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730192AbgKYPZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 10:25:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhGUqgVa3IHgDNBgiouvoOPyni5yoVc6reL+RZxMMXDGQxj9IVlIGe0zOrztPlq1q9oYdxoapg9XmoRiH8PZMUSyGOp6MMrb9yJcc3E9pE5Y31+t4qJAU69gpNRBadhxOKX2eOH8cck8g4VIlQ1jal4RyxPKC76iJq8xeQGhZ53gduUmai/rTvYLYndwjW5OFELwQj5rQpoME4YqqvP2Ped5rPbu+if4hAMCQ98wyALaizt+iq9INKjYhBc/wf9qWm7ST/g2f3MydVH9krQir8yK02W46h9gZ+4YWq1Kjxj8J0okttNlLxCn1N/ZwPbsNt+X9lsPOc0fa1cEfnWJbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8gKGoWngIpQuh4YjNBrCeGymXoL3Seo8lOACWInA+ao=;
 b=ZyCaHITeUaaHIrDssL2X5MY3Ra8DZp9c7iiKOltRexK+AH/JC6ZxnWFw1NOsLoSkB18kTtsifm2oKHQHodyQHiSX0RHg/tEqvXqsvzHwn70T/iB5OilIi7V2AFFIi1zc6OpJY5V09/AzNp5QtmV2vBER2tWGibSMr+cIFAkPR5/ajoYFZQRrePa9BC6FC/8fZ5XjaScH2/MZVCSYsRiZuH8u92YtWXVfDCDCRqllO+qb9edNNp+NSNMLEy/zgcEJ7XjvPf+IgoEuwd4huYbMszIaep+PZRzuXE0BZHELsE65KM8T6dkdmj0SYy0ybdAjaYH6Pwf6jhTeT6Rj6N/wzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8gKGoWngIpQuh4YjNBrCeGymXoL3Seo8lOACWInA+ao=;
 b=HG0E5Z2lXlYWmvgQ+C3+wjAWV81jyj7+H/yc1wYiDZtq2voxyxDh9AnR0WObRBYl8DVWEdit19wjdkV0cAzztmM0eg1ySz9oqk3dxC0bVRKGZWP62W6Vf67MC9gucIjgEj487DbQ4X7YfW+q64hX1NPrSDPFqNo3Te6G2Qj8qns=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4092.namprd12.prod.outlook.com (2603:10b6:5:214::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.20; Wed, 25 Nov 2020 15:25:07 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3589.030; Wed, 25 Nov 2020
 15:25:07 +0000
Subject: Re: [PATCH v4 00/34] SEV-ES hypervisor support
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
 <347c5571-2141-44e5-4650-f63d93fd394f@amd.com>
 <20201124185216.GA235281@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3c59e558-98ed-f3ce-bddf-929149796708@amd.com>
Date:   Wed, 25 Nov 2020 09:25:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201124185216.GA235281@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:806:d3::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0025.namprd11.prod.outlook.com (2603:10b6:806:d3::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Wed, 25 Nov 2020 15:25:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5ce07a60-5824-4b8b-fe4f-08d891564a4a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4092E78BCE8D863763E2D374ECFA0@DM6PR12MB4092.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gp0PIam6ZR0hioYf8JUF1FLqaRITrS9uwqwIAw5/U61M/c+1QdLASU40XII1T/I6q7reCyUMqkVted15dGZM/2ChTP4k9r7dGlvTabb2W1Oe23OM6g67lZ/VwQRFlqNzyaejMzGSUHpLti8TkTnrPPjpXInHaXelyUVjJr3ZgHYO/k7hJhFDjjXcUJkusqfX0JM9DTMwMwpIh/+zX7ksyNNVxFoyELHp0Fz8eGbCWQ1fuINNxTikw2QwcWdcxdohgvh9sS8TQzexlMb2sCtSh2zlyEvskY7SXViZDXelkMHi9uRywZQOMPiERwKWJloxGOcnI6KqWHlt7IWysXeoY8FO0GqSSLtDrqa6kRKMSusqzBAuiFWCWGIR1b/neiIY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(66476007)(5660300002)(4326008)(4744005)(2616005)(6486002)(66556008)(6916009)(956004)(478600001)(36756003)(7416002)(66946007)(8676002)(52116002)(2906002)(6512007)(316002)(54906003)(8936002)(86362001)(6506007)(186003)(16526019)(31686004)(31696002)(26005)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nZAC8dcxCBEC0rsnMr9U2ZoFzouFQapTLQfZv1WyYyV+kzp2wWQxw7Dh5KS0lKfcs1iKDlhqitAQmkufdZ0P+OlOI4csSFgxWKbdbm8Y0u2TofDmYloze7kPY4XYShfv9z+53dAOESgj/35HLHN2UyuQDso0AijJM9Mf5QItiOW2Cc2mm1p29/G5YezezX4R3JmdsZkrdu6p2jDNyvWGYaRZW/dQk5s+a+K3NPpqLTR6krbDNPerEB1dzqfvChHSKKiXfldm/yh94mHTePjuYmPOZXk6GiIG9d++W/7IgB00bsFrV5w/yA8RCOMdbpQMQLnahuf21JuC8Ncu7KYIMHl1waQF1XhlaST1CEuu7qacktgJgqFWiK9FxvAtGMBiU/IxGpvc9G9QEUo95G/LDImJP5OJN6FTOqo6e5fkb9AQ1NsnzSe0O2P9F7PynUxv8eN0Z1Ng+zc4RCjHt6AlmRC2VePHm9YhZuEDSwWOfQAqMFsHLQYo6yXmyS2J4Ntxw2GAmOlW1BGAbP92xSasRP5lFOkoCvBBEmZdvRUzXC4WupPXyOcFCJUsM5vxGl7aUBW9rPH6q5KANgs3n4lZQnz0NvairyCnZH4JAsk7HeH+N1KbXoku0FyFQHuXvzBKLGMmiG8gXE3SKc/OrK710UGDaX6SDkCneXa9Jk/rwvLSdjUCbGKafzgv7kpwAzgFY3Cq5j7srF1OSvwBTUWXAMIB87jjPMkoZ4EEweyf00IGSaYIIwBvYq1RjoQSOx6dR1t6ZD7X7aEO/ta/t8CCQuc4hvU/YVO2TC4keKOQUIOsQKLphS6yzjVETwTU4zprs+yBLx5/QG4nBscFz5ZVJa4A3C9jhk9WoT1tYCyY/GxJ7knDPWZyGRXUR89a78rZgLJxtY49cIBgkx6BLN0Q5w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce07a60-5824-4b8b-fe4f-08d891564a4a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2020 15:25:07.6127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRaZGLtUCJvFSyQJAAI0NI0WR4TvdGB8E96XYkXoL3Ql9nY9UONOoXxcGZF23K9C2XcF7pkFH0A4VsoOn5f4Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/20 12:52 PM, Sean Christopherson wrote:
> On Mon, Nov 23, 2020, Tom Lendacky wrote:
>> On 11/17/20 11:07 AM, Tom Lendacky wrote:
>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> This patch series provides support for running SEV-ES guests under KVM.
>>
>> Any comments on this series?
> 
> I'm planning on doing a thorough review, but it'll probably take me a few more
> weeks to get to it.

Thanks, Sean.

I was hoping to have the hypervisor support one kernel version after the 
guest support and make it into 5.11. It's a tough time of the year for 
that, though. If anyone else has comments, I would appreciate it so they 
can be investigated quickly and resolved in time for targeting 5.12 if 
5.11 won't happen.

Thanks,
Tom

> 
