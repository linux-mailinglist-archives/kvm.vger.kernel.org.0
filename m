Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F6B4D1D3E
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244115AbiCHQdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiCHQdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:33:42 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292371CB04
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:32:46 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p17so17542828plo.9
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 08:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MDJaDnlaWqCwSLZ2xY2jUso11XFGercUGusBxxAgtVk=;
        b=CozgWYjzxJCzVbVnNQdW/74opk6c0nC+E7ilHT/h1ebaB3jgodE/BBGTGntnHY6NzK
         xcLiO9kESCm9B7UZiGxrHLlTqTST3MhnlaMYFCRDVZvGcH5y6ujzPyr/5MXhjdZd6aUg
         kwWlLp1PTpdeSo3TgWijZbZPIIMv4tC57Ig/3rWA0cELRhRdI8U+XQ+8Yx+0+R3LuNln
         7BSmN1DWXCwCQynTO6IkVrBwQhZxJacq5cn/jS7GKLRiA96xHWpxxFUbbeARwQg6xjPt
         C69kIQRngF0Cy+gv/rOCprJSLGN3TbzXkCfeTeZE1Bhn6B9mR9BxG5KrNA0TzNvrnV9g
         eTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MDJaDnlaWqCwSLZ2xY2jUso11XFGercUGusBxxAgtVk=;
        b=WTZP9QP4wPUD2WoQ9LF2p/RojNrMonrjpb1SYw3J1G6iSyYtSV6qNNZcBo6yGg5KEf
         PHbqwjo5pM/pMeGDyaU46xn56K6i9AOlI/swqve9QPiOgoRoOVJvr+UcWLnSktnuKabM
         DZxrM4Lv+lpUo5p+HKzoW8IW9bEiFVFbUwXdh34pE/pWUeK4irH8chJVgQDhzdQHCZvn
         7KhdeXT37uk2/9SywVPPatNnAipvksQqvnnZPg2+7idrMnAymsvNodxgHfsTn7qVfqcn
         V9w45zv7WmUnIUJfPz+cDK6jCwIVefyIajYKjuebgQC1nWJ7qZ2Uay/B1PlWjQWQZu6z
         +aFg==
X-Gm-Message-State: AOAM532THqLTiIwTQrX4/sPy+w4OFfJNe4iIEMYHQChH/q/arPNjKiO6
        xtArl+3ZPY4vkI0UP5m+8zLHhw==
X-Google-Smtp-Source: ABdhPJw+HlG6+ACvZrUVftgp2vOvO45j4Z6gaYuI0dqdXvMXy6c8L2vtKpr+LlK3ZLQ0tINSSDGrlA==
X-Received: by 2002:a17:902:6b47:b0:150:80de:5d49 with SMTP id g7-20020a1709026b4700b0015080de5d49mr18353382plt.77.1646757165466;
        Tue, 08 Mar 2022 08:32:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j9-20020a056a00234900b004f6fe0f4cb2sm9217580pfj.14.2022.03.08.08.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 08:32:44 -0800 (PST)
Date:   Tue, 8 Mar 2022 16:32:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 01/25] KVM: x86/mmu: avoid indirect call for get_cr3
Message-ID: <YieFKfjrgTTnYkL7@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-2-pbonzini@redhat.com>
 <YieBXzkOkB9SZpyp@google.com>
 <2652c27e-ce8c-eb40-1979-9fe732aa9085@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2652c27e-ce8c-eb40-1979-9fe732aa9085@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022, Paolo Bonzini wrote:
> On 3/8/22 17:16, Sean Christopherson wrote:
> > 
> > > +static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> > Wrap the params, no reason to make this line so long.
> > 
> > > +{
> > > +#ifdef CONFIG_RETPOLINE
> > > +	if (mmu->get_guest_pgd == kvm_get_guest_cr3)
> > > +		return kvm_read_cr3(vcpu);
> > This is unnecessarily fragile and confusing at first glance.  Compilers are smart
> > enough to generate a non-inline version of functions if they're used for function
> > pointers, while still inlining where appropriate.  In other words, just drop
> > kvm_get_guest_cr3() entirely, a al get_pdptr => kvm_pdptr_read().
> 
> Unfortunately this isn't entirely true.  The function pointer will not match
> between compilation units, in this case between the one that calls
> kvm_mmu_get_guest_pgd and the one that assigned kvm_read_cr3 to the function
> pointer.

Ooh, that's a nasty gotcha.  And that's why your v1 used a NULL entry as a sentinel
for rerouting to kvm_read_cr3().  Hrm, I'm torn between disliking the NULL behavior
and disliking the subtle redirect :-)

Aha!  An idea that would provide line of sight to avoiding retpoline in all cases
once we use static_call() for nested_ops, which I really want to do...  Drop the
mmu hook entirely and replace it with:

static inline kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu)
{
	if (!mmu_is_nested(vcpu))
		return kvm_read_cr3(vcpu);
	else
		return kvm_x86_ops.nested_ops->get_guest_pgd(vcpu);
}
