Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BA910CB80
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 16:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfK1PPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 10:15:13 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27880 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726917AbfK1PPM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 10:15:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574954111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=hfUt0po4HUkFebbmizcVL2YPqGm9Z9smJkavIxeX74U=;
        b=eRfa1yF9x70ZNQfgidWaQ8a4fDrJSe3qRLRik3bZs7Z1K8uXGKyttx7X3p3GzGNDD1rJpR
        +e60mvZi4y4GxjBEJT3/wADqa/ZXo93WB1Nc/y33ipPJ7y/8ENZ3rfSf8ZRdjkdIy6M3td
        QaY1mY5C9+ueItXEf8Rim1Xa52GjBRQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-7JlSLQCEMNaPr56R7JzhtA-1; Thu, 28 Nov 2019 10:15:10 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FB91107ACC5;
        Thu, 28 Nov 2019 15:15:09 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5455119C6A;
        Thu, 28 Nov 2019 15:15:08 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] arm: Enable the VFP
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
References: <20191128143421.13815-1-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <05576e71-eb32-e41f-5631-1cd90b4dddd5@redhat.com>
Date:   Thu, 28 Nov 2019 16:15:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191128143421.13815-1-drjones@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 7JlSLQCEMNaPr56R7JzhtA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/11/2019 15.34, Andrew Jones wrote:
> Variable argument macros frequently depend on floating point
> registers. Indeed we needed to enable the VFP for arm64 since its
> introduction in order to use printf and the like. Somehow we
> didn't need to do that for arm32 until recently when compiling
> with GCC 9.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
> 
> CC'ing Thomas because I think he had to workaround travis tests
> failing due to this issue once. Maybe travis can now be
> un-worked-around?

Yes, this patch fixes the problem with GCC9 for me:

 https://gitlab.com/huth/kvm-unit-tests/-/jobs/364079089

Feel free to add my

Tested-by: Thomas Huth <thuth@redhat.com>

and if you like, please also include this hunk:

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -17,7 +17,7 @@ build-aarch64:

 build-arm:
  script:
- - dnf install -y qemu-system-arm gcc-arm-linux-gnu-8.2.1-1.fc30.2
+ - dnf install -y qemu-system-arm gcc-arm-linux-gnu
  - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh

 Thomas

