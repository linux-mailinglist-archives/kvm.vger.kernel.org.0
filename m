Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525823F8AB2
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 17:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242901AbhHZPHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 11:07:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234068AbhHZPHu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 11:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629990423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G2Q2x7WOo9oasuIA3XWldpXDoxM+ky2X6T8xE/JmZNk=;
        b=TX4UMwcV8xbtaUFs76+NebtceXbPeZLv6N1enAp8bPWepjpvefci5jKwaqJ5p+NnshjdT+
        7EuDPHb7vK2pR4w2F2sBcP/maVC7BATsPOI2tash6vNNIakSp+qckaD/ECP7Srwxr6OvG1
        2y6mWwD/IpJO6XurLAR1DIj5eHn6Nbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-PCjM7CiCMkOrfpPea-3Y0w-1; Thu, 26 Aug 2021 11:07:01 -0400
X-MC-Unique: PCjM7CiCMkOrfpPea-3Y0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 182B61853026;
        Thu, 26 Aug 2021 15:07:00 +0000 (UTC)
Received: from redhat.com (ovpn-112-96.phx2.redhat.com [10.3.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F1F2B5D9FC;
        Thu, 26 Aug 2021 15:06:54 +0000 (UTC)
Date:   Thu, 26 Aug 2021 10:06:53 -0500
From:   Eric Blake <eblake@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 10/44] hw/i386: Initialize TDX via KVM ioctl()
 when kvm_type is TDX
Message-ID: <20210826150653.3vurw57fluf53cnt@redhat.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <d173ac1f4524153b738309530c6a6599aeaa18fd.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d173ac1f4524153b738309530c6a6599aeaa18fd.1625704981.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20210205-739-420e15
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:54:40PM -0700, isaku.yamahata@gmail.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Introduce tdx_ioctl() to invoke TDX specific sub-ioctls of
> KVM_MEMORY_ENCRYPT_OP.  Use tdx_ioctl() to invoke KVM_TDX_INIT, by way
> of tdx_init(), during kvm_arch_init().  KVM_TDX_INIT configures global
> TD state, e.g. the canonical CPUID config, and must be executed prior to
> creating vCPUs.
> 
> Note, this doesn't address the fact that Qemu may change the CPUID
> configuration when creating vCPUs, i.e. punts on refactoring Qemu to
> provide a stable CPUID config prior to kvm_arch_init().
> 
> Explicitly set subleaf index and flags when adding CPUID
> Set the index and flags when adding a CPUID entry to avoid propagating
> stale state from a removed entry, e.g. when the CPUID 0x4 loop bails, it
> can leave non-zero index and flags in the array.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---

> +++ b/qapi/qom.json
> @@ -760,6 +760,18 @@
>              '*cbitpos': 'uint32',
>              'reduced-phys-bits': 'uint32' } }
>  
> +##
> +# @TdxGuestProperties:
> +#
> +# Properties for tdx-guest objects.
> +#
> +# @debug: enable debug mode (default: off)
> +#
> +# Since: 6.0

This should be 6.2

> +##
> +{ 'struct': 'TdxGuestProperties',
> +  'data': { '*debug': 'bool' } }
> +
>  ##
>  # @ObjectType:
>  #
> @@ -802,6 +814,7 @@
>      'secret_keyring',
>      'sev-guest',
>      's390-pv-guest',
> +    'tdx-guest',
>      'throttle-group',
>      'tls-creds-anon',
>      'tls-creds-psk',
> @@ -858,6 +871,7 @@
>        'secret':                     'SecretProperties',
>        'secret_keyring':             'SecretKeyringProperties',
>        'sev-guest':                  'SevGuestProperties',
> +      'tdx-guest':                  'TdxGuestProperties',
>        'throttle-group':             'ThrottleGroupProperties',
>        'tls-creds-anon':             'TlsCredsAnonProperties',
>        'tls-creds-psk':              'TlsCredsPskProperties',

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org

