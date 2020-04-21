Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02F71B2F88
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgDUSr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726012AbgDUSr6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 14:47:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BC4C0610D5;
        Tue, 21 Apr 2020 11:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=76M7+1Sr4SkV4k1jNKhJ5SiMeMdDXpYSUYbS88cAIiY=; b=ESaRYqCnMzn90s++UMzbJoGIdq
        kOzlLzBzXljYc9c2vz8kRuhB2nCHJ8JQBakiMg+uqyl8sf58KN2DMyHTEYmSOGy4Wfn+BxKe5rIAr
        wa/efYLiMhnnXg8NPALjtQJjS3bdy+/KvwCgPdZUitBY9OrvffP2ddMeLvsJsxNMlWnr7s5yN/fxr
        jiqZT+jACsUqUQaGx4/cQwX1GQGbZzhKPUY7df4XAFFfjDj+XHXNTsQRsAmBfJQ6utni5ZAQ6gxg6
        DK2zYvzEu07eLmt25cmKMsdZXlldDQGifRINMe9SQw5p5A4AGTpRv4XYh4I3uVunPz9ZJOQELktSx
        WzDVOLWA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jQxw5-00071K-IU; Tue, 21 Apr 2020 18:47:57 +0000
Subject: Re: [PATCH v1 01/15] nitro_enclaves: Add ioctl interface definition
To:     Andra Paraschiv <andraprs@amazon.com>, linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <20200421184150.68011-2-andraprs@amazon.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7e0cb729-60ca-3b2e-909b-8883b24908a8@infradead.org>
Date:   Tue, 21 Apr 2020 11:47:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421184150.68011-2-andraprs@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi--

On 4/21/20 11:41 AM, Andra Paraschiv wrote:
> The Nitro Enclaves driver handles the enclave lifetime management. This
> includes enclave creation, termination and setting up its resources such
> as memory and CPU.
> 
> An enclave runs alongside the VM that spawned it. It is abstracted as a
> process running in the VM that launched it. The process interacts with
> the NE driver, that exposes an ioctl interface for creating an enclave
> and setting up its resources.
> 
> Include the KVM API as part of the provided ioctl interface, with an
> additional ENCLAVE_START ioctl command that triggers the enclave run.
> 
> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
>  include/linux/nitro_enclaves.h      | 23 +++++++++++++
>  include/uapi/linux/nitro_enclaves.h | 52 +++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+)
>  create mode 100644 include/linux/nitro_enclaves.h
>  create mode 100644 include/uapi/linux/nitro_enclaves.h
> 

> diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
> new file mode 100644
> index 000000000000..b90dfcf6253a
> --- /dev/null
> +++ b/include/uapi/linux/nitro_enclaves.h
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
> +#define _UAPI_LINUX_NITRO_ENCLAVES_H_
> +
> +#include <linux/kvm.h>
> +#include <linux/types.h>
> +
> +/* Nitro Enclaves (NE) Kernel Driver Interface */
> +
> +/**
> + * The command is used to trigger enclave start after the enclave resources,
> + * such as memory and CPU, have been set.
> + *
> + * The enclave start metadata is an in / out data structure. It includes
> + * provided info by the caller - enclave cid and flags - and returns the
> + * slot uid and the cid (if input cid is 0).
> + */
> +#define NE_ENCLAVE_START _IOWR('B', 0x1, struct enclave_start_metadata)

Please document ioctl major ('B' in this case) and range used in
Documentation/userspace-api/ioctl/ioctl-number.rst.

> +
> +/* Setup metadata necessary for enclave start. */
> +struct enclave_start_metadata {
> +	/* Flags for the enclave to start with (e.g. debug mode) (in). */
> +	__u64 flags;
> +
> +	/**
> +	 * Context ID (CID) for the enclave vsock device. If 0 as input, the
> +	 * CID is autogenerated by the hypervisor and returned back as output
> +	 * by the driver (in/out).
> +	 */
> +	__u64 enclave_cid;
> +
> +	/* Slot unique id mapped to the enclave to start (out). */
> +	__u64 slot_uid;
> +};
> +
> +#endif /* _UAPI_LINUX_NITRO_ENCLAVES_H_ */
> 

thanks.
-- 
~Randy

