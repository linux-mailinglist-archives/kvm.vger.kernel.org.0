Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D9B17287C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 20:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgB0TUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 14:20:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37095 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbgB0TUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 14:20:34 -0500
Received: by mail-lj1-f193.google.com with SMTP id q23so511279ljm.4
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 11:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wD0YMiaevfN+rD/Y82hagTpEJtCW8Y8b9WogafbNlr4=;
        b=TG7xD62gYjK7JebjkwSkRbrtK7tgXmZfvP3BlvPcKRsY+UWUX/GDsGuX3IdePtnuL8
         A7STMFwgkh3q8DBiCkD1Bd4hO3+xgTGI6Rq9MvE3DdiY4jZbP8Ws8SxibxjDpIUDWAFj
         e5zse9h6xkdEo25W4b5f/heAsIPtHGyjPhWWm3VTiA1CPmNZ2t/Ob9GZN/ywhaBuxI3U
         6WOqdFskbcxvcsOBubvozsLBge6ki61QQ7YAPKWQ0eM5dBu0OLHiS1C0ZhZ0QxUPyjf8
         nd+oDjh4DmcwDiFwq+Ffe2Bo+TNWnIzO/dqfvqqg3kUFcXFc3y26crYwUrywzFSOKFid
         7AuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wD0YMiaevfN+rD/Y82hagTpEJtCW8Y8b9WogafbNlr4=;
        b=OB3lEV6G9eHa8BFOkugXhLrACsKe3hpp6gHOY5NvlUog8QGZI+Euh8izBfLIIQCqNz
         KyLmjNFZy47DP/eZ1PE6CA0Zj/l8jj5g9nVjItbMS+R0XI7e6BoMGNHmsLzDulAkJMKc
         j/YEr3k5AkxAZQafecSBG7clkVPiXIIGrT9+HeNTP5IakBWV1sPwfqydQTSN+IWmZCXI
         U2PPfIX/HGdr5Pz8lULMLpo2vjUpN0t3PY2U9GIKKYSyJi5OCQYVZE5mrdFgfwH57puY
         uzr0NJOkFhK+rSUTor6pVEgPQEOvsASTEW9H8PotUQ8mBTKKCjYlsNHcS4miRxQ+Pvbf
         dUiA==
X-Gm-Message-State: ANhLgQ3B+n/Hw8fLeHe7cqCiW8EdkcksvxJhkif9ycFOEA3XftyyF+Sb
        X++G0peoIYG+hbVUKEXLHOk2h4KKhklDAoJWf80YqQ==
X-Google-Smtp-Source: ADFU+vvhHL5c/vts6JKe9eR57rFbjH1YdyPqVOP0IJ/L10WMTLbiZ+hO3YSZtqAZvRhxSzUSGJh4bbXuP9SeiXRl7A4=
X-Received: by 2002:a05:651c:555:: with SMTP id q21mr333700ljp.241.1582831230661;
 Thu, 27 Feb 2020 11:20:30 -0800 (PST)
MIME-Version: 1.0
References: <20200227174430.26371-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200227174430.26371-1-sean.j.christopherson@intel.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 27 Feb 2020 11:20:19 -0800
Message-ID: <CAOQ_Qsg6z4d1oc0-rHQZW_7U9sLtjkAjifbpbGaoQK_Sg9gg1Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Consult only the "basic" exit reason when
 routing nested exit
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 9:47 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Consult only the basic exit reason, i.e. bits 15:0 of vmcs.EXIT_REASON,
> when determining whether a nested VM-Exit should be reflected into L1 or
> handled by KVM in L0.
>
> For better or worse, the switch statement in nested_vmx_exit_reflected()
> currently defaults to "true", i.e. reflects any nested VM-Exit without
> dedicated logic.  Because the case statements only contain the basic
> exit reason, any VM-Exit with modifier bits set will be reflected to L1,
> even if KVM intended to handle it in L0.
>
> Practically speaking, this only affects EXIT_REASON_MCE_DURING_VMENTRY,
> i.e. a #MC that occurs on nested VM-Enter would be incorrectly routed to
> L1, as "failed VM-Entry" is the only modifier that KVM can currently
> encounter.  The SMM modifiers will never be generated as KVM doesn't
> support/employ a SMI Transfer Monitor.  Ditto for "exit from enclave",
> as KVM doesn't yet support virtualizing SGX, i.e. it's impossible to
> enter an enclave in a KVM guest (L1 or L2).
>
> Fixes: 644d711aa0e1 ("KVM: nVMX: Deciding if L0 or L1 should handle an L2 exit")
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0946122a8d3b..127065bbde2c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5554,7 +5554,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>                                 vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
>                                 KVM_ISA_VMX);
>
> -       switch (exit_reason) {
> +       switch ((u16)exit_reason) {
>         case EXIT_REASON_EXCEPTION_NMI:
>                 if (is_nmi(intr_info))
>                         return false;
> --
> 2.24.1
>
Reviewed-by: Oliver Upton <oupton@google.com>
