Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00235F7216
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 01:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiJFXzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 19:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiJFXy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 19:54:59 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF2731EC9
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 16:54:58 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t12-20020a17090a3b4c00b0020b04251529so3214726pjf.5
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 16:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M7tVZPrPdTsQdTKknt/h+pO4XqehvCPxiGrgYVPTQfs=;
        b=EN51jgTcueys0JTvw8YuhHbXKT/GQ0CTfVzyIOzA4D+W2iSfeBPIKzUI62Mz8s2ncn
         v6Fz/qNS91gKANtiwB1VnNeD+2ALRvqqKOo8byIPavQUpoAWP0mt72vRe21/70OEYTqi
         fuvoGprcCNrtlGXY0QFNqnfvxGBxRsAbT5GuGMp3zmtSdInYaa03ikEHc62Aqk9Z+2zr
         G4+a4anDbSJbJNmkraSoYoI+d8JV+KyWOnbaeZFwclKBFRgNFtfRdMXXlgd3HR5KTxPs
         PdRTMY8GpRAtSg1pV9khJiJHbp8jbDpGGMvnVM+8j18PMzlcphI6FI5VmezDW1Ph0OaB
         6JNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M7tVZPrPdTsQdTKknt/h+pO4XqehvCPxiGrgYVPTQfs=;
        b=nZPKXK+rbyN9XHw8ratXOYPLiW7ZSkKXBKARdpHQU8rp0A5oe276g9WlDEppJ13c94
         8/ZbBIEEmCbPny5ezrcsDSOp9/dMUfWNrRRmtbtufGXH5AyE9oY05e4Czi00sZDonnBX
         RaSu21yUleoDgenHCQJuZTia7EXsKlcLjVSeIqDnRGBPfqBaKVRKTamwjnr3T7YDub8p
         Duk1U0mrCby2+UEpG8+xVw57tQBKQZZ3KAe6Ghgib0GJ3PpPoZysgkg7a4ExSXHBZU5j
         EXcq8Hf4H502Z412R+nvlWm1LpCBh67G71gqurFnGikA6YrhaQrOhoL0ci1JW2JehvKv
         n4ow==
X-Gm-Message-State: ACrzQf3KnK52n5A0kTCOc/0A/bmtXc+jI686NqzRjQJidHP7l5RecFm5
        CmJKozD5WIZqh0zqhRg+jh9lxw==
X-Google-Smtp-Source: AMsMyM6J6BXeDJVvzaZCySM1yfJvJcDeLl1/4aWoWiqWNRb1PsMrQ3gkyYYukXl2NyEdl78eW9Mzkg==
X-Received: by 2002:a17:902:f791:b0:17c:c1dd:a3b5 with SMTP id q17-20020a170902f79100b0017cc1dda3b5mr1831807pln.141.1665100497624;
        Thu, 06 Oct 2022 16:54:57 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o68-20020a62cd47000000b00540a8074c9dsm179935pfg.166.2022.10.06.16.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 16:54:56 -0700 (PDT)
Date:   Thu, 6 Oct 2022 23:54:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] KVM: selftests: Add atoi_paranoid() to catch
 errors missed by atoi()
Message-ID: <Yz9qzGDW/GjpDQkY@google.com>
References: <20221006171133.372359-1-vipinsh@google.com>
 <20221006171133.372359-4-vipinsh@google.com>
 <Yz8zYXvhp9WGH4Uz@google.com>
 <CAHVum0cD5R9ej09VNvkkqcQsz7PGrxnMqi1E4kqLv+1d63Rg6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0cD5R9ej09VNvkkqcQsz7PGrxnMqi1E4kqLv+1d63Rg6A@mail.gmail.com>
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

On Thu, Oct 06, 2022, Vipin Sharma wrote:
> On Thu, Oct 6, 2022 at 12:58 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Oct 06, 2022, Vipin Sharma wrote:
> > > +int atoi_paranoid(const char *num_str)
> > > +{
> > > +     int num;
> > > +     char *end_ptr;
> >
> > Reverse fir-tree when it's convention:
> >
> >         char *end_ptr;
> >
> 
> Okay, I will do:
>         char *end_ptr;
>         int num;
> 
> I was not aware of reverse christmas tree convention in KVM subsystem.

Oh, the above was a typo.  It was supposed to be "convenient".  KVM doesn't strictly
follow the almighty fir tree, but I try to use it and encourage others to do so as
it helps with continuity when switching between x86/kvm and the rest of x86/ (the
tip tree maintainers and thus most of the x86 code are devout believers).
