Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E612E3B39DB
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 01:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhFXXuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 19:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbhFXXuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 19:50:18 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B4AC061574
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 16:47:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so4464369pjo.3
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 16:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3TTTSx9oGUkYkJu7+ALA0wTUTD3ZhTwQcOChtOj/Zk4=;
        b=dcIRON5mUNGGXsf2qIr0RoyLHTz85BI5k4nQGGFwzXCBXEB42N+25XKBb545MiCh3n
         X333TJJd8CA4KI/l8oLU2FXmJikjTnS6jtwgwOm6EdOj8jCE7Ngospb91nsnjDN3vTdK
         Gm/Q6MidDco7j/BnrWV3jeDWdYp2T6ieCy59xZyGulffeuufjD4EP2Utcme5V8XUtWap
         xMjqyYVxaRbhvRfbPYnGpw2YEpquVd3V1g8HsD4LwCJNgyd/pto8Ok5edEEJ9TZKMBj9
         eJiujwLn/t/g1xBc0xs/JJxKrIuFVN8g3MsNqzmK6FC9GedID/DrTRn8iujNY/Ey5D0A
         eicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3TTTSx9oGUkYkJu7+ALA0wTUTD3ZhTwQcOChtOj/Zk4=;
        b=JYfc+A8im2gl3Si14rd0qaPrf5ogvpfae8fZsV3CkZ5SJJqffeQnHewwPzjHiCMngM
         t6TKAeANQK1u+LUOZd1hG3ctp89hgBB7VLv8jhDO9NRapUqOj8XJN/rX6zGZ8ODq4KgC
         6n9tTKj6yT23Uvh1VIl1BQikvuqnmue0A4EL+1d4K7TDTASutuvtSNdJDin3ZiZ2xy/F
         mgELUFQppStX2S+XUt+CTsZnkNkhju4rxs76W4Q1KsRqbnAEdEIUM4RE0B0bAxUKLK8A
         nodBU7fTT1QwZqT7y4tVfrFxxxSt3hhVEtOZBFoEsexXgWgd4dEMxC42MSeDmn+iboTZ
         tsdA==
X-Gm-Message-State: AOAM5310kUq0RTIbnFajpb0dlgO3/6xgqRS7+UdswFrN1cryl4KWTwDD
        vcw4FvxNx9E/SiFpsYocUCkDSQ==
X-Google-Smtp-Source: ABdhPJxbrYHlucGt9IM/FGL//GXHXhmKX1X4kkHmCVcpQUo2hMtRCP8UQRXgeap/GV6eKwcSeaIgZA==
X-Received: by 2002:a17:902:d50b:b029:121:b5c8:b246 with SMTP id b11-20020a170902d50bb0290121b5c8b246mr6347367plg.51.1624578477622;
        Thu, 24 Jun 2021 16:47:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d129sm2648854pfd.218.2021.06.24.16.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 16:47:57 -0700 (PDT)
Date:   Thu, 24 Jun 2021 23:47:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH 0/7] KVM: x86: guest MAXPHYADDR and C-bit fixes
Message-ID: <YNUZqRK3ZMdsNdt4@google.com>
References: <20210623230552.4027702-1-seanjc@google.com>
 <324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com>
 <c2d7a69a-386e-6f44-71c2-eb9a243c3a78@amd.com>
 <YNTBdvWxwyx3T+Cs@google.com>
 <2b79e962-b7de-4617-000d-f85890b7ea2c@amd.com>
 <7e3a90c0-75a1-b8fe-dbcf-bda16502ace9@amd.com>
 <YNUEA8n61WO89voW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNUEA8n61WO89voW@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021, Sean Christopherson wrote:
> On Thu, Jun 24, 2021, Tom Lendacky wrote:
> > On 6/24/21 12:39 PM, Tom Lendacky wrote:
> > > 
> > > 
> > > On 6/24/21 12:31 PM, Sean Christopherson wrote:
> > >> On Thu, Jun 24, 2021, Tom Lendacky wrote:
> > >>>>
> > >>>> Here's an explanation of the physical address reduction for bare-metal and
> > >>>> guest.
> > >>>>
> > >>>> With MSR 0xC001_0010[SMEE] = 0:
> > >>>>   No reduction in host or guest max physical address.
> > >>>>
> > >>>> With MSR 0xC001_0010[SMEE] = 1:
> > >>>> - Reduction in the host is enumerated by CPUID 0x8000_001F_EBX[11:6],
> > >>>>   regardless of whether SME is enabled in the host or not. So, for example
> > >>>>   on EPYC generation 2 (Rome) you would see a reduction from 48 to 43.
> > >>>> - There is no reduction in physical address in a legacy guest (non-SEV
> > >>>>   guest), so the guest can use a 48-bit physical address
> > >>
> > >> So the behavior I'm seeing is either a CPU bug or user error.  Can you verify
> > >> the unexpected #PF behavior to make sure I'm not doing something stupid?
> > > 
> > > Yeah, I saw that in patch #3. Let me see what I can find out. I could just
> > > be wrong on that myself - it wouldn't be the first time.
> > 
> > From patch #3:
> >   SVM: KVM: CPU #PF @ rip = 0x409ca4, cr2 = 0xc0000000, pfec = 0xb
> >   KVM: guest PTE = 0x181023 @ GPA = 0x180000, level = 4
> >   KVM: guest PTE = 0x186023 @ GPA = 0x181000, level = 3
> >   KVM: guest PTE = 0x187023 @ GPA = 0x186000, level = 2
> >   KVM: guest PTE = 0xffffbffff003 @ GPA = 0x187000, level = 1
> >   SVM: KVM: GPA = 0x7fffbffff000
> > 
> > I think you may be hitting a special HT region that is at the top 12GB of
> > the 48-bit memory range and is reserved, even for GPAs. Can you somehow
> > get the test to use an address below 0xfffd_0000_0000? That would show
> > that bit 47 is valid for the legacy guest while staying out of the HT region.
> 
> I can make that happen.

Ah, hilarious.  That indeed does the trick.  0xfffd00000000 = #PF,
0xfffcfffff000 = good.

I'll send a revert shortly.  There's another C-bit bug that needs fixing, too :-/
The unconditional __sme_clr() in npf_interception() is wrong and breaks non-SEV
guests.  Based on this from the APM

  If the C-bit is an address bit, this bit is masked from the guest
  physical address when it is translated through the nested page tables.
  Consequently, the hypervisor does not need to be aware of which pages
  the guest has chosen to mark private.

I assume it's not needed for SEV either?  I'm about to find out shortly, but if
you happen to know for sure... :-)
