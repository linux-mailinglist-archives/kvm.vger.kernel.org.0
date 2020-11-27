Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5635E2C67AD
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 15:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbgK0OS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 09:18:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727892AbgK0OS5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 09:18:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606486735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PupoQvhKVlsz4GsHO//mp3+kTpnMsIWyMa7P/KNSkP0=;
        b=h4TltcyZnxwpxiyf4qn1xsoAdk0MuroHVX92An3thzeeVAoDHeeIpmhB1Ctq+8YYgTwmQz
        cZpPZkIC6j9MVFE5CwWyaIgGX/669s0IzrukELBf3ZsvVYpL5L1tN7dSxPeQ9U+ag8Gm15
        KbY+1JB8q3RAGlN23STwPQJefGSlJm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-cZd-QQ8tMQGM-gA8-B8SxA-1; Fri, 27 Nov 2020 09:18:48 -0500
X-MC-Unique: cZd-QQ8tMQGM-gA8-B8SxA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5E9B9A221;
        Fri, 27 Nov 2020 14:18:46 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-70.ams2.redhat.com [10.36.113.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4EC95D71D;
        Fri, 27 Nov 2020 14:18:41 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/7] s390x: SCLP feature checking
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201127130629.120469-1-frankja@linux.ibm.com>
 <20201127130629.120469-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <eefe9449-1759-2608-4395-027ae69ee83c@redhat.com>
Date:   Fri, 27 Nov 2020 15:18:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201127130629.120469-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/11/2020 14.06, Janosch Frank wrote:
> Availability of SIE is announced via a feature bit in a SCLP info CPU
> entry. Let's add a framework that allows us to easily check for such
> facilities.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 19 +++++++++++++++++++
>  lib/s390x/sclp.h | 13 ++++++++++++-
>  3 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
> index e19a1f3..e843601 100644
> --- a/lib/s390x/io.c
> +++ b/lib/s390x/io.c
> @@ -37,6 +37,7 @@ void setup(void)
>  	setup_args_progname(ipl_args);
>  	setup_facilities();
>  	sclp_read_info();
> +	sclp_facilities_setup();
>  	sclp_console_setup();
>  	sclp_memory_setup();
>  	smp_setup();
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index ff56c44..68833b5 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -11,6 +11,7 @@
>   */
>  
>  #include <libcflat.h>
> +#include <bitops.h>
>  #include <asm/page.h>
>  #include <asm/arch_def.h>
>  #include <asm/interrupt.h>
> @@ -27,6 +28,7 @@ static uint64_t max_ram_size;
>  static uint64_t ram_size;
>  char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
>  static ReadInfo *read_info;
> +struct sclp_facilities sclp_facilities;
>  
>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>  static volatile bool sclp_busy;
> @@ -128,6 +130,23 @@ CPUEntry *sclp_get_cpu_entries(void)
>  	return (void *)read_info + read_info->offset_cpu;
>  }
>  
> +void sclp_facilities_setup(void)
> +{
> +	unsigned short cpu0_addr = stap();
> +	CPUEntry *cpu;
> +	int i;
> +
> +	assert(read_info);
> +
> +	cpu = (void *)read_info + read_info->offset_cpu;
> +	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
> +		if (cpu->address == cpu0_addr) {
> +			sclp_facilities.has_sief2 = cpu->feat_sief2;
> +			break;
> +		}
> +	}
> +}
> +
>  /* Perform service call. Return 0 on success, non-zero otherwise. */
>  int sclp_service_call(unsigned int command, void *sccb)
>  {
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 6620531..e18f7e6 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -95,12 +95,22 @@ typedef struct SCCBHeader {
>  typedef struct CPUEntry {
>      uint8_t address;
>      uint8_t reserved0;
> -    uint8_t features[SCCB_CPU_FEATURE_LEN];
> +    uint8_t : 4;
> +    uint8_t feat_sief2 : 1;
> +    uint8_t : 3;
> +    uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
>      uint8_t reserved2[6];
>      uint8_t type;
>      uint8_t reserved1;
>  } __attribute__((packed)) CPUEntry;
>  
> +extern struct sclp_facilities sclp_facilities;
> +
> +struct sclp_facilities {
> +	uint64_t has_sief2 : 1;
> +	uint64_t : 63;
> +};
> +
>  typedef struct ReadInfo {
>      SCCBHeader h;
>      uint16_t rnmax;
> @@ -274,6 +284,7 @@ void sclp_print(const char *str);
>  void sclp_read_info(void);
>  int sclp_get_cpu_num(void);
>  CPUEntry *sclp_get_cpu_entries(void);
> +void sclp_facilities_setup(void);
>  int sclp_service_call(unsigned int command, void *sccb);
>  void sclp_memory_setup(void);
>  uint64_t get_ram_size(void);
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

