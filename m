Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35F045F181
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 17:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378349AbhKZQSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 11:18:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351512AbhKZQP7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 11:15:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637943166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K3jO5tAiYyEGMUBMF/NRiY9sSty76A2Bx8YKlcZY5f0=;
        b=G8/0A9Lws1jpBDeFCRf9i3A/Y6uMSpgFAk56fw34+mJajomGWdPCrpRj3Y8ShUdVufwjJA
        m/io/YtGB3JCXjDA5jHY1tokhLVBZGYXaZz26fLafDGrHeJU8SPRCqN02YgBP5L+zyFqUB
        faGIXA5UCKTdPRbE9QVVlPJSiQ6m45Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-aF_1HCYVPAi1cNL1VV6SPw-1; Fri, 26 Nov 2021 11:12:42 -0500
X-MC-Unique: aF_1HCYVPAi1cNL1VV6SPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6B41801B00;
        Fri, 26 Nov 2021 16:12:40 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0E4F60854;
        Fri, 26 Nov 2021 16:12:36 +0000 (UTC)
Message-ID: <558e7e30-2d87-a19c-c85c-a2993a354074@redhat.com>
Date:   Fri, 26 Nov 2021 17:12:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/4] RISC-V: KVM: Forward SBI experimental and vendor
 extensions
Content-Language: en-US
To:     Anup Patel <anup.patel@wdc.com>, Shuah Khan <shuah@kernel.org>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20211126154020.342924-1-anup.patel@wdc.com>
 <20211126154020.342924-2-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211126154020.342924-2-anup.patel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/26/21 16:40, Anup Patel wrote:
> +static int kvm_sbi_ext_expevend_handler(struct kvm_vcpu *vcpu,
> +					struct kvm_run *run,
> +					unsigned long *out_val,
> +					struct kvm_cpu_trap *utrap,
> +					bool *exit)

Doesn't really matter what this is used for, it's a handler that 
forwards.  So you can name it kvm_sbi_ext_forward_handler.

Paolo

> +{
> +	/*
> +	 * Both SBI experimental and vendor extensions are
> +	 * unconditionally forwarded to userspace.
> +	 */
> +	kvm_riscv_vcpu_sbi_forward(vcpu, run);
> +	*exit = true;
> +	return 0;
> +}
> +

