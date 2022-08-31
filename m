Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FB35A80EF
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 17:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiHaPIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 11:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiHaPIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 11:08:21 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2168A861DE
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 08:08:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 73so5396900pga.1
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 08:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=A7X/jZ9lUqu60MOcRLlF+pbicsriJRei7BENxHD49F4=;
        b=VGN9NnJ4pOLCZ8gaWbaPMBJEImO3hRQpMlwSTeShcL30e6IAeZ3vF0KIGeZuVVLv8C
         tX7JHAnZUz5K26fSfuQSJeTQfajhrTmstexytHlQojmLScnbrpcnrKib/b5DqjfGaPcc
         reZMaKM7x4Nsvv1kk4aP6LXdtodHGKcxvU9m1jzC+mSwyVJ0DWqYI9+bxrZPicbRbFT6
         r1ivhcxiE2q+Y7yhFhId1b+E/FI59tJ2KP0y36P98mqgnMKMa/kKmxR2HwJQISGCUy9G
         daZvIWLaq6xH1wrzNYVtpCphAe0+vRr1gTpMekBgee062qgqpzckha7XAwV5lnih67Y8
         RZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=A7X/jZ9lUqu60MOcRLlF+pbicsriJRei7BENxHD49F4=;
        b=XnEbyqgiSRKKFsOsFx1XOMhgCccwsy+UEy9/XADPJitt5z4ptWSNrzArEzLqh8YAOy
         GLmFlEGNzpdV73bstC/t3BQDJAEruYZtgkJ7cPR8xgCaD8n8yQOqU4HRQymwCQMhB+5h
         MJUo2uguPkYi8Jo1lB1k6VvL3lb/KZotJYolRkEoT/cLbTZTEMle8no9qkFMplFXHTdx
         LcOKMY69KICDd5A8Xp3jO/LWTjw9ohuAJhMvg8QRArL2uSc7pJSyL9UW6YPhDrT2pg6q
         7Bi4SJF0hdZ3fMzsHIKGUQA7G9sMJKEVXfaa38ng76GNZW/+IusmZzJ/7mecO51436PC
         L/Ow==
X-Gm-Message-State: ACgBeo0vbV8+wdKF+TiUQEzlxPg19/fMRQJWrQmVXUsiAYoeMiyMSaK9
        wGqO3nsRslCYEnKJVwsFdAximg==
X-Google-Smtp-Source: AA6agR4bRMh5zkyyHRKCi4bqcLL0d76Q6kqP/ey0xcjPJwwSFwRIeVTm9bK4N6jNOwsNPw8R18K8vA==
X-Received: by 2002:a62:27c1:0:b0:536:32d2:d098 with SMTP id n184-20020a6227c1000000b0053632d2d098mr26789171pfn.63.1661958497958;
        Wed, 31 Aug 2022 08:08:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 68-20020a620647000000b00537d7cc774bsm10290223pfg.139.2022.08.31.08.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:08:17 -0700 (PDT)
Date:   Wed, 31 Aug 2022 15:08:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 11/19] KVM: SVM: Add helper to perform final AVIC "kick"
 of single vCPU
Message-ID: <Yw95XR59VQSbVlY9@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-12-seanjc@google.com>
 <9144c9921bd46ba7c2b2e9427d053b1fc5abccf7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9144c9921bd46ba7c2b2e9427d053b1fc5abccf7.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > @@ -455,13 +461,8 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
> >  	 */
> >  	kvm_for_each_vcpu(i, vcpu, kvm) {
> >  		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
> > -					dest, icrl & APIC_DEST_MASK)) {
> > -			vcpu->arch.apic->irr_pending = true;
> > -			svm_complete_interrupt_delivery(vcpu,
> > -							icrl & APIC_MODE_MASK,
> > -							icrl & APIC_INT_LEVELTRIG,
> > -							icrl & APIC_VECTOR_MASK);
> > -		}
> > +					dest, icrl & APIC_DEST_MASK))
> > +			avic_kick_vcpu(vcpu, icrl);
> >  	}
> >  }
> >  
> 
> I don't know what I think about this, sometimes *minor* code duplication
> might actually be a good thing, as it is easier to read the code, but I don't
> have much against this as well.
> 
> I am not sure if before or after this code is more readable.

I don't have a strong opinion either.  I think I prefer having the helper, but
have no objection to leaving things as is.  Originally I was thinking there was
going to be a third call site, but that didn't happen.
