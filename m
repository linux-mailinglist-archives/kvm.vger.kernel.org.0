Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779F41C1E4E
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 22:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgEAUSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 16:18:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:43681 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAUSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 16:18:37 -0400
IronPort-SDR: KgY3oqt3PPtapMb+U91UqjGB7/Uyg/o+zT7SLAsVphlnG1NoxZlvzAujic8jclOvWAg93YHq0b
 Ce624zheFcww==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 13:18:37 -0700
IronPort-SDR: hxrraMGFZU4NpRZqTnivv/G+Fa1fPCvrMCuNhSyVoJ8gQiqMJ40ejpUf6SaLfWFZudKbORQWTZ
 74TfWVfb4lxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,340,1583222400"; 
   d="scan'208";a="460016158"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 01 May 2020 13:18:36 -0700
Date:   Fri, 1 May 2020 13:18:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joshua Abraham <j.abraham1776@gmail.com>
Cc:     pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: kvm: Fix KVM_KVMCLOCK_CTRL API doc
Message-ID: <20200501201836.GB4760@linux.intel.com>
References: <20200501193404.GA19745@josh-ZenBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501193404.GA19745@josh-ZenBook>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 03:34:06PM -0400, Joshua Abraham wrote:
> The KVM_KVMCLOCK_CTRL ioctl signals to supported KVM guests
> that the hypervisor has paused it.  This updates the documentation
> to reflect that the guest, not the host is notified by this API.

No, the current documentation is correct.  It's probably not as clear as
it could be, but it's accurate as written.  More below.

> Signed-off-by: Joshua Abraham <j.abraham1776@gmail.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index efbbe570aa9b..06a4d9bfc6e5 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2572,7 +2572,7 @@ list in 4.68.
>  :Parameters: None
>  :Returns: 0 on success, -1 on error
>  
> -This signals to the host kernel that the specified guest is being paused by
> +This signals to the guest kernel that the specified guest is being paused by
>  userspace.

The ioctl() signals to the host kernel that host userspace has paused the
vCPU.

>  The host will set a flag in the pvclock structure that is checked

The host kernel, i.e. KVM, then takes that information and forwards it to
the guest kernel via the aforementioned pvclock flag.

The proposed change would imply the ioctl() is somehow getting routed
directly to the guest, which is wrong.

>  from the soft lockup watchdog.  The flag is part of the pvclock structure that
>  is shared between guest and host, specifically the second bit of the flags
> -- 
> 2.17.1
> 
