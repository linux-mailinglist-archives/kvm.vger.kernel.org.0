Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139574DD2CA
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 03:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiCRCKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 22:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiCRCJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 22:09:58 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117C819530B
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 19:08:41 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id o26so4052466pgb.8
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 19:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hmqBxtk4KBce1d7JwMLgrUTHii5BY8s0u21fhI5bosc=;
        b=YzsYMHtSPTMzxXxn6dVBRzIwcoulVgqW6UWSaM4KWyuF4IYi/lvHeq/XIdHHkEfLgn
         oAko8LQ3k+A/QyIFNCB31kcRWFxjZZ7JokaNgpCcyp3yrGmfPk9w+6Q9PNDEWjbtlT9D
         0zqRxxXAm+VbCamyilC7+8FRuEc4yNg6Q4TEE/07hSpM6hZs6XknIOCVn5NmsxtURxgQ
         768cixR5RBXxzR08Y0YL61mfPYvMFjcO2hnRiDccHqhVXQwJky8YrQUeVvNRMc5i5wZq
         WHKoLc8amJ52jvZOiqFKEtj+75BS+MKd4RQ6V90y/GHJ7R2AnQ7y1yHL+xyb01LTtiuH
         QXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hmqBxtk4KBce1d7JwMLgrUTHii5BY8s0u21fhI5bosc=;
        b=1kRF0ou9ildFA+pHxCSzOF5CNc6Crby9ZLIQ248oeeOe5/JRFw6w8asTszCBD5dW25
         k11wzwmocoUAnP1FnBCElTp0GcOeq3KgxtXeulY3F1MPJ7kDoNNTH89HlaEV5j9Y70V4
         vuh6/+iPw28sCnYQ3yg3jR27LCDDV3fh7e2kEjfiHknDlnLLm48gnX8YhWOpQfjawg94
         sI49JwdviHq1F2cqRXux2RhCWpIKeAwBFwI/CTTiynSpGQtK53tDb7J32pZ3eE9qSjid
         eUjp+alu1x7Vr2GueL8kgoT1LGSCmHe/V+rSz4TEtcIVP0UNc3Esh7g4YlxwsgzIutLS
         i4Cg==
X-Gm-Message-State: AOAM532NmI2t7CViqkv1qIiezvnyN9wXXC7t9voYzS553Cl1/08TELZ4
        BFj/kvKAmQn9dduqVWTdj3w=
X-Google-Smtp-Source: ABdhPJx1Haet6V1UVNRmxmsdmtI919fxY6r2iSFakm9GxnwkGZLUYcpHq3znCQBY2F31P9GoCvjYmw==
X-Received: by 2002:a63:110e:0:b0:375:89f4:b54e with SMTP id g14-20020a63110e000000b0037589f4b54emr6118104pgl.430.1647569320164;
        Thu, 17 Mar 2022 19:08:40 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id f31-20020a631f1f000000b003742e45f7d7sm6325122pgf.32.2022.03.17.19.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 19:08:39 -0700 (PDT)
Date:   Thu, 17 Mar 2022 19:08:38 -0700
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
Subject: Re: [RFC PATCH v3 06/36] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
Message-ID: <20220318020838.GB4006347@ls.amr.corp.intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-7-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317135913.2166202-7-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 09:58:43PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index e3b94373b316..bed337e5ba18 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -14,10 +14,77 @@
>  #include "qemu/osdep.h"
>  #include "qapi/error.h"
>  #include "qom/object_interfaces.h"
> +#include "sysemu/kvm.h"
>  
>  #include "hw/i386/x86.h"
>  #include "tdx.h"
>  
> +enum tdx_ioctl_level{
> +    TDX_VM_IOCTL,
> +    TDX_VCPU_IOCTL,
> +};
> +
> +static int __tdx_ioctl(void *state, enum tdx_ioctl_level level, int cmd_id,
> +                        __u32 metadata, void *data)
> +{
> +    struct kvm_tdx_cmd tdx_cmd;
> +    int r;
> +
> +    memset(&tdx_cmd, 0x0, sizeof(tdx_cmd));
> +
> +    tdx_cmd.id = cmd_id;
> +    tdx_cmd.metadata = metadata;
> +    tdx_cmd.data = (__u64)(unsigned long)data;
> +
> +    switch (level) {
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
> +#define tdx_vm_ioctl(cmd_id, metadata, data) \
> +        __tdx_ioctl(NULL, TDX_VM_IOCTL, cmd_id, metadata, data)
> +
> +#define tdx_vcpu_ioctl(cpu, cmd_id, metadata, data) \
> +        __tdx_ioctl(cpu, TDX_VCPU_IOCTL, cmd_id, metadata, data)

No point to use macro.  Normal (inline) function can works.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
