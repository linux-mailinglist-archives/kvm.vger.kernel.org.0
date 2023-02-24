Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD216A1D94
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 15:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjBXOj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 09:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjBXOjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 09:39:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2B41027F
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 06:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677249556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gwn5Ws8pxKxzUZXXgDM8XZWBxd9YpYFMiMTVV+pdj6o=;
        b=CaUVW6rMooib/8pbeqddYtEXLrUVwV/Sjcy7XQFKIBzbHysFy1jhnEpYMvLqS7cOJe5NCQ
        eJkb/ZHPW+xr74ysICLYcw6lFiwqfgPF26icQ04mpK6wcHCI5ynNtaylf6yjNgJPEgWBBR
        NtO2ermDed5Tj58hlqyaHRf3h12IDjQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-227-mVepaZAZOZuPFGOhyqBcdA-1; Fri, 24 Feb 2023 09:39:14 -0500
X-MC-Unique: mVepaZAZOZuPFGOhyqBcdA-1
Received: by mail-wm1-f69.google.com with SMTP id x18-20020a1c7c12000000b003e1e7d3cf9fso1306405wmc.3
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 06:39:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gwn5Ws8pxKxzUZXXgDM8XZWBxd9YpYFMiMTVV+pdj6o=;
        b=lexjmX44hfVBGUgY3nWtgFIOxJByTr/SPTeDRtTChJGWk5t7USGILTQ8yvJZkcCAev
         hSAJ+Box+wSiCaatMDk+f/1ymjRcOfc7ZExddVSRrP7euzHlHTkjHXVnhop+PocivdRn
         OEJKPc/t6MUM2uWL+tcvpOIlKQvanFr+uOw4vpDJPAKywGeRPwK7JJgsjigKfxQZ/Yh4
         1GW8ldRQthEtPQuO3BvJKmYVsBclnFm6CUr15BsSuq7XjdwSAxrK4oQWSZrOhw9jlxAO
         49thj9CIFA0XAfhgd/HSFU7Q634HzWwMgGyxoYZx7JfFnAcvR/+mp28KfBJjcnjew3iR
         it1w==
X-Gm-Message-State: AO0yUKUU80RrNmuYp+tTBCujKwLTE2mQ5pchXO4pQ3rA4K1K7WILZ8mz
        1NnEqD1gaSxauSgFQN/R/3QW37gt9WE/FNg4uAtjhTzaEDfHskdb4cq1i3tuxYvXVpfGAi6dWEc
        6V9Xsk10zfzwL
X-Received: by 2002:adf:f292:0:b0:2c7:1b4d:a6e2 with SMTP id k18-20020adff292000000b002c71b4da6e2mr2266919wro.60.1677249553852;
        Fri, 24 Feb 2023 06:39:13 -0800 (PST)
X-Google-Smtp-Source: AK7set+JEAJuy0JHtdqXFML9piRLztw7qQrOJspvl54b6l6a7RnPlb9+iCzf6dVnOLd0xNVE0Xd+dQ==
X-Received: by 2002:adf:f292:0:b0:2c7:1b4d:a6e2 with SMTP id k18-20020adff292000000b002c71b4da6e2mr2266897wro.60.1677249553531;
        Fri, 24 Feb 2023 06:39:13 -0800 (PST)
Received: from starship ([89.237.96.70])
        by smtp.gmail.com with ESMTPSA id x17-20020adff651000000b002c563b124basm13574658wrp.103.2023.02.24.06.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 06:39:13 -0800 (PST)
Message-ID: <810f38d2d8328b0f24bc8b11b71092546ec22eef.camel@redhat.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Fri, 24 Feb 2023 16:39:10 +0200
In-Reply-To: <Y9R1w8kfQjCNnEfl@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
         <20221129193717.513824-8-mlevitsk@redhat.com> <Y9R1w8kfQjCNnEfl@google.com>
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

On Sat, 2023-01-28 at 01:09 +0000, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> > This patch adds two new vendor callbacks:
> 
> No "this patch" please, just say what it does.
> 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 684a5519812fb2..46993ce61c92db 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -871,8 +871,13 @@ struct kvm_vcpu_arch {
> >  	u64 tsc_scaling_ratio; /* current scaling ratio */
> >  
> >  	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
> > -	unsigned nmi_pending; /* NMI queued after currently running handler */
> > +
> > +	unsigned int nmi_pending; /*
> > +				   * NMI queued after currently running handler
> > +				   * (not including a hardware pending NMI (e.g vNMI))
> > +				   */
> 
> Put the block comment above.  I'd say collapse all of the comments about NMIs into
> a single big block comment.
> 
> >  	bool nmi_injected;    /* Trying to inject an NMI this entry */
> > +
> >  	bool smi_pending;    /* SMI queued after currently running handler */
> >  	u8 handling_intr_from_guest;
> >  
> > @@ -10015,13 +10022,34 @@ static void process_nmi(struct kvm_vcpu *vcpu)
> >  	 * Otherwise, allow two (and we'll inject the first one immediately).
> >  	 */
> >  	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
> > -		limit = 1;
> > +		limit--;
> > +
> > +	/* Also if there is already a NMI hardware queued to be injected,
> > +	 * decrease the limit again
> > +	 */
> 
> 	/*
> 	 * Block comment ...
> 	 */
> 
> > +	if (static_call(kvm_x86_get_hw_nmi_pending)(vcpu))
> 
> I'd prefer "is_hw_nmi_pending()" over "get", even if it means not pairing with
> "set".  Though I think that's a good thing since they aren't perfect pairs.
> 
> > +		limit--;
> >  
> > -	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
> > +	if (limit <= 0)
> > +		return;
> > +
> > +	/* Attempt to use hardware NMI queueing */
> > +	if (static_call(kvm_x86_set_hw_nmi_pending)(vcpu)) {
> > +		limit--;
> > +		nmi_to_queue--;
> > +	}
> > +
> > +	vcpu->arch.nmi_pending += nmi_to_queue;
> >  	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
> >  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> >  }
> >  
> > +/* Return total number of NMIs pending injection to the VM */
> > +int kvm_get_total_nmi_pending(struct kvm_vcpu *vcpu)
> > +{
> > +	return vcpu->arch.nmi_pending + static_call(kvm_x86_get_hw_nmi_pending)(vcpu);
> 
> Nothing cares about the total count, this can just be;

I wanted to have the interface to be a bit more generic so that in theory you could have
more that one hardware NMI pending. I don't care much about it.


Best regards,
	Maxim Levitsky

> 
> 
> 	bool kvm_is_nmi_pending(struct kvm_vcpu *vcpu)
> 	{
> 		return vcpu->arch.nmi_pending ||
> 		       static_call(kvm_x86_is_hw_nmi_pending)(vcpu);
> 	}
> 
> 
> > +}
> > +
> >  void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
> >  				       unsigned long *vcpu_bitmap)
> >  {
> > -- 
> > 2.26.3
> > 


