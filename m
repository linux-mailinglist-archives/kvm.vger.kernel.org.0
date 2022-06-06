Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B92253ED36
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiFFRvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 13:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiFFRvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 13:51:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDABA0D13;
        Mon,  6 Jun 2022 10:51:05 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256GAfCm008425;
        Mon, 6 Jun 2022 17:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=ZoxujMhshSDi4Aq2l7teX+bW6zGck4zo3WJkXOK+auY=;
 b=MpXjc2psJtkGdHMi/YkXSZvEo3+FHEjL38mOgxrOvxzo8cG986ZZrVQiks1ezowva1CW
 2HXhwZMChuMfhfDCNBUGmovQI4voKmq0AayF612S0n+NlqjBd6jhKu6pVcfosqVWSTDf
 B1GiPobKYXmJth89lenkx24+CMZQT8C93xba/NDcfH2TDlC/Bj2XjKGWaHw4+i16BKLL
 HDRNNxR/9nY4kiq/vvTaKCzI2RjntdZarD9kDueFr1Q+xtLmbuHkAj+CK5ri0GGcoDVR
 d+zO9kHfvt3sEBIwAg5ADOHkAKYadpPWQPmF+dDCFjQbkZODX2RZb/3aIqhd5qTSyR/+ Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ggh6sntcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 17:51:01 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256HEP9L002567;
        Mon, 6 Jun 2022 17:51:00 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ggh6sntby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 17:51:00 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256HoKWA007774;
        Mon, 6 Jun 2022 17:50:59 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 3gfy19f1wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 17:50:59 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256Howbb16843158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 17:50:58 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE799124054;
        Mon,  6 Jun 2022 17:50:58 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C376124052;
        Mon,  6 Jun 2022 17:50:58 +0000 (GMT)
Received: from [9.60.75.219] (unknown [9.60.75.219])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 17:50:58 +0000 (GMT)
Message-ID: <a04005af-8f5b-80f9-cf80-80aeb0814d57@linux.ibm.com>
Date:   Mon, 6 Jun 2022 13:50:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v19 17/20] s390/vfio-ap: handle config changed and scan
 complete notification
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-18-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220404221039.1272245-18-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jH1odn8p6mVC1WcrgZzh_9DkP3NWyLUY
X-Proofpoint-ORIG-GUID: k076Vk9vUDdYvdeMxyTX4RJfi_Eq_1KH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_05,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206060074
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/22 18:10, Tony Krowiak wrote:
> This patch implements two new AP driver callbacks:
> 
> void (*on_config_changed)(struct ap_config_info *new_config_info,
>                    struct ap_config_info *old_config_info);
> 
> void (*on_scan_complete)(struct ap_config_info *new_config_info,
>                   struct ap_config_info *old_config_info);
> 
> The on_config_changed callback is invoked at the start of the AP bus scan
> function when it determines that the host AP configuration information
> has changed since the previous scan.
> 
> The vfio_ap device driver registers a callback function for this callback
> that performs the following operations:
> 
> 1. Unplugs the adapters, domains and control domains removed from the
> host's AP configuration from the guests to which they are
> assigned in a single operation.
> 
> 2. Stores bitmaps identifying the adapters, domains and control domains
> added to the host's AP configuration with the structure representing
> the mediated device. When the vfio_ap device driver's probe callback is
> subsequently invoked, the probe function will recognize that the
> queue is being probed due to a change in the host's AP configuration
> and the plugging of the queue into the guest will be bypassed.
> 
> The on_scan_complete callback is invoked after the ap bus scan is
> completed if the host AP configuration data has changed. The vfio_ap
> device driver registers a callback function for this callback that hot
> plugs each queue and control domain added to the AP configuration for each
> guest using them in a single hot plug operation.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_drv.c     |   2 +
>   drivers/s390/crypto/vfio_ap_ops.c     | 270 +++++++++++++++++++++++++-
>   drivers/s390/crypto/vfio_ap_private.h |  12 ++
>   3 files changed, 279 insertions(+), 5 deletions(-)
> 
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
