Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D2243B365
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 15:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbhJZN6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 09:58:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232606AbhJZN6c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 09:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635256567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GqvoimveYlYhulmJuY+J/4zhaZ7J2u8WeVOP1SKbbjw=;
        b=JDhLD0vRUdv7iHt2cbxNudJyKs67HXUelstff1ldQYQslYV9Mz58tOFQKhcvee7GEYO3wr
        VXDXAbvnA8NQgN31SIYJbEr/2j90oE9hMAp7tslmNwSOHVaa0O5DS4XY/MznalpSLlIIAD
        qMYBo4UxNwtT6074X1ghFcM8Ijp3P9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-g5TmEK-YMNG_kSEzmGqIaQ-1; Tue, 26 Oct 2021 09:56:03 -0400
X-MC-Unique: g5TmEK-YMNG_kSEzmGqIaQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87C9280A5C0;
        Tue, 26 Oct 2021 13:56:02 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E48E010023B8;
        Tue, 26 Oct 2021 13:56:00 +0000 (UTC)
Message-ID: <e43a66f1cc08ad185f044ece8ada5c64da2b40eb.camel@redhat.com>
Subject: Re: [PATCH 08/13] KVM: x86: inline kernel_pio into its sole caller
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Tue, 26 Oct 2021 16:55:59 +0300
In-Reply-To: <20211022153616.1722429-9-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
         <20211022153616.1722429-9-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-22 at 11:36 -0400, Paolo Bonzini wrote:
> The caller of kernel_pio already has arguments for most of what kernel_pio
> fishes out of vcpu->arch.pio.  This is the first step towards ensuring that
> vcpu->arch.pio.* is only used when exiting to userspace.
> 
> We can now also WARN if emulated PIO performs successful in-kernel iterations
> before having to fall back to userspace.  The code is not ready for that, and
> it should never happen.
> 
> No functional change intended.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 39 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b26647a5ea22..d6b8df7cea80 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6886,37 +6886,32 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

