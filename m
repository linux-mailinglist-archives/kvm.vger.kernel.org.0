Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC747590FEC
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 13:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiHLLQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 07:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiHLLQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 07:16:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D384A50FB;
        Fri, 12 Aug 2022 04:16:47 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27CArisv018382;
        Fri, 12 Aug 2022 11:16:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=5QLe7XsVszBeVs5J6MXg8/zOQklAaXJqwBu6m8+EPFk=;
 b=m1t1RHsLKS1U0tzpUKKrPcPIv5eUsuwCgtvE01FeLYdWoUnigvCrZ95l1uipYJA8txFX
 lqcivnIqJTcF42kbarTKav/6pM6WCnVwKeHUI3C5qOP4VBWA+vD4kSApPzk12jT3NA5f
 /lK8/oExNN6AXXvv64pM1lfFr88uEVPDCT3v2wLGsw4opxn8xi/bIN02DLHl4kPQkbTs
 FC6hCTDX7hfbm116JKHPBI0smiee9QyxDMwqTpVYQVQfGDnq2mRIgZZQ/rJvlpp227MB
 7Rqeh1VXWpptqL2Vo8EmsatiKISzyYfsuWQ/Kc/ewr+kqOI6WwbNq0I6y//opdxZhX/J kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwngu8sju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 11:16:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27CBGksS001688;
        Fri, 12 Aug 2022 11:16:46 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwngu8shs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 11:16:46 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27CB5xav015877;
        Fri, 12 Aug 2022 11:16:44 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3hw3wfrxyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 11:16:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27CBE69p32375182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 11:14:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5F8AA404D;
        Fri, 12 Aug 2022 11:16:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0ADAA4040;
        Fri, 12 Aug 2022 11:16:40 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.40.207])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Aug 2022 11:16:40 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220810125625.45295-2-imbrenda@linux.ibm.com>
References: <20220810125625.45295-1-imbrenda@linux.ibm.com> <20220810125625.45295-2-imbrenda@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [PATCH v13 1/6] KVM: s390: pv: asynchronous destroy for reboot
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com
Message-ID: <166030300049.24812.17231340197534047162@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Fri, 12 Aug 2022 13:16:40 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rtPeEonOs5gBBTQGmNXIiu2xORD5dxwj
X-Proofpoint-ORIG-GUID: cPlaEBOdANyFsEvNfGL-KOdgAgnQ8Vbj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_08,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208120031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-08-10 14:56:20)
> Until now, destroying a protected guest was an entirely synchronous
> operation that could potentially take a very long time, depending on
> the size of the guest, due to the time needed to clean up the address
> space from protected pages.
>=20
> This patch implements an asynchronous destroy mechanism, that allows a
> protected guest to reboot significantly faster than previously.
>=20
> This is achieved by clearing the pages of the old guest in background.
> In case of reboot, the new guest will be able to run in the same
> address space almost immediately.
>=20
> The old protected guest is then only destroyed when all of its memory has
> been destroyed or otherwise made non protected.
>=20
> Two new PV commands are added for the KVM_S390_PV_COMMAND ioctl:
>=20
> KVM_PV_ASYNC_CLEANUP_PREPARE: prepares the current protected VM for
> asynchronous teardown.=20

I would add:

A protected VM which has been prepared for asynchronous teardown is called =
a *set aside VM*. A set a side VM never has any CPUs associated with it, bu=
t is still registered with the Ultravisor and may have memory.

> The current VM will then continue immediately
> as non-protected. If a protected VM had already been set aside without
> starting the teardown process, this call will fail. There can be at
> most one prepared VM at any time.
>=20
> KVM_PV_ASYNC_CLEANUP_PERFORM: tears down the protected VM previously
> set aside for asynchronous teardown. This PV command should ideally be
> issued by userspace from a separate thread. If a fatal signal is
> received (or the process terminates naturally), the command will
> terminate immediately without completing.=20

I would add:

A set aside VM where cleanup started but was interrupted is called a *lefto=
ver VM*. There can be multiple leftovers per VM, which are tracked in the n=
eed_cleanup list.

I would like a more consistent language. We have three different names for =
the leftover in the patch below:
- leftover,
- the struct describing a leftover is called pv_vm_to_be_destroyed,
- the list of leftover vms is called need_cleanup.

It would be nice if this were a little more consistent, e.g. by renaming pv=
_vm_to_be_destroyed to pvm_vm_leftover and maybe need_cleanup to leftovers.

Otherwise, this looks good. I would be glad if you pick up my naming sugges=
tions, but feel free to add:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
