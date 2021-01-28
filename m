Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4D7307C8C
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhA1Rc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbhA1RcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 12:32:06 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3359C0613ED
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:31:25 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d4so3722644plh.5
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zIagq1YDMcPdDHzt52n/d63p8sKRlhuykJwtOQfmzH0=;
        b=YOr5TGykBESlapnBvS7QSxHnSeB39NpKKDWZDDP8tpTF3zRtSXOx1k0OyZ2v29JDKF
         pHtN2SdYfJYxfV5pjPQPg/sFoya3Jyi5/6xjChw8eqgubgTihe+LsXZi/3zmitYasu9j
         /LBCCTMUb/VJ0quBC5hD21lU6R8zfCUHidXKFK1aDTqExBs7qdu5jWeeYCSA39+Hu1y6
         WmDFRKblRdBx0rWYojhrmtQd/tWOuLzy7iiIYfMacWgyDYEbfavVhJ8IV/tM2NJ39Dam
         Zt00QIzG3qM0vDrao7aPuFJwkp04qU6ojFsZ5hfeguX74yo3Z0N+zJ8c9IsaUnQ9n3Vd
         BEAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zIagq1YDMcPdDHzt52n/d63p8sKRlhuykJwtOQfmzH0=;
        b=ZWMH8V8jDyDYrOvbRN2ZIM/42LVOILdTaRyB3VqILmT1szNqSmzME5+UnEWFji0+Il
         D8lYJlaCMIHOmWF0kMqbasOg2JmtBr6FvY0lKGKYAdy7feZs4GWOTqPGqri40GIxgCqe
         pzPsnA873G7BudD4kaB7bJI7hQobXFX7yLiDpKsqlUXdZLgklgQ6pHALkK+HiTIXDRb9
         vbqV6aZQke0onUrvDtKmgrfReEoCKyEpG8bVxv+aWhVgiwTVrcAc/BLNCknwuRj9N7c5
         5hFvuayhyiL1cmBWb5NN40AWenvkJlT1zyl3VyLIfarw5kbgVM8ZaS1DNmoQ63te/A9I
         U3Xw==
X-Gm-Message-State: AOAM531Jw7KolazPr+aAPPrpQJtelSJ+ZVeMJqSeqLoVffjlT+Os7rlM
        UHphxORsXSYABbiuiMXLDsQ3lw==
X-Google-Smtp-Source: ABdhPJyAf9lphOX4ca5uDEZU62YNcMWtKETJ7kHemEukcEWO1yqerkDOZTiALJpThFYyXYTNlaJ0Gw==
X-Received: by 2002:a17:90a:e656:: with SMTP id ep22mr422462pjb.127.1611855085301;
        Thu, 28 Jan 2021 09:31:25 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a19sm5978447pff.186.2021.01.28.09.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 09:31:24 -0800 (PST)
Date:   Thu, 28 Jan 2021 09:31:18 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [PATCH 1/5] KVM: Make the maximum number of user memslots a
 per-VM thing
Message-ID: <YBL05tbdt9qupGDZ@google.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
 <20210127175731.2020089-2-vkuznets@redhat.com>
 <09f96415-b32d-1073-0b4f-9c6e30d23b3a@oracle.com>
 <877dnx30vv.fsf@vitty.brq.redhat.com>
 <5b6ac6b4-3cc8-2dc3-cd8c-a4e322379409@oracle.com>
 <34f76035-8749-e06b-2fb0-f30e295f6425@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34f76035-8749-e06b-2fb0-f30e295f6425@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 28, 2021, Paolo Bonzini wrote:
> On 28/01/21 11:48, Maciej S. Szmigiero wrote:
> > > 
> > > VMMs (especially big ones like QEMU) are complex and e.g. each driver
> > > can cause memory regions (-> memslots in KVM) to change. With this
> > > feature it becomes possible to set a limit upfront (based on VM
> > > configuration) so it'll be more obvious when it's hit.
> > > 
> > 
> > I see: it's a kind of a "big switch", so every VMM doesn't have to be
> > modified or audited.
> > Thanks for the explanation.
> 
> Not really, it's the opposite: the VMM needs to opt into a smaller number of
> memslots.

Yep, my thinking is that it would be similar to using seccomp to prevent doing
something that should never happen.

> I don't know... I understand it would be defense in depth, however between
> dynamic allocation of memslots arrays and GFP_KERNEL_ACCOUNT, it seems to be
> a bit of a solution in search of a problem.

I'm a-ok waiting to add a capability until there's a VMM that actually wants to
use it.

> For now I applied patches 1-2-5.

Why keep patch 1?  Simply raising the limit in patch 2 shouldn't require per-VM
tracking.  The 'memslots_max' name is also ambiguous.  In my head, the new
capability would restrict the _number_ of memslots, but as implemented in
patches 1+3 it restrists the max _ID_ of a memslot.  Limiting the max ID also
effectively limits that max number of memslots, but that approach confuses
things since the IDs themselves do not affect memory consumption.  Limiting the
IDs bleeds the old implementation details into the ABI.
