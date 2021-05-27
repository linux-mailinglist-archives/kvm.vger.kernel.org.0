Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24201393518
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 19:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhE0Rry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 13:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhE0Rry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 13:47:54 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6119C061574
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 10:46:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ne24-20020a17090b3758b029015f2dafecb0so883950pjb.4
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 10:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YtqAlXPQt1T2JrtUyEkVQDlTKGQ+sdL4dRMoAS4R4r0=;
        b=IvU45LVFCK5JRoORd+87dtJpuDvOgeuf45PK+XrNSI4FiiGvADIhbeVA23gCXwikn4
         3MEwK6C16xrYDiKXI0CBcVuIduXZNPhgmlVgcHidYz+3LmevUQFprpgm68I6vrRK3eSt
         ihnBKZS44UIWrhKbA6/OWk1E827wVgcgbW9Fk4LGgZ/cWzShF1VCy9Vd12vR39F9blGN
         alPFhLbnW0NlUQ4Vmc72hRCiDs/MCDpebAdhCykgl2ypxEdP4fDIcCkRnpS5EFipx+fq
         RHe9x0bJ28ukr757Bn+V9pEIY56oR7HF6T9lfBmkUGBg0rG45rjOzu/4w1R42HCNjZcP
         BEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YtqAlXPQt1T2JrtUyEkVQDlTKGQ+sdL4dRMoAS4R4r0=;
        b=bLurXQtlGhJxx1cktvgAZw3OfEzXwTh+NzDrHUZFIrP5O7K0T35nw8T0m9G5uIO6lI
         J8fsc2r6vLW+jbPrZ+U8lJRLNGr4zp505tNeaw0FXTclcOPrezy/gucGtyqyWnt7U3Si
         tdd0qcNPv1siYDblrrKZXe16h7YybMqJ9TuFPZWA0A2lOktZgsKWAMpfWj/FFtKg6p96
         kcsMraub//BiMr9UvxUMr8PdQKqycfJvDXw22uY0BJbLVto7uTXQlFqpxOy0DI2RCtBn
         PGFQzPTobk86axaOWfUlbLxhAXnvbSCHAx03Il+VuS36feN39I13PPv0V7v2WTv6Uu8V
         Z4nw==
X-Gm-Message-State: AOAM532uGvSliRa2PMcMeZ5pmI0xUfpV68J97aQCpkV+Eu3x2d+DBudK
        yazM/XSUaqH7ZYhxrXJYq6U+Pw==
X-Google-Smtp-Source: ABdhPJz0xI+lZUlax8M3LrA6JtZHnsjxGVbhla/TeyfBZxxTSjOOTG5lWxYHYZM2oY9Ie32ix0BiFg==
X-Received: by 2002:a17:902:70c1:b029:ef:652c:cbb5 with SMTP id l1-20020a17090270c1b02900ef652ccbb5mr4298592plt.14.1622137580136;
        Thu, 27 May 2021 10:46:20 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 4sm2299271pgn.31.2021.05.27.10.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 10:46:19 -0700 (PDT)
Date:   Thu, 27 May 2021 17:46:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 4/4 v2] KVM: x86: Add a new VM statistic to show number
 of VCPUs created in a given VM
Message-ID: <YK/a51NqmQNyqNhE@google.com>
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
 <20210520005012.68377-5-krish.sadhukhan@oracle.com>
 <YKZ6a6UlJt/r985F@google.com>
 <e7c6c2c8-87e5-96ca-5ec6-d28dda16b603@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7c6c2c8-87e5-96ca-5ec6-d28dda16b603@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021, Krish Sadhukhan wrote:
> 
> On 5/20/21 8:04 AM, Sean Christopherson wrote:
> > On Wed, May 19, 2021, Krish Sadhukhan wrote:
> > > 'struct kvm' already has a member for counting the number of VCPUs created
> > > for a given VM. Add this as a new VM statistic to KVM debugfs.
> > Huh!??  Why?  Userspace is the one creating the vCPUs, it darn well should know
> > how many it's created.
> 
> If I am providing a host for users to create VMs, how do I know who creates
> how many VCPUs ? This statistic is intended show usage of VCPU resources on
> a host used by customers.

How are reviewers supposed to know that that's the use case?  Use the changelog
to state _why_ a patch is needed/justified.

> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index cbca3609a152..a9d27ce4cc93 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -258,6 +258,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
> > >   	VM_STAT("nx_largepages_splitted", nx_lpage_splits, .mode = 0444),
> > >   	VM_STAT("max_mmu_page_hash_collisions", max_mmu_page_hash_collisions),
> > >   	VM_STAT("vcpus_ran_nested", vcpus_ran_nested),
> > > +	VM_STAT("created_vcpus", created_vcpus),

IMO, the "created" part is unnecessary for the stats, i.e. just call it "vcpus",
or maybe "nr_vcpus".

> > >   	{ NULL }
> > >   };
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 6b4feb92dc79..ac8f02d8a051 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -3318,6 +3318,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> > >   	}
> > >   	kvm->created_vcpus++;
> > > +	kvm->stat.created_vcpus++;
> > >   	mutex_unlock(&kvm->lock);
> > >   	r = kvm_arch_vcpu_precreate(kvm, id);
> > > @@ -3394,6 +3395,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> > >   vcpu_decrement:
> > >   	mutex_lock(&kvm->lock);
> > >   	kvm->created_vcpus--;
> > > +	kvm->stat.created_vcpus--;
> > >   	mutex_unlock(&kvm->lock);
> > >   	return r;
> > >   }
> > > -- 
> > > 2.27.0
> > > 
