Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7383D44DC46
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 20:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhKKTrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 14:47:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhKKTrF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 14:47:05 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABJTjbm009472;
        Thu, 11 Nov 2021 19:44:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=GFfRmQLYYPWF3fcRqPcep41sYDXrsOxybJSFMhx8ZJ8=;
 b=WrDIXx/JiNBilbiqUCRZQCExVKepRtL5kMitzYTF90DKOfllwkupz6cxnlt9eI/sOIfd
 hoT2ej3Ux6eGp9+nCv/XYtKnGFYlGStDfHqzgMkZ9wp60NWr700Nm18NapVJrm/YKOAg
 bDgbyAS8pwC6xMQ+EmMX/NAzvtxLY0CG75c9NDik74fQ0Fm4TDwxfXiSF/p5kEpANr0j
 iD/Ju8vWqsKuMiBo6TUUiyK0KzgWpnZKUY/oD3svaa1xfZRxpo+GwPZG2t7jyuFpqpsO
 QUzpNDt4La4ySI54AWQDIsuK+wG048OdXQnFWNubnhA7JZ8Pc770TIXBoaYh5WFg9X9O iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c99cs88r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 19:44:15 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABJhuwi000533;
        Thu, 11 Nov 2021 19:44:15 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c99cs88qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 19:44:15 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABJg9kP023334;
        Thu, 11 Nov 2021 19:44:14 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 3c5hbdff6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 19:44:14 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABJiCEL61932002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 19:44:12 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BADC7136061;
        Thu, 11 Nov 2021 19:44:12 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9FD7136060;
        Thu, 11 Nov 2021 19:44:11 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.106.148])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 19:44:11 +0000 (GMT)
Message-ID: <006980fd7d0344b0258aa87128891fcd81c005b7.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
From:   Eric Farman <farman@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Thu, 11 Nov 2021 14:44:10 -0500
In-Reply-To: <ff344676-0c37-610b-eafb-b1477db0f6a1@redhat.com>
References: <20211110203322.1374925-1-farman@linux.ibm.com>
         <20211110203322.1374925-3-farman@linux.ibm.com>
         <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
         <ab82e68051674ea771e2cb5371ca2a204effab40.camel@linux.ibm.com>
         <32836eb5-532f-962d-161a-faa2213a0691@linux.ibm.com>
         <b116e738d8f9b185867ab28395012aaddd58af31.camel@linux.ibm.com>
         <85ba9fa3-ca25-b598-aecd-5e0c6a0308f2@redhat.com>
         <19a2543b24015873db736bddb14d0e4d97712086.camel@linux.ibm.com>
         <ff344676-0c37-610b-eafb-b1477db0f6a1@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zAPBfMpqM_fZttdOGGlcWF4BiYeyiDaq
