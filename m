Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED42A2C315F
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 20:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgKXTtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 14:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbgKXTtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 14:49:10 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C45C061A4F
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 11:49:09 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 34so100452pgp.10
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 11:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cBmKZMpajiKIWN5tBRCoLzJxvBW3rq8fOFgW5/znSig=;
        b=abO5DZnLyapNPhgLSSf/lKJXmbODOZYvrcZGLbM/QTh9TsTAokw2MINS+GkfWsSWXb
         4trka4tPQprDo6K6uK3MjtRpmS8B3Ffzymka/9lKhG2nimTqRjKpKd5ukYnPPla1moeh
         oNur5MfnzwT/sxlfGsP4yTJsA70ZxoI3aPpP7sONi1c+im/N1AzHOJUl7zMwu1Vlev+4
         pSKnZeyWy6Cx0WePVUrPmz0ta0CURZY4H6CrF2pJFjaeBtEnRbZj+0EAJnIbdmzIpv2m
         zCwGFpTMQvkBHPo8q5oToerqIQKJYgOeQfGQco6oPJpm0G5SnPpEhSUsl0ZPmWUOfz6F
         KT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cBmKZMpajiKIWN5tBRCoLzJxvBW3rq8fOFgW5/znSig=;
        b=tyWVyMwS3GgThb/JiyXVQRXb9xFLCOty3Vh1ckgI95CQnA/+bTVBAhRNkWSFH0dXoq
         DXBf9eXFr+k3Oipl4GRdq/OQ4dcPDxqzs1MQPY7Cmu8DSNMfAJlqsVPFlkwy4rdG0uY0
         IexLE65D/XEEIWtAabePDvdyoqix2P4U0c308995Q14/I+tN/u2QaDR/HLims006b1pq
         sf6q7IGa3avujuKZgP4IlySyYS2WTNPZZddnEsESHqYfAjFZcw1uERJa38eNGR4pTKKx
         76TscIqgHi/ZByV2iNvAGdppI3meDcb7e5Rgf4OuL7aZxClT2IFXYdx0wkZ00Ui0n7Za
         VwgQ==
X-Gm-Message-State: AOAM5315mnVt8ay9Cz4J+Y0sTUGbk3D4DQGdPkoy8ixVVJuNCll8obux
        XhKymNQlvqaUMy93tCyCyAQvaw==
X-Google-Smtp-Source: ABdhPJyoz4AIhG2izPE8K3TTUxxow/cd9XwYYI/YdjXK5jCO3mP3Q3IK88SwTHvD3ZeDIG+nhcE8UQ==
X-Received: by 2002:a17:90a:7c4a:: with SMTP id e10mr235473pjl.72.1606247349136;
        Tue, 24 Nov 2020 11:49:09 -0800 (PST)
Received: from google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
        by smtp.gmail.com with ESMTPSA id g11sm40570pju.23.2020.11.24.11.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 11:49:08 -0800 (PST)
Date:   Tue, 24 Nov 2020 11:49:04 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Sean Christopherson <seanjc@google.com>, rientjes@google.com
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lendacky@google.com, Thomas <thomas.lendacky@amd.com>,
        pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com,
        joro@8bytes.org, corbet@lwn.net, Singh@google.com,
        Brijesh <brijesh.singh@amd.com>, Grimm@google.com,
        Jon <jon.grimm@amd.com>, VanTassell@google.com,
        Eric <eric.vantassell@amd.com>, gingell@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Message-ID: <20201124194904.GA45519@google.com>
References: <alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com>
 <20201124191629.GB235281@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124191629.GB235281@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 24, 2020 at 07:16:29PM +0000, Sean Christopherson wrote:
