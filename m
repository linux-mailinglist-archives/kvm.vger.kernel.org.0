Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821BF5309AF
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 08:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiEWGyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 02:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiEWGyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 02:54:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CC2454FA9
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 23:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653288640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6or0LDEr8+Nq81Rkj47r4fBHy8teKoRGQNGc1avEiUw=;
        b=Z23L5CX02ZkusNKCa8G7FcJkvF68aT8t2h630TguCnRAqfBfe8cIrNzvhEIyWPwnsJFBXq
        Pe+GXwG2qUOC2rLPO6zsjBBtCPXx9T3KgcRNk64Uf38DtT0MY/HoeBkoCa193yTCuuTgwR
        cDXfM9xcVubH+3+3BYgnFUQYZc50n8Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-eUJsIwmcNCqspPyOcQzEDw-1; Mon, 23 May 2022 02:50:33 -0400
X-MC-Unique: eUJsIwmcNCqspPyOcQzEDw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43A08801210;
        Mon, 23 May 2022 06:50:32 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C58041047E8;
        Mon, 23 May 2022 06:50:25 +0000 (UTC)
Message-ID: <65991ac329a32cf4128400b643d5b5ccf3918cfe.camel@redhat.com>
Subject: Re: [RFC PATCH v3 02/19] KVM: x86: inhibit APICv/AVIC when the
 guest and/or host changes apic id/base from the defaults.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Date:   Mon, 23 May 2022 09:50:24 +0300
In-Reply-To: <CALMp9eSVji2CPW1AjFoSbWZ_b-r3y67HyatgdqXEqSyUaD1_BQ@mail.gmail.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
         <20220427200314.276673-3-mlevitsk@redhat.com> <YoZrG3n5fgMp4LQl@google.com>
         <e32f6c904c92e9e9efabcc697917a232f5e88881.camel@redhat.com>
         <CALMp9eSVji2CPW1AjFoSbWZ_b-r3y67HyatgdqXEqSyUaD1_BQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-05-22 at 07:47 -0700, Jim Mattson wrote:
> On Sun, May 22, 2022 at 2:03 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > On Thu, 2022-05-19 at 16:06 +0000, Sean Christopherson wrote:
> > > On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> > > > Neither of these settings should be changed by the guest and it is
> > > > a burden to support it in the acceleration code, so just inhibit
> > > > it instead.
> > > > 
> > > > Also add a boolean 'apic_id_changed' to indicate if apic id ever changed.
> > > > 
> > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > ---
> > > > +           return;
> > > > +
> > > > +   pr_warn_once("APIC ID change is unsupported by KVM");
> > > 
> > > It's supported (modulo x2APIC shenanigans), otherwise KVM wouldn't need to disable
> > > APICv.
> > 
> > Here, as I said, it would be nice to see that warning if someone complains.
> > Fact is that AVIC code was totally broken in this regard, and there are probably more,
> > so it would be nice to see if anybody complains.
> > 
> > If you insist, I'll remove this warning.
> 
> This may be fine for a hobbyist, but it's a terrible API in an
> enterprise environment. To be honest, I have no way of propagating
> this warning from /var/log/messages on a particular host to a
> potentially impacted customer. Worse, if they're not the first
> impacted customer since the last host reboot, there's no warning to
> propagate. I suppose I could just tell every later customer, "Your VM
> was scheduled to run on a host that previously reported, 'APIC ID
> change is unsupported by KVM.' If you notice any unusual behavior,
> that might be the reason for it," but that isn't going to inspire
> confidence. I could schedule a drain and reboot of the host, but that
> defeats the whole point of the "_once" suffix.

Mostly agree, and I read alrady few discussions about exactly this,
those warnings are mostly useless, but they are used in the
cases where we don't have the courage to just exit with KVM_EXIT_INTERNAL_ERROR.

I do not thing though that the warning is completely useless, 
as we often have the kernel log of the target machine when things go wrong, 
so *we* can notice it.
In other words a kernel warning is mostly useless but better that nothing.

About KVM_EXIT_WARNING, this is IMHO a very good idea, probably combined
with some form of taint flag, which could be read by qemu and then shown
over hmp/qmp interfaces.

Best regards,
	Maxim levitsky


> 
> I know that there's a long history of doing this in KVM, but I'd like
> to ask that we:
> a) stop piling on
> b) start fixing the existing uses
> 
> If KVM cannot emulate a perfectly valid operation, an exit to
> userspace with KVM_EXIT_INTERNAL_ERROR is warranted. Perhaps for
> operations that we suspect KVM might get wrong, we should have a new
> userspace exit: KVM_EXIT_WARNING?
> 
> I'm not saying that you should remove the warning. I'm just asking
> that it be augmented with a direct signal to userspace that KVM may no
> longer be reliable.
> 


