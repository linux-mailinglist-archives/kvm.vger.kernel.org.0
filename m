Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70417154714
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgBFPH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:07:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35074 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727471AbgBFPH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 10:07:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581001646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=w8LCVij5aCyJSkt/QR0vnlKrFDhq1pjSbm143liEdmI=;
        b=K2P5vC05cwRedolRYUV5kULws932luyGmsNgMCjYhhnG+5p7BwAegHZk7NlfTHnBV4e1kU
        pMPjJUDRngAxew9K1AKp8sRB1sRauB2Z9po70lZqtjuAEgAcLXmYucSNzA66IZIACvoGOR
        DPCCL5esOGfJXBNHpIeRxkGwPv5JfgE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-mjsu103nNiejqxVOktU06Q-1; Thu, 06 Feb 2020 10:07:21 -0500
X-MC-Unique: mjsu103nNiejqxVOktU06Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 626952EDD;
        Thu,  6 Feb 2020 15:07:20 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-151.ams2.redhat.com [10.36.116.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D19015DA7D;
        Thu,  6 Feb 2020 15:07:15 +0000 (UTC)
Subject: Re: [RFCv2 37/37] KVM: s390: protvirt: Add UV cpu reset calls
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-38-borntraeger@de.ibm.com>
 <d8038c68-40d6-c82a-bce9-1b867f629d74@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2e4f9a1b-d6c8-70cd-3b38-78446762459f@redhat.com>
Date:   Thu, 6 Feb 2020 16:07:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d8038c68-40d6-c82a-bce9-1b867f629d74@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/02/2020 15.39, David Hildenbrand wrote:
> On 03.02.20 14:19, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> For protected VMs, the VCPU resets are done by the Ultravisor, as KVM
>> has no access to the VCPU registers.
>>
>> As the Ultravisor will only accept a call for the reset that is
>> needed, we need to fence the UV calls when chaining resets.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/kvm/kvm-s390.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 3e4716b3fc02..f7a3f84be064 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -4699,6 +4699,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>  	void __user *argp = (void __user *)arg;
>>  	int idx;
>>  	long r;
>> +	u32 ret;
>>  
>>  	vcpu_load(vcpu);
>>  
>> @@ -4720,14 +4721,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>  	case KVM_S390_CLEAR_RESET:
>>  		r = 0;
>>  		kvm_arch_vcpu_ioctl_clear_reset(vcpu);
>> +		if (kvm_s390_pv_handle_cpu(vcpu)) {
>> +			r = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
>> +					  UVC_CMD_CPU_RESET_CLEAR, &ret);
>> +			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET CLEAR VCPU: cpu %d rc %x rrc %x",
>> +				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
>> +		}
>>  		break;
>>  	case KVM_S390_INITIAL_RESET:
>>  		r = 0;
>>  		kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>> +		if (kvm_s390_pv_handle_cpu(vcpu)) {
>> +			r = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
>> +					  UVC_CMD_CPU_RESET_INITIAL,
>> +					  &ret);
>> +			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET INITIAL VCPU: cpu %d rc %x rrc %x",
>> +				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
>> +		}
>>  		break;
>>  	case KVM_S390_NORMAL_RESET:
>>  		r = 0;
>>  		kvm_arch_vcpu_ioctl_normal_reset(vcpu);
>> +		if (kvm_s390_pv_handle_cpu(vcpu)) {
>> +			r = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
>> +					  UVC_CMD_CPU_RESET, &ret);
>> +			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET NORMAL VCPU: cpu %d rc %x rrc %x",
>> +				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
>> +		}
>>  		break;
>>  	case KVM_SET_ONE_REG:
>>  	case KVM_GET_ONE_REG: {
>>
> 
> Any reason why to not put that into the actual kvm_arch_vcpu_ioctl_*
> functions?

Because they are chained and you must not chain the UV calls.

 Thomas