> On Fri, Nov 13, 2020, David Rientjes wrote:                                     
> >                                                                               
> > On Mon, 2 Nov 2020, Sean Christopherson wrote:                                
> >                                                                               
> > > On Fri, Oct 02, 2020 at 01:48:10PM -0700, Vipin Sharma wrote:               
> > > > On Fri, Sep 25, 2020 at 03:22:20PM -0700, Vipin Sharma wrote:             
> > > > > I agree with you that the abstract name is better than the concrete     
> > > > > name, I also feel that we must provide HW extensions. Here is one       
> > > > > approach:                                                               
> > > > >                                                                         
> > > > > Cgroup name: cpu_encryption, encryption_slots, or memcrypt (open to     
> > > > > suggestions)                                                            
> > > > >                                                                         
> > > > > Control files: slots.{max, current, events}                             
> > >                                                                             
> > > I don't particularly like the "slots" name, mostly because it could be confused
> > > with KVM's memslots.  Maybe encryption_ids.ids.{max, current, events}?  I don't
> > > love those names either, but "encryption" and "IDs" are the two obvious     
> > > commonalities betwee TDX's encryption key IDs and SEV's encryption address  
> > > space IDs.                                                                  
> > >                                                                             
> >                                                                               
> > Looping Janosch and Christian back into the thread.                           
> >                                                                               
> > I interpret this suggestion as                                                
> > encryption.{sev,sev_es,keyids}.{max,current,events} for AMD and Intel         
> 
> I think it makes sense to use encryption_ids instead of simply encryption, that
> way it's clear the cgroup is accounting ids as opposed to restricting what
> techs can be used on yes/no basis.
> 
> > offerings, which was my thought on this as well.                              
> >                                                                               
> > Certainly the kernel could provide a single interface for all of these and    
> > key value pairs depending on the underlying encryption technology but it      
> > seems to only introduce additional complexity in the kernel in string         
> > parsing that can otherwise be avoided.  I think we all agree that a single    
> > interface for all encryption keys or one-value-per-file could be done in      
> > the kernel and handled by any userspace agent that is configuring these       
> > values.                                                                       
> >                                                                               
> > I think Vipin is adding a root level file that describes how many keys we     
> > have available on the platform for each technology.  So I think this comes    
> > down to, for example, a single encryption.max file vs                         
> > encryption.{sev,sev_es,keyid}.max.  SEV and SEV-ES ASIDs are provisioned      
> 
> Are you suggesting that the cgroup omit "current" and "events"?  I agree there's
> no need to enumerate platform total, but not knowing how many of the allowed IDs
> have been allocated seems problematic.
> 

We will be showing encryption_ids.{sev,sev_es}.{max,current}
I am inclined to not provide "events" as I am not using it, let me know
if this file is required, I can provide it then.

I will provide an encryption_ids.{sev,sev_es}.stat file, which shows
total available ids on the platform. This one will be useful for
scheduling jobs in the cloud infrastructure based on total supported
capacity.

> > separately so we treat them as their own resource here.                       
> >                                                                               
> > So which is easier?                                                           
> >                                                                               
> > $ cat encryption.sev.max                                                      
> > 10                                                                            
> > $ echo -n 15 > encryption.sev.max                                             
> >                                                                               
> > or                                                                            
> >                                                                               
> > $ cat encryption.max                                                          
> > sev 10                                                                        
> > sev_es 10                                                                     
> > keyid 0                                                                       
> > $ echo -n "sev 10" > encryption.max                                           
> >                                                                               
> > I would argue the former is simplest (always preferring                       
> > one-value-per-file) and avoids any string parsing or resource controller      
> > lookups that need to match on that string in the kernel.                      
> 
> Ya, I prefer individual files as well.
> 
> I don't think "keyid" is the best name for TDX, it doesn't leave any wiggle room
> if there are other flavors of key IDs on Intel platform, e.g. private vs. shared
> in the future.  It's also inconsistent with the SEV names, e.g. "asid" isn't
> mentioned anywhere.  And "keyid" sort of reads as "max key id", rather than "max
> number of keyids".  Maybe "tdx_private", or simply "tdx"?  Doesn't have to be
> solved now though, there's plenty of time before TDX will be upstream. :-)
> 
> > The set of encryption.{sev,sev_es,keyid} files that exist would depend on     
> > CONFIG_CGROUP_ENCRYPTION and whether CONFIG_AMD_MEM_ENCRYPT or                
> > CONFIG_INTEL_TDX is configured.  Both can be configured so we have all        
> > three files, but the root file will obviously indicate 0 keys available       
> > for one of them (can't run on AMD and Intel at the same time :).              
> >                                                                               
> > So I'm inclined to suggest that the one-value-per-file format is the ideal    
> > way to go unless there are objections to it.
