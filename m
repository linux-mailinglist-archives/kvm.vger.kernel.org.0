Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FD11C7606
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgEFQMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:12:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32466 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729610AbgEFQMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 12:12:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZRDjL7nazpxt3wSuOJ5/WwzUELoarexy41YvOu/dZk=;
        b=SkNYtRrZRdBg7a5ZvQQo9V5c0Gxha1HH5bf28A6gqxdLCtBXFLqExjwtMvXG5NITAfrmGk
        vLl+dZ84jrhAYsXrl8xRHjyPSnzgQMZkmpzAmXJQIUX9it/vGkfwZUJ9Y9vg3F7clDdORp
        sjpEXNyKGBsAIEofTeNVF9yMm4nbaLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-l-m5nLYwP7axoWQd8MLKoA-1; Wed, 06 May 2020 12:12:37 -0400
X-MC-Unique: l-m5nLYwP7axoWQd8MLKoA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E01D41005510;
        Wed,  6 May 2020 16:12:35 +0000 (UTC)
Received: from [10.3.114.73] (ovpn-114-73.phx2.redhat.com [10.3.114.73])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F6CA6299C;
        Wed,  6 May 2020 16:12:29 +0000 (UTC)
Subject: Re: [PATCH v1 10/17] virtio-mem: Paravirtualized memory hot(un)plug
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-11-david@redhat.com>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <051610a8-4773-2de5-0d4c-48e39791f05e@redhat.com>
Date:   Wed, 6 May 2020 11:12:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506094948.76388-11-david@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/20 4:49 AM, David Hildenbrand wrote:
> This is the very basic/initial version of virtio-mem. An introduction to
> virtio-mem can be found in the Linux kernel driver [1]. While it can be
> used in the current state for hotplug of a smaller amount of memory, it
> will heavily benefit from resizeable memory regions in the future.
> 
> Each virtio-mem device manages a memory region (provided via a memory
> backend). After requested by the hypervisor ("requested-size"), the
> guest can try to plug/unplug blocks of memory within that region, in order
> to reach the requested size. Initially, and after a reboot, all memory is
> unplugged (except in special cases - reboot during postcopy).
> 
> The guest may only try to plug/unplug blocks of memory within the usable
> region size. The usable region size is a little bigger than the
> requested size, to give the device driver some flexibility. The usable
> region size will only grow, except on reboots or when all memory is
> requested to get unplugged. The guest can never plug more memory than
> requested. Unplugged memory will get zapped/discarded, similar to in a
> balloon device.
> 
> The block size is variable, however, it is always chosen in a way such that
> THP splits are avoided (e.g., 2MB). The state of each block
> (plugged/unplugged) is tracked in a bitmap.
> 
> As virtio-mem devices (e.g., virtio-mem-pci) will be memory devices, we now
> expose "VirtioMEMDeviceInfo" via "query-memory-devices".
> 

> +++ b/qapi/misc.json
> @@ -1354,19 +1354,56 @@
>             }
>   }
>   
> +##
> +# @VirtioMEMDeviceInfo:
> +#

> +# @memdev: memory backend linked with the region
> +#
> +# Since: 5.1

Here you claim 5.1,

> +##
> +{ 'struct': 'VirtioMEMDeviceInfo',
> +  'data': { '*id': 'str',
> +            'memaddr': 'size',
> +            'requested-size': 'size',
> +            'size': 'size',
> +            'max-size': 'size',
> +            'block-size': 'size',
> +            'node': 'int',
> +            'memdev': 'str'
> +          }
> +}
> +
>   ##
>   # @MemoryDeviceInfo:
>   #
>   # Union containing information about a memory device
>   #
>   # nvdimm is included since 2.12. virtio-pmem is included since 4.1.
> +# virtio-mem is included since 5.2.

but here 5.2.  They should probably be the same :)

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

