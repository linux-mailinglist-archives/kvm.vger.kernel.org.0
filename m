Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDE064CFE9
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239009AbiLNTLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238428AbiLNTLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:11:33 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185D8DEB7
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 11:11:32 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d15so4360004pls.6
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 11:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k9cGqAjg4onQOK2CDcNCWzuxJXzOE93Rua+7XFpp9qQ=;
        b=rNSjP36539bQaZ50jWk1UKjWFkvEwm2WoMxQBCIFBR6GjWJ0DzUyyCfRsOFGuQtoFG
         194yYYY4LwjCTVwPAEsXO2dLrAzxROlPVtz/BqhF/7b8eOloavcHNc6/ddF10ACn5GPX
         ae3m2kQ6OoooDmZuoTIklSktWJMasHeYtivba72UWQ4cmcu9tb8NlbQzldqr7hv0Fbsg
         WNkplU9RJT2DQUMdFT9a8znpGwfkoPq4X0z63l9fkEoI1GBGHzABK/ehtK4TGtk1/4tV
         1ybhvM+iU/yGA5HuyiWcjZmEJ6XQxI9UctxGnPX9Tr5BwDtSAfN/zob3oqsgqTP1OTVC
         mQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9cGqAjg4onQOK2CDcNCWzuxJXzOE93Rua+7XFpp9qQ=;
        b=51kVOjoOOS69UQh5TDpWcV1vaf52/JsrK3odwKTEEj5P1Z497KFeDNcfA4RxzscP/n
         Yj3YNaO6mAZc5/dxPoTfRiVr9FjxkRyDaNEH4uXcVyofdVnv3Sd69Mkz4i2F4e9gMEEz
         rsnA4HFJeh4u1MBa43dKFPdpA5gWP+JpU7JedPk7cQX++BhCDDhBrDTtiuJjeJ7n0Z5m
         66mCmUBtdP+nRBljR3eNYTxUx4ep+4TprFOwgaimwiykxJ/yT28uJgHjNQV8vHO7F/eF
         bKARztjz7fSP9GgcudyX++v9+DvZNsChTQakrBuJlbSfcx2s3fTEBfwbJPsVG8FPWLLt
         rY0g==
X-Gm-Message-State: AFqh2kqLcHa5+zqobtyheXrmboEuf/oTfDP5zr6+kDTosbP7u05YA3QT
        IsPJsNRJghAeIrelEw9F7ztZ+g==
X-Google-Smtp-Source: AMrXdXtS9+OW8PChs6xxp1Xeqb/YR3Cz7OEFTIwUSqoYiAAJza0TfZ5AkSO4GplC8QT33sBUH1DyCA==
X-Received: by 2002:a17:902:b187:b0:189:58a8:282 with SMTP id s7-20020a170902b18700b0018958a80282mr543017plr.3.1671045091469;
        Wed, 14 Dec 2022 11:11:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t14-20020a1709027fce00b00188fce6e8absm2175827plb.280.2022.12.14.11.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 11:11:30 -0800 (PST)
Date:   Wed, 14 Dec 2022 19:11:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Hou Wenlong <houwenlong.hwl@antgroup.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing
 in kvm_set_pte_rmapp()
Message-ID: <Y5of3zZtfogg1Rml@google.com>
References: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
 <0ce24d7078fa5f1f8d64b0c59826c50f32f8065e.1665214747.git.houwenlong.hwl@antgroup.com>
 <Y0bvT8k9vlDUPup+@google.com>
 <CAJhGHyAENXDLL=2-2KXL3_hKF+XZaFxOfRV2vaf6E5nhUa1Mzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyAENXDLL=2-2KXL3_hKF+XZaFxOfRV2vaf6E5nhUa1Mzw@mail.gmail.com>
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

On Wed, Dec 14, 2022, Lai Jiangshan wrote:
> On Thu, Oct 13, 2022 at 1:00 AM Sean Christopherson <seanjc@google.com> wrote:
> > > +/* Flush the given page (huge or not) of guest memory. */
> > > +static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
> > > +{
> > > +     u64 pages = KVM_PAGES_PER_HPAGE(level);
> > > +
> >
> > Rather than require the caller to align gfn, what about doing gfn_round_for_level()
> > in this helper?  It's a little odd that the caller needs to align gfn but doesn't
> > have to compute the size.
> >
> > I'm 99% certain kvm_set_pte_rmap() is the only path that doesn't already align the
> > gfn, but it's nice to not have to worry about getting this right, e.g. alternatively
> > this helper could WARN if the gfn is misaligned, but that's _more work.
> >
> >         kvm_flush_remote_tlbs_with_address(kvm, gfn_round_for_level(gfn, level),
> >                                            KVM_PAGES_PER_HPAGE(level);
> >
> > If no one objects, this can be done when the series is applied, i.e. no need to
> > send v5 just for this.
> >
> 
> Hello Paolo, Sean, Hou,
> 
> It seems the patchset has not been queued.  I believe it does
> fix bugs.

It's on my list of things to get merged for 6.3.  I haven't been more agressive
in getting it queued because I assume there are very few KVM-on-HyperV users that
are likely to be affected.
