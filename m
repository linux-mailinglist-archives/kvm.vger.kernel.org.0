Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BCF49C6F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 10:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfFRIzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 04:55:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728991AbfFRIzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 04:55:44 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6EA593082231;
        Tue, 18 Jun 2019 08:55:44 +0000 (UTC)
Received: from work-vm (ovpn-117-76.ams2.redhat.com [10.36.117.76])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7196B1A8EC;
        Tue, 18 Jun 2019 08:55:42 +0000 (UTC)
Date:   Tue, 18 Jun 2019 09:55:40 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, maran.wilson@oracle.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Subject: Re: [QEMU PATCH v3 6/9] vmstate: Add support for kernel integer types
Message-ID: <20190618085539.GB2850@work-vm>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-7-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617175658.135869-7-liran.alon@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 18 Jun 2019 08:55:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Liran Alon (liran.alon@oracle.com) wrote:
> Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> Reviewed-by: Maran Wilson <maran.wilson@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  include/migration/vmstate.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/include/migration/vmstate.h b/include/migration/vmstate.h
> index 9224370ed59a..a85424fb0483 100644
> --- a/include/migration/vmstate.h
> +++ b/include/migration/vmstate.h
> @@ -797,6 +797,15 @@ extern const VMStateInfo vmstate_info_qtailq;
>  #define VMSTATE_UINT64_V(_f, _s, _v)                                  \
>      VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint64, uint64_t)

A comment here stating they're for Linux kernel types would be nice.

> +#define VMSTATE_U8_V(_f, _s, _v)                                   \
> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint8, __u8)
> +#define VMSTATE_U16_V(_f, _s, _v)                                  \
> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint16, __u16)
> +#define VMSTATE_U32_V(_f, _s, _v)                                  \
> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint32, __u32)
> +#define VMSTATE_U64_V(_f, _s, _v)                                  \
> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint64, __u64)
> +

Have you checked that builds OK on a non-Linux system?

Dave

>  #define VMSTATE_BOOL(_f, _s)                                          \
>      VMSTATE_BOOL_V(_f, _s, 0)
>  
> @@ -818,6 +827,15 @@ extern const VMStateInfo vmstate_info_qtailq;
>  #define VMSTATE_UINT64(_f, _s)                                        \
>      VMSTATE_UINT64_V(_f, _s, 0)
>  
> +#define VMSTATE_U8(_f, _s)                                         \
> +    VMSTATE_U8_V(_f, _s, 0)
> +#define VMSTATE_U16(_f, _s)                                        \
> +    VMSTATE_U16_V(_f, _s, 0)
> +#define VMSTATE_U32(_f, _s)                                        \
> +    VMSTATE_U32_V(_f, _s, 0)
> +#define VMSTATE_U64(_f, _s)                                        \
> +    VMSTATE_U64_V(_f, _s, 0)
> +
>  #define VMSTATE_UINT8_EQUAL(_f, _s, _err_hint)                        \
>      VMSTATE_SINGLE_FULL(_f, _s, 0, 0,                                 \
>                          vmstate_info_uint8_equal, uint8_t, _err_hint)
> -- 
> 2.20.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
