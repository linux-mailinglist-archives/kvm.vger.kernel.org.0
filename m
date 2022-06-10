Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64938546C1C
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 20:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347482AbiFJSEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 14:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346653AbiFJSEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 14:04:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AE48DF5E
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 11:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654884245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uZZMSYsxNi00mISt/w3TR5/PXiZxHkemYMMPWE5iiPc=;
        b=Mnee0qtMvzb7FKqTSZfbZ9PFSqnMsnqkR5yo71n3hWxijtlDgtirMy+ApiaGxHohlIU7ln
        OD6Sq7SRhVV5QHm8BhbTjG9hHcdGekTmBeF+4pITQLOXkDuEFL8aQNoM5zyf7ZuyOSOAnl
        Fdm/YXxRjXMDn7RwOWtNNQ3tpcREC88=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-R6N8GyT_NW2xUuGUochPag-1; Fri, 10 Jun 2022 14:04:04 -0400
X-MC-Unique: R6N8GyT_NW2xUuGUochPag-1
Received: by mail-wm1-f69.google.com with SMTP id k15-20020a7bc40f000000b0039c4b7f7d09so3747wmi.8
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 11:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uZZMSYsxNi00mISt/w3TR5/PXiZxHkemYMMPWE5iiPc=;
        b=08Fww1opH5AzRHNw9uDdrzrZY01YadzXXKVJqpI1w8ILTncVOJg0ntOlMHVoDl0Ikj
         kMmGwgQlKRkTWTprZQLsMw4hgbbK1B1oc2Drl6TOFtGcM+XPZSkgHNj4GrRV9BDr9o7U
         MrR44W34f9LCvOJA0Psrz/Ov4DErkNe1DQYICTyYQ2SDunHizbGaWuDPmJB9VYS6oMWl
         OZiFfTGz6b0HQFdoR/SDW1NhsXcsqNzmEZrHmk3tjaKs4f3kNOmXPVK1dnSTYOhhgbGv
         5tIBI+JoEw2uuX0U35Yp1cWbezWRkdzd9u7AMyinbneVDQsQU7kY5fDelqNY2/lcVwoH
         jjog==
X-Gm-Message-State: AOAM531QKJDgki9OIpnCATPKLPUb9mjOw6eyI7xM3fz72U8HgQbQYHJL
        u7vNOQZyczH/1hA2XBXsdRi9pTUR6JlG3g1cnptqW5bZ4d58Vov6cbaMIJ1tt0XSkB3ZHe3owWj
        AisyxUuT8kL1/
X-Received: by 2002:a1c:5444:0:b0:39c:3761:ac37 with SMTP id p4-20020a1c5444000000b0039c3761ac37mr943449wmi.144.1654884242901;
        Fri, 10 Jun 2022 11:04:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKlTK8/3tGwSukWS1t2M37Kp0CZ0Kvfx/vbiurZ+tsKe1uz2FzmudIzWkwYCQatu+kCzj7aA==
X-Received: by 2002:a1c:5444:0:b0:39c:3761:ac37 with SMTP id p4-20020a1c5444000000b0039c3761ac37mr943440wmi.144.1654884242685;
        Fri, 10 Jun 2022 11:04:02 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm68257wrf.63.2022.06.10.11.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 11:04:02 -0700 (PDT)
Date:   Fri, 10 Jun 2022 20:03:59 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 142/144] KVM: selftests: Add kvm_has_cap() to provide
 syntactic sugar
Message-ID: <20220610180359.sx3yiunvpu56stm5@gator>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-143-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603004331.1523888-143-seanjc@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 12:43:29AM +0000, Sean Christopherson wrote:
...
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 8f7ee9cb551c..12b7c40542df 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -80,7 +80,7 @@ unsigned int kvm_check_cap(long cap)
>  
>  	close(kvm_fd);
>  
> -	return ret;
> +	return (unsigned int)ret;
>  }

This belongs in the last patch.

Thanks,
drew

