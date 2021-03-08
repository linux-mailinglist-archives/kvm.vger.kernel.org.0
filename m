Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CDC3317CB
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 20:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCHTwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 14:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhCHTwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 14:52:05 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1D6C06175F
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 11:52:05 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y67so7948258pfb.2
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 11:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b2wArSXzT395pNKk6Jr954SMrsx7zhgrxhFUWKaRJ78=;
        b=qWXdkAbiQ0UwoAx16Z8eiy5IdsKgMtZ9jwc2TwBi7bb/CFTxSj0UkjNW8b/IsjRdRw
         9IsB3uTsL/iUZRYjiM9tare7JtPQyvg8aPNA+/giijaSr7oIOfwZpGjH1s0q7hK3FpgQ
         Vi2Cjg3l2vWyCNgWaquGwVy+sCGlVqgQmlehcgdDT3f52bagQoC/KlUj44UD2MNXa1s3
         IhIw6XKvwdxrNOLm/SMaJUyU8/bFgZ/4cTXHQcWv9UjP/ej31FrtQ4EtVJSucI/2toAv
         ECzXjM4RpWJhFbBJVsu8/8Nae6B3ORDaYpdoK1tizgEh7QlfMAOoEGsD6+xTRPy+6vLU
         NO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b2wArSXzT395pNKk6Jr954SMrsx7zhgrxhFUWKaRJ78=;
        b=bFZ+AwrHLhG7A5fegA5KEoHEebJe8PSmYefy8f/LGMiaIDkf9PcDwHbVAzLFNjKaww
         m4iBD9VJzyI8M9g4yeAUX9KKennhN8wsu6AdzETWwfW/5tx5zrpZyXexJaFgsZF9nsap
         MkT9dMijK5JtQu4OxarAFaapdiSsdL1iAuaFqZNK1JPzPa79XIWLlES/lwOuFit+Yi5X
         lZ6Q9GfQfKi31G2AWw0L2Mo9dWPBcz/FeQfKSRCAQAsG//RsyXCGKbnPJ1p9XdYXjRBy
         vWIR65rCVPC2NvkCyA5mKtA4sMbxuGj/65+TEMtFbDRSUCmedAEGny1tLV0c1QKX4rSN
         VJPw==
X-Gm-Message-State: AOAM530HTEZA0NA8KWOrYhhSzpObeFWldOah4z6DD0vWF5fl+6X3yyT/
        WZwi7CHkLyr+IL2Y8ZmZfaKP4w==
X-Google-Smtp-Source: ABdhPJx7H1YAdh8uqghqBhTP3S6mr1k+01XLN3c8TPwAWzGvFJRG1ff9G9wc40iqsQHk0lNQBuRaCg==
X-Received: by 2002:a05:6a00:158b:b029:1d1:f9c9:84ca with SMTP id u11-20020a056a00158bb02901d1f9c984camr23247820pfk.46.1615233124398;
        Mon, 08 Mar 2021 11:52:04 -0800 (PST)
Received: from google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
        by smtp.gmail.com with ESMTPSA id d20sm170314pjv.47.2021.03.08.11.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 11:52:03 -0800 (PST)
Date:   Mon, 8 Mar 2021 11:51:57 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <YEaAXXGZH0uSMA3v@google.com>
References: <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
 <20210308104014.GA5333@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308104014.GA5333@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021, Ashish Kalra wrote:
