Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B38299782
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 20:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgJZTz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 15:55:29 -0400
Received: from mail-bn8nam11on2044.outbound.protection.outlook.com ([40.107.236.44]:21601
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728959AbgJZTz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 15:55:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgouhX7d/JPkhTsAY17ZIMGcPr15Hbe07I3VXGQabKq/iBjOtDdpJKpss397tYx6Y8WFVxsOnEq1EsO5d3wOxsXM0VWCoWhBeomkeaGBBoSCbKfNRl0CxwW/zUiH9gXhCRLzBgpnO5lYRxkQWtVfS8zj43Kx0MCte1Mugk6Tnv2vADsdzqXzrUWoZhn0KtIBKn9ugywiMj8tnB/priB8vfrOIJuzvBmKIe1nF3nqumZeFLQUc0KNjyFJy0hYmL2QvBjIOD8z/diISr83VW2pdHPNVZMmEL8f87uPq4b0qNdm+geJNmuEN28NttEiIHNPMDEQ5U7y5+EvVmdld9ATPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZPwnqGtQcT6VTLDE4eIUB+EFTPojpYwXtQWzLjPt5Y=;
 b=jagaqW5Lyw6GMkNNhhJgz4t7Uu3O3GVmyNTiUw2h3s/WV+1kJqYa1tXduo0DVzTgSvn7mbPwpCFVLpdiEQcgqOTOmlHsSu/5Pf8/VlJoileEP3uQGdbJo03rEY4oHBa2XFuWFjuw7WRQjPjjEQ6Ta6y9Td2qHvRZb0fX79UN5RDxO0gtewzFQysw2MmEp1DoEqScnnaLDdoXu2n/G6j29wpsiTZtVmN9ML1aYPG+OqpcpIPhZ0vpHfxPu7nC91zolm8WC170NkiCyrpIFzxCj+oU7NYKYFHVhBhRIcLH56Vc/pWhOwsKTAVNAzjyRIAwVQA93qoVzzjOFmv32q04VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZPwnqGtQcT6VTLDE4eIUB+EFTPojpYwXtQWzLjPt5Y=;
 b=cgJs+jCcFDzGJcwCaeQZNX63rvZxpz9hPtCCyXrjqy+ajXW6JdyStiKe7rA+E1l8Y/msXlBK64QlN+N4AEjxzUsM5DObpavIBVbXewQpk8/pmQPQhcSQD2l0Ab965BysqvGnF3mOMvvh+JGnmHsNYQX4dwy5dS8IfhaBn6SbHxQ=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4043.namprd12.prod.outlook.com (2603:10b6:5:216::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Mon, 26 Oct 2020 19:55:23 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.018; Mon, 26 Oct 2020
 19:55:23 +0000
Subject: Re: [RFCv2 15/16] KVM: Unmap protected pages from direct mapping
To:     David Hildenbrand <david@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mike Rapoport <rppt@linux.ibm.com>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
 <f153ef1a-a758-dec7-b39c-9990aac9d653@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2fe169d4-ce99-1f30-2fea-89d524fe05a8@amd.com>
Date:   Mon, 26 Oct 2020 14:55:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <f153ef1a-a758-dec7-b39c-9990aac9d653@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR18CA0082.namprd18.prod.outlook.com (2603:10b6:3:3::20)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR18CA0082.namprd18.prod.outlook.com (2603:10b6:3:3::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 19:55:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f49a43a4-a443-45b4-bcdc-08d879e912fd
X-MS-TrafficTypeDiagnostic: DM6PR12MB4043:
X-Microsoft-Antispam-PRVS: <DM6PR12MB404318FF137AEC60FB1AB756EC190@DM6PR12MB4043.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxOZb0N0PLGXWQcm/0BzlkBYVpaFl4RrAFa11YqxsslpPjm9itfvFFR0PKWWXpd5338jjHrB9N6Ek0Z1vzzrxmiI6Tx1751+uNVLC68+AClkYKPyTcd7ui5hTUY8zep7v+5yX3tKyV9eZv2ZGd5fPUyRRcLp7m8dvebb54Sp3zpQNaMDl28EaCmwo/8sHZsO3lb6xy/yMEKj9wdvgOvRY85NtmD0+kzDBHzz5gjT7WGi08jDFziYdtfY6UUEJDsYvSjf+J4p2QJEKs3Rn9aGURatyWQmm+YpOfxwr6PJ9yN9IVhTdl1T0cQQgujgQAAbaZoIkQLv7cxqFKbGKToYXbc2SU8/QW5lYnJNvW6HZ7Cna6DhGNDFbjYbqdB6WoOAbKlEFsPKZ18Pt6EzP9jy0GYRf4eLtcryN8GJOf/KfLqDl44QEdbJVhLKkXjFCxlDn3Z+QRATMIef0XRKAFO8OO5MB93HXRG/i8/iHQCtPeA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(8936002)(54906003)(45080400002)(110136005)(478600001)(2906002)(26005)(5660300002)(36756003)(966005)(31696002)(86362001)(53546011)(6486002)(2616005)(7416002)(956004)(66946007)(66476007)(52116002)(16576012)(4326008)(16526019)(316002)(31686004)(186003)(8676002)(66556008)(921003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yEgfbJ8vshlvG7rGnVfj3wCEDojec5jySxARUYiYy/s7gfl27JTmt6mYUchZ2wR7Y6K/EgCqkMKaMnGOmLlPxO6VorwpgzE6r3lnLvEiQjHJr0te1DaXgSX8U/QQl5TYErtotyLoGKPOqUGE307TlkVkF5MiKWxeEIJ1+N0SQOYte5dbquJQNWDV38rARjye9pnurEqKqole35tajFVWdTqcEzLqpdpiCGlfEq+2SKj1Pw05Gvzy/WA8qpxCD5DNtN7YGEHFtYRNt020WInLAY+tR8s8PcCqNy86zlYfsT0kpiZggI0cQ48NnIU/cb2MOSw6oaq/Jg0N7UwWFM1iphwnFdWnge9SZFmmgEpTML1W8hOmKlRbaj3pGxtd5jHhHk6P++B/LR0/Br2nfOmuGCs/u3uQTFTQKK/4WR00l+68YMJDFv+WJcE0xF7mx+s+2LkRLZ3kA+LBaoolVfVS3y7EcQT7ad4PFVADyPEP5qrAK6S5PTwAm9HUyaVQSIlxd3i5HbuD2MZ/a39WYMr0Bvg8fInAHWpb8xYazZ/0MTtX0jvxGJwoKf0UenW69kCiV8C+1evXN4hX0ZMkYUtMLpm+9FSZDMRPtEpesf1VqBLVDWh4Wb9Rms1GEbb7Y5PXjSzUuYFMxHyU0nq+FQA7pQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f49a43a4-a443-45b4-bcdc-08d879e912fd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 19:55:22.9693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSGiERkTQvRmIpO23p5N3gR5HR7SMJ5aZQfaWujvNyLJOGoNo+zB2ueJ+3oT9BzLakDbTiuoggpy+y5RDVlkew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/20 7:18 AM, David Hildenbrand wrote:
> On 20.10.20 08:18, Kirill A. Shutemov wrote:
>> If the protected memory feature enabled, unmap guest memory from
>> kernel's direct mappings.
> 
> Gah, ugly. I guess this also defeats compaction, swapping, ... oh gosh.
> As if all of the encrypted VM implementations didn't bring us enough
> ugliness already (SEV extensions also don't support reboots, but can at
> least kexec() IIRC).

SEV does support reboot. SEV-ES using Qemu doesn't support reboot because
of the way Qemu resets the vCPU state. If Qemu could relaunch the guest
through the SEV APIs to reset the vCPU state, then a "reboot" would be
possible.

SEV does support kexec, SEV-ES does not at the moment.

Thanks,
Tom

> 
> Something similar is done with secretmem [1]. And people don't seem to
> like fragmenting the direct mapping (including me).
> 
> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20200924132904.1391-1-rppt%40kernel.org&amp;data=04%7C01%7Cthomas.lendacky%40amd.com%7Cb98a5033da37432131b508d874f25194%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637387931403890525%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=BzC%2FeIyOau7BORuUY%2BaiRzYZ%2BOAHANvBDcmV9hpkrts%3D&amp;reserved=0
> 
