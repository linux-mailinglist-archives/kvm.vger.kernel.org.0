Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F7C2D13EF
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 15:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgLGOpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 09:45:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgLGOpX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 09:45:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607352237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yYikCPcIPVfkQPyOTA1er7+ojxS2PgeXAGCbiR51IuI=;
        b=iHwXxWisxMiXzPL6x/bK02QYfui7KaNo1aOqsdWC2uhmJRBz1IFgL9GSz9D2kARYnr5uR/
        hT57THpM41hFGPfC/1mzUr+6+qc2giFdhWxnQwiQhp/neLj2aBdegESbGoQma77oG+FRYJ
        PxWG6i+GSLLzsaC6BBhDd0977aBpF/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-SPQGlG4kPs6bEH4OCatr7A-1; Mon, 07 Dec 2020 09:43:56 -0500
X-MC-Unique: SPQGlG4kPs6bEH4OCatr7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EB25107ACE6;
        Mon,  7 Dec 2020 14:43:54 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0439760C0F;
        Mon,  7 Dec 2020 14:43:45 +0000 (UTC)
Subject: Re: [PATCH v3 5/5] gitlab-ci: Add Xen cross-build jobs
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-s390x@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Cornelia Huck <cohuck@redhat.com>,
        xen-devel@lists.xenproject.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
References: <20201207131503.3858889-1-philmd@redhat.com>
 <20201207131503.3858889-6-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f69be51c-1a16-8c5a-f46c-d621d905c9ca@redhat.com>
Date:   Mon, 7 Dec 2020 15:43:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201207131503.3858889-6-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2020 14.15, Philippe Mathieu-Daudé wrote:
> Cross-build ARM and X86 targets with only Xen accelerator enabled.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  .gitlab-ci.d/crossbuilds.yml | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
> index 51896bbc9fb..bd6473a75a7 100644
> --- a/.gitlab-ci.d/crossbuilds.yml
> +++ b/.gitlab-ci.d/crossbuilds.yml
> @@ -134,3 +134,17 @@ cross-win64-system:
>    extends: .cross_system_build_job
>    variables:
>      IMAGE: fedora-win64-cross
> +
> +cross-amd64-xen-only:
> +  extends: .cross_accel_build_job
> +  variables:
> +    IMAGE: debian-amd64-cross
> +    ACCEL: xen
> +    ACCEL_CONFIGURE_OPTS: --disable-tcg --disable-kvm
> +
> +cross-arm64-xen-only:
> +  extends: .cross_accel_build_job
> +  variables:
> +    IMAGE: debian-arm64-cross
> +    ACCEL: xen
> +    ACCEL_CONFIGURE_OPTS: --disable-tcg --disable-kvm

Reviewed-by: Thomas Huth <thuth@redhat.com>


