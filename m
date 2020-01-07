Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF84132B32
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 17:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgAGQhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 11:37:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:46103 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbgAGQhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 11:37:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 08:37:02 -0800
X-IronPort-AV: E=Sophos;i="5.69,406,1571727600"; 
   d="scan'208";a="215618049"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 08:37:02 -0800
Message-ID: <3025ad3e90ec5c6b48e3101174ab090e054f4c9a.camel@linux.intel.com>
Subject: Re: [PATCH 0/2] page hinting add passthrough support
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     weiqi <weiqi4@huawei.com>, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, x86@kernel.org
Date:   Tue, 07 Jan 2020 08:37:02 -0800
In-Reply-To: <1578408399-20092-1-git-send-email-weiqi4@huawei.com>
References: <1578408399-20092-1-git-send-email-weiqi4@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-01-07 at 22:46 +0800, weiqi wrote:
> From: wei qi <weiqi4@huawei.com>
> 
> 
> I just implemented dynamically updating the iommu table to support pass-through,
> It seen to work fine.
> 
> Test:
> start a 4G vm with 2M hugetlb and ixgbevf passthrough, 
>     GuestOS: linux-5.2.6 + 	(mm / virtio: Provide support for free page reporting)
>     HostOS: 5.5-rc4
>     Host: Intel(R) Xeon(R) Gold 6161 CPU @ 2.20GHz 
> 
> after enable page hinting, free pages at GuestOS can be free at host. 
> 
> 
> before,
>  # cat /sys/devices/system/node/node*/hugepages/hugepages-2048kB/free_hugepages 
>  5620
>  5620
> after start VM,
>  # numastat -c qemu
> 
>  Per-node process memory usage (in MBs)
>  PID              Node 0 Node 1 Total
>  ---------------  ------ ------ -----
>  24463 (qemu_hotr      6      6    12
>  24479 (qemu_tls_      0      8     8
>  70718 (qemu-syst     58    539   597
>  ---------------  ------ ------ -----
>  Total                64    553   616
>  # cat /sys/devices/system/node/node*/hugepages/hugepages-2048kB/free_hugepages 
>  5595
>  5366
> 
> the modify at qemu,
>  +int kvm_discard_range(struct kvm_discard_msg discard_msg)  
>  +{
>  +    return kvm_vm_ioctl(kvm_state, KVM_DISCARD_RANGE, &discard_msg);
>  +}
> 
>  static void virtio_balloon_handle_report(VirtIODevice *vdev, VirtQueue *vq)
>  {
>             ..................
>  +           discard_msg.in_addr = elem->in_addr[i];
>  +           discard_msg.iov_len = elem->in_sg[i].iov_len;
> 
>             ram_block_discard_range(rb, ram_offset, size);
>  +           kvm_discard_range(discard_msg);
> 
> then, further test network bandwidth, performance seem ok.
>  
> Is there any hidden problem in this implementation?

How is it you are avoiding triggering the call to qemu_balloon_inhibit in
QEMU?

> And, is there plan to support pass-throughyour?

It wasn't something I was immediately planning to do. Before we got there
we would need to really address the fact that the host has no idea what
pages the device could be accessing since normally the entire guest is
pinned. I guess these patches are a step toward addressing that?


