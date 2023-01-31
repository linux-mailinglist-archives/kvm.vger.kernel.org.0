Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E64682EF8
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 15:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbjAaOPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 09:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjAaOPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 09:15:08 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D46E12843;
        Tue, 31 Jan 2023 06:15:07 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id 0A33C20EA201; Tue, 31 Jan 2023 06:15:07 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0A33C20EA201
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675174507;
        bh=mT19G71ucLF+4CaSTXOpXQE/L4+jsWO6AotXm3MMpfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f4of6yuJuqxU4bwC8lYZggOCEjPalaQPNsTBE3fhlgDrMgY+vtzzXGQlAff+wYAVQ
         mbZHxNBhfyk66pyhrYtonfjcK3mmagigi+pYRKBanuiMtQCkDmPuMUds8loo3afvqF
         C3+wntX9R8q9w9AwgdpOxAJU1QKzbRugpppPtnig=
Date:   Tue, 31 Jan 2023 06:15:07 -0800
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH RFC v7 07/64] KVM: SEV: Handle KVM_HC_MAP_GPA_RANGE
 hypercall
Message-ID: <20230131141506.GA14449@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-8-michael.roth@amd.com>
 <20230127163558.GA22533@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127163558.GA22533@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 08:35:58AM -0800, Jeremi Piotrowski wrote:
> On Wed, Dec 14, 2022 at 01:39:59PM -0600, Michael Roth wrote:
> > From: Nikunj A Dadhania <nikunj@amd.com>
> > 
> > KVM_HC_MAP_GPA_RANGE hypercall is used by the SEV guest to notify a
> > change in the page encryption status to the hypervisor.
> > 
> > The hypercall exits to userspace with KVM_EXIT_HYPERCALL exit code,
> > currently this is used for explicit memory conversion between
> > shared/private for memfd based private memory.
> > 
> > Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/kvm/x86.c  | 8 ++++++++
> >  virt/kvm/kvm_main.c | 1 +
> >  2 files changed, 9 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index bb6adb216054..732f9cbbadb5 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9649,6 +9649,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> 
> Couldn't find a better commit to comment on:
> when the guest has the ptp-kvm module, it will issue a KVM_HC_CLOCK_PAIRING
> hypercall. This will pass sev_es_validate_vmgexit validation and end up in this
> function where kvm_pv_clock_pairing() is called, and that calls
> kvm_write_guest(). This results in a CPU soft-lockup, at least in my testing.
> 
> Are there any emulated hypercalls that make sense for snp guests? We should
> block at least the ones that definitely don't work.
> 
> Jeremi

So turns out the soft-lockup is a nested issue (details here for those
interested: [^1]), but the questions still stands, of whether we should
block kvm_write_page (and similar) explicitly or rely on the rmp fault.

[^1]: https://github.com/jepio/linux/commit/6c3bdf552e93664ae172660e24ceceed60fd4df5
