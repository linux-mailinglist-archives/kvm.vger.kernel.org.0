Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA355B219B
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 17:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiIHPI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 11:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiIHPIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 11:08:53 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD78E3D73
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 08:08:51 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h188so17012522pgc.12
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 08:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=HhVnH4+z3AjTuUR+xIrmszssYSTaTlD0QO6jVjhm5Yo=;
        b=e6SzDiP6UdIlPwp5cxYJdJhDqfc9Wo8WBi56M80mcphP9cBr9BahrfHePMxA5TZ3ei
         rURV7t9tOev7gHE1N4MHUu2EAXSdFLkPShEqRrkTbeeIU8c6HK3vGY2Li3Z3ClOC9CT+
         2Ei4j4AqpYCu3D48jYHXj6aYaRdxLwuOBguarGtCMuCLRGWs/Qm4mKLmRBqwGrwphHk4
         yg5bkWSJIl1Z8afpLdLrHBEXBD0rXoLhnDQKA3yajHDRN8V1R8OLtZZ03841pk5E0hy0
         iqm5XHtK2T2yeIXGVXVzZXFz0Gpq+wM5HYTE0/ilGev/2f2y+/MDhsh9kVTkaIOR4Gx0
         6KfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HhVnH4+z3AjTuUR+xIrmszssYSTaTlD0QO6jVjhm5Yo=;
        b=iTOv1AcCxHxEhPP4RymY1h9TOnt2F8dDiIay5JsUuOGez4I1qECokcTowAWkve//p9
         nwKqjJTmO3QIJUbHB6V39bTlm4q22HYEICGi77/D8Yxr8d7aJQoN/WSB5TMiK78FFURR
         VPGjSaXIo7TSDjiUWPiyDORTtnB8TRJ4oeokMP8gvqUckcya7hMPa6I01JmLV/W4WvR+
         W1KtnuPFE1Fc83gSr+25AeBaT1i3LABAyuEk6g905oQy2dGJtU28WitwEudpJCCissmI
         r11ulYUJJfx5O9Nne8SuTs9AYHelvhmxXIOCH6JKZEoExBhVvIbb6/nYM7eG7Hz+aGtV
         FISg==
X-Gm-Message-State: ACgBeo1okqJELkutZAhqZDLIA9MLx4hc0AaqTuYzYlHzsmJSfQV0vG6B
        LKThidIAUkdT12G48wzdTq3Wxg==
X-Google-Smtp-Source: AA6agR78MmoHmn7oi8NTo5aukMMugHzYKl4SbXvV7iRYRfMP6WuxJQI4X4n0rtX/cvXSWBm4DACpKg==
X-Received: by 2002:a05:6a00:1aca:b0:52f:55f8:c3ec with SMTP id f10-20020a056a001aca00b0052f55f8c3ecmr9338524pfv.25.1662649730854;
        Thu, 08 Sep 2022 08:08:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jf22-20020a170903269600b001768b6f9a97sm4155191plb.147.2022.09.08.08.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:08:50 -0700 (PDT)
Date:   Thu, 8 Sep 2022 15:08:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     =?utf-8?B?RnJhbnRpxaFlayDFoHVtxaFhbA==?= <frantisek@sumsal.cz>
Cc:     kvm@vger.kernel.org
Subject: Re: BUG: soft lockup - CPU#0 stuck for 26s! with nested KVM on 5.19.x
Message-ID: <YxoFf1LZfru5cmDO@google.com>
References: <a861d348-b3fd-fd1d-2427-0a89ae139948@sumsal.cz>
 <Yxiz3giU/WEftPp6@google.com>
 <a8fc728c-073c-2ff5-2436-40c84c3c62e1@sumsal.cz>
 <Yxi3cj6xKBlJ3IJV@google.com>
 <afbd5927-413b-f876-8146-c3f4deb763e1@sumsal.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afbd5927-413b-f876-8146-c3f4deb763e1@sumsal.cz>
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

On Thu, Sep 08, 2022, František Šumšal wrote:
> On 9/7/22 17:23, Sean Christopherson wrote:
> > On Wed, Sep 07, 2022, František Šumšal wrote:
> > > On 9/7/22 17:08, Sean Christopherson wrote:
> > > > On Wed, Sep 07, 2022, František Šumšal wrote:
> > > > > Hello!
> > > > > 
> > > > > In our Arch Linux part of the upstream systemd CI I recently noticed an
> > > > > uptrend in CPU soft lockups when running one of our tests. This test runs
> > > > > several systemd-nspawn containers in succession and sometimes the underlying
> > > > > VM locks up due to a CPU soft lockup
> > > > 
> > > > By "underlying VM", do you mean L1 or L2?  Where
> > > > 
> > > >       L0 == Bare Metal
> > > >       L1 == Arch Linux (KVM, 5.19.5-arch1-1/5.19.7-arch1-1)
> > > >       L2 == Arch Linux (nested KVM or QEMU TCG, 5.19.5-arch1-1/5.19.7-arch1-1)
> > > 
> > > I mean L2.
> > 
> > Is there anything interesting in the L1 or L0 logs?  A failure in a lower level
> > can manifest as a soft lockup and/or stall in the VM, e.g. because a vCPU isn't
> > run by the host for whatever reason.
> 
> There's nothing (quite literally) in the L0 logs, the host is silent when running the VM/tests.
> As for L1, there doesn't seem to be anything interesting as well. Here are the L1 and L2 logs
> for reference: https://mrc0mmand.fedorapeople.org/kernel-kvm-soft-lockup/2022-09-07-logs/
> 
> > 
> > Does the bug repro with an older version of QEMU?  If it's difficult to roll back
> > the QEMU version, then we can punt on this question for now.
> 
> > 
> > Is it possible to run the nspawn tests in L1?  If the bug repros there, that would
> > greatly shrink the size of the haystack.
> 
> I've fiddled around with the test and managed to trim it down enough so it's easy to run in both
> L1 and L2, and after couple of hours I managed to reproduce it in both layers. That also somewhat
> answers the QEMU question, since L0 uses QEMU 6.2.0 to run L1, and L1 uses QEMU 7.0.0 to run L2.
> In both cases I used TCG emulation, since with it the issue appears to reproduce slightly more
> often (or maybe I was just unlucky with KVM).
> 
> https://mrc0mmand.fedorapeople.org/kernel-kvm-soft-lockup/2022-09-07-logs-no-L2/L1_console.log
> 
> As in the previous case, there's nothing of interest in the L0 logs.
> 
> This also raises a question - is this issue still KVM-related, since in the last case there's
> just L0 baremetal and L1 QEMU/TCG without KVM involved?

Ya, unless there's a latent bug in KVM that's present in your L0 kernel, which is
extremely unlikely given that the bug repros with 4.18 and 5.17 as the bare metal
kernel, this isn't a KVM problem.

The mm, ext4, and scheduler subsystems are all likely candidates.  I'm not familiar
enough with their gory details to point fingers though.

Do you think it's possible to bisect the L1 kernel using the QEMU/TCG configuration?
That'd probably be the least awful way to get a root cause.
