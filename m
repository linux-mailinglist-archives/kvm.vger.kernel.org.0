Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D804A658A86
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 09:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbiL2I2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 03:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiL2I17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 03:27:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67235DFD
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 00:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672302433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gwn9uw8GpeaAYNSjcfDG9cgBntGteGPOXdgf7cDThI=;
        b=f+n+jcDxrJej5p33uVFnAZ7zsKK8JRj/vvAl3ACECEfHrVK+VLZpFQ0dlk2GMtHizEO8GL
        KV7FT4huP3j9gJlRqaTxrNWc+6cU8bqtRmbwOUe+9D/JzwRhhA2U4NKPaKUI/cKRYawBF9
        r8+uxVmnCgS5hN3x56X9Yk3wt9DJdEc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-257-VJLETmoIPUGpqCgtu0Fscg-1; Thu, 29 Dec 2022 03:27:12 -0500
X-MC-Unique: VJLETmoIPUGpqCgtu0Fscg-1
Received: by mail-wm1-f69.google.com with SMTP id m7-20020a05600c4f4700b003d971a5e770so7356884wmq.3
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 00:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3gwn9uw8GpeaAYNSjcfDG9cgBntGteGPOXdgf7cDThI=;
        b=KFipYI9Z06cxqz5/JcvfMFeIeP90DQuMpAWlUcWEHvwPdMIN33n9/kp13hFSjJdRJX
         6Z/796JCWVBouI9kGOjbkHVO5TdMOS66SiZfxiy9ZUTuFP37TnSS6tbEgVRkCiPhCqbF
         dP2noH9nWrOBtlyN7HmiqewsY7hbjWhBjKy6FhsYWdoOciDOZn89+XfVPyZP9e9aReLr
         cvE8g6RRnLL7/OMH4SpZqw0QRHidBzdzSah79OWS5rucEOecXn6gpbfXip/YpMeP0rBV
         NBtW0RiYmvKhvvOg5tzvcd68aV62N7TAmdsWsUNZRnDEU2X+fIYdLPYSTVPOSA2AajJs
         F6kA==
X-Gm-Message-State: AFqh2ko3ErPGP3uekBNFBg3zMlHj0or0A7aF8hBm+ZPBHFl7XGDCgkwy
        aozL0X6XMCy+ft0Kot4f8dtY4EeUa/rg3A2qKpXDY2AI13SjxtLv4T7GrVzPVp0GjZJVPiDmQmN
        HX6A3p4leew4m
X-Received: by 2002:a05:600c:6020:b0:3d1:f0b4:8827 with SMTP id az32-20020a05600c602000b003d1f0b48827mr19496195wmb.25.1672302430936;
        Thu, 29 Dec 2022 00:27:10 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsQs9zU/+72QHHkqHDKfXVW3103mpuPJJ/aAonpa2iu+6ge/EIA41O0YEwthIKCtPSmtrVmsQ==
X-Received: by 2002:a05:600c:6020:b0:3d1:f0b4:8827 with SMTP id az32-20020a05600c602000b003d1f0b48827mr19496182wmb.25.1672302430729;
        Thu, 29 Dec 2022 00:27:10 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id f18-20020a05600c4e9200b003d35c845cbbsm32258609wmq.21.2022.12.29.00.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 00:27:10 -0800 (PST)
Message-ID: <b002fd18c2abdfe5f4395be38858f461b3c76ac3.camel@redhat.com>
Subject: Re: [PATCH v4 28/32] KVM: SVM: Require logical ID to be power-of-2
 for AVIC entry
From:   mlevitsk@redhat.com
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 29 Dec 2022 10:27:08 +0200
In-Reply-To: <f1f1a33134c739f09f5820b5a4973535f121c0da.camel@redhat.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-29-seanjc@google.com>
         <f1f1a33134c739f09f5820b5a4973535f121c0da.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-12-09 at 00:00 +0200, Maxim Levitsky wrote:
> On Sat, 2022-10-01 at 00:59 +0000, Sean Christopherson wrote:
> > Do not modify AVIC's logical ID table if the logical ID portion of the
> > LDR is not a power-of-2, i.e. if the LDR has multiple bits set.  Taking
> > only the first bit means that KVM will fail to match MDAs that intersect
> > with "higher" bits in the "ID"
> > 
> > The "ID" acts as a bitmap, but is referred to as an ID because theres an
> > implicit, unenforced "requirement" that software only set one bit.  This
> > edge case is arguably out-of-spec behavior, but KVM cleanly handles it
> > in all other cases, e.g. the optimized logical map (and AVIC!) is also
> > disabled in this scenario.
> > 
> > Refactor the code to consolidate the checks, and so that the code looks
> > more like avic_kick_target_vcpus_fast().
> > 
> > Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
> > Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 30 +++++++++++++++---------------
> >  1 file changed, 15 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 4b6fc9d64f4d..a9e4e09f83fc 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -513,26 +513,26 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
> >  static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
> >  {
> >  	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
> > -	int index;
> >  	u32 *logical_apic_id_table;
> > -	int dlid = GET_APIC_LOGICAL_ID(ldr);
> > +	u32 cluster, index;
> >  
> > -	if (!dlid)
> > -		return NULL;
> > +	ldr = GET_APIC_LOGICAL_ID(ldr);
> >  
> > -	if (flat) { /* flat */
> > -		index = ffs(dlid) - 1;
> > -		if (index > 7)
> > +	if (flat) {
> > +		cluster = 0;
> > +	} else {
> > +		cluster = (ldr >> 4) << 2;
> > +		if (cluster >= 0xf)
> >  			return NULL;
> > -	} else { /* cluster */
> > -		int cluster = (dlid & 0xf0) >> 4;
> > -		int apic = ffs(dlid & 0x0f) - 1;
> > -
> > -		if ((apic < 0) || (apic > 7) ||
> > -		    (cluster >= 0xf))
> > -			return NULL;
> > -		index = (cluster << 2) + apic;
> > +		ldr &= 0xf;
> >  	}
> > +	if (!ldr || !is_power_of_2(ldr))
> > +		return NULL;
> > +
> > +	index = __ffs(ldr);
> > +	if (WARN_ON_ONCE(index > 7))
> > +		return NULL;
> > +	index += (cluster << 2);
> >  
> >  	logical_apic_id_table = (u32 *) page_address(kvm_svm->avic_logical_id_table_page);
> >  
> 
> Looks good.

I hate to say it but this patch has a bug:

We have both 'cluster = (ldr >> 4) << 2' and then 'index += (cluster << 2)'

One of the shifts has to go.

Best regards,
	Maxim Levitsky


> 
> For future refactoring, I also suggest to rename this function to 'avic_get_logical_id_table_entry'
> to stress the fact that it gets a pointer to the AVIC's data structure.
> 
> Same for 'avic_get_physical_id_entry'
> 
> And also while at it : the 'svm->avic_physical_id_cache', is a very misleading name,
> 
> It should be svm->avic_physical_id_table_entry_ptr with a comment explaining that
> is is the pointer to physid table entry.
> 
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> 
> 
> Best regards,
> 	Maxim Levitsky


