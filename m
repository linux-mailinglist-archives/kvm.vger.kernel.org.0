Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2AF3EDF46
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 23:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhHPVX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 17:23:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231698AbhHPVXz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 17:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629149003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vzaXs+GwPXQ3GQVxI8ZjHLrHrM+BXcmlyODPhL0Bihc=;
        b=RTcyoJ44efv6zHXua6aDcLFoiooldHWbBFycqRHSZj48/RRMlzruv/VhfpWVh3j2UDXc6n
        /1xanexDfP3nyM6xnM8u1CsDuWpzHFkMFjjHkb/8eh8Yq7a7xY6DbG4Wj6xrYDRM9F3CWz
        oe+dVQ/iaTdN401aC54D/EShSy8xutA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-4tZq8Bt7P1WR7GkucxfLDA-1; Mon, 16 Aug 2021 17:23:22 -0400
X-MC-Unique: 4tZq8Bt7P1WR7GkucxfLDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9E6D100806E;
        Mon, 16 Aug 2021 21:23:20 +0000 (UTC)
Received: from redhat.com (ovpn-113-125.phx2.redhat.com [10.3.113.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BD5D179B3;
        Mon, 16 Aug 2021 21:23:16 +0000 (UTC)
Date:   Mon, 16 Aug 2021 16:23:14 -0500
From:   Eric Blake <eblake@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        jejb@linux.ibm.com, tobin@ibm.com, dovmurik@linux.vnet.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 01/13] machine: Add mirrorvcpus=N suboption to -smp
Message-ID: <20210816212314.kxpbo2sfoxkzliwt@redhat.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <235c91b1b09f11c75bfc60597938c97d3ebb0861.1629118207.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <235c91b1b09f11c75bfc60597938c97d3ebb0861.1629118207.git.ashish.kalra@amd.com>
User-Agent: NeoMutt/20210205-719-68949a
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 01:26:45PM +0000, Ashish Kalra wrote:
> From: Dov Murik <dovmurik@linux.vnet.ibm.com>
> 
> Add a notion of mirror vcpus to CpuTopology, which will allow to
> designate a few vcpus (normally 1) for running the guest
> migration handler (MH).
> 
> Example usage for starting a 4-vcpu guest, of which 1 vcpu is marked as
> mirror vcpu.
> 
>     qemu-system-x86_64 -smp 4,mirrorvcpus=1 ...
> 
> Signed-off-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---

> +++ b/qapi/machine.json
> @@ -1303,6 +1303,8 @@
>  #
>  # @maxcpus: maximum number of hotpluggable virtual CPUs in the virtual machine
>  #
> +# @mirrorvcpus: maximum number of mirror virtual CPUs in the virtual machine
> +#

Needs a '(since 6.2)' tag.

>  # Since: 6.1
>  ##
>  { 'struct': 'SMPConfiguration', 'data': {
> @@ -1311,4 +1313,5 @@
>       '*dies': 'int',
>       '*cores': 'int',
>       '*threads': 'int',
> -     '*maxcpus': 'int' } }
> +     '*maxcpus': 'int',
> +     '*mirrorvcpus': 'int' } }

Is this really the right place to be adding it?  The rest of this
struct feels like things that advertise what bare metal can do, and
therefore what we are emulating.  But bare metal can't do mirrors -
that's something that is completely in the realm of emulation only.
If I understand the cover letter, the guest shouldn't be able to
detect that mirroring exists, which is different from how the guest
DOES detect how many dies, cores, and threads are available to use.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org

