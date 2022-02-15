Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7404B6AE1
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 12:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbiBOLbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 06:31:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiBOLbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 06:31:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991E4108771
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 03:31:12 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FAfkg9034440
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:31:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eFesICNuIeUiqTlCzorgSgJpwynUdztDpPaJRZ6WQfQ=;
 b=Ycfqe7lZN+JI7BFifa3An29+9pnJ+N/AvR73ejmV2s57zI0mZ0P3AbwzmaY83VOejiMh
 id5fZRvoptM7NoareP3dvxF1jcyHnnyYx5gvjMhSYK3xE+GlII4/Ks1JAXcPnNkpqPGA
 3OBd/i5PKFJg6usSU5AQVUPOL4ZBYzao8NrFu47Rybcdz8SQuprE8gmn+UscCPAasdVI
 GFAimBqUp8gGxIppyOkUQOhUqxxNVjUvF4iJ0RTpRWEWhyOwVMi/10UmjfV4dg+RXd4S
 R/C4ktCBGkd7cmGkqEABoG7O+nL54nYN48aMuJnW9fZuzRjmhvG0KUwIlgo8tIV8PDQY lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8an6176g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:31:12 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FBGrrC006833
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:31:11 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8an6175m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:31:11 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FBC4m5032752;
        Tue, 15 Feb 2022 11:31:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3e64h9n9c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:31:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FBV6RP39059948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 11:31:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1157A11C04C;
        Tue, 15 Feb 2022 11:31:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA8AB11C04A;
        Tue, 15 Feb 2022 11:31:05 +0000 (GMT)
Received: from [9.145.18.32] (unknown [9.145.18.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 11:31:05 +0000 (GMT)
Message-ID: <30d689f7-4929-d299-2b2b-a52d363f6be3@linux.ibm.com>
Date:   Tue, 15 Feb 2022 12:31:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v2 6/6] s390x: uv-host: use CPU indexes
 instead of addresses
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
 <20220204130855.39520-7-imbrenda@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220204130855.39520-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yyHdLhE0e1GEqyWKSjIqCbWNkTJeXf94
X-Proofpoint-GUID: 59VH1jwn0Kyltu_qhNYw03fx5DllsDQh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 clxscore=1015
 spamscore=0 malwarescore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202150065
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
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
