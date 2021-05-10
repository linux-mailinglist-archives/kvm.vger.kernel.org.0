Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0131C3796CE
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 20:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhEJSIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 14:08:17 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:4627
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230357AbhEJSIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 14:08:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLmEN/OxrAsHpOiJRgiaGKbom/HrmCCXr98HCrAW79KFJZ715+7ZqvwFhont4Qu3HKGFAuEPIp7ss5lCvFN0QgVx01D+YAqnbzQzhDbfPW9LiARh2izEesj0Juvk62tk+fBeWu/todOb9BxiEye8BWHpWWEp9R6YIA8lS2zfO4hPDhGxdQRDPFogiJH4SRxBjvGGmmmO9HNF/IUKbfe5Gkf8HFrzHSVU2C0v8dYzaRQYaMNgX+Je0uCXTK179BhHUL8YuZRYZQdZDVGWRybpGN4slK7LNhFN51UZlL7WGtPnYceSb3K7AbngqEof54xe5TCdiE642LOKbN/ALkgwzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhQSZVSf+ttIYjfRN4+8vAF87v6LN5SrVZ+zDehDixM=;
 b=MHpQB/BiAvmOAJYXfG20mAXweto0SfDKrLrYZwnzabcUWfaRIXSE0ZxgvZWALcGYyInDxKwaHkB9GquysygOnIvvBqj8TXc0itLPT0wr+73wrC84j7XFzVR9y+auYeRLgRIOLJdSCgiOoIWNJowUXWLVAtk9RCPE3K2z8SLJrkmW7mXnp9yw91ozjxuj6uG0PBmXi4iJt64TS92h0RUSryQnl8F9f/3FqoLcnoRGbwvNNqCPJ5EKSpTRIxKHHMj62SKNtYu1CygPh1AthFsKkLsYV/ujXGD3+FguDEXalATjusfAlqwsvZLIYAdpDEkIGWYk2bWogK8Z6orW1jNmdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhQSZVSf+ttIYjfRN4+8vAF87v6LN5SrVZ+zDehDixM=;
 b=Xdpw5HhIjnUh3VNqr7acKRcpkh9S+joAv2CybvV4EqzE/F6a7J6d4vyOfFZYvyZ6INvw9R+fYXWl2vc3Pd7lX+8SpB6UMPNQhBMrOqzKY2dlNWlvsr32X40kTOE2E+ma+vV8n1hfqld028sGhNW/T7apEsQ2xInd2jJApM2hiP8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0122.namprd12.prod.outlook.com (2603:10b6:4:57::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.24; Mon, 10 May 2021 18:07:09 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4108.031; Mon, 10 May
 2021 18:07:09 +0000
Subject: Re: [PATCH 2/2] KVM: x86: Allow userspace to update tracked sregs for
 protected guests
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210507165947.2502412-1-seanjc@google.com>
 <20210507165947.2502412-3-seanjc@google.com>
 <5f084672-5c0d-a6f3-6dcf-38dd76e0bde0@amd.com> <YJla8vpwqCxqgS8C@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <12fe8f83-49b4-1a22-7903-84e45f16c372@amd.com>
Date:   Mon, 10 May 2021 13:07:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YJla8vpwqCxqgS8C@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0401CA0029.namprd04.prod.outlook.com
 (2603:10b6:803:2a::15) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0401CA0029.namprd04.prod.outlook.com (2603:10b6:803:2a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Mon, 10 May 2021 18:07:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08adef92-1d71-4b36-ed56-08d913de6dcd
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0122:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB012217D3FC50D686D681D931EC549@DM5PR1201MB0122.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aQl8qomAUloAg6aW7Nu0qd4E8oqcHqsejj2PzDDN6MVTB3Zkyn5Q0wpCn+O21zVJzUeTbHJJJ+QEEa6l8RnwwedNbWGRKaY7h4oo20ZcADVbTDXn9yLiIspouLwPKzsM7nvFNuwDKgnXVZ462qcLoMOxozaem3UW3CbwxIAup5bcsg0jtk559ahl0KjHzb0PJItxD0+pXt6TdFQCqmYrNEQ1cnr5npTHGSm4jQ3ikUg+aRbNpSO6rNmnapMNmTBtGN+/rcZ25ox55XQYv/wVq30Q8eR9WbkTS2jv8QOjYHObGREAcNiK66mDZT6VEUbUNtxJP/f+dSpMOf+qXShYqYk0A/fQUZuD0hAvZjW42zGmiu1FX39tiE5Np5hsuWEXAqbEI7WzRlOJNI1nVcofHi0wekvzfDAoWnVztR7pmpbd3jsFZ5R17QtxjVGqYExSwYJoqpi0lVgvA4YU90T74ZtVVJpMeRD43YyV2PAXWhzq8A1F4UDj2rMdm+WvGlkjrncSKyNIDRR0oar7AyIT1bB81VQL7QxETFsine9Q14Qeuz1Vj7zofDItJRIHw+YCVaEFPHkh8cp/jX2gDv4nUJ5/1qqVrhcOk9h7nMlT6ZNGF1stjdd6HvG0znxuT9m4KhxWZh7gqOsrL7xJ5m0cM/0LWUJbrSNOfSIq+8vv2hPu28EFuxH3lzR3/xYNv/EH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(53546011)(6916009)(316002)(6506007)(956004)(31686004)(83380400001)(2906002)(4326008)(16526019)(5660300002)(2616005)(54906003)(31696002)(8676002)(26005)(36756003)(6486002)(186003)(38100700002)(66946007)(6512007)(478600001)(66476007)(66556008)(15650500001)(8936002)(7416002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UGMvOWUyOFViUnJOSVFrM2JuajZ2KzZKSmUydkpzZE9aTGJNZVhsNCtlN1h4?=
 =?utf-8?B?dE1Bd1haY2o2WE5SUmh1L01mN1R5TTZ2dUZEUWszY1Ayek1kaHNWYW93ekVP?=
 =?utf-8?B?cnRHYUxLVkRvVGsvNk5qVzBkdVhTaVhVZzg5TTM4ZlJMdG8ySUp6RnVpZjJ5?=
 =?utf-8?B?VWZaYmtLNE51ekF4WHI5b1dyd25BNzZGVk9NclhMU0pkUVE5dUp5UkhaUGtj?=
 =?utf-8?B?ak9LUFRUQmJScGIwU2Q0Vit0R3hvZ2J6alQ3eVo1bmhxZCs1bnNLZkJ4ektE?=
 =?utf-8?B?NHZBamVRTDh0WVE5NUpRREM5QmR2cmtUSjdHU091Q3hlZEFxbGk0MS9mMHp2?=
 =?utf-8?B?ZERSS1Y0ajJzcmZLOUdGMFVNbEZ6YzlvLzZTTXVQSUNFZ1h0MndxSjUwQzYv?=
 =?utf-8?B?WDk2UEZxejhBTjhDYm1PYzh4Zkl2dE1EM3ZSbzN2Zm1MdUJpOHdsNVVvaVpQ?=
 =?utf-8?B?MHBMRFd0N0xaVjZveGNXMHhiSkRMSlk2cGFzd2lQcThERitDTXZwWHlhcTUr?=
 =?utf-8?B?bVk3TndhNTBtcklOcTJzclFUSXRBckcwb1k1d0hkVWxHY3A3cmdTQXAwMkdi?=
 =?utf-8?B?RkNhUUp0QUlBYXc0WjRyUXI4U1FqWFNxa04vQmVyOEJOUDlVMjBrYlpjcmUz?=
 =?utf-8?B?YWwzRzRRbWZzMUJWUGswcnZobit0aTBZWHlCMEV5eE5iekg2ZThDc1BrdXZT?=
 =?utf-8?B?MFN6RnY0ay9DUDlnR3UwaW10QmlrL0NLYjI2dktCVExHcDBnRlFScGlMUlk3?=
 =?utf-8?B?dHd6WjRDYW5JTlB6Yks1bFVNU2tLY1dEZmJLbE1HdkZoT0U1STh0ZXc0RkIy?=
 =?utf-8?B?RkZGWEtYVkIwTGI4SHRmbS9UK1FaVjV5dEdQMmZDN2F2bk10c0xhYTJwbGV4?=
 =?utf-8?B?UHVrTERYM1BrSmw2ekJzTVEzVk9WTGdZNENQUjdyNFdVSzg1NkZjZ2dNS25P?=
 =?utf-8?B?WnlDQUJoaEp0V2xHQ1c1VUhKSjFUOTRrN1NsYXpRUDJydEdTWXZEOGY4WVVi?=
 =?utf-8?B?UVhkK2RrUVl0MGNiSkcwWUFEbTUwRHlxaTJxVVRGNWtWRkdIUjJJbUZQRkdW?=
 =?utf-8?B?T0pydCs1TjdSK1RDeGZoam5yNElNSUVtdWZuZXNDdzIxb09xU3ZwYXZuRXNV?=
 =?utf-8?B?Z25sWmxQTFF1V3UwNkRSY0wzM2poUitUeXh3dk44ckxoalZPcExrbVE1bW1j?=
 =?utf-8?B?WkhaSTlvTk5UbGJFYVd0QXV0V0NOSHhtaTdrUmZLZ1RMZ0hpSFVrNExNMzAv?=
 =?utf-8?B?bFp1NzVVK2FzcXlqTGM4bVUrS2NPcnVONjZ6bmg2T253NlpvUU9WcUlPVVpz?=
 =?utf-8?B?V3puT2FoaW51SEh3VFFGKy92WUlKUFk5N0w2T3ZhWEx4VzdmN0E4NFpGTTVW?=
 =?utf-8?B?eVFLeDBiOTJCOFlyT0tjZGJnZS9wbjBsVHp2OTF0WmRWMUowdUE0V0RmZkpJ?=
 =?utf-8?B?eTVLNzdFS0FvV1g1UWtoQXZ2MFJIdHFuaWZ5b3hxYjVBVGtUS0JidkkwY2JM?=
 =?utf-8?B?ZjFaZjhxL1ZuUlpNeHdtTWswQ0M5bXd5U0w0RWE2cFBLenFyckZMSWhDcUMx?=
 =?utf-8?B?aE02Y0Mzd0FFb2RtclBPVjNCYmpOdmNrRm1ZK0xZbnJDak5ORzVkU0x4a29N?=
 =?utf-8?B?c0JYODhMcWEyVHd0cVJLOStjaHZva2MrVk9SdWpnSFY3am5yVGpxb3VQYTN0?=
 =?utf-8?B?azFTTUhGZDF5MkdYeTdhSUM4MVdVVGQzMFdjSUVOSld5OUFSbkNxelpDN05N?=
 =?utf-8?Q?Q1UNTWvp4YNRKuvRx6MBVHIWs/CJ/OJUyxQUVAj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08adef92-1d71-4b36-ed56-08d913de6dcd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 18:07:09.6565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c3GQjuDSGIiJKrVP4EiXJUqoaOLokDpoaCXISE1ABRC8hnzHjdLuVPLVY9yYIMdZL6Qw4hskeWa7wWVaGwJ+ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/21 11:10 AM, Sean Christopherson wrote:
> On Fri, May 07, 2021, Tom Lendacky wrote:
>> On 5/7/21 11:59 AM, Sean Christopherson wrote:
>>> Allow userspace to set CR0, CR4, CR8, and EFER via KVM_SET_SREGS for
>>> protected guests, e.g. for SEV-ES guests with an encrypted VMSA.  KVM
>>> tracks the aforementioned registers by trapping guest writes, and also
>>> exposes the values to userspace via KVM_GET_SREGS.  Skipping the regs
>>> in KVM_SET_SREGS prevents userspace from updating KVM's CPU model to
>>> match the known hardware state.
>>
>> This is very similar to the original patch I had proposed that you were
>> against :)
> 
> I hope/think my position was that it should be unnecessary for KVM to need to
> know the guest's CR0/4/0 and EFER values, i.e. even the trapping is unnecessary.
> I was going to say I had a change of heart, as EFER.LMA in particular could
> still be required to identify 64-bit mode, but that's wrong; EFER.LMA only gets
> us long mode, the full is_64_bit_mode() needs access to cs.L, which AFAICT isn't
> provided by #VMGEXIT or trapping.

Right, that one is missing. If you take a VMGEXIT that uses the GHCB, then
I think you can assume we're in 64-bit mode.

> 
> Unless I'm missing something, that means that VMGEXIT(VMMCALL) is broken since
> KVM will incorrectly crush (or preserve) bits 63:32 of GPRs.  I'm guessing no
> one has reported a bug because either (a) no one has tested a hypercall that
> requires bits 63:32 in a GPR or (b) the guest just happens to be in 64-bit mode
> when KVM_SEV_LAUNCH_UPDATE_VMSA is invoked and so the segment registers are
> frozen to make it appear as if the guest is perpetually in 64-bit mode.

I don't think it's (b) since the LAUNCH_UPDATE_VMSA is done against reset-
state vCPUs.

> 
> I see that sev_es_validate_vmgexit() checks ghcb_cpl_is_valid(), but isn't that
> either pointless or indicative of a much, much bigger problem?  If VMGEXIT is

It is needed for the VMMCALL exit.

> restricted to CPL0, then the check is pointless.  If VMGEXIT isn't restricted to
> CPL0, then KVM has a big gaping hole that allows a malicious/broken guest
> userspace to crash the VM simply by executing VMGEXIT.  Since valid_bitmap is
> cleared during VMGEXIT handling, I don't think guest userspace can attack/corrupt
> the guest kernel by doing a replay attack, but it does all but guarantee a
> VMGEXIT at CPL>0 will be fatal since the required valid bits won't be set.

Right, so I think some cleanup is needed there, both for the guest and the
hypervisor:

- For the guest, we could just clear the valid bitmask before leaving the
  #VC handler/releasing the GHCB. Userspace can't update the GHCB, so any
  VMGEXIT from userspace would just look like a no-op with the below
  change to KVM.

- For KVM, instead of returning -EINVAL from sev_es_validate_vmgexit(), we
  return the #GP action through the GHCB and continue running the guest.

> 
> Sadly, the APM doesn't describe the VMGEXIT behavior, nor does any of the SEV-ES
> documentation I have.  I assume VMGEXIT is recognized at CPL>0 since it morphs
> to VMMCALL when SEV-ES isn't active.

Correct.

> 
> I.e. either the ghcb_cpl_is_valid() check should be nuked, or more likely KVM

The ghcb_cpl_is_valid() is still needed to see whether the VMMCALL was
from userspace or not (a VMMCALL will generate a #VC). So maybe something
like this instead (this is against the sev-es.c to sev.c rename):

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 432d937f8f1e..bf821a4eacf9 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -270,6 +270,7 @@ static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
 		data->backup_ghcb_active = false;
 		state->ghcb = NULL;
 	} else {
+		vc_ghcb_invalidate(ghcb);
 		data->ghcb_active = false;
 	}
 }
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 17adc1e79136..3b40fd9dc895 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2564,7 +2564,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
-static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
+static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu;
 	struct ghcb *ghcb;
@@ -2670,7 +2670,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		goto vmgexit_err;
 	}
 
