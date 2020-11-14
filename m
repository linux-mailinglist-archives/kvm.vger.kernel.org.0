Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6CF2B29DA
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 01:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgKNA0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 19:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgKNA0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 19:26:12 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775E5C061A04
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 16:26:12 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id b3so5316152pls.11
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 16:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Eyi3ibuvYWMCo7i6ODa9MSLY3tsErf7jEpym/+H+ah4=;
        b=bHZo0ee3XBP9p4M+ZN66+nahhWFE7yUfvbiG5bA6o1mruvmC3Yww3mynB3xOxEvtZM
         dXMICkYjdvO2ADU7o7Cgg6Ittbb0fNtX2JmKSb9Zews8kBA2YRq3+H3PMffKmJy8R98Z
         b9I43agtiQZjKyzPjHkpenN1Mc2Bf3LvlxVMk54MoRm5RnQYy/oAKsvpqbfWjMimZRib
         Ua2BZf3WMCDbmFyGy8BFT6X24fM1a7+f9f/v5F50CZGeyanXn+znzPjnizEY1N9Hh1sn
         cgBzOe2WIZiAC7+98J0+loMccJvGk4jxhzYg9JAw8HD0lURkU29EyqHZBaF2uf+/1P4O
         SlNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=Eyi3ibuvYWMCo7i6ODa9MSLY3tsErf7jEpym/+H+ah4=;
        b=bJNWnxNFRKqj6ak7CA3HS+ExQvDZ8cNXbqooo5oP/obvUtXc+q6UHfSHeRi+konJhO
         YoTnm4NSm73/eOWoe7HKPMd2eKDwemKHFme1SO5Nq6Y7N4BDUzqA3J+SFh1V3plCdOm2
         oJtIJ5N9BuhpvKBg5XQZnw6KVZ4hAJXQXy5x3ACWC2/FDMY5WIrR2CaHfFgi47eppTPF
         FI+18OILY9GEzEpCdBYs6r/YzkrXkGU3BfHzatba9JPDx9Pm3F5EXpUNBUQB9sj8foNW
         eOlsNSwxWHqtd8T1MDqZHV5WCeAVhWbxA1XL8GoCosGcZabqphHzJFGw06CrrKe+z+ZQ
         45hQ==
X-Gm-Message-State: AOAM5324zlSPmJr8hKeRFRF+philAqqLeczCrd9pN5+1ZJR6HKd6Qtzq
        PACJOW6NJYNkO4QPoKcpqWkFng==
X-Google-Smtp-Source: ABdhPJywVAaDqs9IyJIDm5Sl7H77CxDksVRaFSoKiKT8KoxP5BJQn/Gqp6ooi5bqKBGdE2M/Av1EOw==
X-Received: by 2002:a17:902:8341:b029:d8:d123:2297 with SMTP id z1-20020a1709028341b02900d8d1232297mr3991532pln.65.1605313571693;
        Fri, 13 Nov 2020 16:26:11 -0800 (PST)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id n9sm4436027pjk.1.2020.11.13.16.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 16:26:10 -0800 (PST)
Date:   Fri, 13 Nov 2020 16:26:09 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
cc:     Vipin Sharma <vipinsh@google.com>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>, pbonzini@redhat.com,
        tj@kernel.org, lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Grimm, Jon" <jon.grimm@amd.com>,
        "Van Tassell, Eric" <eric.vantassell@amd.com>, gingell@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
In-Reply-To: <20201103020623.GJ21563@linux.intel.com>
Message-ID: <alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com>
References: <20200922004024.3699923-1-vipinsh@google.com> <20200922014836.GA26507@linux.intel.com> <20200922211404.GA4141897@google.com> <20200924192116.GC9649@linux.intel.com> <cb592c59-a50e-5901-71fe-19e43bc9e37e@amd.com> <20200925222220.GA977797@google.com>
 <20201002204810.GA3179405@google.com> <20201103020623.GJ21563@linux.intel.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2 Nov 2020, Sean Christopherson wrote:

> On Fri, Oct 02, 2020 at 01:48:10PM -0700, Vipin Sharma wrote:
> > On Fri, Sep 25, 2020 at 03:22:20PM -0700, Vipin Sharma wrote:
> > > I agree with you that the abstract name is better than the concrete
> > > name, I also feel that we must provide HW extensions. Here is one
> > > approach:
> > > 
> > > Cgroup name: cpu_encryption, encryption_slots, or memcrypt (open to
> > > suggestions)
> > > 
> > > Control files: slots.{max, current, events}
> 
> I don't particularly like the "slots" name, mostly because it could be confused
> with KVM's memslots.  Maybe encryption_ids.ids.{max, current, events}?  I don't
> love those names either, but "encryption" and "IDs" are the two obvious
> commonalities betwee TDX's encryption key IDs and SEV's encryption address
> space IDs.
> 

Looping Janosch and Christian back into the thread.

I interpret this suggestion as
encryption.{sev,sev_es,keyids}.{max,current,events} for AMD and Intel 
offerings, which was my thought on this as well.

Certainly the kernel could provide a single interface for all of these and 
key value pairs depending on the underlying encryption technology but it 
seems to only introduce additional complexity in the kernel in string 
parsing that can otherwise be avoided.  I think we all agree that a single 
interface for all encryption keys or one-value-per-file could be done in 
the kernel and handled by any userspace agent that is configuring these 
values.

I think Vipin is adding a root level file that describes how many keys we 
have available on the platform for each technology.  So I think this comes 
down to, for example, a single encryption.max file vs 
encryption.{sev,sev_es,keyid}.max.  SEV and SEV-ES ASIDs are provisioned 
separately so we treat them as their own resource here.

So which is easier?

$ cat encryption.sev.max
10
$ echo -n 15 > encryption.sev.max

or

$ cat encryption.max
sev 10
sev_es 10
keyid 0
$ echo -n "sev 10" > encryption.max

I would argue the former is simplest (always preferring 
one-value-per-file) and avoids any string parsing or resource controller 
lookups that need to match on that string in the kernel.

The set of encryption.{sev,sev_es,keyid} files that exist would depend on
CONFIG_CGROUP_ENCRYPTION and whether CONFIG_AMD_MEM_ENCRYPT or 
CONFIG_INTEL_TDX is configured.  Both can be configured so we have all 
three files, but the root file will obviously indicate 0 keys available 
for one of them (can't run on AMD and Intel at the same time :).

So I'm inclined to suggest that the one-value-per-file format is the ideal 
way to go unless there are objections to it.
