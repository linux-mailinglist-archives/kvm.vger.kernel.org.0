Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7492D9AA2
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 16:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436639AbgLNPOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 10:14:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgLNPO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 10:14:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEF9uJk062324;
        Mon, 14 Dec 2020 15:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0jS216xXTBEY5Q6yebI+reVK1IbA6YLaGXkggeKiIZQ=;
 b=UCiWd2G/7MjGIQI0VnvHNBfnks65vnxEkueEfvqP1D8Fn932vKVPDt0bDAB2Diam22qS
 qAJMzvPJCTMSPVeaE/5tIHViokMspGZZkFwzb/e/4EXtlqjws3Tx0bHHCXGPbTp9bh+1
 w6ETn7xB2uqGpaF1m6sQnBKYa/OQox2ohNi0DFstwwh5Keib31OZ66iQoOJmh8eVKrzT
 g92us9ZNB0nIpJeGAAAxxK/q6sNpTKH3YYNHik6h0wbPGdCtVdqz/jX8DW2av5aspK40
 wKNr0d0Sm9InGSqs97WoSjfTTJaW/dYh1bhQE5KIMsZ5qJSAmqeKAl5slbTEb+RE0JzT RA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35cntkwmy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 15:13:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEFB8Wm037243;
        Mon, 14 Dec 2020 15:13:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35d7ekmfhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 15:13:33 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEFDShx025931;
        Mon, 14 Dec 2020 15:13:28 GMT
Received: from [10.175.173.239] (/10.175.173.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 07:13:28 -0800
Subject: Re: [PATCH v3 17/17] KVM: x86/xen: Add event channel interrupt vector
 upcall
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, kvm@vger.kernel.org
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-18-dwmw2@infradead.org>
 <3917aa37-ed00-9350-1ba5-c3390be6b500@oracle.com>
 <69daac6166942fa75db068b57e2f1a382a0753fe.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <accc4578-436e-cb6a-6bce-3261f0a0b409@oracle.com>
Date:   Mon, 14 Dec 2020 15:13:23 +0000
MIME-Version: 1.0
In-Reply-To: <69daac6166942fa75db068b57e2f1a382a0753fe.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 2:57 PM, David Woodhouse wrote:
> On Mon, 2020-12-14 at 13:19 +0000, Joao Martins wrote:
>> But I think there's a flaw here. That is handling the case where you don't have a
>> vcpu_info registered, and only shared info. The vcpu_info is then placed elsewhere, i.e.
>> another offset out of shared_info -- which is *I think* the case for PVHVM Windows guests.
> 
> There is no such case any more. In my v3 patch set I *stopped* the
> kernel from attempting to use the vcpu_info embedded in the shinfo, and
> went to *requiring* that the VMM explicitly tell the kernel where it
> is.
> 
Sigh yes, I forgot about that -- and you did mentioned it in earlier posts.

> $ git diff xenpv-post-2..xenpv-post-3 -- Documentation
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d98c2ff90880..d1c30105e6fd 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4834,7 +4834,7 @@ experience inconsistent filtering behavior on MSR accesses.
>                         __u64 gfn;
>                 } shared_info;
>                 struct {
> -                       __u32 vcpu;
> +                       __u32 vcpu_id;
>                         __u64 gpa;
>                 } vcpu_attr;
>                 __u64 pad[4];
> @@ -4849,9 +4849,13 @@ KVM_XEN_ATTR_TYPE_LONG_MODE
>  
>  KVM_XEN_ATTR_TYPE_SHARED_INFO
>    Sets the guest physical frame number at which the Xen "shared info"
> -  page resides. It is the default location for the vcpu_info for the
> -  first 32 vCPUs, and contains other VM-wide data structures shared
> -  between the VM and the host.
> +  page resides. Note that although Xen places vcpu_info for the first
> +  32 vCPUs in the shared_info page, KVM does not automatically do so
> +  and requires that KVM_XEN_ATTR_TYPE_VCPU_INFO be used explicitly
> +  even when the vcpu_info for a given vCPU resides at the "default"
> +  location in the shared_info page. This is because KVM is not aware
> +  of the Xen CPU id which is used as the index into the vcpu_info[]
> +  array, so cannot know the correct default location.
>  
/me nods

>  KVM_XEN_ATTR_TYPE_VCPU_INFO
>    Sets the guest physical address of the vcpu_info for a given vCPU.
> 
>> Perhaps introducing a helper which adds xen_vcpu_info() and returns you the hva (picking
>> the right cache) similar to the RFC patch. Albeit that was with page pinning, but
>> borrowing an older version I had with hva_to_gfn_cache incantation would probably look like:
>>
>>
>>         if (v->arch.xen.vcpu_info_set) {
>>                 ghc = &v->arch.xen.vcpu_info_cache;
>>         } else {
>>                 ghc = &v->arch.xen.vcpu_info_cache;
>>                 offset += offsetof(struct shared_info, vcpu_info);
>>                 offset += (v - kvm_get_vcpu_by_id(0)) * sizeof(struct vcpu_info);
>>         }
> 
> The problem is that we *can't* just use shared_info->vcpu_info[N]
> because we don't know what N is.
> 
> This is what I spent half of last week chasing down, because whatever I
> tried, the original version just ended up delivering interrupts to the
> wrong CPUs.
> 
> The N we want there is actually the *XEN* vcpu_id, which Xen puts into
> CPUID leaf 0x40000004.ebx and which is also the ACPI ID. (Those two had
> better match up since Linux guests use CPUID 0x40000004 for the BSP and
> ACPI for the APs).
> 
> The kernel knows nothing of those numbers. In particular they do *not*
> match up to the indices in kvm->vcpus[M] (which is vcpu->vcpu_idx and
> means nothing except the chronological order in which each vCPU's
> userspace thread happened to create it during startup), and they do not
> match up to vcpu->vcpu_id which is the APIC (not ACPI) ID.
> 
> The kernel doesn't know. Let userspace tell it, since we already needed
> that API for the separate vcpu_info case anyway.
> 

All this time, I was only considering the guest hypercalls in XENMEM_populate_physmap()
for shared_info, and register vcpu_info as the VMM usage for setting the corresponding
attributes. So you register the vcpu_info regardless of guest placement, and I didn't
correlate that and your earlier comment (and also forgot about it) that you used to remove
that complexity.

	Joao
