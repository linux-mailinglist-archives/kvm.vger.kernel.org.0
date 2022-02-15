Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06C4B6AC7
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 12:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbiBOL1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 06:27:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbiBOL1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 06:27:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A691D10D5
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 03:27:02 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FBLt4n011906
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bDPqNH9q19JyMlO9LaoUuPwYULgV1AhWi/LjB1kYLZ4=;
 b=h6wJ5OGv4NwZu1mCXnSvQzFDlT/T77pX0cZXT9FfyB79Wfq7tblr2nx8OZlKD+EriRuW
 kp3l5FRItytvEXfgVlj8/SRo4efika0cTpOLODZROuOhzHrQl3Lj1LUfV+2DWFkQo3YK
 XdL0B65JzSo4Aqki15wxlMtAIr7t6dm4YadrmqZfAsY0dVgWoUcI/dp4JdQQmkJJZJ3x
 vl9otmiaqlD2BfE5XLJitk0epaG0Mcwp4eaD99PS7Oaf1RkOa75WVClWGbdyNX4HGYyk
 9nkuQGIvvLpSC+WsHq5x9pXCqa54afzdIB7DCthb6AbvSK8vI1u6AfaIuFsdDpbhCu06 kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8b83r34p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:27:02 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FBMOdO018841
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:27:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8b83r33t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:27:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FBCLm5028737;
        Tue, 15 Feb 2022 11:26:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3e64h9xfq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:26:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FBQuEh45351346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 11:26:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 384C811C04C;
        Tue, 15 Feb 2022 11:26:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E32E811C052;
        Tue, 15 Feb 2022 11:26:55 +0000 (GMT)
Received: from [9.145.18.32] (unknown [9.145.18.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 11:26:55 +0000 (GMT)
Message-ID: <41a6f895-c8bf-e82c-24c1-e69ca406a853@linux.ibm.com>
Date:   Tue, 15 Feb 2022 12:26:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v2 5/6] s390x: skrf: use CPU indexes
 instead of addresses
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
 <20220204130855.39520-6-imbrenda@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220204130855.39520-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JfEHP4Z33euQqc8EhTj-0PBoYGgwAtx6
X-Proofpoint-GUID: VTuNKByE6SIxOLFpHcEzVSnmMCWioFJ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/4/22 14:08, Claudio Imbrenda wrote:
> Adapt the test to the new semantics of the smp_* functions, and use CPU
> indexes instead of addresses.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
