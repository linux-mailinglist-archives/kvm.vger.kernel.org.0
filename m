Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F024F1560C8
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 22:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgBGVqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 16:46:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727032AbgBGVqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 16:46:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581111989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vVYpZUcLEUs3sOrjbIqPes1hb8KpqKLOy5PIHOTaenw=;
        b=DNPZs/ZTXbpcd78wYKXK5zy5rMcLadeASUx4oh223JwOn2M2DhUMSc7AGfiEN7AZjcRxBG
        84GBoXF+GHfOpISz0GmeLbaB1IdF4uM1olpQBOmJsycUQJNCA5kZ8I5uHp39g6NqLTqd1K
        BAkYDZ0a0yCoYs1QF2ssHLXnkWtBxbA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-kK4iJePkMnmK8UVdKwo80g-1; Fri, 07 Feb 2020 16:46:27 -0500
X-MC-Unique: kK4iJePkMnmK8UVdKwo80g-1
Received: by mail-qv1-f72.google.com with SMTP id dc2so417699qvb.7
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 13:46:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vVYpZUcLEUs3sOrjbIqPes1hb8KpqKLOy5PIHOTaenw=;
        b=snchQOj1QmAxEnnhdP9MtnN1c3OSXBFzVKufZ8m99haIfAi+IZ+wgnE3vcEkiumaVO
         R7TQEH94CYzR8naN9+F9GTBh5TKLGTERHIUF23CHriNoovfwWqZW+1v3JnHAzswZEv/b
         MK+dOk2DUfeQ9JglzPkY85KDu1DZSf+H3rRS9fdOxwqJyGaRZLznFqbRbplpisuW/rjo
         wmLILuaN93IEb+OSI+ORtSVl0g9fxctQbHNuHW+tRG+Z5N8ha5AWLW7K7CuPXxBaV3fw
         BIn25qCCyCcW4jlw3C6cMhuZoC0tqj1R1M/gtgH4PNeGHSFYhMnmcfzMxHNztcVJael7
         fQug==
X-Gm-Message-State: APjAAAWp0SZ0yOcmBX63a0hKTFhIh1brlY1QsC0fJ3Iw3eD5lah0xkuk
        m6G9tOM60i6GttqGpywFKLHtFvJ3IUwS1U/pzETrIQdpZJQPgt9HYK+xalW+bTzCo1+4Wnj0BQd
        iaJXiMLptm00a
X-Received: by 2002:ae9:e910:: with SMTP id x16mr988288qkf.90.1581111987477;
        Fri, 07 Feb 2020 13:46:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqwxRGnu4XDnzwjnf0DDkOxM5HXmG3kOePeoAJPNmuK0HFHObXtw0rsBdJC1716CoqHguYzOkw==
X-Received: by 2002:ae9:e910:: with SMTP id x16mr988252qkf.90.1581111987166;
        Fri, 07 Feb 2020 13:46:27 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id t16sm1892401qkg.96.2020.02.07.13.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 13:46:26 -0800 (PST)
Date:   Fri, 7 Feb 2020 16:46:23 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 17/19] KVM: Terminate memslot walks via used_slots
Message-ID: <20200207214623.GF720553@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-18-sean.j.christopherson@intel.com>
 <20200206210944.GD700495@xz-x1>
 <20200207183325.GI2401@linux.intel.com>
 <20200207203909.GE720553@xz-x1>
 <20200207211016.GN2401@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200207211016.GN2401@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 01:10:16PM -0800, Sean Christopherson wrote:
> On Fri, Feb 07, 2020 at 03:39:09PM -0500, Peter Xu wrote:
> > On Fri, Feb 07, 2020 at 10:33:25AM -0800, Sean Christopherson wrote:
> > > On Thu, Feb 06, 2020 at 04:09:44PM -0500, Peter Xu wrote:
> > > > On Tue, Jan 21, 2020 at 02:31:55PM -0800, Sean Christopherson wrote:
> > > > > @@ -9652,13 +9652,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > > > >  		if (IS_ERR((void *)hva))
> > > > >  			return PTR_ERR((void *)hva);
> > > > >  	} else {
> > > > > -		if (!slot->npages)
> > > > > +		if (!slot || !slot->npages)
> > > > >  			return 0;
> > > > >  
> > > > > -		hva = 0;
> > > > > +		hva = slot->userspace_addr;
> > > > 
> > > > Is this intended?
> > > 
> > > Yes.  It's possible to allow VA=0 for userspace mappings.  It's extremely
> > > uncommon, but possible.  Therefore "hva == 0" shouldn't be used to
> > > indicate an invalid slot.
> > 
> > Note that this is the deletion path in __x86_set_memory_region() not
> > allocation.  IIUC userspace_addr won't even be used in follow up code
> > path so it shouldn't really matter.  Or am I misunderstood somewhere?
> 
> No, but that's precisely why I don't want to zero out @hva, as doing so
> implies that '0' indicates an invalid hva, which is wrong.
> 
> What if I change this to 
> 
> 			hva = 0xdeadull << 48;
> 
> and add a blurb in the changelog about stuff hva with a non-canonical value
> to indicate it's being destroyed.

IMO it's fairly common to have the case where "when A is XXX then
parameters B is invalid" happens in C.  OK feel free to keep any of
these as you prefer (how many times I spoke this only for today? :) as
long as the maintainers are fine with it.  And for sure an extra
comment would always be nice.

Thanks,

-- 
Peter Xu

