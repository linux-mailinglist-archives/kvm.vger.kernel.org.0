Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503A97BF7A0
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 11:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjJJJlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 05:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjJJJlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 05:41:40 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8669F;
        Tue, 10 Oct 2023 02:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:To:From; bh=KiG9gq+pmTjiCNH5AMoTyUrDkGdFm9tyOSauoUX5EWE=; b=CSHN0Dsxd
        GyqSFPEirbfl9CZEngtVS2y9cciXtLcxSnvkEglg4KOvV/GRTscJ9zQwdJYWQNC0P8FupOvDC/uyA
        IxkMNMigg77/PQ1RcfAwx0JRypFaxMbqWDAaKaGzGPUgxOQXCYHcdXL7WDeLWXxGIa4FIUtcDuk4+
        GIsYumYE=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qq9El-0004Bm-KY; Tue, 10 Oct 2023 09:41:11 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qq9El-0004Ha-7T; Tue, 10 Oct 2023 09:41:11 +0000
From:   Paul Durrant <paul@xen.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
Date:   Tue, 10 Oct 2023 09:40:47 +0000
Message-Id: <20231010094047.3850928-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

Unless explicitly told to do so (by passing 'clocksource=tsc' and
'tsc=stable:socket', and then jumping through some hoops concerning
potential CPU hotplug) Xen will never use TSC as its clocksource.
Hence, by default, a Xen guest will not see PVCLOCK_TSC_STABLE_BIT set
in either the primary or secondary pvclock memory areas. This has
led to bugs in some guest kernels which only become evident if
PVCLOCK_TSC_STABLE_BIT *is* set in the pvclocks. Hence, to support
such guests, give the VMM a new attribute to tell KVM to forcibly
clear the bit in the Xen pvclocks.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
 Documentation/virt/kvm/api.rst  |  9 +++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 25 ++++++++++++++++++++-----
 arch/x86/kvm/xen.c              | 13 +++++++++++++
 include/uapi/linux/kvm.h        |  5 +++++
 5 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 21a7578142a1..d06f971a2ce0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5544,6 +5544,7 @@ attribute cannot be read.
 			__u64 expires_ns;
 		} timer;
 		__u8 vector;
+		__u32 flags;
 	} u;
   };
 
@@ -5610,6 +5611,14 @@ KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR
   vector configured with HVM_PARAM_CALLBACK_IRQ. It is disabled by
   setting the vector to zero.
 
+KVM_XEN_VCPU_ATTR_TYPE_PVCLOCK
+  This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
+  support for KVM_XEN_HVM_CONFIG_PVCLOCK feature. It modifies the
+  pvclock information available to the guest. Currently the only defined
+  flag is KVM_XEN_PVCLOCK_TSC_UNSTABLE. If this flag is set then the
+  PVCLOCK_TSC_STABLE_BIT flag will not be set in any of the Xen pvclock
+  sources. This aligns with Xen's behaviour when it is not using TSC
+  as its clock source, which is the default behaviour.
 
 4.129 KVM_XEN_VCPU_GET_ATTR
 ---------------------------
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 17715cb8731d..2edc48e94d56 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -685,6 +685,7 @@ struct kvm_vcpu_xen {
 	u64 hypercall_rip;
 	u32 current_runstate;
 	u8 upcall_vector;
+	bool tsc_is_unstable;
 	struct gfn_to_pfn_cache vcpu_info_cache;
 	struct gfn_to_pfn_cache vcpu_time_info_cache;
 	struct gfn_to_pfn_cache runstate_cache;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..1c6556e14d40 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3096,7 +3096,8 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 
 static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 				    struct gfn_to_pfn_cache *gpc,
-				    unsigned int offset)
+				    unsigned int offset,
+				    bool force_tsc_unstable)
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct pvclock_vcpu_time_info *guest_hv_clock;
@@ -3133,6 +3134,10 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	}
 
 	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
+
+	if (force_tsc_unstable)
+		guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;
+
 	smp_wmb();
 
 	guest_hv_clock->version = ++vcpu->hv_clock.version;
@@ -3231,12 +3236,21 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->hv_clock.flags = pvclock_flags;
 
 	if (vcpu->pv_time.active)
-		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
+		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
+
+	/*
+	 * For Xen guests we may need to override PVCLOCK_TSC_STABLE_BIT as unless
+	 * explicitly told to use TSC as its clocksource Xen will not set this bit.
+	 * This default behaviour led to bugs in some guest kernels which cause
+	 * problems if they observe PVCLOCK_TSC_STABLE_BIT in the pvclock flags.
+	 */
 	if (vcpu->xen.vcpu_info_cache.active)
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
-					offsetof(struct compat_vcpu_info, time));
+					offsetof(struct compat_vcpu_info, time),
+					vcpu->xen.tsc_is_unstable);
 	if (vcpu->xen.vcpu_time_info_cache.active)
-		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
+		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0,
+					vcpu->xen.tsc_is_unstable);
 	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }
@@ -4531,7 +4545,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		    KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
 		    KVM_XEN_HVM_CONFIG_SHARED_INFO |
 		    KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL |
-		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
+		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND |
+		    KVM_XEN_HVM_CONFIG_PVCLOCK;
 		if (sched_info_on())
 			r |= KVM_XEN_HVM_CONFIG_RUNSTATE |
 			     KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 40edf4d1974c..08e64df2e27d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -938,6 +938,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		}
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_PVCLOCK:
+		vcpu->arch.xen.tsc_is_unstable = data->u.flags & KVM_XEN_PVCLOCK_TSC_UNSTABLE;
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -1030,6 +1036,13 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_PVCLOCK:
+		data->u.flags = 0;
+		if (vcpu->arch.xen.tsc_is_unstable)
+			data->u.flags |= KVM_XEN_PVCLOCK_TSC_UNSTABLE;
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 13065dd96132..a101fe60f2e1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1282,6 +1282,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_PVCLOCK		(1 << 7)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1870,6 +1871,8 @@ struct kvm_xen_vcpu_attr {
 			__u64 expires_ns;
 		} timer;
 		__u8 vector;
+		__u32 flags;
+#define KVM_XEN_PVCLOCK_TSC_UNSTABLE (1 << 0)
 	} u;
 };
 
@@ -1884,6 +1887,8 @@ struct kvm_xen_vcpu_attr {
 #define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
 #define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
 #define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_PVCLOCK */
+#define KVM_XEN_VCPU_ATTR_TYPE_PVCLOCK		0x9
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.39.2

