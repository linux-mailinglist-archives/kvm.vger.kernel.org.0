Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F20145115B
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 20:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243601AbhKOTGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 14:06:10 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:52960
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243433AbhKOTB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:01:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qz7oPQSRD76Cumyf4OTRDlM4PG051zuvrOiKnI7Q5a1O5HDu7ToN8DhwR3F2tNvnFQRklVOB5A07phBh2DxXmSt/ul1/jW8sc9aL1Eon+/in4jJpKyjG1TugybvRmdqZqEPKH7IhfUnVcd+k7NQCRjddv4gISWQ0fJG37jBw5gmN4Rgx0qdqno+4tbjTnZz5IGm5PTINqLCHrNwcWZHs6fcHFhGvZfS7xiZGZs4ELSjpkeH/IkAj6etT5qPy6WpOuXd2RDEo94IeQK0qUTd2cbpomvzn5gSHqIfddVenfcGG2XwFZyuAJKHoTE1C5TDpAW1EH4NlWH/Sw+s7yNnaZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTrnN7Y01Lblrv7dMLTBO4KjD+T15IzdePoLJnPbrOk=;
 b=Ms1b3bj6AJmT9/rOxcyIP8JWHb0JKLyznMqom+WuaMgxI++7NUDK7DSKg5WooBWBGdN7yy9BgZaRcfG+AzjssEqaX9yC7PAjsabTm96MLOpw/7JqbQuR/MYuk4twKL7cnx2WjFWusD9mHmWLWDLF5TS/gP3CjcX5qAbFB1oznpwmmnD2CHqDak7GIIYNt9MFyPR7SFDibrZlcNSNccxuVsTV8hQLp2NxcG9HZ8ZhfoIF5tRZg2fXmFrMpHQvGGNGQKb/nZWbzRLWQFgpum7gtKtuYk/fheGJ1x9s30owFPqEi9P0nS+Re/qiqqdu1C7jiDAVIwOrH+TkmzgxR8xbgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTrnN7Y01Lblrv7dMLTBO4KjD+T15IzdePoLJnPbrOk=;
 b=W9w8bz1Yp2l7+OOE3F/tixft2fXU692fjssB+yyxr+ipBkjZZT/H0Pi3qzQRNMlb1727jLkoccqzhDXoWm76mvPjRNBp5k1AZE9LLvZyc1NfxWrPMd072XyKMomAwuLQkg+jWBTe8MXpKZWLRONL7l/OdB98WK7wv9Yaj6k2Nco=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 18:58:59 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 18:58:59 +0000
Cc:     brijesh.singh@amd.com, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com> <f2edf71e-f3b5-f8e3-a75e-e0f811fe6a14@amd.com>
 <YZKqoPAoMCqPZymh@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <f7b37ae0-4b7f-5b2a-1720-cfba0163de3e@amd.com>
