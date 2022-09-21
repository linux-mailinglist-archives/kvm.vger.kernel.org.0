Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2995E5524
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiIUVYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiIUVYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:24:42 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1509A13FB7
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:24:40 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b21so6919031plz.7
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=XKEbM8caf/bjI9ySZ4wo5UYKS2yDp07XIi6tpk95wAs=;
        b=qZpKzh4tBmHgcEFntdD+k7EyXqJkN05az0IQxFiaUb9lwoyUnXb/j+9VhuhkiNwtWS
         DNFoGW5HQYU396dfaaqN38wsDElS1oL1qdvKFFbJwGQ0eLi5NGj3JhInXmhwjYvLomGt
         GnOFv2bnkYkxUklYSCoq/9D32Ztnyb7u+piCIDJEJa5oCBJaLFQKzFSgxlAoXGPk2+Ka
         UUxaUnYUiVe7VY9017NMMiiaXSafsCxXDkJbXR3q1KQp4lDmRmtyE8zCPzDIaatxzgx5
         35246ZQv6EU5mC2XaCQAygq2gh6zZ3Ri3pwZCU1AUBtVmGCbgXkfzdj77gEDDzoomgFx
         d+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=XKEbM8caf/bjI9ySZ4wo5UYKS2yDp07XIi6tpk95wAs=;
        b=uN37IbRLbJ7Byp2hKjbWNP0dBYNznruK2MXlLNn0EttPscsZMvCF11OSfc9+NOO49u
         YmP9QkJx0Jh0cR+8n/pzG6T2yFACMfZZnSD2OBq5Bhm7MxGLTp71AONaEDwXYQUh3KJr
         n4Cu/kQet6tCkYIL0wjsLnUcV2eBM2gZYDY6Xv30V8lGW0CjZTkBnvqb/c//Ql3qSjNj
         TTAiAJugGUfLpdlQCKICLEWEV+v4aSuzK7REntcVhFLwK2Lc7SD6xa0fpxXIIdf4DVlg
         jmG+9Jj6exJ3sr9CmTZpP+DJe2qmFnovJQTr36RYtj2vJe6HIOSuvAFgjBdRGjITG13E
         NR0A==
X-Gm-Message-State: ACrzQf0xhqIJyXM0kW/iXA4I/DCw6uNNU/DDEqQE7X0erkg2K2DiOgvd
        j02j9QI8wVLrV5f1eaolkCLli8mmr+PbWQ==
X-Google-Smtp-Source: AMsMyM5cRLUgFsjz3qEkvgjAk8pPt48HujqufXWsU+8rONMpkTaFoa4XizhZndYHyHB82rVqLI/U/A==
X-Received: by 2002:a17:902:ca05:b0:177:324a:784d with SMTP id w5-20020a170902ca0500b00177324a784dmr9604pld.11.1663795479507;
        Wed, 21 Sep 2022 14:24:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o2-20020a17090a4e8200b001f559e00473sm2341948pjh.43.2022.09.21.14.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:24:38 -0700 (PDT)
Date:   Wed, 21 Sep 2022 21:24:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 20/39] KVM: nVMX: hyper-v: Enable L2 TLB flush
Message-ID: <YyuBE4tphwbUSrtf@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-21-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921152436.3673454-21-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index 7ad56fbc4b4d..dd1589336e79 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -63,6 +63,15 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>  #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (0)
>  #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
>  
> +/*
> + * Note, Hyper-V isn't actually stealing bit 28 from Intel, just abusing it by
> + * pairing it with architecturally impossible exit reasons.  Bit 28 is set only
> + * on SMI exits to a SMI transfer monitor (STM) and if and only if a MTF VM-Exit
> + * is pending.  I.e. it will never be set by hardware for non-SMI exits (there
> + * are only three), nor will it ever be set unless the VMM is an STM.
> + */
> +#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031

This definition should go into hyperv-tlfs.h since it's take verbatim from the TLFS.

https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/nested-virtualization#synthetic-vm-exit
