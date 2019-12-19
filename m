Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB141265BB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 16:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfLSP2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 10:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbfLSP2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 10:28:18 -0500
Received: from localhost (lfbn-ncy-1-150-155.w83-194.abo.wanadoo.fr [83.194.232.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08342206EC;
        Thu, 19 Dec 2019 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576769297;
        bh=sQSHOUejb0NrITZ23gNkinjyHOPbHZHsfdYvVQRdAdw=;
        h=Date:From:To:Cc:Subject:From;
        b=Cfe1T0qkWZG+J2JW8IqUpK72QwIko7lthhk8rJLz5xbd1lly0aD/7qE38mw7CSM1/
         aKLM5FSOCtyau30JeizBYJz2pWjswGW6dfUyGhUKrN2rWxFiJygTsoNhIJG0gKXGUh
         NkJOq7dPQIv/EGEHHhO5wuPbFwLr5QxJBF3CfzGA=
Date:   Thu, 19 Dec 2019 16:28:15 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Async page fault delivered while irq are disabled?
Message-ID: <20191219152814.GA24080@lenoir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

While checking the x86 async page fault code, I can't
find anything that prevents KVM_PV_REASON_PAGE_READY to be injected
while the guest has interrupts disabled. If that page fault happens
to trap in an interrupt disabled section, there may be a deadlock due to the
call to wake_up_process() which locks the rq->lock (among others).

Given how long that code is there, I guess such an issue would
have been reported for a while already. But I just would like to
be sure we are checking that.

Can someone enlighten me?

Thanks.
