Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F895212F6
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 12:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240455AbiEJLC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 07:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240475AbiEJLCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 07:02:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92EF230201;
        Tue, 10 May 2022 03:58:21 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24A8ovKD002063;
        Tue, 10 May 2022 10:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Svvn9kdiwgi/wx/oDegVNwry4KcScA6NcYcUhnrao9s=;
 b=fqjPn4sLNM8PL0DK8srkS28wfa4OVRTDTJerSNDA4Vd1PxuuMb/oC+w8WWW+Qpa30sx2
 MVyW4pGecaK5KoU7ILDWgRnxZ36gGNRkuZ0tVKh7U48rHvTv0vay5vQUZx+b/wnNMfOh
 y41E/d19P+POcNMgq3WaC6zoFYMVET5PmlurDEeJ2jxR75XidUqOOja4fLN7M/gkmCQG
 9Z7ihCGEU/Ur6Lo5Ppkwkrz7UoWEsujwzZTEG+C2GAQ8wReFtxjKRsB7HpWZMos40rYc
 Kk/yAPqVnPRzfy2+JmCIcafuOR+y6aSJxO4tSNjEBxtCP/QpPwRFOSnQxqCLMix3QEXn DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fymwbje37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 10:58:21 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24AAfeYQ009561;
        Tue, 10 May 2022 10:58:20 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fymwbje2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 10:58:20 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24AAvbAu001006;
        Tue, 10 May 2022 10:58:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd8uxbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 10:58:18 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24AAwFEf9765160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 10:58:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55E1142047;
        Tue, 10 May 2022 10:58:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DB0142045;
        Tue, 10 May 2022 10:58:15 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.91.115])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 May 2022 10:58:14 +0000 (GMT)
Message-ID: <aaf93deff51ccac5d17d8a6d38c399745ecf30c1.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/2] s390x: add migration test for CMM
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Date:   Tue, 10 May 2022 12:58:14 +0200
In-Reply-To: <20220509160009.3d90cbe4@p-imbrenda>
References: <20220509120805.437660-1-nrb@linux.ibm.com>
         <20220509160009.3d90cbe4@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oycbTW7wK16bF0CE-zrKLLt2Dvx8Yc2s
X-Proofpoint-ORIG-GUID: nTvq_2BfD0I5jErV0tvtFX58dd0XNNLy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_01,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-09 at 16:00 +0200, Claudio Imbrenda wrote:
> I wonder if we are going to have more of these "split" tests.
> 
> is there a way to make sure migration prerequisites are always
> present?

We could not run _any_ tests if netcat is not installed, which seems
like a bad idea. 

> or rewrite things so that we don't need them?

We need ncat to communicate with the QEMU QMP over unix socket. I am
not aware of a way to use unix sockets in Bash, but no expert either.

We could ship our own version of netcat and build it for the host,
which adds additional complexity and maintenance burden. 

I honestly can't think of a good way.

Or we just put all cmm tests in a single file and accept the fact that
if you don't have all the migration related requirements installed, you
don't get all the tests - even some which are not at all related to
migration. I did not like that so I went with the extra file.
