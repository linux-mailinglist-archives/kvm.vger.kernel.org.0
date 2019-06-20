Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040244C993
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 10:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfFTIgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 04:36:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40375 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfFTIgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 04:36:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so2077405wre.7
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 01:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=78XTCBJ6IQe9uXplpuD9BRY7lz4VHH50PsExpp8KaFU=;
        b=gfCwNpYMXna1qwmClcKmr7z7Jti7GOAjdWZ8t5QEbSlFergoA+tozKWUyBWPHTPUuf
         IXRO/V89S7XdRzFBIUbbsyoPuxw5jiujn6KkUDCfyw3x8NYRRcNqdn/XBYqVPeDYnag+
         /MOSr9yla9sE44W+X8CPocrRNZwnE8KEoOLJ4djo7JkWluxcPfIsCyvJoJuQeuDzaHku
         m8DgMdGtHvqoxtQSoCWuEgYfefnfrkAd2tjsvR4ScXsYiluvN9tAJNBSWHHXHAZOnMT9
         5UGL6kw0jWMFCBeIuFxvjsFg64Tf2f0fvP57g78ZdkkkkokuP8Mqp+YfGXDz3Q2CQ6XT
         NhXQ==
X-Gm-Message-State: APjAAAV/7C2fp9AQ5Rw8V14032Y8gxwEFqRAfiXjQabx6qVbzf24nd0N
        FGQulQ/76TycWomLByiGJxjI1w==
X-Google-Smtp-Source: APXvYqwPvibP8/SSGIkMVjMpSYvP/Q55IC+qHplvCz6Ywcjqwe3zcNYu0+B2xocYRnlWJAQ8dlQ9yQ==
X-Received: by 2002:adf:ce03:: with SMTP id p3mr67060669wrn.94.1561019809656;
        Thu, 20 Jun 2019 01:36:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7822:aa18:a9d8:39ab? ([2001:b07:6468:f312:7822:aa18:a9d8:39ab])
        by smtp.gmail.com with ESMTPSA id v67sm5067971wme.24.2019.06.20.01.36.48
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 01:36:49 -0700 (PDT)
Subject: Re: [PATCH] KVM: vmx: Fix the broken usage of vmx_xsaves_supported
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Tao Xu <tao3.xu@intel.com>, Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190620050301.1149-1-tao3.xu@intel.com>
 <CANRm+Cwg7ogTN1w=xNyn+8CfxwofdxRykULFe217pXidzEhh6Q@mail.gmail.com>
 <f358c914-ae58-9889-a8ef-6ea9f3b2650e@linux.intel.com>
 <b3f76acd-cc7e-9cd7-d7f7-404ba756ab87@redhat.com>
 <CANRm+Cy_oo7BkYXD-nc0Ro=rivJircL6aheuFujMv6twS3gk=g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <165af492-027d-c640-9dea-c4c2d76fa1aa@redhat.com>
Date:   Thu, 20 Jun 2019 10:36:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CANRm+Cy_oo7BkYXD-nc0Ro=rivJircL6aheuFujMv6twS3gk=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/06/19 10:27, Wanpeng Li wrote:
> Agreed, in addition, guest can enable/disable cpuid bits by grub
> parameter

Through what path?  Guest can disable X86_FEATURE_* but that's purely a
Linux feature, the few CPUID bits that can change at runtime already
call kvm_x86_ops->cpuid_update().

Paolo

> , should we call kvm_x86_ops->cpuid_update() in
> kvm_vcpu_reset() path to reflect the new guest cpuid influence to
> exec_control? e.g. the first boot guest disable xsaves in grub, kvm
> disables xsaves in exec_control; then guest reboot w/ xsaves enabled,
> it still get an #UD when executing.

