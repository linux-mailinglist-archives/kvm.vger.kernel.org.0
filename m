Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACD4248797
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 16:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgHROb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 10:31:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27014 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726917AbgHROb5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 10:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597761116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HzfJ3iuWwsI/fDcm0Y3yG1WxMPIIt4U1sMF+NPp5+Iw=;
        b=XMNMEs/JwyCG6j/CEIgKAiagGfgRLRusyoL0hC86UVZwaZWWyY5aLAdd+wjooSfmggJ+TY
        rXtCV+pPfmWorA0xKpMHmZohh8TJzbmZYqQ/e42B2zyr80YpuLMPosLUqWUUMUJ39spi7e
        1upTYGgdM/NJrgDGcJ+NAMgV+67RtpU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-vwl3kBScOD23AGJ5CiDAHg-1; Tue, 18 Aug 2020 10:31:53 -0400
X-MC-Unique: vwl3kBScOD23AGJ5CiDAHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92AB81084C86;
        Tue, 18 Aug 2020 14:31:52 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F775702F1;
        Tue, 18 Aug 2020 14:31:47 +0000 (UTC)
Date:   Tue, 18 Aug 2020 16:31:44 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/4] scripts: add support for architecture
 dependent functions
Message-ID: <20200818143144.vs6ikxp4tgifodyb@kamzik.brq.redhat.com>
References: <20200818130424.20522-1-mhartmay@linux.ibm.com>
 <20200818130424.20522-3-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818130424.20522-3-mhartmay@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 03:04:22PM +0200, Marc Hartmayer wrote:
> This is necessary to keep architecture dependent code separate from
> common code.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  README.md           | 3 ++-
>  scripts/common.bash | 8 ++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/README.md b/README.md
> index 48be206c6db1..24d4bdaaee0d 100644
> --- a/README.md
> +++ b/README.md
> @@ -134,7 +134,8 @@ all unit tests.
>  ## Directory structure
>  
>      .:                  configure script, top-level Makefile, and run_tests.sh
> -    ./scripts:          helper scripts for building and running tests
> +    ./scripts:          general architecture neutral helper scripts for building and running tests
> +    ./scripts/<ARCH>:   architecture dependent helper scripts for building and running tests
>      ./lib:              general architecture neutral services for the tests
>      ./lib/<ARCH>:       architecture dependent services for the tests
>      ./<ARCH>:           the sources of the tests and the created objects/images
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 96655c9ffd1f..c7acdf14a835 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -1,3 +1,4 @@
> +source config.mak
>  
>  function for_each_unittest()
>  {
> @@ -52,3 +53,10 @@ function for_each_unittest()
>  	fi
>  	exec {fd}<&-
>  }
> +
> +# The current file has to be the only file sourcing the arch helper
> +# file
> +ARCH_FUNC=scripts/${ARCH}/func.bash
> +if [ -f "${ARCH_FUNC}" ]; then
> +	source "${ARCH_FUNC}"
> +fi
> -- 
> 2.25.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

