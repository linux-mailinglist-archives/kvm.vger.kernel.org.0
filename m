Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354C354C41E
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 11:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243896AbiFOJBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 05:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiFOJBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 05:01:38 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 355E73466B;
        Wed, 15 Jun 2022 02:01:37 -0700 (PDT)
Received: from anrayabh-desk (unknown [167.220.238.193])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3867620C3230;
        Wed, 15 Jun 2022 02:01:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3867620C3230
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655283696;
        bh=Fo6CSnNJRE/YjGZUQshS1lDdeF7gEOjNbUYnU0G63RU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OnaD1ScM3O1zqniZALodPx0ED0jG6QR1ED06vK40uwFVVy0zVtA2Puo7eTETNo7lJ
         A2oCRhDaQpc8Y3RfIwyP9K6GrmtQxmU42b9laE3IGw37KnsfnuzeuCBT/YYcIxBn8L
         oe7BZvT7sHS7+mYNYukqkWqJ/xdjW3323GG9QdNQ=
Date:   Wed, 15 Jun 2022 14:31:25 +0530
From:   Anirudh Rayabharam <anrayabh@linux.microsoft.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
Message-ID: <Yqmf5UGbNKyGz3dD@anrayabh-desk>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <87sfo7igis.fsf@redhat.com>
 <eaefdea0-0ca3-93f1-a815-03900055fdcd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaefdea0-0ca3-93f1-a815-03900055fdcd@redhat.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 07:20:34PM +0200, Paolo Bonzini wrote:
> On 6/14/22 14:19, Vitaly Kuznetsov wrote:
> > The latest version:
> > https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/datatypes/hv_vmx_enlightened_vmcs
> > 
> > has it, actually. It was missing before (compare with e.g. 6.0b version
> > here:
> > https://github.com/MicrosoftDocs/Virtualization-Documentation/raw/live/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v6.0b.pdf)
> > 
> > but AFAIR TSC scaling wasn't advertised by genuine Hyper-V either.
> > Interestingly enough, eVMCS version didn't change when these fields were
> > added, it is still '1'.
> > 
> > I even have a patch in my stash (attached). I didn't send it out because
> > it wasn't properly tested with different Hyper-V versions.
> > 
> > -- Vitaly
> 
> Anirudh, can you check if Vitaly's patches work for you?

I will check it. But I wonder if they fit the criteria for inclusion in
stable trees...

It is important for the fix to land in the stable trees since this issue
is a regression that was introduced _after_ 5.13. (I probably should've
mentioned this in the changelog.)

Thanks,

	Anirudh.

> 
> Paolo
