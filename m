Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047621D0B07
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732373AbgEMImy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:42:54 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:53526 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732346AbgEMImy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 04:42:54 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 362912E150C;
        Wed, 13 May 2020 11:42:47 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id Lvf1JivS35-gkoqsBmE;
        Wed, 13 May 2020 11:42:47 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1589359367; bh=5NzUWpAJZXoZs7gvnFglGRm+eEh8vtjiBT7B4Dq8eR4=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=EZq0rIdhDHwOceoPNtFLs2sTkegJlU4/x90ntgfIsCDGkdqWJasZxL0ilbjHSApjX
         yH/bK6JE0xhwZ0y3PYwkJq8d7TCzxnWn2uE55AZGIbJHINyV2+gtrV20Ao/Gcejc9S
         Uw/IwWGYI0OIPW9D+GEBrOTe8YWhsQ3GPhMHkjHw=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-iva.dhcp.yndx.net (dynamic-iva.dhcp.yndx.net [2a02:6b8:b080:9009::1:1])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id bE48ANP0Aj-gkXK1vOO;
        Wed, 13 May 2020 11:42:46 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Wed, 13 May 2020 11:42:44 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH v11 1/7] x86/kvm/hyper-v: Explicitly align hcall param
 for kvm_hyperv_exit
Message-ID: <20200513084244.GA29650@rvkaganb.lan>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200424113746.3473563-2-arilou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424113746.3473563-2-arilou@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 02:37:40PM +0300, Jon Doron wrote:
> The problem the patch is trying to address is the fact that 'struct
> kvm_hyperv_exit' has different layout on when compiling in 32 and 64 bit
> modes.
> 
> In 64-bit mode the default alignment boundary is 64 bits thus
> forcing extra gaps after 'type' and 'msr' but in 32-bit mode the
> boundary is at 32 bits thus no extra gaps.
> 
> This is an issue as even when the kernel is 64 bit, the userspace using
> the interface can be both 32 and 64 bit but the same 32 bit userspace has
> to work with 32 bit kernel.
> 
> The issue is fixed by forcing the 64 bit layout, this leads to ABI
> change for 32 bit builds and while we are obviously breaking '32 bit
> userspace with 32 bit kernel' case, we're fixing the '32 bit userspace
> with 64 bit kernel' one.
> 
> As the interface has no (known) users and 32 bit KVM is rather baroque
> nowadays, this seems like a reasonable decision.
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 ++
>  include/uapi/linux/kvm.h       | 2 ++
>  2 files changed, 4 insertions(+)

Reviewed-by: Roman Kagan <rvkagan@yandex-team.ru>
