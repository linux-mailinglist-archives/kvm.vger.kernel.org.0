Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28A65765FC
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 19:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiGOR0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 13:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGOR0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 13:26:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A804E5C34C
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 10:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657905989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aLPo8/DB91UYh27KGei89Hh/TSVF1Z7eDrFOf6DAtVA=;
        b=KRJKao4BP14nJ9flZwX6WfsOrLmiuqcInDbLvKm3NnFpcriDBKKokY2Eg8lzKQqKpQjKss
        W+XL34AQTPSOFt10dBD7y33OyKOiZ40uWyAoAxrvH0wmDYZjkNtOrjXK/bX6B4/sEqYyuQ
        sABXBttvg0jTXiK2JEg5LQ1sXJLfKSE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-UtmJ320aOtyGXH3_TfD0MA-1; Fri, 15 Jul 2022 13:26:27 -0400
X-MC-Unique: UtmJ320aOtyGXH3_TfD0MA-1
Received: by mail-qv1-f72.google.com with SMTP id od5-20020a0562142f0500b00473838e0feeso3352567qvb.9
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 10:26:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aLPo8/DB91UYh27KGei89Hh/TSVF1Z7eDrFOf6DAtVA=;
        b=tgPhiK/zrRPtJjrkXdWXgi9AQwHAZWvxsKaWcLyZW2/VQcY261iqkozboI66vcFnVN
         V1h3cALbm6T/tnTJBxLdNs1IDa2ULeeDkL36MffM19MvK7bj9gl8CrqMVtliPiH5YuQ+
         Oh3M8+fWPujNLfNSTPILOIkRw6KdFqcHkGzr9kgMd+XnQ4w+yb21oLyfl7GV/q4fZ3Nb
         RWAZgvhCMlsML3cb4hoVi2opBFmVzbki99G+d+TVVo6J4+8UPpQ57g52ovtCq2pKtiGN
         sXjc+eSdhRyVzI+8PPwbZhgbrGeyWoSJvK4pBfez+3yYwg3TVdNmK08j30Oiffa2kh4h
         X1aQ==
X-Gm-Message-State: AJIora/IGp10Hr1RMad7BGRqs2TXQNK3Vb3Guy/nAAxRhUE+pb6MwDeF
        SLYfPZ8g0VBnBoi7sJtNZ5n6awQmnfJAkQq6ZUCBfJuBc4t+3uB0C+FpLO88z28bl8bdACTBpFS
        M4x+eo0VQIHJY
X-Received: by 2002:a0c:ed23:0:b0:472:f9c0:9fda with SMTP id u3-20020a0ced23000000b00472f9c09fdamr13113994qvq.24.1657905987404;
        Fri, 15 Jul 2022 10:26:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t+XKIICkmn/ghILEHr7V3nyT6rq6Cepi3e+TjQEDvzNpSjL8AbPTO/GF54O1Ar+BIbBkfv+Q==
X-Received: by 2002:a0c:ed23:0:b0:472:f9c0:9fda with SMTP id u3-20020a0ced23000000b00472f9c09fdamr13113972qvq.24.1657905987091;
        Fri, 15 Jul 2022 10:26:27 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id t24-20020a05622a181800b00304fe5247bfsm4564828qtc.36.2022.07.15.10.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 10:26:26 -0700 (PDT)
Date:   Fri, 15 Jul 2022 13:26:24 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YtGjQNyQcN3GiVgS@xz-m1.local>
References: <877d68mfqv.wl-maz@kernel.org>
 <Yo+82LjHSOdyxKzT@google.com>
 <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
 <2e5198b3-54ea-010e-c418-f98054befe1b@nutanix.com>
 <YtBanRozLuP9qoWs@xz-m1.local>
 <YtCBBI+rU+UQNm4p@google.com>
 <YtCWW2OfbI4+r1L3@xz-m1.local>
 <YtGUmsavkoTBjQTU@google.com>
 <YtGcOSo9xDsWxuCj@xz-m1.local>
 <YtGe4SPbSI6RQLJ1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YtGe4SPbSI6RQLJ1@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022 at 05:07:45PM +0000, Sean Christopherson wrote:
> On Fri, Jul 15, 2022, Peter Xu wrote:
> > On Fri, Jul 15, 2022 at 04:23:54PM +0000, Sean Christopherson wrote:
> > > And the reasoning behind not having kvm_run.dirty_count is that it's fully
> > > redundant if KVM provides a stat, and IMO such a stat will be quite helpful for
> > > things beyond dirty quotas, e.g. being able to see which vCPUs are dirtying memory
> > > from the command line for debug purposes.
> > 
> > Not if with overflow in mind?  Note that I totally agree the overflow may
> > not even happen, but I think it makes sense to consider as a complete
> > design of ceiling-based approach.  Think the Millennium bug, we never know
> > what will happen in the future..
> > 
> > So no objection too on having stats for dirty pages, it's just that if we
> > still want to cover the overflow issue we'd make dirty_count writable, then
> > it'd still better be in kvm_run, imho.
> 
> Yeah, never say never, but unless my math is wrong, overflow isn't happening anytime
> soon.  And if future CPUs can overflow the number of dirty pages, then they'll be
> able to overflow a number of stats, at which point I think we'll want a generic
> ioctl() to reset _all_ stats.

It's slightly different as this affects functionality, unlike most stats.
I'll leave that to Shivam to see his preference.  If to go that way, I hope
we can at least have some WARN_ON_ONCE() on detecting overflows of "count".

Thanks,

-- 
Peter Xu

