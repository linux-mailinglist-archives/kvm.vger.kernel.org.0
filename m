Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69B0358F0C
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 23:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhDHVQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 17:16:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57064 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232452AbhDHVQC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 17:16:02 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 138L4o3B122175;
        Thu, 8 Apr 2021 17:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=+gJwJsERlCfn8dNrTP1UdF6lCsxN+kYYz1wqELB5RuU=;
 b=Qoxz/OgzE0LARYDbGnb1GkZZpU1hpMfo0jgL2bxojnbDF1ZgvVmNB1t4sjvj189Swjii
 37V+yWA7cKs/zxV1vjvGv5z587t0aujd0lVAtlW6kcDmdWxYkGNzScb2KoR43jx3lT9y
 PJ1SlBJX3xZIy8R6e3/KCZhMuUXr+On9yk6KOyRgo4CkTxsHLq6G6pbQO9xCTw4giG2n
 9N8QXSmbL1dBCpSJS+YJEY3rPg3o5kM0bboigsmKEwIRyJWzjVNpCXcimZ6/9gnKNUwk
 Y8aQwb2Wkw47rwbHVWtyhB/xYQJg3FaKW/wUMVxH0V9WpIXwGNL8VyoEcdhuZfpz5aJo Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37t8rphek5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 17:15:48 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 138L5VdN131883;
        Thu, 8 Apr 2021 17:15:48 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37t8rphejh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 17:15:47 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 138LBib2007876;
        Thu, 8 Apr 2021 21:15:46 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 37rvc4br4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 21:15:46 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 138LFjNc31719804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Apr 2021 21:15:45 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67DEB7805E;
        Thu,  8 Apr 2021 21:15:45 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E61DE7805C;
        Thu,  8 Apr 2021 21:15:42 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.189.52])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  8 Apr 2021 21:15:42 +0000 (GMT)
Message-ID: <fc32a469ae219763f80ef1fc9f151a62cfe76ed6.camel@linux.ibm.com>
Subject: Re: [RFC v2] KVM: x86: Support KVM VMs sharing SEV context
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Nathan Tempelman <natet@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        dovmurik@linux.vnet.ibm.com, lersek@redhat.com, frankeh@us.ibm.com
Date:   Thu, 08 Apr 2021 14:15:41 -0700
In-Reply-To: <CABayD+cBdOMzy7g6X4W-M8ssMpbpDGxFA5o-Nc5CmWi-aeCArQ@mail.gmail.com>
References: <20210316014027.3116119-1-natet@google.com>
         <20210402115813.GB17630@ashkalra_ubuntu_server>
         <87bdd3a6-f5eb-91e4-9442-97dfef231640@redhat.com>
         <936fa1e7755687981bdbc3bad9ecf2354c748381.camel@linux.ibm.com>
         <CABayD+cBdOMzy7g6X4W-M8ssMpbpDGxFA5o-Nc5CmWi-aeCArQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EV1dtE_6LgywavOuJOR7eNYuMoAGKwVO
X-Proofpoint-GUID: Y9cjsZa-Lc66B5wV31u__Ngva2wUTI0l
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-08_07:2021-04-08,2021-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104080141
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-04-08 at 12:48 -0700, Steve Rutherford wrote:
> On Thu, Apr 8, 2021 at 10:43 AM James Bottomley <jejb@linux.ibm.com>
> wrote:
> > On Fri, 2021-04-02 at 16:20 +0200, Paolo Bonzini wrote:
> > > On 02/04/21 13:58, Ashish Kalra wrote:
> > > > Hi Nathan,
> > > > 
> > > > Will you be posting a corresponding Qemu patch for this ?
> > > 
> > > Hi Ashish,
> > > 
> > > as far as I know IBM is working on QEMU patches for guest-based
> > > migration helpers.
> > 
> > Yes, that's right, we'll take on this part.
> > 
> > > However, it would be nice to collaborate on the low-level
> > > (SEC/PEI) firmware patches to detect whether a CPU is part of the
> > > primary VM or the mirror.  If Google has any OVMF patches already
> > > done for that, it would be great to combine it with IBM's SEV
> > > migration code and merge it into upstream OVMF.
> > 
> > We've reached the stage with our prototyping where not having the
> > OVMF support is blocking us from working on QEMU.  If we're going
> > to have to reinvent the wheel in OVMF because Google is unwilling
> > to publish the patches, can you at least give some hints about how
> > you did it?
> > 
> > Thanks,
> > 
> > James
> 
> Hey James,
> It's not strictly necessary to modify OVMF to make SEV VMs live
> migrate. If we were to modify OVMF, we would contribute those changes
> upstream.

Well, no, we already published an OVMF RFC to this list that does
migration.  However, the mirror approach requires a different boot
mechanism for the extra vCPU in the mirror.  I assume you're doing this
bootstrap through OVMF so the hypervisor can interrogate it to get the
correct entry point?  That's the code we're asking to see because
that's what replaces our use of the MP service in the RFC.

James


