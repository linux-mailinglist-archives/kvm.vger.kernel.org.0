Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C448B30ADB2
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhBARYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:24:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4982 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229612AbhBARYk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 12:24:40 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 111HG8FL148172;
        Mon, 1 Feb 2021 12:23:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5h6L+W9OKzWFhKXfgMXfJnyDMNx2bJEz/rcoPDTozZU=;
 b=gpPncXGzG6Yc9TluGbmqcK1Gr5KD861UwW+6gn6ZMSW3/VJxsM2bwdwEx+1YWCwORJ6s
 VOBHwgTGUMavi/TJrg0CwMFlwfzB3j6/tCJFCuigeFgcd7Tb+M93FKWF9sYBJFwfiZsg
 +RY/eIcSGwcY0uZzEb5IOoo9OlIQnfBpWgNibEqLX+UakzK5cF/H5uxsEKWIuwjqb0Re
 jmKZ/GtQzX+5GKoTf4wEj/aUvcK5ALPC4Bow6qWCEOoRdf+P9c20d3UZ2aqNMENGEb8v
 HZ8/jAyt840b+N4kqhvGHQsBeKQl1N230XWqhCHBL4vSCq8pQ/61SvyPQG1ea6zH1PNL eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36enw3r5hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 12:23:54 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 111HGoCC150138;
        Mon, 1 Feb 2021 12:23:53 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36enw3r5es-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 12:23:53 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 111GjiBd007782;
        Mon, 1 Feb 2021 17:08:52 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 36cy39049c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 17:08:52 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111H8pKi23462320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 17:08:51 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCABD112067;
        Mon,  1 Feb 2021 17:08:51 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1617A112062;
        Mon,  1 Feb 2021 17:08:47 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.84.157])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  1 Feb 2021 17:08:46 +0000 (GMT)
Subject: Re: [PATCH 6/9] vfio-pci/zdev: fix possible segmentation fault issue
To:     Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, gmataev@nvidia.com,
        cjia@nvidia.com, yishaih@nvidia.com, aik@ozlabs.ru
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-7-mgurtovoy@nvidia.com>
 <20210201175214.0dc3ba14.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <139adb14-f75a-25ef-06da-e87729c2ccf2@linux.ibm.com>
Date:   Mon, 1 Feb 2021 12:08:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201175214.0dc3ba14.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_06:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1011 mlxscore=0
 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/21 11:52 AM, Cornelia Huck wrote:
> On Mon, 1 Feb 2021 16:28:25 +0000
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> 
>> In case allocation fails, we must behave correctly and exit with error.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> Fixes: e6b817d4b821 ("vfio-pci/zdev: Add zPCI capabilities to VFIO_DEVICE_GET_INFO")
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 
> I think this should go in independently of this series. >

Agreed, makes sense to me -- thanks for finding.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

>> ---
>>   drivers/vfio/pci/vfio_pci_zdev.c | 4 ++++
>>   1 file changed, 4 insertions(+)
> 

