Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A320218413
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 11:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgGHJpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 05:45:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34985 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726302AbgGHJpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 05:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594201542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1BdUfU6m5HeEnRh3wmTDiTCHKPgV2EE4GiK0/uOui0Q=;
        b=gSO6qhsX5fVtIZawlld6lWjJUAAoWVzEGlhKDrzsJodR14hUSqITM2LLb5fxRzs5P04qkk
        /6Xqd4Ud1H7Y8QoXD+xWB9BvCW0HXr630RRAWgaTO5CnKZ6l7usLlAFGWsom3ZYT/1bTBl
        5LPfPTXU5VQBD2fYUyLMlFjbsmC2kT0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-URmtmy1KMCOGYzNkX8LYlA-1; Wed, 08 Jul 2020 05:45:37 -0400
X-MC-Unique: URmtmy1KMCOGYzNkX8LYlA-1
Received: by mail-wm1-f71.google.com with SMTP id g138so2270938wme.7
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 02:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1BdUfU6m5HeEnRh3wmTDiTCHKPgV2EE4GiK0/uOui0Q=;
        b=FCmli6EjQ/N0kOiRdpa9qII2tu1L37U71ipbKvrvW5wV9cAkPE1d80GnWfjQZg5axW
         jMCXNdaAqEJ4z6BLRd+SHYbR0TDxTn6wSeyIufmlYR6haCpcsS1df9NhQGLrLRmaAFrM
         KiOY/bn+DRuME4IUbPCIynaR/rhEm3H13KMy5RGbdgTVI4zc93EwPGOkJ7BkNmGhAmv7
         AaQP6x1srauXqBABiDRJns3xmFkE+RbsFUJ7qRQKPCjJGvtrNqcFgTGzrbtZMFiqunNl
         ErHgnyXl5TQ6zOH+fjVpvEMFzYQE1z9+n3GHMyYzuKj9srB1ofxSyaURfmstrN7FHG+i
         Otkg==
X-Gm-Message-State: AOAM533XgTXb+aE3TkMlZw6WkbeGqXS7QlIHQOSAFK+T6mgsGVSPN2i3
        gINPg4pozC+N+oP99fafhmCaU9N1Nxy23yyIALQaJT36bZqSo+lxjxpsLIetXsVwkQwLTaIoWzb
        kBfqBJu7i/00J
X-Received: by 2002:a1c:b686:: with SMTP id g128mr8778632wmf.145.1594201536324;
        Wed, 08 Jul 2020 02:45:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDBku9x1YC9fQdtg8T9bS5u6jo0bpoFEuDr9mwmMSNX88rmd++ZqZ54uewAYHU6Nz4IHzOUw==
X-Received: by 2002:a1c:b686:: with SMTP id g128mr8778609wmf.145.1594201536074;
        Wed, 08 Jul 2020 02:45:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id k18sm4999839wrx.34.2020.07.08.02.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 02:45:35 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Read PDPTEs on CR0.CD and CR0.NW changes
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>, Peter Shier <pshier@google.com>
References: <20200707223630.336700-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c8f73f4c-59e2-1a57-164c-d9d4e11ce486@redhat.com>
Date:   Wed, 8 Jul 2020 11:45:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707223630.336700-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 00:36, Jim Mattson wrote:
> According to the SDM, when PAE paging would be in use following a
> MOV-to-CR0 that modifies any of CR0.CD, CR0.NW, or CR0.PG, then the
> PDPTEs are loaded from the address in CR3. Previously, kvm only loaded
> the PDPTEs when PAE paging would be in use following a MOV-to-CR0 that
> modified CR0.PG.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/x86.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f83b28..5a91c975487d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -775,6 +775,7 @@ EXPORT_SYMBOL_GPL(pdptrs_changed);
>  int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  {
>  	unsigned long old_cr0 = kvm_read_cr0(vcpu);
> +	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
>  	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
>  
>  	cr0 |= X86_CR0_ET;
> @@ -792,9 +793,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
>  		return 1;
>  
> -	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
> +	if (cr0 & X86_CR0_PG) {
>  #ifdef CONFIG_X86_64
> -		if ((vcpu->arch.efer & EFER_LME)) {
> +		if (!is_paging(vcpu) && (vcpu->arch.efer & EFER_LME)) {
>  			int cs_db, cs_l;
>  
>  			if (!is_pae(vcpu))
> @@ -804,8 +805,8 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  				return 1;
>  		} else
>  #endif
> -		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->arch.walk_mmu,
> -						 kvm_read_cr3(vcpu)))
> +		if (is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
> +		    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
>  			return 1;
>  	}
>  
> 

Queued, thanks.

Paolo

