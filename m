Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5144D411744
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 16:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbhITOk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 10:40:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231792AbhITOk6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 10:40:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632148771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nhpibeqk4PvPTYyqOpXGwb8TL8EsN3x82upWewR9w28=;
        b=QPHdNAE5bGOXNbo1icr+lQmrrVxSlR7FO0z+zKfTuHRAfkOi4t3yMrYFDreYPmls+ScmUI
        LKUXe9uQ/S4sJ9bKbiVBL5rrTyihGpQunLG2+EbvdqQpGwo5Msm7LtUT8KKhgi25A/ZV6F
        +L1uT5zspjutn0DnARlrr2fgJi+vL5A=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-r6jX3BEPNqel-tPt_VEEBA-1; Mon, 20 Sep 2021 10:39:30 -0400
X-MC-Unique: r6jX3BEPNqel-tPt_VEEBA-1
Received: by mail-qk1-f198.google.com with SMTP id bl32-20020a05620a1aa000b004330d29d5bfso61505016qkb.23
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nhpibeqk4PvPTYyqOpXGwb8TL8EsN3x82upWewR9w28=;
        b=YPardJnPCt/j52j+L2F33KFg/qyqSMh/OKP9qBBrfBCS235BMXNI0TLTUVMm67s4ei
         cMq9QH1E2nfvOhELpPHbJoM0F0XNEo1OYfZTa0WSwo+xgSePzljS4eDdwNM3K4ZzxH3J
         llfHqf6t7ymj+EBtOtr7p7FdfipCPl93DiZjZKDSX0jg03QL1nZEeDZ2uw9/j9c2JJHo
         KkocymOCxFNEWdMlCutgMLOh5X0F/mkNqYPAGGylqAPhpb8EHcru3/LqVUPz4NsXlVk0
         xjAM4e3GRWt31I4Do0QaMN1QwdMHttl0eFCFHHf55tgWrN8vwZL93aO4OXjaurcIBIjv
         QyFw==
X-Gm-Message-State: AOAM532E8Mmwu0CKdxQ6aESodBXL9dZaochxifmQyFH9rakSOBvWFhAP
        eiS/GnaAAh9e/+fF4CZJkdqhQ2GJmtRTL1rXsY1IE0hTVnEsT+TO+xHwitQy6iYH1tgmqGkLZM8
        LYsXgGfnH19zY
X-Received: by 2002:a05:620a:cd0:: with SMTP id b16mr24832170qkj.136.1632148769855;
        Mon, 20 Sep 2021 07:39:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxB2Y7T7b4bSWSVgRi7HdyZbRCph2nN2tQ4jNT1Sag+Z5mGiiad+h22+bslkc/EIiCd4pdyg==
X-Received: by 2002:a05:620a:cd0:: with SMTP id b16mr24832151qkj.136.1632148769680;
        Mon, 20 Sep 2021 07:39:29 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id n20sm11509869qkk.135.2021.09.20.07.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:39:28 -0700 (PDT)
Date:   Mon, 20 Sep 2021 16:39:24 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: REGRESSION: Upgrading host kernel from 5.11 to 5.13 breaks QEMU
 guests - perf/fw_devlink/kvm
Message-ID: <20210920143924.zh3zb7gf7wmd2uyx@gator>
References: <YUYRKVflRtUytzy5@shell.armlinux.org.uk>
 <877dfcwutt.wl-maz@kernel.org>
 <YUhYNnwaTt+5oMzh@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUhYNnwaTt+5oMzh@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021 at 10:45:26AM +0100, Russell King (Oracle) wrote:
> On Sun, Sep 19, 2021 at 02:36:46PM +0100, Marc Zyngier wrote:
> > Urgh. That's a bummer. T1he PMU driver only comes up once it has found
> > its interrupt controller, which on the Armada 8040 is not the GIC, but
> > some weird thing on the side that doesn't actually serve any real
> > purpose. On HW where the PMU is directly wired into the GIC, it all
> > works fine, though by luck rather than by design.
> > 
> > Anyway, rant over. This is a bug that needs addressing so that KVM can
> > initialise correctly irrespective of the probing order. This probably
> > means that the static key controlling KVM's behaviour wrt the PMU must
> > be controlled by the PMU infrastructure itself, rather than KVM trying
> > to probe for it.
> > 
> > Can you please give the following hack a go (on top of 5.15-rc1)? I've
> > briefly tested it on my McBin, and it did the trick. I've also tested
> > it on the M1 (which really doesn't have an architectural PMU) to
> > verify that it was correctly failing.
> 
> My test program that derives the number of registers qemu uses now
> reports 236 registers again and I see:

Hi Russell,

You may be interested in kvm selftests and this one[1] in particular.

[1] tools/testing/selftests/kvm/aarch64/get-reg-list.c

Thanks,
drew


> 
> kvm [7]: PMU detected and enabled
> 
> in the kernel boot log.
> 
> Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

