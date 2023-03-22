Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881346C590F
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 22:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCVVx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 17:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCVVx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 17:53:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C6B158B2
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 14:53:25 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32MLF863019027;
        Wed, 22 Mar 2023 21:53:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=mlXAo7Mm6ssh6l7Vk/LFp56jv79Zxm9clSndeogY8oY=;
 b=i89t1XCD8YFPughcmS3eVvTEklPzOYfzxNeWz2+19mKNeyZttsHWvFochXV5BwDwIWwC
 hertpMjLUG1sl+qzP5Ae4WF2nMVZWCTcUuWzxK3j0HOKHsKms4zejbDrOwqIxTwEX+ii
 AMmJiztWyeQqr9QWy3KO45iJECtJBZiTU9uf/ful/0RP+z3s4vSIL5ubxAFcjurYEmp3
 0cfFOTNWVMnhyppNrN1mK0BFRVfCr8InxK1f8TY7np3YCa+yy9BXWQ6yveUIYlSZhxfr
 i9wOtqqzIPaAYRWDQFOnbIpwRhEOJEeuuRhxPv1yPOBGf3F4kMJe3ljXxCRSMgtQtat9 jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg9dt8qx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 21:53:14 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32MLrCUB022009;
        Wed, 22 Mar 2023 21:53:13 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg9dt8qx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 21:53:13 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32MLj0Zv031919;
        Wed, 22 Mar 2023 21:53:13 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3pd4x72gu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 21:53:13 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32MLrB5g21431036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 21:53:12 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAE3758057;
        Wed, 22 Mar 2023 21:53:11 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1CF458059;
        Wed, 22 Mar 2023 21:53:10 +0000 (GMT)
Received: from [172.20.3.246] (unknown [9.163.23.201])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Mar 2023 21:53:10 +0000 (GMT)
Message-ID: <4f07f72da5c73d317bb00e6b3c41f47090c5240b.camel@linux.ibm.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Dionna Amalie Glaze <dionnaglaze@google.com>
Cc:     linux-coco@lists.linux.dev, kvm@vger.kernel.org,
        amd-sev-snp@lists.suse.com
Date:   Wed, 22 Mar 2023 17:53:08 -0400
In-Reply-To: <ZBs/TX4eDuj5zc3+@work-vm>
References: <ZBl4592947wC7WKI@suse.de> <ZBnH600JIw1saZZ7@work-vm>
         <ZBnMZsWMJMkxOelX@suse.de> <ZBnhtEsMhuvwfY75@work-vm>
         <ZBn/ZbFwT9emf5zw@suse.de> <ZBoLVktt77F9paNV@work-vm>
         <ZBrIFnlPeCsP0x2g@suse.de>
         <444b0d8d-3a8c-8e6d-1df3-35f57046e58e@amazon.com>
         <ZBrZmbfWXVQLND/E@work-vm>
         <CAAH4kHbYc+Wx5W_S8XFch+z1B19U_Zm=hFQr1fj1rv1S8QOvxg@mail.gmail.com>
         <ZBs/TX4eDuj5zc3+@work-vm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mCMeKRRmqF4AlFxd1xNsaS1o-wq2B75X
X-Proofpoint-GUID: uymxaK8FyiJ2K8VPI79fXJOfykCCRjok
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_18,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=970 impostorscore=0 bulkscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303220154
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-03-22 at 17:47 +0000, Dr. David Alan Gilbert wrote:
[...]
> > I think this might need to jump back to the vTPM protocol thread
> > since this is about COCONUT, but I'm worried we're talking about
> > AMD-specific long-term formats when perhaps the trusted computing
> > group should be widening its scope to how a TPM should be
> > virtualized. I appreciate that we're attempting to solve the
> > problem in the short term, and certainly the SVSM will need
> > attestation capabilities, but the linking to the TPM is dicey
> > without that conversation with TCG, IMHO.
> 
> Some standardisation of the link between the vTPM and the underlying
> CoCo hardware would be great; there's at least 2 or 3 CoCo linked
> vTPMs already and I don't think they're sharing any idea of that.

Well, for SNP, it's easy: the VMPL0 labelled attestation report proves
the SVSM and other components including OVMF and vTPM code
implementation.  We insert a hash of the manufactured EK into the
report and that gives proof from the trusted SVSM of the EK belonging
to the vTPM (essentially binding the vTPM to the VM).  The same thing
would work for other CoCo VM environments.

If we do ephemeral vTPMs, the binding is one time and there's no
persistent state security issue, so the SVSM-vTPM attestation is all
you need to begin trusting the vTPM measurements.

> Whether it's TCG I'm not sure; It doesn't seem to me to make sense
> for them to specify the flow to bring the vTPM up or the details of
> the underlying CoCo's attestation; but standardising how the two
> processes are tied together might be possible.

I think the TCG is probably not going to touch that because how you
attest the code that will run as the SVSM and vTPM is very specific to
each CoCo implementation.  However, they all provide a user data like
field which allows you to add information from the to be verified as
trusted SVSM, so you can use it for the EK, which is pretty identical
to the above proposal.

James