X-Proofpoint-GUID: yhPqa_p4xnSnktHicdjSyYMhyU6b874u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_07,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 phishscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-11-11 at 20:15 +0100, David Hildenbrand wrote:
> On 11.11.21 20:05, Eric Farman wrote:
> > On Thu, 2021-11-11 at 19:29 +0100, David Hildenbrand wrote:
> > > On 11.11.21 18:48, Eric Farman wrote:
> > > > On Thu, 2021-11-11 at 17:13 +0100, Janosch Frank wrote:
> > > > > On 11/11/21 16:03, Eric Farman wrote:
> > > > > > On Thu, 2021-11-11 at 10:15 +0100, David Hildenbrand wrote:
> > > > > > > On 10.11.21 21:33, Eric Farman wrote:
> > > > > > > > With commit 2444b352c3ac ("KVM: s390: forward most SIGP
> > > > > > > > orders
> > > > > > > > to
> > > > > > > > user
> > > > > > > > space") we have a capability that allows the "fast"
> > > > > > > > SIGP
> > > > > > > > orders
> > > > > > > > (as
> > > > > > > > defined by the Programming Notes for the SIGNAL
> > > > > > > > PROCESSOR
> > > > > > > > instruction in
> > > > > > > > the Principles of Operation) to be handled in-kernel,
> > > > > > > > while
> > > > > > > > all
> > > > > > > > others are
> > > > > > > > sent to userspace for processing.
> > > > > > > > 
> > > > > > > > This works fine but it creates a situation when, for
> > > > > > > > example, a
> > > > > > > > SIGP SENSE
> > > > > > > > might return CC1 (STATUS STORED, and status bits
> > > > > > > > indicating
> > > > > > > > the
> > > > > > > > vcpu is
> > > > > > > > stopped), when in actuality userspace is still
> > > > > > > > processing a
> > > > > > > > SIGP
> > > > > > > > STOP AND
> > > > > > > > STORE STATUS order, and the vcpu is not yet actually
> > > > > > > > stopped.
> > > > > > > > Thus,
> > > > > > > > the
> > > > > > > > SIGP SENSE should actually be returning CC2 (busy)
> > > > > > > > instead
> > > > > > > > of
> > > > > > > > CC1.
> > > > > > > > 
> > > > > > > > To fix this, add another CPU capability, dependent on
> > > > > > > > the
> > > > > > > > USER_SIGP
> > > > > > > > one,
> > > > > > > > and two associated IOCTLs. One IOCTL will be used by
> > > > > > > > userspace
> > > > > > > > to
> > > > > > > > mark a
> > > > > > > > vcpu "busy" processing a SIGP order, and cause
> > > > > > > > concurrent
> > > > > > > > orders
> > > > > > > > handled
> > > > > > > > in-kernel to be returned with CC2 (busy). Another IOCTL
> > > > > > > > will be
> > > > > > > > used by
> > > > > > > > userspace to mark the SIGP "finished", and the vcpu
> > > > > > > > free to
> > > > > > > > process
> > > > > > > > additional orders.
> > > > > > > > 
> > > > > > > 
> > > > > > > This looks much cleaner to me, thanks!
> > > > > > > 
> > > > > > > [...]
> > > > > > > 
> > > > > > > > diff --git a/arch/s390/kvm/kvm-s390.h
> > > > > > > > b/arch/s390/kvm/kvm-
> > > > > > > > s390.h
> > > > > > > > index c07a050d757d..54371cede485 100644
> > > > > > > > --- a/arch/s390/kvm/kvm-s390.h
> > > > > > > > +++ b/arch/s390/kvm/kvm-s390.h
> > > > > > > > @@ -82,6 +82,22 @@ static inline int
> > > > > > > > is_vcpu_idle(struct
> > > > > > > > kvm_vcpu
> > > > > > > > *vcpu)
> > > > > > > >   	return test_bit(vcpu->vcpu_idx, vcpu->kvm-
> > > > > > > > > arch.idle_mask);
> > > > > > > >   }
> > > > > > > >   
> > > > > > > > +static inline bool kvm_s390_vcpu_is_sigp_busy(struct
> > > > > > > > kvm_vcpu
> > > > > > > > *vcpu)
> > > > > > > > +{
> > > > > > > > +	return (atomic_read(&vcpu->arch.sigp_busy) ==
> > > > > > > > 1);
> > > > > > > 
> > > > > > > You can drop ()
> > > > > > > 
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static inline bool kvm_s390_vcpu_set_sigp_busy(struct
> > > > > > > > kvm_vcpu
> > > > > > > > *vcpu)
> > > > > > > > +{
> > > > > > > > +	/* Return zero for success, or -EBUSY if
> > > > > > > > another vcpu
> > > > > > > > won */
> > > > > > > > +	return (atomic_cmpxchg(&vcpu->arch.sigp_busy,
> > > > > > > > 0, 1) ==
> > > > > > > > 0) ? 0 :
> > > > > > > > -EBUSY;
> > > > > > > 
> > > > > > > You can drop () as well.
> > > > > > > 
> > > > > > > We might not need the -EBUSY semantics after all. User
> > > > > > > space
> > > > > > > can
> > > > > > > just
> > > > > > > track if it was set, because it's in charge of setting
> > > > > > > it.
> > > > > > 
> > > > > > Hrm, I added this to distinguish a newer kernel with an
> > > > > > older
> > > > > > QEMU,
> > > > > > but
> > > > > > of course an older QEMU won't know the difference either.
> > > > > > I'll
> > > > > > doublecheck that this is works fine in the different
> > > > > > permutations.
> > > > > > 
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static inline void
> > > > > > > > kvm_s390_vcpu_clear_sigp_busy(struct
> > > > > > > > kvm_vcpu
> > > > > > > > *vcpu)
> > > > > > > > +{
> > > > > > > > +	atomic_set(&vcpu->arch.sigp_busy, 0);
> > > > > > > > +}
> > > > > > > > +
> > > > > > > >   static inline int kvm_is_ucontrol(struct kvm *kvm)
> > > > > > > >   {
> > > > > > > >   #ifdef CONFIG_KVM_S390_UCONTROL
> > > > > > > > diff --git a/arch/s390/kvm/sigp.c
> > > > > > > > b/arch/s390/kvm/sigp.c
> > > > > > > > index 5ad3fb4619f1..a37496ea6dfa 100644
> > > > > > > > --- a/arch/s390/kvm/sigp.c
> > > > > > > > +++ b/arch/s390/kvm/sigp.c
> > > > > > > > @@ -276,6 +276,10 @@ static int handle_sigp_dst(struct
> > > > > > > > kvm_vcpu
> > > > > > > > *vcpu, u8 order_code,
> > > > > > > >   	if (!dst_vcpu)
> > > > > > > >   		return SIGP_CC_NOT_OPERATIONAL;
> > > > > > > >   
> > > > > > > > +	if (kvm_s390_vcpu_is_sigp_busy(dst_vcpu)) {
> > > > > > > > +		return SIGP_CC_BUSY;
> > > > > > > > +	}
> > > > > > > 
> > > > > > > You can drop {}
> > > > > > 
> > > > > > Arg, I had some debug in there which needed the braces, and
> > > > > > of
> > > > > > course
> > > > > > it's unnecessary now. Thanks.
> > > > > > 
> > > > > > > > +
> > > > > > > >   	switch (order_code) {
> > > > > > > >   	case SIGP_SENSE:
> > > > > > > >   		vcpu->stat.instruction_sigp_sense++;
> > > > > > > > @@ -411,6 +415,12 @@ int kvm_s390_handle_sigp(struct
> > > > > > > > kvm_vcpu
> > > > > > > > *vcpu)
> > > > > > > >   	if (handle_sigp_order_in_user_space(vcpu,
> > > > > > > > order_code,
> > > > > > > > cpu_addr))
> > > > > > > >   		return -EOPNOTSUPP;
> > > > > > > >   
> > > > > > > > +	/* Check the current vcpu, if it was a target
> > > > > > > > from
> > > > > > > > another vcpu
> > > > > > > > */
> > > > > > > > +	if (kvm_s390_vcpu_is_sigp_busy(vcpu)) {
> > > > > > > > +		kvm_s390_set_psw_cc(vcpu,
> > > > > > > > SIGP_CC_BUSY);
> > > > > > > > +		return 0;
> > > > > > > > +	}
> > > > > > > 
> > > > > > > I don't think we need this. I think the above (checking
> > > > > > > the
> > > > > > > target of
> > > > > > > a
> > > > > > > SIGP order) is sufficient. Or which situation do you have
> > > > > > > in
> > > > > > > mind?
> > > > > > > 
> > > > > > 
> > > > > > Hrm... I think you're right. I was thinking of this:
> > > > > > 
> > > > > > VCPU 1 - SIGP STOP CPU 2
> > > > > > VCPU 2 - SIGP SENSE CPU 1
> > > > > > 
> > > > > > But of course either CPU2 is going to be marked "busy"
> > > > > > first,
> > > > > > and
> > > > > > the
> > > > > > sense doesn't get processed until it's reset, or the sense
> > > > > > arrives
> > > > > > first, and the busy/notbusy doesn't matter. Let me
> > > > > > doublecheck
> > > > > > my
> > > > > > tests
> > > > > > for the non-RFC version.
> > > > > > 
> > > > > > > I do wonder if we want to make this a
> > > > > > > kvm_arch_vcpu_ioctl()
> > > > > > > instead,
> > > > > > 
> > > > > > In one of my original attempts between v1 and v2, I had put
> > > > > > this
> > > > > > there.
> > > > > > This reliably deadlocks my guest, because the caller
> > > > > > (kvm_vcpu_ioctl())
> > > > > > tries to acquire vcpu->mutex, and racing SIGPs (via
> > > > > > KVM_RUN)
> > > > > > might
> > > > > > already be holding it. Thus, it's an async ioctl. I could
> > > > > > fold
> > > > > > it
> > > > > > into
> > > > > > the existing interrupt ioctl, but as those are architected
> > > > > > structs
> > > > > > it
> > > > > > seems more natural do it this way. Or I have mis-understood
> > > > > > something
> > > > > > along the way?
> > > > > > 
> > > > > > > essentially just providing a KVM_S390_SET_SIGP_BUSY *and*
> > > > > > > providing
> > > > > > > the
> > > > > > > order. "order == 0" sets it to !busy.
> > > > > > 
> > > > > > I'd tried this too, since it provided some nice debug-
> > > > > > ability.
> > > > > > Unfortunately, I have a testcase (which I'll eventually get
> > > > > > folded
> > > > > > into
> > > > > > kvm-unit-tests :)) that picks a random order between 0-255,
> > > > > > knowing
> > > > > > that there's only a couple handfuls of valid orders, to
> > > > > > check
> > > > > > the
> > > > > > response. Zero is valid architecturally (POPS figure 4-29),
> > > > > > even if
> > > > > > it's unassigned. The likelihood of it becoming assigned is
> > > > > > probably
> > > > > > quite low, but I'm not sure that I like special-casing an
> > > > > > order
> > > > > > of
> > > > > > zero
> > > > > > in this way.
> > > > > > 
> > > > > 
> > > > > Looking at the API I'd like to avoid having two IOCTLs 
> > > > 
> > > > Since the order is a single byte, we could have the payload of
> > > > an
> > > > ioctl
> > > > say "0-255 is an order that we're busy processing, anything
> > > > higher
> > > > than
> > > > that resets the busy" or something. That would remove the need
> > > > for
> > > > a
> > > > second IOCTL.
> > > 
> > > Maybe just pass an int and treat a negative (or just -1) value as
> > > clearing the order.
> > > 
> > 
> > Right, that's exactly what I had at one point. I thought it was too
> > cumbersome, but maybe not. Will dust it off, pending my question to
> > Janosch about 0-vs-1 IOCTLs.
> 
> As we really only care about the SIGP STOP case, 

Is that really true? SIGP RESTART does an inject back to KVM, ditto the
(INITIAL) CPU RESET orders. It's true that SIGP SENSE is getting
tripped up on whether a vcpu is actually stopped or not, but I believe
that SIGP SENSE saying "everything's fine" when a vcpu is still busy processing an order isn't great either.

> you could theoretically
> bury it into kvm_arch_vcpu_ioctl_set_mpstate(), using a new state
> "KVM_MP_STATE_STOPPING".
> 


