Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DEB57A07B
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238335AbiGSOG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbiGSOGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:06:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFBA5404C;
        Tue, 19 Jul 2022 06:20:53 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JDCISV017833;
        Tue, 19 Jul 2022 13:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : to : from : message-id : date; s=pp1;
 bh=FQ0FB6ht6L08CH+OcHRoBbO7yoXPwLQdE28vOVHq/zY=;
 b=cy20ZYacdAoqe7zSQs4g9qTp/EnCRu5PP69dNqBxJHmpiJb/OGvtfxtnkSYapWPBegZL
 9qbE1tloHYqQuyLirSvu8gC+9j7zzUzGZ3R8BNndUr9bKB8aLTWe6KDhf/Aff9ZeqFZg
 6T8GqPZEbGUuJsfAZ8/j9v0qFvwsFvoSVNuOtLYgMYn+J6XQyxk2/w7O0tjw1ZW2JuG1
 kQB+CP4iTh5KCwTTcNCVAoucc8oMDuAV2twBGC4kvuwHhtBiYjQsD2MjbJs6HPRfVmHZ
 Bn9JD1t4B099PGbTnNKLsvSjlvheXCOQJxyE3bMrEZeyrO7mJ2yBQ2VEsylTaJKq3/5F dA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdw9p0kya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 13:20:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26JDKo31022995;
        Tue, 19 Jul 2022 13:20:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8v535-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 13:20:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26JDKxkX30998940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 13:20:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6DE742041;
        Tue, 19 Jul 2022 13:20:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BA0F4203F;
        Tue, 19 Jul 2022 13:20:47 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.10.188])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jul 2022 13:20:47 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <16b8d198-9f5b-7124-e9bc-69209a0b49ac@linux.ibm.com>
References: <20220718130434.73302-1-nrb@linux.ibm.com> <16b8d198-9f5b-7124-e9bc-69209a0b49ac@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1] s390/kvm: pv: don't present the ecall interrupt twice
To:     Janosch Frank <frankja@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <165823684731.15145.2382851660157537343@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 19 Jul 2022 15:20:47 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zXqba6OGN0c575E2WY_CHJz-ydRjttw7
X-Proofpoint-ORIG-GUID: zXqba6OGN0c575E2WY_CHJz-ydRjttw7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_02,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxlogscore=496 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-07-19 15:07:43)
> On 7/18/22 15:04, Nico Boehr wrote:
> > When the SIGP interpretation facility is present and a VCPU sends an
> > ecall to another VCPU in enabled wait, the sending VCPU receives a 56
> > intercept (partial execution), so KVM can wake up the receiving CPU.
> > Note that the SIGP interpretation facility will take care of the
> > interrupt delivery and KVM's only job is to wake the receiving VCPU.
>=20
> @Nico: Can we fixup the patch subject when picking?
> The prefix normally starts with KVM: arch: Subject starts here
>=20
> kvm: s390: pv: don't present the ecall interrupt twice

Oh sorry for messing that up.

Sure please go ahead and fixup. Thanks.
