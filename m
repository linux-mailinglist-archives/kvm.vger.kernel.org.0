Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B389D613D4F
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiJaS2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiJaS2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:28:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5541D80
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:28:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso16661333pjg.5
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PUraKKUNK44XAI6BEzoPnhB3kLCbCV1WK0Y3k9ADqbY=;
        b=g86moffUvArSf1mG4QVWqpQIDqesWycLW0h8BsnpH9KwklLkIRvdg0L9DnAiwnvEVs
         50RNuAfhDh0FgcGpRuM2qnJ5Q370LbmcLxPyu+oShr9ccP0nD3Z6S/5/zuyxfFYo+QQx
         ES/UECXRVTI404HyMfQ0i073d8FfbpKNJtstU8k73LtX2DRQa5U3rJo3G87Aku8+QyUo
         sb2QFvYoltwVRI2vNfAbS0IOWtN0TmLqYFQ3OZ+39ky2WZCg3LvNT+lRPHS2rCbuZttH
         mDOAdMIlarEKZe/VA/uA9xjAs/jHyjOBKmvMhD2LWmx/qKwSDcYJmD7zwUxH1xuW7ZDB
         tjWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PUraKKUNK44XAI6BEzoPnhB3kLCbCV1WK0Y3k9ADqbY=;
        b=CiTz7c7UBV9kAg1uh76GnuWg0ZrvLufudmPBBWSjnztMmRcw6eXiNJL32FJR3eIFc+
         p+jmaO7PkpISpht4F7uP4lMICc7799Mle7hygtv06UmyAAIlHiyCiQH64SlaSjTLS0EL
         R3eqNQIm/kabDJxATc7bRqgq5PG/YuGvjldNumIHbiIQDpiE/Xzqm06LEzi+H2fBBo2N
         8S3iuNUMrfxmjSW0+A5MCwZBInj9ydeZKtPmwJ+iRoWalgSt0IDwGtKC4KmvaQ7rAZaW
         /FQ6O+EluNfSmLxXoNVTy4KarDSIfnAisbN/1dh8/KN12ACgZA+pfYEuTT4llzQCv9oZ
         pCgA==
X-Gm-Message-State: ACrzQf0ARvJCKlGYlsxtqTNo8josijGVF/4IK77qyMEWLbrg1/RkeWOa
        Vz6gexkbpcyjPBFdC0ObwCfUng==
X-Google-Smtp-Source: AMsMyM5fJFjLwfF2MZppM9yNxI0iTCYeYBSEPjQIULzkgsTFO0eGPMHjFlLE2pIMc189JMvTono8kQ==
X-Received: by 2002:a17:90a:1b44:b0:213:1035:f913 with SMTP id q62-20020a17090a1b4400b002131035f913mr15850318pjq.133.1667240885317;
        Mon, 31 Oct 2022 11:28:05 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a11-20020a170902eccb00b00172e19c5f8bsm4764686plh.168.2022.10.31.11.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:28:04 -0700 (PDT)
Date:   Mon, 31 Oct 2022 18:28:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 04/10] KVM: selftests: Move flds instruction emulation
 failure handling to header
Message-ID: <Y2ATsTO8tqs4gtz/@google.com>
References: <20221031180045.3581757-1-dmatlack@google.com>
 <20221031180045.3581757-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031180045.3581757-5-dmatlack@google.com>
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

On Mon, Oct 31, 2022, David Matlack wrote:
> Move the flds instruction emulation failure handling code to a header
> so it can be re-used in an upcoming test.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../selftests/kvm/x86_64/flds_emulation.h     | 59 +++++++++++++++++++
>  .../smaller_maxphyaddr_emulation_test.c       | 45 ++------------
>  2 files changed, 64 insertions(+), 40 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/flds_emulation.h
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/flds_emulation.h b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
> new file mode 100644
> index 000000000000..be0b4e0dd722
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef SELFTEST_KVM_FLDS_EMULATION_H
> +#define SELFTEST_KVM_FLDS_EMULATION_H
> +
> +#include "kvm_util.h"
> +
> +#define FLDS_MEM_EAX ".byte 0xd9, 0x00"
> +
> +/*
> + * flds is an instruction that the KVM instruction emulator is known not to
> + * support. This can be used in guest code along with a mechanism to force
> + * KVM to emulate the instruction (e.g. by providing an MMIO address) to
> + * exercise emulation failures.
> + */
> +static inline void flds(uint64_t address)
> +{
> +	__asm__ __volatile__(FLDS_MEM_EAX :: "a"(address));
> +}
> +
> +static inline void assert_exit_for_flds_emulation_failure(struct kvm_vcpu *vcpu)

I think it makes sense to keeping the bundling of the assert+skip.  As written,
the last test doesn't need to skip, but that may not always hold true, e.g. if
the test adds more stages to verify KVM handles page splits correctly, and even
when a skip is required, it does no harm.  I can't think of a scenario where a
test would want an FLDS emulation error but wouldn't want to skip the instruction,
e.g. injecting a fault from userspace is largely an orthogonal test.

Maybe this as a helper name?  I don't think it's necessary to include "assert"
anywhere in the name, the idea being that "emulated" provides a hint that it's a
non-trivial helper.  

  static inline void skip_emulated_flds(struct kvm_vcpu *vcpu)

or skip_emulated_flds_instruction() if we're concerned that it might not be obvious
"flds" is an instruction mnemonic.
