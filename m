Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C237A574884
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbiGNJVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238038AbiGNJVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:21:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02B649B5E;
        Thu, 14 Jul 2022 02:18:10 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E8hpe5029356;
        Thu, 14 Jul 2022 09:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gI0a5YaPzOpPO5DZWLSefm5OJ7tCBCUWW+WE1+JFczQ=;
 b=HGISxD3u7Bm2tH0aIc4Svm0yA7AgFyMNP8QFdvcihOZAlSRgFNNGxPy7QjiPz5pDo+zW
 ZhcgoOMudctOzViJ8YWsDAnkF7b4svvPscZRpcQePRCJ8J2BayIdGSrM+OmpLqEimdfW
 bvcqtzKQ25zXE8i2CG+k5SZjs99CKWNqtSO+YXF1VM7+bNj9xamv1+SD14qp2IAl1ynq
 Dxi58vFfhqKtIAFNE1msVLVNjptB6QNExvwEf8f5DLTOTQO4uCKS4bWOLQPuijJGFXM6
 8akOe56Mz/Pu07C8+TBWNvxGq/YjPKn8WeYJRJ12+Qd+CXjejojUB81tnhVzrdv3OSp3 dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hafvw0rne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 09:17:29 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26E8oPA0029981;
        Thu, 14 Jul 2022 09:17:29 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hafvw0rmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 09:17:28 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26E9CTto008519;
        Thu, 14 Jul 2022 09:17:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3h8ncnh73b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 09:17:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26E9FooM15728918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 09:15:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73E174C04E;
        Thu, 14 Jul 2022 09:17:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED3214C046;
        Thu, 14 Jul 2022 09:17:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.75])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 09:17:22 +0000 (GMT)
Date:   Thu, 14 Jul 2022 11:17:21 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v12 00/18] KVM: s390: pv: implement lazy destroy for
 reboot
Message-ID: <20220714111721.3317b758@p-imbrenda>
In-Reply-To: <abed8069-220a-ee32-b4fa-3cff935b539c@linux.ibm.com>
References: <20220628135619.32410-1-imbrenda@linux.ibm.com>
        <abed8069-220a-ee32-b4fa-3cff935b539c@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pxE9ggv-D-KPXyxrZw8Bphp5muHy1E7R
X-Proofpoint-GUID: -wuMVti054uZf9m_GqmcsghxmOFJMhHD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_06,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=997
 priorityscore=1501 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jul 2022 08:59:00 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/28/22 15:56, Claudio Imbrenda wrote:
> > Previously, when a protected VM was rebooted or when it was shut down,
> > its memory was made unprotected, and then the protected VM itself was
> > destroyed. Looping over the whole address space can take some time,
> > considering the overhead of the various Ultravisor Calls (UVCs). This
> > means that a reboot or a shutdown would take a potentially long amount
> > of time, depending on the amount of used memory.
> > 
> > This patchseries implements a deferred destroy mechanism for protected
> > guests. When a protected guest is destroyed, its memory can be cleared
> > in background, allowing the guest to restart or terminate significantly
> > faster than before.
> >   
> 
> Patches 1-12 have spent a considerable amount of time in the CI and I'd 
> like to queue them to be able to focus on the rest of the series.
> 
> Patch 9 will need two small fixups since there are two conflicts where a 
> line was introduced before your addition of the include and the struct 
> kvm_s390_pv mmu_notifier member. I.e. it's more of a patch history 
> problem than a real conflict.
> 
> I'd fix that up when queuing if you're ok with it?

ok for me
