Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B05B3A452
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2019 10:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfFIISH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jun 2019 04:18:07 -0400
Received: from foss.arm.com ([217.140.110.172]:58080 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbfFIISH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jun 2019 04:18:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5F0D344;
        Sun,  9 Jun 2019 01:18:06 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 55CFC3F802;
        Sun,  9 Jun 2019 01:18:06 -0700 (PDT)
Date:   Sun, 9 Jun 2019 10:18:05 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     kvm@vger.kernel.org
Cc:     aarcange@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu
Subject: Reference count on pages held in secondary MMUs
Message-ID: <20190609081805.GC21798@e113682-lin.lund.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I have been looking at how we deal with page_count(page) on pages held
in stage 2 page tables on KVM/arm64.

What we do currently is to drop the reference on the page we get from
get_user_pages() once the page is inserted into our stage 2 page table,
typically leaving page_count(page) == page_mapcount(page) == 1 which
represents the userspace stage 1 mapping of the page,
and we rely on MMU notifiers to remove the stage 2 mapping if
corresponding stage 1 mapping is being unmapped.

I believe this is analogous to what other architectures do?

In some sense, we are thus maintaining a 'hidden', or internal,
reference to the page, which is not counted anywhere.

I am wondering if it would be equally valid to take a reference on the
page, and remove that reference when unmapping via MMU notifiers, and if
so, if there would be any advantages/drawbacks in doing so?


Thanks,

    Christoffer
