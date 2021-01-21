Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74462FE6B9
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 10:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbhAUJvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 04:51:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45322 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726514AbhAUJuj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 04:50:39 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L9heWi057385;
        Thu, 21 Jan 2021 04:49:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OPgAp1qHZF9jlrM+xaDU/KFtE5OhQKmgMfVZj+ppPj8=;
 b=mUDKsn02TPL6a6XJHyUIFUERcqnFYd2CqYovuapaiK3QnqJkSFByIRPd7DQOwfIgXw/G
 48SO9lH3nyl8djwkmtdQEmGKt3fNhIvf+rJq09ZKfAlimycCKJaAwDuNbuL2UNF0kbZI
 7OB+QXerFg4lsTSYa2ZcGVUjIkv9kR1wOT0D1YVeUiKjFkNqAE4HewH9dFnsTOLVGRnK
 2UVaUxuQyxxAcooZJEFCk5LIEYI9OW6ctrZo1m3TsFpeBwGHbUpnivpUT/Z2O3d733I/
 V8t9aLItc+P5zIYWmY5c0mfBGgs0AGRffDd8EPgGPj7epXfcMAyQxT3qM7k4X8MMw6lu +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36777sg5mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:49:46 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10L9hliG057591;
        Thu, 21 Jan 2021 04:49:45 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36777sg5jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:49:45 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L9buCQ000960;
        Thu, 21 Jan 2021 09:49:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3668p4gsdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 09:49:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L9nbMB26083830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 09:49:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D51F811C058;
        Thu, 21 Jan 2021 09:49:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5102811C054;
        Thu, 21 Jan 2021 09:49:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.35])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 09:49:37 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 1/3] s390x: pv: implement routine to
 share/unshare memory
From:   Janosch Frank <frankja@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-2-git-send-email-pmorel@linux.ibm.com>
 <a4ad5c0f-2e77-4ea9-9efd-f4d000f17b72@linux.ibm.com>
Message-ID: <bd581ff6-3db8-424f-28f3-4eab736f415d@linux.ibm.com>
Date:   Thu, 21 Jan 2021 10:49:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a4ad5c0f-2e77-4ea9-9efd-f4d000f17b72@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_04:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/21 10:20 AM, Janosch Frank wrote:
> On 1/21/21 10:13 AM, Pierre Morel wrote:
>> When communicating with the host we need to share part of
>> the memory.
>>
>> Let's implement the ultravisor calls for this.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Suggested-by: Janosch Frank <frankja@linux.ibm.com>
>> Acked-by: Cornelia Huck <cohuck@redhat.com>
>> Acked-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  lib/s390x/asm/uv.h | 38 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 38 insertions(+)
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index 4c2fc48..8400026 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -71,4 +71,42 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>>  	return cc;
>>  }
>>  
>> +static inline int share(unsigned long addr, u16 cmd)
>> +{
>> +	struct uv_cb_share uvcb = {
>> +		.header.cmd = cmd,
>> +		.header.len = sizeof(uvcb),
>> +		.paddr = addr
>> +	};
>> +	int cc;
>> +
>> +	cc = uv_call(0, (u64)&uvcb);
>> +	if (!cc && uvcb.header.rc == 0x0001)
> 
> s/0x0001/UVC_RC_EXECUTED/
> 
> 
>> +		return 0;
>> +
>> +	report_info("cc %d response code: %04x", cc, uvcb.header.rc);
> 
> Will the print have the string UV in it or will I need to guess that a
> UV call failed?
> 
> I'm wondering if an assert would make more sense, if callers are
> interested in the uv rc they will need to write an own share function
> anyway.

Ok, I'll take that back. In the following patches you return NULL if the
share for an allocation fails and you check for NULL after every
allocation so this is fine by me.

> 
>> +	return -1;
>> +}
>> +
>> +/*
>> + * Guest 2 request to the Ultravisor to make a page shared with the
>> + * hypervisor for IO.
>> + *
>> + * @addr: Real or absolute address of the page to be shared
>> + */
>> +static inline int uv_set_shared(unsigned long addr)
>> +{
>> +	return share(addr, UVC_CMD_SET_SHARED_ACCESS);
>> +}
>> +
>> +/*
>> + * Guest 2 request to the Ultravisor to make a page unshared.
>> + *
>> + * @addr: Real or absolute address of the page to be unshared
>> + */
>> +static inline int uv_remove_shared(unsigned long addr)
>> +{
>> +	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
>> +}
>> +
>>  #endif
>>
> 

