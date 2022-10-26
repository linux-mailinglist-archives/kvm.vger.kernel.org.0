Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9615560EB75
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 00:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiJZWVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 18:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiJZWVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 18:21:18 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7B5CF184
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:21:17 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b185so10729046pfb.9
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hiWtZIzTaAaWrui3JWnnI5G6dQ2zJZsEty+ohQxMpns=;
        b=OfbKt/PzCkx8IH9c77QDVQo4BZxO1smbjIc6p1seYFzQc/Jmz+l2dwvWdsgg93sXbe
         G0cBYfuMoHM7Eclo0zK+LI27OVdHAyqPu4JT/YFk7E3LroH/YuLLtRCd69Ysfk8hqPCM
         NLUJymZplAcl0//1WeGFnHMkXJpTbArx7JzU7augCV9h2E53y081ZNcu2OQfdd/1B5cc
         3ZnC7goTnseZhW6PmLp1X0sgMJYGpHaJVupX2ETgcFQ5LGj2n0GigUKjmZoOReLbu+KI
         l0UROuepyprod6MHAGWo1CNYJB6rf3D6On0NmlQuovUtZ7MqRdRj9DXpR2AR/Zs8XX1X
         /3aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hiWtZIzTaAaWrui3JWnnI5G6dQ2zJZsEty+ohQxMpns=;
        b=eB15Uee4EI+zesWxNMmWxWTGAs/2rXz0nVI9XDPZkIICaBXcG/wwPpPnBGj2TvCpTp
         PIwzR2Z3ozDzyqrjFpm+VOI3kr7ySPesDAoWMEEQMoq4uVFg5ChvtusaAbFJsmCRfnqm
         pyPh4AX3/Xnwwy/q0K5Q2cH4RA///ZkKwB5M3OK0ZWdj661JXGEU5QnsN3SGsQ6njc1p
         JdzmR65Bz4jqQNslXYAmY/1N/yrBoA96OV3OuZJvGZj33GEjMEkhYRblguqApuarvNve
         FcBPTUPDtYNxH9LV+PtWJzgqyb9AgbidL9pKMhPDlnNjygyEORcM+7d/JrVFf6qjT/ZT
         Sqxw==
X-Gm-Message-State: ACrzQf0FLzWJ3ByDMOVFJ1eTOL0ep0QSfEnX41Gvfm2LYZOnbaz/We52
        fkzrwDLq6FGhaK+740fadKAefQ==
X-Google-Smtp-Source: AMsMyM5hrpil9ugkudCVguUFVraWGSpBWC+wjecNYCjY2aSXAER/OmLQ6T9zhYEnvxyShg7mp5oJVg==
X-Received: by 2002:a62:874f:0:b0:56c:45eb:1ffa with SMTP id i76-20020a62874f000000b0056c45eb1ffamr6925806pfe.58.1666822877077;
        Wed, 26 Oct 2022 15:21:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004393c5a8006sm3293275pgj.75.2022.10.26.15.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 15:21:16 -0700 (PDT)
Date:   Wed, 26 Oct 2022 22:21:13 +0000
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
Subject: Re: [PATCH v12 44/46] KVM: selftests: evmcs_test: Introduce L2 TLB
 flush test
Message-ID: <Y1my2eHz7QWme42e@google.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
 <20221021153521.1216911-45-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021153521.1216911-45-vkuznets@redhat.com>
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

On Fri, Oct 21, 2022, Vitaly Kuznetsov wrote:
> @@ -48,6 +49,8 @@ static inline void rdmsr_gs_base(void)
>  
>  void l2_guest_code(void)
>  {
> +	u64 unused;
> +
>  	GUEST_SYNC(7);
>  
>  	GUEST_SYNC(8);
> @@ -64,15 +67,33 @@ void l2_guest_code(void)
>  	vmcall();
>  	rdmsr_gs_base(); /* intercepted */
>  
> +	/* L2 TLB flush tests */
> +	hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
> +			 HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);
> +	rdmsr_fs_base();
> +	/*
> +	 * Note: hypercall status (RAX) is not preserved correctly by L1 after
> +	 * synthetic vmexit, use unchecked version.
> +	 */
> +	__hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
> +			   HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS,
> +			   &unused);
> +	/* Make sure we're not issuing Hyper-V TLB flush call again */
> +	__asm__ __volatile__ ("mov $0xdeadbeef, %rcx");

This needs a clobber.  It won't cause problems in the current code, but it will
make someone really sad if they add more code after this.

Using %ecx instead of %rcx will also suffice, 32-bit accesses clear bits 63:32.

Even better, if a "nop" isn't required to get the compiler to emit preamble, would
be to load ECX through an input constraint, that way the compiler "knows" the value
of ECX and can optimize for it (though it's extremely unlikely 0xdeadbeef will be
a useful value).

Actually, not setting RCX in vmcall() is a nasty bug waiting to happen, e.g. if
RCX just happens to contain a value that gets routed to L0.

Rather than handle this as a one-off, can you insert a prep patch to have the
common vmcall() stuff RCX with a "safe" value?

Related side topic, rdmsr_{f,g}s_base() should also use input constraints, and
should use a proper #define for the MSRs.  Also, why earth do those clobber all GPRs?
Oooh, because they get routed to L1 and L1 doesn't preserve GPRs.

Related side topic #2, KVM's kvm_xen_hypercall() is broken, it checks the wrong
input register for 64-bit (checks RAX instead of RCX).  Not sure that's even a
fixable bug though.
