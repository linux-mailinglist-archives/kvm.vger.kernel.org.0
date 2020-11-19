Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E101C2B8DC5
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 09:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgKSIli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 03:41:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbgKSIli (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 03:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605775296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1RCBJ5tMJnSDGuqcCSypMYhyoWkIST42mBGr2K1+Vvw=;
        b=X4qANdeyIZxpXeygT3nObO+UpcLbOzD3bOH79560rDvRngp7lFJRm0wkf2RWAYOg/75VWN
        AWmCjGYcnoJoSre1XhF3nvFfClms5FPDKH7073M3qQq9e/Jqlg1IRLvRO3n50MoVRVjHB2
        6FLmL727V3Pc+Sr85FJ47T95KtaykK0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-cE27cbLBO8Gn3vcbkmg6mQ-1; Thu, 19 Nov 2020 03:41:34 -0500
X-MC-Unique: cE27cbLBO8Gn3vcbkmg6mQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 727248144E1;
        Thu, 19 Nov 2020 08:41:33 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6E515C221;
        Thu, 19 Nov 2020 08:41:28 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: Consolidate sclp read info
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20201117154215.45855-1-frankja@linux.ibm.com>
 <20201117154215.45855-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e1c4a7f0-21a1-1a4e-1f40-f5f2de9d138e@redhat.com>
Date:   Thu, 19 Nov 2020 09:41:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201117154215.45855-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/11/2020 16.42, Janosch Frank wrote:
> Let's only read the information once and pass a pointer to it instead
> of calling sclp multiple times.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 29 +++++++++++++++++++++++------
>  lib/s390x/sclp.h |  3 +++
>  lib/s390x/smp.c  | 23 +++++++++--------------
>  4 files changed, 36 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
> index c0f0bf7..e19a1f3 100644
> --- a/lib/s390x/io.c
> +++ b/lib/s390x/io.c
> @@ -36,6 +36,7 @@ void setup(void)
>  {
>  	setup_args_progname(ipl_args);
>  	setup_facilities();
> +	sclp_read_info();
>  	sclp_console_setup();
>  	sclp_memory_setup();
>  	smp_setup();
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 4054d0e..ea6324e 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -25,6 +25,8 @@ extern unsigned long stacktop;
>  static uint64_t storage_increment_size;
>  static uint64_t max_ram_size;
>  static uint64_t ram_size;
> +char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
> +static ReadInfo *read_info;
>  
>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>  static volatile bool sclp_busy;
> @@ -110,6 +112,22 @@ static void sclp_read_scp_info(ReadInfo *ri, int length)
>  	report_abort("READ_SCP_INFO failed");
>  }
>  
> +void sclp_read_info(void)
> +{
> +	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
> +	read_info = (ReadInfo *)_read_info;
> +}
> +
> +int sclp_get_cpu_num(void)
> +{
> +	return read_info->entries_cpu;
> +}
[...]
>  int smp_query_num_cpus(void)
>  {
> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
> -	return info->nr_configured;
> +	return sclp_get_cpu_num();
>  }

You've changed from ->nr_configured to ->entries_cpu ... I assume that's ok?
Worth to mention the change and rationale in the patch description?

>  struct cpu *smp_cpu_from_addr(uint16_t addr)
> @@ -245,22 +244,18 @@ extern uint64_t *stackptr;
>  void smp_setup(void)
>  {
>  	int i = 0;
> +	int num = smp_query_num_cpus();
>  	unsigned short cpu0_addr = stap();
> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
> +	struct CPUEntry *entry = sclp_get_cpu_entries();
>  
> -	spin_lock(&lock);
> -	sclp_mark_busy();
> -	info->h.length = PAGE_SIZE;
> -	sclp_service_call(SCLP_READ_CPU_INFO, cpu_info_buffer);
> +	if (num > 1)
> +		printf("SMP: Initializing, found %d cpus\n", num);
>  
> -	if (smp_query_num_cpus() > 1)
> -		printf("SMP: Initializing, found %d cpus\n", info->nr_configured);
> -
> -	cpus = calloc(info->nr_configured, sizeof(cpus));
> -	for (i = 0; i < info->nr_configured; i++) {
> -		cpus[i].addr = info->entries[i].address;
> +	cpus = calloc(num, sizeof(cpus));
> +	for (i = 0; i < num; i++) {
> +		cpus[i].addr = entry[i].address;
>  		cpus[i].active = false;
> -		if (info->entries[i].address == cpu0_addr) {
> +		if (entry[i].address == cpu0_addr) {
>  			cpu0 = &cpus[i];
>  			cpu0->stack = stackptr;
>  			cpu0->lowcore = (void *)0;
> 

What about smp_teardown()? It seems to use cpu_info_buffer->nr_configured,
too, which is now likely not valid anymore?

 Thomas

