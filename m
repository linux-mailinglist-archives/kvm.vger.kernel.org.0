Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60FD1870DB
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 18:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731947AbgCPRFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 13:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731703AbgCPRFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 13:05:38 -0400
Received: from localhost (c-67-164-102-47.hsd1.ca.comcast.net [67.164.102.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1ECE2051A;
        Mon, 16 Mar 2020 17:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584378338;
        bh=SBAgB4tnN5H5EqyYoewhaMY5csYHCmQVwSVf76yy/gs=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=BbwwfdvrJpLp/NaruIf9GnCrZSbOkn0rguWsZRP8XubJ0BcYb1I4HyZTcDujkziS0
         BHqsjjbo5+FN5/KvuxaBSKYIQReW/29r1van7t7IZ3ZjNWnkM2mJVIko32wAkDklr9
         Ak1FL3P/W7gO5l+lUODN2MDa2HvaVn/f5qowIYMg=
Date:   Mon, 16 Mar 2020 10:05:37 -0700 (PDT)
From:   Stefano Stabellini <sstabellini@kernel.org>
X-X-Sender: sstabellini@sstabellini-ThinkPad-T480s
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@redhat.com>
cc:     qemu-devel@nongnu.org,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 18/19] hw/arm: Do not build to 'virt' machine on Xen
In-Reply-To: <20200316160634.3386-19-philmd@redhat.com>
Message-ID: <alpine.DEB.2.21.2003161001510.1269@sstabellini-ThinkPad-T480s>
References: <20200316160634.3386-1-philmd@redhat.com> <20200316160634.3386-19-philmd@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1799168742-1584378221=:1269"
Content-ID: <alpine.DEB.2.21.2003161003470.1269@sstabellini-ThinkPad-T480s>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1799168742-1584378221=:1269
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.21.2003161003471.1269@sstabellini-ThinkPad-T480s>

On Mon, 16 Mar 2020, Philippe Mathieu-Daudé wrote:
> Xen on ARM does not use QEMU machines [*]. Disable the 'virt'
> machine there to avoid odd errors such:
> 
>     CC      i386-softmmu/hw/cpu/a15mpcore.o
>   hw/cpu/a15mpcore.c:28:10: fatal error: kvm_arm.h: No such file or directory
> 
> [*] https://wiki.xenproject.org/wiki/Xen_ARM_with_Virtualization_Extensions#Use_of_qemu-system-i386_on_ARM


I confirm that what's written on that wikipage is correct: Xen on ARM
doesn't use QEMU for emulation, only as a PV backends provider. As such,
and also because the code is a bit entangled with the x86 platform, even
on ARM we are building and running qemu-system-i386 to get the PV disk
and PV framebuffer. Of course, no x86 emulation is actually done.

Ideally we would have a non-arch-specific machine type for the PV
backends, but that doesn't exist today.

In short, I think this patch is fine, at least until somebody comes
around and tries to add emulation to Xen on ARM.



> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
> Cc: Stefano Stabellini <sstabellini@kernel.org>
> Cc: Anthony Perard <anthony.perard@citrix.com>
> Cc: Paul Durrant <paul@xen.org>
> Cc: xen-devel@lists.xenproject.org
> ---
>  hw/arm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index 8e801cd15f..69a8e30125 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -1,5 +1,6 @@
>  config ARM_VIRT
>      bool
> +    depends on !XEN
>      default y if KVM
>      imply PCI_DEVICES
>      imply TEST_DEVICES
> -- 
> 2.21.1
> 
--8323329-1799168742-1584378221=:1269--
