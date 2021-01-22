Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0FD300B0E
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 19:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbhAVSUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 13:20:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729127AbhAVPpL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 10:45:11 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10MFYFBr192656;
        Fri, 22 Jan 2021 10:44:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uHDL71WGgdBlbcsqnKXD2Mp6ASVlvnCaGX9WZ9+heCs=;
 b=cG99k5Sv+XNq1sB780o/2cPEkfurXeL3tvP2wPBZa1EBsqPtkJhEjCWwj0zvLsZ7TsNq
 sxVXyQbFZihA4PfNupYxG9xOOW7KfayRJTA5MAbebtrEVMjanz9SUOtGpQuDtM1nCZfm
 3+yZ9/MGx61kGHKvHs+tLzMplWXJi/eLhMQ5Iu9r9OudkSCFl2dPjX6PRzQ7PA/1G+AS
 Dy2gDaKA6eMnTAUQVyVe/rum7OFeO46zT2opGmz3GyfW6DvCfEVjo1/ZDN11xjQ0pK2t
 sfwL2m2dNBh9hCL6HM0F24hYf9cTgTvr4WsDaWGU7lEnYA872XisC9lF7fpGr79YxfLr yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3680v01k7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 10:44:30 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10MFYa31001187;
        Fri, 22 Jan 2021 10:44:29 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3680v01k69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 10:44:29 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10MFYCLl022581;
        Fri, 22 Jan 2021 15:44:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 367k12gq4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 15:44:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10MFiOVj45547782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 15:44:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F74911C052;
        Fri, 22 Jan 2021 15:44:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFA5711C050;
        Fri, 22 Jan 2021 15:44:23 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.82.252])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 15:44:23 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 1/3] s390x: pv: implement routine to
 share/unshare memory
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
 <1611322060-1972-2-git-send-email-pmorel@linux.ibm.com>
 <9c488fa9-9b65-ea7f-124e-f9468dc05a54@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <bf4e68f2-6134-e85c-8bd5-4966852f7481@linux.ibm.com>
Date:   Fri, 22 Jan 2021 16:44:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9c488fa9-9b65-ea7f-124e-f9468dc05a54@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_11:2021-01-22,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/22/21 2:33 PM, Janosch Frank wrote:
> On 1/22/21 2:27 PM, Pierre Morel wrote:
>> When communicating with the host we need to share part of
>> the memory.
>>
>> Let's implement the ultravisor calls for this.
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Thanks,
Pierre

...snip...

-- 
Pierre Morel
IBM Lab Boeblingen
