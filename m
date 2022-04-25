Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B324D50E7E8
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 20:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244275AbiDYSUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 14:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiDYSUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 14:20:01 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490BA3B03B
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:16:57 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id fv2so658614pjb.4
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cJX4NOJxx8yt8bifaIIJHW1REW326f1qVXuNvHoJSGg=;
        b=F3Hg1J94deTs8D8c5x1mAeV7ldoQpgW1s6cQYtX1nmsV/vMU5VmvD2P9H4jtGsz0n6
         HCRfrqmumUVIyK1j9wk+b+Hh7JxDlXVj5WXa39ZQqtlC8foiC7DcT9y4skTjKIFHv4vw
         8YCxCAeVfEmEgrqwzi7pLiiRLvrQf922iJo52BUjCvD7FIZmvWyGa8FOzPJz/6EgGI6v
         XyYd8VT3Qx82VijPLex/NBTEXRxnpS1jZLs2wulPpuMipuqsAczB115q6JB87jO5kRRS
         dGB80hWg50jdhiHePj195LJTjAdj0elbPPMHjXkh5hzfETrtqojnaowF7veZzPtIy0DG
         gipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cJX4NOJxx8yt8bifaIIJHW1REW326f1qVXuNvHoJSGg=;
        b=AwFm4UTehQTftDhUvMYlfiHe8vMyIDSv0JJ/8MNbcU7CG/I4PHr5U4zKMjpbanmrUV
         FyCyuZLj9AMlTaBzDHLOlzCiCJhF8EYELlE3lxPJecAgJIqtWIOodgPIYuUjxuFEPmtC
         Qi7SdeNKQdX9I/dFDCpQlzqnyBb13um6RHB+oNHNSmvFBaiDbkXzyFfI3rDPFAq8p9dp
         HCHXzDnMXicv/Hi/yVOrFK08jhU/5gMlOtjqoPfbwIdI12vBO+2abyqmkTWCVmBalHm5
         du34Si64lA4pAkSPAT1/bdd5Q97ABJhjHCzBuC94zzTL4eyYLIKo+t9GB6o/g+GUuEr4
         +rLA==
X-Gm-Message-State: AOAM530oZYuHarbdEAFa5nHxC6jmi2d343HQEYhRQQ5hmLFog307uhBx
        +6kM0bzyy0bj7NwB09j1hWXyYg==
X-Google-Smtp-Source: ABdhPJxV/XUGUnp8Y08gGA8YCbm1IrFT95czI8pjByDzfirwYlhZgziSfr3Rg2N60hRkRbJm5fHa3A==
X-Received: by 2002:a17:902:b596:b0:158:f23a:c789 with SMTP id a22-20020a170902b59600b00158f23ac789mr19031923pls.57.1650910616632;
        Mon, 25 Apr 2022 11:16:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f16-20020aa78b10000000b0050a81508653sm12251481pfd.198.2022.04.25.11.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 11:16:56 -0700 (PDT)
Date:   Mon, 25 Apr 2022 18:16:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
Message-ID: <YmbllLTbP0TGDemE@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
 <Yma6fEoRstvmu6sd@google.com>
 <CAOQ_QshYttK+e9PQdp+vZo2w7NN8oGVAQm8LC+DBP5gs+5fLwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QshYttK+e9PQdp+vZo2w7NN8oGVAQm8LC+DBP5gs+5fLwA@mail.gmail.com>
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

On Mon, Apr 25, 2022, Oliver Upton wrote:
> On Mon, Apr 25, 2022 at 8:13 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Apr 15, 2022, Oliver Upton wrote:
> > > The ARM architecture requires that software use the 'break-before-make'
> > > sequence whenever memory is being remapped.
> >
> > What does "remapped" mean here?  Changing the pfn?  Promoting/demoting to/from a
> > huge page?
> 
> Both, but in the case of this series it is mostly concerned with
> promotion/demotion. I'll make this language a bit more precise next
> time around.

Please be very precise :-)  It matters because it should be impossible for KVM to
actually change a PFN in a valid PTE.  Callers of mmu_notifier_change_pte() are
required to bookend it with mmu_notifier_invalidate_range_start/end(), i.e. KVM
should have zapped all PTEs and should not establish new PTEs.  I'd actually like
to drop mmu_notifier_change_pte() altogether, because for all intents and purposes,
it's dead code.  But convincing "everyone" that dropping it instead of trying to
salvage it for KSM is too much work :-)
