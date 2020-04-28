Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3191BB76A
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgD1H0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:26:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35946 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgD1H0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:26:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03S7NCln132839;
        Tue, 28 Apr 2020 07:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fiEaYS+dS9oUABY28uymSGU/u4pwmRFH2xFAJ2AXoJY=;
 b=iaIBAxogjbbDzlAdDDV+7R42YefuPNtqXCrKkmg/WTYBB5M+oGeMeAyMN3rorryHZfcv
 +ZWEh1t4Osf9rX8ukdXsRb/EoB5TKjzW7njb1BC4mCJ7NhOZFFInUJlhEe5pSmGOaQav
 5LXold6aKYANKbUT0StdWItbEPkMr+q+xdWcy9HJK4I8dDdD77BVYjBfU0DTEzIfrMyD
 0v3qN3me7tIW378FHLeGo5HjnsBD7aRM0qpXVdjSMNVrBySnsdbCZlZUEA72f/J5fEtB
 8E1oGtFsn28HdpeyJAigyO35wfI/BiJ0mgjce5jHYtW+6PWwh3iezBQ2eTK0AUrC1lLc 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01nmgfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 07:26:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03S7MvWY123078;
        Tue, 28 Apr 2020 07:26:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30my0c4m6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 07:26:01 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03S7Q0sI009100;
        Tue, 28 Apr 2020 07:26:00 GMT
Received: from localhost.localdomain (/10.159.156.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 00:26:00 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted guest"
 VM-execution control in vmcs02 if vmcs12 doesn't set it
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com>
 <20200415193016.GF30627@linux.intel.com>
 <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
 <0b8bd238-e60f-b392-e793-0d88fb876224@redhat.com>
 <d49ce960-92f9-85eb-4cfb-d533a956223e@oracle.com>
 <20200418015545.GB15609@linux.intel.com>
 <c37b9429-0cb8-6514-44a7-65544873dba0@redhat.com>
Message-ID: <02a49d40-fe80-2715-d9a8-17770e72c7a3@oracle.com>
Date:   Tue, 28 Apr 2020 00:25:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <c37b9429-0cb8-6514-44a7-65544873dba0@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280063
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/18/20 2:53 AM, Paolo Bonzini wrote:
> On 18/04/20 03:55, Sean Christopherson wrote:
>>    static inline bool is_unrestricted_guest(struct kvm_vcpu *vcpu)
>>    {
>> 	return enable_unrestricted_guest && (!is_guest_mode(vcpu) ||
>> 	       to_vmx(vcpu)->nested.unrestricted_guest);
>>    }
>>
>> Putting the flag in loaded_vmcs might be more performant?  My guess is it'd
>> be in the noise, at which point I'd rather have it be clear the override is
>> only possible/necessary for nested guests.
> Even better: you can use secondary_exec_controls_get, which does get the
> flag from the loaded_vmcs :) but without actually having to add one.
>
>>> I also see that enable_ept controls the setting of
>>> enable_unrestricted_guest. Perhaps both need to be moved to loaded_vmcs ?
>> No, letting L1 disable EPT in L0 would be pure insanity, and the overall
>> paging mode of L2 is already reflected in the MMU.
> Absolutely.  Unrestricted guest requires EPT, but EPT is invisible to
> the guest.  (Currently EPT requires guest MAXPHYADDR = host MAXPHYADDR,
> in the sense that the guest can detect that the host is lying about
> MAXPHYADDR; but that is really a bug that I hope will be fixed in 5.8,
> relaxing the requirement to guest MAXPHYADDR <= host PHYADDR).


Should EPT for the nested guest be set up in the normal way (PML4E -> 
PDPTE-> PDE -> PTE) when GUEST_CR0.PE is zero ? Or does it have to be a 
special set up like only the PTEs are needed because no protection and 
no paging are used ?

> Paolo
>
>> The dependency on EPT is that VMX requires paging of some form and
>> unrestricted guest allows entering non-root with CR0.PG=0, i.e. requires EPT
>> be enabled.
