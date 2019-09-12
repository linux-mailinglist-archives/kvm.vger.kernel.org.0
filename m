Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8403DB16A8
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 01:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfILX2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 19:28:05 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:45225 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfILX2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 19:28:05 -0400
Received: by mail-pf1-f201.google.com with SMTP id a8so19588020pfo.12
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 16:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PNF3/tBbZ8jzSIpcJS5xE1Kz9iSANR2C78rBu2GcxHE=;
        b=ZBtz47AX4M1POo+YDteOHVKz5G4TQn85zQpPPouuXrclgPrT0XIqIhduO3r4PNXF5l
         4lN+KFl7OqCHi9uq2qUaf6hwxuRZdBlYmvgqmX21I6dskBDM1AY/O0LJ0PBm5uD67YC4
         0DoikU2xjDZbizbTY8ge/6K7+s1JXkb+041KqaUa6hviewIX6kodxmcCFT+CHx4Y8+h4
         HOxNsjoAMt5B2y0VHY6lA2TIepLUuAJKlS/ZmQs9ZGg+i0Q/hG6Xr561iqdKesVq8ZOP
         HgmGktTXW1zf9lWsBaIyQ8ItVfaBzHHAKjb62N6p3kfpDcfapqh61daqwzNPngq/IAMy
         K1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PNF3/tBbZ8jzSIpcJS5xE1Kz9iSANR2C78rBu2GcxHE=;
        b=rtXzCX7i6L5HMb2UcKiPSMbHlx576y8LcuM5l4DZ4qvcOOb2thjlqwkEh0c6GR5nwr
         u2c9/syeqDNdxY9zCa5YE9CeAX9zKct0NLTMm52cT1Ca8i34BeOrgGxQgwEbAtLUvYaB
         6s5hKLl7w3uUYmYSRGo2HRZqrYs3df1Cijh0x3uYiY1rqdbY1Oi3g8Lz301k+IsSiGJ0
         HW9QHY0H73Q4i6wowvQ2vyrF6dmP7MmPLSKMoNJYgz1EMLfZgbyEm9UmGM3Y5JMQdbY8
         0HUkZ39d4PBpH5culj8KWYAW8Mdy0ZwGuTEV3kUE3DbydpnBTCRkUbiezHzL0HImt1Ck
         j0Hw==
X-Gm-Message-State: APjAAAVeIyEVqtatqWankDCCCjl8bgRmga4jIbAEcFW5I+cS2LQXgjir
        t5QcZsBvsg/G2B2QPgZD7TjZToLtreCKy2B4ruQmH5IJfo7ZPBOPdptFelu5BisQLil9bQVXE6g
        CFOrRg0LXUVPXuq9avZEe4I8jsJBr7cLRaWyskf8V53xWpXoDced4rAnSn5FfHpU=
X-Google-Smtp-Source: APXvYqwzeZtu5cSWuZPzGf5kKH6qdxS5bX8KuQFhkAtK9e6sH3Q18MJCvBvmmIJqTKS0+jkTYJr+bjK9B5lWCA==
X-Received: by 2002:a63:de07:: with SMTP id f7mr41500547pgg.213.1568330883178;
 Thu, 12 Sep 2019 16:28:03 -0700 (PDT)
Date:   Thu, 12 Sep 2019 16:27:53 -0700
Message-Id: <20190912232753.85969-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [RFC][PATCH] kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Jacob Xu <jacobhxu@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If these CPUID leaves are implemented, the EDX output is always the
x2APIC ID, regardless of the ECX input. Furthermore, the low byte of
the ECX output is always identical to the low byte of the ECX input.

KVM's CPUID emulation doesn't report the correct ECX and EDX outputs
when the ECX input is greater than the first subleaf for which the
"level type" is zero. This is probably only significant in the case of
the x2APIC ID, which should be the result of CPUID(EAX=0BH):EDX or
CPUID(EAX=1FH):EDX, without even setting a particular ECX input value.

Create a "wildcard" kvm_cpuid_entry2 for leaves 0BH and 1FH in
response to the KVM_GET_SUPPORTED_CPUID ioctl. This entry does not
have the KVM_CPUID_FLAG_SIGNIFCANT_INDEX flag, so it matches all
subleaves for which there isn't a prior explicit index match.

Add a new KVM_CPUID flag that is only applicable to leaves 0BH and
1FH: KVM_CPUID_FLAG_CL_IS_PASSTHROUGH. When KVM's CPUID emulation
encounters this flag, it will fix up ECX[7:0] in the CPUID output. Add
this flag to the aforementioned "wildcard" kvm_cpuid_entry2.

Note that userspace is still responsible for setting EDX to the x2APIC
ID of the vCPU in each of these structures, *including* the wildcard.

Qemu doesn't pass the flags from KVM_GET_SUPPORTED_CPUID to
KVM_SET_CPUID2, so it will have to be modified to take advantage of
these changes. Note that passing the new flag to older kernels will
have no effect.

