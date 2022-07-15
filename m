Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2395765CA
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 19:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbiGORHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 13:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiGORHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 13:07:50 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7B15F994
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 10:07:50 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b133so1362766pfb.6
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 10:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PyjDHYJSmEUME+vQ5HPZ/bXiKs0h3eAxe+eh5JYbdjQ=;
        b=hteK/Tl70jMSj8jMpfbYf8ejQJr7DLMc+526yNe0nTC+oBsvRgo+CD4Ts41uZqQACq
         Q7R6SRR4OZvO5n8Zb2BJYwF5m6AsTTzsTwQkjNm3eTWYoa90YWGrA1y7xFSFqs8Du7FP
         rTA7h3RInfW/a52Q72ouLJ/UTbPD1Hwla1xLU4dnMoL/B8TeoyvjxhUW6s4t4/8mtcIc
         5xHlHdedAOYZ//HABmuP297AwEl6JPdE8o9E+IIvKAFjTT7OCMlIaX0HzOu0H+HCr5FV
         E/ISHm6iGFLcVGHVXmAa2rar73DFrBhPyoa8FqIHZ+KPgD6kgowKidhXr7lQ813qZxVT
         nv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PyjDHYJSmEUME+vQ5HPZ/bXiKs0h3eAxe+eh5JYbdjQ=;
        b=mN9NihtStcEjBkGat/H3HAvhDZcef+nx9onfrzHk8lRwF2IibtZImEDG8wLCSBkr31
         p5z2ST9e2TmUDvAObVA7kFawhPGSnLuSnYxtU1bBmt7v50pzcLn8MTyMufRB0DanAe/4
         7eTzgle4iA7R7SFO22G0/MydHr7WjDc4+GFyNSrD9vIV060yEIGpHg2aYDKuZIYbNZW0
         VbtBiimGv1Om+uT0TgRKQRQKSTvBXOfyDVFLz5VjxEPLJcvJ990kdi3yuF/X+GJjExai
         i9EsmVxtaVruzQteqJS+zEaRTVL4efuhshIoooxhQ2zOSj/PEm3RgC9fhwugGnrgMc1g
         peJQ==
X-Gm-Message-State: AJIora+/8f5osQ8pk/wsHMjPIARqfexCzXJ8lXFIBVnx9iW4UORG54Ok
        7rtAm+sOb8n/XVQz+Hrs+mk8OA==
X-Google-Smtp-Source: AGRyM1tiedOFFdlPzDD4HCJGgJJdP5nEBk1yvEOkZuoi4Tl6wcnuSrAKhc4zfmhPBL/1N8BTg+4ygg==
X-Received: by 2002:a05:6a00:23d4:b0:52a:e5c1:caa7 with SMTP id g20-20020a056a0023d400b0052ae5c1caa7mr14816485pfc.62.1657904869377;
        Fri, 15 Jul 2022 10:07:49 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y15-20020a63e24f000000b00419b02043e1sm3508170pgj.38.2022.07.15.10.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 10:07:48 -0700 (PDT)
Date:   Fri, 15 Jul 2022 17:07:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YtGe4SPbSI6RQLJ1@google.com>
References: <Yo+gTbo5uqqAMjjX@google.com>
 <877d68mfqv.wl-maz@kernel.org>
 <Yo+82LjHSOdyxKzT@google.com>
 <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
 <2e5198b3-54ea-010e-c418-f98054befe1b@nutanix.com>
 <YtBanRozLuP9qoWs@xz-m1.local>
 <YtCBBI+rU+UQNm4p@google.com>
 <YtCWW2OfbI4+r1L3@xz-m1.local>
 <YtGUmsavkoTBjQTU@google.com>
 <YtGcOSo9xDsWxuCj@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtGcOSo9xDsWxuCj@xz-m1.local>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022, Peter Xu wrote:
> On Fri, Jul 15, 2022 at 04:23:54PM +0000, Sean Christopherson wrote:
> > And the reasoning behind not having kvm_run.dirty_count is that it's fully
> > redundant if KVM provides a stat, and IMO such a stat will be quite helpful for
> > things beyond dirty quotas, e.g. being able to see which vCPUs are dirtying memory
> > from the command line for debug purposes.
> 
> Not if with overflow in mind?  Note that I totally agree the overflow may
> not even happen, but I think it makes sense to consider as a complete
> design of ceiling-based approach.  Think the Millennium bug, we never know
> what will happen in the future..
> 
> So no objection too on having stats for dirty pages, it's just that if we
> still want to cover the overflow issue we'd make dirty_count writable, then
> it'd still better be in kvm_run, imho.

Yeah, never say never, but unless my math is wrong, overflow isn't happening anytime
soon.  And if future CPUs can overflow the number of dirty pages, then they'll be
able to overflow a number of stats, at which point I think we'll want a generic
ioctl() to reset _all_ stats.
