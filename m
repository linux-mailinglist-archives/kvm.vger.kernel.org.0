Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD492D0F90
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgLGLjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:39:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726696AbgLGLjk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:39:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607341094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=muAFbZHcdnlA540NVtllekXZu37z+fEhka8P0LY3Jqw=;
        b=Levx0tKtdR2is0Sa1SwqQws+LdMGx3xmYaaLxkpgpHCdjSQ7g1jWGNKP0bycmf3WG4ptPk
        teTjg2w6RpVeJJg+5VHCfyFBkpiyfU6UcAkTXbbr4Ucv5sqJWB+dKyZp2x1JH7+QZHOPMj
        R2PoiMB8sE+VaA+SNLuuJALGpflKRKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-sho2lGVVNdOBmTUquj-bNA-1; Mon, 07 Dec 2020 06:38:13 -0500
X-MC-Unique: sho2lGVVNdOBmTUquj-bNA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D013B180A08A;
        Mon,  7 Dec 2020 11:38:10 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 195BC60BD8;
        Mon,  7 Dec 2020 11:38:00 +0000 (UTC)
Subject: Re: [PATCH v2 3/5] gitlab-ci: Introduce 'cross_accel_build_job'
 template
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Willian Rampazzo <wrampazz@redhat.com>, qemu-s390x@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        xen-devel@lists.xenproject.org, Paul Durrant <paul@xen.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>
References: <20201207112353.3814480-1-philmd@redhat.com>
 <20201207112353.3814480-4-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <93d186c0-feea-8e47-2a03-5276fb898bff@redhat.com>
Date:   Mon, 7 Dec 2020 12:37:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201207112353.3814480-4-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2020 12.23, Philippe Mathieu-Daudé wrote:
> Introduce a job template to cross-build accelerator specific
> jobs (enable a specific accelerator, disabling the others).
> 
> The specific accelerator is selected by the $ACCEL environment
> variable (default to KVM).
> 
> Extra options such disabling other accelerators are passed
> via the $ACCEL_CONFIGURE_OPTS environment variable.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  .gitlab-ci.d/crossbuilds.yml | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
> index 099949aaef3..d8685ade376 100644
> --- a/.gitlab-ci.d/crossbuilds.yml
> +++ b/.gitlab-ci.d/crossbuilds.yml
> @@ -13,6 +13,23 @@
>            xtensa-softmmu"
>      - make -j$(expr $(nproc) + 1) all check-build
>  
> +# Job to cross-build specific accelerators.
> +#
> +# Set the $ACCEL variable to select the specific accelerator (default to
> +# KVM), and set extra options (such disabling other accelerators) via the
> +# $ACCEL_CONFIGURE_OPTS variable.
> +.cross_accel_build_job:
> +  stage: build
> +  image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
> +  timeout: 30m
> +  script:
> +    - mkdir build
> +    - cd build
> +    - PKG_CONFIG_PATH=$PKG_CONFIG_PATH
> +      ../configure --enable-werror $QEMU_CONFIGURE_OPTS --disable-tools
> +        --enable-${ACCEL:-kvm} --target-list="$TARGETS" $ACCEL_CONFIGURE_OPTS
> +    - make -j$(expr $(nproc) + 1) all check-build
> +
>  .cross_user_build_job:
>    stage: build
>    image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest

I wonder whether we could also simply use the .cross_user_build_job - e.g.
by adding a $EXTRA_CONFIGURE_OPTS variable in the "../configure ..." line so
that the accel-jobs could use that for their --enable... and --disable...
settings?

Anyway, I've got no strong opinion on that one, and I'm also fine if we add
this new template, so:

Reviewed-by: Thomas Huth <thuth@redhat.com>

