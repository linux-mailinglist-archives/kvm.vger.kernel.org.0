Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48E816ACB8
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 18:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgBXRKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 12:10:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38128 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727259AbgBXRKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 12:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582564234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MfCZv9bi2V0NBPfpYkHj1I4Z5YX6YopEZ8T+leiO1UA=;
        b=XJn16QRFZyftIVDfQ2SXTz13ntA3Vk4EfgvGQ0r6dvhvk7sUAoqLGXD9gL13uAbEs4DekU
        DqjbecGMDl2TF3WV9o4cr7Bod3x8XrxeUaA5HSU5hBnvLw7t4JGY0o0eDNUUwwBEOy58Go
        qowAf1sQfqfq+hvnO9cW74jKQn3xPp0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-7KfC6UkuPQmS0NYG0bykGQ-1; Mon, 24 Feb 2020 12:10:33 -0500
X-MC-Unique: 7KfC6UkuPQmS0NYG0bykGQ-1
Received: by mail-qt1-f198.google.com with SMTP id l1so11250910qtp.21
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 09:10:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MfCZv9bi2V0NBPfpYkHj1I4Z5YX6YopEZ8T+leiO1UA=;
        b=WmXZy9Duc29P8O1tT2dPPuB2A2QhfJ9gOA9jutw8gap8rQECJpORBD3ZwMTt/OKnyP
         TcK49jTamyQryv9kdYRQF/RlcsighSv750uRtKJW5O7nDXnLLhqL5bOxOiNRM4y2Uwq4
         BvANx5IaBAkRSX7R3zlEI+KdSrJxAdrIRT2kwN/QGiOJQmVTcAyMnLeQkReTExGYofUy
         rAQZaqITE38kK43nnWDy231VDoS1RlFiXx92IENoFt2/njx+fBpbZZktgEw5F2MWxROf
         HO7kWboWBelaFeq8oePOfyvuHHosKSQssfCZ/cHyTM7d50TSUzYAX3+ada0udXw0MGRU
         UHqQ==
X-Gm-Message-State: APjAAAVBcHiHunKmfZ9dMbDNKkchR2N0bet8Q6T6NUYYwKkEG1cjLSPy
        qdN/iAsxd+ToVMdGcX63DHJxkCvNuakhUibyTTt9C0Wu9dOkhuAsmRzwYr2bjoD8hbmjqQfEtiW
        o2P11j/NDUmm0
X-Received: by 2002:a37:9245:: with SMTP id u66mr52011468qkd.102.1582564232652;
        Mon, 24 Feb 2020 09:10:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqzyIQQ5WdGv+SPVQPUaYd1E25iBBNwQEg43XPvLQL/Q0L+cdnXzyt/fYXRfRkzmFLfCkH802g==
X-Received: by 2002:a37:9245:: with SMTP id u66mr52011448qkd.102.1582564232435;
        Mon, 24 Feb 2020 09:10:32 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id i7sm6067790qki.83.2020.02.24.09.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:10:31 -0800 (PST)
Date:   Mon, 24 Feb 2020 12:10:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, jasowang@redhat.com, cohuck@redhat.com,
        slp@redhat.com, felipe@nutanix.com, john.g.johnson@oracle.com,
        robert.bradford@intel.com, Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>
Subject: Re: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Message-ID: <20200224120522-mutt-send-email-mst@kernel.org>
References: <20200222201916.GA1763717@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200222201916.GA1763717@stefanha-x1.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 22, 2020 at 08:19:16PM +0000, Stefan Hajnoczi wrote:
> The KVM_IOREGIONFD_POSTED_WRITES flag
> skips waiting for an acknowledgement on write accesses.  This is
> suitable for accesses that do not require synchronous emulation, such as
> doorbell register writes.

I would avoid hacks like this until we understand this better.
Specificlly one needs to be very careful since memory ordering semantics
can differ between a write into an uncacheable range and host writes into
a data structure. Reads from one region are also assumed to be ordered with
writes to another region, and drivers are known to make assumptions
like this.

Memory ordering being what it is, this isn't a field I'd be comfortable
device writes know what they are doing.

-- 
MST

