Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F9F5350A5
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 16:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344034AbiEZOaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 10:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiEZOaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 10:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51A6AC6E73
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 07:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653575405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/hbXFKs5os4KRddKG4snbTFtherU/r6Je1WrF2mEc5o=;
        b=W2hkmJ9iVVMVq5dfa6dkwqMUqBbw8AI88LiJM9JOJvRp5OCIzUtBSzNRBpRET18SxyfU2C
        e+mS2r6IYYEV8lmdN/gmfhRmwoASkxWvM5Ln4QV4A4yK92JTg6jxOmLyN3YarMuekJ2L/3
        6MT0WITGAyo85zrtx6+XxRYiuuxtHjs=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-ilpOj5u6N7CUvSP36LauAw-1; Thu, 26 May 2022 10:30:04 -0400
X-MC-Unique: ilpOj5u6N7CUvSP36LauAw-1
Received: by mail-il1-f198.google.com with SMTP id a12-20020a92c54c000000b002d2f39932e8so227519ilj.19
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 07:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/hbXFKs5os4KRddKG4snbTFtherU/r6Je1WrF2mEc5o=;
        b=Jus1zI9UbRX4Y584AykDsGN0L4qLQgJf594yZBs711pELAyEjwBj58wrdU81UjjtIW
         9cu3Ybq+2MPly8wx+I0EAXCTDiT3ZEp8lPdXTOS5u8Ev3Dmqnb1FmHQxLIqyW1hJ/v4Q
         eHtOozqqIJBjeOM52KuIlVilqCeeofbDj3s3GFHTgdofzzWPW0our2/NplMF+BmDdlw9
         IalOV5wGSMdxj78cHbp6/GWocnfDOjuLGjL9EsPOEqAgCdyHjX6qKBk55K2VyhQP/R6I
         wJL23tzLxzfciH8P7Eb3Uc6zawGkD6mM3CgCwsW8HD20sZk8wvU98OTTOPDH7JGO7R93
         8cbQ==
X-Gm-Message-State: AOAM532quViJjslNB+7UZtttniQlAHfzw4pDhfOiqtuncWJgDndbXLt7
        WXduzNrCVkh8eM77uVV0WMCyzc/q088tD1YZHJ/JBuOcG85vC+9h4ePCRlrsdbzUYXFo22rEFyF
        MAn1nsfgB+7QA
X-Received: by 2002:a05:6e02:1988:b0:2cf:691e:2a8 with SMTP id g8-20020a056e02198800b002cf691e02a8mr18862916ilf.54.1653575403391;
        Thu, 26 May 2022 07:30:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPSo8mF4mfBm24d7gUVoJ7UmeRwfK10RCCWWPovTs2cnyg4+iIr+dbQG+UmCYbdmiabpUN6w==
X-Received: by 2002:a05:6e02:1988:b0:2cf:691e:2a8 with SMTP id g8-20020a056e02198800b002cf691e02a8mr18862894ilf.54.1653575403028;
        Thu, 26 May 2022 07:30:03 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id l10-20020a92700a000000b002d1d3b1abbesm520825ilc.80.2022.05.26.07.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 07:30:02 -0700 (PDT)
Date:   Thu, 26 May 2022 10:30:00 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH] KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty
 logging
Message-ID: <Yo+O6AqNNBTg7BMY@xz-m1.local>
References: <20220525230904.1584480-1-bgardon@google.com>
 <a3ea7446-901f-1d33-47a9-35755b4d86d5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a3ea7446-901f-1d33-47a9-35755b4d86d5@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 02:01:43PM +0200, Paolo Bonzini wrote:
> On 5/26/22 01:09, Ben Gardon wrote:
> > +		WARN_ON(max_mapping_level < iter.level);
> > +
> > +		/*
> > +		 * If this page is already mapped at the highest
> > +		 * viable level, there's nothing more to do.
> > +		 */
> > +		if (max_mapping_level == iter.level)
> > +			continue;
> > +
> > +		/*
> > +		 * The page can be remapped at a higher level, so step
> > +		 * up to zap the parent SPTE.
> > +		 */
> > +		while (max_mapping_level > iter.level)
> > +			tdp_iter_step_up(&iter);
> > +
> >   		/* Note, a successful atomic zap also does a remote TLB flush. */
> > -		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
> > -			goto retry;
> > +		tdp_mmu_zap_spte_atomic(kvm, &iter);
> > +
> 
> Can you make this a sparate function (for example
> tdp_mmu_zap_collapsible_spte_atomic)?  Otherwise looks great!

There could be a tiny downside of using a helper in that it'll hide the
step-up of the iterator, which might not be as obvious as keeping it in the
loop?

Thanks,

-- 
Peter Xu

