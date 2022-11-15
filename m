Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C1A62936E
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 09:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbiKOImw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 03:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiKOImp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 03:42:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA5B140B3;
        Tue, 15 Nov 2022 00:42:44 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AF8e2b7016507;
        Tue, 15 Nov 2022 08:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AxfTlUSKDKgzTGxKC2vg1IAdhEC+Nz0PvMbt/LdbZqk=;
 b=SftsNggrF0YZjql4kYd2bF4bwn7iYTKmT+8EMAk8im2d9/oecCGGUtmxx/PeBhLRbMjk
 PfRc7qY/nSPY2l9Ct188ZCIls2x8269wAtRTttjJBBaleMCw1LwBumdlhe9KNMKjuE5I
 r4genSdaFeMm+/4wXBqQEV7SI72KyjqJB6zd1GglJbeG/yWpoOUof5zEqdEZ3yNFNNn6
 66eqHZdkbvI2gT4klLsYFNTF/E2TEguzgxgrc/fg8mBZo7/WpC11qRgwNptR2x8lKS7E
 Y3t/oHBT1npZmO90on+vGB5SEbUEVJUFvI4Wj+JqubTzWR4vKOKUe/gXK5Z677vbIokG pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kv7f881n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 08:42:43 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AF8eETK017447;
        Tue, 15 Nov 2022 08:42:43 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kv7f881mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 08:42:43 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AF8Zntn032489;
        Tue, 15 Nov 2022 08:42:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3kt3492xgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 08:42:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AF8gbx61704694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 08:42:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 949A9A405F;
        Tue, 15 Nov 2022 08:42:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26A09A405B;
        Tue, 15 Nov 2022 08:42:37 +0000 (GMT)
Received: from [9.171.74.64] (unknown [9.171.74.64])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Nov 2022 08:42:37 +0000 (GMT)
Message-ID: <d9d73722-f1f5-3ba9-e9f5-538ee4f4ba2e@linux.ibm.com>
Date:   Tue, 15 Nov 2022 09:42:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v16 0/6] KVM: s390: pv: implement lazy destroy for reboot
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20221111170632.77622-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221111170632.77622-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9naloPUGpkJo60TRCQomBLb-eJJdilWU
X-Proofpoint-ORIG-GUID: 3M_XFSOX-aPVB799sh7uUNtn4NcWO0jW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_04,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=816 impostorscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211150058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/22 18:06, Claudio Imbrenda wrote:
> Previously, when a protected VM was rebooted or when it was shut down,
> its memory was made unprotected, and then the protected VM itself was
> destroyed. Looping over the whole address space can take some time,
> considering the overhead of the various Ultravisor Calls (UVCs). This
> means that a reboot or a shutdown would take a potentially long amount
> of time, depending on the amount of used memory.
> 

Well, this was a journey :)

Thanks, picked
