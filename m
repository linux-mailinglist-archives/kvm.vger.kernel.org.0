Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B5243B375
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 15:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhJZN7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 09:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236346AbhJZN7p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 09:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635256641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9we9ZOmPunMjNxTr7QncTOpAReoNjkw6RCURiVA0rAk=;
        b=OBgfXCRWxboAublaKSzo2rTqyR9zNKPZ4q/iYrQi14EfwV6rrcpHZGicsQBJ3hSvAkRees
        YR2eVROLzAM6snl7YHYrQPa1V0ZUrivdD4hHIKX49QiritHisd071kFUCTPpXKFc3sqNxR
        lPiMqiss96voqP25LCjTV1ReH+lzXNw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-Sr05zwYXOZeypfGBX5OWog-1; Tue, 26 Oct 2021 09:57:18 -0400
X-MC-Unique: Sr05zwYXOZeypfGBX5OWog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E61C9802B78;
        Tue, 26 Oct 2021 13:57:16 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52D035F4E0;
        Tue, 26 Oct 2021 13:57:13 +0000 (UTC)
Message-ID: <ed81ce712b8c75bea619ba06bb35c9d21d327a9e.camel@redhat.com>
Subject: Re: [PATCH 13/13] KVM: SEV-ES: reuse advance_sev_es_emulated_ins
 for OUT too
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Tue, 26 Oct 2021 16:57:12 +0300
In-Reply-To: <20211022153616.1722429-14-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
         <20211022153616.1722429-14-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-22 at 11:36 -0400, Paolo Bonzini wrote:
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
> index c3a2f479604d..b9ce4cfec121 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12365,6 +12365,12 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
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
> @@ -12388,8 +12394,7 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
>  		int ret = emulator_pio_out(vcpu, size, port, vcpu->arch.sev_pio_data, count);
>  
>  		/* memcpy done already by emulator_pio_out.  */
> -		vcpu->arch.sev_pio_count -= count;
> -		vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
> +		advance_sev_es_emulated_pio(vcpu, count, size);
>  		if (!ret)
>  			break;
>  
> @@ -12405,12 +12410,6 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
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
> @@ -12418,7 +12417,7 @@ static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
>  	int port = vcpu->arch.pio.port;
>  
>  	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
> -	advance_sev_es_emulated_ins(vcpu, count, size);
> +	advance_sev_es_emulated_pio(vcpu, count, size);
>  	if (vcpu->arch.sev_pio_count)
>  		return kvm_sev_es_ins(vcpu, size, port);
>  	return 1;
> @@ -12434,7 +12433,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
>  			break;
>  
>  		/* Emulation done by the kernel.  */
> -		advance_sev_es_emulated_ins(vcpu, count, size);
> +		advance_sev_es_emulated_pio(vcpu, count, size);
>  		if (!vcpu->arch.sev_pio_count)
>  			return 1;
>  	}

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

