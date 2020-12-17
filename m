Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C82D2DD6C5
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 19:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgLQSEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 13:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729579AbgLQSEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 13:04:54 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD33CC061794
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 10:04:13 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id b5so4565334pjl.0
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 10:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=78OAgNNOpoOEnAKdwZAUhfr7FCnjtWasmU5RULfnKzI=;
        b=ZDULQfVHtosDNYeQ7VS4GEjJex+44VsL11gqXsQoZdPiWJqIN6Y5ZZGiNGSpFVSg7j
         cy4Tg2+6oO9rzlSojzpAZ7+WjdW5OlOAFysA4EU/E4RLG3w2dEwj5fb3KqsGmH9HJXVN
         y9DDtAj1CyZP04ffRpckZZbrwxTewkWHtboSNe6+MnScmOw3Kgt483Gzx+CWyrIsgsXw
         1kWX2hOMmu8hzMp6M0oimmLOQlDR9AbhtV9Zl0gBrruy0nE56iaov7m9Z4PrkV3Lrwwc
         wlpgW77JbbmB5utyF+BFI1yWl5wS7sFxbspqACxHfS1ETTmZJBi1+TeVXZS3vWGoHxY5
         GfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=78OAgNNOpoOEnAKdwZAUhfr7FCnjtWasmU5RULfnKzI=;
        b=j8dsvO0lsog9bxpSRQh+Hh1Q/8suqs0ZvTZawyiiwqRj5HatOLX4bA3j9cE6Ed2JGD
         Z4Gh2w2dD1BFGq1MvobEAUCnN6HQpHt+nYi4iFV2Uv+nAyJzucXejD8KqBlFXYdPeRJ6
         AP2dRDVjKkpcaQWd09923ptLVZUuWM1z7c2uB0rr2ac7WbCovDSoj+idqttjHJcPzssc
         8P2D87q+BOB/cs0KwNGwRV1shyCB9oSJJivdZfL6enB+J7WkU5SV1LRUq83+pHC6dnk0
         6xRKLNmaabDP3F2Hgc4YqJAoe4AZC38gbsZyhV/cGEc1L4ymyRyEsIJvULnTjosaRZ9A
         DO6Q==
X-Gm-Message-State: AOAM532ewBfAg/MkgnPn/2KsfFJ3CUNka/STQZ7wFYJ6W2Tpxg6oiReS
        eikf50t8QmAI50Jm0rxuXlzLDg==
X-Google-Smtp-Source: ABdhPJwPZx3p+RIvmSGoH+uz/HeZ87xIE4srhhZjEQ9mclyEaVmarhqlpdi5RRe8uvnTeOFLZ7XHiw==
X-Received: by 2002:a17:902:9a86:b029:dc:104:1902 with SMTP id w6-20020a1709029a86b02900dc01041902mr416913plp.50.1608228253273;
        Thu, 17 Dec 2020 10:04:13 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a11sm6903462pfr.198.2020.12.17.10.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 10:04:12 -0800 (PST)
Date:   Thu, 17 Dec 2020 10:04:06 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM/nVMX: Use __vmx_vcpu_run in
 nested_vmx_check_vmentry_hw
Message-ID: <X9udlkYvuaMme5pj@google.com>
References: <20201029134145.107560-1-ubizjak@gmail.com>
 <CAFULd4av_xehfPBBL76dH+On4ezLa6rqU6YkqBuLhPcvZTr5pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFULd4av_xehfPBBL76dH+On4ezLa6rqU6YkqBuLhPcvZTr5pQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For future patches, please Cc LKML (in additional to KVM) so that the automatic
archiving and patchwork stuff kicks in.  Thanks!

On Wed, Dec 16, 2020, Uros Bizjak wrote:
> Ping.  This patch didn't receive any feedback.
>
> On Thu, Oct 29, 2020 at 2:41 PM Uros Bizjak <ubizjak@gmail.com> wrote:
> >
> > Replace inline assembly in nested_vmx_check_vmentry_hw
> > with a call to __vmx_vcpu_run.  The function is not
> > performance critical, so (double) GPR save/restore
> > in __vmx_vcpu_run can be tolerated, as far as performance
> > effects are concerned.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > ---

vmx_vmenter() in vmx/vmenter.S can and should now use SYM_FUNC_START_LOCAL
instead of SYM_FUNC_LOCAL.  Other than that nit:

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
