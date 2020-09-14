Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8938269083
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 17:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgINPpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 11:45:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:51856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgINPoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 11:44:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 49067ACCF;
        Mon, 14 Sep 2020 15:44:48 +0000 (UTC)
Date:   Mon, 14 Sep 2020 17:44:30 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Colin King <colin.king@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH tip] KVM: nSVM: avoid freeing uninitialized pointers in
 svm_set_nested_state()
Message-ID: <20200914154430.GE4414@suse.de>
References: <20200914133725.650221-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914133725.650221-1-vkuznets@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:37:25PM +0200, Vitaly Kuznetsov wrote:
> The save and ctl pointers are passed uninitialized to kfree() when
> svm_set_nested_state() follows the 'goto out_set_gif' path. While
> the issue could've been fixed by initializing these on-stack varialbles
> to NULL, it seems preferable to eliminate 'out_set_gif' label completely
> as it is not actually a failure path and duplicating a single svm_set_gif()
> call doesn't look too bad.
> 
> Fixes: 6ccbd29ade0d ("KVM: SVM: nested: Don't allocate VMCB structures on stack")
> Addresses-Coverity: ("Uninitialized pointer read")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: Joerg Roedel <jroedel@suse.de>
> Reported-by: Colin King <colin.king@canonical.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Acked-by: Joerg Roedel <jroedel@suse.de>

