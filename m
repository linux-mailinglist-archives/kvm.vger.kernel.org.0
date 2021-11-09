Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FE544A6FC
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 07:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbhKIGpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 01:45:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:8779 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhKIGpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 01:45:50 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="232233343"
X-IronPort-AV: E=Sophos;i="5.87,219,1631602800"; 
   d="scan'208";a="232233343"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:43:05 -0800
X-IronPort-AV: E=Sophos;i="5.87,219,1631602800"; 
   d="scan'208";a="451769174"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.2.71]) ([10.238.2.71])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:43:00 -0800
Message-ID: <0adf7bec-2b99-99fc-e5e6-e7f393cdbd94@intel.com>
Date:   Tue, 9 Nov 2021 14:42:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH v5 5/7] KVM: MMU: Add support for PKS emulation
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
 <20210811101126.8973-6-chenyi.qiang@intel.com> <YYl+k3VbEieh9X2H@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YYl+k3VbEieh9X2H@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/9/2021 3:46 AM, Sean Christopherson wrote:
> On Wed, Aug 11, 2021, Chenyi Qiang wrote:
>>   * In particular the following conditions come from the error code, the
>>   * page tables and the machine state:
>> -* - PK is always zero unless CR4.PKE=1 and EFER.LMA=1
>> +* - PK is always zero unless CR4.PKE=1/CR4.PKS=1 and EFER.LMA=1
>>   * - PK is always zero if RSVD=1 (reserved bit set) or F=1 (instruction fetch)
>> -* - PK is always zero if U=0 in the page tables
>> -* - PKRU.WD is ignored if CR0.WP=0 and the access is a supervisor access.
>> +* - PK is always zero if
>> +*       - U=0 in the page tables and CR4.PKS=0
>> +*       - U=1 in the page tables and CR4.PKU=0
> 
> I think it makes sense to completely rewrite this "table" or drop it altogether.
> The "always zero" wording is nonsensical when there are multiple conditions for
> "always".  And IMO the whole "PK is ... zero" thing is a bit awkward because it
> leaves the uninitiated wondering what PK=0 even means ('1' == disabled is not the
> most intuitive thing since most PTE bits are '1' = allowed).  Ugh, and re-reading
> with context, that's not even what "PK" means here, this is actually referring to
> PFEC.PK, which is all kinds of confusing because PFEC.PK is merely a "symptom" of
> a #PF to due a protection key violation, not the other way 'round.
> 
> IMO this entire comment could use a good overhaul.  It never explicitly documents
> the "access-disable" and "write-disable" behavior.  More below.
> 
>> +* - (PKRU/PKRS).WD is ignored if CR0.WP=0 and the access is a supervisor access.
> 
> Hrm.  The SDM contradicts itself.
> 
> Section 4.6.1 "Determination of Access Rights" says this for supervisor-mode accesses:
> 
>    If CR0.WP = 0, data may be written to any supervisor-mode address with a protection
>    key for which write access is permitted.
> 
> but section 4.6.2 "Protection Keys" says:
> 
>    If WDi = 1, write accesses are not permitted if CR0.WP = 1. (If CR0.WP = 0,
>    IA32_PKRS.WDi does not affect write accesses to supervisor-mode addresses with
>    protection key i.)
> 
> I believe 4.6.1 is subtly wrong and should be "data access", not "write access".
> 
>    If CR0.WP = 0, data may be written to any supervisor-mode address with a protection
>    key for which data access is permitted.
>                  ^^^^
> 
> Can you follow-up with someone to get the SDM fixed?  This stuff is subtle and
> confusing enough as it is :-)
> 

Nice catch. I'll mention it internally to fix it.

> And on a very related topic, it would be helpful to clarify user-mode vs. supervisor-mode
> and access vs. address.
> 
> How about this for a comment?
> 
> /*
>   * Protection Key Rights (PKR) is an additional mechanism by which data accesses
>   * with 4-level or 5-level paging (EFER.LMA=1) may be disabled based on the
>   * Protection Key Rights Userspace (PRKU) or Protection Key Rights Supervisor
>   * (PKRS) registers.  The Protection Key (PK) used for an access is a 4-bit
>   * value specified in bits 62:59 of the leaf PTE used to translate the address.
>   *
>   * PKRU and PKRS are 32-bit registers, with 16 2-bit entries consisting of an
>   * access-disable (AD) and write-disable (WD) bit.  The PK from the leaf PTE is
>   * used to index the approriate PKR (see below), e.g. PK=1 would consume bits
>   * 3:2 (bit 3 == write-disable, bit 2 == access-disable).
>   *
>   * The PK register (PKRU vs. PKRS) indexed by the PK depends on the type of
>   * _address_ (not access type!).  For a user-mode address, PKRU is used; for a
>   * supervisor-mode address, PKRS is used.  An address is supervisor-mode if the
>   * U/S flag (bit 2) is 0 in at least one of the paging-structure entries, i.e.
>   * an address is user-mode if the U/S flag is 0 in _all_ entries.  Again, this
>   * is the address type, not the the access type, e.g. a supervisor-mode _access_
>   * will consume PKRU if the _address_ is a user-mode address.
>   *
>   * As alluded to above, PKR checks are only performed for data accesses; code
>   * fetches are not subject to PKR checks.  Terminal page faults (!PRESENT or
>   * PFEC.RSVD=1) are also not subject to PKR checks.
>   *
>   * PKR write-disable checks for superivsor-mode _accesses_ are performed if and
>   * only if CR0.WP=1 (though access-disable checks still apply).
>   *
>   * In summary, PKR checks are based on (a) EFER.LMA, (b) CR4.PKE or CR4.PKS,
>   * (c) CR4.WP, (d) the PK in the leaf PTE, (e) two bits from the corresponding
>   * PKR{S,U} entry, (f) the access type (derived from the other PFEC bits), and
>   * (g) the address type (retrieved from the paging-structure entries).
>   *
>   * To avoid conditional branches in permission_fault(), the PKR bitmask caches
>   * the above inputs, except for (e) the PKR{S,U} entry.  The FETCH, USER, and
>   * WRITE bits of the PFEC and the effective value of the paging-structures' U/S
>   * bit (slotted into the PFEC.RSVD position, bit 3) are used to index into the
>   * PKR bitmask (similar to the 4-bit Protection Key itself).  The two bits of
>   * the PKR bitmask "entry" are then extracted and ANDed with the two bits of
>   * the PKR{S,U{} register corresponding to the address type and protection key.
>   *
>   * E.g. for all values where PFEC.FETCH=1, the corresponding pkr_bitmask bits
>   * will be 00b, thus masking away the AD and WD bits from the PKR{S,U} register
>   * to suppress PKR checks on code fetches.
> */

Very clear comment. I'll clean it up and change in next version.

> 
