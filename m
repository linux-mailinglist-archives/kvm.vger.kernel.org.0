Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69304367203
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 19:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245036AbhDURwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 13:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239610AbhDURwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 13:52:50 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B42C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 10:52:16 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c3so10793621pfo.3
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j0oNgrMS6c/o4IGah+hGa4+DPYaNs5vsM0yBA9s/Ipc=;
        b=PC9rmVZOSQtON+ffsnFdk3VaEQKGIV1CRsgOXmNCX0j2YQoCoyoeulAFRgBen0GnBR
         ValLl2k3iCMLTpZWuQt2AeeoPHDCGI1MrKud96kMoeTE13V1yWAN3n0kv2hvIACvUhRc
         +GknI9wuuIsQWZ/8zRe9qGcRJSF7cFUFtx/TD0X4CI37ckPr3bLAEd2KUDP8HnGae+Jh
         Ca9YYQQrttXuLty6496WwEXlNLjl4pmlgAB0XC7xreic+PHV1MNbEoWCETaba1iK0Tki
         rQaVfXr4LLWfLfsW7p1QRYKDHRKDTjOfHOSbLS2u22QVxm3wKBAPoqFbpD5MJ5A68SgH
         6H8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j0oNgrMS6c/o4IGah+hGa4+DPYaNs5vsM0yBA9s/Ipc=;
        b=LkWNc6hifOV4pJaS+ie6S0hYSWHXFPdnxf7PQsR1o/jym5jdTkOg9XslGSBYalWS6x
         F1hLNTmyraYsl9QatbsUYVKah/LOKLBV9UNBxEeDda7jBb6t0w3ESIERxCdNPm3144TM
         HSQDsv7xsnCJzQzGC55Y0rlTiTVvGk3+MhukkvPHLdpBCjBxdu4rmiI6NE4Rv32vqe/I
         kMP8fhxhfFwue8Xv9RIj3opAdXtBs5GgNmFjYS+HjYKWubWjAisrpuLfV6+ROVedJVYU
         4C8Ze50VI3N9LYAaVAWHafEIZwE2u/50lSMuQX4Wr8i/0zVDGKdXOuI/ZvGEE4fQSml7
         +huw==
X-Gm-Message-State: AOAM532Fxv0Bgn/ZSO4ZRtW9oLkhuCjoKP3UYs9DjVCuJ8I8+hdVRqbf
        +RhCks6zP5/9jz1iUQxD2SOEmL/e7W/b6Q==
X-Google-Smtp-Source: ABdhPJxVXoC5+0imRpjdl85DyBHQKbAgh+4ULrJoroIpLVkcIsrUXCvoomrZu1BwmXDOs1Vl/fym4g==
X-Received: by 2002:a62:4d86:0:b029:252:c889:2dd8 with SMTP id a128-20020a624d860000b0290252c8892dd8mr31810996pfb.41.1619027536036;
        Wed, 21 Apr 2021 10:52:16 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id p12sm2829221pjo.4.2021.04.21.10.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 10:52:15 -0700 (PDT)
Date:   Wed, 21 Apr 2021 17:52:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     david.edmondson@oracle.com, jmattson@google.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kvm: x86: Allow userspace to handle emulation
 errors
Message-ID: <YIBmS1rMr5vaE2b6@google.com>
References: <20210421162225.3924641-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421162225.3924641-1-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please wait at least a day between versions to give everyone a chance to review
the latest information and digest other folks' comments.  Even a single day is
a bit too frequent in most cases, especially for a series where people are
actively commenting on the changes, as is the case here.  I.e. give the current
conversation a chance to run its course before spawning a new thread.  Exceptions
are few and far between, e.g. if you completely botched something and there's no
point in having people review the current versions.

Also, please include a cover letter with a synopsis of the delta between versions.
Without that, reviewers have no idea what's different in v1 vs. v2 vs. v3 vs. vN,
which increases the burden on reviewers.  The delta information is especially
helpful if other reviewers join the conversation at a later point.

On Wed, Apr 21, 2021, Aaron Lewis wrote:
> Add a fallback mechanism to the in-kernel instruction emulator that
> allows userspace the opportunity to process an instruction the emulator
> was unable to.  When the in-kernel instruction emulator fails to process
> an instruction it will either inject a #UD into the guest or exit to
> userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> not know how to proceed in an appropriate manner.  This feature lets
> userspace get involved to see if it can figure out a better path
> forward.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
