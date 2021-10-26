Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0212143B373
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 15:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbhJZN7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 09:59:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236366AbhJZN7X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 09:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635256619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3QoVSLUQfJDncXa7oghqPaplz3nYi7lAy3NsjyGe50Q=;
        b=CRNZty4LSC/ucPr86L1GzV0+pEWm69mKe4JxCiQMP14QaySJ4ehKmgaOmETuPYDvKhZjrk
        n62bpM684YUeU+hPpnCP3VL+uhwfrfmS14TDd/ZjCfriT2jjPw1nExt+kG3RekdGOFfyYp
        eia/dySklN04Svpzyri3Pv/KqlbVZOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-hXGJseFsMb6xZIfKRaJoxQ-1; Tue, 26 Oct 2021 09:56:56 -0400
X-MC-Unique: hXGJseFsMb6xZIfKRaJoxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BE2A81424B;
        Tue, 26 Oct 2021 13:56:55 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D5DE5C1A1;
        Tue, 26 Oct 2021 13:56:53 +0000 (UTC)
Message-ID: <6d0bdaf585e97517c28a6c20a38ab4eb32fa3d4d.camel@redhat.com>
Subject: Re: [PATCH 12/13] KVM: x86: de-underscorify __emulator_pio_in
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Tue, 26 Oct 2021 16:56:52 +0300
In-Reply-To: <20211022153616.1722429-13-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
         <20211022153616.1722429-13-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-22 at 11:36 -0400, Paolo Bonzini wrote:
> Now all callers except emulator_pio_in_emulated are using
> __emulator_pio_in/complete_emulator_pio_in explicitly.
> Move the "either copy the result or attempt PIO" logic in
> emulator_pio_in_emulated, and rename __emulator_pio_in to
> just emulator_pio_in.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 42826087afd9..c3a2f479604d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6927,7 +6927,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
>  	return 0;
>  }
>  
> -static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
> +static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
>  			     unsigned short port, void *val, unsigned int count)
>  {
>  	int r = emulator_pio_in_out(vcpu, size, port, val, count, true);
> @@ -6946,27 +6946,21 @@ static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
>  	vcpu->arch.pio.count = 0;
>  }
>  
> -static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
> -			   unsigned short port, void *val, unsigned int count)
> +static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
> +				    int size, unsigned short port, void *val,
> +				    unsigned int count)
>  {
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
>  	if (vcpu->arch.pio.count) {
>  		/* Complete previous iteration.  */
>  		WARN_ON(count != vcpu->arch.pio.count);
>  		complete_emulator_pio_in(vcpu, val);
>  		return 1;
>  	} else {
> -		return __emulator_pio_in(vcpu, size, port, val, count);
> +		return emulator_pio_in(vcpu, size, port, val, count);
>  	}
>  }
>  
> -static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
> -				    int size, unsigned short port, void *val,
> -				    unsigned int count)
> -{
> -	return emulator_pio_in(emul_to_vcpu(ctxt), size, port, val, count);
> -
> -}
> -
>  static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
>  			    unsigned short port, const void *val,
>  			    unsigned int count)
> @@ -8076,7 +8070,7 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
>  	/* For size less than 4 we merge, else we zero extend */
>  	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
>  
> -	ret = __emulator_pio_in(vcpu, size, port, &val, 1);
> +	ret = emulator_pio_in(vcpu, size, port, &val, 1);
>  	if (ret) {
>  		kvm_rax_write(vcpu, val);
>  		return ret;
> @@ -12436,7 +12430,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
>  	for (;;) {
>  		unsigned int count =
>  			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
> -		if (!__emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
> +		if (!emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
>  			break;
>  
>  		/* Emulation done by the kernel.  */
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

