Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B3C16702
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 17:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfEGPkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 11:40:41 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33970 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfEGPkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 11:40:41 -0400
Received: by mail-ot1-f65.google.com with SMTP id l17so5829174otq.1
        for <kvm@vger.kernel.org>; Tue, 07 May 2019 08:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eDjq30ddseBaIw6socWxfPv6NTtk+5QW4X1Ug5iEyJk=;
        b=P0NmBCU8zUOfaF8xaYZsuZ8crvxFB33fl7wDNB9MZv5fgE9bufZ9uXOFacVBRIyhyk
         7jy7cEut0ZZu1RaoDtrr50BVaB/CX/skGeBOtXxoGAGKW89ZemgDpFwl6g0BCyZNTY71
         c96Bv/+lzcoe4YYcd5EMePUR4gTK7GrAqK6itLr2obeqWzYKb3Dql3mDDHzIv1x+/JnT
         zIvYGvdBDonXfV8sEZV0PvMIvA63l1OoRV+8kWQPCfuhVRSXMOb+jYMxWFhFzCGAXSHH
         RES21PeWYeTfPIbRNgVP3JVS3PVW0F6JNq0X1vpUrTbfXgSQ4Ev5ZlVumch1kGRMghci
         mHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eDjq30ddseBaIw6socWxfPv6NTtk+5QW4X1Ug5iEyJk=;
        b=ko7Q95c2lEh5j40hx2Wef9wI0MQt/7WEAwlUQaMN12SV77eHiu3eDRCuDQNUHKGUpa
         wqO3PvkKyUmSCFZhtkaDt42q8FKWiV1nqSdc/QB3s3igPaASlWCN6qGvU6qQvOiM/r4s
         AjN2IB5DhqC3TtKiYoaCjHRVyLJu29imFYIy6l48FGvwXjVZbJkNZZetR1sVHkUgCcXi
         xu+ZehHD2G4VxVFc36FxaUBkAahAHlaNor+SfK/rLMPRiEWWBY9iyBz88jUYtybXnp0/
         a3t/oQGbZ1Pf3ltbzxQlFfyjBFyRroNqRH85k17uTkL2P0zX7zzmkg+Iuui68CUr762s
         ejAw==
X-Gm-Message-State: APjAAAWnyZMTigSxGuispDkuDzlxZKkDVxGBg18Z1uumRS+bk8uJUPzZ
        cak1E0QTNmdk72lLm2Y3Xq6CqBHI/5AnjU1o3HFkPQ==
X-Google-Smtp-Source: APXvYqxgIWANkc/KHq9kAogc8tqlkqRrOccsWEIKbqAeeZcNH5LiQg3MPoGwMh9hdCCYG0LuKCXgqpIi0akzNLzuZFI=
X-Received: by 2002:a9d:222c:: with SMTP id o41mr22033787ota.353.1557243640877;
 Tue, 07 May 2019 08:40:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190426050039.17460-1-pagupta@redhat.com> <20190426050039.17460-4-pagupta@redhat.com>
In-Reply-To: <20190426050039.17460-4-pagupta@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 7 May 2019 08:40:30 -0700
Message-ID: <CAPcyv4hRdvypEj4LBTMfUFm80BdpRYbOugrkkj-3Kk_LErXPqQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/6] libnvdimm: add dax_dev sync flag
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM list <kvm@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Ross Zwisler <zwisler@kernel.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Christoph Hellwig <hch@infradead.org>,
        Len Brown <lenb@kernel.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        jmoyer <jmoyer@redhat.com>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        david <david@fromorbit.com>, cohuck@redhat.com,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kilobyte@angband.pl,
        yuval shaia <yuval.shaia@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 25, 2019 at 10:02 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>
> This patch adds 'DAXDEV_SYNC' flag which is set
> for nd_region doing synchronous flush. This later
> is used to disable MAP_SYNC functionality for
> ext4 & xfs filesystem for devices don't support
> synchronous flush.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
[..]
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 0dd316a74a29..c97fc0cc7167 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -7,6 +7,9 @@
>  #include <linux/radix-tree.h>
>  #include <asm/pgtable.h>
>
> +/* Flag for synchronous flush */
> +#define DAXDEV_F_SYNC true

I'd feel better, i.e. it reads more canonically, if this was defined
as (1UL << 0) and the argument to alloc_dax() was changed to 'unsigned
long flags' rather than a bool.
