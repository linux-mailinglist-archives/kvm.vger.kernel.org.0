Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB39CC8F5B
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfJBRF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 13:05:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfJBRF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 13:05:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 385CB87648;
        Wed,  2 Oct 2019 17:05:57 +0000 (UTC)
Received: from redhat.com (ovpn-112-77.rdu2.redhat.com [10.10.112.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7408F5C3F8;
        Wed,  2 Oct 2019 17:05:46 +0000 (UTC)
Date:   Wed, 2 Oct 2019 13:04:29 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>,
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
Message-ID: <20191002170429.GA8189@redhat.com>
References: <20190815191929.GA9253@redhat.com>
 <20190815201630.GA25517@redhat.com>
 <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
 <20190905180955.GA3251@redhat.com>
 <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
 <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191002192714.GA5020@redhat.com>
 <ab461f02-e6cd-de0f-b6ce-0f5a95798eaa@redhat.com>
 <20191002141542.GA5669@redhat.com>
 <f26710a4-424f-730c-a676-901bae451409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f26710a4-424f-730c-a676-901bae451409@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 02 Oct 2019 17:05:57 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 02, 2019 at 06:18:06PM +0200, Paolo Bonzini wrote:
> On 02/10/19 16:15, Jerome Glisse wrote:
> >>> Why would you need to target mmu notifier on target vma ?
> >> If the mapping of the source VMA changes, mirroring can update the
> >> target VMA via insert_pfn.  But what ensures that KVM's MMU notifier
> >> dismantles its own existing page tables (so that they can be recreated
> >> with the new mapping from the source VMA)?
> >>
> > So just to make sure i follow we have:
> >       - qemu process on host with anonymous vma
> >             -> host cpu page table
> >       - kvm which maps host anonymous vma to guest
> >             -> kvm guest page table
> >       - kvm inspector process which mirror vma from qemu process
> >             -> inspector process page table
> > 
> > AFAIK the KVM notifier's will clear the kvm guest page table whenever
> > necessary (through kvm_mmu_notifier_invalidate_range_start). This is
> > what ensure that KVM's dismatles its own mapping, it abides to mmu-
> > notifier callbacks. If you did not you would have bugs (at least i
> > expect so). Am i wrong here ?
> 
> The KVM inspector process is also (or can be) a QEMU that will have to
> create its own KVM guest page table.

Ok missed that part, thank you for explaining

> 
> So if a page in the source VMA is unmapped we want:
> 
> - the source KVM to invalidate its guest page table (done by the KVM MMU
> notifier)
> 
> - the target VMA to be invalidated (easy using mirroring)
> 
> - the target KVM to invalidate its guest page table, as a result of
> invalidation of the target VMA

You can do the target KVM invalidation inside the mirroring invalidation
code.

Cheers,
Jérôme
