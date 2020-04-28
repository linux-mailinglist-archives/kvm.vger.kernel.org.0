Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EEB1BCD4E
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 22:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgD1UWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 16:22:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24456 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726284AbgD1UWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 16:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588105357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=voGLyeD1WxfVMgEf4Mai58JZB/u+WPmTGh+LxkJS5LU=;
        b=KBkiM90Nb9LnuAeDGFQ4WG7bJFTjEdqdpw+gX1iYMohcLwMT5paGFN5I9BxtA6Kfhfmzuc
        uAoti+sPuCVZAbid7bQuDk8p/v6iLs5DhlBgUXLnjo04WOC7POMqpXt+sY7dgeM96plfE7
        9GSt6qpruf7Gym4CpFKducJ/WAAb9e8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-nv2qFTWwNHKauWqhuzwJ5g-1; Tue, 28 Apr 2020 16:22:31 -0400
X-MC-Unique: nv2qFTWwNHKauWqhuzwJ5g-1
Received: by mail-qk1-f200.google.com with SMTP id z8so24683667qki.13
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 13:22:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=voGLyeD1WxfVMgEf4Mai58JZB/u+WPmTGh+LxkJS5LU=;
        b=Ydkcnzz2EpekAkIhi5d0+5UOH66RWGpzjDiU7nT9Ob+DnKgcOksJI02jNSmjnl3XbT
         ajdsuIe1n+GsOnJ5iZ07BYcI3zsfHX9ktkqkrVFSfHs0pfRPvsP7eh7CnIKIr27OtZj1
         0pTvupIP8J5KzJAFJpktnnbvbUxUvmWrEGw46Q5Z67l8ONW6f5/6jJqaF3FmNRm83Vkv
         Voq3CKcIhLRuLW/asD/egzKaqA/V9KIyT54TrppcWwVufx1gP1VGwWU0PkZXInnCLSGY
         Pf8nQ2Ux75RLF9bh2nEvtOBZV9xdNOK0n3MywCz9s9Xdm3/+8gV97Hrq5ok/RjUiUnJ8
         maLA==
X-Gm-Message-State: AGi0PuYM1g25ZPs+kNuG1ebcwmvCD1mheLi4+UnYRyskH9S9ANUkfsDZ
        oBga8RcH+BY39/DZy9DVcxBuCTBheayC5jIcaAiXXu7JpaJ+Y/ExDz/+6Qg/iBHsUS8doNolKIJ
        XnqMySHherXn6
X-Received: by 2002:a37:66d8:: with SMTP id a207mr28461420qkc.127.1588105351221;
        Tue, 28 Apr 2020 13:22:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypK+LsYsK4GPD3bREyTNhokuLO2gi/E05ejK2hXFbJea8Bo086oicUgNv17RFKAAPIkQ+byHkg==
X-Received: by 2002:a37:66d8:: with SMTP id a207mr28461388qkc.127.1588105350974;
        Tue, 28 Apr 2020 13:22:30 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id x24sm14925754qth.80.2020.04.28.13.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 13:22:30 -0700 (PDT)
Date:   Tue, 28 Apr 2020 16:22:28 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v8 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200428202228.GB4280@xz-x1>
References: <20200331190000.659614-1-peterx@redhat.com>
 <20200331190000.659614-4-peterx@redhat.com>
 <20200423203944.GS17824@linux.intel.com>
 <20200424152151.GB41816@xz-x1>
 <20200427181054.GL14870@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200427181054.GL14870@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 11:10:54AM -0700, Sean Christopherson wrote:

[...]

> > It will "return (0xdeadull << 48)" as you proposed in abbed4fa94f6? :-)
> > 
> > Frankly speaking I always preferred zero but that's just not true any more
> > after above change.  This also reminded me that maybe we should also return the
> > same thing at [1] below.
> 
> Ah, I was looking at this code:
> 
> 	if (!slot || !slot->npages)
> 		return 0;
> 
> That means deletion returns different success values for "deletion was a
> nop" and "deletion was successful".  The nop path should probably return
> (or fill in) "(unsigned long)(0xdeadull << 48)" as well.

Yep.  Since I touched the line here after all, I'll directly squash this small
fix into this patch too when I repost.  Thanks,

[...]

> > > 
> > > >  	} else {
> > > >  		if (!slot || !slot->npages)
> > > > -			return 0;
> > > > +			return ERR_PTR_USR(0);
> > 
> > [1]

-- 
Peter Xu

