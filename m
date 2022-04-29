Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16870514A41
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 15:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359695AbiD2NLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 09:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbiD2NLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 09:11:54 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767D5CABB4;
        Fri, 29 Apr 2022 06:08:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQE+evny/wF3Ek5znjhEc81kH4JDQL2PzQfvo2kAls55LarJvUsiaLSwB23gSzVQN7SzIOPqwzaQ3qrEOoRVswWUt05dBcQbxUtLlYuqaqEBPplZKN3qvuBFW6Ma3Qx53P3FAKiE7ZIrxx8mLWFYfaVeMgr0Tb8qYPrSBVK/kwOT8ei2DoA4U2TGTSmgziHunA2VWo7/jXxm5MDIrwlbjUUpxsHyxtzzi3pbTohA293uVFMXTH7CivhAIdfIdtBEF8gXs3bnJNXxdVa68p35WX68N9IYrwzue67WqUD8SQJRdzWgo3DDCH0s1Zh+R65VBI5nvtjhMHempMHG90e/rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QkW2q9FWkgFl4bBR16zdLA9b2Zq/BfTHXfBqHLJK2w=;
 b=e6kAa2Fmrp2YLsmQF29j3GOCg4PBe+WHfD+Z/ch9FbuLbuJq08ILJ5gtImfUqeXYdya7KzhVRtZHUB4qZJczPkz2AomII8ak3nC14H228Tb42oDNiVoPdtCKbyuu2peAFz+UDLDcgFg/hHi5ElPWJlZQvuBJIADdD9MA4whzV8Zw35ZK6OzHkchEPmVo7vD59E9OXBLqgxc8I+Vu1FD3zKFrljJLd8DK29dU8DSClZtUYvuwgdiE8WCSEm2cGobmDmLlg5BMrY3dCE0Q2uRCqUMaTPNiHMBLFl1pamlBUvIGLnna7E1+KpGiXzP+VJuf1aim3LaFVz8hlX1uyX9SBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QkW2q9FWkgFl4bBR16zdLA9b2Zq/BfTHXfBqHLJK2w=;
 b=oNVGZu7ew//79hsOIjiflbB2t+08n/rnJK+dmmBjLGYMqRPa3ASNEh5KHUrFR2zQZJC9B9bJkPY8Y7l2VR9UhUH69f5AIOcbm6t9ED5KU7HKAPURPsKqav21aD4s5gA7dW1S0xwKJTuUDQFTi+GzJVMGhBGvQVkPJxyljKtOXLs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BN9PR12MB5210.namprd12.prod.outlook.com (2603:10b6:408:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 29 Apr
 2022 13:08:31 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a%4]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 13:08:31 +0000
Message-ID: <46b27b72-aabf-f37d-7304-29debeefd8ae@amd.com>
Date:   Fri, 29 Apr 2022 08:08:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Tao Liu <ltao@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        virtualization@lists.linux-foundation.org,
        Arvind Sankar <nivedita@alum.mit.edu>, hpa@zytor.com,
        Jiri Slaby <jslaby@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Martin Radev <martin.b.radev@gmail.com>,
        Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Cfir Cohen <cfir@google.com>, linux-coco@lists.linux.dev,
        Andy Lutomirski <luto@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>,
        Erdem Aktas <erdemaktas@google.com>
References: <20220127101044.13803-1-joro@8bytes.org>
 <YmuqifsJltdh7rpv@localhost.localdomain>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 00/10] x86/sev: KEXEC/KDUMP support for SEV-ES guests
In-Reply-To: <YmuqifsJltdh7rpv@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0046.namprd11.prod.outlook.com
 (2603:10b6:806:d0::21) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84d2912a-3ca0-4169-c160-08da29e15bfb
