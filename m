Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB1F54E88E
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 19:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378046AbiFPRTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 13:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378248AbiFPRTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 13:19:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2F211A;
        Thu, 16 Jun 2022 10:19:04 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GFZQfM029334;
        Thu, 16 Jun 2022 17:19:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZNO4lFMGmmzZ3EQEFyOj6sVLxBmMKmiSSb0FHZe4oNc=;
 b=hyKKi3hcIZF+8suhTvaRGQeq0tbGudofJsrKn83EqD+On6+HG+HpBcKHFMSUAmeYf782
 JbyR25jK6ZwFxWhHpJ6Bp4ataNwNhaEukYFLngTM5cDuIsbW/5B8T7gcsP1jy1oFSXSa
 7sWmWk6UKBehyE2lOAyq95eVnM8zn4v8Q01ivNM0acSgkg88lVSrLqWilXT86pugWwGo
 8bi4rQAu8wHDLopBudYbDDg9puz5u1nfjtEytT3Q8eYlm7u8SE5JsX9iMDEG6LQ0Odfn
 hlzjYDNh6ZpP2YU5gsOvBkakb5oWfEMPJ4ZXnf6IsbP1UbQBZxd2GgnmQpfmaFh/5nbB uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqbn36cd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 17:19:01 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25GGpV3W007414;
        Thu, 16 Jun 2022 17:19:01 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqbn36cd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 17:19:01 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25GHGxnG032167;
        Thu, 16 Jun 2022 17:19:00 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03wdc.us.ibm.com with ESMTP id 3gmjp9u738-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 17:19:00 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25GHIxc911928004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 17:18:59 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E7E4136053;
        Thu, 16 Jun 2022 17:18:59 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4D5813604F;
        Thu, 16 Jun 2022 17:18:58 +0000 (GMT)
Received: from [9.211.56.136] (unknown [9.211.56.136])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jun 2022 17:18:58 +0000 (GMT)
Message-ID: <4e5d8991-ffd6-7a7d-a8a9-8c2a2211728e@linux.ibm.com>
Date:   Thu, 16 Jun 2022 13:18:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 07/10] vfio/ccw: Create an OPEN FSM Event
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220615203318.3830778-1-farman@linux.ibm.com>
 <20220615203318.3830778-8-farman@linux.ibm.com>
 <0816ab3a-8601-0462-6c2b-4ba7fa8a1e2b@linux.ibm.com>
 <a1fd40e16fd4feb88b3f538e02319267d6901475.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <a1fd40e16fd4feb88b3f538e02319267d6901475.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZkW6X7OhC_IMObENguTL_sJY4RTbuhcH
X-Proofpoint-ORIG-GUID: LEavwj4J2suRp5iQIf3-MhONwyeeKrj0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_14,2022-06-16_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 clxscore=1015 suspectscore=0 phishscore=0
 spamscore=0 impostorscore=0 mlxlogscore=944 lowpriorityscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160071
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>> As for the IDLE/CP_PROCESSING/CP_PENDING cases, going fsm_notoper
>> because this is unexpected probably makes sense, but the logging is
>> going to be really confusing (before this change, you know that you
>> called fsm_notoper because you got VFIO_CCW_EVENT_NOT_OPER -- now
>> you'll
>> see a log entry cut for NOT_OPER but won't be sure if it was for
>> EVENT_NOT_OPER or EVENT_OPEN).  Maybe you can look at 'event' inside
>> fsm_notoper and cut a slightly different trace entry when arriving
>> here
>> for EVENT_OPEN?
> 
> Yeah, good idea. Since we don't expect any of these in normal behavior,
> perhaps I'll trace both state and event, instead of trying to make
> conditionals out of everything.
> 

Sounds good to me

