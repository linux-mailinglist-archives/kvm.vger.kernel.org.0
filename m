Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11D94C938
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 10:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfFTIRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 04:17:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51696 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfFTIRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 04:17:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so2093339wma.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 01:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sFGIfcUZjU/cwOWwsrC6pPBswmDh2q5+9s+Y8U5BUlc=;
        b=q5Rfabn3QMjs5mysgETLqcn6cuIQmnAi1YNCi7G4eIVS0+XRAx9xgIJswq+5NZvcji
         M6khWk2LPo2CwwDCqISu119e5WLs8iDobWkFWHEFJ1A90iH46rRwVd71t/ePB03C/njQ
         EvpO0SZoDEFAhfn+4JL0IrwHIL9nGYbjQaL04We7J4evYEoqQz/yCk5HpGAGjzXB4IYN
         fMPt9FaZTLFw5aROI2XyJxiV/9ARXe+kdBGDpUZ6ge2h+CUf58UbAvwAyB8gjoQphNzb
         RdVDZ57CZK/1AYr+afw3vz9XnZZoN1DUcF3HPGCPZOOw6ryPR7EHjUXMDqiRpI6sWlaA
         lP4Q==
X-Gm-Message-State: APjAAAUpNWeua7XbE7pinOBuqfZ6JloZv4Ty9E/egjSPAGEzp+n6KUgc
        wGtEtmXZ81msgkluOMTsVkqi2A==
X-Google-Smtp-Source: APXvYqw1zymo82PY/ubWagkFMz7ntmIuvIEbcPlzXhLe1h4GT7yyGE0KexnDUK1gAK0FYM/L0/DH6w==
X-Received: by 2002:a1c:a5c8:: with SMTP id o191mr1732649wme.84.1561018650331;
        Thu, 20 Jun 2019 01:17:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7822:aa18:a9d8:39ab? ([2001:b07:6468:f312:7822:aa18:a9d8:39ab])
        by smtp.gmail.com with ESMTPSA id v67sm4998541wme.24.2019.06.20.01.17.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 01:17:29 -0700 (PDT)
Subject: Re: [PATCH] KVM: vmx: Fix the broken usage of vmx_xsaves_supported
To:     Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Wanpeng Li <kernellwp@gmail.com>, Tao Xu <tao3.xu@intel.com>
Cc:     Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190620050301.1149-1-tao3.xu@intel.com>
 <CANRm+Cwg7ogTN1w=xNyn+8CfxwofdxRykULFe217pXidzEhh6Q@mail.gmail.com>
 <f358c914-ae58-9889-a8ef-6ea9f3b2650e@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b3f76acd-cc7e-9cd7-d7f7-404ba756ab87@redhat.com>
Date:   Thu, 20 Jun 2019 10:17:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f358c914-ae58-9889-a8ef-6ea9f3b2650e@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/06/19 08:46, Xiaoyao Li wrote:
>>
>> It depends on whether or not processors support the 1-setting instead
>> of “enable XSAVES/XRSTORS” is 1 in VM-exection control field. Anyway,
> 
> Yes, whether this field exist or not depends on whether processors
> support the 1-setting.
> 
> But if "enable XSAVES/XRSTORS" is clear to 0, XSS_EXIT_BITMAP doesn't
> work. I think in this case, there is no need to set this vmcs field?

vmx->secondary_exec_control can change; you are making the code more
complex by relying on the value of the field at the point of vmx_vcpu_setup.

I do _think_ your version is incorrect, because at this point CPUID has
not been initialized yet and therefore
vmx_compute_secondary_exec_control has not set SECONDARY_EXEC_XSAVES.
However I may be wrong because I didn't review the code very closely:
the old code is obvious and so there is no point in changing it.

Paolo
