Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1FD65DA0C
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjADQkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 11:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjADQj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 11:39:59 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9F912AEA
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 08:39:58 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id c2-20020a17090a020200b00226c762ed23so377971pjc.5
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 08:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C2HTUdZ0zGfC+Gid7LJGzs/LJj+KMx8pHHF9qzd4/pg=;
        b=f/C9ZsY0SRqWCooglJpeskAOkj+pkKdZuydgC5GKTPU6usYXZdOMW1Luks0E3CkpcL
         6fAmPrSoZ3rljQAEGBQhPPo7ElufDGLapLG0kWF+FwJcAFjfjfrPhe3aDdyNiGXFfh57
         v5D4O64BImp3mleGL+ahBN78MoGytyYebiZ8gBAzrNZjFF6WIUiY9C4X//8OZRh2k/Pp
         OFWebdfFv1I0P9NOzNxWgXjTDHHcWQBQJ84oJJbTmD44Y5vGF9qecJxZnxZ5NgDM3F16
         5STmSstq0vrxmI9BluO1qYQkJ8wAEmtUMi4zIB1TR9Xswnr/p92ewfjiZzHWOo4OqVJu
         8bPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2HTUdZ0zGfC+Gid7LJGzs/LJj+KMx8pHHF9qzd4/pg=;
        b=5XLcijuhv+/wuoc69c3fIdZkkwOY7kE5dQMlND4FgvLId4J+tf7hHpxQiY9ICB3uOj
         YoanDQBu3suqmkVn+T0j66rNbT07l4a1yhr1N0+P6doBulKhXx7+QfJeEvDTjq/PKbGg
         NNLyor6kxaUjHUVszBgXexXBIIpGq0M238USLjwwJvZjcYx2FwnnfqGiA/LSu0YKd94/
         ap9kwD9BpzU3wmsBOjAhzc0gh7BtuXvqm72AimwKskc813K8YtFrYJrNQpr+cHWXl/wO
         /KI5KomwSn87/ekq7OUH9ysjmpn9DaXVRttGR8qsab7GMomnvPga2VY/RHWPS4mCjZ/i
         K6DA==
X-Gm-Message-State: AFqh2kpVTNGj50VNtEQYaIR+6DjBnhkUUTJs6fvZHJBcbL3JYH07Azzg
        M3coFnDBCikmBWp2QjcfpdP+mA==
X-Google-Smtp-Source: AMrXdXvLpLLgn+S+m+5f1X5y9glSMF3NHqhHJXpZ5YKQIN88kBGd+eulB5KcHADFDv5uooidfQr/5Q==
X-Received: by 2002:a05:6a20:3b25:b0:b4:1a54:25c6 with SMTP id c37-20020a056a203b2500b000b41a5425c6mr1452953pzh.1.1672850397812;
        Wed, 04 Jan 2023 08:39:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t64-20020a625f43000000b005774f19b41csm22650836pfb.88.2023.01.04.08.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:39:56 -0800 (PST)
Date:   Wed, 4 Jan 2023 16:39:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 2/6] KVM: x86: Clear all supported AVX-512 xfeatures
 if they are not all set
Message-ID: <Y7Wr2dMQwavDkycs@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-3-aaronlewis@google.com>
 <Y7WqXkjW16aA3gaT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7WqXkjW16aA3gaT@google.com>
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

On Wed, Jan 04, 2023, Sean Christopherson wrote:
> On Fri, Dec 30, 2022, Aaron Lewis wrote:
> > Be a good citizen and don't allow any of the supported AVX-512
> > xfeatures[1] to be set if they can't all be set.  That way userspace or
> > a guest doesn't fail if it attempts to set them in XCR0.
> 
> The form letter shortlog+changelo+code doesn't fit AVX-512.  There's only one
> AVX512 flag, SSE and AVX and are pure prerequisites and exist independently of
> AVX512.

Ugh, literacy issues.  AVX512 isn't a singular flag.  Argh.

Can you split this up into two separate patches?  One to require all AVX512 features,
and one to clear AVX512 if SSE or AVX isn't supported?
