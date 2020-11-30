Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6E62C8DDD
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 20:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgK3TTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 14:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729861AbgK3TTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 14:19:37 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD29C0613CF
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 11:18:57 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id x15so7036365pll.2
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 11:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4dzT1syF4BCGkw3x/x1xoTUO12SPv5cKYnd2t45XWII=;
        b=fskAyQ3cXlLPpaMf+LHsgdRTzFh8eZ/cXaETrZgoAuHs8JMcZsYSymyGsatwH4OnSZ
         DK7rYMCjiTHeAd1Ro32ARMahmSQIfIrP1A8hgpfzfiwsxpzMlEYXbYTN+f1n90zL7TBH
         XAfHX82Qzf+Y4041aYGafKhuDEOcRTysdrV2Nqk1HTJehe0DihM0+xSjVNnksWN8eYCU
         S7i0aIYwdkQ4XbxxGvYg+8Mq4gSMVAOoZyaZWZsesj3I2y2ApQs2KjdtxaBo9rNB5RhT
         pSVocA5VmwOCCxIjfXb2QVd9cgGQI6O+sVwTjfdYajKFbksLHAT+L94dn760hyXfowiS
         /RSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4dzT1syF4BCGkw3x/x1xoTUO12SPv5cKYnd2t45XWII=;
        b=NUuxfzEWs/6L0HX7kTUIDGOIME4rvadd709PnpqPnWR3vylQymGk7cBGp7xXFeLX1s
         HPMF5fX22xFI3i7+8Hh9P5onOHDTEjbezF9jIisB9AKtgu53mQa/mtm1ipQ5SWWVmpZv
         sprR8JMmakvnGoWfuwozELk8EfuaNcG5wPku8mvobyqTAhPovsEnBe2LAd0M+7zoT/82
         v3Ib5q7zRn36MJEnz1L7cXvzZsMCCIQKjRdy7Z83PbXQfnqW54za5ejPBbbSu7QAJ9dD
         twYL4lrftpTVj6JZY0THBWPs9oYJgqXLcTEWhoPtWPT5QJ0s6/kCjf6oXhvJlkRe6OYW
         fC0A==
X-Gm-Message-State: AOAM533qs1VGjQDS9ggQKJmcevTi2VkN72EJmdRP0Qk2IUoymcacAv7K
        ia2HFQZWF0XO9SHhsRpCseFIrA==
X-Google-Smtp-Source: ABdhPJw6qhEQIWhvjA5t2SaocwtPwoCxrqx0IYgcupR2Iyk5+ROiudtRUdbN94Jy6o1ufHjP1MnMKA==
X-Received: by 2002:a17:90a:902:: with SMTP id n2mr383861pjn.126.1606763936801;
        Mon, 30 Nov 2020 11:18:56 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id f15sm172345pju.49.2020.11.30.11.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:18:56 -0800 (PST)
Date:   Mon, 30 Nov 2020 19:18:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Andy Lutomirski <luto@kernel.org>, isaku.yamahata@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com, Zhang Chen <chen.zhang@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH 03/67] x86/cpu: Move get_builtin_firmware() common
 code (from microcode only)
Message-ID: <X8VFm5kYnYFTAOMc@google.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
 <46d35ce06d84c55ff02a05610ca3fb6d51ee1a71.1605232743.git.isaku.yamahata@intel.com>
 <20201125220947.GA14656@zn.tnic>
 <20201126001812.GD450871@google.com>
 <20201126101203.GB31565@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126101203.GB31565@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 26, 2020, Borislav Petkov wrote:
> On Thu, Nov 26, 2020 at 12:18:12AM +0000, Sean Christopherson wrote:
> > The SEAM module needs to be loaded during early boot, it can't be
> > deferred to a module, at least not without a lot more blood, sweat,
> > and tears.
> 
> Are you also planning to support builtin seam or only thru initrd loading?

Yep, both built-in and initrd are supported.

> In any case, this commit message needs to state intentions not me having
> to plow all the way up to patch 62.

Yeah, most of the changelogs are in terrible shape.  This first RFC was intended
to get feedback on high level things like code organization and the KVM
shenanigans for VMX and TDX coexistence.
