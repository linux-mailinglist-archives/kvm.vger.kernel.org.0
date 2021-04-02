Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64CC3530CA
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 23:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbhDBVdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 17:33:42 -0400
Received: from mail-bn7nam10on2057.outbound.protection.outlook.com ([40.107.92.57]:15865
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235659AbhDBVdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 17:33:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZ1AKVs4uMOUGk6veVQoAucUN3WjIvg5WkLkjJXz6WAi4KSDr8qOb5dF6z7soP8axCtL3VH2r2BH1pUm1JkyOnWbtknj8csDRbEkJzxeDEyPrIf5JA0zEcAqt/ihQ6RJAPQTvUkRcGMkwFNg56RF3UAkM4fMXcCBESp0pkxnYTFZd1qU9obwslMPrprgiHlTqSkewd41cC2mMn358ATITVxDEDYMcT93KgsHcIICpjSjfC+AQ1Rn2Mxu6k0W8T6+Y6EuXCPAby4miZmQaZPsnzw59zP5vND21WnUwEogRbKJ0yjon0bpNiq8rhOw88LRtYQw6jeoDKaZr2MG2oBKiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOx3uxhhCJU/Z80L+Lt9zvbeedPPxSc/FqVIKIJoxi8=;
 b=JagOTw75xQicTDpfujn9FuS2gzGvjJ11xJCFRQOl7vGbV3QuCrTCiFXnZrFkVnaWRppzgQZNn83T97xF/wmp+Bs50/GTZaaBB+Dp7HEEHhJmy+5eG0gpPsgF7ohLLl0bRSNaWtipu2T+CuesV2X5hRLhemuG7XqpyEauoUwsH2LCqVBZNkNG9J7DXF+8UPUO2A9NoEgykZDeG/QgnDy7Cql86tcFPPh/QPmOqbKJd1IFlgYa92x/FtODA9IjMBDXwmBqNbsBuWJl7yTLbrxzOGjWnDL8VhWN4pjcsdQRCC/Ss9jCwz5bhRe1MwaHAT1PhsS3XuVym4TRVX52RtwcDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOx3uxhhCJU/Z80L+Lt9zvbeedPPxSc/FqVIKIJoxi8=;
 b=o5CXnzAhoUr5cI8eSH/OJwLtqWsrKSBS9HbUVBMZaITENVlTX+SFxouCh+Lr97c9ubMuJxzQoa4u6Eb83uPcPUaw7+ZeVtL9nlI+ERnAfwWdcS5GjVX0y1L5LVuaV9Tuxl+woh1kk/a+WruHwiagdZXDCgMtTyYYV6+5fG5Cgu8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 21:33:37 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3977.033; Fri, 2 Apr 2021
 21:33:37 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 05/13] X86/sev-es: move few helper functions in
 common file
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-6-brijesh.singh@amd.com>
 <20210402192731.GM28499@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d2e142af-130f-aaaf-9b0a-bf82da1a0cc7@amd.com>
