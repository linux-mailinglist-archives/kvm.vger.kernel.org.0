Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42C21DBDF1
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 21:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgETTYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 15:24:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726560AbgETTYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 15:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590002661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SHISqFlqCMxvBm5+qETPogyLCEcwxqXzDOwnrmZ88k0=;
        b=hN1wHufP1oeRLChaUAKwA7l4OAiJsaSx4InVRcFAy166XOQPutWEoOj3oPm5+NZnt4CEWo
        vS4k2V9MAzb6fFJdKSPovaP1QSWXTOwmIKGD+rTlKNt0sCB6ySwjHJyS8jQqbWapksfJ7Z
        OV9N7Lm9eBtIMo6W08nrDEsYaumuYxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-Sxjlh7nDMouZhFlG0GrY4w-1; Wed, 20 May 2020 15:24:19 -0400
X-MC-Unique: Sxjlh7nDMouZhFlG0GrY4w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEA71A0C05;
        Wed, 20 May 2020 19:24:18 +0000 (UTC)
Received: from starship (unknown [10.35.206.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 596B85C1BE;
        Wed, 20 May 2020 19:24:17 +0000 (UTC)
Message-ID: <6b8674fa647d3b80125477dc344581ba7adfb931.camel@redhat.com>
Subject: Re: [PATCH 00/24] KVM: nSVM: event fixes and migration support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Date:   Wed, 20 May 2020 22:24:16 +0300
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-05-20 at 13:21 -0400, Paolo Bonzini wrote:
> Large parts of this series were posted before (patches 1, 3-4-5 and
> 6-7-8-12-13-14).  This is basically what I'd like to get into 5.8 as
> far as nested SVM is concerned; the fix for exception vmexits is related
> to migration support, because it gets rid of the exit_required flag
> and therefore consolidates the SVM migration format.
> 
> There are a couple more bugfixes (2 and 21), the latter of which actually
> affects VMX as well.
> 
> The SVM migration data consists of:
> 
> - the GIF state
> 
> - the guest mode and nested-run-pending flags
> 
> - the host state from before VMRUN
> 
> - the nested VMCB control state
> 
> The last two items are conveniently packaged in VMCB format.  Compared
> to the previous prototype, HF_HIF_MASK is removed since it is part of
> "the host state from before VMRUN".
> 
> The patch has been tested with the QEMU changes after my signature,
> where it also fixes system_reset while x86/svm.flat runs.
> 
> Paolo
> 
> Paolo Bonzini (24):
>   KVM: nSVM: fix condition for filtering async PF
>   KVM: nSVM: leave ASID aside in copy_vmcb_control_area
>   KVM: nSVM: inject exceptions via svm_check_nested_events
>   KVM: nSVM: remove exit_required
>   KVM: nSVM: correctly inject INIT vmexits
>   KVM: nSVM: move map argument out of enter_svm_guest_mode
>   KVM: nSVM: extract load_nested_vmcb_control
>   KVM: nSVM: extract preparation of VMCB for nested run
>   KVM: nSVM: clean up tsc_offset update
>   KVM: nSVM: pass vmcb_control_area to copy_vmcb_control_area
>   KVM: nSVM: remove trailing padding for struct vmcb_control_area
>   KVM: nSVM: save all control fields in svm->nested
>   KVM: nSVM: do not reload pause filter fields from VMCB
>   KVM: nSVM: remove HF_VINTR_MASK
>   KVM: nSVM: remove HF_HIF_MASK
>   KVM: nSVM: split nested_vmcb_check_controls
>   KVM: nSVM: do all MMU switch work in init/uninit functions
>   KVM: nSVM: leave guest mode when clearing EFER.SVME
>   KVM: nSVM: extract svm_set_gif
>   KVM: MMU: pass arbitrary CR0/CR4/EFER to kvm_init_shadow_mmu
>   KVM: x86: always update CR3 in VMCB
>   uaccess: add memzero_user
>   selftests: kvm: add a SVM version of state-test
>   KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE
> 
>  arch/x86/include/asm/kvm_host.h               |   2 -
>  arch/x86/include/asm/svm.h                    |   9 +-
>  arch/x86/include/uapi/asm/kvm.h               |  17 +-
>  arch/x86/kvm/cpuid.h                          |   5 +
>  arch/x86/kvm/irq.c                            |   1 +
>  arch/x86/kvm/mmu.h                            |   2 +-
>  arch/x86/kvm/mmu/mmu.c                        |  14 +-
>  arch/x86/kvm/svm/nested.c                     | 525 +++++++++++-------
>  arch/x86/kvm/svm/svm.c                        | 107 ++--
>  arch/x86/kvm/svm/svm.h                        |  32 +-
>  arch/x86/kvm/vmx/nested.c                     |   5 -
>  arch/x86/kvm/vmx/vmx.c                        |   5 +-
>  arch/x86/kvm/x86.c                            |   3 +-
>  include/linux/uaccess.h                       |   1 +
>  lib/usercopy.c                                |  63 +++
>  .../testing/selftests/kvm/x86_64/state_test.c |  65 ++-
>  16 files changed, 549 insertions(+), 307 deletions(-)
> 

I just smoke-tested this patch series on my system.

Patch 24 doesn't apply cleanly on top of kvm/queue, I appplied it manually,
due to missing KVM_STATE_NESTED_MTF_PENDING bit

Also patch 22 needes ALIGN_UP which is not on mainline.
Probably in linux-next?

With these fixes, I don't see #DE exceptions on a nested guest I try to run
however it still hangs, right around the time it tries to access PS/2 keyboard/mouse.

Best regards,
	Maxim Levitsky

