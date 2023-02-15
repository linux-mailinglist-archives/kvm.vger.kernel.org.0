Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63032698189
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjBORDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjBORDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:03:19 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452FA2CFD0
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:03:04 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id i14-20020a17090aee8e00b00233f1a535e0so1351489pjz.0
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rXpHrm412Se84icLxlhp0c6gn6FcOiMTmYzMu9XFzE0=;
        b=aLJK/RN+Unz5AmXXe1jY38G4rjdZYbR+ulpZxlfYoinsVuT0AVhwUWxXtbsDj+cxdi
         o/xO1bFJomGKwqEdz2sz5QYTN8lW3dhyO/q0maVszkrPBtu9rJ2rfyW4uv1VIkOD7umC
         CR3YEAR8APgGj00V5yp/WQbwIpTihgXmTNa6SOOPf6hlfOikYJu/R38zHTK/27VSgPaf
         FfblQYJBNauILeThbiUEl6MpF57hSexikv3tHqsVOC3XjHRTwp+rphmcFQ6hh/GFzqIJ
         847rlbVckcQrssaXB7GwVsA8r2Ud6PaIUWUPJLPxXVfxrK9vAup92Yn4Rg1nkwG16Jof
         Bgyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rXpHrm412Se84icLxlhp0c6gn6FcOiMTmYzMu9XFzE0=;
        b=24YqzZEWGZS4CIhKiSfKHTEgRNvCbzxGAC05RMwRERaNWcCIqsvsjZvQbYT/3DqorH
         RYtDEnqcrT+C/8DffYusL3x/PDa0Gi2d2E+/BEIfnKzS0dh+rOgbqtRWwFTBT/KQRlL3
         pOMK9sIBsm+UL0pgxNCTfhv73lxpZYwanbdHqM9PvugnW8Ro+J9ilAjpTnEJeCHIJByo
         t/WdEaMcl0kAag8HyI5Utshue0rMFJHgp54E/aw/XHWWwsTAtxk1j1KkNy/muCu8le9f
         twIwYSy3iszL49xSR9Y8ZS2onO+h0BaVBpr9YImaQ1sa8s3F0tbW7MhBInGguc9J3Jf+
         wVpg==
X-Gm-Message-State: AO0yUKW5I54TP9JvrWy8phiLo785xdbs6zB63ejx6tSiTvYUT9HEVBYC
        Bovd+i57JRAAdpQDk4xvXCFpNtWDwDc=
X-Google-Smtp-Source: AK7set/RArgkpEYAvlgEF0UvF1fVSH+rZwKn4nEsJtUurS58zRCLANNB+sRdpIYCCh6+5smbam+TI/Xym8o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:af59:0:b0:4fb:ee04:732a with SMTP id
 s25-20020a63af59000000b004fbee04732amr466823pgo.2.1676480583747; Wed, 15 Feb
 2023 09:03:03 -0800 (PST)
Date:   Wed, 15 Feb 2023 09:03:02 -0800
In-Reply-To: <Y+yfhELf/TbsosO9@linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-5-amoorthy@google.com>
 <Y+yfhELf/TbsosO9@linux.dev>
Message-ID: <Y+0QRsZ4yWyUdpnc@google.com>
Subject: Re: [PATCH 4/8] kvm: Allow hva_pfn_fast to resolve read-only faults.
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Anish Moorthy <amoorthy@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023, Oliver Upton wrote:
> On Wed, Feb 15, 2023 at 01:16:10AM +0000, Anish Moorthy wrote:
> > The upcoming mem_fault_nowait commits will make it so that, when the
> > relevant cap is enabled, hva_to_pfn will return after calling
> > hva_to_pfn_fast without ever attempting to pin memory via
> > hva_to_pfn_slow.
> > 
> > hva_to_pfn_fast currently just fails for read-only faults. However,
> > there doesn't seem to be a reason that we can't just try pinning the
> > page without FOLL_WRITE instead of immediately falling back to slow-GUP.
> > This commit implements that behavior.

State what the patch does, avoid pronouns, and especially don't have "This commmit"
or "This patch" anywhere.  From Documentation/process/submitting-patches.rst:

  Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour.

> > Suggested-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 22 ++++++++++++----------
> >  1 file changed, 12 insertions(+), 10 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d255964ec331e..dae5f48151032 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2479,7 +2479,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
> >  }
> >  
> >  /*
> > - * The fast path to get the writable pfn which will be stored in @pfn,
> > + * The fast path to get the pfn which will be stored in @pfn,
> >   * true indicates success, otherwise false is returned.  It's also the
> >   * only part that runs if we can in atomic context.
> >   */
> > @@ -2487,16 +2487,18 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
> >  			    bool *writable, kvm_pfn_t *pfn)
> >  {
> >  	struct page *page[1];
> > +	bool found_by_fast_gup =
> > +		get_user_page_fast_only(
> > +			addr,
> > +			/*
> > +			 * Fast pin a writable pfn only if it is a write fault request
> > +			 * or the caller allows to map a writable pfn for a read fault
> > +			 * request.
> > +			 */
> > +			(write_fault || writable) ? FOLL_WRITE : 0,
> > +			page);
> >  
> > -	/*
> > -	 * Fast pin a writable pfn only if it is a write fault request
> > -	 * or the caller allows to map a writable pfn for a read fault
> > -	 * request.
> > -	 */
> > -	if (!(write_fault || writable))
> > -		return false;
> > -
> > -	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
> > +	if (found_by_fast_gup) {
> 
> You could have a smaller diff (and arrive at something more readable)

Heh, this whole series just screams "google3". :-)

Anish, please read through 

  Documentation/process/coding-style.rst

and 

  Documentation/process/submitting-patches.rst

particularaly the "Describe your changes" and "Style-check your changes" your
changes sections.  Bonus points if you work through the mostly redundant process/
documentation, e.g. these have supplementary info.

  Documentation/process/4.Coding.rst
  Documentation/process/5.Posting.rst
