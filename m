Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE994E67FE
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 18:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347055AbiCXRpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 13:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352378AbiCXRpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 13:45:50 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F7A24BFB
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:44:18 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n18so5511598plg.5
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JfImJNUCbOehpPz7FrsS+IWbAILIBYPU3ZnKO+FYvRQ=;
        b=s6x6LiUDzlAFTcLdWRbBUmnmxmCBr8FcdjXVQg4gtGYz1RPMAHUhAXgCqEBkFFwcac
         zvjHpBFRKv3l5P67SdaEE3NMmyz1r9Jl7TpFz/IzyAdERdMynMkMAZZZuTuJnmA7Ppi9
         zCcFIOZVEEnj6a4EsZgR/uLOPfbrFQytJ8x2JUyhKouhD5cGpRCLKJDVJ5Syhl+HHHuj
         SA7pyYynBbJZiM2Z1y+OJLgg+1vsLcSmzEtTo44ktiCo7W2gDJBaYI5C84+8wo9yl8Ry
         tvbi+0x1xyks/qHr8Ju5UdWYiNoFiXE7INhmWQGI1O3VCDl1YYg8YaN+wUAcjHXL+pPI
         Bofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JfImJNUCbOehpPz7FrsS+IWbAILIBYPU3ZnKO+FYvRQ=;
        b=oq06K+/KRHVn0yU/j3HOQeiLRCewVANw704y2DvjsXESss7Xdv/DFIya3VPIOAXmVo
         p/XSdJ4ley4IbVzKLG8Vca1gSd6bAJdKESHAMcgRpxAQP6WB/tX+ShJRpcrikxxSPoti
         JQkA4TQbIz4o4YAXX64gR5d8gcEeORRpH1VUJwgFs92dnHvUrhVZkA3XPZPUHyURqbpb
         NbHp4CnXwqR6qhuIZqAV2ZZLyE9AU4AmjFO4LWSUfEpalCjY5EalT6HYAtUWTKxCBRCv
         CzAS3XVDW4sQWGtCzdZXKmjUdXHblqzROkAF0Xo7Nc9+/ZO6OpXktTCjgEYhW+bKfAhJ
         eE3g==
X-Gm-Message-State: AOAM532gXsE+thk8rsZGvMxhWiE8o+LpWwIA0Sfb6zo1c7nboxZUVcmC
        tk/av6X/hTyR11FkdXw7WT2uZw==
X-Google-Smtp-Source: ABdhPJwEj/KvNOhl0CTc+LyA5hlt/xvDR3AEUhD3yUm9iBY5YXLElLl+8Yf9fpqWuYmxZtPv8d92Xg==
X-Received: by 2002:a17:90b:2308:b0:1c6:96f9:8d0 with SMTP id mt8-20020a17090b230800b001c696f908d0mr19641036pjb.127.1648143858087;
        Thu, 24 Mar 2022 10:44:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u204-20020a6279d5000000b004fa58625a80sm4100754pfc.53.2022.03.24.10.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 10:44:17 -0700 (PDT)
Date:   Thu, 24 Mar 2022 17:44:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall
 patching
Message-ID: <Yjyt7tKSDhW66fnR@google.com>
References: <20220316005538.2282772-1-oupton@google.com>
 <20220316005538.2282772-2-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316005538.2282772-2-oupton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022, Oliver Upton wrote:
> KVM handles the VMCALL/VMMCALL instructions very strangely. Even though
> both of these instructions really should #UD when executed on the wrong
> vendor's hardware (i.e. VMCALL on SVM, VMMCALL on VMX), KVM replaces the
> guest's instruction with the appropriate instruction for the vendor.
> Nonetheless, older guest kernels without commit c1118b3602c2 ("x86: kvm:
> use alternatives for VMCALL vs. VMMCALL if kernel text is read-only")
> do not patch in the appropriate instruction using alternatives, likely
> motivating KVM's intervention.
> 
> Add a quirk allowing userspace to opt out of hypercall patching.

A quirk may not be appropriate, per Paolo, the whole cross-vendor thing is
intentional.

https://lore.kernel.org/all/20211210222903.3417968-1-seanjc@google.com

> If the quirk is disabled, KVM synthesizes a #UD in the guest.

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d3a9ce07a565..685c4bc453b4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9291,6 +9291,17 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
>  	char instruction[3];
>  	unsigned long rip = kvm_rip_read(vcpu);
>  
> +	/*
> +	 * If the quirk is disabled, synthesize a #UD and let the guest pick up
> +	 * the pieces.
> +	 */
> +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
> +		ctxt->exception.error_code_valid = false;
> +		ctxt->exception.vector = UD_VECTOR;
> +		ctxt->have_exception = true;
> +		return X86EMUL_PROPAGATE_FAULT;

This should return X86EMUL_UNHANDLEABLE instead of manually injecting a #UD.  That
will also end up generating a #UD in most cases, but will play nice with
KVM_CAP_EXIT_ON_EMULATION_FAILURE.
