Return-Path: <kvm+bounces-17663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E41028C8B5F
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F35B286D95
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D340B1428E9;
	Fri, 17 May 2024 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ddiUDC9P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E7B1422D5
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967607; cv=none; b=k7eZEo27SGbbENdo0N89uTpZJbAxgUIExkftNJAIUN+634uSzFbu8zIAJkKDrJQnro4noQTpnhKjxneU+1zSHUtxUDRES3REDs6wz/FMqhKS9JNPREIJLdrySLpBdc+WNqm0sPUI4wQV2SiBEUAnisdbchYHvc6fMiw5zKSqqUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967607; c=relaxed/simple;
	bh=zzIqDBRAgEIRt3fg5FrSfGxYl1fjerG/V7tHwfIOdIE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NWVMXAWTv6bfd3+7zaCIK+uuoAtmZtO+pyaVNpI5533i1iRpdt89Wu1+/O0jhK2+7sD3lVhytetbonzNSVbJdAcnUfWQK3SsCRJuNjcFQKcnXQVbXAYnEGSqf/UWuF6eGBCPXs807tq8H1ArLtsUlncE8QwMUaC3XVPAWRG+eLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ddiUDC9P; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso7570995a12.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967605; x=1716572405; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/QhdGtxhJBxvqCSUNKLB6DvJjtt7mVPP3auKAb2NG/M=;
        b=ddiUDC9PuTC84wjc1Fi4CgPrVe29wdneoAG0CLbUjR1SQc7ufVFlm2QSIfBwWBXtQx
         SF++3fzsjJxZwJFtyNNPtIItaXvkL4NgXiPdOkymfY7jtLHBXTmeKuSN6xQ2vcYFXzGW
         shYU9jG4GRHOz/qaO8UK+eIuTsGs2Ru1rKV75A9EalLInml4mQWmIDQyD43+rmCfwkkC
         +JjUy9+daIOm3qnRg4f9ABYaoLuZMpxXfWIg+/pd3yzlsc+obpunYjwn71jxOdMafPV4
         zQMwyi+hYQZwVEHVx738VTf7y5ZjyLwVInbXogIjHiGT9jBOUrTkct5v1TDASp8622y9
         Vm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967605; x=1716572405;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/QhdGtxhJBxvqCSUNKLB6DvJjtt7mVPP3auKAb2NG/M=;
        b=v38qTvuaAKXl3WmzYD53Mh2GN0VQy4oWyZeW6A3vB1o9aH3S0C59KFm6sTu4MX2ECw
         zdrxGq3C8JKrMPNCNzc6rO5JmcuehICX8MqO6y7S4LDA8iCtMt7+ZPnzJ/kYAfkvIYfz
         CLRhLIsd0C6DxWZibutk2Jvvys+ndeWqRzD/gCHM/4uZpeqecMCRC1mTE1PMfIvhjG7y
         e+3rd3gTCE3VzFOhHLsCBWqNCgCE+8JS6GS4Sp3wPDQYVocdOn8HGdNbWKDxXTwuWLiK
         4hSIc0CvrNbZpGBgxZg8oBRdB5xtAlpsjv/Cqy+x5J3SghtNbHp75+PJS7QoC9G6zUpW
         Lm3w==
X-Gm-Message-State: AOJu0YxX3TW77df03CHGDmqNmIhoqxA4ezweFZOVlCJzmda05jzh3mF5
	glpliUhGNYwD7/z+eo3oHuJCyQdUsDgFXZ3HicAvbJTi6j/fUR7CsXhTDIyZy9sUx7hA0iAU2V3
	0Hw==
X-Google-Smtp-Source: AGHT+IGXqcyVYyfsrhvREnbdq6WGI4rUGu/X6D5dsKbIh4G7tVICZ2/7A3biOpPmKuH5H/rOeO18jjJySrY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:69a:b0:5f4:246c:1406 with SMTP id
 41be03b00d2f7-6331ae42ab2mr99526a12.3.1715967604889; Fri, 17 May 2024
 10:40:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:48 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-12-seanjc@google.com>
Subject: [PATCH v2 11/49] KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS after
 vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Reject KVM_CAP_X86_DISABLE_EXITS if vCPUs have been created, as disabling
PAUSE/MWAIT/HLT exits after vCPUs have been created is broken and useless,
e.g. except for PAUSE on SVM, the relevant intercepts aren't updated after
vCPU creation.  vCPUs may also end up with an inconsistent configuration
if exits are disabled between creation of multiple vCPUs.

Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
Link: https://lore.kernel.org/all/9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com
Link: https://lore.kernel.org/all/20230121020738.2973-2-kechenl@nvidia.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 1 +
 arch/x86/kvm/x86.c             | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6ab8b5b7c64e..884846282d06 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7645,6 +7645,7 @@ branch to guests' 0x200 interrupt vector.
 :Architectures: x86
 :Parameters: args[0] defines which exits are disabled
 :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
+          or if any vCPUs have already been created
 
 Valid bits in args[0] are::
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bb34891d2f0a..4cb0c150a2f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6568,6 +6568,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
 			break;
 
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus)
+			goto disable_exits_unlock;
+
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
 			kvm->arch.pause_in_guest = true;
 
@@ -6589,6 +6593,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 
 		r = 0;
+disable_exits_unlock:
+		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
 		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
-- 
2.45.0.215.g3402c0e53f-goog


