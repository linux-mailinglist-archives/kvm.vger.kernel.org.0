Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B374D361546
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 00:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237307AbhDOWUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 18:20:04 -0400
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:36591
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237286AbhDOWTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 18:19:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0UrfRH4EPUqzeEjslKAeFG0temnTVOO6fCSoysVAwbCfATDnsCyQ6e4iKLtEgCRWdalfzqd8cRsPFJdSfC+0ekSsDzm00tqGZmqlZHl7ygHrjSyxTGmu/w9EYl29CBeEXDgM19Nwv5JbzdXFIusuvZD5IAR605JoRNETw9c5miQriJ6scmLTV7qyyMPuwXbcTwcBiQPdM64KFSk+u4BZIEOyxv0+NTZN2MTcrX6Ew85Sm088hcPAI0l3mYvcxb4oGdbQbDqhMvRUj/U8u6boI18sjcGKWlNCSJMiZkA9ZScRMi7uMrG9EXI7XN4agDmpUuLxKJ46VV7rw3IzCXy3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmNhzQpLS1mGdvzHx+xW77FGsUrzOlk8adBVtnpjJsI=;
 b=JVxMHJj8Pu40ptYngRIu/hGlbuWAZ8Nzlnrh5xKJmMFv8na/Sazvkm1bKKCKfYPI0Ro2BPQ9heKiDaKUTqxOA+/cBA7PMPztKSLO4gPIdeM25m+F8RIKU8PujOJZf28Z3d9xQ7UdAI7/3I9y+I7vlUsEtaNfqIOLpImLbnrXNx3SrLwTPm6dDHr1XPjDNsAf7uhZIJ0e7opSolKK9SUhq+FISUJ1rbdX7LD2lCoWEvXnMrQnTXBvVEXd0GAuC3j+nEm56F+NYOlFjSjZwWtUSOgmqSQ8H0TmzUcCZUwy2rqEuc1kJY12Wk84yFxuuila5TNc9JoYeghzlvfr8+A6aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmNhzQpLS1mGdvzHx+xW77FGsUrzOlk8adBVtnpjJsI=;
 b=kmPp9K4oqD3GN5Ja/xq2ap/6LzI3siS38zADodUyFabglWeurBTq0NgYgMCOMCajwyDOq/vajZLZ504t3YtEP5/0NIOsA+stNu4YSY5AfwDvkOwxdWWphuzGNe7O2ZPZzxWFfUEQT6edi/vG20e17d5Ku3wtvws5PzEKxh5b14U=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2637.namprd12.prod.outlook.com (2603:10b6:805:6b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Thu, 15 Apr
 2021 22:18:58 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 22:18:58 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak@linux.intel.com, herbert@gondor.apana.org.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 02/30] x86/sev-snp: add RMP entry lookup helpers
To:     Borislav Petkov <bp@alien8.de>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-3-brijesh.singh@amd.com>
 <20210415165711.GD6318@zn.tnic>
 <1813139d-f5f9-3791-dadb-4a684fe1cf46@amd.com>
 <20210415195020.GG6318@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <86cbe68d-e5af-8ab1-04a2-3387d0026854@amd.com>
