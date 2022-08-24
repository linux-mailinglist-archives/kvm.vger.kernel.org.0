Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00E45A0414
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 00:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiHXWej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 18:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiHXWeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 18:34:37 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26D3167CF
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 15:34:36 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso3100676pjk.0
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 15:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=hIBl+NKPOq9B830RCZZr13TZkfTjSQ1qG+Cn7l1J9W4=;
        b=eKaGdeOzZHTemPIaMidSyugctA+XVf9pmKFc6+bBqUs7RzQ/Frlpc14eGSn1yxsmnQ
         T//qMXgIxYfk6twfYhrZY3Ww+vT25OUES8c30ez7Hby6nRsKl9hoRwaHK7MJJy2Miwfq
         mbZAa6oFGWBj9acSEK6AP/TgU2zJX1HnVdxUHxL+WWfAgu2pUELhvEJhkIKK20GEWWVT
         VOBpSFDLa71HfBHzj6B2VN2qq3w84BqlJKRVh5xh1juHQJficEYa6RCshSQns0zo74rs
         +3Zbt/qHvFu+QfNZvDlA60hSD6e2SB8igE98TNf+oJcRjXqTgB5wJM21L9eqxR8fG5Fq
         4oiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=hIBl+NKPOq9B830RCZZr13TZkfTjSQ1qG+Cn7l1J9W4=;
        b=LCgZRMZWKCwb2hoSLnBqlZVUkM0UPhx62qLsjCeaBtEIfMypzdx+VVtEzy5LsDreuA
         9+k1jAKwZFo0/MiC1AL22c8p0ErWJE7TOcDlMZMN/nn+bXw9csyDlF9L/5E+y6ZiyPKJ
         qM8e0DUInge/B8cs0u+nOIgojj/PUItkFSU2mDKCSSX8IFWNuBhaKCDDfpUBtNY+15TT
         DSWSSELjGCbpHQ7KvyKtTSn3o0FkiO809wUleO0xurghYUeGJ6RaVb4yXyr+La5X36Ml
         v7RESgcPyXMDD64W2mWAQGlmrA4i9xF5LHzPRzc9Z9ca1x9j0+5a2fWbjNjOxICu2b/N
         izCQ==
X-Gm-Message-State: ACgBeo1niqr7IR1cgy6uhssnCJeVjzMAJa7dP/q46cgBgRn698tjk/Gi
        mw/hIri/W8GwQlCCAKafaQqyJQ==
X-Google-Smtp-Source: AA6agR4daW+hXlRTu4EWnhGoSW9ryqqPfb4LDLZ/rLEUpa7uB8LHuAbBLypwzLMY83nLN3ia6xtbnA==
X-Received: by 2002:a17:90b:4a41:b0:1fb:77e0:3ff2 with SMTP id lb1-20020a17090b4a4100b001fb77e03ff2mr7358808pjb.161.1661380476105;
        Wed, 24 Aug 2022 15:34:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b187-20020a62cfc4000000b0053641e66825sm10212130pfg.173.2022.08.24.15.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 15:34:35 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:34:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 10/13] KVM: x86: emulator/smm: use smram struct for 64
 bit smram load/restore
Message-ID: <Ywand7dcvFTNgKep@google.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
 <20220803155011.43721-11-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803155011.43721-11-mlevitsk@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022, Maxim Levitsky wrote:
> @@ -9909,57 +9906,51 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, struct kvm_smram_stat
>  }
>  
>  #ifdef CONFIG_X86_64
> -static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
> +static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, struct kvm_smram_state_64 *smram)

Please put these on different lines.

>  	struct desc_ptr dt;
> -	struct kvm_segment seg;
>  	unsigned long val;
>  	int i;
>  
>  	for (i = 0; i < 16; i++)
> -		put_smstate(u64, buf, 0x7ff8 - i * 8, kvm_register_read_raw(vcpu, i));
> +		smram->gprs[15 - i] = kvm_register_read_raw(vcpu, i);

Blech, why do I get the feeling that the original layout was designed so that
ucode could use PUSHAD?  This look so weird...
