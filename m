Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64FA534AA8
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 09:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240286AbiEZHMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 03:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237023AbiEZHMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 03:12:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63041D11E
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 00:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653549121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6IE6DmRFD5lAvDdj5gW9QZ9aM2Cb8MlqNKqWVvkieD8=;
        b=WfSDuknsKIt/z2rejX5PnXffRZc/QdxT1OOPx6K6QQCF9OYgYKFc/okQ6eu70WOAEpX1+q
        zSt+Vo4dorpmRsqZ5+kwrHnnM1FCNXOZQggaHkwlnz3d6gFNJgl7O0qqMdDt80g2EYTSSs
        ILoGT1Wu16KA/UqWk2i1KgDPt0EV50o=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-UZReonZlPwa5zWyO8COcHg-1; Thu, 26 May 2022 03:11:59 -0400
X-MC-Unique: UZReonZlPwa5zWyO8COcHg-1
Received: by mail-ed1-f69.google.com with SMTP id bc17-20020a056402205100b0042aa0e072d3so487753edb.17
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 00:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6IE6DmRFD5lAvDdj5gW9QZ9aM2Cb8MlqNKqWVvkieD8=;
        b=CG3MWNQh/IIhHbkOa6cpy4FDix77+14r19Zt3dd6EjoKsz/goqPbTzsUoy66O7KBeO
         ELQQDh0lvEtKeRHcHM7qwdDWNQ9UDtVf46GwSkm3sSsm7GYMBj1+GKr6WartCZbAgDU7
         kjuH6pEUFoWLsFo9/W55hS5NNLwl87HvSDweYWY7OXLYomr2bQIYR9juu+Ux2Q+KEPVQ
         3SB6nWvh3LFqaYpB8sUDgakl+xdDu6g+wUGR7buUE81E0/HDcV1EyYSYwoPjUTyemisy
         s/l4CJMaeU1Thue8aTo3IM+Re+adDL2BJ3a6M1vWESNSL0fcxZ01ESN62NKi1ijAgEp/
         4L/Q==
X-Gm-Message-State: AOAM530ZUArb0QwVobWc9gt9U++7wJc56jlDbpp7SLMr4hD3ahkP3A10
        ueQRCweWa5SvfC/olRByACyhRdu8sc8JaxgmhLujujZ/0AYFF7J1R0j3zE+w6IS1M/Ye388H3LG
        X4MIrk7Efieuc
X-Received: by 2002:a17:907:7b9d:b0:6f4:df04:affb with SMTP id ne29-20020a1709077b9d00b006f4df04affbmr32698505ejc.473.1653549118675;
        Thu, 26 May 2022 00:11:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/oQiHRMbznEoOQoHrgZ7MU0CD2s2BenPAiqSDCYho3vTAQs3BG35eBpAkDcu+rEhm33FE8w==
X-Received: by 2002:a17:907:7b9d:b0:6f4:df04:affb with SMTP id ne29-20020a1709077b9d00b006f4df04affbmr32698486ejc.473.1653549118425;
        Thu, 26 May 2022 00:11:58 -0700 (PDT)
Received: from gator (cst2-175-76.cust.vodafone.cz. [31.30.175.76])
        by smtp.gmail.com with ESMTPSA id qw16-20020a1709066a1000b006f3ef214e54sm229028ejc.186.2022.05.26.00.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 00:11:57 -0700 (PDT)
Date:   Thu, 26 May 2022 09:11:56 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Dan Cross <cross@oxidecomputer.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
Message-ID: <20220526071156.yemqpnwey42nw7ue@gator>
References: <Yn2ErGvi4XKJuQjI@google.com>
 <20220513010740.8544-1-cross@oxidecomputer.com>
 <20220513010740.8544-3-cross@oxidecomputer.com>
 <Yn5skgiL8SenOHWy@google.com>
 <CAA9fzEEjU9y7HdNOkWTjEtxPDNxTh_PDBWoREGKW2Y2aarZXbw@mail.gmail.com>
 <3cbdf951-513a-7527-ece6-6f2593fbc94e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cbdf951-513a-7527-ece6-6f2593fbc94e@redhat.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 09:44:33AM +0200, Thomas Huth wrote:
> On 24/05/2022 23.22, Dan Cross wrote:
> > On Fri, May 13, 2022 at 10:35 AM Sean Christopherson <seanjc@google.com> wrote:
> ...
> > > > diff --git a/configure b/configure
> > > > index 86c3095..7193811 100755
> > > > --- a/configure
> > > > +++ b/configure
> > > > @@ -15,6 +15,7 @@ objdump=objdump
> > > >   ar=ar
> > > >   addr2line=addr2line
> > > >   arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> > > > +os=$(uname -s)
> > > >   host=$arch
> > > >   cross_prefix=
> > > >   endian=""
> > > > @@ -317,9 +318,9 @@ EOF
> > > >     rm -f lib-test.{o,S}
> > > >   fi
> > > > 
> > > > -# require enhanced getopt
> > > > +# require enhanced getopt everywhere except illumos
> > > >   getopt -T > /dev/null
> > > > -if [ $? -ne 4 ]; then
> > > > +if [ $? -ne 4 ] && [ "$os" != "SunOS" ]; then
> > > 
> > > What does illumos return for `getopt -T`?
> > 
> > Sadly, it returns "0".  I was wrong in my earlier explorations
> > because I did not realize that `configure` does not use `getopt`
> > aside from that one check, which is repeated in `run_tests.sh`.
> > 
> > I would argue that the most straight-forward way to deal with
> > this is to just remove the check for "getopt" from "configure",
> > which doesn't otherwise use "getopt".  The only place it is
> > used is in `run_tests.sh`, which is unlikely to be used directly
> > for illumos, and repeats the check anyway.
> 
> Fine for me if we remove the check from configure, or turn it into a warning
> instead ("Enhanced getopt is not available, you won't be able to use the
> run_tests.sh script" or so).
>

Ack for simply changing the configure error to a warning for now. Ideally
we'd limit the dependencies this project has though. So maybe rewriting
the run_tests.sh command line parser without getopt would be the better
thing to do.

Thanks,
drew

