Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6324AF88E
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbiBIRdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiBIRdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:33:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71EF4C0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644427997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vWvOVJ5mPSH/WCzkGDNfXHjUtJlZ57S/B/HmY8KZozU=;
        b=OeFHlXwi/L1HZpuG0QuOtqtnk54CHLFo1gc8LaDdBcjLEY6E7iaGAatNu2J29up4PzYb+P
        tlJ/pHWkvEW5PGkcXRKgyCoJuwW3LIIMYTjTKIbQG+L0wvToMPwejnMc922SCLSW1aShXm
        GuIQ6nwxef8+wUCPW+YXW2hTWegCKn4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-t3Sw915QN0aNWlsEauPK_w-1; Wed, 09 Feb 2022 12:33:15 -0500
X-MC-Unique: t3Sw915QN0aNWlsEauPK_w-1
Received: by mail-wr1-f72.google.com with SMTP id w7-20020adfbac7000000b001d6f75e4faeso1387612wrg.7
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 09:33:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vWvOVJ5mPSH/WCzkGDNfXHjUtJlZ57S/B/HmY8KZozU=;
        b=fgM+ln2y+QkQLhB8hYc/Tz2dv9wJWYopTKi4/ODFSzUrc9+GLarSkqL13gM0XMSDKp
         bNTMtHvzk5PDiPC7BZMKAAu6XGULrYxI0Rgpp2ahp40yyOnBgUd4+Uqe0pky6CqUG99A
         9Pl0LCem5TBQZP/DENB8LRFui9jsjADAFESehCTipNVURaeWcCGF97pHj8IIe/Z9EmJm
         rzxW//srAzqbj+a6wrkaKfDtH9LsYYO7zjvu4GDwryuJbm2CV1h8IFswaMbqaKypy4vL
         bXVNDBVWx4oIrWJ2fHNDuOHSEJtxTl66TtmQiZ9Fj0Isc1PueclHkGAxk9i8z3UQVhGC
         yepw==
X-Gm-Message-State: AOAM533myLUzQtMgLGMMSvkNkAR67DRFeHZaxKFE+llIchmM+Zgbjube
        /T+J9DleI4mAd2k2m9cd8ePIJjNlmrhN854zKPCU49FKz2mvub2wz3WTDpn6K1WwTBAsUrGkMd2
        GY36EEOkvM2lnLrImmPWWDK0PwZIXbGJInSzARK6+m2yEFT+mHQPQaEJ8LnGNCHf1
X-Received: by 2002:a05:600c:1914:: with SMTP id j20mr3547712wmq.51.1644427994642;
        Wed, 09 Feb 2022 09:33:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxE3LbbSMqJZT2x3KGx9JaA9cEMN+uYeX1XWoA+5Mm/9E/Q1yX28QcW8aXjDo1p/2PdhppPZQ==
X-Received: by 2002:a05:600c:1914:: with SMTP id j20mr3547686wmq.51.1644427994372;
        Wed, 09 Feb 2022 09:33:14 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n14sm16863738wri.75.2022.02.09.09.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:33:13 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: warning in kvm_hv_invalidate_tsc_page due to writes to guest
 memory from VM ioctl context
In-Reply-To: <YgPqV8EZFnENj41D@google.com>
References: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
 <87ee4d9yp3.fsf@redhat.com>
 <060ce89597cfbc85ecd300bdd5c40bb571a16993.camel@redhat.com>
 <87bkzh9wkd.fsf@redhat.com> <YgKjDm5OdSOKIdAo@google.com>
 <87wni48b11.fsf@redhat.com> <YgPqV8EZFnENj41D@google.com>
Date:   Wed, 09 Feb 2022 18:33:12 +0100
Message-ID: <87tud87xnr.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Feb 09, 2022, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Tue, Feb 08, 2022, Vitaly Kuznetsov wrote:
>> >> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> >> > and hv-avic only mentions AutoEOI feature.
>> >> 
>> >> True, this is hidden in "The enlightenment allows to use Hyper-V SynIC
>> >> with hardware APICv/AVIC enabled". Any suggestions on how to improve
>> >> this are more than welcome!.
>> >
>> > Specifically for the WARN, does this approach makes sense?
>> >
>> > https://lore.kernel.org/all/YcTpJ369cRBN4W93@google.com
>> 
>> (Sorry for missing this dicsussion back in December)
>> 
>> It probably does but the patch just introduces
>> HV_TSC_PAGE_UPDATE_REQUIRED flag and drops kvm_write_guest() completely,
>> the flag is never reset and nothing ever gets written to guest's
>> memory. I suppose you've forgotten to commit a hunk :-)
>
> I don't think so, the idea is that kvm_hv_setup_tsc_page() handles the write.
>

Oh, sorry, missed that. Patches always look weird in the browser :-)

>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c194a8cbd25f..c1adc9efea28 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2848,7 +2848,7 @@ static void kvm_end_pvclock_update(struct kvm *kvm)
>>
>>  static void kvm_update_masterclock(struct kvm *kvm)
>>  {
>> -	kvm_hv_invalidate_tsc_page(kvm);
>> +	kvm_hv_request_tsc_page_update(kvm);
>>  	kvm_start_pvclock_update(kvm);
>>  	pvclock_update_vm_gtod_copy(kvm);
>>  	kvm_end_pvclock_update(kvm);
>> @@ -3060,8 +3060,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>>  				       offsetof(struct compat_vcpu_info, time));
>>  	if (vcpu->xen.vcpu_time_info_set)
>>  		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
>> -	if (!v->vcpu_idx)
>> -		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>> +	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>
> This change sends all vCPUs through the helper, not just vCPU 0.  Then the common
> helper checks HV_TSC_PAGE_UPDATE_REQUIRED under lock.
>
> 	if (!(hv->hv_tsc_page_status & HV_TSC_PAGE_UPDATE_REQUIRED))
> 		goto out_unlock;
>
>
> 	--- error checking ---
>
> 	/* Write the struct entirely before the non-zero sequence.  */
> 	smp_wmb();
>
> 	hv->tsc_ref.tsc_sequence = tsc_seq;
> 	if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
> 			    &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
> 		goto out_err;
>
> 	hv->hv_tsc_page_status = HV_TSC_PAGE_SET;
> 	goto out_unlock;
>
> out_err:
> 	hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
> out_unlock:
> 	mutex_unlock(&hv->hv_lock);
>
>
> If there are no errors, the kvm_write_guest() goes through and the status is
> "reset".  If there are errors, the status is set to BROKEN.
>
> Should I send an RFC to facilitate discussion?
>

Sure, please go ahead. There are some basic selftests for TSC page
since:

commit 2c7f76b4c42bd5d953bc821e151644434865f999
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Thu Mar 18 15:09:49 2021 +0100

    selftests: kvm: Add basic Hyper-V clocksources tests

but I'll have to refresh my memory on the problematic migration scenario
when kvm_hv_invalidate_tsc_page() got introduced.

Thanks!

-- 
Vitaly

