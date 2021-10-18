Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4E4431660
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 12:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhJRKrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 06:47:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhJRKrV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 06:47:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634553910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1uyCEHCiTKNcqpUO1aFErGSv7mBpXKpc6cxyusKebck=;
        b=VDwMAlHPj1TREGSw72d4kTXjfN2/5GmI34suUagaQBI0tLgcwhnP4WVpVwVjBYz6rl4YdE
        z7nVKQUrIRG9/WUw+vTH/CuR6X6/FDPO1RqxlFxrNeCfWN6E2ubAxqFR/9VUYfwbHLvh6F
        wGI97KZKDVCIZuAOiZ9WdY0vKGZ5TBc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-XJBqRd8lNvCB--96gauK5w-1; Mon, 18 Oct 2021 06:45:09 -0400
X-MC-Unique: XJBqRd8lNvCB--96gauK5w-1
Received: by mail-ed1-f70.google.com with SMTP id e14-20020a056402088e00b003db6ebb9526so13898436edy.22
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 03:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1uyCEHCiTKNcqpUO1aFErGSv7mBpXKpc6cxyusKebck=;
        b=aiUwYOlvp3Q6E234ZEuTrxcxIlyTq9HbXMI2Z3gsNLYwEv92IN1qe1ZLTVF2AOMeVs
         ATIkGTG2jrbvmiB8aG+amog47COcBbUHnymnKOSQ5NxlrruvdjmTz47DNayjL0jVVpIb
         +oVmD8NGJZfC3bZq2cfZYerRmUzGXNocxK55etD7F7VyhQ6tkjqCMRCiDfNjLp4pThei
         e0Dbsjbj/KMQMvALro6NpCJK+j0NXZTzGqgUi5+XYuhintgveOoEZOfQ0DFD04WuxI0u
         5Ag5DV5W1G72QWXCRNCEdOgEGM/p3tAsP/GHdMitvAIiaRsuviQgldzxVf0b/qZIZV7R
         LOjA==
X-Gm-Message-State: AOAM5300qUYKOAP5dhaz/+ho3pxXjQ+Dhrln4LPtigc2bH4St8bSooOZ
        I7CgM8QpQ+Yk2bLW6pn2ZOehRhVo2g+L+BeCOGze1LsHid0gfpawZlrgxo3rgL2ZRZBahG26E8f
        t+S95w8QbIsxQ
X-Received: by 2002:a17:906:2606:: with SMTP id h6mr29039225ejc.301.1634553907940;
        Mon, 18 Oct 2021 03:45:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0/tbTFUMN7jqyIWaGL6Z8CJvBwotkH9WB6m3QCyklG9WBS81dg1B+4X6yxbU7dGtDKT0pcQ==
X-Received: by 2002:a17:906:2606:: with SMTP id h6mr29039202ejc.301.1634553907748;
        Mon, 18 Oct 2021 03:45:07 -0700 (PDT)
Received: from gator.home (cst2-174-2.cust.vodafone.cz. [31.30.174.2])
        by smtp.gmail.com with ESMTPSA id v13sm10285018edl.69.2021.10.18.03.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 03:45:07 -0700 (PDT)
Date:   Mon, 18 Oct 2021 12:45:05 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        oupton@google.com, qperret@google.com, kernel-team@android.com
Subject: Re: [PATCH v9 00/22] KVM: arm64: Fixed features for protected VMs
Message-ID: <20211018104505.52jvpuhxkbstzerg@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <CA+EHjTxBW2fzSk5wMLceRwExqJwXGTtrK1GZ2L6J-Oh9VCDJJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxBW2fzSk5wMLceRwExqJwXGTtrK1GZ2L6J-Oh9VCDJJg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021 at 10:51:54AM +0100, Fuad Tabba wrote:
> Hi Marc,
> 
> On Wed, Oct 13, 2021 at 1:04 PM Marc Zyngier <maz@kernel.org> wrote:
> >
> > This is an update on Fuad's series[1].
> >
> > Instead of going going back and forth over a series that has seen a
> > fair few versions, I've opted for simply writing a set of fixes on
> > top, hopefully greatly simplifying the handling of most registers, and
> > moving things around to suit my own taste (just because I can).
> >
> > I won't be reposting the initial 11 patches, which is why this series
> > in is reply to patch 11.
> 
> Thanks for this series. I've reviewed, built it, and tested it with a
> dummy protected VM (since we don't have proper protected VMs yet),
> which initializes some of the relevant protected VMs metadata as well
> as its control registers. So fwiw:
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> 
> And to whatever extent possible at this stage:
> Tested-by: Fuad Tabba <tabba@google.com>
>

Hi Fuad,

Out of curiosity, when testing pKVM, what VMM do you use? Also, can you
describe what a "dummy pVM" is? Is it a just pVM which is not actually
protected? How similar is a pVM to a typical VIRTIO-using VM? Actually,
maybe I should just ask if there are instructions for playing with pKVM
somewhere that I could get a pointer to.

Thanks,
drew

