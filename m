Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF75348B76C
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 20:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbiAKTh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 14:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbiAKThz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 14:37:55 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB58C061748
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 11:37:55 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id hv15so671220pjb.5
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 11:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zGHwR3NiHUMCCbtobgvdiBSkcpXAF9setwIu+L+2NTg=;
        b=TAGb+YJCDXlRtjUQUm2H3TX+eCODYtkadlIc0LARHDTdwUNOaWlnYbVItKV6ZFEPr1
         cuhzonW3+Xc7Lf7v+78erPe+pjaUtCwGPGGBf2S/Ag+bsztSgmMctA1FRKkWbQNWn747
         /D+C2lPI1EFydZQN/VawKEj+VK2qkoVFMN/HYpgf6RHy9snvnbMN4w8lZsR+BcvVVbqB
         FcjVWcUwz/5eaIfUo/mQZjQ5bb3IauEUxfNZriFqV3CCuS5sRmU4qA2sUpY87UBRe1vb
         taAuwPX6zJ7hkBg2eryl243n1O5zePA+QqV3lsOKtjyDKIJADikzb8vHLdYV4Laae6He
         m4oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zGHwR3NiHUMCCbtobgvdiBSkcpXAF9setwIu+L+2NTg=;
        b=TPJMyf6MPD4zSrkLHPrFTexJl9TMJRc2dX4WMRLsYn64yPqtteSi8uAWULdDs8DEwC
         5MbepZ28Fuk6IbA5sKIZdCc+EFzHR4vPKLF/I/91eMOce2JFX2ZSGVyDJwIIv9yOje1Z
         HM5IcQW1dp2v2t6LfU9G10xAT94L49vQrfHxqEfml+kx7SbWyol6zTeONtHyL04fCEyH
         MnCXzgl+2p8Pi4y7nE09wFj85Yc3NQzwS224WkDAHr/96iMq4cOKmBZelKvGwu7U7Kht
         Hp4MV1fffb3Njq9SufKru5AwgtFLuOSyZ8kU47r5GHsFEkS6dpGJCWeYTO/TgUSRhvVZ
         yNEg==
X-Gm-Message-State: AOAM531ypZ7cifLZA0PLCk5zfwlFDW1UzbEhpLgdr7JTua0SrQw5yQJg
        nbJ0rQBya1VG+DmguJ7M+zW0JQ==
X-Google-Smtp-Source: ABdhPJyAO1F86LpATpX13rxQnWzV7BjRnUO+onBahR+oWSETlxXBbl1cZjhcoNjBfMW72JaI3Dhm8Q==
X-Received: by 2002:a17:902:c410:b0:149:577c:2b08 with SMTP id k16-20020a170902c41000b00149577c2b08mr5957188plk.108.1641929874631;
        Tue, 11 Jan 2022 11:37:54 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id rm2sm2010382pjb.13.2022.01.11.11.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 11:37:53 -0800 (PST)
Date:   Tue, 11 Jan 2022 19:37:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Sabri N. Ferreiro" <snferreiro1@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sunhao.th@gmail.com
Subject: Re: WARNING in kvm_mmu_uninit_tdp_mmu
Message-ID: <Yd3cjllVD4vS17kG@google.com>
References: <CAKG+3NTTHD3iXgK67B4R3e+ScZ+vW5H4FdwLYy9CR5oBF44DOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKG+3NTTHD3iXgK67B4R3e+ScZ+vW5H4FdwLYy9CR5oBF44DOA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 09, 2022, Sabri N. Ferreiro wrote:
> Hi,
> 
> When using Syzkaller to fuzz the Linux kernel, it triggers the following crash.
> 
> HEAD commit: a7904a538933 Linux 5.16-rc6
> git tree: upstream
> console output: https://pastebin.com/raw/keWCUeJ2
> kernel config: https://docs.google.com/document/d/1w94kqQ4ZSIE6BW-5WIhqp4_Zh7XTPH57L5OF2Xb6O6o/view
> C reproducer: https://pastebin.com/raw/kSxa6Yit
> Syzlang reproducer: https://pastebin.com/raw/2RMu8p6E
> 
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Yuheng Shen mosesfonscqf75@gmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 5 PID: 29657 at arch/x86/kvm/mmu/tdp_mmu.c:46
> kvm_mmu_uninit_tdp_mmu+0xb9/0xf0

I wasn't able to reproduce to confirm, but this is more than likely fixed by
commit 3a0f64de479c ("KVM: x86/mmu: Don't advance iterator after restart due to yielding"),
which didn't land until 5.16-rc7.
