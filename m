Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56B45B2149
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 16:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiIHOw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 10:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiIHOwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 10:52:43 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5925A114A51
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 07:52:41 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v1so4788853plo.9
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 07:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=MSOIR1a3zpSQbiZ6BxPUkenjZWqqxMNPgXiYxLKVulI=;
        b=RLVPcDpNX2GnFwnSbFL5yGt59wXXkRKxKVNl72IL/oZLJCNR/eLAAMRNdr73flqdKd
         SqVbnNaPqH+Vm/EZCMTsTZZKDX5rVxdhvCEeKgQy7PL36Ij6SeeW4nugFiu8VtvcjH0Y
         pR2xGndeDBoAd4gpmj4z6+3ysMZLV+Du1vm7FjGTD58Pr1tEGtuPdFYgHoJ5yUTEHbeg
         pJCRO2WCx6v86IuCkjbimtYkg2IocCaaxFb3DSj9rHku3XGDiFCT1NOk8xuRWm8HZp63
         +CHd6T/DKvwrt8ayn69Ll7D9iQ45VETFtSa1jdamPPiINe+d+sLlRHc31r4Eny22F6i/
         JE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=MSOIR1a3zpSQbiZ6BxPUkenjZWqqxMNPgXiYxLKVulI=;
        b=lku9ms+qRXj0nRMftqdRwo4nTZ0ZHIzy3uPZB95nAE4sWBY5xSfmq/DVzFW109F9NG
         JHaSN8DtUMgwdSCl9KIGHDOVWe8w5ZjH/erzVT7Lq1l9Oy2Yaso4Zt4ojsRMLnC7hrV8
         on2+Kx1iy/fLKrWuSgwD4SqJ8ETyZuzrX/WbR5cybBMnGd6y1Fg6adHtxjB0LBwfQhdI
         0cQJdwh94cmE4umNzRvSgVeyR8c7UwLzHMgFtbnUWQ40fWNM4ZAl8NWqQnAz0gLzIt28
         xbcpo+DQftpZXls9087iWgqYtuwtpXT2C8MFSjc/3rpTCHa8chJd0jl89CAeKp3MvpUw
         Vrxw==
X-Gm-Message-State: ACgBeo3TyoCSVjaCu3n6dR49YQ0JWYJqpKBLJ9tuDJhFn20fKcMFEZAK
        aYrxrZydHK9+UXibxPdeLnU3mw==
X-Google-Smtp-Source: AA6agR5pAPjlU4QMW3Yf7UfXUukfPnrbXzt5ySBoXQZbL5vKiH5NLEwPnDBy79QFCjmCnxNF8tQU3w==
X-Received: by 2002:a17:902:ce11:b0:172:6f2c:a910 with SMTP id k17-20020a170902ce1100b001726f2ca910mr9281976plg.156.1662648760765;
        Thu, 08 Sep 2022 07:52:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j4-20020a63fc04000000b0040caab35e5bsm12880736pgi.89.2022.09.08.07.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:52:40 -0700 (PDT)
Date:   Thu, 8 Sep 2022 14:52:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm/x86: reserve bit
 KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID
Message-ID: <YxoBtD+3sgEEiaFF@google.com>
References: <20220908114146.473630-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908114146.473630-1-kraxel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022, Gerd Hoffmann wrote:
> The KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID bit hints to the guest
> that the size of the physical address space as advertised by CPUID
> leaf 0x80000008 is actually valid and can be used.
> 
> Unfortunately this is not the case today with qemu.  Default behavior is
> to advertise 40 address bits (which I think comes from the very first x64
> opteron processors).  There are lots of intel desktop processors around
> which support less than that (36 or 39 depending on age), and when trying
> to use the full 40 bit address space on those things go south quickly.
> 
> This renders the physical address size information effectively useless
> for guests.  This patch paves the way to fix that by adding a hint for
> the guest so it knows whenever the physical address size is usable or
> not.
> 
> The plan for qemu is to set the bit when the physical address size is
> valid.  That is the case when qemu is started with the host-phys-bits=on
> option set for the cpu.  Eventually qemu can also flip the default for
> that option from off to on, unfortunately that isn't easy for backward
> compatibility reasons.
> 
> The plan for the firmware is to check that bit and when it is set just
> query and use the available physical address space.  When the bit is not
> set be conservative and try not exceed 36 bits (aka 64G) address space.
> The latter is what the firmware does today unconditionally.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  arch/x86/include/uapi/asm/kvm_para.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 6e64b27b2c1e..115bb34413cf 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -37,7 +37,8 @@
>  #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
>  #define KVM_FEATURE_MIGRATION_CONTROL	17
>  
> -#define KVM_HINTS_REALTIME      0
> +#define KVM_HINTS_REALTIME                      0
> +#define KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID  1

Why does KVM need to get involved?  This is purely a userspace problem.  E.g. why
not use QEMU's fw_cfg to communicate this information to the guest?

Defining this flag arguably breaks backwards compatibility for VMMs that already
accurately advertise MAXPHYADDR.  The absence of the flag would imply that MAXPHYADDR
is invalid, which is not the case.
