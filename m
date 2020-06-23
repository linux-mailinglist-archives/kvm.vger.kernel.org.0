Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017E9204D31
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 10:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731786AbgFWI62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 04:58:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32502 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731158AbgFWI61 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 04:58:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592902705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=9KqTHczwitwsDmQMmizRhopAA0XrT1pemLfi2ghMEbY=;
        b=GT7vdWBKdVX5YXGqsvq8ZnY0VNKRKmq8Aot7HLCq961KcmiDO+W9EwNac+pVDK5u8UbbFZ
        MZHJXCJbuOOSkO3Zhsq5XiyZYKrHHmeQGZLuQKZBo6KrSLgVkYU7ZXSM15g8P4cGJze7v7
        yhPfVuiRTvVnYnx1Jfe2pnYeH7fuNfg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-wGMApQJEN0qCHeOdaOEDHw-1; Tue, 23 Jun 2020 04:58:23 -0400
X-MC-Unique: wGMApQJEN0qCHeOdaOEDHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D8A6804001;
        Tue, 23 Jun 2020 08:58:22 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C638876114;
        Tue, 23 Jun 2020 08:58:16 +0000 (UTC)
Subject: Re: [PATCH v9 2/2] s390/kvm: diagnose 0x318 sync and reset
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20200622154636.5499-1-walling@linux.ibm.com>
 <20200622154636.5499-3-walling@linux.ibm.com>
 <06bd4fde-ecdb-0795-bcab-e8f5fbabcd14@redhat.com>
 <4387834c-7cd4-df50-294c-4f56aa14a089@de.ibm.com>
 <a1bcfa5a-368a-cdef-9681-aff2deee2a42@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a90f723d-d425-5b3d-d87b-e124a6b55db6@redhat.com>
Date:   Tue, 23 Jun 2020 10:58:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a1bcfa5a-368a-cdef-9681-aff2deee2a42@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/2020 10.47, Christian Borntraeger wrote:
> 
> 
> On 23.06.20 10:45, Christian Borntraeger wrote:
>>
>>
>> On 23.06.20 10:42, Thomas Huth wrote:
>>> On 22/06/2020 17.46, Collin Walling wrote:
>>>> DIAGNOSE 0x318 (diag318) sets information regarding the environment
>>>> the VM is running in (Linux, z/VM, etc) and is observed via
>>>> firmware/service events.
>>>>
>>>> This is a privileged s390x instruction that must be intercepted by
>>>> SIE. Userspace handles the instruction as well as migration. Data
>>>> is communicated via VCPU register synchronization.
>>>>
>>>> The Control Program Name Code (CPNC) is stored in the SIE block. The
>>>> CPNC along with the Control Program Version Code (CPVC) are stored
>>>> in the kvm_vcpu_arch struct.
>>>>
>>>> This data is reset on load normal and clear resets.
>>>>
>>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>>>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  arch/s390/include/asm/kvm_host.h |  4 +++-
>>>>  arch/s390/include/uapi/asm/kvm.h |  5 ++++-
>>>>  arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
>>>>  arch/s390/kvm/vsie.c             |  1 +
>>>>  include/uapi/linux/kvm.h         |  1 +
>>>>  5 files changed, 19 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>>> index 3d554887794e..8bdf6f1607ca 100644
>>>> --- a/arch/s390/include/asm/kvm_host.h
>>>> +++ b/arch/s390/include/asm/kvm_host.h
>>>> @@ -260,7 +260,8 @@ struct kvm_s390_sie_block {
>>>>  	__u32	scaol;			/* 0x0064 */
>>>>  	__u8	sdf;			/* 0x0068 */
>>>>  	__u8    epdx;			/* 0x0069 */
>>>> -	__u8    reserved6a[2];		/* 0x006a */
>>>> +	__u8	cpnc;			/* 0x006a */
>>>> +	__u8	reserved6b;		/* 0x006b */
>>>>  	__u32	todpr;			/* 0x006c */
>>>>  #define GISA_FORMAT1 0x00000001
>>>>  	__u32	gd;			/* 0x0070 */
>>>> @@ -745,6 +746,7 @@ struct kvm_vcpu_arch {
>>>>  	bool gs_enabled;
>>>>  	bool skey_enabled;
>>>>  	struct kvm_s390_pv_vcpu pv;
>>>> +	union diag318_info diag318_info;
>>>>  };
>>>>  
>>>>  struct kvm_vm_stat {
>>>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>>>> index 436ec7636927..2ae1b660086c 100644
>>>> --- a/arch/s390/include/uapi/asm/kvm.h
>>>> +++ b/arch/s390/include/uapi/asm/kvm.h
>>>> @@ -231,11 +231,13 @@ struct kvm_guest_debug_arch {
>>>>  #define KVM_SYNC_GSCB   (1UL << 9)
>>>>  #define KVM_SYNC_BPBC   (1UL << 10)
>>>>  #define KVM_SYNC_ETOKEN (1UL << 11)
>>>> +#define KVM_SYNC_DIAG318 (1UL << 12)
>>>>  
>>>>  #define KVM_SYNC_S390_VALID_FIELDS \
>>>>  	(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
>>>>  	 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | \
>>>> -	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
>>>> +	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN | \
>>>> +	 KVM_SYNC_DIAG318)
>>>>  
>>>>  /* length and alignment of the sdnx as a power of two */
>>>>  #define SDNXC 8
>>>> @@ -254,6 +256,7 @@ struct kvm_sync_regs {
>>>>  	__u64 pft;	/* pfault token [PFAULT] */
>>>>  	__u64 pfs;	/* pfault select [PFAULT] */
>>>>  	__u64 pfc;	/* pfault compare [PFAULT] */
>>>> +	__u64 diag318;	/* diagnose 0x318 info */
>>>>  	union {
>>>>  		__u64 vrs[32][2];	/* vector registers (KVM_SYNC_VRS) */
>>>>  		__u64 fprs[16];		/* fp registers (KVM_SYNC_FPRS) */
>>>
>>> It's been a while since I touched kvm_sync_regs the last time ... but
>>> can your really extend this structure right in the middle without
>>> breaking older user spaces (ie. QEMUs) ? This is a uapi header ... so I
>>> think you rather have to add this add the end or e.g. put it into the
>>> padding2 region or something like that...? Or do I miss something?
>>
>> Argh. You are right. It should go to the end and not in the middle. Will fixup.
>>
> 
> Something like this on top. 
> 
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index 2ae1b660086c..7a6b14874d65 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -256,7 +256,6 @@ struct kvm_sync_regs {
>         __u64 pft;      /* pfault token [PFAULT] */
>         __u64 pfs;      /* pfault select [PFAULT] */
>         __u64 pfc;      /* pfault compare [PFAULT] */
> -       __u64 diag318;  /* diagnose 0x318 info */
>         union {
>                 __u64 vrs[32][2];       /* vector registers (KVM_SYNC_VRS) */
>                 __u64 fprs[16];         /* fp registers (KVM_SYNC_FPRS) */
> @@ -267,7 +266,8 @@ struct kvm_sync_regs {
>         __u8 reserved2 : 7;
>         __u8 padding1[51];      /* riccb needs to be 64byte aligned */
>         __u8 riccb[64];         /* runtime instrumentation controls block */
> -       __u8 padding2[192];     /* sdnx needs to be 256byte aligned */
> +       __u64 diag318;          /* diagnose 0x318 info */
> +       __u8 padding2[184];     /* sdnx needs to be 256byte aligned */
>         union {
>                 __u8 sdnx[SDNXL];  /* state description annex */
>                 struct {

Ack!

 Thomas

