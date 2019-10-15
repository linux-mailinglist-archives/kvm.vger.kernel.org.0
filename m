Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B59D7191
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 10:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfJOIui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 04:50:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:54791 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbfJOIui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 04:50:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 01:50:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,298,1566889200"; 
   d="scan'208";a="225353910"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga002.fm.intel.com with ESMTP; 15 Oct 2019 01:50:35 -0700
Date:   Tue, 15 Oct 2019 16:53:40 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Subject: Re: [PATCH v5 1/9] Documentation: Introduce EPT based Subpage
 Protection
Message-ID: <20191015085340.GA5118@local-michael-cet-test>
References: <20190917085304.16987-1-weijiang.yang@intel.com>
 <20190917085304.16987-2-weijiang.yang@intel.com>
 <CALMp9eT+P5QTGy=LfZzMozkTC7jdEhbupbfza2tTE3U1grtZkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eT+P5QTGy=LfZzMozkTC7jdEhbupbfza2tTE3U1grtZkQ@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 11, 2019 at 01:31:08PM -0700, Jim Mattson wrote:
> On Tue, Sep 17, 2019 at 1:52 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > Co-developed-by: yi.z.zhang@linux.intel.com
> > Signed-off-by: yi.z.zhang@linux.intel.com
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  Documentation/virtual/kvm/spp_kvm.txt | 178 ++++++++++++++++++++++++++
> >  1 file changed, 178 insertions(+)
> >  create mode 100644 Documentation/virtual/kvm/spp_kvm.txt
> >
> > diff --git a/Documentation/virtual/kvm/spp_kvm.txt b/Documentation/virtual/kvm/spp_kvm.txt
> > new file mode 100644
> > index 000000000000..1bd1c11d0a99
> > --- /dev/null
> > +++ b/Documentation/virtual/kvm/spp_kvm.txt
> > @@ -0,0 +1,178 @@
> > +EPT-Based Sub-Page Protection (SPP) for KVM
> > +====================================================
> > +
> > +1.Overview
> > +  EPT-based Sub-Page Protection(SPP) allows VMM to specify
> > +  fine-grained(128byte per sub-page) write-protection for guest physical
> > +  memory. When it's enabled, the CPU enforces write-access permission
> > +  for the sub-pages within a 4KB page, if corresponding bit is set in
> > +  permission vector, write to sub-page region is allowed, otherwise,
> > +  it's prevented with a EPT violation.
> > +
> > +  *Note*: In current implementation, SPP is exclusive with nested flag,
> > +  if it's on, SPP feature won't work.
> > +
> > +2.SPP Operation
> > +  Sub-Page Protection Table (SPPT) is introduced to manage sub-page
> > +  write-access permission.
> > +
> > +  It is active when:
> > +  a) nested flag is turned off.
> > +  b) "sub-page write protection" VM-execution control is 1.
> > +  c) SPP is initialized with KVM_INIT_SPP ioctl.
> > +  d) Sub-page permissions are set with KVM_SUBPAGES_SET_ACCESS ioctl.
> > +     see below sections for details.
> > +
> > +  __________________________________________________________________________
> > +
> > +  How SPP hardware works:
> > +  __________________________________________________________________________
> > +
> > +  Guest write access --> GPA --> Walk EPT --> EPT leaf entry -----|
> > +  |---------------------------------------------------------------|
> > +  |-> if VMexec_control.spp && ept_leaf_entry.spp_bit (bit 61)
> > +       |
> > +       |-> <false> --> EPT legacy behavior
> > +       |
> > +       |
> > +       |-> <true>  --> if ept_leaf_entry.writable
> > +                        |
> > +                        |-> <true>  --> Ignore SPP
> > +                        |
> > +                        |-> <false> --> GPA --> Walk SPP 4-level table--|
> > +                                                                        |
> > +  |------------<----------get-the-SPPT-point-from-VMCS-filed-----<------|
> /filed/field/
> > +  |
> > +  Walk SPP L4E table
> > +  |
> > +  |---> if-entry-misconfiguration ------------>-------|-------<---------|
> > +   |                                                  |                 |
> > +  else                                                |                 |
> > +   |                                                  |                 |
> > +   |   |------------------SPP VMexit<-----------------|                 |
> > +   |   |                                                                |
> > +   |   |-> exit_qualification & sppt_misconfig --> sppt misconfig       |
> > +   |   |                                                                |
> > +   |   |-> exit_qualification & sppt_miss --> sppt miss                 |
> > +   |---|                                                                |
> > +       |                                                                |
> > +  walk SPPT L3E--|--> if-entry-misconfiguration------------>------------|
> > +                 |                                                      |
> > +                else                                                    |
> > +                 |                                                      |
> > +                 |                                                      |
> > +          walk SPPT L2E --|--> if-entry-misconfiguration-------->-------|
> > +                          |                                             |
> > +                         else                                           |
> > +                          |                                             |
> > +                          |                                             |
> > +                   walk SPPT L1E --|-> if-entry-misconfiguration--->----|
> > +                                   |
> > +                                 else
> > +                                   |
> > +                                   |-> if sub-page writable
> > +                                   |-> <true>  allow, write access
> > +                                   |-> <false> disallow, EPT violation
> > +  ______________________________________________________________________________
> > +
> > +3.IOCTL Interfaces
> > +
> > +    KVM_INIT_SPP:
> > +    Allocate storage for sub-page permission vectors and SPPT root page.
> > +
> > +    KVM_SUBPAGES_GET_ACCESS:
> > +    Get sub-page write permission vectors for given continuous guest pages.
> /continuous/contiguous/
Thanks for all the corrections.

