Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BE64AF7EB
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbiBIRQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiBIRQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:16:09 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A862C05CB82
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:16:13 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id z13so5447507pfa.3
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 09:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OS/vYOaEcHltj8pU0RU1HWmOJM4B0kiaQM88fHj6Yl0=;
        b=hmlScaG/MxxcGv/Ce3Q4Oi9usYARksWWYafzDMafamI2qghv/S0/M4+43akD8WMij2
         efXyMsqUtMgbmaz06fwBdZIlcl4RcHgu0W4zBpPwECH/FmNeJsFmH1nNhiwLwO0kFnRd
         3iYQgsDZT4n3wg9BplUVExDHt5mw2okNzzUyebjeCYcuCTB+TPqZr9JcO+vp4eLdIH2V
         s6nzk6+CA+HLokzqv0s96cGozIqi0Su0pNUGwIeo4ehZX6IuMnjbY7ju6Kg/1al0JiuP
         V9oiitH4w/5+6jSVY14WjRjYFTINblj83m87TfnsjlbkgXEXSRsthZ5rIrJF7/Mpig2t
         ciUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OS/vYOaEcHltj8pU0RU1HWmOJM4B0kiaQM88fHj6Yl0=;
        b=o3CEvkslE+UVoKfq4RYyoDts1UQhayQEwhlkNo2jEqhIsPN8oX1G2SbMc8gwkOLINz
         JbBzihJm5auk7GDXam1IH0AqcPZrwVMiLt31TJeJljf1YxtqKlmO+MZWv3OnTxIsf8g/
         DTeVowD/oUzF7tBYTlOArZW6UpZjZiM3tUErj3GEAm8wq0ut9wmF35cVKwNU9OHKtZR5
         K2HDyiQmDQ/TuN4//aygAXHdHFYtz/jGIckhQu2o3qlYtALmu8hOdoVjuWTojR3F/DzN
         UgcOqc6EOTxeY82/cVT+HaKMOmcu+/08s8F0j2PTeTSoo7Twh2G+6PcKBrOeAvGmYX0J
         4TKA==
X-Gm-Message-State: AOAM533hkpx4IkIM3uGpakYUff3LCwCtj8RqQ5vcG9RiUwxRPbuVZYsE
        jhTxXkm+xUvsFYlachTKm8wZUA==
X-Google-Smtp-Source: ABdhPJx8SCWRZTEmqxObdVShTYrZp66VDixB774iK68T4PYn/ZZtmlUWHXx0vQ8kdvJJiRwTXP0w4Q==
X-Received: by 2002:a63:b207:: with SMTP id x7mr2638660pge.392.1644426972381;
        Wed, 09 Feb 2022 09:16:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q1sm3926434pfs.112.2022.02.09.09.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:16:11 -0800 (PST)
Date:   Wed, 9 Feb 2022 17:16:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 00/12] KVM: MMU: do not unload MMU roots on all role
 changes
Message-ID: <YgP22CSj7GHYslYa@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <YgP04kJeEH0I+hIw@google.com>
 <fc3a4cdc-5a88-55a9-cfcc-fb7936484cc8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc3a4cdc-5a88-55a9-cfcc-fb7936484cc8@redhat.com>
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

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> On 2/9/22 18:07, Sean Christopherson wrote:
> > On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> > > The TDP MMU has a performance regression compared to the legacy MMU
> > > when CR0 changes often.  This was reported for the grsecurity kernel,
> > > which uses CR0.WP to implement kernel W^X.  In that case, each change to
> > > CR0.WP unloads the MMU and causes a lot of unnecessary work.  When running
> > > nested, this can even cause the L1 to hardly make progress, as the L0
> > > hypervisor it is overwhelmed by the amount of MMU work that is needed.
> > 
> > FWIW, my flushing/zapping series fixes this by doing the teardown in an async
> > worker.  There's even a selftest for this exact case :-)
> > 
> > https://lore.kernel.org/all/20211223222318.1039223-1-seanjc@google.com
> 
> I'll check it out (it's next on my list as soon as I finally push
> kvm/{master,next}, which in turn was blocked by this work).

No rush, I need to spin a new version (rebase, and hopefully drop unnecessarily
complex be3havior).

> But not zapping the roots is even better

No argument there :-)
