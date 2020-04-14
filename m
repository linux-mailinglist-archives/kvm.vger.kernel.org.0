Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F6A1A8C10
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 22:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632838AbgDNUO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 16:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2632824AbgDNUOq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 16:14:46 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20608.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6F5C061A10;
        Tue, 14 Apr 2020 13:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EW7co+8Nu+u5BlrEXXfwjpa5SDHB2uDCvDZoJbOSouePuVkl0TrPTYw1kU9mvvC1fre1vIYwUmo8U+GgkqH0aluUtiDSLFuU2PIkzYELg8uP+NTAPeTjadHItf3tBUojW7yBAbOlY52V70sVbwFTIeAvglwuNhwXZboJim+DIrQTnOfbSVi2RS/4fu3T5OBSW7vjGNxaXqd5mlASwpfwOyb08hFOq7YJ2n3n56kGtGfUX6V5z+Kgp4KS0kn3KjgtkahUkqiympnXV5yYeQXwCnhDwOe6+cmrADsnKtdbgA9kO5WLjKYBsGyv2Uj7bqxxFO/hENKalGlkhgUVvbEpvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2csmqSF8Oe5PBqXsxosUGpKAOc+oXHtZhuIHh6sR6i4=;
 b=DUdGywhwVII5gGFJnhMtHMKKPvE5+4OvEP0/OdEKljOpZB9NzJuZHRUAD0LfpHe+hzhtXTP/gsVjUb8wUTItFxS3wOzOP8AbkeDWVedspGZejx75kr7c7f0y9pR6A/JXbFjRqd7RTM3UjZnWVpURbSO6X0gnAgO3eUFzLkplCET4iWdRp5xstoBcY0BPzYYsXHFQfnjlo1DpQ62aA8lW4aHxbYFNfGD1uOG6pGWt99vfFMJ8fV6XOcyCu4lSQ7DbPAQD9Vz3Hg/kHKVxE2s7Ke6J49o8GToblATtPD1E9dt6AOippRJb6NKaTVNfaeKNWWwTK9Jymw9/LvV1KgQm1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2csmqSF8Oe5PBqXsxosUGpKAOc+oXHtZhuIHh6sR6i4=;
 b=lgD/KdHWeEm5tBEgvOVxjnvaPIUFS7X8FqiU+3UyoSbC1iH1mbijDStikSnPUIMlbFBbxrDLui3DGxb0XdAjO/38fpkDSgVH1w37PinlgE4m6IDQ6V+7Z+HnUt30oVpI0WlXgBXl1gcq0rXbUn1bF+/Ge0rKOiw2+JAnxFCOnc8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB2730.namprd12.prod.outlook.com (2603:10b6:5:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Tue, 14 Apr
 2020 20:04:46 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 20:04:46 +0000
Subject: Re: [PATCH 40/70] x86/sev-es: Setup per-cpu GHCBs for the runtime
 handler
To:     Mike Stunes <mstunes@vmware.com>, Joerg Roedel <joro@8bytes.org>
Cc:     "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-41-joro@8bytes.org>
 <A7DF63B4-6589-4386-9302-6B7F8BE0D9BA@vmware.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <09757a84-1d81-74d5-c425-cff241f02ab9@amd.com>
Date:   Tue, 14 Apr 2020 15:04:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <A7DF63B4-6589-4386-9302-6B7F8BE0D9BA@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:805:ca::35) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR16CA0058.namprd16.prod.outlook.com (2603:10b6:805:ca::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17 via Frontend Transport; Tue, 14 Apr 2020 20:04:44 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2d88baec-7789-4b0f-0589-08d7e0af1408
X-MS-TrafficTypeDiagnostic: DM6PR12MB2730:
X-Microsoft-Antispam-PRVS: <DM6PR12MB27301705DD1835E5EE57C9A5ECDA0@DM6PR12MB2730.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39850400004)(396003)(366004)(346002)(376002)(136003)(110136005)(54906003)(31686004)(5660300002)(8936002)(6486002)(316002)(7416002)(8676002)(66556008)(66946007)(66476007)(81156014)(4326008)(26005)(956004)(186003)(16526019)(86362001)(478600001)(31696002)(2616005)(6512007)(36756003)(52116002)(6506007)(53546011)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P+9+lJO65BqVwKwfMoujGV3sf4YpG2eCuzAHByLpzOzbJtukbcWfkJDvONCIchkzwEMjdD936ZscwSVXDuTLpa3Bi1qXPDvANy03Ynd4la/aPgvYyik1B2Q7Ssj1zZaJCE52FkhcuuGNviGLYuXYuEROuiAobs9m7MIljv7J1TvZRK5DqgZEGTgBgu1wVFCVwPMAEo9edPaWukMky3agvbSxdFbxmK7sCYfCS1GCiFxO7YS8Grx6MnFRq7G2g1oUzbm11jPrHuQ1tVj4OdSQjH0Db3GkU9d75y92Dhk+ciaTQIXMCbZ4+yVZz1ooEarF3H+No5HusHfdMgy9WkicfA4lkbe30bUy6GKX3ItjMyAwNi08of4uYtdjjzSnLCACghyJ1Jgaig9e8hKvpyx1NSmGDOfwXIG9NsKKVU7NaBzYTK4h2Tg6mRGeubEHO4Xx
X-MS-Exchange-AntiSpam-MessageData: jVKhd/ZTgd45QYJsJoPVhQy8kFS6DAAMbxql5MDnd7gHDEMf6uQkGo/Jwx3mFmsmfSW7O2wkQBMI0m82DnKypFqriiT3kTMvAySJIxYXEhOvl5yIC9fOve4E9NnGLNXPj7IoN0Plya5sWVqrWuIi1g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d88baec-7789-4b0f-0589-08d7e0af1408
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 20:04:45.9121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fR+sn7Xb32FPeaon4HUWoZpK+isbhOd0bidW5D6YKoXedmbVCT5CRz0gcSeQSSIXC/SPyY2VuKFVm5agHiI6eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2730
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/20 2:03 PM, Mike Stunes wrote:
> On Mar 19, 2020, at 2:13 AM, Joerg Roedel <joro@8bytes.org> wrote:
>>
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> The runtime handler needs a GHCB per CPU. Set them up and map them
>> unencrypted.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>> ---
>> arch/x86/include/asm/mem_encrypt.h |  2 ++
>> arch/x86/kernel/sev-es.c           | 28 +++++++++++++++++++++++++++-
>> arch/x86/kernel/traps.c            |  3 +++
>> 3 files changed, 32 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
>> index c17980e8db78..4bf5286310a0 100644
>> --- a/arch/x86/kernel/sev-es.c
>> +++ b/arch/x86/kernel/sev-es.c
>> @@ -197,6 +203,26 @@ static bool __init sev_es_setup_ghcb(void)
>> 	return true;
>> }
>>
>> +void sev_es_init_ghcbs(void)
>> +{
>> +	int cpu;
>> +
>> +	if (!sev_es_active())
>> +		return;
>> +
>> +	/* Allocate GHCB pages */
>> +	ghcb_page = __alloc_percpu(sizeof(struct ghcb), PAGE_SIZE);
>> +
>> +	/* Initialize per-cpu GHCB pages */
>> +	for_each_possible_cpu(cpu) {
>> +		struct ghcb *ghcb = (struct ghcb *)per_cpu_ptr(ghcb_page, cpu);
>> +
>> +		set_memory_decrypted((unsigned long)ghcb,
>> +				     sizeof(*ghcb) >> PAGE_SHIFT);
>> +		memset(ghcb, 0, sizeof(*ghcb));
>> +	}
>> +}
>> +
> 
> set_memory_decrypted needs to check the return value. I see it
> consistently return ENOMEM. I've traced that back to split_large_page
> in arch/x86/mm/pat/set_memory.c.

At that point the guest won't be able to communicate with the hypervisor, 
too. Maybe we should BUG() here to terminate further processing?

Thanks,
Tom

> 
