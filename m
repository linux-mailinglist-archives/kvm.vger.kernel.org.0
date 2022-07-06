Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0FF568F39
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiGFQd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 12:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiGFQd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 12:33:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CC82AC7;
        Wed,  6 Jul 2022 09:33:55 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266Fl0m4002175;
        Wed, 6 Jul 2022 16:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ziy2+VpVYG4mwcyycR7DZV+CqdzI92MPpl98qy7giYE=;
 b=XPUnRgYY3TZtIkdwysZhEmFBJFZGpLjj4qPj2EPuSA9l24JlOqlLfG5eA7Ck+OOoSyCm
 EQZGfH5XzxW6uULWCn+UEQDp6u6jktRJpl7aJCQq9QsyGlvr0ts5la9tLD2s9HUb78dn
 ufony1mEdaGliejCRdrxKjwdmYNn/95h/hnvkMv2NrjNoy1mHKiUUi65YRvmCpbuy1Tc
 JphsvL5lbFclnMsou6BBGn02zFKuAO/vF3GedoSP8Xo8ebtxI4V9yYa8gkwa3jr0wep/
 7b5v7z49XqxZZtoKEq0F4HQkrtLlkDlKeFVUkJFsDZyORci4okUEu8KUOb8wTpYpEgYd Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5db516wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 16:33:54 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 266GIkus020383;
        Wed, 6 Jul 2022 16:33:54 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5db516w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 16:33:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 266GLxNA013811;
        Wed, 6 Jul 2022 16:33:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3h4usd1ct4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 16:33:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 266GXnVI22151452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 16:33:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29D37A4053;
        Wed,  6 Jul 2022 16:33:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE801A4055;
        Wed,  6 Jul 2022 16:33:48 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.172])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Jul 2022 16:33:48 +0000 (GMT)
Date:   Wed, 6 Jul 2022 18:33:46 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/8] s390x: uv-host: Add access checks
 for donated memory
Message-ID: <20220706183346.2a027e8b@p-imbrenda>
In-Reply-To: <20220706064024.16573-2-frankja@linux.ibm.com>
References: <20220706064024.16573-1-frankja@linux.ibm.com>
        <20220706064024.16573-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wUHtfsghoQjmQI47-mziYdzlzyZ1F6iC
X-Proofpoint-GUID: gFfoUmaUlxtOABi6FKCtRqcQW62fEjT4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207060066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  6 Jul 2022 06:40:17 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's check if the UV really protected all the memory we donated.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/uv-host.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index a1a6d120..983cb4a1 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -43,6 +43,24 @@ static void cpu_loop(void)
>  	for (;;) {}
>  }
>  
> +/*
> + * Checks if a memory area is protected as secure memory.
> + * Will return true if all pages are protected, false otherwise.
> + */
> +static bool access_check_3d(uint64_t *access_ptr, uint64_t len)
> +{
> +	while (len) {
> +		expect_pgm_int();
> +		*access_ptr += 42;

I'm surprised this works, you will get an (expected) exception when
reading from the pointer, and then you should get another one (at this
point unexpected) when writing

> +		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
> +			return false;
> +		access_ptr += PAGE_SIZE / sizeof(access_ptr);
> +		len -= PAGE_SIZE;
> +	}
> +
> +	return true;
> +}
> +
>  static struct cmd_list cmds[] = {
>  	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init), BIT_UVC_CMD_INIT_UV },
>  	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
> @@ -194,6 +212,10 @@ static void test_cpu_create(void)
>  	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
>  	       uvcb_csc.cpu_handle, "success");
>  
> +	rc = access_check_3d((uint64_t *)uvcb_csc.stor_origin,
> +			     uvcb_qui.cpu_stor_len);
> +	report(rc, "Storage protection");
> +
>  	tmp = uvcb_csc.stor_origin;
>  	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
>  	rc = uv_call(0, (uint64_t)&uvcb_csc);
> @@ -292,6 +314,13 @@ static void test_config_create(void)
>  	rc = uv_call(0, (uint64_t)&uvcb_cgc);
>  	report(rc == 0 && uvcb_cgc.header.rc == UVC_RC_EXECUTED, "successful");
>  
> +	rc = access_check_3d((uint64_t *)uvcb_cgc.conf_var_stor_origin, vsize);
> +	report(rc, "Base storage protection");
> +
> +	rc = access_check_3d((uint64_t *)uvcb_cgc.conf_base_stor_origin,
> +			     uvcb_qui.conf_base_phys_stor_len);
> +	report(rc, "Variable storage protection");
> +
>  	uvcb_cgc.header.rc = 0;
>  	uvcb_cgc.header.rrc = 0;
>  	tmp = uvcb_cgc.guest_handle;

