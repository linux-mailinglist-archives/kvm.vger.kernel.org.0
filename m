Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59CA5426D8
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444235AbiFHBBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588403AbiFGXyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:54:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC6AE1148
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 16:06:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so22219597pju.1
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 16:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=abG3pwzEXL1Gfqvm+pIc4+obvEmcxosjsp7a1l9B3BY=;
        b=TqEqKqmeZblgiFIHEy0AWowy9CeOYDhpKovxFjhbfrqKWm++mJXgzHeunG4iwS5KqO
         XTOk1FRVoOSixM/RSGpj9XQSu7Fnqq9xwtACPv9r/ABsi52jy+DZkQcGPOoPTlAk76OQ
         EnquTpFBNszPRx5vE/U7Z7u13G6t+2MJy9Zp+P/BQswkXWDitr2FW3b0+/Atqs3vSslx
         5WTqXO3cUjnso6wDjNB497l0U6UaCYp0RBgZ8MmbGVO1Z4RodXL8YnZQsvFQAdG7vtMc
         zTTjQuKVbLsz9+LueZQGmpJ6rpu61QnJTsmw8LVLUXH22vZMvXiiOFmNv+XMm4DkKEzt
         AqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=abG3pwzEXL1Gfqvm+pIc4+obvEmcxosjsp7a1l9B3BY=;
        b=jK1mfPfNhscVAsAhOPxrn7Qs3xIloOVM6cSwJQ4aP+4aDVWCz6ZU02hDtdfDr4qWdP
         QWCXoDVwj80hCnSzzeUKSOpUl/vO+6/AMRbW4rgz7rONetu/AxVCShmMatLNIngLVSSg
         fNZwbQTZOU8IlrT0bwHhN6ghF3PeWLI2rsDrV6IScu3zvhcXxGBc+B0K9Rn3CjnSrVrd
         mTNp1NMAWcMcFbT82tjmN+ft7jyTP8RiuA1O+JNH3vlHbXUj/2Fos2l9NyJPV2NyK8mi
         cDPIV0594tukoVjhQQ04OLx43aoHdisAmfrfXvYWkeyiUYdwZs5KW9SkElURAfinSOdA
         2BEQ==
X-Gm-Message-State: AOAM530gB9TE56aYVuxcuzGdA0WFXTLOqMAXajy2HnQSgfQOpd7ylInI
        ZyDKty8ZbUw3YR+yU7MXWHpECg==
X-Google-Smtp-Source: ABdhPJx7fpw/6SZnJG5XSThJFnQD3y5io89qefb/nNJG5jxpL5JilcRV8Lcmxm4piUbpiKymN1cHgg==
X-Received: by 2002:a17:90a:e68a:b0:1e3:252f:24e0 with SMTP id s10-20020a17090ae68a00b001e3252f24e0mr46099639pjy.122.1654643184504;
        Tue, 07 Jun 2022 16:06:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a1-20020a63e841000000b003fadfd7be5asm13173155pgk.18.2022.06.07.16.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:06:23 -0700 (PDT)
Date:   Tue, 7 Jun 2022 23:06:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "anup@brainfault.org" <anup@brainfault.org>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v2 000/144] KVM: selftests: Overhaul APIs, purge VCPU_ID
Message-ID: <Yp/Z7KE5C/QVpAeF@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <21570ac1-e684-7983-be00-ba8b3f43a9ee@redhat.com>
 <Yp+0qQqpokj7RSKL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp+0qQqpokj7RSKL@google.com>
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

On Tue, Jun 07, 2022, Sean Christopherson wrote:
> +Raghu
> 
> On Tue, Jun 07, 2022, Paolo Bonzini wrote:
> > Marc, Christian, Anup, can you please give this a go?
> 
> Raghu is going to run on arm64, I'll work with him to iron out any bugs (I should
> have done this before posting).  I.e. Marc is mostly off the hook unless there's
> tests we can't run.

arm64 is quite broken, the only tests that pass are those that don't actually
enter the guest.  Common tests, e.g. rseq and memslots tests, fail with the same
signature, so presumably I botched something in lib/aarch64, but I haven't been
able to find anything via inspection.

Raghu is bisecting...
