Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF75611F2C7
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 17:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfLNQ0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 11:26:55 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26728 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbfLNQ0z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Dec 2019 11:26:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576340814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xTCcQEsnViYyDThiiPsB7XBVprrCPkwPyCcp1A4bdWA=;
        b=ROK3OVIuTSSDpPYT9RhX9tbgclPp8icv2RAfFDlEDd9tMnh/XItkxCFltQ2l03Dzgzg84b
        srH1Q9raXNwdf/yxwdxqz/tv0RfWC5zhlutLVQeRHhBN6yL2egVwPiVO/5nQ/sRrFuBMRS
        VGE04I7NFiYsao5W6RSTZdDiRp2gsuE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-Sgu-s1ZEPvOwHIwELQDdMA-1; Sat, 14 Dec 2019 11:26:47 -0500
X-MC-Unique: Sgu-s1ZEPvOwHIwELQDdMA-1
Received: by mail-qv1-f70.google.com with SMTP id v17so1971169qvi.3
        for <kvm@vger.kernel.org>; Sat, 14 Dec 2019 08:26:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xTCcQEsnViYyDThiiPsB7XBVprrCPkwPyCcp1A4bdWA=;
        b=oL4d4VUN8wcHiRfrvSLJdjgtB+TijvuMXws520MG4OfBxKqrZOadIlinBm3N6XVNYx
         v8kfLU2iLMZMR9qWS1ZqZMk1zp4H57IaG9ZH2XheNJbPeziHQgDAsYBLArVbK06bJC99
         xzg+MOnmRvRyZhRh2mhv2wA+6/rQL/Dhe87yEMnX+Ku7700mieSQZReCL2sVJWjYPlYj
         92ie0eHtRR74HBW1RmMZAZ0asUTBZsNLIALgbdd1TsDiLKYIKyVP10TDJ3/jlNgIXAzT
         CgZWoMJuWMo9aBiXV5CwgDaBeEE1y837ZE4F35ujI0W6DQBfVF3zZ60svm+f66VAMnMZ
         18jQ==
X-Gm-Message-State: APjAAAUgKdMHDkQ0NbPNZ93+9xBho0azYlh+rFokCNBjB97wbwoyj96Q
        kNEMUEmeq1mOdPSW6ArtGLJ5zl4UsQ3kQ0k+kc9eLAClzo6Y91WjW+UnUqaaiJSGT5C9CiWqKIi
        gscCfksgqlAKq
X-Received: by 2002:a05:620a:1265:: with SMTP id b5mr19414254qkl.172.1576340807180;
        Sat, 14 Dec 2019 08:26:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqwA2tHOzVlmpWM+CIZirOCbes2W7tLaOKsaXQYrNj6bJsXvt9XDex8gVHvcT7KB17uqRPfWdg==
X-Received: by 2002:a05:620a:1265:: with SMTP id b5mr19414237qkl.172.1576340806921;
        Sat, 14 Dec 2019 08:26:46 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id z141sm2911860qkb.63.2019.12.14.08.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 08:26:46 -0800 (PST)
Date:   Sat, 14 Dec 2019 11:26:44 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191214162644.GK16429@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 14, 2019 at 08:57:26AM +0100, Paolo Bonzini wrote:
> On 13/12/19 21:23, Peter Xu wrote:
> >> What is the benefit of using u16 for that? That means with 4K pages, you
> >> can share at most 256M of dirty memory each time? That seems low to me,
> >> especially since it's sufficient to touch one byte in a page to dirty it.
> >>
> >> Actually, this is not consistent with the definition in the code ;-)
> >> So I'll assume it's actually u32.
> > Yes it's u32 now.  Actually I believe at least Paolo would prefer u16
> > more. :)
> 
> It has to be u16, because it overlaps the padding of the first entry.

Hmm, could you explain?

Note that here what Christophe commented is on dirty_index,
reset_index of "struct kvm_dirty_ring", so imho it could really be
anything we want as long as it can store a u32 (which is the size of
the elements in kvm_dirty_ring_indexes).

If you were instead talking about the previous union definition of
"struct kvm_dirty_gfns" rather than "struct kvm_dirty_ring", iiuc I've
moved those indices out of it and defined kvm_dirty_ring_indexes which
we expose via kvm_run, so we don't have that limitation as well any
more?

-- 
Peter Xu

