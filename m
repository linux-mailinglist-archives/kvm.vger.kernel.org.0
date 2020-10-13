Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A3228CB01
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 11:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404082AbgJMJ3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 05:29:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50742 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404002AbgJMJ3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 05:29:00 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602581338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i1O8s2NVMzbyTSIoC4o/Bwar79MyscBpN/wzySOZcMw=;
        b=uW10zmnCzpx8UpyrI4zhoFNOFIHWmSBmaIKQ1uNCVYOuvlE6I3feCA/I+xTDsa8G+BjPVX
        jloVQ462c1Fz+bO9mauuDLjZeaz2foRoWuuwKFIn2y5N8iMVDxc9HZLfHDoeS9xTJe48Et
        VjMgzM0okp4b33094pb3/81t14Rqb4rWrwwLXtZXMLD8G/IQISUbl3xsNA5w6/RS4/hnfB
        9xS857zBSaJLvqOPjjqVLm/7PVx8+n0ND0DxdIy3I1Tfk0MQWRRgRGnplyaudWsAzY9FsH
        cQIDl7eF8JJdE2kVGMnFP/I0s6VYa/xehQvK5hI44hlxA+xL5xRHGq4iHEFEpw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602581338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i1O8s2NVMzbyTSIoC4o/Bwar79MyscBpN/wzySOZcMw=;
        b=RmYf0hPn7lHf2YQ43+wjz+Den8N3u/H2ix92RASeMAwPOXCiE+bCDz5igYTzwmrHv79p30
        KC35nfQ7sEgB+hAg==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <0de733f6384874d68afba2606119d0d9b1e8b34e.camel@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org>
 <20201007122046.1113577-1-dwmw2@infradead.org>
 <20201007122046.1113577-5-dwmw2@infradead.org>
 <87blhcx6qz.fsf@nanos.tec.linutronix.de>
 <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org>
 <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org>
 <87362owhcb.fsf@nanos.tec.linutronix.de>
 <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org>
 <87tuv4uwmt.fsf@nanos.tec.linutronix.de>
 <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org>
 <874kn2s3ud.fsf@nanos.tec.linutronix.de>
 <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org>
 <87pn5or8k7.fsf@nanos.tec.linutronix.de>
 <F0F0A646-8DBA-4448-933F-993A3335BD59@infradead.org>
 <87ft6jrdpk.fsf@nanos.tec.linutronix.de>
 <25c54f8e5da1fd5cf3b01ad2fdc1640c5d86baa1.camel@infradead.org>
 <87362jqoh3.fsf@nanos.tec.linutronix.de>
 <1abc2a34c894c32eb474a868671577f6991579df.camel@infradead.org>
 <87eem3ozxd.fsf@nanos.tec.linutronix.de>
 <0de733f6384874d68afba2606119d0d9b1e8b34e.camel@infradead.org>
Date:   Tue, 13 Oct 2020 11:28:58 +0200
Message-ID: <87zh4qo4o5.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 13 2020 at 08:52, David Woodhouse wrote:
> On Tue, 2020-10-13 at 00:13 +0200, Thomas Gleixner wrote:
> +       dom = irq_find_matching_fwspec(fwspec, DOMAIN_BUS_IR);
> +       if (dom)
> +               return IS_ERR(dom) ? NULL : dom;
> +
> +       return x86_vector_domain;
> +}
>
> Ick. There's no need for that.
>
> Eliminating that awful "if not found then slip the x86_vector_domain in
> as a special case" was the whole *point* of using
> irq_find_matching_fwspec() in the first place.

The point was to get rid of irq_remapping_get_irq_domain().

And TBH,

        if (apicid_valid(32768))

is just another way to slip the vector domain in. It's just differently
awful.

Having an explicit answer from the search for IR:

    - Here is the domain
    - Your device is not registered properly
    - IR not enabled or not supported

is way more obvious than the above disguised is_remapping_enabled()
check.

Thanks,

        tglx
