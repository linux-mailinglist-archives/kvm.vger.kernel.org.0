Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2072B113F
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 23:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgKLWSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 17:18:01 -0500
Received: from mail-dm6nam12on2056.outbound.protection.outlook.com ([40.107.243.56]:35937
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725894AbgKLWSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 17:18:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLwogS2KucuCB82KAIneroQwZi6+NyTaZLpAVm+14MB6wyFWHK9CKaXr9eXB9MpIwhIQqxpofzgv2iPXlc7z2GUAzatckJLfVHD+/Flgnn+leRDiQJZDMFCdbHGS1Oh3+8Ail+ZJB7jkC8gO51yeKmNEUXRpeYRoukPHsLTjyjVVaLt5fwiFJWZ8AjNAyfF8eeMitm6n+oEW7pHP4aPrMS4XYsSNtvUrHKdONYgHfRJfZp2K6pBhygImKmdWfQdXbaL+BaYaBixWs866R8pi7ekkoVK6vANXaA+H6BETjiJL2PRws4HIrnONd+naPZjQ9bGXG4KD4c8TD3tS8Txe8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ho/I97presCR0gzHfkvBn/U6m7Yxt4gD1SkyAqie6AI=;
 b=mKbneU4C/7Ko24pPc+hX9/cabrcnVid2RuoAtfpbk3UOBg1dzulwX7njSLLK1jYAA+HN/zu6r9r5FcQ710NmOT46nYLzLUPXbSuOuIm7UXo0S/QVvq+FIhQ6DBhoDP+rxuzdlPfcHO88sOcpnDYKT4PZ4DXZ13ol+glsMfez0WCE+aoG384/oAZk7OskxiFUzgvjv69MuSY8Ewxg5oU8NMiOWPnRulqd0ylTgFK9is4mmZohOyRxGQuMxg/cs5+iI6EBG6zAAJKBFgwDEtXMhNWHGBYbp1lHqBMmqGPsobHmNbE6XIEtH5hL3AP7DEYvGOFFvLqbbxNL6Pd0hOVGpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ho/I97presCR0gzHfkvBn/U6m7Yxt4gD1SkyAqie6AI=;
 b=uwApJCM8RFwzcvxvZOVr4QYIqRxUQ7oFKnGXmnrTskFkaBXTS+D9aGxylVr+3TnJLJ4FA4Em3mn+/v/3tcfdQMgqsy3a27wZ7EycyDelqBkmlsBoYAmoZkzmNuvU6ayGpOTNFUqus9QVhW+fXC/7JaIEUPsNki5xcWSGYt0PjrU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4445.namprd12.prod.outlook.com (2603:10b6:806:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 12 Nov
 2020 22:17:57 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3541.026; Thu, 12 Nov 2020
 22:17:57 +0000
Subject: [PATCH v2 1/2] KVM: x86: Introduce cr3_lm_rsvd_bits in kvm_vcpu_arch
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     junaids@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de, vkuznets@redhat.com,
        jmattson@google.com
Date:   Thu, 12 Nov 2020 16:17:56 -0600
Message-ID: <160521947657.32054.3264016688005356563.stgit@bmoger-ubuntu>
In-Reply-To: <160521930597.32054.4906933314022910996.stgit@bmoger-ubuntu>
References: <160521930597.32054.4906933314022910996.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR04CA0088.namprd04.prod.outlook.com
 (2603:10b6:805:f2::29) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN6PR04CA0088.namprd04.prod.outlook.com (2603:10b6:805:f2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 22:17:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 198d7575-b613-44c0-ccb8-08d88758cf3a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4445A4E8E0A6A20BB4BD625A95E70@SA0PR12MB4445.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y40xjwGxMMjt2t+zg8AVVnwgJZ3Ai2M3AEawUPIAzUjvewa5b3U/45c6uj5k9X3VsGEVhlvIkEaueAM7RzWC7vPjQQCGXwk1RofZc3MClqcf/RbrBlaELJ5b6OYQPLXsBz3TrR1N5TxNDj9GkH7bkfRXalURyXpJHfROES/eiabKcLZXZUm4Jmqs45ndqw2Ma8mIvY+pZSguv/t4HtP/f5Ww81e9K8NdEq1RYSzeZFtlIQ/luS61ykTD+c7MNkX6JW1Nxw0qGIjW1wqxAsP8eHQIlaDoUItFZbHSeTDYGU+QYWI0OT+t3zdtgwobyfeNlbWsM6ddATn8t5q/f5UoLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(52116002)(33716001)(16576012)(9686003)(16526019)(8676002)(86362001)(6486002)(103116003)(478600001)(956004)(6916009)(2906002)(66476007)(8936002)(66556008)(316002)(7416002)(26005)(4326008)(83380400001)(44832011)(5660300002)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DjbDoBq67y2+93lCu/r7zJL3Igt1xVigX3R+WqdaCXMOuS/43owYGMs0UTD72M0dHjdoPn8LeD0qI0c1pwHBIHY9oF3QwK8+2sjPMG1rkc33LNyvEZpd8xH2eO0JgYK9C6EV0RlvVp53BoKM6V2Tr91L8WskdVhfeCgD0NiJ5yqa4lrxjs1ZPssd94BOyqdBNOnGIBguCwFI8hMhhMM2EIwDQwZW12DJokKDSL/1puK0GZQ0kdfvlPLRs8UJqjQ94JMa1RcvXvcBvn8hkLYklK95G3rC/oroywZiVoT2HhPM4WLYGQaOt8dOEU80T7Ol514sDVWKkJLBCu4A0yTBagnD6I6utYtaKVyw2k/cu9z2WJBJTDnOvf7ZysiBTw3o7yF7Q5pFTdQrSYQp48JUnGMHQyXw3UXXyhhn84yhMQgLih97zlxjUA7x6fZT/0X/b5wd+DDywukHzKeQK/XpVAMFYE5ISWzaZwc1DjRk7hAFkXXyhY/xlRJh3gqGPn2Rl7H1HOWxelQ1WUCqnw+/N7YHXoSN2HVXuw4HmYnY28FBC/DPKx+tapC5fe58ZPeRxBpUcALCcOK1llp2jJtUAV1pqRIvXSJleeTqH8Og0a1fPQb2hR5aouWnKarGQeolaLxJU8uYzJdwLuHsc+75FA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 198d7575-b613-44c0-ccb8-08d88758cf3a
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 22:17:57.7913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rkN5tozXyu+VJKaahHDE8l8BDBg4hNikH53Hhb0QZmXT4ok74WfA57E0Kd5oOlCm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4445
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV guests fail to boot on a system that supports the PCID feature.

While emulating the RSM instruction, KVM reads the guest CR3
and calls kvm_set_cr3(). If the vCPU is in the long mode,
kvm_set_cr3() does a sanity check for the CR3 value. In this case,
it validates whether the value has any reserved bits set. The
reserved bit range is 63:cpuid_maxphysaddr(). When AMD memory
encryption is enabled, the memory encryption bit is set in the CR3
value. The memory encryption bit may fall within the KVM reserved
bit range, causing the KVM emulation failure.

Introduce a new field cr3_lm_rsvd_bits in kvm_vcpu_arch which will
cache the reserved bits in the CR3 value. This will be initialized
to rsvd_bits(cpuid_maxphyaddr(vcpu), 63).

If the architecture has any special bits(like AMD SEV encryption bit)
that needs to be masked from the reserved bits, should be cleared
in vendor specific kvm_x86_ops.vcpu_after_set_cpuid handler.

Fixes: a780a3ea628268b2 ("KVM: X86: Fix reserved bits check for MOV to CR3")
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/cpuid.c            |    2 ++
 arch/x86/kvm/x86.c              |    2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d44858b69353..324ddd7fd0aa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -639,6 +639,7 @@ struct kvm_vcpu_arch {
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
 
+	unsigned long cr3_lm_rsvd_bits;
 	int maxphyaddr;
 	int max_tdp_level;
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 06a278b3701d..cb52485cc507 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -169,6 +169,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
 
+	vcpu->arch.cr3_lm_rsvd_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
+
 	/* Invoke the vendor callback only after the above state is updated. */
 	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5ede41bf9e6..ff55e33b268b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1042,7 +1042,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 
 	if (is_long_mode(vcpu) &&
-	    (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
+	    (cr3 & vcpu->arch.cr3_lm_rsvd_bits))
 		return 1;
 	else if (is_pae_paging(vcpu) &&
 		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))

