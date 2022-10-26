Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F8C60E435
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 17:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbiJZPLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 11:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbiJZPLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 11:11:14 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7968A7FD
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 08:11:09 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id u7so11681441qvn.13
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 08:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eT2uz8tUG/sofl6nuodiNAwatRFoHDNx9Z1BojLryfg=;
        b=lHC8D0Zhnqe3uE9yu0bdgopEQXVZ+h7wdNuabF2dxkye0OmeQoY4GBzpd7XzCJpljY
         PSEsmSxTsMUU6v+CBOF4LJVm1jSdZfqutAlgrBP7iWpevfzn9tMe223LkVOD22I0KRjG
         1Rq2GomVkEu3b2DM0EeYz1mYLHdItTSUtsQan6PXvNVA9GxhRr+Upt+JvHSewPzvOKy0
         iG9OIgrQmNKhl1o1CqtWLPW8rXrqtbZ6wmABElscWaR3VT/ukr3lx7v5LXyMkXdinVz/
         fsmLrSqzmQAD86yNTcUEIJ1PVpiFnLOyfJHjfbUTieXBeK6FONXGCPEBb3PhOJTgf+uS
         /eKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eT2uz8tUG/sofl6nuodiNAwatRFoHDNx9Z1BojLryfg=;
        b=CyknhFZQvFp+g8NF6rXVILejLGy2THGvmd2E0PZbhar8JXli7NXdOSfCGApz5BLXGi
         GFKwwdpiPyCPkGP34lcwuJa1vJP8hBnj++pNbUE3YjIeOmtTJ/PLcSuh5PrMNr+uxEJi
         P9JBJg1BOW3q18fcaVQwhy5Qp9/b6OOAcQInp5sgCnaLevzy8QdE+ugE1iUrBpVvYg3h
         mSC4g8oT4qeB1RgtHqLigU12AhnWG5Hff0uUZs0Ijtxe48wNFb5TOpiPbgAiXIovDfgr
         e+mjc/uquG9LSt14NOjINyTvyCZphWdw+qMiKfoQt+jb0CYbn9A4lASQotvJiL2DqABe
         Coeg==
X-Gm-Message-State: ACrzQf21bWJSQwpfFVe6bzF0AyoZ9Cd4guQBVugBIlfQYyj5mfhup3N6
        UIHf5UiXDmX9TD7z+Zf66ivNGCw0bY7O1Q==
X-Google-Smtp-Source: AMsMyM6Yn+1KOEK89O0iT2HyiWTicc/woCgenW2nBrNU7zFODjOEF8s+kOgrUppy9Wku0TzcXnhcnw==
X-Received: by 2002:a17:902:cf08:b0:17d:46b6:25f9 with SMTP id i8-20020a170902cf0800b0017d46b625f9mr44701685plg.67.1666797057642;
        Wed, 26 Oct 2022 08:10:57 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 66-20020a630545000000b0043a0de69c94sm2910520pgf.14.2022.10.26.08.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 08:10:57 -0700 (PDT)
Date:   Wed, 26 Oct 2022 15:10:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     Vipin Sharma <vipinsh@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 3/5] KVM: selftests: Add atoi_paranoid() to catch
 errors missed by atoi()
Message-ID: <Y1lN/YRc2B3KoR+n@google.com>
References: <20221021211816.1525201-1-vipinsh@google.com>
 <20221021211816.1525201-4-vipinsh@google.com>
 <DS0PR11MB63733C7CA0B1497215B40F8DDC309@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB63733C7CA0B1497215B40F8DDC309@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 26, 2022, Wang, Wei W wrote:
> On Saturday, October 22, 2022 5:18 AM, Vipin Sharma wrote:
> > +int atoi_paranoid(const char *num_str)
> > +{
> > +	char *end_ptr;
> > +	long num;
> > +
> > +	errno = 0;
> > +	num = strtol(num_str, &end_ptr, 10);
> 
> Why not use strtoull here?

This intended to be a drop in replacement for atoi(), which allows negative
numbers.

> Negative numbers will result in a huge "unsigned long long" number,
> and this will be captured by your TEST_ASSERT(num >= INT_MIN) below.

As above, we want to allow negative numbers, e.g. memslot_perf_test.c uses '-1'
to indicate "as many slots as possible".

It's unlikely a test will As unlikely as 

> Then we don't need patch 4, I think.

Even if this low level helper disallowed negative numbers, patch 4 still has value
in that the wrappers make the code self-documenting, i.e. makes it very obvious
what input values are allowed.
