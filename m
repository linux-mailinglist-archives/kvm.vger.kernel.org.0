Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7E74D18FA
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 14:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347108AbiCHNSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 08:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244168AbiCHNSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 08:18:40 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F95BC91
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 05:17:41 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id r10so28529977wrp.3
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 05:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XfVP1Futsy++7m0TgbkvY6qiuRCjgerrga+g67lu1Ek=;
        b=daU9XDRbpf5VVtFrY2QzcwF3ZtTcFBrXQsRNdZelyHpgJKdIFec7rg+VV/zCsSDTLV
         +EnGy0tCVeGPFpsekK1W3dlBFpATezbhh3SeK6V9k1iBnVJNTlOfr3tpK6AWsyxHJ0SN
         +oTJM3DO5dRsz2QnuPmw9+aAVUw0VVU+EICURKWHmBuPWwAiQZspNrKzrjlUJA/Sc0Ns
         hMGAJTbDLIXQ9AaW+MFe1+2OkExuZsxMpiV0EAEs98sfGlGfgOOXhNozI4tCH2hTkdux
         PGI8AYV+glVQMiXQWFpKrKBeL08Im9TCs71moi41c75P0JWJDIM7QD5ktYG8IPXiaBEi
         mmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XfVP1Futsy++7m0TgbkvY6qiuRCjgerrga+g67lu1Ek=;
        b=qfG5mCaVfy4j7RV6zdHodRoHq8qXef884k7zR2VZguUAcAXs9SEZ/q4yf8aHteiIzn
         0LgPLvowVdzyslb97CnHGzUlpvCF9QpYWpn3VzJYbxhHT21yidjlFx0qj9r0osvexjG/
         eAxX0ji2R96s6Cxt6bQCfh+cuDMP6xyOIOliYLvt25PA5fsd1ucsDgCt6/2yORI02nQI
         aEGzyXKsDUkTyOucBNAsM19j+GzaFjIx5hQsqG1r6LiX9bf64QIw21FNOlXNOtkjvMDj
         YSK4D59ZkyWgV8XOBeUrX55R0xrT8zdHAwsPangzWNcGR1VV97cpjFCuTbnjjwVUcoGd
         tL/Q==
X-Gm-Message-State: AOAM5310LJNw01RNvJpZk6J0amFrCfIgEJQ0HTT7ZWP9ZkYOBk4TtY/B
        bcfg47hGQFbOPpon4r8UiRpvHw==
X-Google-Smtp-Source: ABdhPJwMzbNS8dkm+oUEuSulCjhaXvI277sU1XFD3cangGoXohBMiM7L39t6Kf1rVlzeuymzembtoQ==
X-Received: by 2002:a5d:4089:0:b0:1f0:4819:61ba with SMTP id o9-20020a5d4089000000b001f0481961bamr12511835wrp.307.1646745459965;
        Tue, 08 Mar 2022 05:17:39 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id bi6-20020a05600c3d8600b00381590dbb25sm2354561wmb.3.2022.03.08.05.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:17:39 -0800 (PST)
Date:   Tue, 8 Mar 2022 13:17:38 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, qperret@google.com, will@kernel.org,
        julien.thierry.kdev@gmail.com, maz@kernel.org
Subject: Re: [PATCH kvmtool v8 1/3] aarch64: Populate the vCPU struct before
 target->init()
Message-ID: <YidXctiW9xUoJl80@google.com>
References: <20220307144243.2039409-1-sebastianene@google.com>
 <20220307144243.2039409-2-sebastianene@google.com>
 <YicvwRlojrgSSrdU@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YicvwRlojrgSSrdU@monolith.localdoman>
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022 at 10:28:17AM +0000, Alexandru Elisei wrote:
> Hi,
> 

Hi,

> On Mon, Mar 07, 2022 at 02:42:42PM +0000, Sebastian Ene wrote:
> > Move the vCPU structure initialisation before the target->init() call to
> >  keep a reference to the kvm structure during init().
> > This is required by the pvtime peripheral to reserve a memory region
> > while the vCPU is beeing initialised.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> 
> I think you're missing Marc's Reviewed-by tag.
>

I will add the Reviewed-by tag to the next iteration.

> Thanks,
> Alex
> 

Thanks,
Sebastian

> > ---
> >  arm/kvm-cpu.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> > index 6a2408c..84ac1e9 100644
> > --- a/arm/kvm-cpu.c
> > +++ b/arm/kvm-cpu.c
> > @@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> >  			die("Unable to find matching target");
> >  	}
> >  
> > +	/* Populate the vcpu structure. */
> > +	vcpu->kvm		= kvm;
> > +	vcpu->cpu_id		= cpu_id;
> > +	vcpu->cpu_type		= vcpu_init.target;
> > +	vcpu->cpu_compatible	= target->compatible;
> > +	vcpu->is_running	= true;
> > +
> >  	if (err || target->init(vcpu))
> >  		die("Unable to initialise vcpu");
> >  
> > @@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> >  		vcpu->ring = (void *)vcpu->kvm_run +
> >  			     (coalesced_offset * PAGE_SIZE);
> >  
> > -	/* Populate the vcpu structure. */
> > -	vcpu->kvm		= kvm;
> > -	vcpu->cpu_id		= cpu_id;
> > -	vcpu->cpu_type		= vcpu_init.target;
> > -	vcpu->cpu_compatible	= target->compatible;
> > -	vcpu->is_running	= true;
> > -
> >  	if (kvm_cpu__configure_features(vcpu))
> >  		die("Unable to configure requested vcpu features");
> >  
> > -- 
> > 2.35.1.616.g0bdcbb4464-goog
> > 
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
