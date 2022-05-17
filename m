Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05EC52ACA4
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 22:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345454AbiEQUVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 16:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351417AbiEQUVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 16:21:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38FB7522C2
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652818907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KMctevbP3UYOVBxFNGJreSIeb1QzMwtAmu7snhHIrlU=;
        b=haIYh5bebKBMXOJd52h3PEKd/zbC64ez4E7mkG3APFycCi0ofoz+nVf4M+IT9xLhIIVvOU
        VzqhX+ZrYB/gS6Bbs3Exqm8S9ikQdlIqXkLJNxBeiLG3+OjhdaBdaOY7oJRLOcLUS96VHA
        xaSkgUTTGXVqgSD5KEPGa1oS5I4yJSY=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-cyK2eXvtNIKdsGTSBhscKg-1; Tue, 17 May 2022 16:21:41 -0400
X-MC-Unique: cyK2eXvtNIKdsGTSBhscKg-1
Received: by mail-io1-f72.google.com with SMTP id k2-20020a0566022d8200b0065ad142f8c1so13121258iow.12
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KMctevbP3UYOVBxFNGJreSIeb1QzMwtAmu7snhHIrlU=;
        b=ct0vdy7Y9onrPwVNkImkntvS6QPdCugsGhAenEVfYMymgsAzsDALn4WnitGq3T5iDr
         jYNHsT3ajmSVCsVqq2Zlj+p/LzZ7V5pSz+ls4wAXnURA60XVPrvSUrgVUNQveL+PDSuG
         WYc1SXvjKFavvDcW4w7Y1pLTcrMCzQdatP7VTkYV/UMAS1hd7gMqauv4puRbAGtIFbOn
         OsjYoRmEsk/aY8xzM9wCJumdgaQ+T+lWItHBxNBp3Dtz41Bq6j4nqbVi0vCgPPVYPk+/
         GaBXYemWhdrAwUegdpWAVExrgT9grentgTG/hdgqRgFixl5wKUNA8iRnRMNyWcyfcNES
         Rv8Q==
X-Gm-Message-State: AOAM533Oo1EXAqguH5SevUrzVjT2/6PsTB+ZhgX5X4jEBXK53XSgKHtr
        erqtyE7AU2BR6G/sl9RwxcZuVcs3Y/mu6Mr5GrLiGbLsclBFLDi80GEwB/V3HDRK21wi0LrM+jp
        BFMeX5+HosOgC
X-Received: by 2002:a6b:ed0f:0:b0:657:b1ff:be52 with SMTP id n15-20020a6bed0f000000b00657b1ffbe52mr10624611iog.34.1652818900932;
        Tue, 17 May 2022 13:21:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiZg55hMKhFc9XJTEOjw9yA3gXA0VR66dIIimf/DLE9obUB7+tH3gqedmlZxo9PNZQnDkuJw==
X-Received: by 2002:a6b:ed0f:0:b0:657:b1ff:be52 with SMTP id n15-20020a6bed0f000000b00657b1ffbe52mr10624603iog.34.1652818900722;
        Tue, 17 May 2022 13:21:40 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id n5-20020a02c785000000b0032b3a78175fsm23636jao.35.2022.05.17.13.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:21:40 -0700 (PDT)
Date:   Tue, 17 May 2022 16:21:36 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 08/10] KVM: selftests: Drop unnecessary rule for
 $(LIBKVM_OBJS)
Message-ID: <YoQD0EDDeW+P3rSh@xz-m1.local>
References: <20220517190524.2202762-1-dmatlack@google.com>
 <20220517190524.2202762-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220517190524.2202762-9-dmatlack@google.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 07:05:22PM +0000, David Matlack wrote:
> Drop the "all: $(LIBKVM_OBJS)" rule. The KVM selftests already depend
> on $(LIBKVM_OBJS), so there is no reason to have this rule.
> 
> Suggested-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Since previous patch touched the same line, normally for such a trivial
change I'll just squash into it.  Or at least it should be before the
previous patch then that one contains one less LOC change.  Anyway:

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

> ---
>  tools/testing/selftests/kvm/Makefile | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index cd7a9df4ad6d..0889fc17baa5 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -189,7 +189,6 @@ $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
>  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> -all: $(LIBKVM_OBJS)
>  $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
>  
>  cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
> -- 
> 2.36.0.550.gb090851708-goog
> 

-- 
Peter Xu

