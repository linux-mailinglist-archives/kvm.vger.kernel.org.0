Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177ED359146
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 03:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhDIBSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 21:18:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18278 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhDIBSl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 21:18:41 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13914DpB159043;
        Thu, 8 Apr 2021 21:18:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=K3XPmNMuwyZZr/5sUSmnx1As4ic0UC/dAepl6HschEw=;
 b=j0NlBetAt1It/D4SQRZoSaCHQZ3be2h1D+ADFr9WW5jXyK/nv0N6jRdh5ZiUmOQRGndo
 TFhUEpZyBTo818tvYewHBEooAu3uER0VImz3R6C6Rmsmr7HyybUo2d7T+JnBzLfTeK8h
 NS35lGtjOzAjj+toJSyovhWivJsBOH4oa4N7gDyblddxiZ2QTEmpyRYhB9TJCjo/xLkg
 X6D8qHzzII43Rbxspylz2CT3PdyGTD5IBOBybLNOgGuxLc9jFQ4AitzklMFw8dwkd0Qf
 CwuPgPTA3x29LvfodDzJtTj39O3CJTQg33X9PFUbMPnlcN6wn9q7JxtR5hU8XmXk8ysU 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvn224cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 21:18:26 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13914JZF159194;
        Thu, 8 Apr 2021 21:18:26 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvn224cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 21:18:26 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1391CmTS016704;
        Fri, 9 Apr 2021 01:18:25 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02wdc.us.ibm.com with ESMTP id 37ryqcfw75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Apr 2021 01:18:25 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1391IOtG31850930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Apr 2021 01:18:24 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ED5378060;
        Fri,  9 Apr 2021 01:18:24 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B336D7805C;
        Fri,  9 Apr 2021 01:18:21 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.189.52])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  9 Apr 2021 01:18:21 +0000 (GMT)
Message-ID: <75863fa3f1c93ffda61f1cddfef0965a0391ef60.camel@linux.ibm.com>
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
Date:   Thu, 08 Apr 2021 18:18:20 -0700
In-Reply-To: <CABayD+c22hgPtjJBLkhyvyt+WAKXhoQOM6n0toVR1XrFY4WHAw@mail.gmail.com>
References: <20210316014027.3116119-1-natet@google.com>
         <20210402115813.GB17630@ashkalra_ubuntu_server>
         <87bdd3a6-f5eb-91e4-9442-97dfef231640@redhat.com>
         <936fa1e7755687981bdbc3bad9ecf2354c748381.camel@linux.ibm.com>
         <CABayD+cBdOMzy7g6X4W-M8ssMpbpDGxFA5o-Nc5CmWi-aeCArQ@mail.gmail.com>
         <fc32a469ae219763f80ef1fc9f151a62cfe76ed6.camel@linux.ibm.com>
         <CABayD+c22hgPtjJBLkhyvyt+WAKXhoQOM6n0toVR1XrFY4WHAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ScaumZ4WLYIlfn8cl9vwDnL047ZMhAGN
X-Proofpoint-ORIG-GUID: NY5Oevx8UJjI5SSIvvp40UoHbyxKxOrP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-08_12:2021-04-08,2021-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 spamscore=0 mlxscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104090004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-04-08 at 17:41 -0700, Steve Rutherford wrote:
> On Thu, Apr 8, 2021 at 2:15 PM James Bottomley <jejb@linux.ibm.com>
> wrote:
> > On Thu, 2021-04-08 at 12:48 -0700, Steve Rutherford wrote:
> > > On Thu, Apr 8, 2021 at 10:43 AM James Bottomley <
> > > jejb@linux.ibm.com>
> > > wrote:
> > > > On Fri, 2021-04-02 at 16:20 +0200, Paolo Bonzini wrote:
[...]
> > > > > However, it would be nice to collaborate on the low-level
> > > > > (SEC/PEI) firmware patches to detect whether a CPU is part of
> > > > > the primary VM or the mirror.  If Google has any OVMF patches
> > > > > already done for that, it would be great to combine it with
> > > > > IBM's SEV migration code and merge it into upstream OVMF.
> > > > 
> > > > We've reached the stage with our prototyping where not having
> > > > the OVMF support is blocking us from working on QEMU.  If we're
> > > > going to have to reinvent the wheel in OVMF because Google is
> > > > unwilling to publish the patches, can you at least give some
> > > > hints about how you did it?
> > > > 
> > > > Thanks,
> > > > 
> > > > James
> > > 
> > > Hey James,
> > > It's not strictly necessary to modify OVMF to make SEV VMs live
> > > migrate. If we were to modify OVMF, we would contribute those
> > > changes
> > > upstream.
> > 
> > Well, no, we already published an OVMF RFC to this list that does
> > migration.  However, the mirror approach requires a different boot
> > mechanism for the extra vCPU in the mirror.  I assume you're doing
> > this bootstrap through OVMF so the hypervisor can interrogate it to
> > get the correct entry point?  That's the code we're asking to see
> > because that's what replaces our use of the MP service in the RFC.
> > 
> > James
> 
> Hey James,
> The intention would be to have a separate, stand-alone firmware-like
> binary run by the mirror. Since the VMM is in control of where it
> places that binary in the guest physical address space and the
> initial configuration of the vCPUs, it can point the vCPUs at an
> entry point contained within that binary, rather than at the standard
> x86 reset vector.

If you want to share ASIDs you have to share the firmware that the
running VM has been attested to.  Once the VM moves from LAUNCH to
RUNNING, the PSP won't allow the VMM to inject any more firmware or do
any more attestations.  What you mirror after this point can thus only
contain what has already been measured or what the guest added.  This
is why we think there has to be a new entry path into the VM for the
mirror vCPU.

So assuming you're thinking you'll inject two pieces of firmware at
start of day: the OVFM and this separate binary and attest to both,
then you can do that, but then you have two problems:

   1. Preventing OVMF from trampling all over your separate binary while
      it's booting
   2. Launching the vCPU up into this separate binary in a way it can
      execute (needs stack and heap)

I think you can likely solve 1. by making the separate binary look like
a ROM, but then you have the problem of where you steal the RAM you
need for a heap and stack and it still brings us back to how to launch
the vCPU which was the original question.

With ES we can set the registers at launch, so a vCPU that's never
launched can still be pre-programmed with the separate binary entry
point but solving the stack and heap looks like it requires co-
operation from OVMF.

That's why we were thinking the easiest straight line approach is to
have a runtime DXE which has a declared initialization routine that
allocates memory for the stack and a heap and a separate declared entry
point for the vCPU which picks up the already allocated and mapped
stack and heap.

James


