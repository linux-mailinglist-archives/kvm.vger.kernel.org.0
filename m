Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A664552541D
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 19:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357330AbiELRv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 13:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357342AbiELRvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 13:51:03 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ED1186D8
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:51:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w17-20020a17090a529100b001db302efed6so5547462pjh.4
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fNBBVy+Cxc1RMi9VEsz9pCMNiJoDsT/4/B0gBmZ9Iao=;
        b=aXMWW7/HCY8ibQ+vQ0lMGfk12i2XCTThPLGxSFkgo8ViKNH3nkmwfZR66od8DZlGXF
         Lx0xKUBmIzdJAAZBKTStHI2J1lEtcykxafxfWTVIzhg2NACSkMPaHOLsEY6eNa8kBhhC
         8X01uZat4shaMo0rFqR2HqGsAbK75dlcuB7E7UiYniVYFffN6nQ6FU+XKoMEYaFT3ygQ
         0vnLt1sdKeLdv4JeyggUv3maZLNvPc42uizGMfsyssWXb2fDKZWHA/llN+0uSjrJ+nV9
         VDpUge0lqnCi78nc5H3HsJQkAUhdNi3+U7bVX0O7ur3DEHyowpp5hxcUXceuxgOboRYx
         S0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fNBBVy+Cxc1RMi9VEsz9pCMNiJoDsT/4/B0gBmZ9Iao=;
        b=QXzHFgKs2+rT1BlPHu1fn/ZJ43Tsr2tchqg5Sop5LIfFNdxl5ZU2/dmLYMiGOApWXw
         qSxLiAKS1j+mQjT5u86jA91jYKXmMjdmGVIJa8eH7FFpkPl9IVd2zEBnqEaf2uVnd6Mw
         wjrQT6XGfGuoQIX69JZJidILrIj/4GcN/mSmwpv92hUVac/y8PtSlb6KKuD6IeKlTsXL
         Px3cU1kTUIud0wzvlBPSY8+z8/vNWYN68noMIt/LuFHeAycrrklEFKkbLDtda4tCvQxv
         kJFXt1mBS6LvGisUx0m7zdLuP6So7T5ROz17gtRyWem+JyLfaPy/gYtnoFMW74GSW5BJ
         EmpA==
X-Gm-Message-State: AOAM530fxyhXash0jXhVrB7T/fuZjO3b3z1I4Q+25x0uDslPtekOxxza
        VX+5/FuX+vzrDphOxtrtjqs=
X-Google-Smtp-Source: ABdhPJxHzvDtaxGj2a+/AOqMRNdWD4bA+szSZvINcMPxmsyjCwgWd/qfA32pcDton1e/S9c5P2r5dw==
X-Received: by 2002:a17:90b:502:b0:1d9:a907:d845 with SMTP id r2-20020a17090b050200b001d9a907d845mr713856pjz.162.1652377861345;
        Thu, 12 May 2022 10:51:01 -0700 (PDT)
Received: from localhost ([192.55.54.48])
        by smtp.gmail.com with ESMTPSA id f8-20020aa78b08000000b0050dc7628202sm92778pfd.220.2022.05.12.10.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 10:51:00 -0700 (PDT)
Date:   Thu, 12 May 2022 10:50:59 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, g@ls.amr.corp.intel.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 09/36] KVM: Introduce kvm_arch_pre_create_vcpu()
Message-ID: <20220512175059.GF2789321@ls.amr.corp.intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-10-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-10-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 11:17:36AM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
> work prior to create any vcpu. This is for i386 TDX because it needs
> call TDX_INIT_VM before creating any vcpu.

Because "11/36 i386/tdx: Initialize TDX before creating TD vcpus" uses
kvm_arch_pre_create_vcpu() (and 10/36 doesn't use it), please move this patch
right before 11/36. (swap 09/36 and 10/36).

Thanks,

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  accel/kvm/kvm-all.c  | 12 ++++++++++++
>  include/sysemu/kvm.h |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 32e177bd26b4..e6fa9d23207a 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -457,6 +457,11 @@ static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
>      return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
>  }
>  
> +int __attribute__ ((weak)) kvm_arch_pre_create_vcpu(CPUState *cpu)
> +{
> +    return 0;
> +}
> +
>  int kvm_init_vcpu(CPUState *cpu, Error **errp)
>  {
>      KVMState *s = kvm_state;
> @@ -465,6 +470,13 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>  
>      trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
>  
> +    ret = kvm_arch_pre_create_vcpu(cpu);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret,
> +                         "kvm_init_vcpu: kvm_arch_pre_create_vcpu() failed");
> +        goto err;
> +    }
> +
>      ret = kvm_get_vcpu(s, kvm_arch_vcpu_id(cpu));
>      if (ret < 0) {
>          error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index a783c7886811..0e94031ab7c7 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -373,6 +373,7 @@ int kvm_arch_put_registers(CPUState *cpu, int level);
>  
>  int kvm_arch_init(MachineState *ms, KVMState *s);
>  
> +int kvm_arch_pre_create_vcpu(CPUState *cpu);
>  int kvm_arch_init_vcpu(CPUState *cpu);
>  int kvm_arch_destroy_vcpu(CPUState *cpu);
>  
> -- 
> 2.27.0
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
