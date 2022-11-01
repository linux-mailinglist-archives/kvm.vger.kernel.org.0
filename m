Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED926151CF
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 19:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiKASxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 14:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiKASxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 14:53:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4A1113A
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 11:53:24 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so9285793pjk.1
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 11:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kIogl8aSx5o02RPy7Uupn5soh8eQt5K+DU/0+En+fDM=;
        b=Dr2bthuuo98UU48CPcQFPhVOnj8Ygc0+Und07u9E4UryEXwxuXQEJiITQ5TOKO8WCg
         gpmOJ/L0kfMeRGw9VieeNZ+6UWzzAC2LNT2Ew/C9ELTTJIVWL3m+aukw2TX40jwytAJN
         pFsKRTq4Qoyp0mB/V7ycz55tQ8ppz93c2wVvgxzzrNILNT7OSRqQlnFyD4sOWwXEUNLL
         3Tf/Dv+hhvz/J/K0UNnQbniNF3klKbmIzRukoo2yteKs7NIrdlVcTcPRp+660DKNPTbi
         qQI+i+YqKs3bxkrMZpDTyh5ayxBIXEolr33WfUFQjPDk0SsThbtXUEsK0S+148VAUbvO
         fzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kIogl8aSx5o02RPy7Uupn5soh8eQt5K+DU/0+En+fDM=;
        b=Ov+1DHl3jAWN+vHKth6iGYfn+gdc70ZTEh4T8EqmOq58Uj/vIXZKyiA73FIC0nZCZU
         QWpjp5Gdm3Yn1JWTjVcV4WvbmMkFdvIKaOOlowFmOZgPx0egbGojSc/Zi1NZpRLnfocx
         /+ZgM8vr8EOUEJX193XPPJvDlFLCFy19c/COcXRmQZ+Wf4qYLvyVF7HW8nvGjjlhnrtY
         fnXjmvcP8ab0FS16LLDGF9dSl3MFgXxACp9TrES+CHKDxS7IYNdJgDNJDu0DWplzk6v8
         JgjIOWfQK3e7ifFcn1TLpmMX1uMSyas2t3RjWfYykceQAYjQYzNIZulznIlTisdZJGEB
         hilQ==
X-Gm-Message-State: ACrzQf3bvir9/lyVUvvXCjWE2xHbWFPtmPfDVoYsOQDnYZT7g+yCmgt3
        8Ry0GiqHEDoQYMnU/Ta1xWtsdtizv4lQZQ==
X-Google-Smtp-Source: AMsMyM79GI9TTB4j5E1EBrwtQYTBAe/CH0MoPX1cXYznOMHHRmBiWC7JKiWyHPFEo/F0odercOMr9A==
X-Received: by 2002:a17:90b:3013:b0:213:ab5f:d388 with SMTP id hg19-20020a17090b301300b00213ab5fd388mr19798694pjb.66.1667328804191;
        Tue, 01 Nov 2022 11:53:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090a708200b001f8c532b93dsm6424350pjk.15.2022.11.01.11.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 11:53:23 -0700 (PDT)
Date:   Tue, 1 Nov 2022 18:53:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Bill Wendling <isanbard@gmail.com>
Cc:     Bill Wendling <morbo@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Disable inlining of measure()
Message-ID: <Y2FrIAPxaEfYISg3@google.com>
References: <20220601163012.3404212-1-morbo@google.com>
 <CALMp9eRgbc624bWe6wcTqpSsdEdnj+Q_xE8L21EdCZmQXBQPsw@mail.gmail.com>
 <CAGG=3QX218AyDM6LS8oe2-PH=eq=hBf5JrGedzb48DavE-5PPA@mail.gmail.com>
 <Y1htZKmRt/+WXhIo@google.com>
 <CAEzuVAetwLSaP2gt00Y0i0xdrj59TVT9ngB1iHXOa-mZ1fOqAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEzuVAetwLSaP2gt00Y0i0xdrj59TVT9ngB1iHXOa-mZ1fOqAA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        TVD_PH_BODY_ACCOUNTS_PRE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 26, 2022, Bill Wendling wrote:
> On Tue, Oct 25, 2022 at 4:12 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Oct 25, 2022, Bill Wendling wrote:
> > > On Wed, Jun 1, 2022 at 10:22 AM Jim Mattson <jmattson@google.com> wrote:
> > > >
> > > > On Wed, Jun 1, 2022 at 9:30 AM Bill Wendling <morbo@google.com> wrote:
> > > > >
> > > > > From: Bill Wendling <isanbard@gmail.com>

This "From:" should not exist.  It causes your @gmail.com account be to credited
as the author, whereas your SOB suggests you intended this to be credited to your
@google.com address.

Let me know if this should indeed list morbo@google.com as the author, I can fix
it up when applying.

> > > > > Signed-off-by: Bill Wendling <morbo@google.com>
> > > > Reviewed-by: Jim Mattson <jmattson@google.com>
