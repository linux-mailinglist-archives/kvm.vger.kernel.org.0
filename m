Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650345FBBEA
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 22:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJKUMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 16:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiJKUMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 16:12:38 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398F09AFD4
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 13:12:37 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h12so7710103pjk.0
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 13:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1qKZeizBSN1p+9fBDhD7IRH7twViwQ28Qm59ICeA+iE=;
        b=jGrMksgym7vzJ+al8aiqd6ZvYoLuOyDOgiiCOv7N4NUq0Vgj2rq0tvWOCmMhhGuZ/x
         7iPChadjeG4Z5Ue0LPZIHF0UFGCFbmgWAvBz+7y8dzwDSBQYJfpnAWIGWodPKAu5SV0l
         Vc8OH1Oyxp0lr5rNWkzNjiYQJfo3x6g0oHCAR9KWJtMbnG/Fs6Wbxtu1MGP4keDcqhAk
         vm+mgAbw0jegdhWHm7Jbpp4FwHdm4G+LFKn5gEwtdennNPojHrRIEwkvyVjVn5Xveuy+
         ay2Tos2bMyNRa6iAnVn44tZeHlB3760xzNFYK0I4sqzugFh4p9S89omq9OiQ3GDXWbZW
         koDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qKZeizBSN1p+9fBDhD7IRH7twViwQ28Qm59ICeA+iE=;
        b=Y76p0rUaErji7In7DfxEZwozXY2y8z75kb2Al93x8VLlSid9Tkr7EjEOGVEcREr/22
         bpIlc/YOqMVmGnWzPKix3+uiZgZCNIjBDVhVxnzmEtGoOVUGbr1MR76BZQH/6XNrQHcJ
         G6ELiZ5o6gO8bXg0i0b34z/pjrdE8p6UF54z5Bj6NLtKo0BC+ydj7oKjsZApv14y+Qw5
         m1SA9XZg5aTL4BLIqGlmkNYqT7L7Q/RZac5I3Coi3PqJ6dFZMANiERGopiWSpY0Hi3lS
         7z5NHgRX3rPM8Rvv2YuJRtG3BrKJtwNqAqgvkUOptdWgCs4LG53yoq4Qh4nFzc92l0cv
         K7rw==
X-Gm-Message-State: ACrzQf0+++R3qxYxa2JnT9rJ2qbMPkqIg3CvxcVbTmjzkg/r3J7gknTw
        xyEIyMSJDKGBxSFBCsFTwavvZk4W9e0MvQ==
X-Google-Smtp-Source: AMsMyM47IaWxbQxEPafkMgECk/yRHxeClzEHnfw9+bghRUkMzhfk9UAO+woKnUQovHebcw4nnt7VRQ==
X-Received: by 2002:a17:903:32d0:b0:17f:9224:6e1f with SMTP id i16-20020a17090332d000b0017f92246e1fmr26132140plr.126.1665519156633;
        Tue, 11 Oct 2022 13:12:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p16-20020a170903249000b0017f864355aasm9042985plw.164.2022.10.11.13.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 13:12:36 -0700 (PDT)
Date:   Tue, 11 Oct 2022 20:12:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Message-ID: <Y0XOMOSnMq49IgRW@google.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921173546.2674386-2-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, David Matlack wrote:
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 6bdaacb6faa0..168c46fd8dd1 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -230,14 +230,14 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
>  }
>  
>  #ifdef CONFIG_X86_64
> -static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
> +extern bool tdp_mmu_enabled;
>  #else
> -static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
> +#define tdp_mmu_enabled false
>  #endif

Rather than open code references to the variable, keep the wrappers so that the
guts can be changed without needing to churn a pile of code.  I'll follow-up in
the "Split out TDP MMU page fault handling" with the reasoning.

E.g.

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6bdaacb6faa0..1ad6d02e103f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -230,14 +230,21 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
 }
 
 #ifdef CONFIG_X86_64
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
+extern bool tdp_mmu_enabled;
+#endif
+
+static inline bool is_tdp_mmu_enabled(void)
+{
+#ifdef CONFIG_X86_64
+	return tdp_mmu_enabled;
 #else
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
+	return false;
 #endif
+}
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
-	return !is_tdp_mmu_enabled(kvm) || kvm_shadow_root_allocated(kvm);
+	return !is_tdp_mmu_enabled() || kvm_shadow_root_allocated(kvm);
 }
 
 static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)

