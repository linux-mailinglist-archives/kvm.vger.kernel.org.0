Return-Path: <kvm+bounces-15965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3667D8B280A
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57C35B22302
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AFF815665E;
	Thu, 25 Apr 2024 18:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GUjHHqXX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098B115575E
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 18:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714068887; cv=none; b=SeE07NONWP6HR9axTrQPkkIRqZAg+e7uDt15Ts+8zvn6LC/d8slY9ybbbNNFNh+/9KWXsLPH6iiiCNJyFDZ0ZNbQXXr0WozDm+qzee878lW3FB9x+MUU2hnylM0grXza5NjoHlaOGskuV/BEF0XV6G/1mIeIOtYoebH8Y0t2dqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714068887; c=relaxed/simple;
	bh=247P5YIdaIT018imI0/FIsolw28zSgLr6OXAMGjYu4k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iG9zELxCBJi3dqpTCLiOx14YF2Eay2veBIVoDIasJylXG6I5cT1uMwd97+kfxZZZHv/1IflJbChFxh/7kFH34M2igCV0Tv7EVpMBAOAQQvYkMtURdPE6MHAFUxNk8HgCRmwIuiAi00OORDkVMv82ZwPzVLTTuQmZ6v8sEHkVCLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GUjHHqXX; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5e4f312a995so1129386a12.2
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 11:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714068885; x=1714673685; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aNpP1eW5DP+TAfE/NjGLi9NUaYZsZjI/uTGRPzZPo4M=;
        b=GUjHHqXX8gP+CwPGBOYzK9I7kFPOLFy8gUhL3rM4BtNb1lfCnrBlpJrtXf8OBq+Yvi
         zXHtNofv/WBOwl+YHZMo8chv2MN1MNk8HyKm94WNmlPqXzg/Hf1hOF0wd+QUQeJrHKaA
         ycKSohc0mAL5x8Srj8oTC4JYa3pXlA76W9gIdU4bZoRtKXLEPlh7oEYNKoYsl29j83Qj
         T+WhOcOldOviG7QLjtjvIVPEq6zJ/mh0v5F5JLqSqVjwZcHLSeGsO0L6V3xDCpnzcD8p
         c2rhKGOskRFAu1OFj7ORkG+tX1n19O+npMSNl3cejrl4JH2OFb9mqbt5x8Z/1mPG7a2/
         aJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714068885; x=1714673685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aNpP1eW5DP+TAfE/NjGLi9NUaYZsZjI/uTGRPzZPo4M=;
        b=L8f3qkj2sab9cBbnvtNQPyOyHXImrKvLFh+ctTpV83DpnuYS758cgH4vybt2cHYFyy
         6qQHhwmPwgARxIeoOMtk8WLn/ro+gmSd3N8YPQ3CSwL+ixqayEPxU8mB4yJjoZB7FXI2
         qzfXBE4dqAildHVg8hUwQzC2h8fhqCXdlUjgVKrgi4JWtSIKK1d1fNMaqyrPuOCoeZsc
         ZXvvz+t1+bCfSH+GkLGzuaW0NNneeaEF7y5rw8U3+XcW4j4LhTAAL/ohNqV9qR7dfmJq
         T/H5jNHGMdlHzB/e27t/fZmI4GsjYeXXIgV6Lv0x8leUHMVIzYY6LSiVNhmgyG8Wk9qU
         Xmfw==
X-Gm-Message-State: AOJu0YztmWmqTZbBoCDGIEEYE59tVNbc4c66mRd5HR2gZ9UKDzUYBcdD
	COR+igrfbwU5XNQ6OdjqnyiiuO2390Kao8mV/VFAuicdsTpmCc7LQQ6QNX+5jJjRYgpWZCQMB3g
	7zg==
X-Google-Smtp-Source: AGHT+IF+pktbKA5ERhhI9ACh0DvxCWS2IxmYMfxElb+yYd48b/kvPmDGRCometGGY/kYmjTT7Oe1ih0b4Y0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6556:0:b0:5dc:1b0a:48e1 with SMTP id
 a22-20020a656556000000b005dc1b0a48e1mr1095pgw.1.1714068885143; Thu, 25 Apr
 2024 11:14:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 11:14:21 -0700
In-Reply-To: <20240425181422.3250947-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425181422.3250947-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425181422.3250947-10-seanjc@google.com>
Subject: [PATCH 09/10] KVM: x86: Suppress failures on userspace access to
 advertised, unsupported MSRs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Extend KVM's suppression of failures due to a userspace access to an
unsupported, but advertised as a "to save" MSR to all MSRs, not just those
that happen to reach the default case statements in kvm_get_msr_common()
and kvm_set_msr_common().  KVM's soon-to-be-established ABI is that if an
MSR is advertised to userspace, then userspace is allowed to read the MSR,
and write back the value that was read, i.e. why an MSR is unsupported
doesn't change KVM's ABI.

Practically speaking, this is very nearly a nop, as the only other paths
that return KVM_MSR_RET_UNSUPPORTED are {svm,vmx}_get_feature_msr(), and
it's unlikely, though not impossible, that userspace is using KVM_GET_MSRS
on unsupported MSRs.

The primary goal of moving the suppression to common code is to allow
returning KVM_MSR_RET_UNSUPPORTED as appropriate throughout KVM, without
having to manually handle the "is userspace accessing an advertised"
waiver.  I.e. this will allow formalizing KVM's ABI without incurring a
high maintenance cost.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04a5ae853774..4c91189342ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -527,6 +527,15 @@ static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
 	if (ret != KVM_MSR_RET_UNSUPPORTED)
 		return ret;
 
+	/*
+	 * Userspace is allowed to read MSRs, and write '0' to MSRs, that KVM
+	 * reports as to-be-saved, even if an MSR isn't fully supported.
+	 * Simply check that @data is '0', which covers both the write '0' case
+	 * and all reads (in which case @data is zeroed on failure; see above).
+	 */
+	if (host_initiated && !*data && kvm_is_msr_to_save(msr))
+		return 0;
+
 	if (!ignore_msrs) {
 		kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
 				      op, msr, *data);
@@ -4163,14 +4172,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 
-		/*
-		 * Userspace is allowed to write '0' to MSRs that KVM reports
-		 * as to-be-saved, even if an MSRs isn't fully supported.
-		 */
-		if (msr_info->host_initiated && !data &&
-		    kvm_is_msr_to_save(msr))
-			break;
-
 		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
@@ -4522,16 +4523,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 
-		/*
-		 * Userspace is allowed to read MSRs that KVM reports as
-		 * to-be-saved, even if an MSR isn't fully supported.
-		 */
-		if (msr_info->host_initiated &&
-		    kvm_is_msr_to_save(msr_info->index)) {
-			msr_info->data = 0;
-			break;
-		}
-
 		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
-- 
2.44.0.769.g3c40516874-goog


