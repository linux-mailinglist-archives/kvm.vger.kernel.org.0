Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD84373CDB
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 16:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhEEOC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 10:02:28 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:38176
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233464AbhEEOC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 10:02:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4WhZSSpPVQ5AxQ45kU4f6BZ474Pmusa12j2QCKrLOdRucfY4XVnTxi4Jqcv8Uh6gC06tf6BxT5uItkEsd1AzyOOrevNLbkbs85xwYAD/M/JTTjWUix5f4Fz3g2hxptdI+kmmzXxW0kcscahRohww9JPhqTiIz3Jr7ifRnzld4rUDbcVFhPQ9vLhK51wo/r4WpcmlO06PnwnchaxF2pTLyp0647AjJifgG2HCIswr5Z7Yv4kUXSMx4BaGk021MLlOZ47ilZUP+RR2gYJQVe7WZ1/AYo01WIjO3+FlnrvrZ/grhx2ftCx2OFVsnApKTQhc0Kh5mbY2je7kImK189A0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/clkxc7KBa4+pcOjVaSBnql6Pi8DhHT+Hj5ky2/DKjY=;
 b=iW4KlZOsOhhmTgmKdUGpqwRT489pdQy3zOBXQfTsj/1SLdFFaOM0VoTEzpbXmJVySv++tbYMIPWCIstaC3HglNQFlEiFa7Gd/ZwEeKjr6Po2wOujIgNVqrXX9GlF6UjSqS/8wSoVmZ93W5ym4Oc6FcAknvYYqYyvnIqnY7PB2BrzsUeeSgz0+sSPt+X4bo5vp52L95TO2SJmUzrkifGaSmMHkigxlAvVaJeUr9A/jCWSYPbjedvxTK2oxRhC6dDllf8pY73Khp5X+fwmqVFjggDV0w4q8XcmYtyveIJEH6uNhYSqSed2KMcApP2YkveXEkQw2t5p0sztGuqBwJhfTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/clkxc7KBa4+pcOjVaSBnql6Pi8DhHT+Hj5ky2/DKjY=;
 b=BcwxCGt0l8wSPzq4kj+FYFZuV0ydS693bEJrvWdHhHtA0BwfrlchiawJbSNG11T+exv9Wg0aUZ04I1hKjHWrcodDQp8BySNZBxvx0Bvex3NLLoDtwV08cJcSSInn9U3csdS3bqWC1gTpUeWRgLPdNiDtiCJDXlQLNpZEfYT9wI4=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.35; Wed, 5 May 2021 14:01:28 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4087.044; Wed, 5 May 2021
 14:01:28 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Subject: SRCU dereference check warning with SEV-ES
