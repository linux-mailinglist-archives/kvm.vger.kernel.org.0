Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1425FC31E
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 11:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJLJcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 05:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJLJcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 05:32:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25CF6DFA4;
        Wed, 12 Oct 2022 02:32:16 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29C8fptX008075;
        Wed, 12 Oct 2022 09:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rZSXgZuBbs+bLzzkjTvXCrJ5CUl17Nvp3jhT3hccX6c=;
 b=nBSM8wu9zKg2KZ2FsdVwOAiRmtOt9b9O93A2NTPIxCWlfDYZ2v5Kk6a2cwEud7fpVe8o
 PTSTV9EliRgPQSD2iLhDRCcMMgvyr9YJRX4H/mMugFUg0SNtdoX5hd1DmHF7+LJV2h/j
 1alkEjIjXBgI86wVNYo60FAmypvm7gsouJHSJMwKbI+8azoP0kSB1E7tLl1MKzrR3AYY
 lBQQBJ9xv4Ca/n+VwXBqvj57F4CjI9FzQ6hk/pLGWqUaETwwJai4r5GwKlNr5vTCoxvu
 SdSEj6Gp78M5DuSaSKbWdlx9Wx5kfmZb8o5ffR8nrveziIGv90YId74ZBrxYiAhWTUoN JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5ta09d5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 09:32:16 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29C9420l024779;
        Wed, 12 Oct 2022 09:32:16 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5ta09d4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 09:32:15 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29C9K5pd031624;
        Wed, 12 Oct 2022 09:32:13 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3k30u9cau8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 09:32:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29C9WAL059244878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 09:32:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36F11A4051;
        Wed, 12 Oct 2022 09:32:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D859FA404D;
        Wed, 12 Oct 2022 09:32:09 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 09:32:09 +0000 (GMT)
Message-ID: <a29e8e63-3cbc-30cc-e0db-8e2bb8616ecb@linux.ibm.com>
Date:   Wed, 12 Oct 2022 11:32:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v15 1/6] KVM: s390: pv: asynchronous destroy for reboot
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com
References: <20221010145442.85867-1-imbrenda@linux.ibm.com>
 <20221010145442.85867-2-imbrenda@linux.ibm.com>
Content-Language: en-US
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20221010145442.85867-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OYBjoMb2oUXI4dhastfz94TeK1CKS7DA
X-Proofpoint-ORIG-GUID: hjFMmBOTloprzUoaqYvwfjpGK1c6-sjH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_04,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210120062
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/10/22 16:54, Claudio Imbrenda wrote:
> Until now, destroying a protected guest was an entirely synchronous
> operation that could potentially take a very long time, depending on
> the size of the guest, due to the time needed to clean up the address
> space from protected pages.
> 
> This patch implements an asynchronous destroy mechanism, that allows a
> protected guest to reboot significantly faster than previously.
> 
> This is achieved by clearing the pages of the old guest in background.
> In case of reboot, the new guest will be able to run in the same
> address space almost immediately.
> 
> The old protected guest is then only destroyed when all of its memory
> has been destroyed or otherwise made non protected.
> 
> Two new PV commands are added for the KVM_S390_PV_COMMAND ioctl:
> 
> KVM_PV_ASYNC_CLEANUP_PREPARE: set aside the current protected VM for
> later asynchronous teardown. The current KVM VM will then continue
> immediately as non-protected. If a protected VM had already been
> set aside for asynchronous teardown, but without starting the teardown
> process, this call will fail. There can be at most one VM set aside at
> any time. Once it is set aside, the protected VM only exists in the
> context of the Ultravisor, it is not associated with the KVM VM
> anymore. Its protected CPUs have already been destroyed, but not its
> memory. This command can be issued again immediately after starting
> KVM_PV_ASYNC_CLEANUP_PERFORM, without having to wait for completion.
> 
> KVM_PV_ASYNC_CLEANUP_PERFORM: tears down the protected VM previously
> set aside using KVM_PV_ASYNC_CLEANUP_PREPARE. Ideally the
> KVM_PV_ASYNC_CLEANUP_PERFORM PV command should be issued by userspace
> from a separate thread. If a fatal signal is received (or if the
> process terminates naturally), the command will terminate immediately
> without completing. All protected VMs whose teardown was interrupted
> will be put in the need_cleanup list. The rest of the normal KVM
> teardown process will take care of properly cleaning up all remaining
> protected VMs, including the ones on the need_cleanup list.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

[snip]
