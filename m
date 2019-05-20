Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9B923169
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 12:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731569AbfETKfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 06:35:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35667 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731455AbfETKfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 06:35:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id q15so12476527wmj.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 03:34:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TDeq1R0ZlxS3eYDtruCGOeX8Ha3Jxa2VQZkw5KkPaxY=;
        b=tu6ljm1TsFUZYG2EPr2ruqFSw2Yqv83LMW/FOyIJfFHdMKAbwtDoHXM3YcVRPK/o/C
         Ee14q7qVtuQDOF72a/6/GAI9KU5M03Dh5qBLdnYOMGP6BcSk5OYEJzAqurHhWB1QgcIk
         dKMFO34LOPYYSHyXQUQ628FKzi2KEWZ3ODt73oiIkhyJZkhniS7hXW1dwnRHq0kQTwN/
         0yVgv8ie4nmvbCAveNB2VE7/P+SA52FBUd32K1ZTjQMeVtWWkZxbtiMAXGTvCpNWKkzU
         mWCpl6LbjN9nzLaO8BvwFxYQ4nHI2solqsLDKpruyhbKZet+ImlCKcHIyVQasn3o82ss
         A+zA==
X-Gm-Message-State: APjAAAWWiQ49n9J+8RJOdLnO1dhPegL2HW+GWBKtySJLRzTZXlySBRea
        S+pOeLbZGP1jAFK1Rc2aktYlkg==
X-Google-Smtp-Source: APXvYqwn/wTJt8p+PuqGYx7YYCzZyxsT5ZwMQNjlbn4FMnuwgXauUwZBRMlrQ25Gm7MW5C+8kJe+sQ==
X-Received: by 2002:a1c:a904:: with SMTP id s4mr16653129wme.92.1558348498438;
        Mon, 20 May 2019 03:34:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id x6sm25589007wru.36.2019.05.20.03.34.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 03:34:57 -0700 (PDT)
Subject: Re: [PATCH RESEND 2/4] KVM: X86: Emulate MSR_IA32_MISC_ENABLE MWAIT
 bit
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <1558082990-7822-1-git-send-email-wanpengli@tencent.com>
 <1558082990-7822-2-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e96eecd6-7095-58b3-32a7-2cfde2f2ebcc@redhat.com>
Date:   Mon, 20 May 2019 12:34:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558082990-7822-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/19 10:49, Wanpeng Li wrote:
> MSR IA32_MSIC_ENABLE bit 18, according to SDM:
> 
> | When this bit is set to 0, the MONITOR feature flag is not set (CPUID.01H:ECX[bit 3] = 0).
> | This indicates that MONITOR/MWAIT are not supported.
> |
> | Software attempts to execute MONITOR/MWAIT will cause #UD when this bit is 0.
> |
> | When this bit is set to 1 (default), MONITOR/MWAIT are supported (CPUID.01H:ECX[bit 3] = 1).
> 
> The CPUID.01H:ECX[bit 3] ought to mirror the value of the MSR bit,
> CPUID.01H:ECX[bit 3] is a better guard than kvm_mwait_in_guest().
> kvm_mwait_in_guest() affects the behavior of MONITOR/MWAIT, not its
> guest visibility.
> 
> This patch implements toggling of the CPUID bit based on guest writes
> to the MSR.

Won't this disable mwait after migration, unless IA32_MISC_ENABLE is set
correctly by firmware or userspace?  I think you need to hide this
behind KVM_CAP_DISABLE_QUIRKS.  (Also, what is the reason for this
change in general besides making behavior closer to real hardware?)

Thanks,

Paolo
