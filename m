Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F951C7DAA
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 01:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgEFXDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 19:03:03 -0400
Received: from mail-dm6nam10on2077.outbound.protection.outlook.com ([40.107.93.77]:6115
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbgEFXDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 19:03:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EUbsl597WivrCTkWD5hyqGS0hmtnKwgiopR7Rpf/3Bbhtx0Dg3bm4SMI4G+GX9jO/zHp1Npyd2K7KpOm7apIVVWHeLkLZaCgYjRfVuarLnilqj+TQZgsDB2ZaPzcL+aecytiDbTjOtQf12u0vhzDHISNAyBKSmdtWgI9BW9FHz24+rcxZIGMv3lJgmVYNmDCFY+LmowKwDjoaRDYeL9HwemwXYC2UxYECXpXC5/3w5pqA8MwWei3UIOCQ2I/qZafxHjwZdGJZgAt+oTVfDtduZfrZJpYqV0BXz6xGBkWjBq2nxF8vY3nlNl6x8/FoqKK7xUJJnImEJagPDxSHGqFrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxfPJLALcywCGY5eQBVLNzKgfI4Um+sZRXZXUK/OeVw=;
 b=JxISCfG84xLvPjfQ/iPcgF0IcdUFQl34mJELHiLMu67eWjLVRUI15WJD0xtu560NTkMPEV3MN/HEOwKoySe4PUVhHEvcVvsFtnRCezzCnImC/X5f38nW3OiH3Q1LDfuiC/F4XE2n8KMaOmJJ5RtRyzzRLcMsLJpvhU4rnIPEAzzaPXCgZ51H+iGmyAOreQveyd4FfldKEKsUishqrYyIqMjHzD0DjFFiV7XxGONgFHgrM3+RJzCnq5PMCeYwYJcFXqEGylMsvO+zU6oy+qNWUKqYt0NhXdYJmaxbqVMvgBcPK9+zUru8sNq50XF7CqKYFi1VUrlyUZV7lt+Xct7Njw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxfPJLALcywCGY5eQBVLNzKgfI4Um+sZRXZXUK/OeVw=;
 b=nH95DECKdn8PIr2XIbcJEFb1p6zPRz8WHgFvRJyY8tXec7xJIE8TF2nNyM7UzRWsReCgjXtvfXChtxGriZgcgZU9xUprGrFXuW2iUfqAchxuOsOcRv/8l2AJAWDivOhxUVg7txcH0au2m1uhE4drevtUi32KkHPgxFPsIr4nSYw=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1370.namprd12.prod.outlook.com (2603:10b6:3:76::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.26; Wed, 6 May 2020 23:02:57 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 23:02:57 +0000
Subject: Re: [PATCH v3 64/75] x86/sev-es: Cache CPUID results for improved
 performance
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
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-65-joro@8bytes.org>
 <ADD6202C-6743-4C05-B9C9-952BC45C215D@vmware.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3ab38184-59fd-73f8-83ca-3f35c8e391eb@amd.com>
Date:   Wed, 6 May 2020 18:02:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <ADD6202C-6743-4C05-B9C9-952BC45C215D@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0119.namprd05.prod.outlook.com
 (2603:10b6:803:42::36) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0501CA0119.namprd05.prod.outlook.com (2603:10b6:803:42::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Wed, 6 May 2020 23:02:55 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6ae54519-a363-4629-06e0-08d7f2119dae
X-MS-TrafficTypeDiagnostic: DM5PR12MB1370:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1370F9C35B6447491F3214ABECA40@DM5PR12MB1370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nyYVi2ogYuRcQwppMRYZupGrReEmbB0qjdyIVoIQgzWrH70W20e/0rB5ASgSFJvVmZe37ydQDdYgmBKNX1GONYsLmhlvt2oqFDJMVMOzWChQIm5Oa3sLfKr7gftvidtxanqk+o+YZjoqFomTGcK+g7y62WrVxUmOuRirY+V/+yPqZZqbkgPp2RxYo1vFv3Alqtd290bT6jmnPX6Grn3jvVaNLRTT1ULt/twLjXVZiwpU72lV5MQijjfFOtkLiJzToQMonwDIg6lNQ4H7ciIxU4O6cOsmtaxFFDAdp7+6ZSQIcWDWAWPc2Q7dNB5RnbaOV72jVOpgeINMBAdCH4h8tDkXPOF97rS+UW9fkRhDeVBLkcRxzkV8+M4ZHy3iQyMZUl84dxj97iGzovMO7GW0fc4x1vLvbxRVmvRQoARCgD/HtVIcj8d8SUenv9XXmj5Q5YgtSF+DBBB7YWhZW6Myi1K5R4eaDzh0OwWkL6oMvjCs8VDeAW1YKkyLqzxM07wzAPU4XMQ0LddZ4QUyRqJbxBQ2SfQIvLIDoFJ7ab0KUzCX7QwCIHvAN82n9pzQ6hlr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(33430700001)(8936002)(66946007)(66476007)(66556008)(186003)(16526019)(956004)(316002)(52116002)(26005)(6512007)(54906003)(110136005)(8676002)(86362001)(53546011)(2906002)(478600001)(31686004)(4326008)(5660300002)(7416002)(6506007)(31696002)(2616005)(33440700001)(6486002)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gW3gQPQKKoCxE9ZjYDIzlqBjTR5C4YgDCbH4zRP18taLfNKlwFGpOrxUcJLqvCgfqRnfTcXYkdLS7QK4R9BeI16dMQwzMVL21fGUO3wxVFZ+nG0cQQ58/jOA0IoqJ+QOc4XThumHQ4JVb7BU/azWXbqe68q/Sf4R9SM/AsWcQVSq18c5JQ3a85NE8Ms0EdBn9IGHaHMTWlrZBK3gPGCRw6Czp2YQekd0bKvDBG9mhdb0QSxFb7hwVlXoUj7SI+mRiRWQzXAsj9ulVsolQKFbAdlbSySo23DjuCbUdWibm3RaBIvqnZJm4tmxqsF08pK+LYe2aEPKNU4/aYOnFV8gpKsPWSQlXx9LxwbFWlZbBHzVdB1LjK8ACj1KbEDtuCWiocQ9ICUOjOa/L4phRoaIHDpBQpYZTta/1lLVNtXf/7h4oYvQLgyoN2XMR7BOQeDbNk91f5b6QsQuxK/Klszr+Vn3GYnlh8BDcpV+6GL+4ELvzGn6aAKj+Rit7Sqwbtd+owBAvRTpd+RZcnGCKfmr//REEoMkRLUMIkKqYE26VYj5m8ZWqbZl0V5kpwvYmitlbYu+bHVDeoH+l2KlkhvFQ0o6cHia2WAyME/evDYrYQnQROzUuWgKGBj7leLVxltweIirMz5fGxBARwBtmhtYR7c043A3DR8+NKpgAhbE/7P85KB1UwkFkt5CswmYZJ+oWzE2kjJrKPkDzCwIRr5AMqc60sueToteWs2DUEGHK1SQerRKTzOKMmBy7orF5A9H+qAs6MA+GkTgmYYoSYDsFyM5hzhO8O8smmYA/CqJdFk=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ae54519-a363-4629-06e0-08d7f2119dae
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 23:02:57.4036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JgELZ4EnHC6LwKCXBii0gsPR+pVA/CseqRJnFvagARdvZh6AuUQH0NgEjLan4W1qDtytoaLbXFn9IUGFPtpQSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1370
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/20 1:08 PM, Mike Stunes wrote:
> 
> 
>> On Apr 28, 2020, at 8:17 AM, Joerg Roedel <joro@8bytes.org> wrote:
>>
>> From: Mike Stunes <mstunes@vmware.com>
>>
>> To avoid a future VMEXIT for a subsequent CPUID function, cache the
>> results returned by CPUID into an xarray.
>>
>> [tl: coding standard changes, register zero extension]
>>
>> Signed-off-by: Mike Stunes <mstunes@vmware.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> [ jroedel@suse.de: - Wrapped cache handling into vc_handle_cpuid_cached()
>>                    - Used lower_32_bits() where applicable
>> 		   - Moved cache_index out of struct es_em_ctxt ]
>> Co-developed-by: Joerg Roedel <jroedel@suse.de>
>> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>> ---
>> arch/x86/kernel/sev-es-shared.c |  12 ++--
>> arch/x86/kernel/sev-es.c        | 119 +++++++++++++++++++++++++++++++-
>> 2 files changed, 124 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
>> index 03095bc7b563..0303834d4811 100644
>> --- a/arch/x86/kernel/sev-es.c
>> +++ b/arch/x86/kernel/sev-es.c
>> @@ -744,6 +758,91 @@ static enum es_result vc_handle_mmio(struct ghcb *ghcb,
>> 	return ret;
>> }
>>
>> +static unsigned long sev_es_get_cpuid_cache_index(struct es_em_ctxt *ctxt)
>> +{
>> +	unsigned long hi, lo;
>> +
>> +	/* Don't attempt to cache until the xarray is initialized */
>> +	if (!sev_es_cpuid_cache_initialized)
>> +		return ULONG_MAX;
>> +
>> +	lo = lower_32_bits(ctxt->regs->ax);
>> +
>> +	/*
>> +	 * CPUID 0x0000000d requires both RCX and XCR0, so it can't be
>> +	 * cached.
>> +	 */
>> +	if (lo == 0x0000000d)
>> +		return ULONG_MAX;
>> +
>> +	/*
>> +	 * Some callers of CPUID don't always set RCX to zero for CPUID
>> +	 * functions that don't require RCX, which can result in excessive
>> +	 * cached values, so RCX needs to be manually zeroed for use as part
>> +	 * of the cache index. Future CPUID values may need RCX, but since
>> +	 * they can't be known, they must not be cached.
>> +	 */
>> +	if (lo > 0x80000020)
>> +		return ULONG_MAX;
> 
> If the cache is shared across CPUs, do we also need to exclude function 0x1 because it contains the LAPIC ID? (Or is the cache per-CPU?)

It's currently not a per-CPU cache, but given what you pointed out, it 
should be if we're going to keep function 0x1 in there. The question will 
be how often is that CPUID issued, as that would determine if (not) 
caching it matters. Or even how often CPUID is issued and whether the 
xarray lock could be under contention if the cache is not per-CPU.

Thanks,
Tom

> 
