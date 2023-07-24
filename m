Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33D375EE3E
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 10:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjGXIsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 04:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbjGXIsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 04:48:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CB71A1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690188431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mhey2rfScVI0ERO3qifA2o1FZHJDtGw8MJL1bWmGkcM=;
        b=NyOAm9CuWaFE94wFwKKEWJ3zP+N35cMcVLdqUv9MU8gP9mbF0f1Cjgk9TKuBHIhedM6gWl
        suJg6ImDswKl6gY3VMG6PzL9aAk4XE0p46bAPPR/Dy3nVREcHp2UeLiEFVKZmvF2xY3fQ9
        aEd51QKSqQY6t4KVqMaEZutrgmsLAac=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-oT7Jp7WnNZWZ-rw25rGdYw-1; Mon, 24 Jul 2023 04:47:09 -0400
X-MC-Unique: oT7Jp7WnNZWZ-rw25rGdYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05582101A54E;
        Mon, 24 Jul 2023 08:47:09 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4782F782E;
        Mon, 24 Jul 2023 08:47:08 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Gavin Shan <gshan@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH for-8.2 1/2] arm/kvm: convert to kvm_set_one_reg
In-Reply-To: <a5b93992-5576-04cf-3af0-2c237831f5c6@redhat.com>
Organization: Red Hat GmbH
References: <20230718111404.23479-1-cohuck@redhat.com>
 <20230718111404.23479-2-cohuck@redhat.com>
 <a5b93992-5576-04cf-3af0-2c237831f5c6@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 24 Jul 2023 10:47:07 +0200
Message-ID: <87bkg1g0hg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24 2023, Gavin Shan <gshan@redhat.com> wrote:

> Hi Connie,
>
> On 7/18/23 21:14, Cornelia Huck wrote:
>> We can neaten the code by switching to the kvm_set_one_reg function.
>> 
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   target/arm/kvm.c   | 13 +++------
>>   target/arm/kvm64.c | 66 +++++++++++++---------------------------------
>>   2 files changed, 21 insertions(+), 58 deletions(-)
>> 
>
> Some wrong replacements to be fixed in kvm_arch_put_fpsimd() as below.
> Apart from that, LGTM:
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> @@ -725,19 +721,17 @@ static void kvm_inject_arm_sea(CPUState *c)
>>   static int kvm_arch_put_fpsimd(CPUState *cs)
>>   {
>>       CPUARMState *env = &ARM_CPU(cs)->env;
>> -    struct kvm_one_reg reg;
>>       int i, ret;
>>   
>>       for (i = 0; i < 32; i++) {
>>           uint64_t *q = aa64_vfp_qreg(env, i);
>>   #if HOST_BIG_ENDIAN
>>           uint64_t fp_val[2] = { q[1], q[0] };
>> -        reg.addr = (uintptr_t)fp_val;
>> +        ret = kvm_set_one_reg(cs, AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]),
>> +                                                        &fp_val);
>                                                             ^^^^^^^
>                                                             s/&fp_val/fp_val
>>   #else
>> -        reg.addr = (uintptr_t)q;
>> +        ret = kvm_set_one_reg(cs, AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]), &q);
>                                                                                ^^^
>                                                                               s/&q/q
>                                                                                
>>   #endif

Whoops, I thought I had double-checked these...

