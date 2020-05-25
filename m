Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661C41E107F
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390964AbgEYO2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:28:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21977 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390911AbgEYO2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 10:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590416891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZaEIUSBX9tpbhuTtXwt0hPkJYnX8LPVpuC0gCRduKRM=;
        b=TAjphygu3iA4QXwEqmcVdAvkaMtxKjBCasWNZmvtaxkCDxjcWFQ7RHfwNn+UxtTa12QlyI
        jonP9GKchSPd1AlxH4j2xMFigXvTc1f/RT1nsSNdXviNjSkBdJqr8Bq0WOu9eQct+3vpNF
        2e+NeaEBD0m4Od3Auwda8R3MPg/9cvY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-U5_HTt5lPbCJh9cnl5GE8Q-1; Mon, 25 May 2020 10:28:09 -0400
X-MC-Unique: U5_HTt5lPbCJh9cnl5GE8Q-1
Received: by mail-qv1-f71.google.com with SMTP id q11so17397226qvu.13
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 07:28:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZaEIUSBX9tpbhuTtXwt0hPkJYnX8LPVpuC0gCRduKRM=;
        b=BDqgKA+4+LoY1vRFxw/5slISwfWSW2X05o3MI6J2jDM89pjZJbOiQnOOYGHohPfFPf
         vdS84+uxbYlBXjpYTsPLZiHp3zatRiyrIdOHyWJb8RasELwQEtVFix4sJsVo7xOGCVu4
         d5dj2q69ECEjx1uqsM9c83zDRS8YtUx8ODpAoAXg3IlwiUUeFAH8CZDkxc+KYihw7HZb
         EKs6tIXwmWly/oQUAh1i6VV+xTupiKP5hw1wjCvxCfoJPu/U9SmPOs2qyGEmIqX3UlM8
         25wOrEPVDuKH1Ab1TmhOnJJTpmt99fzyXQfJ/abMX8S+c0VOeuuYBK/qVw6ahrycScNv
         Qzxg==
X-Gm-Message-State: AOAM531s9Czvuqto6QuvDaIjEMthrnfGSAnRzphk4q29TBiNb2TggT8l
        OWHrm/Zx8InX7I2k6XviquHU1/RPd1Ddp0ZeKS00BUGBBYt98EpE0mhmKsEc/lq76wTpCC/pJ99
        Pw4GjjphESf2m
X-Received: by 2002:ad4:4e6f:: with SMTP id ec15mr16255162qvb.88.1590416889395;
        Mon, 25 May 2020 07:28:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjb9M4FkYI0U4ICscrcqcpLddToI8iQZDPwlZmFCKNG2Yq4ppAaEqVT0efADo9YCNE/szg8g==
X-Received: by 2002:ad4:4e6f:: with SMTP id ec15mr16255137qvb.88.1590416889166;
        Mon, 25 May 2020 07:28:09 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id h3sm13643021qkl.28.2020.05.25.07.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 07:28:08 -0700 (PDT)
Date:   Mon, 25 May 2020 10:28:06 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com, cai@lca.pw
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200525142806.GC1058657@xz-x1>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
 <159017506369.18853.17306023099999811263.stgit@gimli.home>
 <20200523193417.GI766834@xz-x1>
 <20200523170602.5eb09a66@x1.home>
 <20200523235257.GC939059@xz-x1>
 <20200525122607.GC744@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200525122607.GC744@ziepe.ca>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 09:26:07AM -0300, Jason Gunthorpe wrote:
> On Sat, May 23, 2020 at 07:52:57PM -0400, Peter Xu wrote:
> 
> > For what I understand now, IMHO we should still need all those handlings of
> > FAULT_FLAG_RETRY_NOWAIT like in the initial version.  E.g., IIUC KVM gup will
> > try with FOLL_NOWAIT when async is allowed, before the complete slow path.  I'm
> > not sure what would be the side effect of that if fault() blocked it.  E.g.,
> > the caller could be in an atomic context.
> 
> AFAICT FAULT_FLAG_RETRY_NOWAIT only impacts what happens when
> VM_FAULT_RETRY is returned, which this doesn't do?

Yes, that's why I think we should still properly return VM_FAULT_RETRY if
needed..  because IMHO it is still possible that the caller calls with
FAULT_FLAG_RETRY_NOWAIT.

My understanding is that FAULT_FLAG_RETRY_NOWAIT majorly means:

  - We cannot release the mmap_sem, and,
  - We cannot sleep

But we're allowed to return VM_FAULT_RETRY if any of the above is necessary.

Thanks,

-- 
Peter Xu

