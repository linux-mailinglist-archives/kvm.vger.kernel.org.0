Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376FF266A38
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 23:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgIKVoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 17:44:22 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:39009
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725902AbgIKVoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 17:44:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+9HdQt0kQGuSidkM2jpWYKoJf1r4vzME5LEMCNqvs+WOC+EKBjBZX666faxLBChzJscmZCgsqQVx/eSNHjPx3yGJBHJbBW2ztVp534GP1TK+3umzywIg1r89Nlb52A7rvdg1fYBTaI/nXZVx2jVBKNyG3VEtMoCjXKUL7xcnMl5uXIdm40FMSNDOq9YMTV1+N79xAbWz+aPL5n74GNg/GWrMJ8QGaWCx6mtRdeEgcAP1dr5adM3iu0uwYDoaFm0QPYYYNWNhvw5JX8ise5AwoAfUp+L/afZKsxvLbw7n1dstU2Xg18m4u0ZXr/iFNHlyOOO73Mk11YJi89PT26LDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fx1sCKe3QGsnuKHgOxR/DtczxaaUeqmA3aAKFhebhIg=;
 b=bQ/YWho5lyCzIOUM057wPL9r+XKGh18IWOOsisBoOfh/BQXuIkCH4cBzjkK1BMHtJMPVhnl0pZCbpMhJCP2QBtHtWvonCPpwJQTfxIRa0xygH7sImxT37ypkEoL1JVSqJIzRFf4r3+BkKcvmzNl78SEW/xw7VNrdZVJ3YAq5arTTTr76wJwC6efLoO2LJCuQZsQqP775GmhDz2ryDrtO3LztY+J0Fb5CvfYnagHB7YQPpP1Z6x4+WDUbodVuQmKbBx5oCdq54HJ0n6u+6G7gvxJgob8wmRBZhY02VIBJZnUDUZ0BSa/DnJRy0DHhWzF3HCWWUctX/fuUyqc547CCcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fx1sCKe3QGsnuKHgOxR/DtczxaaUeqmA3aAKFhebhIg=;
 b=AKrA6SYayDrPUi+iax5F6XnDmXGbI8RSiXfc9fPtLtmD/CADIh8XeaRjY8+lXkLUmV/m/UDPikifJMSykRi8fhJOgwWXohvXq5kpBnqv/p1SziF7j9eqGJA9RZcISyxz7OHnZvqbCLjEKBCVL53q01YWKSOMYr/2oPD4ZO/KnXE=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1707.namprd12.prod.outlook.com (2603:10b6:3:108::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Fri, 11 Sep 2020 21:44:12 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 21:44:12 +0000
Subject: Re: [PATCH 2/4 v3] x86: AMD: Add hardware-enforced cache coherency as
 a CPUID feature
To:     Borislav Petkov <bp@alien8.de>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
References: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
 <20200911192601.9591-3-krish.sadhukhan@oracle.com>
 <20200911213356.GC4110@zn.tnic>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <86f5e43d-e2fd-6cce-70b8-cdf01b7ebed4@amd.com>
Date:   Fri, 11 Sep 2020 16:44:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200911213356.GC4110@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 21:44:11 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 62ffc48a-26b6-428f-f1d6-08d8569bd23f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1707:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1707D1D902459E24C3D0BBD0EC240@DM5PR12MB1707.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iMQD3HEPevB3mkzipkFtaiWPoc7RUxVd6U1Igjx8Qgxt83jCB96JbXsQyjJgziHaonjyYkqhvBQwo8+kDw4SUG+nqA3JZqI1pd2KvWd3slEyRatpoOlgmhqJ+DSsYZKkbPbxRSgygkLBZreY1UJOKTw5UqsMlxOkxVQBHvQ+gPIHIUVAsaCLplStrTZvGT3ZqCl6Xq1WavINmcXpU14408gwLoaR+LHo97apHRa4CbveLCJBEWP9uiLbixgvbXjinNtRxsLToF28fOukiRmtVU3lA6tCzcS6Q5PhzlSKqA4yNhXFa1/DIszlkZTY7+r/YsUWdodRhoV1e3etQgOGVrOapG3xvf7ZJDcUpCNgVNQzlVgucZGnkpMZckrDNk0k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(7416002)(53546011)(478600001)(316002)(5660300002)(2616005)(6506007)(83380400001)(4326008)(956004)(31686004)(86362001)(31696002)(26005)(66476007)(186003)(16526019)(2906002)(8676002)(110136005)(66556008)(36756003)(66946007)(8936002)(6486002)(6512007)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nC/wm+EMYq8anVFkov5ZJQs2Tv8gLyMmAQscQ1w7vQizSwg9zh3CTZqyP1I5FG9p6VNpl4flcMYKjcuRjb4LtW1BSMSuZbHG/1isuUw4Dl8e1cHReXLShmyxdXHwPwHPpVyn9JHBISWU+Lnjb0nqtSBxhYs4MzWi8k+EJPoxdJz4A5ztCWHwz3hsRX+x/gOJQUBrIsDJjfBP4sLAqRQBwPRLxoqJ7dWLuvIf2Oi1D/26Dh6xFPY9cAj75Gw2uJPArABhPx1HdnnjZsqxmSCxCJldDbs33B1qG4jzUtDGZeF1yvXTRC2zFpmKM1BWw17Vv78FFeNwcKzvE1ceDCsbvEAES6Zp21wjbbfY3F913JH93vxpIheZ0WvdRBdVEUIcwN6Vlyqf55QqzoYeOBrpZbhYOQLSz94CuL36TY+bTshrCcIg+F9/z2GXMTd4neb6EWW4Kupz7ncPLnMQW7J3KUUXqNe3D/Wj0Xfx70sootXzXC+dgBEdZicjtXp+qR1FBgQ9RjTIYeA2NWlv1wtdeTKqEGvU/jCHWYxKW++yceiGKe56O6VExCFbindHzfd1oCoS7Orsbmgn/dZ9D3Klyq5KbTomAteE/MJ+RPVKE0SfpEA/Af1wfyJfPEulIyTOHgLnsiCj5rS2vjWjug3dPA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ffc48a-26b6-428f-f1d6-08d8569bd23f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 21:44:12.3799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUFBqS1mWfciOe+pkdWXCqTI2RYvSlnKRGln38ZLghTvV0zK+vLHB16/W7b/8AqNK7LnirnmxeTUxI6EY71mzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1707
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/20 4:33 PM, Borislav Petkov wrote:
> + Tom.
> 
> On Fri, Sep 11, 2020 at 07:25:59PM +0000, Krish Sadhukhan wrote:
>> +#define X86_FEATURE_HW_CACHE_COHERENCY (11*32+ 7) /* AMD hardware-enforced cache coherency */
> 
> so before you guys paint the bikeshed all kinds of colors :), Tom (CCed)
> is digging out the official name. (If it is even uglier, we might keep
> on bikeshedding...).

I believe the official name is something like CoherencyEnforced. Since 
it's under the 0x8000001f leaf (AMD Secure Encryption), it means that 
coherency is enforced between the same physical address when referenced 
with or without the encryption bit (bare metal or in a guest).

So I kind of like the X86_FEATURE_SME_COHERENT suggestion by Dave, even if 
it also applies to SEV.

Thanks,
Tom

> 
> Once you have that, add the "" after the comment - like
> X86_FEATURE_FENCE_SWAPGS_USER, for example, so that it doesn't show in
> /proc/cpuinfo as luserspace doesn't care about hw coherency between enc
> memory.
> 
> Thx.
> 
