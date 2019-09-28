Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BE5C1008
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 09:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfI1HQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 03:16:47 -0400
Received: from ms.lwn.net ([45.79.88.28]:35680 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfI1HQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 03:16:46 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 30D802B4;
        Sat, 28 Sep 2019 07:16:43 +0000 (UTC)
Date:   Sat, 28 Sep 2019 01:16:39 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Stephen Kitt <steve@sk2.org>
Cc:     linux-doc@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-can@vger.kernel.org, linux-afs@lists.infradead.org,
        kvm@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] docs: use flexible array members, not zero-length
Message-ID: <20190928011639.7c983e77@lwn.net>
In-Reply-To: <20190927142927.27968-1-steve@sk2.org>
References: <20190927142927.27968-1-steve@sk2.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Sep 2019 16:29:27 +0200
Stephen Kitt <steve@sk2.org> wrote:

> Update the docs throughout to remove zero-length arrays, replacing
> them with C99 flexible array members. GCC will then ensure that the
> arrays are always the last element in the struct.

I appreciate the thought but...

> diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
> index 4d565d202ce3..24ce50fc1fc1 100644
> --- a/Documentation/bpf/btf.rst
> +++ b/Documentation/bpf/btf.rst
> @@ -670,7 +670,7 @@ func_info for each specific ELF section.::
>          __u32   sec_name_off; /* offset to section name */
>          __u32   num_info;
>          /* Followed by num_info * record_size number of bytes */
> -        __u8    data[0];
> +        __u8    data[];
>       };

I only checked this one, but found what I had expected: the actual
definition of this structure (found in tools/lib/bpf/libbpf_internal.h)
says "data[0]".  We can't really make the documentation read the way we
*wish* the source would be, we need to document reality.

I'm pretty sure that most of the other examples will be the same.

If you really want to fix these, the right solution is to fix the offending
structures — one patch per structure — in the source, then update the
documentation to match the new reality.

Thanks,

jon
