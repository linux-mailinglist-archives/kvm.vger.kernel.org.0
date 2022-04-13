Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BF44FFA8C
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 17:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiDMPpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 11:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiDMPpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 11:45:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2333553A6F
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 08:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649864582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Pc+Zb+xRIR5yHE6Kcvf6gi8HVLWPTCOKDgqPzeM6RQ=;
        b=L9coFYrDZQurNpXplK6bhp0jtjnEk8AbxqJKKU5ps/6AKloP3HE5+uy6yzQavsINSr1PZj
        NC/SslIg+hJqtRdt6Uu2cy3VNLPdEBnT6YMVrpiVIRjX63bGsegEh3QxPr4am2yYG7xZd7
        jucTs0LlJuOPRhcbXUbvDjK5bvih+o8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-hIQROnsSNtakKsxaTJJswA-1; Wed, 13 Apr 2022 11:43:00 -0400
X-MC-Unique: hIQROnsSNtakKsxaTJJswA-1
Received: by mail-wr1-f69.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so481444wrg.19
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 08:43:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Pc+Zb+xRIR5yHE6Kcvf6gi8HVLWPTCOKDgqPzeM6RQ=;
        b=L83yabWhkXACMDkVisKIsluHulKsDuG0OsNdAb1pOH34E0H5KFJ1x6X+f24rSXtFLi
         bNLXqGyYTsNS2elUUW6dCGSc8G3og7S487/cgZU8Ts2hH78E++0pwQkACxfXAG/nzSEt
         GATjVY0xpSCaYkWFzs15pjx6t6pPHxjSOEtJup4C0l1Eh1kSu0ishaRwyzyzTUJGZUAm
         E7FYMu0ImLTYBTNwhIeQskAQ+oOphzFFN+aFLNUu8Y1NW/AayaKeMRqTYaMwDPpYhbul
         Q+J6y2xZ9siGo6wIAJ2+ENHsK6WG2MjFDHigt9HOzTMWAupvoveMFXDK6EDN8kwJ7Euv
         YcPw==
X-Gm-Message-State: AOAM530rFIbInvFejNHjfCLWsMAeit5Ezcrq4amSAyNuMb0NElJroM1p
        A7ISUcpWmBmSs2aUQVOPMlhQyhU4Mz6boo2dHH9wY4OrJRUpsUqsdEbgTd6tS1nR8lVhRfXX3qG
        0qVGjIbu5mns0
X-Received: by 2002:a7b:ce99:0:b0:38e:b72a:382c with SMTP id q25-20020a7bce99000000b0038eb72a382cmr9261867wmj.128.1649864579709;
        Wed, 13 Apr 2022 08:42:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRnjSPbSd23JRTkSxM1VcgGXP6n+p0ziGiuUsGlIGDVbCl9ulHT3l4SKojr974J2xzUk1+iQ==
X-Received: by 2002:a7b:ce99:0:b0:38e:b72a:382c with SMTP id q25-20020a7bce99000000b0038eb72a382cmr9261858wmj.128.1649864579437;
        Wed, 13 Apr 2022 08:42:59 -0700 (PDT)
Received: from [10.33.192.232] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id 10-20020a5d47aa000000b00207afc4bd39sm6071599wrb.18.2022.04.13.08.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 08:42:58 -0700 (PDT)
Message-ID: <bb0dc8b9-f185-27cb-7c19-68899d528d94@redhat.com>
Date:   Wed, 13 Apr 2022 17:42:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib: s390x: add support for SCLP
 console read
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220413152658.715003-1-nrb@linux.ibm.com>
 <20220413152658.715003-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220413152658.715003-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/04/2022 17.26, Nico Boehr wrote:
