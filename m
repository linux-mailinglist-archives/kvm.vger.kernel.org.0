Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE2443B372
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 15:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbhJZN7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 09:59:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234241AbhJZN7M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 09:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635256608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yPbNljm45EyPlEUcvU/gUFVc1AQvLZWBeZMzrpcYWGE=;
        b=Nm4CmMMwXMjdabpsFxO7vfZkbY3AxWXJQl9o5kYFa0f7ljBeCgwjCHGvEJUlBjc3KsL7Cb
        Fs+aiwg1aeMYZRyXDFZrFOm4+wkocjFbarOdAsodvLE6gPk7pqP8d502Y4CFbgNY7Kpa2r
        5vdrjLZbMjfGGbK9pIM39KJvyrymSM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-y5vmV6sVNUi6hkcNmR683g-1; Tue, 26 Oct 2021 09:56:44 -0400
X-MC-Unique: y5vmV6sVNUi6hkcNmR683g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9800100CCC1;
        Tue, 26 Oct 2021 13:56:43 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 588C2AFD89;
        Tue, 26 Oct 2021 13:56:42 +0000 (UTC)
Message-ID: <5b9fd4b121763c7f1299ede032472ded3b000b60.camel@redhat.com>
Subject: Re: [PATCH 11/13] KVM: x86: wean fast IN from emulator_pio_in
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Tue, 26 Oct 2021 16:56:41 +0300
In-Reply-To: <20211022153616.1722429-12-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
         <20211022153616.1722429-12-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-22 at 11:36 -0400, Paolo Bonzini wrote:
> Now that __emulator_pio_in already fills "val" for in-kernel PIO, it
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
> index e3d3c13fe803..42826087afd9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8061,11 +8061,7 @@ static int complete_fast_pio_in(struct kvm_vcpu *vcpu)
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
> @@ -8080,7 +8076,7 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
>  	/* For size less than 4 we merge, else we zero extend */
>  	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
>  
> -	ret = emulator_pio_in(vcpu, size, port, &val, 1);
> +	ret = __emulator_pio_in(vcpu, size, port, &val, 1);
>  	if (ret) {
>  		kvm_rax_write(vcpu, val);
>  		return ret;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

