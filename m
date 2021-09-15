Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5D740C1EE
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 10:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhIOIoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 04:44:19 -0400
Received: from mga05.intel.com ([192.55.52.43]:27364 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233002AbhIOIoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 04:44:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10107"; a="307810161"
X-IronPort-AV: E=Sophos;i="5.85,294,1624345200"; 
   d="scan'208";a="307810161"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2021 01:42:57 -0700
X-IronPort-AV: E=Sophos;i="5.85,294,1624345200"; 
   d="scan'208";a="544748425"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 15 Sep 2021 01:42:54 -0700
Date:   Wed, 15 Sep 2021 16:28:57 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Subject: Re: [RFC/RFT PATCH 0/2] x86: sgx_vepc: implement ioctl to EREMOVE
 all pages
Message-ID: <20210915082857.GA30272@yangzhon-Virtual>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210914071030.GA28797@yangzhon-Virtual>
 <8e1c6b6d-6a73-827e-f496-b17b3c0f8c89@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e1c6b6d-6a73-827e-f496-b17b3c0f8c89@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021 at 12:19:31PM +0200, Paolo Bonzini wrote:
> On 14/09/21 09:10, Yang Zhong wrote:
> >On Mon, Sep 13, 2021 at 09:11:51AM -0400, Paolo Bonzini wrote:
> >>Based on discussions from the previous week(end), this series implements
> >>a ioctl that performs EREMOVE on all pages mapped by a /dev/sgx_vepc
> >>file descriptor.  Other possibilities, such as closing and reopening
> >>the device, are racy.
> >>
> >>The patches are untested, but I am posting them because they are simple
> >>and so that Yang Zhong can try using them in QEMU.
> >>
> >
> >   Paolo, i re-implemented one reset patch in the Qemu side to call this ioctl(),
> >   and did some tests on Windows and Linux guest, the Windows/Linux guest reboot
> >   work well.
> >
> >   So, it is time for me to send this reset patch to Qemu community? or wait for
> >   this kernel patchset merged? thanks!
> 
> Let's wait for this patch to be accepted first.  I'll wait a little
> more for Jarkko and Dave to comment on this, and include your
> "Tested-by".
> 
> I will also add cond_resched() on the final submission.
> 

  Thanks Paolo, i will send Qemu patch once this patchset is accepted.

  This day, i also did corner cases test and updated related Qemu reset patch.
   
   do {
       ret = ioctl(fd, SGX_IOC_VEPC_REMOVE);
       /* this printf is only for debug*/
       printf("-------sgx ret=%d and n=%d---\n", ret, n++);
       if(ret)
           sleep(1);
   } while (ret);  

  (1). The VEPC size=10M, start 4 enclaves(each ~2G size) in the VM side.
       then do the 'system_reset' in the Qemu monitor tool.
       
  (2). The VEPC size=10G, start 500 enclaves(each ~20M size) in the VM side.
       then do the 'system_reset' in the Qemu monitor tool.

  The ret will show the failures number(SECS pages number, 4 and 500) got from kernel side,
  after sleep 1s, the ioctl will return 0 failures.

  If this reset is triggered by guest bios, there is 0 SECS page got from kernel, which will
  not block VM booting.

  So, until now, the kernel patches work well. If any new issue, i will update it to all. thanks!      

  Yang

> Paolo