Date:   Thu, 15 Apr 2021 17:18:55 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210415195020.GG6318@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR2101CA0019.namprd21.prod.outlook.com
 (2603:10b6:805:106::29) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR2101CA0019.namprd21.prod.outlook.com (2603:10b6:805:106::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.1 via Frontend Transport; Thu, 15 Apr 2021 22:18:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3420f77a-499b-4145-3ded-08d9005c768e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2637638458E195FBF09E6C40E54D9@SN6PR12MB2637.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ELxQKmddrIlf3SD1kwBB+PbZaaiKcnrXPq2HsLq/LVD2kNWUWON1VWgruqcidZKAjdOv3vqpXXC7uxMhRFSEVZrcJWL80zYxLPf+N/K47c/Lf+oys9FLNZcK2HTtPIJDvqu7lSJaEAuVbgtyGFXVb97YvAa3SZ4f1ptsACx20ja0tnTrb8pgldFtvTn2KMQq3K3RWnQBbU5eioe6miCQfXakcJLn3Ln6sfOg6gTVqX5PdR+ZGoAIGMy/wl6Ynv4dT2XNOGaP3IZPn1IQLdxnJjMm677VVUzXjQKcOg05A9afsQTYNgVOZOI1CCUZ1kwbb52ckLFpqo2JEA8vcoD/8x5TaZJZr2eTvSyyEswpVKv8x9dT6fU0Wxe3mXPipzUkgnltRTfRRYlWd+w3MCvRM1YaRkZpFeZu3bLWfjtkFixRS/A5ZwF0/bSPUOfmOabZKbXgMpXSvC5aTqrTAsgCw3tyxWpgUM2ibApq9ImtwqUH0xO/xNAKPO7pHe6GGNYIOz5mj3y+nkT/KvTbDV2VdPzJ2R7XfIWxFbuz5vyNkCERB1U1KLCgSdqQA8HCbDGTlhfrBGj7PiXH4t4Cb0eJrkfMAMyfBjzVxJnKAjtO69dFW0CDN2WQjuUHq9fdZxcihnGP4Moftbc31o/fpaemFpB450Ef0eh6tsfgrT4FH8vjE+YpMFHkiRBIIxpc3MW4aa/CR5gM5XO0dALbRAUrJcdi3VgMwKxZCOa2GULBNPtU+L8G/HuUlD9JwdDiY4dCWVXX+awQFazdk86I48PsEj0Ofefm29lh/vkjTH/KoyTo/MngN0xC9aDHTrG20FLr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(966005)(2906002)(316002)(26005)(31686004)(66476007)(66946007)(52116002)(7416002)(2616005)(31696002)(956004)(36756003)(83380400001)(86362001)(45080400002)(4326008)(44832011)(8676002)(53546011)(66556008)(16526019)(54906003)(6486002)(6506007)(478600001)(6512007)(186003)(38100700002)(38350700002)(8936002)(5660300002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aDBkR3g2U3o2WE1yRytlaWtybGQ0bHNQOWVTRlJaRVF6SDlieXVRbEFYeVlp?=
 =?utf-8?B?dkNoeWRYN05VMTNIRklmQ0ZXNlBveDJzdU1iOTRxNUpieTIxUHZuTFBtZ3gr?=
 =?utf-8?B?V2k2RUNod2NTYitJa21tTVdyT1VGdHNFWE1jdWNtZDk3TTFWRWQ0WjVHQlBx?=
 =?utf-8?B?aWZrOHViMzk3NUR0SkFMMjdPS2tyUVEzQVFPa1JkRXIrSC9EUG1PTWphR3Vh?=
 =?utf-8?B?eEhadXJZZjg1aCszTzVPclpDbGUrZStkVHU0Z3ArUHB2NTAzRUMxdFQydFNI?=
 =?utf-8?B?cFVmOGdHSlFIN1hpRDM4YVBNRTlaNEpVTzhkQ283K0lRY0V1ZEpEeWhqeEl5?=
 =?utf-8?B?TDg0eVMxUFFpWSt5K000OHN1eEp1NjdLTXRrRkxrMmtHeG1INThZWjRsclhS?=
 =?utf-8?B?dDZkN3NoZ2Y1dFB6WmJRTDNFQUZpSExoaEZhcGdZTWpaT043UjRwTkdJNk1S?=
 =?utf-8?B?d2pDZFV2U0QrSkphcjFjV2FFWm1aRkNSblA1azNuK044ZVlmeHNZY3hwazlX?=
 =?utf-8?B?eHV6dmMyVXY3dGRDM1lvSVp3V0JyS0QwZUpsSVlKOXZzUEF5VEFoU3ZQODRi?=
 =?utf-8?B?V1N1dnJJTzRPamFXM2s5dHkyVk9pZmhIT2JHSkVzVEd4NHNJUGlseEdiaTl3?=
 =?utf-8?B?aExZR3NLVWpaTUR3dWRJZmdKNGpabUpxRXVSbWEyWml2R1p6Uy9aenlpSGFW?=
 =?utf-8?B?SkV3TDZPVnVZNWVVZUd5RnY5R0orOFhhZWVHRE5uQzZsL095Y1NHeGJZOElC?=
 =?utf-8?B?K2dJb0tvWllIV0VLckpkOTVVL2tkb0JWakpMNGlzM3gyL2FZcnZBaEpBUklj?=
 =?utf-8?B?bytKYXY0UHVJMXk0TVBhMWt4Z2VDdCtqMFByazZKa3c0TXhhSzdiN1RMZkpq?=
 =?utf-8?B?RDZrK1NzVUdiSWpYSnpXR2YwWUJFZmgwRnlmRjVTSjNkYkgzVjdiTjRuVlpw?=
 =?utf-8?B?OHpKY1hoTzFlRUFIQVd1OWJTMDQ2TjNRdUhiLzhjRnVKQ2E5dXcyZ1UyeVdj?=
 =?utf-8?B?dkgrSSsrRm9zMUZXeHNudUh4RWU4dFFkN2QxSjJVTHFiM0pOaXFickNUYVZq?=
 =?utf-8?B?RE00SzY5bjBRQ09NVHcvM2xPS2dEZmxRZC9tQndlTHpDS0hjVXlIRFFqZ1JM?=
 =?utf-8?B?cmF4QjBDbGk4cXRoRjdDbCtQLys5NWtWbm1JajZzeG1IWFBUanFOUExZTG1V?=
 =?utf-8?B?Y1lRaThiMEVjRnJBWVNBSkFtRGF5YVRJNUxwRkRQZ21rMytiVXRXSjJLZkZZ?=
 =?utf-8?B?Nm03cy9mNC96cW9FeU50eENQaVNOcUVOSFVDQW11dFE5akJvZ1ZNOS9HUnFY?=
 =?utf-8?B?V21rSUx2ckpYcGlZbHlPZXdpSTdIMlY0a3NOZGJCcDdQN1VMQTY3WkRGdWdo?=
 =?utf-8?B?L0pXdDN3c2VUbE1zZXZvVjB5aXIycDZBUUgxMXpwZGZKQWpodzBHMHNiY2k0?=
 =?utf-8?B?cXBHOFdOcXE5NEs5MThoVitCV3dGYWcxbWE0ZHZNZzNsWHlPb2dwSDVjS3B2?=
 =?utf-8?B?azd1SWg5YU9vSXlhNXEwUU90aUxYRVRISFhLYjloc1h0dmNGWjlnT09QaGIz?=
 =?utf-8?B?QUhhNGdhLy84bVVFUFBXcktSdlR1T2plNkI2OFJwOHN4QzBvVVlsaFA4cEJX?=
 =?utf-8?B?Z2QxeHhsekF0NmJ5dnR2Nk9BWTIwWjR4SXp4SjJSWjhPY3dCSDhjejU2a0Uv?=
 =?utf-8?B?TENCTzZaRlN4cllNTXVseTBDTS9JYWJQTjhHeVp2a3hxRXZ5c1dBWVBEbjVG?=
 =?utf-8?Q?sHblrF2vnXzTBzR1rpY9RFET7mT0/2v0DTk8C0X?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3420f77a-499b-4145-3ded-08d9005c768e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 22:18:57.8748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnYilQ74RUD4fyYvR2bXcnRlbPwH6ik58yZv9sHcWtezbZ+Fs69fv74Z1h9s8ZTbfuJ4tv0Hp71eRu3dD1XAVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2637
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/15/21 2:50 PM, Borislav Petkov wrote:
> On Thu, Apr 15, 2021 at 01:08:09PM -0500, Brijesh Singh wrote:
>> This is from Family 19h Model 01h Rev B01. The processor which
>> introduces the SNP feature. Yes, I have already upload the PPR on the BZ.
>>
>> The PPR is also available at AMD: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fen%2Fsupport%2Ftech-docs&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7Ca20ef8e85fca49875f4b08d90047b837%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637541130354491050%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=MosOIntXEk6ikXpIFd89XkZPb8H6oO25y2mP2l82blU%3D&amp;reserved=0
> Please add the link in the bugzilla to the comments here - this is the
> reason why stuff is being uploaded in the first place, because those
> vendor sites tend to change and those links become stale with time.

Will do.


>
>> I guess I was trying to shorten the name. I am good with struct rmpentry;
> Yes please - typedefs are used only in very specific cases.
>
>> All those magic numbers are documented in the PPR.
> We use defines - not magic numbers. For example
>
> #define RMPTABLE_ENTRIES_OFFSET 0x4000
>
> The 8 is probably
>
> PAGE_SHIFT - RMPENTRY_SHIFT
>
> because you have GPA bits [50:12] and an RMP entry is 16 bytes, i.e., 1 << 4.
>
> With defines it is actually clear what the computation is doing - with
> naked numbers not really.

Sure, I will add macros to make it more readable.

