Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F7657C174
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 02:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiGUAJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 20:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiGUAJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 20:09:32 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F44774DF8
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:09:31 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g4so148889pgc.1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qoM/VmdDCaAfMA+on7Rs8dl/w+6tnEP1CJ9Tx8GJQac=;
        b=XtncFWuR6Mkf8iqk2BOqnm1CQuiXPYWbfi2jD9MucHQXqpYYwjTkz3USTC9SHn8GVi
         3Ste7xIBqwTiTcQ4GzJT5VkZwHhF/QTJwol032j0NbEekybIz2/ZieK9ZpLZeqaIkgfV
         Qw5BBtJg8DOSEWng5/HYxDxWEzVrDzhBnZJUCiNJqaZecPtIcy9h/tE0IviGWtbTbir9
         fekem5QltHNjxYKx3+CwRZaLi0JZvK2BIiCxTOEsAD95z/dFkMrEGutrQ1LUfDRt4019
         TfN0SWqciZb05/JD9Ly0XwfR2gUVyANeRMmHcvVwPGTjtuyNO8dl4JHYOeZN6dMx3+KZ
         y3rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qoM/VmdDCaAfMA+on7Rs8dl/w+6tnEP1CJ9Tx8GJQac=;
        b=UL0FOZxdR270PAHkiwFeUoJMMhPb2C8jNhFu3TOrOC3G62QAqv2dW6vPIOOhm7h0Hp
         ECWijyCI5S7KvxJ6HUWzsC7XeASOPjbSPUYs7ZwnUh+x4tGmyqolp1hIbom6ea7rPqz2
         H+o4c22KGJNSGuhzJlxn00xSERejYTz4F6v+s0S3TXKeYHm9POdmlIIkMPBTfAwLO3pC
         3v2Fry+sIeddlv1rze7acLJUPOiJk1dW8AwMNx1ONhPBTjxRfhXVJJVQVAcxOM7HGUHZ
         N3v19m445W0pv7qCtqaC38BMgnuUP6PQ9Bh+o6U6hOa8XXhqrfBvBWFkeDKU9/evFK5x
         egkA==
X-Gm-Message-State: AJIora+6e1yneE36FxKjAPD7zTPoSHoo/M+cxdYajYuUliTNIWIz5Ot/
        VlkaBxpBDPZ+3ijmA6HxN4wCgg==
X-Google-Smtp-Source: AGRyM1uv3DKDwGbdhApYXZ890Ubnlvr9tiaYZew0vTk3Q+Trt+AUezDjXwQ289fb2NvmCfGWQGkt7Q==
X-Received: by 2002:a63:515f:0:b0:419:b668:4f09 with SMTP id r31-20020a63515f000000b00419b6684f09mr29485004pgl.347.1658362170775;
        Wed, 20 Jul 2022 17:09:30 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id t2-20020a17090a024200b001efff0a4ca4sm56480pje.51.2022.07.20.17.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 17:09:30 -0700 (PDT)
Date:   Thu, 21 Jul 2022 00:09:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 06/11] KVM: x86: emulator/smm: number of GPRs in the
 SMRAM image depends on the image format
Message-ID: <YtiZNg7LqVuepc85@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
 <20220621150902.46126-7-mlevitsk@redhat.com>
 <YtiYdTWQ7Vy+IHLO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtiYdTWQ7Vy+IHLO@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 21, 2022, Sean Christopherson wrote:
> On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> > On 64 bit host, if the guest doesn't have X86_FEATURE_LM, we would
> 
> s/we would/KVM will
> 
> > access 16 gprs to 32-bit smram image, causing out-ouf-bound ram
> > access.
> > 
> > On 32 bit host, the rsm_load_state_64/enter_smm_save_state_64
> > is compiled out, thus access overflow can't happen.
> > 
> > Fixes: b443183a25ab61 ("KVM: x86: Reduce the number of emulator GPRs to '8' for 32-bit KVM")
> 
> Argh, I forgot that this one of the like five places KVM actually respects the
> long mode flag.  Even worse, I fixed basically the same thing a while back,
> commit b68f3cc7d978 ("KVM: x86: Always use 32-bit SMRAM save state for 32-bit kernels").
> 
> We should really harden put_smstate() and GET_SMSTATE()...

Or I could read the next few patches and see that they go away...
