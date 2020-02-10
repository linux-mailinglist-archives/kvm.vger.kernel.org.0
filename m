Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746A91571F2
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 10:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgBJJnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 04:43:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727022AbgBJJnB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 04:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581327780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=U7/trwws/wlrSgMtBTmM0ftUrtRbvojpXNWwiQbFGcg=;
        b=Nt0LCXJAygzWlAZVcB7k2/F9blTaGRwFbPHZ1AJjTmaHmWB0Ju+gqSMi25hHusLmtLYklm
        VY6qTSVgHwlbm10hgsrO3n6LOj1QByvV8+Rkh41UoJRkqt8mplmi1KTwloM2DjvCIRgJCV
        3ZZxnCWIiqk+Q6rkRw/6lKXvL5vvtKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-wR-6uW8LO1CTDrTnocoPZw-1; Mon, 10 Feb 2020 04:42:50 -0500
X-MC-Unique: wR-6uW8LO1CTDrTnocoPZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 480D318C35A0;
        Mon, 10 Feb 2020 09:42:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-219.ams2.redhat.com [10.36.116.219])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23A911001281;
        Mon, 10 Feb 2020 09:42:43 +0000 (UTC)
Subject: Re: [PATCH 03/35] s390/protvirt: introduce host side setup
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-4-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <528f69f0-2c9e-9a7b-d817-07809d00ce1b@redhat.com>
Date:   Mon, 10 Feb 2020 10:42:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-4-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Add "prot_virt" command line option which controls if the kernel
> protected VMs support is enabled at early boot time. This has to be
> done early, because it needs large amounts of memory and will disable
> some features like STP time sync for the lpar.
> 
> Extend ultravisor info definitions and expose it via uv_info struct
> filled in during startup.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
[...]
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index ed007f4a6444..af9e1cc93c68 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -3,7 +3,13 @@
>  #include <asm/facility.h>
>  #include <asm/sections.h>
>  
> +/* will be used in arch/s390/kernel/uv.c */
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>  int __bootdata_preserved(prot_virt_guest);
> +#endif
> +#if IS_ENABLED(CONFIG_KVM)
> +struct uv_info __bootdata_preserved(uv_info);
> +#endif
>  
>  void uv_query_info(void)
>  {
> @@ -18,7 +24,20 @@ void uv_query_info(void)
>  	if (uv_call(0, (uint64_t)&uvcb))
>  		return;
>  
> -	if (test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
> +	if (IS_ENABLED(CONFIG_KVM)) {
> +		memcpy(uv_info.inst_calls_list, uvcb.inst_calls_list, sizeof(uv_info.inst_calls_list));
> +		uv_info.uv_base_stor_len = uvcb.uv_base_stor_len;
> +		uv_info.guest_base_stor_len = uvcb.conf_base_phys_stor_len;
> +		uv_info.guest_virt_base_stor_len = uvcb.conf_base_virt_stor_len;
> +		uv_info.guest_virt_var_stor_len = uvcb.conf_virt_var_stor_len;
> +		uv_info.guest_cpu_stor_len = uvcb.cpu_stor_len;
> +		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
> +		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
> +		uv_info.max_guest_cpus = uvcb.max_guest_cpus;
> +	}
> +
> +	if (IS_ENABLED(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) &&
> +	    test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
>  	    test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list))
>  		prot_virt_guest = 1;
>  }
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 4093a2856929..cc7b0b0bc874 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -44,7 +44,19 @@ struct uv_cb_qui {
>  	struct uv_cb_header header;
>  	u64 reserved08;
>  	u64 inst_calls_list[4];
> -	u64 reserved30[15];
> +	u64 reserved30[2];
> +	u64 uv_base_stor_len;
> +	u64 reserved48;
> +	u64 conf_base_phys_stor_len;
> +	u64 conf_base_virt_stor_len;
> +	u64 conf_virt_var_stor_len;
> +	u64 cpu_stor_len;
> +	u32 reserved70[3];
> +	u32 max_num_sec_conf;
> +	u64 max_guest_stor_addr;
> +	u8  reserved88[158-136];
> +	u16 max_guest_cpus;
> +	u64 reserveda0;
>  } __packed __aligned(8);
>  
>  struct uv_cb_share {
> @@ -69,9 +81,21 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>  	return cc;
>  }
>  
> -#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> +struct uv_info {
> +	unsigned long inst_calls_list[4];
> +	unsigned long uv_base_stor_len;
> +	unsigned long guest_base_stor_len;
> +	unsigned long guest_virt_base_stor_len;
> +	unsigned long guest_virt_var_stor_len;
> +	unsigned long guest_cpu_stor_len;
> +	unsigned long max_sec_stor_addr;
> +	unsigned int max_num_sec_conf;
> +	unsigned short max_guest_cpus;
> +};
> +extern struct uv_info uv_info;
>  extern int prot_virt_guest;

Don't you want to keep prot_virt_guest within the "#ifdef
CONFIG_PROTECTED_VIRTUALIZATION_GUEST" ?

> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>  static inline int is_prot_virt_guest(void)
>  {
>  	return prot_virt_guest;
> @@ -121,11 +145,27 @@ static inline int uv_remove_shared(unsigned long addr)
>  	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
>  }
>  
> -void uv_query_info(void);
>  #else
>  #define is_prot_virt_guest() 0
>  static inline int uv_set_shared(unsigned long addr) { return 0; }
>  static inline int uv_remove_shared(unsigned long addr) { return 0; }
> +#endif
> +
> +#if IS_ENABLED(CONFIG_KVM)
> +extern int prot_virt_host;
> +
> +static inline int is_prot_virt_host(void)
> +{
> +	return prot_virt_host;
> +}
> +#else
> +#define is_prot_virt_host() 0
> +#endif
> +
> +#if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
> +	IS_ENABLED(CONFIG_KVM)
> +void uv_query_info(void);
> +#else
>  static inline void uv_query_info(void) {}
>  #endif

With the nit fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>

