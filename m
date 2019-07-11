Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C5564FCE
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 03:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfGKBNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 21:13:19 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37257 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfGKBNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 21:13:18 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so1918396pfa.4
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 18:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RVtvtLW+hA55JDckJ1iLViBZ1ankqgmMr3VovL92Bc4=;
        b=ommTR3wmF5ms6iGM5yq1rC7CW0jqLJugYi5jz2Y3bEi+IRq/6VGKn2J1IRcnoVOHAZ
         3BgV67mm4SCO/N8vubdt3hfVET1e7+rNxvcqNdHE/EIk/toTV7vcPOBOkNSFuL1y9JHr
         J7VGB2LyHLgkEbpP0/LbMWBAu3RHWeS+JEA8lJxze8Xg8qYSMVErCOBGoPhs1KPdj+1H
         Wd+iphfmoYsmCR0LaFH05LIBWzkyXc6gP6aGlbUwtU6ZuNaorw8tUmTtpVPSe4s3Wbru
         Jpb1rqm+3KO53O7LhcgpLPgFnJWaPoSG2vB4jVR2Qjypo6TfDBJ9eTMUFIzHUNvPCSh4
         pPOw==
X-Gm-Message-State: APjAAAXsLGsHaTz92lx8RAlBQROG2WhLK7ud3GCbYhQ2uCSL8ppDg1v4
        sxr5sAgv0c+dUd0mbGojEn8pOA==
X-Google-Smtp-Source: APXvYqxMrVVklNqbVKOTAv5bfnU/VrZIKRnGvwuMCvMVJRLDiPbKxiptG5r1+GRR16h0APaabi9Mew==
X-Received: by 2002:a63:ad07:: with SMTP id g7mr1203863pgf.405.1562807598198;
        Wed, 10 Jul 2019 18:13:18 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f14sm3326411pfn.53.2019.07.10.18.13.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 18:13:16 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Thu, 11 Jul 2019 09:13:05 +0800
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Peter Xu <zhexu@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 06/18] intel_iommu: support virtual command emulation
 and pasid request
Message-ID: <20190711011305.GJ5178@xz-x1>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-7-git-send-email-yi.l.liu@intel.com>
 <20190709031902.GD5178@xz-x1>
 <A2975661238FB949B60364EF0F2C257439F2A65F@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C257439F2A65F@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 11:51:17AM +0000, Liu, Yi L wrote:

[...]

> > > +        s->vcrsp = 1;
> > > +        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
> > > +                         ((uint64_t) s->vcrsp));
> > 
> > Do we really need to emulate the "In Progress" like this?  The vcpu is
> > blocked here after all, and AFAICT all the rest of vcpus should not
> > access these registers because obviously these registers cannot be
> > accessed concurrently...
> 
> Other vcpus should poll the IP bit before submitting vcmds. As IP bit
> is set, other vcpus will not access these bits. but if not, they may submit
> new vcmds, while we only have 1 response register, that is not we
> support. That's why we need to set IP bit.

I still don't think another CPU can use this register even if it
polled with IP==0...  The reason is simply as you described - we only
have one pair of VCMD/VRSPD registers so IMHO the guest IOMMU driver
must have a lock (probably a mutex) to guarantee sequential access of
these registers otherwise race can happen.

> 
> > 
> > I think the IP bit is useful when some new vcmd would take plenty of
> > time so that we can do the long vcmds in async way.  However here it
> > seems not the case?
> 
> no, so far, it is synchronize way. As mentioned above, IP bit is to ensure
> only one vcmd is handled for a time. Other vcpus won't be able to submit
> vcmds before IP is cleared.

[...]

> > > @@ -192,6 +198,7 @@
> > >  #define VTD_ECAP_SRS                (1ULL << 31)
> > >  #define VTD_ECAP_PASID              (1ULL << 40)
> > >  #define VTD_ECAP_SMTS               (1ULL << 43)
> > > +#define VTD_ECAP_VCS                (1ULL << 44)
> > >  #define VTD_ECAP_SLTS               (1ULL << 46)
> > >  #define VTD_ECAP_FLTS               (1ULL << 47)
> > >
> > > @@ -314,6 +321,29 @@ typedef enum VTDFaultReason {
> > >
> > >  #define VTD_CONTEXT_CACHE_GEN_MAX       0xffffffffUL
> > >
> > > +/* VCCAP_REG */
> > > +#define VTD_VCCAP_PAS               (1UL << 0)
> > > +#define VTD_MIN_HPASID              200
> > 
> > Comment this value a bit?
> 
> The basic idea is to let hypervisor to set a range for available PASIDs for
> VMs. One of the reasons is PASID #0 is reserved by RID_PASID usage.
> We have no idea how many reserved PASIDs in future, so here just a
> evaluated value. Honestly, set it as "1" is enough at current stage.

That'll be a very nice initial comment for that (I mean, put it into
the patch, of course :).

Regards,

-- 
Peter Xu
