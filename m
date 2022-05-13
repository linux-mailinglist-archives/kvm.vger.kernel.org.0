Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC38526AC3
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383982AbiEMT4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383959AbiEMT4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:56:08 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FE79C2F3
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 12:56:07 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 31so8420126pgp.8
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 12:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iuo7gXVWTj6TmRuI7XRm6SFteZRKqvV099wooRzLD/8=;
        b=EYv5HC9LkFEq/NZojuo2wu55KVQPtFmnGqq5cZz9W4Q0R08EZl97jy1wkAgbn6/UZu
         6d1yVwUZsI09he4XDAjC0TqMYEeBQOBYB4+j5lHDvVRe8V9cA80k5qYPX46dDdJT3MGV
         w0VsAW0MBS7KyHTEMG7GhQK09vdoYuP1Tydz5AMnmWVs+h3A9qbwK/qRr5uZ59qN2rmt
         3TN3F0OmnG7cZn5XZtSAlJrqOg6BcBw761xuv7IaWSV+Ae+9D8GZfVxTfztjn73WVEme
         hL2zubNUlhSZetS1sSxsXpVJ8b2q08rBF1QNllPPp0TCxJLRbPXESAdUwgIBJj/ROtvQ
         +nyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iuo7gXVWTj6TmRuI7XRm6SFteZRKqvV099wooRzLD/8=;
        b=QH4nwig8SR1ppmsd0a1gnrDyES6TF7sSiRuEBdrQXJMUHOjg+aTpTgAA2eV6mloikF
         GP4zfDVLtNZiPj+fgg5uB7vF3xkjExwtTvgz2kop1iZosiY8ltZ63SAsmVPo0Z4sgs+/
         k23HGFu5uMia1MoKX7j+u0lP4DRZDe3bK0dca2g7xgkm/19GC8Zhg7aBMxQZnuGPOUUb
         yXa5oE24eOVXq0dymdVXAc9PDozJA12Kuf136sohOFMvVIzyTpOqSuAUoGO44ikf26wy
         BfflfRQWExZr/t/TkhS765dcJ3uSBgaHiHdrexyxzdafOL46TzfvxSCfLRujphqyhbrh
         MClg==
X-Gm-Message-State: AOAM533EsRoJRWf1KffS6sTkQCMCoS0w+UN4TC2G7cpk+uXWAy07P4m+
        3jEGaFpD5SbwB0VBp5ACg33h+O7+epsj7A==
X-Google-Smtp-Source: ABdhPJyk/YDaLHecr1/pCrfGYKJch3c5Y5smUoo6VryRlSLcl63aP8XbErGCCK17H7d7Bcdh1zZoeA==
X-Received: by 2002:a63:1d26:0:b0:3c1:eb3f:9daf with SMTP id d38-20020a631d26000000b003c1eb3f9dafmr5220746pgd.284.1652471766565;
        Fri, 13 May 2022 12:56:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x5-20020a63cc05000000b003dafd8f0760sm2011593pgf.28.2022.05.13.12.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 12:56:05 -0700 (PDT)
Date:   Fri, 13 May 2022 19:56:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashkalra@amd.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>
Subject: Re: [PATCH] KVM: SVM: Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak.
Message-ID: <Yn630RFKQiiMRnnf@google.com>
References: <20220512202328.2453895-1-Ashish.Kalra@amd.com>
 <CAMkAt6ogEpWf7J-OhXrPNw8KojwuLxUwfP6B+A7zrRHpNeX3uA@mail.gmail.com>
 <Yn5wDPPbVUysR4SF@google.com>
 <51219031-935d-8da4-7d8f-80073a79f794@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51219031-935d-8da4-7d8f-80073a79f794@amd.com>
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

On Fri, May 13, 2022, Ashish Kalra wrote:
> Hello Sean & Peter,
> > Looking through other copy_to_user() calls:
> > 
> >    - "blob" in sev_ioctl_do_pek_csr()
> >    - "id_blob" in sev_ioctl_do_get_id2()
> >    - "pdh_blob" and "cert_blob" in sev_ioctl_do_pdh_export()
> 
> These functions are part of the ccp driver and a fix for them has already
> been sent upstream to linux-crypto@vger.kernel.org and
> linux-kernel@vger.kernel.org:
> 
> [PATCH] crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel
> memory leak

Ha, that's why I was getting a bit of deja vu.  I saw that fly by and then got it
confused with this patch.
