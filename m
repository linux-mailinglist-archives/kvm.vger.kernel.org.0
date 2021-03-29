Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A60434D737
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 20:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhC2SbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 14:31:18 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:50627 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231750AbhC2SbI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 14:31:08 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2021 14:31:08 EDT
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 69AC21940D29;
        Mon, 29 Mar 2021 14:23:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 29 Mar 2021 14:23:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+jhRBl
        mzSn44QvKDx4qZJ6h57R67+gDRjs5ayVeerd8=; b=ZxgPDIIiXEncekbQMrrRFr
        PGtJDQFOmevpqcLFnVIDzgBmnGwvsEtjd8z09H2HZPe4feklM/lp1a9u+MpzA6VE
        SfNIVu1d7RWnq1+wqnv21zzciyOy3t99z9L0CmQMHfoNY5Pox/9thzPOLX/oWrdW
        gC3BoJ+sxsDVcOIbFxqckeWrj7Ejl7AjTh6nAURtILHYOslY0epRX55TkUol6t4c
        jix8Vb47IbA9vD+GJ0b2rG499fcrfz1LPmYvgpSO8CzAaZfXruHrz8w+2a8x9Zg5
        pTct2N8vfwBakXVJeNEq93hcc4koScjM17y14dQ41y8MRK2wBahlGTLZ1aaEisrg
        ==
X-ME-Sender: <xms:KRtiYO09-l6KBNv4CI4_EsqOP84c61ayhKIKBkyywWIxjW_taRbItg>
    <xme:KRtiYPXRI0MYF1Wu1oQw2ui1AOh_p9p1UUQPHmIlHue7MCwYzACfj2UMhvBdbB9Dp
    MnoM0BHmqAWH3Ai-ck>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpeehleeffeduiedugedulefgteegteekleevueei
    teduleehjeekieelkeevueektdenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:KRtiYAPHDMAi0bftmtLomUUdfY23u8tcuxUu33b7NwRdkpYHzQzAIA>
    <xmx:KRtiYC1B5kc2xMbA_BxEffWIp0Upgbf1zrmaf6mON2okusMFbFmGgg>
    <xmx:KRtiYERJ32ZML-XwRDRnEjOIsOZD2g-lOgk_XyazyGl8SlxDuzTcXw>
    <xmx:LBtiYJv98AtyKK4FHN8V6zm-_H9DwXh0K9CDKYgkbYqyDvQVfmlkGlKpkZ4>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8AC001080057;
        Mon, 29 Mar 2021 14:23:36 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id b3066ee5;
        Mon, 29 Mar 2021 18:23:35 +0000 (UTC)
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v5 0/5] KVM: x86: dump_vmcs: don't assume
 GUEST_IA32_EFER, show MSR autoloads/autosaves
In-Reply-To: <20210318120841.133123-1-david.edmondson@oracle.com>
References: <20210318120841.133123-1-david.edmondson@oracle.com>
X-HGTTG: zarquon
From:   David Edmondson <david.edmondson@oracle.com>
Date:   Mon, 29 Mar 2021 19:23:35 +0100
Message-ID: <cunsg4dhl94.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, 2021-03-18 at 12:08:36 GMT, David Edmondson wrote:

> v2:
> - Don't use vcpu->arch.efer when GUEST_IA32_EFER is not available (Paolo).
> - Dump the MSR autoload/autosave lists (Paolo).
>
> v3:
> - Rebase to master.
> - Check only the load controls (Sean).
> - Always show the PTPRs from the VMCS if they exist (Jim/Sean).
> - Dig EFER out of the MSR autoload list if it's there (Paulo).
> - Calculate and show the effective EFER if it is not coming from
>   either the VMCS or the MSR autoload list (Sean).
>
> v4:
> - Ensure that each changeset builds with just the previous set.
>
> v5:
> - Rebase.
> - Remove some cruft from changeset comments.
> - Add S-by as appropriate.

Any further comments or suggestions?

Thanks.

> David Edmondson (5):
>   KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
>   KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
>   KVM: x86: dump_vmcs should consider only the load controls of EFER/PAT
>   KVM: x86: dump_vmcs should show the effective EFER
>   KVM: x86: dump_vmcs should include the autoload/autostore MSR lists
>
>  arch/x86/kvm/vmx/vmx.c | 58 +++++++++++++++++++++++++++++-------------
>  arch/x86/kvm/vmx/vmx.h |  2 +-
>  2 files changed, 42 insertions(+), 18 deletions(-)
>
> -- 
> 2.30.2

dme.
-- 
Everybody's got something to hide, 'cept me and my monkey.
