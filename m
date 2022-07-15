Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202CA5760B5
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 13:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbiGOLnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 07:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiGOLn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 07:43:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 082FE88CC8
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 04:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657885407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ki/rg86NxH+wVXrdnmin0JzoM5KA471l52TevDjA+74=;
        b=gmGJ3Y5ATUZPwfEq9QrYgbiAF/M6in7TeIHKm9Om3MRSuWfrX3+LQdvpthKf0/X1juxIZ0
        niWb/cXMBmUAY+7kPtieUFUhGVfRWB6L23kM1vyDEiHEeSTqKlp99p7ZmyqQzCQoLOolP/
        BvrN/qBCCXXqnrsrmQ5xYtVWRpECbhc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-FOEZjTu1NbKFgWHLLAMSXQ-1; Fri, 15 Jul 2022 07:43:26 -0400
X-MC-Unique: FOEZjTu1NbKFgWHLLAMSXQ-1
Received: by mail-wm1-f70.google.com with SMTP id n18-20020a05600c501200b003a050cc39a0so1877176wmr.7
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 04:43:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ki/rg86NxH+wVXrdnmin0JzoM5KA471l52TevDjA+74=;
        b=dVWloW+88ePigYtYE9SSxXxY1pdbG3cStEwAAac+wn3qkZnqiAMkI7XmFKN7AUVrlm
         IrabbI5SPF1+G5m1Ywug87AdJGpvEHA+thXDPNhsmIwnr2crGl7rPemWlVNhh7ZtXlP0
         IqrFK+XuU3wA/dE8X52zDbykupJY33oyXWCJKQWSCnspNAeO8qil+LFkHZt+f0qhwFIX
         kiTYPEW3gWmW7qP9jhlYjjkdudKnYCYbGgJP7Vf85uPp2+FoBZanjg3WQquqSFLjJYV7
         5AfJUNtnAUDDoJjFrKIewvNLC915sCrcZw9/II392kta89+SEH6nL4R3ANBBom1oiwhJ
         As/A==
X-Gm-Message-State: AJIora+igV2txymc4w2vxE+dJLmyEsyGglAVRhEWrNHdpDOjNWbFGG6h
        DTrScxPaLfHp2sXTNGyfZWuYb11CNKKtPKhRo520JTrM/hq+DsJj1QefOIMiCERM+th9hJqy75V
        VozWbxRt7lGwD
X-Received: by 2002:a05:600c:4e90:b0:3a0:57d6:4458 with SMTP id f16-20020a05600c4e9000b003a057d64458mr13918813wmq.198.1657885404934;
        Fri, 15 Jul 2022 04:43:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1voIa5Xp8Y0zIi2+lyef5dLJtzpVn4q2JN57Y+LEI7F2eUcC5n0x/9efIPGFXDC6NoCXzKKcA==
X-Received: by 2002:a05:600c:4e90:b0:3a0:57d6:4458 with SMTP id f16-20020a05600c4e9000b003a057d64458mr13918780wmq.198.1657885404641;
        Fri, 15 Jul 2022 04:43:24 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m24-20020a056000181800b0021d68e1fd42sm3655846wrh.89.2022.07.15.04.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 04:43:23 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info)
 sub-leaves, if present
In-Reply-To: <Ys2E2ckrk0JtDl52@google.com>
References: <20220629130514.15780-1-pdurrant@amazon.com>
 <YsynoyUb4zrMBhRU@google.com>
 <369c3e9e02f947e2a2b0c093cbddc99c@EX13D32EUC003.ant.amazon.com>
 <Ys2E2ckrk0JtDl52@google.com>
Date:   Fri, 15 Jul 2022 13:43:22 +0200
Message-ID: <87ilnymwit.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jul 12, 2022, Durrant, Paul wrote:
>> > > @@ -1855,3 +1858,51 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
>> > >       if (kvm->arch.xen_hvm_config.msr)
>> > >               static_branch_slow_dec_deferred(&kvm_xen_enabled);
>> > >  }
>> > > +
>> > > +void kvm_xen_after_set_cpuid(struct kvm_vcpu *vcpu)
>> > > +{
>> > > +     u32 base = 0;
>> > > +     u32 limit;
>> > > +     u32 function;
>> > > +
>> > > +     vcpu->arch.xen.cpuid_tsc_info = 0;
>> > > +
>> > > +     for_each_possible_hypervisor_cpuid_base(function) {
>> > > +             struct kvm_cpuid_entry2 *entry = kvm_find_cpuid_entry(vcpu, function, 0);
>> > > +
>> > > +             if (entry &&
>> > > +                 entry->ebx == XEN_CPUID_SIGNATURE_EBX &&
>> > > +                 entry->ecx == XEN_CPUID_SIGNATURE_ECX &&
>> > > +                 entry->edx == XEN_CPUID_SIGNATURE_EDX) {
>> > > +                     base = function;
>> > > +                     limit = entry->eax;
>> > > +                     break;
>> > > +             }
>> > > +     }
>> > > +     if (!base)
>> > > +             return;
>> > 
>> > Rather than open code a variant of kvm_update_kvm_cpuid_base(), that helper can
>> > be tweaked to take a signature.  Along with a patch to provide a #define for Xen's
>> > signature as a string, this entire function becomes a one-liner.
>> > 
>> 
>> Sure, but as said above, we could make capturing the limit part of the
>> general function too. It could even be extended to capture the Hyper-V
>> base/limit too.  As for defining the sig as a string... I guess it would be
>> neater to use the values from the Xen header, but it'll probably make the
>> code more ugly so a secondary definition is reasonable.
>
> The base needs to be captured separately for KVM and Xen because KVM (and presumably
> Xen itself since Xen also allows a variable base) supports advertising multiple
> hypervisors to the guest.  I don't know if there are any guests that will concurrently
> utilize multiple hypervisor's paravirt features, so maybe we could squeak by, but
> saving 4 bytes isn't worth the risk.
>
> AFAIK, Hyper-V doesn't allow for a variable base, and so doesn't utilize the
> for_each_possible... macro.

FWIW, this matches my understanding too: Windows guests don't seem to
check anything besides 0x40000001 and give up if Hyper-V's id is not
there.

-- 
Vitaly

