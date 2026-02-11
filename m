Return-Path: <kvm+bounces-70835-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kDlSOelajGnelgAAu9opvQ
	(envelope-from <kvm+bounces-70835-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 11:33:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89275123699
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 11:33:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 647F430CF883
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 10:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31520369992;
	Wed, 11 Feb 2026 10:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CTJeW0Z6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200C9368277
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 10:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770805780; cv=none; b=WwhDskErZRlLbFnC57VCw+9VxBDVA24V4Zz6sqmQpj8zTaFOvYUWR3sZsn3Z9bh9keJthes3pY9v0zKVKQ5IfIVRY6hzA52vFbQGn+fj8Wvpz+ScY8PoNQc2/+iqnjLxrr6wqPUZaKnpoj5QZAKOd7RL3BGS3X+AcNc9S232C+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770805780; c=relaxed/simple;
	bh=1S0vbWWfEtMQnQ4r362LGe95BBPV4Kq1mF/STZOwNTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0EdoSOWL8ARnILwSCZxYswelb8+ArcHfNODrN+XWVD/KTNTCOKcRvXS9QHcYH1e7oJ0mTG3onpVwCIt2YgQ3GvRAKRUsOY4mJOxb2vQrVRgbcDQzoiigl2I6nMDgit7LOZlVabDmg2kz/XYuTGZSKO3QFCnL3bwPny8bpRyQYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CTJeW0Z6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4806ce0f97bso15242845e9.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 02:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770805777; x=1771410577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UlBcH75gknJHop9Hj00ouZtc9jKb8tF6/1XoWoJNDVY=;
        b=CTJeW0Z69ZSZzMMdpuMo+t202UiN/2zHhyT1Ja5dshhDaK9IBHpuqx3gWoAKZvKqbf
         2GI/HQCeVL/nOBViH3GynK3i1Ru4WIu+NrWsPJTvEDmdByVvTsH3RYFoiVi55ESCQRCF
         q35K4HlNF4QOJFIuEZpVElVMS179WdsZOdh9Fkc6jDBGhXF1u9hHbUc2J8WUHH0lzuCL
         OWTuSaM7ackLZSNX/pzu4u0FXgS6zxWBrVtc/JPLBOfvprtEZu97xhqxWBCNxOlNvoJC
         nkdqXmb55hNQ+23it0Y/t+4/1PqwnHfw8ziiHxEHa6n1RdaWIB6MIo+Enclc/cknfYI1
         yiWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770805777; x=1771410577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UlBcH75gknJHop9Hj00ouZtc9jKb8tF6/1XoWoJNDVY=;
        b=mi2TSigZv996nYt8c0KUSdbsico1dia64I/zucP9SZz4eY1IqrxSF+aRchKMrRz1f+
         THXNCMvSLanXy6Pg+tdFU+Dcue18GMBHxNb2xn87bZ0z+nolQL5iTbdLfX5rcLc19pwf
         8grwuzpbqybtMUxjSThsK6nZpDS5GpQgKFbEoB4c1mHZWtBD0OckUwmwLhIbvQPdcPl8
         40i17XVleApuVlMJRjY8MVh9M8giDlXw4LP3Z14NS6YRpw5ieAIfIgk4LCA79vK75Fmf
         WW3iHdYy1dF4eNMjyd0SfGcYO4mk/MnuT84XC6Wan2UH4n/Jt99DGz2BAReRjmWRHs0o
         fXHQ==
X-Gm-Message-State: AOJu0YylemSu3rDSnErWsiw+8Y6FARmMdMv6hgWidKjdImb5ocumvvVe
	M1nUUmKV5GknIDRqp9l8m8VVH2iR5F2RhNS1PAMPaBv3XStpuxxU2WBA3X8V+O/f
X-Gm-Gg: AZuq6aLUYfYpRn/sZRgYxfEP51IMQRnIZtzpiFikZJr1g5smE8HD4AMtLpwxpt4REwp
	AvCjYu9eb9cYSG0rJ0ojsuzVuoHJTOvb1RBE+9YbbHJBhT5fSXsd29Q0wKV5Asivmxnh/zy3bPx
	wrKK5AyA3lS8kq5sDPnnU98FW42+XtCez19bKj3aF+qmlw83XzLIxQWIUM4Lu3S3I6essQt2+yB
	aeMlvPFHsGOrhNbJz+v6UlrztRNF2elSnwUePjztGYI4yenzq0OHN5xqe+DuhZ1uwhZ+kEU4csQ
	16PYOcLLYLkcLwQj5kg/pSYU7CIVXTdwkoaSx7+0Aa3xjrxUKGdRnLNfD5ejfN64fEjIdIxr31Q
	foL8QQYj49fZS7ljI/tCbuLTzShQZTwEhjNNFYQ22F/kH1ChCg6rtmWNcuId5nRPARwIDiIg+ne
	GSkmXSOULadG4O4kkU8d/Wln6j6JQsyFaEwK1IjXHfQ1jV3g/haOrZ9EY=
X-Received: by 2002:a05:600c:1388:b0:47b:e2a9:2bd7 with SMTP id 5b1f17b1804b1-48320216126mr225700155e9.19.1770805777015;
        Wed, 11 Feb 2026 02:29:37 -0800 (PST)
Received: from fedora ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d930902sm102500575e9.15.2026.02.11.02.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 02:29:36 -0800 (PST)
From: Uros Bizjak <ubizjak@gmail.com>
To: kvm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] KVM: VMX: Use ASM_INPUT_RM in __vmcs_writel
Date: Wed, 11 Feb 2026 11:28:50 +0100
Message-ID: <20260211102928.100944-2-ubizjak@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260211102928.100944-1-ubizjak@gmail.com>
References: <20260211102928.100944-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,google.com,redhat.com,kernel.org,alien8.de,linux.intel.com,zytor.com];
	TAGGED_FROM(0.00)[bounces-70835-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ubizjak@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,alien8.de:email,intel.com:email,zytor.com:email]
X-Rspamd-Queue-Id: 89275123699
X-Rspamd-Action: no action

Use the ASM_INPUT_RM macro for VMCS write operation in vmx_ops.h to
work around clang problems with "rm" asm constraint. clang seems to
always chose the memory input, while it is almost always the worst
choice.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kvm/vmx/vmx_ops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 1000d37f5b0c..81784befaaf4 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -221,7 +221,7 @@ fault:									\
 
 static __always_inline void __vmcs_writel(unsigned long field, unsigned long value)
 {
-	vmx_asm2(vmwrite, "r"(field), "rm"(value), field, value);
+	vmx_asm2(vmwrite, "r" (field), ASM_INPUT_RM (value), field, value);
 }
 
 static __always_inline void vmcs_write16(unsigned long field, u16 value)
-- 
2.53.0


