Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C9E188B57
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 18:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgCQRAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 13:00:19 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:20724 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbgCQRAT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 13:00:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584464417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pD4ldY6FsMj0oyAEHqGiJztZej2hvg/ILeuMFN/cWHc=;
        b=i0QWnY4qCZN4Xn+rJ/f+CUpwNV5IrVV8OggRhYk39Gd8ecIJKtXhaAyVDpJ51JGH3a8tcd
        NZc1kBCcgRuin7lGjvMsnMutD3j0RGxYBHvJ5r4LVoVY1tYj+oieEQw6w0iUTG/ednDATT
        AHUabcWHmy03iArz9VEogC9Mte8kH78=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-KW1oHsjzMFWetKHeZ8H4rA-1; Tue, 17 Mar 2020 13:00:12 -0400
X-MC-Unique: KW1oHsjzMFWetKHeZ8H4rA-1
Received: by mail-wr1-f69.google.com with SMTP id p5so10878248wrj.17
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 10:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pD4ldY6FsMj0oyAEHqGiJztZej2hvg/ILeuMFN/cWHc=;
        b=N6/KsIUNnLkSCKhMpQ0tUB7gRDp88Por80NuWIGupA88I9Xe+EU9WGL7y+PRrDGY7N
         RamrfKQlFirUHJskbEhEAMLmLJQm8M24tc0dapxUWUkIz+ZBFquJ0MGnbl9qZa4f1/m0
         AnaGR7fJTdmClNNL82/uUpTY47sbD2hyxJkyf3hC26JtonDfmJVlNIufjYkRFzOT4NXZ
         Ckqo/BZYUQW9xqO7+xpp3T5lk3BRhh0Sp7bFFMgBON4n6sBDAAiquaTK39o7fjpVbL1r
         X53ZxaQEEY9rmWmjZe0/o1et86ySfmmLngyHn4O5DUJ86eQ7mBt3PAwAMDYjGDhFQeZZ
         l/gQ==
X-Gm-Message-State: ANhLgQ3up6Ab1AP56iHPmRIZGAkHESKKIRx6/34i83LOLw6gv1oIQUvm
        EFT+ypQH5be/WHQJzoGem8HCW2Rb/o4bHkYqogzsWckD6UdAn8UanIls2/8bIiFq00RMiwKx8iT
        JOABrAWLjQsPU
X-Received: by 2002:adf:e9d2:: with SMTP id l18mr6993042wrn.400.1584464411321;
        Tue, 17 Mar 2020 10:00:11 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuiBti4n3b+I45Dd6Af5CiLPyuCQjyIHtzEMxtdl62LafVztX3/PskWwlTeWTOv4/AIOdpE5A==
X-Received: by 2002:adf:e9d2:: with SMTP id l18mr6993015wrn.400.1584464411054;
        Tue, 17 Mar 2020 10:00:11 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j39sm5737571wre.11.2020.03.17.10.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 10:00:09 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 01/10] KVM: nVMX: Move reflection check into nested_vmx_reflect_vmexit()
In-Reply-To: <20200317161631.GD12526@linux.intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com> <20200312184521.24579-2-sean.j.christopherson@intel.com> <87k13opi6m.fsf@vitty.brq.redhat.com> <20200317053327.GR24267@linux.intel.com> <20200317161631.GD12526@linux.intel.com>
Date:   Tue, 17 Mar 2020 18:00:07 +0100
Message-ID: <874kum533c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Mar 16, 2020 at 10:33:27PM -0700, Sean Christopherson wrote:
>> On Fri, Mar 13, 2020 at 01:12:33PM +0100, Vitaly Kuznetsov wrote:
>> > Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> > 
>> > > -static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
>> > > -					    u32 exit_reason)
>> > > +static inline bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
>> > > +					     u32 exit_reason)
>> > >  {
>> > > -	u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
>> > > +	u32 exit_intr_info;
>> > > +
>> > > +	if (!nested_vmx_exit_reflected(vcpu, exit_reason))
>> > > +		return false;
>> > 
>> > (unrelated to your patch)
>> > 
>> > It's probably just me but 'nested_vmx_exit_reflected()' name always
>> > makes me thinkg 'the vmexit WAS [already] reflected' and not 'the vmexit
>> > NEEDS to be reflected'. 'nested_vmx_exit_needs_reflecting()' maybe?
>> 
>> Not just you.  It'd be nice if the name some how reflected (ha) that the
>> logic is mostly based on whether or not L1 expects the exit, with a few
>> exceptions.  E.g. something like
>> 
>> 	if (!l1_expects_vmexit(...) && !is_system_vmexit(...))
>> 		return false;
>
> Doh, the system VM-Exit logic is backwards, it should be
>
> 	if (!l1_expects_vmexit(...) || is_system_vmexit(...))
> 		return false;
>> 
>> The downside of that is the logic is split, which is probably a net loss?
>

Yea,

(just thinking out loud below)

the problem with the split is that we'll have to handle the same exit
reason twice, e.g. EXIT_REASON_EXCEPTION_NMI (is_nmi() check goes to
is_system_vmexit() and vmcs12->exception_bitmap check goes to
l1_expects_vmexit()). Also, we have two 'special' cases: vmx->fail and
nested_run_pending. While the former belongs to to l1_expects_vmexit(),
the later doesn't belong to either (but we can move it to
nested_vmx_reflect_vmexit() I believe).

On the other hand, I'm a great fan of splitting checkers ('pure'
functions) from actors (functions with 'side-effects') and
nested_vmx_exit_reflected() while looking like a checker does a lot of
'acting': nested_mark_vmcs12_pages_dirty(), trace printk.

-- 
Vitaly

