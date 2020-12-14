Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAEE2D975D
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 12:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407668AbgLNLb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 06:31:27 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43530 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407650AbgLNLbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 06:31:10 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEBTu0t072962;
        Mon, 14 Dec 2020 11:30:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GzBilYAxAOnEjFtUNSYwMg6h9xoU9ni+coXKujVia28=;
 b=IAU6cUcxyRVTThOeXe+FbUoHH6DlwvGBfBVUAp9Q/TlQWtj5nGgYFCXg/9firYyutH/K
 8QbSbRsqCJRTc0yl+UV+L4wYEsrCFFPxoTOcgpf7Fs/8150H+v9OWPHHWrzXpmbi2Myl
 Hf4ba/G/KP1YSnMhwAoImaOYw4WYsz6lqwNu1IzzfE7obFG+HYCCjubLw+G06ffzpQO5
 qD/l00tioV4M0yYJunfKk9JKY+8SFyM/OXgdxGsk+gmt+LPtSHJO/RK9P6aGrCLluJLX
 XkH/X5d/LC2P5pkqG1c2fLVeIZQDz2DaJ0LWPpbjKy/e7vbeTQHgtuv0FSZQ95tQohjt Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcb4u8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 11:30:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEBPGkx139905;
        Mon, 14 Dec 2020 11:30:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35d7ekbmx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 11:30:21 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEBUKKm019935;
        Mon, 14 Dec 2020 11:30:20 GMT
Received: from [10.175.173.239] (/10.175.173.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 03:30:20 -0800
Subject: Re: [PATCH v3 08/17] KVM: x86/xen: register shared_info page
From:   Joao Martins <joao.m.martins@oracle.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, kvm@vger.kernel.org
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-9-dwmw2@infradead.org>
 <da2f8101-c318-d7e5-1e93-f9b99f1718dd@oracle.com>
Message-ID: <f965d9e5-3dae-afa7-d4ff-5177a13ea708@oracle.com>
Date:   Mon, 14 Dec 2020 11:30:16 +0000
MIME-Version: 1.0
In-Reply-To: <da2f8101-c318-d7e5-1e93-f9b99f1718dd@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 10:45 AM, Joao Martins wrote:
> On 12/14/20 8:38 AM, David Woodhouse wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>>
>> We add a new ioctl, XEN_HVM_SHARED_INFO, to allow hypervisor
>> to know where the guest's shared info page is.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  2 ++
>>  arch/x86/kvm/xen.c              | 27 +++++++++++++++++++++++++++
>>  arch/x86/kvm/xen.h              |  1 -
>>  include/uapi/linux/kvm.h        |  4 ++++
>>  4 files changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index c9a4feaee2e7..8bcd83dacf43 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -893,6 +893,8 @@ struct msr_bitmap_range {
>>  /* Xen emulation context */
>>  struct kvm_xen {
>>  	bool long_mode;
>> +	bool shinfo_set;
>> +	struct gfn_to_hva_cache shinfo_cache;
>>  };
>>  
>>  enum kvm_irqchip_mode {
>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>> index 52cb9e465542..9dd9c42842b8 100644
>> --- a/arch/x86/kvm/xen.c
>> +++ b/arch/x86/kvm/xen.c
>> @@ -13,9 +13,23 @@
>>  #include <linux/kvm_host.h>
>>  
>>  #include <trace/events/kvm.h>
>> +#include <xen/interface/xen.h>
>>  
>>  #include "trace.h"
>>  
>> +static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
>> +{
>> +	int ret;
>> +
>> +	ret = kvm_gfn_to_hva_cache_init(kvm, &kvm->arch.xen.shinfo_cache,
>> +					gfn_to_gpa(gfn), PAGE_SIZE);
>> +	if (ret)
>> +		return ret;
>> +
>> +	kvm->arch.xen.shinfo_set = true;
> 
> Can't you just use:
> 
> 	kvm->arch.xen.shinfo_cache.gpa
> 
> Rather than added a bool just to say you set a shinfo?
> 
Or maybe @len in case you want to consider @gpa = 0 as valid.

>> +	return 0;
>> +}
> 
> And then here you just return @ret while removing the other conditional.
> 
>> +
>>  int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>>  {
>>  	int r = -ENOENT;
>> @@ -28,6 +42,11 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>>  		kvm->arch.xen.long_mode = !!data->u.long_mode;
>>  		r = 0;
>>  		break;
>> +
>> +	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
>> +		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
>> +		break;
>> +
>>  	default:
>>  		break;
>>  	}
>> @@ -44,6 +63,14 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>>  		data->u.long_mode = kvm->arch.xen.long_mode;
>>  		r = 0;
>>  		break;
>> +
>> +	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
>> +		if (kvm->arch.xen.shinfo_set) {
>> +			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
>> +			r = 0;
>> +		}
>> +		break;
>> +
>>  	default:
>>  		break;
>>  	}
>> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
>> index cd3c52b62068..120b7450252a 100644
>> --- a/arch/x86/kvm/xen.h
>> +++ b/arch/x86/kvm/xen.h
>> @@ -13,7 +13,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
>>  int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
>>  int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
>>  int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data);
>> -void kvm_xen_destroy_vm(struct kvm *kvm);
>>  
> spurious deletion ?
> 
>>  static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
>>  {
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 6b556ef98b76..caa9faf3c5ad 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1585,11 +1585,15 @@ struct kvm_xen_hvm_attr {
>>  
>>  	union {
>>  		__u8 long_mode;
>> +		struct {
>> +			__u64 gfn;
>> +		} shared_info;
>>  		__u64 pad[4];
>>  	} u;
>>  };
>>  
>>  #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
>> +#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
>>  
>>  /* Secure Encrypted Virtualization command */
>>  enum sev_cmd_id {
>>
