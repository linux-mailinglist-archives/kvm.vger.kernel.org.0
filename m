Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35E94FD92F
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 12:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353023AbiDLJ6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 05:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383485AbiDLIhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 04:37:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50CD35DA46
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 01:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649750532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F2J36Jhz1YaQBB3f5qHeBJfoSIGkVHxMW0PGdSKO3ZM=;
        b=VBtBryg230UuUAxVnp3R87WnLxmxx2hfgC6hk+b5n/uKEBLvRjdMueNTkKtpBBRfuCt9h4
        KODF/EOfSQMVxU/+1l5mAG/HQ/eM/XksJavMOqi7AiLR5RmNZ1xiC2Bedgs5wrN4egavub
        1dbI8tw4YZ0xoCUNwPH4Fz+vXqE4AAU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-SVyiSaj5PvGgsqnhxH4lIw-1; Tue, 12 Apr 2022 04:02:11 -0400
X-MC-Unique: SVyiSaj5PvGgsqnhxH4lIw-1
Received: by mail-wm1-f70.google.com with SMTP id l41-20020a05600c1d2900b0038ec007ac7fso938767wms.4
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 01:02:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F2J36Jhz1YaQBB3f5qHeBJfoSIGkVHxMW0PGdSKO3ZM=;
        b=mU/qa/9Z2WixStPmjOJo1CnGjyRLfk74PwCZ2iZb06cy0XNwvQ8FEmIFJvfzJvdEF3
         n1r4bTwC4Qa0xEqTFGIZOqKBcRdFfbHZ6/c/oAWLjs3/CrK0gMIyzjD5JSmuXSZdYU0Y
         NpV2Hfv45jASUXeNkEiBrBdlpKMHCLmI1R55y1EfVklAbwRW6Ln9d7Xt0cQrSNuVs6mf
         qzXxdLiXuYyA/4QFoMCFhgsSJGq1J7/xHwrDddPoZiqhlvzmsKOpsyKBAQFJXDNodayu
         6+2ISgly7YDKbmHlUWDUU5O1cr7UeCgm57j9vpk4oHuBB1F4kHqHbr8hBWl2SwCuk8r+
         Edpw==
X-Gm-Message-State: AOAM533e+7Pmgl4okL4YbrscSjJOCnw4kO0KMiBDRnybJaHLQ4aTMLg6
        Ln18uJUaCK6xby72S+cUgKGYLGgtuLF3MnPkI+L7HRkHiC9gmKZ9SdT1aTzNLLJoQbaWARgxxjB
        A3uMNAyRX2634
X-Received: by 2002:a05:600c:4f95:b0:38e:b596:b3f5 with SMTP id n21-20020a05600c4f9500b0038eb596b3f5mr2881000wmq.164.1649750530022;
        Tue, 12 Apr 2022 01:02:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzykSjp7VgD9NDoHi2oJCBjKs8vgFuCOlLxU3YiP+FZKbkVGV9WitCc50I9vLUCjke/UODGMw==
X-Received: by 2002:a05:600c:4f95:b0:38e:b596:b3f5 with SMTP id n21-20020a05600c4f9500b0038eb596b3f5mr2880984wmq.164.1649750529737;
        Tue, 12 Apr 2022 01:02:09 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d6a8b000000b002060a8c810bsm24470001wru.24.2022.04.12.01.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 01:02:09 -0700 (PDT)
Message-ID: <3cac38d6-41f1-1c5e-1af1-c19f3f68aab2@redhat.com>
Date:   Tue, 12 Apr 2022 10:02:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH v1 1/4] lib: s390x: add support for SCLP
 console read
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
 <20220411100750.2868587-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220411100750.2868587-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/04/2022 12.07, Nico Boehr wrote:
> Add a basic implementation for reading from the SCLP ACII console. The goal of

s/ACII/ASCII/

> this is to support migration tests on s390x. To know when the migration has been
> finished, we need to listen for a newline on our console.
> 
> Hence, this implementation is focused on the SCLP ASCII console of QEMU and
> currently won't work under e.g. LPAR.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/sclp-console.c | 81 +++++++++++++++++++++++++++++++++++++---
>   lib/s390x/sclp.h         |  7 ++++
>   s390x/Makefile           |  1 +
>   3 files changed, 83 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> index fa36a6a42381..8e22660bf25d 100644
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
> @@ -227,3 +240,59 @@ void sclp_print(const char *str)
>   	sclp_print_ascii(str);
>   	sclp_print_lm(str);
>   }
> +
> +#define SCLP_EVENT_ASCII_DATA_STREAM_FOLLOWS 0
> +
> +static int console_refill_read_buffer(void)
> +{
> +	const int MAX_EVENT_BUFFER_LEN = SCCB_SIZE - offsetof(ReadEventDataAsciiConsole, ebh);
> +	ReadEventDataAsciiConsole *sccb = (void *)_sccb;
> +	const int EVENT_BUFFER_ASCII_RECV_HEADER_LEN = sizeof(sccb->ebh) + sizeof(sccb->type);
> +	int ret = -1;
> +
> +	sclp_console_enable_read();
> +
> +	sclp_mark_busy();
> +	memset(sccb, 0, 4096);
> +	sccb->h.length = PAGE_SIZE;
> +	sccb->h.function_code = SCLP_UNCONDITIONAL_READ;
> +	sccb->h.control_mask[2] = 0x80;

Add at least a comment about what the 0x80 means, please?

> +
> +	sclp_service_call(SCLP_CMD_READ_EVENT_DATA, sccb);
> +
> +	if ((sccb->h.response_code == SCLP_RC_NO_EVENT_BUFFERS_STORED) ||
> +	    (sccb->ebh.type != SCLP_EVENT_ASCII_CONSOLE_DATA) ||
> +	    (sccb->type != SCLP_EVENT_ASCII_DATA_STREAM_FOLLOWS)) {
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	assert(sccb->ebh.length <= MAX_EVENT_BUFFER_LEN);
> +	assert(sccb->ebh.length > EVENT_BUFFER_ASCII_RECV_HEADER_LEN);
> +
> +	read_buf_end = sccb->ebh.length - EVENT_BUFFER_ASCII_RECV_HEADER_LEN;
> +
> +	assert(read_buf_end <= sizeof(read_buf));
> +	memcpy(read_buf, sccb->data, read_buf_end);
> +
> +	read_index = 0;

Set "ret = 0" here?

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
> +		if (ret < 0) {
> +			return ret;
> +		}
> +	}
> +
> +	return read_buf[read_index++];
> +}

  Thomas

