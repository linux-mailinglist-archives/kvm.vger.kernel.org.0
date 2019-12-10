Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D95119A0D
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 22:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbfLJVtK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 16:49:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23111 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729798AbfLJVtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 16:49:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576014547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kRHP/YZ/v5tZHq+EqyHv9Q8ygSXDpE+zmhmcnk0K+/0=;
        b=JNOxeqlHEC08WO5wGiSoU9DljQe27/LzVkjKMFzIj/BHDY1pv/QTjHqQQKuAFrlHCV/98G
        CbQqkqxfWsb7SZzwwJUAvj7go01nO321gZxgnEqHVu8JC+bOUgCT0F4rNVTHX26MwnkAv9
        GcPhEZ2wMuOZQuOUZZIHT4zGI+w1fic=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-N_bnxA_uPrmaFrxy4eSbaQ-1; Tue, 10 Dec 2019 16:49:06 -0500
Received: by mail-qk1-f197.google.com with SMTP id o184so13235605qkf.14
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 13:49:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Fvh9KfncyRLodCGVx6CNMB0xHcL2ji/SSHmtcQvIBc=;
        b=lm+IoRdkQiZE8K5K0PdlRi7nNd1+jmqJGRE2fVwM6wVsmJSfSdg/VcmDAQFL25axrH
         MvcINmPX57Siq8fL2NYMPK0PczEvpChW3ws9VbL8V4XlnQUhD4AJxYeAFnmhuAiE37I5
         28nA7H3d5DbMWjBRZLVCEZANLk0JfaXnNeOqiIco3l26nMtWnDMqzQMMndG361BxtwS4
         7NKt9DEY3CJY4tQ1yv8eAzUYEw8TMZLMwafmt9x0P/12aRA6a2sDGJG8Qx4nBfHeyINO
         sTyXt7dnBs3X5VTNrq/gJIMi8yI6w7tkSYyplPFLDSCxPtKlqdm0cISBChRgj6vmwPWn
         0/Kg==
X-Gm-Message-State: APjAAAVUxwi9Vlnici/Jtd2AeiJ/AyqiqAmkIb4o5+p+BuKDJYx0sn0B
        72oE7WPCQkP4IRr4kuFfBEQFCK41AtVNeh3zNLXfCsRguJ45xcqbTiE3AfFJUwZ4uygoYeByPco
        ml67MnW+FcKQR
X-Received: by 2002:aed:2270:: with SMTP id o45mr32168463qtc.217.1576014546121;
        Tue, 10 Dec 2019 13:49:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqyldUBQOIrNb9JapJRKo8/NDw9CDZXTYIbAMF4XhDN0GqGA/Bm5av5bHhivcOXCrRenuFKEBg==
X-Received: by 2002:aed:2270:: with SMTP id o45mr32168443qtc.217.1576014545942;
        Tue, 10 Dec 2019 13:49:05 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id 68sm1373605qkj.102.2019.12.10.13.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 13:49:04 -0800 (PST)
Date:   Tue, 10 Dec 2019 16:48:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Peter Xu <peterx@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191210164749-mutt-send-email-mst@kernel.org>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
 <20191210081958-mutt-send-email-mst@kernel.org>
 <8843d1c8-1c87-e789-9930-77e052bf72f9@redhat.com>
MIME-Version: 1.0
In-Reply-To: <8843d1c8-1c87-e789-9930-77e052bf72f9@redhat.com>
X-MC-Unique: N_bnxA_uPrmaFrxy4eSbaQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 02:31:54PM +0100, Paolo Bonzini wrote:
> On 10/12/19 14:25, Michael S. Tsirkin wrote:
> >> There is no new infrastructure to track the dirty pages---it's just a
> >> different way to pass them to userspace.
> > Did you guys consider using one of the virtio ring formats?
> > Maybe reusing vhost code?
>=20
> There are no used/available entries here, it's unidirectional
> (kernel->user).

Didn't look at the design yet, but flow control (to prevent overflow)
goes the other way, doesn't it?  That's what used is, essentially.

> > If you did and it's not a good fit, this is something good to mention
> > in the commit log.
> >=20
> > I also wonder about performance numbers - any data here?
>=20
> Yes some numbers would be useful.  Note however that the improvement is
> asymptotical, O(#dirtied pages) vs O(#total pages) so it may differ
> depending on the workload.
>=20
> Paolo

