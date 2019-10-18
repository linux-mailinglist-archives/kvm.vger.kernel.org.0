Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1463DCBF8
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 18:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409286AbfJRQxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 12:53:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409276AbfJRQxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 12:53:22 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5C338BA02
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2019 16:53:21 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id s9so2911929wrw.23
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2019 09:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7nIjunJDs6Nd1x0jIiuXBYJC/Cu8yPLrM0AXlZYMGoo=;
        b=KNXbDsMG0VLH/1Dm0+K7Rq5ITT2xzE9hXFNtAp5qgaTQQ7kdasCwr3CRQeXL88Q5tC
         0gS85egmMf5DfxpNAEohWuHl9FXEXwifHfb97J7snHgjT17wioigxIUnZMIhGB1YqFLe
         e3/nM8GPT9sPengUinfoqeU+KjKqNpwCnj/aG3WUKYMCgCSvdAu4TfqYHnSXFKNSv+g8
         KcOPv846arYSaXOC2gbqaYUKw306tuDw1tHQmYhM42rsNiAQOFNMFl8zNkFRoT6n4Z4o
         dQNCiXd1KdsVdD95WE5GMIS1CI3Snm/JqGWKhBnLhib01RrRx/n9dKj3ESFRclWZKE/U
         UUaA==
X-Gm-Message-State: APjAAAXi058h1X4KA2sHtIna6pE1WYMk4QV8534kgGCoGCQNaGlCbrGD
        WZ6Vr0lAVFGfQvuj0ZRu3o+nkKEmZy5rooBe0BLnZC1nanMj6jNzMk4wsltuh57xk80FMrY884d
        dsttRhbpyH+XL
X-Received: by 2002:a7b:ca4e:: with SMTP id m14mr8764053wml.98.1571417600604;
        Fri, 18 Oct 2019 09:53:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzwNWrTFTytvB1dwIWweyKj915oqiBIUueByCmuT4aAnn5ddb3MyHtYxNiKnFGQLQ+u9inw+g==
X-Received: by 2002:a7b:ca4e:: with SMTP id m14mr8764040wml.98.1571417600357;
        Fri, 18 Oct 2019 09:53:20 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n7sm5844855wrt.59.2019.10.18.09.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 09:53:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        kvm@vger.kernel.org
Cc:     surajjs@amazon.com, wanpengli@tencent.com, rkrcmar@redhat.com,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86/apic: Skip pv ipi test if hcall not available
In-Reply-To: <20191017235036.25624-1-sjitindarsingh@gmail.com>
References: <20191017235036.25624-1-sjitindarsingh@gmail.com>
Date:   Fri, 18 Oct 2019 18:53:19 +0200
Message-ID: <87pniu0zcw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:

> From: Suraj Jitindar Singh <surajjs@amazon.com>
>
> The test in x86/apic.c named test_pv_ipi is used to test for a kernel
> bug where a guest making the hcall KVM_HC_SEND_IPI can trigger an out of
> bounds access.
>
> If the host doesn't implement this hcall then the out of bounds access
> cannot be triggered.
>
> Detect the case where the host doesn't implement the KVM_HC_SEND_IPI
> hcall and skip the test when this is the case, as the test doesn't
> apply.
>
> Output without patch:
> FAIL: PV IPIs testing
>
> With patch:
> SKIP: PV IPIs testing: h-call not available
>
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> ---
>  x86/apic.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/x86/apic.c b/x86/apic.c
> index eb785c4..bd44b54 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -8,6 +8,8 @@
>  #include "atomic.h"
>  #include "fwcfg.h"
>  
> +#include <linux/kvm_para.h>
> +
>  #define MAX_TPR			0xf
>  
>  static void test_lapic_existence(void)
> @@ -638,6 +640,15 @@ static void test_pv_ipi(void)
>      unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 = 0x0;
>  
>      asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
> +    /*
> +     * Detect the case where the hcall is not implemented by the hypervisor and
> +     * skip this test if this is the case. Is the hcall isn't implemented then
> +     * the bug that this test is trying to catch can't be triggered.
> +     */
> +    if (ret == -KVM_ENOSYS) {
> +	    report_skip("PV IPIs testing: h-call not available");
> +	    return;
> +    }
>      report("PV IPIs testing", !ret);
>  }

Should we be checking CPUID bit (KVM_FEATURE_PV_SEND_IPI) instead?

-- 
Vitaly