Unfortunately, the new flag bit was not previously reserved, so it is
possible that a userspace agent that already sets this bit will be
unhappy with the new behavior. Technically, I suppose, this should be
implemented as a new set of ioctls. Posting as an RFC to get comments
on the API breakage.

Fixes: 0771671749b59a ("KVM: Enhance guest cpuid management")
Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Steve Rutherford <srutherford@google.com>
Reviewed-by: Jacob Xu <jacobhxu@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Change-Id: I6b422427f78b530106af3f929518363895367e25
---
 Documentation/virt/kvm/api.txt  |  6 +++++
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/cpuid.c            | 39 +++++++++++++++++++++++++++------
 3 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d067767b6170..be5cc42ad35f4 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -1396,6 +1396,7 @@ struct kvm_cpuid2 {
 #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
 #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
 #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
+#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH	BIT(3)
 
 struct kvm_cpuid_entry2 {
 	__u32 function;
@@ -1447,6 +1448,8 @@ emulate them efficiently. The fields in each entry are defined as follows:
         KVM_CPUID_FLAG_STATE_READ_NEXT:
            for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
            the first entry to be read by a cpu
+	KVM_CPUID_FLAG_CL_IS_PASSTHROUGH:
+	   If the output value of ECX[7:0] matches the input value of ECX[7:0]
    eax, ebx, ecx, edx: the values returned by the cpuid instruction for
          this function/index combination
 
@@ -2992,6 +2995,7 @@ The member 'flags' is used for passing flags from userspace.
 #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
 #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
 #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
+#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH	BIT(3)
 
 struct kvm_cpuid_entry2 {
 	__u32 function;
@@ -3040,6 +3044,8 @@ The fields in each entry are defined as follows:
         KVM_CPUID_FLAG_STATE_READ_NEXT:
            for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
            the first entry to be read by a cpu
+	KVM_CPUID_FLAG_CL_IS_PASSTHROUGH:
+	   If the output value of ECX[7:0] matches the input value of ECX[7:0]
    eax, ebx, ecx, edx: the values returned by the cpuid instruction for
          this function/index combination
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 503d3f42da167..3b67d21123946 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -223,6 +223,7 @@ struct kvm_cpuid_entry2 {
 #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		(1 << 0)
 #define KVM_CPUID_FLAG_STATEFUL_FUNC		(1 << 1)
 #define KVM_CPUID_FLAG_STATE_READ_NEXT		(1 << 2)
+#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH	(1 << 3)
 
 /* for KVM_SET_CPUID2 */
 struct kvm_cpuid2 {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e7d25f4364664..280a796159cb2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -612,19 +612,41 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	 */
 	case 0x1f:
 	case 0xb: {
-		int i, level_type;
+		int i;
 
-		/* read more entries until level_type is zero */
-		for (i = 1; ; ++i) {
+		/*
+		 * We filled in entry[0] for CPUID(EAX=<function>,
+		 * ECX=00H) above.  If its level type (ECX[15:8]) is
+		 * zero, then the leaf is unimplemented, and we're
+		 * done.  Otherwise, continue to populate entries
+		 * until the level type (ECX[15:8]) of the previously
+		 * added entry is zero.
+		 */
+		for (i = 1; entry[i - 1].ecx & 0xff00; ++i) {
 			if (*nent >= maxnent)
 				goto out;
 
-			level_type = entry[i - 1].ecx & 0xff00;
-			if (!level_type)
-				break;
 			do_host_cpuid(&entry[i], function, i);
 			++*nent;
 		}
+
+		if (i > 1) {
+			/*
+			 * If this leaf has multiple entries, treat
+			 * the final entry as a "wildcard." Clear the
+			 * "significant index" flag so that the index
+			 * will be ignored when we later look for an
+			 * entry that matches a CPUID
+			 * invocation. Since this entry will now match
+			 * CPUID(EAX=<function>, ECX=<index>) for any
+			 * <index> >= (i - 1), set the "CL
+			 * passthrough" flag to ensure that ECX[7:0]
+			 * will be set to (<index> & 0xff), per the SDM.
+			 */
+			entry[i - 1].flags &= ~KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+			entry[i - 1].flags |= KVM_CPUID_FLAG_CL_IS_PASSTHROUGH;
+		}
+
 		break;
 	}
 	case 0xd: {
@@ -1001,8 +1023,11 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		*ebx = best->ebx;
 		*ecx = best->ecx;
 		*edx = best->edx;
-	} else
+		if (best->flags & KVM_CPUID_FLAG_CL_IS_PASSTHROUGH)
+			*ecx = (*ecx & ~0xff) | (index & 0xff);
+	} else {
 		*eax = *ebx = *ecx = *edx = 0;
+	}
 	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, entry_found);
 	return entry_found;
 }
-- 
2.23.0.237.gc6a4ce50a0-goog

