Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509904ECC5C
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 20:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350267AbiC3SiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 14:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351129AbiC3SdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 14:33:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 500EF50E13
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648665029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RZbGTsE6fj+tWEXGzmO8DRMy8Cnx5er20TMqeDcb2Ps=;
        b=DNf8MTKDF/DYRQViU+G0054tVcBrV29xlB5AVaRq1F6oTI5H9NslWB3riFQWDbjAS9ChsF
        3YgfJWlthEoAL7MyomwYm5byiLkqS1sfYgpQ/9yb8IH/2Xkfp8R4QXZ2Gs52CDLPinnBdB
        NQbmvixveVtJbdm0WnOxQhfWrpicavU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-fRUICFYrME-1u2W3DYZA6g-1; Wed, 30 Mar 2022 14:30:27 -0400
X-MC-Unique: fRUICFYrME-1u2W3DYZA6g-1
Received: by mail-qt1-f198.google.com with SMTP id z18-20020ac84552000000b002e201c79cd4so18086410qtn.2
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:30:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RZbGTsE6fj+tWEXGzmO8DRMy8Cnx5er20TMqeDcb2Ps=;
        b=uspM+XtjGdVO03IF+XFKnBhME8vK4MISYdS7n+z5ZsuAyfD87FhY4rldVvJIRZsRsD
         lNDUToSSLFB50GCJ0z0Yd8EDAUZxZfgFfIi7psfA2LgiqintMLWmGQQg8rdYafN8tw0O
         1qg+IPN7138leiLMEmSjaJxXpsjjq98i8CxBBsZDVUBdERHSJWMjsBzaUBFGtNioSOs8
         f2TkxnXbT3fwb29IVM7F2AshHvo3vJWZvWEpnQoWhCf3NkxBjfi28lnZowSKJ1Ip10O9
         CeHD5HDEP/lYdJwp3IOVzG1sQ0Ce/JqvsT3ioA+W94PpMZC1JgqOu/Raj/TmVIexutVK
         vTiw==
X-Gm-Message-State: AOAM5309lxNVynQIy0P8HZDYrexmB1D7BAucxHMGLmHH2bqs2GH/4bFw
        OvbCoJl0Upkjwx+UyGu9AcQmwpkdSBvLe+VTIp9KMFOIYVAIWKv8wujLTNYIcbbsWhTTriKV1Kd
        thcNGDXV1rwfJ
X-Received: by 2002:a37:414c:0:b0:67e:6d68:c585 with SMTP id o73-20020a37414c000000b0067e6d68c585mr756747qka.196.1648665026790;
        Wed, 30 Mar 2022 11:30:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxV7GTt34CXdG/qDCogIthPSHMHYYlDRsKEVG6uvoZamRv82rxB1y8ernA5KphBy4D/a0zmOw==
X-Received: by 2002:a37:414c:0:b0:67e:6d68:c585 with SMTP id o73-20020a37414c000000b0067e6d68c585mr756718qka.196.1648665026496;
        Wed, 30 Mar 2022 11:30:26 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id p13-20020a05622a048d00b002e1ce0c627csm18698113qtx.58.2022.03.30.11.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 11:30:26 -0700 (PDT)
Date:   Wed, 30 Mar 2022 14:30:24 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v2 16/26] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <YkShwFaRqlQpyL87@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-17-dmatlack@google.com>
 <YjGgjTnP/9sG8L+2@xz-m1.local>
 <CALzav=fZQYC7YyTbZqbkYTYVUXCq4skc6pkQ2S59BoSxbkKUhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=fZQYC7YyTbZqbkYTYVUXCq4skc6pkQ2S59BoSxbkKUhw@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 03:51:54PM -0700, David Matlack wrote:
> On Wed, Mar 16, 2022 at 1:32 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Mar 11, 2022 at 12:25:18AM +0000, David Matlack wrote:
> > > In order to split a huge page we need to know what access bits to assign
> > > to the role of the new child page table. This can't be easily derived
> > > from the huge page SPTE itself since KVM applies its own access policies
> > > on top, such as for HugePage NX.
> > >
> > > We could walk the guest page tables to determine the correct access
> > > bits, but that is difficult to plumb outside of a vCPU fault context.
> > > Instead, we can store the original access bits for each leaf SPTE
> > > alongside the GFN in the gfns array. The access bits only take up 3
> > > bits, which leaves 61 bits left over for gfns, which is more than
> > > enough. So this change does not require any additional memory.
> >
> > I have a pure question on why eager page split needs to worry on hugepage
> > nx..
> >
> > IIUC that was about forbidden huge page being mapped as executable.  So
> > afaiu the only missing bit that could happen if we copy over the huge page
> > ptes is the executable bit.
> >
> > But then?  I think we could get a page fault on fault->exec==true on the
> > split small page (because when we copy over it's cleared, even though the
> > page can actually be executable), but it should be well resolved right
> > after that small page fault.
> >
> > The thing is IIUC this is a very rare case, IOW, it should mostly not
> > happen in 99% of the use case?  And there's a slight penalty when it
> > happens, but only perf-wise.
> >
> > As I'm not really fluent with the code base, perhaps I missed something?
> 
> You're right that we could get away with not knowing the shadowed
> access permissions to assign to the child SPTEs when splitting a huge
> SPTE. We could just copy the huge SPTE access permissions and then let
> the execute bit be repaired on fault (although those faults would be a
> performance cost).
> 
> But the access permissions are also needed to lookup an existing
> shadow page (or create a new shadow page) to use to split the huge
> page. For example, let's say we are going to split a huge page that
> does not have execute permissions enabled. That could be because NX
> HugePages are enabled or because we are shadowing a guest translation
> that does not allow execution (or both). We wouldn't want to propagate
> the no-execute permission into the child SP role.access if the
> shadowed translation really does allow execution (and vice versa).

Then the follow up (pure) question is what will happen if we simply
propagate the no-exec permission into the child SP?

I think that only happens with direct sptes where guest used huge pages
because that's where the shadow page will be huge, so IIUC that's checked
here when the small page fault triggers:

static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
				   unsigned direct_access)
{
	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
		struct kvm_mmu_page *child;

		/*
		 * For the direct sp, if the guest pte's dirty bit
		 * changed form clean to dirty, it will corrupt the
		 * sp's access: allow writable in the read-only sp,
		 * so we should update the spte at this point to get
		 * a new sp with the correct access.
		 */
		child = to_shadow_page(*sptep & PT64_BASE_ADDR_MASK);
		if (child->role.access == direct_access)
			return;

		drop_parent_pte(child, sptep);
		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
	}
}

Due to missing EXEC the role.access check will not match with direct
access, which is the guest pgtable value which has EXEC set.  Then IIUC
we'll simply drop the no-exec SP and replace it with a new one with exec
perm.  The question is, would that untimately work too?

Even if that works, I agree this sounds tricky because we're potentially
caching fake sp.role conditionally and it seems we never do that before.
It's just that the other option that you proposed here seems to add other
way of complexity on caching spte permission information while kvm doesn't
do either before.  IMHO we need to see which is the best trade off.

I could have missed something else, though.

Thanks,

-- 
Peter Xu