Date:   Mon, 15 Nov 2021 12:58:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YZKqoPAoMCqPZymh@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:208:fc::29) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by MN2PR02CA0016.namprd02.prod.outlook.com (2603:10b6:208:fc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Mon, 15 Nov 2021 18:58:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b91141d-8951-4726-fb6d-08d9a869fb6e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-Microsoft-Antispam-PRVS: <SN6PR12MB26400D5E4EE8D6126C701B2DE5989@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TCbw4vU+mnoULq9zNfAljBKlAzaUDsJrQ9DMqKm1dPsMDHSNliUUbm4jnKvrlbwwQ32B4Hrq/i69KLhnzcqBwwV/tGW/hko3bdekNxQjlK+MUTQLxU+8KXWTDhhgWYE3m4ULGRq+mi8oYImuqt8aR3kjOyQ/rKt8GecMGVkqeai2JRK7fG83lVywhfps8qN14WO1E2euTfBaaFRs4M8/+Ie5Wd2JpAjfHmPXJgzwGnVq3uPF2sfjsXZi51ttyZNBFseSMzN16LoqwZxk4qGxJcv83C/GJ/KBFGatxQnqVZ8+yj9vervCFF3f4ZDRVKUUzGnf/QorFfDhUvfJ+5B1Xy0rZ6w7v9s2J0UGZOfaikhsMHPPx4//AW54jmSfdyoVG4EqPbT+ZQbP2bXNmNBSXuA/bnOjuwavxdAyydQ7UNjacJUlNlbgkzvnSP3KwJ1vyj9cDlLqnBfDRODBe96WELVRnNYpERiwygIkqrTY4lByZDHgnvHrRnT2ZwA3lfKH6kOF3T3+jn6b44HS9C4ZC8e+574A8BzV3pGSmCey8EC7fSRw9P5Bvtjawd13sCW9iAOHgB/Sek3IfQvB+A6VltT6w3goXFFo70QrpgmvGjL0y/MKpisq7Q3W0lMLSXVfAfz0KDwIeim0737VHRDYHshSaZmiQDcN8ORaydgAa0L5y5BWtLB/RXVciy3W5OGgghAQHx7SiUr6DImW8iBcnSdo0amF7NAaCxtPD7+F7pA7mCzYh+xYtZdYs7yEjlXC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(66556008)(508600001)(53546011)(66946007)(16576012)(66476007)(186003)(36756003)(8676002)(38100700002)(6486002)(26005)(8936002)(31686004)(7406005)(7416002)(6916009)(86362001)(31696002)(2616005)(2906002)(316002)(5660300002)(4326008)(956004)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjRoaGZiMXZOaFMwOG9CZVpVVVlaUnhubkkvL2FzMS9ua0VGR3cwNU9ZbVND?=
 =?utf-8?B?YXBzWnI4ek9tVEZXem9NRWxQVm4xa0huSkhnQ0l6eEIyNWVtS3llY1FwNHhF?=
 =?utf-8?B?QmJTUU9DcTFxc29ydmRSU0J6SWQwYVpkNDNmTG1CQTZSazllWXo0d0FHMmpw?=
 =?utf-8?B?ZCtJWFNObmkyVnJBcDQzWW9ReUtYaFJHYlFjdC9aUzYwYWNWTkFQbm04MGJo?=
 =?utf-8?B?Q0lGcFYvY2xTWU84T1RTNDNUNGZmak5Lbk5MZzZIMUZ6RW0wRlcwdWpQZVYr?=
 =?utf-8?B?bzBKc3c4V1M2QkxDMTlyOGZKbEpoTnJFT2tOZWZjMm9hYTd2TmREVWgvVGRs?=
 =?utf-8?B?NmV6Q09BQk11TEJhelN2K1V0NExqVUxpTnFTRzlMY2FzVm1DMTZRS2J4US8y?=
 =?utf-8?B?M3VaWHE5UWd0RXcrVkdESC9ZVCtMNzNDb0RyWmJMcGVLcm9IaVZIN2UzN3NT?=
 =?utf-8?B?NHJkblZsQ2tEQ1haQUxISTVFbm1pNkRvN0l6VVdycVgyYmp6SmJkTGVGbzhE?=
 =?utf-8?B?aVNGSk1pS0dUWEpDSzVybFBtYStzR1UzV1dvM3RDa1ROaXlKT09kcmQyZWxP?=
 =?utf-8?B?UmU0MVg2RDliVXFyNTlkcnN0dkMwQWNqMlRUcTYxaGhIbUtQcWIzV0tEMHZq?=
 =?utf-8?B?QVg0NVRWZHlFME1OMU5ocTI1TFJVQWltU1VYMllIRm1aUzFlbTVTOTJ2aHlp?=
 =?utf-8?B?ZUxUNjlvUEJHK09USkIzZGkwOGN5U1Q3cmFLMTNTNTBjM092VCttd0pYc0lT?=
 =?utf-8?B?dWNibm5jWmFmK1Q2RmRPT3plc0YzY2ZFTmFlZ0U3Vm1aOHhOZUFZUldXR0E5?=
 =?utf-8?B?MTA3aERtSytlVGpzUWI0VDdVSzFEYXViU3JVY011L0pNV29QakdFbDhzODNO?=
 =?utf-8?B?RFZvYnM2blovL2dWZ1B6M2oxbzVRKzVkeGYvWDVxMk1QVS9adGpGZHhLbzZl?=
 =?utf-8?B?TkcxUWtMNXNnNjR6VFNPT2RIcHQyMjF0OGpNajFvN2cvd0tZVVFHQmdYV1pG?=
 =?utf-8?B?d3g0dlppbUdjUmY0SlBvME9senZYZDBLOWoybjl3R2I5RTZVZ0tIYlVlTWVi?=
 =?utf-8?B?NGlRb3B4WEsyUHZlRFh4Tm9UK0RPNmlqVzJ2SjZ0SmwxcnBnaWdCUDd4aFF2?=
 =?utf-8?B?L20xdi95aXdtaEZtMnBQeUNyMXhJYktyR0NtbUZteFN5K3lHdlVkd204akI4?=
 =?utf-8?B?NnRpcEo3ZXVvNjdUelNQR25ZRFpmRjB3VlBKTEd6MWRUNFZpM085ZUdXaGRI?=
 =?utf-8?B?bWpudmVoaXh6RU10aWhTVnpGQkY4TVNQKzZyYzVnN2toV1V0VHF0Z09oYlV1?=
 =?utf-8?B?RGJ3Q2JYTjAxTmF5bE5TVGQvWFpuRHhGWVo1TmZpRnVLV3NTSENCS2RyR1FZ?=
 =?utf-8?B?QlFWcUxFVmZ5YnlQNWRiVHV1c3JFZ3dJOEk3bUlyZEsvZU44bHFsS2NPbUlF?=
 =?utf-8?B?YnlYdlljaTJoUCtud1MrS2hhSGdoMy9aTEFRRnE4RXhHSUMwZU84ekcxSkU4?=
 =?utf-8?B?WmdRalJyTVZSaE9BWHp0akV3T2ljdFdUV1p6amc5SkVENFBPN29ZYkFNekNS?=
 =?utf-8?B?eVRud2sybGdYVDRRai9UY0dBaWxiYVluckNrOEtLQzljRjQ4eGVmNTZ1cmxR?=
 =?utf-8?B?anVYSjg3QU9UM3VZTXRjdkxTSVNId3k4cDR4SzhJYmMxS0tjbi9KalpwaDhE?=
 =?utf-8?B?eXRhK1pNdmpINkNZNmtrdTBaM2xFRmZoVFFGbjF3aGMxNkFhbXdvZ1BlYm1V?=
 =?utf-8?B?Qm9KMFllRkw0aXRsL1QraFR0WnN1OE13K1F1V0lRQy9lNlppa1Q0QS9lN0dW?=
 =?utf-8?B?ZGNCQVdTUFJoMTlFYUFzT1BBbWh1SXRWOGVlMmhtQ3ZxL0hUV3VGc25MUC9z?=
 =?utf-8?B?TlRwd2JTME9jQ3ZUTkMycm9ZSkRIR0ZKdVJUL0U5aUpNVW1LRkhEcHN6VWJL?=
 =?utf-8?B?elhnL3R1YU01WkE5OGZWODl1Mm56MENtcXpuS0xwbUNmeE9JdXpkVDR2dVBp?=
 =?utf-8?B?dzhWbmhhdmVIb09pWHMrV3FzT1hydldYRzNhdkR0d3FVNXFxSnZxZS85NTZK?=
 =?utf-8?B?S29TYkYzaEd3NjRlelYvUUlNOUN0YUU1SWhGS05jTHZydm8rR2JlUzJlaFFS?=
 =?utf-8?B?VmZ4L2RiZW1IWlByZkxFKzJ4S2FQcUJyWGo1VnlHMG83MTA1Nko0eHZkazhL?=
 =?utf-8?Q?gLxleFeWHEykRt75RCjs+9U=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b91141d-8951-4726-fb6d-08d9a869fb6e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 18:58:59.5001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /KgZFkcdtd0K1vGKrCCApX+518TXAA8i63plKQdhO12SI4ajqOM6rzhqmcbjOM/gphPNuPLLczHAfzedj0Abig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/15/21 12:44 PM, Sean Christopherson wrote:
> On Mon, Nov 15, 2021, Brijesh Singh wrote:
>>
>> On 11/12/21 2:37 PM, Sean Christopherson wrote:
>>> This is the direction KVM TDX support is headed, though it's obviously still a WIP.
>>>
>>
>> Just curious, in this approach, how do you propose handling the host
>> kexec/kdump? If a kexec/kdump occurs while the VM is still active, the new
>> kernel will encounter the #PF (RMP violation) because some pages are still
>> marked 'private' in the RMP table.
> 
> There are two basic options: a) eagerly purge the RMP or b) lazily fixup the RMP
> on #PF.  Either approach can be made to work.  I'm not opposed to fixing up the RMP
> on #PF in the kexec/kdump case, I'm opposed to blindly updating the RMP on _all_
> RMP #PFs, i.e. the kernel should modify the RMP if and only if it knows that doing
> so is correct.  E.g. a naive lazy-fixup solution would be to track which pages have
> been sanitized and adjust the RMP on #PF to a page that hasn't yet been sanitized.
> 

Yap, I think option #a will require the current kernel to iterate 
through the entire memory and make it shared before booting the kexec 
kernel. It may bring another ask to track the guest private/shared on 
the host to minimize the iterations.

thanks
