Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBDFEB700C
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 02:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbfISAXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 20:23:35 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59765 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbfISAXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 20:23:35 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46YcyX5cBKz9sNf; Thu, 19 Sep 2019 10:23:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1568852612; bh=cu6MqzQ+Jjg6jBgAMHqPfsdtuEEEpXwelfg4ezvXdsY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nt4NYXLQPNaOq5EaXwA6J6CUQqtE4sYHQnvkHZSOhCjqqWJ01CdAB4tfDaD7elmpm
         n8+n+jy0vrYBX7bhjUejT61fggDfeR0cgCIUnTuqNkpIC0IXNlLj5BQyxdJITIPcBR
         mnSFYsZrVTQqPYzswqowK1En17cvpVKAST5slijgNdV7bpZykh7hDKsvP4WJVNLb/9
         Ol1XIqjO/OL2LCmIx/vGzkgBlQMKHpTE8RacF1q2tw33WNlisVf3Zmdf+cisE74bOX
         ghUTBd1CuYuzqzcB8Zaw4KJe2JcyTf9IC7kOu6x2wrhVjXAyrW69MyKAvq+7wse73h
         GRj1zPawfFkIQ==
Date:   Thu, 19 Sep 2019 10:22:42 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20190919002242.GA19503@blackberry>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
 <20190911185038.24341-11-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911185038.24341-11-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 11, 2019 at 11:50:35AM -0700, Sean Christopherson wrote:
> Move the implementations of KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG
> for CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT into common KVM code.
> The arch specific implemenations are extremely similar, differing
> only in whether the dirty log needs to be sync'd from hardware (x86)
> and how the TLBs are flushed.  Add new arch hooks to handle sync
> and TLB flush; the sync will also be used for non-generic dirty log
> support in a future patch (s390).
> 
> The ulterior motive for providing a common implementation is to
> eliminate the dependency between arch and common code with respect to
> the memslot referenced by the dirty log, i.e. to make it obvious in the
> code that the validity of the memslot is guaranteed, as a future patch
> will rework memslot handling such that id_to_memslot() can return NULL.

I notice you add empty definitions of kvm_arch_sync_dirty_log() for
PPC, both Book E and Book 3S.  Given that PPC doesn't select
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT, why is this necessary?

Paul.
