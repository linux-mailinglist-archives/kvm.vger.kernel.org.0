Return-Path: <kvm+bounces-19161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9CE1901B4F
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 08:34:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 312E7B24ABB
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 06:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1CE11CF8D;
	Mon, 10 Jun 2024 06:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QUMlwyYT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EE41CD11
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 06:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001199; cv=none; b=BUdHie5lhh2mBFO6cxU9b7rM+c7UW6XDomSzWwL/TuIqjOLr4yNLEDbHz3GACt187HR+USRlGBdWtdEuJWr2JlAoqKa+CfkH31YVuEg/nC9PvTKG7FOmuIhrfMyMysPqemwef8zdLRVg85NQ70cAL12oTSDtErD8bZuBokQN7R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001199; c=relaxed/simple;
	bh=AqvaU44Y4+L1JXO5CklIeg/gsPsV6LRGHS7zAcof/1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gYxQhieOKxvQOqgVTxI83wDov04c06EU89IF+PhEintLejn6VHHR1/r/cVOWH0Y63+iOecXrtnsqzl1jHmR8F5/KeDZMtFrf8J1GNkrMOnzBGc3WCScfpXBf9fz1/Rsb4kpA+HzlAaLCtIj6lsMTcqt8+7n1MC0xsF3DO7Ol2i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QUMlwyYT; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df4d62ff39fso7008780276.2
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2024 23:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001197; x=1718605997; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dqyohViu5INtDvXVZa+s1VQcpgMXQ3O7S1A4651HaGs=;
        b=QUMlwyYTW3sLZRtYs3s+6r3MFiaWqX9j9ouWaEUDipI2l73fHgSimRAAKCMh3IY4Gr
         gyNLa4zY+Ds+r1AkbxBhPx/LItrZBaDMlnq52I0VOx6VIsUIlyCj7ciVFa9EMuvIHs4c
         0JeYoLGYYt3GUiC3/jzuMVWNgPG2Hj/T22yP1M8vBZaPituOKGbWPJEnsuEDebWmNAXw
         TV7VPN4Hi561HZ8Ri04yUmXtFy18eXV2UOXv3E6UqQ6y8otHeRBQOUAp/gcQXsIXIHfw
         GxOIVgOOgSHvy/EIIMmQMhjVvClXRnyNKF5OaaA7l65bg0kUQWkfaLfhyIDPk7peuvrB
         322Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001197; x=1718605997;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dqyohViu5INtDvXVZa+s1VQcpgMXQ3O7S1A4651HaGs=;
        b=FSpOXvcL2vqi08IjiUsMus2GMHyREYr1Ef75g5Oq52HwHKds79iEcmQRuV/kcs+kcp
         kjeN790EDd8OPTY0WcuERGwEpYcTSk57Xn0YlGLEAZWf63+ezobjpzt2jWN1b2zXbsoQ
         1iAJYhGDu8APOmDWeFrPApcfejbk7ppr2fhDUqAVwZ2IZMA5zPMBCLUQ4wuMsNWDU1fI
         c9LBpqaq368BbgYAmnHsi7pOcYZT/LsBVGjyadsPj5bkAOCslgvAD7syHqdlx5XotDYl
         UjIEtoz01fKZz1gd0iQOaoUo1s9MSnsIyZLkiu9FsvLuENw8BpLghR1kyOr85dk/Pdfy
         CVVg==
X-Forwarded-Encrypted: i=1; AJvYcCWVtDFGAo5RyCxWBbv27+9oz9fYJN6BdZS1zF+2SIuhrSiBRrdZ9BpAYPfrqM28LQuUUEJ4almuyMEsO166thpU0zcW
X-Gm-Message-State: AOJu0Yyr4YYB9u08TP9Wt+PgidgblDIg5C3ZWalZje0FhL97TSTQXodQ
	1YpumJdR1wYZU5S7uPKRsQaocpCvoeo4VwVdDD0O6b921UF36FxG6ev515LN+crmy94aUSd+Gg=
	=
X-Google-Smtp-Source: AGHT+IGf6WRV7HKSJskgV/e4LobW32lt+CvHAqHY8Xw+IryjRsITtuaQvaI/3e5A/41rY75n+5kl2ImpRQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:1024:b0:dfa:56fa:bb4e with SMTP id
 3f1490d57ef6-dfaf64ea21fmr2585123276.1.1718001197573; Sun, 09 Jun 2024
 23:33:17 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:36 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-8-ptosi@google.com>
Subject: [PATCH v5 7/8] KVM: arm64: Introduce print_nvhe_hyp_panic helper
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a helper to display a panic banner soon to also be used for kCFI
failures, to ensure that we remain consistent.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d41447193e13..b3d6657a259d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -411,6 +411,12 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exce=
ption_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
=20
+static void print_nvhe_hyp_panic(const char *name, u64 panic_addr)
+{
+	kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
+		(void *)(panic_addr + kaslr_offset()));
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -439,11 +445,9 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr,=
 u64 spsr,
 		if (file)
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
-			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
-					(void *)(panic_addr + kaslr_offset()));
+			print_nvhe_hyp_panic("BUG", panic_addr);
 	} else {
-		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
-				(void *)(panic_addr + kaslr_offset()));
+		print_nvhe_hyp_panic("panic", panic_addr);
 	}
=20
 	/* Dump the nVHE hypervisor backtrace */
--=20
2.45.2.505.gda0bf45e8d-goog


