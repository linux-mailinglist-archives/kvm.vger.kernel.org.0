Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D202C309F
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 20:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389340AbgKXTQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 14:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390984AbgKXTQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 14:16:34 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91892C061A4E
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 11:16:34 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t3so9727pgi.11
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 11:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=pJAA+910//zkOrL+GZT4fayjhef5fPiRUZKFa+bHFto=;
        b=jTQQN0yKgoHMjObT8c6z3ir7J5qbZ+HlYkbU0CHXWDtNyE2FtKAxO+njeutCJkOaTm
         ab+BpneBPyX9fvpRdbOKUPvBB1WIvXa4Mzq6etB41U+hcdIlIqe82okpYouL15RRyvB3
         Oda47hlDQJ6j06HyWdb4IPVUqbzadTBTrMdi0ZR31xMDtT18CUsel67bRXs/jVTB+sbl
         3KHk4Tg6NXwYjzXl96x1LuvcNCL6ux2+BocDP2Fx0790aSq2+qHkeavl41niRzi1JTE8
         y0qd0g3iwMnXbiXGreSVhMLDzATcHLq/rlS51+h2q9E5DogrpwiGedNJa3Ke3G/UcsU9
         P4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=pJAA+910//zkOrL+GZT4fayjhef5fPiRUZKFa+bHFto=;
        b=Rw436L8HPftstUn4tCc3pu6GGEItP9iyKSlZyF3urpnxRA58B8jKyA5Xt5RxVV5Cqo
         0b3iWYdX2svC6cQY2up1qrXiX5VyYR4LUJPKb/TQ1928LSL5/0MHNaAaS0vFZU6kgTMH
         5k9oqGiJaFYhE4Up2sxcUYIH8kBzt0Cwi9jEAkPs97ZUixqdVmc5YRp1QT1J10wzIYRh
         Q6DrBCpiquDK+ObmwZOXwrXLyMIHREuygaugjq1HZzeNqi1FHHevGiAGYTdASaxL9NEb
         bBn4DIP9mqoxG5VR5uZOFwBxMNaXlKeUc2XlxkFeaQMc3fBeOMGW2VqJ8aagH9xdNoOi
         CzgA==
X-Gm-Message-State: AOAM530H1LBahQCtvXtIpX+66okCYuzt0IjoiFIcWQ0K2N9YFZJTyPOL
        9dGU+DvcCaOQ4yjybI9CE1ufhQ==
X-Google-Smtp-Source: ABdhPJxln9/MnFj9z5/qDERpAmj+/1EFQ7n2dmHAbvctCUA4pSc5AcEYAUh0jCxlDcCE2GB+epy9zQ==
X-Received: by 2002:a17:90b:b15:: with SMTP id bf21mr64410pjb.21.1606245393777;
        Tue, 24 Nov 2020 11:16:33 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id 35sm16827pgp.26.2020.11.24.11.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 11:16:32 -0800 (PST)
Date:   Tue, 24 Nov 2020 19:16:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Rientjes <rientjes@google.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vipin Sharma <vipinsh@google.com>, Lendacky@google.com,
        Thomas <thomas.lendacky@amd.com>, pbonzini@redhat.com,
        tj@kernel.org, lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net,
        Singh@google.com, Brijesh <brijesh.singh@amd.com>,
        Grimm@google.com, Jon <jon.grimm@amd.com>, VanTassell@google.com,
        Eric <eric.vantassell@amd.com>, gingell@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Message-ID: <20201124191629.GB235281@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 13, 2020, David Rientjes wrote:                                     
>                                                                               
> On Mon, 2 Nov 2020, Sean Christopherson wrote:                                
>                                                                               
> > On Fri, Oct 02, 2020 at 01:48:10PM -0700, Vipin Sharma wrote:               
> > > On Fri, Sep 25, 2020 at 03:22:20PM -0700, Vipin Sharma wrote:             
> > > > I agree with you that the abstract name is better than the concrete     
> > > > name, I also feel that we must provide HW extensions. Here is one       
> > > > approach:                                                               
> > > >                                                                         
> > > > Cgroup name: cpu_encryption, encryption_slots, or memcrypt (open to     
> > > > suggestions)                                                            
> > > >                                                                         
> > > > Control files: slots.{max, current, events}                             
> >                                                                             
> > I don't particularly like the "slots" name, mostly because it could be confused
> > with KVM's memslots.  Maybe encryption_ids.ids.{max, current, events}?  I don't
> > love those names either, but "encryption" and "IDs" are the two obvious     
> > commonalities betwee TDX's encryption key IDs and SEV's encryption address  
> > space IDs.                                                                  
> >                                                                             
>                                                                               
> Looping Janosch and Christian back into the thread.                           
>                                                                               
> I interpret this suggestion as                                                
> encryption.{sev,sev_es,keyids}.{max,current,events} for AMD and Intel         

I think it makes sense to use encryption_ids instead of simply encryption, that
way it's clear the cgroup is accounting ids as opposed to restricting what
techs can be used on yes/no basis.

> offerings, which was my thought on this as well.                              
>                                                                               
> Certainly the kernel could provide a single interface for all of these and    
> key value pairs depending on the underlying encryption technology but it      
> seems to only introduce additional complexity in the kernel in string         
> parsing that can otherwise be avoided.  I think we all agree that a single    
> interface for all encryption keys or one-value-per-file could be done in      
> the kernel and handled by any userspace agent that is configuring these       
> values.                                                                       
>                                                                               
> I think Vipin is adding a root level file that describes how many keys we     
> have available on the platform for each technology.  So I think this comes    
> down to, for example, a single encryption.max file vs                         
> encryption.{sev,sev_es,keyid}.max.  SEV and SEV-ES ASIDs are provisioned      

Are you suggesting that the cgroup omit "current" and "events"?  I agree there's
no need to enumerate platform total, but not knowing how many of the allowed IDs
have been allocated seems problematic.

> separately so we treat them as their own resource here.                       
>                                                                               
> So which is easier?                                                           
>                                                                               
> $ cat encryption.sev.max                                                      
> 10                                                                            
> $ echo -n 15 > encryption.sev.max                                             
>                                                                               
> or                                                                            
>                                                                               
> $ cat encryption.max                                                          
> sev 10                                                                        
> sev_es 10                                                                     
> keyid 0                                                                       
> $ echo -n "sev 10" > encryption.max                                           
>                                                                               
> I would argue the former is simplest (always preferring                       
> one-value-per-file) and avoids any string parsing or resource controller      
> lookups that need to match on that string in the kernel.                      

Ya, I prefer individual files as well.

I don't think "keyid" is the best name for TDX, it doesn't leave any wiggle room
if there are other flavors of key IDs on Intel platform, e.g. private vs. shared
in the future.  It's also inconsistent with the SEV names, e.g. "asid" isn't
mentioned anywhere.  And "keyid" sort of reads as "max key id", rather than "max
number of keyids".  Maybe "tdx_private", or simply "tdx"?  Doesn't have to be
solved now though, there's plenty of time before TDX will be upstream. :-)

> The set of encryption.{sev,sev_es,keyid} files that exist would depend on     
> CONFIG_CGROUP_ENCRYPTION and whether CONFIG_AMD_MEM_ENCRYPT or                
> CONFIG_INTEL_TDX is configured.  Both can be configured so we have all        
> three files, but the root file will obviously indicate 0 keys available       
> for one of them (can't run on AMD and Intel at the same time :).              
>                                                                               
> So I'm inclined to suggest that the one-value-per-file format is the ideal    
> way to go unless there are objections to it.
