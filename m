Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B264F6F2E
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 02:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiDGA21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 20:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiDGA2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 20:28:20 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93B85BE68
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 17:26:21 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id s8so3963950pfk.12
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 17:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JYxH8Wd4nrXFUKoK27SKynkclPMvg/ZZ7jTNviaLYMM=;
        b=AKA+KF/aNHe+UWPbxkSkRBY0RNWtrj3Mu0ZcIZIxxQrmjZdH4WPBAOuknu+cdQHFNT
         PLrciG+s2Qv86qcLJ/4b8R0YZUqNiW6a46rUOM0qdX/YWso/CwnedPv6aOTLc3v/YdD1
         HIlfrGeSk4slDzAu6ilQGZD0bxYvSCBvlKlSDAI82Tkd41MWn0C7pWjneWYGto6wrAH4
         ePsSsWAJDOToKSNQfu/Qv7yZvVyIvJALId7/K2l/uizbvouT9fixH/rvHe7Rd3yZWbZy
         aBriiTyVA31BWOwn3/dsttok8wni5Q/BoWiByBYVhFJsEweJJjziwS+0ZngHylQ3n6yP
         fOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JYxH8Wd4nrXFUKoK27SKynkclPMvg/ZZ7jTNviaLYMM=;
        b=nbLcGOPlHMBrNFw8I4kh3hrtidzby+hrHSLWElb+bqnNTmuDO/AbR2MwkTT3yry6br
         XKdJUegOFkaYXehgOJOap+5Se8g8zjGPtM5XU0jQS5ut9IEJrkVELa2NXSR/W+XrxeJ2
         QQdu/QgsUJXS1H6ag2Ezv6I/2xnry1piF/tQQgfPzRrT4Np0dbl5dEB6l7rs+e+VjwfB
         OozIxFx8N44/UTo+/9SQEn1QxZOZHkbkdkMHwhuZAyF91KJ/brHCVhcJcD4KX3yhmmhh
         OjGPBwUwgAkAIM5+k0OdMgX9WS0Ydx/vXrGEhVHVO7SwWdzNmuUZ2KS6g2Zp7FC0x9fL
         X2QA==
X-Gm-Message-State: AOAM531hqU4IFAfoUIvi8UEJNUaVSjs+q79hoqoplZxLRuLHmAl3tves
        3APXdFE0Chst+4zaMDUjPFoczw==
X-Google-Smtp-Source: ABdhPJy+87fR+JEafumVynFeHjsOql0b40Ua4Ep8O9ThlxJ9EuM625raZEzL5WdfG7f4xrtsRMIX/g==
X-Received: by 2002:a65:530b:0:b0:382:b21d:82eb with SMTP id m11-20020a65530b000000b00382b21d82ebmr9381617pgq.215.1649291181116;
        Wed, 06 Apr 2022 17:26:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090acd0500b001b9c05b075dsm6718725pju.44.2022.04.06.17.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:26:20 -0700 (PDT)
Date:   Thu, 7 Apr 2022 00:26:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <Yk4vqJ1nT+JxEpKo@google.com>
References: <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com>
 <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
 <Yh/nlOXzIhaMLzdk@google.com>
 <YiAdU+pA/RNeyjRi@google.com>
 <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com>
 <YiDps0lOKITPn4gv@google.com>
 <CALMp9eRGNfF0Sb6MTt2ueSmxMmHoF2EgT-0XR=ovteBMy6B2+Q@mail.gmail.com>
 <YiFS241NF6oXaHjf@google.com>
 <764d42ec-4658-f483-b6cb-03596fa6c819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <764d42ec-4658-f483-b6cb-03596fa6c819@redhat.com>
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

On Fri, Mar 04, 2022, Paolo Bonzini wrote:
> On 3/4/22 00:44, Sean Christopherson wrote:
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> > index c92cea0b8ccc..46dd1967ec08 100644
> > --- a/arch/x86/kvm/vmx/nested.h
> > +++ b/arch/x86/kvm/vmx/nested.h
> > @@ -285,8 +285,8 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
> >  }
> > 
> >  /* No difference in the restrictions on guest and host CR4 in VMX operation. */
> > -#define nested_guest_cr4_valid nested_cr4_valid
> > -#define nested_host_cr4_valid  nested_cr4_valid
> > +#define nested_guest_cr4_valid kvm_is_valid_cr4
> > +#define nested_host_cr4_valid  kvm_is_valid_cr4
> 
> This doesn't allow the theoretically possible case of L0 setting some
> CR4-fixed-0 bits for L1.  I'll send another one.

Are you still planning on sending a proper patch for this?

And more importantly, have we shifted your view on this patch/series?