X-MS-TrafficTypeDiagnostic: BN9PR12MB5210:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5210218EBF06A66A7710C2E6ECFC9@BN9PR12MB5210.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euWGa+OpcLFnLunIFlSHZ83Nst/Y+Ftt+FY66S91Y2UtLV3qaJVIcHvY6x1HtBNmUvdXqkM9l8soH1NSbb7rVoLpunRGqYn457W8/OKZKUA76ntTGs20kBw3/dYeis52maKjkNPZYQzJ0Ef0hHqh5C92UH6C04WwMs0avC4uGJ26aRd+ENYVOjvui2uXVJBydet2k99oaTKjhzjIsMjtnPWddhdMB7a/xqbBaUFV+uK6na+GCV5rKRXxHb6/VgUCU2jN+DK8pDKI2Fdpx2G7UYAyWrLLfMIzFmR23UM4VOEr5MB3gOHz4AmIR29KrjD+Cg9VCvFNsGFtICn03B1NZRCXUQk+kfJY5mrQUtU+ltORsrfLx5PRgrPdHxe0rBq32eZZ5TwBu4k1toCQ14caWT61EkSk/eneUxgUKyq2xGy/ksl0VoIyUprQRrjQnpXs+ISI9pbE4OcjQigeYABKIvX0FTekNUdeK6bNlTPSnoveKDzEe4Ed70CLUzr1NrJtmSuMPj/8cfpW7yDdlliFrangJgA7Qe4587xlHMYLTyYVtXyFuc4f2ba2aQSwLLhdX++ablDlfEfPBP1hPGTr42tMRO6zRcqezdBYLAurKQakl8HDGtNZyt2yB1KgV49LLeCTt57UtX16R4ZY/Ptem0kXJnOWYszLVq7TanaO9E/saDTXrBpLiqI8pFJjZShsIrrmcJOF3teHPd+jz0T4nHq+iadIvScxB1agle0SSSkCQOfYcWCBuZBwyS0sKVHlPp9dOL+4BYCsp1mkvHYgwae1mIduXnybYQKTyQg4OHqXRNW7nj5WDHDy3gaSD1CW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(508600001)(36756003)(8936002)(31686004)(316002)(7416002)(966005)(4326008)(6486002)(8676002)(66946007)(66556008)(66476007)(5660300002)(110136005)(6512007)(6506007)(54906003)(2616005)(53546011)(26005)(186003)(38100700002)(86362001)(31696002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1oraytseG5kRUpwU09GUVBZMGFFM1JPKzJDN1NyaURONlpISjRGTzFDblhV?=
 =?utf-8?B?b3ZNM3hhUmhwN3R2Y2oydE9EbDI3TUNHOGJQbklPcHcyVkovNjFpUUtobHFP?=
 =?utf-8?B?VFRBc1BJS3J5Uk85TXpqNnNma2NadWN3bXZqMkN0Y3VEd3dpU1JDYS9iVDk3?=
 =?utf-8?B?OGllU2x3N0tkTjJnTWZwam5tS2RKbitHcngvTzdSVHJ4cVhlOTgxeGZ1QmI2?=
 =?utf-8?B?M2VwOW1hZ2xSbmRwU21tRzJHWXVLeVc2eG1MV3FxUDNoZFN2UHRudjl6Nzcw?=
 =?utf-8?B?SHMyMGdwUHBRQ25MN3RCdHVwOXB5bHdwR0diV3FRL2ZibXR0S2pMckpFZmUz?=
 =?utf-8?B?Sm5jRm5PS2hoZG5ycGxFbE1UU2xPKzVtK2ZmSDN6ajFDVkpkdk1FeFVxZlRY?=
 =?utf-8?B?U0xDYnJTS1pLRnBGTVJrMjFaai8wNmpHVzdtSXNMR0xaL1lWeTgwdWFFNWk4?=
 =?utf-8?B?RmRYV1gxNUl6Q0ZIU1A3U3JBZ0VkaFdCa2pxYUZoQWcxV3VYUk1zdG9nZnRR?=
 =?utf-8?B?b0tPQ1ZZRDRoU24rdzJJN3RDN3VsdkRvOFl6RDREZmw4Ny80NGM5Zm9kbkhY?=
 =?utf-8?B?SUhLcTBYeUZ5MUNIN2x2TXBBdmVGUXNKd25QQy9RUTFjeHN0NFVPZzVSYkV6?=
 =?utf-8?B?VnNZSXRrSUhUN0NUS0NESWtpeFgzdDZBdnh3SkZyOVpCbnNNZVg4MWJqTzU3?=
 =?utf-8?B?QkNBOFl5NzVHZldkMDgvL2wwZ25kSktKby9kQUl3V0pvTTMwMGxTTlFRSUpM?=
 =?utf-8?B?N1lpUnlyQWt3S0pRM0gyejE5VlR2TGJxVnAwTG4wcWNGMEM3dkhydkVycHEv?=
 =?utf-8?B?S3lBS09md3V3c05rcVJ0WDFPZHlOd0xqSXhHNnFwZlUrNjhKSU55TlRlUlZi?=
 =?utf-8?B?NnhIcnNaV1RGM2FwTmVHKzN4eWg0ZXM4M1JKbXhjZzhQTURLS2RCalFQK0ps?=
 =?utf-8?B?WnRYSGVrazN0MUFYUHZSby84RS9ySEtWWVUvVERwSXJ5anQrRU5IcGdXeVVy?=
 =?utf-8?B?VVRNdGo5RkxldHpWNE5qUGF0eHJUUEVXYUJYTUNydHpIa2FTZkxQQjJjb3Jl?=
 =?utf-8?B?SEF1K2ZQVm9jSmhEODNCZHEzQ1VpbG9sRGw4akdGdXlqNTdad3Jka2cyVXRL?=
 =?utf-8?B?NklsRW1hWlhTeE5yaEM5MXBlYXNZOUFObXVPbkI0aUpRbWhhN1JjS0ppTHk2?=
 =?utf-8?B?djRvUkJOMDdXWFo1MDc5dklwMlVnQXgvMTM2UFR4ZXMwa1JScUhoeVU5cVN3?=
 =?utf-8?B?clFwYUsrOTlub2hnUVNYanJZbE0zb1ZtckpMTDBtUGpldTJwQTdpeWt2Ym9v?=
 =?utf-8?B?U1FqN0V2UjRJQ0JLVXlTY1lJLzRzbUJRaUFOUGh2UzdRQ2ltWkVEbnZnMTRp?=
 =?utf-8?B?TDZaMXhTWnB1YWhKSkJWOXdVMi9mNUZaLzJjeEFWWi84cStzSTlwR0lZbVEv?=
 =?utf-8?B?cUVSZHZwTmh6L3lUek5ZUTJ6RzVxN1plZUoxWHFNWEFmTnQxYmp0NkZVKzl5?=
 =?utf-8?B?WmlyVC90NEF2U2szdnNUa3J1L290elQ5UXF3MlVGdUhGaW1YTDZPSzJmb0Zz?=
 =?utf-8?B?djJXT2FiMlhIWjJiWkxDZ1ZiM3hTMXhGZUpOblJzaXhaN29uWGJRVllVRUVI?=
 =?utf-8?B?NSsvSzJucFdzWTNjWkErL0h6K1IxT0RkUDRtdElHVk1JcHhadG5nRGd0a0E4?=
 =?utf-8?B?VndZMWd3TWpwZjhXcjZoV3BTL09nZ0VBdSt4KzdWQy8xdXVFaHl1Mm05S3Fl?=
 =?utf-8?B?bmNHT3hkT1hsSjV3ckZXNXh6SEpTVERIWjRwd2VGQklCb1VpU0JoaGtIU2F2?=
 =?utf-8?B?NHdrUExOU0pHWWlCTXZlVVl5ZTA4VkN0RUt3citrRTBJb3dPVTNLcTc0MjM0?=
 =?utf-8?B?TVp1L2ZEalZUSWJmUXVBZ0Q5M3dtL0dibC9tYkZQVjRJSitKZHA1ellzYWNr?=
 =?utf-8?B?aGVIVzI3Y3plKzluUHFORktMeWlHZnUyWXAwVVMzZnp4RDgvYVdyRElwTUZv?=
 =?utf-8?B?TWhzVi95emZDbnBuQlg2L011anJUUGRuNXBlK0UveWlsU0hEYUxXR3hHcnBR?=
 =?utf-8?B?cElpNWF6c3J4WXA3aU1hVnVTVnR4Uit0RmJ2cjZtMzZTLzMrWkpmeVdTU0Js?=
 =?utf-8?B?L0FrZnBpL1RrQ0wzRnlPby9MMGV6Q3pFZ2VzZS9zWk5wbmlybjcwdFV0TW9o?=
 =?utf-8?B?dzcvZ1BZUVRiZkdHcnBjUks1RXh2b1N3RE9EeHVZMjY2TzRXcHlTbE1LMHdF?=
 =?utf-8?B?cGluUFJzTk9ZTGNNaDV2cEI2aWtJdXM2eUJhZVlNWnJCanBsem8vTm5yaGwr?=
 =?utf-8?B?MUpxcGJJdG15azJFMVpvbXZNNWdHTkpWWEVOMmFJRFJtZDBGNHdwUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d2912a-3ca0-4169-c160-08da29e15bfb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 13:08:31.5826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpdhqnKuiVqxGbU87+sjSKcIpUrXY7J65eJhY5QwPXmMwoCuj7iBQYqfUd9HMc0KXekZvxR1hdduY69ggorp/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5210
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 04:06, Tao Liu wrote:
> On Thu, Jan 27, 2022 at 11:10:34AM +0100, Joerg Roedel wrote:

> 
> Hi Joerg,
> 
> I tried the patch set with 5.17.0-rc1 kernel, and I have a few questions:
> 
> 1) Is it a bug or should qemu-kvm 6.2.0 be patched with specific patch? Because
>     I found it will exit with 0 when I tried to reboot the VM with sev-es enabled.
>     However with only sev enabled, the VM can do reboot with no problem:

