Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C6738A3AD
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 11:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhETJ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 05:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbhETJwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 05:52:32 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E895FC07E5C1;
        Thu, 20 May 2021 02:32:07 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x188so11922745pfd.7;
        Thu, 20 May 2021 02:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HLfcO/MecS4+rtd6Pd4VQw8XBO3rw/gjM5Y8RjQr1Ds=;
        b=hmbUgAfMKfKl6L8zVr8C4kuv+fzJpbOFoDCK3X2SnwJDb7AzoGF8V5mY//xvNZ91OR
         BMyw6GS5vbB5z4dJSPoOuiBmYJCHYLA945ohnJ7UU2bpAi5Gl40wwgxxAIspD3Xtrp2g
         OCcbB3g+rMVDJ5oxjtsBhVN4a/QvyuUUEuNk7FaNr+gqw48VDXugM3Dngebou3mKHqc4
         EQTJv4Uxpl2lKdiDbTm2jyCf2a3ZDpukZMngYRhf0JsTZqRZQCQ1BijA+dz6vhkDsJg0
         QUTtGmec67/GS6UYn264mjcQvSSiEvN2hoHM5usWL72NtPms4rU28fW/yg8V66I+Hpit
         RfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HLfcO/MecS4+rtd6Pd4VQw8XBO3rw/gjM5Y8RjQr1Ds=;
        b=t5KO7rLVGsLLAbYtFPttr/TLxMTzqeSe+LJqsT1O/zD4AbBorTJmPGSxzhzySYpXbt
         aW1oZ10gWGcbC/f/rB+5UeZ3+uboRYykZNLHN/ml6BRF7CYi0wkUgPO15rO8tIR68fWG
         AG7VRvh5xmzCLc8LI50Y8mGo3HTP2ek4pQhrgw/YTV1qVVb5VGre2v4HF4jm48FrM3Mo
         EAUnhYqdp+29XEVqunoXEqzgQqsjm4bzSe4K9NpJ1fkPbrA0WONUZcJ9JBsfwJnAmQeT
         hum675C4HUxiTe8UFy/zZc2CSyqEWAqcl2hu0KBKcTEdZIx1mVt4pxOvH9O1DYwsahv8
         20rw==
X-Gm-Message-State: AOAM531ssCkKnovW5mgxvmFB9mXmOawOjh5LdxqtdpRyDIm6IZgKU6Os
        qL9ALJtC3TFJOlyPaF/zw/8=
X-Google-Smtp-Source: ABdhPJySK9IhwVTlxZj17iML3cV3LYHRtDOolrJuxa9X3Das7Yp30fDO44U/UJ8d5pYuXGyH3TrtzA==
X-Received: by 2002:a62:6481:0:b029:249:ecee:a05d with SMTP id y123-20020a6264810000b0290249eceea05dmr3648202pfb.9.1621503127359;
        Thu, 20 May 2021 02:32:07 -0700 (PDT)
Received: from localhost (public-nat-08.vpngate.v4.open.ad.jp. [219.100.37.240])
        by smtp.gmail.com with ESMTPSA id t1sm1557398pjo.33.2021.05.20.02.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 02:32:06 -0700 (PDT)
Date:   Thu, 20 May 2021 02:31:55 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Connor Kuehl <ckuehl@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH 00/67] KVM: X86: TDX support
Message-ID: <20210520093155.GA3602295@private.email.ne.jp>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
 <3edc0fb2-d552-88df-eead-9e2b80e79be4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3edc0fb2-d552-88df-eead-9e2b80e79be4@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 11:37:23AM -0500,
Connor Kuehl <ckuehl@redhat.com> wrote:

> On 11/16/20 12:25 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > * What's TDX?
> > TDX stands for Trust Domain Extensions which isolates VMs from
> > the virtual-machine manager (VMM)/hypervisor and any other software on
> > the platform. [1]
> > For details, the specifications, [2], [3], [4], [5], [6], [7], are
> > available.
> > 
> > 
> > * The goal of this RFC patch
> > The purpose of this post is to get feedback early on high level design
> > issue of KVM enhancement for TDX. The detailed coding (variable naming
> > etc) is not cared of. This patch series is incomplete (not working).
> > Although multiple software components, not only KVM but also QEMU,
> > guest Linux and virtual bios, need to be updated, this includes only
> > KVM VMM part. For those who are curious to changes to other
> > component, there are public repositories at github. [8], [9]
> 
> Hi,
> 
> I'm planning on reading through this patch set; but before I do, since
> it's been several months and it's a non-trivially sized series, I just
> wanted to confirm that this is the latest revision of the RFC that
> you'd like comments on. Or, if there's a more recent series that I've
> missed, I would be grateful for a pointer to it.

Hi. I'm planning to post rebased/updated v2 soon. Hopefully next week.
So please wait for it. It will include non-trivial change and catch up for the updated spec.

Thanks,

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