> On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> > +Will and Quentin (arm64)
> > 
> > Moving the non-KVM x86 folks to bcc, I don't they care about KVM details at this
> > point.
> > 
> > On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > Thanks for grabbing the data!
> > > > 
> > > > I am fine with both paths. Sean has stated an explicit desire for
> > > > hypercall exiting, so I think that would be the current consensus.
> > 
> > Yep, though it'd be good to get Paolo's input, too.
> > 
> > > > If we want to do hypercall exiting, this should be in a follow-up
> > > > series where we implement something more generic, e.g. a hypercall
> > > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > > exit route, we can drop the kvm side of the hypercall.
> > 
> > I don't think this is a good candidate for arbitrary hypercall interception.  Or
> > rather, I think hypercall interception should be an orthogonal implementation.
> > 
> > The guest, including guest firmware, needs to be aware that the hypercall is
> > supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> > implement a common ABI is an unnecessary risk.
> > 
> > We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> > require further VMM intervention.  But, I just don't see the point, it would
> > save only a few lines of code.  It would also limit what KVM could do in the
> > future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> > then mandatory interception would essentially make it impossible for KVM to do
> > bookkeeping while still honoring the interception request.
> > 
> > However, I do think it would make sense to have the userspace exit be a generic
> > exit type.  But hey, we already have the necessary ABI defined for that!  It's
> > just not used anywhere.
> > 
> > 	/* KVM_EXIT_HYPERCALL */
> > 	struct {
> > 		__u64 nr;
> > 		__u64 args[6];
> > 		__u64 ret;
> > 		__u32 longmode;
> > 		__u32 pad;
> > 	} hypercall;
> > 
> > 
> > > > Userspace could also handle the MSR using MSR filters (would need to
> > > > confirm that).  Then userspace could also be in control of the cpuid bit.
> > 
> > An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> > The data limitation could be fudged by shoving data into non-standard GPRs, but
> > that will result in truly heinous guest code, and extensibility issues.
> > 
> > The data limitation is a moot point, because the x86-only thing is a deal
> > breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> > memory with a host.  I can't think of a clever way to avoid having to support
> > TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> > multiple KVM variants.
> > 
> 
> Potentially, there is another reason for in-kernel hypercall handling
> considering SEV-SNP. In case of SEV-SNP the RMP table tracks the state
> of each guest page, for instance pages in hypervisor state, i.e., pages
> with C=0 and pages in guest valid state with C=1.
> 
> Now, there shouldn't be a need for page encryption status hypercalls on 
> SEV-SNP as KVM can track & reference guest page status directly using 
> the RMP table.

Relying on the RMP table itself would require locking the RMP table for an
extended duration, and walking the entire RMP to find shared pages would be
very inefficient.

> As KVM maintains the RMP table, therefore we will need SET/GET type of
> interfaces to provide the guest page encryption status to userspace.

Hrm, somehow I temporarily forgot about SNP and TDX adding their own hypercalls
for converting between shared and private.  And in the case of TDX, the hypercall
can't be trusted, i.e. is just a hint, otherwise the guest could induce a #MC in
the host.

But, the different guest behavior doesn't require KVM to maintain a list/tree,
e.g. adding a dedicated KVM_EXIT_* for notifying userspace of page encryption
status changes would also suffice.  

Actually, that made me think of another argument against maintaining a list in
KVM: there's no way to notify userspace that a page's status has changed.
Userspace would need to query KVM to do GET_LIST after every GET_DIRTY.
Obviously not a huge issue, but it does make migration slightly less efficient.

On a related topic, there are fatal race conditions that will require careful
coordination between guest and host, and will effectively be wired into the ABI.
SNP and TDX don't suffer these issues because host awareness of status is atomic
with respect to the guest actually writing the page with the new encryption
status.

For SEV live migration...

If the guest does the hypercall after writing the page, then the guest is hosed
if it gets migrated while writing the page (scenario #1):

  vCPU                 Userspace
  zero_bytes[0:N]
                       <transfers written bytes as private instead of shared>
		       <migrates vCPU>
  zero_bytes[N+1:4095]
  set_shared (dest)
  kaboom!

If userspace does GET_DIRTY after GET_LIST, then the host would transfer bad
data by consuming a stale list (scenario #2):

  vCPU               Userspace
                     get_list (from KVM or internally)
  set_shared (src)
  zero_page (src)
                     get_dirty
                     <transfers private data instead of shared>
                     <migrates vCPU>
  kaboom!

If both guest and host order things to avoid #1 and #2, the host can still
migrate the wrong data (scenario #3):

  vCPU               Userspace
  set_private
  zero_bytes[0:4096]
                     get_dirty
  set_shared (src)
                     get_list
                     <transfers as shared instead of private>
		     <migrates vCPU>
  set_private (dest)
  kaboom!

Scenario #3 is unlikely, but plausible, e.g. if the guest bails from its
conversion flow for whatever reason, after making the initial hypercall.  Maybe
it goes without saying, but to address #3, the guest must consider existing data
as lost the instant it tells the host the page has been converted to a different
type.

> For the above reason if we do in-kernel hypercall handling for page
> encryption status (which we probably won't require for SEV-SNP &
> correspondingly there will be no hypercall exiting),

As above, that doesn't preclude KVM from exiting to userspace on conversion.

> then we can implement a standard GET/SET ioctl interface to get/set the guest
> page encryption status for userspace, which will work across SEV, SEV-ES and
> SEV-SNP.
