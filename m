Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33EEE96B06
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 23:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbfHTVCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 17:02:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:47025 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbfHTVCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 17:02:46 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 14:02:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="scan'208";a="169212857"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 20 Aug 2019 14:02:45 -0700
Date:   Tue, 20 Aug 2019 14:02:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190820210245.GC15808@linux.intel.com>
References: <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home>
 <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com>
 <20190820144204.161f49e0@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820144204.161f49e0@x1.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 20, 2019 at 02:42:04PM -0600, Alex Williamson wrote:
> On Tue, 20 Aug 2019 13:03:19 -0700
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > All that being said, it doesn't explain why gfns like 0xfec00 and 0xfee00
> > were sensitive to (lack of) zapping.  My theory is that zapping what were
> > effectively random-but-interesting shadow pages cleaned things up enough
> > to avoid noticeable badness.
> > 
> > 
> > Alex,
> > 
> > Can you please test the attached patch?  It implements a very slimmed down
> > version of kvm_mmu_zap_all() to zap only shadow pages that can hold sptes
> > pointing at the memslot being removed, which was the original intent of
> > kvm_mmu_invalidate_zap_pages_in_memslot().  I apologize in advance if it
> > crashes the host.  I'm hopeful it's correct, but given how broken the
> > previous version was, I'm not exactly confident.
> 
> It doesn't crash the host, but the guest is not happy, failing to boot
> the desktop in one case and triggering errors in the guest w/o even
> running test programs in another case.  Seems like it might be worse
> than previous.  Thanks,

Hrm, I'm back to being completely flummoxed.

Would you be able to generate a trace of all events/kvmmmu, using the
latest patch?  I'd like to rule out a stupid code bug if it's not too
much trouble.
