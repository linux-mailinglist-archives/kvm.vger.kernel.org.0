Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315003F8AEC
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 17:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbhHZPWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 11:22:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56160 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232271AbhHZPWf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 11:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629991307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HKJtNOOJpZ5IR7MBevz7FJGgAL9UgE1nCuyjwiC5a/Q=;
        b=AuJQ/T7qEOZQNjXsOEeMGGj5zJ/bUihiZ5SrihtXAMgfMuklsH5dNmWcREgkB+GdKocJAi
        Hn7N4W9lW9HouoyJ7G7Vjao3r9irrlWBcfQzr58XptEWz4JPsOQssoRov46jfkPQCNrScs
        MUVAtpdP2O3gpjXgoTT+kI7Qhqp7Hxg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-hmpzrJpHNx6FZk_Bxr_bXg-1; Thu, 26 Aug 2021 11:21:46 -0400
X-MC-Unique: hmpzrJpHNx6FZk_Bxr_bXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB25B1008067;
        Thu, 26 Aug 2021 15:21:44 +0000 (UTC)
Received: from redhat.com (ovpn-112-96.phx2.redhat.com [10.3.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D61A25C1D5;
        Thu, 26 Aug 2021 15:21:39 +0000 (UTC)
Date:   Thu, 26 Aug 2021 10:21:38 -0500
From:   Eric Blake <eblake@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [RFC PATCH v2 33/44] qmp: add query-tdx-capabilities query-tdx
 command
Message-ID: <20210826152138.4ashihjr3ccakn5j@redhat.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <f9391aea17154c05a8d51da8a15b8aec4e2d5873.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9391aea17154c05a8d51da8a15b8aec4e2d5873.1625704981.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20210205-739-420e15
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:55:03PM -0700, isaku.yamahata@gmail.com wrote:
> From: Chenyi Qiang <chenyi.qiang@intel.com>
> 
> Add QMP commands that can be used by libvirt to query the TDX capabilities
> and TDX info.  The set of capabilities that needs to be reported is only
> enabled at the moment, which means TDX is enabled.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  include/sysemu/tdx.h       |  6 ++++
>  qapi/misc-target.json      | 59 ++++++++++++++++++++++++++++++++++++++

In addition to Gerd's suggestion to use an enum,

> +++ b/qapi/misc-target.json
> @@ -323,3 +323,62 @@
>  { 'command': 'query-sev-attestation-report', 'data': { 'mnonce': 'str' },
>    'returns': 'SevAttestationReport',
>    'if': 'defined(TARGET_I386)' }
> +
> +##
> +# @TDXInfo:
> +#
> +# Information about Trust Domain Extensions (TDX) support
> +#
> +# @enabled: true if TDX is active
> +#
> +##

Missing a 'Since: 6.2' line, here and elsewhere in the patch.

> +{ 'struct': 'TDXInfo',
> +    'data': { 'enabled': 'bool' },
> +  'if': 'defined(TARGET_I386)'
> +}
> +
> +##
> +# @query-tdx:
> +#
> +# Returns information about TDX
> +#
> +# Returns: @TdxInfo
> +#
> +#
> +# Example:
> +#
> +# -> { "execute": "query-tdx" }
> +# <- { "return": { "enabled": true } }
> +#
> +##
> +{ 'command': 'query-tdx', 'returns': 'TDXInfo',
> +  'if': 'defined(TARGET_I386)' }
> +
> +##
> +# @TDXCapability:
> +#
> +# The struct describes capability for a TDX
> +# feature.
> +#
> +##
> +{ 'struct': 'TDXCapability',
> +  'data': { 'enabled': 'bool' },
> +  'if': 'defined(TARGET_I386)' }
> +
> +##
> +# @query-tdx-capabilities:

Do we need two separate commands, or could 'query-tdx' be made
sufficiently powerful to tell you both whether tdx is available, and
what capabilities it has, all in one command?

> +#
> +# This command is used to get the TDX capabilities, and is supported on Intel
> +# X86 platforms only.
> +#
> +# Returns: @TDXCapability.
> +#
> +#
> +# Example:
> +#
> +# -> { "execute": "query-tdx-capabilities" }
> +# <- { "return": { 'enabled': 'bool' }}
> +#
> +##
> +{ 'command': 'query-tdx-capabilities', 'returns': 'TDXCapability',
> +  'if': 'defined(TARGET_I386)' }

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org

