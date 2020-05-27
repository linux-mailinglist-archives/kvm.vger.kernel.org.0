Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F191E4C5E
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 19:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391719AbgE0RtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 13:49:17 -0400
Received: from mail-eopbgr770071.outbound.protection.outlook.com ([40.107.77.71]:22343
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388206AbgE0RtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 13:49:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bi6+keD1htTp9gWHN90Ict3QrEbPvl10wOvg4ujybDUqW/wE6u+hAM56nw9k2ch0HjbZ4KludR7wU+OQ3JjM4BfGf8BIclfHgfRdz0ccilWPGy4pQUxu/YqUH6475+2uPgslbSUfl6LrfjTSyv/JWI7ZAc3xpaWsjEidLbZt+2qvx06++BwboLGFHIaA7OSmI8PtEcmlz/EjdNS7yqUDjDjBGkAe35zEqLmJbeYpSC8Oepd5SDwxNmQKBXXQ15VWNiN7M0KparnwKKbwuh7mis72FSWNf0VM55XoHaDneW9hCEV08qdq7k7xOLRohuS9kr71UzgQzuxAAzBpGLCpUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpAlLepyQNGtKXB2bnwBKoBls64kpU+zxLrsMjcTf/w=;
 b=j913ecVh3hxRnQ0phtZg4JY091y4q/o6jkXtHvLw4gf0hssGJlv/30Lm7SEvZ1OTkTnHjAtIgxzBKcvrP/4QObwEn0Oo02QBHN3lzOC6I/Jh5t302YdAyi9JDhObGQct3fdf4F/mzh+q5ZxIn2tIV1Hqke5ZiSk2avZuKVRbiCntTGxhDjzUOQcDHx6YHpF/dbkKj2CRo6xD28JRb8aAEZaT3DPZX3NkrIwiSwLN77AuHjgCPAB4aNIMaHQTMmLoGBDmO8BE5tq/shVEEoy95pQr4xaiQiJhxEht+JdSntL4HZK9MJXm7P+MIM3h7A14bD/uY8gDhxY8/DMxhN4T6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpAlLepyQNGtKXB2bnwBKoBls64kpU+zxLrsMjcTf/w=;
 b=UQq0s2HsriNxwT11+3DvBDOxB1+NNOwjwmg/diVneQc/SrqaCDkWECngXBFkv/qtKXVRtfegAEJyRZ8wecmRvzs5GGc229bDl5PYiissWQBxkyBU2RIgEriEHbrSKnPaQaQuMpNsvtT1V5Gn/ONXWwHuSnOWqgSB9YGCrJVLXCE=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1228.namprd12.prod.outlook.com (2603:10b6:3:74::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Wed, 27 May 2020 17:49:10 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3021.029; Wed, 27 May
 2020 17:49:10 +0000
Subject: Re: [PATCH v3 64/75] x86/sev-es: Cache CPUID results for improved
 performance
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
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
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-65-joro@8bytes.org>
 <20200520051637.GA16599@linux.intel.com> <20200526091909.GB28228@zn.tnic>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <cab5e409-be9e-f2c7-424f-6b7d031324dc@amd.com>
Date:   Wed, 27 May 2020 12:49:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200526091909.GB28228@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:805:f2::38) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR04CA0097.namprd04.prod.outlook.com (2603:10b6:805:f2::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Wed, 27 May 2020 17:49:08 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ee69599-7334-4a4c-793e-08d80266425e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1228:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1228474D69F8B00ACB6FD84FECB10@DM5PR12MB1228.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iLhq+j93Q1B8ZSRgVykF00ZJM8QIVQXA8QvywMoTy3aRmPFLXEm7yyOiMcDhxLUgeczLnikZHbEVl9m2HWPdNkH5br7/+qbRzHhXPjBtvJH4dnomv4Ucn3y7P0ZqSfTPaZo3Nkzt97Y2E8DoxxDbACkwDXDQ6wWmu6zLaj6z/k83a9jNHpdMmNuLtk+qncJ4zqXAi0o8PmIPG5uc//q/BXunA0HNBru999tHSLIwA7tPyHkl+v6EzC5TlP7OM7YCx41smr1fnw7IaYHLaiPEiL1sSz44OuVTxaQSxsXN+i+gwAyqXv5qHzQvk5mO7bEqxMncpea0suixpsWyrRDQVjREp5trUeMOnRQRux6+MLso9SiuzDhhdsMoZ7+v9d/a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(36756003)(16526019)(2906002)(26005)(6512007)(8676002)(31696002)(66946007)(66556008)(53546011)(52116002)(83380400001)(6506007)(31686004)(956004)(5660300002)(478600001)(2616005)(54906003)(110136005)(66476007)(316002)(4326008)(8936002)(186003)(86362001)(6486002)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2+2IjZM/5fA4TGQlC0/jCbGLLAyejC24Xm6mAJZyi8kTGgknyWqnB72b11Os7HRTfNu9PiloInUy8RCpJjTJC7mdiBqi4YSeixxEQFx+wCtpnXotxeICzWVe5rmNTm4G2gGRl3AZbCjE4t6zFvxNB2plXH0Z8npgw/MGuwwmnPm5DNxmH3V3r01NtcNep1g1AxVQu9Q2HrN/5bI5gPVO61lKmIo8KLOnbyAaLhn7v8Q0atBqCxh4v72ukIwJVwmOhDAO424EQGe7VuMPDUG6ccULnOBYNJjZq6b4qlpcsh0OmDdFr9pZ8SpXggSNMPSAar/NCqckve0eNo/ZkVC9RhSW1vWVGbsE5sq1CEFzjd5JJ3C2Rr/szJifwxveB6xsDoSVBtTrLFCZ/i0D6CaNM3XkPY3d0XHqbBgtZdePEVgzAh99V0ZpmhCS8seVirsZ0iPU5HMWNuhh21ERXyAx5qmIUtf2oa8amYTF3orLzng=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee69599-7334-4a4c-793e-08d80266425e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 17:49:10.1630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RcnZMn5hZLOHKIGDzn1XpweoVXG7o1NfB3P2+V6So1X19vgtQAItTVfb54IDnu1mS1Q6GqTMYNEfFSaplKFdvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1228
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/26/20 4:19 AM, Borislav Petkov wrote:
> On Tue, May 19, 2020 at 10:16:37PM -0700, Sean Christopherson wrote:
>> The whole cache on-demand approach seems like overkill.  The number of CPUID
>> leaves that are invoked after boot with any regularity can probably be counted
>> on one hand.   IIRC glibc invokes CPUID to gather TLB/cache info, XCR0-based
>> features, and one or two other leafs.  A statically sized global array that's
>> arbitrarily index a la x86_capability would be just as simple and more
>> performant.  It would also allow fancier things like emulating CPUID 0xD in
>> the guest if you want to go down that road.
> 
> And before we do any of that "caching" or whatnot, I'd like to see
> numbers justifying its existence. Because if it is only a couple of
> CPUID invocations and the boot delay is immeasurable, then it's not
> worth the effort.

I added some rudimentary stats code to see how many times there was a 
CPUID cache hit on a 64-vCPU guest during a kernel build (make clean 
followed by make with -j 64):

   SEV-ES CPUID cache statistics
     0x00000000/0x00000000: 220,384
     0x00000007/0x00000000: 213,306
     0x80000000/0x00000000: 1,054,642
     0x80000001/0x00000000: 213,306
     0x80000005/0x00000000: 210,334
     0x80000006/0x00000000: 420,668
     0x80000007/0x00000000: 210,334
     0x80000008/0x00000000: 420,684

     2,963,658 cache hits

So it is significant in quantity, but I'm not sure what the overall 
performance difference is. If I can find some more time I'll try to 
compare the kernel builds with and without the caching to see if it is 
noticeable.

Thanks,
Tom

> 
