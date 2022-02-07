Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B184AC8EB
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 19:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbiBGSy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 13:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbiBGSw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 13:52:27 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E997AC0401DA
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 10:52:25 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id z18so4386550iln.2
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 10:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZxOlVa1DQGjcvwvIwhQ9n0BRjE2uuHT2iju7EF5q0kE=;
        b=D7UFqjGhAE8IF5a9l83ZfxSONqEb3UKrlFzycrhEQjXQpQutv8mJEhizeFO+TFwIGf
         veHRgXltaBOAwBOkZdLR4i3iIQQWIjs3VjW/IpygB24sR9nKioKF3umUMNFHaZtJTaQu
         0EcPXY+L5GTDYd1i7x2+9pvfwBZJ5oiJZi6yo+nMYxwhaLB4GJc+XY/6cPDIL8Koi36q
         ZUNd25PjuCK5lO8JM1Xq/3RDBqpowr8/YlCLiW/7pThzSqROar9mJgSzhK7UExbRe7CP
         QqKanKtafHuDF5SeBdejuqjdVKLwr3Mv7I9BGQqi0+/QeQFV2SOpDiZk1jz04CSexOOH
         AeEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZxOlVa1DQGjcvwvIwhQ9n0BRjE2uuHT2iju7EF5q0kE=;
        b=u301NaulSy64G7gsU4ZIALI7qzOrrqXl0luF4WMiCD1etcvSLfP08VQz1OADFcF1Xk
         hySVSeYk1Sl/2zG+pgQspC77RRIAr/kkZOWR2NTAF7FAYhwTnNXvr6iwCTqtvZPMOHfj
         soAyo6dlwvuew5V3QEFVKtNOoiHqE2/RNRoKL3bUz7pqtjmwcVdrmLz59ylYzHo5HUhS
         oPFP5MTPK8JNIK0RcAsiWg0QEcvx2Q+t84mB1bHK5BzmgWZdk1NnVBiayEFDwLaeYbsF
         MdGfhNV0eCV9DwNU2f8tITAO8vxSEKg2OIX5s0T00CzndORIMq9YY4eWhlHrgn7apXmC
         ziDw==
X-Gm-Message-State: AOAM530m1k8lXdzHagLUMgKFjVwWnH9WsIfMGhTq+qMocDVQ+L54YSIv
        Rh84+z3X9a0TFlfhP4IvfKVyEA==
X-Google-Smtp-Source: ABdhPJzv8lPXy4M2zJgcI/XVE6AtB5tGpEk/pS5ca9fxqF4Ls5meBsyAE4W5GZN2f6WwAyICKoQg0g==
X-Received: by 2002:a05:6e02:1a47:: with SMTP id u7mr442320ilv.33.1644259945038;
        Mon, 07 Feb 2022 10:52:25 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id m1sm6148946ilu.87.2022.02.07.10.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:52:24 -0800 (PST)
Date:   Mon, 7 Feb 2022 18:52:21 +0000
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/7] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <YgFqZfiVej1NB9TY@google.com>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-2-oupton@google.com>
 <ce6e9ae4-2e5b-7078-5322-05b7a61079b4@redhat.com>
 <YgFjaY18suUJjkLL@google.com>
 <YgFmK2ZIh2wSQTnr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgFmK2ZIh2wSQTnr@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 07, 2022 at 06:34:19PM +0000, Sean Christopherson wrote:
> On Mon, Feb 07, 2022, Oliver Upton wrote:
> > Until recently, this all sort of 'worked'. Since we called
> > kvm_update_cpuid() all the time it was possible for KVM to overwrite the
> > bits after the MSR write, just not immediately so. After the whole CPUID
> > rework, we only update the VMX control MSRs immediately after a
> > KVM_SET_CPUID2, meaning we've missed the case of MSR write after CPUID.
> 
> That needs to be explained in the changelog (ditto for patch 02), and arguably
> the Fixes tag is wrong too, or at least incomplete.  The commit that truly broke
> things was
> 
>   aedbaf4f6afd ("KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()")
> 
> I'm guessing this is why Paolo is also confused.  Without understanding that KVM
> used too (eventually) enforce its overrides, it looks like you're proposing an
> arbitrary, unnecessary ABI change.

Gah, sorry, I really didn't provide the full context on this. I chose to
blame the original commits for these since it was still possible to
write the MSR and avoid a KVM update (just looking for paths where
kvm_update_cpuid() is not called), but agree that full breakage came
from the above commit.

I'll add some language discussing how commit aedbaf4f6afd ("KVM: x86: Extract
kvm_update_cpuid_runtime() from kvm_update_cpuid()") fully broke this.

--
Thanks,
Oliver
