Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E77287B4B
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 19:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgJHR7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 13:59:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:7530 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgJHR7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 13:59:53 -0400
IronPort-SDR: Vz2D/nA2l2Erzz62s8YB7+8xt2KndIHt0EwXXnk7P2IPK+hDqOE667+ZzEhW4Iimy7cQnlTBxJ
 OeMsYYPhU1ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="182812617"
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="182812617"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 10:59:52 -0700
IronPort-SDR: apRGQIolZEqv+ssgLkRhSYdoCY6/uRdymbzZHfnYFBg4iX/xWquNT1iZARIcLmTtbYCuhEZQvh
 o4SZbACwZ3Ew==
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="312283179"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 10:59:52 -0700
Date:   Thu, 8 Oct 2020 10:59:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup
Message-ID: <20201008175951.GA9267@linux.intel.com>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
 <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 08, 2020 at 07:00:13PM +0300, stsp wrote:
> 07.10.2020 04:44, Sean Christopherson пишет:
> >Two bug fixes to handle KVM_SET_SREGS without a preceding KVM_SET_CPUID2.
> Hi Sean & KVM devs.
> 
> I tested the patches, and wherever I
> set VMXE in CR4, I now get
> KVM: KVM_SET_SREGS: Invalid argument
> Before the patch I was able (with many
> problems, but still) to set VMXE sometimes.
> 
> So its a NAK so far, waiting for an update. :)

IIRC, you said you were going to test on AMD?  Assuming that's correct, -EINVAL
is the expected behavior.  KVM was essentially lying before; it never actually
set CR4.VMXE in hardware, it just didn't properply detect the error and so VMXE
was set in KVM's shadow of the guest's CR4.
