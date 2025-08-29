Return-Path: <kvm+bounces-56299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EB4F7B3BD58
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BCA974E2159
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885D731E11B;
	Fri, 29 Aug 2025 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wl63MsDQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A453054FC
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756477127; cv=none; b=iwBuIJqEzsUQ2TaW5pOfE8bPvxu1bINRVc7DABNrqJm8pYuk4AqH+yjhULHPoXYe5XV1ri7VGweXTmnBUiDaPsOEv1EXKw9SYJUmnlI5ij7x84wtZZ6kliz/3sGZoVxLadXX5Kk7kXhiR5dgwKSmjj6O6fmwnBUC+8tTvFmeQPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756477127; c=relaxed/simple;
	bh=OUaXq0ZwybCaprhYvqFvKJfAAXGKmp7Rs3uofbIAD5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yw49D8DyiJSsmbJsl+vUR4B/g+TmID40xKkVHP1FJz3G6XIruzxJ1oMA/w5bAhVdH+i3hQ6/vlhKyHUG0rlPooPyUWSh0+d92/KZuaBXBaL7OnmCp8g5k/eRJcukHS6+uhLt2LSAoBrHb1dOmsjaVCi7zCxiON4ist53pTY/WQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wl63MsDQ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b49de40e845so1593224a12.1
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756477125; x=1757081925; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KjqIIm3z2SVAcCrSVbmMRE9jgzcz/VfUw69KcDhSM7g=;
        b=Wl63MsDQYKP2/Q/3BQqAKBhWldjuhRELFjufqL4GIlQE6V7Jakz0ZpZxtG3JlbKgoL
         Xm5IY8CCH4bjiKGqwagUf20lX5sMXbIt+yTFlEs37h193X91yOkajLXiQs/bKsBYCo/Q
         bwQHVy543L8X6nJmga79JI3stAQKGyuK9yJTMgr9Jbqo4IX6CWqakwKaThsg9qCadFcL
         u7799GWaIL4CoXL9TYf06osRSYuWnbmBBdAnvw1Q7m8YNwdWQj6ntrqeMdMqOSHTCeC1
         uq2a40kwWwfSL1m5KMC4jpc92kRpw+QfcxJJQdiKslZQ75w0SQ3SqVkd3JTAbBpUfUEn
         uzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756477125; x=1757081925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KjqIIm3z2SVAcCrSVbmMRE9jgzcz/VfUw69KcDhSM7g=;
        b=lCUNE7RpqtzyuqoPeGQYAV4EK1mJQFa74PkmJfTHQ3uJyuA+/kxhBQt8CHndeeVxPo
         1wfllPTTlyod7GmHV1ISInmMMdtburAZS1vFc4xAGmStasuo5VXmnQFYnx3Fwq5+BukP
         zQydkZjb8dqGwng5IE6wIgfBmO8PFGVaLSJOKLFOUQNxi/WYFQUDqS4kW0zyqfJcTKYV
         6lfUbopuhhFesSjnotlDtqAXmWLXUeh8h+fPICo66KO3nVXaAYWEWoa5ze/XWQJ/lDZ2
         coJbG48gQTByumBthtUHLlnypGJO6n7kRFxmWMPtu6D4k1tj6MvHMS9ZabGmFO0o33yi
         q9sQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGpfd/bv4EJoR0gnK2e3cLM9mgshmnxLqYHcoV+M+3Qny9PNLU5PW8f5q5Mjds2tvu830=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvFTf0gHNVtBxRJz8yCFaivSuTeb8/ZQJmsU0LCJtbivq5gmKv
	4u+LtlKNIc1GaBb1hStsG991ISGo/Xf8atL2mIluJzDAYDlXgWW4rMYaaq2sKno4OPDPBFJ0U6r
	RZwGZag==
X-Google-Smtp-Source: AGHT+IGTX7uYgvOPHD7K4oPjsQ5WMOPGPblRnr11QBc8iEJZSDIjW6wR79PjFDP7p+FTqtE8LPgG7edmkaE=
X-Received: from pfjc29.prod.google.com ([2002:a05:6a00:9d:b0:771:ebf9:d11c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9e:b0:240:1a3a:d7bc
 with SMTP id adf61e73a8af0-24340b8da6fmr37924832637.3.1756477125424; Fri, 29
 Aug 2025 07:18:45 -0700 (PDT)
Date: Fri, 29 Aug 2025 07:18:43 -0700
In-Reply-To: <20250829141233.58081-1-aqibaf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829141233.58081-1-aqibaf@amazon.com>
Message-ID: <aLG2qpCCfjESLZFF@google.com>
Subject: Re: [PATCH 1/1] KVM: selftests: Fix force_emulation_prefix parameter
 type mismatch
From: Sean Christopherson <seanjc@google.com>
To: Aqib Faruqui <aqibaf@amazon.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 29, 2025, Aqib Faruqui wrote:
> Fix kvm_is_forced_enabled() to use get_kvm_param_bool() instead of
> get_kvm_param_integer() when reading the "force_emulation_prefix" kernel
> module parameter.
> 
> The force_emulation_prefix parameter is a boolean that accepts Y/N
> values, but the function was incorrectly trying to parse it as an
> integer using strtol().

Nope, it's been an int since commit:

commit d500e1ed3dc873818277e109ccf6407118669236
Author:     Sean Christopherson <seanjc@google.com>
AuthorDate: Tue Aug 30 23:15:51 2022 +0000
Commit:     Paolo Bonzini <pbonzini@redhat.com>
CommitDate: Mon Sep 26 12:03:04 2022 -0400

    KVM: x86: Allow clearing RFLAGS.RF on forced emulation to test code #DBs
    
    Extend force_emulation_prefix to an 'int' and use bit 1 as a flag to
    indicate that KVM should clear RFLAGS.RF before emulating, e.g. to allow
    tests to force emulation of code breakpoints in conjunction with MOV/POP
    SS blocking, which is impossible without KVM intervention as VMX
    unconditionally sets RFLAGS.RF on intercepted #UD.
    
    Make the behavior controllable so that tests can also test RFLAGS.RF=1
    (again in conjunction with code #DBs).
    
    Note, clearing RFLAGS.RF won't create an infinite #DB loop as the guest's
    IRET from the #DB handler will return to the instruction and not the
    prefix, i.e. the restart won't force emulation.
    
    Opportunistically convert the permissions to the preferred octal format.
    
    Signed-off-by: Sean Christopherson <seanjc@google.com>
    Link: https://lore.kernel.org/r/20220830231614.3580124-5-seanjc@google.com
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 418a069ab0d7..a7ae08e68582 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -173,8 +173,13 @@ bool __read_mostly enable_vmware_backdoor = false;
 module_param(enable_vmware_backdoor, bool, S_IRUGO);
 EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 
-static bool __read_mostly force_emulation_prefix = false;
-module_param(force_emulation_prefix, bool, S_IRUGO);
+/*
+ * Flags to manipulate forced emulation behavior (any non-zero value will
+ * enable forced emulation).
+ */
+#define KVM_FEP_CLEAR_RFLAGS_RF        BIT(1)
+static int __read_mostly force_emulation_prefix;
+module_param(force_emulation_prefix, int, 0444);

