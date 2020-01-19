Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E1D141D40
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 11:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgASKMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 05:12:48 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26300 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgASKMr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Jan 2020 05:12:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579428766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jRdC5C9SszzHrx5URtnzUXOg+cpaWM91XUEJs3Q6WUQ=;
        b=Y6/CUbzp5fjjBJXIndd54pQ2x+s9Z0LYQv6s/IlkaBGyKc8QHZuynjwcRWJHbebkmDmF7c
        0QwtZw2S2ixdT6rtRhkcFPvDVoPYCfNqDR0+BXjDS6nv2K3OWKO2sasj7sSSZxGCOkBA61
        Pr99oObTwL8lW6y3Qmgce9zPvHWXsuc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-i7GY8xgQPUCNVnCfGuYDmQ-1; Sun, 19 Jan 2020 05:12:43 -0500
X-MC-Unique: i7GY8xgQPUCNVnCfGuYDmQ-1
Received: by mail-qk1-f200.google.com with SMTP id n128so18654411qke.19
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 02:12:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jRdC5C9SszzHrx5URtnzUXOg+cpaWM91XUEJs3Q6WUQ=;
        b=ZMJaTaqiZ7RsE17X6EXNySadLPRaGZfTMwLa6sxG/8C3LosFO0vsjh9g1RZZDObx1r
         API404nKQHKbOBEV0JGYnoVatC6Ha84KnmpKplARMk2roiSCpqbEZCpRXD3m/1rYdwHt
         A4JCMhSZe3VLjJcVEdoIQ9fqrI5yKON4i+rNXEq7W2N8EtLzbrpaeLeTZAtTpUNy51vB
         d6Code2DtKJ0qQEeV8f8P0mipHCfcI6HUyXQ176qJBik1fNpISA5AjoY4PTKAQzT7wkl
         K480rCZ5/Zig/ITbaKdwecFtUmnJAf1y/oAtSiUUw0SvoIPO3wF4RrIQ/CR3dozVQbXI
         GAZw==
X-Gm-Message-State: APjAAAVoWP9JJRN4/iA+DRiQWQpyZPZd3BcKVRUIg361IEG19o6T+iNf
        TbQ6MpXjOqfy0xGYIrNhZjSnLsJ9kmZadqOYdyqvTdlmp0FhRvdfkM6w0CbRRHaajs7bidj0/nh
        qfgjtmxmxKVfr
X-Received: by 2002:a05:6214:1103:: with SMTP id e3mr15879984qvs.159.1579428762705;
        Sun, 19 Jan 2020 02:12:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqxlPeGl3vOoGh87qeXcfrEvupqg6iDr2WU7KLpGIgdBVXimjeVKIOsMBPWxHRjhIbTCSqQDqQ==
X-Received: by 2002:a05:6214:1103:: with SMTP id e3mr15879976qvs.159.1579428762519;
        Sun, 19 Jan 2020 02:12:42 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id h32sm16168861qth.2.2020.01.19.02.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 02:12:41 -0800 (PST)
Date:   Sun, 19 Jan 2020 05:12:35 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
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
Message-ID: <20200119051145-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <22bcd5fc-338c-6b72-2bda-47ba38d7e8ef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22bcd5fc-338c-6b72-2bda-47ba38d7e8ef@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 19, 2020 at 10:09:53AM +0100, Paolo Bonzini wrote:
> On 09/01/20 20:15, Peter Xu wrote:
> > Regarding dropping the indices: I feel like it can be done, though we
> > probably need two extra bits for each GFN entry, for example:
> > 
> >   - Bit 0 of the GFN address to show whether this is a valid publish
> >     of dirty gfn
> > 
> >   - Bit 1 of the GFN address to show whether this is collected by the
> >     user
> 
> We can use bit 62 and 63 of the GFN.

If we are short on bits we can just use 1 bit. E.g. set if
userspace has collected the GFN.

> I think this can be done in a secure way.  Later in the thread you say:
> 
> > We simply check fetch_index (sorry I
> > meant this when I said reset_index, anyway it's the only index that we
> > expose to userspace) to make sure:
> > 
> >   reset_index <= fetch_index <= dirty_index
> 
> So this means that KVM_RESET_DIRTY_RINGS should only test the "collected
> by user" flag on dirty ring entries between reset_index and dirty_index.
> 
> Also I would make it
> 
>    00b (invalid GFN) ->
>      01b (valid gfn published by kernel, which is dirty) ->
>        1*b (gfn dirty page collected by userspace) ->
>          00b (gfn reset by kernel, so goes back to invalid gfn)
> That is 10b and 11b are equivalent.  The kernel doesn't read that bit if
> userspace has collected the page.
> 
> Paolo

