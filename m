Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8244E2DB50E
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 21:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgLOU1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 15:27:13 -0500
Received: from mail-bn8nam08on2070.outbound.protection.outlook.com ([40.107.100.70]:33475
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728174AbgLOU0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 15:26:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3XXWjn99rhtge8K30RzWCC2AxBNZljshz1jOpTXohdqE6oMMs/oGT0+zs8PpF4ntMeGkSTVD7/XXD1RPlNV69lU4dSn+yUvAedy6Sc+wtDDkOsBQmSF8JkempdvqGLrzElmuJ/+GGOCwyVN9iuomP+nHR1TdFRaXr6RFm6bR6BgluYEfpWY8/+iWlw7XwOtsezrlFBA4IcSgDDV+Y7hImoXc4ycb2q4kM+TvCacsbQQ0vjOSRdrdMSC2tV5aiefYnCFZtNSSJcSWUvcp3cUymv4aSTHro5Y1DfCmlDC0K5O+qLBnY7RB/++h20hQGVljeuO5264Tuo4gl9OvC3rqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+fzfTyylxN+FHL0zBmK2pk5aSaWJdZHtRKA0cNit0Zo=;
 b=k4XUjxSlfNVKGmOXwo5YodxoalNUlbXsnVydULgUattnX5BBg9sm7xv8+e4gBQAn8YdkxvPGE/0laXQiF8/kEnwp3Q3LRp59/U91GHupVX8MsPLXIQBBHzUma/NoFpodDYlly7y0QXivoKtB2wDvI+/R+quNNA9WvfpTfDHCf0uLIeTJsyEKQErpRgPxbHhpBkVcAqhScBAScdvqYX6MuFkMqlbqlf+ct/8GlY7btdc/DkYqNTCrhvRkz4QWAF7TclHv2QEcYxqvGG6d2Q6sVTVF8GmNJ9dEl47dBVXoLXOMmjjZITW7rteTYLYp/iEA+o245qlcOENRcbflMcMq2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+fzfTyylxN+FHL0zBmK2pk5aSaWJdZHtRKA0cNit0Zo=;
 b=vfhViuHdw4lX2hrRIL68EZUjkJfifR6Lm9NnJu+U4NENCKk4TmKldS9aFh27JsnLJ5+19T4i3BCMo2LYxSZpy4AE8I7pnKJbyoxuc23DBpJJd6WDdqRiXWCENNut+wTEbjIIeoVBbZJnvK9vOSn07otwlMCplcOs02BSIQZdgDw=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0217.namprd12.prod.outlook.com (2603:10b6:4:54::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.13; Tue, 15 Dec 2020 20:25:41 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 20:25:41 +0000
Subject: Re: [PATCH v5 27/34] KVM: SVM: Add support for booting APs for an
 SEV-ES guest
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <47d11ed1c1a48ab71858fc3cde766bf67a4612d1.1607620209.git.thomas.lendacky@amd.com>
 <8ed48a0f-d490-d74d-d10a-968b561a4f2e@redhat.com>
 <2fd11067-a04c-7ce6-3fe1-79a4658bdfe7@amd.com>
Message-ID: <620a7760-2c4b-c8b9-51e1-8008bf29221d@amd.com>
Date:   Tue, 15 Dec 2020 14:25:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <2fd11067-a04c-7ce6-3fe1-79a4658bdfe7@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:610:38::27) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH2PR05CA0050.namprd05.prod.outlook.com (2603:10b6:610:38::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.13 via Frontend Transport; Tue, 15 Dec 2020 20:25:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 85be30a6-8fdb-4e1e-2174-08d8a13797a1
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0217:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB021705D588EDD486F487AA5FECC60@DM5PR1201MB0217.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JwdvzfKmU/4JtkwXnCurAH6pDpbuZmalwisSYKN8Iyxq9jfYcfPp6HVBsa7+lV/6pkUohrOeV15pemqPclyGZa0q8cxwRu8//MUp+F9qfDL6TVZC5ItF+4bvLZTh6EGfVDekW7Jq38+f8Y1EAFQtcwoHaBavVjmMf0SVeMbI0TO0j0TFdLjsBor0ywcql4LvL4FoDkYj3iuU0JkU6GABUsAmmTE7IuxR/Q3aD1xnW1pyLph8GrRtdu0HJtDMwCGjYQAjAyWtZj47Wy+LYC4NSGNGzGrB9YVBnB5HkE50naezIjqgz5uZ7pqJ7LsdEzPe7i7C4SpaG7lNy/L7nORNdy74jOqA9Xs3MRoWheg/BKYGC180NtEYCZe4yc4WRadF0v0xE398nyjibFINjR1trSHEcUvT91iQC5mAGY1QtwtYLCx8N1A9C0/XOU2uYlnk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(83380400001)(5660300002)(31696002)(86362001)(8936002)(66476007)(26005)(66556008)(34490700003)(30864003)(7416002)(16576012)(186003)(2616005)(54906003)(4326008)(53546011)(956004)(508600001)(36756003)(8676002)(66946007)(31686004)(6486002)(2906002)(52116002)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UEkvcEpyVUJSWHA1ak5EYUFwaTRhRE1rdjczTE90ZVBXTElUeTZSdW1XUVpH?=
 =?utf-8?B?OU44dlcxOTlnZGRENmV4eHVRRzRNWjZORGFRVGZCbnBFN09PaFJNYjFURVpn?=
 =?utf-8?B?L0xlTmRaODRFbDQ0d0RHSFoyWlIzNmx3VGxzZXpDY3NORUtpb1RyMWw2c2ZF?=
 =?utf-8?B?YlJiR3lpTGFoeitpZXBxU2kzSHJjOXZJOFNxWFJnTU1pV0JmQ3NUQXIzdzhN?=
 =?utf-8?B?aE9kOFEyN1N1OGltb0UxT3ZFNFhHU2NIN29Ibmlsazc2Ri9xekRJSHU1WXdn?=
 =?utf-8?B?NVIzaHZoVWRYdGQ0ajVoM1ZNR1M2WGc2M0NkZm11RGFEdDNLOUlqNmUxOWRu?=
 =?utf-8?B?YnYzRzVUVHd6dlhTQWdYcSt0MnZsWjdIdDkrYldsQTVrU0NVSFBYcXNickRh?=
 =?utf-8?B?NVJWSGdEN2llMzE0blhvNDBLWks1ZU14ZFFPNU5ieEp3bkJKSUZ0WXdzV1hV?=
 =?utf-8?B?dnR4aVdBODZJeHB1M1RjRUU5TmZlV3JVeE1iRGtRQ0ZRcFV0WExlaHhsZlVH?=
 =?utf-8?B?NGRlNVpIUDI5UEhiMHFDeE53WkdJTTU5RVZUenJLdE8yVzN4endmVGNySHBI?=
 =?utf-8?B?UndPVldMOWRMOGJ1dHplMkZHYWhHcy9QMCszWnZRYlNZOGxhb2FtbWR3RFlF?=
 =?utf-8?B?KzhWdE9uT2R0cWg5RFFXQ2k1aXQ1ODFUQ1FKaStsa2NvaEdFTnV0Vy8xdDJK?=
 =?utf-8?B?djRaVGpBYk1vL2p1QnI2Ly9QUFh3STJGb28xYTJBVGJLY0xyWk9QWEJjNnRp?=
 =?utf-8?B?bGFuZWs4UjJVSzMzMXlPY1EvYTVNRzF1cmRqc1BERytFcFJHY1lNSmY1SENN?=
 =?utf-8?B?VU02djdjVzJCYkZkTWxJaUg1OGpEcG5zQUhqUHZBaTFJL0R6eWJCNi85TGVP?=
 =?utf-8?B?dE5zVFlTUVRDYUxJUkNqQmVTc0lKZXVoNUsxOFlnWmdBNmVzMlZqbVBKUVlh?=
 =?utf-8?B?UEdUU2E4UG5wc2VtTGFaWGRZOXZET0pTdmlSYjYwUzU0UTFHT0tpQU5scUpF?=
 =?utf-8?B?MTZsMkhvUEtDaWtaYkhpRVFxbHBHb3puZDNyNys3SVRCZUU1Z3JkWnVqblRq?=
 =?utf-8?B?SG0vWVllRWd2UDJUNzhFYTA4MTVPU1RzSDcxTnpUNWJuYWdHUEh0QXBpQlZ2?=
 =?utf-8?B?NWVmRis2TFhmZk9ObE13aElUSzdVeWlFVjVqYTdnVkxIZkptZHoxV2RVamJw?=
 =?utf-8?B?UEJwdlMxWTdtQ0JGWi83ODBGNlh4R3FWN2F4d0Q3azlhVlJieVpKV2ZLUWdL?=
 =?utf-8?B?ejNud2NZSkhQeC9XdE1mZHl1QnN3SjRsZzRZSG5JYmpBSUxSeUNsdzkvcnAw?=
 =?utf-8?Q?tL+/mI81Cyj1jxXw/iI8KRgeU3peJAapzF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 20:25:41.1048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 85be30a6-8fdb-4e1e-2174-08d8a13797a1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G/MImTED6I617M4CEBFZib2BZyZEUaM5j1svPH+vId63xtZ46xMTnO4IHoA3IVC5gdAymgYOLhC5ymH3vWCw7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0217
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 1:46 PM, Tom Lendacky wrote:
> On 12/14/20 10:03 AM, Paolo Bonzini wrote:
>> On 10/12/20 18:10, Tom Lendacky wrote:
>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> +    case SVM_VMGEXIT_AP_HLT_LOOP:
>>> +        svm->ap_hlt_loop = true;
>>
>> This value needs to be communicated to userspace.  Let's get this right
>> from the beginning and use a new KVM_MP_STATE_* value instead (perhaps
>> reuse KVM_MP_STATE_STOPPED but for x86 #define it as
>> KVM_MP_STATE_AP_HOLD_RECEIVED?).
> 
> Ok, let me look into this.

Paolo, is this something along the lines of what you were thinking, or am
I off base? I created kvm_emulate_ap_reset_hold() to keep the code
consolidated and remove the duplication, but can easily make those changes
local to sev.c. I'd also like to rename SVM_VMGEXIT_AP_HLT_LOOP to
SVM_VMGEXIT_AP_RESET_HOLD to more closely match the GHBC document, but
that can be done later (if possible, since it is already part of the uapi
include file).

Thanks,
Tom

---
KVM: SVM: Add support for booting APs for an SEV-ES guest

From: Tom Lendacky <thomas.lendacky@amd.com>

Typically under KVM, an AP is booted using the INIT-SIPI-SIPI sequence,
where the guest vCPU register state is updated and then the vCPU is VMRUN
to begin execution of the AP. For an SEV-ES guest, this won't work because
the guest register state is encrypted.

Following the GHCB specification, the hypervisor must not alter the guest
register state, so KVM must track an AP/vCPU boot. Should the guest want
to park the AP, it must use the AP Reset Hold exit event in place of, for
example, a HLT loop.

First AP boot (first INIT-SIPI-SIPI sequence):
  Execute the AP (vCPU) as it was initialized and measured by the SEV-ES
  support. It is up to the guest to transfer control of the AP to the
  proper location.

Subsequent AP boot:
  KVM will expect to receive an AP Reset Hold exit event indicating that
  the vCPU is being parked and will require an INIT-SIPI-SIPI sequence to
  awaken it. When the AP Reset Hold exit event is received, KVM will place
  the vCPU into a simulated HLT mode. Upon receiving the INIT-SIPI-SIPI
  sequence, KVM will make the vCPU runnable. It is again up to the guest
  to then transfer control of the AP to the proper location.

  To differentiate between an actual HLT and an AP Reset Hold, a new MP
  state is introduced, KVM_MP_STATE_AP_RESET_HOLD, which the vCPU is
  placed in upon receiving the AP Reset Hold exit event. Additionally, to
  communicate the AP Reset Hold exit event up to userspace (if needed), a
  new exit reason is introduced, KVM_EXIT_AP_RESET_HOLD.

A new x86 ops function is introduced, vcpu_deliver_sipi_vector, in order
to accomplish AP booting. For VMX, vcpu_deliver_sipi_vector is set to the
original SIPI delivery function, kvm_vcpu_deliver_sipi_vector(). SVM adds
a new function that, for non SEV-ES guests, invokes the original SIPI
delivery function, kvm_vcpu_deliver_sipi_vector(), but for SEV-ES guests,
implements the logic above.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/lapic.c            |    2 +-
 arch/x86/kvm/svm/sev.c          |   22 ++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   10 ++++++++++
 arch/x86/kvm/svm/svm.h          |    2 ++
 arch/x86/kvm/vmx/vmx.c          |    2 ++
 arch/x86/kvm/x86.c              |   20 +++++++++++++++++---
 include/uapi/linux/kvm.h        |    2 ++
 8 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 39707e72b062..23d7b203c060 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1287,6 +1287,8 @@ struct kvm_x86_ops {
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
+
+	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 };
 
 struct kvm_x86_nested_ops {
@@ -1468,6 +1470,7 @@ int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
+int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
 int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
 
 void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6a87623aa578..a2f08ed777d8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2898,7 +2898,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 			/* evaluate pending_events before reading the vector */
 			smp_rmb();
 			sipi_vector = apic->sipi_vector;
-			kvm_vcpu_deliver_sipi_vector(vcpu, sipi_vector);
+			kvm_x86_ops.vcpu_deliver_sipi_vector(vcpu, sipi_vector);
 			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		}
 	}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8b5ef0fe4490..4045de7f8f8b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1561,6 +1561,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
+	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		break;
@@ -1886,6 +1887,9 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_NMI_COMPLETE:
 		ret = svm_invoke_exit_handler(svm, SVM_EXIT_IRET);
 		break;
+	case SVM_VMGEXIT_AP_HLT_LOOP:
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
+		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
 		struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 
@@ -2038,3 +2042,21 @@ void sev_es_vcpu_put(struct vcpu_svm *svm)
 		wrmsrl(host_save_user_msrs[i].index, svm->host_user_msrs[i]);
 	}
 }
