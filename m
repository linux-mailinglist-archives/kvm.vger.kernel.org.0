Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DC81F0880
	for <lists+kvm@lfdr.de>; Sat,  6 Jun 2020 22:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgFFUVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jun 2020 16:21:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55477 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728350AbgFFUVj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 6 Jun 2020 16:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591474898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o4jqwUMVsfsSvwCMKervPyctKjmw5vEX56fqpclyMnA=;
        b=Hs0BuDV7J94R/R/Z5TPQQjiP/lZA8FWNhCF94XsGVd7eCDAUBfzrW3V4cQqJVIvW0mIvI3
        rfHW4Ql9vUbgXDKQk0Qzx59BD/elJpO3Kp10eBcuHBDBnseJoN2U8VjOFQFgfUisq13OIv
        qZFJyB20anH85pewvJahRzpR6CmsQoM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-NbQlkw-GOB-R_WvehTcjIA-1; Sat, 06 Jun 2020 16:21:36 -0400
X-MC-Unique: NbQlkw-GOB-R_WvehTcjIA-1
Received: by mail-wr1-f72.google.com with SMTP id p10so5368780wrn.19
        for <kvm@vger.kernel.org>; Sat, 06 Jun 2020 13:21:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o4jqwUMVsfsSvwCMKervPyctKjmw5vEX56fqpclyMnA=;
        b=HBtpmI13ESClScI+YkRFOnMb345S1DORq3ZBAW7Oe3+FzGbH3Y+MQ9o2VUZhBLg35d
         +iTc5w2ORuApUn0OxLUxRqzdy51OBDPgSIyhOkP4PupgP78rYPZFcxAjgNL6qAVnc64o
         m3mNyqxXD1phCZlETR2UqPEovDueqe0706WkLGj7FdB1ZWAWWJu/fgvv6t3oTDoFukJ2
         m7FqfKXZ/RIBNz4R8SSQL3dULjek92o4DsEwVBivef55oJzfa27uCHWbKNUzJJFKs3td
         GdpEnk6R4oOlU2Scn4/ijLS48l05NrLHwXY8oKaFjSmXoXA151NvqvPFn6mRJ+sdn/UT
         MaDg==
X-Gm-Message-State: AOAM533PaOaypxtTwYvIDQx3lPXlkDQA5zje1BYVwMZmr3jnKlgkp+Pg
        2sAL1+KH6LxaQbo/PQrI69j97DSKh4qTZO/djfALI9a7yzYIVBIntazD6/93EmZnsebeSrUORBz
        GhHg6ZHcR/wDQ
X-Received: by 2002:a1c:ab07:: with SMTP id u7mr8676866wme.130.1591474895285;
        Sat, 06 Jun 2020 13:21:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxD8oca7c9F3z/cHyLGoqmFQRETj0bXMVLckH6LgfSMPy8x0Bsfwmowbutieyi6uCszvoqWhA==
X-Received: by 2002:a1c:ab07:: with SMTP id u7mr8676852wme.130.1591474894974;
        Sat, 06 Jun 2020 13:21:34 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id t189sm16775933wma.4.2020.06.06.13.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 13:21:34 -0700 (PDT)
Date:   Sat, 6 Jun 2020 16:21:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 18/18] guest memory protection: Alter virtio default
 properties for protected guests
Message-ID: <20200606162014-mutt-send-email-mst@kernel.org>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-19-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521034304.340040-19-david@gibson.dropbear.id.au>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 21, 2020 at 01:43:04PM +1000, David Gibson wrote:
> The default behaviour for virtio devices is not to use the platforms normal
> DMA paths, but instead to use the fact that it's running in a hypervisor
> to directly access guest memory.  That doesn't work if the guest's memory
> is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> 
> So, if a guest memory protection mechanism is enabled, then apply the
> iommu_platform=on option so it will go through normal DMA mechanisms.
> Those will presumably have some way of marking memory as shared with the
> hypervisor or hardware so that DMA will work.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  hw/core/machine.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 88d699bceb..cb6580954e 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -28,6 +28,8 @@
>  #include "hw/mem/nvdimm.h"
>  #include "migration/vmstate.h"
>  #include "exec/guest-memory-protection.h"
> +#include "hw/virtio/virtio.h"
> +#include "hw/virtio/virtio-pci.h"
>  
>  GlobalProperty hw_compat_5_0[] = {};
>  const size_t hw_compat_5_0_len = G_N_ELEMENTS(hw_compat_5_0);
> @@ -1159,6 +1161,15 @@ void machine_run_board_init(MachineState *machine)
>           * areas.
>           */
>          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> +
> +        /*
> +         * Virtio devices can't count on directly accessing guest
> +         * memory, so they need iommu_platform=on to use normal DMA
> +         * mechanisms.  That requires disabling legacy virtio support
> +         * for virtio pci devices
> +         */
> +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy", "on");
> +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform", "on");
>      }
>  

I think it's a reasonable way to address this overall.
As Cornelia has commented, addressing ccw as well as cases where user has
specified the property manually could be worth-while.

>      machine_class->init(machine);
> -- 
> 2.26.2

