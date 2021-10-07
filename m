Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C1442604D
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 01:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhJGXSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 19:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbhJGXSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 19:18:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9D3C061755
        for <kvm@vger.kernel.org>; Thu,  7 Oct 2021 16:16:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s66-20020a252c45000000b005ba35261459so9435848ybs.7
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 16:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=ywF2/rgM1bhy2sAaNDgCO3TYtTem4+JSfSFNkboo73g=;
        b=Nl2uaV7VRRjEOm/tpJ9KZVG7uSLYTfk8nEgePBQYBAjZk1f3EiWye9NDSWsSw7PtOE
         y91pUjSmvUwIhExZXsJnE2C3nHeRgeyoMJmuOxe8hK81N5hP+os1RkjJP704V7nSMlDV
         KYSJQNXlZrmU4J3O4GXkEcmdApLX640FSxzOSpNBfucZUFQn645ex3fSQSF0y6jZg9YU
         v0/K4HlgzySOEYa7YUtzKPeoV0EqUuuEY6R9QO8I13kD9lsVeXHiRCSeHZ0xzT1F0uzB
         yzqzb1lMFJqmVu3knJes7mA5BxrrZblOg4zDOqNOkVGvROtrc2G76S8j0nX6S2Cv9HEK
         fi1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc:content-transfer-encoding;
        bh=ywF2/rgM1bhy2sAaNDgCO3TYtTem4+JSfSFNkboo73g=;
        b=xhn5nlTnMIzZduozRE0Vrr5X47JUZXIUIoKAz0R58kzVZmRjhdXrkY8M5SgfFDzBNl
         F2vuWQLhePvzi+7wytynuAwO9NGgPzJsxa0FTf4qdWztrPdftZHs9JRjSFp/rvFdGevw
         Bx/7qRsfl5wTgBbI8VtA9mseY5baS3aJcOw4JQSWVavZxkPxA/W7TPCBcBZ/Ernhw7V6
         eJQHvVqCx3ogbluoxWgEjfjNSUDI7XkRqHchG2YmGx0vzrM7bB1zxfZN59GhiprkStZd
         EGTDhkRKHcHTF5nPL57LbwW8+KJQFIIqMGrRlgm/KQpt6RHjcuLR6S1pg/2WRQsTjgR0
         w11g==
X-Gm-Message-State: AOAM532mit3Fp9oqaJzO6g0k3FYFMhfDPqT41QqJlqMNJJNFhisjzgmC
        rLa1kdce3YGO4iar7nVBfxR6MK9NEus=
X-Google-Smtp-Source: ABdhPJwFiYLQxeDfIfgpJxmittGB2vzEHNxXIQU0imnuo3OfNnGuEIqL7ToIQUEBA1Eq40kG7OqhCwhiSN4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:2783:a5c0:45f5:b0ed])
 (user=seanjc job=sendgmr) by 2002:a25:6150:: with SMTP id v77mr7923658ybb.530.1633648609838;
 Thu, 07 Oct 2021 16:16:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  7 Oct 2021 16:16:47 -0700
Message-Id: <20211007231647.3553604-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH] KVM: x86: Account for 32-bit kernels when handling address in
 TSC attrs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When handling TSC attributes, cast the userspace provided virtual address
to an unsigned long before casting it to a pointer to fix warnings on
32-bit kernels due to casting a 64-bit integer to a 32-bit pointer.

Add a check that the truncated address matches the original address, e.g.
to prevent userspace specifying garbage in bits 63:32.

  arch/x86/kvm/x86.c: In function =E2=80=98kvm_arch_tsc_get_attr=E2=80=99:
  arch/x86/kvm/x86.c:4947:22: error: cast to pointer from integer of differ=
ent size
   4947 |  u64 __user *uaddr =3D (u64 __user *)attr->addr;
        |                      ^
  arch/x86/kvm/x86.c: In function =E2=80=98kvm_arch_tsc_set_attr=E2=80=99:
  arch/x86/kvm/x86.c:4967:22: error: cast to pointer from integer of differ=
ent size
   4967 |  u64 __user *uaddr =3D (u64 __user *)attr->addr;
        |                      ^

Cc: Oliver Upton <oupton@google.com>
Fixes: 469fde25e680 ("KVM: x86: Expose TSC offset controls to userspace")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 196ac33ef958..4a52a08707de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4944,9 +4944,12 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vc=
pu,
 static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
 				 struct kvm_device_attr *attr)
 {
-	u64 __user *uaddr =3D (u64 __user *)attr->addr;
+	u64 __user *uaddr =3D (u64 __user *)(unsigned long)attr->addr;
 	int r;
=20
+	if ((u64)(unsigned long)uaddr !=3D attr->addr)
+		return -EFAULT;
+
 	switch (attr->attr) {
 	case KVM_VCPU_TSC_OFFSET:
 		r =3D -EFAULT;
@@ -4964,10 +4967,13 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *v=
cpu,
 static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
 				 struct kvm_device_attr *attr)
 {
-	u64 __user *uaddr =3D (u64 __user *)attr->addr;
+	u64 __user *uaddr =3D (u64 __user *)(unsigned long)attr->addr;
 	struct kvm *kvm =3D vcpu->kvm;
 	int r;
=20
+	if ((u64)(unsigned long)uaddr !=3D attr->addr)
+		return -EFAULT;
+
 	switch (attr->attr) {
 	case KVM_VCPU_TSC_OFFSET: {
 		u64 offset, tsc, ns;
--=20
2.33.0.882.g93a45727a2-goog

