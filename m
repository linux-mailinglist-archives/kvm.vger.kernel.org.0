Return-Path: <kvm+bounces-69196-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iAdHM8pKeGkKpQEAu9opvQ
	(envelope-from <kvm+bounces-69196-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:19:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ECCB900AA
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:19:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA1783058539
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B9C329C71;
	Tue, 27 Jan 2026 05:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H+sQlNOc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KZBK2svM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F469242925
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491040; cv=none; b=oM8wTP0OJudKIkbhe3Pc5lMj2t0BnVoTiJifouRZE5JSUC1JYkGar7FkNG8G34POrUyM9x20l3thIPLKOJrigSLLkC0bmKXjyURcP2mf2JbWb/AsVE+rg1GVgKFhO8oLM3wmxgA+8EiVytnWvYdDKPAEbheGc0d2AuULpAZeeN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491040; c=relaxed/simple;
	bh=WChw+ew2J0WyvNpKc0setuYs06aXyJEX0ihYPitTR+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9yOyvj/3V/9NXe1rQ+qkTV947O+LfE3yRHBWRrvamSjZpM4COwXMjihC9Z8Dvtv/6B67TGEryvrxiV4oXBR0yFtNRckohC5lzc16J54hsNPcqVdVyHpKYsH09VGtaEMYObxNsmdSzb15VMpp31Jva9CC5vCtT2MXILx/NUQWII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H+sQlNOc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KZBK2svM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dYjm+cwYmX//ogmaWGW851MLQ4JMvXhT/HU+YBIFrsE=;
	b=H+sQlNOctpZMbAHtA3n5zG4D55IuFALgXrohZxsV+v8GzlM9B2PZNKSwVCLXL+2/vlzbRL
	bodoasD/e1mP2jGwGyTHrInCeSdWd44FT0gdd436AxudWuR22fDzrSUk1qTg+oC6Q8qsFR
	d9tvBp+1rUGJWhnQ2U7QF09V6bCgEVc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-KjRhpaRgMBWVBxkCd7DQWA-1; Tue, 27 Jan 2026 00:17:16 -0500
X-MC-Unique: KjRhpaRgMBWVBxkCd7DQWA-1
X-Mimecast-MFC-AGG-ID: KjRhpaRgMBWVBxkCd7DQWA_1769491036
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34abd303b4aso691298a91.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491035; x=1770095835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYjm+cwYmX//ogmaWGW851MLQ4JMvXhT/HU+YBIFrsE=;
        b=KZBK2svM2PfC2GhdjdH0KfaBH6fhXEsH4sLzj3Vg8r9lC1yBWGicA7Q/ui3IfQlvZO
         93OmvV5CfK3Wun/z/e53ayTl5ARWcdTWL6Rid3WTbSR3bvtcxPTunzw5i0VD10gB+oB0
         8Qa7MGonbgFYf/CjxS/5XX8G+gsQyRKSKALMdZPXsUE+DGVKXpF7V9iiBBC5777qHJHa
         cBWT9lZb7/rc8uVgN/+twwQvHEUFvFymeIX44dSUn6t0Xvsgk51M8sxVbatp70Sklhbr
         +uYe5BvuVRsHGnCGKOqK9fMe3zKgGx49a+hKDm1tVi8kXOkbDK+7SRMEu2J38WdMfJgW
         +d9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491035; x=1770095835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dYjm+cwYmX//ogmaWGW851MLQ4JMvXhT/HU+YBIFrsE=;
        b=mAD5TYFrgST88vKgbgED0+53Ee9V8/42j9mxxLvi04wuqm5VQkhiVn3MHVFKBQY/Zr
         aD7Lco8cadhvMYRnDRUlErF0Syn1Ih2OXKS5XNVvtt8en0+IIeXB4bIv/JJiVk0yI/Dc
         HTrwaa9i/UhCn4bgokoVU4PTwe43aOJYdLnqgfwuBukJUc+ZDO7B772fWlIGRoJT8Yoy
         knSjVYAYp8fkxv1qJZney9ticemmAHTIFTJZDKP9+2CmKooIMzjZOwRfpPJ4vrAf6hAJ
         +LN578qjb4yrkh4ujbj0eySdjqQLQOESJ/kYzM94VxKIe2DAbfOtE0hsDHtxitpoogDY
         fWCA==
X-Forwarded-Encrypted: i=1; AJvYcCX+lCmH+sasBiYqJtIBW1iNhwfCt2lP+E+7yWBxPp1ysL1ZurOybKZEjRFACHaMT7IUbso=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVDkQXaxA5tt2IbautMVvT/VjR9JaxtGtk1Hadi+hSsLJKnyzO
	r0KgSbG51Tx9W02ktXdnshhA+VTDZAmF+5kskgEZqRFdSs/zDwbApM3S43FUSuGH9bnVC1/UVUh
	Vxqiaqxe64A3PRV+gtfDmm5r1J9i6CFfG2ax7cZ53QHezxZHia4rhoA==
X-Gm-Gg: AZuq6aI88l2yhSi/qq1rrSL6zngI/MPpvvx6M1gcX80m8ezHWNu7tKhYvGMX2Ldv1wi
	1Oq1ntUXzxpfrKd5jnOMvzmYYKvZ5PlrCiBdpcMgynbRHyOdFWTfL/F++xcvZiUN1igLXg0jDzl
	BTyjJfGjh60r48krqNkW7vMsy8tr5FO5AZSI/VXW5QnlBb8QDt8Yl0v8ovLtHbC9ERTY//78bp9
	5wvvL596VAKsYcYofdI4/oBNCDjGjD0/o6Yp/rzB8YrWy9HNs7CgulDD++68q2WKgjnHlVYoTRU
	6FhHvsLn9N6tWYbrxcQ4aR7lBtKAgHjPSzevrVaXiM/leH1yovNmNzJcuo54YkbIDELI8jSfTWT
	1AQ9OFgJniMCd4D2AgSbv+wCo9NeOmeBA0AmWiW7kkw==
X-Received: by 2002:a17:90a:d603:b0:34a:b4a2:f0c8 with SMTP id 98e67ed59e1d1-353feda7c73mr651962a91.30.1769491035652;
        Mon, 26 Jan 2026 21:17:15 -0800 (PST)
X-Received: by 2002:a17:90a:d603:b0:34a:b4a2:f0c8 with SMTP id 98e67ed59e1d1-353feda7c73mr651949a91.30.1769491035342;
        Mon, 26 Jan 2026 21:17:15 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:15 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 13/33] kvm/i386: reload firmware for confidential guest reset
Date: Tue, 27 Jan 2026 10:45:41 +0530
Message-ID: <20260127051612.219475-14-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
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
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69196-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6ECCB900AA
X-Rspamd-Action: no action

When IGVM is not being used by the confidential guest, the guest firmware has
to be reloaded explictly again into memory. This is because, the memory into
which the firmware was loaded before reset was encrypted and is thus lost
upon reset. When IGVM is used, it is expected that the IGVM will contain the
guest firmware and the execution of the IGVM directives will set up the guest
firmware memory.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e27ccff7a6..38193ea845 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3282,7 +3282,14 @@ int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
 
     if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
         X86MachineState *x86ms = X86_MACHINE(ms);
-
+        /*
+         * For confidential guests, reload bios ROM if IGVM is not specified.
+         * If an IGVM file is specified then the firmware must be provided
+         * in the IGVM file.
+         */
+        if (ms->cgs && !x86ms->igvm) {
+                x86_bios_rom_reload(x86ms);
+        }
         if (x86_machine_is_smm_enabled(x86ms)) {
             memory_listener_register(&smram_listener.listener,
                                      &smram_address_space);
-- 
2.42.0


