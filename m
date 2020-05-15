Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CA11D544C
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 17:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgEOPW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 11:22:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38304 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726245AbgEOPW5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 11:22:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589556176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HUXlVHVDew6Pt3rQAcFMVAmdI76CZRZY959odxV7XQU=;
        b=UXq6yCSbV8edS0c/m5LOup+pyMPyCO3nhcNPu3tP5azr5s/iR7Vd6Z0DSUb2Uc6AYPjyzW
        yOx/lUPO77OqkSZzcAP08Gbz52KQpOt54OvgboK/0XjfvCj3G8mhxIhJYpjex/xL4EANbF
        uXGxFQ1bZ+7D8kz6ubrdm/SzLRjrM2A=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-ZxKcdo3cM-Gb3WKrztxexw-1; Fri, 15 May 2020 11:22:54 -0400
X-MC-Unique: ZxKcdo3cM-Gb3WKrztxexw-1
Received: by mail-qk1-f199.google.com with SMTP id 14so2537233qkv.16
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 08:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HUXlVHVDew6Pt3rQAcFMVAmdI76CZRZY959odxV7XQU=;
        b=orzYlZ+7bcmfFhUKcXnJ41+x73iGXMhuWK0COsMgdlY5jedDzJoF3HXC7/oUJoVJlc
         2lurw81US4J2XIiUlWxlhoK+Z4Tf4mVQwMfLIXWxu+dJLabXQhGq3yvZhDJcNROcY5Bb
         Ks2JZQIodc+aBEko9NEA99XqwQbK5b9DYTPzSklJTvIy3PPFYdag6ITTy4MqqRhNPADv
         5/TIFMX399oP0FcGgiIXXDgD5NwFhn67zjWUDYZuZrYSoPiPSSwnmAVW09Qufsk4Pl02
         52gJZNl2WkDTrXXMoC/w+zXttpsuV2Cpx0GlnMIfEBMLuQMKlCrhThHzaErwk9X13cS0
         ZPbQ==
X-Gm-Message-State: AOAM533G76aDt6ivP10MDQT7RvnBtStDDfQ25GH2QVtr0rqXALWkqZ28
        Avbzs/fQS7F8eTMMoQzMNA2AUP4Ez3kvswHpiSKq4d5L23pNIAcVNOdi5xP8+mWFQeMI6oU4y2B
        Mf1yNu9r3ITVu
X-Received: by 2002:a37:643:: with SMTP id 64mr3421459qkg.99.1589556174151;
        Fri, 15 May 2020 08:22:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRAwA2xdxuhP8vOOprcU5gdcl4p5EwlfhbJap+VnVrYrharU53VdbVu9YOHDr3i4Xs+InCQA==
X-Received: by 2002:a37:643:: with SMTP id 64mr3421434qkg.99.1589556173861;
        Fri, 15 May 2020 08:22:53 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l133sm1798296qke.105.2020.05.15.08.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 08:22:53 -0700 (PDT)
Date:   Fri, 15 May 2020 11:22:51 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH 0/2] vfio/type1/pci: IOMMU PFNMAP invalidation
Message-ID: <20200515152251.GB499802@xz-x1>
References: <158947414729.12590.4345248265094886807.stgit@gimli.home>
 <20200514212538.GB449815@xz-x1>
 <20200514161712.14b34984@w520.home>
 <20200514222415.GA24575@ziepe.ca>
 <20200514165517.3df5a9ef@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200514165517.3df5a9ef@w520.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 04:55:17PM -0600, Alex Williamson wrote:
> > I'm not if this makes sense, can't we arrange to directly trap the
> > IOMMU failure and route it into qemu if that is what is desired?
> 
> Can't guarantee it, some systems wire that directly into their
> management processor so that they can "protect their users" regardless
> of whether they want or need it.  Yay firmware first error handling,
> *sigh*.  Thanks,

Sorry to be slightly out of topic - Alex, does this mean the general approach
of fault reporting from vfio to the userspace is not gonna work too?

Thanks,

-- 
Peter Xu

