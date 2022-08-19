Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2D7599973
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 12:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348224AbiHSKBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 06:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348092AbiHSKBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 06:01:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9AAF4CAE;
        Fri, 19 Aug 2022 03:01:18 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J9xTOn020424;
        Fri, 19 Aug 2022 10:01:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=u6YMy6Ix9WjbVng7rQr/9Mprb+EHTMWFzig8waTbMMY=;
 b=sUXFammzYzb+0MVvJIrscHe/LEFvl1PE78vLNl5vNhAO9zRYmilHrviqQLSWlNvfqAZy
 717/UzB2uAK7b3WD1JauUI2sJGdM98naVYBRZYRtB/3pF0GoDiF2Oya4hJ83KYO53g0H
 gP00EFTugW1b7eqbtL7SATUCB2Sa26m1hy+RIAENDwW53nUnmnKUKQgkgDGM53Mn+C2C
 5mVT4cEUtqKioMhxb/JFS91AZfNp2/qoUgnA9MHIJwRCuZCAZU5DJDSo+ABMxM+LtOde
 pHm05HMJtYwoczfT3pz4PKl6SCX7jlTOFO8KwdUkfNZd6DxUcMVgcNMiQF2V3+vSRzWo 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j28cer1da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 10:01:17 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27JA1C3I024866;
        Fri, 19 Aug 2022 10:01:16 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j28cer1ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 10:01:16 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27J9riHX016876;
        Fri, 19 Aug 2022 10:01:14 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3hx3k8w864-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 10:01:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27JA1AvJ21954904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 10:01:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73155A4053;
        Fri, 19 Aug 2022 10:01:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E73F2A404D;
        Fri, 19 Aug 2022 10:01:09 +0000 (GMT)
Received: from [9.145.49.220] (unknown [9.145.49.220])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 10:01:09 +0000 (GMT)
Message-ID: <ff6cbb6c-9e21-ee40-419e-4251abfd4d87@linux.ibm.com>
Date:   Fri, 19 Aug 2022 12:01:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v13 5/6] KVM: s390: pv: support for Destroy fast UVC
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220810125625.45295-1-imbrenda@linux.ibm.com>
 <20220810125625.45295-6-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220810125625.45295-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yAUyPdwDaF1s1hhXOtpeYWJ7wTlKUt6J
X-Proofpoint-GUID: 9OUB_yrq1vsp62Gj396qVQ5MNLh4KLDg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 phishscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208190037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/22 14:56, Claudio Imbrenda wrote:
> Add support for the Destroy Secure Configuration Fast Ultravisor call,
> and take advantage of it for asynchronous destroy.
> 
> When supported, the protected guest is destroyed immediately using the
> new UVC, leaving only the memory to be cleaned up asynchronously.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/include/asm/uv.h | 10 +++++++
>   arch/s390/kvm/pv.c         | 57 ++++++++++++++++++++++++++++++++------
>   2 files changed, 59 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index be3ef9dd6972..28a9ad57b6f1 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -34,6 +34,7 @@
>   #define UVC_CMD_INIT_UV			0x000f
>   #define UVC_CMD_CREATE_SEC_CONF		0x0100
>   #define UVC_CMD_DESTROY_SEC_CONF	0x0101
> +#define UVC_CMD_DESTROY_SEC_CONF_FAST	0x0102
>   #define UVC_CMD_CREATE_SEC_CPU		0x0120
>   #define UVC_CMD_DESTROY_SEC_CPU		0x0121
>   #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
> @@ -81,6 +82,7 @@ enum uv_cmds_inst {
>   	BIT_UVC_CMD_UNSHARE_ALL = 20,
>   	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
>   	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
> +	BIT_UVC_CMD_DESTROY_SEC_CONF_FAST = 23,
>   	BIT_UVC_CMD_DUMP_INIT = 24,
>   	BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE = 25,
>   	BIT_UVC_CMD_DUMP_CPU = 26,
> @@ -230,6 +232,14 @@ struct uv_cb_nodata {
>   	u64 reserved20[4];
>   } __packed __aligned(8);
>   
> +/* Destroy Configuration Fast */
> +struct uv_cb_destroy_fast {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 handle;
> +	u64 reserved20[5];
> +} __packed __aligned(8);
