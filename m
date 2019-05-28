Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F81B2BD0F
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 03:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfE1B4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 21:56:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:1564 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727654AbfE1B4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 21:56:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 18:56:07 -0700
X-ExtLoop1: 1
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by orsmga002.jf.intel.com with ESMTP; 27 May 2019 18:56:06 -0700
Message-ID: <5CEC9667.30100@intel.com>
Date:   Tue, 28 May 2019 10:01:11 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Eric Hankland <ehankland@google.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com
CC:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
In-Reply-To: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/23/2019 06:23 AM, Eric Hankland wrote:
> - Add a VCPU ioctl that can control which events the guest can monitor.
>
> Signed-off-by: ehankland <ehankland@google.com>
> ---
> Some events can provide a guest with information about other guests or the
> host (e.g. L3 cache stats); providing the capability to restrict access
> to a "safe" set of events would limit the potential for the PMU to be used
> in any side channel attacks. This change introduces a new vcpu ioctl that
> sets an event whitelist. If the guest attempts to program a counter for
> any unwhitelisted event, the kernel counter won't be created, so any
> RDPMC/RDMSR will show 0 instances of that event.

The general idea sounds good to me :)

For the implementation, I would have the following suggestions:

1) Instead of using a whitelist, it would be better to use a blacklist to
forbid the guest from counting any core level information. So by default,
kvm maintains a list of those core level events, which are not supported to
the guest.

The userspace ioctl removes the related events from the blacklist to
make them usable by the guest.

2) Use vm ioctl, instead of vcpu ioctl. The blacklist-ed events can be 
VM wide
(unnecessary to make each CPU to maintain the same copy).
Accordingly, put the pmu event blacklist into kvm->arch.

3) Returning 1 when the guest tries to set the evetlsel msr to count an
event which is on the blacklist.

Best,
Wei
