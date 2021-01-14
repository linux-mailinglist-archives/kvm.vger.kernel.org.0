Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187882F67D2
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 18:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbhANRfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 12:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbhANRfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 12:35:38 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746E5C061574
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 09:34:58 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b5so3599900pjk.2
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 09:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7+wptAskGDjPCM/rtSd9GeVD54civZ0IhTr0BYervcE=;
        b=h0Vzkd89olpKGDIiVF7JgUQgbc4qq8f54PO9VAiv0SLf1yToAF7HSVm+dfVS+xVSZS
         WxtVjR2//GZX/ZlQ51FRTqE/QHI+r0wK3jmdp+3H2wphXOR+fcrAThHeW0vyNAB9VDQK
         GbVu7xyxJqYpqNiokerPhHZOh88Y4ZI9HYPOZ314YtvsDzbvgaV/F3UDhJ7/0mVrPpKX
         9Rm0H9zOnH62+L0x/Yf7kBuc4GUmrT5Wm5TYh55eWunlNuKkivQevoYLyp/UPzLO8mO5
         eJVZP6nW7c5MWru5b+OvjRblx6sWfNJUsOI6LUvkTen+BJKAj7gvYnqOAhOQvzQuDDqm
         j82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7+wptAskGDjPCM/rtSd9GeVD54civZ0IhTr0BYervcE=;
        b=saiIx2iQJ2ZTjbKMRpiC5Yfk3LI7R+fCJMPwWh2gax/As28Gepd6Oa1jURRcMXpJpR
         dvMqoDW52KNeERJs2NbGhJIMTNxwQ4IGPXtdNsx2oCXpYzTrhVlQkVeAw6C5pH1gQJGg
         R4XxbMy9FD5t3rooJpsPbNYpybxOSqkp0bJmLtWP0mC7CYtKGPWhtgZ3BscUPL4ZDMi/
         zb+7rEoSypdOWcRC9KHOvqibh1Va2ANIST11Kdq4I8V7UrjuCGM+NrvTUc1olKHBQQJL
         rY/YAVw6wtAjpRd2aI7YTop+YlqMPtcKgHlVUTm6b/af8iTtzckqc7sP56JmCZ0dUbGG
         OO1w==
X-Gm-Message-State: AOAM533tYnsbmWEMVgOKQ84GxfwtICgOzTHEpJ1fJCS4M8ez5b5nxIuq
        rZlvyJdxV2Ga/rANK1Mc6Pa1XA==
X-Google-Smtp-Source: ABdhPJyWu31+NHrAEdDgt75PYbXBAWB13kUeru9konpXj1/8XYbvlOH+vGoiZx5eczD5HHbL9dqtxA==
X-Received: by 2002:a17:902:ee05:b029:dd:f952:db11 with SMTP id z5-20020a170902ee05b02900ddf952db11mr8409438plb.42.1610645697892;
        Thu, 14 Jan 2021 09:34:57 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 84sm6194330pfy.9.2021.01.14.09.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 09:34:57 -0800 (PST)
Date:   Thu, 14 Jan 2021 09:34:50 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 6/7] KVM: x86: hyper-v: Make Hyper-V emulation enablement
 conditional
Message-ID: <YACAunykMZWrbMwm@google.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
 <20210113143721.328594-7-vkuznets@redhat.com>
 <X/9c9PuAd4XJM4IR@google.com>
 <87v9bz7sdk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9bz7sdk.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Jan 13, 2021, Vitaly Kuznetsov wrote:
> >> Hyper-V emulation is enabled in KVM unconditionally. This is bad at least
> >> from security standpoint as it is an extra attack surface. Ideally, there
> >> should be a per-VM capability explicitly enabled by VMM but currently it
> >
> > Would adding a module param buy us anything (other than complexity)?
> >
> 
> A tiny bit, yes. This series is aimed at protecting KVM from 'curious
> guests' which can try to enable Hyper-V emulation features even when
> they don't show up in CPUID. A module parameter would help to protect
> against a malicious VMM which can still enable all these features. What
> I'm not sure about is how common Linux-guests-only deployments (where
> the parameter can actually get used) are as we'll have to keep it
> 'enabled' by default to avoid breaking existing deployments.

I always forget that these "optional" features aren't so optional for Windows
guests.  Given that, it does seem like a module param would be of dubious value.

What I really want for my own personal development is a Kconfig option to turn
it off completely and shave a few cycles of build time, but I can't even justify
that to myself :-)
