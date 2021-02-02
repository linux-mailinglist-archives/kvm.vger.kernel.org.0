Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689EF30BE11
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 13:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBBMTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 07:19:18 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:45062 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbhBBMRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 07:17:38 -0500
Received: by mail-wr1-f51.google.com with SMTP id m13so20217638wro.12;
        Tue, 02 Feb 2021 04:17:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FBeWZzUCdMq3pBgx5+PcKPDUM/kB3sWqP2EPObN81jI=;
        b=S/r7ayjOo3KYk5CxQfre+otcCUl3KeWcXhUi/rilLopiEcnuZzOQxrtGvWTQ4+wPn6
         rmKygxHXwrYKotJWlLWZr3+DZsFjeHDu2OrDYNSbSAugNZGValgtTUr2Y+hb6n4Ui6kr
         zLfaWxz1N7/C9LbZ8eVhK1hGZXIoZ9dP4ZNP/CB50dQFiCrvIB/vRYv9tkXKEtqsf9ik
         g/qMzug11bUBvkwpISdAz4ix1CuqfpGQu4ORNPQ/fW3Irx1iOKrg/uWWypmAh9tl+vz+
         l52gnqiMGiH0sf3bHXagookNOKIFjSOFQW+0ZFuRz0+OwEpZ2zuhFV0qXn6VkDfRz8Jv
         6ryw==
X-Gm-Message-State: AOAM533jI69XKlWXCyJrGYze03Sn8Q0Kqqyn30f6w1HeDQdNoIRIYtic
        A6l7pFg9kN2WsFZMHGG6nTpp/XkN0qg=
X-Google-Smtp-Source: ABdhPJw6msjE/OXXIu0YVq77lE72v+W6ZYKtX5OZDXoPxoQuKreJnPv74nV7vAch7oMU503EA3XFtg==
X-Received: by 2002:adf:902a:: with SMTP id h39mr23311414wrh.147.1612268216194;
        Tue, 02 Feb 2021 04:16:56 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id r11sm2875114wmh.9.2021.02.02.04.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 04:16:55 -0800 (PST)
Date:   Tue, 2 Feb 2021 12:16:54 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Wei Liu <wei.liu@kernel.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        kvm <kvm@vger.kernel.org>,
        Linux on Hyper-V List <linux-hyperv@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Nuno Das Neves <nunodasneves@linux.microsoft.com>,
        sameo@linux.intel.com, robert.bradford@intel.com,
        sebastien.boeuf@intel.com
Subject: Re: [PATCH v3 00/17] Introducing Linux root partition support for
 Microsoft Hypervisor
Message-ID: <20210202121654.5sscxniybt524b6s@liuwe-devbox-debian-v2>
References: <20201124170744.112180-1-wei.liu@kernel.org>
 <227127cf-bfea-4a06-fcbc-f6c46102e9e6@metux.net>
 <20201202232234.5buzu5wysiaro3hc@liuwe-devbox-debian-v2>
 <87d94c39-e801-fbc6-8f7f-1f1b00fa719d@metux.net>
 <20201215164245.yrorpipw2476w35e@liuwe-devbox-debian-v2>
 <c39553770dc895d7a4f172c337f3bad77642f131.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c39553770dc895d7a4f172c337f3bad77642f131.camel@infradead.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 10:40:43AM +0000, David Woodhouse wrote:
> On Tue, 2020-12-15 at 16:42 +0000, Wei Liu wrote:
> > On Tue, Dec 15, 2020 at 04:25:03PM +0100, Enrico Weigelt, metux IT consult wrote:
> > > On 03.12.20 00:22, Wei Liu wrote:
> > > 
> > > Hi,
> > > 
> > > > I don't follow. Do you mean reusing /dev/kvm but with a different set of
> > > > APIs underneath? I don't think that will work.
> > > 
> > > My idea was using the same uapi for both hypervisors, so that we can use
> > > the same userlands for both.
> > > 
> > > Are the semantis so different that we can't provide the same API ?
> > 
> > We can provide some similar APIs for ease of porting, but can't provide
> > 1:1 mappings. By definition KVM and MSHV are two different things. There
> > is no goal to make one ABI / API compatible with the other.
> 
> I'm not sure I understand.
> 
> KVM is the Linux userspace API for virtualisation. It is designed to be
> versatile enough that it can support multiple implementations across
> multiple architectures, including both AMD SVM and Intel VMX on x86.
> 
> Are you saying that KVM has *failed* to be versatile enough that this
> can be "just another implementation"? What are the problems? Is it
> unfixable? 

The KVM APIs are good enough to cover guest life cycle management. To
make MSHV another implementation of the KVM APIs, we essentially need to
massage the data structures both way.

They are There is also an aspect for controlling the hypervisor that
affect the whole virtualization system. KVM APIs don't handle those. We
would need /dev/mshv for that purpose alone.

There is another aspect for Microsoft Hypervisor specific features and
enhancements, which aren't applicable to KVM. Features make sense for a
specific type-1 hypervisor may not make sense for KVM (a type-2
hypervisor). We have no intention to pollute KVM APIs with those. 

All in all the latter two points make /dev/mshv is a more viable route
in the long run.

Wei.
