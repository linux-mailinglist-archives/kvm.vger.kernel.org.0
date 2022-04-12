Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A734FE868
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 21:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346311AbiDLTEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 15:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbiDLTEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 15:04:52 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51652167CB
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:02:34 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id bx5so19339132pjb.3
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BbHgo1BZwJ1d78lKODjktD+uyii6+g1yexgvQqoo+mw=;
        b=LnxHWLnUc8Yhyif0BM+jfioD7Ro6oz0kP4KlMNi8nfO4tq+gXlDdyA0dqS9g9X8A2O
         DBIAw7SsBQyITHPxOLts+Vq5berRQru9wzh4wQD8g0xFZ8Tjf9Tfaz3fXkGU1WN+T2je
         YA8CzmkbNbjbKus532NPnUss4lxJGoA9Fxx9Hhjm3KXzlQCwUHMmSZOiWthNOgoxVD5R
         n+K8hP1useTogOdMOB+8siQREYoZAG1a7VqjbCvxorOYNPRrCsM9uayrSJ3mTMsDF4KD
         m0gVQV7rNRwJ22KBVPyj4xyVdn5ShjUUbtAKri765i0IgrhIVFXdBHPF7TZSb6AZ4r72
         6l7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BbHgo1BZwJ1d78lKODjktD+uyii6+g1yexgvQqoo+mw=;
        b=b1B+rP0xS4Fjbpn+ysDIQftpk/f+8FT4JZXOAaHdkL/e2E9rJo8E8CdnvRXrbReZLJ
         bdt55ceGrkT1vk3qRdjPNlnF1ASE9rtWTjUekDBkXVbXLAezF95S82tg7crgv1tHHqXY
         P71jZUWK2oeg6/QJ9aI0NwyDf4xoSAnamdVTVaWvFgqqll6kFGudXrcOr7PT6yBvxJ9W
         ZV4r/r/yWcOjiJ8kM+naMNzAN7OHXQ22tU+IZO6/fXHKrR+WX43Lw94atskV0MqCJgR8
         Dbq2SI2B/o6HbemqoY4ehQPmOVp7u0zHnb6hVo2rCIqv8/BfQk425a0kSTtxHxQVSanc
         ktYQ==
X-Gm-Message-State: AOAM530cBUKpjzEmZhz20FOuxgzipxv2sE2lp9QrSe7BObFoQx8CrMIy
        ADkmgbNiL3XDWcoqsfVfhXzRvw==
X-Google-Smtp-Source: ABdhPJw1oDbAvMMNfwaTX2BNI0FFFny/7f3b+EZZShAnrtJlUItXsnb/I0hSpg5w0dihHn8r4i/wJA==
X-Received: by 2002:a17:902:cf02:b0:14f:e0c2:1514 with SMTP id i2-20020a170902cf0200b0014fe0c21514mr38680349plg.90.1649790153659;
        Tue, 12 Apr 2022 12:02:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y4-20020a056a00190400b004fac0896e35sm39513562pfi.42.2022.04.12.12.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 12:02:33 -0700 (PDT)
Date:   Tue, 12 Apr 2022 19:02:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v4 03/10] KVM: selftests: Read binary stats desc in lib
Message-ID: <YlXMxcKVgWxHtiGR@google.com>
References: <20220411211015.3091615-1-bgardon@google.com>
 <20220411211015.3091615-4-bgardon@google.com>
 <YlTN3yq1iBPkw6Aa@google.com>
 <CANgfPd8mZ9-zQBvK=OASQ+n7eq_FpvpStMc_yD-UsmFdQ3OCvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8mZ9-zQBvK=OASQ+n7eq_FpvpStMc_yD-UsmFdQ3OCvA@mail.gmail.com>
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

On Tue, Apr 12, 2022, Ben Gardon wrote:
> On Mon, Apr 11, 2022 at 5:55 PM Mingwei Zhang <mizhang@google.com> wrote:
> > I was very confused on header->name_size. So this field means the
> > maximum string size of a stats name, right? Can we update the comments
> > in the kvm.h to specify that? By reading the comments, I don't really
> > feel this is how we should use this field.
> 
> I believe that's right. I agree the documentation on that was a little
> confusing.

Heh, a little.  I got tripped up looking at this too.  Give me a few minutes and
I'll attach a cleanup patch to add comments and fix the myriad style issues.

This whole file is painful to look at.  Aside from violating preferred kernel
style, it's horribly consistent with itself.  Well, except for the 80 char limit,
to which it has a fanatical devotion.
