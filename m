Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A52AFD51
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 15:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfIKNDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 09:03:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbfIKNDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 09:03:17 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 778A7369D3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 13:03:17 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id m6so23576579qtk.23
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 06:03:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/sfNjqGMZWLcI3m0N4VrOWVEum1o031nknNQPF2WES8=;
        b=AZgsxcqdlLySzoZdVj+KnPlmx09UVivw4TfvQJ9DGF1aXo65uyr6tEHvUtMhjoAF3h
         YEibG37h23TnulU5T6wNLy/dlah3MsqXLyyr/Q6UAoogRja2QvQLsbqu9VffTLB4mGsp
         ktSdP+j+c3spuKZ6EXJtO7bldBKMI+3aPiHiTDICp0vMHswUTlkSgsDyr0Ua1ijvt3gh
         cubliojJa22vKGkh+qjXUWCoNp9oQjGdpf4KVRbXkD4l/RpFuE7Qq/4zv7wBSV/hBfsY
         J4sGCIytVOaEZa+iFfbKlE4z99qcfV+JEMg7cfqRJ5E8DLRhZp+4xgm1HmpuUfytuhaF
         3rnw==
X-Gm-Message-State: APjAAAVVAd+EKBDasliWlGGf8Ix8uhzOYbIfCBU2TYpNm+Bv7guSaE5C
        iyLND5uOoAHb1eXFmp/Hgkk5JHdqPMegFKWnZTuE0LtUfcbsqetNcmuK/dwzmc0uYY6DkFFUgZI
        B1cwjFhXucMh7
X-Received: by 2002:ac8:7242:: with SMTP id l2mr35745596qtp.4.1568206996777;
        Wed, 11 Sep 2019 06:03:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwmsmhjoHJTb7z6oORqOFoKPWxTBsyQouHREJ+8K5GPemL48MacSn+bJagBRzKL996ErgPJyA==
X-Received: by 2002:ac8:7242:: with SMTP id l2mr35745571qtp.4.1568206996537;
        Wed, 11 Sep 2019 06:03:16 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id v2sm6615278qtv.22.2019.09.11.06.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 06:03:15 -0700 (PDT)
Date:   Wed, 11 Sep 2019 09:03:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] vhost: block speculation of translated descriptors
Message-ID: <20190911085807-mutt-send-email-mst@kernel.org>
References: <20190911120908.28410-1-mst@redhat.com>
 <20190911121628.GT4023@dhcp22.suse.cz>
 <20190911082236-mutt-send-email-mst@kernel.org>
 <20190911123316.GX4023@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911123316.GX4023@dhcp22.suse.cz>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 11, 2019 at 02:33:16PM +0200, Michal Hocko wrote:
> On Wed 11-09-19 08:25:03, Michael S. Tsirkin wrote:
> > On Wed, Sep 11, 2019 at 02:16:28PM +0200, Michal Hocko wrote:
> > > On Wed 11-09-19 08:10:00, Michael S. Tsirkin wrote:
> > > > iovec addresses coming from vhost are assumed to be
> > > > pre-validated, but in fact can be speculated to a value
> > > > out of range.
> > > > 
> > > > Userspace address are later validated with array_index_nospec so we can
> > > > be sure kernel info does not leak through these addresses, but vhost
> > > > must also not leak userspace info outside the allowed memory table to
> > > > guests.
> > > > 
> > > > Following the defence in depth principle, make sure
> > > > the address is not validated out of node range.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > Tested-by: Jason Wang <jasowang@redhat.com>
> > > 
> > > no need to mark fo stable? Other spectre fixes tend to be backported
> > > even when the security implications are not really clear. The risk
> > > should be low and better to be covered in case.
> > 
> > This is not really a fix - more a defence in depth thing,
> > quite similar to e.g.  commit b3bbfb3fb5d25776b8e3f361d2eedaabb0b496cd
> > x86: Introduce __uaccess_begin_nospec() and uaccess_try_nospec
> > in scope.
> >
> > That one doesn't seem to be tagged for stable. Was it queued
> > there in practice?
> 
> not marked for stable but it went in. At least to 4.4.

So I guess the answer is I don't know. If you feel it's
justified, then sure, feel free to forward.

-- 
MST
