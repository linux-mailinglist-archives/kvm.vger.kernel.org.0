Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B3A736E73
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjFTONt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 10:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbjFTONr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 10:13:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED691170F;
        Tue, 20 Jun 2023 07:13:35 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35KE9Fl5007801;
        Tue, 20 Jun 2023 14:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=I6bRu5z9WiXNx/MxkQe6IZqRVFBXuWEUggjvUljHrIM=;
 b=EnTpzgMvoNBQELyKqWqYPkzbOMgq4edEjjv5peK18oxUs8h+imPrHqLznQ+kCu3ss9+F
 9gLiz5Fp+F/baXPeFsfwqlo47fzYQidA6e647VNDGV0Mez8Qiv9vNeFCw00VPbF2FwBt
 5Vw0nqyDyXUcLHjQ2UuXSG0CZvScub9QTWbct72HZ9ZfQK8Z0DEZQ9vvMjxU6YXcVQqA
 cmNK4wmOdG5znH2r9B10Xe6PuTYgTI2PcfIV0TXl91i/KfNT5yTbsxyg4oWjnxEALPhi
 1uminvJOPC9eVpNpdmXrRZBfYc2CFuIltBVzfgB7TaBKBuLyZvRAi8jCvJ0v2Cy0P0Mj aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rbdd38epm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jun 2023 14:13:35 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35KEBY0M022704;
        Tue, 20 Jun 2023 14:13:34 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rbdd38enx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jun 2023 14:13:34 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35K6YJ0r025824;
        Tue, 20 Jun 2023 14:13:32 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3r94f59kmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jun 2023 14:13:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35KEDSfR19661562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jun 2023 14:13:28 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB8DF2004E;
        Tue, 20 Jun 2023 14:13:28 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 665112004F;
        Tue, 20 Jun 2023 14:13:28 +0000 (GMT)
Received: from [9.171.27.251] (unknown [9.171.27.251])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Jun 2023 14:13:28 +0000 (GMT)
Message-ID: <9d86e617-4e8f-da3d-0c79-e94df5f3f3a5@linux.ibm.com>
Date:   Tue, 20 Jun 2023 16:13:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests PATCH v5 5/8] lib: s390x: uv: Add pv host
 requirement check function
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
References: <20230619083329.22680-1-frankja@linux.ibm.com>
 <20230619083329.22680-6-frankja@linux.ibm.com>
In-Reply-To: <20230619083329.22680-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KOqK8wFc2slPqFEHA21y858u7zo7xeAh
X-Proofpoint-ORIG-GUID: vFcwh1ZVbMdVe_uVDZDPMRpA5tM7jCRz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-20_10,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 adultscore=0 phishscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306200127
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/23 10:33, Janosch Frank wrote:
> When running PV guests some of the UV memory needs to be allocated
> with > 31 bit addresses which means tests with PV guests will always
> need a lot more memory than other tests.
> Additionally facilities nr 158 and sclp.sief2 need to be available.
> 
> Let's add a function that checks for these requirements and prints a
> helpful skip message.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
[...]
> +bool uv_host_requirement_checks(void)
> +{
> +	if (!test_facility(158)) {
> +		report_skip("UV Call facility unavailable");
> +		return false;
> +	}
> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		return false;
> +	}
> +	if (get_ram_size() < SNIPPET_PV_MIN_MEM_SIZE) {
> +		report_skip("Not enough memory. This test needs about %ld MB of memory",
> +			    SNIPPET_PV_MIN_MEM_SIZE / 1024 / 1024);

I've just replaced the 1024 divisions with SZ_1M i nthe second series. 
Feel free to do that here when picking if I don't need to send a new 
version.
