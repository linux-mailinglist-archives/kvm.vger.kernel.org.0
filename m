Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FE7393A3C
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 02:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhE1A3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 20:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbhE1A3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 20:29:41 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B63C061760
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 17:28:07 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso1540324pji.0
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 17:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HsIFXy6XyY1Kl8elLwbDFy3dqG2MZ/zQxTfXHVcpZt4=;
        b=sl9k+mP7vVMY/eTSb/yN6svp99RNBde975CQqkqpTMkogQM4QS3s/ruwx6tufcfXCQ
         dlSbma1leXFhJYF/KkzGP6ETHxXTdQeI9XQjLPgCdc/8XXnS6olpq/jfzlxm/LzW7Y6Y
         vDJjzKfK/QfEY2ObYHgY3qkhtdeSJ/BWcQSGaKRpAwMb3rOSg8xRD5aFSzteiJ0z/Wfc
         oy2UPB62PGJPIEgicUaM6QeigB1LMlDN5MY6EzoRSfDwpKxU659pNrEMzUGdZv2flECn
         q2pOFd0yGooNtwg437Xp6ioceaPDvVz5kJK71J9CRe3LKU/iQ/70ssAeSdCHAo3yKD9a
         jLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HsIFXy6XyY1Kl8elLwbDFy3dqG2MZ/zQxTfXHVcpZt4=;
        b=Xy7NaOAko1mEwERzVkZrV2/rwwhwXP968Bbx+Pbq63F8W9W7kZeB/hWLqudbjOh6vd
         6wa+sMpqoOZB3efjUOaV5JRsDaaN7uOsts9zOe4bOfo8ljFDMN6JLRmphFO8+2UTOJhn
         cWUH6rppcOaW+7VlShTOwPmubxr2C2O9leJm0F1C0axKBvj2LT6rOJRA0ViTOa+Nmrur
         RF7FmXgFUaAS6Vy6jQRlOzKAutQUpHKTJmDgmwHnWtsYMUF7f+PoONr3givpyojYjb7Y
         taOcD40KD+F1SxOW8YA9ucS8LecnsxZF7YsgUQPihOQT5m+GnlIgjk7iv6h/6XUKA2v5
         YC/w==
X-Gm-Message-State: AOAM5339Td2dragdo9FubKed+vsm9g6/Zg1U22oVdJBv6vOHXqqnkzax
        xEuR8zTqA4a0jMoe19/Ak6YSlg==
X-Google-Smtp-Source: ABdhPJzF5xrTkowyMzuFFwUWiRRe7fknMlencg4R8ZBJmbwejfGkd48/EBxVDost18no4NUcL9APow==
X-Received: by 2002:a17:90b:1902:: with SMTP id mp2mr1252236pjb.176.1622161686609;
        Thu, 27 May 2021 17:28:06 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id m1sm2903200pgd.78.2021.05.27.17.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 17:28:05 -0700 (PDT)
Date:   Fri, 28 May 2021 00:28:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v4 1/2] KVM: X86: Fix warning caused by stale emulation
 context
Message-ID: <YLA5Egyhy5uKDSxq@google.com>
References: <1622160097-37633-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622160097-37633-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Reported by syzkaller:
> 
>   WARNING: CPU: 7 PID: 10526 at linux/arch/x86/kvm//x86.c:7621 x86_emulate_instruction+0x41b/0x510 [kvm]
>   RIP: 0010:x86_emulate_instruction+0x41b/0x510 [kvm]
>   Call Trace:
>    kvm_mmu_page_fault+0x126/0x8f0 [kvm]
>    vmx_handle_exit+0x11e/0x680 [kvm_intel]
>    vcpu_enter_guest+0xd95/0x1b40 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x377/0x6a0 [kvm]
>    kvm_vcpu_ioctl+0x389/0x630 [kvm]
>    __x64_sys_ioctl+0x8e/0xd0
>    do_syscall_64+0x3c/0xb0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Commit 4a1e10d5b5d8 ("KVM: x86: handle hardware breakpoints during emulation())
> adds hardware breakpoints check before emulation the instruction and parts of 
> emulation context initialization, actually we don't have the EMULTYPE_NO_DECODE flag 
> here and the emulation context will not be reused. Commit c8848cee74ff ("KVM: x86:
> set ctxt->have_exception in x86_decode_insn()) triggers the warning because it 
> catches the stale emulation context has #UD, however, it is not during instruction 
> decoding which should result in EMULATION_FAILED. This patch fixes it by moving 
> the second part emulation context initialization into init_emulate_ctxt() and 
> before hardware breakpoints check. The ctxt->ud will be dropped by a follow-up 
> patch.
> 
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000
> 
> Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
> Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
