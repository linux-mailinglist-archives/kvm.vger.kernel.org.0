Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDC8429699
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 20:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbhJKSPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 14:15:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234368AbhJKSPp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 14:15:45 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BIBrw0003966;
        Mon, 11 Oct 2021 14:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Nhr9ozxB8kgeEtRGWJBY00DQVJCWnvf+lQ+KzInYW+Y=;
 b=f5anr2syJ0Ri8Wu8SN2VBvVHzOvq9G7YXNxX5mhicrc4lqCvHMVknEIHHmzTXnQTdKgx
 V198DOZYgkDmK0Qx/1lU/BTSmQnrZxmOyfmYYJpPKYG4Ax1/XNyI4hhU0oOzFZr3q6EV
 N8M4NPezynnBCQqosb/IdIXen6pBgur87AzsZA/Qg26R4JqxJPbJ3TObANxssPM+fqLE
 O0fGA+AYSPtm4TZNW3/FjKYkI+FzIr16zKOUpgQ2vASU66pJlxZpEoB4KtWcA5fLDLH6
 lYOD8E55G4bwi+spTg3fux7FkCOWHxohUz9SfI8fAsDm/llsCOYbpiHGlytEef92h145 pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmtb1011t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 14:13:43 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19BIC2CO004103;
        Mon, 11 Oct 2021 14:13:43 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmtb1011b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 14:13:43 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BIDYUk002068;
        Mon, 11 Oct 2021 18:13:42 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3bkeq648hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 18:13:42 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BIDfY044237108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 18:13:41 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49037112063;
        Mon, 11 Oct 2021 18:13:41 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96D98112062;
        Mon, 11 Oct 2021 18:13:38 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.134.52])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 11 Oct 2021 18:13:38 +0000 (GMT)
Message-ID: <4c733158506497972d5b04b34a169c054fca4ba5.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v1 2/6] KVM: s390: Reject SIGP when destination CPU
 is busy
From:   Eric Farman <farman@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Mon, 11 Oct 2021 14:13:37 -0400
In-Reply-To: <e9935fe6-8c8a-b63d-4076-de85fb0e7146@redhat.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
         <20211008203112.1979843-3-farman@linux.ibm.com>
         <4c6c0b14-e148-9000-c581-db14d2ea555e@redhat.com>
         <8d8012a8-6ea5-6e0e-19c4-d9c64e785222@de.ibm.com>
         <bddd3a05-b364-7b52-f329-11a07146394e@redhat.com>
         <e9935fe6-8c8a-b63d-4076-de85fb0e7146@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ywn9lcLXwhsw7cXqPgEwYC9iFn5urAcm
