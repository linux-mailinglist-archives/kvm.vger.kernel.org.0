Return-Path: <kvm+bounces-71558-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLPcGA33nGlkMQQAu9opvQ
	(envelope-from <kvm+bounces-71558-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:55:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D330C180562
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 860613101E3F
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E59239E9B;
	Tue, 24 Feb 2026 00:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4b5kv0ng"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C4823815D
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894511; cv=none; b=fBTAgKb7K3ow5C8OCRZvsC7lYOMpTVKp3o76DAgdKZ4AepDcc7J0gFxkmgZihvWBGjPcP/ZfECCkdBFZEDWb1cfxS4jGXvf3l2uTTNOacKGsOt1urGVd7UojGWsWA9mRm5R45nxQOCupd8zlyEepP+tGqVpTceKMGrgpqkTTdf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894511; c=relaxed/simple;
	bh=hlc3eDYC5CtCx3ysabEqZdPhL0pvMkg0uv2uuQC4boY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rlVnzyT9aKyDWtTebH1T/tg3fq9NMiXt747lDCSstyz1oYXp8BNNY3vvLvxxGiw1FMgswSS2Y1sOmBLRGNUNz8XvPzXYa0wKzXfW9/zzYRe9swW5tycXfrfl78GJEW0/pwt4kweyezyV5ptbmcWjATClTtPVQ/spI6kfQTRFMNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4b5kv0ng; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ad7e454f38so211316455ad.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771894509; x=1772499309; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oa3pg7vK4S+HyEZf4ju0uKesK2HwwrvHmekpcG0SoGY=;
        b=4b5kv0ng7PvyzYnPE3wrKCdXMc0Ytu3i7JgrNxgHDoU6ZtimAIOWYiAoLcBM/ljiC1
         P7S/XtTU980au6E8+dgKlcLkeXDsNSJuu6zcJMOOQVq/qx0LfuRnQbn55QbkXPqzRXxL
         kyUTSNWXaEyXKwqmELHqHcjEZjc/gusUohhO5Blq9Xc1G6OvDUAHUlvrNqJfpWyBmStE
         mr4vD9Pp0XU3ni5uIYB1KqUzalhDhgVITk+fsJQs6uT1ylssCg7OxnlofwTnHCoJuA94
         ++T6M9rfkUgpJP1+Gr1iHJU6i9x67Wnc4gPVVuHsK9rQLwHAYz+OkPZquNSBfcEXIOq5
         7WxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771894509; x=1772499309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oa3pg7vK4S+HyEZf4ju0uKesK2HwwrvHmekpcG0SoGY=;
        b=UP4yGR4NUNprV0el6D9PgwXYtO2Fu4c6R9s5/wmAOMZUkeQdKZB47QGhNl4G7x6uGQ
         tIcpekE7xjkb7H7mY8v8BQpV9L9sCfVNEBm2WSJg4/HotT4hMlFDculADhMT8WkjWRIS
         2eSE/Pj3h2BThUMNYuzbf2uMfDIunWWP4a9FH0Z3Er9fVp0WmGN+ZbqxF5U37uf/vud1
         PRtNh0aT8lFvMmQ4sG9fmXMlJVuj9P4IeJ1dJiKL+uC7NfWI5i818yOxaAShtqT+WVNW
         XD3cAWwFSH1iUilDLD1bduvTthUKqtEIeRndOoMG9by4Xp3GjRnd6FaHi09ikPa8NIfq
         pWvA==
X-Forwarded-Encrypted: i=1; AJvYcCUUqTzdNXc6S38jAlBvbLWMUkRgahrGqDZa1H5hXgyWVlZv+PjQKSy+3TGhO8cX8GMksTo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIdov68AxVbM0Rygta7qGvNOrl/AjwVZBSyvQLAZ9CIfycCI4j
	TvhMNkK5H5e6rf+6Q60SEHpMDtPZJn/30zwTDqFLlwJtVxZoaq/wdtIoluVPaC6mw7VDvGVbSej
	D8RAd3UWLHPwNlA==
X-Received: from plblb15.prod.google.com ([2002:a17:902:fa4f:b0:2a9:4c70:1b4b])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f68a:b0:2a9:62ce:1c18 with SMTP id d9443c01a7336-2ad74449b3emr95053825ad.14.1771894509056;
 Mon, 23 Feb 2026 16:55:09 -0800 (PST)
Date: Mon, 23 Feb 2026 16:54:39 -0800
In-Reply-To: <20260224005500.1471972-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224005500.1471972-2-jmattson@google.com>
Subject: [PATCH v5 01/10] KVM: x86: SVM: Remove vmcb_is_dirty()
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71558-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D330C180562
X-Rspamd-Action: no action

After commit dd26d1b5d6ed ("KVM: nSVM: Cache all used fields from VMCB12"),
vmcb_is_dirty() has no callers. Remove the function.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0bb93879abfe..8f9e6a39659c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -434,11 +434,6 @@ static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
 	vmcb->control.clean &= ~(1 << bit);
 }
 
-static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
-{
-        return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
-}
-
 static inline bool vmcb12_is_dirty(struct vmcb_ctrl_area_cached *control, int bit)
 {
 	return !test_bit(bit, (unsigned long *)&control->clean);
-- 
2.53.0.371.g1d285c8824-goog


