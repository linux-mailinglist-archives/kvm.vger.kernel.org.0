Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E955FC95B
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiJLQfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJLQfG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:35:06 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DE32F3AB
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:35:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x6so16721069pll.11
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Det2ITA/n+WXH8RhBcuNargdlyOW5bs99Gk+aJ7/qCQ=;
        b=QMdpGzfBf0NldWY/bD/I/AQC+34DaQ6T41DAl98Jbq3s4BBRU97wbxp6mrDPsK+Ajy
         2edzfjH61I/TPtM4Ld3Sg286tM7g4/bes7Zj7CMqf7PHJuiZGAuKkb6vrw7R0AqElJ9g
         q5JEZvX/mhYNsoqrl/mrS7yh+EMgeDi+PhabUfW+c9hkX5GBav4GP492SXT4icsqZZ/V
         eezHq/vlZYz/Pecf8ouJtRivFcbERqR8LAZMKRKHEx10V7KKojX63yeROb8OYzdtW9eV
         xcjCMO/aCFW0H9FYI8asOxTjzUTXU1kGeFnALca+5xVmM5t5zT1ohcqLE2wChC6vaWJL
         3d2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Det2ITA/n+WXH8RhBcuNargdlyOW5bs99Gk+aJ7/qCQ=;
        b=FdaoGaTkS65P/x9t4obga6UxeffYbeeWF2dJwRXF+Z/oiufUtbnH0CfZQhQTYUlMOH
         AnJZHPyBKQy47wnvP+8e+ozA8RbceX4And3kCaiQF0C1TkiDV9+hUcdgF4xoLlSMN11C
         51EnUTCrO8a5jFfrOLPJLbNTsZEEp5qGyhSBKta7aetUtbbVFzytfR6OXSpfROzCUiZQ
         SfsmToOSRuAfy+NDmPJ2T7mkrswhw/H/qlmKfWFfVWBfQ5BpwyCGV4o+SPe47uNFdT8n
         u6u3yZC2MmFLGp9FbSzKvRFJsihXAQ2g/7r3inyZQT8Eyseh2jb79Se4AJj3CevZ6DlZ
         xekQ==
X-Gm-Message-State: ACrzQf2sj41/i2ne3es7tyB5Weiyz7DI3LgveUG268ClsrZqwqESH0FI
        b0u+eRBV8hA86g3RZG66STQzMg==
X-Google-Smtp-Source: AMsMyM5bRwBjSvlQxjunzry9lBqSVllHge5nfGrWav7re3NtQU4PfgFY/iLmKUI5YvxO/sC4U49WJw==
X-Received: by 2002:a17:90b:1e4b:b0:20d:2ad0:ce00 with SMTP id pi11-20020a17090b1e4b00b0020d2ad0ce00mr6388449pjb.72.1665592502345;
        Wed, 12 Oct 2022 09:35:02 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902f34200b0017a1145eec7sm10799750ple.157.2022.10.12.09.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 09:35:01 -0700 (PDT)
Date:   Wed, 12 Oct 2022 16:34:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Mark transfer type as X86_TRANSFER_RET when
 loading CS in iret emulation
Message-ID: <Y0bssbjJTQVB+SCg@google.com>
References: <fcaf1408d2aaaa39b33cdd3b11bf06e7e935d11a.1665565774.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcaf1408d2aaaa39b33cdd3b11bf06e7e935d11a.1665565774.git.houwenlong.hwl@antgroup.com>
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

On Wed, Oct 12, 2022, Hou Wenlong wrote:
> When loading code segment descriptor in iret instruction emulation, the
> checks are same as far return instruction emulation, so transfer type
> should be X86_TRANSFER_RET in __load_segment_descriptor(). Although,
> only iret in real mode is implemented now, and no checks are actually
> needed for real mode, it would still be better to mark transfer type as
> X86_TRANSFER_RET.

It's not strictly a RET though.  The RPL vs. DPL checks in __load_segment_descriptor()
might do the right thing, but there's a rather large pile of stuff IRET can do that
RET can't (ignoring the fact that KVM doesn't even emulate FAR RET to outer privilege
levels).

And __emulate_int_real() also loads CS with X86_TRANSFER_NONE, i.e. KVM still has
a weird path to worry about.

Rather than make the IRET case slightly less wrong, what about adding a sanity
check in __load_segment_descriptor() that KVM doesn't attempt to load CS in Protected
Mode with X86_TRANSFER_NONE?

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3b27622d4642..fe735e18c419 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1641,6 +1641,14 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
                        goto exception;
                break;
        case VCPU_SREG_CS:
+               /*
+                * KVM uses "none" when loading CS as part of emulating Real
+                * Mode exceptions and IRET (handled above).  In all other
+                * cases, loading CS without a control transfer is a KVM bug.
+                */
+               if (WARN_ON_ONCE(transfer == X86_TRANSFER_NONE))
+                       goto exception;
+
                if (!(seg_desc.type & 8))
                        goto exception;

> 
> No functional change intended.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/emulate.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 3b27622d4642..5052eb480068 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2100,6 +2100,7 @@ static int emulate_iret_real(struct x86_emulate_ctxt *ctxt)
>  			     X86_EFLAGS_FIXED;
>  	unsigned long vm86_mask = X86_EFLAGS_VM | X86_EFLAGS_VIF |
>  				  X86_EFLAGS_VIP;
> +	u8 cpl = ctxt->ops->cpl(ctxt);
>  
>  	/* TODO: Add stack limit check */
>  
> @@ -2121,7 +2122,8 @@ static int emulate_iret_real(struct x86_emulate_ctxt *ctxt)
>  	if (rc != X86EMUL_CONTINUE)
>  		return rc;
>  
> -	rc = load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS);
> +	rc = __load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS, cpl,
> +				       X86_TRANSFER_RET, NULL);
>  
>  	if (rc != X86EMUL_CONTINUE)
>  		return rc;
> -- 
> 2.31.1
> 
