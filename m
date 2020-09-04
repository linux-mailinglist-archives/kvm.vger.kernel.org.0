Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17EC25DBBE
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 16:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgIDObN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 10:31:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41158 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728983AbgIDObJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 10:31:09 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-PtOFqzpzNKepccEU3G-I3w-1; Fri, 04 Sep 2020 10:31:05 -0400
X-MC-Unique: PtOFqzpzNKepccEU3G-I3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDA2180F054;
        Fri,  4 Sep 2020 14:31:04 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 003715C1D0;
        Fri,  4 Sep 2020 14:31:03 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 10/10] travis.yml: Add x86 build with
 clang 10
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-11-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <fb94aa98-f586-a069-20f8-42852f150c0b@redhat.com>
Date:   Fri, 4 Sep 2020 16:31:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200901085056.33391-11-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/09/2020 10.50, Roman Bolshakov wrote:
> .gitlab-ci.yml already has a job to build the tests with clang but it's
> not clear how to set it up on a personal github repo.

You can't use gitlab-ci from a github repo, it's a separate git forge
system.

> NB, realmode test is disabled because it fails immediately after start
> if compiled with clang-10.
> 
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  .travis.yml | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/.travis.yml b/.travis.yml
> index f3a8899..ae4ed08 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -17,6 +17,16 @@ jobs:
>                 kvmclock_test msr pcid rdpru realmode rmap_chain s3 setjmp umip"
>        - ACCEL="kvm"
>  
> +    - addons:
> +        apt_packages: clang-10 qemu-system-x86
> +      env:
> +      - CONFIG="--cc=clang-10"
> +      - BUILD_DIR="."
> +      - TESTS="access asyncpf debug emulator ept hypercall hyperv_stimer
> +               hyperv_synic idt_test intel_iommu ioapic ioapic-split
> +               kvmclock_test msr pcid rdpru rmap_chain s3 setjmp umip"
> +      - ACCEL="kvm"

We already have two jobs for compiling on x86, one for testing in-tree
builds and one for testing out-of-tree builds ... I wonder whether we
should simply switch one of those two jobs to use clang-10 instead of
gcc (since the in/out-of-tree stuff should be hopefully independent of
the compiler type)? Since Travis limits the amount of jobs that run at
the same time, that would not increase the total testing time, I think.

 Thomas


PS: Maybe we could update from bionic to focal now, too, and see whether
some more tests are working with the newer version of QEMU there...

