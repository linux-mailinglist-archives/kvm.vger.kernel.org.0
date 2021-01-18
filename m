Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3132FA282
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 15:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390824AbhARM0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 07:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390795AbhARLps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:48 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C2EC061757;
        Mon, 18 Jan 2021 03:45:02 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b2so17210925edm.3;
        Mon, 18 Jan 2021 03:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F68vHZ580IjEbmHg81pdR4Mjf0I0Fx2B1vaIOPSVpXY=;
        b=OIyazj+/o5gz9nsKm88Kja7lALX2H7QNfYXU66HQYUAMKaFrIYHhvaaOQgXYOx5xvj
         NbzzlBSw3IdSzjtZncd7bb0ZpnTs0hkgvmwZcTosEDKAqAEXLGlUMz8qZimwymqoFQ75
         Nc45TC+nY9J5ovFBzAdBeyfQKgxURxGdUb6mTL3UHGB7kDjztaFrAqL13ZYwBqCng0Ns
         FSb5Ki+LleZZkPzpBpvmXso/jPIMH7TwqZpYNVZ+qYWAe2eupYGnh8oisKDJ/ZxcP2jb
         U1SFVAEt2zRQ30Rydy9CQF2+3RBXfykTuJ+o5vnUYhHdpOoOU6ET3wuobGsqpmHxCBgC
         +luQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F68vHZ580IjEbmHg81pdR4Mjf0I0Fx2B1vaIOPSVpXY=;
        b=RJuXk0V7DG1VsR1wtpHfvqHCVMvVYuGLeus2SgWSk3xwZXU+jRhoc/aRRoJhtq7EWS
         mKWldrJyWuwI/4rrYerebcVzl7F4hFUZ34WTdowq9nvL4+e/Cxw2YUkW5fd5LYyv/oYu
         uI2vpNOq9RbwKM0ye7IRffbsKAwrSup759Qc0isJkBin6ZbIHiPF0sjbgD+Yzum2swI/
         vhW1jvPw0aZMTSUJxM8BoNlvBLfR/OmjIc5AXwqmjefZJ9ZXpD6tQUDdbYkPoq1CMeka
         plb5J5kiwDXPk6ktL1YGRkQtdM6rnRNUqMpBn9qzOlulr5oMyDw6oH0EQ3jvJWPrfq5h
         3fZQ==
X-Gm-Message-State: AOAM532S07T1gig+K0hJn590hdhPbdHZB+i+JN3CP04wP35G5tWuJuQi
        V/CF5lMfI7vATpbN9ul9vLHyLhCnexDl7SJO
X-Google-Smtp-Source: ABdhPJwqFgxj7V2Do365QrthtC6//2U204yKEYrYTmPS0An7gKR+Zn0Pp1gYvFmzq3svTIMwmF4PMQ==
X-Received: by 2002:a50:e84d:: with SMTP id k13mr18617210edn.154.1610970300844;
        Mon, 18 Jan 2021 03:45:00 -0800 (PST)
Received: from martin (host-88-217-199-52.customer.m-online.net. [88.217.199.52])
        by smtp.gmail.com with ESMTPSA id bn21sm9318373ejb.47.2021.01.18.03.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 03:45:00 -0800 (PST)
Date:   Mon, 18 Jan 2021 12:44:58 +0100
From:   Martin Radev <martin.b.radev@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     konrad.wilk@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, joro@8bytes.org,
        kirill.shutemov@linux.intel.com, thomas.lendacky@amd.com,
        robert.buhren@sect.tu-berlin.de, file@sect.tu-berlin.de,
        mathias.morbitzer@aisec.fraunhofer.de,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] swiotlb: Validate bounce size in the sync/unmap path
Message-ID: <YAV0uhfkimXn1izW@martin>
References: <X/27MSbfDGCY9WZu@martin>
 <20210113113017.GA28106@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113113017.GA28106@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021 at 12:30:17PM +0100, Christoph Hellwig wrote:
> On Tue, Jan 12, 2021 at 04:07:29PM +0100, Martin Radev wrote:
> > The size of the buffer being bounced is not checked if it happens
> > to be larger than the size of the mapped buffer. Because the size
> > can be controlled by a device, as it's the case with virtio devices,
> > this can lead to memory corruption.
> > 
> 
> I'm really worried about all these hodge podge hacks for not trusted
> hypervisors in the I/O stack.  Instead of trying to harden protocols
> that are fundamentally not designed for this, how about instead coming
> up with a new paravirtualized I/O interface that is specifically
> designed for use with an untrusted hypervisor from the start?

Your comment makes sense but then that would require the cooperation
of these vendors and the cloud providers to agree on something meaningful.
I am also not sure whether the end result would be better than hardening
this interface to catch corruption. There is already some validation in
unmap path anyway.

Another possibility is to move this hardening to the common virtio code,
but I think the code may become more complicated there since it would
require tracking both the dma_addr and length for each descriptor.
