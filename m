Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E65517F58B
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 12:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgCJLAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 07:00:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50153 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725937AbgCJLAc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 07:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583838030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4JG1xSI0M7SxiOdT+XP4LAA8ykTyWX0vFprHuiZRRDg=;
        b=WRAwJfChBlqQ/zxb4khPDLh4Mt4rCJGTl8Nv5pQn5cawzgf6pQGB/GgY4cvvbfa4h3Hv+4
        5yRTa9wGV8uMN64e21lDHeIqa/ckXSMyRT763M/LO5kfbo5viYQWydTDaJ4zVfYCFo2Vxb
        Fl85efo6RQU6Y/1Eb6OjjjFpBFM53tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-si_hbHt5POCEjnAl5TJIig-1; Tue, 10 Mar 2020 07:00:26 -0400
X-MC-Unique: si_hbHt5POCEjnAl5TJIig-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95F1213EA;
        Tue, 10 Mar 2020 11:00:24 +0000 (UTC)
Received: from [10.36.117.85] (ovpn-117-85.ams2.redhat.com [10.36.117.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 871E35C13D;
        Tue, 10 Mar 2020 11:00:21 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 03/13] arm/arm64: gic: Introduce
 setup_irq() helper
To:     Andrew Jones <drjones@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
References: <20200309102420.24498-1-eric.auger@redhat.com>
 <20200309102420.24498-4-eric.auger@redhat.com>
 <20200309105601.3hm2kfhuufgxoydl@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <3e1e2c24-2f30-03f2-ca9c-a2d99aba0740@redhat.com>
Date:   Tue, 10 Mar 2020 12:00:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200309105601.3hm2kfhuufgxoydl@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,
On 3/9/20 11:56 AM, Andrew Jones wrote:
> On Mon, Mar 09, 2020 at 11:24:10AM +0100, Eric Auger wrote:
>> ipi_enable() code would be reusable for other interrupts
>> than IPI. Let's rename it setup_irq() and pass an interrupt
>> handler pointer.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v2 -> v3:
>> - do not export setup_irq anymore
>> ---
>>  arm/gic.c | 20 +++++++-------------
>>  1 file changed, 7 insertions(+), 13 deletions(-)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index fcf4c1f..abf08c7 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -34,6 +34,7 @@ static struct gic *gic;
>>  static int acked[NR_CPUS], spurious[NR_CPUS];
>>  static int bad_sender[NR_CPUS], bad_irq[NR_CPUS];
>>  static cpumask_t ready;
>> +typedef void (*handler_t)(struct pt_regs *regs __unused);
> 
> This is just irq_handler_fn, which is already defined in processor.h.
> We don't need the __unused, not since 6b07148d06b1 ("Replace -Wextra
> with a saner list of warning flags").
Shall I duplicate it into ./lib/arm/asm/processor.h as well?

Thanks

Eric
> 
>>  
>>  static void nr_cpu_check(int nr)
>>  {
>> @@ -215,20 +216,20 @@ static void ipi_test_smp(void)
>>  	report_prefix_pop();
>>  }
>>  
>> -static void ipi_enable(void)
>> +static void setup_irq(handler_t handler)
>>  {
>>  	gic_enable_defaults();
>>  #ifdef __arm__
>> -	install_exception_handler(EXCPTN_IRQ, ipi_handler);
>> +	install_exception_handler(EXCPTN_IRQ, handler);
>>  #else
>> -	install_irq_handler(EL1H_IRQ, ipi_handler);
>> +	install_irq_handler(EL1H_IRQ, handler);
>>  #endif
>>  	local_irq_enable();
>>  }
>>  
>>  static void ipi_send(void)
>>  {
>> -	ipi_enable();
>> +	setup_irq(ipi_handler);
>>  	wait_on_ready();
>>  	ipi_test_self();
>>  	ipi_test_smp();
>> @@ -238,7 +239,7 @@ static void ipi_send(void)
>>  
>>  static void ipi_recv(void)
>>  {
>> -	ipi_enable();
>> +	setup_irq(ipi_handler);
>>  	cpumask_set_cpu(smp_processor_id(), &ready);
>>  	while (1)
>>  		wfi();
>> @@ -295,14 +296,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>>  static void run_active_clear_test(void)
>>  {
>>  	report_prefix_push("active");
>> -	gic_enable_defaults();
>> -#ifdef __arm__
>> -	install_exception_handler(EXCPTN_IRQ, ipi_clear_active_handler);
>> -#else
>> -	install_irq_handler(EL1H_IRQ, ipi_clear_active_handler);
>> -#endif
>> -	local_irq_enable();
>> -
>> +	setup_irq(ipi_clear_active_handler);
>>  	ipi_test_self();
>>  	report_prefix_pop();
>>  }
>> -- 
>> 2.20.1
>>

