Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC943F8AC9
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 17:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbhHZPO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 11:14:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232291AbhHZPO4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 11:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629990848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XaJ33W+0KXzwWgSHvJ5wqivbA3NRCYaI+PDep1AhJCE=;
        b=RYlwCvdhvFvzZ5eipugGKznOe4wiq3Xyxee6UQIT9R+f39OoX2bkUfvrEvwuloc9tPitI3
        4UlNSTUrbsvJ7JPsvFIvypEbtZj+YpUghxXpF5l03FkMV2JiiZte14SFeTLwceShr+Ll+f
        dZIKJWP83+6dxOXAHjugn6iTpjNTltw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-IuSBh38jMFG5I2GFGoOXjw-1; Thu, 26 Aug 2021 11:14:06 -0400
X-MC-Unique: IuSBh38jMFG5I2GFGoOXjw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EF891853026;
        Thu, 26 Aug 2021 15:14:05 +0000 (UTC)
Received: from redhat.com (ovpn-112-96.phx2.redhat.com [10.3.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 392ED60583;
        Thu, 26 Aug 2021 15:14:00 +0000 (UTC)
Date:   Thu, 26 Aug 2021 10:13:58 -0500
From:   Eric Blake <eblake@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, isaku.yamahata@intel.com,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 31/44] target/i386/tdx: Allows
 mrconfigid/mrowner/mrownerconfig for TDX_INIT_VM
Message-ID: <20210826151358.zjlpyd4ldkq3k75s@redhat.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <9f1e7fd7678900791d2094d2f0def53fe0afc658.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f1e7fd7678900791d2094d2f0def53fe0afc658.1625704981.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20210205-739-420e15
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:55:01PM -0700, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> When creating VM with TDX_INIT_VM, three sha384 hash values are accepted
> for TDX attestation.
> So far they were hard coded as 0. Now allow user to specify those values
> via property mrconfigid, mrowner and mrownerconfig.
> string for those property are hex string of 48 * 2 length.
> 
> example
> -device tdx-guest, \
>   mrconfigid=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef, \
>   mrowner=fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210, \
>   mrownerconfig=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  qapi/qom.json         | 11 ++++++++++-
>  target/i386/kvm/tdx.c | 17 +++++++++++++++++
>  target/i386/kvm/tdx.h |  3 +++
>  3 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 70c70e3efe..8f8b7828b3 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -767,10 +767,19 @@
>  #
>  # @debug: enable debug mode (default: off)
>  #
> +# @mrconfigid: MRCONFIGID SHA384 hex string of 48 * 2 length (default: 0)
> +#
> +# @mrowner: MROWNER SHA384 hex string of 48 * 2 length (default: 0)
> +#
> +# @mrownerconfig: MROWNERCONFIG SHA384 hex string of 48 * 2 length (default: 0)
> +#
>  # Since: 6.0

As these are additions in a later release, they'll need a '(since 6.2)' tag.

>  ##
>  { 'struct': 'TdxGuestProperties',
> -  'data': { '*debug': 'bool' } }
> +  'data': { '*debug': 'bool',
> +            '*mrconfigid': 'str',
> +            '*mrowner': 'str',
> +            '*mrownerconfig': 'str' } }

Do we really want hex-encoded strings?  Elsewhere in QMP, we've
favored the more compact base64 encoding; if you have a strong
argument why hex representation is worth the break in consistency,
it's worth calling out in the commit message.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org

