Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEED8151B2A
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 14:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgBDNWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 08:22:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28774 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727168AbgBDNWc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 08:22:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580822551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=SDsnJDDe0PAghrGpgHlP9D2+e+s13wJkTQUSl2vZphA=;
        b=MVZOxKMKyC8Y9DYVCDrmKva3dk/Y7sOZD9vSk5AiGUIiIJDRZLCwGSOPot1flYvmjDjAvZ
        BvkylirLby3Cc0FR8eccBZAxAR2ABGzLgks0sfMc0si7nkgHozLRp3t4H0nL/grP/zhTT0
        I4LEUxdnMPPTTRJsruPOuRzBbdGHNTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-YNyS8oJLNjGVjy608MkOzQ-1; Tue, 04 Feb 2020 08:22:27 -0500
X-MC-Unique: YNyS8oJLNjGVjy608MkOzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4593D8010F1;
        Tue,  4 Feb 2020 13:22:26 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA70360C05;
        Tue,  4 Feb 2020 13:22:14 +0000 (UTC)
Subject: Re: [RFCv2 06/37] s390: add (non)secure page access exceptions
 handlers
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-7-borntraeger@de.ibm.com>
 <dd3d333d-d141-5a22-9b1d-161232b37cfb@redhat.com>
 <20200204124123.183ef25b@p-imbrenda>
 <2362357d-f2b5-62f2-8cb1-b7e281ea66e2@redhat.com>
 <20200204140802.412605a4@p-imbrenda>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <18ce1ac3-9861-d761-52c5-6f90f8095101@redhat.com>
Date:   Tue, 4 Feb 2020 14:22:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200204140802.412605a4@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/2020 14.08, Claudio Imbrenda wrote:
> On Tue, 4 Feb 2020 13:48:47 +0100
> Thomas Huth <thuth@redhat.com> wrote:
> 
>> On 04/02/2020 12.41, Claudio Imbrenda wrote:
>>> On Tue, 4 Feb 2020 11:37:42 +0100
>>> Thomas Huth <thuth@redhat.com> wrote:
>>>
>>> [...]
>>>   
>>>>> ---
>>>>>  arch/s390/kernel/pgm_check.S |  4 +-
>>>>>  arch/s390/mm/fault.c         | 87
>>>>> ++++++++++++++++++++++++++++++++++++ 2 files changed, 89
>>>>> insertions(+), 2 deletions(-)    
>>>> [...]  
>>>>> +void do_non_secure_storage_access(struct pt_regs *regs)
>>>>> +{
>>>>> +	unsigned long gaddr = regs->int_parm_long &
>>>>> __FAIL_ADDR_MASK;
>>>>> +	struct gmap *gmap = (struct gmap *)S390_lowcore.gmap;
>>>>> +	struct uv_cb_cts uvcb = {
>>>>> +		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
>>>>> +		.header.len = sizeof(uvcb),
>>>>> +		.guest_handle = gmap->se_handle,
>>>>> +		.gaddr = gaddr,
>>>>> +	};
>>>>> +	int rc;
>>>>> +
>>>>> +	if (get_fault_type(regs) != GMAP_FAULT) {
>>>>> +		do_fault_error(regs, VM_READ | VM_WRITE,
>>>>> VM_FAULT_BADMAP);
>>>>> +		WARN_ON_ONCE(1);
>>>>> +		return;
>>>>> +	}
>>>>> +
>>>>> +	rc = uv_make_secure(gmap, gaddr, &uvcb, 0);
>>>>> +	if (rc == -EINVAL && uvcb.header.rc != 0x104)
>>>>> +		send_sig(SIGSEGV, current, 0);
>>>>> +}    
>>>>
>>>> What about the other rc beside 0x104 that could happen here? They
>>>> go unnoticed?  
>>>
>>> no, they are handled in the uv_make_secure, and return an
>>> appropriate error code.   
>> Hmm, in patch 05/37, I basically see:
>>
>> +static int make_secure_pte(pte_t *ptep, unsigned long addr, void
>> *data) +{
>> [...]
>> +	rc = uv_call(0, (u64)params->uvcb);
>> +	page_ref_unfreeze(page, expected);
>> +	if (rc)
>> +		rc = (params->uvcb->rc == 0x10a) ? -ENXIO : -EINVAL;
>> +	return rc;
>> +}
>>
>> +int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void
>> *uvcb, int pins)
>> +{
>> [...]
>> +	lock_page(params.page);
>> +	rc = apply_to_page_range(gmap->mm, uaddr, PAGE_SIZE,
>> make_secure_pte, &params);
>> +	unlock_page(params.page);
>> +out:
>> +	up_read(&gmap->mm->mmap_sem);
>> +
>> +	if (rc == -EBUSY) {
>> +		if (local_drain) {
>> +			lru_add_drain_all();
>> +			return -EAGAIN;
>> +		}
>> +		lru_add_drain();
>> +		local_drain = 1;
>> +		goto again;
>> +	} else if (rc == -ENXIO) {
>> +		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
>> +			return -EFAULT;
>> +		return -EAGAIN;
>> +	}
>> +	return rc;
>> +}
>>
>> So 0x10a result in -ENXIO and is handled ==> OK.
>> And 0x104 is handled in do_non_secure_storage_access ==> OK.
>>
>> But what about the other possible error codes? make_secure_pte()
>> returns -EINVAL in that case, but uv_make_secure() does not care
>> about that error code, and do_non_secure_storage_access() only cares
>> if uvcb.header.rc was 0x104 ... what did I miss?
> 
> basically, any error value that is not handled by uv_make_secure is
> passed as-is from make_secure_pte directly to the caller of
> uv_make_secure .
> any RC value that is not explicitly handled here will
> result in -EINVAL. The caller has then to check for -EINVAL and check
> the RC value, like do_non_secure_storage_access does.
> 
> so anything else that goes wrong is passed as-is to the caller.
> for some things, like interrupt handlers, we simply don't care; if we
> need to try again, we will try again, if we notice we can't continue,
> the VM will get killed.

In that case a comment in do_non_secure_storage_access() would be
helpful which states why we do not care about the other error codes in
uvcb.header.rc.

 Thomas

