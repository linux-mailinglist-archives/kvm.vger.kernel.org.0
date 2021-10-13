Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0479B42C425
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbhJMO56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35446 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbhJMO5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:48 -0400
Message-ID: <20211013145322.817101108@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=RLeMhaAZt5yyxkrpW+ax/B5S7CN2/6ZcEG9+mIB/KPk=;
        b=Vv72sKkTsOCIYjTCKiXwfG96yPH3ZHCUJlDziDdOXw3FBwGo+hPRwIuJFLdmMRfoUcFCUJ
        b3ih4TZ43VIFEpsNv3d78DJlXsk/dWMjNugAWf8wClwRplPiOqpr79/Xi4SJMvYmop4SVi
        h2zxwU53RUlRkcjcoV2LdkkOEuZf7kBpOeFXNt/eYjfHvdxwIcaDYkgVA3QInNQzpCYp3c
        5VAhGeCXYy7jcQJb8tnzQErPStOObvh36agpsanFjrvhrcIKURuBJkZPnGlRtzlK6MXTHp
        tbGTr2KQtTtG+T+DBnq2XwjdAxSBe2jzKanHJLJEtVlBYm7mPgeVzhSTrTPQTg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=RLeMhaAZt5yyxkrpW+ax/B5S7CN2/6ZcEG9+mIB/KPk=;
        b=Ch0MM0T7JFbQYyMR8AggsyT9wzFdSYU317hZIC4kiOWkTOiVxmsDalI9/GBMTGNreXdBky
        4STmfDt5MI8JHdDA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 12/21] x86/fpu: Do not leak fpstate pointer on fork
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:43 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If fork fails early then the copied task struct would carry the fpstate
pointer of the parent task.

Not a problem right now, but later when dynamically allocated buffers are
available, keeping the pointer might result in freeing the parents
buffer. Set it to NULL which prevents that. If fork reaches clone_thread,
the pointer will be correctly set to the new task context.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/process.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -87,6 +87,8 @@ int arch_dup_task_struct(struct task_str
 #ifdef CONFIG_VM86
 	dst->thread.vm86 = NULL;
 #endif
+	/* Drop the copied pointer to current's fpstate */
+	dst->thread.fpu.fpstate = NULL;
 	return 0;
 }
 

