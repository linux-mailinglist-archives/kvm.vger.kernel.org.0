Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC80D11D76D
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 20:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbfLLTs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 14:48:27 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34976 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730284AbfLLTsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 14:48:24 -0500
Received: by mail-ot1-f65.google.com with SMTP id o9so3237258ote.2
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 11:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lCyIPGmm9pZuYaQMe79zFMPFkP+ZmU5MS9AqbrmOwNc=;
        b=LmjiQ6Y3tpZugdSlcd+rg78aUn32879Bmxoumcf4KtU4qEAgEeHxpK3vJ4j9jpWpMh
         JsLVy7vBtDiZk4VOuSzIhNw+9K06juyjGnCjyhs7/uXCpyz631P3upDuCVpFgK2V30sp
         tKtBuYVRFL4i3YF+l2aDofmf2mK6zJHfA5320/V6GNaGIvm/PqzywZrsKsZc4jlmITKC
         7R5mNM5l6eYcYrg3mHWmSmY8L6/+uimFf0EZYK1MJD9sBfvRH/BwyszifUjKV+QQWPGm
         dk679DjdoxZI1D9tifTljqmV8jAY5/R1qgvveZ7l9+q7CPsdFBPIhM0T45oNcJhJWRfd
         bG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCyIPGmm9pZuYaQMe79zFMPFkP+ZmU5MS9AqbrmOwNc=;
        b=uhX94t5SFSzPfgEf83X5MpfIXIdIiXvERcqTkYRr2XVt2LQ1OSRDJctJ2r2TmbVhLo
         mMRZmv9JZgZXH6j2brbMAJnHDxUlWjiwFG0xATKvMYJEEl+n3Yqq5npLNlOrcb+WNpmm
         MLep4rhJ8AcaoL4Cq0LPkdywKrXOJnNwlaprbrOI9LkZVKzaLS4jIo1KNcIR1hg/Knfr
         eRJuYauhKdr0ivNImo2RdNYEuCE/OkN3l12qUetbtTS6AAvFQREcvJxD5lOXvlZGpSIL
         jxUylVUdu2cXWxUbBcg2r/8KDiphOYfX51piSUdLojvwI1ztINwjfPGzpAvoPmgXsELg
         IkKQ==
X-Gm-Message-State: APjAAAVvmZA3z3jzv5c6eQhXDds6JpXe6qIojRYRTW2v4tZ3OzSC3HmR
        H0pFlYsxV1Ck0rjxr2dcML043J/HZUOx5JXbmTrZBA==
X-Google-Smtp-Source: APXvYqzSgglPxYBD4ccergwRG+u4Anxgb6meYuHJx5pCaklA2pqhIlpF+AZ2F0oXzqKQ2x/j6OoRxHdmvgE++DyDBmA=
X-Received: by 2002:a9d:4e99:: with SMTP id v25mr10276651otk.363.1576180103398;
 Thu, 12 Dec 2019 11:48:23 -0800 (PST)
MIME-Version: 1.0
References: <20191211213207.215936-1-brho@google.com> <20191211213207.215936-3-brho@google.com>
 <20191212173413.GC3163@linux.intel.com> <CAPcyv4hkz8XCETELBaUOjHQf3=VyVB=KWeRVEPYejvdsg3_MWA@mail.gmail.com>
 <b50720a2-5358-19ea-a45e-a0c0628c68b0@google.com>
In-Reply-To: <b50720a2-5358-19ea-a45e-a0c0628c68b0@google.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 12 Dec 2019 11:48:12 -0800
Message-ID: <CAPcyv4h19dKGpz0XzEHz0nOddnRAefE=rOuhGTHEL6FPhqk8GQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
To:     Barret Rhoden <brho@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Zeng, Jason" <jason.zeng@intel.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 11:16 AM Barret Rhoden <brho@google.com> wrote:
>
> On 12/12/19 12:37 PM, Dan Williams wrote:
> > Yeah, since device-dax is the only path to support longterm page
> > pinning for vfio device assignment, testing with device-dax + 1GB
> > pages would be a useful sanity check.
>
> What are the issues with fs-dax and page pinning?  Is that limitation
> something that is permanent and unfixable (by me or anyone)?

It's a surprisingly painful point of contention...

File backed DAX pages cannot be truncated while the page is pinned
because the pin may indicate that DMA is ongoing to the file block /
DAX page. When that pin is from RDMA or VFIO that creates a situation
where filesystem operations are blocked indefinitely. More details
here: 94db151dc892 "vfio: disable filesystem-dax page pinning".

Currently, to prevent the deadlock, RDMA, VFIO, and IO_URING memory
registration is blocked if the mapping is filesystem-dax backed (see
the FOLL_LONGTERM flag to get_user_pages).

One of the proposals to break the impasse was to allow the filesystem
to forcibly revoke the mapping. I.e. to use the IOMMU to forcibly kick
the RDMA device out of its registration. That was rejected by RDMA
folks because RDMA applications are not prepared for this revocation
to happen and the application that performed the registration may not
be the application that uses the registration. There was an attempt to
use a file lease to indicate the presence of a file /
memory-registration that is blocking file-system operations, but that
was still less palatable to filesystem folks than just keeping the
status quo of blocking longterm pinning.

That said, the VFIO use case seems a different situation than RDMA.
There's often a 1:1 relationship between the application performing
the memory registration and the application consuming it, the VMM, and
there is always an IOMMU present that could revoke access and kill the
guest is the mapping got truncated. It seems in theory that VFIO could
tolerate a "revoke pin on truncate" mechanism where RDMA could not.

> I'd like to put a lot more in a DAX/pmem region than just a guest's
> memory, and having a mountable filesystem would be extremely convenient.

Why would page pinning be involved in allowing the guest to mount a
filesystem on guest-pmem? That already works today, it's just the
device-passthrough that causes guest memory to be pinned indefinitely.
