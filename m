Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A68B59C69E
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 20:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbiHVShX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 14:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237328AbiHVShV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 14:37:21 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EE848EA0
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:37:21 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id x19so10708357plc.5
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=knw0FhqPih0DMLQi3BX8S3tOWcFg9GCWwB+b3MoqYXM=;
        b=REqXIggLvhB59vEgTEnA3tSAocAPV1PsPXetgM7cbJHrykaXQ2Mn44ulz0jJicBYV+
         XBB9RaIP6cdAJpgzBqXps+rOe9Ch9TZXd9Odisw7QPVeMMj0jEQmYkXAxHDqRboiCS/u
         zK1GpcceMxRrYDga6+2kNTLgCcxu8Kmd1YArHokPS1W0JN1IuY4Aie+ppmjs40dhU1qm
         3n0k+UHEsicWiDMhDO7Q9HWsvVynvbCuZPxJJJnn45u7M5oprvHSRJpQu4eaU6GZYpG+
         FAAVFucTkiRGO9GyI/4UGjMoJwJkH48AQxW8SB97c81d8hCIUnD0047ACO41zcl+Bjun
         iN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=knw0FhqPih0DMLQi3BX8S3tOWcFg9GCWwB+b3MoqYXM=;
        b=PJ8DBmDvKXQS3BJT2j2B45aWvyCc3tPYhiQ9U+TIIgUyBWDM9eIcAH81WQm1AbEp1E
         TlhMIsiIA5BbARtDkRIRs4oTeUm/3HZegYOVV/rLqq0rmkhjeHQ9Dv9e9DjIkqwG/nA7
         c/fLXY1si51C8XbgTClgL8eDAr/qmTZve+Xk9kEbh3UQ1KhrHv+NJ1+1j8oojEcJJiNA
         GqlWS2/vLmfIiVnX7Xu+YfRFfI6gshxXPzgw/HG2fRB5lBhSHTl0qIDtSDzXgmsDmS8M
         3npQmJ+GE8aAQA35WSA2ltgdt3+lRMkTqllJETbbo5j9OOjWVPWv7l1bELUCqD4fxMb1
         +ajA==
X-Gm-Message-State: ACgBeo1UOMzPRA1AO7j5EMFxig7UdMX5CGZ/M/izbxrmNLf399drtMrq
        OOd98YPdwipq+4AOygo2507PCw==
X-Google-Smtp-Source: AA6agR75BsxAr+f48ou5etkJKD7TD/Tyv0Zh+pkrSWvDMwdGqg074hjobXmSQJwxY6+bFuET8vrBAw==
X-Received: by 2002:a17:902:f68f:b0:172:ff8a:90d4 with SMTP id l15-20020a170902f68f00b00172ff8a90d4mr165945plg.2.1661193440698;
        Mon, 22 Aug 2022 11:37:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902cec200b0016c5306917fsm8875565plg.53.2022.08.22.11.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 11:37:20 -0700 (PDT)
Date:   Mon, 22 Aug 2022 18:37:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Michal Luczaj <mhal@rbox.co>, kvm <kvm@vger.kernel.org>,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
Message-ID: <YwPM3AkUS7IT+yWJ@google.com>
References: <20220821215900.1419215-1-mhal@rbox.co>
 <20220821220647.1420411-1-mhal@rbox.co>
 <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co>
 <YwOj6tzvIoG34/sF@google.com>
 <87756239-CB76-4D9B-AB63-49B70C8CAFD3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87756239-CB76-4D9B-AB63-49B70C8CAFD3@gmail.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022, Nadav Amit wrote:
> On Aug 22, 2022, at 8:42 AM, Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Mon, Aug 22, 2022, Michal Luczaj wrote:
> >> On 8/22/22 00:06, Michal Luczaj wrote:
> >>> Note that doing this the ASM_TRY() way would require extending
> >>> setup_idt() (to handle #DB) and introducing another ASM_TRY() variant
> >>> (one without the initial `movl $0, %%gs:4`).
> >> 
> >> Replying to self as I was wrong regarding the need for another ASM_TRY() variant.
> >> Once setup_idt() is told to handle #DB,
> > 
> > Hmm, it might be a moot point for this patch (see below), but my vote is to have
> > setup_idt() wire up all known handlers to check_exception_table().  I don't see
> > any reason to skip some vectors.  Code with __ASM_TRY() will explode no matter what,
> > so it's not like it risks suppressing completely unexpected faults.
> 
> I would just like to point out that this whole FEP approach is not friendly
> for other hypervisors or bare-metal testings. While people might have mixed
> feelings about other hypervisors, the benefit of running the tests on
> bare-metal should be clear.

If people want to run KUT on other hypervisors that support a different FEP (KVM
stole it from Xen after all), then I have no objection to genericizing KVM_FEP
and making it a config option.

> Specifically in this test, it is rather simple to avoid using FEP.

I'm saying KUT should do both, i.e. run the same sequences with and without
forced emulation on the "critical" instructions.  That provides full coverage for
bare metal, and also provides coverage for both "fast" and "slow" emulation in
KVM (and other future hypervisors if other prefixes are ever supported).
