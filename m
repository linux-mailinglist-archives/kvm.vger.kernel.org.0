Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A1E5457A8
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 00:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbiFIWuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 18:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbiFIWui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 18:50:38 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73482114D
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 15:50:37 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n18so21393118plg.5
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 15:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=86+OU2zu0HQo0h80hOWzoZfp7+C3/RaLCcLpObk4okU=;
        b=LRdGpJ2DN9iUzIXLjq7TFFay31t4JVL5sF+TcU5L5E9QkwpKgL0PAr2tOFzWd8PVEY
         MKzrLq5lTxMAUZqrFgFQImLShr146ck3DmdoOC/Nw6GJownBRlFa/bsBADLfBUHFCx3c
         0qWlvLjG7Jtvjkg8i8Py7qBpjX5mSzSpoTHLmnmHs3d/0gj8EyfRIMO5Lrp9OJ5uCmqU
         +3bei8n04Qj8KbbQPtM8V+zeDhd+uwTzU6e/1t9R671Rl62BFk/los2+MDJVx/nW04kj
         1xabhqmU4Uwx3lHZpYS0FPCphCcUjA8YBBQTnF8ouVKyqlGF7nJBt04AfoxreCoA21a2
         wBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=86+OU2zu0HQo0h80hOWzoZfp7+C3/RaLCcLpObk4okU=;
        b=wc9k4uwKhtUJbyWo2DBKi4/MusizzBYkv/VAXXND8sABvcu5nnrON797ev7qZVRqBL
         o3uYncQOVeL+q2q+6rwCVBkaRy5Co7byipLyyInjo17pzd8LfJgjwgStrUPExGVBtyJw
         RqSGtuoEO1zgpBnTtLr8etyMuq36flo1AI96MSRqv3N1bnobgmCmRutTxZtl+zwWh/OY
         CDCSYb5clVH24w8RLD9QBLvsemaxtSYhY66ZFxx7yMq+5Yki2Z0DDF1xijcPWB+nHsyj
         bvGsNzthIPl3LjHJUDKhxp+qlBtCdg9zOtvayjM0K+jhLy5aOePwtqJRXpbzQ9KOOHPw
         +HKQ==
X-Gm-Message-State: AOAM530lL+5qBLzacwsT+CkHfyG7/MfsmiN6Uoy5YzyEwmfRIH76pKuk
        K1GNrdSDKD18m3deBkweCxvd61+I5tgC0A==
X-Google-Smtp-Source: ABdhPJxCqBlVUFdhyH8Sq2wxDim/OZzBnGusIkiRzN9CqJDp/O3fE4hkwqlQdWQVPtKkEeNHBR4pMA==
X-Received: by 2002:a17:903:1205:b0:15e:8cbc:fd2b with SMTP id l5-20020a170903120500b0015e8cbcfd2bmr42052809plh.99.1654815036741;
        Thu, 09 Jun 2022 15:50:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s8-20020a62e708000000b0051835ccc008sm17688886pfh.115.2022.06.09.15.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 15:50:36 -0700 (PDT)
Date:   Thu, 9 Jun 2022 22:50:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 6/6] KVM: SEV-ES: reuse advance_sev_es_emulated_ins for
 OUT too
Message-ID: <YqJ5OXwAyXvQuC2/@google.com>
References: <20220608121253.867333-1-pbonzini@redhat.com>
 <20220608121253.867333-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608121253.867333-7-pbonzini@redhat.com>
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
> complete_emulator_pio_in only has to be called by
> complete_sev_es_emulated_ins now; therefore, all that the function does
> now is adjust sev_pio_count and sev_pio_data.  Which is the same for
> both IN and OUT.
> 
> No functional change intended.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fd4382602f65..a3651aa74ed7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13007,6 +13007,12 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
>  
> +static void advance_sev_es_emulated_pio(struct kvm_vcpu *vcpu, unsigned count, int size)
> +{
> +	vcpu->arch.sev_pio_count -= count;
> +	vcpu->arch.sev_pio_data += count * size;
> +}
> +
>  static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
>  			   unsigned int port);
>  
> @@ -13030,8 +13036,7 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
>  		int ret = emulator_pio_out(vcpu, size, port, vcpu->arch.sev_pio_data, count);
>  
>  		/* memcpy done already by emulator_pio_out.  */
> -		vcpu->arch.sev_pio_count -= count;
> -		vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
> +		advance_sev_es_emulated_pio(vcpu, count, size);

I think this is a bug fix that should go in a separate patch.  size == vcpu->arch.pio.size
when kvm_sev_es_outs() is called from complete_sev_es_emulated_outs(), but when
it's called from kvm_sev_es_string_io() it will hold the size of the previous PIO.

>  		if (!ret)
>  			break;
>  
> @@ -13047,12 +13052,6 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
>  static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
>  			  unsigned int port);
>  
> -static void advance_sev_es_emulated_ins(struct kvm_vcpu *vcpu, unsigned count, int size)
> -{
> -	vcpu->arch.sev_pio_count -= count;
> -	vcpu->arch.sev_pio_data += count * size;
> -}
> -
>  static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
>  {
>  	unsigned count = vcpu->arch.pio.count;
> @@ -13060,7 +13059,7 @@ static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
>  	int port = vcpu->arch.pio.port;
>  
>  	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
> -	advance_sev_es_emulated_ins(vcpu, count, size);
> +	advance_sev_es_emulated_pio(vcpu, count, size);
>  	if (vcpu->arch.sev_pio_count)
>  		return kvm_sev_es_ins(vcpu, size, port);
>  	return 1;
> @@ -13076,7 +13075,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
>  			break;
>  
>  		/* Emulation done by the kernel.  */
> -		advance_sev_es_emulated_ins(vcpu, count, size);
> +		advance_sev_es_emulated_pio(vcpu, count, size);
>  		if (!vcpu->arch.sev_pio_count)
>  			return 1;
>  	}
> -- 
> 2.31.1
> 
