Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F135253D0
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 19:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357124AbiELRjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 13:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357126AbiELRjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 13:39:00 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CB15DBED
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:38:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id c1-20020a17090a558100b001dca2694f23so5527467pji.3
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bqZDswKO+uKOqiFNxu6bdQVfPx50iX/8NdeZL1KzfWg=;
        b=nVBZJ+JbXqDEc2yXMf5WXyTFHdDlNSWeLN/j1wcSeXokYE8j54VxOjeb+q1WMzjnFH
         gfc1KYqjD+e1pmcvz87XArJtjONoIG9QBOtFkPWhaFpc/BBxV43PQ327PpQesAZno3RV
         Za15on2Wp1/ja2Dy96WhhQms3y9RlD0E7DQlkaG6FpF26U2cbI7ePdYA+fp/R5EKLdgp
         6Yn2HTw9kjbl1s6CQuq12GNVJbmUGF9IRtbKjKiVhIobi9ROcHM59353gOVsXWm0Lm66
         ajDJK2c+54NKHtt8BlMeCJUA6A+VGerLfBou89BVJqdFRbj0t/adz2iopM8XBEPelM0h
         hYKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bqZDswKO+uKOqiFNxu6bdQVfPx50iX/8NdeZL1KzfWg=;
        b=Nls/UGknlm6KiHi+3bwhrWcF/QhLtNJ+mdTbyxswvUgDRA77eMamfv1wMuzw5S/YF0
         1THT+411NK5o00MhusJK8z4KAkWzpTvPr10qqHatieWU/TMsFBw7tUq/UPaUrapHgMqw
         XrO6VsjoXhE8Dossh/qoxByP/5nQRBeAHpDwW/m45OraXb7AMmS8s5HHZOj3STtQj8K5
         r7icf9KKeqwzTHbgIGiMggk2Cg/yAM2uCne86J146o9tgTuDzW5grdkla4+QxS9/NnIG
         FyOep8wbnVcEpcOESxWgKutxftpUmMW3mQk5auO47sBHmz/JBVPcu1ISzZQX8pcPGyfs
         v5oA==
X-Gm-Message-State: AOAM531pwYmDEaMUTd0qYXwfgBa3cipez26Ini86jSGk53tWTtkJX6XH
        g6PvhgSWwgunjwNnRtsABX0=
X-Google-Smtp-Source: ABdhPJwClBBDDgemPJ7T1eNmlRYn6KMSeFuTSyaX/cTNjfWJ8GwO83NjExKNPc7CBxWAg/ZyqDPGyQ==
X-Received: by 2002:a17:90b:30c4:b0:1d8:3395:a158 with SMTP id hi4-20020a17090b30c400b001d83395a158mr651456pjb.184.1652377138340;
        Thu, 12 May 2022 10:38:58 -0700 (PDT)
Received: from localhost ([192.55.54.48])
        by smtp.gmail.com with ESMTPSA id 123-20020a630581000000b003c14af5062esm2471pgf.70.2022.05.12.10.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 10:38:57 -0700 (PDT)
Date:   Thu, 12 May 2022 10:38:56 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
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
Subject: Re: [RFC PATCH v4 06/36] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
Message-ID: <20220512173856.GD2789321@ls.amr.corp.intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-7-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-7-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 11:17:33AM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> KVM provides TDX capabilities via sub command KVM_TDX_CAPABILITIES of
> IOCTL(KVM_MEMORY_ENCRYPT_OP). Get the capabilities when initializing
> TDX context. It will be used to validate user's setting later.
> 
> Besides, introduce the interfaces to invoke TDX "ioctls" at different
> scope (KVM, VM and VCPU) in preparation.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/tdx.c | 85 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 77e33ae01147..68bedbad0ebe 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -14,12 +14,97 @@
>  #include "qemu/osdep.h"
>  #include "qapi/error.h"
>  #include "qom/object_interfaces.h"
> +#include "sysemu/kvm.h"
>  
>  #include "hw/i386/x86.h"
>  #include "tdx.h"
>  
> +enum tdx_ioctl_level{
> +    TDX_PLATFORM_IOCTL,
> +    TDX_VM_IOCTL,
> +    TDX_VCPU_IOCTL,
> +};
> +
> +static int __tdx_ioctl(void *state, enum tdx_ioctl_level level, int cmd_id,
> +                        __u32 flags, void *data)
> +{
> +    struct kvm_tdx_cmd tdx_cmd;
> +    int r;
> +
> +    memset(&tdx_cmd, 0x0, sizeof(tdx_cmd));
> +
> +    tdx_cmd.id = cmd_id;
> +    tdx_cmd.flags = flags;
> +    tdx_cmd.data = (__u64)(unsigned long)data;
> +
> +    switch (level) {
> +    case TDX_PLATFORM_IOCTL:
> +        r = kvm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
> +        break;
> +    case TDX_VM_IOCTL:
> +        r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
> +        break;
> +    case TDX_VCPU_IOCTL:
> +        r = kvm_vcpu_ioctl(state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
> +        break;
> +    default:
> +        error_report("Invalid tdx_ioctl_level %d", level);
> +        exit(1);
> +    }
> +
> +    return r;
> +}
> +
> +static inline int tdx_platform_ioctl(int cmd_id, __u32 metadata, void *data)

nitpick:  Because metadata was renamed to flags for clarity, please update
those.

> +{
> +    return __tdx_ioctl(NULL, TDX_PLATFORM_IOCTL, cmd_id, metadata, data);
> +}
> +
> +static inline int tdx_vm_ioctl(int cmd_id, __u32 metadata, void *data)
> +{
> +    return __tdx_ioctl(NULL, TDX_VM_IOCTL, cmd_id, metadata, data);
> +}
> +
> +static inline int tdx_vcpu_ioctl(void *vcpu_fd, int cmd_id, __u32 metadata,
> +                                 void *data)
> +{
> +    return  __tdx_ioctl(vcpu_fd, TDX_VCPU_IOCTL, cmd_id, metadata, data);
> +}
> +
> +static struct kvm_tdx_capabilities *tdx_caps;
> +
> +static void get_tdx_capabilities(void)
> +{
> +    struct kvm_tdx_capabilities *caps;
> +    int max_ent = 1;

Because we know the number of entries for TDX 1.0. We can start with better
value with comment on it.


> +    int r, size;
> +
> +    do {
> +        size = sizeof(struct kvm_tdx_capabilities) +
> +               max_ent * sizeof(struct kvm_tdx_cpuid_config);
> +        caps = g_malloc0(size);
> +        caps->nr_cpuid_configs = max_ent;
> +
> +        r = tdx_platform_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
> +        if (r == -E2BIG) {
> +            g_free(caps);
> +            max_ent *= 2;
> +        } else if (r < 0) {
> +            error_report("KVM_TDX_CAPABILITIES failed: %s\n", strerror(-r));
> +            exit(1);
> +        }
> +    }
> +    while (r == -E2BIG);
> +
> +    tdx_caps = caps;
> +}
> +
>  int tdx_kvm_init(MachineState *ms, Error **errp)
>  {
> +    if (!tdx_caps) {
> +        get_tdx_capabilities();
> +    }
> +
>      return 0;
>  }
>  
> -- 
> 2.27.0
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
