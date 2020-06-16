Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8791FAE82
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 12:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgFPKtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 06:49:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40694 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725901AbgFPKt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 06:49:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592304568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=1H0luCJODbtQ42YgYv0yeAzbAXL/psZsh9fUX+jVH3w=;
        b=Q1s93lVzKmQjSiRbAHSyykHkxpl9xuBV72jWg/oVSlJ1dqYUFa5ctY6KLZQF3RNBmf4c1M
        ikzPym1RihChTwv1TQDq3AqYtKi6WFbcG8B8SpuUvnytxMpVLXppJOKs1kM89k3YZVOVo9
        2AODl/77NhjQ2Clw5YpKEDSrm+P9odQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-dkMoe5--OaCYt8sZF_1gtA-1; Tue, 16 Jun 2020 06:49:24 -0400
X-MC-Unique: dkMoe5--OaCYt8sZF_1gtA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21C62846375;
        Tue, 16 Jun 2020 10:49:23 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AB2B768DC;
        Tue, 16 Jun 2020 10:49:19 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: Test full-width counter writes
 support
To:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200529074347.124619-1-like.xu@linux.intel.com>
 <20200529074347.124619-4-like.xu@linux.intel.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b1a5472b-f7d0-82b0-e753-dabf81254488@redhat.com>
Date:   Tue, 16 Jun 2020 12:49:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200529074347.124619-4-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/2020 09.43, Like Xu wrote:
> When the full-width writes capability is set, use the alternative MSR
> range to write larger sign counter values (up to GP counter width).
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  lib/x86/msr.h |   1 +
>  x86/pmu.c     | 125 ++++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 102 insertions(+), 24 deletions(-)
[...]
> @@ -452,6 +468,66 @@ static void check_running_counter_wrmsr(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_counters(void)
> +{
> +	check_gp_counters();
> +	check_fixed_counters();
> +	check_rdpmc();
> +	check_counters_many();
> +	check_counter_overflow();
> +	check_gp_counter_cmask();
> +	check_running_counter_wrmsr();
> +}
> +
> +static void do_unsupported_width_counter_write(void *index)
> +{
> +	wrmsr(MSR_IA32_PMC0 + *((int *) index), 0xffffff0123456789ull);
> +}
> +
> +static void  check_gp_counters_write_width(void)
> +{
> +	u64 val_64 = 0xffffff0123456789ull;
> +	u64 val_32 = val_64 & ((1ul << 32) - 1);
 Hi,

this broke compilation on 32-bit hosts:

 https://travis-ci.com/github/huth/kvm-unit-tests/jobs/349654654#L710

Fix should be easy, I guess - either use 1ull or specify the mask
0xffffffff directly.

 Thomas

