Return-Path: <kvm+bounces-32637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5496B9DB072
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A7C4281862
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F1E661FDF;
	Thu, 28 Nov 2024 00:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RLmFgQLO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ACE339A8
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755359; cv=none; b=lULys8ORlCHgBbYm8wX61iazHcywFR17UVCTWOb/GTtaYl649gpvwcf7gHHZzNQ/x0LmBIQTkfGQ0IAMvpCpsmK9iriYWuc0QPY+NLbE+w3vdqZAbU3vx9iFGm724BmRqxFFatt4Fd276cg+iRTJS2JeFA8VhmY2lngXQLFDNyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755359; c=relaxed/simple;
	bh=WNgn4lu1ApV1cGqCgEdQ8UELTIdxvWrpSXPjrrKh+zU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BLXoD7vF5BWLQRdFkuJDzd3drgPEgioahmwqzLG+zj3sqiee77mlvCrwLJJQqUr3r2pqY42GHsQ/56WhkJng/7ffzuFPcBTwr/bxXKeJQFsERwhHAVnZI+BLf2J94mursg9ABlpQvnGdYVlXN2b/EMlQojPiiyZnmxsVOBTwaP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RLmFgQLO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea873d84edso279975a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755357; x=1733360157; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VnpBHLYkUch4fOHU4hkMVn/ClZoihkAVUxnB9ZaI9Pw=;
        b=RLmFgQLOx1T+u6XwqgMuR4WV6xZYBL7N1RNTWPkNLK6+3EK9CbRxbQnQ7h/GbLX/g+
         DFjgd+VE/Uaf/2C+DEXgI9HniueFRX0267E+uP+5Ny+WHCnzCalSu//K7PjYzSc70nE+
         t6l+1SS9FiX36Xt/4JaIpcrdfEkI3LxiT4SjCDIGt4/kBSdAPuwK3n9fzQX6BzQnn+DI
         zZhW1oKDTepUIrAurkqLmtChy8l1M1LnFaLkvAFs0Efm1LjACQTzRNAW3+k0kmBH64Il
         hi4OVR6L5am0FmrYMhDiu74ILHrqjxllrxnTojspjHXxsvNdYVPq7SnL4fmqo9Ad0pis
         j5bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755357; x=1733360157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VnpBHLYkUch4fOHU4hkMVn/ClZoihkAVUxnB9ZaI9Pw=;
        b=S+wQbDcNMzWRxo4hfwxotTxSO051bn+M0IISXvQfXJP5XPdyMxs79aBiRbTmWG7TMn
         E6u7x5NkGiQSkpdmWH4fNzRPLDya3d1XuS5iJFVEt9g93rVVvY3x+5StgC3gM62Z2nPi
         DPk2PEQbNzbWPWEYbTUNqRvwgw7E3/P4g61jGqHxP1+ZhmhoRDBXbl+U8kmGvZXxUF4P
         YELsoOEwO6ZlRO9MRG0bXPE/9ARhZHPAvLNshzPTVJ12XTjoD62uap4Da8SZinyU1PeO
         eNkEmmXJRifqO6HEugcYvh5zpcasywj5vOlVfWAGWbKL4Ga4z+kdqrZVo7Dy9FwlAyPa
         1HPw==
X-Forwarded-Encrypted: i=1; AJvYcCUSlmsCQsbkk6ADnnTx8Zvh0rTWCbhICHNqFfkaIPI9tZad6JXM+ELO7RHQNmMZ8WTdqY8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8b3CXiqfnSav2n0iDNic5pA6pEYnPH3QcSxI3j8IlNNKoo+w7
	lW8DkrsmwZMQgFPcqaMGW67YKeftyuqdqcWaSxQ1kILVtcAciCMJUbdVhWC6I8TwHET2USii/nT
	OUA==
X-Google-Smtp-Source: AGHT+IGNjVu9IbM8M8x4FgAf0ptLY31wfGw0nWSewj8xLv7iHu7ExU2Pbfe7utzxkDM6gVPdI3CzS8OquPA=
X-Received: from pjbsc10.prod.google.com ([2002:a17:90b:510a:b0:2ea:d2de:f7ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:fe06:b0:2ea:83a0:4798
 with SMTP id 98e67ed59e1d1-2ee08e9f0f7mr7211038a91.3.1732755357079; Wed, 27
 Nov 2024 16:55:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:35 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-5-seanjc@google.com>
Subject: [PATCH v4 04/16] KVM: selftests: Check for a potential unhandled
 exception iff KVM_RUN succeeded
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Don't check for an unhandled exception if KVM_RUN failed, e.g. if it
returned errno=EFAULT, as reporting unhandled exceptions is done via a
ucall, i.e. requires KVM_RUN to exit cleanly.  Theoretically, checking
for a ucall on a failed KVM_RUN could get a false positive, e.g. if there
were stale data in vcpu->run from a previous exit.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 480e3a40d197..33fefeb3ca44 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1648,7 +1648,8 @@ int _vcpu_run(struct kvm_vcpu *vcpu)
 		rc = __vcpu_run(vcpu);
 	} while (rc == -1 && errno == EINTR);
 
-	assert_on_unhandled_exception(vcpu);
+	if (!rc)
+		assert_on_unhandled_exception(vcpu);
 
 	return rc;
 }
-- 
2.47.0.338.g60cca15819-goog


