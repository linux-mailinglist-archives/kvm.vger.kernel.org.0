Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1124B74033A
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 20:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjF0S3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 14:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjF0S3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 14:29:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00FBE58
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 11:28:59 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b50a3809a1so743065ad.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 11:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687890539; x=1690482539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MOaqBvixOW3x98UwibxOqBic6iDT/fgo05f/EM7KrhE=;
        b=I3gXWAJgtGihnOVBLkXXabjfTRTeupaaaW6Xn54va727a8UVTmIc0oTRGqiu9PgkGT
         Ecjj/yJaji3m8v79Bf+O3tISmzqtJiXStCbFMpj7ebJo6kTLjOQYlMF7f2VwLmjcP/bo
         3bD3Js4TrDmJ53ObLgJmyxQm3yPkoXmfyzJFWhi5oepuhKfFF86WCsCDY7Suo56N1brM
         oIBjJyjeiMZNgmQHxMBqw1zb5AzXxLSsJ5aGfdq9J6012Jy3rotkcr3nomLim4Fs4T2O
         j891mDYppfBGO1NxF6zABmrIayZhJjgFVPrR2W6pZrq5Njflgjc5nhwlfO92cb9bn6HW
         2qKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687890539; x=1690482539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MOaqBvixOW3x98UwibxOqBic6iDT/fgo05f/EM7KrhE=;
        b=h/p28I73BlFZir60h+8HGEYu5jhMYVKHmfNJ13muXcCCK3e1lNYezmF1DPju5wyMkn
         THq5k3hCTETje/9uWLg8BcNibYaVWjDxZivAjjD+ddiA+SJCohNEewy8Iec8iP8pmplj
         MaBdI78lnu7/kuvK1mzUD2FuSyk4YEGt4TJvIqD7dw6lrCSlsyE1cB4OdLJqamqKvC/U
         3yDnpJxH82cYL+SS067TcRYtfCVBxctqQgWZTRxUs8z2Y2J0JkqBVlh4gOL/0MZF6EhL
         4OS32OlOemqVs8nhQhS02RnFbJD5VFlYkUqv53eb88B1f3LDQ1mVrZ1QfJx4lKMla9cS
         lR/g==
X-Gm-Message-State: AC+VfDysTsn5krEHyMoa/DkPJDLHcJXoGl3qzH4WfrxFG5xM7VMn8a5V
        aOI1iLtsPj5eAYIWcn1+OKYNzvKET8s=
X-Google-Smtp-Source: ACHHUZ457VEY1UWaYsp3e8te2aqiOGVuMXJD8VeBEcw6bS4ROqFeRhft7xiuubPYUxAlw7tuUs8EFo+pYGw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:9893:b0:1b5:1610:d550 with SMTP id
 s19-20020a170902989300b001b51610d550mr1538915plp.3.1687890539298; Tue, 27 Jun
 2023 11:28:59 -0700 (PDT)
Date:   Tue, 27 Jun 2023 11:28:58 -0700
In-Reply-To: <20230601142309.6307-5-guang.zeng@intel.com>
Mime-Version: 1.0
References: <20230601142309.6307-1-guang.zeng@intel.com> <20230601142309.6307-5-guang.zeng@intel.com>
Message-ID: <ZJsqanMgqOp6M8j/@google.com>
Subject: Re: [PATCH v1 4/6] KVM: x86: Add emulator helper for LASS violation check
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023, Zeng Guang wrote:
> When LASS is enabled, KVM need apply LASS violation check to instruction
> emulations. Add helper for the usage of x86 emulator to perform LASS
> protection.
> 
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
>  arch/x86/kvm/kvm_emulate.h |  1 +
>  arch/x86/kvm/x86.c         | 12 ++++++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index f1439ab7c14b..fd1c2b22867e 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -230,6 +230,7 @@ struct x86_emulate_ops {
>  	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
>  	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
>  	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
> +	bool (*check_lass)(struct x86_emulate_ctxt *ctxt, u64 access, u64 la, u32 flags);
>  };
>  
>  /* Type, address-of, and value of an instruction's operand. */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c0778ca39650..faf01fecc4ca 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8287,6 +8287,17 @@ static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
>  		kvm_vm_bugged(kvm);
>  }
>  
> +static bool emulator_check_lass(struct x86_emulate_ctxt *ctxt,
> +				u64 access, u64 la, u32 flags)
> +{
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> +
> +	if (!is_long_mode(vcpu))
> +		return false;

Likely a moot point if we wrap ->gva_to_gpa(), but most this into the vendor
implementation.

And if we keep these emulator hooks, massage the patch ordering:

  1. Add plumbing to emulator to pass new flags
  2. Add kvm_x86_ops definition and invocation from emulator
  3. Implement and wire up vmx_is_lass_violation()

That way the changes to each area of KVM are better isolated.

> +	return static_call(kvm_x86_check_lass)(vcpu, access, la, flags);
> +}
> +
>  static const struct x86_emulate_ops emulate_ops = {
>  	.vm_bugged           = emulator_vm_bugged,
>  	.read_gpr            = emulator_read_gpr,
> @@ -8332,6 +8343,7 @@ static const struct x86_emulate_ops emulate_ops = {
>  	.leave_smm           = emulator_leave_smm,
>  	.triple_fault        = emulator_triple_fault,
>  	.set_xcr             = emulator_set_xcr,
> +	.check_lass          = emulator_check_lass,
>  };
>  
>  static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
> -- 
> 2.27.0
> 