> Add a basic implementation for reading from the SCLP ASCII console. The goal of
> this is to support migration tests on s390x. To know when the migration has been
> finished, we need to listen for a newline on our console.
> 
> Hence, this implementation is focused on the SCLP ASCII console of QEMU and
> currently won't work under e.g. LPAR.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/sclp-console.c | 79 +++++++++++++++++++++++++++++++++++++---
>   lib/s390x/sclp.h         |  8 ++++
>   s390x/Makefile           |  1 +
>   3 files changed, 82 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> index fa36a6a42381..e580de6830d6 100644
> --- a/lib/s390x/sclp-console.c
> +++ b/lib/s390x/sclp-console.c
> @@ -89,6 +89,10 @@ static char lm_buff[120];
>   static unsigned char lm_buff_off;
>   static struct spinlock lm_buff_lock;
>   
> +static char read_buf[4096];
> +static int read_index = sizeof(read_buf) - 1;
> +static int read_buf_end = 0;
> +
>   static void sclp_print_ascii(const char *str)
>   {
>   	int len = strlen(str);
> @@ -185,7 +189,7 @@ static void sclp_print_lm(const char *str)
>    * indicating which messages the control program (we) want(s) to
>    * send/receive.
>    */
> -static void sclp_set_write_mask(void)
> +static void sclp_write_event_mask(int receive_mask, int send_mask)
>   {
>   	WriteEventMask *sccb = (void *)_sccb;
>   
> @@ -195,18 +199,27 @@ static void sclp_set_write_mask(void)
>   	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
>   	sccb->mask_length = sizeof(sccb_mask_t);
>   
> -	/* For now we don't process sclp input. */
> -	sccb->cp_receive_mask = 0;
> -	/* We send ASCII and line mode. */
> -	sccb->cp_send_mask = SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG;
> +	sccb->cp_receive_mask = receive_mask;
> +	sccb->cp_send_mask = send_mask;
>   
>   	sclp_service_call(SCLP_CMD_WRITE_EVENT_MASK, sccb);
>   	assert(sccb->h.response_code == SCLP_RC_NORMAL_COMPLETION);
>   }
>   
> +static void sclp_console_enable_read(void)
> +{
> +	sclp_write_event_mask(SCLP_EVENT_MASK_MSG_ASCII, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
> +}
> +
> +static void sclp_console_disable_read(void)
> +{
> +	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
> +}
> +
>   void sclp_console_setup(void)
>   {
> -	sclp_set_write_mask();
> +	/* We send ASCII and line mode. */
> +	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
>   }
>   
>   void sclp_print(const char *str)
> @@ -227,3 +240,57 @@ void sclp_print(const char *str)
>   	sclp_print_ascii(str);
>   	sclp_print_lm(str);
>   }
> +
> +static int console_refill_read_buffer(void)
> +{
> +	const int max_event_buffer_len = SCCB_SIZE - offsetof(ReadEventDataAsciiConsole, ebh);
> +	ReadEventDataAsciiConsole *sccb = (void *)_sccb;
> +	const int event_buffer_ascii_recv_header_len = sizeof(sccb->ebh) + sizeof(sccb->type);
> +	int ret = -1;
> +
> +	sclp_console_enable_read();
> +
> +	sclp_mark_busy();
> +	memset(sccb, 0, SCCB_SIZE);
> +	sccb->h.length = PAGE_SIZE;
> +	sccb->h.function_code = SCLP_UNCONDITIONAL_READ;
> +	sccb->h.control_mask[2] = SCLP_CM2_VARIABLE_LENGTH_RESPONSE;
> +
> +	sclp_service_call(SCLP_CMD_READ_EVENT_DATA, sccb);
> +
> +	if ((sccb->h.response_code == SCLP_RC_NO_EVENT_BUFFERS_STORED) ||
> +	    (sccb->ebh.type != SCLP_EVENT_ASCII_CONSOLE_DATA) ||
> +	    (sccb->type != SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS)) {

Cosmetic nit: You could drop the innermost braces.

> +		ret = -1;
> +		goto out;
> +	}
> +
> +	assert(sccb->ebh.length <= max_event_buffer_len);
> +	assert(sccb->ebh.length > event_buffer_ascii_recv_header_len);
> +
> +	read_buf_end = sccb->ebh.length - event_buffer_ascii_recv_header_len;
> +
> +	assert(read_buf_end <= sizeof(read_buf));
> +	memcpy(read_buf, sccb->data, read_buf_end);
> +
> +	read_index = 0;
> +	ret = 0;
> +
> +out:
> +	sclp_console_disable_read();
> +
> +	return ret;
> +}
> +
> +int __getchar(void)
> +{
> +	int ret;
> +
> +	if (read_index >= read_buf_end) {
> +		ret = console_refill_read_buffer();
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return read_buf[read_index++];
> +}
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index fead007a6037..e48a5a3df20b 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -313,6 +313,14 @@ typedef struct ReadEventData {
>   	uint32_t mask;
>   } __attribute__((packed)) ReadEventData;
>   
> +#define SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS 0
> +typedef struct ReadEventDataAsciiConsole {
> +	SCCBHeader h;
> +	EventBufferHeader ebh;
> +	uint8_t type;
> +	char data[];
> +} __attribute__((packed)) ReadEventDataAsciiConsole;
> +
>   extern char _sccb[];
>   void sclp_setup_int(void);
>   void sclp_handle_ext(void);
> diff --git a/s390x/Makefile b/s390x/Makefile
> index c11f6efbd767..f38f442b9cb1 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -75,6 +75,7 @@ cflatobjs += lib/alloc_phys.o
>   cflatobjs += lib/alloc_page.o
>   cflatobjs += lib/vmalloc.o
>   cflatobjs += lib/alloc_phys.o
> +cflatobjs += lib/getchar.o
>   cflatobjs += lib/s390x/io.o
>   cflatobjs += lib/s390x/stack.o
>   cflatobjs += lib/s390x/sclp.o

Reviewed-by: Thomas Huth <thuth@redhat.com>

