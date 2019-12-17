Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C879B1235E0
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 20:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfLQTlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 14:41:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41768 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726612AbfLQTlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 14:41:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576611678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+ys+mrut5WcWzjWDhyLUE00+KWwlntzvJusLfHvDvH8=;
        b=aEAaHPWMRhyaw9k+I4EQsOrM09M+njXmLPnUdOJJ1Lmn48ISSQF+1W4Iwds+KdVUksII1f
        uFb5/EOEGJ49sXt4tm4X1A39Y34jjPkkmvpnJFIv0GZjq2MT0RMD0N+OK+MSxjtgNp7FDS
        S4cyJXovTi81ZT8XwHWuHLy7PRVEtUY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-uAuY9Sy5NbeR22_0O8xLtg-1; Tue, 17 Dec 2019 14:41:18 -0500
X-MC-Unique: uAuY9Sy5NbeR22_0O8xLtg-1
Received: by mail-qt1-f200.google.com with SMTP id p12so7637332qtu.6
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 11:41:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+ys+mrut5WcWzjWDhyLUE00+KWwlntzvJusLfHvDvH8=;
        b=k0isFlG0FX1Amn2jKtsT93w7GFHvB66MpDsSYNUOBUEfYGU3PFZ0DlEGK5a7fO8lhS
         oN39heX9BX37WXetfFPqlUe4EH4MmNxbe0torq+h1DmNltp//MPow+G9Z1yl7q3VuGzs
         ivhGFgAKI8h2748VMB08u/BKKEP70tQxh2y/TZk/7VaKQA0nz7uK9jUN8Ky7A1/8rfBK
         uDuShfnv5huRCeFoexD7TaBZMY9W/RWc1wwe0HS9KwEN5PIyNUVO7J1Cx1BM8Ue6PTS0
         3IexkuJn6QVDZ270SXesY5CKcObT2HtFCbPNMSHxmdcbN4TAuOsv6yEjIOMe/Yxgl5MG
         L02g==
X-Gm-Message-State: APjAAAUe5eD5296JbHv9yCAQ6VLlx0l3Ah8Nrq1Yzdi2WlOWYsH5zqSB
        1CRfeMbZH6+JE1MOhwxfhAcmb089/vv7k9SUa+CIOYeL2yHfZKLAG1Hk98Gv/UHyDcfJS6tqmKV
        BcAbwKhDxXwoa
X-Received: by 2002:a37:61ce:: with SMTP id v197mr6737118qkb.467.1576611677575;
        Tue, 17 Dec 2019 11:41:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqzlQH+E4ia1GvPTRBNNHwmHqDWiHQ0fb1iTJLOyLRTOtENiFlxKcenXhuaXSVJDpj2tAvshlQ==
X-Received: by 2002:a37:61ce:: with SMTP id v197mr6737081qkb.467.1576611677193;
        Tue, 17 Dec 2019 11:41:17 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id v4sm3461251qtd.24.2019.12.17.11.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 11:41:16 -0800 (PST)
Date:   Tue, 17 Dec 2019 14:41:14 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191217194114.GG7258@xz-x1>
References: <20191129213505.18472-5-peterx@redhat.com>
 <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
 <E167A793-B42A-422D-8D46-B992CB6EBE69@redhat.com>
 <d59ac0eb-e65a-a46f-886e-6df80a2b142f@redhat.com>
 <20191217153837.GC7258@xz-x1>
 <ecb949d1-4539-305f-0a84-1704834e37ba@redhat.com>
 <20191217164244.GE7258@xz-x1>
 <c6d00ced-64ff-34af-99dd-abbcbac67836@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c6d00ced-64ff-34af-99dd-abbcbac67836@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 05:48:58PM +0100, Paolo Bonzini wrote:
