Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46C54EE0F0
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 20:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbiCaSrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 14:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237019AbiCaSra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 14:47:30 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E50234560
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 11:45:41 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x2so382553plm.7
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 11:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p0VBDObDoFUONnWI9F1/+zvgmxSX/U3+Op0djrNZ6+Y=;
        b=tEWlML2VMYg3LF9jB/Et4JGlYfjVS9pVUo/fDlqbCKzTkSkq6GGaHSb/gBxTcIKDQP
         Sq3xeikKPcVd5Ah2H6UAKluUf7dSi86OTSEBiH9Bes1ELGs2Gshlt6iXyCPW0IGODBkG
         DEjOHj9KLh9XPUYM+jWrE4CUddNvJW3jE9BTe2bfdfpWaukuUpeyBi4sBHXuEBZpZ7i3
         rVu/EB/6ivKS8kGNRjnagiO5djB6oRKOCjM/NoUKaI2TsnwAOGJwfic3hQUMrymRNITP
         6xQF8+WV+LU3Y7R6KxP+GucOIT5zZaDnrSIiszQML1BggJlJw0bAfGHTyNn8n8uVs1/H
         sSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p0VBDObDoFUONnWI9F1/+zvgmxSX/U3+Op0djrNZ6+Y=;
        b=DXN/3Shgb8XhG4Os6AwkAldv0gPxY9ZvCyhVQezVFleXrcfVwV1dn68b2tR3KGnS7T
         vtwcGmOGZsU2tY9zv153+hHfE7W/H++tTlk4/cqsBa0z34Q9dlvjmrGFUK+zR6LOFNK+
         KaO3KzMYcXSG8/Rc4VJCbmvXJgN7NmpsUQ8G1RyISNLmf5tmDH/Jntmqm+zBFiS+HDQn
         4l15D7K9liMDBDpyUCb6ugzWeq2idMq02kL0Xw9PjletwjMKItzBa1jwdHc+7kxF1XB5
         Z4T5JMQCggTWRFBs2cOWOf7KzWCWHk35VPLUHHqfuAnGx4l/ZRzOXzickcr1LQ0YQj9/
         zl0A==
X-Gm-Message-State: AOAM532y5cFWVotleziuVDqm1FDqec0dc7i7kKWjL54rFro7/bSaFNP8
        oBZAYU82IZB9yhESI/i/1XbQCg==
X-Google-Smtp-Source: ABdhPJw7j6WOuvK4kl+s/hZ1aeTMuDftyemuxNuoMU64veTxp870Hem95njAys6VqCILAsYfpfwgfw==
X-Received: by 2002:a17:902:f78d:b0:14f:ce61:eaf2 with SMTP id q13-20020a170902f78d00b0014fce61eaf2mr6753898pln.124.1648752340665;
        Thu, 31 Mar 2022 11:45:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id fy9-20020a17090b020900b001c690bc05c4sm96606pjb.0.2022.03.31.11.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 11:45:40 -0700 (PDT)
Date:   Thu, 31 Mar 2022 18:45:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     Bruno Goncalves <bgoncalv@redhat.com>, kvm <kvm@vger.kernel.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Li Wang <liwang@redhat.com>
Subject: Re: RIP: 0010:param_get_bool.cold+0x0/0x2 - LTP read_all_sys - 5.17.0
Message-ID: <YkX20LtaENdOOYxi@google.com>
References: <CA+QYu4q7K-pkAbMt3br_7O-Lu2OWyieLfyiju0PNEiy5YdKYzg@mail.gmail.com>
 <CAASaF6yhTpXcWhTyg5VSU6czPPws5+sQ3vR7AWC8xxM7Xm_BGg@mail.gmail.com>
 <YkXv0NoBjLBYBzX8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkXv0NoBjLBYBzX8@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022, Sean Christopherson wrote:
> On Wed, Mar 30, 2022, Jan Stancek wrote:
> > +CC kvm
> > 
> > Issue seems to be that nx_huge_pages is not initialized (-1) and
> > attempted to be used as boolean when reading
> > /sys/module/kvm/parameters/nx_huge_pages
> 
> Ugh, CONFIG_UBSAN_BOOL=y complains about a bool not being 0 or 1.  What a pain.

Side topic, any idea why your traces don't have the UBSAN output?  I verified
that it's not a panic_on_warn thing.  Having the UBSAN output in future bug reports
would be very helpful.

[   13.150244] ================================================================================
[   13.150780] UBSAN: invalid-load in kernel/params.c:320:33
[   13.151192] load of value 255 is not a valid value for type '_Bool'
[   13.152079] ================================================================================
