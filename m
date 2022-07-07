Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89B156A931
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 19:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbiGGROs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 13:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbiGGROr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 13:14:47 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308EA31389
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 10:14:46 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id n12so20741910pfq.0
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 10:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iAlPKThjN3KI+X1ZKU+QfTbzAP64Rk03pVBqEtTAkec=;
        b=WU9PdWSiqG8Ah6C4Wuy5KYkGrJAm1XzRHtMYQrf5owlj5ULolEDy920IAGfqMLmfOk
         t0fpJCKYrIs/HfGMfmIwTgc8Onq5Z5rbm7lNnbbUpsHHND9IirP0SQASpiqOKDMEZiuL
         hBMzUvM8+M8+ajW9BYvG4LWH6wgBgrWpP2FfJGMf2tFiM3f+G0eaAS1jhdhEtkkbm8uA
         MiDwzFT1LwoaB1Em9Pdkq03X/72LB+/FkLahdQaNYn+/st7gEKhetw0uVPD7LErRbhLP
         8HFkU7Ox9aBtg5sLpQzAFjUM/D8zBnc/0vGENKk3V65tX1qrPMQstqh5RHFFZkqU5Gjf
         0XmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iAlPKThjN3KI+X1ZKU+QfTbzAP64Rk03pVBqEtTAkec=;
        b=iv4wDC5TfPkIO6icE0q0k3rfOvZrkr3BDcON3uKlAap1psUswBCQo8JaWQr7Zb/jUS
         lZbjK0/WXzCRISNr1WVeLxSrvZaQNjQ5QePY9DFsVPFTmhLfMRIzJognyuRWBPMWrw68
         Rr3EuE6Jeq38ko188Jd4P+RpmCGT1Bs2xej5lsL28JAd89Sm0D90qE2EfrdKDrz/fy4w
         vAv1d5HHlSFWTnPKOEgfamWdtU9UE/d5o6ySuvcAcA6B4blCnlJUIy/sD4xzzM3vIOTg
         kVoMfOO8niYE00o5ZydeENgjfhyUblBgVqedv4tAE90+1oiMFVgCe2dwEXSO6FoSe2oK
         ItGQ==
X-Gm-Message-State: AJIora+SXNoAXID/K14eiII9eBcAPX8pc1QxYASOomi/p0yCjkMVsQm8
        54usaSnOpVNMPbj3EPEUFs9fEQ==
X-Google-Smtp-Source: AGRyM1vRMXFbdMFd71YenWcBALVLWZrn6kdo+9kkxLz5dRL69HIiwXUwSkTvZ7zMH1demR/UaBFHoA==
X-Received: by 2002:a17:90a:cc18:b0:1ef:839e:45b0 with SMTP id b24-20020a17090acc1800b001ef839e45b0mr6441542pju.156.1657214085599;
        Thu, 07 Jul 2022 10:14:45 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p9-20020a1709026b8900b0016372486febsm27989231plk.297.2022.07.07.10.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 10:14:44 -0700 (PDT)
Date:   Thu, 7 Jul 2022 17:14:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 05/21] KVM: nVMX: Prioritize TSS T-flag #DBs over
 Monitor Trap Flag
Message-ID: <YscUgGElDEPIkIEo@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
 <20220614204730.3359543-6-seanjc@google.com>
 <CALMp9eSH1O8keAVxZzfdvV1vu0AJBhaXVUfkSgYgCPOoSB5=Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSH1O8keAVxZzfdvV1vu0AJBhaXVUfkSgYgCPOoSB5=Jw@mail.gmail.com>
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

On Wed, Jul 06, 2022, Jim Mattson wrote:
> On Tue, Jun 14, 2022 at 1:47 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Service TSS T-flag #DBs prior to pending MTFs, as such #DBs are higher
> > priority than MTF.  KVM itself doesn't emulate TSS #DBs, and any such
> 
> Is there a KVM erratum for that?

Nope, just this hilarious TODO:

	/*
	 * TODO: What about debug traps on tss switch?
	 *       Are we supposed to inject them and update dr6?
	 */

> > exceptions injected from L1 will be handled by hardware (or morphed to
> > a fault-like exception if injection fails), but theoretically userspace
> > could pend a TSS T-flag #DB in conjunction with a pending MTF.
> >
> > Note, there's no known use case this fixes, it's purely to be technically
> > correct with respect to Intel's SDM.
> 
> A test would be nice. :-)

LOL, yeah, but ensuring userspace-injected TSS T-bit #DBs work isn't exactly on
my list of top 100 things to look at.
