Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF23589C9
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhDHQad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:30:33 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:45659 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhDHQac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 12:30:32 -0400
Received: by mail-wr1-f49.google.com with SMTP id f6so2782960wrv.12;
        Thu, 08 Apr 2021 09:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F496zTMs/cLiMo2b9mYzLgl9Z8QdoE+o/DNCzI6MgkY=;
        b=qRmKp29Gbu+abI/zgMqwuTPIfNkSniOCrevF7rnMsgFFGPxPcJxOZ9RpKOY2Koh5uN
         50ROeQdI9VoyUeMMhAA1dJRh1dyk542xCzdMS1XtiM+Pr37/nQkZghrR0skWx4CSve2L
         zdhGWbN+TR+sNd2HsF/5ly+AMJKv7zqwrVXHVRaxhmEJwTvk14KvpqyhIoiW0YK9Cshs
         /vvq763CYp/MJFQK7ULm33ID+urfqWcjFJ3mpqyNCZSeVMinR1MNnQTDKEJg95ilH6u6
         NeagzcC2u96Y5NmEA4T0gtHPFrtcd/l5PWJ9aKjDB3Ky0q/hbR+2shNbGZVVDHndU/GV
         IWTA==
X-Gm-Message-State: AOAM533/Naj2kGCSoAqo7ctK7+mWjtiSG2M+Zmw0v+tErWgr2Ff7j0yp
        iaUmJpBWO7413i3KozkTGgc=
X-Google-Smtp-Source: ABdhPJzu9VwCOtcF4a86gsoB2sZ59A2GDYEVvAXWTOc+xe3vNUmDqkMYDVTfktJ9g6vHQhOeXj1OXA==
X-Received: by 2002:adf:e38a:: with SMTP id e10mr12738849wrm.37.1617899420267;
        Thu, 08 Apr 2021 09:30:20 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id o14sm39776289wrh.88.2021.04.08.09.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 09:30:20 -0700 (PDT)
Date:   Thu, 8 Apr 2021 16:30:18 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Wei Liu <wei.liu@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        graf@amazon.com, eyakovl@amazon.de, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] Add support for XMM fast hypercalls
Message-ID: <20210408163018.mlr23jd2r4st54jc@liuwe-devbox-debian-v2>
References: <20210407212926.3016-1-sidcha@amazon.de>
 <20210408152817.k4d4hjdqu7hsjllo@liuwe-devbox-debian-v2>
 <033e7d77-d640-2c12-4918-da6b5b7f4e21@redhat.com>
 <20210408154006.GA32315@u366d62d47e3651.ant.amazon.com>
 <53200f24-bd57-1509-aee2-0723aa8a3f6f@redhat.com>
 <20210408155442.GC32315@u366d62d47e3651.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408155442.GC32315@u366d62d47e3651.ant.amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 05:54:43PM +0200, Siddharth Chandrasekaran wrote:
> On Thu, Apr 08, 2021 at 05:48:19PM +0200, Paolo Bonzini wrote:
> > On 08/04/21 17:40, Siddharth Chandrasekaran wrote:
> > > > > > Although the Hyper-v TLFS mentions that a guest cannot use this feature
> > > > > > unless the hypervisor advertises support for it, some hypercalls which
> > > > > > we plan on upstreaming in future uses them anyway.
> > > > > No, please don't do this. Check the feature bit(s) before you issue
> > > > > hypercalls which rely on the extended interface.
> > > > Perhaps Siddharth should clarify this, but I read it as Hyper-V being
> > > > buggy and using XMM arguments unconditionally.
> > > The guest is at fault here as it expects Hyper-V to consume arguments
> > > from XMM registers for certain hypercalls (that we are working) even if
> > > we didn't expose the feature via CPUID bits.
> >
> > What guest is that?
> 
> It is a Windows Server 2016.

Can you be more specific? Are you implementing some hypercalls from
TLFS? If so, which ones?

Wei.
