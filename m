Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968673F84E4
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240983AbhHZJ6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:58:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229818AbhHZJ6r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 05:58:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629971880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=leoHqocZKzyqQQ9iOmg3rT9HzD1ObnwnSGi2pkc96+k=;
        b=ha8B6r+eg7fKDDlOwGrcwbhP81h80THi+f0Pw80hpH2G+pPF2W6UEWZOg9movpsRSVsAey
        rM0fU6oKpt8EvBy+YzYNfX3ymafxcMKTqNZFLzOHTaQR9ZHOP2NlA5q/do8jLzClxOy0JF
        J948/Kwu5CdGt3rWzb9PHRBsf3weowA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-LK2y0rkeOZqN9w8WCRn2og-1; Thu, 26 Aug 2021 05:57:58 -0400
X-MC-Unique: LK2y0rkeOZqN9w8WCRn2og-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C95B987D541;
        Thu, 26 Aug 2021 09:57:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C123C60877;
        Thu, 26 Aug 2021 09:57:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] KVM: SMM fixes for nVMX
Date:   Thu, 26 Aug 2021 12:57:48 +0300
Message-Id: <20210826095750.1650467-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Those are two patches that fix SMM entries while nested guests=0D
are active and either EPT or unrestricted guest mode is disabled=0D
(EPT disables the later)=0D
=0D
1. First patch makes sure that we don't run vmx_handle_exit_irqoff=0D
   when we emulate a handful of real mode smm instructions.=0D
=0D
   When in emulation mode, vmx exit reason is not updated,=0D
   and thus this function uses outdated values and crashes.=0D
=0D
2. Second patch works around an incorrect restore of segment=0D
   registers upon entry to nested guest from SMM.=0D
=0D
   When entering the nested guest from SMM we enter real mode,=0D
   and from it straight to nested guest, and in particular=0D
   once we restore L2's CR0, enter_pmode is called which=0D
   'restores' the segment registers from real mode segment=0D
   cache.=0D
=0D
   Normally this isn't a problem since after we finish entering=0D
   the nested guest, we restore all its registers from SMRAM,=0D
   but for the brief period when L2's segment registers are not up to date,=
=0D
   we trip 'vmx_guest_state_valid' check for non unrestricted guest mode, e=
ven=0D
   though it will be later valid.=0D
=0D
Note that I still am able to crash L1 by migrating a VM with a=0D
nested guest running and smm load, on VMX.=0D
=0D
This even happens with normal stock settings of ept=3D1,unrestricted_guest=
=3D1=0D
and will soon be investigated.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: VMX: avoid running vmx_handle_exit_irqoff in case of emulation=0D
  VMX: nSVM: enter protected mode prior to returning to nested guest=0D
    from SMM=0D
=0D
 arch/x86/kvm/vmx/vmx.c | 10 ++++++++++=0D
 1 file changed, 10 insertions(+)=0D
=0D
-- =0D
2.26.3=0D
=0D

