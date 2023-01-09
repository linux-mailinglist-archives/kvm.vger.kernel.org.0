Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F84662B39
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 17:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbjAIQ37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 11:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbjAIQ3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 11:29:32 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C4212614
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 08:29:31 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 20so1130634pfu.13
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 08:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=35yBMGVdrFXKJkciDZqNeFdzTTlTrzLnN/meJzr1Na4=;
        b=FdnVV2CbXLr1oFYsEnHGPjy6OncknXV1I0BYvVhPA5iHGxxn/5AiETTfumk7M3CILn
         kYpCXoBmKqBr7RDhs6heKYOmT26XRzgn4PozrZlwT2RvlGrHhSUrZs83uBbKlRHcwY2x
         ISknDgemm8HojoWvfSK+DcztipGnfggfkrvxNIfQV6tq/+SqhSNIoXqRzAR8iBBhsKAH
         eg1m7dyveet1BUMz62yKQH5dSo/AhccPLrNUcBviEtFOeFBXUaZHXykrrcKuuE63v2HD
         BCaa1HqOma/K5Y3yVLMbmDbc42o8puDPzw91daIPue5lkUYbbZ/Ec0SJZe8j4sJkVXtZ
         xYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=35yBMGVdrFXKJkciDZqNeFdzTTlTrzLnN/meJzr1Na4=;
        b=8AHl7NbhNDbPN6Tp651g6RPBEwwl2gYGkV/TAH4vPZGdKQCskj5TR2wVoe3bDfCOS6
         4Ky/6geHdwmsVAJrzvWjIgZHzFLYuJrllNPFeJ4dLBestlhZNvwToG8rEiklribnsMZp
         ZMeYg3edXnM2kiHIhwiOE3tWkJOBWp1qwuQmq2K+Vz9Xu2O5fs7zlRb71O4VLIM2bSNl
         Hda8Wb+rqLkX1pS0JNR6GUtdhb+fXEX/gFPwmZZ+CX6hYeczt3ZNPLJJdPsCgsXwivgD
         sICRC5LB9qrjXHEykpLPT3GHk+n6Ti8lJMo720+Pu7UspXmKLg1xlzfNCfokjLxr4YFk
         DBng==
X-Gm-Message-State: AFqh2krPz7ZcOj+PWF7hU/8nFMhGIuoHBoTUb9EJ0ytXUh6TZTjik7FZ
        gNqeQC5fX6AtIrkygBLHEN/TVQ==
X-Google-Smtp-Source: AMrXdXvs71bxrjRTj5qKxI0ejL6iobfb7xUEeYO5jYTm2rXDHtnDmUyWO1bs5r2cWRKM3abcEUUt9g==
X-Received: by 2002:a05:6a00:1948:b0:581:bfac:7a52 with SMTP id s8-20020a056a00194800b00581bfac7a52mr657632pfk.1.1673281771259;
        Mon, 09 Jan 2023 08:29:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y22-20020aa78f36000000b00562677968aesm6265168pfr.72.2023.01.09.08.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 08:29:30 -0800 (PST)
Date:   Mon, 9 Jan 2023 16:29:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 2/9] KVM: x86: Add CR4.LAM_SUP in guest owned bits
Message-ID: <Y7xA53sLxCwzfvgD@google.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-3-robert.hu@linux.intel.com>
 <Y7i+/3KbqUto76AR@google.com>
 <5f2f0a44fbb1a2eab36183dfc2fcaf53e1109793.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f2f0a44fbb1a2eab36183dfc2fcaf53e1109793.camel@linux.intel.com>
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

On Sat, Jan 07, 2023, Robert Hoo wrote:
> On Sat, 2023-01-07 at 00:38 +0000, Sean Christopherson wrote:
> > On Fri, Dec 09, 2022, Robert Hoo wrote:
> > > If LAM enabled, CR4.LAM_SUP is owned by guest; otherwise, reserved.
> > 
> > Why is it passed through to the guest?
> 
> I think no need to intercept guest's control over CR4.LAM_SUP, which
> controls LAM appliance to supervisor mode address.

That's not a sufficient justification.  KVM doesn't strictly need to intercept
most CR4 bits, but not intercepting has performance implications, e.g. KVM needs
to do a VMREAD(GUEST_CR4) to get LAM_SUP if the bit is pass through.  As a base
rule, KVM intercepts CR4 bits unless there's a reason not to, e.g. if the CR4 bit
in question is written frequently by real guests and/or never consumed by KVM.
