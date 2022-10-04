Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151275F44A6
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 15:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJDNrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 09:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJDNrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 09:47:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEA829839;
        Tue,  4 Oct 2022 06:47:50 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294DhtCG006929;
        Tue, 4 Oct 2022 13:47:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ePrfINsD2jticLYvBd+XUliag6ETWRLkv4Uszmw0zK4=;
 b=P+1W4o/+fMqO7npu88a8MPDfL9J7uIOMDjl0l2VN869EWIu3OnEFS9GgO1+VhQ6GCfGs
 UbW9gJu8eGzfJTccjQ7c2RxzmVayc4oY82SEE04+sENIuFB1Imr6hP8uTlWWWZa5gvtE
 sZbSl82uan0aql8PeBJAflKV4++qPSUXzUBJSrLBdg6CE6tLe0af/h8eSN2zd7vSbAfu
 gpkNRYGcKxNJYxjbKdobYZLgs4O6U9/wqssEz9Xp8YulTRmd2L+v1utfUBG39emn4bX4
 tXvFOATxxdHO8NLZxMrLKAJs2VkmKVzY84iHwipuw18zErWuIhlwdYiCvW6N6nVZmSlW 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gw19shk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:47:50 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294DiQqL010590;
        Tue, 4 Oct 2022 13:47:49 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gw19sgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:47:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294De8Sv005948;
        Tue, 4 Oct 2022 13:47:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3jxd6948hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 13:47:47 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294DmDT651380626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 13:48:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4958EA405F;
        Tue,  4 Oct 2022 13:47:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB578A4054;
        Tue,  4 Oct 2022 13:47:43 +0000 (GMT)
Received: from [9.145.154.3] (unknown [9.145.154.3])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Oct 2022 13:47:43 +0000 (GMT)
Message-ID: <93dbe028-eb4b-7620-58c9-d1fb8e0431ca@linux.ibm.com>
Date:   Tue, 4 Oct 2022 15:47:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v14 4/6] KVM: s390: pv: avoid export before import if
 possible
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
 <20220930140150.37463-5-imbrenda@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20220930140150.37463-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MMCP-zgIEwDKNSxW8N0rPygT3alerQJ0
X-Proofpoint-GUID: Gz0wkrRTuqY3KmWdLOB0VSQa8n3uIekL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040088
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/30/22 16:01, Claudio Imbrenda wrote:
> If the appropriate UV feature bit is set, there is no need to perform
> an export before import.
> 
> The misc feature indicates, among other things, that importing a shared
> page from a different protected VM will automatically also transfer its
> ownership.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
LGTM
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

> ---
>   arch/s390/kernel/uv.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index f9810d2a267c..9f18a4af9c13 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -255,6 +255,13 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>    */
>   static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
>   {
> +	/*
> +	 * The misc feature indicates, among other things, that importing a
> +	 * shared page from a different protected VM will automatically also
> +	 * transfer its ownership.
> +	 */
> +	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications))
> +		return false;
>   	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
>   		return false;
>   	return atomic_read(&mm->context.protected_count) > 1;
