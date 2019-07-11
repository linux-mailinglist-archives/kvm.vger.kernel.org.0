Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E0365809
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 15:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbfGKNpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 09:45:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43753 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfGKNpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 09:45:16 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so6352739wru.10
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 06:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tNB+Cdder5uir4F/Y1o1Nv0qZI/Q9BfOtg7q5GBmh1s=;
        b=m/k+LZqBAnx3JnDKMTE9R0k1bls+wgLhV68GKnqA4zMp+IVhi6fcLHq4kCvMwfBGyJ
         gi+j2ndM7RVF6BrUw+N6DLkRg0lwBwkqGB4/F+bAsNMkRImcgb0OWePL7YKnCwx33U1B
         HkQeQAZ+F37g/wlT+fngD1j4AYexHe1jrbZJMgMOwZ5AzssBOQrBX7pBor5Mwc4L9XBP
         ggW/kCquvR8nKUKYCk6vhTQb1Uy6/RcnzjeUVO7Z92zBdAQJUgUZzbaD8/nufYBtpr6t
         4ECBN0RrMzgJ2VsZNU+fnDHP5+dG5YTTxZ1cD1zHfyMCBSISkGioMLJyrQJTVhczpTx9
         6ecQ==
X-Gm-Message-State: APjAAAVg4fkQpW1GnpqjIXLsuepsFeav48k0M1EPqWNYdOwnA8mh5MEO
        VDt7mzusQ0j/Fdl2+FlqIRj1ndoVgOk=
X-Google-Smtp-Source: APXvYqzFyb+Jy/hSvo8JhEg2qgu6yKRmj3xzahjZ/U2b9GBadqIjUPYWPxzHnqcBuew+Nte86S5XzA==
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr5297276wrw.96.1562852714320;
        Thu, 11 Jul 2019 06:45:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id y18sm5636707wmi.23.2019.07.11.06.45.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 06:45:13 -0700 (PDT)
Subject: Re: [Qemu-devel] [PATCH 1/4] target/i386: kvm: Init nested-state for
 VMX when vCPU expose VMX
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     Joao Martins <joao.m.martins@oracle.com>, ehabkost@redhat.com,
        kvm@vger.kernel.org
References: <20190705210636.3095-1-liran.alon@oracle.com>
 <20190705210636.3095-2-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <805d7eb5-e171-60bb-94c2-574180f5c44c@redhat.com>
Date:   Thu, 11 Jul 2019 15:45:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705210636.3095-2-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 23:06, Liran Alon wrote:
> -        if (IS_INTEL_CPU(env)) {
> +        if (cpu_has_vmx(env)) {
>              struct kvm_vmx_nested_state_hdr *vmx_hdr =
>                  &env->nested_state->hdr.vmx;
>  

I am not sure this is enough, because kvm_get_nested_state and kvm_put_nested_state would run anyway later.  If we want to cull them completely for a non-VMX virtual machine, I'd do something like this:

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 5035092..73ab102 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1748,14 +1748,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
     max_nested_state_len = kvm_max_nested_state_length();
     if (max_nested_state_len > 0) {
         assert(max_nested_state_len >= offsetof(struct kvm_nested_state, data));
-        env->nested_state = g_malloc0(max_nested_state_len);
 
-        env->nested_state->size = max_nested_state_len;
-
-        if (IS_INTEL_CPU(env)) {
+        if (cpu_has_vmx(env)) {
             struct kvm_vmx_nested_state_hdr *vmx_hdr =
                 &env->nested_state->hdr.vmx;
 
+            env->nested_state = g_malloc0(max_nested_state_len);
+            env->nested_state->size = max_nested_state_len;
             env->nested_state->format = KVM_STATE_NESTED_FORMAT_VMX;
             vmx_hdr->vmxon_pa = -1ull;
             vmx_hdr->vmcs12_pa = -1ull;
@@ -3682,7 +3681,7 @@ static int kvm_put_nested_state(X86CPU *cpu)
     CPUX86State *env = &cpu->env;
     int max_nested_state_len = kvm_max_nested_state_length();
 
-    if (max_nested_state_len <= 0) {
+    if (!env->nested_state) {
         return 0;
     }
 
@@ -3696,7 +3695,7 @@ static int kvm_get_nested_state(X86CPU *cpu)
     int max_nested_state_len = kvm_max_nested_state_length();
     int ret;
 
-    if (max_nested_state_len <= 0) {
+    if (!env->nested_state) {
         return 0;
     }
 

What do you think?  (As a side effect, this completely disables
KVM_GET/SET_NESTED_STATE on SVM, which I think is safer since it
will have to save at least the NPT root and the paging mode.  So we
could remove vmstate_svm_nested_state as well).

Paolo