Date:   Fri, 2 Apr 2021 16:33:35 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210402192731.GM28499@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0059.namprd11.prod.outlook.com
 (2603:10b6:806:d0::34) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0059.namprd11.prod.outlook.com (2603:10b6:806:d0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Fri, 2 Apr 2021 21:33:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3314931-861d-42c4-4019-08d8f61ef9b7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44136DAEFD4E2CA036877AC6E57A9@SA0PR12MB4413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZr39SRD49WrHcL1ldQQfAyp8rPuA8LoxSlaqD7xnjsSh1qVc/APDqDbGqKIu1uG/gh96dOPmF8zy8TaLQuETfYDoNToDgWPKBm8OohGtGLHITv9YfyYXDNYxKGlQSPiFnta1j9sAPMyXZW5K1ocnFo2p9rmTuZL4IWrLgfhQQKdCfRENMPkiBK5iDzaGoIQxuhmp5PXeIvV5844vojOvQrbI9dGZNMvEl3PRd5geRxoURBFFIa6HPqVihbUdJjldB0IrSATpAJiaDd+CVpLdDJO4N9aKdzGtGw/jFAehGqXn1RDYl3+jsgjRC8tNJzMRHUgwAU6DtoFjVfUsxy2Z9Jq4n4+KMv1qldgotShLAeFGixb6r2/ftg2Dg0qCs6n386hcWnEB3Yh5BUeY7ymvwLOABBWhCeU+ubZp6dQfoEXAHUpf2YzEnlWZSz1W9BaBrg82G4n1JlCZ0lmLIP1x7IUOsvvMmfv5xMfhDlBDDJ8lwxb8zz1ZfZEinVYb9fjSt395tcvafOF3sAyP4Wb4kUEXHkz6NMafLMWduOGjHDUmZ8QmuTsVPJxHYVuL59+tsiDY0PgAJ7rfrLaFVHiRsHDdYvflnfkF339VynWZQ1IJ5yplmE5YAd4Lf2KdS+wPc4zyLwPm8gcI01e+rkdlJj/bGb8DsflstEIIKVEH667bbz29+ZsF83OnlsG9YVa7+gzMBvhk0qgCA62D0BikA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(44832011)(38100700001)(83380400001)(31686004)(16526019)(2616005)(956004)(86362001)(36756003)(5660300002)(186003)(478600001)(66476007)(26005)(66556008)(8676002)(6486002)(66946007)(6506007)(2906002)(4326008)(6916009)(53546011)(8936002)(54906003)(6512007)(7416002)(52116002)(316002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MXJsRzlNWlN1ckR5RitJMnA5Kyszam4ya1hlM05scXdidEV6d3BmcGVDdXk3?=
 =?utf-8?B?WUtzUGVrMm9OVnhiSFlqK05IZkgycmF2blE1RUE4NVBGSCs2TVJ4V0tlY0NL?=
 =?utf-8?B?dk5HZHV6SVl3Vk1oQ0o2MWhUQ2xsb2JFdGFqR1RrOUxTenQ5WFVTR0dyeVlj?=
 =?utf-8?B?STlMWElYZGZTcCtiVHBVZ05vY1R3UGJ2N0FxT3FkR3VXR0hNNjREZGJtSU5u?=
 =?utf-8?B?QlBlMnBVd2Z1RjNpc3pFQ3c2aDRseWh4NktTUDFPWjFTNk9UVmFLVWJBRlBZ?=
 =?utf-8?B?QXZjczRWb2RoNllwOUc5UUd1QnE4TTM3VkhtcTkxa011ZkdTM3ZMclltdmdY?=
 =?utf-8?B?T1dROWQvYkRpeDkwR3pESXNiOVVJZlZtb3dOeTlVeHcxb2J5MGE1RG9WKzZI?=
 =?utf-8?B?TC8zbUxQSkJyZmVJVHE5aVlGd09RM0d1ZTM4NUhNL1FDbEExSEVQQWNtYnVn?=
 =?utf-8?B?S3U0SE1PRTJoU2U3bDhqdmVGNzNQeThhVkhqTHZaNEVYSjhVQzZPZW1CU3Qw?=
 =?utf-8?B?azVhTjU0VGhQQXh1em9sYzRMSmpnajBYbHN1OGNlWVBHY3FOc0UzN1phNExq?=
 =?utf-8?B?eDFaV2tNdkNyQkdpRDdoUGRXd2VldlpQbUVIbGR2cDlieFo2d29iUEF1aHRa?=
 =?utf-8?B?SlB4ZUVFdXo0Rmc4MXhWenhNWmlscWY3eElPK0FMS0EyZmJXQWRpODVQNDl5?=
 =?utf-8?B?TDdzemdEZ1N3cTgvYjNsZGJKbzVJVmdPYjV2ZkM5c00yU2lvU1kydFFpN21x?=
 =?utf-8?B?SUl6TTlkYlRiemtjdW1NYXBJRDlvRFZtVzhRK0o3c3ZqUmdjWWt5bUhxYU5D?=
 =?utf-8?B?TUUwSlV1NGpoWW9RbWEvREtLUEo5eWdqdVpKdlBSWmpiaUwwd2Q2VC8yOUdX?=
 =?utf-8?B?QVNsd3ZVZm9DRTRDTkhMZTFMS3dpMHFseURqdHFEcHcrbVJhejZvam9UdXgw?=
 =?utf-8?B?VE5odmhrcGdpMDY0RjYrMXhWNktNa3NHZ2R6eHVrcDFYcGlBdElrS2FyOFkz?=
 =?utf-8?B?VHVGNkJsdUFxbXl4ZWJMdTlzR0tzZG91WXJ1RGd1cVptcUNPaEJteW1nYWto?=
 =?utf-8?B?Y0dCUm5iY2VwMEhpT3hJUEk5VmJjTjkwemtBYTc5Z2V4TVRYbjdxNytOK0o0?=
 =?utf-8?B?cHFtS1N0TlRDZ2ozR1h2RkZmaHFLVW85YWFaSjR5cGJQSUlOcHErZ3NZZkE2?=
 =?utf-8?B?cGtpQmhmR0xWTWxzb3B5b29OSy9HVlBaTFd5VG1vVkR1d1dlcHBWdUdSUkxZ?=
 =?utf-8?B?YVB6cUlvb1dkM3VZNTlZazR2Z3JZU3R6c2w5anhCeFBDRFREVzBMSFdIYkNi?=
 =?utf-8?B?SDVVaTFFMDJUWEFSamJoZ1VGK0g0UVBXejY5NjNtNGdQSzRxVFp2U1ozTDBa?=
 =?utf-8?B?V200VDU0WCszMm1rZERlOGZNWUM4OVdKS3h2ZkUyY0t6a0tEa3ZpamFnVmRn?=
 =?utf-8?B?aGZpS1FvU2dpYVlOZUZJOWNZN3pmejRvVWlmV3RrUldmVmNvbUdnSjd5UEJm?=
 =?utf-8?B?dnZsalBBNktpaDE3a3FLd0g5YTczamJzamR0Wm9jU3g3NkpLOCsramVDTVQx?=
 =?utf-8?B?dXFpU0Npb0R6V2lSZ1FxbGlrUDBQWGt6U21BeHdmT1dBTFNPb2dtb0tqYXpT?=
 =?utf-8?B?QTR6YThWN3Qra2JodjFvZkNXNVlLWS9Gc2Vmb2dPSXNwS05xdlZjNGQySklH?=
 =?utf-8?B?TktQcEd6ZnQxUEJ6b3pVR2hkUGU5cDBSd1Y1TC9JQkUwbTJoQitpY2hzaCtr?=
 =?utf-8?Q?d3u7XDexzVAITU9b0CMOU1kVxP3xnn+4oaDFjwT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3314931-861d-42c4-4019-08d8f61ef9b7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 21:33:37.4881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NiYL0Ti6XTA4CbjmDOKSHbHFptQjbQgbSJD6ryTMufTJ2etCRux3V0zzBnn/t330j96Am/fehfXtM0MuYhWSHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/2/21 2:27 PM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 11:44:16AM -0500, Brijesh Singh wrote:
>> The sev_es_terminate() and sev_es_{wr,rd}_ghcb_msr() helper functions
>> in a common file so that it can be used by both the SEV-ES and SEV-SNP.
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Joerg Roedel <jroedel@suse.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Cc: Dave Hansen <dave.hansen@intel.com>
>> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: x86@kernel.org
>> Cc: kvm@vger.kernel.org
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/boot/compressed/sev-common.c | 32 +++++++++++++++++++++++++++
>>  arch/x86/boot/compressed/sev-es.c     | 22 ++----------------
>>  arch/x86/kernel/sev-common-shared.c   | 31 ++++++++++++++++++++++++++
>>  arch/x86/kernel/sev-es-shared.c       | 21 +++---------------
>>  4 files changed, 68 insertions(+), 38 deletions(-)
>>  create mode 100644 arch/x86/boot/compressed/sev-common.c
>>  create mode 100644 arch/x86/kernel/sev-common-shared.c
> Yeah, once you merge it all into sev.c and sev-shared.c, that patch is
> not needed anymore.


Agreed. Renaming the sev-es.{c,h} -> sev.{c,h} will certainly help.
Additionally,  I noticed that GHCB MSR helper macro's are duplicated
between the arch/x86/include/asm/sev-es.h and arch/x86/kvm/svm/svm.h. I
am creating a new file (arch/x86/include/asm/sev-common.h) that will
consolidate all the helper macro common between the guest and the
hypervisor.

>
> Thx.
>
