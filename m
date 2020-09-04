Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A63825DAD0
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 16:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgIDOAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 10:00:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57879 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730496AbgIDOAa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 10:00:30 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-1LEejf3aMH2DM0N99ktYAQ-1; Fri, 04 Sep 2020 10:00:27 -0400
X-MC-Unique: 1LEejf3aMH2DM0N99ktYAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0C9D192CC46
        for <kvm@vger.kernel.org>; Fri,  4 Sep 2020 14:00:26 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0922419C59;
        Fri,  4 Sep 2020 14:00:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Test build on CentOS 7
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com
References: <20200731091548.8302-1-thuth@redhat.com>
Message-ID: <5ed391a5-ad9f-c143-8286-71ec22497a83@redhat.com>
Date:   Fri, 4 Sep 2020 16:00:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200731091548.8302-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/2020 11.15, Thomas Huth wrote:
> We should also test our build with older versions of Bash and Gcc (at
> least the versions which we still want to support). CentOS 7 should be
> a reasonable base for such tests.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .gitlab-ci.yml | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index d042cde..1ec9797 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -99,3 +99,20 @@ build-clang:
>       eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
>       | tee results.txt
>   - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +
> +build-centos7:
> + image: centos:7
> + before_script:
> + - yum update -y
> + - yum install -y make python qemu-kvm gcc
> + script:
> + - mkdir build
> + - cd build
> + - ../configure --arch=x86_64 --disable-pretty-print-stacks
> + - make -j2
> + - ACCEL=tcg ./run_tests.sh
> +     msr vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_inl_pmtimer
> +     vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed port80
> +     setjmp sieve tsc rmap_chain umip
> +     | tee results.txt
> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
> 

Ping!

Paolo, Drew, any comments on this one?

 Thomas

