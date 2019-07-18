Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D126D5E4
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 22:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfGRUh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 16:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfGRUh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 16:37:58 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E683881F0C;
        Thu, 18 Jul 2019 20:37:57 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7D93B1001B35;
        Thu, 18 Jul 2019 20:37:45 +0000 (UTC)
Date:   Thu, 18 Jul 2019 16:37:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
Message-ID: <20190718163325-mutt-send-email-mst@kernel.org>
References: <20190716115535-mutt-send-email-mst@kernel.org>
 <CAKgT0Ud47-cWu9VnAAD_Q2Fjia5gaWCz_L9HUF6PBhbugv6tCQ@mail.gmail.com>
 <20190716125845-mutt-send-email-mst@kernel.org>
 <CAKgT0UfgPdU1H5ZZ7GL7E=_oZNTzTwZN60Q-+2keBxDgQYODfg@mail.gmail.com>
 <20190717055804-mutt-send-email-mst@kernel.org>
 <CAKgT0Uf4iJxEx+3q_Vo9L1QPuv9PhZUv1=M9UCsn6_qs7rG4aw@mail.gmail.com>
 <20190718003211-mutt-send-email-mst@kernel.org>
 <CAKgT0UfQ3dtfjjm8wnNxX1+Azav6ws9zemH6KYc7RuyvyFo3fQ@mail.gmail.com>
 <20190718113548-mutt-send-email-mst@kernel.org>
 <CAKgT0UeRy2eHKnz4CorefBAG8ro+3h4oFX+z1JY2qRm17fcV8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UeRy2eHKnz4CorefBAG8ro+3h4oFX+z1JY2qRm17fcV8w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 18 Jul 2019 20:37:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 18, 2019 at 01:29:14PM -0700, Alexander Duyck wrote:
> So one thing that is still an issue then is that my approach would
> only work on the first migration. The problem is the logic I have
> implemented assumes that once we have hinted on a page we don't need
> to do it again. However in order to support migration you would need
> to reset the hinting entirely and start over again after doing a
> migration.

Well with precopy at least it's simple: just clear the
dirty bit, it won't be sent, and then on destination
you get a zero page and later COW on first write.
Right?

With precopy it is tricker as destination waits until it gets
all of memory. I think we could use some trick to
make source pretend it's a zero page, that is cheap to send.

-- 
MST
