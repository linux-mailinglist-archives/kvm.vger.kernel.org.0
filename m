Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B730B508AAB
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 16:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352736AbiDTOZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 10:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238125AbiDTOZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 10:25:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6755443CB;
        Wed, 20 Apr 2022 07:22:30 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KEHB6m024692;
        Wed, 20 Apr 2022 14:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=x6wGtle0ZTTKKFOmQ44XkNuq4yD/szsth1NNcJiVIcI=;
 b=VpVIGxk/pVQG0oW3W/p15LfiqUcfA1Y7XpEUu9zTQW391XoYqcGAAU2fYh2Ed36EhTur
 zPzeNnhm3nytaxvZIejPMhHaqU3LwGrGa8u6jA4FlpPGMxZxL1DK6JldBxMSi1B8wTHH
 8+KccN4Fiw3ajUMOtnTxcnqLsI1Y+eRuMv9DNtVqRMeU+udNHJVh72O7TPS4pfmRkJi1
 1p4Mh3XUXkXG3uBky+Bb969rx/HJPZQrY72UIoNIylJI5XLgQdKs29uoPmwEXsDx6Zy7
 t1P8r9m2Kuaf3C9Fe54OWE1x68iuOxopZCLfxsXY4uCMjRROaMRsaNEl2Xx59yNPh4Nj /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff2x6p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 14:22:30 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KCXvwv015495;
        Wed, 20 Apr 2022 14:22:29 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff2x6n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 14:22:29 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KEJ8VH028570;
        Wed, 20 Apr 2022 14:22:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3ffne953k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 14:22:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KEMNDB51970368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 14:22:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B578CA4054;
        Wed, 20 Apr 2022 14:22:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 588EDA405C;
        Wed, 20 Apr 2022 14:22:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 14:22:23 +0000 (GMT)
Date:   Wed, 20 Apr 2022 16:16:14 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 1/4] lib: s390x: add support for SCLP
 console read
Message-ID: <20220420161614.2fc6d218@p-imbrenda>
In-Reply-To: <20220420134557.1307305-2-nrb@linux.ibm.com>
References: <20220420134557.1307305-1-nrb@linux.ibm.com>
        <20220420134557.1307305-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xDLMJWr7rGaY8wruVF4jHjs0mp801a4m
X-Proofpoint-ORIG-GUID: L0f7c2NHawMfZ7treFV6-SWh9hgt2hj5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_04,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Apr 2022 15:45:54 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Add a basic implementation for reading from the SCLP ASCII console. The goal of
> this is to support migration tests on s390x. To know when the migration has been
> finished, we need to listen for a newline on our console.
> 
> Hence, this implementation is focused on the SCLP ASCII console of QEMU and
> currently won't work under e.g. LPAR.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sclp-console.c | 79 +++++++++++++++++++++++++++++++++++++---
>  lib/s390x/sclp.h         |  8 ++++
>  s390x/Makefile           |  1 +
>  3 files changed, 82 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> index fa36a6a42381..8c4bf68cbbab 100644
> --- a/lib/s390x/sclp-console.c
> +++ b/lib/s390x/sclp-console.c
> @@ -89,6 +89,10 @@ static char lm_buff[120];
>  static unsigned char lm_buff_off;
>  static struct spinlock lm_buff_lock;
>  
> +static char read_buf[4096];
> +static int read_index = sizeof(read_buf) - 1;
> +static int read_buf_end = 0;
> +
>  static void sclp_print_ascii(const char *str)
>  {
>  	int len = strlen(str);
> @@ -185,7 +189,7 @@ static void sclp_print_lm(const char *str)
>   * indicating which messages the control program (we) want(s) to
>   * send/receive.
>   */
> -static void sclp_set_write_mask(void)
> +static void sclp_write_event_mask(int receive_mask, int send_mask)
>  {
>  	WriteEventMask *sccb = (void *)_sccb;
>  
> @@ -195,18 +199,27 @@ static void sclp_set_write_mask(void)
>  	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
>  	sccb->mask_length = sizeof(sccb_mask_t);
>  
> -	/* For now we don't process sclp input. */
> -	sccb->cp_receive_mask = 0;
> -	/* We send ASCII and line mode. */
> -	sccb->cp_send_mask = SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG;
> +	sccb->cp_receive_mask = receive_mask;
> +	sccb->cp_send_mask = send_mask;
>  
>  	sclp_service_call(SCLP_CMD_WRITE_EVENT_MASK, sccb);
>  	assert(sccb->h.response_code == SCLP_RC_NORMAL_COMPLETION);
>  }
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
>  void sclp_console_setup(void)
>  {
> -	sclp_set_write_mask();
> +	/* We send ASCII and line mode. */
> +	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
>  }
>  
>  void sclp_print(const char *str)
> @@ -227,3 +240,57 @@ void sclp_print(const char *str)
>  	sclp_print_ascii(str);
>  	sclp_print_lm(str);
>  }
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
> +	if (sccb->h.response_code == SCLP_RC_NO_EVENT_BUFFERS_STORED ||
> +	    sccb->ebh.type != SCLP_EVENT_ASCII_CONSOLE_DATA ||
> +	    sccb->type != SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS) {
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
>  	uint32_t mask;
>  } __attribute__((packed)) ReadEventData;
>  
> +#define SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS 0
> +typedef struct ReadEventDataAsciiConsole {
> +	SCCBHeader h;
> +	EventBufferHeader ebh;
> +	uint8_t type;
> +	char data[];
> +} __attribute__((packed)) ReadEventDataAsciiConsole;
> +
>  extern char _sccb[];
>  void sclp_setup_int(void);
>  void sclp_handle_ext(void);
> diff --git a/s390x/Makefile b/s390x/Makefile
> index c11f6efbd767..f38f442b9cb1 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -75,6 +75,7 @@ cflatobjs += lib/alloc_phys.o
>  cflatobjs += lib/alloc_page.o
>  cflatobjs += lib/vmalloc.o
>  cflatobjs += lib/alloc_phys.o
> +cflatobjs += lib/getchar.o
>  cflatobjs += lib/s390x/io.o
>  cflatobjs += lib/s390x/stack.o
>  cflatobjs += lib/s390x/sclp.o