Message-ID: <601f1278-17dd-7124-f328-b865447ca160@amd.com>
Date:   Wed, 5 May 2021 09:01:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:806:f2::7) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN7PR04CA0002.namprd04.prod.outlook.com (2603:10b6:806:f2::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 14:01:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39e60ffa-9f0d-40c1-699b-08d90fce4740
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1163FAF109E88D74111A0ACFEC599@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lMHsaHS/EdfPATsRnZ33ITvmEfkc2nTU40Asp2C3Pljl+RJ59U8xmZT4FMkx81VflUZ4DOxykcCXHKabsl5oeu4q6NkMjxXzX0C52m8wkdY/NFJLFjjyxlnj4tSUOgXkzm9Ps24ZUZXjO2oZLSIU5NMjoWbHuNaXR6DhSlRU1XgnDdiJv5Zs8PmBQ8Q6Um1zNCq73IaGrXbxRZkCmzE5cMRtI7EXJr0V2hMn/ca68xgZIrooUz9egkfFuPFLaVneUe39677B4/0xx9WJJEq6OZIF757A37kutWmWIUbv5f3Jj12Ev4r7ea4eqZ9qEV2zeC9vrKT9J62ZyU3UKoazw/tMvTP9C1Q3Xk0N8T3qlH7pRt5q2s0zghzse5x0zi3zUlfYl+xviMLkhAjcWfpZvGJeShYIjHm1CkgfDBLqqOfBffCXWIvycwh2Mq0+MmyizOLXUW++gq2JbbfRdBD5vZZZLNvjZ6jI49j3vvlbzPcDJfgY5cKr8n+W5j19RVSj3ZTHhG5ZKR0MNOK3z+Nl6OO95oS4410pmfQWuab2jMXKS8E2tcDJSbMts1di5gF96PdAff5un3oiykGdirBaLF1lHKkeEddK3UCfYa3dIFK/oavHfNICSbg48tEcJ2qLJd/6xp3tTBtCGnz5gDfe4E87IT4iqA6b+8WDkroLHTmWUYdZhE9FtSGQIJnFseC/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(956004)(478600001)(86362001)(26005)(31686004)(110136005)(16576012)(2616005)(2906002)(316002)(4326008)(66556008)(5660300002)(8676002)(6486002)(31696002)(38100700002)(83380400001)(66946007)(66476007)(8936002)(36756003)(186003)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QmhZSm43ZGxuTzJxR1RFWE4yZGhpTUttUlJYVzR3M1VDajIydDN4SW5pK05G?=
 =?utf-8?B?ekxObjl6dk9yMVk0MEF2aWhNQnl5OHpWeTFDRGNLY2V1NWsxak40WEZadHJS?=
 =?utf-8?B?VElNNlJuQU9HVnV0Sk9jWlV4TmF2Sm1uTlB6aC90TU4wZGgxOC9iM3R0dWtT?=
 =?utf-8?B?c0NRb0RnTE5yK0dyNVhHL3k1ODAraHdJbXJnZmZuYWRZVGk2MDR1Um05Qk40?=
 =?utf-8?B?YnpveHRwZmRBS2xISlpHRVJHdWRTYitzV2Rnd1h0YTRBQ25pTHozTmp0NVJ1?=
 =?utf-8?B?NnBTWU92eElPQTBOcWgzTkNMd21yWm11dUg5MjhJY1NxMVM2ZU5OdVhueS9y?=
 =?utf-8?B?M3I5ZmEzSmxlWVI1dWk2RGRja05jZDh2UVBTTDI2dUZDeG0wZHZLTkdkNVJj?=
 =?utf-8?B?K3R0ZEJ1TEJadzJMMmh3cG9QVHFUWk9DNEpkYU8wSkFncDlCWm95bzdMcmF1?=
 =?utf-8?B?ZTJSdUdVUU1lbTZtek9zamFFSHIwc3pkSFJTNGE0eGtuZFlXbFdSZ0c0Y2k0?=
 =?utf-8?B?QWhjejZSMzZJQWpJUkRDWWRibTJ0L1RlWWNuVzBWQnRRakN4bVlFUnBrS3pB?=
 =?utf-8?B?dEFvQk50ZjFrNXNXQUw1RGhLTXBsTnIreUpsVkZ4aEhVSXBPNDhmcEIzQnZ2?=
 =?utf-8?B?eTcxemNHdzlXS3hkM2dWdnNTS1VTNU9uayswOWxXSUNSZlhYNnZ5dm85azR5?=
 =?utf-8?B?SGVEUkw1TXB4QitTQmVUTGNXM1RlQm95ekRKdXAyQ1Zpa05pQ1cxZDNiM3pR?=
 =?utf-8?B?UW5tUFBiWk1xSmhMUVhkWW9KaDdiQnU3UUgxVm5CWjZsZk5IU3Fzd085WFVw?=
 =?utf-8?B?dXlsTmxzVGVQT1dNdzZma0o3M1RzNTFEWGMxQjQ3bGpTcWxHV2kyWGJEZ25Q?=
 =?utf-8?B?Z0tpK2xJNzY4SU12b2xnM01BOTRwSVZJaU13aktWdi9jNzBFczRqWDJSS1hk?=
 =?utf-8?B?OC9mVEJneEJ2SkYzVHZPQnNOd1FlTDBwUS8wbjJ3ZkZKRW9icDN2cndvTWdw?=
 =?utf-8?B?RXl0aDQwVVVjcWJTalJzYm9QVDdMdFgyc2JWR3JlMExBZzhoS3I3L0dpSnov?=
 =?utf-8?B?Zmo3bkpsZUUxSnAzQzJOR2Q4cUdOZWtjdUVFK3F3eHdaamoyV3Q5NmhrQXFD?=
 =?utf-8?B?UXNsNHNoNUI2T0doOUxhbXh4L2JvRGtlUWR3SXdrODlPNmdRcUpVNmMrVUxQ?=
 =?utf-8?B?K3RMaDNTL0NIMUx3WmRBN3lPS0V0dW1MZ29OWUtQZXFyNytnTEVKcG02WEFU?=
 =?utf-8?B?MG00a3lISnJSKzdyRGsxdzhyUWtwVHNqbnZuNy8rSy91TnpqSTBKeVRtVFY4?=
 =?utf-8?B?T0kwSVp3Q2h6L3V5YkJZTkx1ZXV6am43VkYvMmJ6MDZ5NzMvT1VjNDN6R25u?=
 =?utf-8?B?T0gvb2JNZkcrbW9QcndZRStJaFp3TXFRdVBGaStGV2JRbEVZSkw4blZkazJX?=
 =?utf-8?B?cnhJNzljL1NJb09pNTc2MkFZMzlpSnVRWWt4TnBMYTkyei9DRkJRYitmUHh1?=
 =?utf-8?B?RzVLbzM5cmNwU2FmNmhYVEJ3ODN4YThMR3g1OTIzWHBPR203N0o0ajdmY3Vn?=
 =?utf-8?B?dUNBd2RQd3ZadE1BTXFXZEpaUEJlaWdHZUxYUlBHQ1dpQ2tnSTExSEc5SHhs?=
 =?utf-8?B?aWRqQmZnTEFmdHQvRlNYSm9hY3Npcnl6dFdvcGIrZUpnUzh1UlFwM2NKVFBv?=
 =?utf-8?B?UE00bTBZaGttRDdIeDZ0L3ZIN01rZ1dGZGJqYUMvWUp0UVBrQm1Pdmd0TlRZ?=
 =?utf-8?Q?GtH/liTgOKoBDev3htpGCeMevBLWCj0cNZewWah?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39e60ffa-9f0d-40c1-699b-08d90fce4740
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 14:01:28.3788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GDrE7zL3iveI2SEqPyksIn+nHM4TMFU7CWGJTitc9YjfcgQX6RqMQcM3rmaVp+4Fgw4q8wQV89rg+aRYqDMc6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Boris noticed the below warning when running an SEV-ES guest with
CONFIG_PROVE_LOCKING=y.

The SRCU lock is released before invoking the vCPU run op where the SEV-ES
support will unmap the GHCB. Is the proper thing to do here to take the
SRCU lock around the call to kvm_vcpu_unmap() in this case? It does fix
the issue, but I just want to be sure that I shouldn't, instead, be taking
the memslot lock:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 17adc1e79136..76f90cf8c5aa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2723,7 +2723,10 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
 
 	sev_es_sync_to_ghcb(svm);
 
+	svm->vcpu.srcu_idx = srcu_read_lock(&svm->vcpu.kvm->srcu);
 	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
+	srcu_read_unlock(&svm->vcpu.kvm->srcu, svm->vcpu.srcu_idx);
+
 	svm->ghcb = NULL;
 }

