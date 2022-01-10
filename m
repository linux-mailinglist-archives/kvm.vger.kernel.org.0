Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E11F48A39C
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 00:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345700AbiAJX1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 18:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242263AbiAJX1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 18:27:14 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2D8C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 15:27:14 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id oa15so14720807pjb.4
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 15:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4h1d480IZ4YCqogfOcApNhj3xjpkSaqcARPjT3soJXI=;
        b=OedMk2FdzQlt9NdHJDBJpAjrExnz+iTJlbH+kURG3kXwBfI1xKuad2LAUFdvqgOBDf
         NWPtBpYsT6cVofRFba2m0JRvXcIB6ftj7pI/Vv9hlVPaG2jLF0TLj6hHVymXCwcF7p5r
         0qLyjFJ/OpoVADVEhLUJt2dPOaXqq8cVaHk1MOwk/4qP8VYtJ1Hku+sQFBicOiYMxyyJ
         on+51RZIgxk/fqMovmfwTdYO7k97KSS0wq5+ktkhwq4k6BuuR+LL7XptF4fi9e6gnovm
         nZWCgeUZ/+mOl2WFpznwFx+BUILrcNMma/uoKPnZasV3ocO5qeBWa3coPRvDQRIgHQUD
         cz1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4h1d480IZ4YCqogfOcApNhj3xjpkSaqcARPjT3soJXI=;
        b=WXY/yq/NpmoEskSZ7TFdHz31NJfcpc3ujmk1/CvHb2MZWb1uOAUsPIT9iQifrJlDZv
         j+h9te62RAVY+OHn409dpY5ngcmsbXUvVqzGwiHrocD8GK6YLwVBgsLrMf0gtvITmJAa
         m4M1T6ATQs745P7+TwxOBeGspI4YGaVKrswyUjZq/iCjFRzIvn96n6ydix99C2TTe7h5
         RdSU20bIz2HkYxI3eGrNwI3EJMwXYxJ3viXITFODfSbYfsfnmaD5CYlHneK2U3kPWcJN
         CTDLW8B5B64qbd74vOaZqggS111o56tOpHHRmnxyPwL+Lyh5VSmuozgwLkX8dmgUs5tw
         JBEQ==
X-Gm-Message-State: AOAM531uMvuPYU0kHNTdc9KDKFtdWde8fYgRSTa9/T16rJmJVnpwtb6Y
        li2zcJKRiyIeN1CaCJLWVKnZWg==
X-Google-Smtp-Source: ABdhPJxRCN95KRkMaW0D7kUbDkBVMWZrYRgIXRf34blGPkn8FGjpH7FZKnKEFThlL9eICh8AA6973g==
X-Received: by 2002:a17:902:aa07:b0:14a:27da:9503 with SMTP id be7-20020a170902aa0700b0014a27da9503mr1970347plb.60.1641857233303;
        Mon, 10 Jan 2022 15:27:13 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d21sm8260583pfv.45.2022.01.10.15.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:27:12 -0800 (PST)
Date:   Mon, 10 Jan 2022 23:27:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] KVM: x86: Move check_processor_compatibility from
 init ops to runtime ops
Message-ID: <YdzAzT5AqO0aCsHk@google.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-2-chao.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227081515.2088920-2-chao.gao@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 27, 2021, Chao Gao wrote:
> so that KVM can do compatibility checks on hotplugged CPUs. Drop __init
> from check_processor_compatibility() and its callees.

Losing the __init annotation on all these helpers makes me a bit sad, more from a
documentation perspective than a "but we could shave a few bytes" perspective.
More than once I've wondered why some bit of code isn't __init, only to realize
its used for hotplug.

What if we added an __init_or_hotplug annotation that is a nop if HOTPLUG_CPU=y?
At a glance, KVM could use that if the guts of kvm_online_cpu() were #idef'd out
on !CONFIG_HOTPLUG_CPU.  That also give us a bit of test coverage for bots that
build with SMP=n.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a80e3b0c11a8..30bbcb4f4057 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11380,7 +11380,7 @@ void kvm_arch_hardware_unsetup(void)
        static_call(kvm_x86_hardware_unsetup)();
 }

-int kvm_arch_check_processor_compat(void)
+int __init_or_hotplug kvm_arch_check_processor_compat(void)
 {
        struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());

diff --git a/include/linux/init.h b/include/linux/init.h
index d82b4b2e1d25..33788b3c180a 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -53,6 +53,12 @@
 #define __exitdata     __section(".exit.data")
 #define __exit_call    __used __section(".exitcall.exit")

+#ifdef CONFIG_HOTPLUG_CPU
+#define __init_or_hotplug
+#else
+#define __init_or_hotplug __init
+#endif /* CONFIG_HOTPLUG_CPU
+
 /*
  * modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a

