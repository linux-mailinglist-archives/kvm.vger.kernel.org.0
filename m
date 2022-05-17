Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C63252A076
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343904AbiEQLdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbiEQLc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:32:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B6327FFE;
        Tue, 17 May 2022 04:32:56 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HArhKS032447;
        Tue, 17 May 2022 11:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7S/qEovX+DzagnVagYpY+qWBXeYZapNmr+C+3jCrtm8=;
 b=b29XQzG9OdK0+bSamtc4UcSc+T6OzjxIOlFlefPYrFEUXIfkA3PITHiEPA5Pn2enDBVG
 FSx0tnuOzHTUbNhx+Glr78OOM9ZrQUBHDh03sLO4kNmzVBq3H+hnFpCEn6fmGoFxr4X8
 C/ruKtG72/Kn8AHCHQv4QAk00gnBxl5zGtUQFyvP6+PZDNCC7UhQSpqUn44U6nX7DbO8
 2Pcdr/CDHy6Fl44aCQg9CbuIc3PVVjZojXbRmnxuRP5VcWUisUXOktnjDfDKvH37f3Xa
 8ziTZGw2OUzzGFMfmOan7HAmphb2Lf2Is6gxWdGljm41Cm68Z8pzFqaF2Rro8fPDd3ky SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4abw8s3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:32:55 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HBWtr3011516;
        Tue, 17 May 2022 11:32:55 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4abw8s34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:32:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBIMxH025084;
        Tue, 17 May 2022 11:32:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429c3st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:32:53 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBWnCw29819274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:32:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0D57A404D;
        Tue, 17 May 2022 11:32:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35CDAA4051;
        Tue, 17 May 2022 11:32:49 +0000 (GMT)
Received: from [9.152.224.153] (unknown [9.152.224.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:32:49 +0000 (GMT)
Message-ID: <fca64c54-b612-eabf-d460-5b200b581112@linux.ibm.com>
Date:   Tue, 17 May 2022 13:32:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 5/6] s390x: uv-host: Add a set secure
 config parameters test function
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220513095017.16301-1-frankja@linux.ibm.com>
 <20220513095017.16301-6-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220513095017.16301-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ch58R9RMWd9MoWSYaRobu2ybXsAr0nb9
X-Proofpoint-GUID: SbCOMFEkD7srnaSdhr2UYJ9iV0TI4v_r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170068
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Janosch,

On 5/13/22 11:50, Janosch Frank wrote:
> Time for more tests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
If you free 'pages'

> ---
>   s390x/uv-host.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 153a94e1..20d805b8 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -229,6 +229,52 @@ static void test_cpu_destroy(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_set_se_header(void)
> +{
> +	struct uv_cb_ssc uvcb = {
> +		.header.cmd = UVC_CMD_SET_SEC_CONF_PARAMS,
> +		.header.len = sizeof(uvcb),
> +		.guest_handle = uvcb_cgc.guest_handle,
> +		.sec_header_origin = 0,
> +		.sec_header_len = 0x1000,
> +	};
> +	void *pages =  alloc_pages(1);
> +	void *inv;
> +	int rc;
> +
> +	report_prefix_push("sscp");
> +
> +	uvcb.header.len -= 8;
> +	rc = uv_call(0, (uint64_t)&uvcb);
> +	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_LEN,
> +	       "hdr invalid length");
> +	uvcb.header.len += 8;
> +
> +	uvcb.guest_handle += 1;
> +	rc = uv_call(0, (uint64_t)&uvcb);
> +	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_GHANDLE, "invalid handle");
> +	uvcb.guest_handle -= 1;
> +
> +	inv = pages + PAGE_SIZE;
> +	uvcb.sec_header_origin = (uint64_t)inv;
> +	protect_page(inv, PAGE_ENTRY_I);
> +	rc = uv_call(0, (uint64_t)&uvcb);
> +	report(rc == 1 && uvcb.header.rc == 0x103,
> +	       "se hdr access exception");
> +
> +	/*
> +	 * Shift the ptr so the first few DWORDs are accessible but
> +	 * the following are on an invalid page.
> +	 */
> +	uvcb.sec_header_origin -= 0x20;
> +	rc = uv_call(0, (uint64_t)&uvcb);
> +	report(rc == 1 && uvcb.header.rc == 0x103,
> +	       "se hdr access exception crossing");
> +	unprotect_page(inv, PAGE_ENTRY_I);

please free 'pages'.

> +
> +	report_prefix_pop();
> +}
> +
>   static void test_cpu_create(void)
>   {
>   	int rc;
> @@ -669,6 +715,7 @@ int main(void)
>   
>   	test_config_create();
>   	test_cpu_create();
> +	test_set_se_header();
>   	test_cpu_destroy();
>   	test_config_destroy();
>   	test_clear();

Steffen
