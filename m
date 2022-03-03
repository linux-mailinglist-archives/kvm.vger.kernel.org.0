Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F63E4CB481
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 02:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiCCBoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 20:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiCCBoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 20:44:37 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB69555218
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 17:43:52 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id e6so3207450pgn.2
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 17:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G2ys98VpfjjfilZmZ9Hzgua8VvpFM/67GnllViZAQB8=;
        b=QBTLlgNael7S75P9DZex40S7lZd1rtz8JxH36KprcCtYouBIkes5+lO1jN3qSLsIRa
         bjMnNzAmge0LGqSx8eSHpU8lF+6KK4fPyF4ktY363xO6JuqN4IpoW0Y3QDwXi8rie28p
         i6EIU/pCW3VKU5Kw4OxrSuUvb3PPjukUJ9Lh1PJwYAFytjvSK/r6TriKHME2gv0D1y4H
         nKay2QhwivQaikWxAPTlo+s3+dMggyiJX8FIJWEVo4bauEQ0bek0C4+uKvUkfpXMWOLU
         cq8e+xf+9GXSWuk6e8WSLtx7Ms9VeyZTO3rFdFjYCXKXF+XDZLDT1cw6K6wBFJVsQWSV
         65SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G2ys98VpfjjfilZmZ9Hzgua8VvpFM/67GnllViZAQB8=;
        b=J6LkWISUHB39UfsdXqj+xEzwcNvSoMqVdwM8HR7qWlXGuRTxKU63FjNUcMJACm+mbd
         i50967WF2IhNusbVKf9C7XqwMedpKqfQARV2cCkJvdFQ0S1zQWxZ1J3zAsQXrhanuVh9
         70HpxRhgYyWjpHIg3Gnv9TuT4mZhnYVrkcDrI6UGyj9gbkHvxxIoYMRjTxTf++U28/sK
         zvFDTJKocAs2enh77G8FdkoEyQ2XdTHZopj9aNoHxEOPsarEVwkxIsjsZRKyzl/kWCLj
         HxuFBR1i4NKNXmSRqO8ymUrlkP5v+iT8jlKEC+EIvsQ5nDogF5z9hjkHEd0ipaWlNnTf
         vTiQ==
X-Gm-Message-State: AOAM531BG+rxotAbT2Rf1SA4h4ohatRG0u+ooZwlYO7qa9D522Ta7dSf
        Ckg0niRil5TeiOMwE5sSE4hcKA==
X-Google-Smtp-Source: ABdhPJwT53DsFgj9jJmMeN/S8CL9ngZseFlexdAxCpiZ++akuRBaQYmIdd0eBNzXt5XFBaAjwyrdaQ==
X-Received: by 2002:a63:d44:0:b0:36c:644e:791c with SMTP id 4-20020a630d44000000b0036c644e791cmr28288567pgn.417.1646271831425;
        Wed, 02 Mar 2022 17:43:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c7-20020a056a00248700b004e1dc9aeb81sm457601pfv.71.2022.03.02.17.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 17:43:50 -0800 (PST)
Date:   Thu, 3 Mar 2022 01:43:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <YiAdU+pA/RNeyjRi@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-2-oupton@google.com>
 <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
 <Yh5pYhDQbzWQOdIx@google.com>
 <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com>
 <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
 <Yh/nlOXzIhaMLzdk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh/nlOXzIhaMLzdk@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Oliver Upton wrote:
> On Wed, Mar 02, 2022 at 10:22:43PM +0100, Paolo Bonzini wrote:
> > On 3/2/22 21:51, Oliver Upton wrote:
> > > On Wed, Mar 02, 2022 at 01:21:23PM +0100, Paolo Bonzini wrote:
> > > > On 3/1/22 19:43, Oliver Upton wrote:
> > > > > Right, a 1-setting of '{load,clear} IA32_BNDCFGS' should really be the
> > > > > responsibility of userspace. My issue is that the commit message in
> > > > > commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when
> > > > > guest MPX disabled") suggests that userspace can expect these bits to be
> > > > > configured based on guest CPUID. Furthermore, before commit aedbaf4f6afd
> > > > > ("KVM: x86: Extract kvm_update_cpuid_runtime() from
> > > > > kvm_update_cpuid()"), if userspace clears these bits, KVM will continue
> > > > > to set them based on CPUID.
> > > > > 
> > > > > What is the userspace expectation here? If we are saying that changes to
> > > > > IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS after userspace writes these MSRs is a
> > > > > bug, then I agree aedbaf4f6afd is in fact a bugfix. But, the commit
> > > > > message in 5f76f6f5ff96 seems to indicate that userspace wants KVM to
> > > > > configure these bits based on guest CPUID.
> > > > 
> > > > Yes, but I think it's reasonable that userspace wants to override them.  It
> > > > has to do that after KVM_SET_CPUID2, but that's okay too.
> > > > 
> > > 
> > > In that case, I can rework the tests at the end of this series to ensure
> > > userspace's ability to override w/o a quirk. Sorry for the toil,
> > > aedbaf4f6afd caused some breakage for us internally, but really is just
> > > a userspace bug.
> > 
> > How did vanadium break?
> 
> Maybe I can redirect you to a test case to highlight a possible
> regression in KVM, as seen by userspace ;-)

Regressions aside, VMCS controls are not tied to CPUID, KVM should not be mucking
with unrelated things.  The original hack was to fix a userspace bug and should
never have been mreged.
