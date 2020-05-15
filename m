Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014F11D45B7
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 08:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgEOGRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 02:17:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46527 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726584AbgEOGRG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 02:17:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589523425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oN6MYt7rJRAHouc5JqboQ3NUhAVY4MBugEYSlQiB08g=;
        b=PstNC7ZCKRP16gjuP8wzFElefwMx9MR04VTcoDT+7lgTQkd1lGXwe3gw8MKf4azqtlDv0o
        4vSeL6GiMGyEAFPrZgSKeBYC+hZPSIUtPPOea5ySApSGyihOUkSDqoce7sMbx1n6skxjQj
        AZAqll5UgYeJJGzu7yuXFFvuXvptcmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-EVw2PcdEMlGjaoMsis_Fqg-1; Fri, 15 May 2020 02:17:01 -0400
X-MC-Unique: EVw2PcdEMlGjaoMsis_Fqg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF7AD1085943;
        Fri, 15 May 2020 06:16:59 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7C762B4DE;
        Fri, 15 May 2020 06:16:54 +0000 (UTC)
Date:   Fri, 15 May 2020 08:16:52 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Collin Walling <walling@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, pbonzini@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
Message-ID: <20200515081652.62c33498.cohuck@redhat.com>
In-Reply-To: <f3428cd4-d9af-cc99-ff31-4b3f3deee3d2@linux.ibm.com>
References: <20200513221557.14366-1-walling@linux.ibm.com>
        <20200513221557.14366-3-walling@linux.ibm.com>
        <d4320d09-7b3a-ac13-77be-02397f4ccc83@redhat.com>
        <de4e4416-5158-b60f-e2a8-fb6d3d48d516@linux.ibm.com>
        <88d27a61-b55b-ee68-f7f9-85ce7fcefd64@redhat.com>
        <e7691d9a-a446-17db-320e-a2348e0eb057@linux.ibm.com>
        <516405b3-67c4-aa12-1fa5-772e401e4403@redhat.com>
        <2aa0d573-b9d4-8022-9ec5-79f7156d1bcb@linux.ibm.com>
        <af478798-eced-a279-8425-a1bb23d2bd48@redhat.com>
        <f3428cd4-d9af-cc99-ff31-4b3f3deee3d2@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 May 2020 14:53:24 -0400
Collin Walling <walling@linux.ibm.com> wrote:

