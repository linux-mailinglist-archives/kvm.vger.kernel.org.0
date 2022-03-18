Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3764DD2C2
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 03:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiCRCIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 22:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiCRCIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 22:08:21 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A76F1770A1
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 19:07:03 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o6-20020a17090a9f8600b001c6562049d9so7150091pjp.3
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 19:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZXiy/C7hMwMxLnwuA1L60XS6noDYSqCJLi2XWmMShJY=;
        b=HdAYBQsaGCzzw8E2AYi3GkH8GMKUT0DIEZMfuEghBVQrnHPqg/87BmWOSjn7T/E+qt
         MbKnfNg9Xp6FUvdmca3Bsv5NJQeLaU9/OEsVtSTVvLhng/Ssm75/mkxU05iNjBf2CwpG
         9nyIdivEHI97g6FabsCOQPIOIMbf95Pt4y+NlIwdbiBSMXXCEboNjmj0rsoKQh/DQQ1R
         Qc4+sNsTggvpcX0/AQQPBu105EeFUbsbs82xFaK78NJ/X44e4TwN8trnrG/SRf9GcTA/
         nP1KNmgs9G2ipgURIxNX1okWfe6hSVoj1ttzRm8T8YeljrgVwYBNIQWO0rdS0e2FhKuP
         qNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZXiy/C7hMwMxLnwuA1L60XS6noDYSqCJLi2XWmMShJY=;
        b=KOTZZ/TtGsj+uQh+o81IN19HHCWgZWhfEOyrb1glZINZxYMYv33oKcgK/SZk4RR/wW
         PmfXUKXsDOWQhGlfQjmZTVcEnmjDFESJ8k3dJiu92Rn+qdwqVo2vr2koGD0ckrIDNRUI
         pa+ddOgF67q3anwaoY3GafNrVO7GXpg8W0Ko3yHKcYabcVp1sm+nz0toEWniWGLhKMZC
         LvWiKtVhVQDfK4iiW+g6ruxgtnSAWiPCW1jy4U0lU2KWS64CiL4o7nbZu9cQo1FJk/2d
         NR8f4omRf6i9r4TOYvQrr9hZpujChMIDWzIBOEJwu7CiO2PK4ZHMrL0nk/Jun1yp5cHB
         0xwQ==
X-Gm-Message-State: AOAM530y5EnhZ6iimrKyNnaHQZOMqycBMlBoTywtpj42fF7Hr5jKokdd
        blM6nH9d6wZSPlGIV1XjSTs=
X-Google-Smtp-Source: ABdhPJzrIITKIs04Bav53tODGnX7+92k0YLk1AlAiz7xzpR9xRBtJkSyo9jcFpuKl/TiUrTuZEYdcQ==
X-Received: by 2002:a17:90b:3ece:b0:1bf:16ac:7a1b with SMTP id rm14-20020a17090b3ece00b001bf16ac7a1bmr8636107pjb.236.1647569222575;
        Thu, 17 Mar 2022 19:07:02 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id na8-20020a17090b4c0800b001bf191ee347sm11362529pjb.27.2022.03.17.19.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 19:07:02 -0700 (PDT)
Date:   Thu, 17 Mar 2022 19:07:00 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 05/36] i386/tdx: Implement tdx_kvm_init() to
 initialize TDX VM context
Message-ID: <20220318020700.GA4006347@ls.amr.corp.intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-6-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317135913.2166202-6-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 09:58:42PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> Introduce tdx_kvm_init() and invoke it in kvm_confidential_guest_init()
> if it's a TDX VM. More initialization will be added later.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/kvm.c       | 15 ++++++---------
>  target/i386/kvm/meson.build |  2 +-
>  target/i386/kvm/tdx-stub.c  |  9 +++++++++
>  target/i386/kvm/tdx.c       | 13 +++++++++++++
>  target/i386/kvm/tdx.h       |  2 ++
>  5 files changed, 31 insertions(+), 10 deletions(-)
>  create mode 100644 target/i386/kvm/tdx-stub.c
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 70454355f3bf..26ed5faf07b8 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -54,6 +54,7 @@
>  #include "migration/blocker.h"
>  #include "exec/memattrs.h"
>  #include "trace.h"
> +#include "tdx.h"
>  
>  //#define DEBUG_KVM
>  
> @@ -2360,6 +2361,8 @@ static int kvm_confidential_guest_init(MachineState *ms, Error **errp)
>  {
>      if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_SEV_GUEST)) {
>          return sev_kvm_init(ms->cgs, errp);
> +    } else if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_TDX_GUEST)) {
> +        return tdx_kvm_init(ms, errp);
>      }
>  
>      return 0;
> @@ -2374,16 +2377,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>      Error *local_err = NULL;
>  
>      /*
> -     * Initialize SEV context, if required
> +     * Initialize confidential guest (SEV/TDX) context, if required
>       *
> -     * If no memory encryption is requested (ms->cgs == NULL) this is
> -     * a no-op.
> -     *
> -     * It's also a no-op if a non-SEV confidential guest support
> -     * mechanism is selected.  SEV is the only mechanism available to
> -     * select on x86 at present, so this doesn't arise, but if new
> -     * mechanisms are supported in future (e.g. TDX), they'll need
> -     * their own initialization either here or elsewhere.
> +     * It's a no-op if a non-SEV/non-tdx confidential guest support
> +     * mechanism is selected, i.e., ms->cgs == NULL
>       */
>      ret = kvm_confidential_guest_init(ms, &local_err);
>      if (ret < 0) {
> diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
> index b2d7d41acde2..fd30b93ecec9 100644
> --- a/target/i386/kvm/meson.build
> +++ b/target/i386/kvm/meson.build
> @@ -9,7 +9,7 @@ i386_softmmu_kvm_ss.add(files(
>  
>  i386_softmmu_kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
>  
> -i386_softmmu_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
> +i386_softmmu_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'), if_false: files('tdx-stub.c'))
>  
>  i386_softmmu_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
>  
> diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
> new file mode 100644
> index 000000000000..1df24735201e
> --- /dev/null
> +++ b/target/i386/kvm/tdx-stub.c
> @@ -0,0 +1,9 @@
> +#include "qemu/osdep.h"
> +#include "qemu-common.h"
> +
> +#include "tdx.h"
> +
> +int tdx_kvm_init(MachineState *ms, Error **errp)
> +{
> +    return -EINVAL;
> +}
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index d3792d4a3d56..e3b94373b316 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -12,10 +12,23 @@
>   */
>  
>  #include "qemu/osdep.h"
> +#include "qapi/error.h"
>  #include "qom/object_interfaces.h"
>  
> +#include "hw/i386/x86.h"
>  #include "tdx.h"
>  
> +int tdx_kvm_init(MachineState *ms, Error **errp)
> +{
> +    TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
> +                                                    TYPE_TDX_GUEST);

The caller already checks it.  This is redundant. Maybe assert?


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
