Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBCF551DC5
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbiFTOAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351741AbiFTNzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 09:55:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A68B833E39
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655731253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NzIQ07jP7Ucf0c+44ASJDe761bf0uW4WoGXyOYmuq/Y=;
        b=T9Tlti/mhR+nlwJx/Tyv4812uT7wBsBgUdAMG86jyUFPOFiS4jLgXmgNvDmePX+QXZ72NK
        udDcQh/bf4OjHarY4mbgzbAeVuZxIECwVIGLXF4GJtLdxZQVEqGdF94T7tNpLAcw3DQAFr
        LA91/7moEFXNufeRzG/Sn80RWuSMHSU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-tccrStMGO9K12ryFw9Pc3g-1; Mon, 20 Jun 2022 09:20:52 -0400
X-MC-Unique: tccrStMGO9K12ryFw9Pc3g-1
Received: by mail-wm1-f70.google.com with SMTP id p24-20020a05600c1d9800b0039c51c2da19so5861109wms.0
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:20:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NzIQ07jP7Ucf0c+44ASJDe761bf0uW4WoGXyOYmuq/Y=;
        b=7/s8fMn4b3zqOdC0Wr8DcQCfqp4IF7aRCWM83Tc3OZjBtY3NJBTB9fK38LeT5mzRrh
         x0sB2PXkjDR7yUnW38kXFw6h8PQCCZH/sfVzT/jNHsC9nqis8jGmUH2TSsBNrCJdScTw
         0Yof17O7EynH7lZJGYikZskgX4p6JNdZWl4hGVwJGTwBItuFFV64MEHRCAreco9wi466
         k8W6f1t+7RQdcykun5ZsGeaQELVtx1mkGeTaBiyYB2P8enK0TsUTBhpJtZAsHlDq9ycN
         EgGMj6pgEFcHlqZT95poBRG5FeSaYPp5te1r2Y6gYx+Pyla3/fFBEp0KsJhf9ZcMFALr
         7DSw==
X-Gm-Message-State: AJIora9DOaOXJIpjyr0PeD9ofR3hT0spkMv2dd2N5Z+HUQYA2rkpSwB/
        VVVuHujLZK4DtDTF0sjLh+aG0GVq1lYUAYMRkrUSxrsZsqfEuhVZIlrJYVpa3QO40G3zuraqCci
        x7HcqVy4mVwHJ
X-Received: by 2002:a05:6000:1887:b0:218:5d15:9a95 with SMTP id a7-20020a056000188700b002185d159a95mr23018012wri.1.1655731251571;
        Mon, 20 Jun 2022 06:20:51 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v6YrcUzZO8F2Fmbea+YPgX0T97b5fSHtTGMMCEGdCHdfnbcGRcWGr1IQ5E9v6jUl3rX0Y8uw==
X-Received: by 2002:a05:6000:1887:b0:218:5d15:9a95 with SMTP id a7-20020a056000188700b002185d159a95mr23017989wri.1.1655731251385;
        Mon, 20 Jun 2022 06:20:51 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id d5-20020a5d4f85000000b0021b862ad439sm9067735wru.9.2022.06.20.06.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 06:20:50 -0700 (PDT)
Date:   Mon, 20 Jun 2022 15:20:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        vkuznets@redhat.com, thuth@redhat.com, maz@kernel.org,
        anup@brainfault.org
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <20220620132048.jey6rjbbw7skbupb@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
 <20220616121006.ch6x7du6ycevjo5m@gator>
 <Yqy0ZhmF8NF4Jzpe@google.com>
 <Yq0Xpzk2Wa6wBXw9@google.com>
 <20220620072111.ymj2bti6jgw3gsas@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620072111.ymj2bti6jgw3gsas@gator>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 09:21:11AM +0200, Andrew Jones wrote:
> On Sat, Jun 18, 2022 at 12:09:11AM +0000, Sean Christopherson wrote:
> > On Fri, Jun 17, 2022, Colton Lewis wrote:
> > > On Thu, Jun 16, 2022 at 02:10:06PM +0200, Andrew Jones wrote:
> > > > We probably want to ensure all architectures are good with this. afaict,
> > > > riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
> > > > for example.
> > > 
> > > All architectures use UCALL_MAX_ARGS for that. Are you saying there
> > > might be limitations beyond the value of the macro? If so, who should
> > > verify whether this is ok?
> > 
> > I thought there were architectural limitations too, but I believe I was thinking
> > of vcpu_args_set(), where the number of params is limited by the function call
> > ABI, e.g. the number of registers.
> > 
> > Unless there's something really, really subtle going on, all architectures pass
> > the actual ucall struct purely through memory.  Actually, that code is ripe for
> > deduplication, and amazingly it doesn't conflict with Colton's series.  Patches
> > incoming...
> >
> 
> RISC-V uses sbi_ecall() for their implementation of ucall(). CC'ing Anup
> for confirmation, but if I understand the SBI spec correctly, then inputs
> are limited to registers a0-a5.

Ah, never mind... I see SBI is limited to 6 registers, but of course it
only needs one register to pass the uc address... We can make
UCALL_MAX_ARGS whatever we want.

Thanks,
drew

