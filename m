Return-Path: <kvm+bounces-26579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8875975BED
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA1DD284192
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5201A1BCA1E;
	Wed, 11 Sep 2024 20:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="laorYpjR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EB91BC07E
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087354; cv=none; b=jebJHSU/9xDcPDvZjlE5hBfM7TyqUwSUWCm2EzaLoCnT/i8QsjmmHQ1nVF8mmNuw2xjYg8KxaVQ5oU7XGwHBsZ54CCQ/Dkr3HeagGCyZNi5T+tivd9vkJqmAxVv0he2SpjJOmDjPlWMRyihSlyMvbTulWHGhr2ehoOevnpsqJ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087354; c=relaxed/simple;
	bh=hbb0RaWzaTd3JfZQZX9GdrY3DUCQafK7uAfY73KOAY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rbnOmgSynBmQB6ph6Gj1CUrV8h0qFbIhRq0ZQqsK1Ist2pYGSo6Nrjkn1s7jILzItBwz8IyPqyZGnMNZMxVuRR00Vh+AcDy5xutb71zTUiz9b7mxmMpkc2Yl6JOPHTKwnXe7u0XY7mVTmjmY7ZrQjD8JRyhNEb/OVtNEuIqMv1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=laorYpjR; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1d3255f852so901070276.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087351; x=1726692151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQRYVtp40gN2JN3r5ECO8yPdv4xFpWyP5ZtXJGFNMpg=;
        b=laorYpjROjDj9OQcJFqIYfrpyeuZVvMBvuAlQE9vO5E3PwwQrWfqeRl9CmvpOsfDAF
         oBZT4JeOv9AjsJ83/LFI5hY01ft2H8z8/pyU5KJke0GvjpIjoXPn7TL+R0crzMymOchj
         KZnT75pxrgCyILgAjoNgJ/xhFYD1GpHl3dJ9gGQptoCkmXw7jBTGROI0/PI1v9iAtq91
         EWc6eqHAB9gujZTu64gmS7pzs01+/Nowqwn06VzSRJUhoGlUcz1jff9vhx7/zlhNRPxY
         KBPb0RwAyH/mu6UPp42je5y/JWjGyjMzPg1wzZoXdOpeE4sjIYULZGBqX2dUpXkf7Tyx
         oCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087351; x=1726692151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZQRYVtp40gN2JN3r5ECO8yPdv4xFpWyP5ZtXJGFNMpg=;
        b=S0VgrkB0jOP2s64K0HUuxQFrr+i8wDto+Rb9ITpZRDaSI8/P5cAoGNSp5xI2Qe3Try
         EzjK4Zda63dE/n/VUaYCf5VKYb95LKjneIy0QlRAgcLxRgRGFqI4encMFoEF6I4Z655s
         Ukn7xEDBsGkay+5hzDV0N8zdRTwa9XIBK4rm6pG4gOQyyW9Khvwg/S03/+6CW4NftkXr
         NVLuJWprUZKaO7Rgkf0HoDlZ4NCED5k+qD7ulmmameftp+t4Pf0bOhEMJ4wcfCDggF2R
         Jhg22axEl+Gp/yihgYw1d+3cgTBkZCTi27jldcOBdFcFIz7VtieIXmx6CePB7B9RwoJX
         4fOw==
X-Forwarded-Encrypted: i=1; AJvYcCVOklYLpoAWpCOZsvcUJ+DX8K7IjUIW46O0HSq2n76cdoWRMZiFElVvmh1GExZMPECq09c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx00tj5Zyul5krird9kYiLtWAYjcy/H5ok0p769u9CAH62aIhLA
	LVrVXgwFsL5/mMyXTloSe9n8N/p/ETMrAWeRA2j9ErEkadazU7BDdhMUULddr7nlWnPrcdX/PjP
	6pw==
X-Google-Smtp-Source: AGHT+IH8ZQwfCbzagdZgU+EpISSX/A630EuGAq7pLp9hJDXsMNgEZzJ88I5801BwyQ8RRGJvBOpit5rNgP4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c711:0:b0:e0b:af9b:fb79 with SMTP id
 3f1490d57ef6-e1d9dbc1dc5mr2910276.3.1726087350958; Wed, 11 Sep 2024 13:42:30
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:50 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-6-seanjc@google.com>
Subject: [PATCH v2 05/13] KVM: selftests: Check for a potential unhandled
 exception iff KVM_RUN succeeded
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't check for an unhandled exception if KVM_RUN failed, e.g. if it
returned errno=EFAULT, as reporting unhandled exceptions is done via a
ucall, i.e. requires KVM_RUN to exit cleanly.  Theoretically, checking
for a ucall on a failed KVM_RUN could get a false positive, e.g. if there
were stale data in vcpu->run from a previous exit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 56b170b725b3..0e25011d9b51 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1719,7 +1719,8 @@ int _vcpu_run(struct kvm_vcpu *vcpu)
 		rc = __vcpu_run(vcpu);
 	} while (rc == -1 && errno == EINTR);
 
-	assert_on_unhandled_exception(vcpu);
+	if (!rc)
+		assert_on_unhandled_exception(vcpu);
 
 	return rc;
 }
-- 
2.46.0.598.g6f2099f65c-goog


