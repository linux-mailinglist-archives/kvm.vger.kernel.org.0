Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EE22F366C
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 18:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391181AbhALRCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 12:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391023AbhALRCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 12:02:32 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6280C061575
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 09:01:51 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id a188so1726877pfa.11
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 09:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JJxqq8Vl8dankgMuwjdUQF/SpFwONNWv1cBUF/KW+IE=;
        b=VfLw1KPHaPHh/b71Gy9A8iX/zFO2HLewvS0WQd8Hpf00HBAKKW/reJ7Ga4HvnKi4il
         t+vbf1BW4YzhteO7AeGUx7gjdfaURPUo98ekFFgMcO0uQNQqaeH/PAxjDWXYBQB+SwYA
         QNfV4BmVWByO5DqaMcdvh0KRjgj6nYeNdwJ/vjXhrAe1KnUCIYq7ObeWg6OdpNWUEyvk
         mcAK48Ee5luUUhThzXNRsPrPRjzPGbk13FVZUaW9JAfvLnCLFcfaRULDzCQYOPZQT+8V
         Sz4Tk3GxoGpS6OH4BM/LsBuTVyCd6kWCdisTnrw3+RKnG7ONE5oXWqMjyzFcDh5SQcGZ
         UUjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JJxqq8Vl8dankgMuwjdUQF/SpFwONNWv1cBUF/KW+IE=;
        b=tjxVIrJ5TL7PaOkkzlGLvUaqyPz3ClGuFNhaNMMYoxVRt3qSrctZTN+r9WL8YloSWi
         9hmEz8BQi6fgj74/07yE034BX/MwpK68IUZx+RCkpTXoOD4CWMhep/cFFjTdMGRyGqeL
         hm+bTgXO8PR8DgGEUdLWW30nU10wOdrfsmuXc97ObR6iN75W6sJJSuGpK5iOx2Ax81VK
         Z20tFUuVzMqudvgF54duYs8gqzmWwGS82paLpczXX5sPISgiOk1LJFnOZhxJEuu4SKxD
         EHOmTjG3bkl/oQS0vgT/66y4pib+cVF44Jb1QODLcM7EUY6UfmtygnBylAmTmSN1C+KS
         xWxA==
X-Gm-Message-State: AOAM533HYmoBMuAHBhod7IU15/+XKh4JclSLTeEPfmlLouyt1afugo1F
        5DLdRvy/FW0SeVPsQcc1F55Z3RrU/ozRxg==
X-Google-Smtp-Source: ABdhPJwIUaHyESvffSqiPuAcIJdcS7jdjGhZizjZEhyRg6X95q1WIofO4bQEW86U/57cFyNvRUtO8A==
X-Received: by 2002:a62:1b16:0:b029:19e:238:8627 with SMTP id b22-20020a621b160000b029019e02388627mr229957pfb.52.1610470911009;
        Tue, 12 Jan 2021 09:01:51 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id u68sm3648324pfu.195.2021.01.12.09.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 09:01:50 -0800 (PST)
Date:   Tue, 12 Jan 2021 09:01:43 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86/access: Fixed test stuck issue on new
 52bit machine
Message-ID: <X/3V92hO1Sw1IdfZ@google.com>
References: <20210110091942.12835-1-weijiang.yang@intel.com>
 <X/zQdznwyBXHoout@google.com>
 <20210112090421.GA2614@local-michael-cet-test.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112090421.GA2614@local-michael-cet-test.sh.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Yang Weijiang wrote:
> On Mon, Jan 11, 2021 at 02:25:59PM -0800, Sean Christopherson wrote:
> > On Sun, Jan 10, 2021, Yang Weijiang wrote:
> > > When the application is tested on a machine with 52bit-physical-address, the
> > > synthesized 52bit GPA triggers EPT(4-Level) fast_page_fault infinitely.
> > 
> > That doesn't sound right, KVM should use 5-level EPT if guest maxpa > 48.
> > Hmm, unless the CPU doesn't support 5-level EPT, but I didn't think such CPUs
> > (maxpa=52 w/o 5-level EPT) existed?  Ah, but it would be possible with nested
> > VMX, and initial KVM 5-level support didn't allow nested 5-level EPT.  Any
> > chance you're running this test in a VM with 5-level EPT disabled, but maxpa=52?
> >
> Hi, Sean,
> Thanks for the reply!
> I use default settings of the unit-test + 5.2.0 QEMU + 5.10 kernel, in

The default settings are supposed to set guest.MAXPA = host.MAXPA.  At least, I
assume that's the purpose of '-cpu max'.  Maybe your copy of kvm-unit-tests'
x86/unittests.cfg is stale?

  [access]
  file = access.flat
  arch = x86_64
  extra_params = -cpu max
  timeout = 180

> this case, QEMU uses cpu->phys_bits==40, so the guest's PA=40bit and
> LA=57bit, hence 5-level EPT is not enabled. My physical machine is PA=52
> and LA=57 as can checked from cpuid:
> cpuid -1r -l 0x80000008 -s 0
> CPU:
>    0x80000008 0x00: eax=0x00003934 ...
> There're two other ways to w/a this issue: 1) change the QEMU params to
> to extra_params = -cpu host,host-phys-bits, so guest's PA=52 and LA=57,
> this will enable 5-level EPT, meanwhile, it escapes the problematic GPA
> by adding AC_*_BIT51_MASK in invalid_mask.
> 
> 2) add allow_smaller_maxphyaddr=1 to kvm-intel module.

Setting allow_smaller_maxphyaddr=1 is the correct answer.
