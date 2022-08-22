Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCB959BCAB
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 11:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiHVJSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 05:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbiHVJSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 05:18:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8808B15712
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 02:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661159904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LBJ8MqhFUZNYzQi5G0vn7l4X961C4s/0d1vabFTY8yE=;
        b=FyfuVjhC2py8c7Ahql/axDbQxlDiBJcMt0lkkV9F6eUvVdmN/dYXC0zHhzadN9lBZrYOpV
        iI97iTtvLMjEJ5BCalHdpJRJQOcJfgtAJLAdFAo+s1/IxLpUs15uTMrcmIpDyVoEUhzSna
        j5uwV3BuEfPw77DhewG6nEo4tYGfTXE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-0vzUP_llN06Tx8kqXbhxXw-1; Mon, 22 Aug 2022 05:18:23 -0400
X-MC-Unique: 0vzUP_llN06Tx8kqXbhxXw-1
Received: by mail-ed1-f71.google.com with SMTP id r20-20020a05640251d400b00446e3eee8a1so704773edd.21
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 02:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=LBJ8MqhFUZNYzQi5G0vn7l4X961C4s/0d1vabFTY8yE=;
        b=GjnJ6cRejdgGK9kiAbrA/qxdES+kO0aJepwSi3tz7Fx1aGrhyCczFjFejkQ3vp1JEZ
         8Hy1yuEoJE1s5aB93rf2iJLj9+jFN6K+SdQ2hrReOj32pdEXljwYI3f/nxiW2/4/AML5
         DMTT5WIWVfF4e+m1iyl9PK9Z2KV7o2jYqvF60KOFwSRIRRFBpWcqGba34QpAoZbStJ3m
         g1zBo4pJ0YK7qQ/bbMY9uvFHGgJA8U0Wzl6L+jqk9ft2qckRfGxen5Y+bCBpzRKyojzi
         H1tJnedAQDU7nDXeO52KMNDlnzP1k+R2R3v/NHtt/XYH/kIPtM4j9AetW8CKTGvDKYTt
         IR0A==
X-Gm-Message-State: ACgBeo26PlFMo3amiIbt0Vm9YZT9o+bhWzOaavFMXT9l0U8qpvIm9AmZ
        zZNkTaa6BezD1CArUY5p6ZxvL9isSaYCJc+Ffp21tMmPHGAbND3xP+ynNkTXn0cgAr75CRw3T+f
        qenNgCb6VqmZi
X-Received: by 2002:a17:907:270b:b0:73d:6063:cd94 with SMTP id w11-20020a170907270b00b0073d6063cd94mr7310392ejk.672.1661159902122;
        Mon, 22 Aug 2022 02:18:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4FocjB1YZjZ7aq2dv7k0odYHf+Gi1UPhQRNP596sFTxTd2QzbtaiGvkL07tbphY0ompGhAJA==
X-Received: by 2002:a17:907:270b:b0:73d:6063:cd94 with SMTP id w11-20020a170907270b00b0073d6063cd94mr7310378ejk.672.1661159901855;
        Mon, 22 Aug 2022 02:18:21 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r17-20020aa7cfd1000000b0043ba7df7a42sm7826809edy.26.2022.08.22.02.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 02:18:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/26] x86/hyperv: Update 'struct
 hv_enlightened_vmcs' definition
In-Reply-To: <Yv59dZwP6rNUtsrn@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-4-vkuznets@redhat.com>
 <Yv5ZFgztDHzzIQJ+@google.com> <875yiptvsc.fsf@redhat.com>
 <Yv59dZwP6rNUtsrn@google.com>
Date:   Mon, 22 Aug 2022 11:18:20 +0200
Message-ID: <87czcsskkj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Aug 18, 2022, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
>> >> + * Note: HV_X64_NESTED_EVMCS1_2022_UPDATE is not currently documented in any
>> >> + * published TLFS version. When the bit is set, nested hypervisor can use
>> >> + * 'updated' eVMCSv1 specification (perf_global_ctrl, s_cet, ssp, lbr_ctl,
>> >> + * encls_exiting_bitmap, tsc_multiplier fields which were missing in 2016
>> >> + * specification).
>> >> + */
>> >> +#define HV_X64_NESTED_EVMCS1_2022_UPDATE		BIT(0)
>> >
>> > This bit is now defined[*], but the docs says it's only for perf_global_ctrl.  Are
>> > we expecting an update to the TLFS?
>> >
>> > 	Indicates support for the GuestPerfGlobalCtrl and HostPerfGlobalCtrl fields
>> > 	in the enlightened VMCS.
>> >
>> > [*] https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/feature-discovery#hypervisor-nested-virtualization-features---0x4000000a
>> >
>> 
>> Oh well, better this than nothing. I'll ping the people who told me
>> about this bit that their description is incomplete.
>
> Not that it changes anything, but I'd rather have no documentation.  I'd much rather
> KVM say "this is the undocumented behavior" than "the document behavior is wrong".
>

So I reached out to Microsoft and their answer was that for all these new
eVMCS fields (including *PerfGlobalCtrl) observing architectural VMX
MSRs should be enough. *PerfGlobalCtrl case is special because of Win11
bug (if we expose the feature in VMX feature MSRs but don't set
CPUID.0x4000000A.EBX BIT(0) it just doesn't boot).

What I'm still concerned about is future proofing KVM for new
features. When something is getting added to KVM for which no eVMCS
field is currently defined, both Hyper-V-on-KVM and KVM-on-Hyper-V cases
should be taken care of. It would probably be better to reverse our
filtering, explicitly listing features supported in eVMCS. The lists are
going to be fairly long but at least we won't have to take care of any
new architectural feature added to KVM.

-- 
Vitaly

