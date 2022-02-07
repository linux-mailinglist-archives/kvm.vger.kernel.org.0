Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0BF4ABF94
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 14:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243859AbiBGN0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 08:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353403AbiBGNFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 08:05:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7D8C0401D2;
        Mon,  7 Feb 2022 05:05:04 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217BaCje024832;
        Mon, 7 Feb 2022 13:05:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9reA5PYbVXOY4Il5UEVRVO7g9nR9yFNlpSR7fCxMI7U=;
 b=c7fc1zI8s5tgeRjQ+Bs+S+Ljfm81Ugmc7cOspG4a9lysRqflAbYKIXj7tdKrQ/zMPnXe
 tGelKktw0wevQo43+T2T0+FrQe1z4ZJWDdjYSLCvQM89Qwq5tJsuPeZ6KPgf6GxHJEkk
 tRMKEt34xc4r9N5HdEaONmduwt+ia98q/h0XmfwG2LaHKJhpac7K4sf7KtmMluNtKLmu
 wwv9oKAEdHQ84sTXrR+p+E7VSKnh1GE2+srgTCqLKqZMolPh0FcGvjgh0RpOrwlnx1Vx
 fUnP/6w7QzBVUdZ+QDR/FVwwTFoqytNKGpWxD7nbsXo30QmWTCvntlMkXoLYTe4QRKPg ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22tqkxgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 13:05:03 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217D0Hkl012466;
        Mon, 7 Feb 2022 13:05:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22tqkxfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 13:05:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217CwHxL012846;
        Mon, 7 Feb 2022 13:05:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gv8vkbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 13:05:00 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217D4u7s30867896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 13:04:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81EC1A4070;
        Mon,  7 Feb 2022 13:04:56 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94252A406D;
        Mon,  7 Feb 2022 13:04:55 +0000 (GMT)
Received: from [9.171.90.80] (unknown [9.171.90.80])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 13:04:55 +0000 (GMT)
Message-ID: <9a186055-2637-0113-18be-ab08b5db1c74@linux.ibm.com>
Date:   Mon, 7 Feb 2022 14:04:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 30/30] MAINTAINERS: additional files related kvm s390
 pci passthrough
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-31-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220204211536.321475-31-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: URjhQ3veZQwwF_Mw6-Jw4d08Ttlhjew-
X-Proofpoint-GUID: BdCsKKWGCe2pWYq6U14wyGqQzTRWGCp9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 04.02.22 um 22:15 schrieb Matthew Rosato:
> Add entries from the s390 kvm subdirectory related to pci passthrough.
> 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>


Can you change that to  borntraeger@linux.ibm.com ?



> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   MAINTAINERS | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bb83dcbcb619..2762295ad85e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16900,6 +16900,8 @@ M:	Eric Farman <farman@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   L:	kvm@vger.kernel.org
>   S:	Supported
> +F:	arch/s390/include/asm/kvm_pci.h
> +F:	arch/s390/kvm/pci*
>   F:	drivers/vfio/pci/vfio_pci_zdev.c
>   F:	include/uapi/linux/vfio_zdev.h
>   
