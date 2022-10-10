Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDCE5FA063
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 16:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiJJOqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 10:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiJJOqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 10:46:40 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5918920BC6
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 07:46:40 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b2so10562765plc.7
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 07:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tBIijKTV6MbLjjpEdc9XiJPykCvwUEaS5Ef1WceGfdo=;
        b=kQgWP2dkY/RgESZanfPkUpuIEdPs/ztoUT5VUMgKWn1F35JicR4bg6rnGQHO3tSbh7
         H/majzYja7Jit7yBWMnDJBs1ph/FsIULmJyu6pDJFxCpt72sMoKJTpvtNjWoxqdC01Hi
         QlHtDYlZkdhiOyVA1Se/lYrilzo0l+wZKExw386LQxXhIkPlZJILgpywzL3iuLp/rovG
         WHcZmOewNZ3i7iOPL2Aw+Cz6r/iseAv0+AZa/FhAlqS6abkH6cSL4db0KCPVjQlizm3R
         Wr880l0B34v6fIHnu8Ut/VWXSn+kxWafgD6+pQQvcvQuAqpy/zWJjoJvhoOC5oWUREXR
         +J+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBIijKTV6MbLjjpEdc9XiJPykCvwUEaS5Ef1WceGfdo=;
        b=20m2Dl6wtzQXtXnlIBq7cOOF4+/LOgmKpm3KWka0H6g9460ccui4b5oVhOwrYZSeAy
         sVSxrYfzqLzMPPZKFoxj+V3SowF87L89QMsW6fdceSOfNA96M5PqXs++nHhIDmGEu/KX
         /IvEzQMApdC+gc0IXdDwIpXCR0ifu96dnCeu+oauMNdxivgwc1Ir5mJxBDEKvjqXDu5G
         m084o7VyAcNCbOI3EjBDtYGZdvJqCB8uN9RXj5BPZ/OS+106Wo8krR/dHYwN7VM9d/lc
         JAcfkKJzClIosCxd053Z14+QE2Ep/ruz2gktR0/HhlxszzaXBFJvfpQvZUFXtoF+yZyd
         ynwQ==
X-Gm-Message-State: ACrzQf14F0rhTkL956go05lluUWoxlYXptkWg5eULIgnqpnKnMVG22fj
        H+Pxf4g0wYikfwIu8rJwe8SF0sxH+6u0yQ==
X-Google-Smtp-Source: AMsMyM7smnVRHSZmjn9K/Ac3q5LuMJdjYOlv960vFjXiQ+iH3uyZLPK5BMxjDHk3rWEDr+RjgOCHEw==
X-Received: by 2002:a17:902:ccc2:b0:178:29e1:899e with SMTP id z2-20020a170902ccc200b0017829e1899emr19346690ple.114.1665413188754;
        Mon, 10 Oct 2022 07:46:28 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k10-20020a170902c40a00b0017f5ba1fffasm2462554plk.297.2022.10.10.07.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 07:46:28 -0700 (PDT)
Date:   Mon, 10 Oct 2022 14:46:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v6 2/3] KVM: selftests: randomize which pages are written
 vs read
Message-ID: <Y0QwQCq3pyb0v/b3@google.com>
References: <20220912195849.3989707-1-coltonlewis@google.com>
 <20220912195849.3989707-3-coltonlewis@google.com>
 <Y0CSOKOq0T48e0yr@google.com>
 <20221008095032.kcbvpdz4o5tunptn@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221008095032.kcbvpdz4o5tunptn@kamzik>
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

On Sat, Oct 08, 2022, Andrew Jones wrote:
> On Fri, Oct 07, 2022 at 08:55:20PM +0000, Sean Christopherson wrote:
> > On Mon, Sep 12, 2022, Colton Lewis wrote:
> > > @@ -393,7 +403,7 @@ int main(int argc, char *argv[])
> > >  
> > >  	guest_modes_append_default();
> > >  
> > > -	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
> > > +	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
> > 
> > This string is getting quite annoying to maintain, e.g. all of these patches
> > conflict with recent upstream changes, and IIRC will conflict again with Vipin's
> > changes.  AFAICT, the string passed to getopt() doesn't need to be constant, i.e.
> > can be built programmatically.  Not in this series, but as future cleanup we should
> > at least consider a way to make this slightly less painful to maintain.
> >
> 
> I wonder if a getopt string like above is really saying "we're doing too
> much in a single test binary". Are all these switches just for one-off
> experiments which developers need? Or, are testers expected to run this
> binary multiple times with different combinations of switches?

Even if it's just 2 or 3 switches, I agree we need a way to run those configs by
default.

> If it's the latter, then I think we need a test runner script and config file
> to capture those separate invocations (similar to kvm-unit-tests). Or, change
> from a collection of command line switches to building the file multiple
> times with different compile time switches and output filenames.

What about a mix of those two approaches and having individual scripts for each
config?  I like the idea of one executable per config, but we shouldn't need to
compile multiple times.  And that would still allow developers to easily run
non-standard configs.

I'd prefer to avoid adding a test runner, partly because I can never remember the
invocation strings, partly becuase I don't want to encourage mega tests like the
VMX and SVM KVM-unit-tests.
