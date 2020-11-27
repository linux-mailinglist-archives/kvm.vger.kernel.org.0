Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B1B2C6746
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 14:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbgK0N45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 08:56:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730507AbgK0N45 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 08:56:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606485415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gCZQlgci/SioymeB7B3rK1BO8SUaVrO0hA9s6D50hS8=;
        b=bz+/thm7QiSkff7DmzbRnNxARBObFrszPP+TntT0gRiAWisdsfVIQ5uzDSOfYhBXxSJbKS
        OF45tWtCSuVW+BwqOuYB78gGTCmMWalw3BnuTO/Z0weiMqQlWIwCGAyjB7em11itv8ix7U
        0wllwMAoLtIzWbOzHKaHjGkTLNu3zrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-l2xOrsBaNRuNmQZSz3rSMQ-1; Fri, 27 Nov 2020 08:56:51 -0500
X-MC-Unique: l2xOrsBaNRuNmQZSz3rSMQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 140208049D1;
        Fri, 27 Nov 2020 13:56:50 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-70.ams2.redhat.com [10.36.113.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A2405D6D1;
        Fri, 27 Nov 2020 13:56:45 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/7] s390x: Consolidate sclp read info
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201127130629.120469-1-frankja@linux.ibm.com>
 <20201127130629.120469-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <5d79d1c9-0845-69b4-93ad-a4a69119554c@redhat.com>
Date:   Fri, 27 Nov 2020 14:56:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201127130629.120469-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/11/2020 14.06, Janosch Frank wrote:
> Let's only read the information once and pass a pointer to it instead
> of calling sclp multiple times.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 29 +++++++++++++++++++++++------
>  lib/s390x/sclp.h |  3 +++
>  lib/s390x/smp.c  | 28 +++++++++++-----------------
>  4 files changed, 38 insertions(+), 23 deletions(-)
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
> index 4e2ac18..ff56c44 100644
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
> +
> +CPUEntry *sclp_get_cpu_entries(void)
> +{
> +	return (void *)read_info + read_info->offset_cpu;
> +}
> +
>  /* Perform service call. Return 0 on success, non-zero otherwise. */
>  int sclp_service_call(unsigned int command, void *sccb)
>  {
> @@ -127,23 +145,22 @@ int sclp_service_call(unsigned int command, void *sccb)
>  
>  void sclp_memory_setup(void)
>  {
> -	ReadInfo *ri = (void *)_sccb;
>  	uint64_t rnmax, rnsize;
>  	int cc;
>  
> -	sclp_read_scp_info(ri, SCCB_SIZE);
> +	assert(read_info);
>  
>  	/* calculate the storage increment size */
> -	rnsize = ri->rnsize;
> +	rnsize = read_info->rnsize;
>  	if (!rnsize) {
> -		rnsize = ri->rnsize2;
> +		rnsize = read_info->rnsize2;
>  	}
>  	storage_increment_size = rnsize << 20;
>  
>  	/* calculate the maximum memory size */
> -	rnmax = ri->rnmax;
> +	rnmax = read_info->rnmax;
>  	if (!rnmax) {
> -		rnmax = ri->rnmax2;
> +		rnmax = read_info->rnmax2;
>  	}
>  	max_ram_size = rnmax * storage_increment_size;
>  
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 675f07e..6620531 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -271,6 +271,9 @@ void sclp_wait_busy(void);
>  void sclp_mark_busy(void);
>  void sclp_console_setup(void);
>  void sclp_print(const char *str);
> +void sclp_read_info(void);
> +int sclp_get_cpu_num(void);
> +CPUEntry *sclp_get_cpu_entries(void);
>  int sclp_service_call(unsigned int command, void *sccb);
>  void sclp_memory_setup(void);
>  uint64_t get_ram_size(void);
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 77d80ca..f77ad1e 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -25,7 +25,6 @@
>  #include "smp.h"
>  #include "sclp.h"
>  
> -static char cpu_info_buffer[PAGE_SIZE] __attribute__((__aligned__(4096)));
>  static struct cpu *cpus;
>  static struct cpu *cpu0;
>  static struct spinlock lock;
> @@ -34,8 +33,7 @@ extern void smp_cpu_setup_state(void);
>  
>  int smp_query_num_cpus(void)
>  {
> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
> -	return info->nr_configured;
> +	return sclp_get_cpu_num();
>  }
>  
>  struct cpu *smp_cpu_from_addr(uint16_t addr)
> @@ -228,10 +226,10 @@ void smp_teardown(void)
>  {
>  	int i = 0;
>  	uint16_t this_cpu = stap();
> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
> +	int num = smp_query_num_cpus();
>  
>  	spin_lock(&lock);
> -	for (; i < info->nr_configured; i++) {
> +	for (; i < num; i++) {
>  		if (cpus[i].active &&
>  		    cpus[i].addr != this_cpu) {
>  			sigp_retry(cpus[i].addr, SIGP_STOP, 0, NULL);
> @@ -245,22 +243,18 @@ extern uint64_t *stackptr;
>  void smp_setup(void)
>  {
>  	int i = 0;
> +	int num = smp_query_num_cpus();
>  	unsigned short cpu0_addr = stap();
> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
> +	struct CPUEntry *entry = sclp_get_cpu_entries();
>  
> -	spin_lock(&lock);

You've removed the spin_lock(), but not the spin_unlock() at the end of the
function ... looks wrong to me? I guess you rather should keep the
spin_lock() call here?

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

Apart from the spin_lock() problem, patch looks fine to me now.

 Thomas

