Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306261B71C
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 15:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfEMNfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 09:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbfEMNfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 09:35:55 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E31D1552FC;
        Mon, 13 May 2019 13:35:54 +0000 (UTC)
Received: from flask (unknown [10.40.205.238])
        by smtp.corp.redhat.com (Postfix) with SMTP id 22DEB1001F54;
        Mon, 13 May 2019 13:35:51 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Mon, 13 May 2019 15:35:51 +0200
Date:   Mon, 13 May 2019 15:35:51 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH] KVM: X86: Enable IA32_MSIC_ENABLE MONITOR bit when
 exposing mwait/monitor
Message-ID: <20190513133548.GA6538@flask>
References: <1557740799-5792-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557740799-5792-1-git-send-email-wanpengli@tencent.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 13 May 2019 13:35:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-05-13 17:46+0800, Wanpeng Li:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> MSR IA32_MSIC_ENABLE bit 18, according to SDM:
> 
>  | When this bit is set to 0, the MONITOR feature flag is not set (CPUID.01H:ECX[bit 3] = 0). 
>  | This indicates that MONITOR/MWAIT are not supported.
>  | 
>  | Software attempts to execute MONITOR/MWAIT will cause #UD when this bit is 0.
>  | 
>  | When this bit is set to 1 (default), MONITOR/MWAIT are supported (CPUID.01H:ECX[bit 3] = 1). 
> 
> This bit should be set to 1, if BIOS enables MONITOR/MWAIT support on host and 
> we intend to expose mwait/monitor to the guest.

The CPUID.01H:ECX[bit 3] ought to mirror the value of the MSR bit and
as userspace has control of them both, I'd argue that it is userspace's
job to configure both bits to match on the initial setup.

Also, CPUID.01H:ECX[bit 3] is a better guard than kvm_mwait_in_guest().
kvm_mwait_in_guest() affects the behavior of MONITOR/MWAIT, not its
guest visibility.
Some weird migration cases might want MONITOR in CPUID without
kvm_mwait_in_guest() and the MSR should be correct there as well.

Missing the MSR bit shouldn't be a big problem for guests, so I am in
favor of fixing the userspace code.

Thanks.

(For extra correctness in KVM, we could implement toggling of the CPUID
 bit based on guest writes to the MSR.)
