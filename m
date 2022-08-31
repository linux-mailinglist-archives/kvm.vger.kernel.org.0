Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CE85A8363
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiHaQlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbiHaQls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:41:48 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48E182859
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:41:47 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id t129so14963088pfb.6
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=++G3COAxypeyQZbXuhGnyuZYhw1740DPlPvtNk4Tmsg=;
        b=eeM/Dgpg1kt885I/qM+XTBsuEw05V24t7TMi7qvy3G4nWOsx+CcQd17yJZCz9zA5+u
         mwOd0/jxjigywcioFKSqLgoWysvmVPBUbwws4YmXQTqXUtPOn/M5EWUY/UwZA3cJAEQI
         lD99kvf6tQYgi0qNvEZS2AAt8yUAdkW5rTjWBfcPGc/eCyLaw8eMBoauS0n0mm83mlOz
         yG9F93zFGPQIDoFbzWxJcniH23MqFOdm2UPne/zrIkJvlg9T7yfla9YllD7oU5Ayz6a4
         lp9nZuWOHGbqi+pMNHwqc3ZHcBNYphnn1WplaPofqn44/JRcWP+yuYTJ2TwqOLb1xeb2
         wj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=++G3COAxypeyQZbXuhGnyuZYhw1740DPlPvtNk4Tmsg=;
        b=OWH8vu8dViygl/WMWiAulJ8hS9DLh9FhqYJJ65uXnDPxiW7hDl7OTzQ6yqhH3Bi23r
         8HlDcpUpHVaqxZAI1Ybf6/Onhzlai1aO94fTd4Ry6a9PWS4cYvbVB5MOARUFDyLQMNoN
         GBq8I1L+1u0sqifsPyEZyHYjgoJX0EhvV+HheXEgj/witWWBH5qPkumZjt21TcfbfCvk
         EdK1AlcLVqKPlybZSj7aBYo8IaaVOPsGD925cy8OKWRnqgQMWGCMiCwW9L8NliBD3kBR
         UJ2f2vtLU0Nsam1+OmOeHB6AlAN/cKwRdApuXDIz7HkBCd+K/o9knlHgx9h+S8hggVQK
         jx1Q==
X-Gm-Message-State: ACgBeo0CaCXymaTpULYieW53AS1MMA73DDSV3VgU7ziRAUt8XPOvJiSZ
        gXShiGJC461cQtxqm5HAHGC5kg==
X-Google-Smtp-Source: AA6agR5ZqTzzZLsVpwr7BHW5VFrZ6tch8D+TEJQrxn5Wajvo8hVtW4Am12cblYbSE/vDzM+Ga+lbjA==
X-Received: by 2002:a63:91ca:0:b0:42b:4847:90dd with SMTP id l193-20020a6391ca000000b0042b484790ddmr22072544pge.28.1661964106293;
        Wed, 31 Aug 2022 09:41:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x13-20020a17090a1f8d00b001f510175984sm1517590pja.41.2022.08.31.09.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:41:45 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:41:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 14/19] KVM: x86: Honor architectural behavior for aliased
 8-bit APIC IDs
Message-ID: <Yw+PRS2hScQd4ShB@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-15-seanjc@google.com>
 <5f6d99bc28fde0c48907991b6f67009430aea243.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f6d99bc28fde0c48907991b6f67009430aea243.camel@redhat.com>
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

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
> > -		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
> > -			new->phys_map[xapic_id] = apic;
> > +		if (kvm->arch.x2apic_format) {
> > +			/* See also kvm_apic_match_physical_addr(). */
> > +			if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
> > +			    x2apic_id <= new->max_apic_id)
> > +				new->phys_map[x2apic_id] = apic;
> > +
> > +			if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
> > +				new->phys_map[xapic_id] = apic;
> > +		} else {
> > +			/*
> > +			 * Disable the optimized map if the physical APIC ID is
> > +			 * already mapped, i.e. is aliased to multiple vCPUs.
> > +			 * The optimized map requires a strict 1:1 mapping
> > +			 * between IDs and vCPUs.
> > +			 */
> > +			if (apic_x2apic_mode(apic))
> > +				physical_id = x2apic_id;
> > +			else
> > +				physical_id = xapic_id;
> > +
> > +			if (new->phys_map[physical_id]) {
> > +				kvfree(new);
> > +				new = NULL;
> > +				goto out;
> Why not to use the same  KVM_APIC_MODE_XAPIC_FLAT |  KVM_APIC_MODE_XAPIC_CLUSTER
> hack here?

The map's "mode" only covers logical mode (the cleanup patch renames "mode" to
"logical_mode" to make this more clear).  There is no equivalent for dealing with
the physical IDs.  Alternatively, a flag to say "physical map is disabled" could
be added, but KVM already has to cleanly handle a NULL map and in all likelihood
the logical map is also going to be disabled anyways.

Not to mention that APIC performance is unlikely to be a priority for any guest
that triggers this code :-)
