Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DA2545780
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 00:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345751AbiFIWhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 18:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237368AbiFIWhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 18:37:31 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C20E15A3E7
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 15:37:30 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f9so10902554plg.0
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 15:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O60y2iE37MzESN5fyK5JC5FyF2KHeNE/DgjyVicySlo=;
        b=AW/oLjImNaQ93ApSb/VwDfB/JMThSpZdXz4G6I9Kmug/CW1fN5Ofh6f7AqImTcjWbT
         XRc334gnAiSghVMop5nN80ajx3J/8dxZ3UbOyQoR64xBK6MasouOqt8djHfDMxxMy2A0
         q919u3Dq5g4190v4Dph0OltAqZQzHX5v2WXeuYv9wukWkAoru2SQJ7KWIHCUJ1hwBnAL
         WeBLLI6mpxEi+ovPG8XSSgcU+lpfmFe/D4INqw41J4Lio9pZzbr8kHDDXDQtKB/k3sfU
         DSlSQsdOtu8YxMddopbAzSYVUsNguTQcEXiiqeLFFXUph5Zif665rjLNSrcKV/KtD+MG
         47Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O60y2iE37MzESN5fyK5JC5FyF2KHeNE/DgjyVicySlo=;
        b=LfZ4wK8acstEl4S3Q0/8XqWWvSfi2M9Cra3mb2Ni3P5T7KhTB8btWO4YyUU13z9Jd/
         MAIIz3qhrupZtP2BAWbDTD41OfCsUYaetwMXh9lzsZilxwlru2fQEyooP/AWUPmf9i8t
         drwofDyRHD6A7GTf/zg4CWwVPBQkezJuyFzyzAEGdWb7fdKTDnqOyU9ghlJQJdJG4Bhf
         2q42nDdlkUWf2/k70yAXJLynwEt02+f3CMtsQ7y0I0XFVwdP9R+olL4gBjnQBeEJeee9
         Zx2f6pxlvetfE1f+de82wPZyk1wh/Hz90TfTitQiQCuNMAEnJ9NuyeLhBa/SAHuH4aHf
         dlkw==
X-Gm-Message-State: AOAM531IcQ8IJKpRwVmSJWSyNwloUgJvj+F/b1Pm6qnE6eXGC6XNSaoz
        YTQnxZ71eOdKmEo3hpQI9H6q5jjCVuTZTA==
X-Google-Smtp-Source: ABdhPJwo/v0ZKJpb/P+0jZkE1vgqE+a69844IFj0uV7g6Hn280R7QSYuDhhqVQ4ES+f0eKtm/BWb0A==
X-Received: by 2002:a17:90b:1e04:b0:1e8:4a47:966d with SMTP id pg4-20020a17090b1e0400b001e84a47966dmr5503214pjb.51.1654814249861;
        Thu, 09 Jun 2022 15:37:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id bq6-20020a056a000e0600b0051bd9568140sm14547851pfb.109.2022.06.09.15.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 15:37:29 -0700 (PDT)
Date:   Thu, 9 Jun 2022 22:37:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 4/6] KVM: x86: wean fast IN from emulator_pio_in
Message-ID: <YqJ2JgVxZ44VzRe1@google.com>
References: <20220608121253.867333-1-pbonzini@redhat.com>
 <20220608121253.867333-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608121253.867333-5-pbonzini@redhat.com>
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

On Wed, Jun 08, 2022, Paolo Bonzini wrote:
> Now that __emulator_pio_in already fills "val" for in-kernel PIO, it

For some reason the "already" confused the heck out of me.  I thought it was
referring to a previous patch, which it kind of is, but then I couldn't figure
out the relevance to this patch.

Ah, I know why I got confused, the in-kernel PIO case has nothing to do with the
usage in complete_fast_pio_in(), e.g. complete_fast_pio_in() could be modified to
call complete_emulator_pio_in() directly even without the previous cleanup in
this series.

Can you split this patch in two?  It's comically trivial, but it makes the
changelogs much easier to understand.

  Use __emulator_pio_in() directly for fast PIO instead of bouncing through
  emulator_pio_in() now that __emulator_pio_in() fills "val" when handling
  in-kernel PIO.  vcpu->arch.pio.count is guaranteed to be '0', so this a
  pure nop.

  No functional change intended.

and

  Use complete_emulator_pio_in() directly when completing fast PIO, there's
  no need to bounce through emulator_pio_in() as the comment about ECX
  changing doesn't apply to fast PIO, which isn't used for string I/O.

  No functional change intended.

> is both simpler and clearer not to use emulator_pio_in.
> Use the appropriate function in kvm_fast_pio_in and complete_fast_pio_in,
> respectively __emulator_pio_in and complete_emulator_pio_in.
> 
> emulator_pio_in_emulated is now the last caller of emulator_pio_in.
> 
> No functional change intended.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3b641cd2ff6f..aefcc71a7040 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8692,11 +8692,7 @@ static int complete_fast_pio_in(struct kvm_vcpu *vcpu)
>  	/* For size less than 4 we merge, else we zero extend */
>  	val = (vcpu->arch.pio.size < 4) ? kvm_rax_read(vcpu) : 0;
>  
> -	/*
> -	 * Since vcpu->arch.pio.count == 1 let emulator_pio_in perform
> -	 * the copy and tracing
> -	 */
> -	emulator_pio_in(vcpu, vcpu->arch.pio.size, vcpu->arch.pio.port, &val, 1);
> +	complete_emulator_pio_in(vcpu, &val);
>  	kvm_rax_write(vcpu, val);
>  
>  	return kvm_skip_emulated_instruction(vcpu);
> @@ -8711,7 +8707,7 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
>  	/* For size less than 4 we merge, else we zero extend */
>  	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
>  
> -	ret = emulator_pio_in(vcpu, size, port, &val, 1);
> +	ret = __emulator_pio_in(vcpu, size, port, &val, 1);
>  	if (ret) {
>  		kvm_rax_write(vcpu, val);
>  		return ret;
> -- 
> 2.31.1
> 
> 
