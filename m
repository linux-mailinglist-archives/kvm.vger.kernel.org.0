Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6A67C0151
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbjJJQNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbjJJQNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:13:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1219FB7
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696954351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HwWBmshMoiCixnS99NmNTL6QgwlkX3WoE8OY6VxV+Dc=;
        b=fL9YlONUQNFWIxj7ISIaf2ldOpA0ou+qFLORHkGyWx6AImAIxUJR7q3GOdqK9GM+BqFpdp
        dU57cXm5pK0LTUW73rO8fe3C4oWZ/qK2WtAAaiSyKhFwR9ppHLshMBaEbhmqCT7zaIepH+
        6PVTK4l6ZtPP7oLWYzFpZwpICWDQSAA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-CL637J3iMKy6iaBq0JBKgw-1; Tue, 10 Oct 2023 12:12:29 -0400
X-MC-Unique: CL637J3iMKy6iaBq0JBKgw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32cef5f8af5so426875f8f.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:12:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696954348; x=1697559148;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HwWBmshMoiCixnS99NmNTL6QgwlkX3WoE8OY6VxV+Dc=;
        b=dKe6BU9LXltKZ3DQDxd3x4aOkJlxc9eu8P2fuwJch2H7Lvj2xJDU+I/LBJ4xF4zTb2
         DWX2oN/ccJJvw9Rn18nX662rYPRZ8F65ressbzTKtsiYqQwwHa2xkeWNcc1jiNLOH8B1
         NqXtEW8nQc3aBbSjQMq/mdfmNZhNhZwIgnxoN/rhTQ2q2JsgGc2TyfAqPEDXp3Xm5y3F
         QRJfmFdzJ9Or+lEhse6cV0pHj9VB2aT9cpip4Y3yVeON25kBB7GlzNkwGKi2jpnfj8NN
         ljCfa+kK7pglIN1+PKWdPRL/izlxRWv2YESpLDwJELPddXNVkQsSp8tDPTq2/uOB5F3G
         X22Q==
X-Gm-Message-State: AOJu0YyF3/xAfqQhlGt6XAfO/pHB57SAwDgFyECCr7lkH2ukoxpRZ7Cl
        XlgTKLXNQ8SK3KrPhCcSIeofTIH3T0r8dC2ph7H+PW9lIGtMMlZG1RT6lMh6KMlKqf39oJ+Kg11
        VK50uiH5lgQED
X-Received: by 2002:a05:6000:243:b0:329:6b53:e3ad with SMTP id m3-20020a056000024300b003296b53e3admr10803403wrz.34.1696954348427;
        Tue, 10 Oct 2023 09:12:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IES8Q9DWNOpjBqrp2V2Cl2LKRigDk4U8DPwzTgvqENIa2+Gt/O7S7D3nvy1sb4iqw39jOi8+A==
X-Received: by 2002:a05:6000:243:b0:329:6b53:e3ad with SMTP id m3-20020a056000024300b003296b53e3admr10803382wrz.34.1696954348022;
        Tue, 10 Oct 2023 09:12:28 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id f23-20020a7bc8d7000000b003fe1c332810sm16769821wml.33.2023.10.10.09.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 09:12:27 -0700 (PDT)
Message-ID: <e4d6c6a5030f49f44febf99ba4c7040938c3c483.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86/xsave: Remove 'return void' expression for
 'void function'
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Oct 2023 19:12:26 +0300
In-Reply-To: <20231007064019.17472-1-likexu@tencent.com>
References: <20231007064019.17472-1-likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У сб, 2023-10-07 у 14:40 +0800, Like Xu пише:
> From: Like Xu <likexu@tencent.com>
> 
> The requested info will be stored in 'guest_xsave->region' referenced by
> the incoming pointer "struct kvm_xsave *guest_xsave", thus there is no need
> to explicitly use return void expression for a void function "static void
> kvm_vcpu_ioctl_x86_get_xsave(...)". The issue is caught with [-Wpedantic].
> 
> Fixes: 2d287ec65e79 ("x86/fpu: Allow caller to constrain xfeatures when copying to uabi buffer")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fdb2b0e61c43..2571466a317f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5503,8 +5503,8 @@ static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
>  static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
>  					 struct kvm_xsave *guest_xsave)
>  {
> -	return kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
> -					     sizeof(guest_xsave->region));
> +	kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
> +				      sizeof(guest_xsave->region));
>  }
>  
>  static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
> 
> base-commit: 86701e115030e020a052216baa942e8547e0b487
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