X-Proofpoint-ORIG-GUID: zv3N6xYw6_yqvTUiApSz34mWOiddrYqq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_06,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-10-11 at 19:58 +0200, David Hildenbrand wrote:
> On 11.10.21 09:52, Thomas Huth wrote:
> > On 11/10/2021 09.43, Christian Borntraeger wrote:
> > > Am 11.10.21 um 09:27 schrieb Thomas Huth:
> > > > On 08/10/2021 22.31, Eric Farman wrote:
> > > > > With KVM_CAP_USER_SIGP enabled, most orders are handled by
> > > > > userspace.
> > > > > However, some orders (such as STOP or STOP AND STORE STATUS)
> > > > > end up
> > > > > injecting work back into the kernel. Userspace itself should
> > > > > (and QEMU
> > > > > does) look for this conflict, and reject additional (non-
> > > > > reset) orders
> > > > > until this work completes.
> > > > > 
> > > > > But there's no need to delay that. If the kernel knows about
> > > > > the STOP
> > > > > IRQ that is in process, the newly-requested SIGP order can be
> > > > > rejected
> > > > > with a BUSY condition right up front.
> > > > > 
> > > > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > > > Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > > > > ---
> > > > >    arch/s390/kvm/sigp.c | 43
> > > > > +++++++++++++++++++++++++++++++++++++++++++
> > > > >    1 file changed, 43 insertions(+)
> > > > > 
> > > > > diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> > > > > index cf4de80bd541..6ca01bbc72cf 100644
> > > > > --- a/arch/s390/kvm/sigp.c
> > > > > +++ b/arch/s390/kvm/sigp.c
> > > > > @@ -394,6 +394,45 @@ static int
> > > > > handle_sigp_order_in_user_space(struct
> > > > > kvm_vcpu *vcpu, u8 order_code,
> > > > >        return 1;
> > > > >    }
> > > > > +static int handle_sigp_order_is_blocked(struct kvm_vcpu
> > > > > *vcpu, u8
> > > > > order_code,
> > > > > +                    u16 cpu_addr)
> > > > > +{
> > > > > +    struct kvm_vcpu *dst_vcpu = kvm_get_vcpu_by_id(vcpu-
> > > > > >kvm, cpu_addr);
> > > > > +    int rc = 0;
> > > > > +
> > > > > +    /*
> > > > > +     * SIGP orders directed at invalid vcpus are not
> > > > > blocking,
> > > > > +     * and should not return busy here. The code that
> > > > > handles
> > > > > +     * the actual SIGP order will generate the "not
> > > > > operational"
> > > > > +     * response for such a vcpu.
> > > > > +     */
> > > > > +    if (!dst_vcpu)
> > > > > +        return 0;
> > > > > +
> > > > > +    /*
> > > > > +     * SIGP orders that process a flavor of reset would not
> > > > > be
> > > > > +     * blocked through another SIGP on the destination CPU.
> > > > > +     */
> > > > > +    if (order_code == SIGP_CPU_RESET ||
> > > > > +        order_code == SIGP_INITIAL_CPU_RESET)
> > > > > +        return 0;
> > > > > +
> > > > > +    /*
> > > > > +     * Any other SIGP order could race with an existing SIGP
> > > > > order
> > > > > +     * on the destination CPU, and thus encounter a busy
> > > > > condition
> > > > > +     * on the CPU processing the SIGP order. Reject the
> > > > > order at
> > > > > +     * this point, rather than racing with the STOP IRQ
> > > > > injection.
> > > > > +     */
> > > > > +    spin_lock(&dst_vcpu->arch.local_int.lock);
> > > > > +    if (kvm_s390_is_stop_irq_pending(dst_vcpu)) {
> > > > > +        kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
> > > > > +        rc = 1;
> > > > > +    }
> > > > > +    spin_unlock(&dst_vcpu->arch.local_int.lock);
> > > > > +
> > > > > +    return rc;
> > > > > +}
> > > > > +
> > > > >    int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
> > > > >    {
> > > > >        int r1 = (vcpu->arch.sie_block->ipa & 0x00f0) >> 4;
> > > > > @@ -408,6 +447,10 @@ int kvm_s390_handle_sigp(struct kvm_vcpu
> > > > > *vcpu)
> > > > >            return kvm_s390_inject_program_int(vcpu,
> > > > > PGM_PRIVILEGED_OP);
> > > > >        order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
> > > > > +
> > > > > +    if (handle_sigp_order_is_blocked(vcpu, order_code,
> > > > > cpu_addr))
> > > > > +        return 0;
> > > > > +
> > > > >        if (handle_sigp_order_in_user_space(vcpu, order_code,
> > > > > cpu_addr))
> > > > >            return -EOPNOTSUPP;
> > > > 
> > > > We've been bitten quite a bit of times in the past already by
> > > > doing too
> > > > much control logic in the kernel instead of doing it in QEMU,
> > > > where we
> > > > should have a more complete view of the state ... 

Fair enough. It's an unfortunate side effect that "USER_SIGP" means
"all SIGP orders except for these ones that are handled totally within
the kernel."


> > > > so I'm feeling quite a
> > > > bit uneasy of adding this in front of the "return -EOPNOTSUPP"
> > > > here ...
> > > > Did you see any performance issues that would justify this
> > > > change?
> > > 
> > > It does at least handle this case for simple userspaces without
> > > KVM_CAP_S390_USER_SIGP .
> > 
> > For that case, I'd prefer to swap the order here by doing the "if
> > handle_sigp_order_in_user_space return -EOPNOTSUPP" first, and
> > doing the "if
> > handle_sigp_order_is_blocked return 0" afterwards.

Well, that would be fine. But of course part of my worry is when
userspace has CAP_S390_USER_SIGP, and we have a race between the kernel
handling SENSE and userspace handling things like STOP/RESTART.

> > 
> > ... unless we feel really, really sure that it always ok to do it
> > like in
> > this patch ... but as I said, we've been bitten by such things a
> > couple of
> > times already, so I'd suggest to better play safe...
> 
> As raised in the QEMU series, I wonder if it's cleaner for user space
> to 
> set the target CPU as busy/!busy for SIGP while processing an order. 
> We'll need a new VCPU IOCTL, but it conceptually sounds cleaner to me
> ...

Hrm... Well I guess I'd hoped to address this within the boundaries of
what exists today. Since there already is a "userspace sets cpu state"
interface, but those states do not contain a "busy" (just stopped or
operating, according to POPS), I'd tried to stay away from going down
that path to avoid confusion. I'll take a swag at it, though.


