Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653DD545747
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 00:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345646AbiFIWTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 18:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345687AbiFIWTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 18:19:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DBF6D978
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 15:19:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so619623pjo.0
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 15:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YULgola7K497MBlM6Pfvzbon5/Nm8Tu+pAooiIC9hlw=;
        b=GlOpLLlbuCZm916o3oGh2cF5PooLoBW5W20ClJJY90wE155D+yME0t7SkksQwN1lRK
         aumrDVpwKzc6OGHzg4M9BgL4PK3QxQU12CxsoOhKevC8xc/dYTRp9yCp7w4GyWAY88U8
         +uoBt+wuOAE+F+435zyJV8EBiC+pqzXBy7GJs8JoinzdN1aS/QuHFQawfW3qNj6LkWEW
         FvuX+WgVYvcbCkN9EKtLlGQ5BFohie4ujmlYN31DcQE9CHjkLPD0dPh5PteM/5ZrV6rl
         uuZxeYfP6Nn4Al3uNNLMf/US+ZOiRtmTdfTx6rjEPjwzoeL1x17S+hgceHkjMbY3aKA4
         PckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YULgola7K497MBlM6Pfvzbon5/Nm8Tu+pAooiIC9hlw=;
        b=Yq1h369dN6YwGUAkXgGMw6QaMFemihRCDD89qDF6FrWyyD3Z0yXSM/NhIqvU1DHC75
         ZCfrzFjZeMlEoQg9TXs3dmKcvae7ub1G+LeH5p7hU8WMPQ3ZhEh1UKLzJSuvsRBxYvBc
         b6TaOoGETMxkwYmDtHdYNrP0Xm3m+qf/nSr4Waajgv78V+utZNcJZx32wAzRQGVCsM6Z
         8rObMLE3kqGdY5WvxO15v07Fa7WeaZz35XuWmEDl4R3B3vd1w9Cvn2f9xmZLKIGC1g4Z
         mc/wqKVl8q+LPWe0QL8Hvm+5mjB8FTn6cvFabQNaH+UznmZCy/7Ue88NphgQPPdRwHFK
         CeBA==
X-Gm-Message-State: AOAM533vF/9QuOg6Ae5FOx63+B18pcl5K540a2fcNsq8m2JYWeKa9iGU
        GZSW2O/EHfvLElyBdWnuqyVNDg==
X-Google-Smtp-Source: ABdhPJzVrvk6q78nh7Ue2eeMbkCIjL2IwjqmzrEUkajeU7gsKvrNiyqUTY+0T0A7h07wuRPLb8B5Lw==
X-Received: by 2002:a17:902:ef93:b0:163:de9e:edf8 with SMTP id iz19-20020a170902ef9300b00163de9eedf8mr41749061plb.151.1654813147192;
        Thu, 09 Jun 2022 15:19:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902eb8800b00167804a044fsm8631422plg.56.2022.06.09.15.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 15:19:06 -0700 (PDT)
Date:   Thu, 9 Jun 2022 22:19:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/6] KVM: x86: wean in-kernel PIO from vcpu->arch.pio*
Message-ID: <YqJx1/26XGLBX3AH@google.com>
References: <20220608121253.867333-1-pbonzini@redhat.com>
 <20220608121253.867333-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608121253.867333-4-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08, 2022, Paolo Bonzini wrote:
>  static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
> @@ -7482,16 +7486,11 @@ static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
>  		 * shenanigans as KVM doesn't support modifying the rep count,
>  		 * and the emulator ensures @count doesn't overflow the buffer.
>  		 */
> +		complete_emulator_pio_in(vcpu, val);
> +		return 1;
>  	} else {
> -		int r = __emulator_pio_in(vcpu, size, port, count);
> -		if (!r)
> -			return r;
> -
> -		/* Results already available, fall through.  */
> +		return __emulator_pio_in(vcpu, size, port, val, count);

Any objections to not using an "else"?  I.e.

	if (vcpu->arch.pio.count) {
		/*
		 * Complete a previous iteration that required userspace I/O.
		 * Note, @count isn't guaranteed to match pio.count as userspace
		 * can modify ECX before rerunning the vCPU.  Ignore any such
		 * shenanigans as KVM doesn't support modifying the rep count,
		 * and the emulator ensures @count doesn't overflow the buffer.
		 */
		complete_emulator_pio_in(vcpu, val);
		return 1;
	}
	return __emulator_pio_in(vcpu, size, port, val, count);

>  	}
> -
> -	complete_emulator_pio_in(vcpu, val);
> -	return 1;
>  }
>  
>  static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
> @@ -7506,14 +7505,8 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
>  			    unsigned short port, const void *val,
>  			    unsigned int count)
>  {
> -	int ret;
> -
>  	trace_kvm_pio(KVM_PIO_OUT, port, size, count, val);
> -	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
> -	if (ret)
> -                vcpu->arch.pio.count = 0;
> -
> -        return ret;
> +	return emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
>  }
>  
>  static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
> @@ -13064,20 +13057,20 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
>  static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
>  			  unsigned int port);
>  
> -static void advance_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
> +static void advance_sev_es_emulated_ins(struct kvm_vcpu *vcpu, unsigned count, int size)
>  {
> -	unsigned count = vcpu->arch.pio.count;
> -	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
>  	vcpu->arch.sev_pio_count -= count;
> -	vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
> +	vcpu->arch.sev_pio_data += count * size;
>  }
>  
>  static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
>  {
> +	unsigned count = vcpu->arch.pio.count;

Opportunistically use an "unsigned int" if you spin another version?

>  	int size = vcpu->arch.pio.size;
>  	int port = vcpu->arch.pio.port;
>  
> -	advance_sev_es_emulated_ins(vcpu);
> +	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
> +	advance_sev_es_emulated_ins(vcpu, count, size);

Eww.  The dependency between vcpu->arch.pio.count and complete_emulator_pio_in()
is nasty.  Can you add a comment above count to reduce the likelihood of someone
using vcpu->arch.pio.count directly here instead of making a snapshot?

	/*
	 * Snapshot the count before completing userspace I/O, which will
	 * consume the userspace data and thus clear vcpu->arch.pio.count.
	 */
	unsigned int count = vcpu->arch.pio.count;

>  	if (vcpu->arch.sev_pio_count)
>  		return kvm_sev_es_ins(vcpu, size, port);
>  	return 1;
> @@ -13089,11 +13082,11 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
>  	for (;;) {
>  		unsigned int count =
>  			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
> -		if (!__emulator_pio_in(vcpu, size, port, count))
> +		if (!__emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
>  			break;
>  
>  		/* Emulation done by the kernel.  */
> -		advance_sev_es_emulated_ins(vcpu);
> +		advance_sev_es_emulated_ins(vcpu, count, size);
>  		if (!vcpu->arch.sev_pio_count)
>  			return 1;
>  	}
> -- 
> 2.31.1
> 
> 
