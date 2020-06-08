Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3D21F2003
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 21:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgFHTiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 15:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgFHTiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 15:38:17 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F64AC08C5C3
        for <kvm@vger.kernel.org>; Mon,  8 Jun 2020 12:38:16 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id j18so8961294lji.2
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 12:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uexpwyn2fR7P1DcGlDr4HzbFjkt5L1616WAI7BXfvnM=;
        b=r/pKKW7ldNYNP5VPsKHOOYA9uiCiJDTOjL1qxw7wXFhqNSqZZ1N8qblK6dt54QqUUg
         eEplGmu6286Pb/e7cH0KQEBvToMQkN9LykMYJFc2UusP8YNKn0WwoDVzGkPixtKEVaes
         r6rS8bP0yW00zf7RnIM5Lv+a6HudIjwQaeJ/Uqr+Mh7arJU9kgpSTBhWoZtQErrLTIJK
         VGj40ZuwLCDffy95OV2HwmhW5RuBcPx9tSextzl+ojxDZeI7tCCAME8l3os7dvTM3ek7
         7/lN68YINGXozqT3qZIVgnF8dSfTiR8QSXOvBqiB68QcMGnhB8UF56nSN/qJxbETBV9L
         LyRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uexpwyn2fR7P1DcGlDr4HzbFjkt5L1616WAI7BXfvnM=;
        b=uEfd+kG0CHd74J4/bnYNWTWh19M6Dxw7pa8NZ1gHMKpynNF4v1yZVDX5YkUb8yuLMq
         CzFFX2eljHRaNAk6hnjljv4C147Nll6Xn6vHotmRXdLyB7v53jUqhyLb/CTtA7Ytn1jy
         fYS3svZeNGji8x4M1EeEl8IN/F1Y5GLSxC1Plg8Ay20Mh5cIjbH+vdbc2VOqMsXGKLFb
         D7jAFAqUZJdXjUS0L4BM9xJSDYO7W06YxkvOP5BuUoGgtAZ6fQiqUeYlUr1kPcxRZD03
         t6/7yiN9U3eZhNYoUAMc+hB4MZ/J4CeJIVsKpsaBAgV92k12n/jkwHDqe3NfDxg14iFk
         Ymig==
X-Gm-Message-State: AOAM530hZDYwtaqa/FvK1vv4lVd9XPg4OiSN2iGEIaiL1V/HnITaEdXl
        rlF21K7xuaSD7jmB1a5QpwWGoPxyzoeqNr3tg+rkJQ==
X-Google-Smtp-Source: ABdhPJxrj7FJ9fJQGeJQtBPLp7ShZUPGLANThjFoma8TGVYDJ4OyyT46PEHPEWDeFlK/FK+jySaCjca8WZ7k9lXI48o=
X-Received: by 2002:a2e:a17a:: with SMTP id u26mr11302926ljl.235.1591645094413;
 Mon, 08 Jun 2020 12:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200608191857.30319-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200608191857.30319-1-sean.j.christopherson@intel.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 8 Jun 2020 12:38:03 -0700
Message-ID: <CAOQ_QsjEnvk+ci8AAjytoFd+x8x3Li+iJjfT0gd=nMP036G9VQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: nVMX: Consult only the "basic" exit reason when
 routing nested exit
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 8, 2020 at 12:19 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Consult only the basic exit reason, i.e. bits 15:0 of vmcs.EXIT_REASON,
> when determining whether a nested VM-Exit should be reflected into L1 or
> handled by KVM in L0.
>
> For better or worse, the switch statements nested_vmx_l0_wants_exit()
> and nested_vmx_l1_wants_exit() default to reflecting the VM-Exit into L1
> for any nested VM-Exit without dedicated logic.  Because the case
> statements only contain the basic exit reason, any VM-Exit with modifier
> bits set will be reflected to L1, even if KVM intended to handle it in
> L0.
>
> Practically speaking, this only affects EXIT_REASON_MCE_DURING_VMENTRY,
> i.e. a #MC that occurs on nested VM-Enter would be incorrectly routed to
> L1, as "failed VM-Entry" is the only modifier that KVM can currently
> encounter.  The SMM modifiers will never be generated as KVM doesn't
> support/employ a SMI Transfer Monitor.  Ditto for "exit from enclave",
> as KVM doesn't yet support virtualizing SGX, i.e. it's impossible to
> enter an enclave in a KVM guest (L1 or L2).
>
> Note, the original version of this fix[*] is functionally equivalent and
> far more suited to backporting as the affected code was refactored since
> the original patch was posted.
>
> [*] https://lkml.kernel.org/r/20200227174430.26371-1-sean.j.christopherson@intel.com
>
> Fixes: 644d711aa0e1 ("KVM: nVMX: Deciding if L0 or L1 should handle an L2 exit")
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: stable@vger.kernel.org
> Cc: Oliver Upton <oupton@google.com>
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>
> Another wounded soldier.
>
> Oliver, Krish, and Miaohe all provided reviews for v1, but I didn't feel
> comfortable adding the tags to v2 because this is far from a straight
> rebase.
>
> v2: Rebased to kvm/queue, commit fb7333dfd812 ("KVM: SVM: fix calls ...").
>
>  arch/x86/kvm/vmx/nested.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bcb50724be38..adb11b504d5c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5672,7 +5672,7 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
>  {
>         u32 intr_info;
>
> -       switch (exit_reason) {
> +       switch ((u16)exit_reason) {
>         case EXIT_REASON_EXCEPTION_NMI:
>                 intr_info = vmx_get_intr_info(vcpu);
>                 if (is_nmi(intr_info))
> @@ -5733,7 +5733,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
>         struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>         u32 intr_info;
>
> -       switch (exit_reason) {
> +       switch ((u16)exit_reason) {
>         case EXIT_REASON_EXCEPTION_NMI:
>                 intr_info = vmx_get_intr_info(vcpu);
>                 if (is_nmi(intr_info))
> --
> 2.26.0
>
