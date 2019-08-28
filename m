Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAB0A0107
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 13:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfH1LvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 07:51:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbfH1LvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 07:51:13 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88CBB3099F76;
        Wed, 28 Aug 2019 11:51:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 16E941001B0B;
        Wed, 28 Aug 2019 11:51:08 +0000 (UTC)
Date:   Wed, 28 Aug 2019 13:51:06 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 0/4] KVM: selftests: Introduce VM_MODE_PXXV48_4K
Message-ID: <20190828115106.2j6n7qust7uceds5@kamzik.brq.redhat.com>
References: <20190827131015.21691-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827131015.21691-1-peterx@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 28 Aug 2019 11:51:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 09:10:11PM +0800, Peter Xu wrote:
> The work is based on Thomas's s390 port for dirty_log_test.
> 
> This series originates from "[PATCH] KVM: selftests: Detect max PA
> width from cpuid" [1] and one of Drew's comments - instead of keeping
> the hackish line to overwrite guest_pa_bits all the time, this series
> introduced the new mode VM_MODE_PXXV48_4K for x86_64 platform.
> 
> The major issue is that even all the x86_64 kvm selftests are
> currently using the guest mode VM_MODE_P52V48_4K, many x86_64 hosts
> are not using 52 bits PA (and in most cases, far less).  If with luck
> we could be having 48 bits hosts, but it's more adhoc (I've observed 3
> x86_64 systems, they are having different PA width of 36, 39, 48).  I
> am not sure whether this is happening to the other archs as well, but
> it probably makes sense to bring the x86_64 tests to the real world on
> always using the correct PA bits.
> 
> A side effect of this series is that it will also fix the crash we've
> encountered on Xeon E3-1220 as mentioned [1] due to the
> differenciation of PA width.
> 
> With [1], we've observed AMD host issues when with NPT=off.  However a
> funny fact is that after I reworked into this series, the tests can
> instead pass on both NPT=on/off.  It could be that the series changes
> vm->pa_bits or other fields so something was affected.  I didn't dig
> more on that though, considering we should not lose anything.
> 
> Any kind of smoke test would be greatly welcomed (especially on s390
> or ARM).  Same to comments.  Thanks,
> 

The patches didn't apply cleanly for me on 9e8312f5e160, but once I got
them applied I was able to run the aarch64 tests.

> [1] https://lkml.org/lkml/2019/8/26/141
> 
> Peter Xu (4):
>   KVM: selftests: Move vm type into _vm_create() internally
>   KVM: selftests: Create VM earlier for dirty log test
>   KVM: selftests: Introduce VM_MODE_PXXV48_4K
>   KVM: selftests: Remove duplicate guest mode handling
> 
>  tools/testing/selftests/kvm/dirty_log_test.c  | 78 +++++--------------
>  .../testing/selftests/kvm/include/kvm_util.h  | 17 +++-
>  .../selftests/kvm/lib/aarch64/processor.c     |  3 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 77 ++++++++++++++----
>  .../selftests/kvm/lib/x86_64/processor.c      |  8 +-
>  5 files changed, 107 insertions(+), 76 deletions(-)
> 
> -- 
> 2.21.0
>

Thanks,
drew
