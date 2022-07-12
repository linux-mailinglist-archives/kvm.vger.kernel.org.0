Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3D5571B6F
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 15:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiGLNhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 09:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiGLNhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 09:37:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8A9FB79FF
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 06:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657633031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B3NrhGN3QDhLJqIwcsb2TkKqYIlLbUqMpzzZ94y01dE=;
        b=DfyGYXSZ3VXIACfezfD71o8UNxw+e+FeFziL+zbmPE0fHpN0iJfk8p77HdN+84cG8VsGwH
        wnMh9GCx/+0RVWQ9P8HPEDurbN+KFV5uW/O0fpxhIYbmMxKXwt2lhp50mBjxq1nkBeE1uQ
        e+Zi9TXDYPQXKs2n13/3J7Pi3fOoWfE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-3tNAbuD7MNKbBzLhSt-58w-1; Tue, 12 Jul 2022 09:37:10 -0400
X-MC-Unique: 3tNAbuD7MNKbBzLhSt-58w-1
Received: by mail-qt1-f200.google.com with SMTP id q21-20020ac84115000000b0031bf60d9b35so6880092qtl.4
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 06:37:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=B3NrhGN3QDhLJqIwcsb2TkKqYIlLbUqMpzzZ94y01dE=;
        b=GN2Tt349rMBcR1G03N/WcbG5EmjuyYRK81l/ZX7HjaTlPctSaExS7ZOsYD+It/KrbV
         ugKeGU48S0CS4EIDxnuUIGHS5YtLPwHNkKU+brFmlFgl06AMFZjPqzYZPtUt+TQleR07
         RlHpPY/3KALGVff/eOl0I1szAwPgijXX9JIJ6CGlUBj5CjErq4KPjzun+G0X/I+uNz6M
         O4zTl9Zd/n9Mdot5OiQuOr+QKQMEDxAlvoTbQ9UepVQBZihYRLvO4orZCIRzbKBgoFCA
         HlSHAGdT1u9claHZ02QfBzvNamef7PwpA5oEn4IGq5lnjoFIfS37+NH2NoCwsp2RUL9+
         1cLw==
X-Gm-Message-State: AJIora/sH9fxtoWRhDb2EKF+Ow6E2Qz6nUj8hHO4Ige0nhfh0j57ybzY
        fcr2AwUEnYMFnHNgS5VqQ89byRfgkS9vGWyvst9xekIWFuRUt0Q3s+8k8gpMkCSR3d9D5I/fgGw
        LU9iXl3Xi8Jo8
X-Received: by 2002:a05:620a:4446:b0:6af:1d31:c257 with SMTP id w6-20020a05620a444600b006af1d31c257mr15093795qkp.399.1657633030067;
        Tue, 12 Jul 2022 06:37:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tZ903RTp1aT6+v7VmosFNF43G33TqmEcKlRp3/i8mOo2uGbStQlm5M4dWv2KYJBUgBGZWqgw==
X-Received: by 2002:a05:620a:4446:b0:6af:1d31:c257 with SMTP id w6-20020a05620a444600b006af1d31c257mr15093771qkp.399.1657633029822;
        Tue, 12 Jul 2022 06:37:09 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id o21-20020a05622a009500b0031d4044c464sm7807985qtw.46.2022.07.12.06.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 06:37:09 -0700 (PDT)
Message-ID: <4017447bfd4636f4075d29d8f3c57c4c32fd67d2.camel@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: Set error code to segment selector on
 LLDT/LTR non-canonical #GP
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
Date:   Tue, 12 Jul 2022 16:37:06 +0300
In-Reply-To: <20220711232750.1092012-3-seanjc@google.com>
References: <20220711232750.1092012-1-seanjc@google.com>
         <20220711232750.1092012-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-11 at 23:27 +0000, Sean Christopherson wrote:
> When injecting a #GP on LLDT/LTR due to a non-canonical LDT/TSS base, set
> the error code to the selector.  Intel SDM's says nothing about the #GP,
> but AMD's APM explicitly states that both LLDT and LTR set the error code
> to the selector, not zero.
> 
> Note, a non-canonical memory operand on LLDT/LTR does generate a #GP(0),
> but the KVM code in question is specific to the base from the descriptor.
> 
> Fixes: e37a75a13cda ("KVM: x86: Emulator ignores LDTR/TR extended base on LLDT/LTR")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/emulate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 09e4b67b881f..bd9e9c5627d0 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1736,8 +1736,8 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
>                 if (ret != X86EMUL_CONTINUE)
>                         return ret;
>                 if (emul_is_noncanonical_address(get_desc_base(&seg_desc) |
> -                               ((u64)base3 << 32), ctxt))
> -                       return emulate_gp(ctxt, 0);
> +                                                ((u64)base3 << 32), ctxt))
> +                       return emulate_gp(ctxt, err_code);
>         }
>  
>         if (seg == VCPU_SREG_TR) {

I guess this is the quote from AMD's manual (might we worth to add to the source?)


"The 64-bit system-segment base address must be in canonical form. Otherwise, a general-protection
exception occurs with a selector error-code, #GP(selector), when the system segment is loaded.
System-segment limit values are checked by the processor in both 64-bit and compatibility modes,
under the control of the granularity (G) bit."

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

