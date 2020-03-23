Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139DF18FB13
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 18:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgCWROE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 13:14:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:25991 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726987AbgCWROE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 13:14:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584983643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=anWzOdOgydkXrVKrOdnLEoUCtM0RcJIym3nCiuRJjrM=;
        b=JJEmfeHnnYPCj6ztzd9VODLMJdpR6rombwaC3ORLRaYRqUIctKi+q9UW7MrdjkLQlLQWHV
        8K35g/x0i+3m2ygdUZHbGWdyfNX4yrHu/HBP+GyrlSZdq0pcWxtzic8iN4Z1fJY34lPwr/
        jiM+vrW6FNk6bIyFCY+IJapyYeAlXuA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-fZuwqPc5OYaFFrJGXLmLFg-1; Mon, 23 Mar 2020 13:14:02 -0400
X-MC-Unique: fZuwqPc5OYaFFrJGXLmLFg-1
Received: by mail-wm1-f70.google.com with SMTP id p18so63310wmk.9
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 10:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=anWzOdOgydkXrVKrOdnLEoUCtM0RcJIym3nCiuRJjrM=;
        b=bNYiMqA/ruCK+0JHjIr2FxTqS4O5ShYQ+vBrFBZ57NWpA9Kanw4Odass5KKbjC6+Ac
         Ez58e9J1ardljOwPDfhn6bDrDj8nZuhhl+3nKlzpwD4aKsyHXeUdWjvT66KwBtznF/NM
         S9bzHZ6tZ7UqJQ/uI1gqgT6pb5OdefwxqA3Aqd1GeedfmsXoh4nN16g/KDbeOZ3NSqsE
         Tt+5m4TazY6ETJswVf9/p1cCQQH4rIqtKz4btbyP30pisuit75+z8pBPGqcaHKaTNlkG
         ISEs6f4X/wN8DdPAw0et8CPxFwLj1tUy447bpm0ECUKhjc5f3n2j2AI8hqSHvDP4TN1D
         pFNg==
X-Gm-Message-State: ANhLgQ1OGAzoIzd9m+Ed2xTfoxksk59rrAZ1MCpJzmH3xL0Yd5m056ew
        XBvPN6TA2Mcg7uBy0WmyUsUNhfiyrHImboPHdlgnT3H+4bVeaQyYPxZdT9+SXQjSd8kcT8QtZfI
        jkgsCMfTzQN7O
X-Received: by 2002:a1c:6608:: with SMTP id a8mr257456wmc.113.1584983639173;
        Mon, 23 Mar 2020 10:13:59 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtFs4cMXB58aHkd+sJ2rJvzjNXQnaBV17W4ys2qEcHxMUKHMNNVjeSlWnIw66VFZcu5zRYmXA==
X-Received: by 2002:a1c:6608:: with SMTP id a8mr257428wmc.113.1584983638901;
        Mon, 23 Mar 2020 10:13:58 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id a192sm306901wme.5.2020.03.23.10.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 10:13:58 -0700 (PDT)
Date:   Mon, 23 Mar 2020 13:13:53 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200323171353.GL127076@xz-x1>
References: <20200318163720.93929-1-peterx@redhat.com>
 <20200318163720.93929-4-peterx@redhat.com>
 <20200321192211.GC13851@linux.intel.com>
 <20200323145824.GI127076@xz-x1>
 <20200323154216.GG28711@linux.intel.com>
 <20200323162617.GK127076@xz-x1>
 <20200323165551.GS28711@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200323165551.GS28711@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 09:55:51AM -0700, Sean Christopherson wrote:
> On Mon, Mar 23, 2020 at 12:26:17PM -0400, Peter Xu wrote:
> > On Mon, Mar 23, 2020 at 08:42:16AM -0700, Sean Christopherson wrote:
> > > > > Regarding the HVA, it's a bit confusing saying that it's guaranteed to be
> > > > > valid, and then contradicting that in the second clause.  Maybe something
> > > > > like this to explain the GPA->HVA is guaranteed to be valid, but the
> > > > > HVA->HPA is not.
> > > > >  
> > > > > /*
> > > > >  * before use.  Note, KVM internal memory slots are guaranteed to remain valid
> > > > >  * and unchanged until the VM is destroyed, i.e. the GPA->HVA translation will
> > > > >  * not change.  However, the HVA is a user address, i.e. its accessibility is
> > > > >  * not guaranteed, and must be accessed via __copy_{to,from}_user().
> > > > >  */
> > > > 
> > > > Sure I can switch to this, though note that I still think the GPA->HVA
> > > > is not guaranteed logically because the userspace can unmap any HVA it
> > > > wants..
> > > 
> > > You're conflating the GPA->HVA translation with the validity of the HVA,
> > > i.e. the HVA->HPA and/or HVA->VMA translation/association.  GPA->HVA is
> > > guaranteed because userspace doesn't have access to the memslot which
> > > defines that transation.
> > 
> > Yes I completely agree if you mean the pure mapping of GPA->HVA.
> > 
> > I think it's a matter of how to define the "valid" when you say
> > "guaranteed to remain valid", because I don't think the mapping is
> > still valid from the most strict sense if e.g. the backing HVA does
> > not exist any more for that GPA->HVA mapping, then the memslot won't
> > be anything useful.
> 
> Yes.  That's why my proposed comment is worded to state that the _memslot_
> will remain valid.  It deliberately avoids mentioning "valid HVA".

OK, I see the point.  I did re-read the two versions again, I agree
yours is better, which I'll replace with.  Thanks!

-- 
Peter Xu

