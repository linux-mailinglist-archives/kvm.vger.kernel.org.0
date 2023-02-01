Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A46686F7D
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 21:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjBAUCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 15:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbjBAUCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 15:02:38 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897B7A269
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 12:02:37 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so4088467pjq.1
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 12:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kr9wNeu+9zMbp947lD+6b8hMxHEqrpimcBPK+zq5B9E=;
        b=ds4dsJWeCOK3T39vv1XbULKGx6HG5Ep+PbmOPBoO0z+GGkBSAyfBygba3hsDBWQBW8
         1fXRwcSWseSYWToOsjvojXvvxi7WvPIUEYNfF7sgHZ0Zd66Zm86zWJtX0UQjqRBNDC/P
         ZFl+i4PLgGcdMUqrNRSZ9slRmlbSWUoBsIkTyMibCdPIkN7hC8MoMuLa5QBr9MlmCG0o
         sZSYLrYAs6IBHhPe11DdCe1xiJxCp8QZ2iqcOevgjBtWPlwb8BpnVRUGvfc9fFPXgWz7
         n2/swEO7KPlADIC8Bzrt8Dv/jgi+DeUbji7rLTBgftH2U5d5iyEuXBYJmi2bqb9UvRmI
         7//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kr9wNeu+9zMbp947lD+6b8hMxHEqrpimcBPK+zq5B9E=;
        b=wGBMSxTrDAftyTHzvpPlniZXmV47zI/Un75aK5hWzmqW6gtUmPSN1/cFqQyoAzD7TV
         pDgJ8bN2lB+j13cP7IFp9EoxzwZIkZUXneZGa+Pw8XUlFGIwnbBd62vsZQVPxmkgvtH7
         CtzbHTRjhAfMMv4PfvP6BzJ5vO+v+KYyhZJXTPE/L0STm97unJqNdZhNQdxwo1xrC5Np
         fpGPWG85IFwU5J2qBwzjdcFI5HMen+OT+AiBAr+rfgNuThm40c+dbdVQTWzQIscKsVGT
         ValgGo2nRP0pCESSOCDgayVR8wGuBQrTcCNJOQJaOF+nnEKof6qBn7sicQzJw4N2sBak
         Wd2w==
X-Gm-Message-State: AO0yUKV7EB9kvI86EIbzE0Qtpk2FBdJiMeLAfFIMwHIuvLp9RHfYa5bG
        0rad4mqt/AmY794wYYGl4jucOg==
X-Google-Smtp-Source: AK7set8nnzc5/5usrRzjiFXV3Nb3vuTPy73aG7xAyJCvFYhiMXCSq529FDxGIZ8+qoZ75tX62xFO9A==
X-Received: by 2002:a17:902:f549:b0:198:af4f:de07 with SMTP id h9-20020a170902f54900b00198af4fde07mr71711plf.7.1675281756943;
        Wed, 01 Feb 2023 12:02:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 138-20020a621790000000b0059312530b54sm9734999pfx.180.2023.02.01.12.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 12:02:36 -0800 (PST)
Date:   Wed, 1 Feb 2023 20:02:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>
Subject: Re: [RFC 00/14] KVM: x86/MMU: Formalize the Shadow MMU
Message-ID: <Y9rFWP7b/j25IjtZ@google.com>
References: <20221221222418.3307832-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
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

On Wed, Dec 21, 2022, Ben Gardon wrote:
> This series builds on 9352e7470a1b4edd2fa9d235420ecc7bc3971bdc.

Before you send the next version, can you tweak your workflow to generate the
base commit via `git format-patch --base`?  That makes it much easier for humans
and scripts to find the base commit, and saves you from having to remember to
manually specify the base.  Because of the code movement, applying this series
without the precise base is an exercise in frustration.

E.g. my workflow does

	git format-patch --base=HEAD~$nr <more crud>

where $nr is the number of patches to generate.  There's also an "auto" option,
but IIRC that only works if you have the upstream pointing at the base, e.g. it
falls apart if upstream points at your own remote "backup" repo.