-	return 0;
+	return true;
 
 vmgexit_err:
 	vcpu = &svm->vcpu;
@@ -2684,13 +2684,16 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = exit_code;
-	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	/* Clear the valid entries fields */
+	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 
-	return -EINVAL;
+	ghcb_set_sw_exit_info_1(ghcb, 1);
+	ghcb_set_sw_exit_info_2(ghcb,
+				X86_TRAP_GP |
+				SVM_EVTINJ_TYPE_EXEPT |
+				SVM_EVTINJ_VALID);
+
+	return false;
 }
 
 static void pre_sev_es_run(struct vcpu_svm *svm)
@@ -3360,9 +3363,8 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
-	ret = sev_es_validate_vmgexit(svm);
-	if (ret)
-		return ret;
+	if (!sev_es_validate_vmgexit(svm))
+		return 1;
 
 	sev_es_sync_from_ghcb(svm);
 	ghcb_set_sw_exit_info_1(ghcb, 0);

Thoughts?

Thanks,
Tom

> should do something like this (and then the guest needs to be updated to set the
> CPL on every VMGEXIT):
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a9d8d6aafdb8..bb7251e4a3e2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2058,7 +2058,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>         vcpu->arch.regs[VCPU_REGS_RDX] = ghcb_get_rdx_if_valid(ghcb);
>         vcpu->arch.regs[VCPU_REGS_RSI] = ghcb_get_rsi_if_valid(ghcb);
> 
> -       svm->vmcb->save.cpl = ghcb_get_cpl_if_valid(ghcb);
> +       svm->vmcb->save.cpl = 0;
> 
>         if (ghcb_xcr0_is_valid(ghcb)) {
>                 vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> @@ -2088,6 +2088,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>         if (ghcb->ghcb_usage)
>                 goto vmgexit_err;
> 
> +       /* Ignore VMGEXIT at CPL>0 */
> +       if (!ghcb_cpl_is_valid(ghcb) || ghcb_get_cpl_if_valid(ghcb))
> +               return 1;
> +
>         /*
>          * Retrieve the exit code now even though is may not be marked valid
>          * as it could help with debugging.
> @@ -2142,8 +2146,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>                 }
>                 break;
>         case SVM_EXIT_VMMCALL:
> -               if (!ghcb_rax_is_valid(ghcb) ||
> -                   !ghcb_cpl_is_valid(ghcb))
> +               if (!ghcb_rax_is_valid(ghcb))
>                         goto vmgexit_err;
>                 break;
>         case SVM_EXIT_RDTSCP:
> 
>> I'm assuming it's meant to make live migration a bit easier?
> 
> Peter, I forget, were these changes necessary for your work, or was the sole root
> cause the emulated MMIO bug in our backport?
> 
> If KVM chugs along happily without these patches, I'd love to pivot and yank out
> all of the CR0/4/8 and EFER trapping/tracking, and then make KVM_GET_SREGS a nop
> as well.
> 
