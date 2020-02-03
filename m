Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80D21503B6
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 10:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgBCJ7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 04:59:17 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60353 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727337AbgBCJ7Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 04:59:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580723956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hN0XJ3e40Iv8crpZTtg0MhsXfkxzrtU4D3I/YBNqM/A=;
        b=eHZnhiXmBTsnPHfvvMolDx208tnQwtn+HG/KsgVe1ZOVwu4kYi8Pv3W6eM8PaLJvutpLfl
        lif1rfxy2NL2B5Cx/Tr+we66V4pPNG48BQZiE+hB5DNfCVJHmwTZ0p8Ft0Nl5IXfnZ9gj4
        nwkzhRjVzo6ryDJKlsV35QemZFiCTfA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-PwF-Jwz2N9ijVElabRVAZA-1; Mon, 03 Feb 2020 04:59:13 -0500
X-MC-Unique: PwF-Jwz2N9ijVElabRVAZA-1
Received: by mail-wr1-f70.google.com with SMTP id a12so6287843wrn.19
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 01:59:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hN0XJ3e40Iv8crpZTtg0MhsXfkxzrtU4D3I/YBNqM/A=;
        b=m9qQA2wf7/9ejU++MuE0iFn5L10K2Pm9wuvTefEuAB3ypRiXGFmRQMQbOh6aNEnAgo
         TPszMbCucttOxHCvQMFGag64QSPNWNU7ZHEPOJ2bt789yLIoPQtYi2aMNGQANACbtboc
         yvfjX0Vnj9BDKHW5AkzyVMEXFwOOTt37psBygriqPkbIsL16LMbCjMQRQhNCmaQCQsHj
         yKStFlf6leOGfQ1r8fGK8Kz217Ka3BSMRMbAnsA5UZ2LUmZBixVN1IjPX83sYpCK59FE
         7oTaqgI1HSj2JfnZZgKIFHwqz0efGydrCb8EWL+1NqCswPt7lumxvHGpw4XSWIKbg4Ez
         9m2Q==
X-Gm-Message-State: APjAAAUbg3VgWiHOoGceuVZO+Z28l13ME6xMIHIGfZyi2f7MzNjtVkrA
        MNIZSE9AfT/wO2p2dwZunb78z8Y7fepQMksxXxv87D75nCJFMenJT8JY/yzviL1EdJa6OnD7PeE
        L2IhBLvzLXdc/
X-Received: by 2002:a5d:4b8f:: with SMTP id b15mr14441985wrt.100.1580723951822;
        Mon, 03 Feb 2020 01:59:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqwDAvmfMXcckG8AgL2ChzxwLTNuiI4b5o73iz78EgHDkT4RkhlyGqE1J1fmtfqviYtwd3HB7g==
X-Received: by 2002:a5d:4b8f:: with SMTP id b15mr14441966wrt.100.1580723951639;
        Mon, 03 Feb 2020 01:59:11 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y6sm24389481wrl.17.2020.02.03.01.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 01:59:11 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: do not setup pv tlb flush when not paravirtualized
In-Reply-To: <20200131155655.49812-1-cascardo@canonical.com>
References: <20200131155655.49812-1-cascardo@canonical.com>
Date:   Mon, 03 Feb 2020 10:59:10 +0100
Message-ID: <87wo94ng9d.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thadeu Lima de Souza Cascardo <cascardo@canonical.com> writes:

> kvm_setup_pv_tlb_flush will waste memory and print a misguiding message
> when KVM paravirtualization is not available.
>
> Intel SDM says that the when cpuid is used with EAX higher than the
> maximum supported value for basic of extended function, the data for the
> highest supported basic function will be returned.
>
> So, in some systems, kvm_arch_para_features will return bogus data,
> causing kvm_setup_pv_tlb_flush to detect support for pv tlb flush.
>
> Testing for kvm_para_available will work as it checks for the hypervisor
> signature.
>
> Besides, when the "nopv" command line parameter is used, it should not
> continue as well, as kvm_guest_init will no be called in that case.
>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  arch/x86/kernel/kvm.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 81045aabb6f4..d817f255aed8 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -736,6 +736,9 @@ static __init int kvm_setup_pv_tlb_flush(void)
>  {
>  	int cpu;
>  
> +	if (!kvm_para_available() || nopv)
> +		return 0;
> +
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
>  	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
>  	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {

The patch will fix the immediate issue, but why kvm_setup_pv_tlb_flush()
is just an arch_initcall() which will be executed regardless of the fact
if we are running on KVM or not?

In Hyper-V we setup PV TLB flush from ms_hyperv_init_platform() -- which
only happens if Hyper-V platform was detected. Why don't we do it from
kvm_init_platform() in KVM?

-- 
Vitaly

