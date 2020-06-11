Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA101F6A3C
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 16:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgFKOoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 10:44:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24024 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbgFKOoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 10:44:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591886648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C6gchFSLH2QpQ8ISL0O1K29gdL59oTFNtAIl1VrFtO8=;
        b=d+1LS2quQdZG6mW544+pBW8wpVvOf//M6ayCwgyPSclNCbwxz0JmYTpUKE6UCQKH/eIGGH
        uFJZd0MihEBSEn3P+gNGw2pEYcWyIR3hYnEuBUgoWuPKHK+E7Y2ydxc1NsP3AXnzjqJKfJ
        vwce6BGEZCFOD7dvFFwFjUOn0w/sNVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-MnnVk26DOFGhyytKAQjLtA-1; Thu, 11 Jun 2020 10:44:05 -0400
X-MC-Unique: MnnVk26DOFGhyytKAQjLtA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97AAA19057A3;
        Thu, 11 Jun 2020 14:44:04 +0000 (UTC)
Received: from starship (unknown [10.35.206.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C59960FC2;
        Thu, 11 Jun 2020 14:44:03 +0000 (UTC)
Message-ID: <dde19d595336a5d79345f3115df26687871dfad5.camel@redhat.com>
Subject: Re: [PATCH] KVM: check userspace_addr for all memslots
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Jun 2020 17:44:02 +0300
In-Reply-To: <20200601082146.18969-1-pbonzini@redhat.com>
References: <20200601082146.18969-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-06-01 at 04:21 -0400, Paolo Bonzini wrote:
> The userspace_addr alignment and range checks are not performed for private
> memory slots that are prepared by KVM itself.  This is unnecessary and makes
> it questionable to use __*_user functions to access memory later on.  We also
> rely on the userspace address being aligned since we have an entire family
> of functions to map gfn to pfn.
> 
> Fortunately skipping the check is completely unnecessary.  Only x86 uses
> private memslots and their userspace_addr is obtained from vm_mmap,
> therefore it must be below PAGE_OFFSET.  In fact, any attempt to pass
> an address above PAGE_OFFSET would have failed because such an address
> would return true for kvm_is_error_hva.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I bisected this patch to break a VM on my AMD system (3970X)

The reason it happens, is because I have avic enabled (which uses
a private KVM memslot), but it is permanently disabled for that VM,
since I enabled nesting for that VM (+svm) and that triggers the code
in __x86_set_memory_region to set userspace_addr of the disabled
memslot to non canonical address (0xdeadull << 48) which is later rejected in __kvm_set_memory_region
after that patch, and that makes it silently not disable the memslot, which hangs the guest.

The call is from avic_update_access_page, which is called from svm_pre_update_apicv_exec_ctrl
which discards the return value.


I think that the fix for this would be to either make access_ok always return
true for size==0, or __kvm_set_memory_region should treat size==0 specially
and skip that check for it.

Best regards,
	Maxim Levitsky