Thanks,
Tom 

[   97.455047] =============================
[   97.459150] WARNING: suspicious RCU usage
[   97.463259] 5.11.0 #1 Not tainted
[   97.466674] -----------------------------
[   97.470783] include/linux/kvm_host.h:641 suspicious rcu_dereference_check() usage!
[   97.478479] 
               other info that might help us debug this:

[   97.486606] 
               rcu_scheduler_active = 2, debug_locks = 1
[   97.493246] 1 lock held by qemu-system-x86/3793:
[   97.497967]  #0: ffff88810fe800c8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x6d/0x650 [kvm]
[   97.507059] 
               stack backtrace:
[   97.511515] CPU: 0 PID: 3793 Comm: qemu-system-x86 Not tainted 5.11.0 #1
[   97.518335] Hardware name: GIGABYTE MZ01-CE1-00/MZ01-CE1-00, BIOS F02 08/29/2018
[   97.525849] Call Trace:
[   97.528385]  dump_stack+0x77/0x97
[   97.531832]  kvm_vcpu_gfn_to_memslot+0x168/0x170 [kvm]
[   97.537172]  kvm_vcpu_unmap+0x28/0x60 [kvm]
[   97.541548]  pre_sev_run+0x122/0x250 [kvm_amd]
[   97.546132]  svm_vcpu_run+0x505/0x760 [kvm_amd]
[   97.550806]  kvm_arch_vcpu_ioctl_run+0xe03/0x1c20 [kvm]
[   97.556251]  ? kvm_arch_vcpu_ioctl_run+0xb9/0x1c20 [kvm]
[   97.561780]  ? __lock_acquire+0x38e/0x1c30
[   97.566031]  kvm_vcpu_ioctl+0x222/0x650 [kvm]
[   97.570585]  ? __fget_files+0xe3/0x190
[   97.574459]  ? __fget_files+0x5/0x190
[   97.578254]  __x64_sys_ioctl+0x98/0xd0
[   97.582130]  ? lockdep_hardirqs_on+0x88/0x120
[   97.586625]  do_syscall_64+0x34/0x50
[   97.590331]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   97.595521] RIP: 0033:0x7f728ffeb457
[   97.599222] Code: 00 00 90 48 8b 05 39 7a 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 09 7a 0c 00 f7 d8 64 89 01 48
[   97.618277] RSP: 002b:00007f7287ffe7e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   97.626029] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f728ffeb457
[   97.633315] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000015
[   97.640595] RBP: 000055d927433480 R08: 000055d924adb278 R09: 00000000ffffffff
[   97.647877] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[   97.655156] R13: 00007f7290939004 R14: 0000000000000cf8 R15: 0000000000000000