Qemu was specifically patched to exit on reboot with SEV-ES guests. Qemu 
performs a reboot by resetting the vCPU state, which can't be done with an 
SEV-ES guest because the vCPU state is encrypted.

> 
> [root@dell-per7525-03 ~]# virsh start TW-SEV-ES --console
> ....
> Fedora Linux 35 (Server Edition)
> Kernel 5.17.0-rc1 on an x86_64 (ttyS0)
> ....
> [root@fedora ~]# reboot
> .....
> [   48.077682] reboot: Restarting system
> [   48.078109] reboot: machine restart
>                         ^^^^^^^^^^^^^^^ guest vm reached restart
> [root@dell-per7525-03 ~]# echo $?
> 0
> ^^^ qemu-kvm exit with 0, no reboot back to normal VM kernel
> [root@dell-per7525-03 ~]#
> 
> 2) With sev-es enabled and the 2 patch sets applied: A) [PATCH v3 00/10] x86/sev:
> KEXEC/KDUMP support for SEV-ES guests, and B) [PATCH v6 0/7] KVM: SVM: Add initial
> GHCB protocol version 2 support. I can enable kdump and have vmcore generated:
> 
> [root@fedora ~]# dmesg|grep -i sev
> [    0.030600] SEV: Hypervisor GHCB protocol version support: min=1 max=2
> [    0.030602] SEV: Using GHCB protocol version 2
> [    0.296144] AMD Memory Encryption Features active: SEV SEV-ES
> [    0.450991] SEV: AP jump table Blob successfully set up
> [root@fedora ~]# kdumpctl status
> kdump: Kdump is operational
> 
> However without the 2 patch sets, I can also enable kdump and have vmcore generated:
> 
> [root@fedora ~]# dmesg|grep -i sev
> [    0.295754] AMD Memory Encryption Features active: SEV SEV-ES
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ patch set A & B
> 	       not applied, so only have this string.
> [root@fedora ~]# echo c > /proc/sysrq-trigger
> ...
> [    2.759403] kdump[549]: saving vmcore-dmesg.txt to /sysroot/var/crash/127.0.0.1-2022-04-18-05:58:50/
> [    2.804355] kdump[555]: saving vmcore-dmesg.txt complete
> [    2.806915] kdump[557]: saving vmcore
>                             ^^^^^^^^^^^^^ vmcore can still be generated
> ...
> [    7.068981] reboot: Restarting system
> [    7.069340] reboot: machine restart
> 
> [root@dell-per7525-03 ~]# echo $?
> 0
> ^^^ same exit issue as question 1.
> 
> I doesn't have a complete technical background of the patch set, but isn't
> it the issue which this patch set is trying to solve? Or I missed something?

The main goal of this patch set is to really to solve the ability to 
perform a kexec. I would expect kdump to work since kdump shuts down all 
but the executing vCPU and performs its operations before "rebooting" 
(which will exit Qemu as I mentioned above). But kexec requires the need 
to restart the APs from within the guest after they have been stopped. 
That requires specific support and actions on the part of the guest kernel 
in how the APs are stopped and restarted.

Thanks,
Tom

> 
> Thanks,
> Tao Liu
>   
>> _______________________________________________
>> Virtualization mailing list
>> Virtualization@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> 
