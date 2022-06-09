Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CE9545681
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 23:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbiFIVdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 17:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiFIVdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 17:33:38 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2ACEE1147
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 14:33:34 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o6so16174057plg.2
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 14:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m7ycA4UvCRcWR4yKEUVYS54WeWG49dg/6jDxIB9tTNA=;
        b=Jqq2qaUmztHXYlLC5OtDZ1kjE3J4zkrncd42dGrvID2KbEKbAY9YGGZYNNdpgSsi17
         LVCDdST/dYjbt6pTf+bnRXMgQM4hHqzJLOyHwtqChyrmT6E2+mlWn5hIF2V0TZSXd6yt
         tVMowv8ZPTS/p62/qff/4OAqw4onqe01bLt8JukOqng8pdaIBh7P0ZeFKNL9ggilP8vk
         5LxStOh07fwcYGt8ioBMcXY0DG9zd6FfQyvQKMf0TjX0iv11uUTujpxVcY4APAA0AWAO
         YqnYYpPyAl71U0a8/FIrW8jkdfNmx0BdSLrmQttJMQoo9xzBZXmfFbTJdG+/jUdJJ56l
         IKXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m7ycA4UvCRcWR4yKEUVYS54WeWG49dg/6jDxIB9tTNA=;
        b=zGobQefxCQrQBZvSnx0DcVy7EcleyLR7/eK+bBDwMTvNTY9HwKtiuv5hfwfI15hUXG
         A93CdG8FDHjlkI0zWYv7ORldJuFS6R1a8iFNnPV4EqnreiP5wyVocOtO9Ntzte9bH5iR
         NqtEX8be5z7S7kNvoB2DaIFSNqUUJk/f8kpw+TFt3cR8kvWWnRh3mL2sdezoqj8FNynb
         Nm3w2dd3oLKbLMY46ix3Tlcb+8t3kb50Lkp1+MLQBTOB8gqsVUjnQMzdYcn34oT1BZhX
         bwNi6JJofMeVn8ilRMtPFQTzoESlEtBPoIXT178sa61NVmswN5nlCizBQuZ6gyDoVEJK
         GT+Q==
X-Gm-Message-State: AOAM530IeFffOHob0oIjuiNcwkElGtbHLCIhJrvpGlMy7N9l0JM7kSZK
        /hzWTir+nAF9AI/3Rn2TlHfJRI9o5pG3dA==
X-Google-Smtp-Source: ABdhPJyMFtULqK6xP7o6ODg72mXgOYMUfRbFIM45qO5zRVZM10jyMpfcu73oXSgj7e4Wxz96JFuhfg==
X-Received: by 2002:a17:903:2312:b0:163:daf7:83a9 with SMTP id d18-20020a170903231200b00163daf783a9mr41587405plh.160.1654810414111;
        Thu, 09 Jun 2022 14:33:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h11-20020a62830b000000b0050dc7628150sm17761006pfe.42.2022.06.09.14.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 14:33:32 -0700 (PDT)
Date:   Thu, 9 Jun 2022 21:33:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/6] KVM: x86: inline kernel_pio into its sole caller
Message-ID: <YqJnKSpnPFZ5VsnL@google.com>
References: <20220608121253.867333-1-pbonzini@redhat.com>
 <20220608121253.867333-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608121253.867333-2-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08, 2022, Paolo Bonzini wrote:
> The caller of kernel_pio already has arguments for most of what kernel_pio
> fishes out of vcpu->arch.pio.  This is the first step towards ensuring that
> vcpu->arch.pio.* is only used when exiting to userspace.
> 
> We can now also WARN if emulated PIO performs successful in-kernel iterations
> before having to fall back to userspace.  The code is not ready for that, and
> it should never happen.

Please avoid pronouns and state what patch does, not what "can" be done.  It's not
clear without reading the actual code whether "The code is not ready for that" means
"KVM is not ready to WARN" or "KVM is not ready to fall back to exiting userspace
if a

E.g.

  WARN if emulated PIO falls back to userspace after successfully handling
  one or more in-kernel iterations.  The port, size, and access type do not
  change, and KVM so it should be impossible for in-kernel PIO to fail on
  subsequent iterations.

That said, I don't think the above statement is true.  KVM is running with SRCU
protection, but the synchronize_srcu_expedited() in kvm_io_bus_unregister_dev()
only protects against use-after-free, it does not prevent two calls to
kvm_io_bus_read() from seeing different incarnations of kvm->buses.

And if I'm right, that could be exploited to create a buffer overrun due to doing
this memcpy with "data = <original data> + i * size".

	else
		memcpy(vcpu->arch.pio_data, data, size * count);

The existing code is arguably wrong too in that it will result in replaying PIO
accesses, but IMO userspace gets to keep the pieces if it unregisters a device
while vCPUs are running.
 
> No functional change intended.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 39 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 79efdc19b4c8..2f9100f2564e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7415,37 +7415,32 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
>  	return emulator_write_emulated(ctxt, addr, new, bytes, exception);
>  }
>  
> -static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
> -{
> -	int r = 0, i;
> -
> -	for (i = 0; i < vcpu->arch.pio.count; i++) {
> -		if (vcpu->arch.pio.in)
> -			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, vcpu->arch.pio.port,
> -					    vcpu->arch.pio.size, pd);
> -		else
> -			r = kvm_io_bus_write(vcpu, KVM_PIO_BUS,
> -					     vcpu->arch.pio.port, vcpu->arch.pio.size,
> -					     pd);
> -		if (r)
> -			break;
> -		pd += vcpu->arch.pio.size;
> -	}
> -	return r;
> -}
> -
>  static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
>  			       unsigned short port,
>  			       unsigned int count, bool in)
>  {
> +	void *data = vcpu->arch.pio_data;
> +	unsigned i;
> +	int r;
> +
>  	vcpu->arch.pio.port = port;
>  	vcpu->arch.pio.in = in;
> -	vcpu->arch.pio.count  = count;
> +	vcpu->arch.pio.count = count;
>  	vcpu->arch.pio.size = size;
>  
> -	if (!kernel_pio(vcpu, vcpu->arch.pio_data))
> -		return 1;
> +	for (i = 0; i < count; i++) {
> +		if (in)
> +			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, port, size, data);
> +		else
> +			r = kvm_io_bus_write(vcpu, KVM_PIO_BUS, port, size, data);
> +		if (r)
> +			goto userspace_io;
> +		data += size;
> +	}
> +	return 1;
>  
> +userspace_io:
> +	WARN_ON(i != 0);
>  	vcpu->run->exit_reason = KVM_EXIT_IO;
>  	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
>  	vcpu->run->io.size = size;
> -- 
> 2.31.1
> 
> 
