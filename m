Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0019B642513
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 09:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiLEIxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 03:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiLEIsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 03:48:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5934F63C6
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 00:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670230048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rfvEnKIf4mHuvu3yIVqxv1Te1T4eVbeJMHjj7Ep8ikc=;
        b=GlGOVnuhDe1FXGBrQdHHHUJMafMneVn02+QyMP/2k3SkQmoTiuGkG6OtJXK3neRgHepJUe
        h1YJW3usYZUId9uzrM4kjXHMAi5A2At1CfATTe123kkDRvhxVADTvE+NLwnkfa3urLJYJl
        n59Pb7nUh/UhKlrPKKNRbVHepBU+WcU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-658-1euZSmJ6POCclv9U6nDJeg-1; Mon, 05 Dec 2022 03:47:26 -0500
X-MC-Unique: 1euZSmJ6POCclv9U6nDJeg-1
Received: by mail-ed1-f72.google.com with SMTP id w22-20020a056402269600b0046b00a9ee5fso5342561edd.2
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 00:47:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rfvEnKIf4mHuvu3yIVqxv1Te1T4eVbeJMHjj7Ep8ikc=;
        b=uyXG5OUvYQzgEAMbMSH4ipV5EwzQhhtjSATeeXDw9vd45c+viSZmDiR1hU9a3glXsM
         PhFMbmrh/ln7vi6lwhabWT0wt9jLXhdEOaysS+uRbgqidcUdZMB/H71wWWRcJIftlRIN
         bYvxFFi/0/CFJRmEJ059WMmZ7+pn4Nz6q0YeJrBEGi1aguWWUzGntf2RWz5XsMgesvQn
         7GwiHaffhHI8t0lsareFa1DQTnvYOGyXBFgroQ5QKM9UhqoRecqXs9G4E5vqcDFd5GsZ
         zpOqoTcTr8NGbqjME7Jf06T2+2r1eVFPqqlin9VGRUJnvs3QhccXrUQeoYg0zHr8PGOO
         gUYg==
X-Gm-Message-State: ANoB5pmSf1SWVoRp90zCuFJbv/Fzhn6Jvp8oMTCzOuYFyjsAbBZkJQjj
        rQ9lQVpP4ODVB4ES0JocbfQrC4cEv0trvly3fdtoEArJK+Q1uQAUNrc5UvnNFuYfXm88dfVDOGp
        dxYBcE+QuGt4PAhwjc/JwKtOnpSLJH9vZTVO8y8pS7jAFHDToeDESaSsbGPwCRcJ5
X-Received: by 2002:a17:907:986c:b0:7a0:b505:e8f9 with SMTP id ko12-20020a170907986c00b007a0b505e8f9mr57399306ejc.216.1670230045745;
        Mon, 05 Dec 2022 00:47:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4akIQi8ZxTBNZtjIUUOko4vMClvta2bAqlLxc8Vd0sNOyBb3DMgM9yf+Lei9GFyOV6jqe66g==
X-Received: by 2002:a17:907:986c:b0:7a0:b505:e8f9 with SMTP id ko12-20020a170907986c00b007a0b505e8f9mr57399290ejc.216.1670230045506;
        Mon, 05 Dec 2022 00:47:25 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r9-20020a1709061ba900b007aec1b39478sm5997193ejg.188.2022.12.05.00.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 00:47:24 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: adjust entry after renaming the vmx hyperv
 files
In-Reply-To: <20221205082044.10141-1-lukas.bulwahn@gmail.com>
References: <20221205082044.10141-1-lukas.bulwahn@gmail.com>
Date:   Mon, 05 Dec 2022 09:47:23 +0100
Message-ID: <87pmcydyp0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lukas Bulwahn <lukas.bulwahn@gmail.com> writes:

> Commit a789aeba4196 ("KVM: VMX: Rename "vmx/evmcs.{ch}" to
> "vmx/hyperv.{ch}"") renames the VMX specific Hyper-V files, but does not
> adjust the entry in MAINTAINERS.
>
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken reference.
>
> Repair this file reference in KVM X86 HYPER-V (KVM/hyper-v).
>

Fixes: a789aeba4196 ("KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"")

maybe?

> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ceda8a0abffa..8fda3844b55b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11457,7 +11457,7 @@ F:	arch/x86/kvm/hyperv.*
>  F:	arch/x86/kvm/kvm_onhyperv.*
>  F:	arch/x86/kvm/svm/hyperv.*
>  F:	arch/x86/kvm/svm/svm_onhyperv.*
> -F:	arch/x86/kvm/vmx/evmcs.*
> +F:	arch/x86/kvm/vmx/hyperv.*
>  
>  KVM X86 Xen (KVM/Xen)
>  M:	David Woodhouse <dwmw2@infradead.org>

Reviewed-by: 

-- 
Vitaly

