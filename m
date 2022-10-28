Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACAF7611C86
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 23:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiJ1Vmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 17:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJ1Vmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 17:42:36 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448BE23B692
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 14:42:36 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id r18so5894713pgr.12
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 14:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MNtHWFuVJo7RCDVkDfutNqtv/jry9OXULraTG7JwUdc=;
        b=Vc7KCJ7tTFt79LcDHbPh0VgyMSPC07KNz2pxxjI4QACmCoCZHD0ua0xGZDIQlZSP9q
         Xvx17CovdmJVekN1CASKbFPtZ7wS9qKTMJkxZNvRZOgopi2vNV/lCjCFzRYwjRQNRN4E
         1vrUdkRAtfDUBCHQJkGi8SJuTBrP7uPwSuKeUpNO6XrywJw0Mwm+ZNkw6OSr3rnvYXM7
         rRrKecp4EsrMWtUWNehpfv4FhzGrxpeTRTdUMxdMAWP1zj68k2mBfNQKSE+DJDtz03Ql
         Pq9+O7f8vAMVO7OBqeMTgnaWi05XT18EY9jt0QoBnz1EeBFraE2zgSr6CIlRmscuqs3m
         VHGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNtHWFuVJo7RCDVkDfutNqtv/jry9OXULraTG7JwUdc=;
        b=NUrBdKwAUzM6jOPjOrqdWJF5IWqMrGQPQu8z4ByvoASwntRY7OaRbLZna6iV191PNO
         WQD0I9LVXsLp9pnygQikTj3s7Qo6Kfo3tG1oNonnUZvnktpChuhq79kWYm6oTybDKlSA
         JSJ9bcOdLYjs3q+Gq9ypHfa7XJ8FQszrz4NEfkPq4rHV1PO8aD6y4I2uZLseUg89lYlb
         gb17BV/rOeBMrSf2kiXx73+O2ClUOZZq0IIzJ61nGryGEu+tipyFSenApJSyyD6+fcLW
         h/ZHN9G7DTVRZg/iWrMqMC6Wy+c94gZJcWqck0/wSma3Fbky+WaRrV7okylbius5tWIE
         1q2A==
X-Gm-Message-State: ACrzQf2lspv8v57Fd5GH+hIlGzjQkTTF1S+An5A0jmC/QJiJPk9SLkyD
        StHam9ftHULH/AAGTM1fBvH7HA==
X-Google-Smtp-Source: AMsMyM7t32R71Q+XQko8kyhpPUDEskRsXMrXf0innMx8jyiy6H5cYLFZwqNd4+0HGqYl48VEk880MQ==
X-Received: by 2002:a63:d848:0:b0:46f:81cb:6d6c with SMTP id k8-20020a63d848000000b0046f81cb6d6cmr555562pgj.453.1666993355455;
        Fri, 28 Oct 2022 14:42:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p123-20020a625b81000000b0056299fd2ba2sm3264250pfb.162.2022.10.28.14.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:42:35 -0700 (PDT)
Date:   Fri, 28 Oct 2022 21:42:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Do not recover NX Huge Pages when
 dirty logging is enabled
Message-ID: <Y1xMx/0Cu+DsN2LN@google.com>
References: <20221027200316.2221027-1-dmatlack@google.com>
 <7314b8f3-0bda-e52d-1134-02387815a6f8@redhat.com>
 <CALzav=e-gJ77LCo7HsL4X37B96njySebw8DGbPV_xcHbhaCBag@mail.gmail.com>
 <Y1xEggz1oeNObHuP@google.com>
 <CALzav=dOxzbEkMpSfQxo3WawZmwasGyeKEh7AeUugsVsAUKk4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dOxzbEkMpSfQxo3WawZmwasGyeKEh7AeUugsVsAUKk4w@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 28, 2022, David Matlack wrote:
> On Fri, Oct 28, 2022 at 2:07 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Oct 28, 2022, David Matlack wrote:
> > > I'll experiment with a more accurate solution. i.e. have the recovery
> > > worker lookup the memslot for each SP and check if it has dirty
> > > logging enabled. Maybe the increase in CPU usage won't be as bad as I
> > > thought.
> >
> > If you end up grabbing the memslot, use kvm_mmu_max_mapping_level() instead of
> > checking only dirty logging.  The way KVM will avoid zapping shadow pages that
> > could have been NX huge pages when they were created, but can no longer be NX huge
> > pages due to something other than dirty logging, e.g. because the gfn is being
> > shadow for nested TDP.
> 
> kvm_mmu_max_mapping_level() doesn't check if dirty logging is enabled

Gah, I forgot that kvm_mmu_hugepage_adjust() does a one-off check for dirty logging
instead of the info being fed into slot->arch.lpage_info.  Never mind.
