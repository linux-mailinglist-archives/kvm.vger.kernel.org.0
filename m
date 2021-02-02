Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3491330C808
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbhBBRi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:38:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237648AbhBBRgu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:36:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612287323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O4oTsdRd/8zp7Nz1DPVOiX2FHvUnLLUX8No6k0DaE4g=;
        b=KR53mCPo4C2qVRjUMhVuqqPkAyo5CuLzUxyD3SXtAU8kWtb2TSy8DHr7MLlXqF79LTyWc7
        B3bUlGBromdWDt6Ivqra+3CTIoXNumdo5O9OdpAlkuNeEvsHRCx7vTao9Ufh62PRzQnBy2
        vtnk2Hslj4Kzjv3oLwpjZXXWZmstMPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-F-7Hn6pjP9ejWcbt5wZ6eg-1; Tue, 02 Feb 2021 12:35:19 -0500
X-MC-Unique: F-7Hn6pjP9ejWcbt5wZ6eg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88C2D192AB78;
        Tue,  2 Feb 2021 17:35:18 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-112.ams2.redhat.com [10.36.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2BB6544E8;
        Tue,  2 Feb 2021 17:35:13 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 4/5] s390x: css: SCHM tests format 0
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-5-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b3086f69-98fa-07c0-72c7-711c17e71c9d@redhat.com>
Date:   Tue, 2 Feb 2021 18:35:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611930869-25745-5-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/01/2021 15.34, Pierre Morel wrote:
> We tests the update of the mesurement block format 0, the
> mesurement block origin is calculated from the mbo argument
> used by the SCHM instruction and the offset calculated using
> the measurement block index of the SCHIB.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/css.h | 29 ++++++++++++++++++++++++++++
>   s390x/css.c     | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 80 insertions(+)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 938f0ab..ba0bc67 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -358,7 +358,36 @@ static inline void schm(void *mbo, unsigned int flags)
>   	asm("schm" : : "d" (__gpr2), "d" (__gpr1));
>   }
>   
> +#define SCHM_DCTM	1 /* activate Device Connection TiMe */
> +#define SCHM_MBU	2 /* activate Measurement Block Update */
> +
>   int css_enable_mb(int schid, uint64_t mb, int format1, uint16_t mbi,
>   		  uint16_t flags);
>   
> +struct measurement_block_format0 {
> +	uint16_t ssch_rsch_count;
> +	uint16_t sample_count;
> +	uint32_t device_connect_time;
> +	uint32_t function_pending_time;
> +	uint32_t device_disconnect_time;
> +	uint32_t cu_queuing_time;
> +	uint32_t device_active_only_time;
> +	uint32_t device_busy_time;
> +	uint32_t initial_cmd_resp_time;
> +};
> +
> +struct measurement_block_format1 {
> +	uint32_t ssch_rsch_count;
> +	uint32_t sample_count;
> +	uint32_t device_connect_time;
> +	uint32_t function_pending_time;
> +	uint32_t device_disconnect_time;
> +	uint32_t cu_queuing_time;
> +	uint32_t device_active_only_time;
> +	uint32_t device_busy_time;
> +	uint32_t initial_cmd_resp_time;
> +	uint32_t irq_delay_time;
> +	uint32_t irq_prio_delay_time;
> +};
> +
>   #endif
> diff --git a/s390x/css.c b/s390x/css.c
> index 000ce04..2e9ea47 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -155,10 +155,61 @@ static void css_init(void)
>   	report(1, "CSS initialized");
>   }
>   
> +#define SCHM_UPDATE_CNT 10
> +static void test_schm_fmt0(struct measurement_block_format0 *mb0)
> +{
> +	int ret;
> +	int i;
> +
> +	report_prefix_push("Format 0");
> +	ret = css_enable_mb(test_device_sid, 0, 0, 0, PMCW_MBUE);
> +	if (ret) {
> +		report(0, "Enabling measurement_block_format0");
> +		goto end;
> +	}
> +
> +	for (i = 0; i < SCHM_UPDATE_CNT; i++) {
> +		if (!do_test_sense()) {
> +			report(0, "Error during sense");
> +			break;
> +		}
> +	}
> +
> +	report_info("ssch_rsch_count: %d", mb0->ssch_rsch_count);
> +	report_info("sample_count: %d", mb0->sample_count);
> +	report_info("device_connect_time: %d", mb0->device_connect_time);
> +	report_info("function_pending_time: %d", mb0->function_pending_time);
> +	report_info("device_disconnect_time: %d", mb0->device_disconnect_time);
> +	report_info("cu_queuing_time: %d", mb0->cu_queuing_time);
> +	report_info("device_active_only_time: %d", mb0->device_active_only_time);
> +	report_info("device_busy_time: %d", mb0->device_busy_time);
> +	report_info("initial_cmd_resp_time: %d", mb0->initial_cmd_resp_time);
> +
> +	report(i == mb0->ssch_rsch_count,
> +	       "SSCH expected %d measured %d", i, mb0->ssch_rsch_count);
> +
> +end:
> +	report_prefix_pop();
> +}
> +
>   static void test_schm(void)
>   {
> +	struct measurement_block_format0 *mb0;
> +
>   	if (css_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK))
>   		report_info("Extended measurement block available");
> +
> +	mb0 = alloc_io_mem(sizeof(struct measurement_block_format0), 0);
> +	if (!mb0) {
> +		report(0, "measurement_block_format0 allocation");
> +		goto end_free;

If allocation failed, there is certainly no need to try to free it, so you 
can get rid of the goto and the label here and return directly instead. Or 
maybe
Maybe also simply use report_abort() in this case?

  Thomas


> +	}
> +
> +	schm(mb0, SCHM_MBU);
> +	test_schm_fmt0(mb0);
> +
> +end_free:
> +	free_io_mem(mb0, sizeof(struct measurement_block_format0));
>   }
>   
>   static struct {
> 

