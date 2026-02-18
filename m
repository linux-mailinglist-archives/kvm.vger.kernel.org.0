Return-Path: <kvm+bounces-71230-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kBtxC+allWn4SwIAu9opvQ
	(envelope-from <kvm+bounces-71230-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A59C3155F87
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 98C8C3020EFF
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D695230DD37;
	Wed, 18 Feb 2026 11:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Drt5umbT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wp/dJ/Rm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088482FFDD5
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415011; cv=none; b=aPrdK77IEnNTVHvLhfPm2bOopnu4nkztZNhyiREYuWnnyap955ti/rpOoStP/z6Uk+sAGIfuCiKpjeDyTu9k0CRIj3nSoL0SnnZWbKfSkK0dBI9I/CqbK8tFiXxhmUu1M0SM2RwTKX83n5pa2cRs0VvznhVFhgPgBoK//ULazJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415011; c=relaxed/simple;
	bh=4B3wds6hvoQyIonmWIgsX+/muQGEIkRJlP1UYFDowNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/P+hRNNjW8PFQi+Ktr4km9iCVFJdZBk9UmCI1nRpVXdAIWCLTgKw4uZpuRrSfOH2rVyfkMDg0PnYpVq95G2oeORSbO3AZqr3V291gHsUA2ykZze3dDtKdje5PcugF8lIS6FZhVqFGo1roEZzTP49FLtpO0UY9T+S550YGOfhJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Drt5umbT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wp/dJ/Rm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtPGtZmrmBLpOcF7mZMrBE1yp80mmA78e975dk/A+AM=;
	b=Drt5umbTe0QCDG5NKhuqvA8EjTqMoqAxV7QrgpUZZWgbwrpzUhSlyi1WPLLGorrZd3UzR9
	UH7le/hU3PoknfrKQl+pVgXAYcnfCPp1D+1/7WQR7GuxyuEA8MGQLUxbnrSc1Do0B2F//H
	h1K0sompTlig/YBLaJhI5aqZvPDNTEI=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-adncvm_pOByu-LvxZEMkpg-1; Wed, 18 Feb 2026 06:43:27 -0500
X-MC-Unique: adncvm_pOByu-LvxZEMkpg-1
X-Mimecast-MFC-AGG-ID: adncvm_pOByu-LvxZEMkpg_1771415007
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a77040ede0so56799525ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415006; x=1772019806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtPGtZmrmBLpOcF7mZMrBE1yp80mmA78e975dk/A+AM=;
        b=Wp/dJ/Rms+exiAqCIjWsOwdW6oxP7Izv4aKRq7CgTA8v6j5ErDri2xoyqAsMHRUlXh
         p/Hjy5uvcUko6s7bPzICWREUQqm4Tr561CySBi08pLE6tUJSBsDVKkEMLwGvGi39/LRy
         qdDR2B0lj65Wu5KGrLFKkJiHbphXtvo7+JSu7k90sVSAHOXcZjATJFY0X7Gci6pROJ1e
         A0wnlOlt74dtYGTsCdDBYcRyEqIHM6mWeBu/td1Agwv1rK9ekg/zpzERyuoMY6l1mju6
         gdFzQWicWKwBehovQ/bWc6CKkcEdMmvc7IwhQmNOvvEpZwHhIgk+dhGJnSVjKUDy5FpU
         nUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415006; x=1772019806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xtPGtZmrmBLpOcF7mZMrBE1yp80mmA78e975dk/A+AM=;
        b=K+lcEZsglG0zHL8OS4LbEHQVe6ZNwOwAcTblLJdpAWNNSwqDIZWgsVtn4LsMT0BPD0
         JQqJUNch4iiDsM6Dds+UwBlc8Xj8JgSeBXH51v7Getzn+dMDkNccWOEUNDvIqIvl/LEn
         g9H2No54NrBifvQTD1hS8vI9FNcUaStdsbiW0RGZVngSdsh7etCwXW4ATxy6GtHoTcRw
         Z7NSB7y8X+yBfJo0Z77dS5DOwg4oAzZzKe4cqUqMJdKc7KOzqk57JIua8hsMKyGRXhCT
         ev3zCMj7c6TZfo8I196H/7NbyueNIdzjxNGM/6+KbAbngFfMZ5cjKgwstqKj2pZ8/1ti
         +LUA==
X-Forwarded-Encrypted: i=1; AJvYcCW1u2bYO16srjUdvjXwov+dihh4EpkWeo1osiYVqpPTBRuNsGaCqER2dKd5bHzTuSaxhzs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSduF9yI6o0N2V2mNobk8c1XGhNiTo2QQZORK/GB/T2OsA05AN
	JPkhAiClqnXoQmj/IZSHszuTUr1IGxOS2fRaAbtVmsH8/cZBz/99mhTYyv0hg8a51wEgEBNA4G5
	o57VO5YNxlboYRSOA+OPH6clxy/KyW8nnSGkm1GV8wUupuOMcvYgDSA==
X-Gm-Gg: AZuq6aI/C49mACzOxHFtx6YqIuZVogLfxJa8FufgMV2aUWldoj6raDdO28LoYYjfB16
	NZtMkT9QUhTPjYkJjiU0DYCAzY5Qjscq2/Pcrq1PK+ABc/5/eMIIDOM+SuZN3VVgrYy70iZk0cb
	k0Y0En+c/aJUfMQsRbEGbLP+rt41AuqwSJq4OWvEzMg9zx9FbjXJQpb25/LnzNJfIXyDudrR6Ox
	LDZ/4FLspeAk78uf7kOrgeB/l8zprh+KkMvwT9HmWozMv72Crdqxc4n8L9jb5Okt6q7lLlsqwD7
	fuwiRaw6l5cBjagFiuiCdobl/sMeNDJ91OleThxFFfSADDPx8Oj77LFDTTNHwmfsU61Etv/9bf7
	LlJEZv7XVlh7pidGsOMCdSrn+qYqAbGWiCqE2hbISzZu/L5DfSye1
X-Received: by 2002:a17:902:f54e:b0:2aa:f798:8c7f with SMTP id d9443c01a7336-2ad50fe0da1mr15879815ad.54.1771415006582;
        Wed, 18 Feb 2026 03:43:26 -0800 (PST)
X-Received: by 2002:a17:902:f54e:b0:2aa:f798:8c7f with SMTP id d9443c01a7336-2ad50fe0da1mr15879615ad.54.1771415006204;
        Wed, 18 Feb 2026 03:43:26 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:25 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 13/34] kvm/i386: reload firmware for confidential guest reset
Date: Wed, 18 Feb 2026 17:12:06 +0530
Message-ID: <20260218114233.266178-14-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260218114233.266178-1-anisinha@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
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
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71230-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A59C3155F87
X-Rspamd-Action: no action

When IGVM is not being used by the confidential guest, the guest firmware has
to be reloaded explicitly again into memory. This is because, the memory into
which the firmware was loaded before reset was encrypted and is thus lost
upon reset. When IGVM is used, it is expected that the IGVM will contain the
guest firmware and the execution of the IGVM directives will set up the guest
firmware memory.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index feb3f3cf3c..5c8ec77212 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3416,7 +3416,14 @@ int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
 
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


