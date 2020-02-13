Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2576515C05D
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 15:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgBMObR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 09:31:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26936 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgBMObR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Feb 2020 09:31:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581604277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H2iZA/EjBmlcJxLGlNtElex77R9i5KIlucE+aasVj8E=;
        b=WakBBIW0zvBAJ+M2BKLWUarouRVwVXgE+LyaumdwaaTvmp/biT6S+OrxCxqV6YovdBhwkv
        axAVL3HizH1JOZRLUfn/sPuHrUn1t0J9BYZ8bHTWq0LTfV2BeStOOpdWcqM6vHW8TBA04U
        tOf0puD4ZSwykhY37beWH8G7CvffcqM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-SEj7MRKJP6qrg9iRAeUUew-1; Thu, 13 Feb 2020 09:31:14 -0500
X-MC-Unique: SEj7MRKJP6qrg9iRAeUUew-1
Received: by mail-qk1-f199.google.com with SMTP id 12so3814625qkf.20
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 06:31:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H2iZA/EjBmlcJxLGlNtElex77R9i5KIlucE+aasVj8E=;
        b=HREezBWgBwaGrG1t6Tyhn5XV8r7HvqBn+CGtYygAUxUmPI0NMPiWCx3y1QZzWBBvEo
         3jkUBqKAcp34v5y5A7kTO1vkgsMhgjVX58jYiIlc1BfW91fFWWJgVliErhDuigw98RDf
         jgFnjmUWo8djNP133snh1xlz3OiEKzGfNZSvQtEc7J3tYtKAoBDsG1fC0GdSvpn4Mgpo
         LzvyGiCSxOaHZQFYLyIc/xO8GkefQ07U5Wmmp9VXTb6tDOGxpf1I9AddwKgFxVbxdR8g
         oaKicGyjpSsH0z629JHem/3VfNvEkYCQSEcsPcEzlVD7YEZXmFBWqAKDyjtlV4H3ussX
         4B+A==
X-Gm-Message-State: APjAAAU7ReWFPqp7Yo3P4p1dMjVb8h6wPJYbDeQfugULST0Vo9Y0gIvo
        pfY9YU/ESlwSlKAuMN/xVn2cI325kgvvanUapmevYkQ71aoLpEypnFlAgIWGb5bMt1hRyOk02WY
        vQ8IQgN38Ocyw
X-Received: by 2002:a05:620a:2194:: with SMTP id g20mr12410543qka.227.1581604274536;
        Thu, 13 Feb 2020 06:31:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqxCnsR5FnTgRpYraPOQNFn5JMYoRRe4NWXIkIMt3XhtrK99IdkD46xnA0clVscK4ouGtCvpXA==
X-Received: by 2002:a05:620a:2194:: with SMTP id g20mr12410505qka.227.1581604274188;
        Thu, 13 Feb 2020 06:31:14 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id 8sm1422500qkm.92.2020.02.13.06.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 06:31:13 -0800 (PST)
Date:   Thu, 13 Feb 2020 09:31:10 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v3 14/25] intel_iommu: add virtual command capability
 support
Message-ID: <20200213143110.GA1103216@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-15-git-send-email-yi.l.liu@intel.com>
 <20200211215630.GN984290@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BBBF4@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1BBBF4@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 02:40:45AM +0000, Liu, Yi L wrote:
> > From: Peter Xu <peterx@redhat.com>
> > Sent: Wednesday, February 12, 2020 5:57 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v3 14/25] intel_iommu: add virtual command capability support
> > 
> > On Wed, Jan 29, 2020 at 04:16:45AM -0800, Liu, Yi L wrote:
> > > +/*
> > > + * The basic idea is to let hypervisor to set a range for available
> > > + * PASIDs for VMs. One of the reasons is PASID #0 is reserved by
> > > + * RID_PASID usage. We have no idea how many reserved PASIDs in future,
> > > + * so here just an evaluated value. Honestly, set it as "1" is enough
> > > + * at current stage.
> > > + */
> > > +#define VTD_MIN_HPASID              1
> > > +#define VTD_MAX_HPASID              0xFFFFF
> > 
> > One more question: I see that PASID is defined as 20bits long.  It's
> > fine.  However I start to get confused on how the Scalable Mode PASID
> > Directory could service that much of PASID entries.
> > 
> > I'm looking at spec 3.4.3, Figure 3-8.
> > 
> > Firstly, we only have two levels for a PASID table.  The context entry
> > of a device stores a pointer to the "Scalable Mode PASID Directory"
> > page. I see that there're 2^14 entries in "Scalable Mode PASID
> > Directory" page, each is a "Scalable Mode PASID Table".
> > However... how do we fit in the 4K page if each entry is a pointer of
> > x86_64 (8 bytes) while there're 2^14 entries?  A simple math gives me
> > 4K/8 = 512, which means the "Scalable Mode PASID Directory" page can
> > only have 512 entries, then how the 2^14 come from?  Hmm??
> 
> I checked with Kevin. The spec doesn't say the dir table is 4K. It says 4K
> only for pasid table. Also, if you look at 9.4, scalabe-mode context entry
> includes a PDTS field to specify the actual size of the directory table.

Ah I see.  Then it seems to be lost then in this series.  Say, I think
vtd_sm_pasid_table_walk() should also stop walking until reaching the
size there, and you need to fetch that size info from the context
entry before walk starts.

> 
> > Apart of this: also I just noticed (when reading the latter part of
> > the series) that the time that a pasid table walk can consume will
> > depend on this value too.  I'd suggest to make this as small as we
> > can, as long as it satisfies the usage.  We can even bump it in the
> > future.
> 
> I see. This looks to be an optimization. right? Instead of modify the
> value of this macro,  I think we can do this optimization by tracking
> the allocated PASIDs in QEMU. Thus, the pasid table walk  would be more
> efficient and also no dependency on the VTD_MAX_HPASID. Does it make
> sense to you? :-)

Yeah sounds good. :)

Thanks,

-- 
Peter Xu

