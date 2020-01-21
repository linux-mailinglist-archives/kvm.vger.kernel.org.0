Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910FD143836
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 09:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAUI3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 03:29:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22268 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726052AbgAUI3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 03:29:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579595381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lMCuYgplpTFtMdfBdVg8uf0WAbc/YNguxs5ss6B6JTk=;
        b=irVD35SqzFOeBwY5hx7lrery4fxtvflLswMCIm+6kq097RkqzOInyFcekU/RFmhQHUy0eU
        7oXpMFdOv/mzRVb5Gn+88uhNl1r+jlhsfpgm/8LYW1ziE+CDLw/xRnH+fhJpBYjoIWoZ0s
        JQLKvAItc9M2htD/b3O08zQVUglLwAE=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-8IvHKelkMeKZHQ9WXtjH9w-1; Tue, 21 Jan 2020 03:29:39 -0500
X-MC-Unique: 8IvHKelkMeKZHQ9WXtjH9w-1
Received: by mail-pg1-f197.google.com with SMTP id l15so1150006pgk.14
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 00:29:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lMCuYgplpTFtMdfBdVg8uf0WAbc/YNguxs5ss6B6JTk=;
        b=eTc4iAD9Z9ScXDzMiXvjU06M0JqWMBS3reYi3wDGPusyGryoWrJHnkb1yRpLOc8nkq
         UGQ2yP2+EQUetpAaASKDjoCf60aaU/JPvDEGq7/YMcFss25Ml3q4ff5c80ZJvZKSJ2bM
         Vsi7HVNZFVCksmSt39yb3VRV0IYeHTELZZnQFQvY8iHcgVe0kXDE/z7K2FxYPjSfWExr
         kiMBMFfOKscvThnYdFC5Nk0vFO5NzLCrxuctB571gKwQDft/31Vsjd7n3RUxTWT5bC35
         r3C6vViQbh9QN2IHRTGO0QM6AzwlC5yuVdcQkrPMiw1W1yPu0PX7G16rAiSm/w6Ho9Pd
         5Siw==
X-Gm-Message-State: APjAAAUYvyHes6PylQaXo8W76Cis/qAMW1Jm7IwUJdYhsdQloRUJk1iN
        uBp/m0UXc3A8KgS83W7AKMgolPZoooGtAbNRMOVcBOfbNFPut3F8z5KS9PzH4AclWTGkK6kTV2Y
        lgWHYdbM6xphW
X-Received: by 2002:a63:1e47:: with SMTP id p7mr4087864pgm.339.1579595378417;
        Tue, 21 Jan 2020 00:29:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwinOqowEa2cqxN1xgUjt7Y0/UsC42ih+JHvVIsw8rMqznKpATTe5fL6EsyFJlbih/HgXXCzQ==
X-Received: by 2002:a63:1e47:: with SMTP id p7mr4087848pgm.339.1579595378146;
        Tue, 21 Jan 2020 00:29:38 -0800 (PST)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m3sm40146819pgp.32.2020.01.21.00.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 00:29:37 -0800 (PST)
Date:   Tue, 21 Jan 2020 16:29:25 +0800
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200121082925.GB440822@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <22bcd5fc-338c-6b72-2bda-47ba38d7e8ef@redhat.com>
 <20200119051145-mutt-send-email-mst@kernel.org>
 <20200120072915.GD380565@xz-x1>
 <20200120024717-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200120024717-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 20, 2020 at 02:47:46AM -0500, Michael S. Tsirkin wrote:
> On Mon, Jan 20, 2020 at 03:29:15PM +0800, Peter Xu wrote:
> > On Sun, Jan 19, 2020 at 05:12:35AM -0500, Michael S. Tsirkin wrote:
> > > On Sun, Jan 19, 2020 at 10:09:53AM +0100, Paolo Bonzini wrote:
> > > > On 09/01/20 20:15, Peter Xu wrote:
> > > > > Regarding dropping the indices: I feel like it can be done, though we
> > > > > probably need two extra bits for each GFN entry, for example:
> > > > > 
> > > > >   - Bit 0 of the GFN address to show whether this is a valid publish
> > > > >     of dirty gfn
> > > > > 
> > > > >   - Bit 1 of the GFN address to show whether this is collected by the
> > > > >     user
> > > > 
> > > > We can use bit 62 and 63 of the GFN.
> > > 
> > > If we are short on bits we can just use 1 bit. E.g. set if
> > > userspace has collected the GFN.
> > 
> > I'm still unsure whether we can use only one bit for this.  Say,
> > otherwise how does the userspace knows the entry is valid?  For
> > example, the entry with all zeros ({.slot = 0, gfn = 0}) could be
> > recognized as a valid dirty page on slot 0 gfn 0, even if it's
> > actually an unused entry.
> 
> So I guess the reverse: valid entry has bit set, userspace sets it to
> 0 when it collects it?

Right, this seems to work.

Thanks,

-- 
Peter Xu