+
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/* First SIPI: Use the values as initially set by the VMM */
+	if (!svm->received_first_sipi) {
+		svm->received_first_sipi = true;
+		return;
+	}
+
+	/*
+	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
+	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
+	 * non-zero value.
+	 */
+	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 941e5251e13f..5c37fa68ee56 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4382,6 +4382,14 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 		   (vmcb_is_intercept(&svm->vmcb->control, INTERCEPT_INIT));
 }
 
+static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	if (!sev_es_guest(vcpu->kvm))
+		return kvm_vcpu_deliver_sipi_vector(vcpu, vector);
+
+	sev_vcpu_deliver_sipi_vector(vcpu, vector);
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
@@ -4524,6 +4532,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.msr_filter_changed = svm_msr_filter_changed,
 	.complete_emulated_msr = svm_complete_emulated_msr,
+
+	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5431e6335e2e..0fe874ae5498 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -185,6 +185,7 @@ struct vcpu_svm {
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
+	bool received_first_sipi;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
@@ -591,6 +592,7 @@ void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
 void sev_es_vcpu_put(struct vcpu_svm *svm);
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75c9c6a0a3a4..2af05d3b0590 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7707,6 +7707,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
+
+	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 648c677b12e9..622612f88da7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7974,17 +7974,22 @@ void kvm_arch_exit(void)
 	kmem_cache_destroy(x86_fpu_cache);
 }
 
-int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
+int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
-		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
+		vcpu->arch.mp_state = state;
 		return 1;
 	} else {
-		vcpu->run->exit_reason = KVM_EXIT_HLT;
+		vcpu->run->exit_reason = reason;
 		return 0;
 	}
 }
+
+int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
+{
+	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
+}
 EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
@@ -7998,6 +8003,14 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
+int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
+{
+	int ret = kvm_skip_emulated_instruction(vcpu);
+
+	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
+
 #ifdef CONFIG_X86_64
 static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 			        unsigned long clock_type)
@@ -10150,6 +10163,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	kvm_set_segment(vcpu, &cs, VCPU_SREG_CS);
 	kvm_rip_write(vcpu, 0);
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
 int kvm_arch_hardware_enable(void)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 886802b8ffba..374c67875cdb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -251,6 +251,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_X86_RDMSR        29
 #define KVM_EXIT_X86_WRMSR        30
 #define KVM_EXIT_DIRTY_RING_FULL  31
+#define KVM_EXIT_AP_RESET_HOLD    32
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -573,6 +574,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_CHECK_STOP        6
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
+#define KVM_MP_STATE_AP_RESET_HOLD     9
 
 struct kvm_mp_state {
 	__u32 mp_state;
