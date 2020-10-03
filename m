Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC400282392
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 12:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJCKOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 06:14:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgJCKOa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 06:14:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601720069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LrY7ZzRUnhZ7GuZMqcELGWPYItfe77Y46Yqcbu2JTIo=;
        b=TZKjNKplibqpqhYqlezGWiE6pk+MlW79RMn2m9FhgIzC0WD/MdOaJ0ULOLK2hljKvRvIoN
        2dhsnsmHAEuk7f1sYBm3BF8SuPIBkMzHgxCuNWRDdX+4NOS3MMLoOmn4/BPEArURoIp7Bh
        VkCTfZUEhSz5/qhMQ1W9wVAuiM5P3Uw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-2BBmpV7vMtim8jnwcpfuGQ-1; Sat, 03 Oct 2020 06:14:28 -0400
X-MC-Unique: 2BBmpV7vMtim8jnwcpfuGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 656571DDEB;
        Sat,  3 Oct 2020 10:14:26 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-61.ams2.redhat.com [10.36.112.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 581107EB8F;
        Sat,  3 Oct 2020 10:14:24 +0000 (UTC)
Subject: Re: [PATCH v4 12/12] .travis.yml: Add a KVM-only Aarch64 job
To:     Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-13-philmd@redhat.com>
 <bd4c4587-de23-7612-48c7-afc8b94ab9fb@linaro.org>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c7140a42-043c-9bc5-88c8-2cdad9ae2a14@redhat.com>
Date:   Sat, 3 Oct 2020 12:14:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <bd4c4587-de23-7612-48c7-afc8b94ab9fb@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/2020 12.03, Richard Henderson wrote:
> On 9/29/20 5:43 PM, Philippe Mathieu-Daudé wrote:
>> Add a job to build QEMU on Aarch64 with TCG disabled, so
>> this configuration won't bitrot over time.
>>
>> We explicitly modify default-configs/aarch64-softmmu.mak to
>> only select the 'virt' and 'SBSA-REF' machines.
> 
> I really wish we didn't have to do this.
> 
> Can't we e.g. *not* list all of the arm boards explicitly in default-configs,
> but use the Kconfig "default y if ..."?
> 
> Seems like that would let --disable-tcg work as expected.
> One should still be able to create custom configs with e.g.
> CONFIG_EXYNOS4=n or CONIFIG_ARM_V4=n, correct?

But that would be different from how we handle all other targets currently...
IMHO we shoud go into a different direction instead, e.g. by adding a 
"--kconfig-dir" switch to the configure script. If it has not been 
specified, the configs will be read from default-configs/ (or maybe we 
should then rename it to configs/default/). But if the switch has been 
specified with a directory as parameter, the config files will be read from 
that directory instead. We could then have folders like:

- configs/default (current default-configs)
- configs/no-tcg (all machines that work without tcg)
- configs/lean-kvm (for "nemu"-style minimalistic settings)

etc.

What do you think?

  Thomas