> > +
> > +    KVM_SUBPAGES_SET_ACCESS
> > +    Set SPP bit in EPT leaf entries for given continuous guest pages. The
> /continuous/contiguous/
> > +    actual SPPT setup is triggered when SPP miss vm-exit is handled.
> > +
> > +    /* for KVM_SUBPAGES_GET_ACCESS and KVM_SUBPAGES_SET_ACCESS */
> > +    struct kvm_subpage_info {
> > +       __u64 gfn; /* the first page gfn of the continuous pages */
> /continuous/contiguous/
> > +       __u64 npages; /* number of 4K pages */
> > +       __u64 *access_map; /* sub-page write-access bitmap array */
> > +    };
> > +
> > +    #define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, __u64)
> > +    #define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, __u64)
> > +    #define KVM_INIT_SPP              _IOW(KVMIO,  0x4b, __u64)
> 
> The ioctls should be documented in api.txt.
>
Sure, will do it.

> > +4.Set Sub-Page Permission
> > +
> > +  * To enable SPP protection, system admin sets sub-page permission via
> Why system admin? Can't any kvm user do this?
Oops, will change it.

> > +    KVM_SUBPAGES_SET_ACCESS ioctl:
> > +    (1) It first stores the access permissions in bitmap array.
> > +
> > +    (2) Then, if the target 4KB page is mapped as PT_PAGE_TABLE_LEVEL entry in EPT,
> /page is/pages are/
> > +       it sets SPP bit of the corresponding entry to mark sub-page protection.
> > +       If the 4KB page is mapped as PT_DIRECTORY_LEVEL or PT_PDPE_LEVEL, it
> /page is/pages are/
> > +       zapps the hugepage entry and let following memroy access to trigger EPT
> /zapps/zaps/, /entry/enttries/, /memroy/memory/
> > +       page fault, there the gfn is check against SPP permission bitmap and
> /page fault/violation/
> > +       proper level is selected to set up EPT entry.
> > +
> > +
> > +   The SPPT paging structure format is as below:
> > +
> > +   Format of the SPPT L4E, L3E, L2E:
> > +   | Bit    | Contents                                                                 |
> > +   | :----- | :------------------------------------------------------------------------|
> > +   | 0      | Valid entry when set; indicates whether the entry is present             |
> > +   | 11:1   | Reserved (0)                                                             |
> > +   | N-1:12 | Physical address of 4KB aligned SPPT LX-1 Table referenced by this entry |
> > +   | 51:N   | Reserved (0)                                                             |
> > +   | 63:52  | Reserved (0)                                                             |
> > +   Note: N is the physical address width supported by the processor. X is the page level
> > +
> > +   Format of the SPPT L1E:
> > +   | Bit   | Contents                                                          |
> > +   | :---- | :---------------------------------------------------------------- |
> > +   | 0+2i  | Write permission for i-th 128 byte sub-page region.               |
> > +   | 1+2i  | Reserved (0).                                                     |
> > +   Note: 0<=i<=31
> > +
> > +5.SPPT-induced VM exit
> > +
> > +  * SPPT miss and misconfiguration induced VM exit
> > +
> > +    A SPPT missing VM exit occurs when walk the SPPT, there is no SPPT
> > +    misconfiguration but a paging-structure entry is not
> > +    present in any of L4E/L3E/L2E entries.
> > +
> > +    A SPPT misconfiguration VM exit occurs when reserved bits or unsupported values
> > +    are set in SPPT entry.
> > +
> > +    *NOTE* SPPT miss and SPPT misconfigurations can occur only due to an
> > +    attempt to write memory with a guest physical address.
> 
> Can you clarify what this means? For instance, setting an A or D bit
> in a PTE is an attempt to "write memory with a guest physical
> address," but per the SDM, it is not an operation that is eligible for
> sub-page write permissions.

Yep, should be "memory write mapped by EPT leaf entry and guarded by SPP". thanks!
> 
> > +  * SPP permission induced VM exit
> > +    SPP sub-page permission induced violation is reported as EPT violation
> > +    thesefore causes VM exit.
> /thesefore/therefore/
> 
> > +
> > +6.SPPT-induced VM exit handling
> > +
> > +  #define EXIT_REASON_SPP                 66
> > +
> > +  static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
> > +    ...
> > +    [EXIT_REASON_SPP]                     = handle_spp,
> > +    ...
> > +  };
> > +
> > +  New exit qualification for SPPT-induced vmexits.
> > +
> > +  | Bit   | Contents                                                          |
> > +  | :---- | :---------------------------------------------------------------- |
> > +  | 10:0  | Reserved (0).                                                     |
> > +  | 11    | SPPT VM exit type. Set for SPPT Miss, cleared for SPPT Misconfig. |
> > +  | 12    | NMI unblocking due to IRET                                        |
> > +  | 63:13 | Reserved (0)                                                      |
> > +
> > +  In addition to the exit qualification, guest linear address and guest
> > +  physical address fields will be reported.
> > +
> > +  * SPPT miss and misconfiguration induced VM exit
> > +    Set up SPPT entries correctly.
> > +
> > +  * SPP permission induced VM exit
> > +    This kind of VM exit is left to VMI tool to handle.
> > --
> > 2.17.2
> >