> On 5/14/20 2:37 PM, Thomas Huth wrote:
> > On 14/05/2020 19.20, Collin Walling wrote:  
> >> On 5/14/20 5:53 AM, David Hildenbrand wrote:  
> >>> On 14.05.20 11:49, Janosch Frank wrote:  
> >>>> On 5/14/20 11:37 AM, David Hildenbrand wrote:  
> >>>>> On 14.05.20 10:52, Janosch Frank wrote:  
> >>>>>> On 5/14/20 9:53 AM, Thomas Huth wrote:  
> >>>>>>> On 14/05/2020 00.15, Collin Walling wrote:  
> >>>>>>>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
> >>>>>>>> be intercepted by SIE and handled via KVM. Let's introduce some
> >>>>>>>> functions to communicate between userspace and KVM via ioctls. These
> >>>>>>>> will be used to get/set the diag318 related information, as well as
> >>>>>>>> check the system if KVM supports handling this instruction.
> >>>>>>>>
> >>>>>>>> This information can help with diagnosing the environment the VM is
> >>>>>>>> running in (Linux, z/VM, etc) if the OS calls this instruction.
> >>>>>>>>
> >>>>>>>> By default, this feature is disabled and can only be enabled if a
> >>>>>>>> user space program (such as QEMU) explicitly requests it.
> >>>>>>>>
> >>>>>>>> The Control Program Name Code (CPNC) is stored in the SIE block
> >>>>>>>> and a copy is retained in each VCPU. The Control Program Version
> >>>>>>>> Code (CPVC) is not designed to be stored in the SIE block, so we
> >>>>>>>> retain a copy in each VCPU next to the CPNC.
> >>>>>>>>
> >>>>>>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> >>>>>>>> ---
> >>>>>>>>  Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
> >>>>>>>>  arch/s390/include/asm/kvm_host.h      |  6 +-
> >>>>>>>>  arch/s390/include/uapi/asm/kvm.h      |  5 ++
> >>>>>>>>  arch/s390/kvm/diag.c                  | 20 ++++++
> >>>>>>>>  arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
> >>>>>>>>  arch/s390/kvm/kvm-s390.h              |  1 +
> >>>>>>>>  arch/s390/kvm/vsie.c                  |  2 +
> >>>>>>>>  7 files changed, 151 insertions(+), 1 deletion(-)  
> >>>>>>> [...]  
> >>>>>>>> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> >>>>>>>> index 563429dece03..3caed4b880c8 100644
> >>>>>>>> --- a/arch/s390/kvm/diag.c
> >>>>>>>> +++ b/arch/s390/kvm/diag.c
> >>>>>>>> @@ -253,6 +253,24 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
> >>>>>>>>  	return ret < 0 ? ret : 0;
> >>>>>>>>  }
> >>>>>>>>  
> >>>>>>>> +static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
> >>>>>>>> +{
> >>>>>>>> +	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
> >>>>>>>> +	u64 info = vcpu->run->s.regs.gprs[reg];
> >>>>>>>> +
> >>>>>>>> +	if (!vcpu->kvm->arch.use_diag318)
> >>>>>>>> +		return -EOPNOTSUPP;
> >>>>>>>> +
> >>>>>>>> +	vcpu->stat.diagnose_318++;
> >>>>>>>> +	kvm_s390_set_diag318_info(vcpu->kvm, info);
> >>>>>>>> +
> >>>>>>>> +	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
> >>>>>>>> +		   vcpu->kvm->arch.diag318_info.cpnc,
> >>>>>>>> +		   (u64)vcpu->kvm->arch.diag318_info.cpvc);  
> >>
> >> Errr.. thought I dropped this message. We favored just using the
> >> VM_EVENT from last time.
> >>  
> >>>>>>>> +
> >>>>>>>> +	return 0;
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
> >>>>>>>>  {
> >>>>>>>>  	int code = kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
> >>>>>>>> @@ -272,6 +290,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
> >>>>>>>>  		return __diag_page_ref_service(vcpu);
> >>>>>>>>  	case 0x308:
> >>>>>>>>  		return __diag_ipl_functions(vcpu);
> >>>>>>>> +	case 0x318:
> >>>>>>>> +		return __diag_set_diag318_info(vcpu);
> >>>>>>>>  	case 0x500:
> >>>>>>>>  		return __diag_virtio_hypercall(vcpu);  
> >>>>>>>
> >>>>>>> I wonder whether it would make more sense to simply drop to userspace
> >>>>>>> and handle the diag 318 call there? That way the userspace would always
> >>>>>>> be up-to-date, and as we've seen in the past (e.g. with the various SIGP
> >>>>>>> handling), it's better if the userspace is in control... e.g. userspace
> >>>>>>> could also decide to only use KVM_S390_VM_MISC_ENABLE_DIAG318 if the
> >>>>>>> guest just executed the diag 318 instruction.
> >>>>>>>
> >>>>>>> And you need the kvm_s390_vm_get/set_misc functions anyway, so these
> >>>>>>> could also be simply used by the diag 318 handler in userspace?  
> >>
> >> Pardon my ignorance, but I do not think I fully understand what exactly
> >> should be dropped in favor of doing things in userspace.
> >>
> >> My assumption: if a diag handler is not found in KVM, then we
> >> fallthrough to userspace handling?  
> > 
> > Right, if you simply omit this change to diag.c, the default case
> > returns -EOPNOTSUPP which then should cause an exit to userspace. You
> > can then add the code in QEMU to handle_diag() in target/s390x/kvm.c
> > instead.
> > 
> >  Thomas
> >   
> 
> Very cool! Okay, I think this makes sense, then. I'll look into this.
> Thanks for the tip.
> 
> @Conny, I assume this is what you meant as well? If so, ignore my
> response I sent earlier :)
> 

Yes; if done correctly, it should be easy to hack something up for tcg
as well, if we want it.

