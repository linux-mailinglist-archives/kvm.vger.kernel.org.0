Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3636C8997
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 15:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfJBN2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 09:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfJBN2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 09:28:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 908FB18C890B;
        Wed,  2 Oct 2019 13:28:23 +0000 (UTC)
Received: from redhat.com (ovpn-112-58.rdu2.redhat.com [10.10.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52C9E5D9D6;
        Wed,  2 Oct 2019 13:28:12 +0000 (UTC)
Date:   Wed, 2 Oct 2019 15:27:14 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>,
        Matthew Wilcox <willy@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>
Subject: Re: DANGER WILL ROBINSON, DANGER
Message-ID: <20191002192714.GA5020@redhat.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-72-alazar@bitdefender.com>
 <20190809162444.GP5482@bombadil.infradead.org>
 <1565694095.D172a51.28640.@15f23d3a749365d981e968181cce585d2dcb3ffa>
 <20190815191929.GA9253@redhat.com>
 <20190815201630.GA25517@redhat.com>
 <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
 <20190905180955.GA3251@redhat.com>
 <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
 <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Wed, 02 Oct 2019 13:28:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 07:49:51AM +0000, Mircea CIRJALIU - MELIU wrote:
> > On 05/09/19 20:09, Jerome Glisse wrote:
> > > Not sure i understand, you are saying that the solution i outline
> > > above does not work ? If so then i think you are wrong, in the above
> > > solution the importing process mmap a device file and the resulting
> > > vma is then populated using insert_pfn() and constantly keep
> > > synchronize with the target process through mirroring which means that
> > > you never have to look at the struct page ... you can mirror any kind
> > > of memory from the remote process.
> > 
> > If insert_pfn in turn calls MMU notifiers for the target VMA (which would be
> > the KVM MMU notifier), then that would work.  Though I guess it would be
> > possible to call MMU notifier update callbacks around the call to insert_pfn.
> 
> Can't do that.
> First, insert_pfn() uses set_pte_at() which won't trigger the MMU notifier on
> the target VMA. It's also static, so I'll have to access it thru vmf_insert_pfn()
> or vmf_insert_mixed().

Why would you need to target mmu notifier on target vma ? You do not need
that. The workflow is:

    userspace:
        ptr = mmap(/dev/kvm-mirroring-device, virtual_addresse_of_target)

Then when the mirroring process access ptr it triggers page fault that
endup in the vm_operation_struct->fault() which is just doing:

    kernel-kvm-mirroring-function:
        kvm_mirror_page_fault(struct vm_fault *vmf) {
            struct kvm_mirror_struct *kvmms;

            kvmms = kvm_mirror_struct_from_file(vmf->vma->vm_file);
            ...
        again:
            hmm_range_register(&range);
            hmm_range_snapshot(&range);
            take_lock(kvmms->update);
            if (!hmm_range_valid(&range)) {
                vm_insert_pfn();
                drop_lock(kvmms->update);
                hmm_range_unregister(&range);
                return VM_FAULT_NOPAGE;
            }
            drop_lock(kvmms->update);
            goto again;
        }

The notifier callback:
        kvmms_notifier_start() {
            take_lock(kvmms->update);
            clear_pte(start, end);
            drop_lock(kvmms->update);
        }

> 
> Our model (the importing process is encapsulated in another VM) forces us
> to mirror certain pages from the anon VMA backing one VM's system RAM to 
> the other VM's anon VMA. 

The mirror does not have to be an anon vma it can very well be a
device vma ie mmap of a device file. I do not see any reasons why
the mirror need to be an anon vma. Please explain why.

> 
> Using the functions above means setting VM_PFNMAP|VM_MIXEDMAP on 
> the target anon VMA, but I guess this breaks the VMA. Is this recommended?

The mirror vma should not be an anon vma.

> 
> Then, mapping anon pages from one VMA to another without fixing the 
> refcount and the mapcount breaks the daemons that think they're working 
> on a pure anon VMA (kcompactd, khugepaged).

Note here the target vma ie the mirroring one is a mmap of device file
and thus is skip by all of the above (kcompactd, khugepaged, ...) it is
fully ignore by core mm.

Thus you do not need to fix the refcount in any way. If any of the core
mm try to reclaim memory from the original vma then you will get mmu
notifier callbacks and all you have to do is clear the page table of your
device vma.

I did exactly that as a tools in the past and it works just fine with
no change to core mm whatsoever.

Cheers,
Jérôme
