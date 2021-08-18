Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E883F0A43
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 19:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhHRRat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 13:30:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229528AbhHRRar (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 13:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629307811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3V2ZrvsLcLzuD7sXX+tg2QB9Ferqj+fAE5O2aEUKiCI=;
        b=TvGCzr3DxrkMxfs/Nrcw7GvvM47dCGiC+jG1tkm8DgRou0klRNwYIVdt7Qjv7P2mdEC5Qn
        bSX1AiYXsbkECMsCTv/BzjMtMlbA31ArZrrVn18aJg9Yxko5aIHQb/UOUu2sKLVLl97odc
        THo0C0rupOyXX5pefNChXaRsrpFz9zs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-YCwj_B1lMgmoNOcI2BO9Jg-1; Wed, 18 Aug 2021 13:30:10 -0400
X-MC-Unique: YCwj_B1lMgmoNOcI2BO9Jg-1
Received: by mail-wm1-f69.google.com with SMTP id z186-20020a1c7ec30000b02902e6a27a9962so2487275wmc.3
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 10:30:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3V2ZrvsLcLzuD7sXX+tg2QB9Ferqj+fAE5O2aEUKiCI=;
        b=j/w0S2MQ5EKE/Il1PPpp0jgmcjgYgIQwwySYnnT2DFoDfapZW52Q2QdfbPtPnu4CcH
         qyLV5fvh+sIjYI50Kch7UItbRoF5XU6Fc99TMNaRaH8UAEV4O0R1NiiIEvNVi3W7Jfu9
         jX3GzkEzg7ALQyXKjXYj5Ty0PtC/VvfdFSBvzz/lMfEaLT8HTL9CIPQwF73+TMmiGwIl
         DzGB4Cluh9UggaqGfTQpoMTU+x2dloCv87KExoNr3Qmwb0MLhG2vbIx5DoB3xbmwNFL8
         Q4xECOEfYi5msVt9e2ELx/7drwDoY7D3j8To2ZfN4gWGJ3PfIRwR41l3bUHzCSNU/rb2
         Wu6A==
X-Gm-Message-State: AOAM532i2AFoR6tIdt+uiLgF2yrVTTRgsZ3yFpNK5VZEfEXX6gAm3jz9
        furHvozQOZCeAk+0Q6CAraG4hpiuJhyzyYeuxppFvwppliw35p0FTdRKNQXhv7nhHohsFs6icpi
        /6W4g7XsuoWHN
X-Received: by 2002:a05:600c:ac3:: with SMTP id c3mr9473686wmr.44.1629307809297;
        Wed, 18 Aug 2021 10:30:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzmPfBQPDy0ZUJqsyhtmeUS8OiI7eZv0t1xVgOPCZgnHHQjQZuX8pJJrZT8RKWF4pulTEoOw==
X-Received: by 2002:a05:600c:ac3:: with SMTP id c3mr9473672wmr.44.1629307809101;
        Wed, 18 Aug 2021 10:30:09 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id 18sm6323242wmv.27.2021.08.18.10.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:30:08 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:30:06 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        tobin@ibm.com, dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <YR1Dnl6kDjsz+gWI@work-vm>
References: <20210816144413.GA29881@ashkalra_ubuntu_server>
 <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
 <20210816151349.GA29903@ashkalra_ubuntu_server>
 <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
 <20210818103147.GB31834@ashkalra_ubuntu_server>
 <f0b5b725fc879d72c702f88a6ed90e956ec32865.camel@linux.ibm.com>
 <YR0nwVPKymrAeIzV@work-vm>
 <8ae11fca26e8d7f96ffc7ec6353c87353cadc63a.camel@linux.ibm.com>
 <YR0qoV6tDuVxddL5@work-vm>
 <8a94ce57b4aa28df1504dcf08aace88d594ffb32.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a94ce57b4aa28df1504dcf08aace88d594ffb32.camel@linux.ibm.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* James Bottomley (jejb@linux.ibm.com) wrote:
> On Wed, 2021-08-18 at 16:43 +0100, Dr. David Alan Gilbert wrote:
> > * James Bottomley (jejb@linux.ibm.com) wrote:
> [...]
> > > Given the lack of SMI, we can't guarantee that with plain SEV and
> > > -ES. Once we move to -SNP, we can use VMPLs to achieve this.
> > 
> > Doesn't the MH have access to different slots and running on separate
> > vCPUs; so it's still got some separation?
> 
> Remember that the OVMF code is provided by the host, but its attested
> to and run by the guest.  Once the guest takes control (i.e. after OVMF
> boots the next thing), we can't guarantee that it wont overwrite the MH
> code, so the host must treat the MH as untrusted.

Yeh; if it's in a romimage I guess we could write protect it?
(Not that I'd trust it still)

> > > But realistically, given the above API, even if the guest is
> > > malicious, what can it do?  I think it's simply return bogus pages
> > > that cause a crash on start after migration, which doesn't look
> > > like a huge risk to the cloud to me (it's more a self destructive
> > > act on behalf of the guest).
> > 
> > I'm a bit worried about the data structures that are shared between
> > the migration code in qemu and the MH; the code in qemu is going to
> > have to be paranoid about not trusting anything coming from the MH.
> 
> Given that we have to treat the host MH structure as untrusted, this is
> definitely something we have to do.  Although the primary API is simply
> "here's a buffer, please fill it", so there's not much checking to do,
> we just have to be careful that we don't expose any more of the buffer
> than the guest needs to write to ... and, obviously, clean it before
> exposing it to the guest.

I was assuming life got a bit more complicated than that; and we had
to have lists of pages we were requesting, and a list of pages that were
cooked and the qemu thread and the helper thread all had to work in
parallel.  So I'm guessing some list or bookkeeeping that we need to be
very careful of.

Dave

> James
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

