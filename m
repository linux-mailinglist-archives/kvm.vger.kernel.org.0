Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC34D4807E5
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 10:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbhL1Jhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 04:37:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhL1Jhx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Dec 2021 04:37:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640684273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8UNaWMcu6LyEF1PGvetsyJ0a6lkdnxNspgKA2bFoUeA=;
        b=cbI9S0TCEYdwXE5t1ncu3EH3Cd9X16DnMm7e2v44idYboSFlOwgTr4ajIjiIiurtwlMKNp
        Brl6ogYfadCR2sWRKjvsAGKUXXVAfHqXWd8Dz8wGO1jcf/k05y7Ionb3TVIIByWet7Uz+J
        e+iuizMuyum2VuXGLZlPuONjoPooesU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-obuoOKK5OUKFK7HGaFpeSw-1; Tue, 28 Dec 2021 04:37:51 -0500
X-MC-Unique: obuoOKK5OUKFK7HGaFpeSw-1
Received: by mail-ed1-f69.google.com with SMTP id b8-20020a056402350800b003f8f42a883dso5555484edd.16
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 01:37:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8UNaWMcu6LyEF1PGvetsyJ0a6lkdnxNspgKA2bFoUeA=;
        b=0/2OQQ8t0+vIXaHNrXwVkRgk77hA1TEsFml2xozY58So+aB70pOKVk61HERGm5uAwD
         uREVOJiApeVY3xW9PotJm2CFXMh4a0cNHD10kcz+kY6P7ADT7B0MP8StGP32/cCHMAKy
         K9vb6Is+PsSslnESuuL+xa7e6HERwtwdvhIBWBelxdwh2T8tzl4ApeMJj2fB5jqMUUwX
         kPCAxgcTpb5FlBY3S4xCukD74sJhTy2X5WTH3t9Li9EBotXVC2oSMbRrwuzwxs03ilXI
         Fl+jNjmgAoYxooQCJBZUjkut25pszSRF6HFX2u0TY4G0O2r1OKxMxlwYttyhKM9CERG8
         MJvw==
X-Gm-Message-State: AOAM531ZNA16A7FBxasBHtM2xJlxk2QK25oPTJMStWJLeLb+7AUTJDaq
        zS8egb8J9MqlgdpPWmjWE5s81vYkw/M0rOQwAqKBzHGom0yFMh3W919TF2TfEjhGtAieHgSBo+q
        WYAjSihu6weNb
X-Received: by 2002:a17:907:16a8:: with SMTP id hc40mr16049344ejc.210.1640684270171;
        Tue, 28 Dec 2021 01:37:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwk10qerga4au0PlRksDEq0pg2NINxNnJMdwWVAoVSQTerQ17y4x4lhluHN98cBV3jmZIMeqw==
X-Received: by 2002:a17:907:16a8:: with SMTP id hc40mr16049327ejc.210.1640684269989;
        Tue, 28 Dec 2021 01:37:49 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id hb31sm176544ejc.2.2021.12.28.01.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 01:37:49 -0800 (PST)
Date:   Tue, 28 Dec 2021 10:37:48 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v2 4/6] KVM: selftests: arm64: Rework TCR_EL1
 configuration
Message-ID: <20211228093748.ed7ohpnrq3cmljee@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227124809.1335409-5-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 27, 2021 at 12:48:07PM +0000, Marc Zyngier wrote:
> The current way we initialise TCR_EL1 is a bit cumbersome, as
> we mix setting TG0 and IPS in the same swtch statement.
> 
> Split it into two statements (one for the base granule size, and
> another for the IPA size), allowing new modes to be added in a
> more elegant way.
> 
> No functional change intended.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../selftests/kvm/lib/aarch64/processor.c     | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

