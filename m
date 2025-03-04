Return-Path: <kvm+bounces-39950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B281A4D106
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 02:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28B6E176FC8
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 01:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792621C84D2;
	Tue,  4 Mar 2025 01:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TdqeXcPA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB3F54769
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 01:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741052022; cv=none; b=B7whhxFJhwFNNwz0iaSp2zf6sBng3kryR7OgIbmQQrmjy9SjtYeTI2Cd2wFPbLzmcQAS3WB+Ffecdo2nfxz3UDAwSsqu7E+RRDEI5Aa6MwBOfaPUEZWz880f6luRGN5KkpmMHKXMRIjDTfBIuMCLzoMubbAG3IhZbR0k1LdDfdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741052022; c=relaxed/simple;
	bh=58+GQHt2qduafXX+TgqOXjvPQXwK8jv6jk++1FQYVOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mg0ca8oBs5HtXSU7oxglnbt0hJ5ijgGJ5LLeAB/MDL6Q6I36l4B8CNnN4L9qQfTMI/dBS56wOo8a3QC8uNZQa1tgb7v3lYk7117H8L7UAgClVKtaApJMjG8p3Z+2/EKvCsiFtJTvGSSIUmzP5hYzUSuO7V8X8p/b+eE46Jbm3m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TdqeXcPA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2feb019b13aso14545817a91.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 17:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741052020; x=1741656820; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=V2gfYfzd7JIdYMe13GtAqBNZ71NvSFhhiOtC85P36nM=;
        b=TdqeXcPA1URcMscMukMgr4/hWRUQfyQg+Bn7CZQSWwwGo14bjpgexm17I074+TkznE
         HFiS6yBDvEPs2IZ7Zqdr2kJNt57uVztPl6LQ4fWNX2Pvi4+i0OdK0IBT+NsD6MtkqmfS
         5XI2+WjDNQkrTYjzEsALrMQjCqyRFkrF0W+wHexTCNThIks7ZJIeCFNGRfYysm9bq/RC
         LcqNbPkX0NbH2ese/aphrpXm3pIFRvH4luZOA843nG3Ye6D9scIH6jhDupvTwqCo15uV
         D6hM9F3QGUiGnzHmea0nXU2ed/XKaMQuOO6d8+4w9w+SllQ4Z3bFSaWl7+v3EkZU4aE/
         8AlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741052020; x=1741656820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V2gfYfzd7JIdYMe13GtAqBNZ71NvSFhhiOtC85P36nM=;
        b=nS7YA4U1+OOqj0myC3h3jrJpxVoAj2ZxUFfosHOXnxC7+4o7UkOdVFRu4IMpz3y8LC
         GNJQE6cVMUc3VmTjl8KpPIijDZymojoMtIBarfcrVLxv2G6gqnhTSJA9Xvxtu/jWCxYd
         AOzCML8SIcDDac3M3TcpbBywGPm0bYNBcW8WKB93DNJSoKZqb7hW4XGmRYOLc3FezXd7
         NYACdq8OIBbnx5PHLMMovHnyVtFWT7SdHDZjAcHy+yszjxikXkZ/po4szrGmyYCIGNju
         RU7M3puEWT288UZwC0fDqt62kXrKmJfMKQJftZ0SnqjkMeZZXFQJJ71kwCWshoZLO1G2
         jlHQ==
X-Gm-Message-State: AOJu0YxSp0rH34IQHFomdEAcUizhgqI6OLANJSyLZGMvuqnYY4bANWDE
	epUIzRuhb1V7TnFQM+QInEbZUnW9a2CQiVIJ9PhesD6//gqPXLlyN/C04BHXvmod8yz1tjwqyY3
	urQ==
X-Google-Smtp-Source: AGHT+IEC6xZmbOA1zeqtVe50RifjBGDvKSe7UtTePMqhcFtWNi+tt3qWgCKnd/Zv8ZReH+DmFDKZv1kNGFA=
X-Received: from pjbee14.prod.google.com ([2002:a17:90a:fc4e:b0:2ea:5469:76c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384c:b0:2fe:8694:3956
 with SMTP id 98e67ed59e1d1-2febab787d6mr27249929a91.16.1741052020443; Mon, 03
 Mar 2025 17:33:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  3 Mar 2025 17:33:33 -0800
In-Reply-To: <20250304013335.4155703-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304013335.4155703-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304013335.4155703-2-seanjc@google.com>
Subject: [PATCH v5 1/3] KVM: x86: Isolate edge vs. level check in userspace
 I/O APIC route scanning
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, xuyun <xuyun_xy.xy@linux.alibaba.com>, 
	weizijie <zijie.wei@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

Extract and isolate the trigger mode check in kvm_scan_ioapic_routes() in
anticipation of moving destination matching logic to a common helper (for
userspace vs. in-kernel I/O APIC emulation).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq_comm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8136695f7b96..866f84392797 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -424,10 +424,12 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 
 			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
 
-			if (irq.trig_mode &&
-			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
-						 irq.dest_id, irq.dest_mode) ||
-			     kvm_apic_pending_eoi(vcpu, irq.vector)))
+			if (!irq.trig_mode)
+				continue;
+
+			if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
+						irq.dest_id, irq.dest_mode) ||
+			     kvm_apic_pending_eoi(vcpu, irq.vector))
 				__set_bit(irq.vector, ioapic_handled_vectors);
 		}
 	}
-- 
2.48.1.711.g2feabab25a-goog