> On 17/12/19 17:42, Peter Xu wrote:
> > 
> > However I just noticed something... Note that we still didn't read
> > into non-x86 archs, I think it's the same question as when I asked
> > whether we can unify the kvm[_vcpu]_write() interfaces and you'd like
> > me to read the non-x86 archs - I think it's time I read them, because
> > it's still possible that non-x86 archs will still need the per-vm
> > ring... then that could be another problem if we want to at last
> > spread the dirty ring idea outside of x86.
> 
> We can take a look, but I think based on x86 experience it's okay if we
> restrict dirty ring to arches that do no VM-wide accesses.

Here it is - a quick update on callers of mark_page_dirty_in_slot().
The same reverse trace, but ignoring all common and x86 code path
(which I covered in the other thread):

==================================

   mark_page_dirty_in_slot (non-x86)
        mark_page_dirty
            kvm_write_guest_page
                kvm_write_guest
                    kvm_write_guest_lock
                        vgic_its_save_ite [?]
                        vgic_its_save_dte [?]
                        vgic_its_save_cte [?]
                        vgic_its_save_collection_table [?]
                        vgic_v3_lpi_sync_pending_status [?]
                        vgic_v3_save_pending_tables [?]
                    kvmppc_rtas_hcall [&]
                    kvmppc_st [&]
                    access_guest [&]
                    put_guest_lc [&]
                    write_guest_lc [&]
                    write_guest_abs [&]
            mark_page_dirty
                _kvm_mips_map_page_fast [&]
                kvm_mips_map_page [&]
                kvmppc_mmu_map_page [&]
                kvmppc_copy_guest
                    kvmppc_h_page_init [&]
                kvmppc_xive_native_vcpu_eq_sync [&]
                adapter_indicators_set [?] (from kvm_set_irq)
                kvm_s390_sync_dirty_log [?]
                unpin_guest_page
                    unpin_blocks [&]
                    unpin_scb [&]

Cases with [*]: should not matter much
           [&]: should be able to change to per-vcpu context
           [?]: uncertain...

==================================

This time we've got 8 leaves with "[?]".

I'm starting with these:

        vgic_its_save_ite [?]
        vgic_its_save_dte [?]
        vgic_its_save_cte [?]
        vgic_its_save_collection_table [?]
        vgic_v3_lpi_sync_pending_status [?]
        vgic_v3_save_pending_tables [?]

These come from ARM specific ioctls like KVM_DEV_ARM_ITS_SAVE_TABLES,
KVM_DEV_ARM_ITS_RESTORE_TABLES, KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES.
IIUC ARM needed these to allow proper migration which indeed does not
have a vcpu context.

(Though I'm a bit curious why ARM didn't simply migrate these
 information explicitly from userspace, instead it seems to me that
 ARM guests will dump something into guest ram and then tries to
 recover from that which seems to be a bit weird)
 
Then it's this:

        adapter_indicators_set [?]

This is s390 specific, which should come from kvm_set_irq.  I'm not
sure whether we can remove the mark_page_dirty() call of this, if it's
applied from another kernel structure (which should be migrated
properly IIUC).  But I might be completely wrong.

        kvm_s390_sync_dirty_log [?]
        
This is also s390 specific, should be collecting from the hardware
PGSTE_UC_BIT bit.  No vcpu context for sure.

(I'd be glad too if anyone could hint me why x86 cannot use page table
 dirty bits for dirty tracking, if there's short answer...)

I think my conclusion so far...

  - for s390 I don't think we even need this dirty ring buffer thing,
    because I think hardware trackings should be more efficient, then
    we don't need to care much on that either from design-wise of
    dirty ring,

  - for ARM, those no-vcpu-context dirty tracking probably needs to be
    considered, but hopefully that's a very special path so it rarely
    happen.  The bad thing is I didn't dig how many pages will be
    dirtied when ARM guest starts to dump all these things so it could
    be a burst...  If it is, then there's risk to trigger the ring
    full condition (which we wanted to avoid..)

I'm CCing Eric for ARM, Conny&David for s390, just in case there're
further inputs.

Thanks,

-- 
Peter Xu

