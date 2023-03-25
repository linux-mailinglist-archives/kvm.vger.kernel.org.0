Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE646C8CE0
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 10:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjCYJF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Mar 2023 05:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjCYJFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Mar 2023 05:05:55 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80ED7AF33;
        Sat, 25 Mar 2023 02:05:54 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id s20so4009941ljp.1;
        Sat, 25 Mar 2023 02:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679735153; x=1682327153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jhbpEFk67D6hUVRHgU7NUb/AIOHjm0RIrXkV1zDsaxg=;
        b=H+qwl/kGKIjc5XQX8FKXhNDx7e6bQu+pgMxBq5iw3Ijmt8KALRDudsLNCdtLwAmT5N
         595dCnCg9/DwCCA8Lnpur7D9FWTypnrDJthfxq54Lv+dgQiG08q8aoKnrti8yBGlh1Q0
         CEeY5YWZjZQ5KYe/6JGh3ZsuVXkn16zupEyG9i4i5uMqwYvPyYmqD5cKDFJ4rBssKl3s
         xXDSTBoNilpS46j0HZAKx+LIOvCLFboLP8OQucDlQCQUY4rtCJDbgqchpk9rgNVdvzYd
         CJ9osxzuxVjJ+zsyxGee+UxCyD/84cbcteK2zf2+vAdpZtNL7e3T6Rtnq0YRARN7Xga6
         Rgow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679735153; x=1682327153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jhbpEFk67D6hUVRHgU7NUb/AIOHjm0RIrXkV1zDsaxg=;
        b=l3ILKb1j14oF0dlR8z6lXzFZtv2i/NtrIkpceRN4mqBzgBKTLMmNDPJl3lWaCM1xfk
         Yr/K8qXx4rCVJyUdsYhsNoubCnj66PspuGAS9Rr63dlmGyxSNjKKC3MjRsfwmJkn5TeE
         rKQAg8B+lhgFJ++IBBCkK6NPJsPVeTsXCjc592PFPUAE0/7OeIgBAho++l2y8wZuEwy0
         E1VkD9VdOFwEAmvGHIlplC9WiCBj3+1Io2SY7u2IdoYGMWITqUvwPxrunDTdt51Bn6XY
         KYGeYuS3+08JAR0H+df/61ozHOiQOBq6/Yw+W/P9Ta91GHxwooZUiDWjIhnAEDj7fRYJ
         83pw==
X-Gm-Message-State: AAQBX9dfFWy253ci33E8JgkkJ2X63uXGZfMST2Q1OY0EqVHUsHqwK4cN
        YJ3dViK7YyB0OYeBu6goYgA=
X-Google-Smtp-Source: AKy350Y+cC01kcLJ6U/wnucin3pcXJjxfbMjhtuA3lMThBuj/UxwPB5DhjVi2mQsB3YkqmUpPUQH+Q==
X-Received: by 2002:a2e:4a11:0:b0:298:b32d:6bea with SMTP id x17-20020a2e4a11000000b00298b32d6beamr1457955lja.5.1679735152396;
        Sat, 25 Mar 2023 02:05:52 -0700 (PDT)
Received: from localhost (88-113-32-99.elisa-laajakaista.fi. [88.113.32.99])
        by smtp.gmail.com with ESMTPSA id y1-20020a2eb001000000b002986854f27dsm3705931ljk.23.2023.03.25.02.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 02:05:52 -0700 (PDT)
Date:   Sat, 25 Mar 2023 11:05:50 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 017/113] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Message-ID: <20230325110550.00006091@gmail.com>
In-Reply-To: <7cdfc307ea8717849e71063ceebf1e328448e773.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <7cdfc307ea8717849e71063ceebf1e328448e773.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Mar 2023 10:55:41 -0700
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
> TDX specific sub-commands will be added to retrieve/pass TDX specific
> parameters.  Make mem_enc_ioctl non-optional as it's not optional now.
                                                        ^ it is optional now.
> 
> KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
> guest state-protected VM.  It defined subcommands for technology-specific
> operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
> are not limited to memory encryption, but various technology-specific
> operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
> for TDX specific operations and define subcommands.
> 
> TDX requires VM-scoped TDX-specific operations for device model, for
> example, qemu.  Getting system-wide parameters, TDX-specific VM
> initialization.

^ Above two paragraphs are the "background" paragraphs, they should be in
the beginning of the patch comments.

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 +-
>  arch/x86/kvm/vmx/main.c            |  9 +++++++++
>  arch/x86/kvm/vmx/tdx.c             | 26 ++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h         |  4 ++++
>  arch/x86/kvm/x86.c                 |  4 ----
>  5 files changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index b46dcac078b2..58fbaa05fc8c 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -117,7 +117,7 @@ KVM_X86_OP(enter_smm)
>  KVM_X86_OP(leave_smm)
>  KVM_X86_OP(enable_smi_window)
>  #endif
> -KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
> +KVM_X86_OP(dev_mem_enc_ioctl)

I guess it should be KVM_X86_OP(mem_enc_ioctl) here.

>  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 6a5d0c7a2950..8ddd263eeabc 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -50,6 +50,14 @@ static int vt_vm_init(struct kvm *kvm)
>  	return vmx_vm_init(kvm);
>  }
>  
> +static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> +{
> +	if (!is_td(kvm))
> +		return -ENOTTY;
> +
> +	return tdx_vm_ioctl(kvm, argp);
> +}
> +
>  #define VMX_REQUIRED_APICV_INHIBITS		       \
>  (						       \
>         BIT(APICV_INHIBIT_REASON_DISABLE)|	       \
> @@ -203,6 +211,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>  
>  	.dev_mem_enc_ioctl = tdx_dev_ioctl,
> +	.mem_enc_ioctl = vt_mem_enc_ioctl,
>  };
>  
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b59d3081d061..d759028a698e 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -72,6 +72,32 @@ int tdx_dev_ioctl(void __user *argp)
>  	return 0;
>  }
>  
> +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> +{
> +	struct kvm_tdx_cmd tdx_cmd;
> +	int r;
> +
> +	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
> +		return -EFAULT;
> +	if (tdx_cmd.error || tdx_cmd.unused)
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	switch (tdx_cmd.id) {
> +	default:
> +		r = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
> +		r = -EFAULT;
> +
> +out:
> +	mutex_unlock(&kvm->lock);
> +	return r;
> +}
> +
>  static int __init tdx_module_setup(void)
>  {
>  	const struct tdsysinfo_struct *tdsysinfo;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 78c5537e23a1..c70749114e9e 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -142,11 +142,15 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>  int tdx_hardware_enable(void);
>  bool tdx_is_vm_type_supported(unsigned long type);
>  int tdx_dev_ioctl(void __user *argp);
> +
> +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
>  static inline int tdx_hardware_enable(void) { return -EOPNOTSUPP; }
>  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>  static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
> +
> +static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>  #endif
>  
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a3dc32e33aca..8687623929c3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6978,10 +6978,6 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		goto out;
>  	}
>  	case KVM_MEMORY_ENCRYPT_OP: {
> -		r = -ENOTTY;
> -		if (!kvm_x86_ops.mem_enc_ioctl)
> -			goto out;
> -
>  		r = static_call(kvm_x86_mem_enc_ioctl)(kvm, argp);
>  		break;
>  	}

