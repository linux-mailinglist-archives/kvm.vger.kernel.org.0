Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80164170247
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 16:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgBZPYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 10:24:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35270 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727936AbgBZPYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 10:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582730691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h+QkqnbU1iFIPyAtAgMG3gn/Nhb4l1LvHJ8Yic656iE=;
        b=OzZolXb4Pps33VQAMprusr/JGinpCXQDbnGWZWNf7OzKkqCsZZvpvAFDpMEFmGv2FuGX3f
        je13C9o6QdJjmx07/sUODI8fxtlsOUFVPiutfNNxnQSQ4VRp1A8Hgjd2qiN3jijMGiCEQE
        4NdjM3OA6O+kxg49y2KwsRoEyAmxH+c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-qF-jxWI9PkGJd9dAa-qSUg-1; Wed, 26 Feb 2020 10:24:48 -0500
X-MC-Unique: qF-jxWI9PkGJd9dAa-qSUg-1
Received: by mail-wm1-f69.google.com with SMTP id f207so1047912wme.6
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 07:24:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=h+QkqnbU1iFIPyAtAgMG3gn/Nhb4l1LvHJ8Yic656iE=;
        b=E5hPkBueif4IizUGRP7fAOvruPy1kiGrZTVIdkJ9N+5zWx0OxEt8LiPtdq5qV+Ttmz
         /dNaKscqQUpQS87yPnmpZuen/5wARgvw+/F1zRqJCnn02C8pqWhpq4d4eU2IQVByt5ps
         2pgV5jxv9u5junIPdFRwtIIyRk73GmR9fbls5/dCpRnTotz2dz+C5bCqlFwO4ILbo9gb
         G/ptIs4NuyxkDH9FGHvPYVSnFvpUS1I8Rq4kui2b8nEXF18DftMKlEbjifescfKK9fIN
         Hksk1XbK4p47/Hn8Byg1tPOkAkdm9SinGp5XsvG0JK0LzKoQhjNbweY73w/pl27Rfs4R
         WN4Q==
X-Gm-Message-State: APjAAAWRsehahl2T8o6CCNb6pKm2quOgRgESlUFRpDAOd8Sj4kpjy1di
        WFQDKwIH6ThaXpFmEHrFkq0viJLrSTekHbcnMZ8wpNS4tQTBTMgdWpAcfJikyGNDrRGY7QohTJ/
        z2NZLbwBDnIAN
X-Received: by 2002:a7b:cae2:: with SMTP id t2mr4989652wml.38.1582730687308;
        Wed, 26 Feb 2020 07:24:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqxA5F5DBc1k8YNkcYxe4gys14bSQKTA5C8H2lX9KfdEEbB4z/l9LGZIZpRT7KjVaS0UTGpHfw==
X-Received: by 2002:a7b:cae2:: with SMTP id t2mr4989634wml.38.1582730687105;
        Wed, 26 Feb 2020 07:24:47 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id d18sm3794976wrw.49.2020.02.26.07.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 07:24:46 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/13] KVM: x86: Refactor R/W page helper to take the emulation context
In-Reply-To: <20200218232953.5724-5-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com> <20200218232953.5724-5-sean.j.christopherson@intel.com>
Date:   Wed, 26 Feb 2020 16:24:45 +0100
Message-ID: <878skpjrr6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Invert the vcpu->context derivation in emulator_read_write_onepage() in
> preparation for dynamically allocating the emulation context.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 409bf35f26fd..772e704e8083 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5720,14 +5720,14 @@ static const struct read_write_emulator_ops write_emultor = {
>  static int emulator_read_write_onepage(unsigned long addr, void *val,
>  				       unsigned int bytes,
>  				       struct x86_exception *exception,
> -				       struct kvm_vcpu *vcpu,
> +				       struct x86_emulate_ctxt *ctxt,
>  				       const struct read_write_emulator_ops *ops)
>  {
>  	gpa_t gpa;
>  	int handled, ret;
>  	bool write = ops->write;
>  	struct kvm_mmio_fragment *frag;
> -	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
>  
>  	/*
>  	 * If the exit was due to a NPF we may already have a GPA.
> @@ -5791,7 +5791,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
>  
>  		now = -addr & ~PAGE_MASK;
>  		rc = emulator_read_write_onepage(addr, val, now, exception,
> -						 vcpu, ops);
> +						 ctxt, ops);
>  
>  		if (rc != X86EMUL_CONTINUE)
>  			return rc;
> @@ -5803,7 +5803,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
>  	}
>  
>  	rc = emulator_read_write_onepage(addr, val, bytes, exception,
> -					 vcpu, ops);
> +					 ctxt, ops);
>  	if (rc != X86EMUL_CONTINUE)
>  		return rc;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

