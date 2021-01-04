Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DEB2E9F7F
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 22:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbhADV0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 16:26:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725921AbhADV0G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Jan 2021 16:26:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609795480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9W3dm1psOhfGPmDZHDhBv0mst1Ka4uF+LKdlXRt+5h0=;
        b=NF+CBE50iWNgdbDBuNSjgB8oHhnHJ+0tVysHtz95SQw5VQGxiWvPwf6H+he/yBkPn9TIGS
        uap/j0tx7DPBdLnzKIVKTWWixm6d3GXRA66oqcmS3DrHdVYjnjBPug7zjpmDC6uDkCH2xf
        hkA/9wulPJt1tCHUQXdgk1V0Uq8K6Vw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-EBbJ2H8NPPuYxAEMhd05lA-1; Mon, 04 Jan 2021 16:24:36 -0500
X-MC-Unique: EBbJ2H8NPPuYxAEMhd05lA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC0981007278;
        Mon,  4 Jan 2021 21:24:34 +0000 (UTC)
Received: from [10.10.115.194] (ovpn-115-194.rdu2.redhat.com [10.10.115.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52EEE61F59;
        Mon,  4 Jan 2021 21:24:31 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Organization: Red Hat Inc,
Subject: Possible regression in cpuacct.stats system time
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, alexandre.chartre@oracle.com,
        peterz@infradead.org, pbonzini@redhat.com, w90p710@gmail.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com
Message-ID: <12a1b9d4-8534-e23a-6bbd-736474928e6b@redhat.com>
Date:   Mon, 4 Jan 2021 16:24:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Last year I reported an issue of "suspicious RCU usage" [1] with the debug
kernel which was fixed with the patch:

    87fa7f3e98 "x86/kvm: Move context tracking where it belongs"

Recently I have come across a possible regression because of this
patch in the cpuacct.stats system time.

With the latest upstream kernel (5.11-rc2) when we set up a VM and start
observing the system time value from cpuacct.stat then it is significantly
higher than value reported with the kernel that doesn't have the
previously mentioned patch.

For instance, the following are the values of cpuacct.stats right after the
VM bring up completion for two cases:

with a kernel that has the patch-
    user 471
    system 6094

with the patch reverted-
    user 498
    system 1873


FWIU the reason behind this increase is the moving of guest_exit_irqoff()
to its proper location (near vmexit). This leads to the accounting
of instructions that were previously accounted into the guest context as a
part of the system time.

IMO this should be an expected behavior after the previously mentioned
change. Is that a right conclusion or I am missing something here?

Another question that I have is about the patch

    d7a08882a0 "KVM: x86: Unconditionally enable irqs in guest context"

considering we are enabling irqs early now in the code path, do we still
need this patch?


[1] https://lore.kernel.org/lkml/ece36eb1-253a-8ec6-c183-309c10bb35d5@redhat.com/

--
Thanks
Nitesh

