Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB406D8687
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 21:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbjDETHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 15:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjDETHE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 15:07:04 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B16F6E8B;
        Wed,  5 Apr 2023 12:07:02 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z19so35337598plo.2;
        Wed, 05 Apr 2023 12:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680721622; x=1683313622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kwVhT3Qgg4X6vs0QJD2uRXOkYVOmqmJ4ZAyGsBfqShM=;
        b=AQ7NAsN8P7hyejtohZfiz8QHRhmWBCQLYFRQZEU9Ek3CkA4k5cENhzewaXh3AFBsUP
         Fk7g6hendLMMgdYQXtV1mg0cfg9fJxFfo4YufjVbuwl/EtNw/swZasQf8AVTjcUuN9vj
         Lct93BFp9op+kcyOX9+JoIZyixRFLU6ix9dFACXK3VTVV0E4f5oxKr4Pfo7ZCSFoFJji
         0bX4pV1eSEcyA+EBAXC2HgSVZycOdloqyYm75UcgVmRNr/Xbe4od8rwW9BjiCJwQP0lY
         IaATUkdkZ86VEMhC3yXlarTV2HJD3wFM8k40iGqUHlH8t5nJAQNqJww6rhF0SfJ9uOVS
         xFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680721622; x=1683313622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kwVhT3Qgg4X6vs0QJD2uRXOkYVOmqmJ4ZAyGsBfqShM=;
        b=BXZ+sufv0oZuQf+2b6Anx4LBmkoCS4wOdFAwgXPlwPKsNX3w6Pop1qDzZShs2dRzao
         c0jD6LKJezhi2jmac1uba677KWr82imTwz85trt5WObZbyLP4HMGPNiGceTYgZMyZYCS
         PNtFPcaqNuEiQKeOhFmR5VyduMMstWIDsBnRxAtpnt1PrLZ843DTgfagoMYxXeZYzb1R
         1JWXHt4eyyd4adI+69L95xDqOuh6taifpbM6+YAnDkGaGqFrhQvedAi+g2t6oDDzKV03
         NBBky+vhVCnvwn6kVHV6GXURhVwxKObheac7Q7IDNSDEgqQw8OaeFk1TBFoJVKP2SBQC
         vn2g==
X-Gm-Message-State: AAQBX9dWP8pamE9E8ccxG9AIJQcS/knU2IgvyIwxg20IQQ16Rlold+Rf
        4/mLKj2nLHc2DNQ2IEgJpdcBQEI/bDY=
X-Google-Smtp-Source: AKy350ZI59+8Zz3fggsy/2cP8607Mxh88mge7MSbXxCzkDmcgmD4lmoipr/JqUg7k3QZhTC8ew7iZQ==
X-Received: by 2002:a17:90a:5e4d:b0:23f:58d6:b532 with SMTP id u13-20020a17090a5e4d00b0023f58d6b532mr7936046pji.5.1680721621825;
        Wed, 05 Apr 2023 12:07:01 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090ad50300b00240d4521958sm1777359pju.18.2023.04.05.12.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 12:07:01 -0700 (PDT)
Date:   Wed, 5 Apr 2023 12:06:59 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 024/113] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20230405190659.GI1112017@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <275b44ed878beae218db5ad9365af7e2571c0c68.1678643052.git.isaku.yamahata@intel.com>
 <20230404224438.00000ac3.zhi.wang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230404224438.00000ac3.zhi.wang.linux@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 10:44:38PM +0300,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> > +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > +{
> > +
> > +	/* Ignore INIT silently because TDX doesn't support INIT event. */
> > +	if (init_event)
> > +		return;
> > +
> > +	/* This is stub for now. More logic will come here. */
> > +
> > +	/*
> > +	 * Don't update mp_state to runnable because more initialization
> > +	 * is needed by TDX_VCPU_INIT.
> > +	 */
>            ^
>              guess this comment belongs to the later patch.

Ah, right. I'll move the comment to the next patch.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
